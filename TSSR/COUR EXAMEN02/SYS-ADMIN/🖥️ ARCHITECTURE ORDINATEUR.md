
---

## 🎯 L'ESSENTIEL (5 points)

1. **Architecture Von Neumann** = UAL + Unité de contrôle + Mémoire + Entrées/Sorties
2. **CPU** = UAL + Unité de contrôle + Horloge + Registres + Caches
3. **Hiérarchie mémoire** : Registres → L1 → L2 → L3 → RAM → SSD → HDD (du + rapide au + lent)
4. **Caractéristiques CPU** : jeu d'instructions, fréquence (GHz), taille registres (bits)
5. **Ordinateur** = machine électronique, numérique, programmable

---

## 🔄 ARCHITECTURE DE VON NEUMANN

```js
              ┌─────────────┐
              │   MÉMOIRE   │
              │ (données +  │
              │ programmes) │
              └──────┬──────┘
                     │
         ┌───────────┼───────────┐
         │           │           │
         ▼           ▼           ▼
   ┌───────────┐ ┌───────────┐
   │  UNITÉ DE │◄─►│    UAL    │
   │  CONTRÔLE │   │           │
   └───────────┘   └───────────┘
         │               │
         ▼               ▼
   ┌─────────┐     ┌─────────┐
   │ ENTRÉE  │     │ SORTIE  │
   └─────────┘     └─────────┘
```

| Composant | Rôle |
|-----------|------|
| **UAL** (Unité Arithmétique et Logique) | Effectue les opérations (calculs) |
| **Unité de contrôle** | Séquence les opérations |
| **Mémoire** | Stocke données ET programmes |
| **Entrées/Sorties (I/O)** | Communication avec l'extérieur |

---

## ⚙️ LE CPU (Central Processing Unit)

**Définition** : Unité de calcul = circuit intégré

**Composants du CPU :**
- **UAL** (ALU) = fait les calculs
- **Unité de contrôle** = coordonne
- **Horloge** = cadence (fréquence en GHz)
- **Registres** = mémoire ultra-rapide dans le CPU
- **Mémoires caches** = L1, L2, L3

**Caractéristiques d'un CPU :**

| Caractéristique | Description |
|-----------------|-------------|
| **Jeu d'instructions** | x86-64, ARM, etc. |
| **Fréquence** | 1 à 5 GHz |
| **Taille registres** | 32 bits, 64 bits |
| **Nombre de cœurs** | 1 à 16+ cores |

---

## 🧠 HIÉRARCHIE DES MÉMOIRES

```
        Plus RAPIDE          Plus LENT
        Plus CHER            Moins CHER
        Plus PETIT           Plus GRAND
             │                    │
             ▼                    ▼
┌──────────┬────────┬────────┬────────┬────────┬────────┬──────────┐
│ Registres│   L1   │   L2   │   L3   │  RAM   │  SSD   │   HDD    │
└──────────┴────────┴────────┴────────┴────────┴────────┴──────────┘
```

| Mémoire | Taille typique | Vitesse |
|---------|----------------|---------|
| **Registres** | Données unitaires | Vitesse CPU (ns) |
| **Cache L1** | ~10 kio/core | Vitesse CPU / 2 à 4 |
| **Cache L2** | ~100 kio/core | Vitesse L1 / 4 |
| **Cache L3** | ~10 Mio (partagé) | Vitesse L2 / 4 |
| **RAM** | ~10 Gio | Vitesse CPU / 100 |
| **SSD** | ~1 Tio | 0,1 ms |
| **HDD** | ~10 Tio | 10 ms |

**Principe** : Plus c'est proche du CPU, plus c'est rapide mais petit et cher !

---

## 💻 EXEMPLES DE CPU

| | PC Classique | Raspberry Pi 4 |
|--|--------------|----------------|
| **Cœurs** | 1 à 16+ | 4 |
| **Architecture** | 64 bits | 64 bits |
| **Fréquence** | 1 à 5 GHz | 1,5 GHz |
| **Jeu d'instructions** | x86-64 | ARMv8 |
| **Cache L1** | ~10 kio/core | 80 kio/core |
| **Cache L2** | ~100 kio/core | 1 Mio |
| **Cache L3** | ~10 Mio (partagé) | - |

---

## 📊 UNITÉS DE MESURE

| Unité | Valeur |
|-------|--------|
| 1 bit | 0 ou 1 |
| 1 octet (byte) | 8 bits |
| 1 kio (kibioctet) | 1024 octets |
| 1 Mio (mébioctet) | 1024 kio |
| 1 Gio (gibioctet) | 1024 Mio |
| 1 Tio (tébioctet) | 1024 Gio |

---

## ⚠️ PIÈGE CLASSIQUE

> **Cache L1, L2, L3 — ne pas confondre !**
> - **L1** = le plus rapide, le plus petit, dans chaque cœur
> - **L2** = un peu plus lent, plus grand, dans chaque cœur
> - **L3** = le plus lent des caches, le plus grand, **partagé** entre tous les cœurs
> 
> ⚠️ Plus le numéro est petit, plus c'est rapide !

---

## 📝 QUIZ CHECKPOINT

> [!question] Q1 : Quels sont les 4 composants de l'architecture Von Neumann ?
> > [!success]- 🔓 Réponse
> > UAL, Unité de contrôle, Mémoire, Entrées/Sorties

> [!question] Q2 : C'est quoi l'UAL ?
> > [!success]- 🔓 Réponse
> > Unité Arithmétique et Logique — effectue les calculs

> [!question] Q3 : C'est quoi l'unité de contrôle ?
> > [!success]- 🔓 Réponse
> > Elle séquence (coordonne) les opérations

> [!question] Q4 : Quels sont les composants d'un CPU ?
> > [!success]- 🔓 Réponse
> > UAL, Unité de contrôle, Horloge, Registres, Mémoires caches

> [!question] Q5 : Quelles sont les 3 caractéristiques d'un CPU ?
> > [!success]- 🔓 Réponse
> > Jeu d'instructions, Fréquence, Taille des registres

> [!question] Q6 : Ordre des mémoires de la plus rapide à la plus lente ?
> > [!success]- 🔓 Réponse
> > Registres → L1 → L2 → L3 → RAM → SSD → HDD

> [!question] Q7 : Quelle est la différence entre L1, L2 et L3 ?
> > [!success]- 🔓 Réponse
> > L1 = plus rapide, plus petit, par cœur / L2 = moyen, par cœur / L3 = plus lent, plus grand, partagé

> [!question] Q8 : Taille typique du cache L1 ?
> > [!success]- 🔓 Réponse
> > ~10 kio par cœur

> [!question] Q9 : Le cache L3 est par cœur ou partagé ?
> > [!success]- 🔓 Réponse
> > Partagé entre tous les cœurs

> [!question] Q10 : Jeu d'instructions d'un PC classique ?
> > [!success]- 🔓 Réponse
> > x86-64

> [!question] Q11 : Jeu d'instructions d'un Raspberry Pi ?
> > [!success]- 🔓 Réponse
> > ARMv8

> [!question] Q12 : C'est quoi un ordinateur (définition) ?
> > [!success]- 🔓 Réponse
> > Machine électronique, numérique, programmable, qui fait des opérations arithmétiques