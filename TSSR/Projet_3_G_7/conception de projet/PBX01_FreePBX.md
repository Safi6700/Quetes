i# Installation et Configuration IPBX01 - FreePBX 16 (Serveur VoIP)

## Projet Ekoloclast - Infrastructure tssr.lan

---

## 📋 Informations du serveur

| Paramètre | Valeur |
|-----------|--------|
| Nom | IPBX01 |
| Hostname | `ipbx01.tssr.lan` |
| OS | FreePBX Distro 16 (basé sur CentOS) |
| Rôle | Serveur téléphonie VoIP (FreePBX/Asterisk) |
| IP | 172.16.10.5/28 |
| Passerelle | 172.16.10.14 (FW02) |
| DNS | 172.16.10.2 (SRVWIN01) |
| Zone | LAN_SRV |

---

## 📋 Architecture réseau

```
                              INTERNET
                                  │
                                  ▼
                          ┌─────────────┐
                          │   BOX FAI   │
                          └──────┬──────┘
                                 │
                         ┌───────┴───────┐
                         │  FW01 pfSense │
                         └───────┬───────┘
                                 │
                         ┌───────┴───────┐
                         │  FW02 Debian  │
                         │  172.16.10.14 │
                         └───────┬───────┘
                                 │
              ───────────────────┴───────────────────
              │              LAN_SRV                │
              │           172.16.10.0/28            │
              ──────────────────────────────────────
                   │      │      │      │
                   ▼      ▼      ▼      ▼
            ┌────────┐ ┌────────┐ ┌────────┐ ┌────────┐
            │SRVWIN01│ │SRVLX02 │ │SRVWIN04│ │ IPBX01 │
            │  .2    │ │  .3    │ │  .4    │ │  .5    │ ← CE SERVEUR
            │ AD/DNS │ │ GLPI   │ │ WSUS   │ │FreePBX │
            └────────┘ └────────┘ └────────┘ └────────┘
                                                  │
                                                  │ SIP (5060)
                                                  │ RTP (10000-20000)
                                                  ▼
                                    ┌─────────────────────────┐
                                    │       LAN_TEST          │
                                    │    172.16.20.0/28       │
                                    ├────────────┬────────────┤
                                    │  CLIWIN01  │  CLIWIN02  │
                                    │  MicroSIP  │  MicroSIP  │
                                    └────────────┴────────────┘
```

---

## 📋 Ports utilisés

| Port | Protocole | Service | Description |
|------|-----------|---------|-------------|
| 5060 | UDP/TCP | SIP | Signalisation appels |
| 10000-20000 | UDP | RTP | Flux audio |
| 80 | TCP | HTTP | Interface web FreePBX |
| 443 | TCP | HTTPS | Interface web sécurisée |
| 22 | TCP | SSH | Administration |

---

## 📋 Plan de numérotation

| Poste | Extension | Nom | Mot de passe |
|-------|-----------|-----|--------------|
| CLIWIN01 | 20001 | Safi WILDER | 1234 |
| CLIWIN01 | 20002 | Admin IT | 1234 |
| CLIWIN02 | 20003 | Support | 1234 |
| CLIWIN02 | 20004 | Direction | 1234 |

---

## 1. Configuration VirtualBox

### 1.1 Paramètres VM

| Paramètre | Valeur |
|-----------|--------|
| Nom | IPBX01 |
| Type | Linux |
| Version | Red Hat (64-bit) ou Other Linux (64-bit) |
| RAM | **1024 MB** (minimum) |
| CPU | 1 vCPU |
| Disque | **20 GB** |

### 1.2 Carte réseau

| Paramètre | Valeur |
|-----------|--------|
| Adapter 1 | Internal Network |
| Name | `LAN_SRV` |
| Adapter Type | Intel PRO/1000 MT Desktop |
| Cable Connected | ✅ |

---

## 2. Téléchargement de FreePBX Distro

### 2.1 Télécharger l'ISO

Aller sur le site officiel :

```
https://www.freepbx.org/downloads/
```

Télécharger la dernière version **FreePBX Distro 16**.

### 2.2 Insérer l'ISO

