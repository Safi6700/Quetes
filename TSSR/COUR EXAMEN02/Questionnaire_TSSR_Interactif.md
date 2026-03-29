# 📚 QUESTIONNAIRE TSSR - Préparation Examen
## Questions ouvertes avec réponses cliquables

---

# 🌐 MODULE 1 : RÉSEAUX - MODÈLES OSI & TCP/IP

### Question 1.1
**Combien de couches comporte le modèle OSI ? Nommez-les dans l'ordre.**

<details>
<summary>🔓 Voir la réponse</summary>

**7 couches** (de bas en haut) :
1. **Physique** - Transmission des bits
2. **Liaison** - Trames, adresses MAC
3. **Réseau** - Paquets, adresses IP
4. **Transport** - Segments (TCP) / Datagrammes (UDP)
5. **Session** - Établissement des sessions
6. **Présentation** - Formatage, chiffrement
7. **Application** - Services réseau (HTTP, DNS...)

*Mnémotechnique : "Petit Lapin Rose Trouvé à la SPA"*
</details>

---
7couche physique liason réseau
### Question 1.2
**Combien de couches comporte le modèle TCP/IP ? Quelle est la correspondance avec OSI ?**

<details>
<summary>🔓 Voir la réponse</summary>

**4 couches** :
1. **Accès Réseau** = Couches 1+2 OSI (Physique + Liaison)
2. **Internet** = Couche 3 OSI (Réseau)
3. **Transport** = Couche 4 OSI
4. **Application** = Couches 5+6+7 OSI

</details>

---

### Question 1.3
**Quel est le PDU (Protocol Data Unit) de chaque couche OSI ?**

<details>
<summary>🔓 Voir la réponse</summary>

- **Couche 1 (Physique)** : Bit
- **Couche 2 (Liaison)** : Trame
- **Couche 3 (Réseau)** : Paquet (Datagramme IP)
- **Couche 4 (Transport)** : Segment (TCP) ou Datagramme (UDP)
- **Couches 5-7** : Données

</details>

---

### Question 1.4
**Quelle est la différence entre TCP et UDP ?**

<details>
<summary>🔓 Voir la réponse</summary>

| Caractéristique | TCP | UDP |
|-----------------|-----|-----|
| **Connexion** | Orienté connexion | Sans connexion |
| **Fiabilité** | Fiable (accusé de réception) | Non fiable |
| **Ordre** | Garanti | Non garanti |
| **Vitesse** | Plus lent | Plus rapide |
| **N° protocole** | 6 | 17 |
| **Usage** | HTTP, SSH, FTP, SMTP | DNS, DHCP, VoIP, streaming |

</details>

---

### Question 1.5
**Décrivez le TCP Handshake (poignée de main à 3 voies).**

<details>
<summary>🔓 Voir la réponse</summary>

1. **Client → SYN** : Demande de connexion (Seq=x)
2. **Serveur → SYN-ACK** : Acceptation (Seq=y, Ack=x+1)
3. **Client → ACK** : Confirmation (Seq=x+1, Ack=y+1)

→ Connexion établie (ESTABLISHED)

</details>

---

### Question 1.6
**Quel équipement travaille sur quelle couche OSI ?**

<details>
<summary>🔓 Voir la réponse</summary>

- **Hub (concentrateur)** : Couche 1 (Physique) - obsolète
- **Switch (commutateur)** : Couche 2 (Liaison)
- **Routeur** : Couche 3 (Réseau)
- **Pare-feu** : Couches 3-4 (voire 7 pour DPI)

</details>

---

# 🌐 MODULE 2 : ADRESSAGE IPv4

### Question 2.1
**Combien de bits comporte une adresse IPv4 ? Comment est-elle notée ?**

<details>
<summary>🔓 Voir la réponse</summary>

- **32 bits** (4 octets)
- Notation **décimale pointée** : ex. 192.168.1.1
- Notation CIDR : /XX pour le masque (ex: /24)

</details>

---

### Question 2.2
**Quelles sont les 3 plages d'adresses privées RFC 1918 ?**

<details>
<summary>🔓 Voir la réponse</summary>

| Classe | Plage | CIDR |
|--------|-------|------|
| A | 10.0.0.0 – 10.255.255.255 | /8 |
| B | 172.16.0.0 – 172.31.255.255 | /12 |
| C | 192.168.0.0 – 192.168.255.255 | /16 |

</details>

---

### Question 2.3
**Quelle est la formule pour calculer le nombre d'hôtes dans un réseau ?**

<details>
<summary>🔓 Voir la réponse</summary>

**Nb hôtes = 2^(32-CIDR) - 2**

On retire 2 car :
- 1 adresse pour le **réseau** (première)
- 1 adresse pour le **broadcast** (dernière)

Exemples :
- /24 : 2^8 - 2 = **254 hôtes**
- /26 : 2^6 - 2 = **62 hôtes**
- /30 : 2^2 - 2 = **2 hôtes**

</details>

---

### Question 2.4
**Un PC a l'adresse 169.254.15.20. Quel est le problème ?**

<details>
<summary>🔓 Voir la réponse</summary>

C'est une adresse **APIPA** (Automatic Private IP Addressing).

**Diagnostic** : Le client n'a **pas trouvé de serveur DHCP**.

**Vérifications** :
1. Câble réseau connecté ?
2. Service DHCP démarré ?
3. Client et serveur DHCP sur le même VLAN ?
4. Pool d'adresses non épuisé ?

</details>

---

