# Guide Complet - Exercice 1 : Gestion des utilisateurs Windows Server

## Contexte
L'utilisateur Kelly Rhameur a quitté l'entreprise et est remplacée par Lionel Lemarchand.

---

## Partie 1 : Gestion des utilisateurs

### Q.1.1.1 Créer l'utilisateur Lionel Lemarchand avec les mêmes attributs de société que Kelly Rhameur

**Méthode Graphique (Active Directory Users and Computers) :**

**Étape 1 : Ouvrir Active Directory Users and Computers**
- Ouvrir le Gestionnaire de serveur
- Outils → Utilisateurs et ordinateurs Active Directory

**Étape 2 : Analyser le compte de Kelly Rhameur**
- Naviguer vers l'OU où se trouve Kelly Rhameur
- Double-cliquer sur "Kelly.Rhameur"
- Noter tous les attributs dans les onglets :
  - **Général** : Nom, Prénom, Initiales, Description
  - **Compte** : Nom de connexion, Heures de connexion, Ordinateurs
  - **Profil** : Chemin du profil, Script de connexion, Dossier de base
  - **Organisation** : Titre, Service, Société, Responsable
  - **Membre de** : Groupes

**Étape 3 : Créer le nouvel utilisateur Lionel Lemarchand**
- Clic droit sur l'OU → Nouveau → Utilisateur
- Remplir les informations :
  - **Prénom** : Lionel
  - **Nom** : Lemarchand
  - **Nom complet** : Lionel Lemarchand
  - **Nom d'ouverture de session** : Lionel.Lemarchand ou LLemarchand

**Étape 4 : Configurer le mot de passe**
- Définir un mot de passe initial
- Cocher "L'utilisateur doit changer le mot de passe à la prochaine ouverture de session"

**Étape 5 : Copier les attributs de Kelly Rhameur**

Dans les propriétés de Lionel Lemarchand :

**Onglet Général :**
- Description : Copier depuis Kelly Rhameur
- Bureau : Copier depuis Kelly Rhameur
- Téléphone : (laisser vide initialement)

**Onglet Compte :**
- Heures d'ouverture de session : Copier si configuré
- Se connecter à : Copier si configuré

**Onglet Profil :**
- Chemin d'accès du profil : Adapter avec le nouveau nom d'utilisateur
- Script d'ouverture de session : Copier si configuré
- Dossier de base : Créer un nouveau chemin

**Onglet Organisation :**
- **Fonction** : Directeur des Ressources Humaines (exemple)
- **Service** : Copier depuis Kelly Rhameur (ex: CyberSox)
- **Société** : Copier depuis Kelly Rhameur
- **Responsable** : Camille Martin (ou copier depuis Kelly)

**Onglet Membre de :**
- Ajouter Lionel aux mêmes groupes que Kelly :
  - Cliquer sur "Ajouter"
  - Sélectionner chaque groupe dont Kelly était membre
  - Exemples : TSSR-LAN\Users, DirecteurDesRessourcesHumaines, etc.

**Méthode PowerShell :**

```powershell
# Obtenir les informations de Kelly Rhameur
$kelly = Get-ADUser "Kelly.Rhameur" -Properties *

# Créer Lionel Lemarchand avec les mêmes attributs
New-ADUser -Name "Lionel Lemarchand" `
    -GivenName "Lionel" `
    -Surname "Lemarchand" `
    -SamAccountName "Lionel.Lemarchand" `
    -UserPrincipalName "Lionel.Lemarchand@tssr-lan.local" `
    -DisplayName "Lionel Lemarchand" `
    -Title $kelly.Title `
    -Department $kelly.Department `
    -Company $kelly.Company `
    -Manager $kelly.Manager `
    -Path $kelly.DistinguishedName.Split(',',2)[1] `
    -AccountPassword (ConvertTo-SecureString "P@ssw0rd123!" -AsPlainText -Force) `
    -Enabled $true `
    -ChangePasswordAtLogon $true

