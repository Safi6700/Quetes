

> [!warning] ⚠️ Définitions extraites directement de tes fiches de révision.

---

# 1. MODÈLE OSI — 7 couches

**Définition :** Modèle théorique en **7 couches** qui décrit les fonctions de communication réseau (norme ISO). Chaque couche ajoute son entête aux données → **Encapsulation** : Données → Segment → Paquet → Trame → Bits

```
Couche 7 : Application   → HTTP, HTTPS, FTP, SMTP, DNS, SSH
Couche 6 : Présentation  → TLS/SSL, JPEG (chiffrement, compression)
Couche 5 : Session       → NetBIOS, RPC, SMB
Couche 4 : Transport     → TCP (6), UDP (17) — Segment/Datagramme
Couche 3 : Réseau        → IP, ICMP, ARP, OSPF — Paquet
Couche 2 : Liaison       → Ethernet, Wi-Fi, MAC, CRC — Trame
Couche 1 : Physique      → câbles, signaux, bits
```

| Couche | Équipement | Adresse |
|--------|-----------|---------|
| L1 Physique | Hub, répéteur | Aucune |
| L2 Liaison | **Switch** | **MAC** |
| L3 Réseau | **Routeur** | **IP** |
| L4+ | Pare-feu | **Ports** |

**Mnémotechnique :** *"All People Seem To Need Data Processing"*

> [!success]- 🔓 C'est quoi le modèle OSI ?
> Modèle théorique en **7 couches** qui décrit les fonctions de communication réseau (norme ISO).

> [!success]- 🔓 Sur quelle couche travaille un Switch ? Un Routeur ?
> Switch = couche **2** (Liaison / MAC) — Routeur = couche **3** (Réseau / IP)

> [!success]- 🔓 C'est quoi l'encapsulation ?
> Chaque couche ajoute son entête : Données → Segment → Paquet → Trame → Bits

> [!success]- 🔓 Différence Hub et Switch ?
> Hub (L1) = répète à **tous** les ports. Switch (L2) = envoie uniquement au port ciblé (table MAC).

> [!success]- 🔓 C'est quoi le CRC ?
> Contrôle de Redondance Cyclique = détection d'erreurs en couche **2**. Détecte, ne corrige pas.

---

# 2. TCP vs UDP

| | **TCP** | **UDP** |
|--|---------|---------|
| **Protocole** | 6 | 17 |
| **Connexion** | Oui (3-way handshake) | Non |
| **Fiabilité** | Oui (accusés, retransmission) | Non |
| **Vitesse** | Plus lent | Plus rapide |
| **Entête** | 20 octets min | **8 octets** (4 champs) |
| **Usage** | HTTP, FTP, SMTP, SSH | DNS, DHCP, VoIP, streaming |

**3-way handshake TCP :**
```
Client → SYN      → Serveur
Client ← SYN-ACK  ← Serveur
Client → ACK      → Serveur  ✅ Connexion établie
```

**6 flags TCP :** SYN, ACK, FIN, RST, PSH, URG

**Fermeture TCP :** FIN → ACK → FIN → ACK (4 étapes)

> [!success]- 🔓 Différence TCP et UDP en une phrase ?
> TCP = fiable, connecté, 3-way handshake. UDP = rapide, sans connexion, sans garantie.

> [!success]- 🔓 C'est quoi le 3-way handshake ?
> SYN → SYN-ACK → ACK. Établissement de connexion TCP en 3 étapes.

> [!success]- 🔓 Cite les 6 flags TCP.
> SYN, ACK, FIN, RST, PSH, URG

> [!success]- 🔓 Taille de l'entête UDP ? Pourquoi si léger ?
> **8 octets** — 4 champs seulement : port src, port dst, longueur, checksum. Pas de handshake.

> [!success]- 🔓 Cite 3 protocoles qui utilisent UDP.
> DNS (53), DHCP (67/68), SIP (5060) — et aussi NTP (123), SNMP (161/162)

---

# 3. PORTS À CONNAÎTRE PAR CŒUR

| Port | Protocole | Service | TCP/UDP |
|------|-----------|---------|---------|
| 20/21 | FTP | Transfert fichiers | TCP |
| 22 | SSH/SFTP | Shell sécurisé | TCP |
| 23 | Telnet | Non sécurisé | TCP |
| 25 | SMTP | Envoi mail | TCP |
| 53 | DNS | Résolution noms | TCP+UDP |
| 67/68 | DHCP | Config IP auto | UDP |
| 80 | HTTP | Web | TCP |
| 110 | POP3 | Réception mail | TCP |
| 123 | NTP | Synchro temps | UDP |
| 143 | IMAP | Réception mail (sync) | TCP |
| 161/162 | SNMP | Supervision | UDP |
| 389 | LDAP | Annuaire AD | TCP |
| 443 | HTTPS | Web sécurisé | TCP |
| 445 | SMB | Partage Windows | TCP |
| 636 | LDAPS | LDAP sécurisé | TCP |
| 3389 | RDP | Bureau à distance | TCP |
| 5060 | SIP | VoIP | UDP |

> 🧠 **UDP uniquement :** DHCP(67/68), TFTP(69), NTP(123), SNMP(161/162), SIP(5060)
> *"Des Thés Nocturnes Sans Internet Protégé"*

---

# 4. DNS — Domain Name System

**Définition :** Service qui traduit les noms de domaine en adresses IP. Port **53 UDP** (TCP pour les transferts de zone).

**2 types de serveurs :** Faisant **autorité** (détient l'info officielle d'une zone) / **Résolveur** (interroge + met en cache selon le TTL)

**TTL** = durée de validité en cache. **ICANN/IANA** gère la racine / **AFNIC** gère le .fr

⚠️ Il y a **13 domaines** racine mais **+130 serveurs physiques** (anycast) — pas 13 serveurs !

**Enregistrements DNS :**

| Type | Rôle |
|------|------|
| **A** | Nom → IPv4 |
| **AAAA** | Nom → IPv6 |
| **CNAME** | Alias → autre nom |
| **MX** | Serveur mail du domaine |
| **NS** | Serveur faisant autorité |
| **PTR** | IP → Nom (résolution inverse) |
| **SOA** | Serveur primaire de zone |

**Résolution inverse :** `.in-addr.arpa` (IPv4) / `.ip6.arpa` (IPv6) — enregistrement **PTR**

**Commandes :** `dig domaine.com` (Linux) / `nslookup domaine.com` (Windows)

> [!success]- 🔓 C'est quoi le DNS ?
> Service qui traduit les noms de domaine en adresses IP. Port **53 UDP**.

