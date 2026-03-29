# Cours Complet PowerShell — Du Zéro à l'Autonomie TSSR

## Métadonnées
- **Niveau** : Débutant → Intermédiaire
- **Objectif** : Maîtriser PowerShell pour l'administration système et les exercices TSSR
- **Prérequis** : Connaître les bases de Windows, avoir accès à une VM Windows
- **Liens** : [[Quiz_Scripts_PowerShell_Checkpoint2]] | [[Guide_Scripts_Checkpoint2]]

---

# CHAPITRE 1 — Découverte de PowerShell

## 1.1 C'est quoi PowerShell ?

PowerShell est un **shell** (interface en ligne de commande) ET un **langage de script** créé par Microsoft. Contrairement à CMD (l'invite de commande classique), PowerShell travaille avec des **objets**, pas juste du texte.

### La différence fondamentale avec CMD et Bash

| Aspect | CMD / Bash | PowerShell |
|---|---|---|
| Données | Texte brut (chaînes de caractères) | **Objets** avec des propriétés |
| Filtrage | Découper du texte (`grep`, `awk`, `cut`) | Accéder aux propriétés (`.Name`, `.Length`) |
| Philosophie | Tout est texte | Tout est objet |

**Exemple concret** : lister les fichiers d'un dossier

```bash
# En Bash : on obtient du TEXTE qu'il faut découper
ls -la
# -rw-r--r-- 1 user group 1234 Mar 8 14:30 fichier.txt
# Pour avoir juste la taille, il faut faire : awk '{print $5}'
```

```powershell
# En PowerShell : on obtient des OBJETS avec des propriétés
Get-ChildItem
# On accède directement à la propriété :
(Get-ChildItem fichier.txt).Length   # → 1234
```

## 1.2 Lancer PowerShell

Sur Windows, il y a plusieurs façons :

- **PowerShell** : Chercher "PowerShell" dans le menu Démarrer (version 5.1, intégrée à Windows)
- **PowerShell en admin** : Clic droit → "Exécuter en tant qu'administrateur"
- **PowerShell ISE** : Éditeur intégré avec coloration syntaxique (bon pour débuter)
- **Windows Terminal** : Interface moderne qui supporte PowerShell (recommandé)

Pour vérifier ta version :
```powershell
$PSVersionTable.PSVersion
```

## 1.3 Premiers pas — Commandes de base

### La syntaxe Verbe-Nom

Toutes les commandes PowerShell (appelées **cmdlets**, prononcé "command-lets") suivent le pattern **Verbe-Nom** :

```
Get-Process      → Verbe: Get      Nom: Process
Set-Location     → Verbe: Set      Nom: Location
New-Item         → Verbe: New      Nom: Item
Remove-Item      → Verbe: Remove   Nom: Item
```

### Les verbes les plus courants

| Verbe | Action | Exemple |
|---|---|---|
| `Get` | Récupérer / Lire | `Get-Process`, `Get-Service` |
| `Set` | Modifier | `Set-Location`, `Set-Content` |
| `New` | Créer | `New-Item`, `New-LocalUser` |
| `Remove` | Supprimer | `Remove-Item`, `Remove-LocalUser` |
| `Start` | Démarrer | `Start-Process`, `Start-Service` |
| `Stop` | Arrêter | `Stop-Process`, `Stop-Service` |
| `Test` | Vérifier | `Test-Path`, `Test-Connection` |
| `Import` | Importer | `Import-Csv`, `Import-Module` |
| `Export` | Exporter | `Export-Csv`, `Export-Clixml` |
| `Add` | Ajouter | `Add-Content`, `Add-LocalGroupMember` |
| `Write` | Écrire | `Write-Host`, `Write-Output` |

### L'aide intégrée — Ton meilleur ami

```powershell
# Aide complète sur une commande
Get-Help Get-Process -Full

# Exemples d'utilisation
Get-Help Get-Process -Examples

# Chercher une commande par mot-clé
Get-Command *process*
Get-Command *user*

# Voir toutes les propriétés d'un objet
Get-Process | Get-Member
```

**Astuce TSSR** : En examen, `Get-Command *motcle*` te permet de retrouver une commande que tu as oubliée.

---

# CHAPITRE 2 — Les Variables

## 2.1 Déclarer et utiliser une variable

En PowerShell, les variables commencent par `$` :

```powershell
# Déclaration simple
$prenom = "Safi"
$age = 25
$estAdmin = $true

# Afficher
Write-Host $prenom          # → Safi
Write-Host "Bonjour $prenom"  # → Bonjour Safi (interpolation)
Write-Host 'Bonjour $prenom'  # → Bonjour $prenom (pas d'interpolation avec ')
```

### Règle fondamentale : guillemets doubles vs simples

| Guillemets | Comportement | Exemple |
|---|---|---|
| `" "` (doubles) | **Interpolation** — les variables sont remplacées par leur valeur | `"Bonjour $prenom"` → `Bonjour Safi` |
| `' '` (simples) | **Littéral** — le texte est tel quel | `'Bonjour $prenom'` → `Bonjour $prenom` |

## 2.2 Types de données

PowerShell est **typé dynamiquement** (le type est détecté automatiquement) :

```powershell
$nombre = 42            # [int] — entier
$texte = "Bonjour"      # [string] — chaîne de caractères
$decimal = 3.14          # [double] — nombre à virgule
$booleen = $true         # [bool] — vrai ou faux
$tableau = @(1, 2, 3)    # [array] — tableau
$nul = $null             # Rien, vide, absence de valeur
```

Pour connaître le type d'une variable :
```powershell
$nombre = 42
$nombre.GetType().Name    # → Int32
```

Pour forcer un type (cast) :
```powershell
[string]$nombre = 42      # Force en string → "42"
[int]$texte = "123"        # Force en int → 123
```

## 2.3 Les variables automatiques

PowerShell a des variables prédéfinies très utiles :

| Variable | Contenu |
|---|---|
| `$true` / `$false` | Vrai / Faux |
| `$null` | Valeur nulle (rien) |
| `$_` | Objet courant dans le pipeline |
| `$?` | Succès de la dernière commande (`$true` ou `$false`) |
| `$Error` | Tableau des erreurs récentes |
| `$Home` | Dossier personnel de l'utilisateur |
| `$PSVersionTable` | Infos sur la version PowerShell |
| `$args` | Arguments passés à un script |
| `$env:COMPUTERNAME` | Nom de l'ordinateur |
| `$env:USERNAME` | Nom de l'utilisateur connecté |

```powershell
# Exemples
Write-Host "Machine : $env:COMPUTERNAME"   # → Machine : CLIENT1
Write-Host "User : $env:USERNAME"          # → User : Wilder
Write-Host "Home : $Home"                  # → Home : C:\Users\Wilder
```

## 2.4 Sous-expressions `$()`

Quand tu veux accéder à une **propriété d'objet** dans une chaîne, tu dois utiliser `$()` :

```powershell
$user = Get-LocalUser -Name "Administrator"

# INCORRECT — PowerShell ne comprend pas .Name dans la chaîne
Write-Host "Le compte est : $user.Name"
# → Le compte est : System.Object.Name  (MAUVAIS !)

# CORRECT — $() force l'évaluation de l'expression
Write-Host "Le compte est : $($user.Name)"
# → Le compte est : Administrator
```

**Règle** : Dès que tu as un point `.` ou un calcul dans une chaîne `" "`, utilise `$()`.

```powershell
# Autres exemples
Write-Host "Il y a $(Get-Process | Measure-Object | Select-Object -ExpandProperty Count) processus"
Write-Host "2 + 2 = $(2 + 2)"
```

---

# CHAPITRE 3 — Le Pipeline `|`

## 3.1 Concept du pipeline

Le pipeline (`|`) passe la **sortie** d'une commande comme **entrée** de la suivante. C'est la même idée qu'en Bash, SAUF qu'en PowerShell ce sont des **objets** qui circulent, pas du texte.

```powershell
# Commande1 produit des objets → Commande2 les filtre → Commande3 les formate
Get-Process | Where-Object {$_.CPU -gt 100} | Sort-Object CPU -Descending
```

Visualisation :
```
Get-Process
    │ (envoie des objets Process)
    ▼
Where-Object {$_.CPU -gt 100}
    │ (ne garde que ceux avec CPU > 100)
    ▼
Sort-Object CPU -Descending
    │ (trie par CPU décroissant)
    ▼
Affichage
```

## 3.2 Les cmdlets du pipeline les plus utilisées

### `Where-Object` — Filtrer

Garde uniquement les objets qui correspondent à une condition. L'objet courant est `$_`.

```powershell
# Services en cours d'exécution
Get-Service | Where-Object {$_.Status -eq "Running"}

# Processus utilisant plus de 100 MB de mémoire
Get-Process | Where-Object {$_.WorkingSet64 -gt 100MB}

# Fichiers .txt dans un dossier
Get-ChildItem | Where-Object {$_.Extension -eq ".txt"}

# Utilisateurs locaux activés
Get-LocalUser | Where-Object {$_.Enabled -eq $true}
```

### `Select-Object` — Choisir des colonnes ou sauter des lignes

```powershell
# Garder seulement certaines propriétés (colonnes)
Get-Process | Select-Object Name, CPU, Id

# Prendre les 5 premiers
Get-Process | Select-Object -First 5

# Sauter les 2 premiers
Get-Process | Select-Object -Skip 2

# Extraire une seule valeur (pas un objet)
Get-Process | Measure-Object | Select-Object -ExpandProperty Count
```

### `Sort-Object` — Trier

```powershell
# Trier par nom (croissant par défaut)
Get-Process | Sort-Object Name

# Trier par CPU décroissant
Get-Process | Sort-Object CPU -Descending

# Trier par plusieurs critères
Get-ChildItem | Sort-Object Extension, Name
```

### `ForEach-Object` — Exécuter une action sur chaque objet

```powershell
# Afficher juste les noms
Get-Service | ForEach-Object { Write-Host $_.Name }

# Arrêter tous les processus "notepad"
Get-Process notepad | ForEach-Object { Stop-Process -Id $_.Id }
```

### `Measure-Object` — Compter, moyenner, sommer

```powershell
# Compter le nombre de fichiers
Get-ChildItem | Measure-Object | Select-Object -ExpandProperty Count

# Somme des tailles de fichiers
Get-ChildItem | Measure-Object -Property Length -Sum
```

### `Format-Table` / `Format-List` — Mise en forme

```powershell
# Tableau (par défaut pour peu de colonnes)
Get-Process | Format-Table Name, CPU, Id -AutoSize

# Liste (pour voir toutes les propriétés)
Get-Process -Name "explorer" | Format-List *
```

## 3.3 Enchaîner les pipes — Exemples pratiques

```powershell
# Top 5 processus par mémoire
Get-Process | Sort-Object WorkingSet64 -Descending | Select-Object -First 5 Name, @{N="MB";E={[math]::Round($_.WorkingSet64/1MB,2)}}

# Services arrêtés dont le nom commence par "W"
Get-Service | Where-Object {$_.Status -eq "Stopped" -and $_.Name -like "W*"} | Select-Object Name, Status

# Fichiers modifiés aujourd'hui
Get-ChildItem -Recurse | Where-Object {$_.LastWriteTime -gt (Get-Date).Date} | Select-Object Name, LastWriteTime
```

---

# CHAPITRE 4 — Opérateurs

## 4.1 Opérateurs de comparaison

PowerShell utilise `-eq`, `-ne`, etc. au lieu de `==`, `!=` :

| Opérateur | Signification | Exemple |
|---|---|---|
| `-eq` | Égal (equal) | `$a -eq 5` |
| `-ne` | Pas égal (not equal) | `$a -ne 5` |
| `-gt` | Plus grand que (greater than) | `$a -gt 5` |
| `-lt` | Plus petit que (less than) | `$a -lt 5` |
| `-ge` | Plus grand ou égal (greater or equal) | `$a -ge 5` |
| `-le` | Plus petit ou égal (less or equal) | `$a -le 5` |
| `-like` | Correspond au pattern (wildcard `*`) | `$a -like "*.txt"` |
| `-notlike` | Ne correspond pas | `$a -notlike "*.exe"` |
| `-match` | Correspond à la regex | `$a -match "^[0-9]+"` |
| `-contains` | Le tableau contient | `@(1,2,3) -contains 2` |
| `-in` | L'élément est dans le tableau | `2 -in @(1,2,3)` |

```powershell
# Exemples
"Bonjour" -eq "bonjour"      # → True (insensible à la casse par défaut !)
"Bonjour" -ceq "bonjour"     # → False (-ceq = case-sensitive equal)
"fichier.txt" -like "*.txt"   # → True
"192.168.1.1" -match "\d+"    # → True
```

## 4.2 Opérateurs logiques

| Opérateur | Signification |
|---|---|
| `-and` | ET logique |
| `-or` | OU logique |
| `-not` ou `!` | NON logique |

```powershell
# Combiner des conditions
$age = 25
$estAdmin = $true

If ($age -ge 18 -and $estAdmin) {
    Write-Host "Adulte et admin"
}

# Utilisation de -not
If (-not (Test-Path "C:\Dossier")) {
    Write-Host "Le dossier n'existe pas"
}
```

## 4.3 Opérateurs d'affectation

```powershell
$a = 10       # Affectation
$a += 5       # $a = $a + 5 → 15
$a -= 3       # $a = $a - 3 → 12
$a *= 2       # $a = $a * 2 → 24
$a /= 4       # $a = $a / 4 → 6
$a++           # Incrémente de 1 → 7
$a--           # Décrémente de 1 → 6

# Pour les chaînes
$texte = "Bonjour"
$texte += " Safi"   # → "Bonjour Safi"
```

---

# CHAPITRE 5 — Structures de Contrôle

## 5.1 If / ElseIf / Else

```powershell
$note = 15

If ($note -ge 16) {
    Write-Host "Très bien" -ForegroundColor Green
}
ElseIf ($note -ge 12) {
    Write-Host "Bien" -ForegroundColor Yellow
}
ElseIf ($note -ge 10) {
    Write-Host "Passable" -ForegroundColor DarkYellow
}
Else {
    Write-Host "Insuffisant" -ForegroundColor Red
}
```

### Pattern courant : tester l'existence

```powershell
# Fichier existe ?
If (Test-Path "C:\Scripts\Users.csv") {
    Write-Host "Le fichier existe"
} Else {
    Write-Host "Fichier introuvable !"
}

# Utilisateur existe ?
If (Get-LocalUser -Name "Anna.Dumas" -ErrorAction SilentlyContinue) {
    Write-Host "L'utilisateur existe"
} Else {
    Write-Host "L'utilisateur n'existe pas"
}

# Variable est nulle ou vide ?
$nom = ""
If ([string]::IsNullOrEmpty($nom)) {
    Write-Host "Le nom est vide"
}
```

## 5.2 Switch

Alternative élégante à de multiples `If/ElseIf` :

```powershell
$service = "Communication"

Switch ($service) {
    "Communication" { Write-Host "Département Communication" }
    "Comptabilite"  { Write-Host "Département Comptabilité" }
    "RH"            { Write-Host "Ressources Humaines" }
    Default         { Write-Host "Service inconnu" }
}
```

## 5.3 Boucle ForEach

La boucle la plus utilisée en PowerShell. Il y a 2 syntaxes :

### Syntaxe 1 : ForEach statement (la plus courante)

```powershell
$fruits = @("Pomme", "Banane", "Orange")

ForEach ($fruit in $fruits) {
    Write-Host "J'aime les $fruit"
}
# → J'aime les Pomme
# → J'aime les Banane
# → J'aime les Orange
```

### Syntaxe 2 : ForEach-Object dans le pipeline

```powershell
@("Pomme", "Banane", "Orange") | ForEach-Object {
    Write-Host "J'aime les $_"
}
```

### Différence clé

| ForEach ($x in $collection) | $collection \| ForEach-Object |
|---|---|
| Charge TOUT en mémoire d'abord | Traite objet par objet (streaming) |
| Variable nommée `$x` | Variable automatique `$_` |
| Plus rapide pour petites collections | Plus économe en mémoire |
| Ne fonctionne PAS dans un pipe | Fonctionne DANS un pipe |

### Exemple pratique TSSR : parcourir les utilisateurs d'un CSV

```powershell
$Users = Import-Csv -Path "C:\Scripts\Users.csv" -Delimiter ";"

ForEach ($User in $Users) {
    $Nom = "$($User.prenom).$($User.nom)"
    Write-Host "Traitement de $Nom..."
}
```

## 5.4 Boucle For

Pour les boucles avec un compteur :

```powershell
# Compter de 1 à 10
For ($i = 1; $i -le 10; $i++) {
    Write-Host "Itération $i"
}

# Parcourir un tableau par index
$serveurs = @("SRV01", "SRV02", "SRV03")
For ($i = 0; $i -lt $serveurs.Count; $i++) {
    Write-Host "Serveur $($i + 1) : $($serveurs[$i])"
}
```

## 5.5 Boucle While et Do-While

```powershell
# While : teste AVANT d'exécuter
$compteur = 0
While ($compteur -lt 5) {
    Write-Host "Compteur : $compteur"
    $compteur++
}

# Do-While : exécute AU MOINS UNE FOIS, puis teste
Do {
    $reponse = Read-Host "Entrez 'oui' pour continuer"
} While ($reponse -ne "oui")
```

## 5.6 Try / Catch — Gérer les erreurs

```powershell
Try {
    # Code qui pourrait échouer
    $contenu = Get-Content "C:\fichier_inexistant.txt" -ErrorAction Stop
    Write-Host "Fichier lu avec succès"
}
Catch {
    # Code exécuté si erreur
    Write-Host "Erreur : $($_.Exception.Message)" -ForegroundColor Red
}
Finally {
    # Code exécuté TOUJOURS (erreur ou pas)
    Write-Host "Nettoyage terminé"
}
```

**Important** : `-ErrorAction Stop` est nécessaire pour que `Catch` intercepte les erreurs non-terminales.

---

# CHAPITRE 6 — Fichiers et Dossiers

## 6.1 Navigation

```powershell
# Afficher le dossier courant
Get-Location                  # Équivalent de pwd
# ou plus court :
$PWD

# Changer de dossier
Set-Location C:\Scripts       # Équivalent de cd
cd C:\Scripts                 # Alias (fonctionne aussi)

# Lister le contenu
Get-ChildItem                 # Équivalent de ls ou dir
Get-ChildItem -Recurse        # Récursif
Get-ChildItem -Filter "*.csv" # Filtrer par extension
```

## 6.2 Créer, copier, déplacer, supprimer

```powershell
# Créer un dossier
New-Item -ItemType Directory -Path "C:\MonDossier"

# Créer un fichier
New-Item -ItemType File -Path "C:\MonDossier\fichier.txt"

# Copier
Copy-Item "source.txt" "destination.txt"
Copy-Item "C:\Dossier1" "C:\Dossier2" -Recurse    # Dossier entier

# Déplacer
Move-Item "ancien.txt" "nouveau.txt"

# Supprimer
Remove-Item "fichier.txt"
Remove-Item "C:\Dossier" -Recurse -Force   # Dossier + contenu

# Vérifier existence
Test-Path "C:\Scripts\Users.csv"   # → $true ou $false
```

## 6.3 Lire et écrire dans des fichiers

```powershell
# LIRE un fichier
$contenu = Get-Content "C:\Scripts\fichier.txt"              # Tableau de lignes
$texte = Get-Content "C:\Scripts\fichier.txt" -Raw            # Texte brut entier
$ligne5 = (Get-Content "C:\Scripts\fichier.txt")[4]           # 5ème ligne (index 0)

# ÉCRIRE (remplace tout le contenu)
Set-Content -Path "C:\fichier.txt" -Value "Nouveau contenu"

# AJOUTER à la fin (append)
Add-Content -Path "C:\fichier.txt" -Value "Ligne ajoutée"

# ÉCRIRE plusieurs lignes
$lignes = @("Ligne 1", "Ligne 2", "Ligne 3")
Set-Content -Path "C:\fichier.txt" -Value $lignes
```

## 6.4 Import-Csv — Lire un CSV comme des objets

C'est LA commande essentielle pour les exercices TSSR :

```powershell
# Fichier Users.csv (séparateur point-virgule) :
# prenom;nom;service
# Anna;Dumas;Communication
# Matheo;Aubert;Communication

# Importer
$Users = Import-Csv -Path "C:\Scripts\Users.csv" -Delimiter ";"

# Chaque ligne devient un OBJET avec des propriétés
ForEach ($User in $Users) {
    Write-Host "$($User.prenom) $($User.nom) - $($User.service)"
}
# → Anna Dumas - Communication
# → Matheo Aubert - Communication

# Accéder à un utilisateur spécifique
$Users[0].prenom    # → Anna
$Users[1].nom       # → Aubert

# Combien d'utilisateurs ?
$Users.Count        # → 2
```

### Ce que fait Import-Csv en interne :

```
Fichier CSV                          Objets PowerShell
┌────────────────────────┐           ┌──────────────────────┐
│ prenom;nom;service     │  ──────►  │ (en-tête = propriétés)│
│ Anna;Dumas;Communication│  ──────►  │ .prenom = Anna       │
│ Matheo;Aubert;Communication│────►  │ .prenom = Matheo     │
└────────────────────────┘           └──────────────────────┘
```

La première ligne est TOUJOURS l'en-tête. Les lignes suivantes deviennent des objets.

---

# CHAPITRE 7 — Fonctions

## 7.1 Créer une fonction

```powershell
function Dire-Bonjour {
    Write-Host "Bonjour le monde !"
}

# Appel
Dire-Bonjour    # → Bonjour le monde !
```

## 7.2 Fonctions avec paramètres

```powershell
# Méthode 1 : param() — la plus propre
function Dire-Bonjour {
    param(
        [string]$Prenom,
        [string]$Nom
    )
    Write-Host "Bonjour $Prenom $Nom !"
}

Dire-Bonjour -Prenom "Safi" -Nom "Dupont"
# → Bonjour Safi Dupont !
```

### Paramètres avec valeurs par défaut

```powershell
function Creer-Utilisateur {
    param(
        [string]$Nom,
        [string]$MotDePasse = "Azerty1*",    # Valeur par défaut
        [switch]$Admin                        # Switch = booléen sans valeur
    )

    Write-Host "Création de $Nom avec le mdp $MotDePasse"
    If ($Admin) {
        Write-Host "$Nom est administrateur"
    }
}

Creer-Utilisateur -Nom "Safi"                  # MdP par défaut
Creer-Utilisateur -Nom "Safi" -MotDePasse "MonMdP123!" -Admin
```

### Le type [switch]

Un paramètre `[switch]` est un **booléen qui n'a pas besoin de valeur**. Sa présence = `$true`, son absence = `$false`.

```powershell
# -PasswordNeverExpires est un switch dans New-LocalUser
New-LocalUser -Name "Test" -Password $pwd -PasswordNeverExpires
# PasswordNeverExpires est $true car le switch est présent
```

## 7.3 Fonctions avec valeur de retour

```powershell
function Additionner {
    param([int]$a, [int]$b)
    return ($a + $b)
}

$resultat = Additionner -a 5 -b 3
Write-Host "Résultat : $resultat"   # → Résultat : 8
```

## 7.4 Les modules (.psm1)

Un module est un fichier qui contient des fonctions réutilisables :

```powershell
# ===== Fichier : MesFonctions.psm1 =====
function Log {
    param([string]$Message)
    $date = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    Add-Content -Path "C:\log.txt" -Value "$date - $Message"
}

function Test-Admin {
    $identity = [Security.Principal.WindowsIdentity]::GetCurrent()
    $principal = New-Object Security.Principal.WindowsPrincipal($identity)
    return $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
}
```

```powershell
# ===== Dans ton script principal =====
Import-Module "C:\Scripts\MesFonctions.psm1"

# Maintenant tu peux utiliser les fonctions
Log -Message "Script démarré"

If (Test-Admin) {
    Write-Host "Tu es admin !"
} Else {
    Write-Host "Tu n'es pas admin."
}
```

---

# CHAPITRE 8 — Gestion des Utilisateurs Locaux

C'est le cœur des exercices TSSR. Voici toutes les commandes à connaître.

## 8.1 Voir les utilisateurs et groupes

```powershell
# Lister tous les utilisateurs locaux
Get-LocalUser

# Détails d'un utilisateur spécifique
Get-LocalUser -Name "Administrator"

# Voir TOUTES les propriétés
Get-LocalUser -Name "Administrator" | Format-List *

# Lister tous les groupes locaux
Get-LocalGroup

# Voir les membres d'un groupe
Get-LocalGroupMember -Group "Administrateurs"
Get-LocalGroupMember -Group "Utilisateurs"
```

## 8.2 Créer un utilisateur

```powershell
# Étape 1 : Créer le mot de passe sécurisé
$Password = ConvertTo-SecureString "MonMdP123!" -AsPlainText -Force

# Étape 2 : Créer l'utilisateur
New-LocalUser -Name "Anna.Dumas" `
              -Password $Password `
              -FullName "Anna Dumas" `
              -Description "Service Communication" `
              -PasswordNeverExpires

# Étape 3 : Ajouter au groupe "Utilisateurs"
Add-LocalGroupMember -Group "Utilisateurs" -Member "Anna.Dumas"
```

### Paramètres de New-LocalUser

| Paramètre | Obligatoire | Rôle |
|---|---|---|
| `-Name` | Oui | Nom de connexion (login) |
| `-Password` | Oui* | Mot de passe (SecureString) |
| `-FullName` | Non | Nom complet affiché |
| `-Description` | Non | Description du compte |
| `-PasswordNeverExpires` | Non | Désactive l'expiration du mdp |
| `-AccountNeverExpires` | Non | Le compte n'expire jamais |
| `-UserMayNotChangePassword` | Non | Empêche l'utilisateur de changer son mdp |
| `-Disabled` | Non | Crée le compte désactivé |

## 8.3 Modifier un utilisateur

```powershell
# Changer la description
Set-LocalUser -Name "Anna.Dumas" -Description "Nouvelle description"

# Désactiver un compte
Disable-LocalUser -Name "Anna.Dumas"

# Réactiver
Enable-LocalUser -Name "Anna.Dumas"

# Changer le mot de passe
$NewPwd = ConvertTo-SecureString "NouveauMdP!" -AsPlainText -Force
Set-LocalUser -Name "Anna.Dumas" -Password $NewPwd
```

## 8.4 Supprimer un utilisateur

```powershell
Remove-LocalUser -Name "Anna.Dumas"
```

## 8.5 Groupes locaux

```powershell
# Créer un groupe
New-LocalGroup -Name "ServiceCom" -Description "Service Communication"

# Ajouter un membre
Add-LocalGroupMember -Group "ServiceCom" -Member "Anna.Dumas"

# Retirer un membre
Remove-LocalGroupMember -Group "ServiceCom" -Member "Anna.Dumas"

# Supprimer un groupe
Remove-LocalGroup -Name "ServiceCom"
```

### Noms des groupes locaux intégrés

| Windows FR | Windows EN | Rôle |
|---|---|---|
| Administrateurs | Administrators | Droits admin complets |
| Utilisateurs | Users | Droits standards |
| Invités | Guests | Droits minimaux |
| Utilisateurs du Bureau à distance | Remote Desktop Users | Connexion RDP |

**Piège classique** : Le nom dépend de la **langue de Windows** ! Sur un Windows FR, c'est "Utilisateurs" ; sur un Windows EN, c'est "Users".

---

# CHAPITRE 9 — Scripts PowerShell (.ps1)

## 9.1 Créer et exécuter un script

Un script PowerShell est un fichier texte avec l'extension `.ps1`.

```powershell
# ===== MonScript.ps1 =====
Write-Host "Bonjour depuis mon script !"
Write-Host "Nous sommes le $(Get-Date -Format 'dd/MM/yyyy')"
```

### Exécuter un script

```powershell
# Depuis PowerShell
.\MonScript.ps1                           # Depuis le dossier du script
C:\Scripts\MonScript.ps1                  # Chemin complet
& "C:\Scripts\Mon Script.ps1"             # Si le chemin contient des espaces
```

### Politique d'exécution

Par défaut, Windows peut bloquer l'exécution des scripts. Pour vérifier et modifier :

```powershell
# Voir la politique actuelle
Get-ExecutionPolicy

# Autoriser les scripts locaux (en tant qu'admin)
Set-ExecutionPolicy RemoteSigned

# Les politiques :
# Restricted     → Aucun script autorisé (défaut)
# RemoteSigned   → Scripts locaux OK, scripts téléchargés doivent être signés
# Unrestricted   → Tout est autorisé
# Bypass         → Aucune restriction
```

## 9.2 Script avec paramètres

```powershell
# ===== MonScript.ps1 =====
param(
    [string]$Nom = "Monde",
    [int]$Repetitions = 1
)

For ($i = 1; $i -le $Repetitions; $i++) {
    Write-Host "Bonjour $Nom ! (fois $i)"
}
```

```powershell
# Appel
.\MonScript.ps1                            # → Bonjour Monde ! (fois 1)
.\MonScript.ps1 -Nom "Safi" -Repetitions 3  # → 3 fois "Bonjour Safi !"
```

## 9.3 Structure d'un script professionnel

Voici le template à suivre pour tes exercices TSSR :

```powershell
# =============================================================================
# Nom du script : AddLocalUsers.ps1
# Auteur        : Safi
# Date          : 08/03/2026
# Description   : Crée des utilisateurs locaux depuis un fichier CSV
# =============================================================================

# ─── PARAMÈTRES ET CHEMINS ───────────────────────────────────────────────────
$CsvPath = "C:\Scripts\Users.csv"
$LogPath = "C:\Scripts\log.txt"

# ─── CHARGEMENT DES MODULES ─────────────────────────────────────────────────
Import-Module "C:\Scripts\Functions.psm1"

# ─── FONCTIONS LOCALES (si nécessaire) ──────────────────────────────────────
function Afficher-Resultat {
    param([string]$Message, [string]$Couleur = "White")
    Write-Host $Message -ForegroundColor $Couleur
}

# ─── SCRIPT PRINCIPAL ────────────────────────────────────────────────────────
Log -FilePath $LogPath -Content "Début du script"

# Vérifier que le fichier CSV existe
If (-not (Test-Path $CsvPath)) {
    Afficher-Resultat "ERREUR : Fichier $CsvPath introuvable !" "Red"
    Exit 1
}

# Importer les données
$Users = Import-Csv -Path $CsvPath -Delimiter ";"

# Traitement
ForEach ($User in $Users) {
    # ... logique ici ...
}

Log -FilePath $LogPath -Content "Fin du script"
Afficher-Resultat "Script terminé avec succès" "Green"

# ─── FIN DU SCRIPT ──────────────────────────────────────────────────────────
```

## 9.4 Élévation de privilèges (UAC)

Beaucoup d'opérations admin nécessitent des droits élevés. Deux approches :

### Approche 1 : Lancer PowerShell en admin directement

Clic droit sur PowerShell → "Exécuter en tant qu'administrateur"

### Approche 2 : Script de lancement (comme Main.ps1)

```powershell
# Main.ps1 — Lance un script avec élévation
Start-Process -FilePath "powershell.exe" `
              -ArgumentList "C:\Scripts\AddLocalUsers.ps1" `
              -Verb RunAs `
              -WindowStyle Maximized
```

### Vérifier si on est admin dans un script

```powershell
$isAdmin = ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)

