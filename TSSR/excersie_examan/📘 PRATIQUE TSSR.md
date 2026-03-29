

## Mise en situation professionnelle

---

## 📋 CONTEXTE

Tu viens d'être embauché en tant que **Technicien Systèmes et Réseaux** dans l'entreprise **SWEETCAKES**, une PME spécialisée dans la pâtisserie industrielle. L'entreprise compte 3 services :

- **Direction** (2 personnes)
- **Comptabilité** (3 personnes)
- **Production** (5 personnes) Tu interviens sur l'infrastructure informatique suite au départ d'un collaborateur et à l'arrivée d'un nouveau.

---

## 🖥️ INFRASTRUCTURE À MONTER

### Machines virtuelles (VirtualBox)

| Nom          | OS                  | Fonction         | RAM  | Réseau                  |
| ------------ | ------------------- | ---------------- | ---- | ----------------------- |
| **SRVWIN01** | Windows Server 2022 | AD-DS, DNS, DHCP | 4 Go | Réseau interne "intnet" |
| **SRVLX01**  | Debian 12           | Serveur Linux    | 2 Go | Réseau interne "intnet" |
| **CLIENT01** | Windows 10/11       | Poste client 1   | 2 Go | Réseau interne "intnet" |
| **CLIENT02** | Windows 10/11       | Poste client 2   | 2 Go | Réseau interne "intnet" |


### Plan d'adressage IP

| Machine  | Adresse IP   | Masque              | Passerelle   | DNS          |
| -------- | ------------ | ------------------- | ------------ | ------------ |
| SRVWIN01 | 172.16.10.10 | /24 (255.255.255.0) | -            | 127.0.0.1    |
| SRVLX01  | 172.16.10.20 | /24 (255.255.255.0) | 172.16.10.10 | 172.16.10.10 |
| CLIENT01 | DHCP         | /24                 | Via DHCP     | Via DHCP     |
| CLIENT02 | DHCP         | /24                 | Via DHCP     | Via DHCP     |

### Informations du domaine

- **Nom de domaine** : sweetcakes.lan
- **Nom NetBIOS** : SWEETCAKES
- **Mot de passe Administrateur** : Azerty1*

---

## ⚠️ LÉGENDE DES RÉPONSES

- **🖱️ GUI** = Solution graphique (interface Windows)
- **⌨️ PowerShell** = Solution en ligne de commande (bonus)

---

# PARTIE 1 : INSTALLATION ET CONFIGURATION DE BASE

---

## Exercice 1.1 - Configuration réseau du serveur Windows

**Consigne :** Configure l'adresse IP statique sur SRVWIN01 selon le plan d'adressage.

> [!tip]- Réponse
> 
> ### 🖱️ Solution graphique (GUI)
> 
> **Étape 1 :** Ouvrir le Centre Réseau et partage
> 
> - Clic droit sur l'icône réseau en bas à droite (barre des tâches)
> - Cliquer sur **"Ouvrir les paramètres réseau et Internet"**
> - Cliquer sur **"Centre Réseau et partage"** (en bas)
> 
> **Étape 2 :** Accéder aux propriétés de la carte réseau
> 
> - Cliquer sur **"Modifier les paramètres de la carte"** (menu de gauche)
> - Clic droit sur **"Ethernet"** → **"Propriétés"**
> 
> **Étape 3 :** Configurer IPv4
> 
> - Double-cliquer sur **"Protocole Internet version 4 (TCP/IPv4)"**
> - Cocher **"Utiliser l'adresse IP suivante"**
> - Remplir :
>     - **Adresse IP :** 172.16.10.10
>     - **Masque de sous-réseau :** 255.255.255.0
>     - **Passerelle par défaut :** (laisser vide)
> - Cocher **"Utiliser l'adresse de serveur DNS suivante"**
>     - **Serveur DNS préféré :** 127.0.0.1
> - Cliquer **OK** puis **Fermer**
> 
> **Étape 4 :** Vérifier la configuration
> 
> - Ouvrir **cmd** (touche Windows + R, taper `cmd`, Entrée)
> - Taper : `ipconfig /all`
> - Vérifier que l'IP est bien 172.16.10.10
> 
> ---
> 
> ### ⌨️ Solution PowerShell (bonus)
> 
> ```powershell
> # Voir les interfaces
> Get-NetAdapter
> 
> # Configurer l'IP (adapter InterfaceIndex selon ta machine)
> New-NetIPAddress -InterfaceIndex 5 -IPAddress 172.16.10.10 -PrefixLength 24
> 
> # Configurer le DNS
> Set-DnsClientServerAddress -InterfaceIndex 5 -ServerAddresses 127.0.0.1
> 
> # Vérifier
> ipconfig /all
> ```

---

## Exercice 1.2 - Renommer le serveur Windows

**Consigne :** Renomme le serveur en **SRVWIN01** et redémarre.

