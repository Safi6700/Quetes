# Quiz — Scripts PowerShell Checkpoint 2

## Métadonnées
- **Sujet** : Scripts PowerShell — Main.ps1, AddLocalUsers.ps1, Functions.psm1
- **Nombre de questions** : 25
- **Difficulté** : Mixte (fondamentaux → avancé)
- **Lien** : [[Guide_Scripts_Checkpoint2]]

---

## Questions

### Q1 — Rôle de Main.ps1
Quel est le rôle unique du script Main.ps1 dans le système ?
?
Main.ps1 sert uniquement de **lanceur**. Il exécute AddLocalUsers.ps1 avec des **privilèges élevés** (administrateur) via le paramètre `-Verb RunAs` de `Start-Process`, ce qui déclenche la fenêtre UAC.

---

### Q2 — Bug du chemin
Quel était le bug dans Main.ps1 (Q.2.2) et comment le corriger ?
?
Le chemin pointait vers `C:\Temp\AddLocalUsers.ps1` au lieu de `C:\Scripts\AddLocalUsers.ps1`. Le script n'était donc jamais trouvé ni exécuté. Correction : remplacer `C:\Temp` par `C:\Scripts`.

---

### Q3 — Paramètre -Verb RunAs
Que fait le paramètre `-Verb RunAs` dans la commande `Start-Process` ?
?
`-Verb RunAs` déclenche une **élévation de privilèges** via UAC (User Account Control). Une fenêtre apparaît demandant les identifiants d'un compte administrateur, et le processus lancé s'exécute avec des droits admin.

---

### Q4 — Séparateur CSV
Pourquoi doit-on spécifier `-Delimiter ";"` dans `Import-Csv` pour ce fichier Users.csv ?
?
Le fichier CSV utilise le **point-virgule** `;` comme séparateur au lieu de la virgule `,`. C'est courant dans les CSV français car la virgule est utilisée comme séparateur décimal. Sans `-Delimiter ";"`, PowerShell cherche des virgules et ne découpe pas correctement les colonnes.

---

### Q5 — Import-Csv et en-têtes
`Import-Csv` traite automatiquement la première ligne du fichier CSV. Comment ?
?
`Import-Csv` utilise automatiquement la **première ligne comme noms de colonnes** (headers). Il crée ensuite des objets PowerShell dont les propriétés correspondent à ces noms de colonnes. La première ligne n'est JAMAIS comptée comme une donnée.

---

### Q6 — Bug Select-Object -Skip 1
Pourquoi `| Select-Object -Skip 1` après `Import-Csv` provoque la perte du premier utilisateur ?
?
Puisque `Import-Csv` gère déjà l'en-tête automatiquement, les données retournées commencent directement au **premier utilisateur** (Anna Dumas). `Select-Object -Skip 1` saute donc cet utilisateur, pas l'en-tête qui a déjà été traitée par `Import-Csv`.

---

### Q7 — Select-Object pour les colonnes
Quelle est la commande pour ne garder que les colonnes `prenom`, `nom` et `description` du CSV ?
?
```powershell
Import-Csv -Path $FilePath -Delimiter ";" | Select-Object prenom, nom, description
```
`Select-Object` suivi des noms de propriétés filtre les colonnes et ne conserve que celles spécifiées.

---

### Q8 — ConvertTo-SecureString
Pourquoi utilise-t-on `ConvertTo-SecureString` pour le mot de passe ? Que font les paramètres `-AsPlainText -Force` ?
?
`New-LocalUser` exige un mot de passe de type **SecureString** (chiffré en mémoire), pas du texte brut. `-AsPlainText` autorise la conversion depuis du texte clair, et `-Force` supprime l'avertissement de sécurité qui rappelle que passer un mot de passe en clair est risqué.

---

### Q9 — ErrorAction SilentlyContinue
Que fait `-ErrorAction SilentlyContinue` dans `Get-LocalUser -Name $Name -ErrorAction SilentlyContinue` ?
?
Si l'utilisateur n'existe pas, `Get-LocalUser` génère une **erreur**. `-ErrorAction SilentlyContinue` **supprime cette erreur** et retourne `$null` silencieusement, permettant au `If (-not ...)` de fonctionner proprement sans message d'erreur rouge dans la console.

---

