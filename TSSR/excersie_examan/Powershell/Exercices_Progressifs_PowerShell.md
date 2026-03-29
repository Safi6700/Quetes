# Exercices Progressifs PowerShell — Du Zéro au Script Utilisateurs

## Métadonnées
- **Objectif** : Maîtriser PowerShell pas à pas jusqu'à écrire un script de création d'utilisateurs
- **Méthode** : Chaque niveau introduit 1-2 concepts. Tu ne passes au suivant que quand tu as compris.
- **Liens** : [[Cours_Complet_PowerShell_TSSR]] | [[Guide_Scripts_Checkpoint2]]

---

# NIVEAU 1 — Découverte : Variables et Affichage

> **Concepts** : `Write-Host`, variables `$`, guillemets `" "` vs `' '`

---

### Exercice 1.1 — Mon premier script
Écris un script qui affiche "Bonjour, je suis [ton prénom] !" en vert.
?
```powershell
Write-Host "Bonjour, je suis Safi !" -ForegroundColor Green
```

---

### Exercice 1.2 — Variables simples
Crée 3 variables : `$prenom`, `$ville`, `$age`. Affiche la phrase :
"Je m'appelle [prenom], j'habite à [ville] et j'ai [age] ans."
?
```powershell
$prenom = "Safi"
$ville = "Strasbourg"
$age = 25

Write-Host "Je m'appelle $prenom, j'habite à $ville et j'ai $age ans."
```

---

### Exercice 1.3 — Guillemets doubles vs simples
Sans exécuter, devine ce que chaque ligne affiche. Puis vérifie.
```powershell
$animal = "Chat"
Write-Host "Mon animal : $animal"
Write-Host 'Mon animal : $animal'
Write-Host "Il y a $(2 + 3) animaux"
```
?
```
Mon animal : Chat          ← guillemets doubles = interpolation
Mon animal : $animal       ← guillemets simples = texte littéral
Il y a 5 animaux           ← $() évalue l'expression à l'intérieur
```

---

### Exercice 1.4 — Variables d'environnement
Affiche le nom de ta machine et le nom d'utilisateur connecté, chacun sur une ligne.
?
```powershell
Write-Host "Machine : $env:COMPUTERNAME"
Write-Host "Utilisateur : $env:USERNAME"
```

---

### Exercice 1.5 — Concaténation de variables
Crée `$prenom = "Anna"` et `$nom = "Dumas"`. Construis une variable `$login` qui vaut `"Anna.Dumas"`. Affiche-la.
?
```powershell
$prenom = "Anna"
$nom = "Dumas"
$login = "$prenom.$nom"

Write-Host "Login : $login"
# → Login : Anna.Dumas
```

---

# NIVEAU 2 — Conditions : If / Else

> **Concepts** : `If`, `Else`, `ElseIf`, opérateurs `-eq`, `-ne`, `-gt`, `-lt`

---

### Exercice 2.1 — Première condition
Crée une variable `$temperature = 35`. Si elle est supérieure à 30, affiche "Il fait chaud !" en rouge. Sinon, affiche "Température normale" en vert.
?
```powershell
$temperature = 35

If ($temperature -gt 30) {
    Write-Host "Il fait chaud !" -ForegroundColor Red
} Else {
    Write-Host "Température normale" -ForegroundColor Green
}
```

---

### Exercice 2.2 — Plusieurs conditions
Crée une variable `$note = 14`. Affiche :
- "Excellent" (vert) si ≥ 16
- "Bien" (jaune) si ≥ 12
- "Passable" (orange/DarkYellow) si ≥ 10
- "Insuffisant" (rouge) sinon
?
```powershell
$note = 14

If ($note -ge 16) {
    Write-Host "Excellent" -ForegroundColor Green
} ElseIf ($note -ge 12) {
    Write-Host "Bien" -ForegroundColor Yellow
} ElseIf ($note -ge 10) {
    Write-Host "Passable" -ForegroundColor DarkYellow
} Else {
    Write-Host "Insuffisant" -ForegroundColor Red
}
```

---

### Exercice 2.3 — Comparer des chaînes
Crée `$reponse = "oui"`. Teste si `$reponse` est égal à "oui". Si oui, affiche "Tu as dit oui". Sinon, affiche "Tu n'as pas dit oui".
?
```powershell
$reponse = "oui"

If ($reponse -eq "oui") {
    Write-Host "Tu as dit oui"
} Else {
    Write-Host "Tu n'as pas dit oui"
}
```
Note : `-eq` est **insensible à la casse** par défaut. "OUI", "Oui" et "oui" sont tous égaux.