### Question 2.5
**Calculez l'adresse réseau et le broadcast de 192.168.10.50/24**

<details>
<summary>🔓 Voir la réponse</summary>

- **Masque** : /24 = 255.255.255.0
- **Adresse réseau** : 192.168.10.0 (bits hôte à 0)
- **Broadcast** : 192.168.10.255 (bits hôte à 1)
- **Plage utilisable** : 192.168.10.1 à 192.168.10.254

</details>

---

# 🌐 MODULE 3 : ADRESSAGE IPv6

### Question 3.1
**Combien de bits comporte une adresse IPv6 ? Quels types d'adresses existent ?**

<details>
<summary>🔓 Voir la réponse</summary>

- **128 bits** (notation hexadécimale avec :)
- **3 types** : Unicast, Multicast, Anycast
- **PAS de Broadcast** en IPv6 !

</details>

---

### Question 3.2
**Quels sont les préfixes IPv6 importants à connaître ?**

<details>
<summary>🔓 Voir la réponse</summary>

| Préfixe | Type | Usage |
|---------|------|-------|
| **::1/128** | Loopback | Boucle locale |
| **fe80::/10** | Link-Local | Non routable, auto-configuré |
| **fd00::/8** | Unique Local | Privé, routable en interne |
| **2000::/3** | Global Unicast | Public, Internet |
| **ff00::/8** | Multicast | Groupe |

</details>

---

### Question 3.3
**Une machine a une adresse fe80::. Peut-elle communiquer avec un autre réseau ?**

<details>
<summary>🔓 Voir la réponse</summary>

**NON** - fe80:: est une adresse **Link-Local**.

Elle est **non routable** et ne peut communiquer que sur son segment réseau local (même lien physique).

C'est l'équivalent IPv6 d'APIPA en IPv4.

</details>

---

### Question 3.4
**C'est quoi SLAAC ?**

<details>
<summary>🔓 Voir la réponse</summary>

**SLAAC** = StateLess Address AutoConfiguration

- Autoconfiguration IPv6 **sans serveur DHCP**
- L'hôte génère automatiquement son adresse
- Utilise le préfixe réseau annoncé par le routeur + son identifiant d'interface

</details>

---

# 📡 MODULE 4 : PROTOCOLES RÉSEAU

### Question 4.1
**Quel est le rôle du protocole DNS ? Sur quel port fonctionne-t-il ?**

<details>
<summary>🔓 Voir la réponse</summary>

**DNS** (Domain Name System) :
- Traduit les noms de domaine en adresses IP
- Port **53** (UDP par défaut, TCP pour les transferts de zone)

**2 types de serveurs** :
- **Faisant autorité** : détient l'info officielle d'une zone
- **Résolveur** : interroge les serveurs + met en cache (TTL)

</details>

---

### Question 4.2
**Décrivez la séquence DORA du protocole DHCP.**

<details>
<summary>🔓 Voir la réponse</summary>

**DORA** = Discover → Offer → Request → Acknowledge

1. **DISCOVER** (broadcast) : Client cherche un serveur DHCP
2. **OFFER** : Serveur propose une configuration IP
3. **REQUEST** (broadcast) : Client accepte l'offre
4. **ACK** : Serveur confirme le bail

**Ports** : UDP 67 (serveur) et UDP 68 (client)

</details>

---

### Question 4.3
**Quels sont les enregistrements DNS importants ?**

<details>
<summary>🔓 Voir la réponse</summary>

| Type | Nom | Contenu |
|------|-----|---------|
| **A** | Address | IPv4 |
| **AAAA** | Address v6 | IPv6 |
| **NS** | Name Server | Serveur faisant autorité |
| **MX** | Mail eXchange | Serveur mail du domaine |
| **CNAME** | Canonical Name | Alias vers un autre nom |
| **PTR** | Pointer | Résolution inverse (IP → nom) |

</details>

---

### Question 4.4
**Ping par IP fonctionne mais ping par nom échoue. Quel est le problème ?**

<details>
<summary>🔓 Voir la réponse</summary>

**Problème DNS** (pas réseau).

**Vérifications** :
1. Résolveur DNS configuré ? (`/etc/resolv.conf` ou config Windows)
2. Serveur DNS joignable ? (`ping` vers le serveur DNS)
3. Entrée dans `/etc/hosts` ou `C:\Windows\System32\drivers\etc\hosts` ?
4. Service DNS fonctionnel ?

**Commandes de test** : `nslookup domaine.com` ou `dig domaine.com`

</details>

---

# 📡 MODULE 5 : ETHERNET & COUCHE 2

### Question 5.1
**Quelle est la structure d'une trame Ethernet ?**

<details>
<summary>🔓 Voir la réponse</summary>

```
┌──────────┬──────────┬───────────┬─────────────┬──────┐
│ MAC Dest │ MAC Src  │ EtherType │   Données   │ FCS  │
│  6 oct   │  6 oct   │  2 oct    │ 46-1500 oct │4 oct │
└──────────┴──────────┴───────────┴─────────────┴──────┘
```

**Taille totale** : 64 à 1518 octets
**MTU** : 1500 octets (Maximum Transmission Unit)

</details>

---

### Question 5.2
**Quels sont les EtherTypes à connaître ?**

<details>
<summary>🔓 Voir la réponse</summary>

| EtherType | Protocole |
|-----------|-----------|
| **0x0800** | IPv4 |
| **0x0806** | ARP |
| **0x86DD** | IPv6 |

</details>

---

### Question 5.3
**Quelle est la différence entre un switch et un hub ?**

