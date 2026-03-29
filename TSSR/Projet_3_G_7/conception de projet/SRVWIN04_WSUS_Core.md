
# Installation et Configuration SRVWIN04 - WSUS sur Windows Server Core

## Projet Ekoloclast - Infrastructure tssr.lan

---

## 📋 Informations du serveur

| Paramètre | Valeur |
|-----------|--------|
| Nom | SRVWIN04 |
| Hostname | `srvwin04.tssr.lan` |
| OS | Windows Server 2022 **Core** (sans GUI) |
| Rôle | WSUS (Windows Server Update Services) |
| IP | 172.16.10.4/28 |
| Passerelle | 172.16.10.14 (FW02) |
| DNS | 172.16.10.2 (SRVWIN01) |
| Zone | LAN_SRV |
| Domaine | tssr.lan |

---

## 📋 Avantages de Windows Server Core

| Aspect | Server Core | Server GUI |
|--------|-------------|------------|
| RAM utilisée | ~512 MB | ~2 GB |
| Espace disque | ~10 GB | ~20 GB |
| Surface d'attaque | Réduite | Plus large |
| Mises à jour | Moins fréquentes | Plus fréquentes |
| Administration | PowerShell / À distance | Interface graphique |

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
            │AD/DNS  │ │ GLPI   │ │ WSUS   │ │FreePBX │
            │ DHCP   │ │        │ │ CORE   │ │        │
            └────────┘ └────────┘ └────────┘ └────────┘
                 │                    ↑
                 │                    │
                 └────── Gestion ─────┘
                       à distance
```

---

## 1. Configuration VirtualBox

### 1.1 Paramètres VM

| Paramètre | Valeur |
|-----------|--------|
| Nom | SRVWIN04 |
| Type | Microsoft Windows |
| Version | Windows 2022 (64-bit) |
| RAM | **2048 MB** (suffisant pour Core) |
| CPU | 2 vCPU |
| Disque | **60 GB** (WSUS stocke les mises à jour) |

### 1.2 Carte réseau

| Paramètre | Valeur |
|-----------|--------|
| Adapter 1 | Internal Network |
| Name | `LAN_SRV` |

---

## 2. Installation Windows Server 2022 Core

### 2.1 Démarrer sur l'ISO

1. Insérer l'ISO Windows Server 2022
2. Démarrer la VM
3. Sélectionner la langue : **Français**
4. Cliquer **Installer maintenant**

### 2.2 Sélectionner l'édition (IMPORTANT)

Choisir :

```
Windows Server 2022 Standard
```

> ⚠️ **NE PAS choisir** "Desktop Experience" - c'est la version avec GUI !

### 2.3 Type d'installation

Sélectionner : **Personnalisée : installer uniquement Windows**

### 2.4 Partitionnement

1. Sélectionner le disque
2. Cliquer **Nouveau** → **Appliquer**
3. **Suivant**

### 2.5 Fin d'installation

1. Attendre la fin de l'installation
2. Le serveur redémarre
3. Définir le mot de passe Administrator : `Azerty1*`

---

## 3. Première connexion - Interface SConfig

Après connexion, l'écran **SConfig** s'affiche automatiquement :

```
┌──────────────────────────────────────────────────────────────────┐
│                    Server Configuration                          │
├──────────────────────────────────────────────────────────────────┤
│  1) Domain/Workgroup:                      Workgroup: WORKGROUP  │
│  2) Computer Name:                         WIN-XXXXXXXX          │
│  3) Add Local Administrator                                      │
│  4) Configure Remote Management            Enabled               │
│  5) Windows Update Settings                                      │
│  6) Download and Install Updates                                 │
│  7) Remote Desktop:                        Disabled              │
│  8) Network Settings                                             │
│  9) Date and Time                                                │
│ 10) Telemetry settings                                           │
│ 11) Windows Activation                                           │
│ 12) Log off User                                                 │
│ 13) Restart Server                                               │
│ 14) Shut Down Server                                             │
│ 15) Exit to Command Line                                         │
├──────────────────────────────────────────────────────────────────┤
│  Enter number to select an option:                               │
└──────────────────────────────────────────────────────────────────┘
```

---

## 4. Configuration réseau via SConfig

### 4.1 Configurer l'IP statique

1. Taper `8` → Entrée (Network Settings)
2. Sélectionner l'adaptateur (généralement `1`)
3. Taper `1` → Set Network Adapter Address
4. Taper `S` → Static IP
5. Entrer les informations :

| Paramètre | Valeur |
|-----------|--------|
| Static IP address | `172.16.10.4` |
| Subnet mask | `255.255.255.240` |
| Default gateway | `172.16.10.14` |

### 4.2 Configurer le DNS

1. Dans le menu Network, taper `2` → Set DNS Servers
2. Entrer : `172.16.10.2`

### 4.3 Vérifier la configuration

Taper `4` → Return to Main Menu

---

## 5. Renommer le serveur

### 5.1 Via SConfig

1. Taper `2` → Computer Name
2. Entrer : `SRVWIN04`
3. Confirmer le redémarrage : **Yes**

---

## 6. Activer le Bureau à distance

### 6.1 Via SConfig

1. Après redémarrage, taper `7` → Remote Desktop
2. Taper `E` → Enable
3. Taper `1` → Allow only clients running Remote Desktop with NLA

---

## 7. Joindre le domaine

### 7.1 Via SConfig

1. Taper `1` → Domain/Workgroup
2. Taper `D` → Domain
3. Entrer le nom du domaine : `tssr.lan`
4. Entrer les credentials :
   - Username : `Administrator`
   - Password : `Azerty1*`
5. Confirmer le redémarrage : **Yes**

---

## 8. Configuration via PowerShell

### 8.1 Accéder à PowerShell

Depuis SConfig, taper `15` → Exit to Command Line

Puis taper :

```powershell
powershell
```

### 8.2 Vérifier la configuration réseau

```powershell
# Voir la configuration IP
Get-NetIPAddress -InterfaceAlias "Ethernet*"

