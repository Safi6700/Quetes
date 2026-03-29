# Guide Complet - Scripts PowerShell Checkpoint 2

## Vue d'ensemble du système

Le Checkpoint 2 met en place un **système automatisé de création d'utilisateurs locaux** sur un poste Windows. Ce système est composé de **3 fichiers** qui travaillent ensemble :

```
C:\Scripts\
├── Main.ps1              → Point d'entrée (lance le script principal avec élévation)
├── AddLocalUsers.ps1     → Script principal (lit le CSV, crée les utilisateurs)
├── Functions.psm1        → Module PowerShell (contient la fonction Log)
└── Users.csv             → Fichier de données (liste des utilisateurs à créer)
```

---

## 1. Le fichier Users.csv — La source de données

```csv
prenom;nom;societe;fonction;service;description;mail;mobile;scriptPath;telephoneNumber
Anna;Dumas;sweetcakes;Directeur;Communication;Utilisateur du service Communication;Anna.Dumas@sweetcakes.net;06.28.37.25.55;logonscript.bat;01.59.82.30.21
Styrbjörn;Colin;sweetcakes;Assistant;Communication;Utilisateur du service Communication;Quentin.Colin@sweetcakes.net;06.52.65.51.47;logonscript.bat;01.51.91.31.24
Matheo;Aubert;sweetcakes;Assistant;Communication;Utilisateur du service Communication;Matheo.Aubert@sweetcakes.net;06.66.82.20.34;logonscript.bat;01.94.44.57.17
Anaïs;Bourgeois;sweetcakes;Directeur;Comptabilite;Utilisateur du service Comptabilite;Rose.Bourgeois@sweetcakes.net;06.17.31.57.26;logonscript.bat;01.31.25.95.11
```

### Points clés à comprendre :

- **Séparateur** : Le point-virgule `;` (pas la virgule). C'est typique des CSV français car la virgule est utilisée comme séparateur décimal en France.
- **Ligne 1** : C'est l'en-tête (header) — elle contient les noms des colonnes, PAS un utilisateur.
- **10 colonnes** : prenom, nom, societe, fonction, service, description, mail, mobile, scriptPath, telephoneNumber
- **Seules quelques colonnes sont utiles** pour la création d'un utilisateur local : `prenom`, `nom`, et `description`.

---

## 2. Main.ps1 — Le lanceur

### Rôle

Main.ps1 est le **point d'entrée**. Il est exécuté par un utilisateur standard (non-admin). Son seul rôle est de **relancer le vrai script avec des privilèges élevés** (en tant qu'administrateur).

### Version originale (BUGGÉE)

```powershell
# Q.2.2
Start-Process -FilePath "powershell.exe" -ArgumentList "C:\Temp\AddLocalUsers.ps1" -Verb RunAs -WindowStyle Maximized
```

### Bug Q.2.2 : Mauvais chemin

