# Installation et Configuration SRVWIN01 - Active Directory / DNS / DHCP

## Projet Ekoloclast - Infrastructure tssr.lan

---

## 📋 Informations du serveur

| Paramètre | Valeur |
|-----------|--------|
| Nom | SRVWIN01 |
| Hostname | `srvwin01.tssr.lan` |
| OS | Windows Server 2022 GUI |
| Rôles | AD DS, DNS, DHCP |
| IP | 172.16.10.2/28 |
| Passerelle | 172.16.10.14 (FW02) |
| DNS | 127.0.0.1 (lui-même) |
| Zone | LAN_SRV |
| Domaine | tssr.lan |

---

## 📋 Architecture réseau

```
                         FW02 Debian
                         172.16.10.14
                              │
              ────────────────┴────────────────
              │           LAN_SRV             │
              │        172.16.10.0/28         │
              ─────────────────────────────────
                   │      │      │      │
                   ▼      ▼      ▼      ▼
            ┌────────┐ ┌────────┐ ┌────────┐ ┌────────┐
            │SRVWIN01│ │SRVLX02 │ │SRVWIN04│ │ IPBX01 │
            │  .2    │ │  .3    │ │  .4    │ │  .5    │
            │AD/DNS/ │ │ GLPI   │ │ WSUS   │ │FreePBX │
            │ DHCP   │ │        │ │        │ │        │
            └────────┘ └────────┘ └────────┘ └────────┘
                ↑
           CE SERVEUR
```

---

## 1. Configuration VirtualBox

### 1.1 Paramètres VM

| Paramètre | Valeur |
|-----------|--------|
| Nom | SRVWIN01 |
| Type | Microsoft Windows |
| Version | Windows 2022 (64-bit) |
| RAM | **4096 MB** |
| CPU | 2 vCPU |
| Disque | **50 GB** |

### 1.2 Carte réseau

| Paramètre | Valeur |
|-----------|--------|
| Adapter 1 | Internal Network |
| Name | `LAN_SRV` |

---

## 2. Installation Windows Server 2022

### 2.1 Type d'installation

Sélectionner : **Windows Server 2022 Standard (Desktop Experience)**

### 2.2 Configuration initiale

| Paramètre | Valeur |
|-----------|--------|
| Mot de passe Administrator | `Azerty1*` |

---

## 3. Configuration réseau

### 3.1 Configurer l'IP statique

1. **Settings** → **Network & Internet** → **Ethernet**
2. Cliquer sur l'adaptateur → **Edit**
3. Sélectionner **Manual** → Activer **IPv4**

| Champ | Valeur |
|-------|--------|
| IP address | `172.16.10.2` |
| Subnet prefix length | `28` |
| Gateway | `172.16.10.14` |
| Preferred DNS | `127.0.0.1` |

4. **Save**

### 3.2 Renommer le serveur

1. **Settings** → **System** → **About** → **Rename this PC**
2. Nouveau nom : `SRVWIN01`
3. **Restart**

---

## 4. Installation des rôles

### 4.1 Ouvrir Server Manager

**Server Manager** → **Manage** → **Add Roles and Features**

### 4.2 Installer AD DS

1. **Next** jusqu'à **Server Roles**
2. Cocher **Active Directory Domain Services**
3. **Add Features** → **Next** → **Install**

### 4.3 Promouvoir en contrôleur de domaine

1. Cliquer sur le drapeau jaune → **Promote this server to a domain controller**
2. Sélectionner **Add a new forest**
3. Root domain name : `tssr.lan`
4. **Next**
5. Mot de passe DSRM : `Azerty1*`
6. **Next** → **Install**
7. Le serveur redémarre automatiquement

### 4.4 Installer DNS (automatique avec AD DS)

Le rôle DNS est installé automatiquement avec AD DS.

### 4.5 Installer DHCP

1. **Server Manager** → **Manage** → **Add Roles and Features**
2. Cocher **DHCP Server**
3. **Add Features** → **Next** → **Install**
4. Après installation : **Complete DHCP configuration**
5. **Commit** → **Close**

---

## 5. Configuration DNS

### 5.1 Vérifier la zone directe

1. **Server Manager** → **Tools** → **DNS**
2. Développer **SRVWIN01** → **Forward Lookup Zones** → **tssr.lan**

### 5.2 Enregistrements DNS créés

