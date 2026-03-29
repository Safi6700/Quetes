# Quiz — Cours Complet PowerShell TSSR

## Métadonnées
- **Sujet** : PowerShell — Fondamentaux à Administration Système
- **Nombre de questions** : 30
- **Difficulté** : Progressive (Facile → Difficile)
- **Lien** : [[Cours_Complet_PowerShell_TSSR]]

---

## BLOC 1 — Bases et Variables

### Q1 — Syntaxe Verbe-Nom
Quelle est la convention de nommage des commandes PowerShell ? Donne 3 exemples.
?
Les cmdlets PowerShell suivent le pattern **Verbe-Nom** : le verbe indique l'action, le nom indique la cible. Exemples : `Get-Process` (obtenir les processus), `New-Item` (créer un élément), `Remove-LocalUser` (supprimer un utilisateur local).

---

### Q2 — Guillemets doubles vs simples
Quelle est la sortie de chacune de ces lignes ?
```powershell
$nom = "Safi"
Write-Host "Bonjour $nom"
Write-Host 'Bonjour $nom'
```
?
- `"Bonjour $nom"` → **Bonjour Safi** (guillemets doubles = interpolation, la variable est remplacée)
- `'Bonjour $nom'` → **Bonjour $nom** (guillemets simples = littéral, le texte reste tel quel)

---

### Q3 — Sous-expression
Pourquoi ce code ne fonctionne PAS correctement ? Comment le corriger ?
```powershell
$user = Get-LocalUser -Name "Admin"
Write-Host "Le compte est $user.Name"
```
?
PowerShell ne résout pas `.Name` à l'intérieur d'une chaîne `" "` sans sous-expression. Il affiche l'objet entier suivi du texte littéral `.Name`. Correction : utiliser `$()` → `Write-Host "Le compte est $($user.Name)"`

---

### Q4 — Variables automatiques
À quoi servent les variables `$_`, `$null`, `$true` et `$?` ?
?
- `$_` : l'objet **courant** dans le pipeline (dans `ForEach-Object`, `Where-Object`)
- `$null` : représente **l'absence de valeur** (rien, vide)
- `$true` / `$false` : les valeurs **booléennes** (vrai/faux)
- `$?` : contient `$true` si la **dernière commande a réussi**, `$false` sinon

---

### Q5 — Types de données
Quel est le type de chaque variable ?
```powershell
$a = 42
$b = "Bonjour"
$c = $true
$d = @(1, 2, 3)
```
?
- `$a` → `[int]` (Int32) — entier
- `$b` → `[string]` — chaîne de caractères
- `$c` → `[bool]` — booléen
- `$d` → `[array]` (Object[]) — tableau

---

## BLOC 2 — Pipeline et Filtrage

### Q6 — Le pipeline
Que fait le symbole `|` en PowerShell ? Quelle différence avec Bash ?
?
Le `|` (pipeline) passe la **sortie** d'une commande comme **entrée** de la suivante. La différence avec Bash : en PowerShell, ce sont des **objets** qui circulent dans le pipeline, pas du texte brut. On peut donc accéder directement aux propriétés sans découper du texte.

---

### Q7 — Where-Object
Écris la commande pour lister uniquement les services Windows qui sont arrêtés.
?
```powershell
Get-Service | Where-Object {$_.Status -eq "Stopped"}
```
`Where-Object` filtre les objets selon une condition. `$_` représente chaque service dans le pipeline, et `.Status` est sa propriété d'état.

---

### Q8 — Select-Object
Quelle est la différence entre ces 2 commandes ?
```powershell
Import-Csv "f.csv" | Select-Object Name, Email
Import-Csv "f.csv" | Select-Object -Skip 1
```
?
- La première **filtre les colonnes** : ne garde que les propriétés `Name` et `Email` de chaque objet
- La deuxième **saute la première ligne de données** et garde tout le reste avec toutes les colonnes

---