---

### Exercice 2.4 — Test-Path
Vérifie si le fichier `C:\Windows\System32\drivers\etc\hosts` existe. Affiche "Fichier trouvé" ou "Fichier introuvable" selon le cas.
?
```powershell
If (Test-Path "C:\Windows\System32\drivers\etc\hosts") {
    Write-Host "Fichier trouvé" -ForegroundColor Green
} Else {
    Write-Host "Fichier introuvable" -ForegroundColor Red
}
```

---

### Exercice 2.5 — Combiner avec -and / -or
Crée `$age = 25` et `$permis = $true`. Affiche "Peut conduire" uniquement si l'âge est ≥ 18 ET que le permis est vrai.
?
```powershell
$age = 25
$permis = $true

If ($age -ge 18 -and $permis) {
    Write-Host "Peut conduire" -ForegroundColor Green
} Else {
    Write-Host "Ne peut pas conduire" -ForegroundColor Red
}
```

---

# NIVEAU 3 — Boucles

> **Concepts** : `ForEach`, `For`, tableaux `@()`

---

### Exercice 3.1 — Premier tableau et boucle
Crée un tableau de 4 prénoms. Affiche chaque prénom avec "Bonjour [prénom] !"
?
```powershell
$prenoms = @("Anna", "Matheo", "Anaïs", "Styrbjörn")

ForEach ($prenom in $prenoms) {
    Write-Host "Bonjour $prenom !"
}
# → Bonjour Anna !
# → Bonjour Matheo !
# → Bonjour Anaïs !
# → Bonjour Styrbjörn !
```

---

### Exercice 3.2 — Boucle avec condition
En reprenant le tableau précédent, affiche chaque prénom. Si le prénom est "Matheo", affiche-le en vert. Sinon, affiche-le en blanc.
?
```powershell
$prenoms = @("Anna", "Matheo", "Anaïs", "Styrbjörn")

ForEach ($prenom in $prenoms) {
    If ($prenom -eq "Matheo") {
        Write-Host "Bonjour $prenom !" -ForegroundColor Green
    } Else {
        Write-Host "Bonjour $prenom !" -ForegroundColor White
    }
}
```

---

### Exercice 3.3 — Boucle For avec compteur
Affiche "Utilisateur_1", "Utilisateur_2", ... jusqu'à "Utilisateur_5" en utilisant une boucle `For`.
?
```powershell
For ($i = 1; $i -le 5; $i++) {
    Write-Host "Utilisateur_$i"
}
# → Utilisateur_1
# → Utilisateur_2
# → Utilisateur_3
# → Utilisateur_4
# → Utilisateur_5
```

---

### Exercice 3.4 — Boucle avec compteur de résultats
Crée un tableau de notes : `@(15, 8, 12, 17, 6, 14)`. Parcours-le et compte combien de notes sont ≥ 10. À la fin, affiche "X élèves ont la moyenne".
?
```powershell
$notes = @(15, 8, 12, 17, 6, 14)
$compteur = 0

ForEach ($note in $notes) {
    If ($note -ge 10) {
        $compteur++
    }
}

Write-Host "$compteur élèves ont la moyenne"
# → 4 élèves ont la moyenne
```

---

### Exercice 3.5 — Boucle et construction de noms
Tu as 2 tableaux : `$prenoms = @("Anna", "Matheo")` et `$noms = @("Dumas", "Aubert")`. Parcours les 2 en parallèle (par index) et affiche "Prenom.Nom" pour chacun.
?
```powershell
$prenoms = @("Anna", "Matheo")
$noms = @("Dumas", "Aubert")

For ($i = 0; $i -lt $prenoms.Count; $i++) {
    $login = "$($prenoms[$i]).$($noms[$i])"
    Write-Host $login
}
# → Anna.Dumas
# → Matheo.Aubert
```
On utilise `$()` car on accède à un élément de tableau par index `[$i]` dans une chaîne.

---

# NIVEAU 4 — Fichiers

> **Concepts** : `Get-Content`, `Set-Content`, `Add-Content`, `New-Item`, `Test-Path`

---