Le chemin pointe vers `C:\Temp\AddLocalUsers.ps1` alors que le script est dans `C:\Scripts\`.

### Explication de la commande `Start-Process`

| Paramètre | Valeur | Rôle |
|---|---|---|
| `-FilePath` | `"powershell.exe"` | Lance une nouvelle instance de PowerShell |
| `-ArgumentList` | `"C:\Scripts\AddLocalUsers.ps1"` | Le script à exécuter dans cette nouvelle instance |
| `-Verb RunAs` | — | **Déclenche l'élévation de privilèges** (UAC) — c'est la clé ! |
| `-WindowStyle Maximized` | — | La fenêtre s'ouvre en plein écran |

### Pourquoi `-Verb RunAs` ?

Quand un utilisateur standard (ex: "Wilder") exécute Main.ps1, il n'a PAS les droits admin. Or, créer des utilisateurs locaux nécessite des droits admin. `-Verb RunAs` déclenche la fenêtre UAC (User Account Control) qui demande les identifiants d'un compte administrateur. Le script AddLocalUsers.ps1 s'exécute alors **dans un contexte admin**.

### Version corrigée

```powershell
# Q.2.2 - Correction du chemin du script
# Le script AddLocalUsers.ps1 se trouve dans C:\Scripts et non C:\Temp
Start-Process -FilePath "powershell.exe" -ArgumentList "C:\Scripts\AddLocalUsers.ps1" -Verb RunAs -WindowStyle Maximized
```

---

## 3. Functions.psm1 — Le module de fonctions

### C'est quoi un fichier .psm1 ?

Un fichier `.psm1` est un **module PowerShell**. C'est une bibliothèque de fonctions réutilisables. On l'importe avec `Import-Module` et ensuite on peut appeler ses fonctions.

### Le code de la fonction Log

```powershell
function Log
{
    param([string]$FilePath,[string]$Content)

    # Vérifie si le fichier existe, sinon le crée
    If (-not (Test-Path -Path $FilePath))
    {
        New-Item -ItemType File -Path $FilePath | Out-Null
    }

    # Construit la ligne de journal
    $Date = Get-Date -Format "dd/MM/yyyy-HH:mm:ss"
    $User = [System.Security.Principal.WindowsIdentity]::GetCurrent().Name
    $logLine = "$Date;$User;$Content"

    # Ajoute la ligne de journal au fichier
    Add-Content -Path $FilePath -Value $logLine
}
```

### Décortiquons chaque partie :

**`param([string]$FilePath,[string]$Content)`**
- Déclare 2 paramètres d'entrée :
  - `$FilePath` : chemin du fichier de log (ex: `"C:\Scripts\log.txt"`)
  - `$Content` : le message à journaliser (ex: `"Utilisateur Anna.Dumas créé"`)

**`If (-not (Test-Path -Path $FilePath))`**
- `Test-Path` vérifie si le fichier existe → retourne `$true` ou `$false`
- `-not` inverse le résultat
- Donc : "si le fichier N'existe PAS"

**`New-Item -ItemType File -Path $FilePath | Out-Null`**
- Crée le fichier s'il n'existe pas
- `| Out-Null` supprime la sortie console (sinon PowerShell affiche les détails du fichier créé)

**`$Date = Get-Date -Format "dd/MM/yyyy-HH:mm:ss"`**
- Récupère la date/heure actuelle au format `08/03/2026-14:30:45`

**`$User = [System.Security.Principal.WindowsIdentity]::GetCurrent().Name`**
- Récupère le nom de l'utilisateur Windows qui exécute le script
- Retourne quelque chose comme `CLIENT1\Administrator`

**`$logLine = "$Date;$User;$Content"`**
- Construit la ligne de log avec le format : `08/03/2026-14:30:45;CLIENT1\Administrator;Utilisateur créé`

**`Add-Content -Path $FilePath -Value $logLine`**
- Ajoute (append) la ligne à la fin du fichier

### Comment l'utiliser dans un script

```powershell
# D'abord, importer le module
Import-Module "C:\Scripts\Functions.psm1"

# Ensuite, appeler la fonction
Log -FilePath "C:\Scripts\log.txt" -Content "Le compte Anna.Dumas a été créé"
```

---

## 4. AddLocalUsers.ps1 — Le script principal

### Version originale reconstituée (BUGGÉE)

Basé sur les questions Q.2.2 à Q.2.11 du checkpoint, voici le script avec TOUS les bugs :

```powershell
# Script de création d'utilisateurs locaux
# AddLocalUsers.ps1

# Chemin du fichier CSV
$FilePath = "C:\Scripts\Users.csv"

# Q.2.3 - BUG : Select-Object -Skip 1 saute le 1er utilisateur
# (le développeur pensait sauter l'en-tête, mais Import-Csv le gère déjà)
$Users = Import-Csv -Path $FilePath -Delimiter ";" | Select-Object -Skip 1

# Q.2.5 - BUG : Tous les champs sont importés, seuls prenom/nom/description sont utiles