> [!tip]- Réponse
> 
> ### 🖱️ Solution graphique (GUI)
> 
> **Étape 1 :** Ouvrir les propriétés système
> 
> - Clic droit sur **"Ce PC"** (sur le Bureau ou dans l'Explorateur)
> - Cliquer sur **"Propriétés"**
> 
> **Étape 2 :** Renommer l'ordinateur
> 
> - Cliquer sur **"Renommer ce PC"** (ou "Modifier les paramètres" → onglet "Nom de l'ordinateur" → "Modifier")
> - Dans le champ "Nom de l'ordinateur", taper : **SRVWIN01**
> - Cliquer **OK**
> 
> **Étape 3 :** Redémarrer
> 
> - Cliquer **OK** sur le message qui demande de redémarrer
> - Cliquer **"Redémarrer maintenant"**
> 
> **Étape 4 :** Vérifier après redémarrage
> 
> - Ouvrir **cmd**
> - Taper : `hostname`
> - Doit afficher : SRVWIN01
> 
> ---
> 
> ### ⌨️ Solution PowerShell (bonus)
> 
> ```powershell
> Rename-Computer -NewName "SRVWIN01" -Restart
> ```

---

## Exercice 1.3 - Préparer la connectivité client avant AD (IP statique + fichier hosts)

**SCÉNARIO :** Avant d'installer AD-DS et DNS, le client ne peut pas résoudre le nom du serveur. Tu dois configurer une IP statique temporaire et modifier le fichier hosts pour que le client puisse joindre le serveur par son nom. **Consigne :**

1. Sur CLIENT01, configure une IP statique temporaire : **172.16.10.50/24**, DNS : **172.16.10.10**
2. Modifie le fichier hosts de CLIENT01 pour que le nom **SRVWIN01** et **srvwin01.sweetcakes.lan** pointent vers 172.16.10.10
3. Vérifie avec `ping SRVWIN01`

> [!tip]- Réponse
> 
> ### 🖱️ Solution graphique (GUI)
> 
> **Étape 1 :** Configurer une IP statique temporaire sur CLIENT01
> 
> - Clic droit icône réseau → **"Ouvrir les paramètres réseau et Internet"**
> - **"Modifier les paramètres de la carte"**
> - Clic droit **Ethernet** → **Propriétés** → **TCP/IPv4**
> - Cocher **"Utiliser l'adresse IP suivante"**
>     - **IP :** 172.16.10.50
>     - **Masque :** 255.255.255.0
>     - **Passerelle :** 172.16.10.10
>     - **DNS préféré :** 172.16.10.10
> - **OK** → **Fermer**
> 
> **Étape 2 :** Modifier le fichier hosts
> 
> - Ouvrir **Bloc-notes en administrateur** (clic droit → Exécuter en tant qu'administrateur)
> - Fichier → Ouvrir → `C:\Windows\System32\drivers\etc\hosts` (changer en "Tous les fichiers")
> - Ajouter à la fin :
>     
>     ```
>     172.16.10.10    SRVWIN01172.16.10.10    srvwin01.sweetcakes.lan
>     ```
>     
> - Enregistrer
> 
> **Étape 3 :** Vérifier
> 
> ```cmd
> ping SRVWIN01
> ping srvwin01.sweetcakes.lan
> ```
> 
> - Doit répondre 172.16.10.10
> 
> **⚠️ Note :** Cette config est temporaire. Après l'installation d'AD-DS + DNS + DHCP, on repassera CLIENT01 en DHCP et le fichier hosts ne sera plus nécessaire (le DNS prendra le relais).

---

## Exercice 1.4 - Installation du rôle AD-DS

**Consigne :** Installe le rôle Active Directory Domain Services et promeut le serveur en contrôleur de domaine pour le domaine **sweetcakes.lan**.

> [!tip]- Réponse
> 
> ### 🖱️ Solution graphique (GUI)
> 
> **PARTIE A - Installer le rôle AD-DS**
> 
> **Étape 1 :** Ouvrir le Gestionnaire de serveur
> 
> - Cliquer sur l'icône **"Gestionnaire de serveur"** dans la barre des tâches
> 
> **Étape 2 :** Ajouter un rôle
> 
> - Cliquer sur **"Gérer"** (en haut à droite)
> - Cliquer sur **"Ajouter des rôles et fonctionnalités"**
> 
> **Étape 3 :** Assistant d'ajout de rôles
> 
> - **Avant de commencer :** Cliquer **Suivant**
> - **Type d'installation :** Garder "Installation basée sur un rôle ou une fonctionnalité" → **Suivant**
> - **Sélection du serveur :** Garder SRVWIN01 sélectionné → **Suivant**
> - **Rôles de serveurs :** Cocher **"Services AD DS"**
>     - Une fenêtre popup apparaît → Cliquer **"Ajouter des fonctionnalités"**
>     - Cliquer **Suivant**
> - **Fonctionnalités :** Cliquer **Suivant** (ne rien ajouter)
> - **AD DS :** Lire les informations → Cliquer **Suivant**
> - **Confirmation :** Cliquer **"Installer"**
> - Attendre la fin de l'installation
> 
> ---
> 
> **PARTIE B - Promouvoir en contrôleur de domaine**
> 
> **Étape 4 :** Lancer la promotion
> 
> - Dans le Gestionnaire de serveur, cliquer sur le **drapeau jaune** ⚠️ (notifications)
> - Cliquer sur **"Promouvoir ce serveur en contrôleur de domaine"**
> 
> **Étape 5 :** Configuration du déploiement
> 
> - Cocher **"Ajouter une nouvelle forêt"**
> - **Nom de domaine racine :** sweetcakes.lan
> - Cliquer **Suivant**
> 
> **Étape 6 :** Options du contrôleur de domaine
> 
> - **Niveau fonctionnel :** Windows Server 2016 (ou plus récent)
> - Cocher : ✅ Serveur DNS
> - Cocher : ✅ Catalogue global (GC)
> - **Mot de passe DSRM :** Azerty1* (et confirmer)
> - Cliquer **Suivant**
> 
> **Étape 7 :** Options DNS → Ignorer l'avertissement → **Suivant**
> 
> **Étape 8 :** Options supplémentaires → **Nom NetBIOS :** SWEETCAKES → **Suivant**
> 
> **Étape 9 :** Chemins → Garder par défaut → **Suivant**
> 
> **Étape 10 :** Vérifier et installer
> 
> - Ignorer les avertissements normaux → Cliquer **"Installer"**
> - ⏳ Le serveur redémarre automatiquement
> 
> **Étape 11 :** Vérifier après redémarrage
> 
> - Se connecter avec : **SWEETCAKES\Administrator** / Azerty1*
> - Ouvrir **cmd** : `systeminfo | findstr Domaine` → sweetcakes.lan
> 
> ---
> 
> ### ⌨️ Solution PowerShell (bonus)
> 
> ```powershell
> Install-WindowsFeature -Name AD-Domain-Services -IncludeManagementTools
> 
> Install-ADDSForest `
>     -DomainName "sweetcakes.lan" `
>     -DomainNetBIOSName "SWEETCAKES" `
>     -InstallDNS:$true `
>     -SafeModeAdministratorPassword (ConvertTo-SecureString "Azerty1*" -AsPlainText -Force) `
>     -Force:$true
> ```

---

## Exercice 1.5 - Joindre CLIENT01 au domaine

**Consigne :**

1. Repasse CLIENT01 en **DHCP** (supprime l'IP statique temporaire de l'exercice 1.3)
2. Vérifie qu'il reçoit une IP du serveur DHCP (le rôle DHCP sera installé en Partie 3)
3. Joins CLIENT01 au domaine sweetcakes.lan

**⚠️ Prérequis :** Le rôle DHCP doit être installé (Partie 3, exercice 3.1) avant de faire cet exercice. Si le DHCP n'est pas encore en place, garde l'IP statique temporaire et configure le DNS manuellement sur 172.16.10.10.

> [!tip]- Réponse
> 
> ### 🖱️ Solution graphique (GUI)
> 
> **⚠️ PRÉREQUIS IMPORTANT :**
> 
> - Le serveur SRVWIN01 doit être allumé et configuré (AD-DS + DNS actifs)
> - Les deux machines doivent être sur le même réseau VirtualBox ("intnet")
> 
> ---
> 
> **PARTIE A - Repasser en DHCP (ou vérifier la connectivité)**
> 
> **Étape 1 :** Sur CLIENT01, ouvrir les paramètres réseau
> 
> - Clic droit sur l'icône réseau → **"Ouvrir les paramètres réseau et Internet"**
> - **"Modifier les paramètres de la carte"**
> 
> **Étape 2 :** Configurer en DHCP
> 
> - Clic droit sur **Ethernet** → **Propriétés**
> - Double-cliquer sur **"Protocole Internet version 4 (TCP/IPv4)"**
> - Cocher **"Obtenir une adresse IP automatiquement"**
> - Cocher **"Obtenir les adresses des serveurs DNS automatiquement"**
> - Cliquer **OK** puis **Fermer**
> 
> **Étape 3 :** Renouveler l'IP
> 
> ```cmd
> ipconfig /release
> ipconfig /renew
> ipconfig /all
> ```
> 
> - Vérifier : IP dans la plage 172.16.10.110-200, DNS = 172.16.10.10
> 
> **Étape 4 :** Vérifier la résolution DNS
> 
> ```cmd
> nslookup sweetcakes.lan
> ping SRVWIN01
> ```
> 
> - Si ça ne répond pas → ne pas continuer
> 
> ---
> 
> **PARTIE B - Joindre le domaine**
> 
> **Étape 5 :** Clic droit sur **"Ce PC"** → **"Propriétés"** → **"Paramètres avancés du système"** → Onglet **"Nom de l'ordinateur"** → **"Modifier..."**
> 
> **Étape 6 :** Cocher **"Domaine"** → taper : **sweetcakes.lan** → **OK**
> 
> **Étape 7 :** Identifiants : **Administrator** / **Azerty1*** → **OK**
> 
> **Étape 8 :** Message "Bienvenue dans le domaine" → **Redémarrer**
> 
> **Étape 9 :** Vérifier : `systeminfo | findstr Domaine` → sweetcakes.lan
> 
> ---
> 
> ### ⌨️ Solution PowerShell (bonus)
> 
> ```powershell
> Add-Computer -DomainName "sweetcakes.lan" -Credential (Get-Credential) -Restart
> ```

---

## Exercice 1.6 - Joindre CLIENT02 au domaine

**Consigne :**

1. Configure CLIENT02 en DHCP
2. Vérifie qu'il reçoit une IP du serveur DHCP
3. Joins CLIENT02 au domaine sweetcakes.lan

> [!tip]- Réponse
> 
> **Procédure identique à l'exercice 1.5** (CLIENT01), appliquée sur CLIENT02.
> 
> **Étape 1 :** Vérifier réseau VirtualBox : CLIENT02 doit être sur le réseau interne **"intnet"**
> 
> **Étape 2 :** Configurer en DHCP → `ipconfig /release` → `ipconfig /renew`
> 
> - Vérifier IP dans la plage 172.16.10.110 - 172.16.10.200
> 
> **Étape 3 :** Vérifier DNS : `nslookup sweetcakes.lan` et `ping SRVWIN01`
> 
> **Étape 4 :** Joindre le domaine
> 
> - Clic droit **Ce PC** → Propriétés → Modifier → Domaine : **sweetcakes.lan**
> - Identifiants : **Administrator** / **Azerty1***
> - Redémarrer
> 
> **Étape 5 :** Vérifier : `systeminfo | findstr Domaine` → sweetcakes.lan
> 
> ---
> 
> ### ⌨️ Solution PowerShell (bonus)
> 
> ```powershell
> Add-Computer -DomainName "sweetcakes.lan" -Credential (Get-Credential) -Restart
> ```
> 
> **⚠️ CLIENT02 sert principalement aux tests de téléphonie** (2ème softphone).

---

# PARTIE 2 : DNS

---

## Exercice 2.1 - Ajouter une entrée dans le fichier hosts

**Consigne :** Le nom "serveur-test" doit pointer vers 172.16.10.99 sur CLIENT01, sans modifier le DNS.

> [!tip]- Réponse
> 
> - Ouvrir **Bloc-notes en administrateur**
> - Fichier → Ouvrir → `C:\Windows\System32\drivers\etc\hosts` (changer en "Tous les fichiers")
> - Ajouter : `172.16.10.99 serveur-test`
> - Enregistrer → Tester : `ping serveur-test`

---

## Exercice 2.2 - Créer un alias DNS (CNAME)

**SCÉNARIO :** SRVLX01 héberge un intranet. Les utilisateurs doivent y accéder via **http://intranet.sweetcakes.lan** **Consigne :**

1. Créer un enregistrement **A** pour SRVLX01 pointant vers **172.16.10.20**
2. Créer un alias **CNAME** `intranet` pointant vers SRVLX01
3. Vérifier avec `nslookup intranet.sweetcakes.lan` depuis CLIENT01

> [!tip]- Réponse
> 
> ### 🖱️ Solution graphique (GUI)
> 
> **Étape 1 :** Ouvrir **dnsmgmt.msc** → Zones de recherche directes → sweetcakes.lan
> 
> **Étape 2 :** Créer enregistrement A : clic droit → **Nouvel hôte (A)** → Nom : SRVLX01, IP : 172.16.10.20 → **Ajouter**
> 
> **Étape 3 :** Créer alias CNAME : clic droit → **Nouvel alias (CNAME)** → Nom : intranet → Parcourir → SRVLX01 → **OK**
> 
> **Étape 4 :** Vérifier : `nslookup intranet.sweetcakes.lan` → doit résoudre 172.16.10.20

---

## Exercice 2.3 - Créer un enregistrement DNS A pour l'IPBX

**SCÉNARIO :** Faire en sorte que le serveur IPBX soit accessible par le nom **ipbx.sweetcakes.lan**. **Consigne :**

1. Créer un enregistrement **A** dans la zone DNS sweetcakes.lan : nom **ipbx**, IP **172.16.10.5**
2. Vérifier avec `nslookup ipbx.sweetcakes.lan` et `ping ipbx.sweetcakes.lan` depuis CLIENT01

> [!tip]- Réponse
> 
> ### 🖱️ Solution graphique (GUI)
> 
> **Étape 1 :** Ouvrir **dnsmgmt.msc** → Zones de recherche directes → sweetcakes.lan
> 
> **Étape 2 :** Clic droit sur la zone → **Nouvel hôte (A ou AAAA)...**
> 
> - **Nom :** ipbx
> - **Adresse IP :** 172.16.10.5
> - Cliquer **Ajouter un hôte** → **OK** → **Terminé**
> 
> **Étape 3 :** Vérifier sur le client
> 
> ```cmd
> nslookup ipbx.sweetcakes.lan
> ping ipbx.sweetcakes.lan
> ```
> 
> ---
> 
> ### ⌨️ Solution PowerShell (bonus)
> 
> ```powershell
> Add-DnsServerResourceRecordA -ZoneName "sweetcakes.lan" -Name "ipbx" -IPv4Address "172.16.10.5"
> ```

---

## Exercice 2.4 - Créer un enregistrement MX fictif

**SCÉNARIO :** L'entreprise prévoit d'installer un serveur de messagerie. Tu dois préparer l'enregistrement DNS MX. **Consigne :** Crée un enregistrement **MX** dans la zone sweetcakes.lan pointant vers **mail.sweetcakes.lan** avec une priorité de **10**. Crée d'abord l'enregistrement A pour mail (172.16.10.30).

> [!tip]- Réponse
> 
> ### 🖱️ Solution graphique (GUI)
> 
> **Étape 1 :** Créer d'abord l'enregistrement A pour le serveur mail
> 
> - **dnsmgmt.msc** → sweetcakes.lan → clic droit → **Nouvel hôte (A)**
> - Nom : **mail** | IP : **172.16.10.30** → **Ajouter**
> 
> **Étape 2 :** Créer l'enregistrement MX
> 
> - Clic droit sur la zone sweetcakes.lan → **"Nouvel enregistrement de courrier (MX)..."** _(New Mail Exchanger)_
> - **Domaine :** (laisser vide = sweetcakes.lan)
> - **Serveur de messagerie :** mail.sweetcakes.lan
> - **Priorité :** 10
> - **OK**
> 
> **Étape 3 :** Vérifier
> 
> ```cmd
> nslookup -type=MX sweetcakes.lan
> ```
> 
> Doit afficher : `mail exchanger = 10 mail.sweetcakes.lan`
> 
> ---
> 
> ### ⌨️ Solution PowerShell (bonus)
> 
> ```powershell
> Add-DnsServerResourceRecordA -ZoneName "sweetcakes.lan" -Name "mail" -IPv4Address "172.16.10.30"
> Add-DnsServerResourceRecordMX -ZoneName "sweetcakes.lan" -Name "." -MailExchange "mail.sweetcakes.lan" -Preference 10
> ```
> 
> **📌 L'enregistrement MX :**
> 
> - Indique quel serveur gère les emails du domaine
> - La **priorité** (plus petit = plus prioritaire) permet d'avoir plusieurs serveurs mail en failover
> - Ex : MX 10 mail.sweetcakes.lan (primaire) + MX 20 mail2.sweetcakes.lan (secours)

---

## Exercice 2.5 - Comprendre l'enregistrement SOA

**SCÉNARIO :** Le jury peut te demander d'expliquer l'enregistrement SOA d'une zone DNS. **Consigne :** Affiche l'enregistrement SOA de la zone sweetcakes.lan. Identifie et explique chaque champ.

> [!tip]- Réponse
> 
> **Étape 1 :** Afficher le SOA
> 
> ```cmd
> nslookup -type=SOA sweetcakes.lan
> ```
> 
> **Étape 2 :** Via GUI
> 
> - **dnsmgmt.msc** → sweetcakes.lan → double-cliquer sur l'enregistrement **SOA** (Start of Authority)
> 
> **Étape 3 :** Champs du SOA
> 
> |Champ|Valeur type|Signification|
> |---|---|---|
> |**Serveur principal** _(Primary server)_|srvwin01.sweetcakes.lan|Le serveur DNS maître de la zone|
> |**Responsable** _(Responsible person)_|hostmaster.sweetcakes.lan|Email du responsable (le `.` remplace le `@`)|
> |**Numéro de série** _(Serial number)_|1 (ou date)|Incrémenté à chaque modification → les DNS secondaires savent qu'il faut synchroniser|
> |**Actualisation** _(Refresh)_|900 (15 min)|Fréquence de vérification par les DNS secondaires|
> |**Nouvelle tentative** _(Retry)_|600 (10 min)|Délai de réessai si le refresh échoue|
> |**Expiration** _(Expire)_|86400 (24h)|Si le secondaire ne joint plus le primaire après ce délai, il arrête de répondre|
> |**TTL minimum**|3600 (1h)|Durée de cache par défaut pour les enregistrements|
> 
> **📌 Le SOA est créé automatiquement** avec la zone. On ne le crée pas manuellement, mais il faut savoir le lire et l'expliquer à l'oral.

---

## Exercice 2.6 - Créer un enregistrement NS fictif

**SCÉNARIO :** L'entreprise prévoit un DNS secondaire. Tu dois ajouter un enregistrement NS. **Consigne :** Crée un enregistrement A pour **ns2** (172.16.10.11) puis un enregistrement **NS** pointant vers ns2.sweetcakes.lan.

> [!tip]- Réponse
> 
> ### 🖱️ Solution graphique (GUI)
> 
> **Étape 1 :** Créer l'enregistrement A pour ns2
> 
> - **dnsmgmt.msc** → sweetcakes.lan → clic droit → **Nouvel hôte (A)**
> - Nom : **ns2** | IP : **172.16.10.11** → **Ajouter**
> 
> **Étape 2 :** Ajouter l'enregistrement NS
> 
> - Clic droit sur sweetcakes.lan → **Propriétés**
> - Onglet **"Serveurs de noms"** _(Name Servers)_
> - **Ajouter** → taper : **ns2.sweetcakes.lan** → **Résoudre** → **OK**
> 
> **Étape 3 :** Vérifier
> 
> ```cmd
> nslookup -type=NS sweetcakes.lan
> ```
> 
> Doit afficher : srvwin01.sweetcakes.lan ET ns2.sweetcakes.lan
> 
> ---
> 
> ### ⌨️ Solution PowerShell (bonus)
> 
> ```powershell
> Add-DnsServerResourceRecordA -ZoneName "sweetcakes.lan" -Name "ns2" -IPv4Address "172.16.10.11"
> Add-DnsServerResourceRecord -ZoneName "sweetcakes.lan" -NS -Name "." -NameServer "ns2.sweetcakes.lan"
> ```
> 
> **📌 L'enregistrement NS :**
> 
> - Indique quels serveurs DNS font **autorité** sur la zone
> - Chaque zone doit avoir au moins 1 NS (le primaire)
> - En ajouter un 2ème = préparation pour un DNS secondaire (redondance)

---

## Exercice 2.7 - Créer un enregistrement AAAA (IPv6)

**SCÉNARIO :** Tu dois préparer un enregistrement DNS pour qu'un futur serveur soit accessible en IPv6. **Consigne :** Crée un enregistrement **AAAA** pour **srvlx01-v6** pointant vers l'adresse IPv6 **fd00::20** dans la zone sweetcakes.lan. Vérifie avec nslookup.

> [!tip]- Réponse
> 
> ### 🖱️ Solution graphique (GUI)
> 
> **Étape 1 :** Ouvrir **dnsmgmt.msc** → sweetcakes.lan
> 
> **Étape 2 :** Clic droit → **Nouvel hôte (A ou AAAA)...**
> 
> - **Nom :** srvlx01-v6
> - **Adresse IP :** fd00::20
> - Cliquer **Ajouter un hôte** → **OK**
> 
> **Étape 3 :** Vérifier
> 
> ```cmd
> nslookup -type=AAAA srvlx01-v6.sweetcakes.lan
> ```
> 
> Doit afficher : fd00::20
> 
> ---
> 
> ### ⌨️ Solution PowerShell (bonus)
> 
> ```powershell
> Add-DnsServerResourceRecordAAAA -ZoneName "sweetcakes.lan" -Name "srvlx01-v6" -IPv6Address "fd00::20"
> ```
> 
> **📌 Différence A vs AAAA :**
> 
> |Type|Version IP|Exemple|
> |---|---|---|
> |**A**|IPv4|172.16.10.20|
> |**AAAA**|IPv6|fd00::20|

---

## Exercice 2.8 - Créer une zone de recherche inversée DNS (PTR)

**SCÉNARIO :** Tu dois pouvoir résoudre une IP vers un nom (résolution inversée). **Consigne :**

1. Créer la zone de recherche inversée pour le réseau **172.16.10.0/24**
2. Ajouter les enregistrements PTR
3. Tester la résolution inversée depuis CLIENT01

> [!tip]- Réponse
> 
> ### 🖱️ Solution graphique (GUI)
> 
> **Étape 1 :** Ouvrir **dnsmgmt.msc** → **Zones de recherche inversée**
> 
> **Étape 2 :** Clic droit → **Nouvelle zone...**
> 
> - Type : **Zone principale** → Suivant
> - Réplication : **Vers tous les serveurs DNS du domaine** → Suivant
> - **Zone de recherche inversée IPv4** → Suivant
> - **ID réseau :** 172.16.10 → Suivant
> - **Mises à jour dynamiques :** Autoriser uniquement les mises à jour dynamiques sécurisées → Suivant
> - **Terminer**
> 
> **Étape 3 :** Ajouter un enregistrement PTR manuellement
> 
> - Développer **Zones de recherche inversée** → **10.16.172.in-addr.arpa**
> - Clic droit → **Nouveau pointeur (PTR)...**
> - **Numéro IP de l'hôte :** 10 (pour 172.16.10.10)
> - **Nom d'hôte :** Parcourir → sélectionner **SRVWIN01** → **OK**
> - Répéter pour SRVLX01 (IP : 20)
> 
> **Étape 4 :** Tester depuis CLIENT01
> 
> ```cmd
> nslookup 172.16.10.10
> nslookup 172.16.10.20
> ```
> 
> ---
> 
> ### ⌨️ Solution PowerShell (bonus)
> 
> ```powershell
> Add-DnsServerPrimaryZone -NetworkId "172.16.10.0/24" -ReplicationScope "Domain"
> Add-DnsServerResourceRecordPtr -ZoneName "10.16.172.in-addr.arpa" -Name "10" -PtrDomainName "SRVWIN01.sweetcakes.lan"
> Add-DnsServerResourceRecordPtr -ZoneName "10.16.172.in-addr.arpa" -Name "20" -PtrDomainName "SRVLX01.sweetcakes.lan"
> ```

---

## 📌 Récap types d'enregistrements DNS

|Type|Rôle|Exemple|
|---|---|---|
|**A**|Nom → IPv4|srvlx01 → 172.16.10.20|
|**AAAA**|Nom → IPv6|srvlx01-v6 → fd00::20|
|**CNAME**|Alias → un autre nom|intranet → srvlx01|
|**MX**|Serveur de messagerie du domaine|sweetcakes.lan → mail.sweetcakes.lan (priorité 10)|
|**NS**|Serveurs DNS faisant autorité|sweetcakes.lan → srvwin01.sweetcakes.lan|
|**PTR**|IP → Nom (résolution inversée)|172.16.10.10 → srvwin01.sweetcakes.lan|
|**SOA**|Infos d'autorité de la zone (auto)|Serveur primaire, serial, refresh, expire...|

---

# PARTIE 3 : DHCP (installation + avancé)

---

## Exercice 3.1 - Installation et configuration du rôle DHCP

**Consigne :**

1. Installe le rôle DHCP sur SRVWIN01
2. Crée une étendue avec les paramètres suivants :
    - Nom : LAN_SWEETCAKES
    - Plage : 172.16.10.100 à 172.16.10.200
    - Masque : 255.255.255.0
    - Passerelle : 172.16.10.10
    - DNS : 172.16.10.10
    - Durée du bail : 8 jours

> [!tip]- Réponse
> 
> ### 🖱️ Solution graphique (GUI)
> 
> **PARTIE A - Installer le rôle DHCP**
> 
> **Étape 1 :** Gestionnaire de serveur → **"Gérer"** → **"Ajouter des rôles et fonctionnalités"**
> 
> **Étape 2 :** Cliquer **Suivant** jusqu'à "Rôles de serveurs" → Cocher **"Serveur DHCP"** → **"Ajouter des fonctionnalités"** → **Suivant** → **"Installer"**
> 
> **Étape 3 :** Drapeau jaune ⚠️ → **"Terminer la configuration DHCP"** → **Valider** → **Fermer**
> 
> ---
> 
> **PARTIE B - Créer l'étendue DHCP**
> 
> **Étape 4 :** Ouvrir la console **DHCP** (Outils → DHCP)
> 
> **Étape 5 :** Développer srvwin01.sweetcakes.lan → Clic droit sur **"IPv4"** → **"Nouvelle étendue..."**
> 
> **Étape 6 :** Assistant :
> 
> - **Nom :** LAN_SWEETCAKES → **Suivant**
> - **Plage :** Début : 172.16.10.100 | Fin : 172.16.10.200 | Masque : 255.255.255.0 → **Suivant**
> - **Exclusions :** Suivant (on le fait après)
> - **Durée du bail :** 8 jours → **Suivant**
> - **Options DHCP :** Oui, configurer maintenant → **Suivant**
> - **Routeur :** 172.16.10.10 → **Ajouter** → **Suivant**
> - **DNS :** sweetcakes.lan + 172.16.10.10 → **Suivant**
> - **WINS :** Suivant
> - **Activer :** Oui → **Suivant** → **Terminer**
> 
> ---
> 
> ### ⌨️ Solution PowerShell (bonus)
> 
> ```powershell
> Install-WindowsFeature -Name DHCP -IncludeManagementTools
> Add-DhcpServerInDC -DnsName "SRVWIN01.sweetcakes.lan" -IPAddress 172.16.10.10
> Add-DhcpServerv4Scope -Name "LAN_SWEETCAKES" -StartRange 172.16.10.100 -EndRange 172.16.10.200 -SubnetMask 255.255.255.0 -LeaseDuration 8.00:00:00 -State Active
> Set-DhcpServerv4OptionValue -ScopeId 172.16.10.0 -Router 172.16.10.10
> Set-DhcpServerv4OptionValue -ScopeId 172.16.10.0 -DnsServer 172.16.10.10
> Set-DhcpServerv4OptionValue -ScopeId 172.16.10.0 -DnsDomain "sweetcakes.lan"
> ```

---

## Exercice 3.2 - Ajouter une plage d'exclusion DHCP IPv4

**Consigne :** Ajoute une plage d'exclusion de 172.16.10.100 à 172.16.10.109 (réservée pour les serveurs et imprimantes).

> [!tip]- Réponse
> 
> ### 🖱️ Solution graphique (GUI)
> 
> - Console DHCP → IPv4 → LAN_SWEETCAKES → clic droit **"Pool d'adresses"** → **"Nouvelle plage d'exclusion..."**
> - **Début :** 172.16.10.100 | **Fin :** 172.16.10.109 → **Ajouter** → **Fermer**
> - Vérifier dans "Pool d'adresses" : la plage d'exclusion est affichée
> 
> ---
> 
> ### ⌨️ Solution PowerShell (bonus)
> 
> ```powershell
> Add-DhcpServerv4ExclusionRange -ScopeId 172.16.10.0 -StartRange 172.16.10.100 -EndRange 172.16.10.109
> ```

---

## Exercice 3.3 - Ajouter une plage d'exclusion DHCP IPv6

**SCÉNARIO :** L'entreprise active IPv6 sur le réseau. Tu dois configurer une exclusion sur l'étendue IPv6 du serveur DHCP. **Consigne :**

1. Ouvre la console DHCP → développe **IPv6**
2. Si aucune étendue IPv6 n'existe, crée une étendue avec le préfixe **fd00::/64**
3. Ajoute une plage d'exclusion IPv6 : **fd00::1** à **fd00::10** (réservée aux serveurs)

> [!tip]- Réponse
> 
> ### 🖱️ Solution graphique (GUI)
> 
> **Étape 1 :** Console DHCP → clic droit sur **IPv6** → **"Nouvelle étendue..."**
> 
> - **Nom :** LAN_SWEETCAKES_V6
> - **Préfixe :** fd00::
> - **Préférence :** 0
> - **Suivant** → configurer les paramètres → **Terminer**
> 
> **Étape 2 :** Développer IPv6 → étendue → clic droit **"Exclusions"** → **"Nouvelle plage d'exclusion..."**
> 
> - **Début :** fd00::1
> - **Fin :** fd00::10
> - **Ajouter** → **Fermer**
> 
> ---
> 
> ### ⌨️ Solution PowerShell (bonus)
> 
> ```powershell
> Add-DhcpServerv6Scope -Prefix fd00:: -Name "LAN_SWEETCAKES_V6" -State Active
> Add-DhcpServerv6ExclusionRange -Prefix fd00:: -StartRange fd00::1 -EndRange fd00::10
> ```

---

## Exercice 3.4 - Créer une réservation DHCP IPv4

**SCÉNARIO :** Le poste CLIENT01 doit toujours recevoir l'adresse IP **172.16.10.110**. **Consigne :**

1. Récupérer l'**adresse MAC** de CLIENT01 avec `ipconfig /all`
2. Créer une **réservation DHCP** pour CLIENT01 sur l'IP **172.16.10.110**
3. Renouveler le bail et vérifier

> [!tip]- Réponse
> 
> **Étape 1 :** Sur CLIENT01 : `ipconfig /all` → noter l'**adresse physique** (MAC)
> 
> **Étape 2 :** Sur SRVWIN01, console DHCP → IPv4 → LAN_SWEETCAKES → clic droit **Réservations** → **Nouvelle réservation**
> 
> - **Nom :** CLIENT01
> - **Adresse IP :** 172.16.10.110
> - **Adresse MAC :** 080027A1B2C3 (⚠️ sans tirets !)
> - Cliquer **Ajouter** → **Fermer**
> 
> **⚠️ PIÈGE :** L'IP de réservation doit être **hors de la plage d'exclusion** (100-109).
> 
> **Étape 3 :** Sur CLIENT01 : `ipconfig /release` puis `ipconfig /renew` → vérifier IP = 172.16.10.110
> 
> ---
> 
> ### ⌨️ Solution PowerShell (bonus)
> 
> ```powershell
> Add-DhcpServerv4Reservation -ScopeId 172.16.10.0 -IPAddress 172.16.10.110 -ClientId "080027A1B2C3" -Name "CLIENT01"
> ```

---

## Exercice 3.4b - Créer une réservation DHCP IPv6

**SCÉNARIO :** Tu dois réserver une adresse IPv6 pour un serveur. **Consigne :** Crée une réservation IPv6 dans l'étendue fd00::/64 pour un équipement avec l'adresse **fd00::100** et son identifiant DUID.

> [!tip]- Réponse
> 
> ### 🖱️ Solution graphique (GUI)
> 
> **Étape 1 :** Récupérer le DUID du client
> 
> - Sur le client : `ipconfig /all` → noter le **DUID DHCPv6 client**
> 
> **Étape 2 :** Console DHCP → IPv6 → étendue → clic droit **Réservations** → **Nouvelle réservation...**
> 
> - **Nom :** SRV-RESERVE-V6
> - **Adresse IPv6 :** fd00::100
> - **DUID :** (coller le DUID récupéré)
> - **Ajouter** → **Fermer**
> 
> ---
> 
> ### ⌨️ Solution PowerShell (bonus)
> 
> ```powershell
> Add-DhcpServerv6Reservation -Prefix fd00:: -IPAddress fd00::100 -ClientDuid "00-01-00-01-XX-XX-XX-XX" -Name "SRV-RESERVE-V6"
> ```
> 
> **📌 Différence IPv4 vs IPv6 pour les réservations :**
> 
> ||IPv4|IPv6|
> |---|---|---|
> |**Identifiant client**|Adresse MAC|DUID (DHCPv6 Unique Identifier)|
> |**Format**|080027A1B2C3 (sans tirets)|00-01-00-01-XX-XX-XX-XX|

---

## Exercice 3.5 - Modifier la plage DHCP IPv4

**SCÉNARIO :** Limiter la distribution DHCP aux adresses **172.16.10.110 à 172.16.10.150**. **Consigne :** Ajouter une exclusion pour bloquer les adresses **151 à 200**.

> [!tip]- Réponse
> 
> Console DHCP → Pool d'adresses → clic droit → **Nouvelle plage d'exclusion**
> 
> - Début : 172.16.10.151 | Fin : 172.16.10.200 → **Ajouter** → **Fermer**
> 
> Résultat : exclusions 100-109 + 151-200 → distribution : **110 à 150**

---

## Exercice 3.5b - Modifier la plage DHCP IPv6

**SCÉNARIO :** Limiter la distribution DHCPv6 de la même façon. **Consigne :** Ajouter une exclusion IPv6 pour bloquer **fd00::100 à fd00::200**.

> [!tip]- Réponse
> 
> Console DHCP → IPv6 → étendue → **Exclusions** → clic droit → **Nouvelle plage d'exclusion...**
> 
> - **Début :** fd00::100 | **Fin :** fd00::200 → **Ajouter** → **Fermer**
> 
> ---
> 
> ### ⌨️ Solution PowerShell (bonus)
> 
> ```powershell
> Add-DhcpServerv6ExclusionRange -Prefix fd00:: -StartRange fd00::100 -EndRange fd00::200
> ```

---

# PARTIE 4 : GESTION DES UTILISATEURS ET GROUPES AD

---

## Exercice 4.1 - Créer la structure d'OU

**Consigne :** Crée la structure d'unités d'organisation suivante :

```
sweetcakes.lan
├── OU=Utilisateurs
│   ├── OU=Direction
│   ├── OU=Comptabilite
│   └── OU=Production
├── OU=Ordinateurs
└── OU=Groupes
```

> [!tip]- Réponse
> 
> ### 🖱️ Solution graphique (GUI)
> 
> **Étape 1 :** Ouvrir **dsa.msc**
> 
> **Étape 2 :** Clic droit sur **sweetcakes.lan** → **Nouveau** → **Unité d'organisation** → Nom : **Utilisateurs** → OK
> 
> **Étape 3 :** Clic droit sur l'OU **Utilisateurs** → Nouveau → OU → **Direction** → OK. Répéter pour **Comptabilite** et **Production**
> 
> **Étape 4 :** Clic droit sur sweetcakes.lan → Nouveau → OU → **Ordinateurs** → OK
> 
> **Étape 5 :** Idem pour **Groupes** → OK
> 
> ---
> 
> ### ⌨️ Solution PowerShell (bonus)
> 
> ```powershell
> New-ADOrganizationalUnit -Name "Utilisateurs" -Path "DC=sweetcakes,DC=lan"
> New-ADOrganizationalUnit -Name "Ordinateurs" -Path "DC=sweetcakes,DC=lan"
> New-ADOrganizationalUnit -Name "Groupes" -Path "DC=sweetcakes,DC=lan"
> New-ADOrganizationalUnit -Name "Direction" -Path "OU=Utilisateurs,DC=sweetcakes,DC=lan"
> New-ADOrganizationalUnit -Name "Comptabilite" -Path "OU=Utilisateurs,DC=sweetcakes,DC=lan"
> New-ADOrganizationalUnit -Name "Production" -Path "OU=Utilisateurs,DC=sweetcakes,DC=lan"
> ```

---

## Exercice 4.2 - Créer les groupes de sécurité

**Consigne :** Crée les groupes de sécurité globaux suivants dans l'OU Groupes : GRP_Direction, GRP_Comptabilite, GRP_Production.

> [!tip]- Réponse
> 
> ### 🖱️ Solution graphique (GUI)
> 
> - **dsa.msc** → OU **Groupes** → clic droit → **Nouveau** → **Groupe**
> - **Nom :** GRP_Direction | **Étendue :** Globale | **Type :** Sécurité → OK
> - Répéter pour **GRP_Comptabilite** et **GRP_Production**
> 
> ---
> 
> ### ⌨️ Solution PowerShell (bonus)
> 
> ```powershell
> New-ADGroup -Name "GRP_Direction" -GroupScope Global -GroupCategory Security -Path "OU=Groupes,DC=sweetcakes,DC=lan"
> New-ADGroup -Name "GRP_Comptabilite" -GroupScope Global -GroupCategory Security -Path "OU=Groupes,DC=sweetcakes,DC=lan"
> New-ADGroup -Name "GRP_Production" -GroupScope Global -GroupCategory Security -Path "OU=Groupes,DC=sweetcakes,DC=lan"
> ```

---

## Exercice 4.3 - Créer les utilisateurs

**Consigne :** Crée les utilisateurs suivants avec le mot de passe **Azerty123!** :

|Prénom|Nom|Login|Service|OU|
|---|---|---|---|---|
|Marie|DUPONT|m.dupont|Direction|Direction|
|Jean|MARTIN|j.martin|Comptabilité|Comptabilite|
|Pierre|DURAND|p.durand|Comptabilité|Comptabilite|
|Sophie|BERNARD|s.bernard|Production|Production|

> [!tip]- Réponse
> 
> ### 🖱️ Solution graphique (GUI)
> 
> **Pour Marie DUPONT :** dsa.msc → Utilisateurs → Direction → clic droit → Nouveau → Utilisateur
> 
> - Prénom : Marie | Nom : DUPONT | Login : m.dupont → Suivant
> - Mot de passe : Azerty123! | Décocher "doit changer" | Cocher "n'expire jamais" → Suivant → Terminer
> - Double-cliquer → Onglet Organisation → Service : Direction, Société : SWEETCAKES → OK
> 
> **Répéter pour :** Jean MARTIN, Pierre DURAND, Sophie BERNARD dans leurs OU respectives
> 
> ---
> 
> ### ⌨️ Solution PowerShell (bonus)
> 
> ```powershell
> $Password = ConvertTo-SecureString "Azerty123!" -AsPlainText -Force
> 
> New-ADUser -Name "Marie DUPONT" -GivenName "Marie" -Surname "DUPONT" -SamAccountName "m.dupont" -UserPrincipalName "m.dupont@sweetcakes.lan" -Path "OU=Direction,OU=Utilisateurs,DC=sweetcakes,DC=lan" -AccountPassword $Password -Enabled $true -Department "Direction" -Company "SWEETCAKES"
> 
> New-ADUser -Name "Jean MARTIN" -GivenName "Jean" -Surname "MARTIN" -SamAccountName "j.martin" -UserPrincipalName "j.martin@sweetcakes.lan" -Path "OU=Comptabilite,OU=Utilisateurs,DC=sweetcakes,DC=lan" -AccountPassword $Password -Enabled $true -Department "Comptabilite" -Company "SWEETCAKES"
> 
> New-ADUser -Name "Pierre DURAND" -GivenName "Pierre" -Surname "DURAND" -SamAccountName "p.durand" -UserPrincipalName "p.durand@sweetcakes.lan" -Path "OU=Comptabilite,OU=Utilisateurs,DC=sweetcakes,DC=lan" -AccountPassword $Password -Enabled $true -Department "Comptabilite" -Company "SWEETCAKES"
> 
> New-ADUser -Name "Sophie BERNARD" -GivenName "Sophie" -Surname "BERNARD" -SamAccountName "s.bernard" -UserPrincipalName "s.bernard@sweetcakes.lan" -Path "OU=Production,OU=Utilisateurs,DC=sweetcakes,DC=lan" -AccountPassword $Password -Enabled $true -Department "Production" -Company "SWEETCAKES"
> ```

---

## Exercice 4.4 - Ajouter les utilisateurs aux groupes

**Consigne :** Ajoute chaque utilisateur au groupe correspondant à son service.

> [!tip]- Réponse
> 
> ### 🖱️ Solution graphique (GUI)
> 
> - OU **Groupes** → Double-cliquer **GRP_Direction** → Onglet **Membres** → **Ajouter** → m.dupont → **OK**
> - Double-cliquer **GRP_Comptabilite** → Membres → Ajouter → **j.martin; p.durand** → OK
> - Double-cliquer **GRP_Production** → Membres → Ajouter → **s.bernard** → OK
> 
> ---
> 
> ### ⌨️ Solution PowerShell (bonus)
> 
> ```powershell
> Add-ADGroupMember -Identity "GRP_Direction" -Members "m.dupont"
> Add-ADGroupMember -Identity "GRP_Comptabilite" -Members "j.martin", "p.durand"
> Add-ADGroupMember -Identity "GRP_Production" -Members "s.bernard"
> ```

---

## Exercice 4.5 - Mettre en place l'AGDLP

**SCÉNARIO :** Le dossier `\\SRVWIN01\Projets` doit être accessible en **Modification** par Comptabilité et en **Lecture seule** par Production. Tu dois appliquer la méthode **AGDLP**. **Consigne :**

1. Crée les groupes **DL_Projets_RW** et **DL_Projets_RO** (Domain Local, Sécurité) dans l'OU Groupes
2. Imbrique : GRP_Comptabilite → DL_Projets_RW, GRP_Production → DL_Projets_RO

> [!tip]- Réponse
> 
> ### 🖱️ Solution graphique (GUI)
> 
> **Étape 1 :** dsa.msc → OU **Groupes** → Nouveau → Groupe
> 
> - Nom : **DL_Projets_RW** | Étendue : **Domaine local** | Type : **Sécurité** → OK
> - Répéter pour **DL_Projets_RO**
> 
> **Étape 2 :** Imbriquer
> 
> - Double-cliquer **DL_Projets_RW** → Membres → Ajouter → **GRP_Comptabilite** → OK
> - Double-cliquer **DL_Projets_RO** → Membres → Ajouter → **GRP_Production** → OK
> 
> **Schéma AGDLP :**
> 
> ```
> l.moreau (Account) → GRP_Comptabilite (Global) → DL_Projets_RW (Domain Local) → Modify sur C:\Projets
> s.bernard (Account) → GRP_Production (Global) → DL_Projets_RO (Domain Local) → Read sur C:\Projets
> ```
> 
> **⚠️ Pourquoi AGDLP ?**
> 
> - Permissions NTFS TOUJOURS sur groupes **Domain Local** (DL_)
> - Utilisateurs TOUJOURS dans groupes **Globaux** (GRP_)
> - Avantage : nouveau service → ajouter son GRP_ dans le DL_ sans toucher aux permissions
> 
> ---
> 
> ### ⌨️ Solution PowerShell (bonus)
> 
> ```powershell
> New-ADGroup -Name "DL_Projets_RW" -GroupScope DomainLocal -GroupCategory Security -Path "OU=Groupes,DC=sweetcakes,DC=lan"
> New-ADGroup -Name "DL_Projets_RO" -GroupScope DomainLocal -GroupCategory Security -Path "OU=Groupes,DC=sweetcakes,DC=lan"
> Add-ADGroupMember -Identity "DL_Projets_RW" -Members "GRP_Comptabilite"
> Add-ADGroupMember -Identity "DL_Projets_RO" -Members "GRP_Production"
> ```

---

# PARTIE 5 : SCÉNARIO - DÉPART ET ARRIVÉE D'UN COLLABORATEUR

---

## Exercice 5.1 - Départ d'un collaborateur

**SCÉNARIO :** Jean MARTIN quitte l'entreprise. **Consigne :** Sécurise son compte : crée une OU pour archiver les comptes désactivés, désactive le compte, réinitialise le mot de passe, retire-le de ses groupes et déplace-le.

> [!tip]- Réponse
> 
> ### 🖱️ Solution graphique (GUI)
> 
> **Étape 1 :** Créer l'OU **Utilisateurs_Desactives** (clic droit sweetcakes.lan → Nouveau → OU)
> 
> **Étape 2 :** Désactiver le compte : clic droit **Jean MARTIN** → **"Désactiver le compte"**
> 
> **Étape 3 :** Réinitialiser le mot de passe : clic droit → **"Réinitialiser le mot de passe"** → Desactive2024!
> 
> **Étape 4 :** Retirer des groupes : Double-cliquer → onglet **Membre de** → sélectionner GRP_Comptabilite → **Supprimer** (⚠️ garder "Utilisateurs du domaine")
> 
> **Étape 5 :** Déplacer : clic droit → **"Déplacer"** → sélectionner **Utilisateurs_Desactives** → **OK**
> 
> ---
> 
> ### ⌨️ Solution PowerShell (bonus)
> 
> ```powershell
> New-ADOrganizationalUnit -Name "Utilisateurs_Desactives" -Path "DC=sweetcakes,DC=lan"
> Disable-ADAccount -Identity "j.martin"
> Set-ADAccountPassword -Identity "j.martin" -Reset -NewPassword (ConvertTo-SecureString "Desactive2024!" -AsPlainText -Force)
> Get-ADUser "j.martin" -Properties MemberOf | Select-Object -ExpandProperty MemberOf | Where-Object { $_ -notlike "*Domain Users*" } | ForEach-Object { Remove-ADGroupMember -Identity $_ -Members "j.martin" -Confirm:$false }
> Move-ADObject -Identity (Get-ADUser "j.martin").DistinguishedName -TargetPath "OU=Utilisateurs_Desactives,DC=sweetcakes,DC=lan"
> ```

---

## Exercice 5.2 - Arrivée d'un nouveau collaborateur

**SCÉNARIO :** Lucie MOREAU remplace Jean MARTIN au service Comptabilité. **Consigne :** Consulte les attributs de l'ancien, crée le nouveau compte avec les mêmes attributs et ajoute-le au bon groupe.

> [!tip]- Réponse
> 
> ### 🖱️ Solution graphique (GUI)
> 
> **Étape 1 :** Consulter les attributs de l'ancien (Utilisateurs_Desactives → Jean MARTIN → Onglet **Organisation** → noter Service + Société)
> 
> **Étape 2 :** Créer dans **Utilisateurs → Comptabilite** : clic droit → Nouveau → Utilisateur
> 
> - Prénom : Lucie | Nom : MOREAU | Login : l.moreau | Mot de passe : Azerty123!
> - Onglet Organisation → Service : Comptabilite, Société : SWEETCAKES
> 
> **Étape 3 :** Ajouter au groupe : GRP_Comptabilite → Membres → Ajouter → l.moreau
> 
> ---
> 
> ### ⌨️ Solution PowerShell (bonus)
> 
> ```powershell
> $ancien = Get-ADUser "j.martin" -Properties Department, Company
> New-ADUser -Name "Lucie MOREAU" -GivenName "Lucie" -Surname "MOREAU" -SamAccountName "l.moreau" -UserPrincipalName "l.moreau@sweetcakes.lan" -Path "OU=Comptabilite,OU=Utilisateurs,DC=sweetcakes,DC=lan" -AccountPassword (ConvertTo-SecureString "Azerty123!" -AsPlainText -Force) -Enabled $true -Department $ancien.Department -Company $ancien.Company
> Add-ADGroupMember -Identity "GRP_Comptabilite" -Members "l.moreau"
> ```

---

# PARTIE 6 : SERVEUR DE FICHIERS ET PARTAGES

---

## Exercice 6.1 - Installer le rôle Serveur de fichiers

**Consigne :** Installe le rôle **Serveur de fichiers** (File Server) sur SRVWIN01 via le Gestionnaire de serveur.

> [!tip]- Réponse
> 
> ### 🖱️ Solution graphique (GUI)
> 
> **Étape 1 :** Ouvrir le **Gestionnaire de serveur** _(Server Manager)_
> 
> **Étape 2 :** Cliquer sur **"Ajouter des rôles et fonctionnalités"** _(Add Roles and Features)_
> 
> - Suivant → Installation basée sur un rôle → Suivant → Sélectionner SRVWIN01 → Suivant
> 
> **Étape 3 :** Dans la liste des rôles :
> 
> - Développer **"Services de fichiers et de stockage"** _(File and Storage Services)_
> - Développer **"Services de fichiers et iSCSI"** _(File and iSCSI Services)_
> - Cocher **"Serveur de fichiers"** _(File Server)_ → si déjà coché, c'est installé par défaut
> - Suivant → Suivant → **Installer**
> 
> ---
> 
> ### ⌨️ Solution PowerShell (bonus)
> 
> ```powershell
> # Vérifier si déjà installé
> Get-WindowsFeature -Name FS-FileServer
> 
> # Installer si nécessaire
> Install-WindowsFeature -Name FS-FileServer -IncludeManagementTools
> ```

---

## Exercice 6.2 - Créer les dossiers partagés

**Consigne :** Crée les dossiers suivants sur SRVWIN01 et partage-les :

|Dossier|Chemin|Nom de partage|Permissions Share|Permissions NTFS|
|---|---|---|---|---|
|Partage|C:\Partage|Partage|Everyone → Full Control|Utilisateurs du domaine → Modification|
|Wallpapers|C:\Wallpapers|Wallpapers|Everyone → Read|Utilisateurs du domaine → Lecture|
|Projets|C:\Projets|Projets|Everyone → Full Control|(sera configuré en AGDLP dans la Partie 8)|

> [!tip]- Réponse
> 
> ### 🖱️ Solution graphique (GUI)
> 
> **Pour chaque dossier (exemple avec C:\Partage) :**
> 
> **Étape 1 :** Créer le dossier
> 
> - Ouvrir l'Explorateur → C:\ → Clic droit → Nouveau dossier → nommer **Partage**
> 
> **Étape 2 :** Partager le dossier
> 
> - Clic droit sur le dossier → **Propriétés** → Onglet **Partage** _(Sharing)_
> - **Partage avancé** _(Advanced Sharing)_ → Cocher **"Partager ce dossier"** _(Share this folder)_
> - Nom du partage : **Partage**
> - **Autorisations** _(Permissions)_ → Tout le monde _(Everyone)_ → **Contrôle total** _(Full Control)_ → OK
> 
> **Étape 3 :** Configurer les permissions NTFS
> 
> - Onglet **Sécurité** _(Security)_ → **Modifier** _(Edit)_ → **Ajouter** _(Add)_
> - Taper **Utilisateurs du domaine** _(Domain Users)_ → Vérifier les noms → OK
> - Cocher **Modification** _(Modify)_ → OK
> 
> ⚠️ **Best practice :** Permissions **larges sur le partage** (Everyone Full Control), filtrage **fin en NTFS**
> 
> **Répéter pour Wallpapers** (Lecture seule) **et Projets** (Full Control en partage, NTFS configuré plus tard)
> 
> ---
> 
> ### ⌨️ Solution PowerShell (bonus)
> 
> ```powershell
> # Créer les dossiers
> New-Item -Path "C:\Partage" -ItemType Directory
> New-Item -Path "C:\Wallpapers" -ItemType Directory
> New-Item -Path "C:\Projets" -ItemType Directory
> 
> # Partager
> New-SmbShare -Name "Partage" -Path "C:\Partage" -FullAccess "Everyone"
> New-SmbShare -Name "Wallpapers" -Path "C:\Wallpapers" -ReadAccess "Everyone"
> New-SmbShare -Name "Projets" -Path "C:\Projets" -FullAccess "Everyone"
> 
> # Permissions NTFS sur Partage
> $acl = Get-Acl "C:\Partage"
> $acl.AddAccessRule((New-Object System.Security.AccessControl.FileSystemAccessRule("SWEETCAKES\Utilisateurs du domaine","Modify","ContainerInherit,ObjectInherit","None","Allow")))
> Set-Acl "C:\Partage" $acl
> 
> # Permissions NTFS sur Wallpapers
> $acl = Get-Acl "C:\Wallpapers"
> $acl.AddAccessRule((New-Object System.Security.AccessControl.FileSystemAccessRule("SWEETCAKES\Utilisateurs du domaine","ReadAndExecute","ContainerInherit,ObjectInherit","None","Allow")))
> Set-Acl "C:\Wallpapers" $acl
> ```
> 
> **Copier une image compta.jpg dans C:\Wallpapers** (nécessaire pour la GPO fond d'écran)

---

# PARTIE 7 : ADAC — POLITIQUE DE MOT DE PASSE

---

## Exercice 7.1 - Ouvrir ADAC (Active Directory Administrative Center)

**Consigne :** Ouvre le **Centre d'administration Active Directory** (ADAC) sur SRVWIN01 et explore l'interface.

> [!tip]- Réponse
> 
> ### 🖱️ Solution graphique (GUI)
> 
> **Méthode 1 :** Touche Windows → taper **dsac.exe** → Entrée
> 
> **Méthode 2 :** Gestionnaire de serveur → Outils → **Centre d'administration Active Directory** _(Active Directory Administrative Center)_
> 
> **Ce que tu vois :**
> 
> - Vue d'ensemble du domaine sweetcakes.lan
> - Navigation : tu retrouves les OU, utilisateurs, groupes (comme dans dsa.msc mais interface différente)
> - ADAC permet de gérer les **stratégies de mot de passe affinées (FGPP)** → ce que dsa.msc ne permet pas
> 
> **📌 Comparaison outils AD :**
> 
> |Outil|Commande|Utilisation principale|
> |---|---|---|
> |**ADUC**|dsa.msc|Gestion courante utilisateurs/groupes/OU|
> |**ADAC**|dsac.exe|FGPP, corbeille AD, vues avancées|
> |**GPMC**|gpmc.msc|Gestion des GPO|

---

## Exercice 7.2 - Créer une PSO (Password Settings Object) / FGPP

**SCÉNARIO :** La Direction veut une politique de mot de passe plus stricte que la politique par défaut du domaine. Les membres de GRP_Direction doivent avoir un mot de passe de **minimum 12 caractères**, renouvelé tous les **60 jours**, avec **5 tentatives** avant verrouillage. **Consigne :** Crée une PSO (stratégie de mot de passe affinée) nommée **PSO_Direction** dans ADAC. Applique-la au groupe **GRP_Direction**.

> [!tip]- Réponse
> 
> ### 🖱️ Solution graphique (GUI)
> 
> **Étape 1 :** Ouvrir ADAC → **dsac.exe**
> 
> **Étape 2 :** Naviguer vers le conteneur **System → Password Settings Container**
> 
> - Dans le panneau de gauche : sweetcakes (local) → **System** → **Password Settings Container**
> 
> **Étape 3 :** Créer la PSO
> 
> - Clic droit dans le volet central → **Nouveau** → **Paramètres de mot de passe** _(Password Settings)_
> - Remplir :
>     - **Nom :** PSO_Direction
>     - **Priorité (Precedence) :** 10 (plus le chiffre est bas, plus la priorité est haute)
>     - **Longueur minimale du mot de passe :** 12
>     - **Durée de vie maximale du mot de passe :** 60 jours
>     - **Nombre de tentatives échouées autorisées :** 5
>     - **Durée de verrouillage du compte :** 30 minutes
>     - **Historique des mots de passe :** 10 (l'utilisateur ne peut pas réutiliser les 10 derniers)
>     - Cocher **"Le mot de passe doit respecter des exigences de complexité"**
> 
> **Étape 4 :** Appliquer à un groupe
> 
> - Section **"S'applique directement à"** _(Directly Applies To)_ → **Ajouter**
> - Taper **GRP_Direction** → Vérifier les noms → OK
> 
> **Étape 5 :** Cliquer **OK** pour créer la PSO
> 
> ---
> 
> ### ⌨️ Solution PowerShell (bonus)
> 
> ```powershell
> New-ADFineGrainedPasswordPolicy -Name "PSO_Direction" `
>     -Precedence 10 `
>     -MinPasswordLength 12 `
>     -MaxPasswordAge "60.00:00:00" `
>     -LockoutThreshold 5 `
>     -LockoutDuration "00:30:00" `
>     -LockoutObservationWindow "00:30:00" `
>     -PasswordHistoryCount 10 `
>     -ComplexityEnabled $true
> 
> # Appliquer au groupe
> Add-ADFineGrainedPasswordPolicySubject -Identity "PSO_Direction" -Subjects "GRP_Direction"
> 
> # Vérifier
> Get-ADFineGrainedPasswordPolicy -Identity "PSO_Direction"
> Get-ADFineGrainedPasswordPolicySubject -Identity "PSO_Direction"
> ```
> 
> **📌 À retenir :**
> 
> - **PSO/FGPP** = permet d'avoir des politiques de mot de passe **différentes par groupe** (contrairement à la GPO par défaut qui s'applique à tout le domaine)
> - S'applique à un **groupe de sécurité Global** ou à un **utilisateur**, jamais à une OU
> - **Priorité (Precedence)** : le chiffre le plus **bas** gagne en cas de conflit
> - Nécessite un niveau fonctionnel de domaine **Windows Server 2008** minimum

---

# PARTIE 8 : GPO (STRATÉGIES DE GROUPE)

---

## Exercice 8.0a - GPO — Bloquer le Panneau de configuration

**SCÉNARIO :** La Direction souhaite empêcher les utilisateurs standard d'accéder au Panneau de configuration sur les postes clients. **Consigne :** Crée une GPO **GPO_Bloquer_PanneauConfig** liée à l'OU **Utilisateurs**. Configure-la pour interdire l'accès au Panneau de configuration et aux Paramètres PC. Ajoute Domain Computers en Read (MS16-072).

> [!tip]- Réponse
> 
> ### 🖱️ Solution graphique (GUI)
> 
> **Étape 1 :** Ouvrir **gpmc.msc**
> 
> **Étape 2 :** Créer la GPO
> 
> - Objets de stratégie de groupe → Clic droit → **Nouveau** → Nom : **GPO_Bloquer_PanneauConfig** → OK
> 
> **Étape 3 :** Lier à l'OU Utilisateurs
> 
> - Clic droit sur **Utilisateurs** → **Lier un objet de stratégie de groupe existant** → GPO_Bloquer_PanneauConfig → OK
> 
> **Étape 4 :** Configurer la GPO
> 
> - Clic droit sur la GPO → **Modifier** _(Edit)_
> - **Configuration utilisateur** _(User Configuration)_ → **Stratégies** _(Policies)_ → **Modèles d'administration** _(Administrative Templates)_ → **Panneau de configuration** _(Control Panel)_
> - Double-cliquer sur **"Interdire l'accès au Panneau de configuration et aux paramètres du PC"** _(Prohibit access to Control Panel and PC settings)_
> - Cocher **Activé** _(Enabled)_ → **OK**
> 
> **Étape 5 :** Ajouter Domain Computers en Read (MS16-072)
> 
> - Cliquer sur la GPO → Onglet **Délégation** _(Delegation)_ → **Avancé...** _(Advanced)_
> - **Ajouter** → **Domain Computers** → OK → cocher ✅ **Lecture** _(Read)_ uniquement → **OK**

---

## Exercice 8.0b - GPO — Bloquer l'invite de commandes (CMD)

**SCÉNARIO :** Pour des raisons de sécurité, l'accès à CMD doit être bloqué pour les utilisateurs standard. **Consigne :** Crée une GPO **GPO_Bloquer_CMD** liée à l'OU **Utilisateurs**. Configure-la pour empêcher l'accès à l'invite de commandes. Ajoute Domain Computers en Read (MS16-072).

> [!tip]- Réponse
> 
> ### 🖱️ Solution graphique (GUI)
> 
> **Étape 1 :** Ouvrir **gpmc.msc** → Créer GPO **GPO_Bloquer_CMD** → Lier à l'OU **Utilisateurs**
> 
> **Étape 2 :** Modifier la GPO
> 
> - **Configuration utilisateur** → **Stratégies** → **Modèles d'administration** → **Système** _(System)_
> - Double-cliquer sur **"Empêcher l'accès à l'invite de commandes"** _(Prevent access to the command prompt)_
> - Cocher **Activé** _(Enabled)_
> - Option **"Désactiver également le traitement des scripts ?"** → **Non** (sinon les scripts de connexion GPO ne fonctionnent plus !)
> - **OK**
> 
> **Étape 3 :** Ajouter Domain Computers en Read (MS16-072)
> 
> - Délégation → Avancé → Ajouter → **Domain Computers** → Lecture → OK
> 
> ⚠️ **PIÈGE :** Si tu mets "Oui" pour désactiver les scripts, les scripts de connexion (logon scripts) et les mappages de lecteurs par GPO ne fonctionneront plus !

---

## Exercice 8.1 - Créer une GPO de fond d'écran avec filtrage de sécurité

## **SCÉNARIO :** La direction souhaite que les utilisateurs de l'OU Comptabilité aient un fond d'écran spécifique. La GPO doit avoir un **filtrage de sécurité par groupe**.

### 8.1a — Préparer le wallpaper

**Consigne :** Vérifie que le dossier `\\SRVWIN01\Wallpapers` contient une image **compta.jpg** (créé dans la Partie 6).

> [!tip]- Réponse
> 
> - Ouvrir l'Explorateur → `\\SRVWIN01\Wallpapers`
> - Vérifier que **compta.jpg** est présent
> - Si absent → copier une image .jpg dans C:\Wallpapers sur SRVWIN01
> - Vérifier les permissions NTFS : Utilisateurs du domaine → **Lecture**

---

### 8.1b — Créer la GPO avec filtrage de sécurité

**Consigne :** Crée une GPO **GPO_Compta_Wallpaper**, lie-la à l'OU **Comptabilite**, configure le fond d'écran et le filtrage de sécurité pour que seul **GRP_Comptabilite** reçoive la GPO.

> [!tip]- Réponse
> 
> **Étape 1 :** Ouvrir **gpmc.msc**
> 
> **Étape 2 :** Créer la GPO
> 
> - Forêt → Domaines → sweetcakes.lan → **Objets de stratégie de groupe** _(Group Policy Objects)_
> - Clic droit → **Nouveau** _(New)_ → Nom : **GPO_Compta_Wallpaper** → OK
> 
> **Étape 3 :** Lier la GPO à l'OU
> 
> - Clic droit sur **Comptabilite** → **Lier un objet de stratégie de groupe existant** _(Link an Existing GPO)_ → sélectionner GPO_Compta_Wallpaper → OK
> 
> **Étape 4 :** Configurer le fond d'écran
> 
> - Clic droit sur GPO_Compta_Wallpaper → **Modifier** _(Edit)_
> - Naviguer : **Configuration utilisateur** _(User Configuration)_ → **Stratégies** _(Policies)_ → **Modèles d'administration** _(Administrative Templates)_ → **Bureau** _(Desktop)_ → **Bureau** _(Desktop)_
> - Double-cliquer **"Papier peint du Bureau"** _(Desktop Wallpaper)_
> - Cocher **Activé** _(Enabled)_
> - Nom du papier peint : `\\SRVWIN01\Wallpapers\compta.jpg`
> - Style : **Étirer**
> - **OK**
> 
> **Étape 5 : 🔴 FILTRAGE DE SÉCURITÉ**
> 
> - Cliquer sur **GPO_Compta_Wallpaper** (dans les liens)
> - Onglet **"Étendue"** _(Scope)_ → section **"Filtrage de sécurité"** _(Security Filtering)_
> - Sélectionner **"Utilisateurs authentifiés"** _(Authenticated Users)_ → **"Supprimer"** _(Remove)_ → confirmer
> - **"Ajouter..."** _(Add)_ → taper **GRP_Comptabilite** → **Vérifier les noms** _(Check Names)_ → **OK**
> 
> **Étape 5bis : Délégation — droits de lecture GPO (PIÈGE !)**
> 
> - Onglet **"Délégation"** _(Delegation)_ → **"Avancé..."** _(Advanced)_
> - **Ajouter** → **GRP_Comptabilite** → OK → cocher ✅ **Lecture** _(Read)_ + ✅ **Appliquer la stratégie de groupe** _(Apply Group Policy)_ → **OK**
> 
> **Étape 5ter : Ajouter Domain Computers en lecture (PIÈGE MS16-072 !)**
> 
> - Toujours dans **"Avancé..."** → **Ajouter** → **Domain Computers** → OK
> - Cocher : ✅ **Lecture** _(Read)_ (Allow) uniquement → **OK**
> - → Depuis le patch MS16-072, c'est le **compte machine** qui lit la GPO. Sans Domain Computers en Read, la GPO ne s'applique pas !

---

### 8.1c — Tester la GPO

**Consigne :** Sur CLIENT01, connecte-toi avec un utilisateur du service Comptabilité et vérifie que le fond d'écran s'applique.

> [!tip]- Réponse
> 
> - Ouvrir cmd : `gpupdate /force`
> - Déconnexion/reconnexion
> - Le fond d'écran doit changer
> - Vérifier : `gpresult /r` → la GPO doit apparaître

---

## Exercice 8.2 - Configurer une restriction horaire de connexion

**SCÉNARIO :** L'utilisateur Sophie BERNARD ne doit pouvoir se connecter que du lundi au vendredi, de 7h à 17h. **Consigne :**

1. Ouvrir les propriétés du compte Sophie BERNARD dans Active Directory
2. Configurer les **horaires d'accès** pour n'autoriser que **lundi-vendredi, 7h-17h**
3. Tout le reste doit être **refusé**

> [!tip]- Réponse
> 
> **⚠️ Note :** Les restrictions horaires se configurent sur le **compte utilisateur**, pas via GPO.
> 
> ### 🖱️ Solution graphique (GUI)
> 
> - Ouvrir **dsa.msc** → Utilisateurs → Production → Double-cliquer **Sophie BERNARD**
> - Onglet **"Compte"** → **"Horaires d'accès..."**
> - Cliquer **"Tout refuser"** (tout devient bleu = refusé)
> - Sélectionner **Lundi à Vendredi, 7h à 17h** (cliquer-glisser)
> - Cliquer **"Connexion autorisée"** (la zone devient blanche)
> - **OK**
> 
> ---
> 
> ### ⌨️ Solution PowerShell (bonus)
> 
> ```powershell
> # Créer un tableau de 168 bytes (24h x 7 jours) — tout à 0 = tout refusé
> [byte[]]$hours = @(0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0)
> 
> # Autoriser Lundi-Vendredi 7h-17h
> # Chaque jour = 3 bytes (8h par byte), Dimanche = bytes 0-2, Lundi = bytes 3-5...
> $hours[3] = 0x80; $hours[4] = 0xFF; $hours[5] = 0x01   # Lundi
> $hours[6] = 0x80; $hours[7] = 0xFF; $hours[8] = 0x01   # Mardi
> $hours[9] = 0x80; $hours[10] = 0xFF; $hours[11] = 0x01  # Mercredi
> $hours[12] = 0x80; $hours[13] = 0xFF; $hours[14] = 0x01 # Jeudi
> $hours[15] = 0x80; $hours[16] = 0xFF; $hours[17] = 0x01 # Vendredi
> 
> Set-ADUser -Identity "s.bernard" -Replace @{logonHours = $hours}
> 
> # Vérifier
> Get-ADUser -Identity "s.bernard" -Properties logonHours
> ```
> 
> ⚠️ Le calcul des bytes LogonHours est complexe — en examen, la GUI est beaucoup plus rapide et fiable.

---

## Exercice 8.3 - Créer une GPO de mappage de lecteur réseau

## **SCÉNARIO :** Tous les utilisateurs doivent avoir un lecteur **S:** mappé vers \\SRVWIN01\Partage (créé dans la Partie 6).

### 8.3a — Vérifier le partage

**Consigne :** Vérifie que le partage `\\SRVWIN01\Partage` est accessible (créé dans la Partie 6). Permissions Share : Everyone → Full Control. Permissions NTFS : Utilisateurs du domaine → Modification.

> [!tip]- Réponse
> 
> - Ouvrir l'Explorateur → `\\SRVWIN01\Partage` → doit être accessible
> - Si erreur → vérifier les permissions dans la Partie 6
> - ⚠️ Best practice : permissions **larges sur le partage**, filtrage **fin en NTFS**

---

### 8.3b — Créer la GPO et configurer le mappage de lecteur

**Consigne :** Crée une GPO **GPO_Lecteur_Partage**, lie-la à l'OU **Utilisateurs**, configure un mappage de lecteur **S:** vers `\\SRVWIN01\Partage`, et ajoute Domain Computers en Read.

> [!tip]- Réponse
> 
> - Ouvrir **gpmc.msc** → Créer GPO **"GPO_Lecteur_Partage"**
> - Lier à l'OU **Utilisateurs**
> - Modifier _(Edit)_ → **Configuration utilisateur** _(User Configuration)_ → **Préférences** _(Preferences)_ → **Paramètres Windows** _(Windows Settings)_ → **Mappages de lecteurs** _(Drive Maps)_
> - Clic droit → **Nouveau** _(New)_ → **Lecteur mappé** _(Mapped Drive)_
>     - Action : **Créer** _(Create)_
>     - Emplacement _(Location)_ : `\\SRVWIN01\Partage`
>     - Reconnecter _(Reconnect)_ : ✅
>     - Lettre _(Drive Letter)_ : **S:**
> - **OK**
> 
> **⚠️ Domain Computers en Read (MS16-072) :**
> 
> - On garde **Authenticated Users** dans le filtrage de sécurité car la GPO cible tous les utilisateurs
> - Cliquer sur la GPO → Onglet **Délégation** → **Avancé...**
> - **Ajouter** → **Domain Computers** → OK → cocher ✅ **Lecture** (Allow) uniquement → **OK**

---

### 8.3c — Tester

**Consigne :** Sur CLIENT01, force la mise à jour des GPO et vérifie que le lecteur S: apparaît.

> [!tip]- Réponse
> 
> - `gpupdate /force` + déconnexion/reconnexion
> - Le lecteur **S:** doit apparaître dans l'Explorateur
> - Vérifier : `net use` → doit afficher `S: \\SRVWIN01\Partage`

---

## Exercice 8.4 - Mettre en place l'AGDLP sur un partage

## **SCÉNARIO :** Le dossier `\\SRVWIN01\Projets` (créé dans la Partie 6) doit être accessible en **Modification** par le service Comptabilité et en **Lecture seule** par le service Production. Tu dois appliquer la méthode **AGDLP**.

### 8.4a — Configurer les permissions NTFS avec AGDLP

**Consigne :** Les groupes Domain Local (DL_Projets_RW et DL_Projets_RO) ont déjà été créés et imbriqués dans la Partie 4 (exercice 4.5). Configure maintenant les permissions NTFS sur C:\Projets : **DL_Projets_RW → Modification**, **DL_Projets_RO → Lecture et exécution**. Supprime le groupe "Utilisateurs" si présent.

> [!tip]- Réponse
> 
> ### 🖱️ Solution graphique (GUI)
> 
> - Clic droit sur C:\Projets → Propriétés → Onglet **Sécurité** _(Security)_ → **Modifier** _(Edit)_ → **Ajouter** _(Add)_
> - Ajouter **DL_Projets_RW** → cocher **Modification** _(Modify)_ → OK
> - Ajouter **DL_Projets_RO** → cocher **Lecture et exécution** _(Read & Execute)_ → OK
> - ⚠️ Supprimer **Utilisateurs** _(Users)_ des permissions NTFS si présent
> 
> ### ⌨️ Solution PowerShell (bonus)
> 
> ```powershell
> $acl = Get-Acl "C:\Projets"
> $acl.AddAccessRule((New-Object System.Security.AccessControl.FileSystemAccessRule("DL_Projets_RW","Modify","ContainerInherit,ObjectInherit","None","Allow")))
> $acl.AddAccessRule((New-Object System.Security.AccessControl.FileSystemAccessRule("DL_Projets_RO","ReadAndExecute","ContainerInherit,ObjectInherit","None","Allow")))
> Set-Acl "C:\Projets" $acl
> ```

---

### 8.4b — Tester l'accès

**Consigne :** Sur CLIENT01, teste que **p.durand** (Comptabilité) peut créer/modifier des fichiers, et que **s.bernard** (Production) ne peut que lire.

> [!tip]- Réponse
> 
> - Se connecter avec **p.durand** → `\\SRVWIN01\Projets` → doit pouvoir créer/modifier des fichiers ✅
> - Se connecter avec **s.bernard** → `\\SRVWIN01\Projets` → doit pouvoir lire mais PAS modifier ✅
> 
> **Schéma AGDLP :**
> 
> ```
> m.dupont (Account) → GRP_Direction (Global)
> l.moreau (Account) → GRP_Comptabilite (Global) → DL_Projets_RW (Domain Local) → Modify sur C:\Projets
> s.bernard (Account) → GRP_Production (Global) → DL_Projets_RO (Domain Local) → Read sur C:\Projets
> ```
> 
> **⚠️ Pourquoi AGDLP ?**
> 
> - Permissions NTFS TOUJOURS sur groupes **Domain Local** (DL_)
> - Utilisateurs TOUJOURS dans groupes **Globaux** (GRP_)
> - Globaux imbriqués dans Domain Local
> - Avantage : nouveau service → ajouter son GRP_ dans le DL_ sans toucher aux permissions

---

# PARTIE 9 : ADMINISTRATION WINDOWS — SSH + SCP

---

## Exercice 9.1 - Configurer OpenSSH Server sur SRVWIN01

**SCÉNARIO :** Tu dois pouvoir administrer SRVWIN01 à distance en SSH depuis les postes clients Windows. **Consigne :** Installe et configure le serveur OpenSSH sur SRVWIN01. Vérifie que le service fonctionne et que la connexion SSH est possible depuis CLIENT01.

> [!tip]- Réponse
> 
> **Étape 1 :** Vérifier si OpenSSH est disponible
> 
> ### 🖱️ GUI
> 
> - Ouvrir **Paramètres** _(Settings)_ → **Applications** → **Fonctionnalités facultatives** _(Optional Features)_
> - Cliquer **Afficher les fonctionnalités** _(View features)_ ou faire défiler la liste
> - Chercher **OpenSSH** → tu dois voir **OpenSSH Client** (installé) et **OpenSSH Server** (à installer)
> 
> ### ⌨️ PowerShell
> 
> ```powershell
> Get-WindowsCapability -Online | Where-Object Name -like "OpenSSH*"
> ```
> 
> - Tu dois voir **OpenSSH.Client** (State: Installed) et **OpenSSH.Server** (State: NotPresent)
> 
> ---
> 
> **Étape 2 :** Installer le serveur OpenSSH
> 
> ### 🖱️ GUI
> 
> - Toujours dans **Fonctionnalités facultatives** → Cliquer **Ajouter une fonctionnalité** _(Add a feature)_
> - Chercher **OpenSSH Server** → Cocher → **Installer** _(Install)_
> - Attendre la fin de l'installation
> 
> ### ⌨️ PowerShell
> 
> ```powershell
> Add-WindowsCapability -Online -Name OpenSSH.Server~~~~0.0.1.0
> ```
> 
> ---
> 
> **Étape 3 :** Démarrer et activer le service
> 
> ### 🖱️ GUI
> 
> - Ouvrir **services.msc** (touche Windows + R → `services.msc` → Entrée)
> - Chercher **OpenSSH SSH Server** (sshd) dans la liste
> - Clic droit → **Propriétés** _(Properties)_
> - **Type de démarrage** _(Startup type)_ : changer en **Automatique** _(Automatic)_
> - Cliquer **Démarrer** _(Start)_ → **OK**
> 
> ### ⌨️ PowerShell
> 
> ```powershell
> Start-Service sshd
> Set-Service -Name sshd -StartupType 'Automatic'
> ```
> 
> ---
> 
> **Étape 4 :** Vérifier le pare-feu (règle normalement créée automatiquement)
> 
> ### 🖱️ GUI
> 
> - Ouvrir **wf.msc** (Pare-feu Windows Defender avec sécurité avancée)
> - Cliquer **Règles de trafic entrant** _(Inbound Rules)_
> - Chercher une règle **OpenSSH Server (sshd)** → Port **22** → doit être **Activée** _(Enabled)_
> - Si absente → Clic droit → **Nouvelle règle** _(New Rule)_ → **Port** → TCP → **22** → Autoriser → Nom : **OpenSSH Server (sshd)** → Terminer
> 
> ### ⌨️ PowerShell
> 
> ```powershell
> Get-NetFirewallRule -Name *ssh*
> ```
> 
> - Si la règle n'existe pas :
> 
> ```powershell
> New-NetFirewallRule -Name sshd -DisplayName 'OpenSSH Server (sshd)' -Enabled True -Direction Inbound -Protocol TCP -Action Allow -LocalPort 22
> ```
> 
> ---
> 
> **Étape 5 :** Tester depuis CLIENT01
> 
> ```powershell
> ssh Administrateur@172.16.10.10
> ```
> 
> - Mot de passe : **Azerty1***
> - Tu dois obtenir une invite de commande PowerShell sur SRVWIN01
> 
> ---
> 
> **📌 Fichiers de config OpenSSH Windows :**
> 
> |Fichier|Chemin|
> |---|---|
> |Config serveur|`C:\ProgramData\ssh\sshd_config`|
> |Clés autorisées (admin)|`C:\ProgramData\ssh\administrators_authorized_keys`|
> |Clés autorisées (utilisateur)|`C:\Users\<user>\.ssh\authorized_keys`|
> |Log SSH|`C:\ProgramData\ssh\logs\sshd.log`|
> 
> ⚠️ **PIÈGE Windows :** Pour les comptes **administrateurs**, les clés publiques doivent aller dans `C:\ProgramData\ssh\administrators_authorized_keys` (PAS dans ~/.ssh/authorized_keys !)

---

## Exercice 9.2 - Envoyer une clé publique en SCP vers SRVWIN01

**SCÉNARIO :** Tu veux pouvoir te connecter en SSH à SRVWIN01 **sans mot de passe** (par clé). Tu dois copier ta clé publique depuis CLIENT01 vers le fichier `administrators_authorized_keys` sur SRVWIN01. **Consigne :** Depuis CLIENT01, génère une paire de clés SSH (si pas déjà fait) puis copie la clé publique sur SRVWIN01 avec SCP. Configure les permissions du fichier `administrators_authorized_keys`.

> [!tip]- Réponse
> 
> ### ⌨️ Solution depuis CLIENT01 (PowerShell)
> 
> **Étape 1 :** Générer une clé SSH (si pas déjà fait)
> 
> ```powershell
> ssh-keygen -t ed25519
> ```
> 
> - Entrée pour chemin par défaut → Passphrase optionnel
> 
> **Étape 2 :** Copier la clé publique via SCP
> 
> ```powershell
> scp $env:USERPROFILE\.ssh\id_ed25519.pub Administrateur@172.16.10.10:C:\ProgramData\ssh\administrators_authorized_keys
> ```
> 
> - Entrer le mot de passe **Azerty1*** quand demandé
> 
> **Étape 3 :** Configurer les permissions du fichier (sur SRVWIN01)
> 
> - Se connecter en SSH à SRVWIN01 :
> 
> ```powershell
> ssh Administrateur@172.16.10.10
> ```
> 
> - Fixer les permissions (obligatoire pour les comptes admin) :
> 
> ```powershell
> icacls "C:\ProgramData\ssh\administrators_authorized_keys" /inheritance:r /grant "Administrators:F" /grant "SYSTEM:F"
> ```
> 
> **Étape 4 :** Tester la connexion par clé
> 
> - Fermer la session SSH → se reconnecter :
> 
> ```powershell
> ssh Administrateur@172.16.10.10
> ```
> 
> - → La connexion doit se faire **sans demander de mot de passe**
> 
> **⚠️ PIÈGES courants :**
> 
> - Si la connexion demande encore un mot de passe → vérifier les permissions avec `icacls`
> - Le fichier `administrators_authorized_keys` ne doit **PAS** être héritable
> - Si le fichier contient déjà des clés, **ajouter** la nouvelle à la suite (ne pas écraser)
> - Pour ajouter sans écraser : utiliser `>>` au lieu de `>` ou concaténer manuellement

---

# PARTIE 10 : SERVEUR LINUX (SRVLX01)

**⚠️ PRÉREQUIS VM :** Avant de démarrer SRVLX01, ajouter un **2ème disque dur** dans VirtualBox :

- VM éteinte → **Configuration** → **Stockage** → Contrôleur SATA → icône **"Ajouter un disque"**
- Créer un nouveau disque VDI de **10 Go** (dynamiquement alloué)
- Démarrer la VM

---

## Exercice 10.0 - Préparer le disque dur supplémentaire

**Consigne :** Le 2ème disque dur doit être préparé ainsi :

- 1 partition de **6 Go** en **ext4** nommée **DATA**
- 1 partition de **2 Go** en **ext4** nommée **PERSO**
- 1 partition avec le **reste** en **swap** (désactiver l'ancien swap s'il existe)

> [!tip]- Réponse
> 
> ### 🐧 Solution Linux
> 
> **Étape 1 :** Identifier le nouveau disque
> 
> ```bash
> lsblk
> ```
> 
> - Tu dois voir **sdb** (ou **sdc**) sans partition → c'est ton nouveau disque
> - `sda` = disque système (NE PAS TOUCHER)
> 
> **Étape 2 :** Partitionner avec fdisk
> 
> ```bash
> sudo fdisk /dev/sdb
> ```
> 
> **Créer la partition 1 (DATA - 6 Go) :**
> 
> ```
> Command: n          ← nouvelle partition
> Partition type: p   ← primaire
> Partition number: 1
> First sector: (Entrée pour défaut)
> Last sector: +6G
> ```
> 
> **Créer la partition 2 (PERSO - 2 Go) :**
> 
> ```
> Command: n
> Partition type: p
> Partition number: 2
> First sector: (Entrée)
> Last sector: +2G
> ```
> 
> **Créer la partition 3 (SWAP - reste du disque) :**
> 
> ```
> Command: n
> Partition type: p
> Partition number: 3
> First sector: (Entrée)
> Last sector: (Entrée)  ← prend tout le reste
> ```
> 
> **Changer le type de la partition 3 en swap :**
> 
> ```
> Command: t            ← changer le type
> Partition number: 3
> Hex code: 82          ← Linux swap
> ```
> 
> **Écrire et quitter :**
> 
> ```
> Command: w            ← écrire la table de partitions
> ```
> 
> **Étape 3 :** Vérifier les partitions
> 
> ```bash
> lsblk /dev/sdb
> ```
> 
> - Doit afficher : sdb1 (6G), sdb2 (2G), sdb3 (~2G)
> 
> **Étape 4 :** Formater les partitions
> 
> ```bash
> # Formater en ext4
> sudo mkfs.ext4 -L DATA /dev/sdb1
> sudo mkfs.ext4 -L PERSO /dev/sdb2
> 
> # Formater en swap
> sudo mkswap -L SWAP /dev/sdb3
> ```
> 
> → L'option `-L` donne un **nom (label)** à la partition
> 
> **Étape 5 :** Créer les points de montage
> 
> ```bash
> sudo mkdir -p /mnt/data
> sudo mkdir -p /mnt/perso
> ```
> 
> **Étape 6 :** Monter les partitions
> 
> ```bash
> sudo mount /dev/sdb1 /mnt/data
> sudo mount /dev/sdb2 /mnt/perso
> ```
> 
> **Étape 7 :** Gérer le swap
> 
> ```bash
> # Désactiver l'ancien swap (s'il existe)
> sudo swapoff -a
> 
> # Activer le nouveau swap
> sudo swapon /dev/sdb3
> 
> # Vérifier
> free -h
> ```
> 
> **Étape 8 :** Rendre le montage permanent (fstab)
> 
> ```bash
> # Récupérer les UUID
> sudo blkid /dev/sdb1 /dev/sdb2 /dev/sdb3
> ```
> 
> → Noter les UUID
> 
> ```bash
> sudo nano /etc/fstab
> ```
> 
> Ajouter ces lignes (remplacer les UUID) :
> 
> ```
> UUID=xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx  /mnt/data   ext4  defaults  0  2
> UUID=yyyyyyyy-yyyy-yyyy-yyyy-yyyyyyyyyyyy  /mnt/perso  ext4  defaults  0  2
> UUID=zzzzzzzz-zzzz-zzzz-zzzz-zzzzzzzzzzzz  none        swap  sw        0  0
> ```
> 
> **Étape 9 :** Vérifier tout
> 
> ```bash
> # Voir les montages
> df -h
> 
> # Voir le swap
> free -h
> 
> # Voir les partitions avec labels
> lsblk -f /dev/sdb
> ```
> 
> **📌 Commandes à connaître :**
> 
> |Commande|Rôle|
> |---|---|
> |`fdisk /dev/sdb`|Partitionner un disque|
> |`lsblk`|Lister les disques et partitions|
> |`blkid`|Afficher les UUID|
> |`mkfs.ext4 -L NOM /dev/sdb1`|Formater en ext4 avec label|
> |`mkswap /dev/sdb3`|Formater en swap|
> |`mount /dev/sdb1 /mnt/data`|Monter une partition|
> |`swapon / swapoff`|Activer/désactiver le swap|
> |`/etc/fstab`|Montage permanent au boot|
> |`df -h`|Voir l'espace disque monté|
> |`free -h`|Voir la RAM et le swap|

---

**⚠️ PRÉREQUIS SUPPLÉMENTAIRE :** Avant de continuer, ajouter **2 disques supplémentaires** de 10 Go chacun (sdc et sdd) dans VirtualBox :

- VM éteinte → **Configuration** → **Stockage** → Contrôleur SATA → icône disque dur (+) → Créer → **10 Go** → répéter pour le 2ème
- Démarrer la VM → `lsblk` → vérifier que **sdc** et **sdd** apparaissent

---

## Exercice 10.0b — Créer une architecture LVM

**SCÉNARIO :** L'entreprise a besoin d'espace de stockage flexible pour les projets. Tu dois créer un volume logique LVM sur le nouveau disque **sdc**. **Consigne :**

1. Créer une partition de type LVM sur **tout le disque sdc**
2. Initialiser le PV, créer le VG `vg-data`, créer un LV `lv-projets` de **6 Go**
3. Formater en **ext4** et monter sur `/srv/projets`
4. Rendre le montage **permanent** (fstab)
5. Vérifier avec `pvs`, `vgs`, `lvs` et `df -hT`

> [!tip]- Réponse
> 
> ```bash
> # === Partitionner sdc en type LVM ===
> sudo fdisk /dev/sdc
> # n → p → 1 → Entrée → Entrée (tout le disque)
> # t → 8e (Linux LVM)
> # w
> 
> # === Créer PV → VG → LV ===
> sudo pvcreate /dev/sdc1
> sudo vgcreate vg-data /dev/sdc1
> sudo lvcreate -L 6G -n lv-projets vg-data
> 
> # === Formater et monter ===
> sudo mkfs.ext4 /dev/vg-data/lv-projets
> sudo mkdir -p /srv/projets
> sudo mount /dev/vg-data/lv-projets /srv/projets
> 
> # === Montage permanent ===
> sudo nano /etc/fstab
> # /dev/vg-data/lv-projets  /srv/projets  ext4  defaults  0  2
> 
> # === Vérifier ===
> sudo pvs && sudo vgs && sudo lvs
> df -hT /srv/projets
> lsblk
> ```
> 
> ⚠️ Partition type **8e** dans fdisk = Linux LVM Architecture : **PV → VG → LV → FS** (toujours dans cet ordre)

---

## Exercice 10.0c — Agrandir un volume LVM à chaud

**SCÉNARIO :** L'espace projets est plein. Le disque **sdd** vient d'être ajouté. Agrandir `lv-projets` de **4 Go** sans interrompre le service. **Consigne :**

1. Partitionner **sdd** en type LVM
2. Ajouter sdd au VG `vg-data` existant
3. Agrandir le LV `lv-projets` de 4 Go
4. Redimensionner le système de fichiers **à chaud**
5. Vérifier que `lv-projets` fait maintenant **10 Go**

> [!tip]- Réponse
> 
> ```bash
> # === Partitionner sdd en type LVM ===
> sudo fdisk /dev/sdd
> # n → p → 1 → Entrée → Entrée → t → 8e → w
> 
> # === Ajouter sdd au VG existant ===
> sudo pvcreate /dev/sdd1
> sudo vgextend vg-data /dev/sdd1
> sudo vgs   # → l'espace libre a augmenté
> 
> # === Agrandir le LV de 4G ===
> sudo lvextend -L +4G /dev/vg-data/lv-projets
> 
> # === Redimensionner le FS à chaud ===
> sudo resize2fs /dev/vg-data/lv-projets
> 
> # === Vérifier ===
> sudo pvs && sudo vgs && sudo lvs
> df -hT /srv/projets
> # → lv-projets fait maintenant 10G
> ```
> 
> ⚠️ `resize2fs` APRÈS `lvextend` sinon le FS ne voit pas la nouvelle taille ! ext4 supporte le redimensionnement **à chaud** (pas besoin de démonter)

---

## Exercice 10.0d — Transformer le LVM en RAID 1

**SCÉNARIO :** On n'a plus besoin du LVM. On va réutiliser **sdc** et **sdd** pour créer un **RAID 1** (miroir) pour les sauvegardes. **Étape 1 — Consigne :** Démonter et détruire complètement l'architecture LVM sur sdc et sdd. Les disques doivent être propres (aucune partition).

> [!tip]- Réponse Étape 1
> 
> ```bash
> # Démonter
> sudo umount /srv/projets
> 
> # Supprimer la ligne LVM dans fstab
> sudo nano /etc/fstab
> # → Supprimer la ligne /dev/vg-data/lv-projets
> 
> # Détruire dans l'ordre inverse : LV → VG → PV
> sudo lvremove /dev/vg-data/lv-projets   # → y
> sudo vgremove vg-data
> sudo pvremove /dev/sdc1
> sudo pvremove /dev/sdd1
> 
> # Nettoyer les tables de partitions
> sudo wipefs -a /dev/sdc
> sudo wipefs -a /dev/sdd
> 
> # Vérifier
> lsblk
> sudo pvs && sudo vgs && sudo lvs
> # → tout vide, sdc et sdd propres
> ```

**Étape 2 — Consigne :** Créer une grappe **RAID 1** avec mdadm sur **sdc** et **sdd**. Formater en ext4, monter sur `/srv/backups`. Sauvegarder la config RAID et rendre le montage permanent.

> [!tip]- Réponse Étape 2
> 
> ```bash
> # === Partitionner sdc en type RAID ===
> sudo fdisk /dev/sdc
> # n → p → 1 → Entrée → Entrée (tout le disque)
> # t → fd (Linux raid autodetect)
> # w
> 
> # === Partitionner sdd en type RAID ===
> sudo fdisk /dev/sdd
> # n → p → 1 → Entrée → Entrée → t → fd → w
> 
> # === Créer la grappe RAID 1 ===
> sudo mdadm --create /dev/md0 --level=1 --raid-devices=2 /dev/sdc1 /dev/sdd1
> # → y si demandé
> 
> # === Vérifier la construction ===
> cat /proc/mdstat
> sudo mdadm --detail /dev/md0
> 
> # === Formater et monter ===
> sudo mkfs.ext4 /dev/md0
> sudo mkdir -p /srv/backups
> sudo mount /dev/md0 /srv/backups
> 
> # === Sauvegarder la config RAID ===
> sudo mdadm --detail --scan | sudo tee -a /etc/mdadm/mdadm.conf
> sudo update-initramfs -u
> 
> # === Montage permanent ===
> sudo nano /etc/fstab
> # /dev/md0  /srv/backups  ext4  defaults  0  2
> 
> # === Vérifier ===
> df -hT /srv/backups
> cat /proc/mdstat
> lsblk
> ```
> 
> ⚠️ Partition type **fd** dans fdisk = Linux raid autodetect RAID 1 = **miroir** : capacité = 1 seul disque, tolère 1 panne

---

## Exercice 10.0e — Tout démonter et nettoyer

**Consigne :** Les exercices de stockage sont terminés. Démonte et nettoie tout proprement : le RAID (sdc+sdd) ET les partitions du 10.0 (sdb). Supprime toutes les entrées dans fstab.

> [!tip]- Réponse
> 
> ```bash
> # === 1. Démonter le RAID ===
> sudo umount /srv/backups
> sudo mdadm --stop /dev/md0
> sudo mdadm --zero-superblock /dev/sdc1
> sudo mdadm --zero-superblock /dev/sdd1
> 
> # Nettoyer mdadm.conf (supprimer la ligne ARRAY md0)
> sudo nano /etc/mdadm/mdadm.conf
> sudo update-initramfs -u
> 
> # === 2. Démonter les partitions sdb (exercice 10.0) ===
> sudo umount /mnt/data
> sudo umount /mnt/perso
> sudo swapoff /dev/sdb3
> 
> # === 3. Nettoyer fstab ===
> sudo nano /etc/fstab
> # → Supprimer TOUTES les lignes sdb + md0
> 
> # === 4. Effacer les disques ===
> sudo wipefs -a /dev/sdb
> sudo wipefs -a /dev/sdc
> sudo wipefs -a /dev/sdd
> 
> # === 5. Vérifier ===
> lsblk
> cat /proc/mdstat
> # → tout propre, aucune partition
> ```

---

**📋 Récap progression stockage :**

```
sdb → Partitionnement classique (10.0) → monté
sdc → LVM : PV → VG → LV (10.0b) → monté
sdd → Agrandir VG + LV (10.0c) → monté
Nettoyer LVM sdc+sdd (10.0d étape 1)
sdc + sdd → RAID 1 mdadm (10.0d étape 2) → monté
Tout démonter + nettoyer (10.0e)
```

**📋 Commandes clés par niveau :**

|Niveau|Créer|Vérifier|Supprimer|
|---|---|---|---|
|**Partitions**|`fdisk`|`lsblk`, `blkid`|`wipefs -a`|
|**LVM - PV**|`pvcreate`|`pvs`|`pvremove`|
|**LVM - VG**|`vgcreate` / `vgextend`|`vgs`|`vgremove`|
|**LVM - LV**|`lvcreate` / `lvextend`|`lvs`|`lvremove`|
|**LVM - FS**|`mkfs.ext4` / `resize2fs`|`df -hT`|—|
|**RAID**|`mdadm --create`|`cat /proc/mdstat`, `mdadm --detail`|`mdadm --stop`, `--zero-superblock`|
|**Montage**|`mount` + `fstab`|`df -hT`, `lsblk`|`umount`|
|Type fdisk|Code|Usage||
|---|---|---||
|Linux|83|Partition standard||
|Linux swap|82|Swap||
|Linux LVM|**8e**|Volume LVM||
|Linux raid autodetect|**fd**|Volume RAID||

---

## Exercice 10.1 - Configuration réseau Linux

**Consigne :** Configure l'adresse IP statique de SRVLX01 selon le plan d'adressage (172.16.10.20/24, passerelle 172.16.10.10, DNS 172.16.10.10). Vérifie la connectivité avec le serveur Windows.

> [!tip]- Réponse
> 
> ```bash
> # Identifier l'interface
> ip link show
> 
> # Éditer la config
> sudo nano /etc/network/interfaces
> ```
> 
> ```
> auto lo
> iface lo inet loopback
> 
> auto enp0s3
> iface enp0s3 inet static
>     address 172.16.10.20
>     netmask 255.255.255.0
>     gateway 172.16.10.10
>     dns-nameservers 172.16.10.10
> ```
> 
> ```bash
> sudo systemctl restart networking
> ip addr show enp0s3
> ip route
> ping -c 4 172.16.10.10
> ```

---

## Exercice 10.2 - Créer un utilisateur Linux avec droits sudo

**SCÉNARIO :** Tu viens de prendre en charge le serveur Linux. Tu dois créer ton propre compte d'administration. **Consigne :**

1. Créer un utilisateur **technicien** avec un répertoire personnel et le shell `/bin/bash`
2. Lui attribuer un mot de passe
3. L'ajouter au groupe **sudo** pour qu'il puisse exécuter des commandes en tant que root
4. Vérifier que l'utilisateur est bien dans le groupe sudo
5. Tester l'élévation de privilèges avec `sudo whoami`

> [!tip]- Réponse
> 
> ```bash
> sudo useradd -m -s /bin/bash technicien
> sudo passwd technicien
> sudo usermod -aG sudo technicien
> groups technicien
> # Doit afficher : technicien : technicien sudo
> su - technicien
> sudo whoami
> # Doit afficher : root
> ```

---

## Exercice 10.3 - Sécuriser SSH

## **SCÉNARIO :** L'accès SSH au serveur doit être sécurisé. Tu vas procéder étape par étape.

### 10.3a — Générer une paire de clés SSH sur le client

**Consigne :** Sur le poste client (Windows ou Linux), génère une paire de clés SSH de type **ed25519**.

> [!tip]- Réponse
> 
> **Depuis un client Windows (PowerShell) :**
> 
> ```powershell
> ssh-keygen -t ed25519
> ```
> 
> - Entrée pour chemin par défaut → Passphrase optionnel
> - Fichiers créés : `id_ed25519` (privée) + `id_ed25519.pub` (publique)
> 
> **Depuis un client Linux :**
> 
> ```bash
> ssh-keygen -t ed25519
> ```

---

### 10.3b — Copier la clé publique sur le serveur

**Consigne :** Copie ta clé publique dans le fichier `~/.ssh/authorized_keys` de l'utilisateur **technicien** sur SRVLX01 (172.16.10.20).

> [!tip]- Réponse
> 
> **Depuis Linux :**
> 
> ```bash
> ssh-copy-id -p 22 technicien@172.16.10.20
> ```
> 
> **Depuis Windows (méthode SCP) :**
> 
> ```powershell
> # Copier la clé publique vers le home de technicien
> scp $env:USERPROFILE\.ssh\id_ed25519.pub technicien@172.16.10.20:/home/technicien/
> 
> # Se connecter en SSH pour placer la clé
> ssh technicien@172.16.10.20
> ```
> 
> ```bash
> # Sur le serveur Linux :
> mkdir -p ~/.ssh
> chmod 700 ~/.ssh
> cat ~/id_ed25519.pub >> ~/.ssh/authorized_keys
> chmod 600 ~/.ssh/authorized_keys
> rm ~/id_ed25519.pub
> ```
> 
> **Depuis Windows (méthode manuelle) :**
> 
> ```powershell
> type $env:USERPROFILE\.ssh\id_ed25519.pub
> # Copier le contenu, puis se connecter au serveur :
> ssh technicien@172.16.10.20
> ```
> 
> ```bash
> # Sur le serveur :
> mkdir -p ~/.ssh
> chmod 700 ~/.ssh
> nano ~/.ssh/authorized_keys
> # Coller la clé publique
> chmod 600 ~/.ssh/authorized_keys
> ```

---

### 10.3c — Tester la connexion par clé

**Consigne :** Depuis le client, connecte-toi en SSH à technicien@172.16.10.20. La connexion doit se faire **sans demander de mot de passe**. Si ça demande un mot de passe → la clé n'est pas en place, ne passe PAS à la suite.

> [!tip]- Réponse
> 
> ```bash
> ssh technicien@172.16.10.20
> # → Si ça connecte sans mot de passe → c'est bon, passe à la suite
> # → Si ça demande un mot de passe → vérifie les permissions :
> #    chmod 700 ~/.ssh
> #    chmod 600 ~/.ssh/authorized_keys
> ```
> 
> **🔴 IMPORTANT : Teste OBLIGATOIREMENT la connexion par clé AVANT de désactiver le mot de passe ! Si tu désactives le mot de passe sans clé fonctionnelle → tu es verrouillé dehors !**

---

### 10.3d — Configurer sshd_config sur le serveur

**Consigne :** Modifie `/etc/ssh/sshd_config` sur SRVLX01 pour :

- Changer le port à **22504**
- **Interdire** la connexion root
- **Interdire** l'authentification par mot de passe
- **Autoriser** l'authentification par clé
- **Restreindre** l'accès au seul utilisateur `technicien` Puis redémarre le service SSH.

> [!tip]- Réponse
> 
> ```bash
> sudo nano /etc/ssh/sshd_config
> ```
> 
> Modifier (enlever le # si commentées) :
> 
> ```
> Port 22504
> PermitRootLogin no
> PasswordAuthentication no
> PubkeyAuthentication yes
> AllowUsers technicien
> ```
> 
> ```bash
> sudo systemctl restart sshd
> sudo ss -tlnp | grep ssh
> # Doit afficher : LISTEN *:22504
> ```

---

### 10.3e — Tester la sécurisation

**Consigne :** Depuis le client, vérifie que :

1. La connexion par clé sur le port 22504 **fonctionne**
2. La connexion en root est **refusée**
3. La connexion par mot de passe est **refusée**

> [!tip]- Réponse
> 
> ```bash
> # 1. Connexion par clé (ne demande PAS de mot de passe)
> ssh -p 22504 technicien@172.16.10.20
> # → Doit se connecter directement, sans demander de mot de passe
> 
> # 2. Tester que root est refusé
> ssh -p 22504 root@172.16.10.20
> # → Permission denied
> 
> # 3. Tester que le mot de passe ne fonctionne plus
> ssh -p 22504 -o PubkeyAuthentication=no technicien@172.16.10.20
> # → Permission denied (publickey)
> ```
> 
> |Paramètre sshd_config|Valeur|Effet|
> |---|---|---|
> |`Port`|22504|Change le port d'écoute|
> |`PermitRootLogin`|no|Interdit root en SSH|
> |`PasswordAuthentication`|no|Interdit les mots de passe|
> |`PubkeyAuthentication`|yes|Autorise les clés SSH|
> |`AllowUsers`|technicien|Restreint l'accès SSH à cet utilisateur uniquement|

---

## Exercice 10.4 - Gestion des droits sur un fichier

**SCÉNARIO :** Le webmaster de l'entreprise a besoin d'un espace de travail sécurisé. **Consigne :**

1. Créer un utilisateur **webmaster** avec un répertoire personnel et le shell `/bin/bash`
2. Créer le dossier `/home/partage`
3. Créer le fichier `/home/partage/Lisez-moi`
4. Configurer les droits pour que **seul webmaster et son groupe** puissent lire et écrire ce fichier (aucun droit pour les autres)
5. Vérifier les droits avec `ls -l` — résultat attendu : **-rw-rw----**

> [!tip]- Réponse
> 
> ```bash
> sudo useradd -m -s /bin/bash webmaster
> sudo passwd webmaster
> sudo mkdir -p /home/partage
> sudo touch /home/partage/Lisez-moi
> sudo chown webmaster:webmaster /home/partage/Lisez-moi
> sudo chmod 660 /home/partage/Lisez-moi
> ls -l /home/partage/Lisez-moi
> # -rw-rw---- 1 webmaster webmaster ... Lisez-moi
> ```

---

## Exercice 10.4b - Ajouter un 2ème utilisateur

**Consigne :** Crée un utilisateur **stagiaire** avec un répertoire personnel et le shell `/bin/bash`. Attribue-lui un mot de passe. Vérifie sa création.

> [!tip]- Réponse
> 
> ```bash
> sudo adduser stagiaire
> # → adduser est interactif : il demande le mot de passe + infos (optionnelles, Entrée pour passer)
> 
> # Vérifier
> id stagiaire
> # Doit afficher : uid=xxxx(stagiaire) gid=xxxx(stagiaire) groups=xxxx(stagiaire)
> ls /home/stagiaire
> # Le répertoire personnel doit exister
> ```
> 
> **📌 Différence useradd vs adduser (Debian) :**
> 
> |Commande|Comportement|
> |---|---|
> |`useradd -m -s /bin/bash`|Commande bas niveau, options obligatoires|
> |`adduser`|Script interactif Debian, crée tout automatiquement (home, shell, mot de passe)|

---

## Exercice 10.4c - Renommer un utilisateur

**Consigne :** L'utilisateur **stagiaire** change de poste et devient **assistant**. Renomme son login, son répertoire personnel et son groupe principal.

> [!tip]- Réponse
> 
> ```bash
> # ⚠️ L'utilisateur ne doit PAS être connecté pendant le renommage
> 
> # 1. Renommer le login
> sudo usermod -l assistant stagiaire
> 
> # 2. Renommer le répertoire personnel
> sudo usermod -d /home/assistant -m assistant
> 
> # 3. Renommer le groupe principal
> sudo groupmod -n assistant stagiaire
> 
> # Vérifier
> id assistant
> ls /home/assistant
> # Le login, home et groupe doivent tous afficher "assistant"
> ```
> 
> ⚠️ **PIÈGE :** `usermod -l` ne renomme PAS le répertoire home ni le groupe → il faut faire les 3 commandes !

---

## Exercice 10.4d - Créer un groupe et gérer les membres

**Consigne :**

1. Crée un groupe **equipe-web**
2. Ajoute les utilisateurs **webmaster** et **assistant** au groupe **equipe-web**
3. Vérifie les membres du groupe
4. Retire **assistant** du groupe
5. Vérifie à nouveau

> [!tip]- Réponse
> 
> ```bash
> # 1. Créer le groupe
> sudo groupadd equipe-web
> 
> # 2. Ajouter les utilisateurs au groupe
> sudo usermod -aG equipe-web webmaster
> sudo usermod -aG equipe-web assistant
> 
> # 3. Vérifier les membres
> getent group equipe-web
> # Doit afficher : equipe-web:x:xxxx:webmaster,assistant
> 
> # 4. Retirer assistant du groupe
> sudo gpasswd -d assistant equipe-web
> 
> # 5. Vérifier
> getent group equipe-web
> # Doit afficher : equipe-web:x:xxxx:webmaster
> ```
> 
> **📌 Commandes gestion utilisateurs/groupes Linux :**
> 
> |Action|Commande|
> |---|---|
> |Créer utilisateur|`adduser nom` ou `useradd -m -s /bin/bash nom`|
> |Supprimer utilisateur|`userdel -r nom` (avec -r = supprime le home)|
> |Renommer login|`usermod -l nouveau ancien`|
> |Changer home|`usermod -d /home/nouveau -m nom`|
> |Créer groupe|`groupadd nom`|
> |Renommer groupe|`groupmod -n nouveau ancien`|
> |Ajouter au groupe|`usermod -aG groupe nom`|
> |Retirer du groupe|`gpasswd -d nom groupe`|
> |Voir les groupes|`groups nom` ou `id nom`|
> |Lister membres|`getent group nomgroupe`|

---

## Exercice 10.5 - Remplacer un site web par un site temporaire

**SCÉNARIO :** Sur le home de root se trouvent deux fichiers :

- **LisezMoi** → infos sur les serveurs
- **En-Travaux.tar.gz** → archive contenant une image + un index.html temporaire

---

### 10.5a — Lire les informations et sauvegarder le site actuel

**Consigne :** Lis le fichier `/root/LisezMoi` puis sauvegarde le site actuel (`/var/www/html`) dans `/var/www/html_backup`.

> [!tip]- Réponse
> 
> ```bash
> sudo -i
> cat /root/LisezMoi
> cp -r /var/www/html /var/www/html_backup
> ```

---

### 10.5b — Extraire l'archive et copier le contenu

**Consigne :** Extrais l'archive `En-Travaux.tar.gz` et copie son contenu dans `/var/www/html/`.

> [!tip]- Réponse
> 
> ```bash
> cd /root
> tar -xzf En-Travaux.tar.gz
> ls -la En-Travaux/
> cp -r En-Travaux/* /var/www/html/
> ```
> 
> **📌 Commandes tar à connaître :**
> 
> |Commande|Action|
> |---|---|
> |`tar -xzf fichier.tar.gz`|Extraire archive gzip|
> |`tar -xjf fichier.tar.bz2`|Extraire archive bzip2|
> |`tar -czf archive.tar.gz dossier/`|Créer archive gzip|
> |`tar -tzf fichier.tar.gz`|Lister sans extraire|

---

### 10.5c — Corriger les permissions et tester

**Consigne :** Corrige les permissions (propriétaire `www-data`, droits 755 sur dossiers, 644 sur fichiers) et vérifie que le site temporaire s'affiche dans le navigateur.

> [!tip]- Réponse
> 
> ```bash
> chown -R www-data:www-data /var/www/html/
> find /var/www/html/ -type d -exec chmod 755 {} \;
> find /var/www/html/ -type f -exec chmod 644 {} \;
> systemctl status apache2
> ```
> 
> **Tester depuis CLIENT01 :** navigateur → http://172.16.10.20 → page "En travaux"

---

# PARTIE 11 : TÉLÉPHONIE IPBX

---

## Exercice 11.1 - Créer un compte utilisateur sur l'IPBX

**SCÉNARIO :** L'utilisateur Miguel Hernandez doit être joignable en téléphonie IP. **Consigne :** Accède à l'interface FreePBX (http://172.16.10.5), crée une extension SIP **80104** pour Miguel Hernandez et applique la configuration.

> [!tip]- Réponse
> 
> - Ouvrir un navigateur → **http://172.16.10.5** → se connecter avec les identifiants admin
> - Menu **Applications** → **Extensions** → **"Add Extension"** → choisir **SIP** (ou PJSIP)
> - **User Extension :** 80104
> - **Display Name :** Miguel Hernandez
> - **Secret (mot de passe SIP) :** P@ssw0rd80104
> - Cliquer **Submit**
> - **⚠️ IMPORTANT :** Cliquer sur **"Apply Config"** (bandeau rouge en haut)
> - Sans "Apply Config", les changements ne sont pas pris en compte !
> - Vérifier : l'extension 80104 doit apparaître dans la liste

---

## Exercice 11.2 - Configurer les softphones et tester un appel

## **SCÉNARIO :** Deux collaborateurs doivent pouvoir communiquer en téléphonie IP. Un softphone est installé sur chaque poste client Windows.

### 11.2a — Configurer les deux softphones

**Consigne :** Installe un softphone (MicroSIP ou Zoiper) sur CLIENT01 et CLIENT02. Configure CLIENT01 avec l'extension **80104** (Miguel) et CLIENT02 avec **80103** (Emma), serveur **172.16.10.5**. Vérifie que les deux affichent "Registered".

> [!tip]- Réponse
> 
> **Softphone 1 — Miguel Hernandez (CLIENT01) :**
> 
> **Pour MicroSIP :**
> 
> - Ouvrir MicroSIP → Menu → **Add Account**
> - **SIP Server :** 172.16.10.5
> - **SIP Proxy :** 172.16.10.5
> - **Username :** 80104
> - **Domain :** 172.16.10.5
> - **Password :** P@ssw0rd80104
> - Cliquer **Save**
> 
> **Pour Zoiper :**
> 
> - Settings → Accounts → Add account
> - **Username :** 80104 | **Password :** P@ssw0rd80104 | **Hostname :** 172.16.10.5
> 
> **Softphone 2 — Emma Chen (CLIENT02) :**
> 
> - Même procédure avec : **Username :** 80103 | **Password :** (secret d'Emma dans FreePBX)
> 
> Les deux softphones doivent afficher **"Registered"** ou **"Online"**

---

### 11.2b — Passer un appel test

**Consigne :** Vérifie que les deux softphones affichent **"Registered"**, puis passe un appel de **80104 → 80103**. Fais une copie d'écran de la communication.

> [!tip]- Réponse
> 
> - Les deux softphones doivent afficher **"Registered"** ou **"Online"**
> - Si "Registration failed" → vérifier IP, username, password
> - Sur le softphone de Miguel (80104 sur CLIENT01), composer **80103**
> - Décrocher sur le softphone d'Emma (80103 sur CLIENT02)
> - **Faire une copie d'écran montrant la communication en cours**
> 
> **⚠️ Dépannage courant :**
> 
> - Pas de son → vérifier les périphériques audio dans le softphone
> - Registration failed → vérifier que le serveur IPBX est joignable (`ping 172.16.10.5`)
> - Port SIP : **5060** (UDP) doit être ouvert

---

## Exercice 11.3 - Configurer un renvoi d'appel (Call Forward)

## **SCÉNARIO :** Miguel Hernandez (80104) part en réunion. Il veut que ses appels soient automatiquement renvoyés vers Emma Chen (80103).

### 11.3a — Configurer le renvoi dans FreePBX

**Consigne :** Configure un renvoi d'appel **inconditionnel** (Call Forward All) sur l'extension 80104 vers 80103. Applique la configuration.

> [!tip]- Réponse
> 
> **Méthode 1 — Via l'interface FreePBX (admin) :**
> 
> - Ouvrir **http://172.16.10.5** → se connecter admin
> - Menu **Applications** → **Extensions** → cliquer sur **80104** (Miguel Hernandez)
> - Section **"Call Forward"** (ou **"Find Me / Follow Me"** selon la version) :
>     - **Call Forward All :** cocher **Enabled**
>     - **Destination :** **80103**
> - Cliquer **Submit**
> - **⚠️ Cliquer "Apply Config"** (bandeau rouge)
> 
> **Méthode 2 — Via le téléphone/softphone (utilisateur) :**
> 
> - Sur le softphone de Miguel, composer : `*72 80103` (activer renvoi vers 80103)
> - Pour désactiver : composer `*73`
> 
> **📌 Codes étoile FreePBX (Feature Codes) :**
> 
> |Code|Action|
> |---|---|
> |`*72` + numéro|Activer le renvoi d'appel inconditionnel|
> |`*73`|Désactiver le renvoi d'appel|
> |`*90` + numéro|Activer le renvoi si occupé (Call Forward Busy)|
> |`*91`|Désactiver le renvoi si occupé|
> |`*52` + numéro|Activer le renvoi si pas de réponse (Call Forward No Answer)|
> |`*53`|Désactiver le renvoi si pas de réponse|

---

### 11.3b — Tester le renvoi d'appel

**Consigne :** Depuis CLIENT02 (Emma, 80103), appelle le **80104** (Miguel). L'appel doit être **automatiquement renvoyé** vers 80103 (Emma reçoit l'appel sur son propre poste). Teste aussi en appelant depuis un 3ème poste si disponible, sinon vérifie le comportement dans les logs FreePBX.

> [!tip]- Réponse
> 
> **Test :**
> 
> - Depuis CLIENT02 (80103) → appeler **80104**
> - Le softphone de Miguel (CLIENT01) ne doit **PAS sonner**
> - L'appel doit être renvoyé → le softphone d'Emma (CLIENT02) reçoit l'appel en retour
> - ⚠️ Ce test crée une boucle si Emma appelle Miguel et que le renvoi pointe vers Emma → pour un vrai test, utiliser un 3ème poste ou vérifier dans les logs
> 
> **Vérification via FreePBX :**
> 
> - Menu **Reports** → **CDR Reports** (Call Detail Records)
> - L'appel vers 80104 doit montrer une redirection vers 80103
> 
> **Après le test — Désactiver le renvoi :**
> 
> - FreePBX → Extensions → 80104 → **Call Forward All : Disabled** → Submit → Apply Config
> - Ou sur le softphone : composer **`*73`**