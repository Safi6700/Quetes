

## 📋 Table des matières

```table-of-contents
title: 
style: nestedList # TOC style (nestedList|nestedOrderedList|inlineFirstLevel)
minLevel: 2 # Include headings from the specified level
maxLevel: 2 # Include headings up to the specified level
include: 
exclude: 
includeLinks: true # Make headings clickable
hideWhenEmpty: false # Hide TOC if no headings are found
debugInConsole: false # Print debug info in Obsidian console
```

---

## 🎯 Introduction aux groupes locaux

Les **groupes locaux** sont des conteneurs qui permettent d'organiser les utilisateurs et de gérer les permissions sur un système Windows local. Contrairement aux groupes de domaine Active Directory, ils existent uniquement sur la machine où ils sont créés.

### Pourquoi utiliser des groupes locaux ?

- **Simplification de la gestion des permissions** : Au lieu d'attribuer des droits à chaque utilisateur individuellement, on les attribue au groupe
- **Organisation logique** : Regroupement des utilisateurs par fonction, département ou besoin d'accès
- **Sécurité renforcée** : Principe du moindre privilège appliqué par catégorie
- **Maintenance facilitée** : Ajout/retrait d'un utilisateur du groupe plutôt que modification des permissions

> [!info] Contexte d'utilisation Les groupes locaux sont particulièrement pertinents pour :
> 
> - Les postes de travail autonomes (non-domaine)
> - Les serveurs de workgroup
> - Les environnements de test et développement
> - Les machines avec des besoins de permissions spécifiques locales

---

## 🔍 Get-LocalGroup - Consultation des groupes

### Vue d'ensemble

`Get-LocalGroup` permet de lister et d'inspecter tous les groupes locaux présents sur une machine Windows. C'est votre outil de diagnostic pour comprendre l'organisation actuelle des groupes.

### Syntaxe de base

```powershell
# Lister tous les groupes locaux
Get-LocalGroup

# Obtenir un groupe spécifique par nom
Get-LocalGroup -Name "Administrators"

# Obtenir un groupe par son SID (Security Identifier)
Get-LocalGroup -SID "S-1-5-32-544"
```

### Les propriétés des groupes

Chaque groupe local possède plusieurs propriétés importantes :

|Propriété|Description|Exemple|
|---|---|---|
|**Name**|Nom d'affichage du groupe|"Administrators"|
|**Description**|Description textuelle du rôle du groupe|"Administrators have complete and unrestricted access..."|
|**SID**|Identifiant de sécurité unique|"S-1-5-32-544"|
|**ObjectClass**|Type d'objet (toujours "Group" ici)|"Group"|
|**PrincipalSource**|Source du principal (Local, ActiveDirectory, etc.)|"Local"|

```powershell
# Afficher toutes les propriétés d'un groupe
Get-LocalGroup -Name "Administrators" | Format-List *

# Afficher uniquement certaines propriétés
Get-LocalGroup | Select-Object Name, Description, SID
```

> [!example] Exemple de sortie
> 
> ```
> Name             : Administrators
> Description      : Administrators have complete and unrestricted access to the computer/domain
> SID              : S-1-5-32-544
> ObjectClass      : Group
> PrincipalSource  : Local
> ```

### Les groupes intégrés Windows

Windows crée automatiquement plusieurs groupes locaux lors de l'installation. Voici les principaux :

#### 🔑 **Administrators**

- **Permissions** : Accès complet et illimité à la machine
- **Usage** : Réservé aux administrateurs système uniquement
- **SID** : S-1-5-32-544

```powershell
Get-LocalGroup -Name "Administrators"
```

#### 👥 **Users**

- **Permissions** : Permissions standard pour utiliser la machine
- **Usage** : Utilisateurs quotidiens sans privilèges administratifs
- **SID** : S-1-5-32-545

#### 🚪 **Guests**

- **Permissions** : Accès très limité, temporaire
- **Usage** : Comptes invités occasionnels
- **SID** : S-1-5-32-546

#### ⚡ **Power Users**

- **Permissions** : Permissions élevées mais pas totales (groupe legacy)
- **Usage** : Compatibilité avec anciennes applications
- **SID** : S-1-5-32-547

> [!warning] Attention : Power Users Le groupe Power Users est un héritage des anciennes versions de Windows. Dans les environnements modernes (Windows 10/11, Server 2016+), il n'a plus de permissions spéciales par défaut. Évitez de l'utiliser pour de nouvelles configurations.

#### 🖥️ **Remote Desktop Users**

- **Permissions** : Droit de se connecter via Bureau à distance
- **Usage** : Utilisateurs autorisés à se connecter en RDP
- **SID** : S-1-5-32-555

```powershell
# Vérifier qui peut se connecter en RDP
Get-LocalGroup -Name "Remote Desktop Users"
```