If (-not $isAdmin) {
    Write-Host "Ce script nécessite des droits administrateur !" -ForegroundColor Red
    Exit 1
}
```

---

# CHAPITRE 10 — Commandes d'Administration Système

## 10.1 Services Windows

```powershell
# Lister tous les services
Get-Service

# État d'un service spécifique
Get-Service -Name "Spooler"     # Service d'impression

# Services en cours
Get-Service | Where-Object {$_.Status -eq "Running"}

# Démarrer / Arrêter / Redémarrer
Start-Service -Name "Spooler"
Stop-Service -Name "Spooler"
Restart-Service -Name "Spooler"
```

## 10.2 Processus

```powershell
# Lister les processus
Get-Process

# Détails d'un processus
Get-Process -Name "explorer" | Format-List *

# Tuer un processus
Stop-Process -Name "notepad"
Stop-Process -Id 1234
```

## 10.3 Réseau

```powershell
# Configuration IP (équivalent de ipconfig)
Get-NetIPAddress
Get-NetIPConfiguration

# Ping
Test-Connection -ComputerName "192.168.1.1" -Count 4

# DNS
Resolve-DnsName "google.com"

# Ports ouverts
Get-NetTCPConnection | Where-Object {$_.State -eq "Listen"}

# Partage réseau
New-SmbShare -Name "Scripts" -Path "C:\Scripts" -FullAccess "Administrator"
Get-SmbShare
```

## 10.4 Système

```powershell
# Infos système
Get-ComputerInfo | Select-Object CsName, WindowsVersion, OsArchitecture

