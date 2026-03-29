---


---

## 📚 MODULE 1 : LE ROUTAGE (Bases)

> [!question]- C'est quoi le routage ?
> Technique pour faire communiquer des nœuds de **réseaux IP différents** via des intermédiaires appelés **routeurs**

> [!question]- C'est quoi un routeur ?
> Passerelle présente sur **plusieurs réseaux** qui transmet les paquets vers leur destination

> [!question]- Comment une machine sait si le destinataire est sur le même réseau ?
> Elle calcule le réseau de ses interfaces et vérifie si l'IP destination en fait partie

> [!question]- Destinataire sur le même réseau → que se passe-t-il ?
> Envoi **direct** via Ethernet. Utilisation de **ARP** (IPv4) ou **NDP** (IPv6) pour trouver l'adresse MAC du destinataire

> [!question]- Destinataire sur un autre réseau → que se passe-t-il ?
> La machine consulte sa **table de routage** pour trouver le routeur (next hop) et envoie la trame à l'adresse MAC du **routeur** (pas du destinataire final)

> [!question]- Dans une trame routée, quelle adresse MAC destination ?
> L'adresse MAC du **routeur** (passerelle), PAS celle du destinataire final

> [!question]- Dans une trame routée, quelle adresse IP destination ?
> L'adresse IP du **destinataire final** (elle ne change pas)

> [!question]- C'est quoi ARP ?
> Address Resolution Protocol → Résout une adresse **IP en MAC** sur IPv4 (broadcast)

> [!question]- C'est quoi NDP ?
> Neighbor Discovery Protocol → Résout une adresse **IP en MAC** sur IPv6 (multicast)

> [!question]- C'est quoi une table de routage ?
> Liste des routeurs accessibles et des réseaux qu'ils permettent de joindre

> [!question]- Que contient une entrée de table de routage ?
> **Destination** (réseau + masque), **Next hop** (passerelle), interface, métrique

> [!question]- C'est quoi la passerelle par défaut ?
> Routeur utilisé quand aucune route spécifique ne correspond (default gateway)

> [!question]- C'est quoi la métrique ?
> Mesure de qualité d'une route (plus c'est bas = meilleur)

> [!question]- En IPv6, quelle adresse pour les passerelles ?
> Les adresses **lien-local** (fe80::...)

---

## 📚 MODULE 2 : COMMANDES ROUTAGE

> [!question]- Afficher table de routage IPv4 (Linux)
> `ip route`

> [!question]- Afficher table de routage IPv6 (Linux)
> `ip -6 route`

> [!question]- Ajouter une route (Linux)
> `ip route add 192.168.128.0/17 via 10.0.0.2`

> [!question]- Ajouter passerelle par défaut (Linux)
> `ip route add default via 10.0.0.254`

> [!question]- Activer routage IPv4 sur Linux (temporaire)
> `sysctl -w net.ipv4.ip_forward=1`

> [!question]- Activer routage IPv6 sur Linux (temporaire)
> `sysctl -w net.ipv6.conf.all.forwarding=1`

> [!question]- Fichier config persistante routage Linux
> `/etc/sysctl.conf`

> [!question]- Afficher table de routage (Windows)
> `route print` ou `Get-NetRoute` (PowerShell)

> [!question]- Ajouter une route (Windows)
> `route add 192.168.128.0/17 10.0.0.2`

---

## 📚 MODULE 3 : ROUTAGE DYNAMIQUE

> [!question]- C'est quoi le routage dynamique ?
> Mise à jour **automatique** des tables de routage entre routeurs + basculement auto en cas de panne

> [!question]- Quand utiliser le routage dynamique ?
> Réseaux avec **plus de 5 routeurs** ou réseaux instables/changeants

> [!question]- Les 4 protocoles de routage dynamique ?
> **RIP**, **EIGRP**, **OSPF**, **BGP**

> [!question]- RIP - caractéristiques
> Petits réseaux, simple, max **15 sauts**, port UDP **520**

> [!question]- RIP - versions
> RIPv1 et RIPv2 (IPv4), RIPng (IPv6)

