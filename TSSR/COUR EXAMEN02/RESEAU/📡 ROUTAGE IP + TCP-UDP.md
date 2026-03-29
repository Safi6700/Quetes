
---

## 🎯 L'essentiel (5 points)

1. **Table de routage** = liste des destinations + passerelle (next hop) pour y aller
2. **Passerelle par défaut** (default gateway) = où envoyer si destination inconnue
3. **Routage statique** = routes configurées manuellement (petits réseaux)
4. **Routage dynamique** = routes apprises automatiquement (OSPF, BGP)
5. **TCP = fiable + connexion** / **UDP = rapide + sans connexion**

---

## 📋 Table de routage — Composition

| Élément | Description |
|---------|-------------|
| **Destination** | Adresse réseau + masque |
| **Next hop** | Adresse de la passerelle |
| **Interface** | Interface de sortie |
| **Métrique** | Qualité de la route (moins = mieux) |

---

## 🔄 TCP Handshake (poignée de main à 3 voies)

```js
CLIENT                                     SERVEUR
   |                                          |
Fermé                                       Fermé
   |                                          |
   |                                        Écoute
   |                                          |
   |-------- 1. SYN (Seq=x) ----------------> |
   |                                          |
Attente                                    Attente
   |                                          |
   |<------- 2. SYN-ACK (Seq=y, Ack=x+1) ---- |
   |                                          |
   |-------- 3. ACK (Seq=x+1, Ack=y+1) -----> |
   |                                          |
Connecté                                  Connecté
```

| État CLIENT | État SERVEUR |
|-------------|--------------|
| Fermé | Fermé |
| — | Écoute (LISTEN) |
| Attente (SYN-SENT) | Attente (SYN-RECEIVED) |
| Connecté (ESTABLISHED) | Connecté (ESTABLISHED) |

---

## 📝 TCP vs UDP

| | TCP | UDP |
|--|-----|-----|
| **Connexion** | Oui (handshake) | Non |
| **Fiabilité** | Oui (ACK, retransmission) | Non |
| **Ordre garanti** | Oui | Non |
| **Rapidité** | Lent | Rapide |
| **N° protocole** | 6 | 17 |
| **Usage** | HTTP, SSH, FTP | DNS, DHCP, VoIP |

---

## 🔧 Commandes

| Commande                                   | OS         | Rôle                                     |
| ------------------------------------------ | ---------- | ---------------------------------------- |
| `ip route`                                 | Linux      | Afficher table routage IPv4              |
| `ip -6 route`                              | Linux      | Afficher table routage IPv6              |
| `ip route add 192.168.1.0/24 via 10.0.0.1` | Linux      | Ajouter une route                        |
| `ip route add default via 10.0.0.254`      | Linux      | Ajouter passerelle par défaut            |
| `route print`                              | Windows    | Afficher table routage                   |
| `route add 192.168.1.0/24 10.0.0.1`        | Windows    | Ajouter une route                        |
| `Get-NetRoute`                             | PowerShell | Afficher table routage                   |
| `sysctl net.ipv4.ip_forward=1`             | Linux      | Activer routage (transformer en routeur) |

---

## 📝 Protocoles de routage dynamique

| Protocole | Usage | Port |
|-----------|-------|------|
| **OSPF** | Réseaux internes | — |
| **BGP** | Entre FAI / Internet | TCP 179 |
| **EIGRP** | Cisco uniquement | 88 |

---

## ⚠️ Piège classique

> **Routage statique** = pour petits réseaux stables  
> **Routage dynamique** = pour grands réseaux qui changent

> **Forwarding désactivé par défaut** sur Linux → `sysctl net.ipv4.ip_forward=1` pour activer

---

## 📝 QUIZ Checkpoint

### Question 1
**C'est quoi une table de routage ?**

> [!success]- 🔓 Réponse
> Liste des destinations (réseaux) + passerelle (next hop) pour les atteindre  
> Chaque nœud IP (routeur ou non) en possède une

---

### Question 2
**C'est quoi la passerelle par défaut ?**

> [!success]- 🔓 Réponse
> L'adresse du routeur où envoyer les paquets quand la destination n'est pas dans la table  
> = route par défaut (default gateway)

---

### Question 3
**Décris le TCP handshake (3 étapes)**

> [!success]- 🔓 Réponse
> 1. **Client → SYN** (demande connexion, Seq=x)
> 2. **Serveur → SYN-ACK** (accepte, Seq=y, Ack=x+1)
> 3. **Client → ACK** (confirme, Seq=x+1, Ack=y+1)
> → Connexion établie

---

### Question 4
**Différence TCP vs UDP ?**

> [!success]- 🔓 Réponse
> - **TCP** : fiable, connexion, ordre garanti, lent (HTTP, SSH)
> - **UDP** : rapide, pas de connexion, pas fiable (DNS, DHCP, VoIP)

---

### Question 5
**Commande Linux pour voir la table de routage ?**

> [!success]- 🔓 Réponse
> `ip route` (IPv4) ou `ip -6 route` (IPv6)

---

### Question 6
**Comment transformer un Linux en routeur ?**

> [!success]- 🔓 Réponse
> Activer le forwarding IP :  
> `sysctl -w net.ipv4.ip_forward=1`  
> Pour persistant : modifier `/etc/sysctl.conf`

---

### Question 7
**C'est quoi OSPF et BGP ?**

> [!success]- 🔓 Réponse
> Protocoles de **routage dynamique** :
> - **OSPF** : réseaux internes d'entreprise
> - **BGP** : entre FAI / sur Internet (port TCP 179)

---

### Question 8
**Quels sont les flags TCP importants ?**

> [!success]- 🔓 Réponse
> - **SYN** : demande connexion
> - **ACK** : acquittement
> - **FIN** : fin de connexion
> - **RST** : reset connexion

---
## 🎤 À retenir pour l'oral

> **Table de routage** = liste destination + passerelle (next hop) pour atteindre chaque réseau

> **Passerelle par défaut** (default gateway) = où envoyer si destination inconnue

> **TCP Handshake** : SYN → SYN-ACK → ACK (3 étapes pour établir connexion)

> **TCP vs UDP** : TCP = fiable, connexion, lent (HTTP, SSH) | UDP = rapide, sans connexion (DNS, DHCP, VoIP)

> **Activer routage Linux** : `sysctl net.ipv4.ip_forward=1` (désactivé par défaut)

> **Commandes** : `ip route` (Linux) | `route print` (Windows) pour voir la table de routage