### Q9 — Sort-Object
Écris la commande pour trier les processus par utilisation CPU décroissante et ne garder que les 5 premiers.
?
```powershell
Get-Process | Sort-Object CPU -Descending | Select-Object -First 5
```
`Sort-Object` trie les objets, `-Descending` inverse l'ordre, et `Select-Object -First 5` ne garde que les 5 premiers résultats.

---

### Q10 — Measure-Object
Comment compter le nombre de fichiers `.txt` dans un dossier ?
?
```powershell
Get-ChildItem -Filter "*.txt" | Measure-Object | Select-Object -ExpandProperty Count
```
`Measure-Object` compte les objets, et `-ExpandProperty Count` extrait directement le nombre au lieu de retourner un objet Measure.

---

## BLOC 3 — Opérateurs et Conditions

### Q11 — Opérateurs de comparaison
Pourquoi PowerShell utilise `-eq` au lieu de `==` ? Cite 4 opérateurs de comparaison.
?
PowerShell utilise `-eq` car `=` est réservé à l'**affectation** et `>` / `<` sont utilisés pour la **redirection**. Les 4 principaux : `-eq` (égal), `-ne` (pas égal), `-gt` (plus grand), `-lt` (plus petit). Bonus : `-ge` (≥), `-le` (≤), `-like` (wildcard), `-match` (regex).

---

### Q12 — Sensibilité à la casse
Quel est le résultat de `"HELLO" -eq "hello"` ? Comment forcer la sensibilité à la casse ?
?
Le résultat est `$true` car les opérateurs PowerShell sont **insensibles à la casse par défaut**. Pour forcer la sensibilité, on préfixe avec `c` : `-ceq` → `"HELLO" -ceq "hello"` retourne `$false`.

---

### Q13 — Opérateur -like
Que retourne `"rapport_2026.pdf" -like "*.pdf"` et pourquoi ?
?
Retourne `$true`. L'opérateur `-like` utilise des **wildcards** : `*` correspond à n'importe quelle séquence de caractères. Donc `"*.pdf"` signifie "n'importe quoi qui se termine par .pdf".

---

### Q14 — If / ElseIf / Else
Écris un bloc conditionnel qui teste si une variable `$score` est ≥ 80 (affiche "Excellent"), ≥ 50 (affiche "Passable"), ou en-dessous (affiche "Insuffisant").
?
```powershell
If ($score -ge 80) {
    Write-Host "Excellent" -ForegroundColor Green
}
ElseIf ($score -ge 50) {
    Write-Host "Passable" -ForegroundColor Yellow
}
Else {
    Write-Host "Insuffisant" -ForegroundColor Red
}
```

---

### Q15 — Test-Path dans un If
Écris le code pour vérifier si `C:\Scripts\Users.csv` existe. Si oui, afficher "OK". Si non, afficher "Fichier manquant" et quitter le script.
?
```powershell
If (Test-Path "C:\Scripts\Users.csv") {
    Write-Host "OK" -ForegroundColor Green
} Else {
    Write-Host "Fichier manquant" -ForegroundColor Red
    Exit 1
}
```
`Test-Path` retourne `$true` si le chemin existe. `Exit 1` termine le script avec un code d'erreur.

---

## BLOC 4 — Boucles

### Q16 — ForEach statement vs ForEach-Object
Quelle est la différence entre ces 2 syntaxes ? Quand utiliser l'une ou l'autre ?
```powershell
ForEach ($item in $collection) { ... }
$collection | ForEach-Object { ... }
```
?
- `ForEach ($item in $collection)` : **instruction** — charge tout en mémoire, utilise une variable nommée `$item`, plus rapide pour petites collections, ne fonctionne PAS dans un pipe
- `$collection | ForEach-Object` : **cmdlet** dans le pipeline — traite objet par objet en streaming, utilise `$_`, plus économe en mémoire pour grandes collections

---

### Q17 — Boucle For
Écris une boucle For qui affiche les nombres de 1 à 10.
?
```powershell
For ($i = 1; $i -le 10; $i++) {
    Write-Host $i
}
```
Les 3 parties : initialisation (`$i = 1`), condition (`$i -le 10`), incrémentation (`$i++`).

---