# Copier les appartenances aux groupes
$groups = Get-ADUser "Kelly.Rhameur" -Properties MemberOf | Select-Object -ExpandProperty MemberOf
foreach ($group in $groups) {
    Add-ADGroupMember -Identity $group -Members "Lionel.Lemarchand"
}
```

**Vérification :**
- Ouvrir le compte Lionel Lemarchand
- Vérifier tous les onglets
- Comparer avec Kelly Rhameur
- Tester la connexion

---

### Q.1.1.2 Créer une OU DeactivatedUsers et déplacer le compte désactivé de Kelly Rhameur dedans

**Méthode Graphique :**

**Étape 1 : Créer l'OU DeactivatedUsers**
- Dans Active Directory Users and Computers
- Clic droit sur le domaine (TSSR-LAN) → Nouveau → Unité d'organisation
- Nom : **DeactivatedUsers**
- Décocher "Protéger le conteneur contre la suppression accidentelle" (optionnel)
- Cliquer sur OK

**Étape 2 : Désactiver le compte de Kelly Rhameur**
- Localiser le compte Kelly.Rhameur
- Clic droit → Désactiver le compte
- Un message de confirmation apparaît
- Le compte apparaît maintenant avec une flèche vers le bas (🔽)

**Étape 3 : Déplacer Kelly Rhameur vers DeactivatedUsers**
- Clic droit sur Kelly.Rhameur → Déplacer
- Sélectionner l'OU "DeactivatedUsers"
- Cliquer sur OK

**Méthode PowerShell :**

```powershell
# Créer l'OU DeactivatedUsers
New-ADOrganizationalUnit -Name "DeactivatedUsers" -Path "DC=TSSR-LAN,DC=local"

# Désactiver le compte de Kelly Rhameur
Disable-ADAccount -Identity "Kelly.Rhameur"

# Déplacer Kelly vers DeactivatedUsers
$kellyDN = (Get-ADUser "Kelly.Rhameur").DistinguishedName
$targetOU = "OU=DeactivatedUsers,DC=TSSR-LAN,DC=local"
Move-ADObject -Identity $kellyDN -TargetPath $targetOU

# Vérifier
Get-ADUser "Kelly.Rhameur" | Select-Object Name, Enabled, DistinguishedName
```

**Vérification :**
```
Name          Enabled DistinguishedName
----          ------- -----------------
Kelly Rhameur False   CN=Kelly Rhameur,OU=DeactivatedUsers,DC=TSSR-LAN,DC=local
```

---

### Q.1.1.3 Modifier le groupe de l'OU dans laquelle était Kelly Rhameur en conséquence

**Contexte :**
Kelly Rhameur était dans un groupe spécifique à son OU (par exemple, le groupe "DirecteurDesRessourcesHumaines"). Il faut maintenant :
1. Retirer Kelly de ce groupe
2. S'assurer que Lionel y soit ajouté (déjà fait en Q.1.1.1)

**Méthode Graphique :**

**Étape 1 : Identifier le groupe de l'OU**
- Dans Active Directory Users and Computers
- Naviguer vers l'ancienne OU de Kelly
- Identifier le groupe correspondant (ex: TSSR-LAN\Users)

**Étape 2 : Modifier l'appartenance de Kelly**
- Double-cliquer sur le groupe
- Onglet "Membres"
- Sélectionner "Kelly Rhameur"
- Cliquer sur "Supprimer"
- Cliquer sur OK

**OU**

- Double-cliquer sur Kelly.Rhameur
- Onglet "Membre de"
- Sélectionner le groupe de l'OU
- Cliquer sur "Supprimer"

**Étape 3 : Vérifier que Lionel est bien membre du groupe**
- Double-cliquer sur le groupe
- Vérifier que "Lionel Lemarchand" apparaît dans les membres

**Méthode PowerShell :**

```powershell
# Identifier les groupes de Kelly (avant déplacement)
$kellyGroups = Get-ADUser "Kelly.Rhameur" -Properties MemberOf | 
    Select-Object -ExpandProperty MemberOf

# Retirer Kelly de tous les groupes de son ancienne OU
foreach ($group in $kellyGroups) {
    Remove-ADGroupMember -Identity $group -Members "Kelly.Rhameur" -Confirm:$false
}

# Vérifier que Lionel est bien dans le groupe approprié
Get-ADUser "Lionel.Lemarchand" -Properties MemberOf | 
    Select-Object -ExpandProperty MemberOf
