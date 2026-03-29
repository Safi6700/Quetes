## 🎯 L'ESSENTIEL (5 points)

1. **RDP** = protocole Microsoft, port TCP/UDP 3389, intégré Windows Pro/Entreprise
2. **VNC** = protocole RFB, port TCP 5900, multiplateforme
3. **SSH** = port TCP 22, chiffré par défaut, alternative sécurisée à Telnet
4. **Terminal léger** = poste client sans disque dur local, boot PXE
5. **Citrix** = protocole ICA/HDX, architecture : StoreFront → Delivery Controller → VDA

---

## 🔄 ARCHITECTURE CITRIX

```js
┌─────────────┐     ┌─────────────┐     ┌──────────────────┐     ┌─────────┐
│   Client    │────▶│  StoreFront │────▶│    Delivery      │────▶│   VDA   │
│  Workspace  │     │  (portail)  │     │   Controller     │     │(session)│
└─────────────┘     └─────────────┘     └──────────────────┘     └─────────┘
                                               │
                                               ▼
                                        ┌─────────────┐
                                        │    Active   │
                                        │  Directory  │
                                        └─────────────┘
```

---

## 📊 TABLEAU DES PROTOCOLES

| Protocole | Port défaut | Cryptage défaut | Cas d'usage |
|-----------|-------------|-----------------|-------------|
| **RDP** | TCP/UDP 3389 | RC4 (TLS option) | Bureau Windows |
| **VNC** | TCP 5900+N | Aucun (via TLS) | Multiplateforme |
| **SSH** | TCP 22 | Chiffrement symétrique | CLI sécurisé |
| **X11** | TCP 6000+N | Aucun (via SSH) | GUI Linux |
| **SPICE** | TCP 3001 | TLS option | VMs QEMU/KVM |

---

## 🔧 OUTILS

| Type | Outils | Caractéristiques |
|------|--------|------------------|
| **Commerciaux** | TeamViewer, AnyDesk | Simple, multiplateforme |
| **Intégrés** | RDP Windows | Pro/Entreprise uniquement |
| **Open source** | VNC, Guacamole, Remmina | Guacamole = via navigateur |

---

## 🏢 CITRIX - VOCABULAIRE

| Terme | Définition |
|-------|------------|
| **ICA/HDX** | Protocoles de connexion Citrix |
| **VDA** | Virtual Delivery Agent (héberge session) |
| **StoreFront** | Portail utilisateur |
| **Delivery Controller** | Gère authentification (valide via AD) |
| **Ferme Citrix** | Serveurs Citrix redondants |
| **DaaS** | Desktop as a Service (Cloud) |
| **Fichier .ica** | Fichier de connexion généré |

---

## ✅ BONNES PRATIQUES

- **Connexion** : Ethernet > Wi-Fi
- **Redondance** : plusieurs Delivery Controllers, VDA, StoreFront
- **Réseau** : VLANs dédiés trafic client/serveur
- **Sécurité** : SSL/TLS, MFA, Active Directory, pas de stockage local

---

## ⚠️ PIÈGE CLASSIQUE

> **Confondre les ports**
> → RDP = 3389 / VNC = 5900 / SSH = 22 / SPICE = 3001
>
> **Confondre VDA et Delivery Controller**
> → VDA = héberge la session
> → Delivery Controller = gère l'authentification
>
> **RDP sur Windows Famille**
> → RDP = Pro/Entreprise uniquement

---

## 📝 QUIZ

**Q1 : Port par défaut de RDP ?**
> [!success]- Réponse
> TCP/UDP 3389

**Q2 : Quel protocole utilise VNC ?**
> [!success]- Réponse
> RFB (Remote Frame Buffer)

**Q3 : Port par défaut de SSH ?**
> [!success]- Réponse
> TCP 22

**Q4 : Qu'est-ce qu'un terminal léger ?**
> [!success]- Réponse
> Poste client sans disque dur local (données sur serveur)

**Q5 : Comment démarre un terminal léger ?**
> [!success]- Réponse
> Via la carte réseau (boot PXE)

**Q6 : Que signifie VDA ?**
> [!success]- Réponse
> Virtual Delivery Agent (héberge la session)

**Q7 : Quel composant Citrix est le portail utilisateur ?**
> [!success]- Réponse
> StoreFront

**Q8 : Quel fichier est généré lors d'une connexion Citrix ?**
> [!success]- Réponse
> Fichier .ica

**Q9 : Quel outil open source permet l'accès distant via navigateur ?**
> [!success]- Réponse
> Guacamole

**Q10 : Quel protocole est l'alternative sécurisée à Telnet ?**
> [!success]- Réponse
> SSH

**Q11 : Port de SPICE ?**
> [!success]- Réponse
> TCP 3001

**Q12 : Que signifie DaaS ?**
> [!success]- Réponse
> Desktop as a Service

**Q13 : RDP est intégré à quelles éditions Windows ?**
> [!success]- Réponse
> Pro et Entreprise

**Q14 : Quel protocole pour les VMs QEMU/KVM ?**
> [!success]- Réponse
> SPICE

**Q15 : Quelle connexion privilégier pour les terminaux légers ?**
> [!success]- Réponse
> Ethernet (pas Wi-Fi)