| Type | Nom | Valeur |
|------|-----|--------|
| A | srvwin01 | 172.16.10.2 |
| A | srvlx02 | 172.16.10.3 |
| A | srvwin04 | 172.16.10.4 |
| A | ipbx01 | 172.16.10.5 |
| A | mail | 172.16.30.2 |
| MX | @ | mail.tssr.lan (priorité 10) |

### 5.3 Ajouter un enregistrement A

1. Clic droit sur **tssr.lan** → **New Host (A or AAAA)**
2. Remplir :
   - Name : `nom-serveur`
   - IP address : `172.16.10.x`
3. **Add Host**

### 5.4 Ajouter un enregistrement MX

1. Clic droit sur **tssr.lan** → **New Mail Exchanger (MX)**
2. Remplir :
   - Host or child domain : (laisser vide)
   - FQDN of mail server : `mail.tssr.lan`
   - Mail server priority : `10`
3. **OK**

### 5.5 Configurer les DNS Forwarders

1. Clic droit sur **SRVWIN01** → **Properties**
2. Onglet **Forwarders** → **Edit**
3. Ajouter : `8.8.8.8` et `8.8.4.4`
4. **OK**

---

## 6. Configuration DHCP

### 6.1 Créer une étendue (Scope)

1. **Server Manager** → **Tools** → **DHCP**
2. Développer **SRVWIN01** → **IPv4**
3. Clic droit sur **IPv4** → **New Scope**

### 6.2 Configuration de l'étendue LAN_TEST

| Paramètre | Valeur |
|-----------|--------|
| Name | `LAN_TEST` |
| Start IP | `172.16.20.1` |
| End IP | `172.16.20.10` |
| Subnet mask | `255.255.255.240` |
| Exclusions | (aucune) |
| Lease duration | 8 days |
| Router (Gateway) | `172.16.20.14` |
| DNS Server | `172.16.10.2` |
| DNS Domain | `tssr.lan` |

### 6.3 Activer l'étendue

1. Clic droit sur le scope → **Activate**

---

## 7. Structure Active Directory

### 7.1 Créer les OU (Unités d'Organisation)

1. **Server Manager** → **Tools** → **Active Directory Users and Computers**
2. Clic droit sur **tssr.lan** → **New** → **Organizational Unit**

Créer les OU suivantes :

| OU | Description |
|----|-------------|
| `DSI` | Département Systèmes d'Information |
| `Direction` | Direction générale |
| `RH` | Ressources Humaines |
| `Commercial` | Service commercial |
| `Support` | Support technique |
| `Comptabilite` | Service comptabilité |

### 7.2 Créer les groupes

Pour chaque département, créer un groupe :

1. Clic droit sur l'OU → **New** → **Group**
2. Group name : `GRP_DSI` (par exemple)
3. Group scope : **Global**
4. Group type : **Security**

| Groupe | OU |
|--------|-----|
| GRP_DSI | DSI |
| GRP_Direction | Direction |
| GRP_RH | RH |
| GRP_Commercial | Commercial |
| GRP_Support | Support |
| GRP_Comptabilite | Comptabilite |

### 7.3 Créer les utilisateurs

1. Clic droit sur l'OU correspondante → **New** → **User**
2. Remplir les informations

| Utilisateur | OU | Groupe | Fonction |
|-------------|-----|--------|----------|
| Safi WILDER | DSI | GRP_DSI | Manager |
| Admin IT | DSI | GRP_DSI | Standard |
| Jean DUPONT | Direction | GRP_Direction | Manager |
| Marie MARTIN | RH | GRP_RH | Standard |
| Pierre DURAND | Commercial | GRP_Commercial | Standard |
| Sophie PETIT | Support | GRP_Support | Standard |

---

## 8. Stratégie de mot de passe (Active Directory Administrative Center)

### 8.1 Ouvrir Active Directory Administrative Center

1. **Server Manager** → **Tools** → **Active Directory Administrative Center**

Ou taper dans **Exécuter** (Win + R) :

```
dsac.exe
```

### 8.2 Activer la corbeille AD (optionnel mais recommandé)

1. Cliquer sur **tssr (local)** dans le panneau gauche
2. Dans le panneau **Tasks** à droite → **Enable Recycle Bin**
3. **OK** → Rafraîchir

### 8.3 Accéder au Password Settings Container

1. Dans **Active Directory Administrative Center**
2. Cliquer sur **tssr (local)** dans le panneau gauche
3. Double-cliquer sur **System**
4. Double-cliquer sur **Password Settings Container**