# Nom de la machine
$env:COMPUTERNAME
Rename-Computer -NewName "CLIENT2" -Restart

# Espace disque
Get-PSDrive -PSProvider FileSystem

# Événements système (Event Log)
Get-EventLog -LogName System -Newest 10
Get-EventLog -LogName Application -EntryType Error -Newest 5
```

---

# CHAPITRE 11 — Exercices Pratiques Progressifs

## Exercice 1 — Variables et affichage (Facile)

**Objectif** : Créer un script qui affiche les infos système.

```
Consigne :
- Stocker le nom de la machine, le nom d'utilisateur et la date dans des variables
- Afficher le tout de manière formatée
```

**Solution** :
```powershell
$machine = $env:COMPUTERNAME
$user = $env:USERNAME
$date = Get-Date -Format "dd/MM/yyyy à HH:mm"

Write-Host "═══════════════════════════════"
Write-Host "  Rapport système"
Write-Host "═══════════════════════════════"
Write-Host "  Machine  : $machine"
Write-Host "  Utilisateur : $user"
Write-Host "  Date     : $date"
Write-Host "═══════════════════════════════"
```

## Exercice 2 — Conditions et fichiers (Moyen)

**Objectif** : Script qui vérifie si un dossier existe et le crée sinon.

```
Consigne :
- Vérifier si C:\BackupLogs existe
- Si oui → afficher "Le dossier existe déjà" en jaune
- Si non → le créer et afficher "Dossier créé" en vert
- Dans les 2 cas, créer un fichier rapport.txt dedans avec la date
```

**Solution** :
```powershell
$dossier = "C:\BackupLogs"

