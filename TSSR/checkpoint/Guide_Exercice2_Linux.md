us# Guide Complet - Exercice 2 : Manipulations pratiques sur VM Linux

## Partie 1 : Gestion des utilisateurs

### Q.2.1.1 Sur le serveur, créer un compte pour ton usage personnel

**Commande :**
```bash
useradd -m -s /bin/bash arno
passwd arno
```

**Explications :**
- `useradd` : Commande pour créer un utilisateur
- `-m` : Crée le répertoire personnel de l'utilisateur
- `-s /bin/bash` : Définit le shell par défaut
- `passwd arno` : Définit le mot de passe pour l'utilisateur

**Vérification :**
```bash
# Vérifier que l'utilisateur a été créé
cat /etc/passwd | grep arno

# Vérifier le mot de passe
root@SRVLX01:~# su - arno
arno@SRVLX01:~$
```

**Exemple de sortie attendue :**
```
root@SRVLX01:~# useradd -m -s /bin/bash arno
root@SRVLX01:~# passwd arno
Nouveau mot de passe :
Retapez le nouveau mot de passe :
passwd: password updated successfully
```

---

### Q.2.1.2 Quelles préconisations proposes-tu concernant ce compte ?

**Réponse :**

Les préconisations importantes pour un compte utilisateur personnel sur un serveur :

1. **Sécurité du mot de passe :**
   - Utiliser un mot de passe fort (minimum 12 caractères, avec majuscules, minuscules, chiffres et caractères spéciaux)
   - Changer régulièrement le mot de passe

2. **Droits et privilèges :**
   - Ajouter l'utilisateur au groupe sudo pour les tâches administratives
   ```bash
   usermod -aG sudo arno
   ```
   
3. **Connexion SSH sécurisée :**
   - Utiliser l'authentification par clé SSH plutôt que par mot de passe
   - Désactiver la connexion root directe via SSH

4. **Isolation :**
   - Ne pas utiliser root pour les tâches quotidiennes
   - Utiliser sudo uniquement quand nécessaire

5. **Traçabilité :**
   - Configurer la journalisation des commandes sudo
   - Surveiller les connexions

---

## Partie 2 : Configuration de SSH

### Q.2.2.1 Désactiver complètement l'accès à distance de l'utilisateur root

**Commande :**
```bash
nano /etc/ssh/sshd_config
```

**Modification à apporter :**
Ajouter ou modifier la ligne suivante dans le fichier :
```
PermitRootLogin no
```

**Sauvegarder et redémarrer :**
```bash
systemctl restart sshd
```

**Vérification :**
```bash
# Essayer de se connecter en tant que root depuis une autre machine
root@SRVLX01:~# ssh root@SRVLX01
# La connexion devrait être refusée
```

**Exemple de sortie attendue :**
```
root@SRVLX01:~# ssh root@SRVLX01
The authenticity of host 'srvlx01 (127.0.0.1)' can't be established.
ECDSA key fingerprint is SHA256:xxxxxxxxxxxx.
Are you sure you want to continue connecting (yes/no/[fingerprint])? yes
root@srvlx01's password: 
Permission denied, please try again.
```

---

### Q.2.2.2 Autoriser l'accès à distance à ton compte personnel uniquement

**Commande :**
```bash
nano /etc/ssh/sshd_config
```

**Modification à apporter :**
Ajouter dans le fichier :
```
AllowUsers arno
```

**Sauvegarder et redémarrer :**
```bash
systemctl restart sshd
```

**Vérification :**
```bash
# Se connecter avec le compte arno
root@SRVLX01:~# ssh arno@SRVLX01
# La connexion devrait fonctionner
```

**Exemple de sortie attendue :**
```
root@SRVLX01:~# ssh arno@SRVLX01
arno@srvlx01's password: 
Last login: [date]
arno@SRVLX01:~$
```

---

### Q.2.2.3 Mettre en place une authentification par clé valide et désactiver l'authentification par mot de passe

**Étape 1 : Générer une paire de clés SSH (sur la machine cliente)**
```bash
ssh-keygen -t rsa -b 4096
```

**Étape 2 : Copier la clé publique sur le serveur**
```bash
ssh-copy-id arno@SRVLX01
```

**Étape 3 : Modifier la configuration SSH**
```bash
nano /etc/ssh/sshd_config
```

**Modifications à apporter :**
```
PasswordAuthentication no
PubkeyAuthentication yes
```

**Étape 4 : Redémarrer SSH**
```bash
systemctl restart sshd
```

