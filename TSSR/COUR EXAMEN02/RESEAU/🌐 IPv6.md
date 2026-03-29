
---

## 🎯 L'essentiel (6 points max)

1. **128 bits** = ~3,4 × 10³⁸ adresses
2. **3 types** : Unicast, Multicast, Anycast — **PAS de Broadcast**
3. **Link-Local (fe80::/10)** = obligatoire, auto-configuré, **non routable**
4. **Unique Local (fd00::/8)** = privé, routable en interne
5. **Global Unicast (2000::/3)** = public, routable Internet
6. **SLAAC** = autoconfiguration sans DHCP

---

## 🔑 Préfixes à connaître

| Préfixe       | Type           | Retenir                 |
| ------------- | -------------- | ----------------------- |
| **::**        | Indéfinie      | Adresse non spécifiée   |
| **::1/128**   | Loopback       | Boucle locale           |
| **fe80::/10** | Link-Local     | Non routable, auto      |
| **fd00::/8**  | Unique Local   | Privé, routable interne |
| **2000::/3**  | Global Unicast | Public, Internet        |
| **ff00::/8**  | Multicast      | Groupe                  |

---

## ⚠️ Piège classique

> **fe80 ≠ fd ≠ 2000**
> - **fe80** = Link-Local = **NON ROUTABLE** (ne passe jamais un routeur)
> - **fd00** = Unique Local = privé, routable en interne
> - **2000** = Global = public, routable partout

---

## 📝 QUIZ Checkpoint (8 questions)

### Question 1
**Taille d'une adresse IPv6 ?**
> [!success]- 🔓 Réponse
> 128 bits

---

### Question 2
**Les 3 types d'adresses IPv6 ?**
> [!success]- 🔓 Réponse
> Unicast, Multicast, Anycast (pas de Broadcast)

---

### Question 3
**Préfixe des adresses Link-Local ?**
> [!success]- 🔓 Réponse
> fe80::/10

---

### Question 4
**L'adresse fe80:: est-elle routable ?**
> [!success]- 🔓 Réponse
> NON, elle ne passe pas les routeurs

---

### Question 5
**Préfixe des adresses privées (Unique Local) ?**
> [!success]- 🔓 Réponse
> fd00::/8 (ou fc00::/7)

---

### Question 6
**Préfixe des adresses publiques (Global Unicast) ?**
> [!success]- 🔓 Réponse
> 2000::/3

---

### Question 7
**C'est quoi SLAAC ?**
> [!success]- 🔓 Réponse
> StateLess Address AutoConfiguration = autoconfiguration sans DHCP

---

### Question 8
**DIAGNOSTIC : Une machine a une adresse fe80:: mais ne communique pas avec un autre réseau. Pourquoi ?**
> [!success]- 🔓 Réponse
> fe80 = Link-Local = **non routable**. Elle ne peut communiquer que sur son lien local (même segment réseau).


## 🎤 À retenir pour l'oral

> **IPv6 = 128 bits** (vs 32 bits IPv4), notation hexadécimale.
> 
> **3 types d'adresses** : Unicast, Multicast, Anycast (pas de Broadcast).
> 
> **fe80::/10** = Link-Local (non routable, équivalent APIPA).
> 
> **2000::/3** = Global Unicast (adresses publiques).
> 
> **fd00::/8** = Unique Local (équivalent RFC 1918 privé).
> 
> **::1** = Loopback (équivalent 127.0.0.1).
> 
> **SLAAC** = autoconfiguration sans DHCP, génère l'adresse automatiquement.
> 
> **DHCPv6** = ports UDP 546 (client) et 547 (serveur).