1. Dans VirtualBox, sélectionner la VM IPBX01
2. **Settings** → **Storage** → **Controller: IDE**
3. Cliquer sur l'icône CD → **Choose a disk file**
4. Sélectionner l'ISO FreePBX

---

## 3. Installation de FreePBX Distro

### 3.1 Démarrage

1. Démarrer la VM
2. Au menu de démarrage, choisir la **version recommandée**

### 3.2 Type d'installation

Sélectionner :

```
Graphical Installation - Output to VGA
```

### 3.3 Type de distribution

Choisir :

```
FreePBX Standard
```

### 3.4 Configuration du mot de passe root

Pendant l'installation, cliquer sur **ROOT PASSWORD** :

| Champ | Valeur |
|-------|--------|
| Root Password | `Azerty1*` |
| Confirm | `Azerty1*` |

> ⚠️ **Attention** : Le clavier est en QWERTY pendant l'installation !

### 3.5 Fin de l'installation

1. Attendre la fin de l'installation
2. **Éteindre la VM**
3. **Retirer l'ISO** du lecteur
4. **Redémarrer la VM**

---

## 4. Configuration réseau du serveur

### 4.1 Se connecter en root

```
Login: root
Password: Azerty1*
```

### 4.2 Vérifier les cartes réseau

```bash
ip a
```

### 4.3 Configurer l'IP statique

Éditer le fichier de configuration réseau :

```bash
vi /etc/sysconfig/network-scripts/ifcfg-eth0
```

Modifier le contenu :

```
DEVICE=eth0
BOOTPROTO=static
ONBOOT=yes
IPADDR=172.16.10.5
NETMASK=255.255.255.240
GATEWAY=172.16.10.14
DNS1=172.16.10.2
```

### 4.4 Redémarrer le réseau

```bash
systemctl restart network
```

### 4.5 Vérifier la configuration

```bash
ip a
ping -c 3 172.16.10.14
ping -c 3 172.16.10.2
```

---

## 5. Configuration du clavier français

### 5.1 Vérifier la configuration actuelle

```bash
localectl
```

### 5.2 Appliquer la configuration française

```bash
# Définir la locale système en français
localectl set-locale LANG=fr_FR.utf8

# Définir le clavier console en français
localectl set-keymap fr

# Définir le clavier X11 en français
localectl set-x11-keymap fr
```

### 5.3 Vérifier

```bash
localectl
```

Résultat attendu :

```
System Locale: LANG=fr_FR.UTF-8
    VC Keymap: fr
   X11 Layout: fr
```

---

## 6. Création d'un utilisateur SSH

### 6.1 Créer l'utilisateur

```bash
adduser safi
passwd safi
```

Entrer le mot de passe : `Azerty1*`

### 6.2 Configurer SSH

```bash
vi /etc/ssh/sshd_config
```

Modifier ces lignes :

```
PermitRootLogin no
AllowUsers safi
PasswordAuthentication yes
```

### 6.3 Redémarrer SSH

```bash
systemctl restart sshd
```

### 6.4 Tester la connexion SSH

Depuis un client :

```bash
ssh safi@172.16.10.5
```

Pour passer root après connexion :

```bash
su -
```

---

## 7. Configuration DNS sur SRVWIN01

### 7.1 Ajouter l'enregistrement A

Sur **SRVWIN01** → **DNS Manager** :

1. **Forward Lookup Zones** → **tssr.lan**
2. Clic droit → **New Host (A or AAAA)**

| Champ | Valeur |
|-------|--------|
| Name | `ipbx01` |
| IP address | `172.16.10.5` |

3. **Add Host**

### 7.2 Vérifier

Depuis un client :

```cmd
nslookup ipbx01.tssr.lan
```

---

## 8. Connexion à l'interface Web FreePBX

### 8.1 Accéder à l'interface

Depuis un navigateur (CLIWIN01 ou SRVWIN01) :

```
http://172.16.10.5
```

ou

```
http://ipbx01.tssr.lan
```

### 8.2 Configuration initiale

Au premier accès, créer le compte administrateur :