If (Test-Path $dossier) {
    Write-Host "Le dossier $dossier existe déjà" -ForegroundColor Yellow
} Else {
    New-Item -ItemType Directory -Path $dossier | Out-Null
    Write-Host "Dossier $dossier créé" -ForegroundColor Green
}

$date = Get-Date -Format "dd/MM/yyyy HH:mm:ss"
Add-Content -Path "$dossier\rapport.txt" -Value "Vérification effectuée le $date"
Write-Host "Rapport mis à jour"
```

## Exercice 3 — Boucle et CSV (Moyen)

**Objectif** : Lire un CSV et afficher un rapport.

Crée d'abord ce fichier `serveurs.csv` :
```csv
nom;ip;role;statut
SRV01;192.168.1.10;AD;actif
SRV02;192.168.1.11;DHCP;actif
SRV03;192.168.1.12;Fichiers;inactif
SRV04;192.168.1.13;Web;actif
```

```
Consigne :
- Importer le CSV
- Afficher chaque serveur avec son rôle
- Compter et afficher le nombre de serveurs actifs et inactifs
```

**Solution** :
```powershell
$serveurs = Import-Csv -Path "C:\Scripts\serveurs.csv" -Delimiter ";"

$actifs = 0
$inactifs = 0

ForEach ($srv in $serveurs) {
    If ($srv.statut -eq "actif") {
        Write-Host "$($srv.nom) ($($srv.ip)) - $($srv.role) : ACTIF" -ForegroundColor Green
        $actifs++
    } Else {
        Write-Host "$($srv.nom) ($($srv.ip)) - $($srv.role) : INACTIF" -ForegroundColor Red
        $inactifs++
    }
}

