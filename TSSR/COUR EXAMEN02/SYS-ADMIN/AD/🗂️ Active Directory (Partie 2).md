
---

## 🎯 L'essentiel (définitions courtes à apprendre)

1. **DNS** = **obligatoire** pour AD (résout les noms ET localise les services)

2. **SNTP** = synchronisation de l'heure, **indispensable** pour Kerberos

3. **Kerberos** = protocole d'**authentification** par défaut depuis Windows 2000

4. **Réplication** = copie des données entre DC pour avoir la **même info partout**
   - Intra-site : 5 min
   - Inter-site : 180 min (3h)

1. **FSMO** = 5 rôles spéciaux répartis sur les DC (certaines tâches = 1 seul DC autorisé)

   - **Forêt** (1 seul par forêt) :
     - Maître de schéma → gère les MAJ du schéma
     - Maître d'attribution de noms de domaine → gère les noms de domaines
   - **Domaine** (1 seul par domaine) :
     - Maître RID → gère les attributions de RID/SID
     - Maître d'infrastructure → gère les relations des objets entre domaine
     - **Émulateur PDC** (primordial) → synchronisation du temps, verrouillage de comptes

3. **GUID** = identifiant unique dans la **forêt**, ne change **jamais**

4. **SID** = identifiant unique dans le **domaine**, peut changer

5. **AGDLP** = méthode pour gérer les permissions proprement (jamais de droits directs sur un user)

6. **Tiering Model** = 3 niveaux de sécurité **séparés** (T0 = DC, T1 = serveurs, T2 = postes)

---

## 🔌 Protocoles liés à AD

| Protocole | Rôle |
|-----------|------|
| **DNS** | Obligatoire pour AD (noms + services) |
| **SNTP** | Synchro heure (obligatoire pour Kerberos) |
| **Kerberos** | Authentification |
| **LDAP** | Requêtes sur l'annuaire |

---

## 🔄 Réplication

| Type | Intervalle par défaut |
|------|----------------------|
| **Intra-site** | 5 min |
| **Inter-site** | 180 min (3h) |

**KCC** = composant qui gère automatiquement la topologie de réplication

---

## 🎭 Les 5 rôles FSMO

| Niveau | Rôle | En bref |
|--------|------|---------|
| **Forêt** | Maître de schéma | Modifie la structure AD |
| **Forêt** | Maître d'attribution de noms | Ajoute/supprime des domaines |
| **Domaine** | Maître RID | Attribue les identifiants (SID) |
| **Domaine** | Maître d'infrastructure | Gère les liens entre domaines |
| **Domaine** | **Émulateur PDC** ⭐ | Synchro heure + verrouillage comptes (le plus critique) |

---

## 🆔 GUID vs SID

| | GUID | SID |
|--|------|-----|
| **Portée** | Forêt | Domaine |
| **Change ?** | **Jamais** | Peut changer (ex: changement de domaine) |

---

## 👥 AGDLP (méthode permissions)

**A** → **G** → **DL** → **P**

| Lettre | Signifie | C'est quoi |
|--------|----------|------------|
| **A** | Account | L'utilisateur |
| **G** | Global group | Groupe métier (ex: Comptables) |
| **DL** | Domain Local group | Groupe de droits (ex: Lecture_Factures) |
| **P** | Permissions | Droits sur la ressource |

→ **Jamais** de permissions directement sur un utilisateur !

---

## 🔐 Tiering Model (3 niveaux séparés)

| Tier | Contient | Niveau de risque |
|------|----------|------------------|
| **T0** | DC, admins entreprise | Le plus **critique** |
| **T1** | Serveurs applicatifs | Intermédiaire |
| **T2** | Postes utilisateurs | Le plus **exposé** (phishing...) |

⚠️ Un admin T0 ne doit **JAMAIS** se connecter sur un poste T2 !

---

## ⚠️ Piège classique

> **GUID vs SID** :
> - GUID = forêt, **permanent**
> - SID = domaine, peut changer

---

## ✅ Checkpoint examen

**Questions Checkpoint 4 :**
- **Q2.1** : Qu'est-ce qu'un rôle FSMO ?
- **Q2.2** : Pourquoi la réplication entre DC est primordiale ?

---

## 📝 QUIZ Checkpoint

### Question 1
**Quels protocoles sont obligatoires pour AD ?**
> [!success]- 🔓 Réponse
> - **DNS** (noms + services)
> - **SNTP** (heure, pour Kerberos)

---

### Question 2
**C'est quoi un rôle FSMO ? (Question CP4)**
> [!success]- 🔓 Réponse
> 5 rôles spéciaux où **un seul DC** peut faire certaines tâches (schéma, RID, PDC...).

---

### Question 3
**Pourquoi la réplication est primordiale ? (Question CP4)**
> [!success]- 🔓 Réponse
> Pour que tous les DC aient la **même info**. Si un DC tombe, les autres ont les données.

---

### Question 4
**Quels sont les intervalles de réplication ?**
> [!success]- 🔓 Réponse
> - Intra-site : **5 min**
> - Inter-site : **180 min** (3h)

---

### Question 5
**Différence GUID / SID ?**
> [!success]- 🔓 Réponse
> - **GUID** = forêt, ne change jamais
> - **SID** = domaine, peut changer

---

### Question 6
**C'est quoi AGDLP ?**
> [!success]- 🔓 Réponse
> Méthode pour les permissions : **Account → Global → Domain Local → Permissions**
> Jamais de droits directs sur un user !

---

### Question 7
**C'est quoi le Tiering Model ?**
> [!success]- 🔓 Réponse
> 3 niveaux séparés : **T0** (DC) / **T1** (serveurs) / **T2** (postes).
> Un admin T0 ne se connecte jamais sur T2.

---

### Question 8
**Quel est le rôle FSMO le plus critique ?**
> [!success]- 🔓 Réponse
> **Émulateur PDC** : gère la synchro heure et le verrouillage des comptes.

---

## 🎤 À retenir pour l'oral

> **DNS** = obligatoire pour AD / **SNTP** = obligatoire pour Kerberos

> **Réplication** = même info sur tous les DC (5 min intra, 180 min inter)

> **FSMO** = 5 rôles spéciaux, 1 seul DC autorisé par rôle

> **GUID** = forêt, permanent / **SID** = domaine, peut changer

> **AGDLP** = A → G → DL → P (jamais de droits directs sur user)

> **Tiering** = T0 (DC) / T1 (serveurs) / T2 (postes) → ne pas mélanger !

---