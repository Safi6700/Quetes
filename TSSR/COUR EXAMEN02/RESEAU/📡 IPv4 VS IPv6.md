
---

## 🎯 L'essentiel (5 points)

1. **IPv4** = 32 bits (4 octets) — notation décimale pointée (192.168.1.1)
2. **IPv6** = 128 bits — notation hexadécimale avec `:` (2001:db8::1)
3. **CIDR** = notation /XX pour indiquer le masque (ex: /24 = 255.255.255.0)
4. **Adresse réseau** = IP ET masque (premiers bits) / **Broadcast** = dernière adresse
5. **IPv6 : pas de broadcast** → multicast + anycast / **SLAAC** = autoconfiguration

---

## 📊 Comparatif IPv4 vs IPv6

| | IPv4 | IPv6 |
|--|------|------|
| **Longueur** | 32 bits | 128 bits |
| **Notation** | Décimal pointé | Hexadécimal |
| **Séparateur** | `.` | `:` |
| **Nb adresses** | 4,3 milliards | 3,4×10³⁸ |
| **Config** | Statique, DHCP | SLAAC, DHCPv6 |
| **Broadcast** | Oui | Non (multicast) |
| **IPsec** | Optionnel | Intégré |

---

## 📝 Plages privées IPv4 (RFC 1918)

| Classe | Plage | CIDR |
|--------|-------|------|
| A | 10.0.0.0 – 10.255.255.255 | /8 |
| B | 172.16.0.0 – 172.31.255.255 | /12 |
| C | 192.168.0.0 – 192.168.255.255 | /16 |

---

## 📝 Adresses IPv6 importantes

| Type | Préfixe | Usage |
|------|---------|-------|
| **Loopback** | `::1/128` | Boucle locale |
| **Link-Local** | `fe80::/10` | LAN uniquement, non routable, auto |
| **Unique Local** | `fc00::/7` (fd00::/8) | Réseau privé, routable en interne |
| **Global Unicast** | `2000::/3` | Internet, routable |
| **Multicast** | `ff00::/8` | Multi-destinataires |

---

## 🔢 Calcul d'adresse réseau (IPv4)

```js
Exemple : 172.16.20.19/20

Adresse : 10101100.00010000.00010100.00010011
Masque :  11111111.11111111.11110000.00000000  (/20 = 255.255.240.0)
          ─────────────────────────────────────
Réseau :  10101100.00010000.00010000.00000000  = 172.16.16.0

Broadcast : 172.16.31.255 (dernière adresse)
Nb hôtes : 2^(32-20) - 2 = 4094
```

---

## 📋 Masques courants

| CIDR | Masque | Nb hôtes |
|------|--------|----------|
| /8 | 255.0.0.0 | 16 777 214 |
| /16 | 255.255.0.0 | 65 534 |
| /24 | 255.255.255.0 | 254 |
| /25 | 255.255.255.128 | 126 |
| /30 | 255.255.255.252 | 2 |

---

## 🔧 Commandes

| Commande | OS | Rôle |
|----------|-----|------|
| `ip a` | Linux | Voir config IP |
| `ip addr add 192.168.1.10/24 dev eth0` | Linux | Ajouter IP |
| `ipconfig` | Windows | Voir config IP |
| `ipconfig /all` | Windows | Config IP détaillée |

---

## ⚠️ Piège classique

> **169.254.x.x** = adresse APIPA → le client n'a pas trouvé de DHCP !

> **fe80::** = adresse link-local IPv6 → **non routable**, LAN uniquement

> **Nb hôtes = 2^n - 2** → on retire adresse réseau + broadcast

---

## 📝 QUIZ Checkpoint

### Question 1
**Quelle est la différence entre IPv4 et IPv6 ?**

> [!success]- 🔓 Réponse
> - **IPv4** : 32 bits, décimal pointé, 4,3 milliards d'adresses
> - **IPv6** : 128 bits, hexadécimal, 3,4×10³⁸ adresses
> - IPv6 : pas de broadcast, IPsec intégré, SLAAC

---

### Question 2
**Calculer l'adresse réseau de 192.168.10.50/24**

> [!success]- 🔓 Réponse
> /24 = 255.255.255.0 → 3 octets réseau  
> Adresse réseau : **192.168.10.0**  
> Broadcast : **192.168.10.255**

---

### Question 3
**Quelles sont les plages privées IPv4 ?**

> [!success]- 🔓 Réponse
> - **10.0.0.0/8** (classe A)
> - **172.16.0.0/12** (classe B : 172.16 à 172.31)
> - **192.168.0.0/16** (classe C)

---

### Question 4
**C'est quoi une adresse fe80:: ?**

> [!success]- 🔓 Réponse
> Adresse **Link-Local IPv6** (fe80::/10)  
> - Configurée automatiquement (SLAAC)
> - Communication LAN uniquement
> - **Non routable**

---

### Question 5
**C'est quoi SLAAC ?**

> [!success]- 🔓 Réponse
> **Stateless Address Autoconfiguration**  
> - Autoconfiguration IPv6 sans serveur DHCP
> - L'hôte génère son adresse automatiquement

---

### Question 6
**Combien d'hôtes dans un réseau /26 ?**

> [!success]- 🔓 Réponse
> 2^(32-26) - 2 = 2^6 - 2 = **62 hôtes**

---

### Question 7
**Un PC a l'IP 169.254.10.5 — Que s'est-il passé ?**

> [!success]- 🔓 Réponse
> Pas de serveur DHCP trouvé → **adresse APIPA**  
> Plage 169.254.0.0/16 — communication locale uniquement

---

### Question 8
**C'est quoi le broadcast en IPv4 ? Existe-t-il en IPv6 ?**

> [!success]- 🔓 Réponse
> - **IPv4** : dernière adresse du réseau, envoie à tous les hôtes
> - **IPv6** : **pas de broadcast** → remplacé par **multicast** (ff00::/8)

---

## 🎤 À retenir pour l'oral

> **IPv4** = 32 bits, notation décimale pointée (192.168.1.1)

> **IPv6** = 128 bits, notation hexadécimale (2001:db8::1), pas de broadcast

> **CIDR** = notation /XX pour le masque (/24 = 255.255.255.0)

> **Plages privées RFC 1918** : 10.0.0.0/8 | 172.16.0.0/12 | 192.168.0.0/16

> **169.254.x.x = APIPA** → pas de serveur DHCP trouvé

> **fe80::/10** = Link-Local IPv6 (non routable, LAN uniquement)

> **SLAAC** = autoconfiguration IPv6 sans DHCP

> **Formule hôtes** : 2^(32-CIDR) - 2

---

