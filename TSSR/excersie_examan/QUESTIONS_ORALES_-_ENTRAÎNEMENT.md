
---

## Question O.1 - Qu'est-ce qu'un VPN ?

> [!success]- Réponse
> Un **VPN** (Virtual Private Network) crée une connexion sécurisée et chiffrée entre deux points à travers Internet.
> - **Site-à-site** : relie deux réseaux (siège ↔ filiale)
> - **Nomade (client-à-site)** : utilisateur distant → réseau entreprise
> - Protocoles : IPSec, OpenVPN, WireGuard

---

## Question O.2 - À quoi sert le DHCP ?

> [!success]- Réponse
> Attribue automatiquement une config IP (adresse, masque, passerelle, DNS, bail).
> Ports : UDP 67 (serveur) / UDP 68 (client).

---

## Question O.3 - Différence utilisateur AD vs local ?

> [!success]- Réponse
> - **Local** : SAM locale, valable sur 1 PC, pas de GPO domaine
> - **AD** : NTDS.dit, valable sur tout le domaine, soumis aux GPO

---

## Question O.4 - Qu'est-ce qu'une GPO ?

> [!success]- Réponse
> Ensemble de paramètres pour users/PC du domaine AD.
> Config ordinateur (au boot) + Config utilisateur (à l'ouverture de session).
> Ex : fond d'écran, lecteurs réseau, restrictions, déploiement logiciels.

---

## Question O.5 - À quoi sert un pare-feu ?

> [!success]- Réponse
> Filtre le trafic entrant/sortant selon des règles. Bloque le non-autorisé, autorise le légitime, journalise.
> Matériel (appliance) ou logiciel (Windows Firewall, iptables/nftables).

---

## Question O.6 - Comment se connecter à distance ?

> [!success]- Réponse
> - **Windows** : RDP (port TCP 3389) → `mstsc`
> - **Linux** : SSH (port TCP 22) → `ssh user@ip`
> - Autres : TeamViewer, AnyDesk, VNC

---

## Question O.7 - Qu'est-ce qu'un proxy ?

> [!success]- Réponse
> Intermédiaire entre les utilisateurs et Internet. Fonctions : cache, filtrage, anonymat, journalisation.
> Port courant : 3128 (Squid), 8080.

---

## Question O.8 - Qu'est-ce que WSUS ?

> [!success]- Réponse
> Rôle Windows Server pour gérer les mises à jour Microsoft de façon centralisée. Téléchargement unique, contrôle des MAJ, planification, rapports.

---

## Question O.9 - Avantages d'un cluster d'hyperviseurs ?

> [!success]- Réponse
> HA (haute disponibilité), répartition de charge, migration à chaud, tolérance aux pannes.
> Ex : VMware vSphere, Proxmox VE, Hyper-V Cluster.

---

## Question O.10 - Différence switch vs hub ?

> [!success]- Réponse
> - **Hub** : couche 1, répète sur tous les ports, collisions, obsolète
> - **Switch** : couche 2, table MAC, envoi ciblé, bande passante dédiée

---

## Question O.11 - Qu'est-ce qu'un VLAN ?

> [!success]- Réponse
> Réseau local virtuel = segmentation logique. Sécurité (isolation), performance (réduit broadcast), flexibilité.
> Communication inter-VLAN → routeur ou switch L3.

---

## Question O.12 - C'est quoi le câble bleu du port console ?

> [!success]- Réponse
> Câble console (série/rollover). RJ-45 côté switch → DB9/USB côté PC.
> Configuration initiale via terminal série (PuTTY). Paramètres : 9600 bauds, 8N1.

---

## Question O.13 - Qu'est-ce qu'une ACL Cisco ? Différence standard vs étendue ?

> [!success]- Réponse
> Une ACL (Access Control List) filtre le trafic sur un routeur selon des règles permit/deny.
> - **Standard (1-99)** : filtre uniquement sur l'IP **source** → placement près de la **destination**
> - **Étendue (100-199)** : filtre sur source + destination + protocole + port → placement près de la **source**
> - ⚠️ Il y a toujours un `deny any` implicite à la fin → sans `permit any`, tout est bloqué
> - 

---

## Question O.15 - Qu'est-ce qu'un trunk ? Quel protocole ?

> [!success]- Réponse
> Un **trunk** est un lien réseau qui transporte **plusieurs VLANs** entre 2 switchs (ou switch ↔ routeur).
> Protocole : **802.1Q** (ajoute un tag de 4 octets dans la trame Ethernet avec le numéro de VLAN).
> - Port **access** = 1 VLAN, vers un PC → pas de tag
> - Port **trunk** = plusieurs VLANs, entre équipements réseau → tag 802.1Q

---

## Question O.16 - Comment faire communiquer 2 VLANs ?

> [!success]- Réponse
> Les VLANs sont isolés par défaut (pas de communication). Pour les faire communiquer :
> - **Router on a Stick** : 1 routeur avec des sous-interfaces (G0/0.10, G0/0.20) + trunk vers le switch. Chaque sous-interface = passerelle d'un VLAN. `encapsulation dot1Q [VLAN]` sur chaque sous-interface.
> - **Switch L3** : routage inter-VLAN directement sur le switch (SVI = interface VLAN)
> - Au titre TSSR → connaître **Router on a Stick** (c'est la question CP4 Q4.3)

---

## Question O.17 - Qu'est-ce que le NAT/PAT ? Différence ?

> [!success]- Réponse
> - **NAT** (Network Address Translation) : traduit une IP privée en IP publique pour sortir sur Internet
> - **PAT** (Port Address Translation / NAT overload) : plusieurs machines internes partagent **une seule IP publique** en utilisant des ports différents → c'est le cas le plus courant
> - **DNAT** (redirection de port / port forwarding) : redirige le trafic entrant vers un serveur interne
> - Commande Cisco PAT : `ip nat inside source list 1 interface G0/1 overload`

---

## Question O.18 - Qu'est-ce qu'une route statique ? Quand l'utiliser ?

> [!success]- Réponse
> Une route ajoutée **manuellement** dans la table de routage. Syntaxe Cisco : `ip route [réseau] [masque] [next-hop]`.
> - **C** = Connected (directement connecté), **S** = Static dans `show ip route`
> - Route par défaut : `ip route 0.0.0.0 0.0.0.0 [next-hop]` → tout ce qu'on ne connaît pas part vers ce routeur
> - Utilisation : petits réseaux, liens fixes. Pour les grands réseaux → protocoles dynamiques (OSPF, EIGRP)

---

## Question O.19 - 2 PCs sur des réseaux différents ne se pinguent pas. Que vérifier ?

> [!success]- Réponse
> Diagnostic en 5 étapes :
> 1. **Câblage** : voyants verts ? câble branché ?
> 2. **IP/masque** : `ipconfig` / `ip a` → bonne IP, bon masque, même sous-réseau que la passerelle ?
> 3. **Passerelle** : configurée ? ping la passerelle → si KO, problème local
> 4. **Routeur** : interfaces UP (`show ip interface brief`) ? `no shutdown` fait ? Routes statiques vers les réseaux distants ?
> 5. **Retour** : le routeur distant a-t-il une route **retour** vers le réseau source ?
> ⚠️ Le piège classique : on configure l'aller mais on oublie le retour !

---

## Question O.20 - Wildcard mask : c'est quoi ? Comment le calculer ?

> [!success]- Réponse
> Le wildcard mask est l'**inverse** du masque de sous-réseau. Utilisé dans les ACL et OSPF Cisco.
> Calcul : **255.255.255.255 − masque**
>
> | Masque | Wildcard | Signification |
> |--------|----------|---------------|
> | 255.255.255.0 (/24) | **0.0.0.255** | Tout un réseau /24 |
> | 255.255.255.255 (/32) | **0.0.0.0** (= `host`) | 1 seule IP |
> | 255.255.0.0 (/16) | **0.0.255.255** | Tout un /16 |
> | 255.255.255.252 (/30) | **0.0.0.3** | 4 adresses (lien point-à-point) |

---

## Question O.21 - Qu'est-ce qu'un VDI persistant et non-persistant ?

> [!success]- Réponse
> Le **VDI** (Virtual Desktop Infrastructure) fournit des bureaux virtuels hébergés sur un serveur centralisé.
> - **Persistant** : chaque utilisateur a son propre bureau dédié. Les données, applis et personnalisations sont **conservées** entre les sessions. → Plus de confort, mais plus coûteux en stockage.
> - **Non-persistant** : le bureau est **réinitialisé** à chaque déconnexion (image de base identique pour tous). Les données utilisateur doivent être stockées ailleurs (profils itinérants, OneDrive, partage réseau). → Plus simple à maintenir, moins de stockage, idéal pour des postes standardisés (centres d'appels, salles de formation).
> - Ex : VMware Horizon, Citrix Virtual Apps and Desktops, Microsoft AVD

---

## Question O.22 - Différence entre RTO et RPO ?

> [!success]- Réponse
> Deux indicateurs clés du **PRA** (Plan de Reprise d'Activité) :
> - **RPO** (Recovery Point Objective) : quantité **maximale de données** qu'on accepte de perdre. Se mesure en temps (ex : RPO = 1h → on peut perdre au max 1h de données → il faut sauvegarder au moins toutes les heures).
> - **RTO** (Recovery Time Objective) : **durée maximale d'indisponibilité** acceptable avant la reprise du service (ex : RTO = 4h → le système doit être rétabli en moins de 4h).
> - RPO → fréquence des sauvegardes | RTO → rapidité de la restauration
> - Plus le RPO/RTO est faible, plus la solution coûte cher (réplication temps réel, HA, etc.)

---

## Question O.23 - Quels sont les avantages et inconvénients des snapshots sur des VM ?

> [!success]- Réponse
> Un **snapshot** capture l'état complet d'une VM à un instant T (disque, mémoire, config).
> **Avantages** :
> - Retour arrière rapide avant une mise à jour ou un changement de config
> - Pratique pour les tests : on peut revenir à l'état initial en quelques clics
> - Pas besoin d'arrêter la VM pour en prendre un
>
> **Inconvénients** :
> - ⚠️ **Ce n'est pas une sauvegarde !** (stocké sur le même datastore que la VM)
> - Consomme de l'espace disque de façon **croissante** (fichiers delta qui grossissent)
> - **Dégrade les performances** s'ils sont conservés trop longtemps ou s'il y en a trop (chaîne de snapshots)
> - Bonne pratique : supprimer le snapshot **dès que possible** après validation du changement

---

## Question O.24 - Comment bloquer un trafic inter-VLAN sur un switch ?

> [!success]- Réponse
> Par défaut, les VLANs sont **isolés** (pas de communication). Le trafic inter-VLAN n'existe que si on l'a activé (Router on a Stick ou Switch L3).
> Pour **bloquer** un trafic inter-VLAN spécifique :
> - **ACL sur le routeur/switch L3** : appliquer une ACL étendue sur l'interface ou la SVI pour deny le trafic entre certains VLANs
> - **Exemple** : bloquer VLAN 10 → VLAN 20 :
>   ```
>   access-list 100 deny ip 192.168.10.0 0.0.0.255 192.168.20.0 0.0.0.255
>   access-list 100 permit ip any any
>   ```
>   Puis appliquer sur l'interface : `ip access-group 100 in`
> - **Autre option** : ne tout simplement **pas router** entre les VLANs concernés (pas de SVI ou pas de sous-interface pour ce VLAN)
> - Sur certains switchs managés : fonctionnalité **Private VLAN** ou **VLAN isolation**