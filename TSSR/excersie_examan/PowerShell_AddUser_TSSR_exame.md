# PowerShell — Commenter & Débugger un Script AddUser (TSSR)

> **Objectif** : Être capable de comprendre, commenter et débugger un script de création d'utilisateurs
> **Durée estimée** : 4-6 heures à ton rythme
> **Conseil** : Ouvre PowerShell ISE (tape `ise` dans le menu Démarrer) et teste chaque exemple

---

## PARTIE 1 — Les bases indispensables (avant de toucher un script)

### 1.1 — C'est quoi une cmdlet ?

Une **cmdlet** (prononce "command-let") c'est une commande PowerShell.
Elle suit TOUJOURS le format : **Verbe-Nom**

```
Get-Help        → "Obtenir" + "Aide"
New-LocalUser   → "Nouveau" + "UtilisateurLocal"
Add-LocalGroupMember → "Ajouter" + "MembreGroupeLocal"
```

**Les verbes les plus courants :**

| Verbe   | Signification      | Exemple               |
|---------|---------------------|-----------------------|
| `Get`   | Récupérer/Lire      | `Get-LocalUser`       |
| `New`   | Créer               | `New-LocalUser`       |
| `Set`   | Modifier            | `Set-LocalUser`       |
| `Add`   | Ajouter             | `Add-LocalGroupMember`|
| `Remove`| Supprimer           | `Remove-LocalUser`    |
| `Import`| Importer            | `Import-Csv`          |
| `Export`| Exporter            | `Export-Csv`          |
| `Write` | Écrire/Afficher     | `Write-Host`          |

---

### 1.2 — Les variables

Une variable commence TOUJOURS par `$`

```powershell
$nom = "Dupont"           # Je stocke du texte (string)
$age = 25                 # Je stocke un nombre (int)
$actif = $true            # Je stocke vrai/faux (booléen)
```

**Insérer une variable dans du texte :**

```powershell
# Guillemets doubles " " → la variable est remplacée par sa valeur
Write-Host "Bonjour $nom"    # Affiche : Bonjour Dupont

# Guillemets simples ' ' → le texte est pris tel quel (littéral)
Write-Host 'Bonjour $nom'    # Affiche : Bonjour $nom
```

> ⚠️ **Piège d'examen** : `" "` et `' '` ne font pas la même chose !

---

### 1.3 — Le pipe `|`

Le pipe envoie le **résultat** d'une commande vers une autre commande.

```powershell
# Sans pipe : je fais 2 étapes séparées
$users = Get-LocalUser
$users | Where-Object { $_.Enabled -eq $true }

# Avec pipe : tout en une ligne
Get-LocalUser | Where-Object { $_.Enabled -eq $true }
# Je récupère les utilisateurs, puis je filtre ceux qui sont actifs
```

`$_` = l'objet en cours dans le pipe (chaque utilisateur un par un)

---

### 1.4 — Les paramètres

Les paramètres commencent par `-` et donnent des infos à la cmdlet :

```powershell
New-LocalUser -Name "Dupont" -Password $mdp -FullName "Jean Dupont"
#             ↑ paramètre      ↑ valeur    ↑ paramètre  ↑ valeur
```

---

### 1.5 — Les commentaires

```powershell
# Ceci est un commentaire sur une ligne

<#
  Ceci est un commentaire
  sur plusieurs lignes
  (bloc de commentaire)
#>
```

---

## PARTIE 2 — Les cmdlets clés pour AddUser

### 2.1 — Créer un utilisateur : `New-LocalUser`

```powershell
New-LocalUser -Name "jdupont" -Password $mdp -FullName "Jean Dupont" -Description "Comptabilité"
```

| Paramètre      | Obligatoire ? | Description                            |
|----------------|---------------|----------------------------------------|
| `-Name`        | ✅ OUI        | Login du compte (ex: "jdupont")        |
| `-Password`    | ✅ OUI*       | Mot de passe en SecureString           |
| `-FullName`    | ❌ NON        | Nom complet affiché                    |
| `-Description` | ❌ NON        | Description du compte                  |
| `-AccountNeverExpires` | ❌ NON | Le compte n'expire jamais             |
| `-NoPassword`  | ❌ NON        | Créer sans mot de passe (déconseillé)  |

*Le mot de passe doit être un **SecureString**, pas du texte brut :

