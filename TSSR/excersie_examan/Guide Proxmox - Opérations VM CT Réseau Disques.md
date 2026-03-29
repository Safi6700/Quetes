# Guide Proxmox - Opérations VM / CT / Réseau / Disques

> **Catégorie :** Virtualisation | **Niveau :** Moyen à Avancé

---

## Sommaire

1. [Création de VM/CT selon consignes](#1--création-de-vmct)
2. [Déplacement de VM/CT sur un autre noeud](#2--déplacement-de-vmct-sur-un-autre-noeud)
3. [Snapshot de VM/CT](#3--snapshot-de-vmct)
4. [Revenir sur un snapshot antérieur](#4--revenir-sur-un-snapshot-antérieur)
5. [Clone de VM/CT](#5--clone-de-vmct)
6. [Ajouter un disque dur à une VM](#6--ajouter-un-disque-dur-à-une-vm)
7. [Modifier les interfaces réseaux de VM/CT](#7--modifier-les-interfaces-réseaux-de-vmct)
8. [Démarrage automatique de VM après démarrage du noeud](#8--démarrage-automatique-de-vm)
9. [Protection contre la suppression de VM](#9--protection-contre-la-suppression-de-vm)
10. [Backup d'une VM](#10--backup-dune-vm)
11. [Détacher un disque dur de VM](#11--détacher-un-disque-dur-de-vm)
12. [Attacher un disque "mis de côté"](#12--attacher-un-disque-mis-de-côté)
13. [Créer une carte réseau sur le noeud avec une plage IP](#13--créer-une-carte-réseau-sur-le-noeud)
14. [Modifier l'ordre de démarrage d'un disque dur](#14--modifier-lordre-de-démarrage-dun-disque-dur)

---

## 1 — Création de VM/CT

### Créer une VM (Machine Virtuelle)

#### Via l'interface web

1. Connecte-toi à `https://@IP:8006/`
2. Clique sur **Create VM** (bouton bleu en haut à droite)
3. Remplis les onglets :

| Onglet | Paramètre | Exemple |
|---|---|---|
| **General** | Node | `pve` |
| | VM ID | `100` (auto-incrémenté) |
| | Name | `debian12-srv` |
| **OS** | ISO Image | Sélectionne ton ISO uploadée |
| **System** | Machine | `q35` (recommandé) |
| | BIOS | `OVMF (UEFI)` ou `SeaBIOS` |
| **Disks** | Bus/Device | `SCSI` (recommandé) |
| | Storage | Ton espace de stockage VM |
| | Disk size | `20` (en GiB) |
| | Format | `qcow2` ou `raw` |
| **CPU** | Cores | `2` |
| **Memory** | Memory (MiB) | `2048` |
| **Network** | Bridge | `vmbr0` |
| | Model | `VirtIO` (meilleure performance) |

4. Clique sur **Finish**

#### Via la CLI

```bash
# Je crée une VM avec l'ID 100
qm create 100 \
  --name debian12-srv \
  --memory 2048 \
  --cores 2 \
  --net0 virtio,bridge=vmbr0 \
  --scsihw virtio-scsi-pci \
  --scsi0 local-lvm:20 \
  --cdrom local:iso/debian-12.iso \
  --boot order=scsi0;ide2
```

---

### Créer un CT (Conteneur LXC)

#### Via l'interface web

1. Clique sur **Create CT** (bouton en haut à droite)
2. Remplis les onglets :

| Onglet | Paramètre | Exemple |
|---|---|---|
| **General** | Hostname | `ct-debian` |
| | Password | Mot de passe root |
| | Unprivileged | Coché (recommandé) |
| **Template** | Storage | Disque contenant les templates |
| | Template | `debian-12-standard_12.2-1_amd64.tar.zst` |
| **Disks** | Storage | Espace de stockage CT |
| | Disk size | `8` (GiB) |
| **CPU** | Cores | `1` |
| **Memory** | Memory (MiB) | `512` |
| **Network** | Name | `eth0` |
| | Bridge | `vmbr0` |
| | IPv4 | `DHCP` ou `Static` |

3. Clique sur **Finish**

#### Via la CLI

```bash
# Je crée un conteneur avec l'ID 200
pct create 200 local:vztmpl/debian-12-standard_12.2-1_amd64.tar.zst \
  --hostname ct-debian \
  --memory 512 \
  --cores 1 \
  --net0 name=eth0,bridge=vmbr0,ip=dhcp \
  --storage local-lvm \
  --rootfs local-lvm:8 \
  --password
```

> [!tip] Télécharger un template
> **GUI :** Sélectionne un stockage → **CT Templates** → **Templates** → Choisis et télécharge
> **CLI :**
> ```bash
> pveam update
> pveam available | grep debian
> pveam download local debian-12-standard_12.2-1_amd64.tar.zst
> ```

---

## 2 — Déplacement de VM/CT sur un autre noeud

> [!warning] Prérequis
> Tu dois avoir un **cluster Proxmox** avec au moins 2 noeuds et un **stockage partagé** (NFS, Ceph, iSCSI...) ou utiliser la migration locale.

### Via l'interface web

1. Clic droit sur la VM/CT dans le panneau de gauche
2. Clique sur **Migrate**
3. Choisis le **noeud cible**
4. Choisis le type de migration :
   - **Online** : la VM reste allumée pendant la migration (live migration)
   - **Offline** : la VM est éteinte avant la migration
5. Clique sur **Migrate**

### Via la CLI

```bash
# Je migre la VM 100 vers le noeud pve2 (en ligne)
qm migrate 100 pve2 --online

# Je migre le CT 200 vers le noeud pve2
pct migrate 200 pve2
```

> [!note] Stockage local
> Si tu n'as pas de stockage partagé, coche **With local disks** dans l'assistant de migration. Proxmox copiera les disques via le réseau.

---

## 3 — Snapshot de VM/CT

Un snapshot sauvegarde l'état complet de la VM/CT (disques, RAM, configuration) à un instant T.

### Via l'interface web

1. Sélectionne ta VM/CT dans le panneau de gauche
2. Va dans l'onglet **Snapshots**
3. Clique sur **Take Snapshot**
4. Remplis :
   - **Name** : `avant-mise-a-jour` (pas d'espaces)
   - **Description** : `Snapshot avant la mise à jour du 22/03/2026`
   - **Include RAM** : coche si tu veux sauvegarder l'état de la mémoire (VM allumée)
5. Clique sur **Take Snapshot**

### Via la CLI

```bash
# Je fais un snapshot de la VM 100 avec la RAM
qm snapshot 100 avant-mise-a-jour --description "Snapshot avant mise a jour" --vmstate

# Je fais un snapshot du CT 200 (pas de RAM pour les CT)
pct snapshot 200 avant-mise-a-jour --description "Snapshot avant mise a jour"
```

> [!note]
> Pour lister les snapshots existants :
> ```bash
> qm listsnapshot 100
> pct listsnapshot 200
> ```

---

## 4 — Revenir sur un snapshot antérieur

### Via l'interface web

1. Sélectionne ta VM/CT
2. Va dans l'onglet **Snapshots**
3. Sélectionne le snapshot voulu
4. Clique sur **Rollback**
5. Confirme

> [!warning] Attention
> Le rollback **supprime toutes les modifications** faites depuis ce snapshot. La VM/CT sera **arrêtée** avant le rollback.

### Via la CLI

```bash
# Je reviens au snapshot "avant-mise-a-jour" sur la VM 100
qm rollback 100 avant-mise-a-jour

# Je reviens au snapshot sur le CT 200
pct rollback 200 avant-mise-a-jour
```

**Supprimer un snapshot :**

```bash
# Je supprime un snapshot de la VM 100
qm delsnapshot 100 avant-mise-a-jour

# Je supprime un snapshot du CT 200
pct delsnapshot 200 avant-mise-a-jour
```

---

## 5 — Clone de VM/CT

Le clonage crée une copie complète d'une VM/CT.

### Via l'interface web

1. Clic droit sur la VM/CT
2. Clique sur **Clone**
3. Remplis :

| Paramètre | Description |
|---|---|
| **Target node** | Noeud de destination |
| **VM ID** | ID de la nouvelle VM |
| **Name** | Nom du clone |
| **Mode** | **Full Clone** (copie indépendante) ou **Linked Clone** (dépend de l'original) |
| **Target Storage** | Stockage de destination |

4. Clique sur **Clone**

### Via la CLI

```bash
# Je fais un clone complet de la VM 100 vers la VM 101
qm clone 100 101 --name clone-debian --full

# Je fais un clone du CT 200 vers le CT 201
pct clone 200 201 --hostname clone-ct --full
```

> [!tip] Full Clone vs Linked Clone
> - **Full Clone** : copie indépendante, prend plus de place mais autonome
> - **Linked Clone** : plus rapide et léger, mais dépend du disque d'origine (ne pas supprimer l'original)

---

## 6 — Ajouter un disque dur à une VM

### Via l'interface web

1. Sélectionne ta VM (elle doit être **éteinte**)
2. Va dans **Hardware**
3. Clique sur **Add → Hard Disk**
4. Configure :

| Paramètre | Valeur |
|---|---|
| **Bus/Device** | SCSI (recommandé) ou SATA |
| **Storage** | Ton espace de stockage |
| **Disk size (GiB)** | Taille souhaitée |
| **Format** | `qcow2` ou `raw` |

5. Clique sur **Add**

### Via la CLI

```bash
# J'ajoute un disque de 50 Go sur le bus SCSI à la VM 100
qm set 100 --scsi1 local-lvm:50
```

> [!warning] Attention dans la VM
> Le disque est ajouté côté hyperviseur, mais dans la VM il faut encore le **partitionner**, **formater** et **monter** :
> ```bash
> fdisk /dev/sdb
> mkfs.ext4 /dev/sdb1
> mkdir -p /mnt/data
> mount /dev/sdb1 /mnt/data
> ```
> Et ajouter dans `/etc/fstab` pour le montage automatique (utilise l'UUID avec `blkid`).

---

## 7 — Modifier les interfaces réseaux de VM/CT

### Pour une VM

#### Via l'interface web

1. Sélectionne ta VM
2. Va dans **Hardware**
3. Double-clique sur l'interface réseau existante (ex: `net0`) pour la **modifier**, ou clique sur **Add → Network Device** pour en **ajouter** une
4. Configure :

| Paramètre | Description |
|---|---|
| **Bridge** | `vmbr0`, `vmbr1`... (pont réseau du noeud) |
| **Model** | `VirtIO` (meilleure perf) ou `E1000` |
| **VLAN Tag** | Optionnel, pour isoler le trafic |
| **Firewall** | Cocher pour activer le firewall Proxmox |
| **MAC address** | Laisse auto ou personnalise |

5. Clique sur **OK**

#### Via la CLI

```bash
# Je modifie l'interface net0 de la VM 100
qm set 100 --net0 virtio,bridge=vmbr1,tag=10

# J'ajoute une 2ème interface net1
qm set 100 --net1 virtio,bridge=vmbr2
```

---

### Pour un CT

#### Via l'interface web

1. Sélectionne ton CT
2. Va dans **Network**
3. Double-clique sur l'interface existante ou clique sur **Add**
4. Configure :

| Paramètre | Description |
|---|---|
| **Name** | `eth0`, `eth1`... |
| **Bridge** | `vmbr0`, `vmbr1`... |
| **IPv4** | `Static` ou `DHCP` |
| **IPv4/CIDR** | Ex: `192.168.1.50/24` |
| **Gateway** | Ex: `192.168.1.1` |
| **IPv6** | `Static`, `DHCP`, ou `SLAAC` |

5. Clique sur **OK**

#### Via la CLI

```bash
# Je modifie l'interface eth0 du CT 200
pct set 200 --net0 name=eth0,bridge=vmbr0,ip=192.168.1.50/24,gw=192.168.1.1

# J'ajoute une 2ème interface eth1
pct set 200 --net1 name=eth1,bridge=vmbr1,ip=10.10.10.50/24
```

---

## 8 — Démarrage automatique de VM

Configure une VM pour qu'elle démarre automatiquement quand le noeud Proxmox redémarre.

### Via l'interface web

1. Sélectionne ta VM/CT
2. Va dans **Options**
3. Double-clique sur **Start at boot**
4. Coche **Yes**
5. Clique sur **OK**

**Configurer l'ordre de démarrage (optionnel) :**

6. Double-clique sur **Start/Shutdown order**
7. Configure :

| Paramètre | Description |
|---|---|
| **Start order** | Numéro d'ordre (1 = démarre en premier) |
| **Startup delay** | Délai en secondes avant de démarrer la VM suivante |
| **Shutdown timeout** | Temps max en secondes pour l'arrêt propre |

### Via la CLI

```bash
# J'active le démarrage auto de la VM 100
qm set 100 --onboot 1

# Je configure l'ordre : démarrage en 1er, délai 30s, timeout 60s
qm set 100 --startup order=1,up=30,down=60

# J'active le démarrage auto du CT 200 avec un ordre de 2
pct set 200 --onboot 1
pct set 200 --startup order=2,up=15,down=60
```

---

## 9 — Protection contre la suppression de VM

Empêche la suppression accidentelle d'une VM/CT.

### Via l'interface web

1. Sélectionne ta VM/CT
2. Va dans **Options**
3. Double-clique sur **Protection**
4. Coche **Yes**
5. Clique sur **OK**

### Via la CLI

```bash
# J'active la protection sur la VM 100
qm set 100 --protection 1

# J'active la protection sur le CT 200
pct set 200 --protection 1
```

> [!note]
> Quand la protection est activée :
> - Impossible de **supprimer** la VM/CT
> - Impossible de **supprimer les disques** de la VM
> - Il faut **désactiver** la protection avant de pouvoir supprimer

**Désactiver la protection :**

```bash
qm set 100 --protection 0
pct set 200 --protection 0
```

---

## 10 — Backup d'une VM

### Via l'interface web (backup ponctuel)

1. Sélectionne ta VM/CT
2. Va dans **Backup**
3. Clique sur **Backup now**
4. Configure :

| Paramètre | Description |
|---|---|
| **Storage** | Espace de stockage pour les backups |
| **Mode** | `Snapshot` (VM allumée), `Suspend`, ou `Stop` |
| **Compression** | `ZSTD` (recommandé) ou `LZO` ou `GZIP` |

5. Clique sur **Backup**

### Via la CLI

```bash
# Je fais un backup de la VM 100 en mode snapshot avec compression zstd
vzdump 100 --storage local --mode snapshot --compress zstd

# Je fais un backup du CT 200
vzdump 200 --storage local --mode snapshot --compress zstd
```

### Programmer un backup automatique

#### Via l'interface web

1. Va dans **Datacenter → Backup**
2. Clique sur **Add**
3. Configure :

| Paramètre | Exemple |
|---|---|
| **Node** | Tous ou un noeud spécifique |
| **Storage** | `local` |
| **Schedule** | `Tous les jours à 02:00` |
| **Selection mode** | `Include` puis sélectionne les VM/CT |
| **Mode** | `Snapshot` |
| **Compression** | `ZSTD` |
| **Retention** | Keep Last = `3` (garde les 3 derniers backups) |

> [!tip] Restaurer un backup
> **GUI :** Sélectionne la VM/CT → **Backup** → Sélectionne le backup → **Restore**
> **CLI :**
> ```bash
> qmrestore /var/lib/vz/dump/vzdump-qemu-100-*.vma.zst 100
> pct restore 200 /var/lib/vz/dump/vzdump-lxc-200-*.tar.zst
> ```

---

## 11 — Détacher un disque dur de VM

Détacher un disque le retire de la VM sans le supprimer. Il reste disponible comme "disque inutilisé".

### Via l'interface web

1. Sélectionne ta VM (**éteinte**)
2. Va dans **Hardware**
3. Sélectionne le disque à détacher (ex: `scsi1`)
4. Clique sur **Detach**
5. Confirme

Le disque apparaît maintenant comme **Unused Disk 0** dans la liste Hardware.

### Via la CLI

```bash
# Je détache le disque scsi1 de la VM 100
qm set 100 --delete scsi1
```

> [!note]
> Le disque n'est pas supprimé, il est listé comme disque inutilisé. Pour le **supprimer définitivement**, sélectionne le **Unused Disk** et clique sur **Remove**.

---

## 12 — Attacher un disque "mis de côté"

Réattache un disque précédemment détaché.

### Via l'interface web

1. Sélectionne ta VM (**éteinte**)
2. Va dans **Hardware**
3. Tu vois le disque listé comme **Unused Disk 0** (ou 1, 2...)
4. Double-clique dessus (ou sélectionne + **Edit**)
5. Choisis le **Bus/Device** (SCSI, SATA, IDE, VirtIO)
6. Clique sur **Add**

Le disque est de nouveau attaché et utilisable par la VM.

### Via la CLI

```bash
# Je liste les disques inutilisés de la VM 100
qm config 100 | grep unused

# Je rattache le disque unused0 sur le bus scsi1
qm set 100 --scsi1 local-lvm:vm-100-disk-2
```

---

## 13 — Créer une carte réseau sur le noeud

Crée un nouveau **bridge** (pont réseau) avec sa propre plage d'adresses IP.

### Via l'interface web

1. Sélectionne **pve** dans le panneau de gauche
2. Va dans **System → Network**
3. Clique sur **Create → Linux Bridge**
4. Configure :

| Paramètre | Exemple |
|---|---|
| **Name** | `vmbr1` |
| **IPv4/CIDR** | `10.10.10.1/24` |
| **IPv6/CIDR** | Optionnel |
| **Bridge ports** | Vide (réseau interne isolé) ou `enp0s8` (interface physique) |
| **Comment** | `Réseau interne LAB` |

5. Clique sur **Create**
6. Clique sur **Apply Configuration** (en haut)

### Via la CLI

Édite le fichier `/etc/network/interfaces` :

```bash
nano /etc/network/interfaces
```

Ajoute le bloc suivant :

```bash
# Je crée un bridge pour le réseau interne
auto vmbr1
iface vmbr1 inet static
    address 10.10.10.1/24
    bridge-ports none
    bridge-stp off
    bridge-fd 0
    post-up echo 1 > /proc/sys/net/ipv4/ip_forward
```

Puis applique :

```bash
ifreload -a
```

> [!note] Bridge ports
> - `bridge-ports none` = réseau **isolé** (seules les VM/CT sur ce bridge communiquent entre elles)
> - `bridge-ports enp0s8` = le bridge est lié à une **interface physique** (accès au réseau externe)

> [!tip] Activer le routage entre les bridges
> Si tu veux que les VM sur `vmbr1` puissent communiquer avec celles sur `vmbr0`, active le forwarding IP :
> ```bash
> echo 1 > /proc/sys/net/ipv4/ip_forward
> ```
> Et ajoute une règle NAT si nécessaire :
> ```bash
> iptables -t nat -A POSTROUTING -s 10.10.10.0/24 -o vmbr0 -j MASQUERADE
> ```

---

## 14 — Modifier l'ordre de démarrage d'un disque dur

Configure l'ordre dans lequel les disques sont utilisés au démarrage de la VM.

### Via l'interface web

1. Sélectionne ta VM
2. Va dans **Options**
3. Double-clique sur **Boot Order**
4. Tu vois la liste des périphériques de démarrage :
   - `scsi0` (disque dur principal)
   - `ide2` (lecteur CD/DVD)
   - `net0` (boot PXE réseau)
   - Autres disques...
5. **Active/Désactive** les périphériques avec la case à cocher
6. **Glisse-dépose** pour réorganiser l'ordre
7. Clique sur **OK**

### Via la CLI

```bash
# Je configure l'ordre de boot : d'abord scsi0 puis ide2
qm set 100 --boot order=scsi0;ide2

# Je configure : d'abord le CD (pour installer un OS), puis le disque
qm set 100 --boot order=ide2;scsi0

# Je configure : boot PXE d'abord, puis disque
qm set 100 --boot order=net0;scsi0
```

> [!tip] Cas d'usage courants
> - **Installation d'un OS** : mets le CD/DVD (`ide2`) en premier, puis après l'installation remets le disque dur (`scsi0`) en premier
> - **Boot PXE** : mets `net0` en premier pour démarrer depuis le réseau (déploiement automatisé)
> - **Multi-disques** : mets le disque contenant le système en premier (`scsi0` avant `scsi1`)

---

## Récapitulatif des commandes

| Action | Commande VM (`qm`) | Commande CT (`pct`) |
|---|---|---|
| Créer | `qm create <ID>` | `pct create <ID>` |
| Démarrer | `qm start <ID>` | `pct start <ID>` |
| Arrêter | `qm shutdown <ID>` | `pct shutdown <ID>` |
| Forcer l'arrêt | `qm stop <ID>` | `pct stop <ID>` |
| Snapshot | `qm snapshot <ID> <nom>` | `pct snapshot <ID> <nom>` |
| Rollback | `qm rollback <ID> <nom>` | `pct rollback <ID> <nom>` |
| Clone | `qm clone <ID> <newID>` | `pct clone <ID> <newID>` |
| Migrer | `qm migrate <ID> <noeud>` | `pct migrate <ID> <noeud>` |
| Backup | `vzdump <ID>` | `vzdump <ID>` |
| Config | `qm config <ID>` | `pct config <ID>` |
| Modifier | `qm set <ID> --param val` | `pct set <ID> --param val` |
| Supprimer | `qm destroy <ID>` | `pct destroy <ID>` |
