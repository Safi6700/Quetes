

## 🎯 L'ESSENTIEL (5 points)

1. **Sécurité** = protection contre actions malveillantes | **Sûreté** = protection contre dysfonctionnements/accidents
2. **D.I.C.P** (CIA en anglais) : Disponibilité, Intégrité, Confidentialité, (Preuve)
3. **Vulnérabilité** → **Menace** → **Attaque** (chaîne de risque)
4. **PSSI** = Politique de Sécurité du SI, établie par le **RSSI** (CISO)
5. **Principe de moindre privilège** : donner uniquement les droits nécessaires

---

## 🔄 CHAÎNE DE RISQUE

```js
┌─────────────────────────────────────────────────────────────┐
│                    ANALYSE DE RISQUES                       │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  VULNÉRABILITÉ ──────> MENACE ──────> ATTAQUE               │
│        │                  │               │                 │
│        ▼                  ▼               ▼                 │
│   Faiblesse de      Cause potentielle  Action malveillante  │
│   conception,       d'un dommage       concrétisant         │
│   réalisation,      sur le SI          la menace            │
│   configuration                                             │
│                                                             │
├─────────────────────────────────────────────────────────────┤
│                    OBJECTIFS PSSI                           │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  PRÉVENIR ──> DÉTECTER ──> RÉAGIR ──> RÉPARER ──> ÉVOLUER   │
│      │           │           │           │           │      │
│   Éviter      Savoir si   Réponse    Remettre    Améliorer  │
│   les         attaque     appropriée  SI en       la PSSI   │
│   failles     a lieu                  état                  │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

---

## 🔐 D.I.C.P - LES 4 PILIERS

| Pilier | Description | Exemple d'atteinte |
|--------|-------------|-------------------|
| **D**isponibilité | Service accessible quand nécessaire | Attaque DDoS |
| **I**ntégrité | Données exactes et complètes | Modification de fichiers |
| **C**onfidentialité | Accès réservé aux autorisés | Vol de données |
| **P**reuve (Traçabilité) | Prouver qui a fait quoi | Logs effacés |

---

## 👤 INGÉNIERIE SOCIALE

| Technique | Description |
|-----------|-------------|
| **Phishing** (Hameçonnage) | Faux site/mail pour voler identifiants (attaque de masse) |
| **Spear Phishing** (Harponnage) | Phishing ciblé sur une personne/entreprise |
| **Social Engineering** | Manipuler utilisateurs légitimes (téléphone, mail, réseaux sociaux) |

**Prévention** : Formation utilisateurs, vérifier URLs (https), vérifier métadonnées, regard critique, canaux sécurisés

---

## 🦠 MALWARES (Logiciels malveillants)

### Par nature :

| Type | Description |
|------|-------------|
| **Virus** | Contamine d'autres programmes (Exécutable/Macro/Boot) |
| **Ver (Worm)** | Autoréplication réseau via vulnérabilités |

### Par charge :

| Type | Description |
|------|-------------|
| **Ransomware** (Rançongiciel) | Chiffre données, demande rançon |
| **Trojan** (Cheval de Troie) | Programme caché (Keylogger, Backdoor) |
| **Spyware** (Mouchard) | Espionne l'utilisateur |
| **Wiper** (Bombe logique) | Détruit les données |
| **Bot/BotNet** | Machine zombie, réseau de machines contrôlées |

**Prévention** : Antivirus à jour, moindre privilège, logiciels de confiance, vérifier empreintes, limiter périphériques

---

## 🔑 MOTS DE PASSE

### Attaques sur les mots de passe :

| Attaque | Description | Contre-mesure |
|---------|-------------|---------------|
| **Force brute** | Tester toutes combinaisons | Limiter tentatives, MDP long |
| **Dictionnaire** | Tester mots courants (123456, password...) | Interdire MDP courants |
| **Capture en clair** | Écoute réseau, lecture BDD | Chiffrer (TLS), ne pas stocker en clair |
| **Keylogger** | Enregistre les frappes clavier | Sécuriser poste de travail |

### Stockage sécurisé :

```js
┌─────────────────────────────────────────────────────────────┐
│              NE JAMAIS STOCKER EN CLAIR !                    │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│  Mot de passe + SEL (aléatoire) ──> HACHAGE ──> Empreinte   │
│                                                              │
│  Stockage = Empreinte + Sel                                  │
│                                                              │
│  Algorithmes recommandés : bcrypt, scrypt, argon2, yescrypt │
│                                                              │
│  ⚠️ Même MDP + Sel différent = Empreintes différentes       │
│     (contre tables arc-en-ciel)                              │
│                                                              │
└─────────────────────────────────────────────────────────────┘
```

---

## ⚠️ PIÈGE CLASSIQUE EXAMEN

```js
❌ ERREUR : Confondre Sécurité et Sûreté
   → Sécurité = actions MALVEILLANTES (attaques)
   → Sûreté = accidents/dysfonctionnements (pannes)

