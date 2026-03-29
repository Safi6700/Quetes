# 🎯 TSSR - Révision Questions par CCP

> [!info] Basé sur le fichier de révision des sessions précédentes
> Réponses raccourcies avec **mots-clés** pour mémorisation rapide.

---

# CCP 1 — Support utilisateur en centre de service

---

### ❓ Différence entre incident et problème (ITIL) ?

> [!success] Réponse
> **Incident** = événement imprévu qui perturbe un service → objectif : **rétablir vite**
> **Problème** = cause sous-jacente d'un ou plusieurs incidents → objectif : **trouver la cause racine** et éviter la récurrence

---

### ❓ Différents moyens de prendre le contrôle à distance ?

> [!success] Réponse
> - **RDP** (Windows), **VNC**, **TeamViewer**, **AnyDesk**
> - **SSH** (Linux/Unix), SSH avec **X11** (retour graphique)
> - **Chrome Remote Desktop** (web)
> - **VPN** + outils locaux
> - **Remote PowerShell**
> - **SCCM** (Microsoft)

---

### ❓ Étapes de résolution d'incident par téléphone ?

> [!success] Réponse
> 1. Identification / Détection
> 2. Notification
> 3. Enregistrement
> 4. Catégorisation et priorisation
> 5. Diagnostic et investigation
> 6. Suivi (ou escalade)
> 7. Résolution (et documentation)
> 8. Clôture

---

### ❓ Qu'est-ce qu'un MDM ?

> [!success] Réponse
> **Mobile Device Management** → gérer, surveiller et sécuriser les appareils mobiles (smartphones, tablettes) en entreprise.
> Config à distance, déploiement d'apps, MAJ, politique d'entreprise.

---

### ❓ Politique de mot de passe ?

> [!success] Réponse
> **Complexité** (majuscules, minuscules, chiffres, caractères spéciaux) — **Longueur** (8+ caractères) — **Renouvellement** (ex: tous les 3 mois) — **Interdiction réutilisation** (10 derniers) — **Verrouillage** après X tentatives

---

### ❓ À quoi sert un logiciel de gestion de parc informatique ?

> [!success] Réponse
> Suivre, gérer et optimiser tous les équipements IT (PC, serveurs, logiciels).
> → maintenance, MAJ, **comptabilité des licences**, suivi garanties, planification remplacements

---

### ❓ Avantages d'un outil de gestion d'incidents ?

> [!success] Réponse
> **Traçabilité** — **Priorisation** (urgence/impact) — **Communication** (notifications auto) — **Reporting** (tendances) — **Centralisation** (base unique, historique)

---

### ❓ Outil collaboratif synchrone vs asynchrone ?

> [!success] Réponse
> **Synchrone** = temps réel → Google Meet, Zoom, chat, co-rédaction Google Docs
> **Asynchrone** = pas en même temps → emails, forums, Trello

---

### ❓ Nouvelles stations avec disques 4 To : précautions ?

> [!success] Réponse
> Configurer le BIOS pour la prise en compte de l'**UEFI** (disques >2 To = GPT obligatoire)

---

### ❓ Rédiger email de maintenance SI ?

> [!success] Réponse
> Sujet clair — informer de la date/durée — préciser l'impact (base de données indisponible) — remercier pour la compréhension

---

### ❓ Former les utilisateurs au stockage en ligne : points à évoquer ?

> [!success] Réponse
> Présentation de la solution (Dropbox, Google Drive, OneDrive) — comment **sauvegarder et accéder** — comment **partager** — **sécurité et droits d'accès**

---

### ❓ Procédure récupérer un fichier supprimé ?

> [!success] Réponse
> 1. Vérifier la **corbeille**
> 2. Si vidée → **outils de récupération** de données
> 3. Vérifier les **sauvegardes locales**

---

### ❓ Config messagerie smartphone : renseignements nécessaires ?

> [!success] Réponse
> Type de messagerie (**IMAP**, POP3, Exchange) — adresse email + mot de passe — nom/IP des serveurs **SMTP** et **IMAP/POP3**

---

### ❓ Après résolution d'un problème, que faire ?

> [!success] Réponse
> **Informer** l'utilisateur → **vérifier** que ça fonctionne → **documenter** dans la base de connaissances

---

### ❓ Correctif de sécurité urgent pendant la pause déjeuner ?