### Q18 — Boucle et CSV
Tu as un CSV avec des colonnes `prenom` et `nom`. Écris le code pour afficher chaque nom complet au format "Prenom NOM".
?
```powershell
$users = Import-Csv -Path "fichier.csv" -Delimiter ";"
ForEach ($user in $users) {
    Write-Host "$($user.prenom) $($user.nom.ToUpper())"
}
```
`.ToUpper()` convertit le nom en majuscules. On utilise `$()` car on accède à des propriétés d'objet dans une chaîne.

---

## BLOC 5 — Fichiers et CSV

### Q19 — Import-Csv
Que fait `Import-Csv` avec la première ligne du fichier ? Pourquoi `| Select-Object -Skip 1` est une erreur courante ?
?
`Import-Csv` utilise **automatiquement** la première ligne comme **noms de colonnes** (headers). Les données retournées commencent donc au premier enregistrement réel. Ajouter `Select-Object -Skip 1` saute le **premier utilisateur**, pas l'en-tête qui est déjà traitée.

---

### Q20 — Délimiteur
Pourquoi les CSV français utilisent souvent `;` au lieu de `,` ? Comment le spécifier dans `Import-Csv` ?
?
En France, la **virgule** est le séparateur décimal (ex: 3,14€), donc elle ne peut pas servir de séparateur de colonnes. On utilise le **point-virgule** à la place. On le spécifie avec `-Delimiter ";"` dans `Import-Csv`.

---

### Q21 — Get-Content vs Import-Csv
Quelle est la différence fondamentale entre `Get-Content "f.csv"` et `Import-Csv "f.csv"` ?
?
- `Get-Content` retourne un **tableau de chaînes** (chaque ligne = une string brute). Il ne comprend pas la structure CSV.
- `Import-Csv` retourne des **objets structurés** avec des propriétés nommées d'après les colonnes. On peut accéder à `$objet.prenom` directement.

---

### Q22 — Add-Content vs Set-Content
Quelle commande utiliser pour un fichier de log et pourquoi ?
?
**`Add-Content`** car elle **ajoute** (append) à la fin du fichier sans effacer le contenu existant. `Set-Content` **remplace** tout le contenu, ce qui écraserait les logs précédents à chaque écriture.

---

## BLOC 6 — Fonctions et Modules

### Q23 — Déclarer une fonction avec param
Écris une fonction `Saluer` qui prend un paramètre `$Nom` (string) avec la valeur par défaut "Monde".
?
```powershell
function Saluer {
    param(
        [string]$Nom = "Monde"
    )
    Write-Host "Bonjour $Nom !"
}
Saluer              # → Bonjour Monde !
Saluer -Nom "Safi"  # → Bonjour Safi !
```

---

### Q24 — Type [switch]
C'est quoi un paramètre de type `[switch]` ? Donne un exemple concret en PowerShell natif.
?
Un `[switch]` est un paramètre **booléen sans valeur**. Sa simple **présence** dans l'appel = `$true`, son **absence** = `$false`. Exemple natif : `-PasswordNeverExpires` dans `New-LocalUser`. On ne lui donne pas de valeur, on le met ou on ne le met pas.

---

### Q25 — Import-Module
Quelle est la différence entre `Import-Module "fichier.psm1"` et `. "fichier.ps1"` (dot-sourcing) ?
?
- `Import-Module` : méthode **standard** pour les modules `.psm1`. Charge les fonctions exportées dans un scope contrôlé.
- `. "fichier.ps1"` (dot-sourcing) : exécute le fichier dans le **scope actuel**. Tout (variables, fonctions) devient directement accessible comme si le code était écrit dans le script courant.

---

## BLOC 7 — Administration Système

### Q26 — ConvertTo-SecureString
Pourquoi ne peut-on pas simplement écrire `-Password "Azerty1*"` dans `New-LocalUser` ?
?
`New-LocalUser` exige un mot de passe de type **SecureString** (chiffré en mémoire) pour des raisons de sécurité. Il faut d'abord convertir le texte : `ConvertTo-SecureString "Azerty1*" -AsPlainText -Force`. `-AsPlainText` autorise la conversion depuis du texte clair, `-Force` supprime l'avertissement.