### Exercice 4.1 — Créer et écrire dans un fichier
Crée un fichier `C:\Temp\test.txt` contenant la phrase "Ceci est mon premier fichier PowerShell".
?
```powershell
# Créer le dossier si nécessaire
If (-not (Test-Path "C:\Temp")) {
    New-Item -ItemType Directory -Path "C:\Temp" | Out-Null
}

# Écrire dans le fichier
Set-Content -Path "C:\Temp\test.txt" -Value "Ceci est mon premier fichier PowerShell"
```

---

### Exercice 4.2 — Ajouter des lignes
Ajoute 3 lignes dans le fichier `C:\Temp\test.txt` avec la date et l'heure à chaque ligne. Chaque ligne doit contenir : "Log : [date et heure]"
?
```powershell
For ($i = 1; $i -le 3; $i++) {
    $date = Get-Date -Format "dd/MM/yyyy HH:mm:ss"
    Add-Content -Path "C:\Temp\test.txt" -Value "Log : $date"
}
```
`Add-Content` ajoute à la fin sans effacer. `Set-Content` remplacerait tout.

---

### Exercice 4.3 — Lire un fichier
Lis le fichier créé à l'exercice précédent et affiche chaque ligne numérotée : "Ligne 1 : ...", "Ligne 2 : ...", etc.
?
```powershell
$lignes = Get-Content -Path "C:\Temp\test.txt"
$numero = 1

ForEach ($ligne in $lignes) {
    Write-Host "Ligne $numero : $ligne"
    $numero++
}
```

---

### Exercice 4.4 — Vérifier puis écrire
Avant d'écrire dans un fichier log, vérifie s'il existe. S'il n'existe pas, crée-le. Puis ajoute la ligne "Script démarré le [date]".
?
```powershell
$logFile = "C:\Temp\monlog.txt"

If (-not (Test-Path $logFile)) {
    New-Item -ItemType File -Path $logFile | Out-Null
    Write-Host "Fichier log créé" -ForegroundColor Green
}

$date = Get-Date -Format "dd/MM/yyyy-HH:mm:ss"
Add-Content -Path $logFile -Value "Script démarré le $date"
Write-Host "Log mis à jour"
```
C'est exactement ce que fait la fonction `Log` du Checkpoint 2 !

---

# NIVEAU 5 — Import-Csv : Lire des données structurées

> **Concepts** : `Import-Csv`, `-Delimiter`, propriétés d'objets, `Select-Object`

---

### Exercice 5.1 — Créer et lire un CSV simple
D'abord, crée ce fichier CSV avec PowerShell, puis lis-le avec `Import-Csv`.

Le fichier `C:\Temp\equipe.csv` doit contenir :
```
prenom;nom;role
Safi;Durand;Admin
Marie;Martin;User
Jean;Petit;User
```
?
```powershell
# Créer le CSV
$contenu = @(
    "prenom;nom;role",
    "Safi;Durand;Admin",
    "Marie;Martin;User",
    "Jean;Petit;User"
)
Set-Content -Path "C:\Temp\equipe.csv" -Value $contenu

# Lire le CSV
$equipe = Import-Csv -Path "C:\Temp\equipe.csv" -Delimiter ";"

# Afficher chaque personne
ForEach ($personne in $equipe) {
    Write-Host "$($personne.prenom) $($personne.nom) - $($personne.role)"
}
# → Safi Durand - Admin
# → Marie Martin - User
# → Jean Petit - User
```

---

### Exercice 5.2 — Filtrer les données d'un CSV
En reprenant le CSV de l'exercice 5.1, affiche uniquement les personnes dont le rôle est "User".
?
```powershell
$equipe = Import-Csv -Path "C:\Temp\equipe.csv" -Delimiter ";"

ForEach ($personne in $equipe) {
    If ($personne.role -eq "User") {
        Write-Host "$($personne.prenom) $($personne.nom)" -ForegroundColor Cyan
    }
}
# → Marie Martin
# → Jean Petit
```

---

### Exercice 5.3 — Select-Object : garder certaines colonnes
Importe le CSV mais ne garde que les colonnes `prenom` et `nom`. Affiche le résultat.
?
```powershell
$equipe = Import-Csv -Path "C:\Temp\equipe.csv" -Delimiter ";" | Select-Object prenom, nom

ForEach ($personne in $equipe) {
    Write-Host "$($personne.prenom) $($personne.nom)"
}
```
`Select-Object prenom, nom` supprime la colonne `role`. C'est utile quand un CSV a beaucoup de colonnes et qu'on n'en utilise que quelques-unes.