```powershell
# Méthode 1 : convertir un texte en SecureString (dans un script)
$mdp = ConvertTo-SecureString "P@ssw0rd123!" -AsPlainText -Force

# Méthode 2 : demander la saisie masquée (interactif)
$mdp = Read-Host "Mot de passe" -AsSecureString
```

> ⚠️ **Piège d'examen** : Sans `-AsPlainText -Force`, `ConvertTo-SecureString` ne marche pas sur du texte brut → erreur !

---

### 2.2 — Ajouter à un groupe : `Add-LocalGroupMember`

```powershell
Add-LocalGroupMember -Group "Utilisateurs" -Member "jdupont"
```

| Paramètre | Description                                          |
|-----------|------------------------------------------------------|
| `-Group`  | Nom du groupe (attention FR/EN !)                    |
| `-Member` | Nom de l'utilisateur à ajouter                       |

> ⚠️ **Piège d'examen** : Sur un Windows FR c'est `"Utilisateurs"`, sur un EN c'est `"Users"`. Pareil : `"Administrateurs"` vs `"Administrators"`

---

### 2.3 — Importer un CSV : `Import-Csv`

Un fichier CSV c'est un tableau en texte. Exemple de `utilisateurs.csv` :

```
Nom;Prenom;Login;MotDePasse;Groupe
Dupont;Jean;jdupont;P@ss123!;Utilisateurs
Martin;Sophie;smartin;P@ss456!;Administrateurs
```

```powershell
$users = Import-Csv -Path "C:\utilisateurs.csv" -Delimiter ";"
# $users contient maintenant un tableau d'objets
# Chaque ligne du CSV = un objet
# Chaque colonne = une propriété accessible avec .NomColonne
```

Accéder aux données :

```powershell
$users[0].Nom       # → "Dupont"    (première ligne, colonne Nom)
$users[0].Login     # → "jdupont"
$users[1].Prenom    # → "Sophie"    (deuxième ligne, colonne Prenom)
```

> ⚠️ **Piège d'examen** : Le délimiteur par défaut est la **virgule** `,`. En France on utilise souvent le **point-virgule** `;` → il faut préciser `-Delimiter ";"`

---

### 2.4 — La boucle `foreach`

Pour traiter chaque ligne du CSV une par une :

```powershell
foreach ($user in $users) {
    # $user = la ligne en cours
    Write-Host $user.Nom       # Affiche le nom de chaque utilisateur
    Write-Host $user.Prenom
}
```

Autre écriture (via le pipe) :

```powershell
$users | ForEach-Object {
    # $_ = la ligne en cours
    Write-Host $_.Nom
}
```

---

### 2.5 — Conditions `if/else`

```powershell
if (condition) {
    # Si la condition est vraie
} else {
    # Sinon
}
```

Exemple concret — vérifier si un utilisateur existe déjà :

```powershell
if (Get-LocalUser -Name "jdupont" -ErrorAction SilentlyContinue) {
    Write-Host "L'utilisateur jdupont existe déjà"
} else {
    Write-Host "L'utilisateur jdupont n'existe pas, je le crée"
    New-LocalUser -Name "jdupont" -Password $mdp
}
```

`-ErrorAction SilentlyContinue` → si l'utilisateur n'existe pas, ça ne plante pas, ça renvoie juste "rien"

---

### 2.6 — `try/catch` (gestion d'erreurs)

```powershell
try {
    # Je tente de faire quelque chose
    New-LocalUser -Name "jdupont" -Password $mdp
    Write-Host "Utilisateur créé avec succès"
}
catch {
    # Si ça plante, j'arrive ici
    Write-Host "Erreur : $_"
    # $_ contient le message d'erreur
}
```

---

## PARTIE 3 — Script complet commenté (à connaître par cœur)

Voici un script typique d'examen TSSR avec **chaque ligne commentée** :