❌ ERREUR : Confondre Vulnérabilité, Menace et Attaque
   → Vulnérabilité = la faiblesse (faille)
   → Menace = le risque potentiel
   → Attaque = l'exploitation concrète

❌ ERREUR : Penser que hacher = chiffrer
   → Hachage = sens unique (irréversible)
   → Chiffrement = réversible avec clé

❌ ERREUR : Oublier le SEL dans le hachage de MDP
   → Sans sel : même MDP = même empreinte (vulnérable aux rainbow tables)
```

---

## 📝 QUIZ - Teste tes connaissances

**Q1 : Que signifie D.I.C.P ?**
> [!success]- Réponse
> Disponibilité, Intégrité, Confidentialité, Preuve (traçabilité)

**Q2 : Différence entre Sécurité et Sûreté ?**
> [!success]- Réponse
> Sécurité = protection contre actions malveillantes / Sûreté = protection contre dysfonctionnements et accidents

**Q3 : Qu'est-ce qu'une vulnérabilité ?**
> [!success]- Réponse
> Une faiblesse de conception, réalisation, installation, configuration ou utilisation

**Q4 : Qu'est-ce que le phishing ?**
> [!success]- Réponse
> Technique qui consiste à imiter un site/mail légitime pour voler des informations sensibles (identifiants, CB...)

**Q5 : Différence entre virus et ver ?**
> [!success]- Réponse
> Virus = contamine d'autres programmes / Ver = autoréplication via le réseau

**Q6 : Qu'est-ce qu'un ransomware ?**
> [!success]- Réponse
> Malware qui chiffre les données et demande une rançon pour les déchiffrer

**Q7 : Pourquoi utiliser un SEL pour les mots de passe ?**
> [!success]- Réponse
> Pour que deux mots de passe identiques aient des empreintes différentes (contre les tables arc-en-ciel)

**Q8 : Qui établit la PSSI ?**
> [!success]- Réponse
> Le RSSI (Responsable de la Sécurité des Systèmes d'Information) ou CISO

**Q9 : Quels algorithmes de hachage pour les mots de passe ?**
> [!success]- Réponse
> bcrypt, scrypt, argon2, yescrypt (calcul coûteux volontairement)

**Q10 : Quels sont les 5 objectifs de la PSSI face aux vulnérabilités ?**
> [!success]- Réponse
> Prévenir, Détecter, Réagir, Réparer, Faire évoluer la PSSI 

---
## 🎤 À retenir pour l'oral

> **D.I.C.P** = Disponibilité, Intégrité, Confidentialité, Preuve (traçabilité)

> **Sécurité vs Sûreté** : Sécurité = actions malveillantes | Sûreté = accidents/dysfonctionnements

> **Chaîne de risque** : Vulnérabilité (faiblesse) → Menace (risque potentiel) → Attaque (exploitation)

> **Phishing** = faux site/mail pour voler identifiants | **Spear Phishing** = ciblé sur une personne

> **Malwares** : Virus (contamine programmes) | Ver (autoréplication réseau) | Ransomware (chiffre + rançon) | Trojan (programme caché)

> **Mots de passe** : JAMAIS en clair → Hachage + SEL (bcrypt, argon2) contre rainbow tables


