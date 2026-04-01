# 🔧 Guide Manipulation Switch Cisco (Oral TSSR)

## Connexion au Switch

- Câble **console** branché sur le port Console du switch
- **PuTTY** → connexion **Serial**, port **COM** (visible dans le Gestionnaire de périphériques), vitesse **9600 bauds**

---

## Modes de navigation

```
Switch>                     ← Mode utilisateur
Switch> enable
Switch#                     ← Mode privilégié
Switch# configure terminal
Switch(config)#             ← Mode configuration globale
```

> 💡 **Astuce `do`** : depuis le mode config, tu peux lancer n'importe quelle commande `show` ou `wr` en ajoutant `do` devant.  
> Exemple : `do show vlan brief`, `do wr`

---

## VLANs

### Créer et nommer une VLAN

```
Switch(config)# vlan 50
Switch(config-vlan)# name Comptabilite
Switch(config-vlan)# exit
```

### Renommer une VLAN existante

```
Switch(config)# vlan 50
Switch(config-vlan)# name NouveauNom
Switch(config-vlan)# exit
```

### Supprimer une VLAN

```
Switch(config)# no vlan 50
```

---

## Ports ACCESS

### Configurer un seul port

```
Switch(config)# interface fastEthernet 0/10
Switch(config-if)# switchport mode access
Switch(config-if)# switchport access vlan 50
Switch(config-if)# exit
```

### Configurer une plage de ports

```
Switch(config)# interface range fastEthernet 0/1 - 12
Switch(config-if-range)# switchport mode access
Switch(config-if-range)# switchport access vlan 10
Switch(config-if-range)# exit
```

---

## Port TRUNK

Le trunk transporte **plusieurs VLANs** sur un seul lien (switch ↔ switch ou switch ↔ routeur).

### Configurer un port en trunk

```
Switch(config)# interface gigabitEthernet 0/1
Switch(config-if)# switchport mode trunk
Switch(config-if)# exit
```

### Limiter les VLANs autorisées sur le trunk

```
Switch(config-if)# switchport trunk allowed vlan 10,20,30
```

### Ajouter une VLAN au trunk (sans écraser les autres)

```
Switch(config-if)# switchport trunk allowed vlan add 50
```

---

## Activer / Désactiver un port

```
Switch(config)# interface fastEthernet 0/10
Switch(config-if)# shutdown           ← désactive le port
Switch(config-if)# no shutdown        ← réactive le port
```

### Port err-disabled (port en panne/erreur)

> ⚠️ **Piège classique** : un simple `no shutdown` ne suffit pas.  
> Il faut d'abord faire `shutdown` PUIS `no shutdown` pour réinitialiser le port.

```
Switch(config)# interface fastEthernet 0/10
Switch(config-if)# shutdown
Switch(config-if)# no shutdown
Switch(config-if)# exit
```

---

## Adresse IP sur une VLAN (Interface SVI)

Utile pour l'administration à distance du switch (SSH, Telnet, ping).

```
Switch(config)# interface vlan 90
Switch(config-if)# ip address 192.168.99.254 255.255.255.0
Switch(config-if)# no shutdown
Switch(config-if)# exit
```

### Passerelle par défaut du switch

```
Switch(config)# ip default-gateway 192.168.99.1
```

---

## Configuration SSH

### Étape 1 — Prérequis (hostname + domaine)

```
Switch(config)# hostname SW1
SW1(config)# ip domain-name tssr.lan
```

### Étape 2 — Générer la clé RSA

```
SW1(config)# crypto key generate rsa
```

> Quand il demande la taille, taper **1024** ou **2048**.

### Étape 3 — Créer un utilisateur local

```
SW1(config)# username admin privilege 15 secret P@ssw0rd
```

### Étape 4 — Configurer les lignes VTY pour SSH

```
SW1(config)# line vty 0 4
SW1(config-line)# transport input ssh
SW1(config-line)# login local
SW1(config-line)# exit
```

### Étape 5 — Forcer SSH version 2

```
SW1(config)# ip ssh version 2
```

### Test de connexion SSH

Depuis un PC ou un autre équipement :