Write-Host "`nRésumé : $actifs actif(s), $inactifs inactif(s)"
```

## Exercice 4 — Création d'utilisateurs (Difficile — Niveau Checkpoint)

**Objectif** : Reproduire le script du Checkpoint 2 depuis zéro.

```
Consigne :
- Lire le fichier Users.csv (séparateur ;)
- Ne garder que prenom, nom et description
- Pour chaque utilisateur :
  - Construire le nom au format Prenom.Nom
  - Vérifier s'il existe déjà
  - Si non : le créer avec un mdp "Azerty1*", description, mdp sans expiration
  - L'ajouter au groupe "Utilisateurs"
  - Afficher un message vert avec le nom et le mdp
  - Si oui : afficher un message rouge
- Journaliser chaque action dans un fichier log
```

**Essaie de le faire SEUL avant de regarder la solution dans** [[Guide_Scripts_Checkpoint2]]

## Exercice 5 — Fonction personnalisée (Difficile)

**Objectif** : Créer ton propre module de fonctions.

```
Consigne :
Crée un fichier MonModule.psm1 avec 3 fonctions :
1. Test-Fichier : prend un chemin en paramètre, retourne $true/$false
2. Ecrire-Log : prend un message et un chemin, écrit la date + message dans le fichier
3. Creer-Utilisateur : prend nom, mdp, description, crée l'utilisateur et retourne $true/$false