| Champ | Valeur |
|-------|--------|
| Username | `admin` |
| Password | `Azerty1*` |
| Confirm Password | `Azerty1*` |
| Email Address | `admin@tssr.lan` |

Cliquer **Create Account**

### 8.3 Se connecter

| Champ | Valeur |
|-------|--------|
| Username | `admin` |
| Password | `Azerty1*` |

---

## 9. Mise à jour des modules FreePBX

### 9.1 Accéder au gestionnaire de modules

1. **Admin** → **Module Admin**
2. Cliquer sur **Check Online**

### 9.2 Mettre à jour les modules

1. Sélectionner tous les modules à mettre à jour
2. Cliquer sur **Upgrade All**
3. Cliquer sur **Process**
4. Confirmer avec **Confirm**

### 9.3 Appliquer les changements

Cliquer sur le bouton rouge **Apply Config** en haut de la page.

---

## 10. Création des extensions (lignes VoIP)

### 10.1 Accéder au menu Extensions

1. **Applications** → **Extensions**
2. Onglet **SIP [chan_pjsip] Extensions**
3. Cliquer sur **+ Add New SIP [chan_pjsip] Extension**

### 10.2 Créer l'extension 20001 - Safi WILDER

| Champ | Valeur |
|-------|--------|
| User Extension | `20001` |
| Display Name | `Safi WILDER` |
| Secret | `1234` |
| Password For New User | `1234` |

Cliquer **Submit**

### 10.3 Créer l'extension 20002 - Admin IT

1. **Applications** → **Extensions**
2. Onglet **SIP [chan_pjsip] Extensions**
3. Cliquer sur **+ Add New SIP [chan_pjsip] Extension**

| Champ | Valeur |
|-------|--------|
| User Extension | `20002` |
| Display Name | `Admin IT` |
| Secret | `1234` |

Cliquer **Submit**

### 10.4 Créer l'extension 20003 - Support

1. **Applications** → **Extensions**
2. Onglet **SIP [chan_pjsip] Extensions**
3. Cliquer sur **+ Add New SIP [chan_pjsip] Extension**

| Champ | Valeur |
|-------|--------|
| User Extension | `20003` |
| Display Name | `Support` |
| Secret | `1234` |

Cliquer **Submit**

### 10.5 Créer l'extension 20004 - Direction

1. **Applications** → **Extensions**
2. Onglet **SIP [chan_pjsip] Extensions**
3. Cliquer sur **+ Add New SIP [chan_pjsip] Extension**

| Champ | Valeur |
|-------|--------|
| User Extension | `20004` |
| Display Name | `Direction` |
| Secret | `1234` |

Cliquer **Submit**

### 10.6 Appliquer la configuration

Cliquer sur le bouton rouge **Apply Config** en haut de la page.

> ✅ Les 4 lignes téléphoniques sont créées !

---

## 11. Récapitulatif des extensions

| Extension | Nom | Secret | Poste |
|-----------|-----|--------|-------|
| 20001 | Safi WILDER | 1234 | CLIWIN01 |
| 20002 | Admin IT | 1234 | CLIWIN01 |
| 20003 | Support | 1234 | CLIWIN02 |
| 20004 | Direction | 1234 | CLIWIN02 |

---

## 12. Installation du softphone MicroSIP

### 12.1 Télécharger MicroSIP

Sur **CLIWIN01** et **CLIWIN02**, télécharger :

```
https://www.microsip.org/downloads
```

Télécharger : **MicroSIP-3.21.3.exe** (ou dernière version)

### 12.2 Installer MicroSIP

1. Exécuter le fichier téléchargé
2. Suivre les étapes d'installation
3. Lancer **MicroSIP**

---

## 13. Configuration de MicroSIP sur CLIWIN01

### 13.1 Ajouter un compte

1. Lancer **MicroSIP**
2. Clic droit sur la fenêtre → **Account** (ou **Compte**)
3. Cliquer sur **Add** (ou **Ajouter**)

### 13.2 Configurer le compte Safi WILDER

