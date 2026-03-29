ip# Installation et Configuration SRVLX01 - iRedMail (Serveur Messagerie)

## Projet Ekoloclast - Infrastructure tssr.lan

---

## 📋 Informations du serveur

| Paramètre | Valeur |
|-----------|--------|
| Nom | SRVLX01 |
| Hostname FQDN | `mail.tssr.lan` |
| OS | Debian 12 (Bookworm) - Sans GUI |
| Rôle | Serveur de messagerie (iRedMail) |
| IP | 172.16.30.1/28 |
| Passerelle | 172.16.30.14 (FW01 - DMZ) |
| DNS | 172.16.10.2 (SRVWIN01) |
| Zone | **DMZ** |
| Domaine mail | `@tssr.lan` |

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
         ┌───────────────────────┴───────────────────────┐
         │                 FW01 pfSense                  │
         │                                               │
         │  WAN: DHCP    TRANSIT: 10.10.5.1   DMZ: 172.16.30.14
         │    │              │                    │
         └────┼──────────────┼────────────────────┼──────┘
              │              │                    │
         Internet       Transit              DMZ Network
                             │              172.16.30.0/28
                             │                    │
                             ▼                    ▼
                      ┌───────────┐        ┌───────────────┐
                      │   FW02    │        │   SRVLX01     │
                      │ 10.10.5.2 │        │ 172.16.30.1   │ ← CE SERVEUR
                      └─────┬─────┘        │   iRedMail    │
                            │              │   Messagerie  │
                   ┌────────┴────────┐     └───────────────┘
                   │                 │
              LAN_SRV           LAN_TEST
           172.16.10.0/28    172.16.20.0/28
                   │                 │
            ┌──────┴──────┐    ┌─────┴─────┐
            │ SRVWIN01    │    │ CLIWIN01  │
            │ SRVLX02     │    │ CLIWIN02  │
            │ SRVWIN04    │    └───────────┘
            └─────────────┘
```

---

## 📋 Ports utilisés par iRedMail

| Port | Protocole | Service | Description |
|------|-----------|---------|-------------|
| 25 | TCP | SMTP | Envoi de mails (serveur à serveur) |
| 465 | TCP | SMTPS | SMTP sécurisé (SSL) |
| 587 | TCP | Submission | Envoi de mails (client à serveur) |
| 110 | TCP | POP3 | Réception mails (non sécurisé) |
| 995 | TCP | POP3S | Réception mails (SSL) |
| 143 | TCP | IMAP | Réception mails (non sécurisé) |
| 993 | TCP | IMAPS | Réception mails (SSL) |
| 80 | TCP | HTTP | Webmail (Roundcube) |
| 443 | TCP | HTTPS | Webmail sécurisé |

---

## 1. Configuration VirtualBox

### 1.1 Paramètres VM

| Paramètre | Valeur |
|-----------|--------|
| Nom | SRVLX01 |
| Type | Linux |
| Version | Debian (64-bit) |
| RAM | **4096 MB** (minimum requis) |
| CPU | 2 vCPU |
| Disque | **40 GB** (stockage mails) |

### 1.2 Carte réseau

| Paramètre | Valeur |
|-----------|--------|
| Adapter 1 | Internal Network |
| Name | `DMZ` |
| Adapter Type | Intel PRO/1000 MT Desktop |
| Promiscuous Mode | Deny |
| Cable Connected | ✅ |

---

## 2. Installation Debian 12 (Sans GUI)

### 2.1 Télécharger l'ISO

```
https://cdimage.debian.org/debian-cd/current/amd64/iso-cd/debian-12.9.0-amd64-netinst.iso
```

### 2.2 Démarrer l'installation

1. Insérer l'ISO
2. Démarrer la VM
3. Au menu, sélectionner **"Install"** (pas Graphical install)

### 2.3 Configuration de l'installation

| Étape | Valeur |
|-------|--------|
| Langue | Français |
| Pays | France |
| Clavier | Français |
| **Nom de la machine** | `mail` |
| **Domaine** | `tssr.lan` |
| Mot de passe root | `Azerty1*` |
| Utilisateur | `admin` |
| Mot de passe utilisateur | `Azerty1*` |
| Fuseau horaire | Paris |
| Partitionnement | Disque entier - tout dans une partition |
| Miroir | France / deb.debian.org |
| Proxy | Laisser vide |

### 2.4 Sélection des logiciels (IMPORTANT)

**DÉCOCHER TOUT sauf :**

```
┌─────────────────────────────────────────────────────────────┐
│  Sélection des logiciels                                    │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  [ ] Environnement de bureau Debian     ← DÉCOCHER !       │
│  [ ] ... GNOME                          ← DÉCOCHER !       │
│  [ ] Serveur web                        ← DÉCOCHER !       │
│  [ ] Serveur d'impression               ← DÉCOCHER !       │
│  [x] Serveur SSH                        ← COCHER           │
│  [x] Utilitaires usuels du système      ← COCHER           │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