# Voir la passerelle
Get-NetRoute -DestinationPrefix "0.0.0.0/0"

# Voir le DNS
Get-DnsClientServerAddress

# Tester la connectivité
Test-Connection 172.16.10.2
Test-Connection 172.16.10.14
```

### 8.3 Vérifier le domaine

```powershell
# Voir le domaine
(Get-WmiObject Win32_ComputerSystem).Domain

# Voir le nom complet
[System.Net.Dns]::GetHostEntry("localhost").HostName
```

---

## 9. Installation du rôle WSUS

### 9.1 Créer le dossier pour les mises à jour

```powershell
# Créer le dossier de stockage WSUS
New-Item -Path "C:\WSUS" -ItemType Directory
```

### 9.2 Installer le rôle WSUS

```powershell
# Installer WSUS avec la base de données interne Windows (WID)
Install-WindowsFeature -Name UpdateServices -IncludeManagementTools
```

Attendre la fin de l'installation (peut prendre plusieurs minutes).

### 9.3 Vérifier l'installation

```powershell
Get-WindowsFeature -Name UpdateServices*
```

Résultat attendu :

```
Display Name                                            Name                       Install State
------------                                            ----                       -------------
[X] Windows Server Update Services                      UpdateServices                 Installed
    [X] WID Connectivity                                UpdateServices-WidDB           Installed
    [X] WSUS Services                                   UpdateServices-Services        Installed
```

---

## 10. Configuration post-installation WSUS

### 10.1 Exécuter la configuration WSUS

```powershell
# Configurer WSUS avec le chemin de stockage
cd "C:\Program Files\Update Services\Tools"
.\wsusutil.exe postinstall CONTENT_DIR=C:\WSUS
```

Attendre le message : `Post install has successfully completed`

### 10.2 Configurer WSUS via PowerShell

```powershell
# Importer le module WSUS
Import-Module UpdateServices

# Récupérer le serveur WSUS
$wsus = Get-WsusServer

# Voir la configuration
$wsus
```

### 10.3 Configurer la synchronisation

```powershell
# Récupérer la configuration
$wsusConfig = $wsus.GetConfiguration()

# Configurer la source (Microsoft Update)
Set-WsusServerSynchronization -SyncFromMU

# Démarrer la synchronisation initiale (récupère les catégories)
$subscription = $wsus.GetSubscription()
$subscription.StartSynchronizationForCategoryOnly()