> [!success]- 🔓 Différence serveur faisant autorité et résolveur ?
> Faisant autorité = détient l'info officielle d'une zone. Résolveur = interroge les serveurs + met en cache (TTL).

> [!success]- 🔓 C'est quoi un enregistrement MX ?
> Mail eXchange = indique le serveur de messagerie du domaine.

> [!success]- 🔓 DIAGNOSTIC : ping IP OK mais ping nom KO. Problème DNS ou réseau ?
> Problème **DNS**. Vérifier : résolveur configuré ? Serveur DNS joignable ?

> [!success]- 🔓 C'est quoi le TTL ?
> Time To Live = durée (en secondes) de validité d'un enregistrement en cache DNS.

---

# 5. DHCP — Dynamic Host Configuration Protocol

**Définition :** Attribution automatique de configuration IP (adresse, masque, passerelle, DNS). Ports **UDP 67** (serveur) et **UDP 68** (client). Le client s'identifie par son **adresse MAC**, IP source initiale = **0.0.0.0**.

**Processus DORA :**
```
D → Discover   : client cherche un serveur (broadcast)
O → Offer      : serveur propose une IP
R → Request    : client accepte (broadcast)
A → Acknowledge: serveur confirme le bail
```

| Message     | Rôle                             |
| ----------- | -------------------------------- |
| **NACK**    | Serveur refuse                   |
| **DECLINE** | Client refuse (IP déjà utilisée) |
| **RELEASE** | Client rend son bail             |

**IP APIPA** : 169.254.x.x = pas de DHCP → **DHCP KO !**

**DHCP Relay (ip-helper)** = nécessaire pour traverser les routeurs/VLANs

**Commandes :** `ipconfig /release` + `/renew` (Windows) / `dhclient -r` + `dhclient` (Linux)

> [!success]- 🔓 C'est quoi DORA ?
> Discover → Offer → Request → Acknowledge. Séquence d'obtention d'une IP en DHCP.

> [!success]- 🔓 Quels ports utilise DHCP ?
> **UDP 67** (serveur) et **UDP 68** (client).

> [!success]- 🔓 Un client a l'IP 169.254.x.x. Que s'est-il passé ?
> Pas de serveur DHCP trouvé → le client s'est auto-attribué une adresse **APIPA**. DHCP KO.

> [!success]- 🔓 Différence RELEASE et DECLINE ?
> RELEASE = client rend son bail volontairement. DECLINE = client refuse l'IP (déjà utilisée).

> [!success]- 🔓 Pourquoi DISCOVER est envoyé en broadcast ?
> Le client n'a pas encore d'IP valide (src = 0.0.0.0) → ne peut pas faire d'unicast.

---

# 6. VLAN — Virtual Local Area Network

**Définition :** Séparer un réseau physique en plusieurs réseaux logiques isolés sur un même switch, pour la sécurité et la performance.

| Terme                 | Définition                                                                 |
| --------------------- | -------------------------------------------------------------------------- |
| **Access port**       | 1 seul VLAN — pour connecter un appareil                                   |
| **Trunk**             | Plusieurs VLANs (802.1Q) — entre switchs ou switch↔routeur                 |
| **Router on a Stick** | 1 routeur + 1 trunk + sous-interfaces (g0/0.10…) — encapsulation **dot1q** |
| **DHCP Relay**        | Relaye les requêtes DHCP entre VLANs                                       |

> ⚠️ **Trame routée : la MAC destination change à chaque saut, l'IP destination reste la même**

> [!success]- 🔓 C'est quoi un VLAN ?
> Segmentation logique d'un switch en plusieurs réseaux isolés sans séparation physique.

> [!success]- 🔓 Différence port Access et port Trunk ?
> Access = 1 seul VLAN (pour un appareil). Trunk = plusieurs VLANs (802.1Q), entre switchs ou switch↔routeur.

> [!success]- 🔓 C'est quoi le Router on a Stick ?
> Routage inter-VLAN : 1 routeur + 1 lien trunk + sous-interfaces (une par VLAN, encapsulation dot1q).

> [!success]- 🔓 Dans une trame routée, que devient la MAC ? Et l'IP ?
> MAC = change à chaque saut (= MAC du routeur). IP destination = ne change jamais.

> [!success]- 🔓 Pourquoi a-t-on besoin d'un DHCP Relay en environnement VLAN ?
> Le broadcast DHCP ne traverse pas les routeurs. Le relay (ip-helper) transmet les requêtes au serveur DHCP.

---

# 7. ACTIVE DIRECTORY

**Définition :** Annuaire Microsoft pour **gérer les utilisateurs, ordinateurs et ressources** d'un réseau Windows. Basé sur **LDAP** = base de données hiérarchique (en arbre).

**Fil directeur :** DNS trouve le DC → Kerberos authentifie → AD regarde ton OU → GPO s'appliquent.

| Terme | Définition |
|-------|------------|
| **AD DS** | Service qui stocke et gère l'annuaire |
| **DC** | Contrôleur de domaine — authentifie les users. Si HS → domaine inutilisable |
| **RODC** | DC en lecture seule — pour sites distants |
| **OU** | Dossier pour organiser les objets + appliquer des GPO |
| **GPO** | Stratégie de groupe appliquée aux OU/users |
| **Catalogue Global** | Annuaire de toute la forêt. 1er DC créé = CG automatiquement |

**Structure :** Objet → OU → Domaine → Arbre → Forêt

**AGDLP :**
```
Utilisateurs → Groupes Globaux (GRP_) → Groupes Domain Local (DL_) → Permissions NTFS
```

**GPO — Ordre LSDOU :** Local → Site → Domaine → OU *(la dernière gagne)*

> ⚠️ **OU ≠ Groupe** : OU = organiser + GPO / Groupe = donner des permissions

> [!success]- 🔓 C'est quoi Active Directory ?
> Annuaire Microsoft pour gérer les utilisateurs, ordinateurs et ressources d'un réseau Windows.

> [!success]- 🔓 C'est quoi un DC ? Que se passe-t-il s'il tombe ?
> Serveur qui contient l'annuaire AD et authentifie les utilisateurs. Si HS → domaine **inutilisable**.

> [!success]- 🔓 Explique AGDLP en une phrase.
> Utilisateurs dans groupes Globaux (GRP_) → dans groupes Domain Local (DL_) → qui reçoivent les permissions NTFS.

> [!success]- 🔓 Différence OU et Groupe ?
> OU = organiser + appliquer des GPO. Groupe = donner des permissions.

> [!success]- 🔓 C'est quoi l'ordre LSDOU ?
> Local → Site → Domaine → OU. Ordre d'application des GPO. La dernière appliquée gagne.