### Q10 — Logique du If
Explique la logique de `If (-not (Get-LocalUser -Name $Name -ErrorAction SilentlyContinue))`.
?
1. `Get-LocalUser` cherche l'utilisateur → retourne un objet si trouvé, `$null` si non trouvé
2. En PowerShell, un objet = `$true`, `$null` = `$false`
3. `-not` inverse : si l'utilisateur N'EXISTE PAS (`$null` → `$false` → `-not` → `$true`), on entre dans le bloc `If` pour le créer

---

### Q11 — Paramètre -Description
Quel paramètre manquait dans `New-LocalUser` pour inclure la description de l'utilisateur ?
?
Le paramètre `-Description $User.description`. Cela remplit le champ "Description" du compte utilisateur local Windows avec la valeur du CSV (ex: "Utilisateur du service Communication").

---

### Q12 — PasswordNeverExpires
Que se passe-t-il si on omet `-PasswordNeverExpires` lors de la création d'un utilisateur local ?
?
Par défaut, Windows applique une **politique d'expiration du mot de passe** (généralement 42 jours). Après cette période, l'utilisateur est obligé de changer son mot de passe. `-PasswordNeverExpires` désactive ce comportement.

---

### Q13 — Nom du groupe local
Pourquoi `Add-LocalGroupMember -Group "Utilisateur"` échoue alors que `-Group "Utilisateurs"` fonctionne ?
?
Le nom exact du groupe local sur un Windows en français est **"Utilisateurs"** (avec un **S**). "Utilisateur" sans S n'existe pas comme groupe, donc PowerShell retourne une erreur "groupe introuvable". Sur Windows anglais, le groupe s'appelle **"Users"**.

---

### Q14 — Write-Host et les couleurs
Quelle est la différence entre `Write-Host "message" -ForegroundColor Green` et `Write-Host "message" -ForegroundColor Red` dans le contexte de ce script ?
?
**Vert** = action réussie (utilisateur créé avec succès). **Rouge** = problème ou alerte (utilisateur existe déjà). C'est une convention visuelle qui aide l'administrateur à identifier rapidement le résultat de chaque opération sans lire chaque message en détail.

---

### Q15 — Fichier .psm1 vs .ps1
Quelle est la différence entre un fichier `.psm1` et un fichier `.ps1` ?
?
- **`.ps1`** = Script PowerShell — s'exécute séquentiellement du début à la fin
- **`.psm1`** = Module PowerShell — contient des **fonctions réutilisables** qu'on charge avec `Import-Module`. Les fonctions ne s'exécutent pas au chargement, elles deviennent disponibles pour être appelées.

---

### Q16 — Import-Module vs dot-sourcing
Quelles sont les 2 méthodes pour charger la fonction Log dans le script ? Quelle est la différence ?
?
1. **`Import-Module "C:\Scripts\Functions.psm1"`** — Méthode standard pour les modules `.psm1`. Charge les fonctions exportées dans un scope séparé.
2. **`. "C:\Scripts\Functions.psm1"`** (dot-sourcing) — Exécute le fichier dans le scope **actuel** du script. Tout le contenu est directement accessible comme s'il faisait partie du script.

---

### Q17 — Anatomie de la fonction Log
Combien de paramètres prend la fonction `Log` et que représente chacun ?
?
La fonction `Log` prend **2 paramètres** :
- `$FilePath` (string) : le chemin du fichier de log (ex: `"C:\Scripts\log.txt"`)
- `$Content` (string) : le message à écrire dans le log (ex: `"Compte Anna.Dumas créé"`)

---

### Q18 — Format de la ligne de log
Quel est le format d'une ligne écrite par la fonction Log ? Donne un exemple concret.
?
Format : `Date;Utilisateur;Contenu`
Exemple : `08/03/2026-14:30:45;CLIENT1\Administrator;Création réussie du compte Anna.Dumas`
- La date vient de `Get-Date -Format "dd/MM/yyyy-HH:mm:ss"`
- L'utilisateur vient de `[System.Security.Principal.WindowsIdentity]::GetCurrent().Name`
- Le contenu est le paramètre `$Content`

---

### Q19 — Test-Path
Dans la fonction Log, que fait `If (-not (Test-Path -Path $FilePath))` ?
?
`Test-Path` vérifie si le fichier de log **existe** sur le disque. Si le fichier **n'existe pas** (`-not`), il est créé avec `New-Item`. Cela évite une erreur lors du premier appel à `Add-Content` sur un fichier inexistant.