Puis crée un script principal qui importe le module et utilise les 3 fonctions.
```

**Solution** :
```powershell
# ===== MonModule.psm1 =====

function Test-Fichier {
    param([string]$Chemin)
    return (Test-Path $Chemin)
}

function Ecrire-Log {
    param(
        [string]$Message,
        [string]$Chemin = "C:\Scripts\log.txt"
    )

    If (-not (Test-Path $Chemin)) {
        New-Item -ItemType File -Path $Chemin | Out-Null
    }

    $ligne = "$(Get-Date -Format 'dd/MM/yyyy-HH:mm:ss');$env:USERNAME;$Message"
    Add-Content -Path $Chemin -Value $ligne
}

function Creer-Utilisateur {
    param(
        [string]$Nom,
        [string]$MotDePasse,
        [string]$Description = ""
    )

    Try {
        $pwd = ConvertTo-SecureString $MotDePasse -AsPlainText -Force
        New-LocalUser -Name $Nom -Password $pwd -Description $Description -PasswordNeverExpires -ErrorAction Stop
        Add-LocalGroupMember -Group "Utilisateurs" -Member $Nom -ErrorAction Stop
        return $true
    }
    Catch {
        return $false
    }
}
```

```powershell
# ===== ScriptPrincipal.ps1 =====
Import-Module "C:\Scripts\MonModule.psm1"