---

# 8. RAID

**Définition :** Technique pour combiner plusieurs disques en un seul volume (performance et/ou fiabilité).

| RAID | Principe | Disques min | Tolérance | Capacité |
|------|---------|-------------|-----------|---------|
| **0** | Striping | 2 | ❌ Aucune | n × disque |
| **1** | Miroir | 2 | ✅ n-1 pannes | 1 × disque |
| **5** | Parité répartie | 3 | ✅ 1 panne | (n-1) × disque |
| **6** | Double parité | 4 | ✅ 2 pannes | (n-2) × disque |
| **10** | Miroir + Striping | 4 | ✅ 1 par grappe | n/2 × disque |

**Hot spare** = disque de secours pour reconstruction automatique.

> ⚠️ **RAID ≠ Sauvegarde** : protège la panne disque, PAS la suppression, virus ou incendie !

> [!success]- 🔓 C'est quoi le RAID ?
> Technique pour combiner plusieurs disques : performance (RAID 0) et/ou fiabilité (RAID 1, 5, 6).

> [!success]- 🔓 Différence RAID 0 et RAID 1 ?
> RAID 0 = striping, performance, aucune tolérance panne. RAID 1 = miroir, tolère n-1 pannes.

> [!success]- 🔓 Quel RAID pour tolérer 2 pannes simultanées ?
> **RAID 6** (double parité, 4 disques minimum).

> [!success]- 🔓 RAID remplace-t-il les sauvegardes ?
> **Non.** RAID protège contre la panne disque, pas contre la suppression, virus ou incendie.

> [!success]- 🔓 Combien de disques minimum pour RAID 5 ? Et RAID 10 ?
> RAID 5 = **3 disques**. RAID 10 = **4 disques**.

---

# 9. LVM — Logical Volume Manager

**Définition :** Méthode et logiciel de gestion des disques Linux permettant de créer des volumes logiques **flexibles et redimensionnables à chaud**.

```
Disque physique → PV → VG → LV → Système de fichiers → Point de montage
```

```bash
pvcreate /dev/sdb                      # Créer un PV
vgcreate monvg /dev/sdb                # Créer un VG
lvcreate -L 10G -n monlv monvg         # Créer un LV
lvextend -L +5G /dev/monvg/monlv       # Agrandir
pvs / vgs / lvs                        # Afficher
```

> ⚠️ Toujours faire `resize2fs` APRÈS `lvextend` — sinon le FS ne voit pas l'espace supplémentaire !

> [!success]- 🔓 C'est quoi LVM ?
> Méthode et logiciel de gestion des disques Linux — volumes flexibles et redimensionnables à chaud.

> [!success]- 🔓 Quel est l'ordre à respecter en LVM ?
> PV → VG → LV → Système de fichiers → Montage. Toujours dans cet ordre.

> [!success]- 🔓 Après un lvextend, quelle commande est obligatoire ?
> `resize2fs` — pour étendre le système de fichiers après l'extension du LV.

> [!success]- 🔓 Différence NAS et SAN ?
> NAS = partage de **fichiers** (NFS/SMB) sur LAN classique. SAN = accès aux **blocs** (iSCSI), réseau dédié.

---

# 10. DMZ — DeMilitarized Zone

**Définition :** Zone réseau pour les serveurs **accessibles depuis Internet** (web, mail…), isolée du LAN interne.

```
Internet ←→ [Pare-feu] ←→ DMZ (Apache, Mail...) ←→ [Pare-feu] ←→ LAN interne
```

- Les serveurs DMZ **ne peuvent pas initier** de connexions vers le LAN interne
- Si un serveur DMZ est compromis → le LAN reste protégé

> [!success]- 🔓 C'est quoi une DMZ ?
> Zone réseau pour les serveurs accessibles depuis Internet, isolée du LAN interne.

> [!success]- 🔓 Pourquoi les serveurs DMZ ne peuvent pas contacter le LAN interne ?
> Pour que si un serveur DMZ est compromis, l'attaquant ne puisse pas rebondir vers le réseau interne.

> [!success]- 🔓 Cite les étapes pour sécuriser un serveur web depuis Internet.
> DMZ + port forwarding HTTPS (443) + autoriser uniquement HTTPS Internet→DMZ + bloquer Internet→LAN + certificat TLS.

---

# 11. NAT — Network Address Translation

**Définition :** Traduction d'adresses IP privées en adresses IP publiques — **IPv4 uniquement**. Existe à cause de la **pénurie d'adresses IPv4**.

| Type | Définition | Sens |
|------|-----------|------|
| **PAT/NAPT** | IP + port → plusieurs machines via 1 IP publique | Sortie Internet |
| **SNAT** | Change l'**IP source** | Sortie Internet |
| **DNAT** | Change l'**IP destination** | Publication de services |
| **NAT 1:1** | 1 IP privée ↔ 1 IP publique dédiée (bidirectionnel) | Serveur exposé |
| **Port forwarding** | Redirige un port public vers une machine interne | DNAT par port |

> ⚠️ NAT = **IPv4 uniquement**. IPv6 a assez d'adresses → pas besoin de NAT.

> [!success]- 🔓 C'est quoi le NAT ?
> Traduction d'adresses IP privées en publiques — IPv4 uniquement. Permet à plusieurs machines d'accéder à Internet via 1 IP publique.

> [!success]- 🔓 Différence SNAT et DNAT ?
> SNAT = traduit l'IP **source** (sortie Internet). DNAT = traduit l'IP **destination** (publication de services).

> [!success]- 🔓 C'est quoi PAT/NAPT ?
> Traduction IP + port → plusieurs machines internes via 1 seule IP publique. Les ports différencient les connexions.

> [!success]- 🔓 Pourquoi le NAT existe ?
> Pénurie d'adresses IPv4 — pas assez d'IP publiques pour toutes les machines.

---

# 12. FIREWALL / PARE-FEU

**Définition :** Équipement ou logiciel qui **filtre le trafic** réseau entrant et sortant selon des règles.

| Type | En bref |
|------|---------|
| **Stateless** | Sans mémoire — chaque paquet traité seul |
| **Stateful** | Avec mémoire — suit les connexions, réponses auto-autorisées |
| **DPI** | Inspecte le **contenu** (impossible si chiffré) |
| **WAF** | Pare-feu applicatif spécialisé **HTTP** |

**Actions :** ACCEPT / **DROP** (silencieux) / **REJECT** (répond)

**Politique :** Tout bloquer → autoriser uniquement ce qui est nécessaire.