> [!question]- EIGRP - caractéristiques
> Grands réseaux, **Cisco uniquement**, convergence rapide, port **88**

> [!question]- OSPF - caractéristiques
> Réseaux moyens/grands, **protocole ouvert**, supporte VLSM, port **89**

> [!question]- BGP - caractéristiques
> Routage **Internet**, entre systèmes autonomes (ISP), port TCP **179**

---

## 📚 MODULE 4 : PROTOCOLES DE TRANSPORT (UDP)

> [!question]- UDP c'est quoi ?
> User Datagram Protocol - Protocole de couche 4 **léger et non fiable**

> [!question]- UDP - numéro de protocole IP
> **17**

> [!question]- UDP - mode connecté ?
> **Non** - pas de connexion établie

> [!question]- UDP - fiabilité ?
> **Aucune** - pas de retransmission, pas de garantie d'ordre

> [!question]- UDP - taille entête
> **8 octets** (4 champs de 16 bits)

> [!question]- UDP - champs de l'entête
> Port source, Port destination, Longueur, Checksum

> [!question]- UDP - cas d'usage
> DNS, Streaming, DHCP, diffusion d'infos temps réel

---

## 📚 MODULE 5 : PROTOCOLES DE TRANSPORT (TCP)

> [!question]- TCP c'est quoi ?
> Transmission Control Protocol - Protocole de couche 4 **fiable et connecté**

> [!question]- TCP - numéro de protocole IP
> **6**

> [!question]- TCP - mode connecté ?
> **Oui** - connexion établie avant échange

> [!question]- TCP - fiabilité ?
> **Oui** - acquittements, retransmissions, ordre garanti

> [!question]- TCP - les 6 flags de contrôle
> **SYN**, **ACK**, **FIN**, **RST**, **PSH**, **URG**

> [!question]- TCP - établissement connexion (3-way handshake)
> 1. Client → SYN
> 2. Serveur → SYN + ACK
> 3. Client → ACK

> [!question]- TCP - fermeture connexion
> 4. FIN → 2. ACK → 3. FIN → 4. ACK

> [!question]- C'est quoi le numéro de séquence ?
> Numéro identifiant chaque segment pour garantir l'ordre

> [!question]- C'est quoi le numéro d'acquittement ?
> Indique le prochain numéro de séquence attendu (= j'ai bien reçu jusqu'ici)

> [!question]- C'est quoi la fenêtre TCP (Window) ?
> Nombre d'octets que le destinataire est prêt à recevoir (contrôle de flux)

---

## 📚 MODULE 6 : LES PORTS

> [!question]- C'est quoi un port ?
> Identifiant de processus/application sur une interface (16 bits = 0-65535)

> [!question]- Ports 0-1023
> **Well Known Ports** - ports système/serveurs standards (réservés)

> [!question]- Ports 1024-49151
> **Registered Ports** - ports utilisateurs/serveurs enregistrés

> [!question]- Ports 49152-65535
> **Ephemeral Ports** - ports dynamiques pour les clients

> [!question]- Port DNS
> **53** (TCP et UDP)

> [!question]- Port HTTP / HTTPS
> **80** / **443**

> [!question]- Port SSH
> **22**

> [!question]- Port DHCP
> **67** (serveur) et **68** (client)

---

## 💡 LES 10 TRUCS À CONNAÎTRE PAR CŒUR

1. **ARP** = IP → MAC en IPv4 / **NDP** = IP → MAC en IPv6
2. Trame routée = MAC du **routeur**, IP du **destinataire final**
3. **Table de routage** = destination + next hop + métrique
4. Activer routage Linux = `net.ipv4.ip_forward=1`
5. **RIP** = petits réseaux, 15 sauts max, port 520
6. **OSPF** = protocole ouvert, réseaux moyens, port 89
7. **BGP** = Internet, entre ISP, port TCP 179
8. **UDP** = léger, non fiable, port 17
9. **TCP** = fiable, connecté, 3-way handshake (SYN, SYN-ACK, ACK)
10. Ports : 0-1023 système, 49152+ clients

---

