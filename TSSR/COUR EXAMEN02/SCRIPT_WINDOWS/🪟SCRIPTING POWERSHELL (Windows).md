
---

## 🎯 L'ESSENTIEL (5 points)

1. **Cmdlet** = commande PowerShell format `Verbe-Nom` (Get-ChildItem, Set-Item...)
2. **Variables** : `$NomVariable` (préfixe $ obligatoire)
3. **Extension** : `.ps1` pour les scripts
4. **Politique exécution** : `Set-ExecutionPolicy` (bloque scripts par défaut)
5. **Portée variables** : Global, Script, Local, Private

> “C’est quoi la différence entre wildcard et regex ?”


> Une **wildcard** sert à faire correspondre des **noms de fichiers** et est interprétée par le **shell**.  
> Une **regex** sert à analyser ou filtrer du **contenu texte** et est interprétée par un **programme** (grep, PowerShell…).
---

## 📝 VARIABLES

### Déclaration et utilisation

```powershell
# Déclaration
$MaVariable = "valeur"
$Nombre = 42

# Affichage
Write-Host $MaVariable
Write-Host "Valeur: $Nombre"

# Exécution dynamique
$Commande = "whoami"
Invoke-Expression -Command $Commande
```

### Variables spéciales

| Variable | Description |
|----------|-------------|
| `$?` | État dernière opération (True/False) |
| `$_` | Objet courant dans le pipeline |
| `$args` | Tableau des arguments passés |
| `$Null` | Valeur NULL ou vide |
| `$True` / `$False` | Booléens |

### Portée des variables

| Portée | Description |
|--------|-------------|
| **Global** | Disponible dans toute la session |
| **Script** | Uniquement dans le script |
| **Local** | Dans la commande/script en cours |
| **Private** | Non visible hors de la portée |

---

## 🔍 OPÉRATEURS DE COMPARAISON

| Opérateur | Signification | Exemple |
|-----------|---------------|---------|
| `-eq` | Equal (égal) | `$a -eq 5` |
| `-ne` | Not Equal (différent) | `$a -ne 5` |
| `-gt` | Greater Than (>) | `$a -gt 5` |
| `-lt` | Less Than (<) | `$a -lt 5` |
| `-ge` | Greater or Equal (>=) | `$a -ge 5` |
| `-le` | Less or Equal (<=) | `$a -le 5` |
| `-like` | Avec wildcards (*) | `$s -like "test*"` |
| `-match` | Avec regex | `$s -match "^test"` |

### Opérateurs logiques

| Opérateur | Signification |
|-----------|---------------|
| `-and` | ET logique |
| `-or` | OU logique |
| `-xor` | OU exclusif |
| `-not` ou `!` | NON logique |

---

## 🔀 STRUCTURES CONDITIONNELLES

### If / Else

```powershell
If (condition)
{
    # instructions si vrai
}
Else
{
    # instructions si faux
}
```

**Exemple :**
```powershell
If (New-Item -ItemType Directory -Name NewDir -ErrorAction SilentlyContinue)
{
    Write-Host "Création dossier succès"
}
Else
{
    Write-Host "Création dossier échec" -ForegroundColor Red
}
```

### Switch

```powershell
Switch ($Condition)
{
    valeur1 { Write-Host "cas 1" }
    valeur2 { Write-Host "cas 2" }
    default { Write-Host "cas par défaut" }
}
```

---

## 🔁 BOUCLES

### For

```powershell
For ($i=0; $i -le 10; $i++)
{
    Write-Host "Valeur: $i"
}
```

### Foreach

```powershell
$Services = Get-Service
Foreach ($Service in $Services)
{
    Write-Host "$($Service.Name) --> $($Service.Status)"
}
```

### While

```powershell
$Count = 0
While ($Count -le 10)
{
    Write-Host "Compteur égal à $Count"
    $Count++
}
```

### Do While / Do Until

```powershell
# Do While - s'exécute TANT QUE condition vraie
Do
{
    Write-Host "Compteur: $Count"
    $Count++
}
While ($Count -le 10)

# Do Until - s'exécute JUSQU'À ce que condition vraie
Do
{
    Write-Host "Compteur: $Count"
    $Count++
}
Until ($Count -eq 10)
```

---

## 🔧 FONCTIONS

```powershell
# Fonction simple
function Hello
{
    Write-Host "Hi folks !"
}

# Fonction avec paramètres
function Greet
{
    param ([Array]$ArgumentsList)
    If ($ArgumentsList.Count -gt 0)
    {
        Write-Host "Hi $($ArgumentsList[0])"
    }
    Else
    {
        Hello
    }
}

# Appel
Greet -ArgumentsList $args
```

---

## 🔄 COMPARAISON BASH vs POWERSHELL

| Concept | Bash | PowerShell |
|---------|------|------------|
| Variable | `$var` ou `${var}` | `$var` |
| Égalité nombre | `-eq` | `-eq` |
| Égalité chaîne | `=` ou `==` | `-eq` |
| Différent | `-ne` ou `!=` | `-ne` |
| ET logique | `&&` ou `-a` | `-and` |
| OU logique | `\|\|` ou `-o` | `-or` |
| If | `if [ ]; then; fi` | `If () { }` |
| For | `for i in; do; done` | `For () { }` |
| Foreach | `for item in list` | `Foreach ($item in $list)` |

---

## ⚠️ PIÈGE CLASSIQUE EXAMEN

```
❌ ERREUR : Oublier le $ devant les variables
   → PowerShell : $Variable (toujours avec $)

❌ ERREUR : Utiliser == au lieu de -eq
   → PowerShell utilise -eq, -ne, -gt, -lt (pas ==, !=, >, <)

❌ ERREUR : Confondre While et Until
   → While = TANT QUE condition vraie
   → Until = JUSQU'À ce que condition vraie

❌ ERREUR : Oublier Set-ExecutionPolicy
   → Par défaut, les scripts .ps1 sont BLOQUÉS !
   → Set-ExecutionPolicy RemoteSigned

❌ ERREUR : Confondre -and et &&
   → PowerShell : -and, -or
   → Bash : && et ||
```

---

## 📝 QUIZ - Teste tes connaissances

**Q1 : Format d'une cmdlet PowerShell ?**
> [!success]- Réponse
> `Verbe-Nom` (ex: Get-ChildItem, Set-Item)

**Q2 : Comment déclarer une variable en PowerShell ?**
> [!success]- Réponse
> `$NomVariable = valeur`

**Q3 : Opérateur "égal" en PowerShell ?**
> [!success]- Réponse
> `-eq` (equal)

**Q4 : Opérateur "supérieur à" en PowerShell ?**
> [!success]- Réponse
> `-gt` (greater than)

**Q5 : Différence entre While et Until ?**
> [!success]- Réponse
> While = tant que vrai / Until = jusqu'à ce que vrai

**Q6 : Variable qui contient l'état de la dernière commande ?**
> [!success]- Réponse
> `$?` (True ou False)

**Q7 : Variable qui contient l'objet courant dans un pipeline ?**
> [!success]- Réponse
> `$_`

**Q8 : Cmdlet pour exécuter une chaîne comme commande ?**
> [!success]- Réponse
> `Invoke-Expression`

**Q9 : Extension des scripts PowerShell ?**
> [!success]- Réponse
> `.ps1`

**Q10 : Commande pour autoriser l'exécution des scripts ?**
> [!success]- Réponse
> `Set-ExecutionPolicy`