<details>
<summary>🔓 Voir la réponse</summary>

| | Hub | Switch |
|--|-----|--------|
| **Couche OSI** | 1 (Physique) | 2 (Liaison) |
| **Transmission** | Répète à TOUS les ports | Envoie uniquement au destinataire |
| **Intelligence** | Aucune | Table MAC (CAM) |
| **Statut** | Obsolète | Standard actuel |

</details>

---

### Question 5.4
**C'est quoi le protocole ARP ?**

<details>
<summary>🔓 Voir la réponse</summary>

**ARP** = Address Resolution Protocol

**Rôle** : Résout une adresse IP en adresse MAC

**Fonctionnement** :
1. ARP Request (broadcast) : "Qui a l'IP X.X.X.X ?"
2. ARP Reply (unicast) : "C'est moi, voici ma MAC"
3. Stockage dans le cache ARP

**Commande** : `arp -a` pour voir le cache ARP

</details>

---

# 🔐 MODULE 6 : SÉCURITÉ RÉSEAU

### Question 6.1
**Quels sont les 4 piliers de la sécurité informatique (D.I.C.P) ?**

<details>
<summary>🔓 Voir la réponse</summary>

| Pilier | Description | Exemple d'atteinte |
|--------|-------------|-------------------|
| **D**isponibilité | Service accessible | Attaque DDoS |
| **I**ntégrité | Données exactes | Modification de fichiers |
| **C**onfidentialité | Accès réservé aux autorisés | Vol de données |
| **P**reuve (Traçabilité) | Prouver qui a fait quoi | Logs effacés |

</details>

---

### Question 6.2
**Quelle est la différence entre chiffrement symétrique et asymétrique ?**

<details>
<summary>🔓 Voir la réponse</summary>

| | Symétrique | Asymétrique |
|--|-----------|-------------|
| **Clés** | 1 seule (secrète, partagée) | 2 clés (publique + privée) |
| **Vitesse** | Rapide | Lent |
| **Problème** | Partage sécurisé de la clé | - |
| **Algorithmes** | AES, DES, 3DES | RSA, ECC |

**Hybride (TLS)** : Asymétrique pour échanger la clé + Symétrique pour chiffrer

</details>

---

### Question 6.3
**C'est quoi une fonction de hachage ?**

<details>
<summary>🔓 Voir la réponse</summary>

Fonction qui génère une **empreinte unique** de taille fixe à partir d'un message.

**Caractéristiques** :
- **Irréversible** : impossible de retrouver le message original
- **Déterministe** : même entrée = même sortie
- **Collision rare** : 2 messages différents = hashes différents

**Algorithmes** : MD5 (obsolète), SHA-1 (obsolète), **SHA-256**, SHA-3

**Usage** : Vérifier intégrité, stocker mots de passe (avec sel)

</details>

---

### Question 6.4
**Quelle est la différence entre un pare-feu stateless et stateful ?**

<details>
<summary>🔓 Voir la réponse</summary>

| | Stateless | Stateful |
|--|-----------|----------|
| **Mémoire** | ❌ Non | ✅ Oui |
| **Suivi connexion** | ❌ Non | ✅ Oui |
| **Réponses** | Règle manuelle nécessaire | Auto-autorisées |
| **Vitesse** | Plus rapide | Plus lent |

**Stateful** : suit l'état des connexions TCP, autorise automatiquement les réponses aux connexions initiées depuis l'intérieur.

</details>

---

### Question 6.5
**Quelle est la différence entre DROP et REJECT sur un pare-feu ?**

<details>
<summary>🔓 Voir la réponse</summary>

- **DROP** : Refuse **sans réponse** (silencieux)
  - L'attaquant ne sait pas si le port existe
  
- **REJECT** : Refuse **avec notification**
  - L'attaquant sait que le firewall est présent

**Recommandation** : DROP pour la sécurité

</details>

---

# 🔐 MODULE 7 : VPN & SSH

### Question 7.1
**C'est quoi un VPN ? Quels sont les types ?**

<details>
<summary>🔓 Voir la réponse</summary>

**VPN** = Virtual Private Network = Tunnel chiffré pour se connecter à un réseau distant

**Types** :
| Type | Usage | Exemple |
|------|-------|---------|
| **Site-à-Site** | Relie 2 réseaux | Paris ↔ Montréal (permanent) |
| **Nomade** | 1 user → réseau entreprise | Télétravail |
| **Point-à-point** | 1 machine → 1 machine | Maintenance distante |

</details>

---

### Question 7.2
**C'est quoi IPsec ? Différence entre AH et ESP ?**

<details>
<summary>🔓 Voir la réponse</summary>

**IPsec** = Protocole VPN niveau 3 (couche réseau)

| | AH | ESP |
|--|---|-----|
| **Authentification** | ✅ | ✅ |
| **Intégrité** | ✅ | ✅ |
| **Chiffrement** | ❌ | ✅ |

**Modes** :
- **Tunnel** : protège tout le paquet (site-à-site)
- **Transport** : protège les données uniquement

</details>

---

### Question 7.3
**Quel port utilise SSH ? C'est quoi TOFU ?**

<details>
<summary>🔓 Voir la réponse</summary>

**SSH** = Secure Shell, port **TCP 22**

**TOFU** = Trust On First Use
- À la 1ère connexion, on accepte l'empreinte du serveur
- Stockée dans `~/.ssh/known_hosts`
- Si elle change ensuite → **ALERTE** (possible man-in-the-middle)

</details>

---