```
ssh -l admin 192.168.99.254
```

> 📝 **Note** : même si le SSH ne renvoie pas de réponse sur le switch physique de l'oral, le jury veut voir que tu connais les étapes de configuration.

---

## Commandes de vérification

| Commande | Description |
|----------|-------------|
| `show vlan brief` | Liste des VLANs et ports associés |
| `show interfaces trunk` | Ports trunk et VLANs autorisées |
| `show ip interface brief` | État UP/DOWN de toutes les interfaces |
| `show interfaces status` | État détaillé de chaque port |
| `show interfaces f0/10 switchport` | Détail VLAN/mode d'un port précis |
| `show ip ssh` | Vérifier si SSH est activé |
| `show running-config` | Configuration complète en cours |

> Depuis le mode config : `do sh vlan brief`, `do sh ip int br`, `do sh interfaces trunk`

---

## Sauvegarder la configuration

```
Switch# copy running-config startup-config
```

ou simplement :

```
Switch# wr
```

---

## 🎯 Conseils pour l'oral

1. **Annonce** chaque action au jury avant de taper la commande
2. **Vérifie** après chaque manip avec un `show` (`do sh vlan brief`, `do sh interfaces trunk`)
3. **Sauvegarde** à la fin avec `wr` — ça montre que tu es rigoureux
4. Si tu te trompes, pas de panique : `no` + la commande annule ce que tu viens de faire



# Routage Inter-VLAN sur Cisco

## Table des matières

