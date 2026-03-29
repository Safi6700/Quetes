# Configuration pfSense FW01 - Guide Complet avec DMZ

## Projet Ekoloclast - Infrastructure tssr.lan

---

## 📋 Architecture Complète

```
                                    INTERNET
                                        │
                                        ▼
                              ┌─────────────────┐
                              │    BOX FAI      │
                              │  192.168.1.1    │
                              └────────┬────────┘
                                       │
         ┌─────────────────────────────┴─────────────────────────────────┐
         │                      FW01 pfSense                             │
         │                                                               │
         │   ┌──────────┐      ┌──────────┐      ┌──────────┐           │
         │   │   em0    │      │   em1    │      │   em2    │           │
         │   │   WAN    │      │ TRANSIT  │      │   DMZ    │           │
         │   │  DHCP    │      │10.10.5.1 │      │172.16.30 │           │
         │   │          │      │   /29    │      │  .14/28  │           │
         │   └──────────┘      └────┬─────┘      └────┬─────┘           │
         │                          │                 │                  │
         └──────────────────────────┼─────────────────┼──────────────────┘
                                    │                 │
                           VLAN 5 Transit       VLAN 30 DMZ
                           10.10.5.0/29         172.16.30.0/28
                                    │                 │
                                    │                 ▼
                                    │          ┌───────────┐
                                    │          │  SRVLX01  │
                                    │          │Messagerie │
                                    │          │172.16.30.1│
                                    │          └───────────┘
                                    │
                                    ▼
         ┌──────────────────────────────────────────────────────────────┐
         │                      FW02 Debian                              │
         │                      10.10.5.2                                │
         │                                                               │
         │   br10: 172.16.10.14/28        br20: 172.16.20.14/28         │
         └─────────────┬────────────────────────────┬───────────────────┘
                       │                            │
                  VLAN 10                      VLAN 20
                  LAN_SRV                      LAN_TEST
                       │                            │
         ┌─────────────┴─────────────┐    ┌────────┴────────┐
         │  SRVWIN01  172.16.10.2    │    │  CLIWIN01       │
         │  SRVLX02   172.16.10.3    │    │  CLIWIN02       │
         │  SRVWIN04  172.16.10.4    │    │                 │
         └───────────────────────────┘    └─────────────────┘
```

---

## 📋 Plan d'adressage

| VLAN | Nom | Réseau | Passerelle | Géré par |
|------|-----|--------|------------|----------|
| - | WAN | DHCP | Box FAI | FW01 |
| 5 | Transit | 10.10.5.0/29 | 10.10.5.1 | FW01 |
| 10 | LAN_SRV | 172.16.10.0/28 | 172.16.10.14 | FW02 |
| 20 | LAN_TEST | 172.16.20.0/28 | 172.16.20.14 | FW02 |
| 30 | DMZ | 172.16.30.0/28 | 172.16.30.14 | **FW01** |

---

## 📋 Interfaces FW01

| Interface | Nom | IP | Réseau | Rôle |
|-----------|-----|-----|--------|------|
| em0 | WAN | DHCP | Internet | Accès Internet |
| em1 | TRANSIT | 10.10.5.1/29 | Transit | Vers FW02 |
| em2 | DMZ | 172.16.30.14/28 | DMZ | Vers SRVLX01 |

---

## 📋 Serveurs

| Serveur | Réseau | IP | Rôle |
|---------|--------|-----|------|
| SRVWIN01 | LAN_SRV | 172.16.10.2 | AD/DNS/DHCP |
| SRVLX02 | LAN_SRV | 172.16.10.3 | GLPI |
| SRVWIN04 | LAN_SRV | 172.16.10.4 | WSUS |
| SRVLX01 | **DMZ** | 172.16.30.1 | Messagerie |

---

## 1. Configuration VirtualBox

### 1.1 Paramètres VM

| Paramètre | Valeur |
|-----------|--------|
| RAM | 1024 MB |
| CPU | 1 vCPU |
| Disque | 20 GB |

### 1.2 Cartes réseau (3 cartes)