#### 💾 **Backup Operators**

- **Permissions** : Droit de sauvegarder et restaurer des fichiers
- **Usage** : Comptes de service de backup
- **SID** : S-1-5-32-551

### Recherche et filtrage avancés

#### Utilisation des wildcards

```powershell
# Trouver tous les groupes contenant "Remote"
Get-LocalGroup -Name "*Remote*"

# Trouver tous les groupes commençant par "Backup"
Get-LocalGroup -Name "Backup*"

# Trouver tous les groupes se terminant par "Users"
Get-LocalGroup -Name "*Users"
```

> [!tip] Astuce : Recherche insensible à la casse PowerShell traite les wildcards de manière insensible à la casse. `"*admin*"` trouvera "Administrators", "ADMIN", "Admin", etc.

#### Identification des groupes personnalisés

Pour différencier les groupes intégrés Windows des groupes créés manuellement :

```powershell
# Les groupes intégrés ont des SID bien connus commençant par S-1-5-32
# Les groupes personnalisés ont des SID différents

Get-LocalGroup | Where-Object { $_.SID -notlike "S-1-5-32-*" }
```

#### Filtrage par description

```powershell
# Trouver les groupes avec une description spécifique
Get-LocalGroup | Where-Object { $_.Description -like "*access*" }

# Trouver les groupes sans description
Get-LocalGroup | Where-Object { [string]::IsNullOrEmpty($_.Description) }
```

### Exemples pratiques

```powershell
# Audit complet : Exporter tous les groupes dans un CSV
Get-LocalGroup | Export-Csv -Path "C:\Audit\LocalGroups.csv" -NoTypeInformation

# Compter le nombre total de groupes
(Get-LocalGroup).Count

# Afficher uniquement les noms de groupes
Get-LocalGroup | Select-Object -ExpandProperty Name

# Vérifier l'existence d'un groupe spécifique
if (Get-LocalGroup -Name "Developers" -ErrorAction SilentlyContinue) {
    Write-Host "Le groupe Developers existe"
} else {
    Write-Host "Le groupe Developers n'existe pas"
}
```

> [!warning] Gestion des erreurs Utilisez toujours `-ErrorAction SilentlyContinue` ou un bloc `try/catch` lors de la recherche de groupes qui pourraient ne pas exister, pour éviter des erreurs qui interrompent votre script.

---

## ➕ New-LocalGroup - Création de groupes

### Vue d'ensemble

`New-LocalGroup` permet de créer de nouveaux groupes locaux personnalisés. C'est essentiel pour organiser les permissions selon vos besoins spécifiques.

### Syntaxe de base

```powershell
# Syntaxe minimale (seul le nom est obligatoire)
New-LocalGroup -Name "NomDuGroupe"

# Syntaxe complète avec description
New-LocalGroup -Name "NomDuGroupe" -Description "Description du rôle du groupe"
```

### Paramètres détaillés

#### `-Name` (Obligatoire)

Le nom du groupe à créer. Doit être unique sur la machine.

```powershell
New-LocalGroup -Name "Developers"
```

> [!warning] Contraintes de nommage
> 
> - Maximum 256 caractères
> - Ne peut pas contenir uniquement des points ou espaces
> - Ne peut pas contenir : `" / \ [ ] : ; | = , + * ? < > @`
> - Sensible à la casse lors de la création, mais Windows traite les noms comme insensibles à la casse

#### `-Description`

Documentation du rôle et de l'usage du groupe. **Fortement recommandé** pour la maintenance.

```powershell
New-LocalGroup -Name "Developers" -Description "Développeurs avec accès aux outils de développement"
```

> [!tip] Bonnes pratiques pour les descriptions
> 
> - Soyez spécifique : "Accès en lecture aux logs d'application" plutôt que "Logs"
> - Indiquez le périmètre : "Équipe Finance - Accès comptabilité"
> - Mentionnez les restrictions : "Lecture seule, pas de modification"

### Cas d'usage courants

#### 1️⃣ Groupes départementaux

Organisation par service ou département de l'entreprise.

```powershell
# Groupe pour le département RH
New-LocalGroup -Name "RH_Team" -Description "Équipe Ressources Humaines - Accès aux dossiers RH"

# Groupe pour le département IT
New-LocalGroup -Name "IT_Support" -Description "Support informatique - Accès aux outils de diagnostic"

# Groupe pour le département Finance
New-LocalGroup -Name "Finance_Team" -Description "Équipe Finance - Accès aux systèmes comptables"
```

#### 2️⃣ Groupes d'application

Permissions spécifiques pour des applications métier.

