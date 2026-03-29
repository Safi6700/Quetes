
---

## 🎯 L'essentiel (définitions courtes à apprendre)

1. **Active Directory (AD)** = annuaire Microsoft pour **gérer les utilisateurs, ordinateurs et ressources** d'un réseau Windows

2. **Annuaire LDAP** = base de données **hiérarchique** (en arbre), pas comme une BDD classique avec des tables

3. **AD DS** = le service qui stocke et gère l'annuaire Active Directory

4. **Domaine** = ensemble d'objets (users, PC...) gérés par un ou plusieurs DC

5. **Contrôleur de domaine (DC)** = serveur qui contient l'annuaire AD et **authentifie** les utilisateurs
   - ⚠️ Si le DC est HS → le domaine est **inutilisable**

6. **RODC** = DC en **lecture seule**, utilisé pour les sites distants

7. **OU (Unité d'Organisation)** = dossier pour **organiser** les objets AD et **appliquer des GPO**

8. **Catalogue Global** = l’annuaire de toute la forêt (permet de trouver un objet même s’il est dans un autre domaine) 
    .  1er DC créé = catalogue global auto)

---

## 📋 Structure logique AD (du plus petit au plus grand)

| Niveau | C'est quoi | Exemple |
|--------|-----------|---------|
| **Objet** | Un élément (user, PC, imprimante) | jean.dupont |
| **OU** | Dossier pour organiser + GPO | OU=Comptabilité |
| **Domaine** | Ensemble d'objets + 1 ou plusieurs DC | entreprise.local |
| **Arbre** | Domaines avec même racine DNS | entreprise.local + paris.entreprise.local |
| **Forêt** | Ensemble d'arbres liés par des relations de confiance | Tout le groupe |

---

## 🔄 Workgroup vs Domaine

| Critère | Workgroup | Domaine |
|---------|-----------|---------|
| **Gestion** | Décentralisée (chaque PC) | **Centralisée** (DC) |
| **Connexion** | Compte local uniquement | Compte domaine partout |
| **Limite** | ~20 machines max | Illimité |
| **Authentification** | Locale | Par le DC |

---

## 📌 OU vs Groupe (piège classique !)

| | OU | Groupe |
|--|----|----|
| **Sert à** | Organiser + appliquer GPO | Donner des **permissions** |
| **Contient** | Users, PC, autres OU | Users, autres groupes |

---

## 🔧 Commandes PowerShell

| Commande | Usage |
|----------|-------|
| `Get-ADUser` | Liste les utilisateurs |
| `Get-ADComputer` | Liste les ordinateurs |
| `Get-ADGroup` | Liste les groupes |
| `Get-ADOrganizationalUnit` | Liste les OU |
| `Get-ADDomainController` | Liste les DC |

---

## ⚠️ Piège classique

> **OU ≠ Groupe**
> - OU = organiser + GPO
> - Groupe = permissions NTFS/partage

---

## ✅ Checkpoint examen

**Ce que le jury peut demander :**
- Définir AD, LDAP, domaine, DC
- Structure logique (Objet → OU → Domaine → Arbre → Forêt)
- Différence Workgroup / Domaine
- Différence OU / Groupe

---

## 📝 QUIZ Checkpoint

### Question 1
**C'est quoi Active Directory ?**
> [!success]- 🔓 Réponse
> Annuaire Microsoft pour **gérer les utilisateurs, ordinateurs et ressources** d'un réseau Windows.

---

### Question 2
**C'est quoi un annuaire LDAP ?**
> [!success]- 🔓 Réponse
> Base de données **hiérarchique** (en arbre), pas relationnelle.

---

### Question 3
**C'est quoi un DC ?**
> [!success]- 🔓 Réponse
> Serveur qui contient l'annuaire AD et **authentifie** les utilisateurs. Si HS → domaine inutilisable.

---

### Question 4
**Quels sont les 5 niveaux de la structure AD ?**
> [!success]- 🔓 Réponse
> **Objet → OU → Domaine → Arbre → Forêt**

---

### Question 5
**Différence OU et Groupe ?**
> [!success]- 🔓 Réponse
> - **OU** = organiser + appliquer GPO
> - **Groupe** = donner des permissions

---

### Question 6
**C'est quoi un RODC ?**
> [!success]- 🔓 Réponse
> DC en **lecture seule**, pour les sites distants.

---

### Question 7
**Workgroup ou Domaine pour 150 postes ?**
> [!success]- 🔓 Réponse
> **Domaine** obligatoire. Workgroup limité à ~20 machines et pas de gestion centralisée.

---

### Question 8
**C'est quoi le Catalogue Global ?**
> [!success]- 🔓 Réponse
> Index pour **chercher dans toute la forêt**. Le 1er DC créé devient automatiquement catalogue global.

---

## 🎤 À retenir pour l'oral

> **AD** = annuaire Microsoft pour gérer users/PC/ressources

> **LDAP** = BDD hiérarchique (en arbre)

> **DC** = serveur qui authentifie (si HS → domaine KO)

> **Structure** : Objet → OU → Domaine → Arbre → Forêt

> **OU** = organiser + GPO / **Groupe** = permissions

> **RODC** = DC lecture seule (sites distants)

---