$csvPath = "C:\Scripts\Users.csv"

If (-not (Test-Fichier -Chemin $csvPath)) {
    Write-Host "Fichier CSV introuvable !" -ForegroundColor Red
    Exit 1
}

Ecrire-Log -Message "Début du script"

$Users = Import-Csv -Path $csvPath -Delimiter ";" | Select-Object prenom, nom, description

ForEach ($User in $Users) {
    $nom = "$($User.prenom).$($User.nom)"

    If (Get-LocalUser -Name $nom -ErrorAction SilentlyContinue) {
        Write-Host "Le compte $nom existe déjà" -ForegroundColor Red
        Ecrire-Log -Message "Compte $nom existe déjà"
    } Else {
        $resultat = Creer-Utilisateur -Nom $nom -MotDePasse "Azerty1*" -Description $User.description
        If ($resultat) {
            Write-Host "Compte $nom créé avec succès" -ForegroundColor Green
            Ecrire-Log -Message "Compte $nom créé"
        } Else {
            Write-Host "Erreur création de $nom" -ForegroundColor Red
            Ecrire-Log -Message "ERREUR création $nom"
        }
    }
}

Ecrire-Log -Message "Fin du script"
```

---

# CHAPITRE 12 — Aide-mémoire Rapide

## Commandes les plus utiles pour TSSR

```powershell
# ─── FICHIERS ────────────────────────────────
Get-ChildItem          # ls / dir
Get-Content            # cat
Set-Content            # Écrire (écrase)
Add-Content            # Écrire (ajoute)
Test-Path              # Existe ?
New-Item               # Créer fichier/dossier
Copy-Item              # Copier
Move-Item              # Déplacer
Remove-Item            # Supprimer