### Question 7.4
**Quels fichiers SSH sont importants côté client ?**

<details>
<summary>🔓 Voir la réponse</summary>

| Fichier | Emplacement | Rôle |
|---------|-------------|------|
| `known_hosts` | `~/.ssh/` | Clés publiques serveurs connus |
| `id_ed25519` | `~/.ssh/` | Clé privée utilisateur |
| `id_ed25519.pub` | `~/.ssh/` | Clé publique utilisateur |
| `config` | `~/.ssh/` | Config client personnalisée |

**Commandes** :
- `ssh-keygen -t ed25519` : Générer une paire de clés
- `ssh-copy-id user@host` : Copier la clé publique sur le serveur

</details>

---

# 🖥️ MODULE 8 : SYSTÈMES D'EXPLOITATION

### Question 8.1
**Quels sont les rôles d'un système d'exploitation ?**

<details>
<summary>🔓 Voir la réponse</summary>

- **Gestion des processus** : partage du CPU
- **Gestion de la mémoire** : allocation de la RAM
- **Gestion du stockage** : accès aux disques, fichiers
- **Gestion des utilisateurs** : comptes, droits, sessions
- **Gestion des périphériques** : drivers, accès matériel
- **Interface utilisateur** : CLI ou GUI

</details>

---

### Question 8.2
**Quelles sont les 4 libertés du logiciel libre ?**

<details>
<summary>🔓 Voir la réponse</summary>

| # | Liberté |
|---|---------|
| 0 | **Exécuter** le programme pour n'importe quel usage |
| 1 | **Étudier** le programme et l'adapter (accès au code source) |
| 2 | **Redistribuer** des copies |
| 3 | **Améliorer** et distribuer les améliorations |

</details>

---

### Question 8.3
**Quelle est la différence entre Linux et GNU/Linux ?**

<details>
<summary>🔓 Voir la réponse</summary>

- **Linux** = Juste le **noyau** (kernel), créé par Linus Torvalds en 1991
- **GNU/Linux** = Noyau Linux + **outils GNU** + distribution complète

GNU = projet lancé par Richard Stallman en 1983

On dit souvent "Linux" par abus de langage.

</details>

---

# 🐧 MODULE 9 : LINUX - UTILISATEURS & DROITS

### Question 9.1
**Quel est l'UID de root ? Où sont stockés les utilisateurs et mots de passe ?**

<details>
<summary>🔓 Voir la réponse</summary>

- **UID de root** : **0**
- **Fichiers** :
  - `/etc/passwd` : infos utilisateurs (lisible par tous)
  - `/etc/shadow` : mots de passe chiffrés (**root only**)
  - `/etc/group` : groupes

</details>

---

### Question 9.2
**Que signifient les droits rwx ? Comment les exprimer en numérique ?**

<details>
<summary>🔓 Voir la réponse</summary>

| Lettre | Signification | Valeur |
|--------|---------------|--------|
| **r** | read (lecture) | 4 |
| **w** | write (écriture) | 2 |
| **x** | execute (exécution) | 1 |

**Exemple** : rwxr-xr-x = 755
- user : rwx = 4+2+1 = 7
- group : r-x = 4+0+1 = 5
- others : r-x = 4+0+1 = 5

</details>

---

### Question 9.3
**Quelle est la différence entre chmod et chown ?**

<details>
<summary>🔓 Voir la réponse</summary>

- **chmod** : Modifier les **droits** (rwx)
  - Exemple : `chmod 755 fichier`
  
- **chown** : Modifier le **propriétaire** (user:group)
  - Exemple : `chown user:groupe fichier`

</details>

---

### Question 9.4
**Comment ajouter un utilisateur à un groupe secondaire ?**

<details>
<summary>🔓 Voir la réponse</summary>

```bash
usermod -aG groupe utilisateur
```

**⚠️ Le `-a` est crucial !**
- Avec `-a` : ajoute au groupe (conserve les autres)
- Sans `-a` : remplace tous les groupes secondaires

</details>

---

# 🪟 MODULE 10 : WINDOWS - UTILISATEURS & DROITS

### Question 10.1
**C'est quoi un SID ? Quel est le RID de l'Administrateur ?**

<details>
<summary>🔓 Voir la réponse</summary>

**SID** = Security Identifier = Identifiant unique utilisateur/groupe

**RID** = partie finale du SID

| RID | Compte |
|-----|--------|
| 500 | Administrateur |
| 501 | Invité |

**Well-known SIDs** :
- S-1-5-32-544 : Groupe Administrateurs
- S-1-5-32-545 : Groupe Utilisateurs

</details>

---

### Question 10.2
**Entre Allow et Deny, lequel est prioritaire ?**

<details>
<summary>🔓 Voir la réponse</summary>

**DENY est TOUJOURS prioritaire sur Allow**

Même avec Allow FullControl, un Deny quelque part bloque l'accès.

**Diagnostic** : Si un utilisateur ne peut pas accéder malgré les droits → chercher un Deny sur l'utilisateur ou un de ses groupes.

</details>

---

# 🗂️ MODULE 11 : ACTIVE DIRECTORY

### Question 11.1
**C'est quoi Active Directory ? Quelle est la structure logique ?**

<details>
<summary>🔓 Voir la réponse</summary>

**AD** = Annuaire Microsoft pour gérer les utilisateurs, ordinateurs et ressources d'un réseau Windows.

