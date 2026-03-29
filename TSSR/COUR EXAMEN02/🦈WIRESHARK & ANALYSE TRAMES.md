
---

## 🎯 L'ESSENTIEL (5 points)

1. **Trame Ethernet** = MAC dest + MAC source + EtherType + Données + CRC
2. **EtherType** = identifie le protocole encapsulé (IPv4, ARP, IPv6...)
3. **ARP** = résout IP → MAC (broadcast "Qui a cette IP ?")
4. **ICMP** = protocole de contrôle IP (ping, erreurs)
5. **Encapsulation** : Donnée → Segment → Paquet → Trame → Bits

---

## 🔄 STRUCTURE TRAME ETHERNET

```js
┌──────────────┬──────────────┬───────────┬─────────────────┬──────────┐
│  MAC Dest    │  MAC Source  │ EtherType │     Payload     │   CRC    │
│   6 octets   │   6 octets   │  2 octets │  46-1500 octets │ 4 octets │
└──────────────┴──────────────┴───────────┴─────────────────┴──────────┘
                      │
                      └── Indique le protocole encapsule
                          
Taille totale : 64 à 1518 octets
MTU (Maximum Transmission Unit) = 1500 octets max pour le payload
```

---

## 📊 ETHERTYPES À CONNAÎTRE

| EtherType | Protocole | Rôle |
|-----------|-----------|------|
| **0x0800** | IPv4 | Protocole Internet v4 |
| **0x0806** | ARP | Résolution IP → MAC |
| **0x8035** | RARP | Résolution inverse MAC → IP |
| **0x86DD** | IPv6 | Protocole Internet v6 |

---

## 🔁 PROTOCOLE ARP

**Rôle** : Trouver l'adresse MAC correspondant à une IP (couche 2 ↔ couche 3)

```vb
1. PC veut envoyer à 192.168.1.10
2. ARP Request (broadcast) : "Qui a 192.168.1.10 ?"
3. ARP Reply (unicast) : "C'est moi, voici ma MAC"
4. PC enregistre dans son cache ARP
```

**Caractéristiques ARP :**
- EtherType : `0x0806`
- Encapsulé directement dans Ethernet
- Requête en **broadcast** (MAC dest = FF:FF:FF:FF:FF:FF)
- Réponse en **unicast**

---

## 📡 PROTOCOLE ICMP

**Rôle** : Protocole de contrôle pour IP (messages d'erreur, ping)

- Encapsulé dans IP (Protocol = 1)
- **Ping** = ICMP Echo Request + Echo Reply
- Utilisé pour diagnostiquer les problèmes réseau

**ICMPv6** : regroupe ICMP + ARP + IGMP en un seul protocole

---

## 🔄 ENCAPSULATION (MODÈLE OSI)

```js
Couche 7-5 : Donnée
     ↓
Couche 4   : Segment (TCP/UDP)
     ↓
Couche 3   : Paquet (IP)
     ↓
Couche 2   : Trame (Ethernet)
     ↓
Couche 1   : Bits
```

---

## 🔍 ANALYSE WIRESHARK - CHECKPOINT 2

### Questions types sur fichiers .pcap :

**À identifier dans une capture :**
1. **EtherType** → quel protocole encapsulé ?
2. **Protocoles empilés** → Ethernet > IP > TCP/UDP > Application
3. **MAC source/destination** → qui envoie ? qui reçoit ?
4. **IP source/destination** → restent fixes d'un bout à l'autre
5. **Emplacement capture** → regarder les MAC pour deviner où

### Rappel important :
- **Adresses MAC** = changent à chaque saut (routeur)
- **Adresses IP** = restent identiques de bout en bout

---

## ⚠️ PIÈGE CLASSIQUE

> **Dans une trame qui traverse un routeur :**
> - Les adresses **IP** ne changent PAS
> - Les adresses **MAC** CHANGENT à chaque saut
> 
> Exemple ping PC1 → réseau distant :
> - Entre PC1 et switch : MAC src = PC1, MAC dest = routeur
> - Après le routeur : MAC src = routeur, MAC dest = destination finale
> - IP src et IP dest = toujours les mêmes !

---

## 📝 QUIZ CHECKPOINT

> [!question] Q1 : Quel est l'EtherType de IPv4 ?
> > [!success]- 🔓 Réponse
> > `0x0800`

> [!question] Q2 : Quel est l'EtherType de ARP ?
> > [!success]- 🔓 Réponse
> > `0x0806`

> [!question] Q3 : Quel est l'EtherType de IPv6 ?
> > [!success]- 🔓 Réponse
> > `0x86DD`

> [!question] Q4 : À quoi sert ARP ?
> > [!success]- 🔓 Réponse
> > Résoudre une adresse IP en adresse MAC

> [!question] Q5 : Comment fonctionne une requête ARP ?
> > [!success]- 🔓 Réponse
> > Broadcast "Qui a l'IP X.X.X.X ?" → réponse unicast avec la MAC

> [!question] Q6 : À quoi sert ICMP ?
>  [!success]- 🔓 Réponse
>  Protocole de contrôle IP (ping, messages d'erreur)

> [!question] Q7 : Dans une trame traversant un routeur, qu'est-ce qui change ?
> > [!success]- 🔓 Réponse
> > Les adresses MAC (pas les adresses IP)

> [!question] Q8 : Taille min/max d'une trame Ethernet ?
> > [!success]- 🔓 Réponse
> > 64 à 1518 octets

> [!question] Q9 : C'est quoi le MTU ?
> > [!success]- 🔓 Réponse
> > Maximum Transmission Unit = taille max du payload (1500 octets)

> [!question] Q10 : Ordre d'encapsulation descendant ?
> > [!success]- 🔓 Réponse
> > Donnée → Segment → Paquet → Trame → Bits

> [!question] Q11 : Une requête ARP est envoyée en broadcast ou unicast ?
> > [!success]- 🔓 Réponse
> > Broadcast (MAC dest = FF:FF:FF:FF:FF:FF)

> [!question] Q12 : Quels champs contient l'en-tête MAC (MAC header) ?
> > [!success]- 🔓 Réponse
> > MAC destination, MAC source, EtherType

---

## 🎤 À retenir pour l'oral

> **Trame Ethernet** = MAC Dest (6) + MAC Src (6) + EtherType (2) + Payload (46-1500) + CRC (4)

> **EtherTypes** : 0x0800 = IPv4 | 0x0806 = ARP | 0x86DD = IPv6

> **ARP** = résout IP → MAC (requête broadcast, réponse unicast)

> **Encapsulation** : Donnée → Segment (TCP/UDP) → Paquet (IP) → Trame (Ethernet) → Bits

> **À travers un routeur** : les adresses **MAC changent** à chaque saut, les adresses **IP restent fixes**

> **MTU** = Maximum Transmission Unit = 1500 octets (taille max payload Ethernet)


