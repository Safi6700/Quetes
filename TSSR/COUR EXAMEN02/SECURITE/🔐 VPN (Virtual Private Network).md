
---

## 🎯 L'essentiel (définitions courtes à apprendre)

1. **VPN** = tunnel **chiffré** qui permet de se connecter à un réseau distant de façon sécurisée

2. **Tunnel** = passage sûr à travers un réseau (encapsulation + chiffrement)

3. **VPN Site-à-Site** = relie **2 réseaux** d'entreprise (ex: Paris ↔ Montréal). Permanent et transparent pour les users

4. **VPN Nomade** (accès distant) = un **user** se connecte au réseau de l'entreprise depuis chez lui

5. **IPsec** = protocole VPN niveau 3 (couche réseau), utilisé pour site-à-site

6. **OpenVPN** = solution VPN basée sur **TLS**, port 1194 (UDP ou TCP)

---

## 📋 Types de VPN (Question CP4 Q6.4)

| Type | C'est quoi | Exemple |
|------|------------|---------|
| **Site-à-Site** | Relie 2 réseaux | Paris ↔ Montréal (permanent) |
| **Nomade** (accès distant) | 1 user → réseau entreprise | Télétravail |
| **Point-à-point** | 1 machine → 1 machine | Maintenance distante |

---

## 🔄 Protocoles VPN

| Protocole | Niveau OSI | Particularité |
|-----------|-----------|---------------|
| **IPsec** | Couche 3 (réseau) | Standard, boîtiers VPN |
| **OpenVPN** | TLS | Libre, port 1194 |
| **WireGuard** | Moderne | Léger, rapide |
| L2TP, GRE | Tunnel seul | Pas de chiffrement natif |

---

## 🔐 IPsec en bref

- Niveau IP (couche 3)
- **Transparent** pour les applications
- **AH** = authentification + intégrité
- **ESP** = authentification + intégrité + **chiffrement**
- Mode **tunnel** = protège tout le paquet (site-à-site)
- Mode **transport** = protège les données uniquement

---

## ⚠️ Piège classique

> **VPN ≠ 100% sécurisé**
> - Un VPN ouvre une **brèche** entre 2 réseaux
> - Nécessite : authentification robuste + surveillance

---

## ✅ Checkpoint examen

**Questions Checkpoint 4 :**
- **Q6.4** : Identifier le type de VPN (site-à-site ou nomade)
- **Q6.6** : Traduire une config IPsec/ISAKMP

---

## 📝 QUIZ Checkpoint

### Question 1
**C'est quoi un VPN ?**
> [!success]- 🔓 Réponse
> Tunnel **chiffré** pour se connecter à un réseau distant de façon sécurisée.

---

### Question 2
**Différence VPN site-à-site et nomade ? (Question CP4)**
> [!success]- 🔓 Réponse
> - **Site-à-site** = 2 réseaux reliés (permanent, transparent)
> - **Nomade** = 1 user se connecte au réseau entreprise

---

### Question 3
**C'est quoi IPsec ?**
> [!success]- 🔓 Réponse
> Protocole VPN niveau 3 (IP). AH = intégrité, ESP = intégrité + **chiffrement**.

---

### Question 4
**C'est quoi OpenVPN ?**
> [!success]- 🔓 Réponse
> Solution VPN libre basée sur **TLS**, port 1194 (UDP ou TCP).

---

### Question 5
**Différence mode tunnel et transport (IPsec) ?**
> [!success]- 🔓 Réponse
> - **Tunnel** = protège tout le paquet (site-à-site)
> - **Transport** = protège les données seulement

---

### Question 6
**Un VPN est-il 100% sécurisé ?**
> [!success]- 🔓 Réponse
> Non, un VPN ouvre une **brèche** entre 2 réseaux. Il faut authentification robuste + surveillance.

---

## 🎤 À retenir pour l'oral

> **VPN** = tunnel chiffré vers un réseau distant

> **Site-à-site** = 2 réseaux (permanent) / **Nomade** = 1 user (télétravail)

> **IPsec** = niveau 3, AH (intégrité) + ESP (chiffrement)

> **OpenVPN** = basé sur TLS, port 1194

> **Attention** : VPN = brèche réseau → bien sécuriser

---