# ─── UTILISATEURS LOCAUX ─────────────────────
Get-LocalUser          # Lister
New-LocalUser          # Créer
Set-LocalUser          # Modifier
Remove-LocalUser       # Supprimer
Enable-LocalUser       # Activer
Disable-LocalUser      # Désactiver

# ─── GROUPES LOCAUX ──────────────────────────
Get-LocalGroup         # Lister
Get-LocalGroupMember   # Voir les membres
Add-LocalGroupMember   # Ajouter un membre
Remove-LocalGroupMember # Retirer un membre

# ─── SERVICES ────────────────────────────────
Get-Service            # Lister
Start-Service          # Démarrer
Stop-Service           # Arrêter
Restart-Service        # Redémarrer

# ─── RÉSEAU ──────────────────────────────────
Get-NetIPAddress       # Config IP
Test-Connection        # Ping
Resolve-DnsName        # Résolution DNS
Get-NetTCPConnection   # Ports ouverts

# ─── SYSTÈME ─────────────────────────────────
Get-Process            # Processus
Get-ComputerInfo       # Infos machine
Get-EventLog           # Logs système
```

## Symboles et opérateurs importants

```
$variable          Variable
$_                 Objet courant dans le pipeline
$()                Sous-expression (dans les chaînes "")
@()                Tableau
@{}                Hashtable (dictionnaire)
|                  Pipeline
`                  Continuation de ligne (backtick)
#                  Commentaire
<# ... #>          Commentaire multiligne
-eq -ne -gt -lt    Comparaisons
-and -or -not      Logique
-like -match       Pattern matching
```