**ACL Cisco :**
```
access-list <n°> <permit|deny> <proto> <src> <wildcard> <dst> <wildcard> [eq <port>]
```
> ⚠️ Wildcard = masque **inversé** : /24 → 0.0.0.255
> ⚠️ Règles lues **de haut en bas**. Toujours finir par `permit ip any any`.

> [!success]- 🔓 Différence Stateless et Stateful ?
> Stateless = sans mémoire, chaque paquet traité seul. Stateful = avec mémoire, suit les connexions et autorise automatiquement les réponses.

> [!success]- 🔓 Différence DROP et REJECT ?
> DROP = refuse sans répondre (silencieux). REJECT = refuse et envoie une notification.

> [!success]- 🔓 C'est quoi un wildcard mask ?
> Masque inversé : /24 (255.255.255.0) → wildcard **0.0.0.255**.

> [!success]- 🔓 Quelle politique de filtrage est recommandée ?
> Tout bloquer (deny all) puis autoriser uniquement ce qui est nécessaire.

> [!success]- 🔓 C'est quoi un WAF ?
> Web Application Firewall = pare-feu applicatif spécialisé dans le protocole HTTP.

---

# 13. VPN — Virtual Private Network

**Définition :** Tunnel **chiffré** pour se connecter à un réseau distant de façon sécurisée sur un réseau non sécurisé (Internet).

| Type | Description |
|------|-------------|
| **Site-à-site** | Relie 2 réseaux — permanent, transparent pour les users |
| **Nomade** | 1 utilisateur → réseau entreprise (télétravail) |

| Protocole | Particularité |
|-----------|---------------|
| **IPsec** | Couche 3. AH = intégrité / ESP = intégrité + **chiffrement** |
| **OpenVPN** | Basé sur TLS, port **1194** UDP/TCP |
| **WireGuard** | Léger, rapide, moderne |

**IPsec :** mode **tunnel** (protège tout le paquet) / mode **transport** (protège les données uniquement)

> ⚠️ VPN ≠ 100% sécurisé — ouvre une brèche entre 2 réseaux.

> [!success]- 🔓 C'est quoi un VPN ?
> Tunnel chiffré pour se connecter à un réseau distant de façon sécurisée.

> [!success]- 🔓 Différence VPN site-à-site et nomade ?
> Site-à-site = relie 2 réseaux (permanent). Nomade = 1 utilisateur se connecte au réseau entreprise.

> [!success]- 🔓 Différence mode tunnel et mode transport (IPsec) ?
> Tunnel = protège tout le paquet (site-à-site). Transport = protège les données uniquement.

> [!success]- 🔓 Quel port utilise OpenVPN ?
> Port **1194** UDP (ou TCP).

---

# 14. SSH — Se Shell

**Définition :** Protocole de connexion à distance **sécurisé** qui remplace Telnet. Port **TCP 22**. Garantit : Confidentialité + Intégrité (HMAC) + Authentification.

**TOFU** (Trust On First Use) = 1ère connexion → accepter l'empreinte du serveur → stockée dans `~/.ssh/known_hosts`

| Fichier | Rôle |
|---------|------|
| `~/.ssh/known_hosts` | Clés publiques des **serveurs** connus |
| `~/.ssh/authorized_keys` | Clés publiques des **clients** autorisés |
| `~/.ssh/id_ed25519` | Clé **privée** utilisateur |
| `/etc/ssh/sshd_config` | Config **serveur** SSH |

```bash
ssh-keygen -t ed25519      # Générer une paire de clés
ssh-copy-id user@IP        # Copier la clé publique vers un serveur Linux
ssh -p 2222 user@IP        # Connexion port personnalisé
```

> ⚠️ `known_hosts` = clés des SERVEURS / `authorized_keys` = clés des CLIENTS (ne pas confondre !)

> [!success]- 🔓 Quel port utilise SSH ?
> Port **TCP 22**.

> [!success]- 🔓 C'est quoi TOFU ?
> Trust On First Use — à la 1ère connexion, on accepte l'empreinte du serveur → stockée dans `~/.ssh/known_hosts`.

> [!success]- 🔓 Différence known_hosts et authorized_keys ?
> `known_hosts` = clés publiques des **serveurs** connus. `authorized_keys` = clés publiques des **clients** autorisés.

> [!success]- 🔓 Quelle commande pour copier sa clé publique sur un serveur Linux ?
> `ssh-copy-id user@IP`

---

# 15. CRYPTOGRAPHIE

**Symétrique** = 1 seule clé pour chiffrer ET déchiffrer — rapide, partage de clé difficile (AES, DES)

**Asymétrique** = 2 clés : **publique** (chiffre) + **privée** (déchiffre) — lent, échange sécurisé (RSA, ECC)

**Hachage** = empreinte **unique et irréversible** — taille fixe quelle que soit l'entrée (MD5, SHA256)

**Hybride** = asymétrique pour échanger la clé + symétrique pour chiffrer → c'est **TLS/SSL**

**Signature numérique** = hachage + chiffrement asymétrique → **authentification + intégrité**

> [!success]- 🔓 Différence chiffrement symétrique et asymétrique ?
> Symétrique = 1 seule clé (rapide, partage difficile). Asymétrique = paire publique/privée (lent, échange sécurisé).

> [!success]- 🔓 C'est quoi le hachage ?
> Empreinte unique et irréversible d'un message, taille fixe quelle que soit l'entrée.

> [!success]- 🔓 Comment fonctionne TLS/SSL ?
> Hybride : asymétrique pour échanger la clé de session + symétrique pour chiffrer les données.

> [!success]- 🔓 C'est quoi une signature numérique ?
> Hachage + chiffrement asymétrique → garantit authentification et intégrité du message.

---

# 16. CYBERSÉCURITÉ — D.I.C.P

**Sécurité** = protection contre actions **malveillantes** / **Sûreté** = protection contre **accidents**

| Pilier | Description | Exemple d'atteinte |
|--------|-------------|-------------------|
| **D**isponibilité | Service accessible quand nécessaire | DDoS |
| **I**ntégrité | Données exactes et non modifiées | Modification fichiers |
| **C**onfidentialité | Accès réservé aux autorisés | Vol de données |
| **P**reuve | Prouver qui a fait quoi | Logs effacés |

**Chaîne de risque :** Vulnérabilité → Menace → Attaque

**PSSI** = Politique de Sécurité du SI, établie par le **RSSI**

**Phishing** = faux mail/site pour voler identifiants / **Spear Phishing** = phishing ciblé

> [!success]- 🔓 C'est quoi le DICP ?
> Les 4 piliers : Disponibilité, Intégrité, Confidentialité, Preuve (Traçabilité).