> ⚠️ **CRITIQUE** : iRedMail installe lui-même Nginx/Apache. Ne PAS installer de serveur web !

### 2.5 Fin d'installation

1. Installer GRUB : **Oui** → Sélectionner `/dev/sda`
2. Terminer l'installation
3. Retirer l'ISO
4. Redémarrer

---

## 3. Configuration réseau

### 3.1 Se connecter

```
mail login: root
Password: Azerty1*
```

### 3.2 Configurer l'IP statique

```bash
nano /etc/network/interfaces
```

Modifier le fichier :

```
# This file describes the network interfaces available on your system
# and how to activate them. For more information, see interfaces(5).

source /etc/network/interfaces.d/*

# The loopback network interface
auto lo
iface lo inet loopback

# The primary network interface
auto enp0s3
iface enp0s3 inet static
    address 172.16.30.1
    netmask 255.255.255.240
    gateway 172.16.30.14
    dns-nameservers 172.16.10.2
    dns-search tssr.lan
```

### 3.3 Configurer le DNS

```bash
nano /etc/resolv.conf
```

Contenu :

```
search tssr.lan
nameserver 172.16.10.2
```

### 3.4 Redémarrer le réseau

```bash
systemctl restart networking
```

### 3.5 Vérifier la configuration

```bash
# Vérifier l'IP
ip a

# Ping passerelle (FW01 - DMZ)
ping -c 3 172.16.30.14

# Ping DNS (SRVWIN01 - via FW01)
ping -c 3 172.16.10.2

# Ping Internet
ping -c 3 8.8.8.8

# Test DNS
nslookup google.com
```

> ⚠️ **Si pas de connectivité Internet**, vérifier les règles pare-feu sur FW01 (interface DMZ).

---

## 4. Configuration du hostname

### 4.1 Vérifier le hostname actuel

```bash
hostname
hostname -f
```

Doit afficher :
```
mail
mail.tssr.lan
```

### 4.2 Corriger si nécessaire

```bash
# Définir le hostname
hostnamectl set-hostname mail.tssr.lan

# Éditer /etc/hosts
nano /etc/hosts
```

Contenu de `/etc/hosts` :

```
127.0.0.1       localhost
172.16.30.1     mail.tssr.lan mail
```

> ⚠️ **IMPORTANT** : Le FQDN (`mail.tssr.lan`) doit pointer vers l'IP du serveur, PAS vers 127.0.0.1 !

### 4.3 Vérifier

```bash
hostname -f
# Doit afficher : mail.tssr.lan
```

---

## 5. Préparation du système

### 5.1 Mettre à jour le système

```bash
apt update && apt upgrade -y
```

### 5.2 Installer les outils nécessaires

```bash
apt install -y wget curl bzip2 gzip
```

### 5.3 Redémarrer

```bash
reboot
```

---

## 6. Téléchargement et installation iRedMail

### 6.1 Télécharger iRedMail

```bash
# Se connecter en root
su -

# Aller dans /root
cd /root

# Télécharger la dernière version
wget https://github.com/iredmail/iRedMail/archive/refs/tags/1.7.1.tar.gz

# Extraire
tar -xzf 1.7.1.tar.gz

# Aller dans le dossier
cd iRedMail-1.7.1
```

### 6.2 Lancer l'installation

