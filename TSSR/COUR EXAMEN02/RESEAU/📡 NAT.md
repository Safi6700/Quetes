## 🎯 L'essentiel (5 points)

1. **NAT** = traduction d'adresses IP (privées ↔ publiques) — **IPv4 uniquement**
2. **PAT/NAPT** = traduction IP + port → plusieurs machines internes via 1 seule IP publique
3. **SNAT** (Source NAT) = sortie Internet — traduit l'adresse **source**
4. **DNAT** (Destination NAT) = publication de services — traduit l'adresse **destination**
5. **NAT 1:1** = 1 IP privée ↔ 1 IP publique dédiée (statique)

---

## 🔄 Les types de NAT

| Type                | Nom complet              | Sens           | Usage                                               |
| ------------------- | ------------------------ | -------------- | --------------------------------------------------- |
| **PAT/NAPT**        | Port Address Translation | Source         | Sortie Internet (plusieurs clients → 1 IP publique) |
| **SNAT**            | Source NAT               | Source         | Sortie Internet                                     |
| **DNAT**            | Destination NAT          | Destination    | Publier un serveur interne                          |
| **NAT 1:1**         | Static NAT               | Bidirectionnel | 1 IP privée = 1 IP publique dédiée                  |
| **Port forwarding** | Redirection de port      | Destination    | Exposer un service sur un port précis               |

---

## 🔄 Schéma PAT/NAPT (sortie Internet)

```js
RÉSEAU INTERNE                    ROUTEUR NAT                    INTERNET
                                       |
PC1 (10.1.1.11:52369) ------>  203.1.113.123:52369  ------>  google.com:443
                                       |
PC2 (10.1.1.12:52370) ------>  203.1.113.123:52370  ------>  google.com:443
                                       |
         Plusieurs IP privées  →  1 seule IP publique (ports différents)
```

---

## 🔄 Schéma DNAT (publication service)

```js
INTERNET                         ROUTEUR NAT                    RÉSEAU INTERNE
                                       |
Client (204.1.97.10) ------>  203.1.113.123:80  ------>  Serveur web (172.16.1.15:80)
                                       |
         L'IP publique est traduite vers l'IP privée du serveur
```

---

## 📝 Autres noms du PAT/NAPT

| Nom | Contexte |
|-----|----------|
| NAT overload | Cisco |
| NAT masquerade | Linux (iptables/nftables) |
| SNAT avec ports | pfSense, Stormshield |

---

## ⚠️ Piège classique

> **NAT concerne UNIQUEMENT IPv4** — pas IPv6  
> (IPv6 a assez d'adresses, pas besoin de NAT)

> **Collision de ports** : si 2 machines utilisent le même port source, le routeur en change un automatiquement

---

## 📝 QUIZ Checkpoint

### Question 1
**C'est quoi le NAT ?**

> [!success]- 🔓 Réponse
> Traduction d'adresses IP privées en adresses IP publiques (et inversement)  
> Permet à plusieurs machines internes d'accéder à Internet via 1 IP publique

---

### Question 2
**Différence entre SNAT et DNAT ?**

> [!success]- 🔓 Réponse
> - **SNAT** (Source NAT) : traduit l'adresse **source** → sortie Internet
> - **DNAT** (Destination NAT) : traduit l'adresse **destination** → publication de services

---

### Question 3
**C'est quoi PAT/NAPT ?**

> [!success]- 🔓 Réponse
> **Port Address Translation** / **Network Address Port Translation**  
> Traduction IP + port → plusieurs machines via 1 seule IP publique  
> Les ports différencient les communications

---

### Question 4
**Pourquoi le NAT existe ?**

> [!success]- 🔓 Réponse
> **Pénurie d'adresses IPv4** — pas assez d'IP publiques pour toutes les machines  
> Le NAT permet de mutualiser une IP publique

---

### Question 5
**Comment appelle-t-on le NAT sous Linux (iptables) ?**

> [!success]- 🔓 Réponse
> **NAT masquerade**

---

### Question 6
**C'est quoi le NAT 1:1 ?**

> [!success]- 🔓 Réponse
> **Static NAT** — 1 IP privée associée à 1 IP publique dédiée  
> Traduction bidirectionnelle (aller et retour)

---

### Question 7
**C'est quoi le port forwarding ?**

> [!success]- 🔓 Réponse
> Redirection d'un port public vers une machine interne  
> Ex : port 80 public → serveur web interne 172.16.1.15:80  
> C'est une forme de **DNAT**

---

### Question 8
**Le NAT fonctionne-t-il en IPv6 ?**

> [!success]- 🔓 Réponse
> **Non** — IPv6 a suffisamment d'adresses, pas besoin de NAT  
> (il existe NPTv6 mais très rare)

---
## 🎤 À retenir pour l'oral

> **NAT** = traduction d'adresses IP privées ↔ publiques — **IPv4 uniquement**

> **PAT/NAPT** = traduction IP + port → plusieurs machines internes via 1 seule IP publique

> **SNAT** (Source NAT) = sortie Internet, traduit l'adresse **source**

> **DNAT** (Destination NAT) = publication de services, traduit l'adresse **destination**

> **Port forwarding** = rediriger un port public vers un serveur interne (forme de DNAT)

> **Pourquoi NAT ?** Pénurie d'adresses IPv4 → mutualiser 1 IP publique pour plusieurs machines
