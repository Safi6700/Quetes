
---
## 🎯 L'essentiel (6 points)

1. **IPv4 = 32 bits** — notation décimale pointée (ex: 192.168.1.1)
2. **CIDR /XX** = nombre de bits réseau (ex: /24 = 24 bits réseau)
3. **Adresse réseau** = première adresse | **Broadcast** = dernière adresse
4. **Nb hôtes = 2^(32-CIDR) - 2** (on retire réseau + broadcast)
5. **RFC 1918** = plages privées (10, 172.16-31, 192.168)
6. **APIPA 169.254.x.x** = pas de DHCP trouvé

---

## 🔢 Plages indispensables

| Plage              | Type          | Retenir         |
| ------------------ | ------------- | --------------- |
| **10.0.0.0/8**     | Privé RFC1918 | Classe A privée |
| **172.16.0.0/12**  | Privé RFC1918 | 172.16 → 172.31 |
| **192.168.0.0/16** | Privé RFC1918 | Classe C privée |
| **127.0.0.0/8**    | Loopback      | Boucle locale   |
| **169.254.0.0/16** | APIPA         | Problème DHCP ! |

---

## 📐 Calculs attendus

**Trouver réseau + broadcast :**
- Réseau = mettre tous les bits hôte à 0
- Broadcast = mettre tous les bits hôte à 1

**Nombre d'hôtes :**
```js
Nb hôtes = 2^(32-CIDR) - 2
```

| CIDR | Calcul | Nb hôtes |
|------|--------|----------|
| /24 | 2^8 - 2 | 254 |
| /25 | 2^7 - 2 | 126 |
| /26 | 2^6 - 2 | 62 |
| /30 | 2^2 - 2 | 2 |

---

## ⚠️ Piège classique

> **Oublier le -2** → on retire TOUJOURS réseau + broadcast
> 
> **Confondre réseau / broadcast** → réseau = première, broadcast = dernière
> 
> **169.254.x.x = APIPA** → le client n'a PAS trouvé de serveur DHCP !

---

## 📝 QUIZ Checkpoint (8 questions)

### Question 1
**Combien de bits dans une adresse IPv4 ?**
> [!success]- 🔓 Réponse
> 32 bits (4 octets)

---

### Question 2
**Que signifie /24 ?**
> [!success]- 🔓 Réponse
> 24 bits pour le réseau, masque 255.255.255.0

---

### Question 3
**Formule du nombre d'hôtes ?**
> [!success]- 🔓 Réponse
> 2^(32-CIDR) - 2

---

### Question 4
**Quelles sont les 3 plages privées RFC 1918 ?**
> [!success]- 🔓 Réponse
> 10.0.0.0/8, 172.16.0.0/12, 192.168.0.0/16

---

### Question 5
**Adresse réseau de 192.168.10.50/24 ?**
> [!success]- 🔓 Réponse
> 192.168.10.0

---

### Question 6
**Broadcast de 192.168.10.0/24 ?**
> [!success]- 🔓 Réponse
> 192.168.10.255

---

### Question 7
**Combien d'hôtes dans un /26 ?**
> [!success]- 🔓 Réponse
> 2^6 - 2 = 62 hôtes

---

### Question 8
**DIAGNOSTIC : Un PC a l'adresse 169.254.15.20. Quel est le problème ?**
> [!success]- 🔓 Réponse
> Adresse APIPA = le client n'a pas trouvé de serveur DHCP. Vérifier : câble, service DHCP, config réseau.



## 🎤 À retenir pour l'oral

> **IPv4 = 32 bits**, notation CIDR /XX pour le masque.
>  **Formule hôtes : 2^(32-CIDR) - 2** (toujours retirer réseau + broadcast). 
>  **3 plages privées RFC 1918** : 10.x, 172.16-31.x, 192.168.x. 
>  **169.254.x.x = APIPA** → diagnostic immédiat : pas de DHCP. 
>  Savoir calculer adresse réseau (bits hôte à 0) et broadcast (bits hôte à 1).