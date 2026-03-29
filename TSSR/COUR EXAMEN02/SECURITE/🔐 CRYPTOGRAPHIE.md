
---

## 🎯 L'essentiel (5 points)

1. **Symétrique** = 1 seule clé (chiffrer + déchiffrer) — rapide mais partage de clé difficile
2. **Asymétrique** = 2 clés (publique + privée) — lent mais échange sécurisé
3. **Hachage** = empreinte unique d'un message (MD5, SHA) — irréversible
4. **Hybride** = asymétrique pour échanger la clé + symétrique pour chiffrer (TLS/SSL)
5. **Signature numérique** = hachage + chiffrement asymétrique → authentification + intégrité

---

## 🔄 Cryptographie Symétrique

```js
         1 SEULE CLÉ
              │
    ┌─────────┴─────────┐
    ▼                   ▼
┌───────┐           ┌───────┐         ┌───────┐
│Message│──Clé──►   │Chiffré│──Clé──► │Message│
│ clair │ Chiffre   │       │Déchiffre│ clair │
└───────┘           └───────┘         └───────┘
```

| Caractéristique | Valeur |
|-----------------|--------|
| **Clés** | 1 seule (secrète, partagée) |
| **Vitesse** | Rapide |
| **Problème** | Partage sécurisé de la clé |
| **Algorithmes** | AES, DES, 3DES, ChaCha20 |

---

## 🔄 Cryptographie Asymétrique

```js
    CLÉ PUBLIQUE              CLÉ PRIVÉE
         │                         │
         ▼                         ▼
┌───────┐            ┌───────┐            ┌───────┐
│Message│──Publique─►│Chiffré│──Privée──► │Message│
│ clair │  Chiffre   │       │ Déchiffre  │ clair │
└───────┘            └───────┘            └───────┘
```

| Caractéristique | Valeur                               |
| --------------- | ------------------------------------ |
| **Clés**        | Paire : publique + privée            |
| **Vitesse**     | Lent                                 |
| **Avantage**    | Pas besoin de partager la clé privée |
| **Algorithmes** | RSA, ECC (courbes elliptiques)       |
| **Inventeurs**  | Diffie & Hellman                     |

---

## 📝 Usages Asymétrique

| Mode | Clé utilisée | Usage |
|------|--------------|-------|
| **Confidentialité** | Chiffre avec publique, déchiffre avec privée | Envoyer un message secret |
| **Authentification** | Chiffre avec privée, déchiffre avec publique | Signature numérique |

---

## 🔄 Fonction de Hachage

```vb
Message ──────► [HASH] ──────► Empreinte (fixe)
                                 │
                    Irréversible ✗
```

| Caractéristique | Valeur |
|-----------------|--------|
| **Sortie** | Taille fixe (ex: 256 bits) |
| **Irréversible** | Impossible de retrouver le message |
| **Collision** | 2 messages ≠ même hash = très rare |
| **Algorithmes** | MD5 (obsolète), SHA-1 (obsolète), SHA-256, SHA-3 |
| **Usage** | Vérifier intégrité, stocker mots de passe |

---

## 🔄 Cryptographie Hybride (TLS/SSL)

```js
1. Échange clé symétrique via asymétrique (Diffie-Hellman)
2. Communication chiffrée avec clé symétrique (rapide)
```

| Élément | Rôle |
|---------|------|
| **Asymétrique** | Échange sécurisé de la clé de session |
| **Symétrique** | Chiffrement des données (performance) |
| **Clé de session** | Clé symétrique temporaire, usage unique |

---

## 📝 Signature Numérique

```vb
ÉMETTEUR                              RÉCEPTEUR
    │                                     │
    │── 1. Hash du message ──►            │
    │── 2. Chiffre hash (clé privée) ──►  │
    │── 3. Envoie message + signature ──► │
    │                                     │
    │                      4. Hash du message reçu
    │                      5. Déchiffre signature (clé publique)
    │                      6. Compare les 2 hash
    │                                     │
    │              ✓ = Authentique + Intègre
```

---

## ⚠️ Piège classique

> **Symétrique = rapide** mais problème de partage de clé  
> **Asymétrique = sécurisé** mais lent → on combine les deux (hybride)

> **Hachage ≠ Chiffrement** : le hash est irréversible !

> **MD5 et SHA-1 sont obsolètes** → utiliser SHA-256 minimum

---

## 📝 QUIZ Checkpoint

### Question 1
**Différence entre chiffrement symétrique et asymétrique ?**

> [!success]- 🔓 Réponse
> - **Symétrique** : 1 seule clé pour chiffrer ET déchiffrer — rapide
> - **Asymétrique** : 2 clés (publique + privée) — lent mais sécurisé

---
### Question 2
**C'est quoi une fonction de hachage ?**

> [!success]- 🔓 Réponse
> Fonction qui génère une **empreinte unique** de taille fixe à partir d'un message  
> **Irréversible** : impossible de retrouver le message original  
> Ex : SHA-256, MD5

---

### Question 3
**Pourquoi utilise-t-on la cryptographie hybride ?**

> [!success]- 🔓 Réponse
> - **Asymétrique** pour échanger la clé de session de façon sécurisée
> - **Symétrique** pour chiffrer les données (plus rapide)
> = combine sécurité + performance

---
### Question 4
**C'est quoi une signature numérique ?**

> [!success]- 🔓 Réponse
> **Hachage** du message + **chiffrement** du hash avec la clé privée  
> Garantit : **authentification** (c'est bien l'émetteur) + **intégrité** (message non modifié)

---
### Question 5
**C'est quoi l'échange de clés Diffie-Hellman ?**

> [!success]- 🔓 Réponse
> Protocole permettant de **construire un secret partagé** (clé de session)  
> Même sur un canal **non sécurisé**  
> Utilisé dans TLS/SSL, SSH

---

### Question 6
**Quels algorithmes de hachage sont obsolètes ?**

> [!success]- 🔓 Réponse
> **MD5** et **SHA-1** — vulnérables aux collisions  
> Utiliser **SHA-256** ou **SHA-3** minimum

---

### Question 7
**C'est quoi une clé de session ?**

> [!success]- 🔓 Réponse
> Clé **symétrique temporaire** à usage unique, limitée dans le temps  
> Générée pour chaque connexion (ex: TLS)

---

### Question 8
**Comment fonctionne le chiffrement pour la confidentialité en asymétrique ?**

> [!success]- 🔓 Réponse
> - **Chiffrer** avec la clé **publique** du destinataire
> - **Déchiffrer** avec sa clé **privée**
> → Seul le destinataire peut lire le message

---
## 🎤 À retenir pour l'oral

> **Symétrique** = 1 clé (chiffrer + déchiffrer) — rapide mais partage difficile (AES, DES)

> **Asymétrique** = 2 clés (publique + privée) — lent mais sécurisé (RSA, ECC)

> **Hachage** = empreinte unique irréversible — MD5/SHA-1 obsolètes → utiliser SHA-256

> **Hybride (TLS)** = asymétrique pour échanger la clé + symétrique pour chiffrer (performance + sécurité)

> **Signature numérique** = hash du message + chiffrement avec clé privée → authentification + intégrité

> **Clé de session** = clé symétrique temporaire générée pour chaque connexion