```

---

### Q.1.1.4 Créer le dossier Individuel du nouvel utilisateur et archiver celui de Kelly Rhameur en le suffixant par -ARCHIVE

**Méthode Graphique (Explorateur de fichiers) :**

**Étape 1 : Localiser le dossier de Kelly Rhameur**
- Ouvrir l'Explorateur de fichiers
- Naviguer vers le partage des dossiers personnels (généralement `\\serveur\users\` ou `\\serveur\home\`)
- Localiser le dossier de Kelly Rhameur

**Étape 2 : Renommer le dossier de Kelly**
- Clic droit sur le dossier de Kelly Rhameur
- Sélectionner "Renommer"
- Ajouter le suffixe "-ARCHIVE"
- Exemple : `Kelly.Rhameur` → `Kelly.Rhameur-ARCHIVE`

**Étape 3 : Créer le dossier pour Lionel Lemarchand**
- Dans le même répertoire
- Clic droit → Nouveau → Dossier
- Nom : `Lionel.Lemarchand`

**Étape 4 : Configurer les permissions du nouveau dossier**
- Clic droit sur `Lionel.Lemarchand` → Propriétés
- Onglet "Sécurité"
- Cliquer sur "Avancé"
- Désactiver l'héritage si nécessaire
- Ajouter les permissions :
  - **Lionel.Lemarchand** : Contrôle total
  - **Administrateurs** : Contrôle total
  - **SYSTEM** : Contrôle total

**Étape 5 : Configurer le dossier de base dans AD**
- Ouvrir Active Directory Users and Computers
- Double-cliquer sur Lionel.Lemarchand
- Onglet "Profil"
- Section "Dossier de base" :
  - Sélectionner "Connecter"
  - Lecteur : choisir une lettre (ex: H:)
  - À : `\\SERVEUR\Users\Lionel.Lemarchand`
- Cliquer sur OK

**Méthode PowerShell :**

```powershell
# Variables
$serverName = "SRVWIN01"
$sharePath = "\\$serverName\Users"
$kellyFolder = "$sharePath\Kelly.Rhameur"
$kellyArchive = "$sharePath\Kelly.Rhameur-ARCHIVE"
$lionelFolder = "$sharePath\Lionel.Lemarchand"

# Renommer le dossier de Kelly
Rename-Item -Path $kellyFolder -NewName "Kelly.Rhameur-ARCHIVE"

# Créer le dossier pour Lionel
New-Item -Path $lionelFolder -ItemType Directory

# Configurer les permissions pour Lionel
$acl = Get-Acl $lionelFolder
$permission = "TSSR-LAN\Lionel.Lemarchand","FullControl","ContainerInherit,ObjectInherit","None","Allow"
$accessRule = New-Object System.Security.AccessControl.FileSystemAccessRule $permission
$acl.SetAccessRule($accessRule)
Set-Acl $lionelFolder $acl

# Configurer le dossier de base dans AD
Set-ADUser "Lionel.Lemarchand" -HomeDrive "H:" -HomeDirectory $lionelFolder

# Vérifier
Get-ADUser "Lionel.Lemarchand" -Properties HomeDirectory, HomeDrive | 
    Select-Object Name, HomeDirectory, HomeDrive
```

**Vérification :**
- Vérifier que le dossier `Kelly.Rhameur-ARCHIVE` existe
- Vérifier que le dossier `Lionel.Lemarchand` existe
- Tester la connexion avec Lionel et vérifier que le lecteur H: est mappé
- Vérifier les permissions

---

## Partie 2 : Restriction utilisateurs

### Q.1.2.1 Faire en sorte que l'utilisateur Gabriel Ghul ne puisse se connecter que du lundi au vendredi, de 7h à 17h

**Méthode Graphique :**

**Étape 1 : Ouvrir les propriétés de Gabriel Ghul**
- Active Directory Users and Computers
- Localiser Gabriel.Ghul
- Double-cliquer sur le compte

**Étape 2 : Configurer les heures d'ouverture de session**
- Onglet "Compte"
- Cliquer sur "Heures d'ouverture de session..."
- Une grille apparaît avec les jours et heures

**Étape 3 : Configurer la grille**
Par défaut, tout est autorisé (bleu). Il faut :
1. Sélectionner TOUT → Cliquer sur "Connexion refusée" (blanc)
2. Sélectionner Lundi à Vendredi, de 7h00 à 17h00
3. Cliquer sur "Connexion autorisée" (bleu)

**Configuration détaillée :**
- **Lundi** : 7h00-17h00 (autorisé)
- **Mardi** : 7h00-17h00 (autorisé)
- **Mercredi** : 7h00-17h00 (autorisé)
- **Jeudi** : 7h00-17h00 (autorisé)
- **Vendredi** : 7h00-17h00 (autorisé)
- **Samedi** : Tout refusé
- **Dimanche** : Tout refusé

**Étape 4 : Valider**
- Cliquer sur OK
- Cliquer sur OK dans les propriétés

**Méthode PowerShell :**

```powershell
# Créer un tableau d'octets pour les heures de connexion
# Chaque jour = 3 octets (24 heures)
# 21 octets au total (7 jours)
$hours = New-Object byte[] 21