| Adapter | Mode | Nom réseau | Rôle |
|---------|------|------------|------|
| Adapter 1 | NAT ou Bridged | - | WAN (Internet) |
| Adapter 2 | Internal Network | `Transit` | TRANSIT vers FW02 |
| Adapter 3 | Internal Network | `DMZ` | DMZ vers SRVLX01 |

---

## 2. Installation pfSense

1. Démarrer avec l'ISO pfSense
2. **Accept** la licence
3. **Install pfSense**
4. **French** keyboard (ou US)
5. **Auto (ZFS)** → **stripe** → Sélectionner disque
6. **Reboot** (retirer l'ISO)

---

## 3. Configuration Console

### 3.1 Assignation des interfaces

```
Should VLANs be set up now? n

Enter the WAN interface name: em0
Enter the LAN interface name: em1
Enter the Optional 1 interface name: em2

Do you want to proceed? y
```

### 3.2 Configurer IP LAN (Transit)

Menu **2** → Interface **2** (LAN) :

```
Enter the new LAN IPv4 address: 10.10.5.1
Enter the new LAN IPv4 subnet bit count: 29
For a LAN, press <ENTER> for none: (Enter)
Enter the new LAN IPv6 address: (Enter)
Do you want to enable the DHCP server on LAN? n
Do you want to revert to HTTP? y
```

### 3.3 Configurer IP OPT1 (DMZ)

Menu **2** → Interface **3** (OPT1) :

```
Enter the new OPT1 IPv4 address: 172.16.30.14
Enter the new OPT1 IPv4 subnet bit count: 28
For a LAN, press <ENTER> for none: (Enter)
Enter the new OPT1 IPv6 address: (Enter)
Do you want to enable the DHCP server on OPT1? n
```

---

## 4. Configuration Web GUI

### 4.1 Connexion

- URL : `http://10.10.5.1`
- Login : `admin`
- Password : `pfsense`

### 4.2 Assistant initial

1. **Hostname** : `FW01`
2. **Domain** : `tssr.lan`
3. **DNS** : `8.8.8.8`, `8.8.4.4`
4. **Timezone** : `Europe/Paris`
5. **WAN** : DHCP, décocher "Block private networks"
6. **LAN** : `10.10.5.1/29`
7. **Admin Password** : Définir un mot de passe fort

---

## 5. Configuration des Interfaces

### 5.1 Interface WAN

**Interfaces** → **WAN**

| Paramètre | Valeur |
|-----------|--------|
| Enable | ✅ |
| IPv4 Type | DHCP |
| Block private networks | ❌ Décocher |

**Save** → **Apply Changes**

### 5.2 Interface TRANSIT (LAN)

**Interfaces** → **LAN**

| Paramètre | Valeur |
|-----------|--------|
| Enable | ✅ |
| Description | `TRANSIT` |
| IPv4 Address | `10.10.5.1` |
| IPv4 Subnet | `29` |

**Save** → **Apply Changes**

### 5.3 Interface DMZ (OPT1)

**Interfaces** → **OPT1**

| Paramètre | Valeur |
|-----------|--------|
| Enable | ✅ |
| Description | `DMZ` |
| IPv4 Address | `172.16.30.14` |
| IPv4 Subnet | `28` |

**Save** → **Apply Changes**

---

## 6. Création des Alias

### 6.1 Alias des réseaux

**Firewall** → **Aliases** → **IP** → **+ Add**

#### Alias : NET_Internal

| Paramètre   | Valeur                                  |
| ----------- | --------------------------------------- |
| Name        | `NET_Internal`                          |
| Type        | Network(s)                              |
| Network 1   | `172.16.10.0/28`                        |
| Network 2   | `172.16.20.0/28`                        |
| Description | `Réseaux internes (LAN_SRV + LAN_TEST)` |

**Save**

#### Alias : NET_DMZ

| Paramètre | Valeur |
|-----------|--------|
| Name | `NET_DMZ` |
| Type | Network(s) |
| Network | `172.16.30.0/28` |
| Description | `Réseau DMZ` |

**Save**

#### Alias : SRV_Messagerie

| Paramètre | Valeur |
|-----------|--------|
| Name | `SRV_Messagerie` |
| Type | Host(s) |
| Host | `172.16.30.1` |
| Description | `SRVLX01 - Serveur Messagerie` |

**Save**

### 6.2 Alias des ports

**Firewall** → **Aliases** → **Ports** → **+ Add**

#### Alias : PORTS_Web

| Paramètre | Valeur |
|-----------|--------|
| Name | `PORTS_Web` |
| Type | Port(s) |
| Port 1 | `80` |
| Port 2 | `443` |
| Description | `HTTP et HTTPS` |

**Save**

#### Alias : PORTS_Mail

| Paramètre | Valeur |
|-----------|--------|
| Name | `PORTS_Mail` |
| Type | Port(s) |
| Port 1 | `25` (SMTP) |
| Port 2 | `465` (SMTPS) |
| Port 3 | `587` (Submission) |
| Port 4 | `110` (POP3) |
| Port 5 | `995` (POP3S) |
| Port 6 | `143` (IMAP) |
| Port 7 | `993` (IMAPS) |
| Description | `Ports Messagerie` |

**Save**

### 6.3 Récapitulatif des alias

| Alias | Type | Valeur | Utilité |
|-------|------|--------|---------|
| `NET_Internal` | Network | 172.16.10.0/28, 172.16.20.0/28 | Réseaux via FW02 |
| `NET_DMZ` | Network | 172.16.30.0/28 | Réseau DMZ |
| `SRV_Messagerie` | Host | 172.16.30.1 | Serveur messagerie |
| `PORTS_Web` | Port | 80, 443 | HTTP/HTTPS |
| `PORTS_Mail` | Port | 25, 465, 587, 110, 995, 143, 993 | Messagerie |

---

## 7. Routes Statiques

### 7.1 Créer la passerelle vers FW02

**System** → **Routing** → **Gateways** → **+ Add**

| Paramètre      | Valeur              |
| -------------- | ------------------- |
| Interface      | TRANSIT             |
| Address Family | IPv4                |
| Name           | `GW_FW02`           |
| Gateway        | `10.10.5.2`         |
| Description    | `Gateway vers FW02` |

**Save** → **Apply Changes**

### 7.2 Route vers LAN_SRV

**System** → **Routing** → **Static Routes** → **+ Add**

| Paramètre | Valeur |
|-----------|--------|
| Destination network | `172.16.10.0/28` |
| Gateway | `GW_FW02 - 10.10.5.2` |
| Description | `Route vers LAN_SRV (Serveurs)` |

**Save**

### 7.3 Route vers LAN_TEST

| Paramètre | Valeur |
|-----------|--------|
| Destination network | `172.16.20.0/28` |
| Gateway | `GW_FW02 - 10.10.5.2` |
| Description | `Route vers LAN_TEST (Clients)` |

**Save** → **Apply Changes**

> ⚠️ **Note** : Pas besoin de route pour la DMZ car FW01 est directement connecté à ce réseau.

---

## 8. Règles de Pare-feu

### 8.1 Comprendre les flux

| Flux | Passe par FW01 ? | Interface concernée |
|------|-----------------|---------------------|
| LAN interne → Internet | ✅ OUI | TRANSIT |
| DMZ → Internet | ✅ OUI | DMZ |
| LAN interne → DMZ | ✅ OUI | TRANSIT (entrée) → DMZ (sortie) |
| DMZ → LAN interne | ✅ OUI | **BLOQUER** (sécurité) |
| Client → AD/WSUS/GLPI | ❌ NON | Géré par FW02 |

### 8.2 Règles Interface TRANSIT

**Firewall** → **Rules** → **TRANSIT**

---

#### Règle 1 : Accès Internet (Web)

| Paramètre        | Valeur                        |
| ---------------- | ----------------------------- |
| Action           | Pass                          |
| Interface        | TRANSIT                       |
| Protocol         | TCP                           |
| Source           | `NET_Internal`                |
| Destination      | any                           |
| Destination Port | `PORTS_Web`                   |
| Description      | `LAN → Internet (HTTP/HTTPS)` |

---

#### Règle 2 : Accès Internet (DNS)

| Paramètre | Valeur |
|-----------|--------|
| Action | Pass |
| Interface | TRANSIT |
| Protocol | TCP/UDP |
| Source | `NET_Internal` |
| Destination | any |
| Destination Port | `53` |
| Description | `LAN → Internet (DNS)` |

---

#### Règle 3 : Accès Internet (NTP)

| Paramètre | Valeur |
|-----------|--------|
| Action | Pass |
| Interface | TRANSIT |
| Protocol | UDP |
| Source | `NET_Internal` |
| Destination | any |
| Destination Port | `123` |
| Description | `LAN → Internet (NTP)` |

---

#### Règle 4 : LAN vers DMZ (Messagerie Web)

| Paramètre | Valeur |
|-----------|--------|
| Action | Pass |
| Interface | TRANSIT |
| Protocol | TCP |
| Source | `NET_Internal` |
| Destination | `SRV_Messagerie` |
| Destination Port | `PORTS_Web` |
| Description | `LAN → Messagerie (Webmail)` |

---

#### Règle 5 : LAN vers DMZ (Protocoles Mail)

| Paramètre | Valeur |
|-----------|--------|
| Action | Pass |
| Interface | TRANSIT |
| Protocol | TCP |
| Source | `NET_Internal` |
| Destination | `SRV_Messagerie` |
| Destination Port | `PORTS_Mail` |
| Description | `LAN → Messagerie (SMTP/IMAP/POP)` |

---

#### Règle 6 : ICMP (Ping)

| Paramètre | Valeur |
|-----------|--------|
| Action | Pass |
| Interface | TRANSIT |
| Protocol | ICMP |
| Source | `NET_Internal` |
| Destination | any |
| Description | `LAN → Ping diagnostic` |

---

#### Règle 7 : Block All

| Paramètre | Valeur |
|-----------|--------|
| Action | Block |
| Interface | TRANSIT |
| Protocol | any |
| Source | any |
| Destination | any |
| Log | ✅ |
| Description | `BLOCK ALL - Deny par défaut` |

---

### 8.3 Règles Interface DMZ

**Firewall** → **Rules** → **DMZ**

---

#### Règle 1 : DMZ vers Internet (Web)

| Paramètre | Valeur |
|-----------|--------|
| Action | Pass |
| Interface | DMZ |
| Protocol | TCP |
| Source | `NET_DMZ` |
| Destination | any |
| Destination Port | `PORTS_Web` |
| Description | `DMZ → Internet (HTTP/HTTPS)` |

---

#### Règle 2 : DMZ vers Internet (DNS)

| Paramètre | Valeur |
|-----------|--------|
| Action | Pass |
| Interface | DMZ |
| Protocol | TCP/UDP |
| Source | `NET_DMZ` |
| Destination | any |
| Destination Port | `53` |
| Description | `DMZ → Internet (DNS)` |

---

#### Règle 3 : DMZ vers Internet (Mail sortant)

| Paramètre | Valeur |
|-----------|--------|
| Action | Pass |
| Interface | DMZ |
| Protocol | TCP |
| Source | `SRV_Messagerie` |
| Destination | any |
| Destination Port | `25, 465, 587` |
| Description | `Messagerie → Internet (SMTP sortant)` |

---

#### Règle 4 : DMZ vers Internet (NTP)

| Paramètre | Valeur |
|-----------|--------|
| Action | Pass |
| Interface | DMZ |
| Protocol | UDP |
| Source | `NET_DMZ` |
| Destination | any |
| Destination Port | `123` |
| Description | `DMZ → Internet (NTP)` |

---

#### Règle 5 : ICMP (Ping)

| Paramètre | Valeur |
|-----------|--------|
| Action | Pass |
| Interface | DMZ |
| Protocol | ICMP |
| Source | `NET_DMZ` |
| Destination | any |
| Description | `DMZ → Ping diagnostic` |

---

#### Règle 6 : BLOQUER DMZ vers LAN (CRITIQUE)

| Paramètre | Valeur |
|-----------|--------|
| Action | **Block** |
| Interface | DMZ |
| Protocol | any |
| Source | `NET_DMZ` |
| Destination | `NET_Internal` |
| Log | ✅ |
| Description | `⛔ BLOQUER DMZ → LAN (Sécurité)` |

> ⚠️ **IMPORTANT** : Cette règle **DOIT** être avant la règle Block All pour être efficace, mais elle est redondante si Block All est présent. Elle sert surtout à logger explicitement les tentatives.

---

#### Règle 7 : Block All

| Paramètre | Valeur |
|-----------|--------|
| Action | Block |
| Interface | DMZ |
| Protocol | any |
| Source | any |
| Destination | any |
| Log | ✅ |
| Description | `BLOCK ALL - Deny par défaut` |

---

### 8.4 Interface WAN

**Firewall** → **Rules** → **WAN**

Par défaut, tout est bloqué. Ajouter uniquement si nécessaire (ex: port forwarding pour la messagerie).

#### (Optionnel) Port Forwarding pour Messagerie

Si tu veux recevoir des mails depuis Internet :

**Firewall** → **NAT** → **Port Forward** → **+ Add**

| Paramètre | Valeur |
|-----------|--------|
| Interface | WAN |
| Protocol | TCP |
| Destination | WAN Address |
| Destination Port | `25` |
| Redirect Target IP | `172.16.30.1` |
| Redirect Target Port | `25` |
| Description | `NAT SMTP vers Messagerie` |

Répéter pour les autres ports si nécessaire (465, 587, 993, etc.)

---

### 8.5 Récapitulatif des règles

#### Interface TRANSIT (7 règles)

| # | Action | Source | Destination | Port | Description |
|---|--------|--------|-------------|------|-------------|
| 1 | Pass | NET_Internal | any | 80, 443 | Internet Web |
| 2 | Pass | NET_Internal | any | 53 | DNS |
| 3 | Pass | NET_Internal | any | 123 | NTP |
| 4 | Pass | NET_Internal | SRV_Messagerie | 80, 443 | Webmail |
| 5 | Pass | NET_Internal | SRV_Messagerie | PORTS_Mail | Mail |
| 6 | Pass | NET_Internal | any | ICMP | Ping |
| 7 | Block | any | any | any | Deny All |

#### Interface DMZ (7 règles)

| # | Action | Source | Destination | Port | Description |
|---|--------|--------|-------------|------|-------------|
| 1 | Pass | NET_DMZ | any | 80, 443 | Internet Web |
| 2 | Pass | NET_DMZ | any | 53 | DNS |
| 3 | Pass | SRV_Messagerie | any | 25, 465, 587 | SMTP sortant |
| 4 | Pass | NET_DMZ | any | 123 | NTP |
| 5 | Pass | NET_DMZ | any | ICMP | Ping |
| 6 | Block | NET_DMZ | NET_Internal | any | ⛔ Bloquer DMZ→LAN |
| 7 | Block | any | any | any | Deny All |

---

## 9. Configuration NAT

### 9.1 Outbound NAT

**Firewall** → **NAT** → **Outbound**

1. Sélectionner **Hybrid Outbound NAT rule generation**
2. **Save** → **Apply Changes**

### 9.2 Ajouter règles NAT manuelles (si nécessaire)

**+ Add** :

#### NAT pour réseaux internes

| Paramètre | Valeur |
|-----------|--------|
| Interface | WAN |
| Source | `NET_Internal` |
| Destination | any |
| Translation | Interface Address |
| Description | `NAT LAN vers Internet` |

#### NAT pour DMZ

| Paramètre | Valeur |
|-----------|--------|
| Interface | WAN |
| Source | `NET_DMZ` |
| Destination | any |
| Translation | Interface Address |
| Description | `NAT DMZ vers Internet` |

**Save** → **Apply Changes**

---

## 10. Vérification

### 10.1 Vérifier les routes

**Diagnostics** → **Routes**

| Destination | Gateway | Interface |
|-------------|---------|-----------|
| default | (WAN Gateway) | WAN |
| 10.10.5.0/29 | link#2 | TRANSIT |
| 172.16.10.0/28 | 10.10.5.2 | TRANSIT |
| 172.16.20.0/28 | 10.10.5.2 | TRANSIT |
| 172.16.30.0/28 | link#3 | DMZ |

### 10.2 Tests depuis pfSense

**Diagnostics** → **Ping**

| Test | Host | Résultat |
|------|------|----------|
| Internet | `8.8.8.8` | ✅ OK |
| FW02 | `10.10.5.2` | ✅ OK |
| SRVWIN01 | `172.16.10.2` | ✅ OK |
| SRVLX01 (DMZ) | `172.16.30.1` | ✅ OK |

### 10.3 Tests depuis SRVLX01 (DMZ)

```bash
# Test Internet
ping -c 3 8.8.8.8

# Test DNS
nslookup google.com

# Test vers LAN (DOIT ÉCHOUER - bloqué)
ping -c 3 172.16.10.2
# Résultat attendu : timeout (bloqué par le firewall)
```

### 10.4 Tests depuis un client (CLIWIN01)

```cmd
REM Test Internet
ping 8.8.8.8

REM Test Messagerie
ping 172.16.30.1

REM Test accès webmail
curl http://172.16.30.1
```

---

## 11. Schéma des flux autorisés/bloqués

```
┌─────────────────────────────────────────────────────────────────────────┐
│                         FLUX AUTORISÉS                                  │
├─────────────────────────────────────────────────────────────────────────┤
│                                                                         │
│  LAN_SRV / LAN_TEST → Internet                                         │
│     ✅ HTTP/HTTPS (80, 443)                                            │
│     ✅ DNS (53)                                                         │
│     ✅ NTP (123)                                                        │
│     ✅ ICMP                                                             │
│                                                                         │
│  LAN_SRV / LAN_TEST → DMZ (Messagerie)                                 │
│     ✅ Webmail (80, 443)                                               │
│     ✅ SMTP/IMAP/POP (25, 465, 587, 143, 993, 110, 995)                │
│                                                                         │
│  DMZ → Internet                                                         │
│     ✅ HTTP/HTTPS (80, 443)                                            │
│     ✅ DNS (53)                                                         │
│     ✅ SMTP sortant (25, 465, 587)                                     │
│     ✅ NTP (123)                                                        │
│                                                                         │
├─────────────────────────────────────────────────────────────────────────┤
│                         FLUX BLOQUÉS                                    │
├─────────────────────────────────────────────────────────────────────────┤
│                                                                         │
│  DMZ → LAN_SRV / LAN_TEST                                              │
│     ⛔ TOUT BLOQUÉ (sécurité DMZ)                                      │
│                                                                         │
│  Internet → LAN (sans port forwarding)                                  │
│     ⛔ TOUT BLOQUÉ                                                      │
│                                                                         │
└─────────────────────────────────────────────────────────────────────────┘
```

---

## 12. Sauvegarde

**Diagnostics** → **Backup & Restore** → **Download configuration as XML**

Nom recommandé : `config-FW01-DMZ-tssr-lan-YYYYMMDD.xml`

---

## 📊 Récapitulatif Final

### Interfaces

| Interface | IP | Réseau | Rôle |
|-----------|-----|--------|------|
| WAN (em0) | DHCP | Internet | Accès Internet |
| TRANSIT (em1) | 10.10.5.1/29 | Transit | Vers FW02 |
| DMZ (em2) | 172.16.30.14/28 | DMZ | Vers Messagerie |

### Alias (5 total)

| Alias | Valeur |
|-------|--------|
| NET_Internal | 172.16.10.0/28, 172.16.20.0/28 |
| NET_DMZ | 172.16.30.0/28 |
| SRV_Messagerie | 172.16.30.1 |
| PORTS_Web | 80, 443 |
| PORTS_Mail | 25, 465, 587, 110, 995, 143, 993 |

### Routes statiques (2)

| Destination | Gateway |
|-------------|---------|
| 172.16.10.0/28 | 10.10.5.2 (FW02) |
| 172.16.20.0/28 | 10.10.5.2 (FW02) |

### Règles de pare-feu

| Interface | Nombre de règles |
|-----------|------------------|
| TRANSIT | 7 |
| DMZ | 7 |
| WAN | 0 (+ port forward optionnel) |

---

## 📚 Références

- [pfSense Documentation](https://docs.netgate.com/pfsense/en/latest/)
- [pfSense DMZ Configuration](https://docs.netgate.com/pfsense/en/latest/recipes/example-basic-configuration.html)
- [pfSense NAT](https://docs.netgate.com/pfsense/en/latest/nat/index.html)

---

**Auteur :** Safi  
**Projet :** Ekoloclast - Infrastructure tssr.lan  
**Version :** Complète avec DMZ