ForEach ($User in $Users)
{
    $Name = "$($User.prenom).$($User.nom)"
    $Password = ConvertTo-SecureString "Azerty1*" -AsPlainText -Force

    If (-not (Get-LocalUser -Name $Name -ErrorAction SilentlyContinue))
    {
        # Q.2.4 - BUG : Le champ Description n'est pas utilisé dans New-LocalUser
        # Q.2.11 - BUG : Le mot de passe expire (pas de -PasswordNeverExpires)
        New-LocalUser -Name $Name -Password $Password -FullName "$($User.prenom) $($User.nom)"

        # Q.2.10 - BUG : Le nom du groupe est incorrect
        Add-LocalGroupMember -Group "Utilisateur" -Member $Name

        # Q.2.6 - BUG : Le mot de passe n'est pas affiché dans le message
        Write-Host "Le compte $Name a été crée" -ForegroundColor Green
    }
    # Q.2.9 - BUG : Pas de bloc Else, donc aucun message si l'utilisateur existe déjà
}

# Q.2.7 - BUG : La fonction Log de Functions.psm1 n'est pas intégrée
# Q.2.8 - BUG : Aucune journalisation des événements
```

---

### Version corrigée complète (TOUS les bugs fixés)

```powershell
# =============================================================================
# Script de création d'utilisateurs locaux
# AddLocalUsers.ps1 - Version corrigée
# =============================================================================

# Chemin du fichier CSV et du fichier de log
$FilePath = "C:\Scripts\Users.csv"
$LogFile  = "C:\Scripts\log.txt"

# Q.2.7 - Intégration de la fonction Log depuis le module Functions.psm1
# Méthode 1 : Import du module (recommandé)
Import-Module "C:\Scripts\Functions.psm1"
# Méthode 2 alternative : dot-sourcing (charger directement le code)
# . "C:\Scripts\Functions.psm1"

# Q.2.8 - Journalisation du début du script
Log -FilePath $LogFile -Content "========== Début du script AddLocalUsers =========="

# Q.2.3 - CORRECTION : Suppression du Select-Object -Skip 1
# Import-Csv gère automatiquement la première ligne comme en-tête
# Donc le -Skip 1 sautait en réalité le premier UTILISATEUR (Anna Dumas)
#
# Q.2.5 - CORRECTION : On sélectionne uniquement les champs nécessaires
# Au lieu d'importer les 10 colonnes, on ne garde que prenom, nom, description
$Users = Import-Csv -Path $FilePath -Delimiter ";" | Select-Object prenom, nom, description

ForEach ($User in $Users)
{
    # Construction du nom d'utilisateur au format Prenom.Nom
    $Name     = "$($User.prenom).$($User.nom)"
    $Password = ConvertTo-SecureString "Azerty1*" -AsPlainText -Force

    # Test d'existence de l'utilisateur
    If (-not (Get-LocalUser -Name $Name -ErrorAction SilentlyContinue))
    {
        # L'utilisateur n'existe pas → on le crée

        # Q.2.4  - CORRECTION : Ajout du paramètre -Description
        # Q.2.11 - CORRECTION : Ajout de -PasswordNeverExpires pour que le mdp n'expire pas
        New-LocalUser -Name $Name `
                      -Password $Password `
                      -FullName "$($User.prenom) $($User.nom)" `
                      -Description $User.description `
                      -PasswordNeverExpires

        # Q.2.10 - CORRECTION : Le nom du groupe local est "Utilisateurs" (avec un S)
        # Sur un Windows en anglais, ce serait "Users"
        Add-LocalGroupMember -Group "Utilisateurs" -Member $Name

        # Q.2.6 - CORRECTION : Le mot de passe est affiché dans le message
        Write-Host "Le compte $Name a été crée avec le mot de passe Azerty1*" -ForegroundColor Green

        # Q.2.8 - Journalisation de la création réussie
        Log -FilePath $LogFile -Content "Création réussie du compte $Name"
    }
    Else
    {
        # Q.2.9 - CORRECTION : Message en rouge si l'utilisateur existe déjà
        Write-Host "Le compte $Name existe déjà" -ForegroundColor Red

        # Q.2.8 - Journalisation de l'existence
        Log -FilePath $LogFile -Content "Le compte $Name existe déjà - non créé"
    }
}

# Q.2.8 - Journalisation de la fin du script
Log -FilePath $LogFile -Content "========== Fin du script AddLocalUsers =========="