# Attendre la fin de la synchronisation des catégories
While ($subscription.GetSynchronizationStatus() -ne 'NotProcessing') {
    Write-Host "Synchronisation en cours..." -ForegroundColor Yellow
    Start-Sleep -Seconds 10
}
Write-Host "Synchronisation des catégories terminée !" -ForegroundColor Green
```

### 10.4 Sélectionner les produits

```powershell
# Voir tous les produits disponibles
Get-WsusProduct | Select-Object -ExpandProperty Product | Select Title

# Activer Windows 10 et Windows 11
Get-WsusProduct | Where-Object {
    $_.Product.Title -in @(
        'Windows 10',
        'Windows 11',
        'Windows Server 2022'
    )
} | Set-WsusProduct

# Désactiver tous les autres produits (optionnel - pour économiser de l'espace)
# Get-WsusProduct | Where-Object { $_.Product.Title -notin @('Windows 10', 'Windows 11', 'Windows Server 2022') } | Set-WsusProduct -Disable
```

### 10.5 Sélectionner les classifications

```powershell
# Voir les classifications
Get-WsusClassification

# Activer uniquement les mises à jour de sécurité et critiques
Get-WsusClassification | Where-Object {
    $_.Classification.Title -in @(
        'Critical Updates',
        'Security Updates',
        'Definition Updates'
    )
} | Set-WsusClassification
```

### 10.6 Configurer la langue

```powershell
# Configurer pour le français uniquement
$wsusConfig = (Get-WsusServer).GetConfiguration()
$wsusConfig.AllUpdateLanguagesEnabled = $false
$wsusConfig.SetEnabledUpdateLanguages(@("fr"))
$wsusConfig.Save()
```

### 10.7 Lancer la première synchronisation complète

```powershell
# Démarrer la synchronisation complète
$subscription = (Get-WsusServer).GetSubscription()
$subscription.StartSynchronization()

Write-Host "Synchronisation démarrée. Cela peut prendre plusieurs heures." -ForegroundColor Yellow

# Vérifier le statut
$subscription.GetSynchronizationStatus()
```

> ⚠️ **Note** : La première synchronisation peut prendre **plusieurs heures** selon la connexion Internet.

---

## 11. Créer les groupes d'ordinateurs WSUS

```powershell
# Récupérer le serveur WSUS
$wsus = Get-WsusServer

# Créer les groupes
$wsus.CreateComputerTargetGroup("Serveurs")
$wsus.CreateComputerTargetGroup("Clients_Windows")
$wsus.CreateComputerTargetGroup("Test")

# Vérifier les groupes
$wsus.GetComputerTargetGroups() | Select Name
```

---

## 12. Configuration de l'administration à distance

### 12.1 Sur SRVWIN04 (Server Core)

```powershell
# Activer WinRM
Enable-PSRemoting -Force

# Configurer le pare-feu pour WSUS
New-NetFirewallRule -DisplayName "WSUS HTTP" -Direction Inbound -Protocol TCP -LocalPort 8530 -Action Allow
New-NetFirewallRule -DisplayName "WSUS HTTPS" -Direction Inbound -Protocol TCP -LocalPort 8531 -Action Allow

# Autoriser l'administration à distance
Set-Item WSMan:\localhost\Client\TrustedHosts -Value "SRVWIN01.tssr.lan" -Force
```

### 12.2 Sur SRVWIN01 (pour administrer WSUS à distance)

1. **Server Manager** → **Manage** → **Add Roles and Features**
2. Aller jusqu'à **Features**
3. Développer **Remote Server Administration Tools** → **Role Administration Tools**
4. Cocher **Windows Server Update Services Tools**
5. **Install**

### 12.3 Connecter la console WSUS à SRVWIN04

Sur SRVWIN01 :

1. **Server Manager** → **Tools** → **Windows Server Update Services**
2. Dans la console WSUS : **Action** → **Connect to Server**
3. Server name : `SRVWIN04.tssr.lan`
4. Port : `8530`
5. Décocher "Use SSL"
6. **Connect**

---

## 13. Configuration GPO pour les clients

### 13.1 Sur SRVWIN01 - Créer la GPO

1. **Server Manager** → **Tools** → **Group Policy Management**
2. Clic droit sur **tssr.lan** → **Create a GPO in this domain, and Link it here**
3. Nom : `GPO_WSUS_Config`

### 13.2 Configurer la GPO

1. Clic droit sur **GPO_WSUS_Config** → **Edit**
2. Naviguer vers :
   - **Computer Configuration** → **Policies** → **Administrative Templates** → **Windows Components** → **Windows Update**

### 13.3 Paramètres à configurer

| Paramètre | Valeur |
|-----------|--------|
| Configure Automatic Updates | Enabled → 4 - Auto download and schedule |
| Specify intranet Microsoft update service location | `http://srvwin04.tssr.lan:8530` |
| Specify intranet statistics server | `http://srvwin04.tssr.lan:8530` |
| Enable client-side targeting | Enabled → `Clients_Windows` |