> [!success]- 🔓 Différence vulnérabilité, menace et attaque ?
> Vulnérabilité = faiblesse. Menace = cause potentielle. Attaque = action malveillante concrète.

> [!success]- 🔓 C'est quoi le spear phishing ?
> Phishing ciblé sur une personne ou entreprise précise (≠ phishing de masse).

> [!success]- 🔓 C'est quoi la PSSI ?
> Politique de Sécurité du SI — établie par le RSSI, définit les règles de sécurité de l'entreprise.

---

# 17. IDS / IPS

**IDS** = **détecte** les intrusions et **alerte** — passif, ne bloque pas

**IPS** = **détecte ET bloque** — actif, en coupure

**NIDS/NIPS** = surveillance **réseau** / **HIDS/HIPS** = surveillance **machine**

| | IDS | IPS |
|--|-----|-----|
| **Mode** | Passif (écoute) | Actif (en coupure) |
| **Bloque ?** | Non | Oui |

**Méthodes :** signature / anomalie / politique / réputation

> ⚠️ NIDS ne fonctionne pas sur trafic **chiffré** → HIDS prend le relais

> [!success]- 🔓 Différence IDS et IPS ?
> IDS = détecte et alerte (passif). IPS = détecte ET bloque (actif, en coupure).

> [!success]- 🔓 Différence NIDS et HIDS ?
> NIDS = surveille le **réseau**. HIDS = surveille une **machine** (hôte).

> [!success]- 🔓 Pourquoi un NIDS ne peut pas analyser le trafic HTTPS ?
> HTTPS est chiffré → le NIDS ne peut pas lire le contenu. Le HIDS peut car il est sur la machine.

> [!success]- 🔓 C'est quoi la détection par anomalie ?
> Établir une ligne de base du trafic normal → alerter si écart. Détecte les nouvelles attaques mais peut générer des faux positifs.

---

# 18. SÉCURISER LES SYSTÈMES (Hardening)

**Défense en profondeur** = multiplier les barrières — le firewall seul ne suffit pas

**Minimisation** = ne garder que les services strictement nécessaires → réduit la surface d'attaque

**Hardening** = la config par défaut n'est pas sécurisée → appliquer les recommandations ANSSI/éditeur

**Moindre privilège** = donner uniquement les droits nécessaires

**TPM** = puce pour stockage sécurisé de clés cryptographiques

**MFA** = authentification multi-facteur — obligatoire pour les comptes admin

> [!success]- 🔓 C'est quoi la défense en profondeur ?
> Multiplier les barrières de sécurité — le firewall seul ne suffit pas.

> [!success]- 🔓 C'est quoi le principe de minimisation ?
> Ne garder que les composants et services strictement nécessaires → réduire la surface d'attaque.

> [!success]- 🔓 C'est quoi le MFA ?
> Authentification Multi-Facteur — combinaison de plusieurs facteurs d'identification.

> [!success]- 🔓 C'est quoi le Tiering Model ?
> Modèle de sécurité en 3 niveaux séparés : T0 (DC), T1 (serveurs), T2 (postes utilisateurs).

---

# 19. IPv4

**IPv4** = adresse sur **32 bits**, notation décimale pointée. **Nb hôtes = 2^(32-CIDR) - 2**

**Plages privées RFC 1918 :** 10.0.0.0/8 — 172.16.0.0/12 — 192.168.0.0/16

**127.0.0.0/8** = loopback / **169.254.0.0/16** = APIPA

| CIDR | Nb hôtes |
|------|---------|
| /24 | 254 |
| /25 | 126 |
| /30 | 2 |

> [!success]- 🔓 Sur combien de bits est codée une adresse IPv4 ?
> **32 bits**, notation décimale pointée.

> [!success]- 🔓 Cite les 3 plages privées RFC 1918.
> 10.0.0.0/8 — 172.16.0.0/12 — 192.168.0.0/16

> [!success]- 🔓 Combien d'hôtes sur un /24 ?
> 2^8 - 2 = **254 hôtes**.

> [!success]- 🔓 C'est quoi l'adresse 127.0.0.1 ?
> Adresse de **loopback** — la machine se parle à elle-même.

---

# 20. IPv6

**IPv6** = adresse sur **128 bits**. **Pas de Broadcast.** 3 types : Unicast / Multicast / Anycast

| Type | Préfixe | Routable ? |
|------|---------|-----------|
| **Global Unicast** | 2000::/3 | ✅ Internet |
| **Unique Local** | fd00::/8 | ✅ Interne |
| **Link-Local** | fe80::/10 | ❌ NON routable |
| Loopback | ::1/128 | — |

**SLAAC** = autoconfiguration sans DHCP grâce aux **RA** (Router Advertisement) du routeur

> [!success]- 🔓 Sur combien de bits est une adresse IPv6 ?
> **128 bits**.

> [!success]- 🔓 Cite les 3 types d'adresses IPv6.
> Unicast, Multicast, Anycast — **pas de Broadcast**.

> [!success]- 🔓 C'est quoi une adresse fe80:: ?
> Adresse **Link-Local** — auto-configurée, **non routable**, ne passe jamais un routeur.

> [!success]- 🔓 C'est quoi SLAAC ?
> Autoconfiguration IPv6 sans DHCP — le routeur envoie des **RA** avec le préfixe réseau.

---

# 21. ETHERNET

**Ethernet** = protocole de la **couche 2** — norme IEEE 802.3

**Adresse MAC** = 48 bits (6 octets). 3 premiers octets = **OUI** (fabricant). Broadcast = FF:FF:FF:FF:FF:FF

**Trame :** MAC dst + MAC src + EtherType + Données + **FCS** (CRC = détection d'erreurs)

> [!success]- 🔓 Sur combien de bits est une adresse MAC ?
> **48 bits** (6 octets). Les 3 premiers = OUI (identifiant fabricant).

> [!success]- 🔓 C'est quoi le FCS ?
> Frame Check Sequence = champ CRC pour la **détection d'erreurs** en couche 2.

> [!success]- 🔓 Quelle est l'adresse MAC de broadcast ?
> **FF:FF:FF:FF:FF:FF**

---

# 22. VoIP / ToIP

**VoIP** = transmettre la voix sur IP (la technologie)

**ToIP** = téléphonie d'entreprise complète sur IP (l'infrastructure). La ToIP **s'appuie sur** la VoIP.

**PABX** = autocommutateur RTC (ancien) / **IPBX** = autocommutateur IP (moderne, ex: FreePBX)

**SIP** = protocole de **signalisation** des appels, port **5060** (5061 TLS)

**RTP** = transporte le **flux voix/vidéo** après l'établissement SIP

