
---

## 🎯 L'essentiel (5 points)

1. **Ethernet** = protocole de **couche 2 (Liaison)** — norme IEEE 802.3
2. **Adresse MAC** = 48 bits (6 octets) — identifiant unique de l'interface réseau
3. **Trame** = PDU de la couche 2 (contient MAC dest + MAC src + données)
4. **Switch** = équipement couche 2, transmet les trames uniquement au destinataire
5. **VLAN** = réseau virtuel, segmente un switch en plusieurs réseaux logiques

---

## 🔄 Structure de la trame Ethernet

```js
┌─────────┬─────────┬──────────┬──────────┬───────────┬──────────────┬─────┐
│Preambule│  SFD    │ MAC Dest │ MAC Src  │ EtherType │   Donnees    │ FCS │
│ 7 oct   │ 1 oct   │  6 oct   │  6 oct   │  2 oct    │ 46-1500 oct  │4 oct│
└─────────┴─────────┴──────────┴──────────┴───────────┴──────────────┴─────┘
```

| Champ | Taille | Rôle |
|-------|--------|------|
| **Préambule** | 7 octets | Synchronisation |
| **SFD** | 1 octet | Début de trame |
| **MAC Destination** | 6 octets | Adresse destinataire |
| **MAC Source** | 6 octets | Adresse émetteur |
| **EtherType** | 2 octets | Type de protocole (0x0800=IPv4, 0x86DD=IPv6) |
| **Données** | 46-1500 oct | Payload (datagramme IP) |
| **FCS** | 4 octets | Contrôle d'erreur (CRC) |

---

## 📝 Adresse MAC

| Caractéristique       | Valeur                                               |
| --------------------- | ---------------------------------------------------- |
| **Taille**            | 48 bits (6 octets)                                   |
| **Notation**          | Hexa séparé par `:` ou `-` (ex: 08:00:27:BF:01:6F)   |
| **3 premiers octets** | OUI (Organizationally Unique Identifier) = fabricant |
| **3 derniers octets** | Identifiant unique de l'interface                    |
| **Broadcast**         | FF:FF:FF:FF:FF:FF                                    |

---

## 📝 Modèle OSI / IEEE 802

| Couche OSI | Sous-couche IEEE | Rôle |
|------------|------------------|------|
| **Couche 1** (Physique) | PHY | Médium, débit, câblage |
| **Couche 2** (Liaison) | MAC | Format trame, adresses |
| | LLC | Interface avec couche 3 |

---

## 📝 Équipements réseau

| Équipement | Couche OSI | Rôle |
|------------|------------|------|
| **Hub** | 1 | Répète à tous les ports (obsolète) |
| **Switch** | 2 | Transmet uniquement au destinataire (table MAC) |
| **Routeur** | 3 | Interconnecte les réseaux IP |

---
## 📝 VLAN (IEEE 802.1Q)

| Élément | Description |
|---------|-------------|
| **VLAN** | Réseau virtuel sur un switch |
| **802.1Q** | Ajoute un tag de 4 octets dans la trame |
| **VLAN ID** | Identifiant du VLAN (1-4094) |
| **Trunk** | Lien transportant plusieurs VLANs |

---
## 🔧 Commandes

| Commande | OS | Rôle |
|----------|-----|------|
| `ip link` | Linux | Voir interfaces |
| `ip a` | Linux | Voir config IP + MAC |
| `Get-NetAdapter` | PowerShell | Voir interfaces + MAC |
| `ipconfig /all` | Windows | Voir MAC |
| `arp -a` | Linux/Windows | Table ARP (IP ↔ MAC) |

---
## ⚠️ Piège classique

> **Switch ≠ Hub** : le switch envoie uniquement au destinataire, le hub à tout le monde

> **MAC = couche 2** / **IP = couche 3** — ne pas confondre !

> **FCS (Frame Check Sequence)** = CRC pour détecter les erreurs de transmission

---
## 📝 QUIZ Checkpoint

### Question 1
**C'est quoi une adresse MAC ?**

> [!success]- 🔓 Réponse
> Adresse physique de **48 bits** (6 octets), identifiant unique d'une interface réseau  
> Notation hexa : `08:00:27:BF:01:6F`

---
### Question 2
**Sur quelle couche OSI fonctionne Ethernet ?**

> [!success]- 🔓 Réponse
> **Couche 2 (Liaison)** — sous-couches MAC et LLC  
> Norme IEEE 802.3

---
### Question 3
**Quelle est la structure d'une trame Ethernet ?**

> [!success]- 🔓 Réponse
> Préambule (7) + SFD (1) + MAC Dest (6) + MAC Src (6) + EtherType (2) + Données (46-1500) + FCS (4)

---
### Question 4
**Différence entre switch et hub ?**

> [!success]- 🔓 Réponse
> - **Hub** (couche 1) : répète la trame à TOUS les ports
> - **Switch** (couche 2) : envoie uniquement au port du destinataire (table MAC)

---
### Question 5
**C'est quoi un VLAN ?**

> [!success]- 🔓 Réponse
> **Virtual LAN** — réseau virtuel qui segmente un switch en plusieurs réseaux logiques  
> Norme **IEEE 802.1Q** — ajoute un tag VLAN ID dans la trame

---
### Question 6
**C'est quoi l'EtherType ?**

> [!success]- 🔓 Réponse
> Champ de 2 octets indiquant le protocole transporté :
> - **0x0800** = IPv4
> - **0x86DD** = IPv6
> - **0x0806** = ARP

---

### Question 7
**Quelle commande pour voir l'adresse MAC sous Linux ?**

> [!success]- 🔓 Réponse
> `ip a` ou `ip link`

---
### Question 8
**C'est quoi le FCS ?**

> [!success]- 🔓 Réponse
> **Frame Check Sequence** (4 octets)  
> CRC pour vérifier si la trame n'a pas été altérée pendant la transmission

---
## 🎤 À retenir pour l'oral

> **Ethernet** = protocole **couche 2 (Liaison)**, norme IEEE 802.3

> **Adresse MAC** = 48 bits (6 octets), identifiant unique physique, format hexa (ex: 08:00:27:BF:01:6F)

> **Trame Ethernet** = MAC Dest + MAC Src + EtherType + Données (46-1500) + FCS

> **EtherType** : 0x0800 = IPv4 | 0x86DD = IPv6 | 0x0806 = ARP

> **Switch vs Hub** : Switch = envoie au destinataire (table MAC) | Hub = répète à tous (obsolète)

> **VLAN** = réseau virtuel qui segmente un switch, norme 802.1Q (tag 4 octets)