---

## 14. Commandes d'administration courantes

### 14.1 Se connecter à SRVWIN04 depuis SRVWIN01

```powershell
# Ouvrir une session PowerShell à distance
Enter-PSSession -ComputerName SRVWIN04.tssr.lan -Credential tssr\Administrator
```

### 14.2 Commandes WSUS utiles

```powershell
# Importer le module
Import-Module UpdateServices

# Récupérer le serveur
$wsus = Get-WsusServer

# Voir le statut de synchronisation
$wsus.GetSubscription().GetSynchronizationStatus()

# Voir la dernière synchronisation
$wsus.GetSubscription().LastSynchronizationTime

# Lancer une synchronisation
$wsus.GetSubscription().StartSynchronization()

# Voir les ordinateurs
Get-WsusComputer -All

# Voir les mises à jour disponibles
Get-WsusUpdate -Approval Unapproved -Status Needed

# Approuver une mise à jour pour un groupe
$update = Get-WsusUpdate -UpdateId "ID-DE-LA-MISE-A-JOUR"
$group = $wsus.GetComputerTargetGroups() | Where-Object { $_.Name -eq "Clients_Windows" }
Approve-WsusUpdate -Update $update -Action Install -TargetGroupName "Clients_Windows"
```

### 14.3 Maintenance WSUS

```powershell
# Nettoyer les mises à jour obsolètes
Invoke-WsusServerCleanup -CleanupObsoleteUpdates -CleanupUnneededContentFiles

# Voir l'espace disque utilisé
Get-ChildItem C:\WSUS -Recurse | Measure-Object -Property Length -Sum
```

---

## 15. Retourner à SConfig

Pour revenir à l'écran SConfig depuis PowerShell :

```powershell
exit
sconfig
```

---

## 16. Commandes de maintenance Server Core

### 16.1 Gestion des services

```powershell
# Voir les services WSUS
Get-Service -Name *wsus*, *wuauserv*

# Redémarrer WSUS
Restart-Service -Name WsusService

# Voir le statut
Get-Service -Name WsusService
```

### 16.2 Gestion du serveur

```powershell
# Redémarrer le serveur
Restart-Computer -Force

# Arrêter le serveur
Stop-Computer -Force

# Voir les logs d'événements
Get-EventLog -LogName Application -Newest 50

# Voir l'espace disque
Get-PSDrive -PSProvider FileSystem
```

### 16.3 Mises à jour du serveur Core

```powershell
# Chercher les mises à jour disponibles
$searcher = New-Object -ComObject Microsoft.Update.Searcher
$results = $searcher.Search("IsInstalled=0")
$results.Updates | Select-Object Title

# Installer les mises à jour via SConfig
# Taper 6 dans SConfig
```

---

## 17. Dépannage

### 17.1 WSUS ne démarre pas

```powershell
# Vérifier le service
Get-Service -Name WsusService

# Voir les logs
Get-EventLog -LogName Application -Source "Windows Server Update Services" -Newest 20

# Redémarrer le service
Restart-Service -Name WsusService
```

### 17.2 Les clients ne se connectent pas

```powershell
# Vérifier le port 8530
Test-NetConnection -ComputerName localhost -Port 8530

# Vérifier le pare-feu
Get-NetFirewallRule -DisplayName "*WSUS*"

# Sur le client, forcer la détection
# (exécuter sur le client)
wuauclt /detectnow
```