```powershell
<#
    Script : Création d'utilisateurs locaux depuis un fichier CSV
    Auteur : [Ton nom]
    Date   : [Date]
    Usage  : Exécuter en tant qu'Administrateur
#>

# ============================================================
# VARIABLES
# ============================================================

# Je définis le chemin du fichier CSV contenant les utilisateurs
$cheminCsv = "C:\Scripts\utilisateurs.csv"

# Je définis le mot de passe par défaut pour tous les comptes
# ConvertTo-SecureString convertit le texte en chaîne sécurisée
# -AsPlainText : j'envoie du texte brut
# -Force : je confirme que je sais ce que je fais
$mdpDefaut = ConvertTo-SecureString "P@ssw0rd123!" -AsPlainText -Force

# ============================================================
# IMPORT DU CSV
# ============================================================

# J'importe le fichier CSV dans une variable
# -Delimiter ";" : le séparateur est le point-virgule (standard FR)
$utilisateurs = Import-Csv -Path $cheminCsv -Delimiter ";"

# ============================================================
# BOUCLE DE CREATION
# ============================================================

# Je parcours chaque ligne du CSV (chaque utilisateur)
foreach ($user in $utilisateurs) {

    # Je récupère les infos de la ligne en cours dans des variables
    $login  = $user.Login
    $nom    = $user.Nom
    $prenom = $user.Prenom
    $groupe = $user.Groupe

    # Je construis le nom complet en combinant prénom et nom
    $nomComplet = "$prenom $nom"

    # Je vérifie si l'utilisateur existe déjà sur la machine
    # -ErrorAction SilentlyContinue : si l'utilisateur n'existe pas,
    # la commande ne génère pas d'erreur, elle renvoie $null
    $existe = Get-LocalUser -Name $login -ErrorAction SilentlyContinue

    # Si la variable $existe n'est pas vide, l'utilisateur existe déjà
    if ($existe) {
        # J'affiche un message d'avertissement en jaune
        Write-Host "[$login] existe déjà — ignoré" -ForegroundColor Yellow
    }
    else {
        # L'utilisateur n'existe pas, je tente de le créer
        try {
            # Je crée l'utilisateur local
            # -Name : login du compte
            # -Password : mot de passe (SecureString)
            # -FullName : nom affiché
            # -Description : texte libre
            New-LocalUser -Name $login `
                          -Password $mdpDefaut `
                          -FullName $nomComplet `
                          -Description "Compte créé par script"

            # J'ajoute l'utilisateur au groupe spécifié dans le CSV
            Add-LocalGroupMember -Group $groupe -Member $login

            # J'affiche un message de succès en vert
            Write-Host "[$login] créé et ajouté au groupe $groupe" -ForegroundColor Green
        }
        catch {
            # Si une erreur survient, j'affiche le message d'erreur en rouge
            # $_.Exception.Message contient le détail de l'erreur
            Write-Host "[$login] ERREUR : $($_.Exception.Message)" -ForegroundColor Red
        }
    }
}

