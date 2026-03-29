# GUIDE COMPLET SRVLX02 - SERVEUR GLPI
## Ubuntu Server 24.04 LTS - Docker - GLPI
### Projet Ekoloclast

---

# ANALYSE DU README DU CAMARADE

## Erreurs et incohérences identifiées

| # | Problème | Dans le README | Correction |
|---|----------|----------------|------------|
| 1 | **Incohérence OS** | Ligne 5 : "ubuntu-server" mais Ligne 10 : "Type: Debian" | Choisir UN seul OS |
| 2 | **Nom VM** | "GLPO1" (faute de frappe) | Devrait être GLPI01 ou SRVLX02 |
| 3 | **DNS incorrect** | 172.16.10.5 | Devrait être **172.16.10.2** (SRVWIN01) |
| 4 | **URL Docker** | `download.docker.com/linux/debian/gpg` | Pour Ubuntu : `download.docker.com/linux/ubuntu/gpg` |
| 5 | **Dépôt Docker** | Utilise `$(lsb_release -cs)` avec dépôt Debian | Pour Ubuntu, utiliser le dépôt Ubuntu |
| 6 | **docker-compose.yml** | Non fourni dans le document | Fichier essentiel manquant |
| 7 | **IP serveur** | 172.16.10.6 | Toi tu veux **172.16.10.3** |

## Ce qui est correct dans son README

| # | Élément | Commentaire |
|---|---------|-------------|
| ✅ | RAM 1-2 Go, CPU 2 cœurs, Disque 20G | Configuration VM correcte |
| ✅ | Ne pas installer Apache | Évite les conflits avec Docker |
| ✅ | Utilisation de NMCLI | Bonne méthode pour config réseau |
| ✅ | Utilisation de Docker | Méthode moderne et propre |
| ✅ | Structure docker-compose | Bonne approche (db + glpi) |

---

# INFORMATIONS DE TON SERVEUR

| Paramètre | Valeur |
|-----------|--------|
| **Nom** | SRVLX02 |
| **OS** | Ubuntu Server 24.04 LTS |
| **IP** | 172.16.10.3 |
| **Masque** | 255.255.255.240 (/28) |
| **Passerelle** | 172.16.10.1 (FW02) |
| **DNS** | 172.16.10.2 (SRVWIN01) |
| **Domaine** | tssr.lan |
| **Rôle** | Serveur GLPI (Gestion de parc + Ticketing) |

## Configuration VM recommandée

| Paramètre | Valeur |
|-----------|--------|
| RAM | 2 Go minimum |
| CPU | 2 cœurs |
| Disque | 20 Go minimum |
| Réseau | Bridged ou Internal Network (selon ton infra) |

---

# PARTIE 1 : INSTALLATION UBUNTU SERVER

## 1.1 Télécharger l'ISO

→ https://ubuntu.com/download/server
→ Ubuntu Server 24.04 LTS

## 1.2 Installation

1. Démarrer la VM avec l'ISO
2. Langue : **English** (recommandé pour serveur)
3. Keyboard : **French** ou selon ta préférence
4. Type d'installation : **Ubuntu Server (minimized)** ou **Ubuntu Server**
5. Configuration réseau : **Laisser DHCP pour l'instant** (on configure après)
6. Proxy : Laisser vide
7. Mirror : Garder par défaut
8. Storage : **Use an entire disk**
9. Nom machine : `srvlx02`
10. Username : `safi` (ou ton nom)
11. Password : `Azerty123!` (ou autre)
12. SSH : **Install OpenSSH server** ☑
13. Featured snaps : **Ne rien cocher**
14. Attendre l'installation → **Reboot Now**

---

# PARTIE 2 : CONFIGURATION RÉSEAU

## 2.1 Méthode 1 : Netplan (Recommandée pour Ubuntu)

> **Différence avec le camarade :** Ubuntu utilise **Netplan** par défaut, pas NetworkManager (NMCLI)

### Identifier l'interface réseau

```bash
ip a
```

Tu verras quelque chose comme :
```
1: lo: <LOOPBACK,UP,LOWER_UP> ...
2: enp0s3: <BROADCAST,MULTICAST,UP,LOWER_UP> ...   ← Interface réseau
```

### Éditer la configuration Netplan