### 8.4 Créer un PSO (Password Settings Object)

1. Dans le panneau **Tasks** à droite → **New** → **Password Settings**

### 8.5 Configurer la stratégie de mot de passe

Remplir les champs suivants :

| Champ | Valeur |
|-------|--------|
| **Name** | `PSO_Ekoloclast` |
| **Precedence** | `10` |

**Section Password policy :**

| Paramètre | Valeur |
|-----------|--------|
| Enforce minimum password length | ✅ Coché |
| Minimum password length | `8` |
| Enforce password history | ✅ Coché |
| Number of passwords remembered | `5` |
| Password must meet complexity requirements | ✅ Coché |
| Store password using reversible encryption | ❌ Décoché |
| Enforce minimum password age | ✅ Coché |
| Minimum password age (days) | `1` |
| Enforce maximum password age | ✅ Coché |
| Maximum password age (days) | `90` |

**Section Account lockout policy :**

| Paramètre | Valeur |
|-----------|--------|
| Enforce account lockout policy | ✅ Coché |
| Number of failed logon attempts allowed | `5` |
| Reset failed logon attempts count after (mins) | `30` |
| Account will be locked out for (mins) | `30` |

### 8.6 Appliquer la stratégie aux utilisateurs/groupes

1. Dans la section **Directly Applies To** (en bas)
2. Cliquer sur **Add**
3. Taper `Domain Users` → **Check Names** → **OK**

> Cela applique la stratégie à **tous les utilisateurs du domaine**.

Pour appliquer à des groupes spécifiques uniquement :
- Ajouter : `GRP_DSI`, `GRP_Direction`, etc.

### 8.7 Valider la création

1. Cliquer **OK** pour créer le PSO
2. Le PSO apparaît dans **Password Settings Container**

### 8.8 Vérifier l'application du PSO sur un utilisateur

1. Dans **Active Directory Administrative Center**
2. Aller dans **tssr (local)** → **DSI** (ou autre OU)
3. Cliquer sur un utilisateur (ex: Safi WILDER)
4. Dans le panneau **Tasks** → **View resultant password settings**
5. Vérifier que **PSO_Ekoloclast** est affiché

---

## 9. GPO supplémentaires

### 9.1 Ouvrir Group Policy Management

**Server Manager** → **Tools** → **Group Policy Management**

### 9.2 GPO - Blocage Panneau de configuration

1. Clic droit sur **tssr.lan** → **Create a GPO in this domain, and Link it here**
2. Nom : `GPO_Bloquer_Panneau_Config`
3. Clic droit sur la GPO → **Edit**
4. Naviguer vers :
   - **User Configuration** → **Policies** → **Administrative Templates** → **Control Panel**
5. Double-clic sur **Prohibit access to Control Panel and PC settings**
6. Sélectionner **Enabled** → **OK**
7. Fermer l'éditeur

### 9.3 GPO - Administrateur local du domaine

1. Créer une GPO : `GPO_Admin_Local`
2. **Edit** → Naviguer vers :
   - **Computer Configuration** → **Preferences** → **Control Panel Settings** → **Local Users and Groups**
3. Clic droit → **New** → **Local Group**
4. Group name : **Administrators (built-in)**
5. **Add** → Sélectionner le compte admin du domaine
6. **OK**

### 9.4 GPO - Politique PowerShell

1. Créer une GPO : `GPO_PowerShell_Security`
2. **Edit** → Naviguer vers :
   - **Computer Configuration** → **Policies** → **Administrative Templates** → **Windows Components** → **Windows PowerShell**
3. Configurer :
   - **Turn on Script Execution** : Enabled → Allow only signed scripts
   - **Turn on PowerShell Script Block Logging** : Enabled

### 9.5 GPO - WSUS

1. Créer une GPO : `GPO_WSUS_Config`
2. **Edit** → Naviguer vers :
   - **Computer Configuration** → **Policies** → **Administrative Templates** → **Windows Components** → **Windows Update**
3. Configurer :
   - **Configure Automatic Updates** : Enabled (Auto download and schedule)
   - **Specify intranet Microsoft update service location** : `http://srvwin04.tssr.lan:8530`

---

## 10. Vérification

### 10.1 Vérifier AD DS

