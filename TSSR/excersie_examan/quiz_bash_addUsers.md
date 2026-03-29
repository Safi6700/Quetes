# 🧠 Quiz Bash — `addUsers.sh`
#quiz #bash #linux #tssr #scripting

> **15 questions** couvrant toutes les fonctionnalités clés du script.
> Réponds à chaque question avant de regarder la réponse.

---

## Question 1 — Shebang

Que signifie la première ligne `#!/bin/bash` d'un script ?

```bash
#!/bin/bash
```

> [!question]- 💡 Réponse
> `#!/bin/bash` est le **shebang**.
> Le `#!` indique au système d'exploitation quel interpréteur utiliser pour exécuter le script.
> Sans lui, le shell par défaut du système serait utilisé, ce qui peut différer de Bash et provoquer des erreurs.

---

## Question 2 — Variable `$#`

Quelle variable contient le **nombre d'arguments** passés au script ?

```bash
./addUsers.sh user1 user2 user3
# Combien d'arguments ?
```

> [!question]- 💡 Réponse
> La variable **`$#`** contient le nombre d'arguments.
> Ici `$# = 3` car on a passé `user1`, `user2`, `user3`.
>
> | Variable | Contenu |
> |---|---|
> | `$#` | Nombre d'arguments → `3` |
> | `$0` | Nom du script → `./addUsers.sh` |
> | `$1` | Premier argument → `user1` |
> | `$@` | Tous les arguments → `user1 user2 user3` |

---

## Question 3 — Variable `$@`

Que contient `$@` et combien de tours fait cette boucle ?

```bash
./addUsers.sh alice bob charlie

for utilisateur in $@
do
  echo $utilisateur
done
```

> [!question]- 💡 Réponse
> `$@` contient **tous les arguments séparément**.
> La boucle fait **3 tours** :
> - Tour 1 → `utilisateur=alice`
> - Tour 2 → `utilisateur=bob`
> - Tour 3 → `utilisateur=charlie`
>
> C'est ce qui permet de traiter un **nombre quelconque** d'utilisateurs automatiquement.

---

## Question 4 — Test `-eq`

Que teste l'expression `[ $# -eq 0 ]` ?

```bash
if [ $# -eq 0 ]; then
  echo "Il manque les noms d'utilisateurs en argument - Fin du script"
fi
```

> [!question]- 💡 Réponse
> `-eq` est l'opérateur de comparaison numérique **égal à** (*equal*).
> `$# -eq 0` teste si le **nombre d'arguments est strictement égal à zéro**.
> C'est le test utilisé pour vérifier qu'aucun utilisateur n'a été passé en argument.
>
> | Opérateur | Signification |
> |---|---|
> | `-eq` | égal à |
> | `-ne` | différent de |
> | `-lt` | inférieur à |
> | `-gt` | supérieur à |
> | `-le` | inférieur ou égal |
> | `-ge` | supérieur ou égal |

---

## Question 5 — `exit 0` vs `exit 1`

Quelle est la différence entre `exit 0` et `exit 1` ?

```bash
exit 0   # utilisé en fin de script normal
exit 1   # utilisé après le message d'erreur
```