```bash
bash iRedMail.sh
```

### 6.3 Assistant d'installation iRedMail

#### Écran 1 : Bienvenue

```
Welcome to iRedMail installation wizard.
Continue? [y|N] : y
```

#### Écran 2 : Répertoire de stockage des mails

```
Default mail storage path: /var/vmail

[/var/vmail] : (Entrée pour accepter)
```

#### Écran 3 : Serveur web

```
Choose a web server:
  * [X] Nginx
  * [ ] OpenLiteSpeed

(Laisser Nginx sélectionné) → Entrée
```

#### Écran 4 : Base de données

```
Choose a backend for mail accounts:
  * [X] MariaDB
  * [ ] PostgreSQL
  * [ ] OpenLDAP

(Laisser MariaDB sélectionné) → Entrée
```

#### Écran 5 : Mot de passe MariaDB root

```
MySQL root password: Azerty1*
```

#### Écran 6 : Premier domaine mail

```
Your first mail domain name: tssr.lan
```

#### Écran 7 : Mot de passe administrateur

```
Password for postmaster@tssr.lan: Azerty1*
```

> C'est le compte admin pour gérer les mails.

#### Écran 8 : Composants optionnels

```
Optional components:
  [X] Roundcubemail        ← Webmail (GARDER)
  [X] netdata              ← Monitoring (optionnel)
  [X] iRedAdmin            ← Panel admin (GARDER)
  [X] Fail2ban             ← Sécurité (GARDER)
```

Sélectionner avec **Espace**, puis **Entrée**.

#### Écran 9 : Confirmation

```
Review your settings:
  * Mail storage:        /var/vmail
  * Web server:          Nginx
  * Backend:             MariaDB
  * First domain:        tssr.lan
  * Admin:               postmaster@tssr.lan
  ...

Continue? [y|N] : y
```

### 6.4 Attendre l'installation

L'installation prend **5-15 minutes**. Attendre jusqu'à voir :

```
********************************************************************
* Congratulations, mail server setup completed successfully!
********************************************************************
```

### 6.5 Informations importantes affichées

Note ces informations :

```
* URLs d'accès :
  - Webmail (Roundcube): https://mail.tssr.lan/mail/
  - Admin panel:         https://mail.tssr.lan/iredadmin/

* Compte admin :
  - Username: postmaster@tssr.lan
  - Password: Azerty1*

* Fichier de configuration : /root/iRedMail-1.7.1/config
```

### 6.6 Redémarrer le serveur

```bash
reboot
```

---

## 7. Configuration DNS sur SRVWIN01

Pour que la messagerie fonctionne, ajouter les enregistrements DNS sur SRVWIN01.

### 7.1 Ouvrir DNS Manager sur SRVWIN01

**Server Manager** → **Tools** → **DNS**

### 7.2 Zone directe (tssr.lan)

Ajouter ces enregistrements :

#### Enregistrement A

| Type | Nom | Valeur |
|------|-----|--------|
| A | `mail` | `172.16.30.1` |

Clic droit sur `tssr.lan` → **New Host (A or AAAA)**

#### Enregistrement MX

| Type | Nom | Serveur de messagerie | Priorité |
|------|-----|----------------------|----------|
| MX | (vide) | `mail.tssr.lan` | `10` |

Clic droit sur `tssr.lan` → **New Mail Exchanger (MX)**

### 7.3 Zone inverse (si configurée)

Ajouter un enregistrement PTR :

| IP | Nom |
|----|-----|
| 172.16.30.1 | mail.tssr.lan |

### 7.4 Vérifier la résolution DNS

Depuis un client :

```cmd
nslookup mail.tssr.lan
nslookup -type=MX tssr.lan
```

---

## 8. Configuration pare-feu FW01 (DMZ)

### 8.1 Règles DMZ existantes (rappel)

Les règles actuelles permettent déjà :
- DMZ → Internet (HTTP, HTTPS, DNS, SMTP sortant)
- LAN → DMZ (Webmail, Mail)

### 8.2 Vérifier les règles

**Firewall** → **Rules** → **DMZ**

Les règles doivent inclure :