# Fonction pour définir les heures autorisées
function Set-LogonHours {
    param($hours, $day, $startHour, $endHour)
    
    for ($hour = $startHour; $hour -lt $endHour; $hour++) {
        $byteIndex = ($day * 3) + [Math]::Floor($hour / 8)
        $bitIndex = $hour % 8
        $hours[$byteIndex] = $hours[$byteIndex] -bor ([byte](1 -shl $bitIndex))
    }
}

# Configurer lundi à vendredi (0-4), de 7h à 17h
for ($day = 0; $day -le 4; $day++) {
    Set-LogonHours -hours $hours -day $day -startHour 7 -endHour 17
}

# Appliquer à Gabriel Ghul
Set-ADUser "Gabriel.Ghul" -Replace @{logonHours = $hours}

# Vérifier
Get-ADUser "Gabriel.Ghul" -Properties logonHours
```

**Alternative PowerShell plus simple :**

```powershell
# Utiliser le module RSAT
$user = Get-ADUser "Gabriel.Ghul"

# Créer les heures de connexion (exemple simplifié)
# Lundi=1, Mardi=2, ... Vendredi=5
# 7h-17h = 07:00-17:00

# Note: La configuration complète nécessite un script plus complexe
# Il est recommandé d'utiliser l'interface graphique pour cette tâche
```

**Vérification :**
- Ouvrir les propriétés de Gabriel Ghul
- Vérifier dans "Heures d'ouverture de session"
- Tester en dehors des heures autorisées

---

### Q.1.2.2 De même, bloquer sa connexion au seul ordinateur CLIENT01

**Méthode Graphique :**

**Étape 1 : Ouvrir les propriétés de Gabriel Ghul**
- Active Directory Users and Computers
- Double-cliquer sur Gabriel.Ghul

**Étape 2 : Configurer les ordinateurs autorisés**
- Onglet "Compte"
- Cliquer sur "Se connecter à..."
- Sélectionner "Les ordinateurs suivants"

**Étape 3 : Ajouter CLIENT01**
- Dans la zone de texte, taper le nom de l'ordinateur
- Cliquer sur "Ajouter"
- Nom de l'ordinateur : **CLIENT01**
- Cliquer sur OK

**Étape 4 : Valider**
- Vérifier que CLIENT01 apparaît dans la liste
- Cliquer sur OK
- Cliquer sur OK dans les propriétés

**Méthode PowerShell :**

```powershell
# Définir l'ordinateur autorisé
Set-ADUser "Gabriel.Ghul" -Replace @{userWorkstations = "CLIENT01"}

# Pour plusieurs ordinateurs (séparés par des virgules)
# Set-ADUser "Gabriel.Ghul" -Replace @{userWorkstations = "CLIENT01,CLIENT02"}

# Vérifier
Get-ADUser "Gabriel.Ghul" -Properties userWorkstations | 
    Select-Object Name, userWorkstations