> [!question]- 💡 Réponse
> En Unix, tout programme retourne un **code de sortie** :
> - `exit 0` → **succès** (tout s'est bien passé)
> - `exit 1` → **erreur** (quelque chose a échoué)
>
> C'est une convention universelle utilisée par tous les programmes Unix.
> Dans notre script, `exit 1` est utilisé uniquement quand il manque des arguments — c'est le seul cas qui justifie un arrêt immédiat.

---

## Question 6 — Variable `$?`

Que contient `$?` après l'exécution de `useradd` ?

```bash
sudo useradd -m -s /bin/bash user1
echo $?
# Affiche quoi si la création a réussi ?
# Affiche quoi si elle a échoué ?
```

> [!question]- 💡 Réponse
> `$?` contient le **code de retour de la dernière commande** :
> - `$? = 0` → `useradd` a **réussi**
> - `$? ≠ 0` → `useradd` a **échoué** (ex: `9` si l'utilisateur existe déjà)
>
> ⚠️ **Important** : `$?` est **réécrit après chaque nouvelle commande**.
> Il faut tester `$?` **immédiatement** après la commande qui nous intéresse, sinon sa valeur sera écrasée.

---

## Question 7 — Redirection `&> /dev/null`

Pourquoi redirige-t-on la sortie de `grep` vers `/dev/null` ?

```bash
grep "^$utilisateur:" /etc/passwd &> /dev/null
```

> [!question]- 💡 Réponse
> `/dev/null` est la **poubelle système** : tout ce qui y est envoyé est supprimé.
> `&>` redirige à la fois **stdout (sortie standard)** et **stderr (erreurs)**.
>
> On ne veut **pas afficher** la ligne trouvée dans `/etc/passwd`.
> On veut uniquement utiliser le **code de retour** de `grep` :
> - `grep` trouve → code retour `0` → l'utilisateur existe
> - `grep` ne trouve pas → code retour `1` → l'utilisateur n'existe pas

---

## Question 8 — Ancre `^` dans `grep`

Pourquoi utilise-t-on `"^$utilisateur:"` plutôt que `"$utilisateur"` ?

```bash
# Correct ✅
grep "^$utilisateur:" /etc/passwd

# Risqué ❌
grep "$utilisateur" /etc/passwd
```

> [!question]- 💡 Réponse
> Sans `^` et `:`, chercher `user1` matcherait aussi `user10`, `super_user1`, `user100`...
>
> - `^` → **ancre le début de ligne** (le nom commence exactement là)
> - `:` → **délimite la fin du nom** (le format de `/etc/passwd` sépare les champs par `:`)
>
> Exemple de ligne dans `/etc/passwd` :
> ```
> user1:x:1001:1001::/home/user1:/bin/bash
> ```
> Avec `^user1:` on est **certain** de ne matcher que l'utilisateur `user1` exactement.

---

## Question 9 — Options de `useradd`

Que font les options `-m` et `-s /bin/bash` ? Que se passe-t-il si on oublie `-m` ?

```bash
sudo useradd -m -s /bin/bash $utilisateur
```

> [!question]- 💡 Réponse
> | Option | Effet |
> |---|---|
> | `-m` | Crée automatiquement le répertoire `/home/$utilisateur` |
> | `-s /bin/bash` | Définit **Bash** comme shell de connexion de l'utilisateur |
>
> **Sans `-m`** : l'utilisateur est créé dans le système (`/etc/passwd`) mais **n'a pas de répertoire home**. La connexion avec ce compte peut générer des erreurs car le système ne trouve pas `~`.

---

## Question 10 — Structure `if/else`

Que se passe-t-il si l'utilisateur existe déjà dans ce bloc ?

```bash
if grep "^$utilisateur:" /etc/passwd &>/dev/null
then
  echo "L'utilisateur $utilisateur existe déjà"
else
  sudo useradd -m -s /bin/bash $utilisateur
fi
```

> [!question]- 💡 Réponse
> Si `grep` trouve l'utilisateur (code retour `0`) :
> - Le bloc `then` s'exécute → le message est affiché
> - Le bloc `else` est **ignoré** → `useradd` n'est **pas** exécuté
> - La boucle `for` continue naturellement vers l'argument suivant
>
> Le script **ne s'arrête pas** — c'est voulu : on traite tous les arguments même si certains existent déjà.

---

## Question 11 — Vérification de la création

Pourquoi teste-t-on `$?` immédiatement après `useradd` ?

```bash
sudo useradd -m -s /bin/bash $utilisateur
if [ $? -eq 0 ]; then        # ← doit être juste après
  echo "L'utilisateur $utilisateur a été créé"
else
  echo "Erreur à la création de l'utilisateur $utilisateur"
fi
```

> [!question]- 💡 Réponse
> `$?` est **réécrit après chaque commande exécutée**.
> Si on exécute n'importe quelle autre commande entre `useradd` et le test `if`, `$?` contiendra le code de cette nouvelle commande — pas celui de `useradd`.
>
> Il faut donc tester `$?` **immédiatement** après la commande dont on veut vérifier le résultat.

---

## Question 12 — `exit` interdit dans la boucle

Le sujet dit *"le script continue dans tous les cas"*. Quel mot-clé est **interdit** à l'intérieur de la boucle ?

```bash
for utilisateur in $@
do
  # ...
  sudo useradd -m -s /bin/bash $utilisateur
  if [ $? -ne 0 ]; then
    echo "Erreur à la création de l'utilisateur $utilisateur"
    ???   # que mettre ici ?
  fi
done
```

> [!question]- 💡 Réponse
> Le mot-clé **`exit`** est **interdit** à l'intérieur de la boucle.
> `exit` stoppe **immédiatement tout le script**, y compris les utilisateurs suivants non encore traités.
>
> La bonne pratique : afficher le message d'erreur et **ne rien mettre** — la boucle `for` passe naturellement à l'argument suivant.
>
> ⚠️ Seul le bloc "absence d'arguments" justifie un `exit 1` dans ce script.

---

## Question 13 — Ordre logique du script

Quel est le bon ordre des blocs dans le script ?

> [!question]- 💡 Réponse
> L'ordre correct est :
>
> ```
> 1. #!/bin/bash              → Shebang
> 2. Vérification des args    → Si $# -eq 0 → message + exit 1
> 3. Boucle for sur $@        → Pour chaque utilisateur
> 4.   Vérif existence        → grep dans /etc/passwd
> 5.   Si n'existe pas        → useradd
> 6.   Vérif création         → test $?
> 7. exit 0                   → Fin normale du script
> ```
>
> Chaque étape n'est exécutée que si la précédente a du sens.
> La vérification des arguments en **premier** évite d'entrer inutilement dans la boucle.

---

## Question 14 — `chmod +x`

Pourquoi faut-il exécuter `chmod +x addUsers.sh` avant `./addUsers.sh` ?

```bash
chmod +x addUsers.sh
./addUsers.sh user1 user2
```

> [!question]- 💡 Réponse
> Sous Linux, un fichier texte n'est **pas exécutable par défaut**.
> `chmod +x` ajoute le **bit d'exécution** (`x`) au fichier.
> Sans ça, le terminal retourne `Permission denied` au lancement.
>
> **Alternative** : `bash addUsers.sh user1 user2`
> Cette commande n'exige pas le bit `+x` car c'est `bash` lui-même qui lit et interprète le fichier.

---

## Question 15 — Logique globale du script

Sans regarder le script, décris en une phrase le rôle de chacune de ces variables :

| Variable | Rôle |
|---|---|
| `$#` | ? |
| `$@` | ? |
| `$?` | ? |
| `$0` | ? |
| `$1` | ? |

> [!question]- 💡 Réponse
>
> | Variable | Rôle |
> |---|---|
> | `$#` | **Nombre** d'arguments passés au script |
> | `$@` | **Liste** de tous les arguments (séparés) |
> | `$?` | **Code de retour** de la dernière commande (0=succès) |
> | `$0` | **Nom** du script lui-même (`./addUsers.sh`) |
> | `$1` | **Premier** argument passé au script |
>
> Ces 5 variables sont les **variables spéciales** les plus utilisées en Bash. Les maîtriser, c'est maîtriser la base de tout script d'administration système.

---

## 📊 Récapitulatif des thèmes

| #   | Thème               | Concept clé                    |
| --- | ------------------- | ------------------------------ |
| 1   | Shebang             | `#!/bin/bash`                  |
| 2   | Arguments           | `$#`                           |
| 3   | Arguments           | `$@` et boucle for             |
| 4   | Test conditionnel   | `-eq`                          |
| 5   | Code de sortie      | `exit 0` / `exit 1`            |
| 6   | Code de retour      | `$?`                           |
| 7   | Redirections        | `&> /dev/null`                 |
| 8   | Grep & regex        | Ancre `^` et `:`               |
| 9   | Useradd             | Options `-m` et `-s`           |
| 10  | Structure if/else   | Flux conditionnel              |
| 11  | Vérification        | Tester `$?` immédiatement      |
| 12  | Logique de flux     | `exit` interdit dans boucle    |
| 13  | Pseudo-code         | Ordre logique du script        |
| 14  | Permissions         | `chmod +x`                     |
| 15  | Variables spéciales | Récapitulatif `$# $@ $? $0 $1` |

---

*Source : Checkpoint 1 TSSR v2025 — Exercice 3*