```powershell
# Groupe pour une application de base de données
New-LocalGroup -Name "AppDB_Users" -Description "Utilisateurs autorisés à accéder à AppDB"

# Groupe pour les administrateurs d'application
New-LocalGroup -Name "AppDB_Admins" -Description "Administrateurs de l'application AppDB avec droits de configuration"

# Groupe pour les lecteurs uniquement
New-LocalGroup -Name "AppDB_Readers" -Description "Accès en lecture seule à AppDB"
```

#### 3️⃣ Groupes de permissions spécifiques

Permissions granulaires pour des tâches précises.

```powershell
# Groupe pour la lecture des logs
New-LocalGroup -Name "LogReaders" -Description "Accès en lecture aux fichiers logs système et application"

# Groupe pour les opérations de backup
New-LocalGroup -Name "BackupOperators_Custom" -Description "Opérateurs de sauvegarde pour applications spécifiques"

# Groupe pour accès réseau
New-LocalGroup -Name "NetworkShare_RW" -Description "Accès lecture/écriture au partage réseau \\server\data"
```

### Droits administrateur nécessaires

> [!warning] Privilèges requis La création de groupes locaux **nécessite des privilèges administrateur**. Vous devez :
> 
> - Être membre du groupe Administrators local
> - Ou exécuter PowerShell en tant qu'administrateur (clic droit → "Exécuter en tant qu'administrateur")

```powershell
# Vérifier si vous avez les droits administrateur
$currentPrincipal = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
$isAdmin = $currentPrincipal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)

if ($isAdmin) {
    Write-Host "✓ Vous avez les droits administrateur" -ForegroundColor Green
} else {
    Write-Host "✗ Droits administrateur requis" -ForegroundColor Red
}
```

### Nommage cohérent et standardisé

Une convention de nommage claire facilite la gestion à long terme.

#### Préfixes par catégorie

```powershell
# Groupes départementaux : DEPT_
New-LocalGroup -Name "DEPT_Sales" -Description "Département des ventes"
New-LocalGroup -Name "DEPT_Marketing" -Description "Département marketing"

# Groupes applicatifs : APP_
New-LocalGroup -Name "APP_CRM_Users" -Description "Utilisateurs du CRM"
New-LocalGroup -Name "APP_CRM_Admins" -Description "Administrateurs du CRM"

# Groupes de permissions : PERM_
New-LocalGroup -Name "PERM_Backup" -Description "Droits de sauvegarde"
New-LocalGroup -Name "PERM_Logs_Read" -Description "Lecture des logs"

# Groupes de projet : PROJ_
New-LocalGroup -Name "PROJ_Alpha_Team" -Description "Équipe projet Alpha"
```

#### Suffixes par niveau de permission

```powershell
# Lecture seule : _RO (Read Only)
New-LocalGroup -Name "Finance_RO" -Description "Finance - Lecture seule"

# Lecture/Écriture : _RW (Read Write)
New-LocalGroup -Name "Finance_RW" -Description "Finance - Lecture et écriture"

# Administration : _Admin
New-LocalGroup -Name "Finance_Admin" -Description "Finance - Administration complète"
```

### Gestion des erreurs courantes

```powershell
# Vérifier si le groupe existe déjà avant de créer
try {
    $existingGroup = Get-LocalGroup -Name "Developers" -ErrorAction Stop
    Write-Host "Le groupe 'Developers' existe déjà" -ForegroundColor Yellow
} catch {
    # Le groupe n'existe pas, on peut le créer
    New-LocalGroup -Name "Developers" -Description "Équipe de développement"
    Write-Host "Groupe 'Developers' créé avec succès" -ForegroundColor Green
}
```

```powershell
# Création avec gestion d'erreur complète
try {
    New-LocalGroup -Name "TestGroup" -Description "Groupe de test" -ErrorAction Stop
    Write-Host "✓ Groupe créé avec succès" -ForegroundColor Green
} catch [Microsoft.PowerShell.Commands.GroupExistsException] {
    Write-Host "✗ Le groupe existe déjà" -ForegroundColor Yellow
} catch [System.UnauthorizedAccessException] {
    Write-Host "✗ Droits administrateur insuffisants" -ForegroundColor Red
} catch {
    Write-Host "✗ Erreur : $($_.Exception.Message)" -ForegroundColor Red
}
```

### Exemples de scripts complets

#### Création en masse de groupes départementaux

```powershell
# Définition des départements
$departments = @(
    @{Name="DEPT_Sales"; Description="Département des ventes"},
    @{Name="DEPT_Marketing"; Description="Département marketing"},
    @{Name="DEPT_IT"; Description="Département informatique"},
    @{Name="DEPT_HR"; Description="Ressources humaines"}
)

# Création de tous les groupes
foreach ($dept in $departments) {
    try {
        New-LocalGroup -Name $dept.Name -Description $dept.Description -ErrorAction Stop
        Write-Host "✓ Groupe $($dept.Name) créé" -ForegroundColor Green
    } catch {
        Write-Host "✗ Échec pour $($dept.Name): $($_.Exception.Message)" -ForegroundColor Red
    }
}
```