```

**Vérification :**
- Tenter de se connecter depuis CLIENT01 → devrait fonctionner
- Tenter de se connecter depuis un autre ordinateur → devrait être refusé
- Message d'erreur attendu : "Votre compte est configuré pour vous empêcher d'utiliser cet ordinateur"

---

### Q.1.2.3 Mettre en place une stratégie de mot de passe pour durcir les comptes des utilisateurs de l'OU LabUsers

**Méthode : Group Policy (GPO)**

**Étape 1 : Ouvrir la console de gestion des stratégies de groupe**
- Gestionnaire de serveur → Outils → Gestion des stratégies de groupe

**Étape 2 : Créer une nouvelle GPO**
- Développer la forêt et le domaine
- Clic droit sur l'OU "LabUsers"
- Sélectionner "Créer un objet GPO dans ce domaine et le lier ici..."
- Nom : **PasswordPolicy-LabUsers**
- Cliquer sur OK

**Étape 3 : Modifier la GPO**
- Clic droit sur la GPO créée → Modifier
- Naviguer vers :
  ```
  Configuration ordinateur
    └── Stratégies
        └── Paramètres Windows
            └── Paramètres de sécurité
                └── Stratégies de compte
                    └── Stratégie de mot de passe
  ```

**Étape 4 : Configurer les paramètres de mot de passe**

Configurer les paramètres suivants (valeurs recommandées) :

1. **Appliquer l'historique des mots de passe**
   - Activé
   - Valeur : 24 mots de passe mémorisés

2. **Durée de vie maximale du mot de passe**
   - Activé
   - Valeur : 90 jours

3. **Durée de vie minimale du mot de passe**
   - Activé
   - Valeur : 1 jour

4. **Longueur minimale du mot de passe**
   - Activé
   - Valeur : 12 caractères (ou 14 pour plus de sécurité)

5. **Le mot de passe doit respecter des exigences de complexité**
   - Activé
   - Cela impose :
     - Minimum 3 des 4 catégories : majuscules, minuscules, chiffres, caractères spéciaux
     - Ne pas contenir le nom de compte

6. **Stocker les mots de passe en utilisant un chiffrement réversible**
   - Désactivé (sauf besoin spécifique)

**Étape 5 : Configurer les paramètres de verrouillage de compte**

Naviguer vers :
```
Stratégies de compte → Stratégie de verrouillage du compte
```

Configurer :

1. **Seuil de verrouillage du compte**
   - Activé
   - Valeur : 5 tentatives incorrectes

2. **Durée de verrouillage du compte**
   - Activé
   - Valeur : 30 minutes

3. **Réinitialiser le compteur de verrouillages du compte après**
   - Activé
   - Valeur : 30 minutes

**Étape 6 : Appliquer la GPO**
- Fermer l'éditeur de stratégie de groupe
- La GPO est maintenant liée à l'OU LabUsers

**Étape 7 : Forcer la mise à jour**
Sur un poste client membre de l'OU LabUsers :
```cmd
gpupdate /force
```

**Méthode PowerShell :**

```powershell
# Créer une nouvelle GPO
$gpoName = "PasswordPolicy-LabUsers"
$ouPath = "OU=LabUsers,DC=TSSR-LAN,DC=local"

New-GPO -Name $gpoName | New-GPLink -Target $ouPath

# Configurer les paramètres de mot de passe
# Note: La configuration via PowerShell est complexe
# Il est recommandé d'utiliser l'interface graphique ou Set-ADDefaultDomainPasswordPolicy

# Pour une Fine-Grained Password Policy (FGPP) - alternative recommandée
New-ADFineGrainedPasswordPolicy -Name "LabUsers-PSO" `
    -Precedence 10 `
    -ComplexityEnabled $true `
    -MinPasswordLength 12 `
    -MaxPasswordAge "90.00:00:00" `
    -MinPasswordAge "1.00:00:00" `
    -PasswordHistoryCount 24 `
    -LockoutDuration "00:30:00" `
    -LockoutObservationWindow "00:30:00" `
    -LockoutThreshold 5

# Appliquer aux utilisateurs de LabUsers
$labUsers = Get-ADUser -Filter * -SearchBase $ouPath
foreach ($user in $labUsers) {
    Add-ADFineGrainedPasswordPolicySubject -Identity "LabUsers-PSO" -Subjects $user
}
```

**Vérification :**

```powershell
# Vérifier les GPO liées à l'OU
Get-GPInheritance -Target "OU=LabUsers,DC=TSSR-LAN,DC=local"

# Sur un poste client
gpresult /H gpresult.html
# Ouvrir le fichier HTML et vérifier les stratégies appliquées

# Vérifier la FGPP
Get-ADFineGrainedPasswordPolicy -Filter * | Format-List
```