| # | Source | Destination | Port | Description |
|---|--------|-------------|------|-------------|
| 1 | DMZ | any | 80, 443 | Web sortant |
| 2 | DMZ | any | 53 | DNS |
| 3 | DMZ | any | 25, 465, 587 | SMTP sortant |
| 4 | DMZ | any | ICMP | Ping |
| 5 | DMZ | LAN | any | **BLOCK** |
| 6 | any | any | any | **BLOCK** |

**Firewall** → **Rules** → **TRANSIT**

| # | Source | Destination | Port | Description |
|---|--------|-------------|------|-------------|
| ... | NET_Internal | SRV_Messagerie | 80, 443 | Webmail |
| ... | NET_Internal | SRV_Messagerie | 25, 465, 587, 143, 993, 110, 995 | Mail |

### 8.3 Port Forward pour recevoir des mails externes (optionnel)

Si tu veux recevoir des mails depuis Internet :

**Firewall** → **NAT** → **Port Forward** → **+ Add**

| Champ | Valeur |
|-------|--------|
| Interface | WAN |
| Protocol | TCP |
| Destination | WAN Address |
| Destination Port | 25 |
| Redirect Target IP | 172.16.30.1 |
| Redirect Target Port | 25 |
| Description | NAT SMTP vers Messagerie |

---

## 9. Test du serveur mail

### 9.1 Vérifier les services sur SRVLX01

```bash
# Se connecter en root
su -

# Vérifier les services
systemctl status postfix
systemctl status dovecot
systemctl status nginx
systemctl status mariadb

# Vérifier les ports
ss -tlnp | grep -E "25|465|587|110|995|143|993|80|443"
```

### 9.2 Accéder au Webmail

Depuis un client (CLIWIN01) :

```
https://172.16.30.1/mail/
```

ou

```
https://mail.tssr.lan/mail/
```

> ⚠️ Le certificat SSL est auto-signé, accepter l'exception de sécurité.

### 9.3 Se connecter

| Champ | Valeur |
|-------|--------|
| Username | `postmaster@tssr.lan` |
| Password | `Azerty1*` |

### 9.4 Accéder au panel admin

```
https://mail.tssr.lan/iredadmin/
```

| Champ | Valeur |
|-------|--------|
| Username | `postmaster@tssr.lan` |
| Password | `Azerty1*` |

---

## 10. Créer des utilisateurs mail

### 10.1 Via iRedAdmin (interface web)

1. Aller sur `https://mail.tssr.lan/iredadmin/`
2. Se connecter avec `postmaster@tssr.lan`
3. **Add** → **User**
4. Remplir :
   - Username : `prenom.nom`
   - Password : `xxxxxx`
   - Domain : `tssr.lan`
5. **Add**

### 10.2 Exemples d'utilisateurs à créer

| Email | Description |
|-------|-------------|
| `admin@tssr.lan` | Administrateur système |
| `support@tssr.lan` | Support technique |
| `contact@tssr.lan` | Contact général |
| `prenom.nom@tssr.lan` | Utilisateurs Ekoloclast |

---

## 11. Configuration client mail

### 11.1 Paramètres de configuration

| Paramètre | Valeur |
|-----------|--------|
| Serveur entrant (IMAP) | `mail.tssr.lan` |
| Port IMAP | `993` (SSL) ou `143` (STARTTLS) |
| Serveur sortant (SMTP) | `mail.tssr.lan` |
| Port SMTP | `587` (STARTTLS) ou `465` (SSL) |
| Authentification | Mot de passe normal |
| Nom d'utilisateur | `prenom.nom@tssr.lan` |

### 11.2 Configuration Thunderbird

1. **Fichier** → **Nouveau** → **Compte courrier existant**
2. Entrer : Nom, Email, Mot de passe
3. **Configuration manuelle** :
   - IMAP : `mail.tssr.lan`, Port `993`, SSL/TLS
   - SMTP : `mail.tssr.lan`, Port `587`, STARTTLS
4. **Terminé**

### 11.3 Configuration Outlook

1. **Fichier** → **Ajouter un compte**
2. Choisir **Configuration manuelle**
3. **IMAP** :
   - Serveur : `mail.tssr.lan`
   - Port : `993`
   - Chiffrement : SSL/TLS
