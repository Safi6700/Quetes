
---

### **1. Couche Physique**

**Rôle** : Transmet les bits sur le support matériel (câbles, ondes radio, fibre optique).

**PDU** : Bit

**Matériel** : Hub, répéteur, câble RJ45, fibre optique

**Exemples de protocoles** : Ethernet (IEEE 802.3), Wi-Fi (IEEE 802.11), Bluetooth (IEEE 802.15)

---

### **2. Couche Liaison de Données**

**Rôle** : Organise les données en trames, gère les adresses MAC et détecte les erreurs (CRC).

**PDU** : Trame

**Matériel** : Switch, pont (bridge)

**Exemples de protocoles** : Ethernet (IEEE 802.3), PPP (Point-to-Point Protocol)

---

### **3. Couche Réseau**

**Rôle** : Achemine les paquets entre réseaux en utilisant des adresses IP.

**PDU** : Paquet (ou Datagramme IP)

**Matériel** : Routeur

**Exemples de protocoles** : IP (v4/v6), ICMP, OSPF

---

### **4. Couche Transport**

**Rôle** : Gère la transmission de bout en bout, contrôle de flux et d'erreurs.

**PDU** : Segment (TCP) ou Datagramme (UDP)

**Matériel** : Pare-feu (pour les ports)

**Exemples de protocoles** : TCP (6), UDP (17)

---

### **5. Couche Session**

**Rôle** : Établit, maintient et termine les sessions entre applications.

**PDU** : Données

**Matériel** : Pare-feu (pour les sessions)

**Exemples de protocoles** : NetBIOS, RPC, SMB

---

### **6. Couche Présentation**

**Rôle** : Formate les données (chiffrement, compression) pour l'application.

**PDU** : Données

**Matériel** : Géré par le logiciel (ex: serveur web)

**Exemples de protocoles** : TLS/SSL, JPEG, MPEG

---

### **7. Couche Application**

**Rôle** : Fournit les services réseau aux applications (ex: navigation web, email).

**PDU** : Données applicatives

**Matériel** : PC, serveur

**Exemples de protocoles** : HTTP (80), HTTPS (443), FTP (21), DNS (53), SMTP (25)

---

### **À retenir absolument**

- **Couches basses (1-3)** : Gèrent le matériel et le transport des données (accès réseau, routage)

- **Couches hautes (5-7)** : Gèrent les services et les données pour les utilisateurs (sessions, formatage, applications)

- **Couche Transport (4)** : Assure la fiabilité et le contrôle de flux entre les hôtes

---

## 📝 QUIZ

**Q1 : Quel est le PDU de la couche 2 ?**
> [!success]- Réponse
> Trame

**Q2 : Quel équipement travaille en couche 3 ?**
> [!success]- Réponse
> Routeur

**Q3 : Quelle est la différence entre TCP et UDP ?**
> [!success]- Réponse
> TCP = fiable, orienté connexion / UDP = rapide, sans connexion

**Q4 : Sur quel port fonctionne HTTP ?**
> [!success]- Réponse
> Port 80

**Q5 : Quel type d'adresse utilise la couche 2 ?**
> [!success]- Réponse
> Adresse MAC

**Q6 : Quel est le PDU de la couche 4 avec TCP ?**
> [!success]- Réponse
> Segment

**Q7 : Quelles couches OSI sont rarement utilisées en pratique ?**
> [!success]- Réponse
> Couche 5 (Session) et Couche 6 (Présentation)

**Q8 : Quel équipement de couche 1 est obsolète aujourd'hui ?**
> [!success]- Réponse
> Le Hub (concentrateur)

**Q9 : Quel protocole permet la résolution de noms ? Sur quel port ?**
> [!success]- Réponse
> DNS sur le port UDP 53

**Q10 : Dans quel sens se fait l'encapsulation ?**
> [!success]- Réponse
> Données → Segment → Paquet → Trame → Bits (de haut en bas)

**Q11 : Combien de couches dans le modèle OSI ?**
> [!success]- Réponse
> 7 couches

**Q12 : Quel est le rôle de la couche Réseau ?**
> [!success]- Réponse
> Achemine les paquets entre réseaux (routage) via adresses IP

**Q13 : Que signifie CRC ?**
> [!success]- Réponse
> Contrôle de Redondance Cyclique — détection d'erreurs en couche 2

**Q14 : Quel matériel utilise la couche 2 ?**
> [!success]- Réponse
> Switch et pont (bridge)