# J'affiche un message de fin de script
Write-Host "`nTraitement terminé." -ForegroundColor Cyan
```

**Le fichier CSV correspondant** (`utilisateurs.csv`) :

```
Nom;Prenom;Login;Groupe
Dupont;Jean;jdupont;Utilisateurs
Martin;Sophie;smartin;Administrateurs
Bernard;Luc;lbernard;Utilisateurs
```

---

## PARTIE 4 — Les bugs classiques (apprends à les repérer)

### Bug 1 : Guillemets manquants ou mauvais type

```powershell
# ❌ BUG : pas de guillemets autour du texte
$nom = Dupont
# ✅ FIX : toujours mettre des guillemets pour du texte
$nom = "Dupont"
```

### Bug 2 : Oubli du `$` devant une variable

```powershell
# ❌ BUG : "nom" sans le $ n'est pas une variable
Write-Host "Bonjour nom"
# ✅ FIX : ajouter le $ pour appeler la variable
Write-Host "Bonjour $nom"
```

### Bug 3 : Guillemets simples au lieu de doubles

```powershell
# ❌ BUG : les guillemets simples n'interprètent pas les variables
Write-Host 'Bonjour $nom'     # Affiche littéralement : Bonjour $nom
# ✅ FIX : utiliser des guillemets doubles
Write-Host "Bonjour $nom"     # Affiche : Bonjour Dupont
```

### Bug 4 : Mot de passe non sécurisé

```powershell
# ❌ BUG : mot de passe en texte brut → erreur
New-LocalUser -Name "test" -Password "P@ssw0rd!"
# ✅ FIX : convertir en SecureString
$mdp = ConvertTo-SecureString "P@ssw0rd!" -AsPlainText -Force
New-LocalUser -Name "test" -Password $mdp
```

### Bug 5 : Mauvais délimiteur CSV

```powershell
# ❌ BUG : le CSV utilise des ; mais on ne le précise pas
# Import-Csv utilise la virgule par défaut → colonnes cassées
$users = Import-Csv -Path "fichier.csv"
# ✅ FIX : préciser le délimiteur
$users = Import-Csv -Path "fichier.csv" -Delimiter ";"
```

### Bug 6 : Mauvais nom de groupe (FR vs EN)

```powershell
# ❌ BUG : on est sur un Windows français mais on utilise le nom anglais
Add-LocalGroupMember -Group "Users" -Member "jdupont"
# ✅ FIX : utiliser le nom français
Add-LocalGroupMember -Group "Utilisateurs" -Member "jdupont"
```

### Bug 7 : Propriété CSV inexistante (faute de frappe)

```powershell
# CSV contient : Nom;Prenom;Login
# ❌ BUG : "Name" n'existe pas dans le CSV, c'est "Nom"
$login = $user.Name
# ✅ FIX : utiliser le nom exact de la colonne du CSV
$login = $user.Nom
```

### Bug 8 : Accolades manquantes ou mal placées

```powershell
# ❌ BUG : accolade fermante oubliée
foreach ($user in $users) {
    New-LocalUser -Name $user.Login -Password $mdp
# il manque }

# ✅ FIX : toujours fermer les accolades
foreach ($user in $users) {
    New-LocalUser -Name $user.Login -Password $mdp
}
```

### Bug 9 : `-ErrorAction` mal écrit

```powershell
# ❌ BUG : ce n'est pas le bon nom
Get-LocalUser -Name "test" -ErrorAction Silently
# ✅ FIX : c'est SilentlyContinue (en un seul mot)
Get-LocalUser -Name "test" -ErrorAction SilentlyContinue
```

### Bug 10 : Oubli du backtick pour le multiligne

```powershell
# ❌ BUG : PowerShell pense que la commande s'arrête à la fin de la ligne
New-LocalUser -Name $login
              -Password $mdp
# ✅ FIX : utiliser le backtick ` en fin de ligne pour continuer
New-LocalUser -Name $login `
              -Password $mdp
```

---

## PARTIE 5 — Exercices d'entraînement

### Exercice 1 : Commente ce script

Ajoute un commentaire `#` à chaque ligne pour expliquer ce qu'elle fait :

```powershell
$fichier = "C:\users.csv"
$mdp = ConvertTo-SecureString "Azerty1!" -AsPlainText -Force
$liste = Import-Csv -Path $fichier -Delimiter ";"

foreach ($u in $liste) {
    $exist = Get-LocalUser -Name $u.Login -ErrorAction SilentlyContinue
    if (-not $exist) {
        New-LocalUser -Name $u.Login -Password $mdp -FullName "$($u.Prenom) $($u.Nom)"
        Add-LocalGroupMember -Group $u.Groupe -Member $u.Login
        Write-Host "$($u.Login) créé" -ForegroundColor Green
    } else {
        Write-Host "$($u.Login) existe déjà" -ForegroundColor Yellow
    }
}
```

> 💡 **Astuce** : `$($u.Prenom)` → les `$()` permettent d'insérer une propriété d'objet dans un texte entre guillemets doubles. Sans les parenthèses, PowerShell ne sait pas où finit la variable.

---

### Exercice 2 : Trouve les 5 bugs

Ce script contient **5 erreurs**. Trouve-les et corrige-les :

```powershell
$csv = Import-Csv -Path "C:\liste.csv"
$pass = "Motdepasse1!"

foreach ($u in $csv) {
    New-LocalUser -Name u.Login -Password $pass -FullName '$($u.Prenom) $($u.Nom)'
    Add-LocalGroupMember -Group "Users" -Member $u.login
    Write-Host "$u.Login créé"
}
```

<details>
<summary>👉 Clique ici pour voir les réponses</summary>

**Bug 1** : `$csv = Import-Csv -Path "C:\liste.csv"`
→ Pas de `-Delimiter ";"` si le CSV est en français (séparateur `;`)

**Bug 2** : `$pass = "Motdepasse1!"`
→ Le mot de passe est en texte brut, il faut un SecureString :
`$pass = ConvertTo-SecureString "Motdepasse1!" -AsPlainText -Force`

**Bug 3** : `-Name u.Login`
→ Il manque le `$` devant `u` : `-Name $u.Login`

**Bug 4** : `-FullName '$($u.Prenom) $($u.Nom)'`
→ Guillemets simples `' '` : les variables ne sont pas interprétées
→ Fix : `-FullName "$($u.Prenom) $($u.Nom)"`

**Bug 5** : `Write-Host "$u.Login créé"`
→ Il faut `$($u.Login)` avec les parenthèses pour accéder à la propriété d'un objet dans une chaîne
→ Fix : `Write-Host "$($u.Login) créé"`

**(Bonus)** : `-Group "Users"` → peut planter sur un Windows FR (devrait être `"Utilisateurs"`)

</details>

---

### Exercice 3 : Complète le script à trous

```powershell
# Je définis le chemin du fichier CSV
$chemin = ___________

# Je convertis le mot de passe en SecureString
$mdp = ___________ "Welcome1!" ___________ ___________

# J'importe le CSV avec le bon délimiteur
$users = ___________ -Path $chemin ___________

# Je boucle sur chaque utilisateur
___________ ($u ___________ $users) {

    # Je vérifie si le compte existe déjà
    $check = Get-LocalUser -Name ___________ -ErrorAction ___________

    if (-not $check) {
        # Je crée le compte
        ___________ -Name $u.Login -Password ___________ -FullName "$($u.Prenom) $($u.Nom)"

        # J'ajoute au groupe
        ___________ -Group $u.Groupe -Member ___________
    }
}
```

<details>
<summary>👉 Clique ici pour voir les réponses</summary>

```powershell
$chemin = "C:\Scripts\utilisateurs.csv"
$mdp = ConvertTo-SecureString "Welcome1!" -AsPlainText -Force
$users = Import-Csv -Path $chemin -Delimiter ";"
foreach ($u in $users) {
    $check = Get-LocalUser -Name $u.Login -ErrorAction SilentlyContinue
    if (-not $check) {
        New-LocalUser -Name $u.Login -Password $mdp -FullName "$($u.Prenom) $($u.Nom)"
        Add-LocalGroupMember -Group $u.Groupe -Member $u.Login
    }
}
```

</details>

---

## PARTIE 6 — Antisèche rapide (à imprimer pour réviser)

| Quoi | Commande | Explication rapide |
|------|----------|--------------------|
| Créer un utilisateur | `New-LocalUser -Name "x" -Password $mdp` | Crée un compte local |
| Supprimer un utilisateur | `Remove-LocalUser -Name "x"` | Supprime le compte |
| Lister les utilisateurs | `Get-LocalUser` | Affiche tous les comptes |
| Ajouter à un groupe | `Add-LocalGroupMember -Group "G" -Member "x"` | Met l'user dans le groupe |
| Mot de passe sécurisé | `ConvertTo-SecureString "txt" -AsPlainText -Force` | Convertit texte → SecureString |
| Importer un CSV | `Import-Csv -Path "f.csv" -Delimiter ";"` | Lit un fichier CSV |
| Boucle | `foreach ($x in $liste) { }` | Parcourt chaque élément |
| Condition | `if (condition) { } else { }` | Si… sinon… |
| Gestion erreur | `try { } catch { $_ }` | Tente… attrape l'erreur |
| Vérifier si existe | `Get-LocalUser -Name "x" -ErrorAction SilentlyContinue` | Pas d'erreur si absent |
| Afficher texte | `Write-Host "texte" -ForegroundColor Green` | Affiche en couleur |
| Variable dans texte | `"Bonjour $nom"` | Guillemets doubles = interprétation |
| Propriété dans texte | `"Login: $($u.Login)"` | `$()` pour les propriétés |
| Commentaire | `# commentaire` | Ligne ignorée |
| Bloc commentaire | `<# ... #>` | Plusieurs lignes ignorées |
| Continuation de ligne | `` ` `` (backtick) | La commande continue à la ligne suivante |

---

## PARTIE 7 — Ce que le correcteur attend dans tes commentaires

Quand on te demande de **commenter un script**, le correcteur veut :

1. **Un bloc d'en-tête** en haut du script (nom, auteur, date, description)
2. **Un commentaire par bloc logique** (pas forcément chaque ligne, mais chaque étape)
3. **Expliquer le POURQUOI**, pas juste le quoi :
   - ❌ `# ConvertTo-SecureString` (ça, le correcteur le voit déjà)
   - ✅ `# Je convertis le mot de passe en SecureString car PowerShell refuse le texte brut`
4. **Expliquer les paramètres importants** :
   - ✅ `# -AsPlainText -Force : nécessaire pour convertir depuis du texte en clair`
   - ✅ `# -ErrorAction SilentlyContinue : évite l'erreur si l'utilisateur n'existe pas`

---

*Bonne révision ! 💪*
