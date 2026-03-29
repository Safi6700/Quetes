
---

## 🎯 L'essentiel (5 points)

1. **DHCP** = attribution automatique de config IP (adresse, masque, passerelle, DNS)
2. **Ports UDP 67** (serveur) et **UDP 68** (client)
3. **Bail (lease)** = durée de validité de l'adresse attribuée
4. **Séquence DORA** = Discover → Offer → Request → Ack
5. **Client s'identifie par MAC** — IP source initiale : 0.0.0.0

---

## 🔄 Séquence DORA (à connaître par cœur)

```js
CLIENT (0.0.0.0)                           SERVEUR
      |                                        |
      |-- 1. DISCOVER (broadcast) ------------>|  "Qui peut me donner une IP ?"
      |                                        |
      |<-- 2. OFFER ---------------------------|  "Je te propose 192.168.1.50"
      |                                        |
      |-- 3. REQUEST (broadcast) ------------->|  "OK je prends 192.168.1.50"
      |                                        |
      |<-- 4. ACK -----------------------------|  "Validé pour X heures"
      |                                        |
```

| Étape | Message | Direction | Rôle |
|-------|---------|-----------|------|
| **D** | DISCOVER | Client → Broadcast | Recherche serveur DHCP |
| **O** | OFFER | Serveur → Client | Proposition de config |
| **R** | REQUEST | Client → Broadcast | Acceptation de l'offre |
| **A** | ACK | Serveur → Client | Confirmation du bail |

---

## 📝 Paramètres envoyés

| Obligatoire | Optionnel |
|-------------|-----------|
| Adresse IP | Passerelle par défaut |
| Masque (CIDR) | DNS |
| Durée du bail | Nom de domaine |
| | Serveur PXE |

---

## 📨 Autres messages DHCP

| Message     | Direction        | Rôle                               |
| ----------- | ---------------- | ---------------------------------- |
| **NACK**    | Serveur → Client | Refus de réservation               |
| **DECLINE** | Client → Serveur | Client refuse (IP déjà utilisée)   |
| **RELEASE** | Client → Serveur | Résiliation du bail                |
| **INFORM**  | Client → Serveur | Demande config sans réservation IP |

---

## 🔧 Commandes

| Commande | OS | Rôle |
|----------|-----|------|
| `dhclient -r` | Linux | Libérer le bail |
| `dhclient eth0` | Linux | Demander nouvelle IP |
| `ipconfig /release` | Windows | Libérer le bail |
| `ipconfig /renew` | Windows | Renouveler le bail |

---

## ⚠️ Piège classique

> **DISCOVER et REQUEST sont envoyés en BROADCAST** (pas en unicast)  
> Pourquoi ? Le client n'a **pas encore d'IP valide** (source = 0.0.0.0)

> **DHCP ne traverse pas les routeurs** par défaut → utiliser **ip-helper** pour relayer

---

## 📝 QUIZ Checkpoint

### Question 1
**Quels ports utilise DHCP ?**

> [!success]- 🔓 Réponse
> **UDP 67** (serveur) et **UDP 68** (client)

---

### Question 2
**Que signifie DORA ?**

> [!success]- 🔓 Réponse
> **D**iscover → **O**ffer → **R**equest → **A**ck  
> Séquence d'obtention d'une IP en DHCP

---

### Question 3
**Le serveur DHCP est actif mais le client ne reçoit pas d'IP. Causes possibles ?**

> [!success]- 🔓 Réponse
> - Client et serveur **pas sur le même réseau/VLAN**
> - **Pare-feu** bloque ports 67/68
> - **Câble** non connecté ou mauvais mode réseau (NAT au lieu de réseau interne)
> - Pool d'adresses **épuisé**
> - Service DHCP **non démarré**

---

### Question 4
**Un client a l'IP 169.254.x.x — Que s'est-il passé ?**

> [!success]- 🔓 Réponse
> Pas de serveur DHCP trouvé → le client s'est attribué une **adresse APIPA**  
> Plage : **169.254.0.0/16** — communication locale uniquement

---

### Question 5
**Quelle est la différence entre RELEASE et DECLINE ?**

> [!success]- 🔓 Réponse
> - **RELEASE** : client **rend** son bail volontairement
> - **DECLINE** : client **refuse** l'IP car elle est déjà utilisée (détecté par ARP)

---

### Question 6
**Comment le serveur identifie le client ?**

> [!success]- 🔓 Réponse
> Par son **adresse MAC** (ou option 61 Client Identifier)

---

### Question 7
**Que se passe-t-il au redémarrage si le bail est encore valide ?**

> [!success]- 🔓 Réponse
> Le client envoie directement **REQUEST** (pas DISCOVER)  
> Le serveur répond **ACK** si IP encore valide, sinon **NACK**

---

### Question 8
**Commande Windows pour libérer puis renouveler l'IP ?**

> [!success]- 🔓 Réponse
> `ipconfig /release` puis `ipconfig /renew`


---

## 🎤 À retenir pour l'oral

> **DHCP** = attribution automatique d'IP, ports **UDP 67** (serveur) et **UDP 68** (client)

> **Séquence DORA** : Discover → Offer → Request → Acknowledge (tout en broadcast sauf Offer)

> **Bail** = durée de validité de l'IP. Renouvellement à 50%, broadcast à 87.5%, libération à 100%

> **APIPA 169.254.x.x** = pas de serveur DHCP trouvé → autoconfiguration locale uniquement

> **Diagnostic** : client sans IP = vérifier câble/VLAN, pare-feu ports 67-68, service DHCP démarré, pool non épuisé

> **Commandes** : `ipconfig /release` + `/renew` (Windows) | `dhclient -r` + `dhclient` (Linux)

---