### 17.3 Synchronisation échoue

```powershell
# Voir le statut
$wsus = Get-WsusServer
$wsus.GetSubscription().GetLastSynchronizationInfo()

# Vérifier la connectivité Internet
Test-Connection update.microsoft.com
```

### 17.4 Réinitialiser WSUS

```powershell
# Arrêter le service
Stop-Service -Name WsusService

# Réinitialiser la base de données
cd "C:\Program Files\Update Services\Tools"
.\wsusutil.exe reset

# Redémarrer
Start-Service -Name WsusService
```

---

## 18. Sauvegarde

### 18.1 Sauvegarder la configuration WSUS

```powershell
# Exporter la configuration
cd "C:\Program Files\Update Services\Tools"
.\wsusutil.exe export C:\Backup\wsus_export.xml.gz C:\Backup\wsus_export.log
```

### 18.2 Sauvegarder la base de données WID

```powershell
# Créer le dossier de backup
New-Item -Path "C:\Backup" -ItemType Directory -Force

# La base WID est dans :
# C:\Windows\WID\Data\SUSDB.mdf
# C:\Windows\WID\Data\SUSDB_log.ldf

# Copier les fichiers (service arrêté)
Stop-Service -Name WsusService
Copy-Item "C:\Windows\WID\Data\SUSDB.mdf" "C:\Backup\SUSDB.mdf"
Copy-Item "C:\Windows\WID\Data\SUSDB_log.ldf" "C:\Backup\SUSDB_log.ldf"
Start-Service -Name WsusService
```

---

## 📊 Récapitulatif

### Serveur

| Paramètre | Valeur |
|-----------|--------|
| Hostname | srvwin04.tssr.lan |
| IP | 172.16.10.4/28 |
| Passerelle | 172.16.10.14 |
| DNS | 172.16.10.2 |
| OS | Windows Server 2022 Core |
| Domaine | tssr.lan |

### Accès

| Méthode | Identifiants |
|---------|--------------|
| Console locale | tssr\Administrator / Azerty1* |
| PowerShell Remoting | Enter-PSSession -ComputerName SRVWIN04.tssr.lan |
| Bureau à distance | mstsc /v:SRVWIN04.tssr.lan |
| Console WSUS | Depuis SRVWIN01 → Tools → WSUS |

### WSUS

| Paramètre | Valeur |
|-----------|--------|
| Port HTTP | 8530 |
| Port HTTPS | 8531 |
| Dossier contenu | C:\WSUS |
| URL client | http://srvwin04.tssr.lan:8530 |

### Groupes WSUS

| Groupe | Usage |
|--------|-------|
| Serveurs | Serveurs Windows |
| Clients_Windows | Postes clients |
| Test | Groupe de test |

### GPO

| GPO | Paramètre |
|-----|-----------|
| GPO_WSUS_Config | http://srvwin04.tssr.lan:8530 |

---

## 📚 Commandes essentielles

```powershell
# Ouvrir SConfig
sconfig

# Session PowerShell distante depuis SRVWIN01
Enter-PSSession -ComputerName SRVWIN04.tssr.lan

# Statut WSUS
$wsus = Get-WsusServer
$wsus.GetSubscription().GetSynchronizationStatus()

# Lancer synchronisation
(Get-WsusServer).GetSubscription().StartSynchronization()

# Voir les ordinateurs
Get-WsusComputer -All

# Nettoyer WSUS
Invoke-WsusServerCleanup -CleanupObsoleteUpdates
```

---

## 📚 Références

- [Microsoft Docs - Windows Server Core](https://docs.microsoft.com/en-us/windows-server/administration/server-core/what-is-server-core)
- [Microsoft Docs - WSUS](https://docs.microsoft.com/en-us/windows-server/administration/windows-server-update-services/)
- [Microsoft Docs - WSUS PowerShell](https://docs.microsoft.com/en-us/powershell/module/updateservices/)

---

**Auteur :** Safi  
**Projet :** Ekoloclast - Infrastructure tssr.lan  
**Version :** Windows Server 2022 Core / WSUS
