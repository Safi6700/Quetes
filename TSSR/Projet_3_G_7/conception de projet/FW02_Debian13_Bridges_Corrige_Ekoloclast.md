# Guide de Configuration FW02 - Routeur/Switch Debian 13
## Projet Ekoloclast - Architecture Corrigée

---

## 📋 Table des matières

1. [Architecture corrigée](#1-architecture-corrigée)
2. [Configuration VirtualBox](#2-configuration-virtualbox)
3. [Installation Debian 13](#3-installation-debian-13)
4. [Configuration réseau FW02](#4-configuration-réseau-fw02)
5. [Configuration des Bridges (Switches virtuels)](#5-configuration-des-bridges)
6. [Configuration iptables](#6-configuration-iptables)
7. [Mise à jour configuration FW01 pfSense](#7-mise-à-jour-configuration-fw01-pfsense)
8. [Tests et validation](#8-tests-et-validation)

---

## 1. Architecture corrigée

### 1.1 Schéma de l'architecture réelle

D'après ton schéma, voici l'architecture correcte :

```
                                    INTERNET
                                        │
                                        ▼
                              ┌─────────────────┐
                              │    BOX FAI      │
                              │  192.168.1.1    │
                              └────────┬────────┘
                                       │ IP: 192.168.1.x/24
                                       │
         ┌─────────────────────────────┴─────────────────────────────────┐
         │                      FW01 PARE-FEU pfSense                    │
         │                                                               │
         │   ┌──────────┐      ┌──────────┐      ┌──────────┐           │
         │   │   G1/3   │      │   G1/1   │      │   G1/2   │           │
         │   │   WAN    │      │   LAN    │      │   DMZ    │           │
         │   │192.168.1.│      │10.10.5.1 │      │10.10.5.3 │           │
         │   │   x/24   │      │   /29    │      │   /29    │           │
         │   └──────────┘      └────┬─────┘      └────┬─────┘           │
         │                          │                 │                  │
         └──────────────────────────┼─────────────────┼──────────────────┘
                                    │                 │
                           VLAN 5 Transit      VLAN 30 DMZ
                           10.10.5.0/29        (direct pfSense)
                                    │                 │
                                    │                 ▼
                                    │          ┌───────────┐
                                    │          │  SW-C/8P  │
                                    │          │   (DMZ)   │
                                    │          └─────┬─────┘
                                    │                │
                                    │                ▼
                                    │          ┌───────────┐
                                    │          │  SRVLX01  │
                                    │          │Messagerie │
                                    │          │172.16.30.1│
                                    │          └───────────┘
                                    │
                                    ▼
┌───────────────────────────────────────────────────────────────────────┐
│                         FW02 DEBIAN 13                                │
│                    (Routeur + Switch virtuel)                         │
│                                                                       │
│   ┌─────────────────────────────────────────────────────────────┐    │
│   │  enp0s3 - VLAN 5 Transit                                    │    │
│   │  IP: 10.10.5.2/29                                           │    │
│   │  Gateway: 10.10.5.1 (vers FW01)                             │    │
│   └─────────────────────────────────────────────────────────────┘    │
│                                                                       │
│   ┌─────────────────────────────────────────────────────────────┐    │
│   │  G0/1 - Interface vers Switch B                             │    │
│   │  IF1: 172.16.10.14/28 (Passerelle VLAN 10)                  │    │
│   │  IF2: 172.16.20.14/28 (Passerelle VLAN 20)                  │    │
│   └─────────────────────────────────────────────────────────────┘    │
│                                                                       │
└───────────────────────────────────────────────────────────────────────┘
                                    │
                                    │ Trunk VLAN 10 + VLAN 20
                                    ▼
┌───────────────────────────────────────────────────────────────────────┐
│                         LAN-SW-B/48P                                  │
│                      (Switch principal)                               │
│                                                                       │
│   ┌─────────┐  ┌─────────┐  ┌─────────────────────────────────┐      │
│   │ Uplink  │  │  Vers   │  │      Vers VLANs 40-130          │      │
│   │  FW02   │  │  SW-A   │  │      (hors périmètre)           │      │
│   └────┬────┘  └────┬────┘  └─────────────────────────────────┘      │
│        │            │                                                 │
└────────┼────────────┼─────────────────────────────────────────────────┘
         │            │
         │            ▼
         │  ┌───────────────────────────────────────────────────────────┐
         │  │                    LAN-SW-A/8P                            │
         │  │                 (Switch serveurs)                         │
         │  │                                                           │
         │  │   Ports 0/1 : VLAN 10 (Serveurs)                         │
         │  │   Ports 0/2 : VLAN 20 (Test)                             │
         │  │                                                           │
         │  │   ┌─────────┐ ┌─────────┐ ┌─────────┐ ┌─────────┐        │
         │  │   │SRVWIN01 │ │ IPBX01  │ │SRVWIN04 │ │ SRVLX02 │        │
         │  │   │ .10.1   │ │ .10.2   │ │ .10.3   │ │ .10.4   │        │
         │  │   └─────────┘ └─────────┘ └─────────┘ └─────────┘        │
         │  │                                                           │
         │  │   ┌─────────┐ ┌─────────┐                                │
         │  │   │CLIWIN01 │ │CLIWIN02 │                                │
         │  │   │ .20.1   │ │ .20.2   │                                │
         │  │   └─────────┘ └─────────┘                                │
         │  │                                                           │
         │  └───────────────────────────────────────────────────────────┘
         │
         └──► (Connexion trunk vers FW02)
```

### 1.2 Récapitulatif des rôles

| Équipement | Rôle | VLANs gérés | Connexions |
|------------|------|-------------|------------|
| **FW01 pfSense** | Pare-feu périmétrique + DMZ | WAN, VLAN 5, VLAN 30 | Internet, FW02, DMZ |
| **FW02 Debian** | Routeur inter-VLAN | VLAN 5, VLAN 10, VLAN 20 | FW01, SW-B |
| **SW-B (48P)** | Switch distribution | VLAN 10, 20, (40-130) | FW02, SW-A |
| **SW-A (8P)** | Switch accès serveurs | VLAN 10, VLAN 20 | SW-B, Serveurs, Clients |
| **SW-C (8P)** | Switch DMZ | VLAN 30 | FW01, SRVLX01 |

### 1.3 Plan d'adressage corrigé

| VLAN | Nom | Réseau | Passerelle | Équipement passerelle |
|------|-----|--------|------------|----------------------|
| 5 | Transit | 10.10.5.0/29 | 10.10.5.1 | FW01 (vers Internet) |
| 10 | Serveurs | 172.16.10.0/28 | 172.16.10.14 | **FW02** |
| 20 | Test | 172.16.20.0/28 | 172.16.20.14 | **FW02** |
| 30 | DMZ | 172.16.30.0/28 | 172.16.30.14 | **FW01** (direct) |

### 1.4 Interfaces FW02 (Debian 13)

| Interface | Type | VLAN | Adresse IP | Connecté à |
|-----------|------|------|------------|------------|
| enp0s3 | Physique | 5 | 10.10.5.2/29 | FW01 (LAN) |
| enp0s8 | Physique | - | - | SW-B (trunk) |
| enp0s8.10 | Sub-interface | 10 | 172.16.10.14/28 | VLAN 10 |
| enp0s8.20 | Sub-interface | 20 | 172.16.20.14/28 | VLAN 20 |

**OU avec Bridges :**

| Interface | Type | VLAN | Adresse IP | Connecté à |
|-----------|------|------|------------|------------|
| enp0s3 | Physique | 5 | 10.10.5.2/29 | FW01 |
| br10 | Bridge | 10 | 172.16.10.14/28 | SW-B/SW-A |
| br20 | Bridge | 20 | 172.16.20.14/28 | SW-B/SW-A |

---

## 2. Configuration VirtualBox

### 2.1 Réseaux internes à créer

| Nom réseau interne | Usage | VMs connectées |
|--------------------|-------|----------------|
| `VLAN5_Transit` | Liaison FW01 ↔ FW02 | FW01 (LAN), FW02 (enp0s3) |
| `VLAN10_Serveurs` | Serveurs internes | FW02 (br10), SRVWIN01, IPBX01, SRVWIN04, SRVLX02 |
| `VLAN20_Test` | Zone test | FW02 (br20), CLIWIN01, CLIWIN02 |
| `VLAN30_DMZ` | DMZ (direct pfSense) | FW01 (OPT1/DMZ), SRVLX01 |

### 2.2 Configuration VM FW02 Debian 13

#### Paramètres généraux

| Paramètre | Valeur |
|-----------|--------|
| Nom | FW02-Debian13 |
| Type | Linux |
| Version | Debian (64-bit) |
| RAM | 1024 MB |
| CPU | 1 vCPU |
| Disque | 20 GB (dynamique) |

#### Configuration des cartes réseau

```
┌─────────────────────────────────────────────────────────────────────┐
│                    FW02 - 3 CARTES RÉSEAU                           │
├─────────────────────────────────────────────────────────────────────┤
│                                                                     │
│  CARTE 1 (enp0s3) - VLAN 5 Transit vers FW01                       │
│  ├── Activer : ✓                                                    │
│  ├── Mode : Réseau interne                                         │
│  ├── Nom : VLAN5_Transit                                           │
│  ├── Mode promiscuité : Autoriser tout                             │
│  └── Type : Intel PRO/1000 MT Desktop (82540EM)                    │
│                                                                     │
│  CARTE 2 (enp0s8) - VLAN 10 Serveurs                               │
│  ├── Activer : ✓                                                    │
│  ├── Mode : Réseau interne                                         │
│  ├── Nom : VLAN10_Serveurs                                         │
│  ├── Mode promiscuité : Autoriser tout    ← OBLIGATOIRE            │
│  └── Type : Intel PRO/1000 MT Desktop (82540EM)                    │
│                                                                     │
│  CARTE 3 (enp0s9) - VLAN 20 Test                                   │
│  ├── Activer : ✓                                                    │
│  ├── Mode : Réseau interne                                         │
│  ├── Nom : VLAN20_Test                                             │
│  ├── Mode promiscuité : Autoriser tout    ← OBLIGATOIRE            │
│  └── Type : Intel PRO/1000 MT Desktop (82540EM)                    │
│                                                                     │
└─────────────────────────────────────────────────────────────────────┘
```

### 2.3 Configuration VM FW01 pfSense (mise à jour)

```
┌─────────────────────────────────────────────────────────────────────┐
│                    FW01 - 3 CARTES RÉSEAU                           │
├─────────────────────────────────────────────────────────────────────┤
│                                                                     │
│  CARTE 1 (em0) - WAN vers Internet                                 │
│  ├── Mode : NAT ou Accès par pont                                  │
│  └── IP : DHCP ou 192.168.1.2/24                                   │
│                                                                     │
│  CARTE 2 (em1) - LAN vers FW02 (VLAN 5)                           │
│  ├── Mode : Réseau interne                                         │
│  ├── Nom : VLAN5_Transit                                           │
│  └── IP : 10.10.5.1/29                                             │
│                                                                     │
│  CARTE 3 (em2) - DMZ directe (VLAN 30)                            │
│  ├── Mode : Réseau interne                                         │
│  ├── Nom : VLAN30_DMZ                                              │
│  └── IP : 172.16.30.14/28                                          │
│                                                                     │
└─────────────────────────────────────────────────────────────────────┘
```

### 2.4 Configuration des autres VMs

| VM | Réseau interne | IP | Passerelle |
|----|----------------|-----|------------|
| SRVWIN01 | VLAN10_Serveurs | 172.16.10.1/28 | 172.16.10.14 (FW02) |
| IPBX01 | VLAN10_Serveurs | 172.16.10.2/28 | 172.16.10.14 (FW02) |
| SRVWIN04 | VLAN10_Serveurs | 172.16.10.3/28 | 172.16.10.14 (FW02) |
| SRVLX02 | VLAN10_Serveurs | 172.16.10.4/28 | 172.16.10.14 (FW02) |
| CLIWIN01 | VLAN20_Test | 172.16.20.1/28 | 172.16.20.14 (FW02) |
| CLIWIN02 | VLAN20_Test | 172.16.20.2/28 | 172.16.20.14 (FW02) |
| SRVLX01 | VLAN30_DMZ | 172.16.30.1/28 | 172.16.30.14 (**FW01**) |

---

## 3. Installation Debian 13

### 3.1 Téléchargement Debian 13 (Trixie)

Debian 13 "Trixie" est actuellement en **testing**. Télécharge l'ISO :

- **URL** : https://www.debian.org/devel/debian-installer/
- **Ou** : https://cdimage.debian.org/cdimage/weekly-builds/amd64/iso-cd/
- **Fichier** : `debian-testing-amd64-netinst.iso`

### 3.2 Installation

Pendant l'installation :

1. **Langue** : Français
2. **Nom de machine** : `FW02`
3. **Domaine** : `tssr.lan`
4. **Mot de passe root** : (définir un mot de passe fort)
5. **Utilisateur** : `admin`
6. **Partitionnement** : Utiliser tout le disque
7. **Logiciels** :
   - ❌ Environnement de bureau
   - ✅ Serveur SSH
   - ✅ Utilitaires usuels du système

### 3.3 Post-installation - Paquets nécessaires

```bash
# Connexion en root
su -

# Mise à jour du système
apt update && apt upgrade -y

# Installation des paquets réseau
apt install -y \
    bridge-utils \
    vlan \
    iptables \
    iptables-persistent \
    nftables \
    net-tools \
    iproute2 \
    tcpdump \
    traceroute \
    ethtool \
    htop \
    vim \
    sudo \
    curl \
    wget

# Ajouter l'utilisateur au groupe sudo
usermod -aG sudo admin

# Charger le module 8021q pour les VLANs
modprobe 8021q
echo "8021q" >> /etc/modules

# Charger le module bridge
modprobe bridge
echo "bridge" >> /etc/modules
```

### 3.4 Vérification des interfaces

```bash
# Lister les interfaces
ip link show

# Résultat attendu :
1: lo: <LOOPBACK,UP,LOWER_UP>
2: enp0s3: <BROADCAST,MULTICAST>
3: enp0s8: <BROADCAST,MULTICAST>
4: enp0s9: <BROADCAST,MULTICAST>
```

---

## 4. Configuration réseau FW02

### 4.1 Option A : Configuration avec sous-interfaces VLAN (simple)

Cette méthode utilise le VLAN tagging 802.1Q sur une seule interface trunk.

```bash
nano /etc/network/interfaces
```

```bash
#=====================================================
# /etc/network/interfaces
# FW02 Debian 13 - Configuration avec VLANs
# Projet Ekoloclast
#=====================================================

# Interface loopback
auto lo
iface lo inet loopback

#=====================================================
# enp0s3 - VLAN 5 Transit (vers FW01 pfSense)
#=====================================================
auto enp0s3
iface enp0s3 inet static
    address 10.10.5.2
    netmask 255.255.255.248
    gateway 10.10.5.1
    # Route par défaut vers FW01 pour accès Internet

#=====================================================
# enp0s8 - VLAN 10 Serveurs
#=====================================================
auto enp0s8
iface enp0s8 inet static
    address 172.16.10.14
    netmask 255.255.255.240
    # Passerelle pour le VLAN 10

#=====================================================
# enp0s9 - VLAN 20 Test
#=====================================================
auto enp0s9
iface enp0s9 inet static
    address 172.16.20.14
    netmask 255.255.255.240
    # Passerelle pour le VLAN 20
```

### 4.2 Option B : Configuration avec Bridges (recommandée)

Cette méthode simule les switches SW-A et SW-B avec des bridges Linux.

```bash
nano /etc/network/interfaces
```

```bash
#=====================================================
# /etc/network/interfaces
# FW02 Debian 13 - Configuration avec Bridges
# Projet Ekoloclast
# 
# Architecture :
#   FW02 ──► SW-B (br_swb) ──► SW-A (simulation)
#                │
#                ├── VLAN 10 (br10) : Serveurs
#                └── VLAN 20 (br20) : Test
#=====================================================

# Interface loopback
auto lo
iface lo inet loopback

#=====================================================
# enp0s3 - VLAN 5 Transit (vers FW01 pfSense)
# Connexion point-à-point, pas de bridge nécessaire
#=====================================================
auto enp0s3
iface enp0s3 inet static
    address 10.10.5.2
    netmask 255.255.255.248
    gateway 10.10.5.1

#=====================================================
# BRIDGE br10 - VLAN 10 Serveurs (172.16.10.0/28)
# Simule SW-B + SW-A pour le VLAN 10
#=====================================================

# Interface physique enp0s8 (membre du bridge, sans IP)
auto enp0s8
iface enp0s8 inet manual
    up ip link set dev $IFACE up
    down ip link set dev $IFACE down

# Bridge br10 - Switch virtuel VLAN 10
auto br10
iface br10 inet static
    address 172.16.10.14
    netmask 255.255.255.240
    bridge_ports enp0s8
    bridge_stp off
    bridge_waitport 0
    bridge_fd 0
    # Machines connectées : SRVWIN01, IPBX01, SRVWIN04, SRVLX02

#=====================================================
# BRIDGE br20 - VLAN 20 Test (172.16.20.0/28)
# Simule SW-B + SW-A pour le VLAN 20
#=====================================================

# Interface physique enp0s9 (membre du bridge, sans IP)
auto enp0s9
iface enp0s9 inet manual
    up ip link set dev $IFACE up
    down ip link set dev $IFACE down

# Bridge br20 - Switch virtuel VLAN 20
auto br20
iface br20 inet static
    address 172.16.20.14
    netmask 255.255.255.240
    bridge_ports enp0s9
    bridge_stp off
    bridge_waitport 0
    bridge_fd 0
    # Machines connectées : CLIWIN01, CLIWIN02
```

### 4.3 Activer le routage IPv4

```bash
# Éditer sysctl.conf
nano /etc/sysctl.conf
```

```bash
#=====================================================
# /etc/sysctl.conf - FW02 Debian 13
#=====================================================

# Activer le routage IPv4
net.ipv4.ip_forward = 1

# Sécurité : désactiver les redirections ICMP
net.ipv4.conf.all.send_redirects = 0
net.ipv4.conf.default.send_redirects = 0
net.ipv4.conf.all.accept_redirects = 0
net.ipv4.conf.default.accept_redirects = 0

# Protection contre les attaques
net.ipv4.icmp_echo_ignore_broadcasts = 1
net.ipv4.tcp_syncookies = 1
net.ipv4.conf.all.accept_source_route = 0
net.ipv4.conf.default.accept_source_route = 0

# Protection contre le spoofing
net.ipv4.conf.all.rp_filter = 1
net.ipv4.conf.default.rp_filter = 1
```

```bash
# Appliquer les paramètres
sysctl -p
```

### 4.4 Appliquer et vérifier la configuration

```bash
# Redémarrer le réseau
systemctl restart networking

# Ou redémarrer la machine (plus sûr)
reboot
```

Après redémarrage :

```bash
# Vérifier les interfaces
ip addr show

# Résultat attendu :
1: lo: <LOOPBACK,UP,LOWER_UP>
    inet 127.0.0.1/8 scope host lo
2: enp0s3: <BROADCAST,MULTICAST,UP,LOWER_UP>
    inet 10.10.5.2/29 brd 10.10.5.7 scope global enp0s3
3: enp0s8: <BROADCAST,MULTICAST,UP,LOWER_UP>
    master br10 state forwarding
4: enp0s9: <BROADCAST,MULTICAST,UP,LOWER_UP>
    master br20 state forwarding
5: br10: <BROADCAST,MULTICAST,UP,LOWER_UP>
    inet 172.16.10.14/28 brd 172.16.10.15 scope global br10
6: br20: <BROADCAST,MULTICAST,UP,LOWER_UP>
    inet 172.16.20.14/28 brd 172.16.20.15 scope global br20

# Vérifier les bridges
brctl show

# Résultat attendu :
bridge name    bridge id              STP enabled    interfaces
br10           8000.xxxxxxxxxxxx      no             enp0s8
br20           8000.xxxxxxxxxxxx      no             enp0s9

# Vérifier la table de routage
ip route show

# Résultat attendu :
default via 10.10.5.1 dev enp0s3
10.10.5.0/29 dev enp0s3 proto kernel scope link src 10.10.5.2
172.16.10.0/28 dev br10 proto kernel scope link src 172.16.10.14
172.16.20.0/28 dev br20 proto kernel scope link src 172.16.20.14

# Vérifier le routage actif
cat /proc/sys/net/ipv4/ip_forward
# Doit retourner : 1
```

---

## 5. Configuration des Bridges (Switches virtuels)

### 5.1 Schéma des bridges

```
┌─────────────────────────────────────────────────────────────────────┐
│                    FW02 - BRIDGES LINUX                             │
│                   (Simulation SW-B + SW-A)                          │
├─────────────────────────────────────────────────────────────────────┤
│                                                                     │
│  enp0s3 ───────────────────────────► 10.10.5.2/29                  │
│  (pas de bridge)                      │                             │
│                                       ▼                             │
│                                   Vers FW01                         │
│                                                                     │
│  ┌─────────────────────────────────────────────────────────────┐   │
│  │  BRIDGE br10 (VLAN 10 - Serveurs)                           │   │
│  │  IP: 172.16.10.14/28                                        │   │
│  │                                                              │   │
│  │  ┌─────────┐                                                 │   │
│  │  │ enp0s8  │ ◄── Réseau interne VBox "VLAN10_Serveurs"      │   │
│  │  │ (port)  │                                                 │   │
│  │  └─────────┘                                                 │   │
│  │       │                                                      │   │
│  │       ├── SRVWIN01 (172.16.10.1)                            │   │
│  │       ├── IPBX01   (172.16.10.2)                            │   │
│  │       ├── SRVWIN04 (172.16.10.3)                            │   │
│  │       └── SRVLX02  (172.16.10.4)                            │   │
│  │                                                              │   │
│  └──────────────────────────────────────────────────────────────┘   │
│                                                                     │
│  ┌─────────────────────────────────────────────────────────────┐   │
│  │  BRIDGE br20 (VLAN 20 - Test)                               │   │
│  │  IP: 172.16.20.14/28                                        │   │
│  │                                                              │   │
│  │  ┌─────────┐                                                 │   │
│  │  │ enp0s9  │ ◄── Réseau interne VBox "VLAN20_Test"          │   │
│  │  │ (port)  │                                                 │   │
│  │  └─────────┘                                                 │   │
│  │       │                                                      │   │
│  │       ├── CLIWIN01 (172.16.20.1)                            │   │
│  │       └── CLIWIN02 (172.16.20.2)                            │   │
│  │                                                              │   │
│  └──────────────────────────────────────────────────────────────┘   │
│                                                                     │
└─────────────────────────────────────────────────────────────────────┘
```

### 5.2 Commandes bridge utiles

```bash
# Voir tous les bridges
brctl show

# Voir les détails d'un bridge
brctl showstp br10

# Voir la table MAC (adresses apprises)
brctl showmacs br10

# Ajouter une interface à un bridge (temporaire)
brctl addif br10 enp0s10

# Retirer une interface d'un bridge
brctl delif br10 enp0s10

# Activer/désactiver STP
brctl stp br10 on
brctl stp br10 off

# Avec iproute2 (moderne)
ip link show master br10
bridge fdb show br br10
bridge link show
```

### 5.3 Ajouter des ports au bridge (si plus de cartes)

Si tu veux ajouter plus de "ports" au switch virtuel :

```bash
# Dans /etc/network/interfaces

# Ajouter enp0s10 au bridge br10
auto enp0s10
iface enp0s10 inet manual

auto br10
iface br10 inet static
    address 172.16.10.14
    netmask 255.255.255.240
    bridge_ports enp0s8 enp0s10    # ← Plusieurs interfaces
    bridge_stp off
    bridge_fd 0
```

---

## 6. Configuration iptables

### 6.1 Script iptables pour FW02 (VLAN 10 et 20 uniquement)

```bash
nano /usr/local/bin/fw02-iptables.sh
chmod +x /usr/local/bin/fw02-iptables.sh
```

```bash
#!/bin/bash
#=====================================================
# FW02 Debian 13 - Configuration iptables
# Projet Ekoloclast
# 
# Gère uniquement : VLAN 5 (transit), VLAN 10, VLAN 20
# DMZ (VLAN 30) géré par FW01 pfSense
#=====================================================

# Variables
TRANSIT="enp0s3"      # VLAN 5 vers FW01
BR10="br10"           # VLAN 10 Serveurs
BR20="br20"           # VLAN 20 Test

# Adresses réseau
NET_VLAN10="172.16.10.0/28"
NET_VLAN20="172.16.20.0/28"
NET_VLAN30="172.16.30.0/28"  # Pour les règles vers DMZ (via FW01)

# Flush des règles existantes
iptables -F
iptables -X
iptables -t nat -F
iptables -t nat -X
iptables -t mangle -F
iptables -t mangle -X

#=====================================================
# POLITIQUE PAR DÉFAUT
#=====================================================
iptables -P INPUT DROP
iptables -P FORWARD DROP
iptables -P OUTPUT ACCEPT

#=====================================================
# RÈGLES INPUT (trafic vers FW02 lui-même)
#=====================================================

# Loopback
iptables -A INPUT -i lo -j ACCEPT

# Connexions établies
iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT

# SSH depuis VLAN 10 (administration)
iptables -A INPUT -i $BR10 -p tcp --dport 22 -j ACCEPT

# SSH depuis VLAN 20 (pour tests)
iptables -A INPUT -i $BR20 -p tcp --dport 22 -j ACCEPT

# ICMP (ping) depuis tous les réseaux gérés
iptables -A INPUT -i $TRANSIT -p icmp --icmp-type echo-request -j ACCEPT
iptables -A INPUT -i $BR10 -p icmp --icmp-type echo-request -j ACCEPT
iptables -A INPUT -i $BR20 -p icmp --icmp-type echo-request -j ACCEPT
iptables -A INPUT -p icmp --icmp-type echo-reply -j ACCEPT

#=====================================================
# RÈGLES FORWARD (routage entre réseaux)
#=====================================================

# Connexions établies/relatives
iptables -A FORWARD -m state --state ESTABLISHED,RELATED -j ACCEPT

#-----------------------------------------------------
# VLAN 10 (Serveurs) → Accès complet
#-----------------------------------------------------
# Vers Internet (via VLAN 5 → FW01)
iptables -A FORWARD -i $BR10 -o $TRANSIT -j ACCEPT

# Vers VLAN 20 (Test) - communication interne
iptables -A FORWARD -i $BR10 -o $BR20 -j ACCEPT

# Vers DMZ (VLAN 30 via FW01) - si nécessaire
# Le trafic passe par 10.10.5.1 puis FW01 route vers DMZ
iptables -A FORWARD -i $BR10 -o $TRANSIT -d $NET_VLAN30 -j ACCEPT

#-----------------------------------------------------
# VLAN 20 (Test/Clients) → Accès contrôlé
#-----------------------------------------------------
# Vers Internet (via VLAN 5 → FW01)
iptables -A FORWARD -i $BR20 -o $TRANSIT -j ACCEPT

# Vers VLAN 10 - Services Active Directory
iptables -A FORWARD -i $BR20 -o $BR10 -p udp --dport 53 -j ACCEPT    # DNS
iptables -A FORWARD -i $BR20 -o $BR10 -p tcp --dport 53 -j ACCEPT    # DNS
iptables -A FORWARD -i $BR20 -o $BR10 -p udp --dport 67:68 -j ACCEPT # DHCP
iptables -A FORWARD -i $BR20 -o $BR10 -p tcp --dport 88 -j ACCEPT    # Kerberos
iptables -A FORWARD -i $BR20 -o $BR10 -p udp --dport 88 -j ACCEPT    # Kerberos
iptables -A FORWARD -i $BR20 -o $BR10 -p tcp --dport 135 -j ACCEPT   # RPC
iptables -A FORWARD -i $BR20 -o $BR10 -p tcp --dport 139 -j ACCEPT   # NetBIOS
iptables -A FORWARD -i $BR20 -o $BR10 -p tcp --dport 389 -j ACCEPT   # LDAP
iptables -A FORWARD -i $BR20 -o $BR10 -p udp --dport 389 -j ACCEPT   # LDAP
iptables -A FORWARD -i $BR20 -o $BR10 -p tcp --dport 445 -j ACCEPT   # SMB
iptables -A FORWARD -i $BR20 -o $BR10 -p tcp --dport 464 -j ACCEPT   # Kerberos passwd
iptables -A FORWARD -i $BR20 -o $BR10 -p tcp --dport 636 -j ACCEPT   # LDAPS
iptables -A FORWARD -i $BR20 -o $BR10 -p tcp --dport 3268:3269 -j ACCEPT # Global Catalog

# Vers VLAN 10 - Services applicatifs
iptables -A FORWARD -i $BR20 -o $BR10 -p tcp --dport 80 -j ACCEPT    # HTTP (GLPI)
iptables -A FORWARD -i $BR20 -o $BR10 -p tcp --dport 443 -j ACCEPT   # HTTPS
iptables -A FORWARD -i $BR20 -o $BR10 -p udp --dport 5060 -j ACCEPT  # SIP (VoIP)
iptables -A FORWARD -i $BR20 -o $BR10 -p tcp --dport 5060 -j ACCEPT  # SIP
iptables -A FORWARD -i $BR20 -o $BR10 -p udp --dport 10000:20000 -j ACCEPT # RTP (VoIP)

# Vers VLAN 10 - WSUS
iptables -A FORWARD -i $BR20 -o $BR10 -p tcp --dport 8530 -j ACCEPT  # WSUS HTTP
iptables -A FORWARD -i $BR20 -o $BR10 -p tcp --dport 8531 -j ACCEPT  # WSUS HTTPS

# Vers DMZ (VLAN 30) - Messagerie (via FW01)
# Le trafic vers 172.16.30.x passe par la route par défaut (10.10.5.1)
iptables -A FORWARD -i $BR20 -o $TRANSIT -d $NET_VLAN30 -j ACCEPT

#-----------------------------------------------------
# Depuis VLAN 5 (réponses)
#-----------------------------------------------------
# Déjà couvert par ESTABLISHED,RELATED

#=====================================================
# LOGGING (optionnel - pour debug)
#=====================================================
# Décommenter pour activer les logs
#iptables -A INPUT -j LOG --log-prefix "FW02-INPUT-DROP: " --log-level 4
#iptables -A FORWARD -j LOG --log-prefix "FW02-FORWARD-DROP: " --log-level 4

#=====================================================
# Sauvegarder les règles
#=====================================================
iptables-save > /etc/iptables/rules.v4

echo "=========================================="
echo "  Règles iptables FW02 appliquées !"
echo "=========================================="
echo ""
echo "Interfaces :"
echo "  - Transit (VLAN 5) : $TRANSIT"
echo "  - Serveurs (VLAN 10) : $BR10"
echo "  - Test (VLAN 20) : $BR20"
echo ""
echo "Règles actives :"
iptables -L -v -n --line-numbers | head -50
```

### 6.2 Exécuter et rendre persistant

```bash
# Exécuter le script
/usr/local/bin/fw02-iptables.sh

# Vérifier que iptables-persistent est installé
apt install -y iptables-persistent

# Les règles sont automatiquement sauvegardées dans /etc/iptables/rules.v4
```

### 6.3 Alternative : nftables (Debian 13 default)

Debian 13 utilise nftables par défaut. Voici la même configuration :

```bash
nano /etc/nftables.conf
```

```bash
#!/usr/sbin/nft -f
#=====================================================
# FW02 Debian 13 - Configuration nftables
# Projet Ekoloclast
#=====================================================

flush ruleset

table inet filter {
    
    chain input {
        type filter hook input priority 0; policy drop;
        
        # Loopback
        iif "lo" accept
        
        # Connexions établies
        ct state established,related accept
        
        # SSH depuis VLAN 10 et 20
        iifname "br10" tcp dport 22 accept
        iifname "br20" tcp dport 22 accept
        
        # ICMP
        icmp type echo-request accept
        icmp type echo-reply accept
    }
    
    chain forward {
        type filter hook forward priority 0; policy drop;
        
        # Connexions établies
        ct state established,related accept
        
        # VLAN 10 → Tout
        iifname "br10" oifname "enp0s3" accept
        iifname "br10" oifname "br20" accept
        
        # VLAN 20 → Internet
        iifname "br20" oifname "enp0s3" accept
        
        # VLAN 20 → VLAN 10 (services spécifiques)
        iifname "br20" oifname "br10" tcp dport { 53, 80, 88, 135, 139, 389, 443, 445, 636, 3268, 3269, 5060, 8530, 8531 } accept
        iifname "br20" oifname "br10" udp dport { 53, 67, 68, 88, 389, 5060 } accept
        iifname "br20" oifname "br10" udp dport 10000-20000 accept
    }
    
    chain output {
        type filter hook output priority 0; policy accept;
    }
}
```

```bash
# Activer nftables
systemctl enable nftables
systemctl start nftables

# Vérifier
nft list ruleset
```

---

## 7. Mise à jour configuration FW01 pfSense

### 7.1 Interfaces FW01 (corrigées)

Comme la DMZ est maintenant directement sur pfSense :

| Interface | Port | Réseau | IP |
|-----------|------|--------|-----|
| WAN | em0 | 192.168.1.0/24 | DHCP ou .2 |
| LAN | em1 | 10.10.5.0/29 | 10.10.5.1 |
| **DMZ** | **em2** | **172.16.30.0/28** | **172.16.30.14** |

### 7.2 Configuration interface DMZ sur pfSense

**Interfaces → Assignments → Add (em2)**

**Interfaces → OPT1 (renommer en DMZ)**

| Paramètre | Valeur |
|-----------|--------|
| Enable | ✓ |
| Description | DMZ |
| IPv4 Configuration | Static IPv4 |
| IPv4 Address | 172.16.30.14 |
| IPv4 Subnet | 28 |

### 7.3 Routes statiques sur FW01

**System → Routing → Static Routes**

| Destination | Gateway | Description |
|-------------|---------|-------------|
| 172.16.10.0/28 | 10.10.5.2 (FW02) | VLAN 10 Serveurs |
| 172.16.20.0/28 | 10.10.5.2 (FW02) | VLAN 20 Test |

> **Note** : Pas besoin de route pour VLAN 30 car c'est directement connecté à FW01.

### 7.4 Règles firewall DMZ sur pfSense

**Firewall → Rules → DMZ**

```
┌─────────────────────────────────────────────────────────────────────┐
│                    RÈGLES DMZ - FW01 pfSense                        │
├─────────────────────────────────────────────────────────────────────┤
│  #   Action   Proto    Source          Dest           Port          │
├─────────────────────────────────────────────────────────────────────┤
│  1   Pass     TCP      DMZ net         any            53,80,443     │
│                                                       25,587,465    │
│  2   Pass     UDP      DMZ net         any            53,123        │
│  3   Pass     TCP      DMZ net         172.16.10.1    53            │
│  4   Block    *        DMZ net         LAN net        *             │
│  5   Block    *        DMZ net         172.16.10.0/28 *             │
│  6   Block    *        DMZ net         172.16.20.0/28 *             │
│  7   Block    *        any             any            *    [LOG]    │
└─────────────────────────────────────────────────────────────────────┘
```

---

## 8. Tests et validation

### 8.1 Tests depuis FW02

```bash
# Test vers FW01 (VLAN 5)
ping -c 3 10.10.5.1

# Test vers Internet (via FW01)
ping -c 3 8.8.8.8

# Test DNS
host www.google.com

# Vérifier les bridges
brctl show

# Vérifier la table de routage
ip route show
```

### 8.2 Tests depuis CLIWIN01 (VLAN 20)

```cmd
REM Configuration IP (si manuelle)
netsh interface ip set address "Ethernet" static 172.16.20.1 255.255.255.240 172.16.20.14
netsh interface ip set dns "Ethernet" static 172.16.10.1

REM Test passerelle (FW02)
ping 172.16.20.14

REM Test serveur AD (VLAN 10)
ping 172.16.10.1

REM Test Internet
ping 8.8.8.8

REM Test DMZ (via FW01)
ping 172.16.30.1

REM Traceroute vers DMZ
tracert 172.16.30.1
REM Résultat attendu :
REM   1. 172.16.20.14 (FW02)
REM   2. 10.10.5.1    (FW01)
REM   3. 172.16.30.1  (SRVLX01)
```

### 8.3 Tests depuis SRVLX01 (DMZ - VLAN 30)

```bash
# Test passerelle (FW01)
ping -c 3 172.16.30.14

# Test Internet
ping -c 3 8.8.8.8

# Test DNS interne (devrait fonctionner si règle autorisée)
ping -c 3 172.16.10.1

# Test VLAN 10 (devrait être BLOQUÉ par le firewall)
ping -c 3 172.16.10.2
# Résultat attendu : timeout (bloqué)

# Test VLAN 20 (devrait être BLOQUÉ)
ping -c 3 172.16.20.1
# Résultat attendu : timeout (bloqué)
```

### 8.4 Schéma des flux de test

```
┌─────────────────────────────────────────────────────────────────────┐
│                    FLUX DE TEST VALIDÉS                             │
├─────────────────────────────────────────────────────────────────────┤
│                                                                     │
│  CLIWIN01 (VLAN 20) ──► SRVWIN01 (VLAN 10)                        │
│     172.16.20.1    ──►    172.16.10.1                              │
│     Chemin : CLIWIN01 → br20 → FW02 → br10 → SRVWIN01             │
│     ✓ AUTORISÉ (services AD)                                       │
│                                                                     │
│  CLIWIN01 (VLAN 20) ──► Internet                                   │
│     172.16.20.1    ──►    8.8.8.8                                  │
│     Chemin : CLIWIN01 → br20 → FW02 → enp0s3 → FW01 → WAN         │
│     ✓ AUTORISÉ                                                     │
│                                                                     │
│  CLIWIN01 (VLAN 20) ──► SRVLX01 (DMZ)                             │
│     172.16.20.1    ──►    172.16.30.1                              │
│     Chemin : CLIWIN01 → FW02 → FW01 → DMZ → SRVLX01               │
│     ✓ AUTORISÉ (messagerie)                                        │
│                                                                     │
│  SRVLX01 (DMZ) ──► SRVWIN01 (VLAN 10)                             │
│     172.16.30.1  ──►  172.16.10.1                                  │
│     Chemin : SRVLX01 → FW01 (BLOQUÉ par règle DMZ)                │
│     ✗ BLOQUÉ (sécurité DMZ)                                        │
│                                                                     │
└─────────────────────────────────────────────────────────────────────┘
```

---

## 9. Récapitulatif final

### 9.1 Architecture finale

```
                              INTERNET
                                  │
                            ┌─────┴─────┐
                            │  BOX FAI  │
                            │192.168.1.1│
                            └─────┬─────┘
                                  │
┌─────────────────────────────────┴─────────────────────────────────────┐
│                         FW01 pfSense                                  │
│  WAN: 192.168.1.x │ LAN: 10.10.5.1/29 │ DMZ: 172.16.30.14/28        │
└─────────┬───────────────────┬───────────────────┬─────────────────────┘
          │                   │                   │
     (Internet)          VLAN 5              VLAN 30
                         Transit               DMZ
                              │                   │
                              │              ┌────┴────┐
                              │              │ SW-C    │
                              │              └────┬────┘
                              │                   │
                              │              ┌────┴────┐
                              │              │SRVLX01  │
                              │              │172.16.  │
                              │              │30.1/28  │
                              │              └─────────┘
                              │
┌─────────────────────────────┴─────────────────────────────────────────┐
│                         FW02 Debian 13                                │
│                    (Routeur + Switch virtuel)                         │
│                                                                       │
│  enp0s3: 10.10.5.2/29  │  br10: 172.16.10.14/28  │  br20: 172.16.20.14/28  │
└─────────────────────────┬───────────────────────────┬─────────────────┘
                          │                           │
                     VLAN 10                      VLAN 20
                     Serveurs                       Test
                          │                           │
              ┌───────────┴───────────┐       ┌───────┴───────┐
              │        SW-B           │       │    (via SW-B)  │
              │       (48P)           │       │               │
              └───────────┬───────────┘       │               │
                          │                   │               │
              ┌───────────┴───────────┐       │               │
              │        SW-A           │       │               │
              │        (8P)           │       │               │
              └───┬───┬───┬───┬───────┘       │               │
                  │   │   │   │               │               │
                  ▼   ▼   ▼   ▼               ▼               ▼
          ┌──────┬──────┬──────┬──────┐  ┌────────┐    ┌────────┐
          │SRV   │IPBX  │SRV   │SRVLX │  │CLIWIN  │    │CLIWIN  │
          │WIN01 │01    │WIN04 │02    │  │01      │    │02      │
          │.10.1 │.10.2 │.10.3 │.10.4 │  │.20.1   │    │.20.2   │
          └──────┴──────┴──────┴──────┘  └────────┘    └────────┘
```

### 9.2 Checklist de déploiement

#### FW02 Debian 13

- [ ] VM créée avec 3 cartes réseau
- [ ] Mode promiscuité activé sur cartes 2 et 3
- [ ] Debian 13 installé (netinst)
- [ ] Paquets installés : bridge-utils, iptables, etc.
- [ ] `/etc/network/interfaces` configuré avec bridges
- [ ] IP forwarding activé (`sysctl -p`)
- [ ] Bridges créés et UP (`brctl show`)
- [ ] Table de routage correcte (`ip route`)
- [ ] iptables configuré et persistant
- [ ] Tests ping inter-VLAN OK

#### FW01 pfSense

- [ ] Interface DMZ (em2) configurée : 172.16.30.14/28
- [ ] Routes statiques vers VLAN 10 et 20 via 10.10.5.2
- [ ] Règles firewall DMZ configurées
- [ ] NAT outbound pour tous les réseaux internes

### 9.3 Fichiers de configuration

| Fichier | Contenu |
|---------|---------|
| `/etc/network/interfaces` | Configuration bridges et IPs |
| `/etc/sysctl.conf` | ip_forward + sécurité |
| `/etc/iptables/rules.v4` | Règles firewall |
| `/usr/local/bin/fw02-iptables.sh` | Script de configuration |

---

**Document créé pour le projet Ekoloclast**
**FW02 Debian 13 - Routeur/Switch avec Bridges**
**DMZ sur FW01 pfSense**