#### Création avec validation

```powershell
function New-ValidatedLocalGroup {
    param(
        [Parameter(Mandatory=$true)]
        [string]$Name,
        
        [string]$Description = ""
    )
    
    # Validation du nom
    if ($Name -match '["/\\[\]:;|=,+*?<>@]') {
        Write-Error "Le nom contient des caractères interdits"
        return
    }
    
    # Vérification de l'existence
    if (Get-LocalGroup -Name $Name -ErrorAction SilentlyContinue) {
        Write-Warning "Le groupe '$Name' existe déjà"
        return
    }
    
    # Création
    try {
        New-LocalGroup -Name $Name -Description $Description -ErrorAction Stop
        Write-Host "✓ Groupe '$Name' créé avec succès" -ForegroundColor Green
    } catch {
        Write-Error "Échec de création : $($_.Exception.Message)"
    }
}

# Utilisation
New-ValidatedLocalGroup -Name "PROJ_Phoenix" -Description "Équipe projet Phoenix"
```

---

## ✅ Bonnes pratiques

### 1. Documentation systématique

```powershell
# TOUJOURS ajouter une description explicite
New-LocalGroup -Name "WebDevelopers" -Description "Développeurs web - Accès IIS et dossiers web"

# PAS de groupes sans description
New-LocalGroup -Name "WebDevelopers"  # ❌ Mauvais
```

### 2. Convention de nommage stricte

- Définissez une convention et respectez-la dans toute l'organisation
- Utilisez des préfixes/suffixes cohérents
- Évitez les noms ambigus comme "Group1", "TestGroup"

### 3. Principe du moindre privilège

```powershell
# Créez des groupes avec des permissions granulaires
New-LocalGroup -Name "Logs_ReadOnly" -Description "Lecture seule des logs"
New-LocalGroup -Name "Logs_ReadWrite" -Description "Lecture et écriture des logs"
New-LocalGroup -Name "Logs_Admin" -Description "Administration complète des logs"

# Plutôt qu'un seul groupe avec tous les droits
```

### 4. Audit régulier

```powershell
# Script d'audit mensuel
Get-LocalGroup | 
    Select-Object Name, Description, SID | 
    Export-Csv "C:\Audit\LocalGroups_$(Get-Date -Format 'yyyy-MM-dd').csv" -NoTypeInformation
```

### 5. Nettoyage des groupes obsolètes

```powershell
# Identifier les groupes personnalisés (non-intégrés)
$customGroups = Get-LocalGroup | Where-Object { $_.SID -notlike "S-1-5-32-*" }

# Vérifier lesquels sont inutilisés (à faire manuellement pour chaque groupe)
foreach ($group in $customGroups) {
    $members = Get-LocalGroupMember -Group $group.Name -ErrorAction SilentlyContinue
    if ($members.Count -eq 0) {
        Write-Host "⚠️  Groupe vide : $($group.Name)" -ForegroundColor Yellow
    }
}
```

### 6. Séparation des environnements

Pour les machines de développement/test :

```powershell
# Utilisez des préfixes d'environnement
New-LocalGroup -Name "DEV_Developers" -Description "[DEV] Développeurs"
New-LocalGroup -Name "TEST_Testers" -Description "[TEST] Testeurs"
New-LocalGroup -Name "PROD_Operators" -Description "[PROD] Opérateurs"
```

> [!tip] Astuce : Script de déploiement Créez un script PowerShell standardisé pour déployer la même structure de groupes sur toutes les machines d'un même type (postes dev, serveurs, etc.). Cela garantit la cohérence de votre infrastructure.

---

## 🎓 Points clés à retenir

1. **Get-LocalGroup** est votre outil d'inspection et d'audit des groupes locaux
2. Les groupes intégrés Windows (Administrators, Users, etc.) ont des rôles prédéfinis
3. **New-LocalGroup** nécessite des privilèges administrateur
4. La description d'un groupe est optionnelle mais **fortement recommandée**
5. Une convention de nommage cohérente facilite la gestion à long terme
6. Privilégiez la granularité des permissions (plusieurs groupes spécialisés plutôt qu'un groupe "tout-puissant")
7. Auditez régulièrement vos groupes pour identifier les groupes obsolètes ou mal configurés

---

> [!info] Note Ce cours couvre uniquement la consultation et la création de groupes locaux. La gestion des membres (ajout, suppression d'utilisateurs dans les groupes) est traitée dans une autre section du cours avec les cmdlets `Add-LocalGroupMember`, `Remove-LocalGroupMember` et `Get-LocalGroupMember`.