```powershell
# Vérifier le domaine
Get-ADDomain

# Lister les utilisateurs
Get-ADUser -Filter *

# Lister les groupes
Get-ADGroup -Filter *

# Lister les OU
Get-ADOrganizationalUnit -Filter *
```

### 10.2 Vérifier DNS

```powershell
# Lister les zones
Get-DnsServerZone

# Lister les enregistrements
Get-DnsServerResourceRecord -ZoneName "tssr.lan"

# Tester la résolution
nslookup mail.tssr.lan
nslookup ipbx01.tssr.lan
```

### 10.3 Vérifier DHCP

```powershell
# Lister les scopes
Get-DhcpServerv4Scope

# Lister les baux
Get-DhcpServerv4Lease -ScopeId 172.16.20.0
```

### 10.4 Vérifier le PSO (stratégie de mot de passe)

```powershell
# Lister les PSO
Get-ADFineGrainedPasswordPolicy -Filter *

# Voir les détails d'un PSO
Get-ADFineGrainedPasswordPolicy -Identity "PSO_Ekoloclast"

# Voir le PSO appliqué à un utilisateur
Get-ADUserResultantPasswordPolicy -Identity "safi.wilder"
```

---

## 11. Dépannage

### 11.1 Utilisateur bloqué

1. **AD Users and Computers** → Trouver l'utilisateur
2. Clic droit → **Properties** → Onglet **Account**
3. Décocher **Unlock account**
4. **OK**

### 11.2 DNS ne résout pas

1. Vérifier les enregistrements dans DNS Manager
2. Vérifier les forwarders
3. Tester : `nslookup nom.tssr.lan 127.0.0.1`

### 11.3 DHCP ne distribue pas d'IP

1. Vérifier que le scope est activé
2. Vérifier que le service DHCP est démarré
3. Vérifier la plage d'adresses

### 11.4 PSO non appliqué

1. Vérifier que le PSO est bien lié aux groupes/utilisateurs dans **Directly Applies To**
2. Vérifier la précédence (Precedence) - le plus bas gagne
3. Utiliser **View resultant password settings** sur l'utilisateur

---

## 📊 Récapitulatif

### Serveur

| Paramètre | Valeur |
|-----------|--------|
| Hostname | srvwin01.tssr.lan |
| IP | 172.16.10.2/28 |
| Passerelle | 172.16.10.14 |
| DNS | 127.0.0.1 |
| Domaine | tssr.lan |

### Accès

| Service | Identifiants |
|---------|--------------|
| Administrator | tssr\Administrator / Azerty1* |

### Enregistrements DNS

| Type | Nom | Valeur |
|------|-----|--------|
| A | srvwin01 | 172.16.10.2 |
| A | srvlx02 | 172.16.10.3 |
| A | srvwin04 | 172.16.10.4 |
| A | ipbx01 | 172.16.10.5 |
| A | mail | 172.16.30.2 |
| MX | @ | mail.tssr.lan |

### PSO (Stratégie de mot de passe via Administrative Center)

| Paramètre | Valeur |
|-----------|--------|
| Nom | PSO_Ekoloclast |
| Longueur minimale | 8 caractères |
| Complexité | Activée |
| Historique | 5 mots de passe |
| Âge minimum | 1 jour |
| Âge maximum | 90 jours |
| Tentatives échouées | 5 |
| Durée verrouillage | 30 min |
| Reset compteur | 30 min |
| Appliqué à | Domain Users |

### GPO

| GPO | Description |
|-----|-------------|
| GPO_Bloquer_Panneau_Config | Bloque l'accès au panneau de configuration |
| GPO_Admin_Local | Ajoute un compte domaine comme admin local |
| GPO_PowerShell_Security | Politique de sécurité PowerShell |
| GPO_WSUS_Config | Configuration WSUS clients |

---

## 📚 Références

- [Microsoft Docs - AD DS](https://docs.microsoft.com/en-us/windows-server/identity/ad-ds/)
- [Microsoft Docs - Fine-Grained Password Policies](https://docs.microsoft.com/en-us/windows-server/identity/ad-ds/get-started/adac/introduction-to-active-directory-administrative-center-enhancements--level-100-#fine_grained_pswd_policy_mgmt)
- [Microsoft Docs - DNS](https://docs.microsoft.com/en-us/windows-server/networking/dns/)

---

**Auteur :** Safi  
**Projet :** Ekoloclast - Infrastructure tssr.lan  
**Version :** Windows Server 2022 / AD DS / DNS / DHCP
