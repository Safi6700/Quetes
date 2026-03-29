# 1. Pare-feu

### a. Configuration

- Nom de la machine : FW01
- Type : pfsense
- Connexion :
	- Login : `admin`
	- Mdp : `pfsense`
- Réseau : 3 interfaces WAN, LAN, DMZ
	- WAN : @IP dans la plage réseau de la box Internet
		- Gateway : @IP interne de la box internet
	- LAN : x.x.x.254/24 <= Accès console Web
	- DMZ : y.y.y.254/24

## b. Règles

- Mise en place de règles de pare-feu WAN, LAN, DMZ (ex.: https://docs.netgate.com/pfsense/en/latest/recipes/example-basic-configuration.html)
- Principe du **Deny All**

# 2. Domaine AD DS

## a. Configuration

- Nom de la machine : SRVWIN01
- OS : Windows Server 2022 GUI
- Rôles : AD-DS
- Domaine AD DS : tssr.lan
## b. Organisation AD DS

### i. OU

- Création de toutes les OU correspondantes aux noms des départements
- Mettre les utilisateurs crées dans les OU correspondantes
### ii. Groupes

- Créer les groupes correspondants aux départements choisi
- Mettre les utilisateurs correspondant dans les groupes
- Implémentation de l'AGDLP

### iii. Utilisateurs

- Création d'au moins 6 utilisateurs :
	- 2 avec la fonction **Manager** dans 2 départements différents
	- 2 utilisateurs "standard" dépendants d'un manager (donc 4 utilisateurs en tout)

## c. GPO

- Création des GPO suivantes :
	- Politique de mot de passe (complexité, longueur, etc.)
	- Verrouillage de compte (blocage de l'accès à la session après quelques erreur de mot de passe)
	- Blocage complet ou partiel au panneau de configuration
	- Gestion d'un compte du domaine qui est administrateur local des machines
	- Politique de sécurité PowerShell
- Créer 2 GPO supplémentaires au choix

# 3. DNS

## a. Configuration

 - Nom de la machine : SRVWIN01
- Rôles : DNS
- Création d'une zone directe

## b. Zone DNS

- Mise en place d'une zone directe
- Création des enregistrement de type A pour les machines de l'infra
- Création des DNS forwarders

# 4. DHCP

## a. Configuration

 - Nom de la machine : SRVWIN01
- Rôles : DHCP

## b. Plage DHCP

- Création d'1 plage DHCP pour le LAN

# 5. GLPI

## a. Configuration

- Nom : SRVLX01 (ou machine indépendante GLPI01)
- OS : Debian CLI
- Installation de GLPI

## b. Autre configuration

- Accès en web depuis n'importe quel client sur la web GUI
- Mise en place d'une gestion de parc
- Mise en place d'un système de ticketing

# 6. WSUS

## a. Configuration

- Nom de la machine : SRVWIN04
- Rôles : WSUS

## b. Autre configuration

- Création de groupe locaux WSUS
- Gestion de MAJ de sécurité par groupe

# 7. VOIP

## a. Configuration

- Nom de la machine : IPBX01
- Installation de FreePBX (https://www.freepbx.org/)

## b. Lignes VoIP

- Création de lignes VoIP pour les utilisateurs déjà créer
- Validation de communication téléphonique VoIP entre 2 clients VoIP sur serveur et client Windows
- Utilisation d'un softphone (comme 3CX)

# 8. Messagerie

## a. Configuration

- Nom de la machine : SRVLX01
- OS : Debian CLI
- Installation de :
	- Zimbra (https://www.zimbra.com/product/download/)
	- ou iRedMail (https://www.iredmail.org/)

## b. Boites mail

 - Création de boite mail pour les utilisateurs crées
- Connexion via client de messagerie local
- Validation d'envoie et de réception de mails entre 2 clients de messagerie sur serveur et client Windows

# 9. Clients

Préparer 2 clients :
- Windows 10 : CLIWIN01
- Windows 11 : CLIWIN02

Les 2 clients font parti du domaine AD.