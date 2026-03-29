
---

## 🎯 L'ESSENTIEL (5 points)

1. **Port TCP 22** par défaut, protocole client/serveur sécurisé
2. **Authentification bidirectionnelle** : client authentifie serveur ET serveur authentifie client
3. **TOFU** (Trust On First Use) : 1ère connexion = accepter empreinte → stockée dans `~/.ssh/known_hosts`
4. **3 garanties** : Confidentialité (chiffrement) + Intégrité (HMAC) + Authentification
5. **PFS** (Perfect Forward Secrecy) via échange Diffie-Hellman

---

## 🔄 PROCESSUS DE CONNEXION SSH

```js
┌──────────────────────────────────────────────────────────────┐
│                    PREMIÈRE CONNEXION                        │
├──────────────────────────────────────────────────────────────┤
│                                                              │
│  CLIENT                              SERVEUR                 │
│    │                                    │                    │
│    │──── 1. Demande connexion ─────────>│                    │
│    │                                    │                    │
│    │<─── 2. Clé publique serveur ───────│                    │
│    │                                    │                    │
│    │  ⚠️ Affichage empreinte (fingerprint)                   │
│    │  "ED25519 key fingerprint is SHA256:xxx"                │
│    │  → Vérification manuelle (théorie)                      │
│    │  → Acceptation (yes)                                    │
│    │                                    │                    │
│    │──── 3. Challenge au serveur ──────>│                    │
│    │      (prouve clé privée)           │                    │
│    │                                    │                    │
│    │<─── 4. Réponse challenge ──────────│                    │
│    │                                    │                    │
│    │  ✅ Clé stockée ~/.ssh/known_hosts                      │ 
│    │                                    │                    │
│    │──── 5. Auth client (mdp/clé) ─────>│                    │
│    │                                    │                    │
│    │<─── 6. Session établie ────────────│                    │
│                                                              │
└──────────────────────────────────────────────────────────────┘

┌──────────────────────────────────────────────────────────────┐
│                   CONNEXIONS SUIVANTES                       │
├──────────────────────────────────────────────────────────────┤
│  → Vérification clé reçue = clé dans known_hosts             │
│  → Si différente = ALERTE USURPATION POSSIBLE !              │
└──────────────────────────────────────────────────────────────┘
```

---

## 🔧 COMMANDES ESSENTIELLES

| Commande | Description |
|----------|-------------|
| `ssh user@host` | Connexion basique |
| `ssh -p 2222 user@host` | Connexion port personnalisé |
| `ssh-keygen -t ed25519` | Générer paire de clés (recommandé) |
| `ssh-keygen -t ecdsa -b 256` | Générer clés ECDSA |
| `ssh-copy-id user@host` | Copier clé publique sur serveur |
| `ssh-keygen -lf fichier.pub` | Afficher empreinte d'une clé |
| `sshd -t` | Tester config serveur (syntaxe) |
| `sshd -T` | Tester et afficher config |
| `ssh -G host` | Afficher config client pour host |

---

## 📁 FICHIERS IMPORTANTS

| Fichier | Emplacement | Rôle |
|---------|-------------|------|
| `known_hosts` | `~/.ssh/` | Clés publiques serveurs connus |
| `id_ed25519` | `~/.ssh/` | Clé privée utilisateur |
| `id_ed25519.pub` | `~/.ssh/` | Clé publique utilisateur |
| `authorized_keys` | `~/.ssh/` | Clés autorisées (côté serveur) |
| `sshd_config` | `/etc/ssh/` | Config serveur SSH |
| `ssh_config` | `/etc/ssh/` | Config client (global) |
| `config` | `~/.ssh/` | Config client (utilisateur) |
| `ssh_host_*_key` | `/etc/ssh/` | Clés du serveur |

---

## 🔑 MÉTHODES D'AUTHENTIFICATION CLIENT

| Méthode | Description |
|---------|-------------|
| `password` | Mot de passe système |
| `publickey` | Paire clé privée/publique |
| `hostbased` | Par clés pour tous users d'un hôte |
| `GSSAPI` | Via Kerberos |