**Test :**
1. Créer un utilisateur de test dans LabUsers
2. Tenter de définir un mot de passe faible → devrait être refusé
3. Définir un mot de passe conforme
4. Tester le verrouillage avec 5 mauvais mots de passe

---

## Partie 3 : Lecteurs réseaux

### Q.1.3.1 Créer une GPO Drive-Mount qui monte les lecteurs E: et F: sur les clients

**Contexte :**
Il faut créer une stratégie de groupe qui mappe automatiquement :
- Lecteur E: vers un partage réseau
- Lecteur F: vers un autre partage réseau

**Étape 1 : Créer les partages réseau (prérequis)**

Si les partages n'existent pas encore :

**Sur le serveur de fichiers :**
```powershell
# Créer les dossiers
New-Item -Path "C:\Shares\Drive-E" -ItemType Directory
New-Item -Path "C:\Shares\Drive-F" -ItemType Directory

# Créer les partages
New-SmbShare -Name "Drive-E" -Path "C:\Shares\Drive-E" -FullAccess "Everyone"
New-SmbShare -Name "Drive-F" -Path "C:\Shares\Drive-F" -FullAccess "Everyone"

# Configurer les permissions NTFS
$acl = Get-Acl "C:\Shares\Drive-E"
$permission = "BUILTIN\Users","Modify","ContainerInherit,ObjectInherit","None","Allow"
$accessRule = New-Object System.Security.AccessControl.FileSystemAccessRule $permission
$acl.SetAccessRule($accessRule)
Set-Acl "C:\Shares\Drive-E" $acl

# Répéter pour Drive-F
```

**Étape 2 : Créer la GPO**

**Méthode Graphique :**

1. **Ouvrir la gestion des stratégies de groupe**
   - Gestionnaire de serveur → Outils → Gestion des stratégies de groupe

2. **Créer une nouvelle GPO**
   - Développer Forêt → Domaines → TSSR-LAN
   - Clic droit sur l'OU cible (ou le domaine) → "Créer un objet GPO dans ce domaine et le lier ici..."
   - Nom : **Drive-Mount**
   - Cliquer sur OK

3. **Modifier la GPO**
   - Clic droit sur "Drive-Mount" → Modifier

4. **Configurer les mappages de lecteurs**

   Naviguer vers :
   ```
   Configuration utilisateur
     └── Préférences
         └── Paramètres Windows
             └── Mappages de lecteurs
   ```

5. **Créer le mappage pour le lecteur E:**
   - Clic droit dans le panneau de droite → Nouveau → Lecteur mappé
   - Configurer :
     - **Action** : Créer
     - **Emplacement** : `\\SRVWIN01\Drive-E` (adapter le nom du serveur)
     - **Reconnecter** : Coché
     - **Lettre de lecteur** : E:
     - **Utiliser** : E:
     - **Étiquette** : (optionnel, ex: "Lecteur E - Partagé")
   - Onglet "Commun" :
     - Optionnel : cocher "Cibler au niveau élément" si besoin de filtrage
   - Cliquer sur OK

6. **Créer le mappage pour le lecteur F:**
   - Clic droit dans le panneau de droite → Nouveau → Lecteur mappé
   - Configurer :
     - **Action** : Créer
     - **Emplacement** : `\\SRVWIN01\Drive-F`
     - **Reconnecter** : Coché
     - **Lettre de lecteur** : F:
     - **Utiliser** : F:
     - **Étiquette** : (optionnel, ex: "Lecteur F - Documents")
   - Cliquer sur OK

7. **Fermer l'éditeur**
   - Fermer la fenêtre de modification de la GPO

**Étape 3 : Lier la GPO à l'OU appropriée**

Si la GPO n'est pas encore liée :
- Clic droit sur l'OU cible → "Lier un objet de stratégie de groupe existant..."
- Sélectionner "Drive-Mount"
- Cliquer sur OK

**Méthode PowerShell :**

```powershell
# Créer la GPO
$gpoName = "Drive-Mount"
New-GPO -Name $gpoName

# Lier la GPO au domaine ou à une OU
New-GPLink -Name $gpoName -Target "DC=TSSR-LAN,DC=local"

# Pour configurer les mappages de lecteurs via PowerShell,
# il faut utiliser l'API XML de la GPO (complexe)
# Il est fortement recommandé d'utiliser l'interface graphique

# Alternative : utiliser Set-GPPrefRegistryValue pour certains paramètres
# Mais pour les mappages de lecteurs, l'interface graphique est préférable
```

