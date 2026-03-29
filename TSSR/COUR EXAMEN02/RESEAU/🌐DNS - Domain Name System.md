
## 🎯 L'essentiel (5 points)

1. **DNS** = traduit noms de domaine → adresses IP (port **53 UDP/TCP**)
2. **2 types serveurs** : Faisant autorité (détient l'info) / Résolveur (interroge + cache)
3. **13 domaines racine** (a-m.root-servers.net) mais +130 serveurs physiques (anycast)
4. **TTL** = durée de vie d'un enregistrement en cache
5. **ICANN** gère la racine / **AFNIC** gère le .fr

---

## 🔄 Résolution DNS (séquence à connaître)

```js
CLIENT                RÉSOLVEUR                 INTERNET
   |                      |                         |
   |-- 1. odyssey.wcs.com?-->|                      |
   |                      |-- 2. --------------> RACINE (.)
   |                      |<-- 3. NS de .com ------|
   |                      |                         |
   |                      |-- 4. --------------> TLD .com
   |                      |<-- 5. NS de wcs.com ---|
   |                      |                         |
   |                      |-- 6. --------------> AUTORITÉ wcs.com
   |                      |<-- 7. IP: 142.250.x.x -|
   |                      |                         |
   |<-- 8. Réponse IP ----|                         |
```

---

## 📝 Enregistrements DNS (RR)

| Type | Nom | Contenu |
|------|-----|---------|
| **A** | Address | IPv4 |
| **AAAA** | Address v6 | IPv6 |
| **NS** | Name Server | Serveur faisant autorité |
| **MX** | Mail eXchange | Serveur mail du domaine |
| **CNAME** | Canonical Name | Alias vers un autre nom |
| **PTR** | Pointer | Résolution inverse (IP → nom) |
| **SOA** | Start Of Authority | Serveur primaire de zone |

---

## 🔃 Résolution inverse

| Version | Domaine | Exemple |
|---------|---------|---------|
| IPv4 | `.in-addr.arpa` | 192.168.1.10 → `10.1.168.192.in-addr.arpa` |
| IPv6 | `.ip6.arpa` | Inversé par chiffre hexa |

---

## 🔧 Commandes / Config à retenir

| Action | Linux | Windows |
|--------|-------|---------|
| Interroger DNS | `dig domaine.com` | `nslookup domaine.com` |
| Requête type spécifique | `dig domaine.com MX` | `nslookup -type=MX domaine.com` |
| Requête simple | `host domaine.com` | - |
| Résolution locale | `/etc/hosts` | `C:\Windows\System32\drivers\etc\hosts` |

**Format fichier hosts :**
```
192.168.1.10    serveur1    alias_serveur
```

---

## ⚠️ Piège classique

> **"13 serveurs racine"** = FAUX !  
> Il y a **13 domaines** mais **+130 serveurs physiques** répartis mondialement (anycast)

---

## 📝 QUIZ Checkpoint

### Question 1
**Quel port utilise DNS ?**
> [!success]- 🔓 Réponse
> Port **53** (UDP par défaut, TCP pour transferts de zone)

---

### Question 2
**Différence entre serveur faisant autorité et résolveur ?**
> [!success]- 🔓 Réponse
> - **Faisant autorité** : détient l'info officielle d'une zone
> - **Résolveur** : interroge les serveurs + met en cache (TTL)

---

### Question 3
**Que signifie l'enregistrement MX ?**
> [!success]- 🔓 Réponse
> **Mail eXchange** = serveur de messagerie du domaine

---

### Question 4
**Qui gère la racine DNS ? Qui gère .fr ?**
> [!success]- 🔓 Réponse
> - Racine : **ICANN / IANA**
> - .fr : **AFNIC**

---

### Question 5
**C'est quoi un FQDN ?**
> [!success]- 🔓 Réponse
> **Fully Qualified Domain Name** = nom complet avec point final  
> Ex : `www.wildcodeschool.com.`

---

### Question 6
**Comment fonctionne la résolution inverse ?**
> [!success]- 🔓 Réponse
> - Domaine `.in-addr.arpa` (IPv4) ou `.ip6.arpa` (IPv6)
> - IP **inversée** + enregistrement **PTR**
> - Ex : 192.168.1.10 → `10.1.168.192.in-addr.arpa`

---

### Question 7
**C'est quoi le TTL ?**
> [!success]- 🔓 Réponse
> **Time To Live** = durée (secondes) de validité en cache

---

### Question 8
**DIAGNOSTIC : Ping par IP fonctionne, ping par nom échoue. Problème DNS ou réseau ?**
> [!success]- 🔓 Réponse
> Problème **DNS** (pas réseau). Vérifier :
> - Résolveur configuré ? (`/etc/resolv.conf`)
> - Entrée dans `/etc/hosts` ?
> - Serveur DNS joignable ?


---

## 🎤 À retenir pour l'oral

> **DNS** = traduction nom → IP (et inverse), port **UDP 53**

> **2 types serveurs** : Faisant autorité (détient la zone) / Résolveur (interroge + cache)

> **Enregistrements clés** : A (IPv4), AAAA (IPv6), CNAME (alias), MX (mail), PTR (inverse)

> **Résolution inverse** : domaine `.in-addr.arpa` (IPv4) / `.ip6.arpa` (IPv6)

> **Diagnostic** : ping IP OK mais ping nom KO = problème DNS (vérifier `/etc/resolv.conf` ou serveur DNS)

> **Commandes** : `dig` / `nslookup` pour tester, `/etc/hosts` prioritaire sur DNS

---

