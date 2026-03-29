# 🗂️ FICHE TSSR – Les GPO

---

## 🎯 L'essentiel (définitions courtes à apprendre)

1. **GPO** (Group Policy Object) = règles pour **configurer automatiquement** les users et PC d'un domaine AD

2. **LSDOU** = ordre d'application des GPO : **Local → Site → Domaine → OU** (la dernière gagne)

   - La dernière GPO appliquée **gagne** (concept d'héritage)

1. **Enforced** = force une GPO même si l'héritage est bloqué (à utiliser **rarement**)

2. **Filtrage de sécurité** = choisir **qui reçoit** la GPO (par défaut : tous les users authentifiés)

3. **SYSVOL** = dossier partagé sur les DC qui contient les **fichiers des GPO**

4. **Stratégie locale** = règles sur **1 seul PC** (gpedit.msc), écrasées par les GPO domaine

---

## 🔄 Ordre LSDOU (à retenir par cœur)

```
L → S → D → OU

Local → Site → Domaine → OU
         ↓
   La dernière GAGNE
```

---

## 📋 Stratégie locale vs GPO

| | Stratégie locale | GPO |
|--|------------------|-----|
| **Portée** | 1 seul PC | Tout le domaine |
| **Console** | gpedit.msc | gpmc.msc |
| **Priorité** | Faible | **Forte** (écrase le local) |

---

## 🔧 Commandes à retenir

| Commande | Usage |
|----------|-------|
| `gpupdate /force` | Forcer l'application des GPO |
| `gpresult /r` | Voir les GPO appliquées |
| `gpmc.msc` | Console de gestion GPO (serveur) |
| `gpedit.msc` | Éditeur stratégie locale (poste) |

---

## ⚠️ Piège classique

> **Une GPO ne s'applique pas ?** Vérifier :
> 1. GPO **activée** ?
> 2. **Liée** à la bonne OU ?
> 3. User/PC dans la bonne **OU** ?
> 4. **Filtrage de sécurité** OK ?

---

## ✅ Checkpoint examen

**Ce que le jury peut demander :**
- C'est quoi une GPO
- Ordre LSDOU
- Différence stratégie locale / GPO
- Commandes gpupdate, gpresult

---

## 📝 QUIZ Checkpoint

### Question 1
**C'est quoi une GPO ?**
> [!success]- 🔓 Réponse
> Règles pour **configurer automatiquement** les users et PC d'un domaine AD.

---

### Question 2
**C'est quoi LSDOU ?**
> [!success]- 🔓 Réponse
> Ordre d'application : **Local → Site → Domaine → OU**. La dernière gagne.

---

### Question 3
**Différence stratégie locale / GPO ?**
> [!success]- 🔓 Réponse
> - Locale = 1 seul PC (gpedit.msc)
> - GPO = tout le domaine, **prioritaire** sur le local

---

### Question 4
**Comment forcer l'application des GPO ?**
> [!success]- 🔓 Réponse
> `gpupdate /force`

---

### Question 5
**Comment voir les GPO appliquées sur un poste ?**
> [!success]- 🔓 Réponse
> `gpresult /r`

---

### Question 6
**C'est quoi Enforced ?**
> [!success]- 🔓 Réponse
> Force une GPO même si l'héritage est bloqué. À utiliser **rarement**.

---

## 🎤 À retenir pour l'oral

> **GPO** = configurer automatiquement users et PC du domaine

> **LSDOU** = Local → Site → Domaine → OU (la dernière gagne)

> **gpupdate /force** = forcer / **gpresult /r** = voir les GPO appliquées

> **Locale** = 1 PC / **GPO** = domaine (prioritaire)

---