---

### Exercice 5.4 — Compter les résultats d'un CSV
Importe le CSV. Compte combien de personnes ont le rôle "User" et combien ont le rôle "Admin". Affiche le résumé.
?
```powershell
$equipe = Import-Csv -Path "C:\Temp\equipe.csv" -Delimiter ";"

$admins = 0
$users = 0

ForEach ($personne in $equipe) {
    If ($personne.role -eq "Admin") {
        $admins++
    } Else {
        $users++
    }
}

Write-Host "Admins : $admins"
Write-Host "Users  : $users"
Write-Host "Total  : $($admins + $users)"
```

---

### Exercice 5.5 — Construire un login depuis un CSV
Importe le CSV. Pour chaque personne, construis un login au format "Prenom.Nom" et affiche "Le login de [prenom] [nom] est : [login]".
?
```powershell
$equipe = Import-Csv -Path "C:\Temp\equipe.csv" -Delimiter ";"

ForEach ($personne in $equipe) {
    $login = "$($personne.prenom).$($personne.nom)"
    Write-Host "Le login de $($personne.prenom) $($personne.nom) est : $login"
}
# → Le login de Safi Durand est : Safi.Durand
# → Le login de Marie Martin est : Marie.Martin
# → Le login de Jean Petit est : Jean.Petit
```
C'est EXACTEMENT le mécanisme du script AddLocalUsers.ps1 !

---

# NIVEAU 6 — Fonctions

> **Concepts** : `function`, `param()`, `return`, `Import-Module`

---

### Exercice 6.1 — Première fonction
Crée une fonction `Dire-Bonjour` qui prend un paramètre `$Nom` et affiche "Bonjour [Nom] !". Appelle-la 3 fois avec des noms différents.
?
```powershell
function Dire-Bonjour {
    param([string]$Nom)
    Write-Host "Bonjour $Nom !"
}

Dire-Bonjour -Nom "Anna"
Dire-Bonjour -Nom "Matheo"
Dire-Bonjour -Nom "Safi"
```

---

### Exercice 6.2 — Fonction avec valeur par défaut
Crée une fonction `Afficher-Message` qui prend `$Message` et `$Couleur` (par défaut "White"). Affiche le message dans la couleur donnée.
?
```powershell
function Afficher-Message {
    param(
        [string]$Message,
        [string]$Couleur = "White"
    )
    Write-Host $Message -ForegroundColor $Couleur
}

Afficher-Message -Message "Succès !" -Couleur "Green"
Afficher-Message -Message "Attention !" -Couleur "Yellow"
Afficher-Message -Message "Info normale"                    # → White par défaut
```

---

### Exercice 6.3 — Fonction de log
Crée une fonction `Ecrire-Log` qui prend `$Chemin` et `$Message`. Elle doit :
1. Vérifier si le fichier existe, sinon le créer
2. Ajouter une ligne au format : "date;utilisateur;message"

Teste-la en l'appelant 3 fois.
?
```powershell
function Ecrire-Log {
    param(
        [string]$Chemin,
        [string]$Message
    )

    # Créer le fichier s'il n'existe pas
    If (-not (Test-Path $Chemin)) {
        New-Item -ItemType File -Path $Chemin | Out-Null
    }

    # Construire la ligne
    $date = Get-Date -Format "dd/MM/yyyy-HH:mm:ss"
    $user = $env:USERNAME
    $ligne = "$date;$user;$Message"

    # Écrire
    Add-Content -Path $Chemin -Value $ligne
}

# Test
Ecrire-Log -Chemin "C:\Temp\monlog.txt" -Message "Script démarré"
Ecrire-Log -Chemin "C:\Temp\monlog.txt" -Message "Traitement en cours"
Ecrire-Log -Chemin "C:\Temp\monlog.txt" -Message "Script terminé"

# Vérifier
Get-Content "C:\Temp\monlog.txt"
```
C'est la fonction `Log` de Functions.psm1 du Checkpoint 2, tu viens de la recréer !

---