- [1. Router-on-a-Stick (sous-interfaces)](#1-router-on-a-stick-sous-interfaces)
- [2. Routage par Switch L3 (SVI)](#2-routage-par-switch-l3-svi)
- [3. Comparaison des deux méthodes](#3-comparaison-des-deux-méthodes)
- [4. Le tagging 802.1Q](#4-le-tagging-8021q)
- [5. Commandes d'affichage des routes](#5-commandes-daffichage-des-routes)

---

## 1. Router-on-a-Stick (sous-interfaces)

Un seul lien **trunk** entre le switch et le routeur, avec une **sous-interface** par VLAN.

### Configuration du Switch (trunk vers le routeur)

```cisco
Switch(config)# interface GigabitEthernet0/1
Switch(config-if)# switchport mode trunk
Switch(config-if)# switchport trunk allowed vlan 10,20,30
```

### Configuration du Routeur (sous-interfaces)

```cisco
! Activation de l'interface physique
Router(config)# interface GigabitEthernet0/0
Router(config-if)# no shutdown

! Sous-interface pour le VLAN 10
Router(config)# interface GigabitEthernet0/0.10
Router(config-subif)# encapsulation dot1Q 10
Router(config-subif)# ip address 192.168.10.1 255.255.255.0

! Sous-interface pour le VLAN 20
Router(config)# interface GigabitEthernet0/0.20
Router(config-subif)# encapsulation dot1Q 20
Router(config-subif)# ip address 192.168.20.1 255.255.255.0

! Sous-interface pour le VLAN 30
Router(config)# interface GigabitEthernet0/0.30
Router(config-subif)# encapsulation dot1Q 30
Router(config-subif)# ip address 192.168.30.1 255.255.255.0
```

> **Note :** Chaque sous-interface (`.10`, `.20`, `.30`) agit comme **passerelle par défaut** pour les hôtes du VLAN correspondant.

---

## 2. Routage par Switch L3 (SVI)

Sur un switch multicouche (Catalyst 3560/3650/9300), le routage se fait directement sur le switch via des **SVI** (Switch Virtual Interfaces).

```cisco
! Activer le routage IP sur le switch (commande obligatoire)
Switch(config)# ip routing

! SVI pour le VLAN 10
Switch(config)# interface vlan 10
Switch(config-if)# ip address 192.168.10.1 255.255.255.0
Switch(config-if)# no shutdown

! SVI pour le VLAN 20
Switch(config)# interface vlan 20
Switch(config-if)# ip address 192.168.20.1 255.255.255.0
Switch(config-if)# no shutdown

! SVI pour le VLAN 30
Switch(config)# interface vlan 30
Switch(config-if)# ip address 192.168.30.1 255.255.255.0
Switch(config-if)# no shutdown
```

> **Important :** Sans la commande `ip routing`, le switch ne route pas entre les VLANs.

---

## 3. Comparaison des deux méthodes

| Critère | Router-on-a-Stick | Switch L3 (SVI) |
|---|---|---|
| **Équipement** | Routeur + Switch L2 | Switch L3 seul |
| **Performance** | Limitée (un seul lien) | Meilleure (routage matériel) |
| **Coût** | Moins cher | Plus cher (switch L3) |
| **Cas d'usage** | Petit réseau / lab | Réseau de production |

---

## 4. Le tagging 802.1Q

### Principe

Sur un lien **trunk**, le switch ajoute un **tag 802.1Q** dans l'en-tête Ethernet de chaque trame. Ce tag contient le **VLAN ID**.

Côté routeur, la commande `encapsulation dot1Q [vlan-id]` indique quelle sous-interface traite les trames tagguées avec ce VLAN ID.

### Exemple de flux

Un PC dans le VLAN 10 (`192.168.10.10`) ping un PC dans le VLAN 20 (`192.168.20.10`) :

```
1. PC VLAN 10 envoie le paquet vers sa passerelle (192.168.10.1)
2. Le switch tagge la trame avec VLAN 10 sur le trunk
3. Le routeur reçoit la trame sur Gi0/0.10 (encapsulation dot1Q 10)
4. Le routeur route le paquet vers 192.168.20.0/24
5. Le routeur envoie la trame par Gi0/0.20 avec le tag VLAN 20
6. Le switch reçoit la trame, lit le tag 20, transmet au port access du VLAN 20
7. Le PC VLAN 20 reçoit le paquet
```

### Schéma

```
PC VLAN 10 ──► [Switch port access] ──► [Trunk tagué] ──► Routeur Gi0/0.10
                                                              │ (route)
PC VLAN 20 ◄── [Switch port access] ◄── [Trunk tagué] ◄── Routeur Gi0/0.20
```

### VLAN natif

Le VLAN natif (par défaut VLAN 1) circule **sans tag** sur le trunk. Configuration :

```cisco
Router(config)# interface GigabitEthernet0/0.1
Router(config-subif)# encapsulation dot1Q 1 native
```

> Le mot-clé `native` indique que les trames de ce VLAN ne sont pas tagguées.

---

## 5. Commandes d'affichage des routes

### Table de routage complète

```cisco
Router# show ip route
```

### Codes de la table de routage

| Code | Signification |
|------|---------------|
| `C` | Connected – réseau directement connecté |
| `L` | Local – IP exacte de l'interface |
| `S` | Static – route statique |
| `O` | OSPF |
| `R` | RIP |
| `D` | EIGRP |
| `B` | BGP |

### Filtrer par type de route

```cisco
Router# show ip route static         ! Routes statiques uniquement
Router# show ip route connected       ! Réseaux connectés uniquement
Router# show ip route ospf            ! Routes OSPF uniquement
```

### Vérifier une route précise

```cisco
Router# show ip route 192.168.20.0
```

### Exemple de sortie (Router-on-a-Stick)

```
Router# show ip route

C    192.168.10.0/24 is directly connected, GigabitEthernet0/0.10
L    192.168.10.1/32 is directly connected, GigabitEthernet0/0.10
C    192.168.20.0/24 is directly connected, GigabitEthernet0/0.20
L    192.168.20.1/32 is directly connected, GigabitEthernet0/0.20
C    192.168.30.0/24 is directly connected, GigabitEthernet0/0.30
L    192.168.30.1/32 is directly connected, GigabitEthernet0/0.30
```

### Autres commandes utiles

```cisco
Router# show ip interface brief       ! État rapide de toutes les interfaces
Router# show ip protocols             ! Protocoles de routage actifs (OSPF, RIP...)
Router# show ip route summary         ! Résumé avec le nombre de routes par type
```

---

> **Astuce CCNA :** `show ip route` et `show ip interface brief` sont les deux commandes les plus utilisées en troubleshooting et tombent régulièrement à l'examen.
