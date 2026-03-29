# 🐧 Atelier : Gestion avancée de LVM

|Difficulté|Durée|Validation|
|---|---|---|
|Moyen|1h|Auto-validation|

---

## 🤓 Objectifs

- ✅ Manipuler des PV, VG, et LV
- ✅ Effectuer des actions avancées sur LVM

---

## 📋 Sommaire

1. [Étape 1 - Prérequis](https://claude.ai/chat/c1c166ac-be2e-4bc8-b3cf-f5c8245d3be6#%C3%A9tape-1---pr%C3%A9requis)
2. [Étape 2 - Initialisation et création des LV](https://claude.ai/chat/c1c166ac-be2e-4bc8-b3cf-f5c8245d3be6#%C3%A9tape-2---initialisation-et-cr%C3%A9ation-des-lv)
3. [Étape 3 - Formatage et montage de FS](https://claude.ai/chat/c1c166ac-be2e-4bc8-b3cf-f5c8245d3be6#%C3%A9tape-3---formatage-et-montage-de-fs)
4. [Étape 4 - Étendre le LV](https://claude.ai/chat/c1c166ac-be2e-4bc8-b3cf-f5c8245d3be6#%C3%A9tape-4---%C3%A9tendre-le-lv)
5. [Étape 5 - Ajout d'un disque au PV existant](https://claude.ai/chat/c1c166ac-be2e-4bc8-b3cf-f5c8245d3be6#%C3%A9tape-5---ajout-dun-disque-au-pv-existant)
6. [Étape 6 - Création d'un snapshot](https://claude.ai/chat/c1c166ac-be2e-4bc8-b3cf-f5c8245d3be6#%C3%A9tape-6---cr%C3%A9ation-dun-snapshot)
7. [Étape 7 - Redimensionnement d'un LV](https://claude.ai/chat/c1c166ac-be2e-4bc8-b3cf-f5c8245d3be6#%C3%A9tape-7---redimensionnement-dun-lv)

---

## ✔️ Étape 1 - Prérequis

### Matériel requis

|Élément|Spécification|
|---|---|
|Hyperviseur|VirtualBox|
|VM|Debian 12 installé et mis à jour|
|Disque 1|10 Go|
|Disque 2|20 Go|
|Disque 3|25 Go|

### Partitionnement pendant l'installation de Debian

> Choisir l'option **"Manuel"** lors de l'étape de partitionnement.

|Partition|Taille|Point de montage|
|---|---|---|
|Système|8 Go|`/`|
|Swap|≥ RAM de la VM|-|
|/home|Reste de l'espace|`/home`|

### Environnement de test

```
Testé avec : Debian 12
Hyperviseur : VirtualBox 7
Hôte : Ubuntu 22.04 LTS
```

---

## 🔬 Étape 2 - Initialisation et création des LV

> **Disques utilisés :** 10 Go et 20 Go

### 2.1 Vérifier l'installation de LVM

```bash
lvm version
```

ou

```bash
apt list --installed lvm2
```

### 2.2 Installer LVM (si nécessaire)

```bash
sudo apt install lvm2
```

### 2.3 Procédure d'initialisation

|Étape|Action|Commande|
|---|---|---|
|1|Identifier les disques non-système|`fdisk -l`|
|2|Initialiser le disque 1 pour LVM|`pvcreate /dev/sdb`|
|3|Initialiser le disque 2 pour LVM|`pvcreate /dev/sdc`|
|4|Créer le groupe de volumes|`vgcreate vg_datas /dev/sdb /dev/sdc`|
|5|Vérifier la création du VG|`vgdisplay`|

### 2.4 Créer le volume logique

```bash
lvcreate -L 25G -n lv_datas vg_datas
```

|Option|Description|
|---|---|
|`-L 25G`|Spécifie la taille du volume logique (25 Go)|
|`-n lv_datas`|Définit le nom du volume logique|
|`vg_datas`|Groupe de volumes cible|

### 2.5 Vérification

```bash
lvdisplay
```

> **Validation :** LV Size doit afficher la taille choisie.

> [!question]- 🧪 Test : Créer un LV de 35 Go Essaye de créer un volume logique de 35 Go et observe le résultat.
> 
> ```bash
> lvcreate -L 35G -n test_lv vg_datas
> ```

---

## 🔬 Étape 3 - Formatage et montage de FS

### 3.1 Formater le volume logique

```bash
mkfs.ext4 /dev/vg_datas/lv_datas
```

### 3.2 Créer le point de montage

```bash
mkdir /mnt/datas
```

### 3.3 Monter le volume logique

```bash
mount /dev/vg_datas/lv_datas /mnt/datas
```

### 3.4 Montage automatique au démarrage

Ajouter dans `/etc/fstab` :

```
/dev/vg_datas/lv_datas /mnt/datas ext4 defaults 0 2
```

---

## 🔬 Étape 4 - Étendre le LV

### 4.1 Vérifier l'espace disponible

```bash
vgs
```

### 4.2 Étendre le LV avec tout l'espace restant

```bash
lvextend -l +100%FREE /dev/vg_datas/lv_datas
```

### 4.3 Étendre le système de fichiers

```bash
resize2fs /dev/vg_datas/lv_datas
```

### 4.4 Vérification

```bash
lvs
```

---

## 🔬 Étape 5 - Ajout d'un disque au PV existant

> **Disque utilisé :** 25 Go (`/dev/sdd`)

### 5.1 Initialiser le nouveau disque

```bash
pvcreate /dev/sdd
```

### 5.2 Ajouter au VG existant

```bash
vgextend vg_datas /dev/sdd
```

### 5.3 Vérifier l'ajout

```bash
vgs
```

> **Validation :** VFree doit correspondre à la taille du disque ajouté.

### 5.4 Créer un nouveau LV

```bash
lvcreate -L 15G -n lv_datas2 vg_datas
```

### 5.5 Formater et monter

```bash
mkfs.ext4 /dev/vg_datas/lv_datas2
mkdir /mnt/datas2
mount /dev/vg_datas/lv_datas2 /mnt/datas2
```

### 5.6 Montage automatique

Ajouter dans `/etc/fstab` :

```
/dev/vg_datas/lv_datas2 /mnt/datas2 ext4 defaults 0 2
```

---

## 🔬 Étape 6 - Création d'un snapshot

### 6.1 Créer un fichier de test

```bash
echo "Contenu avant création du snapshot !" > /mnt/datas2/test_file.txt
```

### 6.2 Créer le snapshot

```bash
lvcreate --size 5G --snapshot --name lv_datas_snap /dev/vg_datas/lv_datas2
```

### 6.3 Monter le snapshot

```bash
mkdir /mnt/datas_snap
mount /dev/vg_datas/lv_datas_snap /mnt/datas_snap/
```

### 6.4 Vérifier le contenu

```bash
ls /mnt/datas2
ls /mnt/datas_snap
```

> **Validation :** Le contenu de `datas_snap` est identique à celui de `lv_datas2`.

### 6.5 Test d'indépendance

```bash
echo "Après création du snapshot" > /mnt/datas2/test_file1.txt
```

> Vérifier si ce fichier apparaît dans le snapshot ou s'il est indépendant.

### 6.6 Supprimer le snapshot

```bash
umount /mnt/datas_snap
lvremove /dev/vg_datas/lv_datas_snap
```

---

## 🔬 Étape 7 - Redimensionnement d'un LV

> ⚠️ **Attention :** Avant de redimensionner, vérifier l'intégrité avec `e2fsck`.

### 7.1 Démonter le LV

```bash
umount /mnt/datas
```

### 7.2 Redimensionner le LV à 15 Go (MAUVAISE MÉTHODE)

```bash
lvresize -L 15G /dev/vg_datas/lv_datas
```

> ⚠️ Un message d'alerte prévient que les données et le FS peuvent être détruits.

### 7.3 Tentative de redimensionnement du FS

```bash
resize2fs /dev/vg_datas/lv_datas
```

> ❌ **Échec :** La taille du FS dépasse la taille physique du LV.

### 7.4 Procédure correcte de réduction

| Étape | Action                             | Commande                                    |
| ----- | ---------------------------------- | ------------------------------------------- |
| 1     | Revenir à la taille initiale du LV | `lvresize -L 29.99G /dev/vg_datas/lv_datas` |
| 2     | Réparer le FS                      | `e2fsck -f /dev/vg_datas/lv_datas`          |
| 3     | Réduire le FS                      | `resize2fs /dev/vg_datas/lv_datas 15G`      |
| 4     | Réduire le LV                      | `lvresize -L 15G /dev/vg_datas/lv_datas`    |
| 5     | Vérifier l'opération               | `e2fsck -f /dev/vg_datas/lv_datas`          |

> ⚠️ **Important :** Toujours réduire le FS **AVANT** de réduire le LV !

---

## 📊 Récapitulatif des commandes LVM

|Catégorie|Commande|Description|
|---|---|---|
|**PV**|`pvcreate`|Initialiser un disque pour LVM|
|**VG**|`vgcreate`|Créer un groupe de volumes|
|**VG**|`vgextend`|Ajouter un disque au VG|
|**VG**|`vgdisplay`|Afficher les infos du VG|
|**VG**|`vgs`|Liste résumée des VG|
|**LV**|`lvcreate`|Créer un volume logique|
|**LV**|`lvextend`|Étendre un LV|
|**LV**|`lvresize`|Redimensionner un LV|
|**LV**|`lvdisplay`|Afficher les infos du LV|
|**LV**|`lvs`|Liste résumée des LV|
|**LV**|`lvremove`|Supprimer un LV|
|**FS**|`mkfs.ext4`|Formater en ext4|
|**FS**|`resize2fs`|Redimensionner le FS|
|**FS**|`e2fsck -f`|Vérifier/réparer le FS|

---

## ✅ Validation de l'atelier

L'atelier est validé si tu as réussi à :

- [ ] Créer des PV avec `pvcreate`
- [ ] Créer un VG avec `vgcreate`
- [ ] Créer des LV avec `lvcreate`
- [ ] Formater et monter les LV
- [ ] Étendre un LV
- [ ] Ajouter un disque au VG
- [ ] Créer et supprimer un snapshot
- [ ] Redimensionner un LV correctement