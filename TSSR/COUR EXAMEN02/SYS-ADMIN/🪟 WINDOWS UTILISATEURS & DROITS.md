
---

## 🎯 L'essentiel (6 points)

1. **SID** = Security Identifier (identifiant unique utilisateur/groupe)
2. **RID** = partie finale du SID (500 = Administrateur, 501 = Invité)
3. **Well-known SIDs** : S-1-5-32-544 (Admins), S-1-5-32-545 (Users), S-1-5-32-546 (Invités)
4. **SAM** = Security Account Manager, base des comptes locaux (`%SystemRoot%\system32\Config\SAM`)
5. **Groupes Windows** = peuvent contenir utilisateurs ET autres groupes (≠ Linux)
6. **Droits NTFS** : FullControl, Modify, ReadAndExecute, Read, Write — **Deny prioritaire sur Allow**

---

## 🔑 Commandes indispensables

| Cmdlet | Rôle |
|--------|------|
| `Get-LocalUser` | Lister utilisateurs locaux |
| `Get-LocalGroup` | Lister groupes locaux |
| `Add-LocalGroupMember` | Ajouter membre à un groupe |
| `Get-LocalGroupMember` | Lister membres d'un groupe |
| `Get-Acl -Path "chemin"` | Voir droits (Owner, Group, Access) |

---

## ⚠️ Pièges classiques

> **Deny prioritaire sur Allow**
> → Même avec Allow FullControl, un Deny bloque l'accès !
>
> **SID ≠ RID**
> → SID = chaîne complète (S-1-5-21-xxx-500)
> → RID = juste la partie finale (500)
>
> **Comptes locaux (SAM) ≠ Domaine (AD)**
> → SAM = machine locale uniquement
> → Active Directory = annuaire centralisé du domaine
>
> **Get-LocalUser ≠ Get-WmiObject**
> → Get-LocalUser = liste simple (Name, Enabled)
> → Get-WmiObject Win32_UserAccount = détaillé (avec SID)

---

## 📝 QUIZ Checkpoint (8 questions)

### Question 1
**C'est quoi le SID ?**
> [!success]- 🔓 Réponse
> Security Identifier = identifiant unique utilisateur/groupe

---

### Question 2
**Quel est le RID de l'Administrateur ?**
> [!success]- 🔓 Réponse
> 500

---

### Question 3
**Où est stockée la base SAM ?**
> [!success]- 🔓 Réponse
> `%SystemRoot%\system32\Config\SAM`

---

### Question 4
**Quelle cmdlet pour voir les droits d'un fichier ?**
> [!success]- 🔓 Réponse
> `Get-Acl -Path "chemin"`

---

### Question 5
**Entre Allow et Deny, lequel est prioritaire ?**
> [!success]- 🔓 Réponse
> Deny (le refus est toujours prioritaire)

---

### Question 6
**Différence entre groupes Linux et Windows ?**
> [!success]- 🔓 Réponse
> Linux = que des utilisateurs | Windows = utilisateurs + autres groupes

---

### Question 7
**Quel est le SID du groupe Administrateurs ?**
> [!success]- 🔓 Réponse
> S-1-5-32-544

---

### Question 8
**DIAGNOSTIC : Un utilisateur a Allow FullControl mais ne peut pas accéder au fichier. Pourquoi ?**
> [!success]- 🔓 Réponse
> Il y a probablement un **Deny** quelque part (sur l'utilisateur ou un de ses groupes). Deny est prioritaire sur Allow.


---

## 🎤 À retenir pour l'oral

> **SID** = Security Identifier (identifiant unique utilisateur/groupe, équivalent UID/GID Linux)

> **RID** = partie finale du SID (500 = Administrateur, 501 = Invité)

> **Well-known SIDs** : S-1-5-32-544 (Admins) | S-1-5-32-545 (Users) | S-1-5-32-546 (Invités)

> **SAM** = base des comptes locaux (`%SystemRoot%\system32\Config\SAM`)

> **Groupes Windows** = peuvent contenir utilisateurs ET autres groupes (≠ Linux)

> **Deny prioritaire sur Allow** → même avec FullControl, un Deny bloque l'accès !

> **Commandes** : `Get-LocalUser` | `Get-LocalGroup` | `Get-Acl -Path "chemin"`

---
