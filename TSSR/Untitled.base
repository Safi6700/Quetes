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
