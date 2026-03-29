# 🌐 FICHE TSSR – Serveurs Web

---

## 🎯 L'essentiel (définitions courtes à apprendre)

1. **Web** = système hypertexte basé sur 3 composants : **HTTP** (protocole) + **URL** (adresse) + **HTML** (langage)

2. **HTTP** = protocole client-serveur, port **80**, sans état (stateless), basé sur TCP

3. **HTTPS** = HTTP over TLS, port **443**, chiffrement + authentification par certificat X.509

4. **Serveur web** = logiciel en écoute sur 80/443, reçoit requête HTTP → renvoie réponse HTTP

5. **VirtualHost** = un serveur web peut héberger plusieurs sites (distinction par nom d'hôte)

6. **Proxy** = intermédiaire client/serveur (couche 7) : cache, filtrage, anonymat, répartition de charge

---

## 🔄 Requête / Réponse HTTP

```
CLIENT (navigateur)                    SERVEUR WEB
        |                                    |
        |-- REQUÊTE HTTP ------------------->|
        |   • Méthode (GET, POST...)         |
        |   • URL                            |
        |   • Entêtes (Host, Cookie...)      |
        |   • Corps (optionnel)              |
        |                                    |
        |<-- RÉPONSE HTTP -------------------|
        |   • Code statut (200, 404...)      |
        |   • Entêtes (Content-Type...)      |
        |   • Corps (page HTML, fichier...)  |
        |                                    |
```

---

## 📋 Structure d'une URL

```
schéma://autorité/chemin?requête#fragment

https://www.example.com:443/page/index.html?id=42&lang=fr#section2
  │          │          │         │              │           │
  │          │          │         │              │           └─ Fragment (ancre)
  │          │          │         │              └─ Requête (paramètres)
  │          │          │         └─ Chemin (fichier)
  │          │          └─ Port (optionnel)
  │          └─ Autorité (domaine ou IP)
  └─ Schéma (protocole)
```

---

## 🔧 Ports et protocoles

| Protocole | Port | Description |
|-----------|------|-------------|
| **HTTP** | 80 | Non chiffré |
| **HTTPS** | 443 | Chiffré (TLS) |

---

## 🖥️ Serveurs web courants

| Serveur | Système | Notes |
|---------|---------|-------|
| **Apache** | Linux/Windows | VirtualHost, très répandu |
| **Nginx** | Linux | Server blocks, performant, reverse proxy |
| **IIS** | Windows | Intégré à Windows Server |

---

## 📌 Types de proxy

| Type | Rôle |
|------|------|
| **Proxy (forward)** | Côté client → cache, filtrage, anonymat |
| **Reverse proxy** | Côté serveur → répartition charge, sécurité, cache |
| **Transparent** | Invisible pour le client (ex: portail captif) |

---

## 🔧 Solutions Proxy / Reverse Proxy

| Outil | Usage |
|-------|-------|
| **Squid** | Proxy HTTP (cache, filtrage) |
| **HAProxy** | Reverse proxy, répartition de charge |
| **Traefik** | Reverse proxy moderne (conteneurs) |
| **Varnish** | Cache HTTP |

---

## ⚠️ Piège classique

> **Confondre HTTP et HTTPS**
> - **HTTP** = port 80, non chiffré → données en clair !
> - **HTTPS** = port 443, chiffré TLS + certificat X.509
> 
> → En production, HTTPS est **obligatoire** (Let's Encrypt = AC gratuite)

---

## ✅ Checkpoint examen

**Ce que le jury peut demander :**
- Différence HTTP / HTTPS
- Structure d'une URL
- Rôle d'un serveur web
- Différence proxy / reverse proxy

---

## 📝 QUIZ Checkpoint

### Question 1
**Quels sont les 3 composants essentiels du Web ?**
> [!success]- 🔓 Réponse
> - **HTTP** (protocole de transfert)
> - **URL** (adresse des ressources)
> - **HTML** (langage de description)

---

### Question 2
**Quel port pour HTTP ? Pour HTTPS ?**
> [!success]- 🔓 Réponse
> - HTTP = port **80**
> - HTTPS = port **443**

---

### Question 3
**Que signifie "HTTP est stateless" ?**
> [!success]- 🔓 Réponse
> **Sans état** : chaque requête est indépendante, le serveur ne garde pas de mémoire des requêtes précédentes (d'où l'utilisation des cookies/sessions).

---

### Question 4
**Qu'est-ce qu'un VirtualHost ?**
> [!success]- 🔓 Réponse
> Mécanisme permettant à **un seul serveur web** d'héberger **plusieurs sites** différents, distingués par le nom d'hôte dans la requête.

---

### Question 5
**Quelle est la différence entre proxy et reverse proxy ?**
> [!success]- 🔓 Réponse
> - **Proxy (forward)** : côté CLIENT → cache, filtrage, anonymat
> - **Reverse proxy** : côté SERVEUR → répartition de charge, sécurité, cache

---

### Question 6
**Que contient une requête HTTP ?**
> [!success]- 🔓 Réponse
> 1. Ligne de démarrage : **méthode** (GET, POST) + **URL** + version HTTP
> 2. **Entêtes** : Host, Cookie, etc.
> 3. **Corps** (optionnel) : données envoyées

---

### Question 7
**C'est quoi HTTPS et pourquoi c'est indispensable ?**
> [!success]- 🔓 Réponse
> **HTTP over TLS** (port 443) :
> - **Confidentialité** : données chiffrées
> - **Authentification** : certificat X.509 prouve l'identité du serveur
> → Indispensable pour protéger les données en transit

---

### Question 8
**DIAGNOSTIC : Un site web ne s'affiche pas. Quelles vérifications ?**
> [!success]- 🔓 Réponse
> 1. **DNS** : résolution du nom (`nslookup` / `dig`)
> 2. **Connectivité** : `ping` vers le serveur
> 3. **Port ouvert** : `telnet serveur 80` ou `443`
> 4. **Service actif** : vérifier que le serveur web tourne
> 5. **Firewall** : ports 80/443 autorisés ?
> 6. **Logs serveur** : erreurs Apache/Nginx ?

---

## 🎤 À retenir pour l'oral

> **Web** = HTTP (port 80) + URL + HTML

> **HTTPS** = HTTP + TLS (port 443) → chiffrement + certificat X.509 obligatoire

> **Serveur web** = reçoit requêtes HTTP, renvoie réponses (Apache, Nginx, IIS)

> **VirtualHost** = plusieurs sites sur un même serveur (distinction par nom d'hôte)

> **Proxy** = intermédiaire couche 7 : forward (côté client) vs reverse (côté serveur)

---