### Exercice 6.4 — Fonction avec return
Crée une fonction `Tester-Existence` qui prend un `$Chemin` et retourne `$true` si le fichier existe, `$false` sinon. Utilise-la dans un `If`.
?
```powershell
function Tester-Existence {
    param([string]$Chemin)
    return (Test-Path $Chemin)
}

# Utilisation
If (Tester-Existence -Chemin "C:\Windows\System32") {
    Write-Host "Le chemin existe" -ForegroundColor Green
} Else {
    Write-Host "Le chemin n'existe pas" -ForegroundColor Red
}
```

---

# NIVEAU 7 — Gestion des utilisateurs locaux

> **Concepts** : `Get-LocalUser`, `New-LocalUser`, `ConvertTo-SecureString`, `Add-LocalGroupMember`
> ⚠️ Ces exercices nécessitent des **droits administrateur**

---

### Exercice 7.1 — Lister les utilisateurs
Affiche la liste de tous les utilisateurs locaux avec leur nom et leur statut (activé/désactivé).
?
```powershell
$users = Get-LocalUser

ForEach ($user in $users) {
    If ($user.Enabled) {
        Write-Host "$($user.Name) : ACTIF" -ForegroundColor Green
    } Else {
        Write-Host "$($user.Name) : DÉSACTIVÉ" -ForegroundColor Red
    }
}
```

---

### Exercice 7.2 — Vérifier si un utilisateur existe
Écris un code qui vérifie si l'utilisateur "TestUser" existe. Affiche le résultat avec une couleur.
?
```powershell
$nomUser = "TestUser"

If (Get-LocalUser -Name $nomUser -ErrorAction SilentlyContinue) {
    Write-Host "L'utilisateur $nomUser existe" -ForegroundColor Yellow
} Else {
    Write-Host "L'utilisateur $nomUser n'existe pas" -ForegroundColor Cyan
}
```
`-ErrorAction SilentlyContinue` empêche l'erreur rouge si l'utilisateur n'existe pas.

---

### Exercice 7.3 — Créer UN utilisateur
Crée un utilisateur "Test.User" avec le mot de passe "MonMdP123!", la description "Compte de test", et un mot de passe qui n'expire pas.
?
```powershell
# Étape 1 : Préparer le mot de passe (SecureString obligatoire)
$password = ConvertTo-SecureString "MonMdP123!" -AsPlainText -Force

# Étape 2 : Créer l'utilisateur
New-LocalUser -Name "Test.User" `
              -Password $password `
              -FullName "Test User" `
              -Description "Compte de test" `
              -PasswordNeverExpires

# Étape 3 : L'ajouter au groupe Utilisateurs
Add-LocalGroupMember -Group "Utilisateurs" -Member "Test.User"

Write-Host "Utilisateur Test.User créé !" -ForegroundColor Green
```

---

### Exercice 7.4 — Vérifier AVANT de créer
Combine les exercices 7.2 et 7.3 : vérifie d'abord si "Test.User" existe. S'il n'existe pas, crée-le (message vert). S'il existe, affiche un message rouge.
?
```powershell
$nomUser = "Test.User"
$password = ConvertTo-SecureString "MonMdP123!" -AsPlainText -Force

If (-not (Get-LocalUser -Name $nomUser -ErrorAction SilentlyContinue)) {
    # L'utilisateur n'existe PAS → on le crée
    New-LocalUser -Name $nomUser `
                  -Password $password `
                  -FullName "Test User" `
                  -Description "Compte de test" `
                  -PasswordNeverExpires

    Add-LocalGroupMember -Group "Utilisateurs" -Member $nomUser

    Write-Host "Le compte $nomUser a été créé avec le mot de passe MonMdP123!" -ForegroundColor Green
} Else {
    # L'utilisateur EXISTE DÉJÀ
    Write-Host "Le compte $nomUser existe déjà" -ForegroundColor Red
}
```
C'est le cœur de la boucle du script AddLocalUsers.ps1 !

---

### Exercice 7.5 — Supprimer un utilisateur (nettoyage)
Supprime l'utilisateur "Test.User" créé à l'exercice précédent. Vérifie d'abord qu'il existe.
?
```powershell
$nomUser = "Test.User"

If (Get-LocalUser -Name $nomUser -ErrorAction SilentlyContinue) {
    Remove-LocalUser -Name $nomUser
    Write-Host "Utilisateur $nomUser supprimé" -ForegroundColor Green
} Else {
    Write-Host "L'utilisateur $nomUser n'existe pas" -ForegroundColor Yellow
}
```

---

# NIVEAU 8 — Combiner CSV + Boucle + Utilisateurs