```bash
sudo nano /etc/netplan/00-installer-config.yaml
```

### Contenu du fichier (ATTENTION à l'indentation YAML !)

```yaml
network:
  version: 2
  renderer: networkd
  ethernets:
    enp0s3:
      addresses:
        - 172.16.10.3/28
      routes:
        - to: default
          via: 172.16.10.1
      nameservers:
        addresses:
          - 172.16.10.2
        search:
          - tssr.lan
```

> ⚠️ **IMPORTANT :** 
> - Remplace `enp0s3` par le nom de TON interface (vérifié avec `ip a`)
> - L'indentation YAML est CRITIQUE (utiliser des espaces, PAS de tabulations)

### Appliquer la configuration

```bash
sudo netplan apply
```

### Vérifier

```bash
ip a
ip route
cat /etc/resolv.conf
```

---

## 2.2 Méthode 2 : NetworkManager (NMCLI) - Comme le camarade

> Si tu préfères utiliser NMCLI comme ton camarade (mais ce n'est pas la méthode par défaut sur Ubuntu Server)

### Installer NetworkManager

```bash
sudo apt update
sudo apt install network-manager -y
```

### Désactiver systemd-networkd (pour éviter les conflits)

```bash
sudo systemctl stop systemd-networkd
sudo systemctl disable systemd-networkd
sudo systemctl enable NetworkManager
sudo systemctl start NetworkManager
```

### Créer la connexion statique

```bash
# Voir les interfaces
nmcli device status

# Créer une connexion statique
nmcli con add type ethernet \
    con-name "static-lan" \
    ifname enp0s3 \
    ipv4.addresses 172.16.10.3/28 \
    ipv4.gateway 172.16.10.1 \
    ipv4.dns 172.16.10.2 \
    ipv4.dns-search tssr.lan \
    ipv4.method manual

# Activer la connexion
nmcli con up static-lan
```

> ⚠️ **Erreur du camarade :** Il a mis DNS 172.16.10.5 - C'est FAUX pour ton projet !
> Le DNS correct est **172.16.10.2** (SRVWIN01)

---

## 2.3 Configurer le hostname

```bash
# Définir le hostname
sudo hostnamectl set-hostname srvlx02

# Éditer /etc/hosts
sudo nano /etc/hosts
```

Ajouter :
```
127.0.0.1       localhost
172.16.10.3     srvlx02.tssr.lan srvlx02
```

---

## 2.4 Tester la connectivité

```bash
# Ping passerelle
ping -c 3 172.16.10.1

# Ping DNS (SRVWIN01)
ping -c 3 172.16.10.2

# Ping Internet
ping -c 3 8.8.8.8

# Test résolution DNS
nslookup srvwin01.tssr.lan
```

---

# PARTIE 3 : INSTALLATION DE DOCKER

> ⚠️ **Erreur du camarade :** Il utilise les commandes pour **Debian**, pas **Ubuntu** !
> Les URLs et dépôts sont différents.

## 3.1 Mettre à jour le système

```bash
sudo apt update
sudo apt upgrade -y
```

## 3.2 Installer les prérequis

```bash
sudo apt install -y \
    ca-certificates \
    curl \
    gnupg \
    lsb-release
```

## 3.3 Ajouter la clé GPG Docker (POUR UBUNTU !)

```bash
# Créer le dossier pour les clés
sudo install -m 0755 -d /etc/apt/keyrings

# Télécharger la clé GPG Docker pour UBUNTU (pas Debian !)
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg

# Donner les permissions
sudo chmod a+r /etc/apt/keyrings/docker.gpg
```

> ⚠️ **Différence avec le camarade :** URL = `download.docker.com/linux/ubuntu/gpg` (pas debian)

## 3.4 Ajouter le dépôt Docker (POUR UBUNTU !)

```bash
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
```

> ⚠️ **Différence avec le camarade :** 
> - URL = `download.docker.com/linux/ubuntu` (pas debian)
> - Utilise `$VERSION_CODENAME` au lieu de `$(lsb_release -cs)`

## 3.5 Installer Docker

```bash
sudo apt update
sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
```

## 3.6 Configurer Docker

```bash
# Activer Docker au démarrage
sudo systemctl enable docker
sudo systemctl start docker

# Ajouter ton utilisateur au groupe docker (évite sudo à chaque fois)
sudo usermod -aG docker $USER

# IMPORTANT : Déconnexion/reconnexion pour appliquer le groupe
exit
```

**→ Reconnecte-toi en SSH ou sur la console**

## 3.7 Vérifier l'installation

```bash
docker --version
docker compose version

# Test
docker run hello-world
```

---

# PARTIE 4 : INSTALLATION DE GLPI AVEC DOCKER

## 4.1 Créer la structure de dossiers

```bash
# Créer le dossier principal
sudo mkdir -p /opt/glpi

# Donner les permissions
sudo chown -R $USER:$USER /opt/glpi

# Se déplacer dans le dossier
cd /opt/glpi
```

## 4.2 Créer le fichier docker-compose.yml

> ⚠️ **Erreur du camarade :** Il ne fournit pas le contenu du fichier docker-compose.yml !

```bash
nano docker-compose.yml
```

### Contenu du fichier docker-compose.yml

```yaml
version: '3.8'

services:
  # Service base de données MariaDB
  mariadb:
    image: mariadb:10.11
    container_name: glpi-mariadb
    restart: always
    environment:
      MARIADB_ROOT_PASSWORD: RootP@ssw0rd2024!
      MARIADB_DATABASE: glpi
      MARIADB_USER: glpi
      MARIADB_PASSWORD: Azerty123!
    volumes:
      - mariadb_data:/var/lib/mysql
    networks:
      - glpi-network

  # Service GLPI
  glpi:
    image: diouxx/glpi:latest
    container_name: glpi-app
    restart: always
    ports:
      - "80:80"
    environment:
      TIMEZONE: Europe/Paris
    volumes:
      - glpi_data:/var/www/html/glpi
    depends_on:
      - mariadb
    networks:
      - glpi-network

# Volumes persistants
volumes:
  mariadb_data:
  glpi_data:

# Réseau interne
networks:
  glpi-network:
    driver: bridge
```

### Explication des paramètres

| Paramètre | Valeur | Description |
|-----------|--------|-------------|
| MARIADB_ROOT_PASSWORD | RootP@ssw0rd2024! | Mot de passe root MariaDB |
| MARIADB_DATABASE | glpi | Nom de la base de données |
| MARIADB_USER | glpi | Utilisateur GLPI |
| MARIADB_PASSWORD | Azerty123! | Mot de passe utilisateur GLPI |
| Port | 80:80 | Port web GLPI |
| TIMEZONE | Europe/Paris | Fuseau horaire |

## 4.3 Lancer les conteneurs

```bash
cd /opt/glpi

# Lancer en arrière-plan
docker compose up -d

# Vérifier le statut
docker compose ps

# Voir les logs (si problème)
docker compose logs -f
```

### Résultat attendu

```
NAME            IMAGE                 STATUS          PORTS
glpi-mariadb    mariadb:10.11        Up 2 minutes    3306/tcp
glpi-app        diouxx/glpi:latest   Up 2 minutes    0.0.0.0:80->80/tcp
```

## 4.4 Attendre l'initialisation

Attendre **2-3 minutes** que les conteneurs démarrent complètement.

```bash
# Vérifier que MariaDB est prêt
docker logs glpi-mariadb 2>&1 | grep -i "ready for connections"

# Vérifier que GLPI est prêt
docker logs glpi-app 2>&1 | tail -20
```

---

# PARTIE 5 : CONFIGURATION GLPI (INTERFACE WEB)

## 5.1 Accéder à l'interface web

Depuis un navigateur sur un PC client du réseau :

```
http://172.16.10.3
```

ou si tu as configuré le DNS :

```
http://glpi.tssr.lan
```

> ⚠️ N'oublie pas d'ajouter l'enregistrement DNS sur SRVWIN01 !

## 5.2 Assistant d'installation GLPI

### Étape 1 : Sélection de la langue

```
┌─────────────────────────────────────────────────────────────────┐
│  GLPI Setup                                                     │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  Select your language:                                          │
│                                                                 │
│  [Français (French)                              ▼]             │
│                                                                 │
│                              [OK]                               │
└─────────────────────────────────────────────────────────────────┘
```

→ Sélectionner **Français** → **OK**

### Étape 2 : Licence

```
┌─────────────────────────────────────────────────────────────────┐
│  Licence                                                        │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  ☑ J'ai lu et accepte les termes de la licence                  │
│                                                                 │
│                              [Continuer]                        │
└─────────────────────────────────────────────────────────────────┘
```

→ Cocher la case → **Continuer**

### Étape 3 : Installation ou mise à jour

```
┌─────────────────────────────────────────────────────────────────┐
│  Début de l'installation                                        │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  ● Installer                                                    │
│  ○ Mettre à jour                                                │
│                                                                 │
│                              [Continuer]                        │
└─────────────────────────────────────────────────────────────────┘
```

→ Sélectionner **Installer** → **Continuer**

### Étape 4 : Vérification des prérequis

```
┌─────────────────────────────────────────────────────────────────┐
│  Vérification de la compatibilité de votre environnement        │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  ✅ PHP version >= 7.4                                          │
│  ✅ Extension mysqli                                            │
│  ✅ Extension ctype                                             │
│  ✅ Extension fileinfo                                          │
│  ✅ Extension json                                              │
│  ✅ Extension mbstring                                          │
│  ✅ ...                                                         │
│                                                                 │
│                              [Continuer]                        │
└─────────────────────────────────────────────────────────────────┘
```

→ Tout devrait être vert → **Continuer**

### Étape 5 : Configuration de la base de données

```
┌─────────────────────────────────────────────────────────────────┐
│  Configuration de la connexion à la base de données             │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  Serveur SQL:        [mariadb                        ]          │
│                       ↑                                         │
│                       Nom du service Docker !                   │
│                                                                 │
│  Utilisateur SQL:    [glpi                           ]          │
│                                                                 │
│  Mot de passe SQL:   [Azerty123!                     ]          │
│                                                                 │
│                              [Continuer]                        │
└─────────────────────────────────────────────────────────────────┘
```

| Champ | Valeur | Explication |
|-------|--------|-------------|
| Serveur SQL | `mariadb` | Nom du service dans docker-compose (PAS localhost !) |
| Utilisateur SQL | `glpi` | Défini dans MARIADB_USER |
| Mot de passe SQL | `Azerty123!` | Défini dans MARIADB_PASSWORD |

> ⚠️ **IMPORTANT :** Le serveur SQL est `mariadb` (nom du service Docker), PAS `localhost` ni `db` !

→ Cliquer **Continuer**

### Étape 6 : Sélection de la base de données

```
┌─────────────────────────────────────────────────────────────────┐
│  Sélection de la base de données                                │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  ● glpi                                                         │
│                                                                 │
│                              [Continuer]                        │
└─────────────────────────────────────────────────────────────────┘
```

→ Sélectionner **glpi** → **Continuer**

### Étape 7 : Initialisation de la base

```
┌─────────────────────────────────────────────────────────────────┐
│  Initialisation de la base de données                           │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  ████████████████████████████████████████  100%                 │
│                                                                 │
│  ✅ Base de données initialisée avec succès                     │
│                                                                 │
│                              [Continuer]                        │
└─────────────────────────────────────────────────────────────────┘
```

→ Attendre → **Continuer**

### Étape 8 : Collecte de données (Telemetry)

→ Choisir selon ta préférence → **Continuer**

### Étape 9 : Installation terminée

```
┌─────────────────────────────────────────────────────────────────┐
│  Installation terminée                                          │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  ✅ GLPI a été installé avec succès                             │
│                                                                 │
│  Comptes par défaut :                                           │
│                                                                 │
│  ┌─────────────────────────────────────────────────────────┐    │
│  │ Utilisateur      │ Mot de passe │ Profil               │    │
│  │──────────────────┼──────────────┼─────────────────────│    │
│  │ glpi             │ glpi         │ Super-Admin          │    │
│  │ tech             │ tech         │ Technicien           │    │
│  │ normal           │ normal       │ Utilisateur          │    │
│  │ post-only        │ postonly     │ Post-only            │    │
│  └─────────────────────────────────────────────────────────┘    │
│                                                                 │
│                              [Utiliser GLPI]                    │
└─────────────────────────────────────────────────────────────────┘
```

**⚠️ NOTER LES IDENTIFIANTS PAR DÉFAUT !**

| Utilisateur | Mot de passe | Profil |
|-------------|--------------|--------|
| glpi | glpi | Super-Admin |
| tech | tech | Technicien |
| normal | normal | Utilisateur |
| post-only | postonly | Post-only |

→ Cliquer **Utiliser GLPI**

---

# PARTIE 6 : SÉCURISATION POST-INSTALLATION

## 6.1 Se connecter en Super-Admin

```
Login:    glpi
Password: glpi
```

## 6.2 Changer les mots de passe par défaut

1. **Administration** → **Utilisateurs**
2. Cliquer sur chaque utilisateur
3. Changer le mot de passe

| Utilisateur | Nouveau mot de passe suggéré |
|-------------|------------------------------|
| glpi | GlpiAdmin2024! |
| tech | TechAdmin2024! |
| normal | NormalUser2024! |
| post-only | PostOnly2024! |

## 6.3 Supprimer le fichier d'installation

```bash
# Sur le serveur SRVLX02
docker exec -it glpi-app rm /var/www/html/glpi/install/install.php
```

Ou via l'interface web : GLPI affiche un avertissement de sécurité avec un lien pour le supprimer.

---

# PARTIE 7 : CONFIGURATION GLPI - GESTION DE PARC

> **Exigence du projet :** Mise en place d'une gestion de parc

## 7.1 Ajouter des catégories de matériel

1. **Configuration** → **Intitulés**
2. Chercher **Types d'ordinateurs**
3. Ajouter :
   - PC Portable
   - PC Fixe
   - Serveur

## 7.2 Ajouter des ordinateurs

1. **Parc** → **Ordinateurs** → **+ Ajouter**

| Champ | Exemple |
|-------|---------|
| Nom | CLIWIN01 |
| Type | PC Portable |
| Fabricant | Dell |
| Modèle | Latitude 5520 |
| Numéro de série | ABC123 |
| Lieu | Paris - 8ème |
| Utilisateur | k.kim |
| Statut | En service |

## 7.3 Ajouter d'autres équipements

GLPI permet de gérer :
- **Parc** → **Moniteurs**
- **Parc** → **Imprimantes**
- **Parc** → **Téléphones**
- **Parc** → **Périphériques**
- **Parc** → **Logiciels**

---

# PARTIE 8 : CONFIGURATION GLPI - SYSTÈME DE TICKETING

> **Exigence du projet :** Mise en place d'un système de ticketing

## 8.1 Configurer les catégories de tickets

1. **Configuration** → **Intitulés**
2. Chercher **Catégories de tickets**
3. Ajouter :
   - Incident matériel
   - Incident logiciel
   - Demande de service
   - Réseau
   - Accès / Droits

## 8.2 Créer un ticket de test

1. **Assistance** → **Tickets** → **+ Ajouter**

| Champ | Valeur |
|-------|--------|
| Titre | Test - PC ne démarre pas |
| Description | L'ordinateur CLIWIN01 ne démarre plus depuis ce matin |
| Catégorie | Incident matériel |
| Priorité | Haute |
| Demandeur | k.kim |
| Technicien assigné | tech |

## 8.3 Configurer les notifications par email (optionnel)

1. **Configuration** → **Notifications** → **Configurer les notifications**
2. Configurer le serveur SMTP si disponible

---

# PARTIE 9 : AJOUTER L'ENREGISTREMENT DNS SUR SRVWIN01

> **Ne pas oublier !** Il faut que les clients puissent accéder à GLPI via son nom.

## Sur SRVWIN01 (Windows Server)

### Via DNS Manager (GUI)

1. **Tools** → **DNS**
2. Expand **Forward Lookup Zones** → **tssr.lan**
3. Right-click → **New Host (A)...**

| Name | IP Address |
|------|------------|
| srvlx02 | 172.16.10.3 |

4. Ajouter aussi l'alias CNAME :
   - Right-click → **New Alias (CNAME)...**
   - Alias name: `glpi`
   - FQDN: `srvlx02.tssr.lan`

### Via PowerShell

```powershell
# Enregistrement A
Add-DnsServerResourceRecordA -ZoneName "tssr.lan" -Name "srvlx02" -IPv4Address "172.16.10.3"

# Alias CNAME
Add-DnsServerResourceRecordCName -ZoneName "tssr.lan" -Name "glpi" -HostNameAlias "srvlx02.tssr.lan"
```

### Test

```powershell
nslookup srvlx02.tssr.lan
nslookup glpi.tssr.lan
```

---

# PARTIE 10 : COMMANDES UTILES

## Gestion Docker

```bash
# Voir les conteneurs
docker ps

# Voir les logs
docker compose logs -f

# Redémarrer les conteneurs
docker compose restart

# Arrêter les conteneurs
docker compose down

# Démarrer les conteneurs
docker compose up -d

# Voir l'utilisation des ressources
docker stats
```

## Sauvegarde

```bash
# Sauvegarder la base de données
docker exec glpi-mariadb mysqldump -u root -pRootP@ssw0rd2024! glpi > /opt/glpi/backup_glpi_$(date +%Y%m%d).sql

# Sauvegarder les fichiers GLPI
docker cp glpi-app:/var/www/html/glpi /opt/glpi/backup_files_$(date +%Y%m%d)
```

## Mise à jour GLPI

```bash
cd /opt/glpi

# Arrêter les conteneurs
docker compose down

# Télécharger la dernière image
docker compose pull

# Redémarrer
docker compose up -d
```

---

# PARTIE 11 : VÉRIFICATIONS FINALES

## Checklist

| # | Vérification | Commande/Action | Statut |
|---|--------------|-----------------|--------|
| 1 | IP configurée | `ip a` → 172.16.10.3 | ☐ |
| 2 | Hostname correct | `hostname` → srvlx02 | ☐ |
| 3 | DNS fonctionne | `nslookup srvwin01.tssr.lan` | ☐ |
| 4 | Ping passerelle | `ping 172.16.10.1` | ☐ |
| 5 | Docker installé | `docker --version` | ☐ |
| 6 | Conteneurs running | `docker ps` → 2 conteneurs | ☐ |
| 7 | GLPI accessible | http://172.16.10.3 | ☐ |
| 8 | Login fonctionne | glpi / glpi | ☐ |
| 9 | DNS sur SRVWIN01 | `nslookup srvlx02.tssr.lan` | ☐ |
| 10 | Gestion de parc | Ajouter un ordinateur | ☐ |
| 11 | Ticketing | Créer un ticket | ☐ |

## Test depuis un client Windows

```powershell
# Test résolution DNS
nslookup glpi.tssr.lan

# Ouvrir dans le navigateur
start http://glpi.tssr.lan
```

---

# RÉCAPITULATIF DES DIFFÉRENCES AVEC LE README DU CAMARADE

| Aspect | README Camarade | Mon Guide |
|--------|-----------------|-----------|
| **OS** | Confusion Debian/Ubuntu | Ubuntu Server 24.04 |
| **Nom serveur** | GLPO1 (faute) | SRVLX02 |
| **IP** | 172.16.10.6 | 172.16.10.3 |
| **DNS** | 172.16.10.5 (erreur) | 172.16.10.2 (SRVWIN01) |
| **Config réseau** | NMCLI uniquement | Netplan (recommandé) + NMCLI |
| **URL Docker** | Debian | Ubuntu |
| **docker-compose.yml** | Non fourni | Complet avec explications |
| **Serveur SQL** | "db" | "mariadb" (nom du service) |
| **Post-installation** | Non couvert | Sécurisation + config |
| **Gestion parc** | Non couvert | Inclus |
| **Ticketing** | Non couvert | Inclus |

---

# INFORMATIONS DE CONNEXION

## Serveur SRVLX02

| Élément | Valeur |
|---------|--------|
| IP | 172.16.10.3 |
| SSH | `ssh safi@172.16.10.3` |
| User Linux | safi |
| Password Linux | Azerty123! |

## GLPI

| Élément | Valeur |
|---------|--------|
| URL | http://172.16.10.3 ou http://glpi.tssr.lan |
| Super-Admin | glpi / glpi (changer après !) |
| Technicien | tech / tech |

## Base de données

| Élément       | Valeur                |
| ------------- | --------------------- |
| Serveur       | mariadb (dans Docker) |
| Base          | glpi                  |
| User          | glpi                  |
| Password      | Azerty123!            |
| Root password | RootP@ssw0rd2024!     |

---

**Document créé pour le projet Ekoloclast**
**SRVLX02 - Serveur GLPI - Ubuntu Server**
