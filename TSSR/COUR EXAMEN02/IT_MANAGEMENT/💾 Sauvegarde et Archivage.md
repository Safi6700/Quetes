
---

## 🎯 L'essentiel (définitions courtes à apprendre)

1. **Sauvegarde** = copie des données sur un autre support pour les récupérer en cas d'incident

2. **Restauration** = recopier les données sauvegardées vers la production

3. **Archivage** = conserver des données dont on n'a pas besoin maintenant pour usage ultérieur (≠ sauvegarde)

4. **PRA** (Plan de Reprise d'Activité) = procédures pour reprendre l'activité après un sinistre

5. **PCA** (Plan de Continuité d'Activité) = procédures pour maintenir l'activité pendant un sinistre

6. **Règle 3-2-1** = 3 copies, 2 supports différents, 1 copie hors-site

7. **Clonage** = image complète d'une machine (redémarrage plus rapide qu'une restauration classique)

---

## 📋 Types de sauvegardes (IMPORTANT)

| Type | Principe | Avantage | Inconvénient |
|------|----------|----------|--------------|
| **Complète** | Copie TOUTES les données | Restauration facile | Long, gros espace |
| **Incrémentale** | Modifs depuis la **dernière sauvegarde** | Rapide, peu d'espace | Restauration complexe |
| **Différentielle** | Modifs depuis la **dernière complète** | Compromis | Espace croissant |

**Stratégie classique** : 1 complète/semaine + 1 incrémentale/jour

---

## 🔄 Schéma des types de sauvegardes

```
COMPLÈTE          INCRÉMENTALE              DIFFÉRENTIELLE
    │                   │                         │
    ▼                   ▼                         ▼
[TOUT]           [Modifs depuis              [Modifs depuis
                  sauvegarde N-1]            dernière COMPLÈTE]
    
Lundi: Complète     Lundi: Complète         Lundi: Complète
Mardi: Complète     Mardi: Modifs Lun→Mar   Mardi: Modifs Lun→Mar
Merci: Complète     Merci: Modifs Mar→Mer   Merci: Modifs Lun→Mer
                                             (cumule !)
```

---

## 📍 Où sauvegarder ?

| Support | Avantage | Inconvénient |
|---------|----------|--------------|
| **Autre disque (même serveur)** | Rapide | Pas de protection si crash serveur |
| **Autre serveur** | Protection locale | Pas de protection si incendie |
| **Bandes LTO** | Grande capacité, hors-ligne | Lent, matériel dédié |
| **Cloud** | Hors-site automatique | Coût, dépendance internet |

---

## 🔐 Règle 3-2-1 (IMPORTANT)

```
┌─────────────────────────────────────────────┐
│               RÈGLE 3-2-1                   │
├─────────────────────────────────────────────┤
│  3 copies    → Prod + 2 sauvegardes         │
│  2 supports  → Ex: disque + bande           │
│  1 hors-site → Protection incendie/vol      │
└─────────────────────────────────────────────┘
```

**Copies hors-ligne** = protection contre les **rançongiciels**

---

## 📅 Péremption des sauvegardes

| Période | Conservation |
|---------|--------------|
| **Hebdomadaires** | 1-2 mois |
| **Mensuelles** | 1-2 ans |

Pourquoi conserver longtemps ? → Compromission invisible, suppression par erreur

---

## ⚠️ Piège classique

> **Sauvegarde ≠ Archivage**
> - **Sauvegarde** = copie pour récupérer en cas de panne (données actives)
> - **Archivage** = stockage long terme de données plus utilisées (supprimées de la prod)
>
> **ET** : Tester régulièrement les restaurations ! Une sauvegarde non testée = inutile

---

## ✅ Checkpoint examen (CP8)

**Compétence CP8** : Mettre en place, assurer et tester les sauvegardes et restaurations

**Ce que le jury peut demander :**
- Différence complète / incrémentale / différentielle
- Expliquer la règle 3-2-1
- Différence sauvegarde / archivage
- Différence PRA / PCA
- Pourquoi tester les restaurations ?

---

## 📝 QUIZ Checkpoint

### Question 1
**C'est quoi une sauvegarde ?**
> [!success]- 🔓 Réponse
> Copie des données sur un autre support pour les récupérer en cas d'incident.

---

### Question 2
**Différence sauvegarde complète, incrémentale, différentielle ?**
> [!success]- 🔓 Réponse
> - **Complète** = copie tout
> - **Incrémentale** = modifs depuis la **dernière sauvegarde** (rapide)
> - **Différentielle** = modifs depuis la **dernière complète** (compromis)

---

### Question 3
**C'est quoi la règle 3-2-1 ?**
> [!success]- 🔓 Réponse
> - **3** copies (prod + 2 sauvegardes)
> - **2** supports différents
> - **1** copie hors-site

---

### Question 4
**Différence PRA et PCA ?**
> [!success]- 🔓 Réponse
> - **PRA** (Plan de Reprise d'Activité) = reprendre APRÈS un sinistre
> - **PCA** (Plan de Continuité d'Activité) = maintenir PENDANT un sinistre

---

### Question 5
**Différence sauvegarde et archivage ?**
> [!success]- 🔓 Réponse
> - **Sauvegarde** = copie pour récupérer (données actives en prod)
> - **Archivage** = stockage long terme (données supprimées de la prod)

---

### Question 6
**Pourquoi des copies hors-ligne ?**
> [!success]- 🔓 Réponse
> Protection contre les **rançongiciels** (ransomware) qui chiffrent tout ce qui est accessible sur le réseau.

---

### Question 7
**Pourquoi tester régulièrement les restaurations ?**
> [!success]- 🔓 Réponse
> Pour vérifier que les sauvegardes sont **fonctionnelles**. Une sauvegarde non testée peut être corrompue ou inutilisable.

---

### Question 8
**DIAGNOSTIC : Une restauration échoue. Quelles vérifications ?**
> [!success]- 🔓 Réponse
> 1. Support de sauvegarde accessible ?
> 2. Fichiers de sauvegarde intègres (pas corrompus) ?
> 3. Espace disque suffisant pour restaurer ?
> 4. Droits d'accès corrects ?
> 5. Consulter le **catalogue** de sauvegarde

---

## 🎤 À retenir pour l'oral

> **Sauvegarde** = copie pour récupérer / **Archivage** = stockage long terme

> **Complète** = tout / **Incrémentale** = depuis dernière sauvegarde / **Différentielle** = depuis dernière complète

> **Règle 3-2-1** = 3 copies, 2 supports, 1 hors-site

> **PRA** = reprendre après sinistre / **PCA** = continuer pendant sinistre

> **Toujours tester les restaurations !**

---