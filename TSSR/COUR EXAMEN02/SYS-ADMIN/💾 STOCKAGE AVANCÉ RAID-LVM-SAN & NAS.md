
---

## 🎯 L'essentiel (définitions courtes à apprendre)

1. **RAID** = technique pour combiner plusieurs disques en un seul volume (performance et/ou fiabilité)

2. **LVM** = couche logicielle pour gérer le stockage de façon **flexible** (redimensionner sans tout casser)

3. **NAS** = serveur de fichiers accessible via le **réseau** (NFS, SMB)

4. **SAN** = réseau dédié au stockage (accès bas niveau aux disques, iSCSI, Fibre Channel)

5. **Hot spare** = disque de secours pour reconstruction automatique en cas de panne

---

## 📋 Niveaux RAID (IMPORTANT)

| RAID | Principe | Disques min | Tolérance panne | Capacité |
|------|----------|-------------|-----------------|----------|
| **RAID 0** | Striping (performance) | 2 | ❌ Aucune | n × disque |
| **RAID 1** | Miroir (fiabilité) | 2 | ✅ n-1 pannes | 1 × disque |
| **RAID 5** | Parité répartie | 3 | ✅ 1 panne | (n-1) × disque |
| **RAID 6** | Double parité | 4 | ✅ 2 pannes | (n-2) × disque |
| **RAID 10** | Miroir + Striping | 4 | ✅ 1 par grappe | n/2 × disque |

---

## 🔑 RAID à retenir

| Si tu veux... | Utilise |
|---------------|---------|
| **Performance** (pas de sécu) | RAID 0 |
| **Fiabilité max** | RAID 1 |
| **Compromis perf + fiabilité** | RAID 5 |
| **Tolérer 2 pannes** | RAID 6 |
| **Performance + fiabilité** | RAID 10 |

---

## 🔄 LVM (Logical Volume Manager)

| Terme | C'est quoi |
|-------|------------|
| **PV** (Physical Volume) | Disque ou partition physique |
| **VG** (Volume Group) | Groupe de PV |
| **LV** (Logical Volume) | "Partition" logique dans un VG |

**Architecture** : PV → VG → LV → Système de fichiers

**Avantage** : Agrandir/réduire les volumes **à chaud** sans reformater

---

## 🔧 Commandes LVM

| Commande                           | Usage                  |
| ---------------------------------- | ---------------------- |
| `pvcreate /dev/sdb`                | Créer un PV            |
| `vgcreate monvg /dev/sdb`          | Créer un VG            |
| `lvcreate -L 10G -n monlv monvg`   | Créer un LV de 10 Go   |
| `lvextend -L +5G /dev/monvg/monlv` | Agrandir le LV de 5 Go |
| `pvs`, `vgs`, `lvs`                | Afficher PV, VG, LV    |

---

## 🌐 NAS vs SAN

|               | NAS              | SAN                  |
| ------------- | ---------------- | -------------------- |
| **Niveau**    | Fichiers         | Blocs (bas niveau)   |
| **Protocole** | NFS, SMB         | iSCSI, Fibre Channel |
| **Usage**     | Partage fichiers | VM, bases de données |
| **Réseau**    | LAN classique    | Réseau dédié         |
|               |                  |                      |

---

## ⚠️ Piège classique

> **RAID ≠ Sauvegarde**
> - RAID protège contre la **panne disque**
> - Mais PAS contre : suppression accidentelle, virus, incendie...
> → Il faut **toujours** des sauvegardes en plus !

---

## ✅ Checkpoint examen

**Ce que le jury peut demander :**
- Expliquer les niveaux RAID (0, 1, 5, 6, 10)
- Différence NAS / SAN
- Avantages de LVM
- Pourquoi RAID ne remplace pas la sauvegarde

---

## 📝 QUIZ Checkpoint

### Question 1
**C'est quoi RAID ?**
> [!success]- 🔓 Réponse
> Technique pour combiner plusieurs disques : **performance** (RAID 0) et/ou **fiabilité** (RAID 1, 5, 6).

---

### Question 2
**Différence RAID 0 et RAID 1 ?**
> [!success]- 🔓 Réponse
> - **RAID 0** = striping, performance, **aucune** tolérance panne
> - **RAID 1** = miroir, fiabilité, tolère n-1 pannes

---

### Question 3
**Combien de disques minimum pour RAID 5 ?**
> [!success]- 🔓 Réponse
> **3 disques** minimum (tolère 1 panne).

---

### Question 4
**C'est quoi LVM ?**
> [!success]- 🔓 Réponse
> Couche logicielle pour gérer le stockage de façon **flexible** : PV → VG → LV.
> Permet d'agrandir les volumes à chaud.

---

### Question 5
**Différence NAS et SAN ?**
> [!success]- 🔓 Réponse
> - **NAS** = partage de **fichiers** (NFS, SMB)
> - **SAN** = accès aux **blocs** (iSCSI), réseau dédié

---

### Question 6
**RAID remplace-t-il les sauvegardes ?**
> [!success]- 🔓 Réponse
> **NON !** RAID protège contre la panne disque, pas contre suppression, virus ou incendie.

---

### Question 7
**Quel RAID pour tolérer 2 pannes ?**
> [!success]- 🔓 Réponse
> **RAID 6** (double parité, 4 disques minimum).

---

## 🎤 À retenir pour l'oral

> **RAID 0** = performance, pas de sécu / **RAID 1** = miroir, fiabilité max

> **RAID 5** = parité, tolère 1 panne (3 disques min)

> **LVM** = PV → VG → LV (flexible, agrandir à chaud)

> **NAS** = fichiers (NFS/SMB) / **SAN** = blocs (iSCSI)

> **RAID ≠ Sauvegarde** (toujours faire des backups !)

---