> **Concepts** : Tout ce qui précède combiné ensemble
> C'est le niveau du Checkpoint 2

---

### Exercice 8.1 — Lire un CSV et construire des logins
Crée ce fichier CSV `C:\Temp\users.csv` :
```
prenom;nom;description
Safi;Durand;Service Informatique
Marie;Martin;Service Communication
Jean;Petit;Service Comptabilite
```
Importe-le et affiche pour chaque personne : "Login : Prenom.Nom — Description"
?
```powershell
# Créer le CSV
$csv = @(
    "prenom;nom;description",
    "Safi;Durand;Service Informatique",
    "Marie;Martin;Service Communication",
    "Jean;Petit;Service Comptabilite"
)
Set-Content -Path "C:\Temp\users.csv" -Value $csv

# Lire et afficher
$users = Import-Csv -Path "C:\Temp\users.csv" -Delimiter ";"

ForEach ($user in $users) {
    $login = "$($user.prenom).$($user.nom)"
    Write-Host "Login : $login — $($user.description)"
}
```

---

### Exercice 8.2 — Simuler la création (sans vraiment créer)
Reprends l'exercice 8.1. Pour chaque utilisateur du CSV :
1. Construis le login
2. Vérifie s'il existe (il n'existera pas)
3. **Simule** la création : affiche "CREATION : [login] avec mdp Azerty1*" en vert
4. Si l'utilisateur existait, affiche "EXISTE DÉJÀ : [login]" en rouge
5. À la fin, affiche le total de créations et le total d'existants
?
```powershell
$users = Import-Csv -Path "C:\Temp\users.csv" -Delimiter ";"

$crees = 0
$existants = 0

ForEach ($user in $users) {
    $login = "$($user.prenom).$($user.nom)"

    If (-not (Get-LocalUser -Name $login -ErrorAction SilentlyContinue)) {
        # Simulation : juste un message, pas de vraie création
        Write-Host "CREATION : $login avec mdp Azerty1*" -ForegroundColor Green
        $crees++
    } Else {
        Write-Host "EXISTE DÉJÀ : $login" -ForegroundColor Red
        $existants++
    }
}

Write-Host ""
Write-Host "Résumé : $crees créé(s), $existants existant(s)"
```

---

### Exercice 8.3 — Créer les utilisateurs pour de vrai
Maintenant, remplace la simulation par la vraie création. Pour chaque utilisateur :
1. Construis le login Prenom.Nom
2. Vérifie l'existence
3. Crée l'utilisateur avec mdp "Azerty1*", description du CSV, mdp sans expiration
4. Ajoute au groupe "Utilisateurs"
5. Message vert avec login + mdp, ou message rouge si existant
?
```powershell
$users = Import-Csv -Path "C:\Temp\users.csv" -Delimiter ";"
$mdpTexte = "Azerty1*"
$password = ConvertTo-SecureString $mdpTexte -AsPlainText -Force

ForEach ($user in $users) {
    $login = "$($user.prenom).$($user.nom)"

    If (-not (Get-LocalUser -Name $login -ErrorAction SilentlyContinue)) {
        New-LocalUser -Name $login `
                      -Password $password `
                      -FullName "$($user.prenom) $($user.nom)" `
                      -Description $user.description `
                      -PasswordNeverExpires

        Add-LocalGroupMember -Group "Utilisateurs" -Member $login

        Write-Host "Le compte $login a été créé avec le mot de passe $mdpTexte" -ForegroundColor Green
    } Else {
        Write-Host "Le compte $login existe déjà" -ForegroundColor Red
    }
}
```

---