4. **SMTP** :
   - Serveur : `mail.tssr.lan`
   - Port : `587`
   - Chiffrement : STARTTLS

---

## 12. Test d'envoi/réception de mail

### 12.1 Test interne (Webmail)

1. Se connecter au webmail avec `postmaster@tssr.lan`
2. Composer un nouveau mail vers `admin@tssr.lan`
3. Envoyer
4. Se connecter avec `admin@tssr.lan`
5. Vérifier la réception

### 12.2 Test via ligne de commande (SRVLX01)

```bash
# Installer mailutils
apt install mailutils -y

# Envoyer un mail de test
echo "Test depuis SRVLX01" | mail -s "Test Mail" admin@tssr.lan
```

### 12.3 Vérifier les logs

```bash
# Logs Postfix (envoi)
tail -f /var/log/mail.log

# Logs Dovecot (réception)
tail -f /var/log/dovecot/dovecot.log
```

---

## 13. Dépannage

### 13.1 Impossible d'accéder au webmail

```bash
# Vérifier Nginx
systemctl status nginx

# Redémarrer
systemctl restart nginx

# Vérifier les logs
tail -f /var/log/nginx/error.log
```

### 13.2 Impossible d'envoyer des mails

```bash
# Vérifier Postfix
systemctl status postfix

# Tester SMTP
telnet mail.tssr.lan 25

# Vérifier les logs
tail -f /var/log/mail.log
```

### 13.3 Impossible de recevoir des mails

```bash
# Vérifier Dovecot
systemctl status dovecot

# Vérifier les logs
tail -f /var/log/dovecot/dovecot.log
```

### 13.4 Erreur de certificat SSL

Le certificat est auto-signé. Pour les clients :
- Accepter l'exception de sécurité
- Ou installer un certificat Let's Encrypt (nécessite accès Internet)

---

## 14. Sauvegarde

### 14.1 Sauvegarder les mails

```bash
# Les mails sont dans /var/vmail
tar -czvf /root/backup_vmail_$(date +%Y%m%d).tar.gz /var/vmail
```

### 14.2 Sauvegarder la base de données

```bash
mysqldump -u root -p --all-databases > /root/backup_db_$(date +%Y%m%d).sql
```

### 14.3 Sauvegarder la configuration

```bash
tar -czvf /root/backup_config_$(date +%Y%m%d).tar.gz /etc/postfix /etc/dovecot /etc/nginx
```

---

## 📊 Récapitulatif

### Configuration serveur

| Paramètre | Valeur |
|-----------|--------|
| Hostname | mail.tssr.lan |
| IP | 172.16.30.1/28 |
| Passerelle | 172.16.30.14 |
| DNS | 172.16.10.2 |
| Zone | DMZ |

### Comptes par défaut

| Compte | Email | Mot de passe |
|--------|-------|--------------|
| Admin | postmaster@tssr.lan | Azerty1* |

### URLs d'accès

| Service | URL |
|---------|-----|
| Webmail | https://mail.tssr.lan/mail/ |
| Admin | https://mail.tssr.lan/iredadmin/ |

### Ports

| Port | Service |
|------|---------|
| 25 | SMTP |
| 465 | SMTPS |
| 587 | Submission |
| 993 | IMAPS |
| 995 | POP3S |
| 443 | HTTPS (Webmail) |

### Services installés

| Service | Description |
|---------|-------------|
| Postfix | Serveur SMTP |
| Dovecot | Serveur IMAP/POP3 |
| Nginx | Serveur web |
| MariaDB | Base de données |
| Roundcube | Webmail |
| iRedAdmin | Panel admin |
| Fail2ban | Sécurité |

---

## 📚 Références

- [Documentation iRedMail](https://docs.iredmail.org/)
- [iRedMail GitHub](https://github.com/iredmail/iRedMail)
- [Roundcube Webmail](https://roundcube.net/)

---

**Auteur :** Safi  
**Projet :** Ekoloclast - Infrastructure tssr.lan  
**Version :** iRedMail sur Debian 12 (DMZ)
