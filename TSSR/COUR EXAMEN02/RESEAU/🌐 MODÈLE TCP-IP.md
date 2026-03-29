

---

### **1. Couche Accès Réseau (Liaison)**
**Rôle** : Gère la communication locale sur le réseau physique (câbles, adresses MAC, trames).
**PDU** : **Trame** + **Bit**
**Matériel** : Hub, répéteur, switch, pont
**Correspond à** : Couches 1 et 2 du modèle OSI
**Sous-couches** :
- **MAC** (Medium Access Control) : adresse matérielle
- **LLC** (Logical Link Control) : encapsulation, détection d'erreur (optionnel)
**Exemples de protocoles** : Ethernet, Wi-Fi, PPP

---

### **2. Couche Internet**
**Rôle** : Interconnexion de réseaux physiques différents pour former un réseau logique. Chaque machine a un identifiant IP unique, les paquets transitent par des routeurs.
**PDU** : **Paquet**
**Matériel** : Routeur
**Correspond à** : Couche 3 du modèle OSI
**Exemples de protocoles** : IP (v4/v6), ICMP, ARP

---

### **3. Couche Transport**
**Rôle** : Transfert de bout en bout, découpage des données, contrôle de flux, réordonnancement.
**PDU** : **Segment** (TCP) ou **Datagramme** (UDP)
**Matériel** : Pare-feu
**Correspond à** : Couche 4 du modèle OSI
**Exemples de protocoles** :
- **TCP** : fiable, orienté connexion
- **UDP** : rapide, non fiable
- **TLS** : chiffrement (optionnel)

---

### **4. Couche Application**
**Rôle** : Interface avec l'utilisateur, fournit les services réseau aux applications.
**PDU** : **Données applicatives**
**Matériel** : PC, serveur
**Correspond à** : Couches 5, 6 et 7 du modèle OSI
**Exemples de protocoles** : HTTP (80), HTTPS (443), FTP (21), DNS (53), SMTP (25), SSH (22)

---

## 🔄 TCP vs UDP

| Caractéristique | TCP | UDP |
|-----------------|-----|-----|
| PDU | Segment | Datagramme |
| Connexion | Orienté connexion | Sans connexion |
| Fiabilité | Fiable (accusé de réception) | Non fiable |
| Vitesse | Plus lent | Plus rapide |
| Utilisation | HTTP, FTP, SMTP, SSH | DNS, DHCP, VoIP, streaming |

---

## 🔄 Poignée de main TCP (Three-Way Handshake)

```js
CLIENT                              SERVEUR
   |                                    |
   |-------- 1. SYN (Seq=x) ----------->|  Demande connexion
   |                                    |
   |<--- 2. SYN-ACK (Seq=y, Ack=x+1) ---|  Accepte connexion
   |                                    |
   |-------- 3. ACK (Ack=y+1) --------->|  Connexion établie
   |                                    |
```

**Flags TCP à connaître** :
- **SYN** : Synchronisation (demande connexion)
- **ACK** : Acquittement
- **FIN** : Fin de connexion
- **RST** : Reset connexion
- **PSH** : Outrepasser le tampon
- **URG** : Données urgentes

---

## 🔄 Datagramme UDP (4 champs seulement)

- Port source (16 bits)
- Port destination (16 bits)
- Taille du datagramme (16 bits)
- Somme de contrôle (16 bits)

---

### **À retenir absolument**
- **TCP/IP = 4 couches** (modèle pratique utilisé sur les vrais réseaux)
- **OSI = 7 couches** (modèle théorique)
- **TCP = fiable** (accusé de réception, handshake)
- **UDP = rapide** mais pas de garantie de livraison
- Les couches 5, 6, 7 OSI sont fusionnées dans la couche Application TCP/IP

---

## 📝 QUIZ

**Q1 : Combien de couches dans le modèle TCP/IP ?**
> [!success]- Réponse
> 4 couches

**Q2 : Quelle est la différence entre TCP et UDP ?**
> [!success]- Réponse
> TCP = fiable, orienté connexion / UDP = rapide, sans connexion

**Q3 : Comment s'appelle la séquence d'établissement de connexion TCP ?**
> [!success]- Réponse
> Three-Way Handshake (poignée de main en 3 étapes)

**Q4 : Quels sont les 3 flags échangés lors du handshake TCP ?**
> [!success]- Réponse
> SYN → SYN-ACK → ACK

**Q5 : Quel est le PDU de la couche Transport avec UDP ?**
> [!success]- Réponse
> Datagramme

**Q6 : Combien de champs dans l'entête UDP ?**
> [!success]- Réponse
> 4 champs (port src, port dst, taille, checksum)

**Q7 : Que signifie le flag FIN en TCP ?**
> [!success]- Réponse
> Fin de connexion (plus de données à envoyer)

**Q8 : Quelle couche TCP/IP correspond aux couches 5, 6 et 7 du modèle OSI ?**
> [!success]- Réponse
> Couche Application

**Q9 : Quel protocole de transport utilise DNS ?**
> [!success]- Réponse
> UDP (port 53)

**Q10 : Quel protocole de transport utilise HTTP ?**
> [!success]- Réponse
> TCP (port 80)

**Q11 : Que signifie le flag SYN ?**
> [!success]- Réponse
> Synchronisation du numéro de séquence (demande de connexion)

**Q12 : Que signifie le flag ACK ?**
> [!success]- Réponse
> Acquittement (accusé de réception)

**Q13 : Quel est le rôle de la couche Internet dans TCP/IP ?**
> [!success]- Réponse
> Interconnexion de réseaux, routage des paquets via adresses IP

**Q14 : Quelles sont les 2 sous-couches de la couche Accès Réseau ?**
> [!success]- Réponse
> MAC (Medium Access Control) et LLC (Logical Link Control)

---
## 🎤 À retenir pour l'oral

> **4 couches TCP/IP** : Accès Réseau → Internet → Transport → Application

> **Couche Accès Réseau** = couches 1+2 OSI (trames, bits, MAC, Ethernet)

> **Couche Internet** = couche 3 OSI (paquets, IP, ICMP, routage)

> **Couche Transport** = couche 4 OSI (segments TCP / datagrammes UDP)

> **Couche Application** = couches 5+6+7 OSI (HTTP, DNS, SMTP, FTP...)

> **TCP vs UDP** : TCP = fiable, connexion (SYN-SYN/ACK-ACK) | UDP = rapide, sans connexion

> **Handshake TCP** : SYN → SYN-ACK → ACK (3 étapes)

> **Encapsulation** : Données → Segment → Paquet → Trame → Bits

---