**Vérification :**
```bash
# Essayer de se connecter sans mot de passe
ssh arno@SRVLX01
# La connexion devrait fonctionner automatiquement avec la clé
```

**Note importante :** Assurez-vous de tester la connexion par clé AVANT de désactiver l'authentification par mot de passe pour éviter de vous bloquer l'accès au serveur.

---

## Partie 3 : Analyse du stockage

### Q.2.3.1 Quels sont les systèmes de fichiers actuellement montés ?

**Commande :**
```bash
df -h
```

**Exemple de sortie attendue :**
```
root@SRVLX01:~# df -h
Sys. de fichiers     Taille Utilisé Dispo Uti% Monté sur
udev                   4,0M       0  4,0M   0% /dev
tmpfs                  380M     59M  322M  16% /run
/dev/mapper/cp5--vg--root ext4
                       4,0M    1,5G  1,1G  60% /
tmpfs                  5,0M       0  5,0M   0% /run/lock
/dev/sda1             ext2     485M     0  485M   0% /dev/shm
/dev/md0p1            ext3     47M    47M  530M  81% /boot
tmpfs                  1M       0    1M   0% /run/user/0
```

**Systèmes de fichiers identifiés :**
- `/` : Système racine monté sur `/dev/mapper/cp5--vg--root`
- `/boot` : Partition de démarrage sur `/dev/md0p1`
- Systèmes temporaires : `tmpfs`, `udev`

---

### Q.2.3.2 Quel type de système de stockage ils utilisent ?

**Commande :**
```bash
lsblk -f
```

**Exemple de sortie attendue :**
```
root@SRVLX01:~# lsblk -f
NAME                FSTYPE      LABEL UUID                                 MOUNTPOINT
sda                                                                       
├─sda1              linux_raid_member
│ └─md0             LVM2_member
│   ├─md0p1         ext2                                                  /boot
│   └─cp5-vg-root   ext4                                                  /
├─sda2              LVM2_member
│ └─cp5--vg--swap_1 swap
└─sda3              ext2        1.0                                        
```

**Réponse :**

Les types de systèmes de stockage utilisés sont :

1. **RAID logiciel** : 
   - Utilisation de `md0` (Linux RAID)
   - Visible avec les partitions `linux_raid_member`

2. **LVM (Logical Volume Manager)** :
   - Groupe de volumes : `cp5-vg`
   - Volumes logiques : `cp5--vg--root` et `cp5--vg--swap_1`

3. **Systèmes de fichiers** :
   - `ext4` pour la racine (/)
   - `ext2` pour /boot
   - `swap` pour l'espace d'échange

---

### Q.2.3.3 Ajouter un nouveau disque de 8,00 Gio au serveur et réparer le volume RAID

**Étape 1 : Identifier le nouveau disque**
```bash
lsblk
fdisk -l
```

**Étape 2 : Créer une partition sur le nouveau disque**
```bash
fdisk /dev/sdb
# Commandes dans fdisk :
# n (nouvelle partition)
# p (primaire)
# 1 (numéro de partition)
# Entrée (premier secteur par défaut)
# Entrée (dernier secteur par défaut)
# t (changer le type)
# fd (Linux raid autodetect)
# w (écrire les modifications)
```

**Étape 3 : Ajouter le disque au RAID**
```bash
mdadm --manage /dev/md0 --add /dev/sdb1
```

**Étape 4 : Vérifier l'état du RAID**
```bash
cat /proc/mdstat
mdadm --detail /dev/md0
```

**Exemple de sortie attendue :**
```
root@SRVLX01:~# cat /proc/mdstat
Personalities : [raid1]
md0 : active raid1 sdb1[2] sda1[0]
      8388544 blocks super 1.2 [2/2] [UU]
      bitmap: 0/1 pages [0KB], 65536KB chunk

unused devices: <none>
```

---

### Q.2.3.4 Ajouter un nouveau volume logique LVM de 2 Gio qui servira à héberger des sauvegardes

**Étape 1 : Vérifier l'espace disponible**
```bash
vgdisplay
vgs
```

**Étape 2 : Créer le volume logique**
```bash
lvcreate -L 2G -n bareos-storage cp5-vg
```

**Étape 3 : Formater le volume**
```bash
mkfs.ext4 /dev/cp5-vg/bareos-storage
```

**Étape 4 : Créer le point de montage**
```bash
mkdir -p /var/lib/bareos/storage
```

**Étape 5 : Monter le volume**
```bash
mount /dev/cp5-vg/bareos-storage /var/lib/bareos/storage
```