**Structure** (du plus petit au plus grand) :
1. **Objet** : un élément (user, PC, imprimante)
2. **OU** (Unité d'Organisation) : dossier pour organiser + GPO
3. **Domaine** : ensemble d'objets + DC
4. **Arbre** : domaines avec même racine DNS
5. **Forêt** : ensemble d'arbres liés

</details>

---

### Question 11.2
**Quelle est la différence entre OU et Groupe ?**

<details>
<summary>🔓 Voir la réponse</summary>

| | OU | Groupe |
|--|----|----|
| **Sert à** | Organiser + appliquer GPO | Donner des **permissions** |
| **Contient** | Users, PC, autres OU | Users, autres groupes |

**⚠️ Piège classique** : Ne pas confondre les deux !

</details>

---

### Question 11.3
**C'est quoi un rôle FSMO ? Quels sont les 5 rôles ?**

<details>
<summary>🔓 Voir la réponse</summary>

**FSMO** = Flexible Single Master Operations = 5 rôles spéciaux où **un seul DC** peut faire certaines tâches.

**Niveau Forêt** (1 par forêt) :
- Maître de schéma
- Maître d'attribution de noms de domaine

**Niveau Domaine** (1 par domaine) :
- Maître RID
- Maître d'infrastructure
- **Émulateur PDC** (le plus critique : synchro heure + verrouillage comptes)

</details>

---

### Question 11.4
**C'est quoi LSDOU pour les GPO ?**

<details>
<summary>🔓 Voir la réponse</summary>

**LSDOU** = Ordre d'application des GPO :

**L**ocal → **S**ite → **D**omaine → **OU**

**La dernière GPO appliquée gagne !**

</details>

---

### Question 11.5
**C'est quoi AGDLP ?**

<details>
<summary>🔓 Voir la réponse</summary>

**AGDLP** = Méthode pour gérer les permissions proprement

| Lettre | Signifie | C'est quoi |
|--------|----------|------------|
| **A** | Account | L'utilisateur |
| **G** | Global group | Groupe métier (ex: Comptables) |
| **DL** | Domain Local group | Groupe de droits (ex: Lecture_Factures) |
| **P** | Permissions | Droits sur la ressource |

**⚠️ Jamais de permissions directement sur un utilisateur !**

</details>

---

# 📡 MODULE 12 : VIRTUALISATION

### Question 12.1
**Quelle est la différence entre hyperviseur Type 1 et Type 2 ?**

<details>
<summary>🔓 Voir la réponse</summary>

| | Type 1 (Bare Metal) | Type 2 (Hébergé) |
|--|--------|--------|
| **Installation** | Direct sur matériel | Sur un OS existant |
| **Performance** | Excellente | Moins bonne |
| **Usage** | Datacenter, production | Développement, test |
| **Exemples** | VMware ESXi, Hyper-V, Proxmox, KVM | VirtualBox, VMware Workstation |

**⚠️ VirtualBox = Type 2** (piège classique !)

</details>

---

### Question 12.2
**C'est quoi l'overhead en virtualisation ?**

<details>
<summary>🔓 Voir la réponse</summary>

**Overhead** = Ressources (CPU, RAM) consommées par l'hyperviseur lui-même pour gérer la virtualisation.

= Coût supplémentaire en plus des ressources des VM

</details>

---

# 🐳 MODULE 13 : CONTENEURS & DOCKER

### Question 13.1
**Quelle est la différence entre une VM et un conteneur ?**

<details>
<summary>🔓 Voir la réponse</summary>

| | VM | Conteneur |
|--|----|----|
| **Contient** | OS complet | Juste l'appli + dépendances |
| **Poids** | Lourd (Go) | Léger (Mo) |
| **Démarrage** | Minutes | **Secondes** |
| **Isolation** | Totale | Partage le noyau hôte |

</details>

---

### Question 13.2
**C'est quoi un Dockerfile ? Comment l'utiliser ?**

<details>
<summary>🔓 Voir la réponse</summary>

**Dockerfile** = Fichier texte avec les instructions pour construire une image Docker.

**Exemple** :
```dockerfile
FROM ubuntu:latest        # Image de base
RUN apt-get update        # Exécuter commande
WORKDIR /data             # Dossier de travail
COPY fichier /data/       # Copier fichiers
CMD ["bash", "-i"]        # Commande au démarrage
```

**Utilisation** : `docker build -t mon_image .`

</details>

---

### Question 13.3
**Quelle est la différence entre IaaS, PaaS et SaaS ?**

<details>
<summary>🔓 Voir la réponse</summary>

| Terme | Signifie | Tu gères | Exemple |
|-------|----------|----------|---------|
| **IaaS** | Infrastructure as a Service | OS, applis, données | AWS EC2, Azure VM |
| **PaaS** | Platform as a Service | Applis, données | Heroku, Azure App Service |
| **SaaS** | Software as a Service | Rien (juste utiliser) | Gmail, Office 365 |

</details>

---

# 💾 MODULE 14 : STOCKAGE & SAUVEGARDE

### Question 14.1
**Quelle est la différence entre sauvegarde complète, incrémentale et différentielle ?**

<details>
<summary>🔓 Voir la réponse</summary>

| Type | Principe | Avantage | Inconvénient |
|------|----------|----------|--------------|
| **Complète** | Copie TOUTES les données | Restauration facile | Long, gros espace |
| **Incrémentale** | Modifs depuis la **dernière sauvegarde** | Rapide, peu d'espace | Restauration complexe |
| **Différentielle** | Modifs depuis la **dernière complète** | Compromis | Espace croissant |

**Stratégie classique** : 1 complète/semaine + 1 incrémentale/jour

</details>

---

### Question 14.2
**C'est quoi la règle 3-2-1 ?**

<details>
<summary>🔓 Voir la réponse</summary>

- **3** copies (prod + 2 sauvegardes)
- **2** supports différents (ex: disque + bande)
- **1** copie hors-site (protection incendie/vol)

**Copies hors-ligne** = protection contre les **ransomwares**

</details>

---

### Question 14.3
**Quelle est la différence entre PRA et PCA ?**

<details>
<summary>🔓 Voir la réponse</summary>

- **PRA** (Plan de Reprise d'Activité) = Reprendre **APRÈS** un sinistre
- **PCA** (Plan de Continuité d'Activité) = Maintenir **PENDANT** un sinistre

</details>

---

### Question 14.4
**Expliquez les niveaux RAID 0, 1, 5 et 10.**

<details>
<summary>🔓 Voir la réponse</summary>

| RAID | Principe | Disques min | Tolérance panne | Capacité |
|------|----------|-------------|-----------------|----------|
| **RAID 0** | Striping (performance) | 2 | ❌ Aucune | n × disque |
| **RAID 1** | Miroir (fiabilité) | 2 | ✅ n-1 pannes | 1 × disque |
| **RAID 5** | Parité répartie | 3 | ✅ 1 panne | (n-1) × disque |
| **RAID 10** | Miroir + Striping | 4 | ✅ 1 par grappe | n/2 × disque |

**⚠️ RAID ≠ Sauvegarde** : RAID protège contre la panne disque, pas contre suppression, virus ou incendie !

</details>

---

# 💾 MODULE 15 : STOCKAGE LINUX

### Question 15.1
**Quelle commande pour partitionner un disque sous Linux ?**

<details>
<summary>🔓 Voir la réponse</summary>

```bash
fdisk /dev/sdX
```

**Autres outils** : `cfdisk` (semi-graphique), `parted` (avancé), `gparted` (GUI)

</details>

---

### Question 15.2
**Comment formater une partition en ext4 et la monter ?**

<details>
<summary>🔓 Voir la réponse</summary>

```bash
# Formater en ext4
mkfs.ext4 /dev/sda1

# Créer le point de montage
mkdir -p /mnt/data

# Monter la partition
mount /dev/sda1 /mnt/data

# Voir l'UUID
blkid
```

</details>

---

### Question 15.3
**À quoi sert le fichier /etc/fstab ? Pourquoi utiliser UUID ?**

<details>
<summary>🔓 Voir la réponse</summary>

**/etc/fstab** = Fichier de montages automatiques au démarrage

**6 colonnes** : périphérique, point de montage, type FS, options, dump, pass

**Pourquoi UUID ?** : Le nom du disque (/dev/sdX) peut changer au redémarrage, l'UUID reste fixe.

```bash
# Trouver l'UUID
blkid

# Exemple ligne fstab
UUID=9e35d3c3... /mnt/data ext4 defaults 0 2
```

</details>

---

# ⚙️ MODULE 16 : GESTION PROCESSUS & MÉMOIRE

### Question 16.1
**C'est quoi un processus ? Quel est le PID du premier processus Linux ?**

<details>
<summary>🔓 Voir la réponse</summary>

**Processus** = Programme en cours d'exécution, identifié par un **PID**

**PID 1** = **systemd** (ou init) = premier processus, parent de tous les autres

</details>

---

### Question 16.2
**Quelle est la différence entre Ctrl+C et Ctrl+Z ?**

<details>
<summary>🔓 Voir la réponse</summary>

- **Ctrl+C** (SIGINT) = **Interrompt** le processus (arrêt)
- **Ctrl+Z** (SIGTSTP) = **Met en pause** le processus

**Pour reprendre après Ctrl+Z** :
- `fg` : reprendre en premier plan
- `bg` : reprendre en arrière-plan

</details>

---

### Question 16.3
**C'est quoi le swap ?**

<details>
<summary>🔓 Voir la réponse</summary>

**Swap** = Mémoire virtuelle sur disque utilisée quand la RAM est pleine.

**Beaucoup plus lent que la RAM !**

Si beaucoup de swap utilisé → besoin de plus de RAM.

**Commandes** :
- `free` : voir utilisation mémoire + swap
- `mkswap /dev/sdX` : initialiser une partition swap
- `swapon /dev/sdX` : activer le swap

</details>

---

# 🔧 MODULE 17 : SCRIPTING BASH

### Question 17.1
**Que signifient les variables spéciales $?, $#, $@ en Bash ?**

<details>
<summary>🔓 Voir la réponse</summary>

| Variable | Signification |
|----------|---------------|
| `$?` | Code de sortie dernière commande (0 = succès) |
| `$#` | Nombre d'arguments |
| `$@` | Tous les arguments (mots séparés) |
| `$0` | Nom du script |
| `$1, $2...` | Arguments 1, 2... |

</details>

---

### Question 17.2
**Quels sont les opérateurs de test pour les nombres en Bash ?**

<details>
<summary>🔓 Voir la réponse</summary>

| Opérateur | Signification |
|-----------|---------------|
| `-eq` | égal (equal) |
| `-ne` | différent (not equal) |
| `-lt` | inférieur (less than) |
| `-le` | inférieur ou égal |
| `-gt` | supérieur (greater than) |
| `-ge` | supérieur ou égal |

**Exemple** : `[ $a -eq 5 ]`

</details>

---

### Question 17.3
**Comment tester si un fichier existe en Bash ?**

<details>
<summary>🔓 Voir la réponse</summary>

```bash
if [ -e fichier ]
then
    echo "Le fichier existe"
fi
```

**Autres tests** :
- `-f` : est un fichier
- `-d` : est un dossier
- `-r` : lecture autorisée
- `-w` : écriture autorisée
- `-x` : exécution autorisée

</details>

---

# 🔧 MODULE 18 : POWERSHELL

### Question 18.1
**Quel est le format d'une cmdlet PowerShell ?**

<details>
<summary>🔓 Voir la réponse</summary>

**Verbe-Nom**

Exemples :
- `Get-ChildItem`
- `Set-Item`
- `Get-LocalUser`
- `Add-LocalGroupMember`

</details>

---

### Question 18.2
**Quels sont les opérateurs de comparaison en PowerShell ?**

<details>
<summary>🔓 Voir la réponse</summary>

| Opérateur | Signification |
|-----------|---------------|
| `-eq` | Equal (égal) |
| `-ne` | Not Equal (différent) |
| `-gt` | Greater Than (>) |
| `-lt` | Less Than (<) |
| `-ge` | Greater or Equal (>=) |
| `-le` | Less or Equal (<=) |
| `-like` | Avec wildcards (*) |
| `-match` | Avec regex |

**⚠️ Ne pas utiliser ==, !=, >, < comme en Bash !**

</details>

---

# 🎫 MODULE 19 : ITIL & GESTION D'INCIDENTS

### Question 19.1
**Quelle est la différence entre incident et problème selon ITIL ?**

<details>
<summary>🔓 Voir la réponse</summary>

| | Incident | Problème |
|--|----------|----------|
| **C'est** | L'**EFFET** | La **CAUSE** |
| **Exemple** | "Je ne peux pas me connecter" | Serveur DHCP en panne |
| **Objectif** | Restaurer le service vite | Trouver et éliminer la cause |

</details>

---

### Question 19.2
**Quelles sont les 8 étapes de gestion d'un incident ?**

<details>
<summary>🔓 Voir la réponse</summary>

1. **Identification** (détecter)
2. **Notification** (signaler)
3. **Enregistrement** (créer le ticket)
4. **Catégorisation + Priorisation**
5. **Diagnostic**
6. **Suivi (ou escalade)**
7. **Résolution** (et documentation)
8. **Clôture**

</details>

---

### Question 19.3
**Quels sont les niveaux de support ?**

<details>
<summary>🔓 Voir la réponse</summary>

| Niveau | Rôle |
|--------|------|
| **N0** | Enregistrement, tri |
| **N1** | Résolution simple (procédures) |
| **N2** | Analyse + résolution complexe |
| **N3** | Expertise technique poussée |

</details>

---

# 📋 MODULE 20 : MÉTHODES AGILES & SCRUM

### Question 20.1
**Quels sont les 3 rôles Scrum ?**

<details>
<summary>🔓 Voir la réponse</summary>

| Rôle | Responsabilité |
|------|----------------|
| **Product Owner** | Porte la vision du produit, gère le Product Backlog |
| **Scrum Master** | Facilite l'application de Scrum, lève les obstacles |
| **Développeurs** | Équipe qui réalise le produit |

</details>

---

### Question 20.2
**Quels sont les 3 piliers de Scrum ?**

<details>
<summary>🔓 Voir la réponse</summary>

1. **Transparence**
2. **Inspection**
3. **Adaptation**

</details>

---

### Question 20.3
**Quelle est la durée maximale du Daily Scrum ?**

<details>
<summary>🔓 Voir la réponse</summary>

**15 minutes maximum**

Questions abordées :
- Qu'ai-je fait hier ?
- Que vais-je faire aujourd'hui ?
- Quels sont mes blocages ?

</details>

---

# 🔌 MODULE 21 : PORTS & PROTOCOLES

### Question 21.1
**Citez les ports les plus importants à connaître.**

<details>
<summary>🔓 Voir la réponse</summary>

| Port | Protocole | Usage |
|------|-----------|-------|
| 20/21 | FTP | Transfert de fichiers |
| 22 | SSH/SFTP | Connexion sécurisée |
| 23 | Telnet | Connexion non sécurisée (obsolète) |
| 25 | SMTP | Envoi d'emails |
| 53 | DNS | Résolution de noms |
| 67/68 | DHCP | Attribution IP automatique |
| 80 | HTTP | Web non chiffré |
| 110 | POP3 | Réception emails |
| 143 | IMAP | Accès emails synchronisé |
| 389 | LDAP | Annuaire |
| 443 | HTTPS | Web chiffré |
| 445 | SMB | Partage fichiers Windows |
| 3389 | RDP | Bureau à distance Windows |

</details>

---

### Question 21.2
**Quelle est la différence entre IMAP et POP3 ?**

<details>
<summary>🔓 Voir la réponse</summary>

| | IMAP | POP3 |
|--|------|------|
| **Mails** | Restent sur serveur | Téléchargés puis supprimés |
| **Multi-appareils** | ✅ Oui (synchro) | ❌ Non |
| **Port** | 143 (993 SSL) | 110 (995 SSL) |

**Pour plusieurs appareils** → IMAP

</details>

---

# 🔀 MODULE 22 : GIT & GITHUB

### Question 22.1
**Quelle est la différence entre Git et GitHub ?**

<details>
<summary>🔓 Voir la réponse</summary>

| Git | GitHub |
|-----|--------|
| Logiciel de gestion de versions | Service web |
| Local | En ligne |
| Décentralisé | Hébergement + collaboration |
| Créé en 2005 par Linus Torvalds | Créé en 2008 |

**⚠️ Ne pas confondre !**

</details>

---

### Question 22.2
**Quels sont les 3 "arbres" de Git ?**

<details>
<summary>🔓 Voir la réponse</summary>

1. **Répertoire de travail** (Working Directory)
2. **Index** (Stage) - zone de préparation
3. **HEAD** - dernier commit

**Workflow** : modifier → `git add` → `git commit` → `git push`

</details>

---

# 🌐 MODULE 23 : NAT & ROUTAGE

### Question 23.1
**C'est quoi le NAT ? Pourquoi existe-t-il ?**

<details>
<summary>🔓 Voir la réponse</summary>

**NAT** = Network Address Translation = Traduction d'adresses IP privées ↔ publiques

**Pourquoi ?** Pénurie d'adresses IPv4 → permet à plusieurs machines internes d'utiliser 1 seule IP publique.

**⚠️ NAT concerne UNIQUEMENT IPv4** (pas IPv6)

</details>

---

### Question 23.2
**Quelle est la différence entre SNAT et DNAT ?**

<details>
<summary>🔓 Voir la réponse</summary>

| | SNAT | DNAT |
|--|------|------|
| **Nom** | Source NAT | Destination NAT |
| **Traduit** | Adresse **source** | Adresse **destination** |
| **Usage** | Sortie Internet | Publication de services |

**PAT/NAPT** = Traduction IP + port → plusieurs machines via 1 seule IP publique

</details>

---

### Question 23.3
**C'est quoi une table de routage ?**

<details>
<summary>🔓 Voir la réponse</summary>

**Table de routage** = Liste des destinations (réseaux) + passerelle (next hop) pour les atteindre.

**Composition d'une entrée** :
- Destination (réseau + masque)
- Next hop (passerelle)
- Interface de sortie
- Métrique (qualité de la route)

**Passerelle par défaut** = où envoyer si destination inconnue

**Commandes** :
- Linux : `ip route`
- Windows : `route print`

</details>

---

# 📧 MODULE 24 : SERVICES BUREAUTIQUES

### Question 24.1
**Quels sont les protocoles de messagerie et leurs ports ?**

<details>
<summary>🔓 Voir la réponse</summary>

| Protocole | Rôle | Port |
|-----------|------|------|
| **SMTP** | Envoyer | 25 (ou 587 avec auth) |
| **IMAP** | Consulter (synchro) | 143 (993 SSL) |
| **POP3** | Télécharger | 110 (995 SSL) |

</details>

---

### Question 24.2
**Quel port pour RDP (bureau à distance Windows) ?**

<details>
<summary>🔓 Voir la réponse</summary>

**Port 3389** (TCP/UDP)

</details>

---

# 🖥️ MODULE 25 : GESTION DE PARC

### Question 25.1
**Quelle est la différence entre GLPI et MDM ?**

<details>
<summary>🔓 Voir la réponse</summary>

| | GLPI | MDM |
|--|------|-----|
| **Type** | Gestion **passive** | Gestion **active** |
| **Cible** | Parc fixe (PC, serveurs) | Appareils **mobiles** |
| **Actions** | Inventaire, tickets | Déployer, verrouiller, effacer à distance |

</details>

---

### Question 25.2
**Quels sont les 3 axes de la gestion de parc ?**

<details>
<summary>🔓 Voir la réponse</summary>

1. **Entretenir** : Maintenir en état de fonctionnement
2. **Développer** : Faire évoluer, renouveler le matériel
3. **Optimiser** : Améliorer l'efficacité, former les users

</details>

---

# 🏢 MODULE 26 : ORGANISATION DSI

### Question 26.1
**Quelle est la différence entre Dev et Ops ?**

<details>
<summary>🔓 Voir la réponse</summary>

- **Dev** = Développe les logiciels
- **Ops** = Déploie et maintient l'infrastructure

**DevOps** = Approche pour réconcilier Dev et Ops → CI/CD, IaC, automatisation

**⚠️ DevOps = une APPROCHE, pas un métier**

</details>

---

### Question 26.2
**Qui est responsable de la sécurité du SI ?**

<details>
<summary>🔓 Voir la réponse</summary>

**TOUT LE MONDE !**

Mais piloté par le **RSSI** (Responsable Sécurité des SI) ou CISO en anglais.

</details>

---

# 🌐 MODULE 27 : SERVEURS WEB

### Question 27.1
**Quels sont les 3 composants essentiels du Web ?**

<details>
<summary>🔓 Voir la réponse</summary>

1. **HTTP** (protocole de transfert)
2. **URL** (adresse des ressources)
3. **HTML** (langage de description)

</details>

---

### Question 27.2
**Quelle est la différence entre proxy et reverse proxy ?**

<details>
<summary>🔓 Voir la réponse</summary>

| | Proxy (Forward) | Reverse Proxy |
|--|-----------------|---------------|
| **Côté** | CLIENT | SERVEUR |
| **Usage** | Cache, filtrage, anonymat | Répartition charge, sécurité, cache |

</details>

---

# ✅ FIN DU QUESTIONNAIRE

## Conseils pour l'examen

1. **Questionnaire professionnel (2h)** : Questions ouvertes, réponses justifiées
2. **MSP (2h30)** : Manipulations sur VM
3. **Entretien technique (45 min)** : Devant le jury, résolution d'incidents
4. **Entretien final (20 min)** : Discussion sur le dossier professionnel

**Bonne chance !** 🎓