**Configuration avancée - Ciblage (optionnel) :**

Si vous voulez que les lecteurs ne soient mappés que pour certains utilisateurs :

1. Dans les propriétés du lecteur mappé
2. Onglet "Commun"
3. Cocher "Cibler au niveau élément"
4. Cliquer sur "Ciblage..."
5. Ajouter des critères :
   - **Groupe de sécurité** : appartient à un groupe spécifique
   - **Utilisateur** : utilisateur spécifique
   - **Ordinateur** : ordinateur spécifique
   - Etc.

**Étape 4 : Forcer la mise à jour sur les clients**

**Sur un poste client :**
```cmd
gpupdate /force
```

**Ou se déconnecter et se reconnecter**

**Vérification :**

1. **Sur un poste client, après application de la GPO :**
   - Ouvrir l'Explorateur de fichiers
   - Vérifier que les lecteurs E: et F: sont présents
   - Vérifier qu'ils pointent vers les bons partages

2. **Vérifier la GPO appliquée :**
```cmd
gpresult /R
# Chercher "Drive-Mount" dans la liste des GPO appliquées

# Ou générer un rapport HTML
gpresult /H C:\gpresult.html
```

3. **Tester l'accès aux lecteurs :**
   - Ouvrir le lecteur E:
   - Créer un fichier test
   - Vérifier sur le serveur que le fichier existe dans `C:\Shares\Drive-E`

**Dépannage :**

Si les lecteurs ne sont pas mappés :

1. **Vérifier que la GPO est bien appliquée :**
```cmd
gpresult /R
```

2. **Vérifier les journaux d'événements :**
   - Observateur d'événements
   - Journaux Windows → Application
   - Chercher les erreurs liées à GroupPolicy

3. **Vérifier les permissions :**
   - L'utilisateur a-t-il accès aux partages ?
   - Les permissions NTFS sont-elles correctes ?

4. **Forcer une mise à jour :**
```cmd
gpupdate /force /wait:0
```

5. **Redémarrer le poste client**

---

## Commandes PowerShell utiles

### Gestion des utilisateurs
```powershell
# Créer un utilisateur
New-ADUser -Name "John Doe" -GivenName "John" -Surname "Doe" `
    -SamAccountName "jdoe" -UserPrincipalName "jdoe@domain.com" `
    -AccountPassword (ConvertTo-SecureString "P@ssw0rd" -AsPlainText -Force) `
    -Enabled $true

# Modifier un utilisateur
Set-ADUser "jdoe" -Title "Manager" -Department "IT"

# Désactiver un utilisateur
Disable-ADAccount -Identity "jdoe"

# Activer un utilisateur
Enable-ADAccount -Identity "jdoe"

# Déplacer un utilisateur
Move-ADObject -Identity "CN=John Doe,OU=Users,DC=domain,DC=com" `
    -TargetPath "OU=Disabled,DC=domain,DC=com"

# Supprimer un utilisateur
Remove-ADUser -Identity "jdoe" -Confirm:$false
```

### Gestion des groupes
```powershell
# Créer un groupe
New-ADGroup -Name "IT-Team" -GroupScope Global -GroupCategory Security

# Ajouter un membre
Add-ADGroupMember -Identity "IT-Team" -Members "jdoe"

# Retirer un membre
Remove-ADGroupMember -Identity "IT-Team" -Members "jdoe" -Confirm:$false

# Lister les membres d'un groupe
Get-ADGroupMember -Identity "IT-Team"
```

### Gestion des OU
```powershell
# Créer une OU
New-ADOrganizationalUnit -Name "Disabled Users" -Path "DC=domain,DC=com"

# Supprimer une OU
Remove-ADOrganizationalUnit -Identity "OU=Test,DC=domain,DC=com" -Confirm:$false
```

### Gestion des GPO
```powershell
# Lister toutes les GPO
Get-GPO -All

# Créer une GPO
New-GPO -Name "TestGPO"

# Lier une GPO
New-GPLink -Name "TestGPO" -Target "OU=Users,DC=domain,DC=com"

# Supprimer une GPO
Remove-GPO -Name "TestGPO"

# Générer un rapport GPO
Get-GPOReport -Name "TestGPO" -ReportType HTML -Path "C:\GPOReport.html"
```