### Exercice 8.4 — Ajouter la journalisation (Log)
Reprends l'exercice 8.3 et ajoute une fonction `Log` dans le script. Journalise :
- Le début du script
- Chaque création réussie
- Chaque utilisateur existant
- La fin du script
?
```powershell
# ─── Fonction Log ────────────────────────
function Log {
    param([string]$FilePath, [string]$Content)

    If (-not (Test-Path $FilePath)) {
        New-Item -ItemType File -Path $FilePath | Out-Null
    }

    $date = Get-Date -Format "dd/MM/yyyy-HH:mm:ss"
    $user = [System.Security.Principal.WindowsIdentity]::GetCurrent().Name
    $logLine = "$date;$user;$Content"

    Add-Content -Path $FilePath -Value $logLine
}

# ─── Variables ───────────────────────────
$csvPath = "C:\Temp\users.csv"
$logPath = "C:\Temp\script_log.txt"
$mdpTexte = "Azerty1*"
$password = ConvertTo-SecureString $mdpTexte -AsPlainText -Force

# ─── Début ───────────────────────────────
Log -FilePath $logPath -Content "========== Début du script =========="

# ─── Traitement ──────────────────────────
$users = Import-Csv -Path $csvPath -Delimiter ";"

ForEach ($user in $users) {
    $login = "$($user.prenom).$($user.nom)"

    If (-not (Get-LocalUser -Name $login -ErrorAction SilentlyContinue)) {
        New-LocalUser -Name $login `
                      -Password $password `
                      -FullName "$($user.prenom) $($user.nom)" `
                      -Description $user.description `
                      -PasswordNeverExpires

        Add-LocalGroupMember -Group "Utilisateurs" -Member $login

        Write-Host "Le compte $login a été créé avec le mot de passe $mdpTexte" -ForegroundColor Green
        Log -FilePath $logPath -Content "Création réussie du compte $login"
    } Else {
        Write-Host "Le compte $login existe déjà" -ForegroundColor Red
        Log -FilePath $logPath -Content "Le compte $login existe déjà"
    }
}

# ─── Fin ─────────────────────────────────
Log -FilePath $logPath -Content "========== Fin du script =========="
```

---

### Exercice 8.5 — Le script COMPLET façon Checkpoint 2
C'est le boss final. Reproduis **l'architecture complète** du Checkpoint 2 :

1. **Un fichier `Functions.psm1`** avec la fonction Log
2. **Un fichier `Main.ps1`** qui lance le script principal avec élévation
3. **Un fichier `AddLocalUsers.ps1`** qui :
   - Importe le module Functions.psm1
   - Lit le CSV avec seulement les colonnes prenom, nom, description
   - Boucle sur chaque utilisateur
   - Vérifie existence → crée ou alerte
   - Journalise chaque action
   - Affiche le mot de passe dans le message de succès

**Essaie de l'écrire entièrement SEUL.**
Si tu y arrives, tu es prêt pour le Checkpoint.
?
```powershell
# ===== Functions.psm1 =====
function Log {
    param([string]$FilePath, [string]$Content)

    If (-not (Test-Path -Path $FilePath)) {
        New-Item -ItemType File -Path $FilePath | Out-Null
    }

    $Date = Get-Date -Format "dd/MM/yyyy-HH:mm:ss"
    $User = [System.Security.Principal.WindowsIdentity]::GetCurrent().Name
    $logLine = "$Date;$User;$Content"

    Add-Content -Path $FilePath -Value $logLine
}
```

```powershell
# ===== Main.ps1 =====
Start-Process -FilePath "powershell.exe" `
              -ArgumentList "C:\Scripts\AddLocalUsers.ps1" `
              -Verb RunAs `
              -WindowStyle Maximized
```

```powershell
# ===== AddLocalUsers.ps1 =====
$FilePath = "C:\Scripts\Users.csv"
$LogFile  = "C:\Scripts\log.txt"

Import-Module "C:\Scripts\Functions.psm1"

Log -FilePath $LogFile -Content "========== Début du script =========="

$Users = Import-Csv -Path $FilePath -Delimiter ";" | Select-Object prenom, nom, description

ForEach ($User in $Users) {
    $Name     = "$($User.prenom).$($User.nom)"
    $Password = ConvertTo-SecureString "Azerty1*" -AsPlainText -Force

    If (-not (Get-LocalUser -Name $Name -ErrorAction SilentlyContinue)) {
        New-LocalUser -Name $Name `
                      -Password $Password `
                      -FullName "$($User.prenom) $($User.nom)" `
                      -Description $User.description `
                      -PasswordNeverExpires

        Add-LocalGroupMember -Group "Utilisateurs" -Member $Name

        Write-Host "Le compte $Name a été créé avec le mot de passe Azerty1*" -ForegroundColor Green
        Log -FilePath $LogFile -Content "Création réussie du compte $Name"
    } Else {
        Write-Host "Le compte $Name existe déjà" -ForegroundColor Red
        Log -FilePath $LogFile -Content "Le compte $Name existe déjà - non créé"
    }
}

