## 🎯 L'ESSENTIEL (5 points)

1. **CLI** = Command Line Interface (prompt → commande → résultat → prompt)
2. **bash** = shell classique Linux (projet GNU, 1988, Brian Fox)
3. **PowerShell** = nouveau shell Windows (depuis Windows 7, remplace cmd.exe)
4. **Prompt bash** : `user@host:~$` (utilisateur) ou `#` (root)
5. **Prompt PowerShell** : `PS C:\Users\wilder>`

---

## 📊 SHELLS EXISTANTS

| OS | Shells |
|----|--------|
| **Windows** | cmd.exe, PowerShell |
| **Unix/Linux** | sh (historique), bash (classique), csh, ksh, tcsh, zsh, dash, ash |

---

## 🔧 FONCTIONNALITÉS COMMUNES

| Fonctionnalité | Description |
|----------------|-------------|
| **Historique** | Rappel des commandes précédentes |
| **Auto-complétion** | Tab pour compléter |
| **Variables d'environnement** | PATH (Linux) / $env:path (PowerShell) |
| **Alias** | Raccourcis de commandes |
| **Arrière-plan** | `commande &` |

---

## 📝 SYNTAXE DES COMMANDES (BASH)

```js
$ [chemin/]nom_commande [option…] [argument…]
```

| Élément | Exemple |
|---------|---------|
| **Options courtes** | `-l`, `-a` |
| **Options longues** | `--help`, `--version` |
| **Séparateur** | espace(s) |
| **Sensible à la casse** | OUI |

---

## 🔗 EXÉCUTION DE COMMANDES

| Syntaxe | Effet |
|---------|-------|
| `commande` | Exécution simple |
| `cmd1 ; cmd2` | Séquence (exécute les 2) |
| `cmd1 && cmd2` | cmd2 si cmd1 réussit |
| `cmd1 \|\| cmd2` | cmd2 si cmd1 échoue |
| `commande &` | Exécution en arrière-plan |
| `Ctrl + C` | Arrêt commande (SIGTERM) |

---

## 📤 REDIRECTIONS (BASH)

| Syntaxe | Effet |
|---------|-------|
| `cmd > fichier` | Sortie standard → fichier (écrase) |
| `cmd >> fichier` | Sortie standard → fichier (ajout) |
| `cmd < fichier` | Entrée standard ← fichier |
| `cmd 2> fichier` | Sortie erreur → fichier |
| `cmd > f.txt 2>&1` | Sortie + erreur → même fichier |

---

## 🔀 PIPE (TUBE)

| Syntaxe | Effet |
|---------|-------|
| `cmd1 \| cmd2` | Sortie cmd1 → entrée cmd2 |
| `cmd1 \|& cmd2` | Sortie + erreur cmd1 → entrée cmd2 |

---

## 🔧 COMMANDES INTERNES (BUILTIN)

| Commande | Rôle |
|----------|------|
| `cd` | Changer de répertoire |
| `type` | Afficher le type d'une commande |
| `echo` | Afficher une valeur |

---

## ⚠️ PIÈGE CLASSIQUE

```
❌ Confondre > et >>
   → > = écrase le fichier
   → >> = ajoute au fichier

❌ Confondre && et ||
   → && = si succès
   → || = si échec

❌ Oublier 2>&1 pour rediriger les erreurs
   → cmd > fichier 2>&1 (erreur + sortie)

❌ Prompt $ vs #
   → $ = utilisateur normal
   → # = root
```

---

## 📝 QUIZ

**Q1 : Que signifie CLI ?**
> [!success]- Réponse
> Command Line Interface

**Q2 : Quel est le shell classique de Linux ?**
> [!success]- Réponse
> bash

**Q3 : PowerShell remplace quoi ?**
> [!success]- Réponse
> cmd.exe (command.com)

**Q4 : Quel symbole dans le prompt indique root ?**
> [!success]- Réponse
> #

**Q5 : Quelle variable contient les chemins des commandes sous Linux ?**
> [!success]- Réponse
> PATH

**Q6 : Comment exécuter une commande en arrière-plan ?**
> [!success]- Réponse
> `commande &`

**Q7 : Que fait `cmd1 && cmd2` ?**
> [!success]- Réponse
> Exécute cmd2 seulement si cmd1 réussit

**Q8 : Que fait `>` vs `>>` ?**
> [!success]- Réponse
> `>` écrase, `>>` ajoute

**Q9 : Comment rediriger la sortie d'erreur ?**
> [!success]- Réponse
> `2>` ou `2>>`

**Q10 : Que fait le pipe `|` ?**
> [!success]- Réponse
> Connecte la sortie d'une commande à l'entrée d'une autre

**Q11 : Raccourci pour arrêter une commande en cours ?**
> [!success]- Réponse
> Ctrl + C

**Q12 : Quelle commande affiche le type d'une commande ?**
> [!success]- Réponse
> `type`

**Q13 : Variable PATH en PowerShell ?**
> [!success]- Réponse
> `$env:path`

**Q14 : Qui a créé bash et quand ?**
> [!success]- Réponse
> Brian Fox, 1988

**Q15 : Quelle variable configure le prompt bash ?**
> [!success]- Réponse
> PS1