> [!success]- 🔓 Différence VoIP et ToIP ?
> VoIP = transmettre la voix sur IP (la techno). ToIP = téléphonie d'entreprise complète sur IP (l'infrastructure).

> [!success]- 🔓 C'est quoi SIP ? Quel port ?
> Session Initiation Protocol = protocole de signalisation des appels. Port **5060**.

> [!success]- 🔓 Différence PABX et IPBX ?
> PABX = autocommutateur RTC (ancien). IPBX = autocommutateur IP (moderne).

> [!success]- 🔓 À quoi sert RTP ?
> Transporte le **flux voix/vidéo** une fois la communication établie par SIP.

---

# 23. RADIUS

**Définition :** Protocole **AAA** qui centralise l'authentification, les droits d'accès et la traçabilité des utilisateurs sur un réseau (Wifi, filaire, VPN).

**AAA :** Authentication / Authorization / Accounting

**Ports :** 1812/UDP (auth) + 1813/UDP (traçabilité)

**3 acteurs :** Client → **NAS** (point d'entrée réseau) → **Serveur RADIUS**

| Message | Rôle |
|---------|------|
| Access-Request | Demande d'auth |
| Access-Accept | Accès autorisé |
| Access-Reject | Accès refusé |

> [!success]- 🔓 C'est quoi RADIUS ?
> Protocole AAA qui centralise l'authentification, les droits et la traçabilité des utilisateurs réseau.

> [!success]- 🔓 Que signifie AAA ?
> Authentication / Authorization / Accounting (traçabilité).

> [!success]- 🔓 Quels ports utilise RADIUS ?
> **1812/UDP** (authentification) et **1813/UDP** (traçabilité).

> [!success]- 🔓 C'est quoi un NAS dans RADIUS ?
> Network Access Server = point d'entrée réseau (borne Wifi, switch 802.1X, VPN) qui relaie l'auth vers le serveur RADIUS.

---

# 24. CLOUD & VIRTUALISATION

**Cloud Computing** = fournir des services informatiques via le réseau.

| Modèle | Qui gère l'OS ? | Exemple |
|--------|----------------|---------|
| **IaaS** | Le **client** | AWS, Azure |
| **PaaS** | Le **fournisseur** | Heroku |
| **SaaS** | Le **fournisseur** (tout) | Office 365, Gmail |

**3 déploiements :** Public (partagé) / Privé (dédié) / Hybride

**Type 1** (bare metal) = directement sur le matériel → performances (ESXi, Proxmox, KVM)

**Type 2** (hébergé) = sur un OS existant → plus simple (VirtualBox, VMware Workstation)

**Cluster** = plusieurs serveurs physiques → haute disponibilité + migration à chaud

> [!success]- 🔓 Différence IaaS, PaaS et SaaS ?
> IaaS = client gère l'OS. PaaS = fournisseur gère matériel+OS. SaaS = fournisseur gère tout.

> [!success]- 🔓 Différence hyperviseur Type 1 et Type 2 ?
> Type 1 = bare metal, directement sur le matériel (performances). Type 2 = sur un OS existant (plus simple).

> [!success]- 🔓 C'est quoi un cluster d'hyperviseurs ?
> Regroupement de plusieurs serveurs physiques → haute disponibilité + migration à chaud des VM.

---

# 25. DOCKER / CONTENEURS

**Conteneur** = environnement **isolé** exécutant une application avec ses dépendances — plus léger qu'une VM

**Docker** = conteneurisation **applicative** / **LXC** = conteneurisation **système**

| | VM | Conteneur |
|--|----|-----------|
| **Poids** | Lourd (Go) | Léger (Mo) |
| **Démarrage** | Minutes | Secondes |
| **Isolation** | OS complet | Partage le noyau hôte |

**Image** = modèle figé / **Dockerfile** = instructions de build / **Volume** = stockage persistant

> [!success]- 🔓 Différence VM et conteneur ?
> VM = OS complet, lourd, minutes pour démarrer. Conteneur = partage le noyau, léger (Mo), secondes.

> [!success]- 🔓 C'est quoi une image Docker ?
> Modèle figé et immuable servant à créer un conteneur.

> [!success]- 🔓 Pourquoi utiliser un volume Docker ?
> Pour que les données persistent même si le conteneur est supprimé.

> [!success]- 🔓 Différence Docker et LXC ?
> Docker = conteneurisation **applicative** (1 processus). LXC = conteneurisation **système** (ressemble à une VM complète).

---

# 26. SAUVEGARDE

**Sauvegarde** = copie des données pour récupérer en cas d'incident

**Archivage** = conserver des données dont on n'a plus besoin maintenant (≠ sauvegarde)

**Règle 3-2-1** = **3** copies, **2** supports différents, **1** copie hors-site

| Type | Principe | Restauration |
|------|---------|-------------|
| **Complète** | Copie TOUT | Simple |
| **Incrémentale** | Modifs depuis la **dernière sauvegarde** | Complexe |
| **Différentielle** | Modifs depuis la **dernière complète** | Moyenne |

**PRA** = Plan de Reprise d'Activité → **reprendre** après un sinistre

**PCA** = Plan de Continuité d'Activité → **maintenir** l'activité **pendant** un sinistre

> [!success]- 🔓 Différence sauvegarde et archivage ?
> Sauvegarde = copie pour récupérer en cas d'incident. Archivage = conserver des données dont on n'a plus besoin maintenant.

> [!success]- 🔓 C'est quoi la règle 3-2-1 ?
> 3 copies, 2 supports différents, 1 copie hors-site.

> [!success]- 🔓 Différence incrémentale et différentielle ?
> Incrémentale = modifs depuis la **dernière sauvegarde**. Différentielle = modifs depuis la **dernière complète**.

> [!success]- 🔓 Différence PRA et PCA ?
> PRA = reprendre l'activité **après** un sinistre. PCA = maintenir l'activité **pendant** un sinistre.

---

# 27. ITIL / GESTION DES INCIDENTS

**ITIL** = méthode de **bonnes pratiques** pour gérer les services informatiques

**Incident** = événement imprévu qui **perturbe** le SI — c'est l'**EFFET**

**Problème** = la **cause** d'un ou plusieurs incidents

**SLA** = contrat définissant les délais et niveaux de service

**CMDB** = base de données recensant tous les équipements et leur configuration

**GLPI** = parc + helpdesk (gestion **passive**) / **MDM** = gestion **active** des mobiles

> [!success]- 🔓 Différence incident et problème (ITIL) ?
> Incident = l'EFFET (ce que l'utilisateur voit). Problème = la CAUSE racine.