Log -FilePath $LogFile -Content "========== Fin du script =========="
Read-Host "Appuyez sur Entrée pour fermer"
```

---

# NIVEAU 9 — Exercices Bonus d'entraînement

> Pour aller plus loin et solidifier ta compréhension

---

### Exercice 9.1 — Script de nettoyage
Écris un script qui supprime tous les utilisateurs créés par le script précédent. Il doit relire le même CSV et supprimer chaque utilisateur s'il existe.
?
```powershell
$users = Import-Csv -Path "C:\Temp\users.csv" -Delimiter ";"

ForEach ($user in $users) {
    $login = "$($user.prenom).$($user.nom)"

    If (Get-LocalUser -Name $login -ErrorAction SilentlyContinue) {
        Remove-LocalUser -Name $login
        Write-Host "Supprimé : $login" -ForegroundColor Yellow
    } Else {
        Write-Host "Inexistant : $login" -ForegroundColor Gray
    }
}
```

---

### Exercice 9.2 — Demander le mot de passe à l'utilisateur
Modifie le script de création pour que le mot de passe ne soit pas codé en dur. Utilise `Read-Host` pour le demander à l'admin au début du script.
?
```powershell
$mdpTexte = Read-Host "Entrez le mot de passe pour les nouveaux comptes" -AsSecureString

# Si tu veux aussi l'afficher, utilise :
# $mdpTexte = Read-Host "Entrez le mot de passe"
# $password = ConvertTo-SecureString $mdpTexte -AsPlainText -Force

# Avec -AsSecureString, pas besoin de ConvertTo-SecureString :
$users = Import-Csv -Path "C:\Temp\users.csv" -Delimiter ";"

ForEach ($user in $users) {
    $login = "$($user.prenom).$($user.nom)"

    If (-not (Get-LocalUser -Name $login -ErrorAction SilentlyContinue)) {
        New-LocalUser -Name $login -Password $mdpTexte -PasswordNeverExpires
        Write-Host "Créé : $login" -ForegroundColor Green
    }
}
```

---

### Exercice 9.3 — Try/Catch pour gérer les erreurs
Reprends la création d'utilisateur et entoure-la d'un `Try/Catch`. Si la création échoue pour une raison quelconque, affiche l'erreur en rouge sans que le script plante.
?
```powershell
$users = Import-Csv -Path "C:\Temp\users.csv" -Delimiter ";"
$password = ConvertTo-SecureString "Azerty1*" -AsPlainText -Force

ForEach ($user in $users) {
    $login = "$($user.prenom).$($user.nom)"

    If (-not (Get-LocalUser -Name $login -ErrorAction SilentlyContinue)) {
        Try {
            New-LocalUser -Name $login -Password $password -Description $user.description -PasswordNeverExpires -ErrorAction Stop
            Add-LocalGroupMember -Group "Utilisateurs" -Member $login -ErrorAction Stop
            Write-Host "Créé : $login" -ForegroundColor Green
        }
        Catch {
            Write-Host "ERREUR pour $login : $($_.Exception.Message)" -ForegroundColor Red
        }
    } Else {
        Write-Host "Existe déjà : $login" -ForegroundColor Yellow
    }
}
```
`-ErrorAction Stop` transforme les erreurs non-terminales en erreurs terminales que `Catch` peut attraper.

---

# Progression résumée

| Niveau | Tu apprends | Tu sais faire après |
|---|---|---|
| **1** | Variables, `Write-Host`, `$()` | Stocker des données et afficher du texte |
| **2** | `If/Else`, opérateurs | Prendre des décisions dans un script |
| **3** | `ForEach`, `For`, tableaux | Répéter des actions automatiquement |
| **4** | Fichiers, `Add-Content`, `Test-Path` | Lire/écrire des fichiers, vérifier leur existence |
| **5** | `Import-Csv`, `Select-Object` | Lire des données structurées (listes d'utilisateurs) |
| **6** | Fonctions, `param()`, modules | Créer du code réutilisable |
| **7** | `New-LocalUser`, `SecureString` | Créer/vérifier des utilisateurs Windows |
| **8** | **Tout combiné** | Écrire le script complet du Checkpoint 2 |
| **9** | `Try/Catch`, `Read-Host` | Gérer les erreurs, rendre le script interactif |

**Conseil** : Fais les exercices dans l'ordre sur ta VM. Ne regarde la solution qu'après avoir essayé au moins 5 minutes. Si tu bloques, relis le chapitre correspondant dans [[Cours_Complet_PowerShell_TSSR]].
