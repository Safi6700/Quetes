
---

## 🎯 L'ESSENTIEL (5 points)

1. **Disque → Partitions → Système de fichiers (FS)** : 1 partition = 1 FS
2. **ext4** = système de fichiers Linux principal (journalisation, compression, chiffrement)
3. **NTFS** = système de fichiers Windows (successeur de FAT, ACL avancées)
4. **/etc/fstab** = montages automatiques au démarrage (utiliser UUID)
5. **MBR** = max 4 partitions primaires, 2 To max | **GPT** = moderne, pas de limite

---

## 🔄 SCHÉMA DISQUE → PARTITION → FS

```js
┌─────────────────────────────────────────┐
│              DISQUE PHYSIQUE            │
├─────────────┬─────────────┬─────────────┤
│  Partition 1│  Partition 2│  Partition 3│
│    (sda1)   │    (sda2)   │    (sda3)   │
├─────────────┼─────────────┼─────────────┤
│    ext4     │    ext4     │    swap     │
│    (FS)     │    (FS)     │             │
└─────────────┴─────────────┴─────────────┘
```

---

## 📁 NOMENCLATURE LINUX

| Type | Chemin | Exemple |
|------|--------|---------|
| Disque SATA | `/dev/sdX` | /dev/sda, /dev/sdb |
| Partition SATA | `/dev/sdXP` | /dev/sda1, /dev/sda2 |
| Disque NVMe | `/dev/nvmeYnZ` | /dev/nvme0n1 |
| Partition NVMe | `/dev/nvmeYnZpP` | /dev/nvme0n1p1 |

⚠️ Un disque peut changer de nom au redémarrage → utiliser **UUID** !

---

## 🔧 COMMANDES LINUX

### Partitionnement
| Commande | Rôle |
|----------|------|
| `fdisk /dev/sdX` | Partitionner (CLI) - **exigé au checkpoint** |
| `cfdisk` | Partitionner (semi-graphique) |
| `parted` | Partitionner (avancé) |
| `gparted` | Partitionner (GUI) |

### Formatage
| Commande | Rôle |
|----------|------|
| `mkfs.ext4 /dev/sdX1` | Formater en ext4 |
| `mkswap /dev/sdX2` | Initialiser partition swap |
| `fsck` | Vérifier système de fichiers |
| `resize2fs` | Redimensionner |
| `e2label` | Changer étiquette |

### Montage
| Commande | Rôle |
|----------|------|
| `mount /dev/sda1 /mnt/data` | Monter partition |
| `umount /mnt/data` | Démonter |
| `blkid` | Voir UUID des partitions |

### Swap
| Commande | Rôle |
|----------|------|
| `swapon /dev/sdX` | Activer swap |
| `swapoff /dev/sdX` | Désactiver swap |
| `free` | Voir utilisation mémoire + swap |

---

## 📄 FICHIER /etc/fstab

```bash
# <périphérique>  <point montage>  <type>  <options>  <dump>  <pass>
UUID=9e35d3c3...  /                ext4    errors=remount-ro  0  1
UUID=df91b5ef...  /boot            ext4    defaults           0  2
UUID=2e80388d...  none             swap    sw                 0  0
```

**6 colonnes :**
1. Périphérique (UUID recommandé)
2. Point de montage
3. Type de FS (ext4, swap...)
4. Options
5. Dump (sauvegarde)
6. Pass (ordre vérification)

---

## 🪟 COMMANDES WINDOWS

| Commande/Outil | Rôle |
|----------------|------|
| `Diskpart` | Gestion disques/partitions (CLI) |
| `Format` | Formater une partition |
| `diskmgmt.msc` | Gestion de disques (GUI) |

---

## 📊 SYSTÈMES DE FICHIERS

| FS | OS | Caractéristiques |
|----|-----|------------------|
| **ext4** | Linux | Journalisation, compression, chiffrement, limite fragmentation |
| **NTFS** | Windows | ACL avancées, journalisation, compression, chiffrement |
| **FAT32** | Tous | Compatible partout, limite 4 Go/fichier |
| **swap** | Linux | Mémoire virtuelle |

---

## ⚠️ PIÈGE CLASSIQUE

> **Checkpoint : utiliser fdisk (pas cfdisk) et UUID (pas /dev/sdX)**
> 
> Dans `/etc/fstab`, toujours utiliser l'UUID :
> ```bash
> blkid  # pour trouver l'UUID
> ```
> ⚠️ Ne pas oublier de créer le dossier de montage avant !
> ```bash
> mkdir -p /mnt/data
> ```

---

## 📝 QUIZ CHECKPOINT

> [!question] Q1 : Commande pour partitionner un disque (exigée au checkpoint) ?
> > [!success]- 🔓 Réponse
> > `fdisk /dev/sdX`

> [!question] Q2 : Commande pour formater en ext4 ?
> > [!success]- 🔓 Réponse
> > `mkfs.ext4 /dev/sdX1`

> [!question] Q3 : Fichier pour le montage automatique au démarrage ?
> > [!success]- 🔓 Réponse
> > `/etc/fstab`

> [!question] Q4 : Commande pour voir l'UUID d'une partition ?
> > [!success]- 🔓 Réponse
> > `blkid`

> [!question] Q5 : Commande pour monter une partition ?
> > [!success]- 🔓 Réponse
> > `mount /dev/sdX1 /point/montage`

> [!question] Q6 : Commande pour initialiser une partition swap ?
> > [!success]- 🔓 Réponse
> > `mkswap /dev/sdX`

> [!question] Q7 : Commande pour activer le swap ?
> > [!success]- 🔓 Réponse
> > `swapon /dev/sdX`

> [!question] Q8 : Système de fichiers principal de Linux ?
> > [!success]- 🔓 Réponse
> > ext4

> [!question] Q9 : Système de fichiers principal de Windows ?
> > [!success]- 🔓 Réponse
> > NTFS

> [!question] Q10 : Combien de colonnes dans /etc/fstab ?
> > [!success]- 🔓 Réponse
> > 6 colonnes

> [!question] Q11 : Chemin d'un disque SATA sous Linux ?
> > [!success]- 🔓 Réponse
> > `/dev/sdX` (ex: /dev/sda)

> [!question] Q12 : Pourquoi utiliser UUID plutôt que /dev/sdX ?
> > [!success]- 🔓 Réponse
> > Car le nom du disque peut changer au redémarrage, l'UUID reste fixe

---
## 🎤 À retenir pour l'oral

> **Disque → Partitions → Système de fichiers** : 1 partition = 1 FS

> **ext4** = FS principal Linux (journalisation, compression, chiffrement)

> **NTFS** = FS principal Windows (ACL avancées, journalisation)

> **/etc/fstab** = montages automatiques au démarrage (6 colonnes, utiliser UUID)

> **UUID** : toujours utiliser UUID plutôt que /dev/sdX (le nom peut changer au redémarrage)

> **Commandes clés** : `fdisk` (partitionner) | `mkfs.ext4` (formater) | `mount` (monter) | `blkid` (voir UUID)

> **Swap** : `mkswap` (initialiser) | `swapon` (activer)

---