> [!success]- 🔓 C'est quoi un SLA ?
> Contrat qui définit les délais et niveaux de service garantis.

> [!success]- 🔓 C'est quoi la CMDB ?
> Base de données qui recense tous les équipements du parc et leur configuration.

> [!success]- 🔓 Différence GLPI et MDM ?
> GLPI = gestion **passive** (inventaire, tickets). MDM = gestion **active** des mobiles (déployer, verrouiller, effacer).

---

# 28. WSUS / GESTION DES MAJ

**WSUS** = centralise et contrôle le déploiement des **MAJ Microsoft** sur le parc

**Avantages :** contrôle avant déploiement + économie bande passante + rapports de conformité

**3 statuts :** Non-approuvée / **Approuvée** / Refusée

**Patch Tuesday** = correctifs Microsoft publiés le **2ème mardi de chaque mois**

**3 niveaux :** Mineure / Majeure / **Critique** (failles de sécurité — obligatoire)

> [!success]- 🔓 C'est quoi WSUS ?
> Rôle Windows Server pour centraliser et contrôler le déploiement des MAJ Microsoft sur le parc.

> [!success]- 🔓 Pourquoi utiliser WSUS ?
> Pour contrôler les MAJ avant déploiement, économiser la bande passante et éviter les redémarrages intempestifs.

> [!success]- 🔓 C'est quoi le Patch Tuesday ?
> Publication mensuelle des correctifs Microsoft le **2ème mardi de chaque mois**.

> [!success]- 🔓 Différence MAJ critique et majeure ?
> Critique = obligatoire, correctif de faille de sécurité. Majeure = prioritaire, nouvelles fonctionnalités.

---

# 29. JOURNALISATION / SUPERVISION

**Journalisation** = enregistrement des traces d'activité → **logs**

**Syslog** = standard Linux — port **514/UDP** (6514/TCP TLS). Daemon = **rsyslog**, fichiers dans `/var/log/`

**journalctl** = outil de consultation des journaux **systemd**

**Observateur d'événements** (Windows) = `eventvwr`. Centralisation via **WEF** (port 5985/5986)

**Supervision** = surveillance du SI pour assurer le **MCO** (Maintien en Condition Opérationnelle)