### Gestion des partages
```powershell
# Créer un partage
New-SmbShare -Name "SharedFolder" -Path "C:\Shared" -FullAccess "Everyone"

# Lister les partages
Get-SmbShare

# Supprimer un partage
Remove-SmbShare -Name "SharedFolder" -Force
```

---

## Checklist de vérification

### Partie 1 - Gestion des utilisateurs
- [ ] Lionel Lemarchand créé avec tous les attributs de Kelly
- [ ] Lionel ajouté aux mêmes groupes que Kelly
- [ ] OU DeactivatedUsers créée
- [ ] Kelly Rhameur désactivée
- [ ] Kelly déplacée vers DeactivatedUsers
- [ ] Kelly retirée des groupes de son ancienne OU
- [ ] Dossier de Kelly renommé avec -ARCHIVE
- [ ] Dossier de Lionel créé
- [ ] Permissions configurées sur le dossier de Lionel
- [ ] Dossier de base configuré dans AD pour Lionel

### Partie 2 - Restrictions utilisateurs
- [ ] Heures de connexion configurées pour Gabriel (Lun-Ven, 7h-17h)
- [ ] Ordinateur autorisé configuré pour Gabriel (CLIENT01 uniquement)
- [ ] GPO de mot de passe créée pour LabUsers
- [ ] Paramètres de complexité configurés (12 caractères minimum)
- [ ] Historique de 24 mots de passe
- [ ] Verrouillage après 5 tentatives
- [ ] GPO testée et fonctionnelle

### Partie 3 - Lecteurs réseaux
- [ ] Partages réseau créés (Drive-E et Drive-F)
- [ ] Permissions configurées sur les partages
- [ ] GPO Drive-Mount créée
- [ ] Mappage lecteur E: configuré
- [ ] Mappage lecteur F: configuré
- [ ] GPO liée à l'OU appropriée
- [ ] Lecteurs testés sur un poste client
- [ ] Accès aux partages vérifié

---

## Bonnes pratiques

1. **Documentation**
   - Documenter tous les changements effectués
   - Tenir un journal des modifications
   - Conserver les anciennes configurations

2. **Sauvegardes**
   - Sauvegarder les données de Kelly avant archivage
   - Sauvegarder les GPO avant modification
   - Conserver une copie de la configuration AD

3. **Tests**
   - Tester les restrictions d'heures
   - Tester les restrictions d'ordinateurs
   - Tester les mappages de lecteurs
   - Vérifier les permissions

4. **Sécurité**
   - Utiliser des mots de passe forts
   - Limiter les accès administrateurs
   - Surveiller les journaux d'événements
   - Auditer les changements AD régulièrement

5. **Maintenance**
   - Nettoyer régulièrement les comptes désactivés
   - Archiver les données des utilisateurs partis
   - Réviser les GPO périodiquement
   - Mettre à jour la documentation

---

## Dépannage courant

### Problème : L'utilisateur ne peut pas se connecter
- Vérifier que le compte est activé
- Vérifier les heures de connexion
- Vérifier les ordinateurs autorisés
- Vérifier que le mot de passe n'a pas expiré
- Vérifier les journaux d'événements

### Problème : Les lecteurs ne se mappent pas
- Forcer gpupdate /force
- Vérifier les permissions sur les partages
- Vérifier que le serveur est accessible
- Vérifier la configuration de la GPO
- Redémarrer le poste client

### Problème : La GPO ne s'applique pas
- Vérifier le lien de la GPO
- Vérifier l'héritage de la GPO
- Vérifier les filtres de sécurité
- Utiliser gpresult pour diagnostiquer
- Vérifier les journaux d'événements

### Problème : Permissions refusées
- Vérifier les permissions NTFS
- Vérifier les permissions de partage
- Vérifier l'appartenance aux groupes
- Vérifier les GPO de restriction

---

## Ressources supplémentaires

- Documentation Microsoft Active Directory
- Documentation Group Policy
- PowerShell pour Active Directory
- Outils RSAT (Remote Server Administration Tools)
- Journaux d'événements Windows

---

**Fin du guide**
