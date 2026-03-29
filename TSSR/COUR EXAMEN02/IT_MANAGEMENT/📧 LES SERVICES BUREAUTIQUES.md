
---

## 🎯 L'essentiel (définitions courtes à apprendre)

1. **Messagerie** = service pour **envoyer/recevoir** des mails (Exchange, Gmail...)

2. **SMTP** = protocole pour **envoyer** les mails (port 25, ou 587 avec auth)

3. **IMAP** = protocole pour **consulter** les mails (synchronisés, restent sur le serveur)

4. **POP3** = protocole pour **télécharger** les mails (supprimés du serveur)

5. **Prise de main à distance** = contrôler un PC depuis un autre PC (RDP, VNC, TeamViewer...)

6. **RDP** = protocole Microsoft pour bureau à distance (port **3389**)

---

## 📧 Protocoles de messagerie

| Protocole | Rôle | Port |
|-----------|------|------|
| **SMTP** | Envoyer | 25 (ou 587 avec auth) |
| **IMAP** | Consulter (synchro) | 143 (993 SSL) |
| **POP3** | Télécharger | 110 (995 SSL) |

---

## 📋 IMAP vs POP3

| | IMAP | POP3 |
|--|------|------|
| **Mails** | Restent sur serveur | Téléchargés puis supprimés |
| **Multi-appareils** | ✅ Oui (synchro) | ❌ Non |
| **Hors ligne** | Partiel | ✅ Oui |

---

## 🖥️ Prise de main à distance

| Solution | Type | Port |
|----------|------|------|
| **RDP** | Microsoft natif | 3389 |
| **VNC** | Multi-plateforme | 5900 |
| **SSH** | Ligne de commande | 22 |
| **TeamViewer** | Commercial | Traverse les NAT |

---

## ☁️ Stockage de fichiers

| Type | C'est quoi | Exemple |
|------|------------|---------|
| **NAS** | Stockage réseau local | Synology |
| **Cloud** | Stockage en ligne | OneDrive, Google Drive |
| **DFS** | Système de fichiers distribué Windows | Partages AD unifiés |

---

## ⚠️ Piège classique

> **IMAP vs POP3**
> - IMAP = mails **sur le serveur** (synchro multi-appareils)
> - POP3 = mails **téléchargés** (1 seul appareil)

---

## ✅ Checkpoint examen

**Ce que le jury peut demander :**
- Différence SMTP / IMAP / POP3
- Ports de messagerie
- Solutions de prise de main à distance
- Port RDP

---

## 📝 QUIZ Checkpoint

### Question 1
**C'est quoi SMTP ?**
> [!success]- 🔓 Réponse
> Protocole pour **envoyer** les mails. Port 25 (ou 587 avec authentification).

---

### Question 2
**Différence IMAP et POP3 ?**
> [!success]- 🔓 Réponse
> - **IMAP** = mails restent sur serveur (synchro multi-appareils)
> - **POP3** = mails téléchargés puis supprimés du serveur

---

### Question 3
**Quel port pour RDP ?**
> [!success]- 🔓 Réponse
> Port **3389**

---

### Question 4
**Quel port pour SSH ?**
> [!success]- 🔓 Réponse
> Port **22**

---

### Question 5
**Pour accéder aux mails depuis PC + téléphone, IMAP ou POP3 ?**
> [!success]- 🔓 Réponse
> **IMAP** (les mails restent sur le serveur et sont synchronisés sur tous les appareils)

---

### Question 6
**Quelles solutions pour la prise de main à distance ?**
> [!success]- 🔓 Réponse
> RDP (Microsoft), VNC (multi-plateforme), SSH (ligne de commande), TeamViewer (commercial)

---

## 🎤 À retenir pour l'oral

> **SMTP** = envoyer (port 25/587) / **IMAP** = consulter (synchro) / **POP3** = télécharger

> **IMAP** = multi-appareils / **POP3** = 1 seul appareil

> **RDP** = port 3389 / **SSH** = port 22

> **NAS** = stockage réseau local / **Cloud** = stockage en ligne

---