**SNMP :** GET (interroger) / SET (modifier) / TRAP (alerte de l'équipement)

**MIB** = base d'infos supervisables sur chaque équipement. Chaque info = un **OID**

> [!success]- 🔓 C'est quoi la journalisation ?
> Enregistrement des traces d'activité des applications et de l'OS → journaux (logs).

> [!success]- 🔓 Quel daemon gère les logs sur Linux ? Où sont-ils ?
> **rsyslog** — fichiers dans `/var/log/`.

> [!success]- 🔓 Les 3 opérations SNMP ?
> GET (interroger) / SET (modifier) / TRAP (alerte envoyée par l'équipement).

> [!success]- 🔓 C'est quoi le MCO ?
> Maintien en Condition Opérationnelle — garantir le bon fonctionnement du SI en continu.

---

# 30. UTILISATEURS LINUX

**UID** = identifiant utilisateur / **GID** = identifiant groupe / **root = UID 0**

**Fichiers clés :** `/etc/passwd` (infos users, lisible par tous) / `/etc/shadow` (mots de passe chiffrés, root only) / `/etc/group`

**Droits rwx :** r=4, w=2, x=1 — pour **u**ser / **g**roup / **o**thers

`chmod 755` = rwxr-xr-x / `chown user:groupe fichier` = changer propriétaire

> [!success]- 🔓 Quel est l'UID de root ?
> **UID 0** — toujours.

> [!success]- 🔓 Différence /etc/passwd et /etc/shadow ?
> `/etc/passwd` = infos users, lisible par tous. `/etc/shadow` = mots de passe chiffrés, root uniquement.

> [!success]- 🔓 Que signifie chmod 755 ?
> rwxr-xr-x — propriétaire : tout / groupe et autres : lecture + exécution.

> [!success]- 🔓 Quelle commande pour ajouter un user à un groupe Linux ?
> `usermod -aG groupe user`

---

# 31. UTILISATEURS WINDOWS

**SID** = Security Identifier — identifiant unique d'un utilisateur/groupe

**RID** = partie finale du SID — **500** = Administrateur / **501** = Invité

**SAM** = base des comptes locaux (`%SystemRoot%\system32\Config\SAM`)

**Droits NTFS :** FullControl, Modify, ReadAndExecute, Read, Write

> ⚠️ **Deny prioritaire sur Allow** — même avec Allow FullControl, un Deny bloque l'accès !

> [!success]- 🔓 C'est quoi un SID ?
> Security Identifier = identifiant unique d'un utilisateur ou groupe dans Windows.

> [!success]- 🔓 Quel RID correspond au compte Administrateur ?
> **RID 500**.

> [!success]- 🔓 Deny vs Allow NTFS — lequel gagne ?
> **Deny** est toujours prioritaire sur Allow.

> [!success]- 🔓 C'est quoi la base SAM ?
> Security Account Manager = base de données des comptes **locaux** Windows.

---

# 32. DÉPLOIEMENT WINDOWS

**WDS** = Windows Deployment Services — déploie Windows via le réseau par **PXE**

**PXE** = démarrage réseau : DHCP → TFTP → image OS

**MDT** = Microsoft Deployment Toolkit — outil **gratuit** de déploiement par séquences de tâches

**Sysprep** = "rescelle" une image avant capture : `sysprep.exe /oobe /generalize /shutdown`

⚠️ Après un Sysprep, **ne pas rallumer le PC !**

**WIM** = format d'image disque Microsoft (.wim) — indépendant du matériel

| Image | Contenu |
|-------|---------|
| **Thin** | OS uniquement |
| **Thick** | OS + tous les logiciels |
| **Hybrid** | OS + logiciels de base |

> [!success]- 🔓 C'est quoi PXE ?
> Preboot Execution Environment = démarrage réseau. Séquence : DHCP → TFTP → image OS.

> [!success]- 🔓 C'est quoi Sysprep ?
> Outil pour "resceller" une image Windows avant capture — retire les infos spécifiques à la machine (SID, nom…).

> [!success]- 🔓 Différence image Thin et Thick ?
> Thin = OS uniquement (logiciels déployés après). Thick = OS + tous les logiciels.

> [!success]- 🔓 C'est quoi MDT ?
> Microsoft Deployment Toolkit = outil gratuit de déploiement Windows par séquences de tâches.

---

---

# 🎯 GRAND QUIZ FINAL — 40 questions mélangées

> [!success]- 🔓 Q1 — C'est quoi le modèle OSI ?
> Modèle théorique en **7 couches** décrivant les fonctions de communication réseau (norme ISO).

> [!success]- 🔓 Q2 — Sur quelle couche OSI travaille un switch ?
> Couche **2** (Liaison) — adresses MAC.

> [!success]- 🔓 Q3 — Différence TCP et UDP ?
> TCP = fiable, connecté, 3-way handshake. UDP = rapide, sans connexion, sans garantie.

> [!success]- 🔓 Q4 — Quel port pour SSH ? RDP ? DNS ?
> SSH = **22** / RDP = **3389** / DNS = **53**

> [!success]- 🔓 Q5 — C'est quoi le DNS ?
> Service qui traduit les noms de domaine en adresses IP. Port **53 UDP**.

> [!success]- 🔓 Q6 — Ping IP OK, ping nom KO. Quel problème ?
> Problème **DNS** — vérifier le résolveur configuré.

> [!success]- 🔓 Q7 — C'est quoi DORA ?
> Discover → Offer → Request → Acknowledge. Séquence DHCP pour obtenir une IP.

> [!success]- 🔓 Q8 — Un client a l'IP 169.254.x.x. Que faire ?
> Problème DHCP (APIPA). Vérifier : câble, service DHCP, port 67/68, pool non épuisé.

> [!success]- 🔓 Q9 — C'est quoi un VLAN ?
> Segmentation logique d'un switch en plusieurs réseaux isolés sans séparation physique.

> [!success]- 🔓 Q10 — Différence port Access et Trunk ?
> Access = 1 seul VLAN. Trunk = plusieurs VLANs (802.1Q), entre switchs ou switch↔routeur.

> [!success]- 🔓 Q11 — C'est quoi Active Directory ?
> Annuaire Microsoft pour gérer les utilisateurs, ordinateurs et ressources d'un réseau Windows.

> [!success]- 🔓 Q12 — Explique AGDLP.
> Utilisateurs → GRP_ (Globaux) → DL_ (Domain Local) → Permissions NTFS.

> [!success]- 🔓 Q13 — Différence OU et Groupe AD ?
> OU = organiser + GPO. Groupe = donner des permissions.

> [!success]- 🔓 Q14 — Quel RAID pour tolérer 2 pannes disques ?
> **RAID 6** (4 disques minimum).

> [!success]- 🔓 Q15 — RAID remplace-t-il les sauvegardes ?
> Non. RAID protège la panne disque, pas la suppression, virus ou incendie.

> [!success]- 🔓 Q16 — Ordre LVM à respecter ?
> PV → VG → LV → Système de fichiers → Montage.

> [!success]- 🔓 Q17 — C'est quoi une DMZ ?
> Zone réseau pour les serveurs accessibles depuis Internet, isolée du LAN interne.

> [!success]- 🔓 Q18 — Différence SNAT et DNAT ?
> SNAT = traduit l'IP source (sortie Internet). DNAT = traduit l'IP destination (publication de services).

> [!success]- 🔓 Q19 — Différence DROP et REJECT ?
> DROP = refuse sans répondre. REJECT = refuse et envoie une notification.

> [!success]- 🔓 Q20 — Différence VPN site-à-site et nomade ?
> Site-à-site = relie 2 réseaux (permanent). Nomade = 1 user se connecte au réseau entreprise.

> [!success]- 🔓 Q21 — Différence known_hosts et authorized_keys ?
> `known_hosts` = clés des serveurs connus. `authorized_keys` = clés des clients autorisés.

> [!success]- 🔓 Q22 — Différence chiffrement symétrique et asymétrique ?
> Symétrique = 1 clé (rapide). Asymétrique = paire publique/privée (lent, échange sécurisé).

> [!success]- 🔓 Q23 — Les 4 piliers du DICP ?
> Disponibilité / Intégrité / Confidentialité / Preuve.

> [!success]- 🔓 Q24 — Différence IDS et IPS ?
> IDS = détecte et alerte (passif). IPS = détecte ET bloque (actif).

> [!success]- 🔓 Q25 — C'est quoi la défense en profondeur ?
> Multiplier les barrières de sécurité — le firewall seul ne suffit pas.

> [!success]- 🔓 Q26 — Cite les 3 plages privées RFC 1918.
> 10.0.0.0/8 — 172.16.0.0/12 — 192.168.0.0/16

> [!success]- 🔓 Q27 — C'est quoi une adresse fe80:: ?
> Adresse Link-Local IPv6 — auto-configurée, **non routable**, ne passe jamais un routeur.

> [!success]- 🔓 Q28 — C'est quoi RADIUS ?
> Protocole AAA qui centralise l'authentification, les droits et la traçabilité des utilisateurs réseau.

> [!success]- 🔓 Q29 — Différence IaaS, PaaS, SaaS ?
> IaaS = client gère l'OS. PaaS = fournisseur gère matériel+OS. SaaS = fournisseur gère tout.

> [!success]- 🔓 Q30 — Différence VM et conteneur ?
> VM = OS complet, lourd, lent. Conteneur = partage le noyau, léger (Mo), démarrage en secondes.

> [!success]- 🔓 Q31 — C'est quoi la règle 3-2-1 ?
> 3 copies, 2 supports différents, 1 copie hors-site.

> [!success]- 🔓 Q32 — Différence PRA et PCA ?
> PRA = reprendre après un sinistre. PCA = maintenir pendant un sinistre.

> [!success]- 🔓 Q33 — Différence incident et problème (ITIL) ?
> Incident = l'EFFET. Problème = la CAUSE racine.

> [!success]- 🔓 Q34 — C'est quoi le Patch Tuesday ?
> Correctifs Microsoft publiés le **2ème mardi de chaque mois**.

> [!success]- 🔓 Q35 — Les 3 opérations SNMP ?
> GET (interroger) / SET (modifier) / TRAP (alerte de l'équipement).

> [!success]- 🔓 Q36 — Quel est l'UID de root sous Linux ?
> **UID 0**.

> [!success]- 🔓 Q37 — Deny vs Allow NTFS — lequel gagne ?
> **Deny** est toujours prioritaire.

> [!success]- 🔓 Q38 — C'est quoi PXE ?
> Démarrage réseau pour déployer un OS : DHCP → TFTP → image.

> [!success]- 🔓 Q39 — C'est quoi Sysprep ?
> Outil pour resceller une image Windows avant capture — retire SID, nom machine… pour la rendre déployable.

> [!success]- 🔓 Q40 — Différence VoIP et ToIP ?
> VoIP = transmettre la voix sur IP (la techno). ToIP = téléphonie d'entreprise complète sur IP (l'infrastructure).