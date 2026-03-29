
---

## 🎯 L'essentiel (6 points)

1. **UID** = dentifiants utilisateur
2. **GID** = groupe
3. **root**= UID 0
4. **Fichiers clés** : `/etc/passwd` (users), `/etc/shadow` (mdp chiffrés), `/etc/group` (groupes)
5. **Droits rwx** = read (4), write (2), execute (1) — pour **u**/ser, **g**/roup, **o**/thers
6. **chmod** = modifier les droits | **chown** = modifier le propriétaire
7. **Home** : `/home/user` pour utilisateurs | `/root` pour root
8. **Groupes** : principal (GID dans passwd) + secondaires (dans /etc/group)

---

## 🔑 Commandes indispensables

|Commande|Rôle|
|---|---|
|`id`|Afficher UID, GID, groupes|
|`adduser nom`|Créer utilisateur|
|`deluser nom`|Supprimer utilisateur|
|`usermod -aG groupe user`|Ajouter user à un groupe|
|`passwd user`|Changer mot de passe|
|`chmod 755 fichier`|Modifier droits (rwxr-xr-x)|
|`chown user:groupe fichier`|Changer propriétaire|
|`ls -l`|Voir droits et propriétaire|

---

## ⚠️ Pièges classiques

> **passwd ≠ shadow**
> 
> - `/etc/passwd` = infos user (lisible par tous)
> - `/etc/shadow` = mots de passe chiffrés (root only)
> 
> **root = UID 0** → toujours, ne pas oublier
> 
> **chmod ≠ chown**
> 
> - chmod = droits (rwx)
> - chown = propriétaire (user:group)
> 
> **3 catégories de droits** : user / group / others (dans cet ordre !)

---

## 📝 QUIZ Checkpoint (8 questions)

### Question 1

**Quel est l'UID de root ?**

> [!success]- 🔓 Réponse UID 0

---

### Question 2

**Quel fichier contient les mots de passe chiffrés ?**

> [!success]- 🔓 Réponse /etc/shadow

---

### Question 3

**Que signifie rwx en valeur numérique ?**

> [!success]- 🔓 Réponse r=4, w=2, x=1 → rwx = 7

---

### Question 4

**Différence entre chmod et chown ?**

> [!success]- 🔓 Réponse chmod = modifier les droits (rwx) | chown = modifier le propriétaire

---

### Question 5

**Commande pour ajouter un utilisateur à un groupe secondaire ?**

> [!success]- 🔓 Réponse `usermod -aG groupe utilisateur`

---

### Question 6

**Que signifie les droits 755 ?**

> [!success]- 🔓 Réponse rwxr-xr-x (user: tout, group: lecture+exec, others: lecture+exec)

---

### Question 7

**Où se trouve le home de root ?**

> [!success]- 🔓 Réponse /root (pas /home/root)

---

### Question 8

**DIAGNOSTIC : Un utilisateur ne peut pas lire un fichier. Quelles vérifications ?**

> [!success]- 🔓 Réponse
> 
> 1. `ls -l` → vérifier droits r pour user/group/others
> 2. `id` → vérifier si user appartient au groupe du fichier
> 3. Vérifier le propriétaire avec `ls -l`


---
## 🎤 À retenir pour l'oral

> **UID 0 = root** (superutilisateur, tous les droits)

> **Fichiers clés** : `/etc/passwd` (users) | `/etc/shadow` (mdp chiffrés, root only) | `/etc/group` (groupes)

> **Droits rwx** = read (4), write (2), execute (1) — pour user / group / others

> **chmod** = modifier les droits | **chown** = modifier le propriétaire

> **usermod -aG groupe user** = ajouter à un groupe (le -a est crucial sinon ça remplace !)

> **Home** : `/home/user` pour utilisateurs | `/root` pour root

> **su** = changer d'utilisateur | **sudo** = exécuter UNE commande en root

---