| Champ | Valeur |
|-------|--------|
| Account Name | `Safi WILDER` |
| SIP Server | `172.16.10.5` |
| SIP Proxy | (laisser vide) |
| Username | `20001` |
| Domain | `172.16.10.5` |
| Login | `20001` |
| Password | `1234` |
| Display Name | `Safi WILDER` |
| Transport | `UDP` |

4. Cliquer **Save** (ou **Enregistrer**)

### 13.3 Vérifier la connexion

Si bien configuré, tu verras :
- **"Online"** ou **"En ligne"** en vert ✅

Si erreur :
- **"Registration failed"** → Vérifier les identifiants

---

## 14. Configuration de MicroSIP sur CLIWIN02

### 14.1 Configurer le compte Support

| Champ | Valeur |
|-------|--------|
| Account Name | `Support` |
| SIP Server | `172.16.10.5` |
| SIP Proxy | (laisser vide) |
| Username | `20003` |
| Domain | `172.16.10.5` |
| Login | `20003` |
| Password | `1234` |
| Display Name | `Support` |
| Transport | `UDP` |

---

## 15. Test de communication

### 15.1 Vérifier l'enregistrement

Dans MicroSIP, le statut doit afficher **"Online"** ou **"En ligne"**.

### 15.2 Passer un appel

1. Sur **CLIWIN01** (extension 20001)
2. Taper `20003` dans MicroSIP
3. Appuyer sur **Entrée** ou cliquer sur le bouton d'appel

### 15.3 Recevoir l'appel

1. Sur **CLIWIN02**, l'appel arrive
2. Cliquer pour **décrocher**

### 15.4 Vérifier la communication

- Les deux utilisateurs doivent pouvoir s'entendre
- L'audio doit fonctionner dans les deux sens

> ✅ **Félicitations !** Les 2 utilisateurs communiquent !

---

## 16. Configuration pare-feu FW02 (si clients sur LAN_TEST)

> ⚠️ Ces règles sont nécessaires **uniquement** si les clients (CLIWIN01/02) sont sur le réseau **LAN_TEST (172.16.20.0/28)**.
> Si les clients sont sur **LAN_SRV (172.16.10.0/28)**, pas besoin de ces règles.

### 16.1 Se connecter à FW02

```bash
ssh admin@172.16.10.14
sudo su -
```

### 16.2 Ajouter les règles VoIP

```bash
# SIP (signalisation) - UDP port 5060
iptables -A FORWARD -s 172.16.20.0/28 -d 172.16.10.5 -p udp --dport 5060 -j ACCEPT

# SIP (signalisation) - TCP port 5060
iptables -A FORWARD -s 172.16.20.0/28 -d 172.16.10.5 -p tcp --dport 5060 -j ACCEPT

# RTP (flux audio) - UDP ports 10000-20000
iptables -A FORWARD -s 172.16.20.0/28 -d 172.16.10.5 -p udp --dport 10000:20000 -j ACCEPT

# Retour - IPBX01 vers clients (audio)
iptables -A FORWARD -s 172.16.10.5 -d 172.16.20.0/28 -p udp -j ACCEPT

# HTTP - Accès interface web FreePBX
iptables -A FORWARD -s 172.16.20.0/28 -d 172.16.10.5 -p tcp --dport 80 -j ACCEPT
```

### 16.3 Sauvegarder les règles

```bash
iptables-save > /etc/iptables/rules.v4
```

### 16.4 Vérifier les règles

```bash
iptables -L FORWARD -v -n | grep 172.16.10.5
```

---

## 17. Vérification dans FreePBX

### 17.1 Voir les extensions enregistrées

1. **Reports** → **Asterisk Info**
2. Cliquer sur **PJSIP Endpoints**

Les extensions enregistrées affichent **Avail**.

### 17.2 Console Asterisk (CLI)

```bash
# Se connecter en SSH
ssh safi@172.16.10.5
su -

# Ouvrir la console Asterisk
asterisk -rvvv

# Voir les endpoints
CLI> pjsip show endpoints

# Voir les appels en cours
CLI> core show channels

# Quitter
CLI> quit
```

---

## 18. Dépannage

### 18.1 Extension non enregistrée