---

### Q27 — ErrorAction SilentlyContinue
Que se passe-t-il si on exécute `Get-LocalUser -Name "Inexistant"` SANS `-ErrorAction SilentlyContinue` ?
?
PowerShell affiche un **message d'erreur en rouge** dans la console car l'utilisateur n'existe pas. Avec `-ErrorAction SilentlyContinue`, l'erreur est supprimée et la commande retourne `$null` silencieusement, ce qui permet de tester le résultat dans un `If` sans pollution visuelle.

---

### Q28 — Groupes locaux FR vs EN
Sur un Windows en français, le groupe des utilisateurs standard s'appelle "Utilisateurs". Comment s'appelle-t-il sur un Windows en anglais ? Pourquoi c'est un piège fréquent ?
?
Sur Windows anglais : **"Users"**. C'est un piège car les noms de groupes locaux sont **traduits selon la langue de Windows**. Si tu écris `"Utilisateurs"` sur un Windows EN ou `"Users"` sur un Windows FR, PowerShell retourne "groupe introuvable".

---

### Q29 — Start-Process -Verb RunAs
Un utilisateur standard exécute Main.ps1 qui contient `Start-Process ... -Verb RunAs`. Décris ce qui se passe étape par étape.
?
1. L'utilisateur standard lance Main.ps1 → il s'exécute avec ses droits limités
2. `Start-Process -Verb RunAs` déclenche la fenêtre **UAC** (User Account Control)
3. L'UAC demande les **identifiants d'un compte administrateur**
4. Si les identifiants sont corrects, une **nouvelle fenêtre PowerShell** s'ouvre
5. Cette nouvelle fenêtre a des **droits admin** et exécute le script cible
6. Les 2 fenêtres sont des processus **indépendants** (l'original reste ouvert)

---

### Q30 — Script complet : diagnostic
Ce script contient 4 erreurs. Trouve-les toutes.
```powershell
$Users = Import-Csv -Path "C:\Users.csv" -Delimiter ","
ForEach ($User in $Users) {
    $Name = "$User.prenom.$User.nom"
    $Pwd = "Azerty1*"
    If (-not (Get-LocalUser -Name $Name)) {
        New-LocalUser -Name $Name -Password $Pwd -Description $User.description
    }
}
```
?
**Erreur 1** : Le délimiteur est probablement `;` et non `,` (CSV français).
**Erreur 2** : `$User.prenom` dans la chaîne doit être `$($User.prenom)` — sans `$()` l'interpolation échoue.
**Erreur 3** : `$Pwd` est une string, mais `-Password` attend un **SecureString** → il faut `ConvertTo-SecureString`.
**Erreur 4** : `Get-LocalUser` sans `-ErrorAction SilentlyContinue` va afficher une erreur rouge si l'utilisateur n'existe pas.

---

## Tableau récapitulatif des cmdlets à connaître

| Cmdlet | Action | Contexte TSSR |
|---|---|---|
| `Import-Csv` | Lire un CSV → objets | Lecture de listes d'utilisateurs |
| `Select-Object` | Filtrer colonnes / lignes | Ne garder que les champs utiles |
| `Where-Object` | Filtrer par condition | Services actifs, users activés |
| `ForEach` | Boucler sur une collection | Traiter chaque utilisateur |
| `ConvertTo-SecureString` | Texte → mdp sécurisé | Création de comptes |
| `New-LocalUser` | Créer un utilisateur | Administration locale |
| `Add-LocalGroupMember` | Ajouter à un groupe | Gestion des droits |
| `Get-LocalUser` | Vérifier existence | Test avant création |
| `Import-Module` | Charger un module | Utiliser des fonctions externes |
| `Start-Process -Verb RunAs` | Élévation UAC | Lancer en admin |
| `Write-Host -ForegroundColor` | Affichage coloré | Feedback visuel |
| `Test-Path` | Vérifier existence fichier | Validation avant traitement |
| `Add-Content` | Écrire dans un log | Journalisation |