**Config serveur** : `AuthenticationMethods publickey,password` (cumul possible)

---

## 🚇 TUNNELS SSH

| Option | Usage | Description |
|--------|-------|-------------|
| `-L port:host:hostport` | Local Forward | Client:port → Serveur → host:hostport |
| `-R port:host:hostport` | Remote Forward | Serveur:port → Client → host:hostport |
| `-D port` | Proxy SOCKS | Client devient proxy SOCKS |
| `-X` | X11 Forward | Interface graphique à distance |
| `-w tun:tun` | Tunnel VPN | Device tun point à point |

---

## 📤 TRANSFERT DE FICHIERS

| Outil | Description |
|-------|-------------|
| **SCP** | Secure Copy (copie simple) |
| **SFTP** | SSH File Transfer Protocol (interactif) |
| **SSHFS** | Montage dossier distant |

---

## ⚠️ PIÈGE CLASSIQUE EXAMEN

```
❌ ERREUR : Confondre clé SERVEUR et clé CLIENT

→ Clés SERVEUR : /etc/ssh/ssh_host_*_key
  (générées à l'installation, identifient le serveur)

→ Clés CLIENT : ~/.ssh/id_*
  (générées par l'utilisateur avec ssh-keygen)

❌ ERREUR : Oublier que known_hosts stocke les clés SERVEURS
   (pas les clés des utilisateurs autorisés !)

❌ ERREUR : Confondre authorized_keys et known_hosts
   → authorized_keys = clés publiques des CLIENTS autorisés
   → known_hosts = clés publiques des SERVEURS connus
```

---

## 📝 QUIZ - Teste tes connaissances

**Q1 : Quel port utilise SSH par défaut ?**
> [!success]- Réponse
> Port TCP 22

**Q2 : Que signifie TOFU ?**
> [!success]- Réponse
> Trust On First Use - À la première connexion, on fait confiance à la clé reçue

**Q3 : Où sont stockées les clés publiques des serveurs connus ?**
> [!success]- Réponse
> `~/.ssh/known_hosts`

**Q4 : Quelle commande pour générer une paire de clés ED25519 ?**
> [!success]- Réponse
> `ssh-keygen -t ed25519`

**Q5 : Quelle commande pour copier sa clé publique sur un serveur ?**
> [!success]- Réponse
> `ssh-copy-id user@serveur`

**Q6 : Quel fichier config côté serveur ?**
> [!success]- Réponse
> `/etc/ssh/sshd_config`

**Q7 : Quelle option SSH pour créer un tunnel local (port forwarding) ?**
> [!success]- Réponse
> `ssh -L port:host:hostport`

**Q8 : Que garantit PFS (Perfect Forward Secrecy) ?**
> [!success]- Réponse
> Même si la clé privée est compromise plus tard, les sessions passées restent sécurisées (grâce à Diffie-Hellman)

**Q9 : Différence entre SCP et SFTP ?**
> [!success]- Réponse
> SCP = copie simple, SFTP = protocole interactif (navigation, suppression, etc.)

**Q10 : Que se passe-t-il si la clé serveur change entre deux connexions ?**
> [!success]- Réponse
> Alerte de sécurité ! Possible usurpation (man-in-the-middle). La connexion est bloquée.

---
## 🎤 À retenir pour l'oral

> **SSH** = protocole sécurisé de connexion à distance, port **TCP 22**

> **TOFU** (Trust On First Use) = 1ère connexion → accepter empreinte serveur → stockée dans `~/.ssh/known_hosts`

> **Authentification** : par mot de passe OU par clé publique (plus sécurisé)

> **Fichiers clés** : `known_hosts` = serveurs connus | `authorized_keys` = clients autorisés | `id_ed25519` = clé privée

> **Commandes** : `ssh-keygen -t ed25519` (générer clé) | `ssh-copy-id user@host` (copier clé publique)

> **Tunnels** : `-L` (local forward) | `-R` (remote forward) | `-D` (proxy SOCKS)

---