# Pause pour lire les messages avant fermeture de la fenêtre
Read-Host "Appuyez sur Entrée pour fermer"
```

---

## 5. Analyse détaillée de chaque correction

### Q.2.2 — Correction du chemin dans Main.ps1

**Problème** : `C:\Temp\AddLocalUsers.ps1` → fichier introuvable.
**Correction** : `C:\Scripts\AddLocalUsers.ps1`
**Concept** : Un chemin incorrect = script jamais exécuté. PowerShell affiche une erreur "fichier introuvable".

### Q.2.3 — Premier utilisateur sauté

**Problème** : `Import-Csv ... | Select-Object -Skip 1`
**Explication** : `Import-Csv` est intelligent — il utilise **automatiquement** la première ligne du CSV comme noms de colonnes (headers). Donc quand il retourne les données, la première ligne de données EST déjà le premier utilisateur (Anna Dumas). En ajoutant `Select-Object -Skip 1`, on saute Anna Dumas et on commence à Styrbjörn Colin.
**Correction** : Supprimer le `| Select-Object -Skip 1`

### Q.2.4 — Champ Description non utilisé

**Problème** : `New-LocalUser` est appelé sans le paramètre `-Description`.
**Correction** : Ajouter `-Description $User.description`
**Concept** : Le champ description dans Windows permet d'identifier le rôle de l'utilisateur (ex: "Utilisateur du service Communication").

### Q.2.5 — Trop de champs importés

**Problème** : Les 10 colonnes du CSV sont chargées en mémoire alors que seules 3 sont utilisées.
**Correction** : `| Select-Object prenom, nom, description`
**Concept** : `Select-Object` filtre les propriétés d'un objet. C'est une bonne pratique de ne garder que ce qui est nécessaire (performance + lisibilité).

### Q.2.6 — Mot de passe non affiché

**Problème** : Le message de succès ne contient pas le mot de passe.
**Correction** : `Write-Host "Le compte $Name a été crée avec le mot de passe Azerty1*"`
**Concept** : En entreprise, l'administrateur doit communiquer le mot de passe initial à l'utilisateur.

### Q.2.7 — Intégration de la fonction Log

**Problème** : Le fichier Functions.psm1 contient une fonction Log qui n'est jamais chargée.
**Correction** : `Import-Module "C:\Scripts\Functions.psm1"`
**Concept** : Un module `.psm1` doit être importé avant que ses fonctions soient disponibles.

Il y a 2 méthodes pour charger du code PowerShell externe :

| Méthode | Syntaxe | Usage |
|---|---|---|
| `Import-Module` | `Import-Module "chemin.psm1"` | Pour les modules (.psm1) — méthode standard |
| Dot-sourcing | `. "chemin.ps1"` | Pour les scripts (.ps1) — exécute dans le scope actuel |

### Q.2.8 — Journalisation des événements

**Problème** : Aucun suivi des actions du script.
**Correction** : Appels à `Log` à des moments clés (début, création, erreur, fin).
**Concept** : En entreprise, la journalisation (logging) est essentielle pour tracer qui a fait quoi et quand. Le fichier de log produit ressemble à :

```
08/03/2026-14:30:45;CLIENT1\Administrator;========== Début du script AddLocalUsers ==========
08/03/2026-14:30:46;CLIENT1\Administrator;Création réussie du compte Anna.Dumas
08/03/2026-14:30:47;CLIENT1\Administrator;Création réussie du compte Styrbjörn.Colin
08/03/2026-14:30:47;CLIENT1\Administrator;Le compte Matheo.Aubert existe déjà - non créé
08/03/2026-14:30:48;CLIENT1\Administrator;Création réussie du compte Anaïs.Bourgeois
08/03/2026-14:30:48;CLIENT1\Administrator;========== Fin du script AddLocalUsers ==========
```

### Q.2.9 — Pas de message quand l'utilisateur existe

**Problème** : Le bloc `If` n'a pas de `Else`. Quand l'utilisateur existe, rien ne s'affiche.
**Correction** : Ajouter un `Else` avec un `Write-Host` en rouge.
**Concept** : L'utilisateur du script doit TOUJOURS savoir ce qui se passe. Pas de message = confusion.

### Q.2.10 — Ajout au groupe local échoue

**Problème** : `Add-LocalGroupMember -Group "Utilisateur"` — il manque le **S** à "Utilisateur**s**".
**Correction** : `-Group "Utilisateurs"` (sur Windows français) ou `-Group "Users"` (sur Windows anglais).
**Concept** : Les noms de groupes locaux sont traduits selon la langue de Windows. Un nom incorrect = erreur "groupe introuvable".

### Q.2.11 — Mot de passe qui expire

**Problème** : `New-LocalUser` est appelé sans `-PasswordNeverExpires`.
**Correction** : Ajouter le switch `-PasswordNeverExpires`
**Concept** : Par défaut, Windows impose une expiration du mot de passe (42 jours). Pour des comptes de service ou des situations spécifiques, on peut désactiver cette expiration.

---

## 6. Cmdlets PowerShell utilisés — Référence rapide

### `Import-Csv`
```powershell
Import-Csv -Path "fichier.csv" -Delimiter ";"
```
Lit un fichier CSV et retourne des **objets PowerShell** avec des propriétés correspondant aux colonnes.

### `Select-Object`
```powershell
$data | Select-Object prenom, nom     # Garde seulement ces colonnes
$data | Select-Object -Skip 1         # Saute le 1er élément
$data | Select-Object -First 3        # Prend les 3 premiers
```

### `ConvertTo-SecureString`
```powershell
ConvertTo-SecureString "motdepasse" -AsPlainText -Force
```
Convertit un texte en `SecureString` (format chiffré). Obligatoire pour les mots de passe dans PowerShell. `-Force` supprime l'avertissement de sécurité.

### `Get-LocalUser`
```powershell
Get-LocalUser -Name "Anna.Dumas" -ErrorAction SilentlyContinue
```
Vérifie si un utilisateur local existe. `-ErrorAction SilentlyContinue` empêche l'affichage d'une erreur si l'utilisateur n'existe pas (retourne `$null` silencieusement).

### `New-LocalUser`
```powershell
New-LocalUser -Name "Anna.Dumas" `
              -Password $SecurePassword `
              -FullName "Anna Dumas" `
              -Description "Service Communication" `
              -PasswordNeverExpires