**Étape 6 : Rendre le montage permanent**
```bash
nano /etc/fstab
```

**Ajouter la ligne suivante :**
```
/dev/cp5-vg/bareos-storage  /var/lib/bareos/storage  ext4  defaults  0  2
```

**Vérification :**
```bash
df -h | grep bareos
mount | grep bareos
```

**Exemple de sortie attendue :**
```
root@SRVLX01:~# df -h | grep bareos
/dev/mapper/cp5--vg--bareos--storage  2.0G   24M  1.8G   2% /var/lib/bareos/storage
```

---

### Q.2.3.5 Combien d'espace disponible reste-t-il dans le groupe de volume ?

**Commande :**
```bash
vgdisplay
# ou
vgs
```

**Exemple de sortie attendue :**
```
root@SRVLX01:~# vgdisplay
  --- Volume group ---
  VG Name               cp5-vg
  System ID             
  Format                lvm2
  Metadata Areas        1
  Metadata Sequence No  4
  VG Access             read/write
  VG Status             resizable
  MAX LV                0
  Cur LV                3
  Open LV               2
  Max PV                0
  Cur PV                1
  Act PV                1
  VG Size               7.52 GiB
  PE Size               4.00 MiB
  Total PE              1925
  Alloc PE / Size       1600 / 6.25 GiB
  Free  PE / Size       325 / 1.27 GiB
  VG UUID               xxxx-xxxx-xxxx-xxxx
```

**Réponse :**
L'espace disponible dans le groupe de volume est indiqué dans la ligne `Free PE / Size`. Dans cet exemple, il reste **1.27 GiB** disponible.

---

## Partie 4 : Sauvegardes

### Q.2.4.1 Rôles des composants Bareos

**Commande pour obtenir les configurations :**
```bash
bareos-dir -t
# ou
cat /etc/bareos/bareos-dir.d/storage/bareos-fd.conf
```

**Réponse :**

Les 3 principaux composants de Bareos sont :

1. **Bareos Director (bareos-dir)** :
   - Gère les configurations et ordonne les sauvegardes
   - S'occupe du stockage des sauvegardes
   - Coordonne tous les processus de sauvegarde et restauration
   - Stocke les métadonnées dans une base de données

2. **Bareos Storage Daemon (bareos-sd)** :
   - Gère le stockage physique des données
   - Écrit et lit les données sur les supports de stockage
   - Communique avec le Director et les File Daemons

3. **Bareos File Daemon (bareos-fd)** :
   - Installé sur chaque machine à sauvegarder
   - Lit et envoie les fichiers à sauvegarder
   - Restaure les fichiers lors d'une restauration
   - Communique avec le Director

**Schéma de fonctionnement :**
```
[Client/Machine] ---(bareos-fd)---> [Storage] ---(bareos-sd)---> [Director] ---(bareos-dir)
```

---

## Partie 5 : Filtrage réseau

### Q.2.5.1 Quelles sont actuellement les règles appliquées sur Netfilter ?

**Commande :**
```bash
nft list ruleset
# ou pour iptables
iptables -L -v -n
```

**Exemple de sortie attendue :**
```
root@SRVLX01:~# nft list ruleset
table inet filter_table {
  chain input {
    type filter hook input priority filter; policy drop;
    ct state invalid drop
    ct state established,related accept
    iifname "lo" accept
    ip protocol icmp accept
    ip6 nexthdr ipv6-icmp accept
  }
}
```

**Explication des règles :**
- Politique par défaut : DROP (tout refuser par défaut)
- Accepter les connexions établies et reliées
- Accepter le trafic sur l'interface locale (lo)
- Accepter les pings ICMP

---

### Q.2.5.2 Quels types de communications sont autorisées ?

**Commande :**
```bash
iptables -L INPUT -v -n --line-numbers
```

**Réponse basée sur l'exemple :**

Communications autorisées :
1. **Connexions établies et reliées** : `ct state established,related accept`
2. **Trafic local** : `iifname "lo" accept`
3. **ICMP (ping)** : `ip protocol icmp accept`
4. **IPv6 ICMP** : `ip6 nexthdr ipv6-icmp accept`
5. **Ports spécifiques** (si configurés) :
   - Port 22 (SSH)
   - Port 80 (HTTP)
   - Autres ports selon la configuration

---

### Q.2.5.3 Quels types sont interdits ?

**Commande :**
```bash
iptables -L INPUT -v -n | grep DROP
nft list ruleset | grep "ct state invalid"
```

