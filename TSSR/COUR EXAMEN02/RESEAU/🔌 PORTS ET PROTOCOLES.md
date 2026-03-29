
## 🎯 Les plages de ports

- **0 à 1023** : Ports systèmes (Well Known Ports) — Serveur

- **1024 à 49151** : Ports utilisateurs (Registered Ports) — Serveur

- **49152 à 65535** : Ports dynamiques (Ephemeral Ports) — Client

---

## Couche Application (Modèle TCP/IP)

**DNS** (53) : *Domain Name System*
→ Résolution de noms de domaine

**SIP** (5060/5061) : *Session Initiation Protocol*
→ Protocole d'initiation de session (VoIP)

**DHCP** (67/68) : *Dynamic Host Configuration Protocol*
→ Attribution dynamique d'adresses IP

**TFTP** (69) : *Trivial File Transfer Protocol*
→ Transfert de fichiers simple

**NTP** (123) : *Network Time Protocol*
→ Synchronisation de l'heure

**SNMP** (161/162) : *Simple Network Management Protocol*
→ Gestion et supervision de réseau

**FTP** (20/21) : *File Transfer Protocol*
→ Transfert de fichiers

**SFTP** (22) : *Secure File Transfer Protocol*
→ Transfert sécurisé de fichiers

**SSH** (22) : *Secure Shell*
→ Connexion sécurisée à distance

**Telnet** (23) : *Teletype Network*
→ Connexion à distance non sécurisée

**SMTP** (25) : *Simple Mail Transfer Protocol*
→ Envoi d'emails

**SMTPS** (465/587) : *Simple Mail Transfer Protocol Secure*
→ Envoi sécurisé d'emails

**HTTP** (80) : *Hypertext Transfer Protocol*
→ Protocole de communication du web

**HTTPS** (443) : *Hypertext Transfer Protocol Secure*
→ HTTP sécurisé (chiffré)

**POP3** (110) : *Post Office Protocol v3*
→ Récupération d'emails (télécharge et supprime du serveur)

**POP3S** (995) : *Post Office Protocol v3 Secure*
→ POP3 sécurisé

**IMAP** (143) : *Internet Message Access Protocol*
→ Accès aux emails sur le serveur (synchronisé)

**IMAPS** (993) : *Internet Message Access Protocol Secure*
→ IMAP sécurisé

**LDAP** (389) : *Lightweight Directory Access Protocol*
→ Accès aux annuaires (Active Directory)

**LDAPS** (636) : *Lightweight Directory Access Protocol Secure*
→ LDAP sécurisé

**SMB** (445) : *Server Message Block*
→ Partage de fichiers et imprimantes (Windows)

**MySQL** (3306) : *MySQL Database*
→ Base de données MySQL

**RDP** (3389) : *Remote Desktop Protocol*
→ Bureau à distance (Windows)

---

## Couche Transport (Modèle TCP/IP)

**TCP** : *Transmission Control Protocol*
→ Protocole fiable, orienté connexion (accusé de réception)

**UDP** : *User Datagram Protocol*
→ Protocole rapide, non fiable, sans connexion

---

## Couche Internet (Modèle TCP/IP)

**IP** : *Internet Protocol*
→ Adressage et routage des paquets (IPv4/IPv6)

**ICMP** : *Internet Control Message Protocol*
→ Messages de contrôle et d'erreur (ping, traceroute)

**ARP** : *Address Resolution Protocol*
→ Résolution d'adresses IP en adresses MAC

---

## Couche Accès Réseau (Modèle TCP/IP)

**Ethernet** : *Ethernet*
→ Protocole de communication pour les réseaux locaux (LAN)

---

## À retenir absolument

- **TCP** : Utilisé pour les applications nécessitant une connexion fiable (HTTP, FTP, SSH, SMTP)

- **UDP** : Utilisé pour les applications nécessitant de la rapidité (DNS, DHCP, VoIP, streaming)

- **Port** : Numéro qui identifie une application/un service sur une machine (0-65535)

- **IANA** : Organisme qui gère l'attribution des numéros de ports

---

## 📝 QUIZ

**Q1 : Sur quel port fonctionne HTTP ?**
> [!success]- Réponse
> Port 80

**Q2 : Sur quel port fonctionne HTTPS ?**
> [!success]- Réponse
> Port 443

**Q3 : Sur quel port fonctionne DNS ?**
> [!success]- Réponse
> Port 53 (UDP)

**Q4 : Sur quel port fonctionne SSH ?**
> [!success]- Réponse
> Port 22

**Q5 : Sur quel port fonctionne FTP ?**
> [!success]- Réponse
> Port 21 (contrôle) et 20 (données)

**Q6 : Sur quel port fonctionne RDP ?**
> [!success]- Réponse
> Port 3389

**Q7 : Sur quel port fonctionne DHCP ?**
> [!success]- Réponse
> Port 67 (serveur) et 68 (client)

**Q8 : Que signifie HTTP ?**
> [!success]- Réponse
> Hypertext Transfer Protocol

**Q9 : Que signifie DNS ?**
> [!success]- Réponse
> Domain Name System

**Q10 : Que signifie DHCP ?**
> [!success]- Réponse
> Dynamic Host Configuration Protocol

**Q11 : Que signifie SSH ?**
> [!success]- Réponse
> Secure Shell

**Q12 : Que signifie SMTP ?**
> [!success]- Réponse
> Simple Mail Transfer Protocol

**Q13 : Quelle est la plage des ports systèmes (Well Known Ports) ?**
> [!success]- Réponse
> 0 à 1023

**Q14 : Quelle est la différence entre POP3 et IMAP ?**
> [!success]- Réponse
> POP3 télécharge et supprime les emails du serveur / IMAP synchronise et garde les emails sur le serveur

**Q15 : Quel protocole remplace Telnet de manière sécurisée ?**
> [!success]- Réponse
> SSH

**Q16 : Que signifie ARP ?**
> [!success]- Réponse
> Address Resolution Protocol

**Q17 : Quel est le rôle de ARP ?**
> [!success]- Réponse
> Résolution d'adresses IP en adresses MAC

**Q18 : Sur quel port fonctionne LDAP ?**
> [!success]- Réponse
> Port 389 (LDAPS = 636)

**Q19 : Sur quel port fonctionne SMB ?**
> [!success]- Réponse
> Port 445

**Q20 : Que signifie ICMP et à quoi ça sert ?**
> [!success]- Réponse
> Internet Control Message Protocol — Messages de contrôle et d'erreur (ping, traceroute)