---

### Q20 — Out-Null
Pourquoi utilise-t-on `| Out-Null` après `New-Item` dans la fonction Log ?
?
`New-Item` retourne un objet représentant le fichier créé et l'affiche dans la console. `| Out-Null` **supprime cette sortie** pour que la console reste propre. Le fichier est toujours créé, mais aucun texte parasite n'apparaît.

---

### Q21 — Backtick dans PowerShell
Dans le script corrigé, que signifie le caractère `` ` `` (backtick) à la fin de certaines lignes de `New-LocalUser` ?
?
Le backtick `` ` `` est le caractère de **continuation de ligne** en PowerShell. Il permet de couper une commande longue sur plusieurs lignes pour la rendre plus lisible. C'est l'équivalent du `\` en bash.
```powershell
New-LocalUser -Name $Name `
              -Password $Password `
              -Description $User.description
```

---

### Q22 — ForEach vs foreach-object
Le script utilise `ForEach ($User in $Users)`. Quelle est la différence avec `$Users | ForEach-Object` ?
?
- **`ForEach ($User in $Users)`** = instruction de **boucle** (statement). Charge toutes les données en mémoire d'abord, puis itère. Plus rapide pour les petites collections.
- **`$Users | ForEach-Object { $_ }`** = **cmdlet** dans le pipeline. Traite les objets un par un en streaming. Plus économe en mémoire pour les grandes collections. L'objet courant est `$_` au lieu d'une variable nommée.

---

### Q23 — Interpolation de chaînes
Que produit `"$($User.prenom).$($User.nom)"` si prenom=Anna et nom=Dumas ?
?
Le résultat est `Anna.Dumas`. La syntaxe `$()` (sous-expression) est nécessaire pour accéder aux **propriétés** d'un objet à l'intérieur d'une chaîne entre guillemets doubles. Sans `$()`, PowerShell ne résoudrait pas `.prenom` et `.nom` correctement.

---

### Q24 — Flux complet d'exécution
Décris dans l'ordre les 6 grandes étapes de l'exécution du système complet (de Wilder qui lance Main.ps1 jusqu'à la fin).
?
1. **Wilder** (non-admin) exécute `Main.ps1`
2. `Start-Process -Verb RunAs` déclenche la fenêtre **UAC** → Wilder entre les identifiants admin
3. Une nouvelle fenêtre PowerShell s'ouvre en tant qu'**admin** et exécute `AddLocalUsers.ps1`
4. Le script charge le module `Functions.psm1` → fonction `Log` disponible
5. `Import-Csv` lit `Users.csv` → 4 objets utilisateur créés en mémoire
6. La boucle `ForEach` traite chaque utilisateur : vérifie existence → crée ou alerte → journalise

---

### Q25 — Add-Content vs Set-Content
La fonction Log utilise `Add-Content`. Que se passerait-il si on utilisait `Set-Content` à la place ?
?
- **`Add-Content`** = **ajoute** (append) à la fin du fichier. Chaque appel ajoute une nouvelle ligne sans effacer les précédentes.
- **`Set-Content`** = **remplace** tout le contenu du fichier. Si on l'utilisait dans la fonction Log, chaque nouvelle entrée **écraserait** les précédentes et on ne garderait que la dernière ligne de log.

---

## Résumé des bugs et corrections

| Question | Bug | Correction |
|----------|-----|------------|
| Q.2.2 | Chemin `C:\Temp\` incorrect | → `C:\Scripts\` |
| Q.2.3 | `Select-Object -Skip 1` saute 1er user | → Supprimer le Skip |
| Q.2.4 | `-Description` manquant | → Ajouter `-Description $User.description` |
| Q.2.5 | 10 colonnes importées inutilement | → `Select-Object prenom, nom, description` |
| Q.2.6 | Mot de passe non affiché | → Inclure le mdp dans `Write-Host` |
| Q.2.7 | Module Functions.psm1 non chargé | → `Import-Module` |
| Q.2.8 | Aucune journalisation | → Appels à `Log` aux moments clés |
| Q.2.9 | Pas de message si user existe | → Bloc `Else` avec `Write-Host` rouge |
| Q.2.10 | Groupe "Utilisateur" sans S | → "Utilisateurs" |
| Q.2.11 | Mot de passe expire | → `-PasswordNeverExpires` |