**Réponse :**

Types de communications interdites :
1. **Paquets invalides** : `ct state invalid drop`
2. **Toutes les nouvelles connexions non explicitement autorisées** (politique DROP par défaut)
3. **Connexions sur des ports non ouverts**

---

### Q.2.5.4 Ajouter les règles pour Bareos

**Commandes pour ajouter les règles :**

**Pour nftables :**
```bash
# Autoriser le port director (9101)
nft add rule inet filter_table input tcp dport 9101 accept

# Autoriser le port file daemon (9102)
nft add rule inet filter_table input tcp dport 9102 accept

# Autoriser le port storage daemon (9103)
nft add rule inet filter_table input tcp dport 9103 accept
```

**Pour iptables :**
```bash
# Autoriser Bareos Director
iptables -A INPUT -p tcp --dport 9101 -j ACCEPT

# Autoriser Bareos File Daemon
iptables -A INPUT -p tcp --dport 9102 -j ACCEPT

# Autoriser Bareos Storage Daemon
iptables -A INPUT -p tcp --dport 9103 -j ACCEPT

# Sauvegarder les règles
iptables-save > /etc/iptables/rules.v4
```

**Vérification :**
```bash
nft list ruleset | grep 910
# ou
iptables -L INPUT -v -n | grep 910
```

---

## Partie 6 : Analyse de logs

### Q.2.6.1 Lister les 10 derniers échecs de connexion ayant eu lieu sur le serveur

**Commande :**
```bash
grep "Failed password" /var/log/auth.log | tail -n 10
```

**Commande plus détaillée pour extraire date, heure et IP :**
```bash
grep "Failed password" /var/log/auth.log | tail -n 10 | awk '{print "Date:", $1, $2, $3, "- IP:", $(NF-3)}'
```

**Exemple de sortie attendue :**
```
root@SRVLX01:~# grep "Failed password" /var/log/auth.log | tail -n 10
Jan 19 21:03:56 SRVLX01 sshd[5041]: Failed password for arno from 127.0.0.1 port 55312 ssh2
Jan 19 21:05:50 SRVLX01 sshd[5348]: Failed password for invalid user root from 127.0.0.1 port 55312 ssh2
```

**Informations extraites pour chaque tentative :**
1. **Date et heure de la tentative** : Jan 19 21:03:56
2. **L'adresse IP de la machine** : 127.0.0.1

**Alternative avec journalctl :**
```bash
journalctl -u ssh -g "Failed password" -n 10
```

---

## Commandes utiles supplémentaires

### Gestion des utilisateurs
```bash
# Lister tous les utilisateurs
cat /etc/passwd

# Voir les groupes d'un utilisateur
groups arno

# Changer le shell d'un utilisateur
usermod -s /bin/bash arno

# Supprimer un utilisateur
userdel -r arno
```

### SSH
```bash
# Vérifier la configuration SSH
sshd -t

# Voir les connexions SSH actives
who
w

# Historique des connexions
last
```

### Stockage
```bash
# Voir l'utilisation du disque
du -sh /*

# Informations sur les volumes LVM
pvdisplay  # Physical volumes
vgdisplay  # Volume groups
lvdisplay  # Logical volumes

# État du RAID
cat /proc/mdstat
mdadm --detail /dev/md0
```

### Firewall
```bash
# Sauvegarder les règles nftables
nft list ruleset > /etc/nftables.conf

# Recharger les règles
nft -f /etc/nftables.conf
```

### Logs
```bash
# Logs système
journalctl -xe

# Logs SSH
tail -f /var/log/auth.log

# Logs spécifiques à un service
journalctl -u ssh -f
```

---

## Points de vigilance

1. **Toujours tester la configuration SSH avant de fermer la session actuelle**
2. **Faire des sauvegardes de configuration avant toute modification**
3. **Documenter les changements effectués**
4. **Vérifier les logs régulièrement pour détecter les tentatives d'intrusion**
5. **Maintenir le système à jour**

---

## Checklist de sécurité

- [ ] Compte utilisateur personnel créé avec mot de passe fort
- [ ] Utilisateur ajouté au groupe sudo
- [ ] Accès root SSH désactivé
- [ ] Authentification par clé SSH configurée
- [ ] Authentification par mot de passe désactivée
- [ ] Firewall configuré avec politique restrictive
- [ ] Ports Bareos ouverts uniquement si nécessaire
- [ ] Logs surveillés régulièrement
- [ ] Sauvegardes configurées et testées
- [ ] Documentation à jour