```

### `Add-LocalGroupMember`
```powershell
Add-LocalGroupMember -Group "Utilisateurs" -Member "Anna.Dumas"
```
Ajoute un utilisateur à un groupe local.

### `Write-Host`
```powershell
Write-Host "Message vert" -ForegroundColor Green
Write-Host "Message rouge" -ForegroundColor Red
```
Affiche du texte coloré dans la console. Les couleurs disponibles : Black, Blue, Cyan, DarkBlue, DarkCyan, DarkGray, DarkGreen, DarkMagenta, DarkRed, DarkYellow, Gray, Green, Magenta, Red, White, Yellow.

### `Start-Process`
```powershell
Start-Process -FilePath "powershell.exe" -ArgumentList "script.ps1" -Verb RunAs
```
Lance un nouveau processus. `-Verb RunAs` = élévation de privilèges (UAC).

### `Import-Module`
```powershell
Import-Module "C:\Scripts\Functions.psm1"
```
Charge un module PowerShell et rend ses fonctions disponibles dans le script courant.

---

## 7. Flux d'exécution complet

```
Utilisateur "Wilder" (non-admin)
        │
        ▼
  Double-clic Main.ps1
        │
        ▼
  Start-Process avec -Verb RunAs
        │
        ▼
  ┌─────────────────────┐
  │   Fenêtre UAC       │
  │   "Voulez-vous      │
  │   autoriser cette    │
  │   application ?"     │
  │   → Entrer le mdp    │
  │     admin local      │
  └─────────────────────┘
        │
        ▼
  Nouvelle fenêtre PowerShell (admin)
  → Exécute AddLocalUsers.ps1
        │
        ▼
  Import-Module Functions.psm1
  → Fonction Log disponible
        │
        ▼
  Import-Csv Users.csv
  → 4 objets utilisateur chargés
        │
        ▼
  ┌─── ForEach ──────────────────────┐
  │  Pour chaque utilisateur :       │
  │    1. Construire le nom          │
  │    2. Vérifier s'il existe       │
  │    3. Si non → créer + log       │
  │    4. Si oui → message rouge     │
  └──────────────────────────────────┘
        │
        ▼
  Fin du script + Log
```
