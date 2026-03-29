
---

## 🎯 L'essentiel (définitions courtes à apprendre)

1. **Pare-feu (Firewall)** = équipement ou logiciel réseau qui **filtre le trafic** entrant et sortant selon des règles
   - Objectif : **contrôler les communications** entre réseaux de confiance différente

2. **Stateless** = pare-feu **sans mémoire** → chaque paquet traité indépendamment

3. **Stateful** = pare-feu **avec mémoire** → suit les connexions TCP, autorise automatiquement les réponses

4. **DPI** (Deep Packet Inspection) = pare-feu qui **inspecte le contenu** des paquets (pas juste les en-têtes)

5. **DMZ** = zone réseau pour les serveurs **accessibles depuis Internet** (web, mail)

6. **Zone de confiance** = regroupement de machines ayant les **mêmes besoins en sécurité**

---

## 🔄 Les 4 types de pare-feux

| Type | En bref | Avantage | Limite |
|------|---------|----------|--------|
| **Stateless** | Filtre sur IP/port, pas de mémoire | Rapide | Pas de suivi connexion |
| **Stateful** | Suit les connexions TCP | Réponses auto-autorisées | Consomme plus de ressources |
| **Applicatif (DPI)** | Inspecte le contenu | Filtrage fin | Impossible si chiffré (HTTPS) |
| **Personnel** | Logiciel sur 1 machine | Interactif | Moins sûr (1 service parmi d'autres) |

---

## 📋 Stateless vs Stateful (à retenir)

| | Stateless | Stateful |
|--|-----------|----------|
| **Mémoire** | ❌ Non | ✅ Oui |
| **Suivi connexion** | ❌ Non | ✅ Oui |
| **Réponses** | Règle manuelle | Auto-autorisées |
| **Vitesse** | Rapide | Plus lent |

---

## 🛡️ Politique de filtrage

**Approche recommandée** : 
1. **Tout bloquer** (deny all)
2. **Autoriser uniquement** ce qui est nécessaire

---

## 🔧 Actions de filtrage

| Action | Comportement |
|--------|--------------|
| **ACCEPT** | Paquet accepté |
| **DROP** | Refusé **sans réponse** (silencieux) |
| **REJECT** | Refusé **avec réponse** (notification) |

---

## ⚠️ Piège classique

> **DROP vs REJECT** :
> - DROP = silencieux (l'attaquant ne sait pas si le port existe)
> - REJECT = répond (l'attaquant sait que le firewall est là)

---

## ✅ Checkpoint examen

**Ce que le jury peut demander :**
- Définir un pare-feu
- Différence Stateless / Stateful
- Qu'est-ce qu'une DMZ
- Types de pare-feux

---

## 📝 QUIZ Checkpoint

### Question 1
**C'est quoi un pare-feu ?**
> [!success]- 🔓 Réponse
> Équipement ou logiciel qui **filtre le trafic** réseau entrant et sortant selon des règles.

---

### Question 2
**Différence Stateless / Stateful ?**
> [!success]- 🔓 Réponse
> - **Stateless** = sans mémoire, chaque paquet traité seul
> - **Stateful** = avec mémoire, suit les connexions, autorise les réponses automatiquement

---

### Question 3
**C'est quoi une DMZ ?**
> [!success]- 🔓 Réponse
> Zone réseau pour les serveurs **accessibles depuis Internet** (web, mail). Zone à surveiller particulièrement.

---

### Question 4
**Quels sont les 4 types de pare-feux ?**
> [!success]- 🔓 Réponse
> 1. **Stateless** (sans mémoire)
> 2. **Stateful** (avec mémoire)
> 3. **Applicatif / DPI** (inspecte le contenu)
> 4. **Personnel** (logiciel sur 1 machine)

---

### Question 5
**Quelle politique de filtrage est recommandée ?**
> [!success]- 🔓 Réponse
> **Tout bloquer** puis **autoriser uniquement** ce qui est nécessaire (whitelist).

---

### Question 6
**Différence DROP / REJECT ?**
> [!success]- 🔓 Réponse
> - **DROP** = refuse sans répondre (silencieux)
> - **REJECT** = refuse et envoie une notification

---

### Question 7
**Pourquoi un pare-feu DPI ne peut pas tout inspecter ?**
> [!success]- 🔓 Réponse
> Impossible d'inspecter le **trafic chiffré** (HTTPS) sans certificat intermédiaire.

---

### Question 8
**C'est quoi une zone de confiance ?**
> [!success]- 🔓 Réponse
> Regroupement de machines ayant les **mêmes besoins en sécurité** (ex: utilisateurs, serveurs, DMZ...).

---

## 🎤 À retenir pour l'oral

> **Pare-feu** = filtre le trafic réseau selon des règles

> **Stateless** = sans mémoire / **Stateful** = avec mémoire (suit les connexions)

> **DMZ** = zone pour serveurs accessibles depuis Internet

> **Politique** = tout bloquer + autoriser le nécessaire

> **DROP** = silencieux / **REJECT** = répond

---