| Problème | Solution |
|----------|----------|
| Mauvais mot de passe | Vérifier Secret dans FreePBX |
| Mauvaise IP serveur | Vérifier SIP Server = `172.16.10.5` |
| Port bloqué | Vérifier pare-feu (port 5060) |

### 18.2 Pas d'audio (one-way audio)

| Problème | Solution |
|----------|----------|
| Ports RTP bloqués | Ouvrir 10000-20000 UDP sur pare-feu |
| NAT mal configuré | Vérifier NAT Settings dans FreePBX |

### 18.3 Interface web inaccessible

```bash
# Vérifier Apache/httpd
systemctl status httpd

# Redémarrer
systemctl restart httpd
```

### 18.4 MicroSIP affiche "Registration failed"

1. Vérifier que l'extension existe dans FreePBX
2. Vérifier Username = numéro d'extension (ex: `20001`)
3. Vérifier Password = Secret de l'extension (ex: `1234`)
4. Vérifier SIP Server et Domain = `172.16.10.5`

---

## 19. Sauvegarde

### 19.1 Via interface web

1. **Admin** → **Backup & Restore**
2. **+ Add Backup**
3. Configurer la sauvegarde
4. **Save** puis **Run Backup**

### 19.2 Via ligne de commande

```bash
# Sauvegarder la configuration Asterisk
tar -czvf /root/backup_asterisk_$(date +%Y%m%d).tar.gz /etc/asterisk

# Sauvegarder FreePBX
tar -czvf /root/backup_freepbx_$(date +%Y%m%d).tar.gz /var/www/html
```

---

## 📊 Récapitulatif

### Serveur

| Paramètre | Valeur |
|-----------|--------|
| Hostname | ipbx01.tssr.lan |
| IP | 172.16.10.5/28 |
| Passerelle | 172.16.10.14 |
| DNS | 172.16.10.2 |
| OS | FreePBX Distro 16 (CentOS) |

### Accès

| Service | URL/Adresse | Identifiants |
|---------|-------------|--------------|
| Interface Web | http://172.16.10.5 | admin / Azerty1* |
| SSH | safi@172.16.10.5 | Azerty1* |
| Console | root | Azerty1* |

### Extensions

| Extension | Nom | Secret | Poste |
|-----------|-----|--------|-------|
| 20001 | Safi WILDER | 1234 | CLIWIN01 |
| 20002 | Admin IT | 1234 | CLIWIN01 |
| 20003 | Support | 1234 | CLIWIN02 |
| 20004 | Direction | 1234 | CLIWIN02 |

### Configuration MicroSIP

| Champ | Valeur |
|-------|--------|
| SIP Server | `172.16.10.5` |
| Domain | `172.16.10.5` |
| Username | Numéro d'extension (ex: `20001`) |
| Login | Numéro d'extension (ex: `20001`) |
| Password | `1234` |
| Transport | `UDP` |

### Ports

| Port | Protocole | Usage |
|------|-----------|-------|
| 5060 | UDP/TCP | SIP (signalisation) |
| 10000-20000 | UDP | RTP (flux audio) |
| 80 | TCP | Interface web |
| 22 | TCP | SSH |

---

## 📚 Définitions

| Terme | Définition |
|-------|------------|
| **VoIP** | Voice over IP - Technologie pour passer des appels par Internet |
| **ToIP** | Telephony over IP - Infrastructure téléphonie d'entreprise sur IP |
| **IPBX** | Autocommutateur utilisant des réseaux IP |
| **SIP** | Session Initiation Protocol - Protocole de signalisation |
| **RTP** | Real-time Transport Protocol - Transport audio/vidéo |
| **Softphone** | Logiciel émulant un téléphone |

---

## 📚 Références

- [FreePBX Documentation](https://wiki.freepbx.org/)
- [FreePBX Downloads](https://www.freepbx.org/downloads/)
- [MicroSIP Downloads](https://www.microsip.org/downloads)
- [Asterisk Wiki](https://wiki.asterisk.org/)

---

**Auteur :** Safi  
**Projet :** Ekoloclast - Infrastructure tssr.lan  
**Version :** FreePBX Distro 16 / Asterisk / MicroSIP