> [!success] Réponse
> Communication rapide (mail + degré d'urgence) → appliquer le correctif + redémarrer → vérifier la réussite → seconde communication

---

### ❓ Utilisateurs ne retrouvent pas leurs fichiers entre les PC ?

> [!success] Réponse
> Mettre en place un **serveur de fichiers réseau** ou **stockage cloud** → former les utilisateurs aux ressources partagées

---

# CCP 2 — Serveurs Windows et Active Directory

---

### ❓ Qu'est-ce qu'un rôle FSMO ?

> [!success] Réponse
> **FSMO** = Flexible Single Master Operation → rôles spéciaux sur un DC en AD. **5 rôles** :
> 1. Maître de **schéma**
> 2. Maître d'attribution de **nom de domaine**
> 3. Maître **RID**
> 4. Maître d'**infrastructure**
> 5. Émulateur **PDC**

---

### ❓ Pourquoi la réplication entre DC est primordiale ?

> [!success] Réponse
> Garantit la **cohérence** et la **disponibilité** des données d'annuaire (utilisateurs, MDP, GPO) sur tous les DC.
> → Les utilisateurs accèdent aux infos **à jour** quel que soit le DC.
> → **Tolérance de panne**.

---

### ❓ RAID 0, 1, 5 : lequel est le plus sécurisé ?

> [!success] Réponse
> **RAID 0** = striping, min 2 disques → perte 1 disque = **perte totale**
> **RAID 1** = mirroring, min 2 disques → perte 1 disque = **aucune perte**
> **RAID 5** = striping + parité, min 3 disques → perte 1 disque = **aucune perte**
> → 2 disques : **RAID 1** le plus sûr. À partir de 3 : **RAID 5** (meilleur en lecture/écriture + parité)

---

### ❓ Outils pour gérer les journaux d'événements Windows ?

> [!success] Réponse
> **Observateur d'événements** (Event Viewer) — **PowerShell** (Get-EventLog, Get-WinEvent) — solutions de centralisation (SIEM)

---

### ❓ Qu'est-ce qu'une GPO ?

> [!success] Réponse
> **Group Policy Object** = stratégie de groupe dans AD → appliquer des configs et restrictions de manière **centralisée** sur les utilisateurs et ordinateurs du domaine

---

### ❓ Bonne pratique : permissions NTFS sur des utilisateurs ?

> [!success] Réponse
> **Non** → bonne pratique = mettre les permissions sur des **groupes**, puis ajouter les utilisateurs dans les groupes (principe **AGDLP**)

---

### ❓ Utilisateur AD jdoe et local jdoe : même bureau ?

> [!success] Réponse
> **Non** → 2 comptes différents, 2 profils distincts, 2 bureaux séparés

---

### ❓ AD : base hiérarchique ou relationnelle ?

> [!success] Réponse
> **Hiérarchique** → structure en arbre : Forêt > Domaine > OU > Objets
> Exemple : OU "Comptabilité" contient les utilisateurs du service compta

---

### ❓ Comment mettre en place une politique de MDP sur AD ?

> [!success] Réponse
> Via **GPO** → Default Domain Policy → Configuration ordinateur → Stratégies de compte → Stratégie de mot de passe

---

### ❓ Qu'est-ce qu'un objet Active Directory ?

> [!success] Réponse
> Toute entité stockée dans l'annuaire AD : **utilisateur, groupe, ordinateur, OU, imprimante, contact**. Chaque objet a des **attributs** et un **DN** unique.

---

### ❓ Concept d'attribut d'objet AD ?

> [!success] Réponse
> Un attribut = **propriété** d'un objet AD (ex : nom, prénom, email, SID, mot de passe). Définis par le **schéma** AD.

---

### ❓ Bonne pratique de supprimer un compte le lendemain du départ ?

> [!success] Réponse
> **Non** → **désactiver** le compte d'abord. Raisons : conservation données, audit, transfert droits au remplaçant. Suppression **après une période définie**.

---

### ❓ Qu'est-ce que la réplication AD ?

> [!success] Réponse
> **Synchronisation** des données d'annuaire entre tous les DC → cohérence, disponibilité, tolérance de panne.

---

### ❓ Tous les DC doivent être des serveurs graphiques ?

> [!success] Réponse
> **Non** → on peut utiliser **Windows Server Core** (sans GUI). Avantages : moins de surface d'attaque, moins de ressources, moins de MAJ.

---

### ❓ Comment administrer un serveur Core ?

> [!success] Réponse
> **PowerShell** (local ou remote) — **RSAT** depuis un autre poste — **Windows Admin Center** (web) — **Sconfig** pour la config de base

---

# CCP 3 — Serveurs Linux

---

### ❓ Élévation de privilèges sous Linux ?

> [!success] Réponse
> `sudo` (exécuter en root) ou `su` (changer d'utilisateur)

---

### ❓ Commande pour ajouter IP 172.16.8.16 sur enp0s8 ?

> [!success] Réponse
> `ip address add 172.16.8.16/24 dev enp0s8`

---

### ❓ Wilder ne peut pas accéder au dossier travaux ?

> [!success] Réponse
> **Cause** : pas les permissions nécessaires.
> **Diagnostic** : `ls -ld /home/wilder/travaux/`
> **Résolution** : `chmod` (modifier droits) ou `chown` (changer propriétaire)

---

### ❓ chmod u+x /home/tssr/factures/export.sh ?

> [!success] Réponse
> Ajoute le droit d'**exécution** (`x`) pour le **propriétaire** (`u`) sur le fichier export.sh

---

### ❓ Nouveau disque avec 1 partition : comment se nommera-t-elle ?

> [!success] Réponse
> **`sdb1`** (disque existant = sda, nouveau disque = sdb, partition 1 = sdb1)

---

### ❓ Partitionner des disques >2 To sous Linux ?

> [!success] Réponse
> `fdisk` ne fonctionne pas >2 To → utiliser **`gdisk`** ou **`gfdisk`** (support GPT)

---

### ❓ /etc/shadow, /etc/passwd, /etc/group ?

> [!success] Réponse
> `/etc/passwd` = infos comptes utilisateurs
> `/etc/shadow` = **mots de passe chiffrés**
> `/etc/group` = infos sur les **groupes**

---

### ❓ systemctl start vs systemctl enable ?

> [!success] Réponse
> `start` = **démarre** le service maintenant
> `enable` = configure pour **démarrer auto au boot**
> → pas le même effet

---

### ❓ dig (Linux) = tracert (Windows) ?

> [!success] Réponse
> **Non.** `dig` = requête infos **DNS**. `tracert` = chemin des paquets IP (sauts de routeurs). Totalement différent.

---

### ❓ À quoi sert chroot ?

> [!success] Réponse
> Change la **racine** du système de fichiers pour un processus → **environnement isolé**. Utilité : sécurité (ex : serveur DNS chrooté), tests.

---

### ❓ Afficher les 20 dernières lignes de logs en temps réel ?

> [!success] Réponse
> `tail -n 20 -f /var/log/syslog`

---

### ❓ usermod -a -G admin sthomas ?

> [!success] Réponse
> **Ajoute** (`-a`) l'utilisateur sthomas au **groupe admin** (`-G`). Sans `-a` il serait retiré de ses autres groupes.

---

### ❓ chmod 777 startScript.sh : bonne idée ?

> [!success] Réponse
> **Non** → 777 = tous les droits pour tout le monde = **risque de sécurité**. Appliquer le **moindre privilège**.

---

### ❓ mount/umount Linux = dism mount/umount Windows ?

> [!success] Réponse
> **Non.** `mount/umount` = monter des **systèmes de fichiers**. `dism mount/umount` = monter des **images d'OS (.wim)**. Cibles et utilisations différentes.

---

### ❓ À quoi sert Samba ? Équivalent Windows ?

> [!success] Réponse
> Samba = implémentation open-source du protocole **SMB** sur Linux. Permet le **partage de fichiers** entre Linux et Windows. Équivalent Windows = SMB natif.

---

# CCP 4 — Exploiter un réseau IP

---

### ❓ 192.168.16.0/25 découpé en 4 sous-réseaux ?

> [!success] Réponse
> /25 ÷ 4 = **/27** (32 adresses chacun)
> SR1 : 192.168.16.0/27 → broadcast .31
> SR2 : 192.168.16.32/27 → broadcast .63

---

### ❓ Tableau conversion décimal/binaire/hexa ?

> [!success] Réponse
> 9 = 00001001 = 0x09
> 127 = 01111111 = 0x7F
> 255 = 11111111 = 0xFF
> 16 = 00010000 = 0x10

---

### ❓ Schéma VLAN : liens trunk et routage inter-VLAN ?

> [!success] Réponse
> Liens trunk = **entre les switchs et le routeur** (transportent plusieurs VLANs).
> Méthode = **Router-on-a-stick** → le routeur route entre VLANs avec des id différents sur le même lien.

---

### ❓ PC1 (192.168.1.54/24) et PC2 (192.168.2.74/24) ne communiquent pas ?

> [!success] Réponse
> **Solution matérielle** : installer un **routeur** entre les 2 sous-réseaux.
> **Paramétrage** : configurer le routeur pour connaître les 2 sous-réseaux + **passerelle par défaut** sur chaque PC.

---

### ❓ 4 PC sur un switch (1 seul VLAN), communications ICMP ?

> [!success] Réponse
> **PC1** (.10.8/24) et **PC2** (.10.12/24) : même sous-réseau → communiquent entre eux et avec PC3
> **PC3** (.10.10 avec **/16**) : réseau plus large 192.168.0.0/16 → envoie à tous, mais seuls PC1/PC2 répondent. PC4 l'envoie à sa passerelle.
> **PC4** (.11.9/24) : sous-réseau différent 192.168.11.0/24 → **ne communique avec personne** directement

---

### ❓ Actions pour sécuriser un réseau sans fil ?

> [!success] Réponse
> Changer le **SSID** — chiffrement **WPA3** — MDP **fort** — désactiver diffusion SSID — réseau **invité** — MAJ **firmware** — **filtrage MAC** — désactiver admin à distance — serveur **RADIUS**

---

### ❓ Routes statiques sur Routeur1 pour PC0 ↔ PC3 ?

> [!success] Réponse
> ```
> ip route 192.168.1.0 255.255.255.0 172.14.1.1
> ip route 192.168.2.0 255.255.255.0 41.11.21.1
> ```

---

### ❓ Tableau protocoles / ports ?

> [!success] Réponse
> | Protocole | Port TCP | Port UDP |
> |-----------|----------|----------|
> | HTTP | 80 | |
> | FTP/SFTP | 20, 21, 22 | |
> | SSH | 22 | |
> | TFTP | | 69 |
> | SMTP | 25 | |
> | IMAP | 143 / 993 | |
> | LDAP | 389 / 636 | |
> | POP3 | 110 / 995 | |
> | DNS | 53 | 53 |
> | NTP | 123 | |

---

### ❓ Téléphone IP : quels ports du switch ?

> [!success] Réponse
> Le téléphone a un **chargeur** → on peut le brancher sur les **ports 1 à 8** (pas besoin de PoE)

---

### ❓ Protocoles sur quelles couches TCP/IP ?

> [!success] Réponse
> **Accès réseau** : ARP, Ethernet
> **Internet** : ARP, ICMP, IPv6, DHCP
> **Application** : FTP, TLS/SSL, POP3, Telnet, SNMP

---

### ❓ Tables de routage R1, R2, R3 ?

> [!success] Réponse
> Chaque routeur connaît ses réseaux **directement connectés** (direct) + routes vers réseaux distants via **next hop**.
> Les 2 dernières lignes de R1 et R2 peuvent être remplacées par une **route par défaut** `0.0.0.0/0`.

---

### ❓ Bob et Alice ne communiquent pas : pourquoi ?

> [!success] Réponse
> **Chevauchement de sous-réseaux** : le /27 de PC5 recoupe le /28 du lien entre R2 et R3.
> **Solution** : passer le masque du VLAN de PC5 à **/29** → plus de chevauchement.

---

### ❓ Qu'est-ce qu'une topologie réseau ? Les 2 types ?

> [!success] Réponse
> Schéma décrivant comment les nœuds sont connectés.
> **Topologie physique** = câblage. **Topologie logique** = transmission des données (ex : VLANs).

---

### ❓ 5 protocoles courants + équivalents sécurisés ?

> [!success] Réponse
> HTTP(80) → **HTTPS**(443) | SMTP(25) → **SMTPS**(465) | FTP(21) → **SFTP**(22) | DNS(53) → **DNS-over-TLS**(853) | IMAP(143) → **IMAPS**(993)

---

### ❓ Différences switch, switch L3, routeur ?

> [!success] Réponse
> **Switch** = couche 2, adresses **MAC**, connecte un même LAN/VLAN
> **Routeur** = couche 3, adresses **IP**, connecte **plusieurs réseaux**
> **Switch L3** = fusion des 2, gère MAC + IP, fait du routage inter-VLAN

---

### ❓ Gi0/3, Gi1/2, Gi1/3 et combien de VLANs ?

> [!success] Réponse
> G0/3 = **VLAN 1** (default). G1/2 et G1/3 = **VLAN 10** (FINANCES).
> **7 id** de VLANs affichés, seulement **3 actifs** : default, DSI, FINANCES. Les 4 autres = historiques non supportés.

---

### ❓ Qu'est-ce qu'un trunk VLAN ?

> [!success] Réponse
> Transporter **plusieurs VLANs** sur une **seule liaison physique**. Chaque VLAN identifié par un **id**. Évite la multiplication des matériels.

---

### ❓ Intérêt des sous-réseaux pour les tables de routage ?

> [!success] Réponse
> **Simplifie** les tables en regroupant les adresses IP. Plus grande **segmentation** → meilleure **sécurité**.

---

### ❓ Adresse FF:FF:FF:FF:FF:FF ?

> [!success] Réponse
> Adresse de **broadcast ethernet** (couche liaison, adresse **MAC**).
> Équivalent IP : `255.255.255.255` = broadcast IP (couche réseau).

---

### ❓ 2 solutions pour le routage inter-VLAN ?

> [!success] Réponse
> 1. Routeur avec **interfaces physiques** séparées pour chaque VLAN
> 2. Routeur avec **une seule interface** en trunk = **router-on-a-stick** (agrégation de VLAN)

---

### ❓ Adresse réseau de la moitié de 198.51.100.0/24 ?

> [!success] Réponse
> /24 ÷ 2 = **/25**. 256/2 = 128.
> 2ème moitié : **198.51.100.128/25**

---

### ❓ Commande pour la latence entre 2 machines ?

> [!success] Réponse
> `ping`

---

### ❓ Peut-on configurer 172.16.15.255 sur un PC ?

> [!success] Réponse
> **Oui** sauf si c'est l'adresse de broadcast du sous-réseau.
> En /24 → c'est le broadcast → **non**
> En /16 → broadcast = 172.16.255.255 → **oui**

---

### ❓ Pourquoi switch plutôt que hub ?

> [!success] Réponse
> **Hub** = envoie à **tous** les ports (collision unique). **Switch** = envoie au **port destinataire** (domaines de collision distincts). → moins de trafic inutile, meilleures performances.

---

### ❓ /28 en notation décimale ?

> [!success] Réponse
> /28 → 11111111.11111111.11111111.1111**0000** → **255.255.255.240**

---

### ❓ À quoi sert un serveur DHCP ?

> [!success] Réponse
> Attribue **automatiquement** une config IP : adresse IP, masque, passerelle, DNS, etc. Simplifie la gestion des adresses.

---

### ❓ Qu'est-ce qu'un trunk SIP ?

> [!success] Réponse
> Jonction entre **2 réseaux téléphoniques** (ex : 2 IPBX) via le protocole **SIP** → domaine de la **ToIP**.

---

### ❓ Que fait l'adresse 255.255.255.255 ?

> [!success] Réponse
> Adresse de **broadcast**. Envoie des paquets à **tous les matériels** du réseau local. Ex : **DHCP REQUEST**.

---

### ❓ VLANs actifs dans la capture "show vlan status" ?

> [!success] Réponse
> Seuls les VLANs **1** et **1170** sont actifs (colonne Operstate = **Up**). Les autres (2, 4, 25, 212, 213) sont **Down**.

---

### ❓ Ping PC1→PC6 et PC3→PC6 : adresses MAC/IP ?

> [!success] Réponse
> **PC1→PC6** : IP src=172.16.1.10, dst=10.15.1.60. MAC src=PC1, MAC dst=**e0 sur R1** (passerelle)
> **PC3→PC6** : IP src=192.168.100.30, dst=10.15.1.60. MAC src=PC3, MAC dst=**e1 sur R1**
> ==IP de bout en bout, MAC change à chaque saut==

---

### ❓ IPv6 ::1 et équivalent IPv4 ?

> [!success] Réponse
> **Boucle locale (loopback)**. Communication de l'hôte avec lui-même.
> IPv4 = **127.0.0.1**

---

### ❓ Différence commutateur vs routeur ?

> [!success] Réponse
> **Commutateur** = couche 2, adresse **MAC**, recopie au port destinataire.
> **Routeur** = couche 3, adresse **IP**, dirige selon la **table de routage**.

---

### ❓ Commande pour afficher les routes sous Windows ?

> [!success] Réponse
> `route print`

---

### ❓ TCP/IP vs OSI ?

> [!success] Réponse
> **TCP/IP** = 4 couches (liaison, réseau, transport, application) → modèle pratique
> **OSI** = 7 couches → modèle théorique

---

# CCP 5 — Infrastructure virtualisée

---

### ❓ Cluster d'hyperviseurs : définition et intérêt ?

> [!success] Réponse
> Regroupement de **plusieurs serveurs** avec hyperviseurs pour gérer des VM.
> → **haute disponibilité**, **répartition de charge**, gestion centralisée, **continuité de service** même si un serveur tombe.

---

### ❓ Qu'est-ce qu'un conteneur Docker ?

> [!success] Réponse
> **Instance d'une image**. Le conteneur est à l'image ce que le processus est au programme.
> Plusieurs conteneurs depuis la même image. Les modifications restent **dans le conteneur**, pas sur l'image.

---

### ❓ Que représente ce Dockerfile ?

> [!success] Réponse
> `FROM ubuntu:latest` → image de base Ubuntu
> `RUN apt-get install bash nano` → installe des paquets
> `RUN mkdir /data` + `WORKDIR /data` → crée et définit le répertoire de travail
> `CMD ["bash", "-i"]` → lance bash interactif au démarrage
> → On sauvegarde dans un fichier **Dockerfile** puis on construit avec `docker build`

---

### ❓ Erreur CRITICAL Swap Usage sur Nagios ?

> [!success] Réponse
> Erreur **CRITICAL** sur **Swap Usage** → **0% free** dans Status.
> → Il faut **augmenter la taille du swap**.

---

### ❓ PaaS, IaaS, SaaS ?

> [!success] Réponse
> **PaaS** = Platform as a Service → plateforme pour développer sans gérer l'infra
> **IaaS** = Infrastructure as a Service → ressources virtualisées sur Internet
> **SaaS** = Software as a Service → logiciels dans le cloud via navigateur

---

### ❓ Éléments indispensables pour la HA (High Availability) ?

> [!success] Réponse
> **Redondance matérielle** — **Load Balancing** — **Failover** automatique — **Réplication** temps réel — **Supervision** — **PRA et PCA**

---

### ❓ Qu'est-ce qu'une image Docker ?

> [!success] Réponse
> Modèle **binaire et immuable** utilisé pour créer des conteneurs.

---

### ❓ Composants matériels importants pour un hôte de VM ?

> [!success] Réponse
> **RAM** — **Stockage disque** — **Processeur**

---

### ❓ docker system prune ?

> [!success] Réponse
> Supprime les ressources **non-utilisées** par Docker (conteneurs arrêtés, images inutilisées, etc.)

---

### ❓ Avantages/inconvénients conteneurisation vs virtualisation ?

> [!success] Réponse
> Conteneurs : plus **léger**, démarrage **plus rapide**, meilleure utilisation des ressources.
> Inconvénients : **isolation moins forte**, complexité de cohabitation des apps.

---

### ❓ Fichier de config VirtualBox : quelles infos ?

> [!success] Réponse
> Nom VM : "Linux VM" — OS : Linux 64 bits — RAM : **8192 Mo (8 Go)** — Boot sur disque 1 — Disque : **10 Go** type Normal — BIOS : ACPI + IOAPIC activés — Réseau : adaptateur **virtio en NAT**

---

### ❓ Qu'est-ce qu'un conteneur ?

> [!success] Réponse
> Environnement **isolé et léger** qui exécute une application en partageant le **noyau** de l'hôte. Plus léger qu'une VM.

---

### ❓ 2 hyperviseurs de type 1 et 2 de type 2 ?

> [!success] Réponse
> **Type 1** (bare-metal) : VMware **ESXi**, Microsoft **Hyper-V**
> **Type 2** (hébergé sur un OS) : **VirtualBox**, VMware **Workstation**

---

### ❓ Comment mettre à jour une image Docker ?

> [!success] Réponse
> `docker pull` → télécharge la **dernière version** depuis le registre.

---

# CCP 6 — Automatiser des tâches avec des scripts

---

### ❓ Récupérer des arguments passés à un script ?

> [!success] Réponse
> **Bash** : `$1`, `$2`, `$3`... (`$0` = nom du script, `$#` = nombre d'args, `$@` = tous)
> **PowerShell** : `param($arg1, $arg2)` ou `$args[0]`

---

### ❓ Automatiser la création d'utilisateurs Windows ?

> [!success] Réponse
> **PowerShell** avec `New-ADUser` + `Import-Csv` pour création en masse depuis un CSV.
> Ou **script batch** avec `dsadd`.

---

### ❓ Avantages d'Ansible ?

> [!success] Réponse
> **Agentless** (utilise SSH/WinRM) — **Idempotent** — fichiers **YAML** lisibles (playbooks) — gestion **centralisée**

---

### ❓ Vérifier un script Bash sans l'exécuter ?

> [!success] Réponse
> `bash -n script.sh` → vérification **syntaxique** sans exécution.

---

### ❓ Planifier des tâches récurrentes ?

> [!success] Réponse
> **Windows** : Planificateur de tâches / `schtasks`
> **Linux** : `crontab -e`

---

### ❓ Script auto à l'ouverture de session Windows ?

> [!success] Réponse
> **GPO** → scripts de connexion. Ou **Planificateur de tâches** avec déclencheur ouverture de session. Ou dossier **startup**.

---

# CCP 7 — Sécuriser les accès Internet et interconnexions

---

### ❓ Impact des ACL sur 172.16.0.10 et fusion ?

> [!success] Réponse
> ACL 100 : **bloque ICMP** (ping) de 172.16.0.10 vers 172.17.0.0, autorise le reste.
> ACL 101 : **bloque TCP port 80** (HTTP) et **443** (HTTPS) de 172.16.0.10 vers 220.0.0.60, autorise le reste.
> **Fusion** possible :
> ```
> access-list 110 deny icmp host 172.16.0.10 172.17.0.0 0.255.255.255
> access-list 110 deny tcp host 172.16.0.10 host 220.0.0.60 eq www
> access-list 110 deny tcp host 172.16.0.10 host 220.0.0.60 eq 443
> access-list 110 permit ip any any
> ```

---

### ❓ sha512sum : pourquoi même longueur de sortie ?

> [!success] Réponse
> **Fonction de hachage cryptographique** → produit toujours une sortie de **taille fixe**, quelle que soit la taille de l'entrée.

---

### ❓ Accéder au serveur web de manière sécurisée depuis Internet ?

> [!success] Réponse
> 1. Créer sur le firewall une **redirection du port 443** (HTTPS) vers l'IP du serveur web dans la **DMZ**
> 2. Créer une **règle** pour autoriser le trafic **WAN → DMZ** sur le port 443

---

### ❓ Types de VPN dans les illustrations ?

> [!success] Réponse
> **VPN A** = accès distant (**host to network**) : client isolé → Internet → réseau entreprise
> **VPN B** = **site à site** : Site A ↔ Internet ↔ Site B (2 pare-feux VPN)

---

### ❓ Chiffrement asymétrique Alice → Bob ?

> [!success] Réponse
> Alice utilise la **clé publique de Bob** pour chiffrer. Bob utilise sa **clé privée** pour déchiffrer.
> = **chiffrement asymétrique**.

---

### ❓ Traduire le passage VPN IPSec/ISAKMP ?

> [!success] Réponse
> Le nœud initiateur envoie toutes ses **politiques** au nœud distant. Le distant vérifie chaque politique dans l'**ordre de priorité** (la plus haute d'abord) jusqu'à trouver une **correspondance**.

---

### ❓ 3 types de menaces pour un SI ?

> [!success] Réponse
> **Malwares** (virus, ransomwares, chevaux de Troie) — **Phishing** (hameçonnage) — **Intrusions réseau** (accès non autorisé) — **DDoS** — **Fuites de données** — **Exploitation de vulnérabilités**

---

### ❓ Pourquoi mettre à jour le firmware réseau ?

> [!success] Réponse
> Corriger des **vulnérabilités** — améliorer **performances/stabilité** — ajouter des **fonctionnalités**

---

### ❓ Que font ces commandes SSH ?

> [!success] Réponse
> Configuration de l'**authentification par clé SSH** entre 2 machines :
> `ssh-keygen` = génère paire de clés → la clé publique (`id_rsa.pub`) est copiée dans `~/.ssh/authorized_keys` du client → connexion **sans mot de passe**

---

### ❓ ACL sur R1 : que déduire de 172.16.15.10 ?

> [!success] Réponse
> Ports 67, 68 = **DHCP**. Port 53 (TCP+UDP) = **DNS**.
> → 172.16.15.10 est un **serveur DHCP et DNS**.

---

### ❓ Zone blanche Wi-Fi ?

> [!success] Réponse
> Zone **sans couverture** réseau. Détection : **NetSpot**, WiFi Analyzer, cartographie.
> Solution : **répéteurs wifi** pour propager le signal.

---

### ❓ WPA est-il sécurisé ?

> [!success] Réponse
> Plus sécurisé que **WEP** (obsolète), mais moins que **WPA2** et **WPA3**.
> → Aujourd'hui, WPA n'est **pas considéré sécurisé**.

---

### ❓ Expliquer les règles du firewall ?

> [!success] Réponse
> Règle 1 : autorise **172.16.8.54** en **SSH** vers le firewall → administration
> Règle 2 : autorise **172.16.10.58** en **HTTPS** vers le firewall → administration web
> Règle 3 : autorise les machines du **LAN** vers le firewall → certains services
> Règle 4 : **bloque toutes** les connexions TCP vers le firewall

---

### ❓ Type de Wi-Fi pour bureaux 400m² ?

> [!success] Réponse
> Wi-Fi en mode **infrastructure étendue (ESS)**. 1 à 2 bornes suffisent. Possibilité d'en ajouter.

---

### ❓ Cryptographie asymétrique : Bob envoie à Alice ?

> [!success] Réponse
> Bob chiffre avec **PUB-Alice** (clé publique). Alice déchiffre avec **PRI-Alice** (clé privée).

---

# CCP 8 — Sauvegardes et restaurations

---

### ❓ Règle 3-2-1 ?

> [!success] Réponse
> **3** copies (prod + 2 sauvegardes) — **2** types de support différents — **1** copie **hors-site**

---

### ❓ Types de sauvegardes ?

> [!success] Réponse
> **Complète** — **Incrémentale** (depuis dernière sauvegarde) — **Différentielle** (depuis dernière complète)

---

### ❓ Sauvegarde vs archivage vs clonage ?

> [!success] Réponse
> **Sauvegarde** = copie de données **en production**, restaurable.
> **Archivage** = stockage **long terme**, données retirées de la production (raisons légales/historiques).
> **Clonage** = **réplique exacte** d'un système/disque, pour déployer des configs identiques.

---

### ❓ Bonnes pratiques pour sécuriser une sauvegarde ?

> [!success] Réponse
> **Chiffrement** — tests réguliers de **restauration** — stockage **hors-site** — contrôle d'accès — supervision/alertes

---

### ❓ Différence PRA vs PCA ?

> [!success] Réponse
> **PCA** = maintenir l'activité **pendant** le sinistre
> **PRA** = reprendre l'activité **après** le sinistre (RTO + RPO)

---

### ❓ Outils/technologies pour un PRA efficace ?

> [!success] Réponse
> Réplication des données — sauvegardes automatisées — site de repli — virtualisation — documentation des procédures — tests réguliers

---

### ❓ Messagerie en cloud : sauvegarde locale ?

> [!success] Réponse
> Utiliser un outil de **backup cloud-to-local** (ex : Veeam Backup for M365, MailStore). Export **PST** régulier. Archivage local.

---

### ❓ Types de stockage pour les sauvegardes ?

> [!success] Réponse
> **NAS** (réseau) — **SAN** — **Bandes LTO** — **Cloud** — **Disques externes** — **Serveur de sauvegarde**

---

### ❓ Avantages/inconvénients du stockage sur bandes LTO ?

> [!success] Réponse
> **Avantages** : grande capacité, coût faible par To, durabilité, hors-ligne (protection ransomware)
> **Inconvénients** : accès **séquentiel** (lent), matériel dédié, restauration plus longue

---

### ❓ Pourquoi une politique de rétention ?

> [!success] Réponse
> Gérer l'**espace de stockage** — respecter les **obligations légales** — pouvoir restaurer sur une période définie — maîtriser les **coûts**

---

### ❓ Outils pour automatiser la gestion des sauvegardes ?

> [!success] Réponse
> **Veeam** — **Acronis** — **Bacula** — **Windows Server Backup** — **rsync** + cron (Linux) — **Nakivo**

---

# CCP 9 — Déploiement des postes de travail

---

### ❓ Avantages d'un service centralisé de MAJ ? Solution connue ?

> [!success] Réponse
> **Sécurité renforcée** (dernières MAJ pour tous) — **gestion centralisée** (simplifiée).
> Solution : **WSUS** (Windows Server Update Services).

---

### ❓ Inconvénients des clients légers vs postes fixes ?

> [!success] Réponse
> **Dépendance au réseau** — **point de défaillance unique** (serveur central) — **coût initial** élevé — **personnalisation limitée**

---

### ❓ sysprep.exe /oobe /generalize /shutdown ?

> [!success] Réponse
> `/oobe` = fenêtres de guide utilisateur au prochain démarrage
> `/generalize` = supprime les infos spécifiques (SID, etc.) → réutilisable sur d'autres machines
> `/shutdown` = éteint après sysprep
> → Préparer un **master** pour **déploiement de masse**

---

### ❓ Utilité d'un dépôt local de paquets Linux ?

> [!success] Réponse
> Téléchargement **local** au lieu d'Internet → **gain de bande passante**. Maîtrise des paquets et versions disponibles.

---

### ❓ dism mount et dism umount ?

> [!success] Réponse
> Commandes de **montage/démontage d'image** sous Windows. On monte une image (.wim) pour la modifier, puis on la démonte.

---

### ❓ Actions pour un déploiement de masse ?

> [!success] Réponse
> 1. Préparation du **PC modèle** (master)
> 2. **Sysprep** du master
> 3. **Capture** de l'image
> 4. **Déploiement** du master sur les postes

---

### ❓ Commandes Diskpart : but ?

> [!success] Réponse
> `list disk` → affiche les disques. `select disk 2` → sélectionne. `clean` → supprime partitions. `create partition primary` → crée partition. `format fs=ntfs quick` → formate en NTFS. `active` → bootable. `assign` → attribue une lettre.
> → **Préparer un disque** (ou clé USB bootable)

---

### ❓ DHCP : utilité et moyens techniques ?

> [!success] Réponse
> Protocole qui propose une **config IP automatique** (adresse, masque, passerelle, DNS).
> Mise en place : **serveur DHCP** (Windows/Linux), **routeur**, **firewall**.

---

### ❓ Relais DHCP : utilité et commandes ?

> [!success] Réponse
> Transmet les messages DHCP entre clients et serveur sur **des réseaux différents**.
> Routeur : `ip helper-address`. Windows : rôle **agent relais DHCP**.

---

### ❓ Qu'est-ce qu'un sysprep ?

> [!success] Réponse
> Utilitaire Windows pour préparer une machine en **master** de déploiement. Supprime tous les **identifiants** et traces de personnalisation.

---

### ❓ DNS sécurisé (DNSSEC) ?

> [!success] Réponse
> Utilise des **signatures cryptographiques** pour sécuriser les infos DNS. Système de **clé privée / clé publique**.

---

### ❓ Qu'est-ce qu'un boot PXE ?

> [!success] Réponse
> **Preboot Execution Environment** → boot via le **réseau** sans disque dur, clé USB ni CD. Nécessite DHCP + TFTP + image de boot.

---

### ❓ WSUS : en quoi ça aide la maintenance du parc ?

> [!success] Réponse
> **Centralise** la gestion et distribution des MAJ Windows. L'admin peut **approuver ou refuser** les MAJ, ou **tester** sur des petits groupes de tests.

---

# Questions orales — Entretien jury

---

### ❓ Qu'est-ce qu'un VPN ?

> [!success] Réponse
> Tunnel **chiffré** sur Internet pour accéder au réseau d'entreprise à distance de manière **sécurisée**.

---

### ❓ À quoi sert le DHCP ?

> [!success] Réponse
> Attribution **automatique** d'une configuration IP (adresse, masque, passerelle, DNS).

---

### ❓ Se connecter à distance sur une machine ?

> [!success] Réponse
> **RDP** (Windows), **SSH** (Linux), VNC, TeamViewer, AnyDesk.

---

### ❓ Câble bleu relié du PC au port console du switch ?

> [!success] Réponse
> **Câble console** (rollover/série) → administration locale du switch via **CLI** (PuTTY).

---

### ❓ Qu'est-ce qu'un proxy ?

> [!success] Réponse
> **Intermédiaire** entre clients et Internet → filtrage web, cache, anonymisation, sécurité, journalisation.

---

### ❓ Quel protocole utilise le VPN ?

> [!success] Réponse
> **IPSec**, OpenVPN, WireGuard, L2TP/IPSec. (PPTP = obsolète)

---

### ❓ Différence utilisateur AD vs local ?

> [!success] Réponse
> **AD** = stocké dans l'annuaire, se connecte sur **tout PC du domaine**.
> **Local** = stocké sur la machine (SAM), se connecte **uniquement sur cette machine**.

---

### ❓ Avantages d'un cluster d'hyperviseurs ?

> [!success] Réponse
> **HA**, tolérance de panne, répartition de charge, **migration à chaud**, gestion centralisée.

---

### ❓ À quoi sert WSUS ?

> [!success] Réponse
> Gestion **centralisée** des mises à jour Windows. Approuver/refuser les MAJ, économiser la bande passante.

---

### ❓ À quoi sert le pare-feu ?

> [!success] Réponse
> **Filtre le trafic** réseau entrant/sortant selon des règles. Protège le réseau interne des menaces.

---

### ❓ Bloquer un trafic inter-VLAN sur un switch ?

> [!success] Réponse
> Avec des **ACL** sur le switch L3 ou le routeur. Ou ne **pas configurer** de routage entre ces VLANs.

---

### ❓ VDI persistant vs non-persistant ?

> [!success] Réponse
> **Persistant** = bureau virtuel personnel, conserve les modifications entre sessions.
> **Non-persistant** = bureau **réinitialisé** à chaque connexion, image identique pour tous.

---

### ❓ Différence RTO vs RPO ?

> [!success] Réponse
> **RTO** = durée max d'**interruption** acceptable.
> **RPO** = quantité max de **données perdues** acceptable.

---

### ❓ Avantages/inconvénients des snapshots de VM ?

> [!success] Réponse
> ✅ Sauvegarde rapide, retour arrière facile, idéal avant MAJ/test.
> ❌ Consomment de l'espace disque, dégradent les performances, ==ne remplacent PAS une vraie sauvegarde==.

---

> [!warning] Rappel
> - Toujours utiliser le **vocabulaire technique** précis
> - Mentionner les **protocoles** et **ports** quand pertinent
> - Penser **sécurité** dans chaque réponse
> - Faire le lien avec le **dossier professionnel**
