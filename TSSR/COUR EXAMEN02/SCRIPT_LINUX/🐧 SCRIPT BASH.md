
---

## 🎯 L'ESSENTIEL (5 points)

1. **Shebang** : `#!/bin/bash` en 1ère ligne
2. **$?** = code de sortie (0 = succès, autre = échec)
3.  **$#** = nombre d'arguments
4. **$@** = tous les arguments
5. **Test** : `[ condition ]` — vrai si retourne 0
6. **exit 0** = fin script avec succès

> “C’est quoi la différence entre wildcard et regex ?”

> Une **wildcard** sert à faire correspondre des **noms de fichiers** et est interprétée par le **shell**.  
> Une **regex** sert à analyser ou filtrer du **contenu texte** et est interprétée par un **programme** (grep, PowerShell…).
---

## 📋 VARIABLES SPÉCIALES

| Variable    | Signification                     |
| ----------- | --------------------------------- |
| `$0`        | Nom du script                     |
| `$1, $2...` | Arguments 1, 2...                 |
| `$#`        | Nombre d'arguments                |
| `$@`        | Tous les arguments (mots séparés) |
| `$*`        | Tous les arguments (un seul mot)  |
| `$?`        | Code de sortie dernière commande  |
| `$$`        | PID du shell                      |

---

## 🔢 TESTS SUR NOMBRES

| Opérateur | Signification |
|-----------|---------------|
| `-eq` | égal (equal) |
| `-ne` | différent (not equal) |
| `-lt` | inférieur (less than) |
| `-le` | inférieur ou égal |
| `-gt` | supérieur (greater than) |
| `-ge` | supérieur ou égal |

---

## 📝 TESTS SUR CHAÎNES

| Opérateur | Signification |
|-----------|---------------|
| `=` | chaînes identiques |
| `!=` | chaînes différentes |
| `-z` | chaîne vide |
| `-n` | chaîne non vide |

---

## 📁 TESTS SUR FICHIERS

| Opérateur | Signification |
|-----------|---------------|
| `-e` | existe |
| `-f` | est un fichier |
| `-d` | est un dossier |
| `-r` | lecture autorisée |
| `-w` | écriture autorisée |
| `-x` | exécution autorisée |
| `-s` | existe et taille > 0 |

---

## 🔗 OPÉRATEURS LOGIQUES

| Opérateur | Signification |
|-----------|---------------|
| `!` | NON logique |
| `-a` | ET logique |
| `-o` | OU logique |

---

## 🔀 STRUCTURES CONDITIONNELLES

```bash
# IF
if [ condition ]
then
    instructions
elif [ condition2 ]
then
    instructions
else
    instructions
fi

# CASE
case $variable in
    valeur1) instructions;;
    valeur2|valeur3) instructions;;
    *) instructions par défaut;;
esac
```

---

## 🔄 BOUCLES

```bash
# FOR
for var in liste
do
    instructions
done

# WHILE
while [ condition ]
do
    instructions
done
```

---

## ⚠️ PIÈGE CLASSIQUE

```
❌ Oublier les espaces dans [ ]
   → [ $a -eq 1 ] ✅
   → [$a -eq 1]   ❌

❌ Confondre $@ et $*
   → $@ = arguments séparés (pour boucle for)
   → $* = arguments en un mot

❌ Oublier que 0 = vrai en bash
   → $? = 0 → commande réussie
   → $? ≠ 0 → commande échouée

❌ Oublier chmod u+x script.sh
```

---

## 📝 QUIZ

**Q1 : Que signifie $# ?**
> [!success]- Réponse
> Nombre d'arguments du script

**Q2 : Que signifie $? ?**
> [!success]- Réponse
> Code de sortie de la dernière commande

**Q3 : Comment tester si un fichier existe ?**
> [!success]- Réponse
> `[ -e fichier ]`

**Q4 : Comment tester si une variable est vide ?**
> [!success]- Réponse
> `[ -z $variable ]`

**Q5 : Opérateur pour "égal" avec des nombres ?**
> [!success]- Réponse
> `-eq`

**Q6 : Comment récupérer le 1er argument ?**
> [!success]- Réponse
> `$1`

**Q7 : En bash, 0 c'est vrai ou faux ?**
> [!success]- Réponse
> Vrai (succès)

**Q8 : Différence entre -f et -d ?**
> [!success]- Réponse
> `-f` = fichier, `-d` = dossier

**Q9 : Comment tester si on peut écrire dans un fichier ?**
> [!success]- Réponse
> `[ -w fichier ]`

**Q10 : Structure pour énumérer plusieurs cas ?**
> [!success]- Réponse
> `case ... esac`