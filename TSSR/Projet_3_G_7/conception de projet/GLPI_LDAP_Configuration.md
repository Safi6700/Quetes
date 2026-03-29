# GUIDE CONFIGURATION LDAP - GLPI
## Connexion Active Directory pour authentification utilisateurs
### Projet Ekoloclast - Installation Apache/MariaDB (sans Docker)

---

# ANALYSE DU GUIDE DE TON CAMARADE

## Ce qui manque dans son guide

| # | Élément manquant | Importance |
|---|------------------|------------|
| 1 | **BaseDN complet** | CRITIQUE - Sans ça, LDAP ne trouve pas les utilisateurs |
| 2 | **Compte de liaison (Bind DN)** | CRITIQUE - Compte pour se connecter à l'AD |
| 3 | **Mot de passe du compte** | CRITIQUE - Authentification |
| 4 | **Filtre de connexion complet** | Important - Pour filtrer les bons objets |
| 5 | **Configuration des champs** | Important - Mapping des attributs |
| 6 | **Prérequis PHP-LDAP** | Important - Module nécessaire |

## Ce qui est correct dans son guide

| # | Élément | Commentaire |
|---|---------|-------------|
| ✅ | Serveur : SRVWIN01.tssr.lan | Correct |
| ✅ | Champ identifiant : sAMAccountName | Correct pour AD |
| ✅ | Import des utilisateurs | Bonne procédure |
| ✅ | Attribution des profils | Bonne explication |

---

# TA SITUATION

| Paramètre | Valeur |
|-----------|--------|
| **Installation GLPI** | Apache + MariaDB (quête centre formation) |
| **Serveur GLPI** | SRVLX01 ou SRVLX02 |
| **Domaine AD** | tssr.lan |
| **Serveur AD** | SRVWIN01.tssr.lan (172.16.10.2) |
| **Objectif** | Les utilisateurs AD peuvent créer des tickets |

---

# PARTIE 1 : PRÉREQUIS

## 1.1 Vérifier le module PHP-LDAP

La quête de ton centre a normalement installé php-ldap, mais vérifions :

```bash
# Vérifier si php-ldap est installé
php -m | grep ldap
```

**Résultat attendu :**
```
ldap
```

**Si le module n'est pas installé :**

```bash
# Installer php-ldap (adapter la version PHP)
sudo apt install php-ldap -y

# Redémarrer Apache
sudo systemctl restart apache2
```

## 1.2 Vérifier la connectivité vers le serveur AD

```bash
# Ping du serveur AD
ping -c 3 172.16.10.2

# Test résolution DNS
nslookup srvwin01.tssr.lan

# Test port LDAP (389)
nc -zv 172.16.10.2 389
```

**Résultat attendu :**
```
Connection to 172.16.10.2 389 port [tcp/ldap] succeeded!
```

## 1.3 Créer un compte de service AD pour GLPI

> ⚠️ **IMPORTANT** : Il faut un compte AD dédié pour que GLPI puisse lire l'annuaire !

### Sur SRVWIN01 (PowerShell ou GUI)

**Option 1 : PowerShell**

```powershell
# Créer le compte de service GLPI
New-ADUser -Name "svc_glpi" `
    -SamAccountName "svc_glpi" `
    -UserPrincipalName "svc_glpi@tssr.lan" `
    -Path "OU=Utilisateurs,OU=_Ekoloclast,DC=tssr,DC=lan" `
    -AccountPassword (ConvertTo-SecureString "Azerty123!" -AsPlainText -Force) `
    -Enabled $true `
    -PasswordNeverExpires $true `
    -CannotChangePassword $true `
    -Description "Compte de service pour GLPI LDAP"
```

**Option 2 : GUI (Active Directory Users and Computers)**

1. **Tools** → **Active Directory Users and Computers**
2. Naviguer vers **tssr.lan** → **_Ekoloclast** → **Utilisateurs**
3. Right-click → **New** → **User**

| Champ | Valeur |
|-------|--------|
| First name | Service |
| Last name | GLPI |
| User logon name | svc_glpi |
| Password | Azerty123! |
| ☑ Password never expires | Coché |
| ☐ User must change password | Décoché |

---

# PARTIE 2 : CONFIGURATION LDAP DANS GLPI

## 2.1 Accéder à la configuration LDAP

1. Se connecter à GLPI avec le compte **glpi** (Super-Admin)
2. **Configuration** → **Authentification** → **Annuaires LDAP**

```
┌─────────────────────────────────────────────────────────────────┐
│  GLPI > Configuration > Authentification                        │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  ┌─────────────────────────────────────────────────────────┐    │
│  │ • Annuaires LDAP        ← Cliquer ici                   │    │
│  │ • Serveurs de messagerie                                │    │
│  │ • Autres méthodes d'authentification                    │    │
│  └─────────────────────────────────────────────────────────┘    │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

## 2.2 Ajouter un nouvel annuaire LDAP

Cliquer sur **+ Ajouter**

```
┌─────────────────────────────────────────────────────────────────┐
│  Annuaires LDAP                                                 │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  [+ Ajouter]                                                    │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

## 2.3 Configurer l'annuaire - Onglet "Annuaire LDAP"

### Configuration principale

| Champ                    | Valeur                                                                                          | Explication                        |
| ------------------------ | ----------------------------------------------------------------------------------------------- | ---------------------------------- |
| **Nom**                  | `Active Directory Ekoloclast`                                                                   | Nom descriptif                     |
| **Serveur**              | `srvwin01.tssr.lan`                                                                             | FQDN du serveur AD                 |
| **Port**                 | `389`                                                                                           | Port LDAP standard                 |
| **Filtre de connexion**  | `(&(objectClass=user)(objectCategory=person)(!(userAccountControl:1.2.840.113556.1.4.803:=2)))` | Filtre les utilisateurs actifs     |
| **BaseDN**               | `DC=tssr,DC=lan`                                                                                | Racine de recherche                |
| **Utiliser TLS**         | Non                                                                                             | Optionnel (oui si LDAPS configuré) |
| **Version du protocole** | `3`                                                                                             | LDAP v3                            |
| **Actif**                | Oui                                                                                             | Activer l'annuaire                 |

### Compte de liaison (Bind)

| Champ            | Valeur              | Explication            |
| ---------------- | ------------------- | ---------------------- |
| **DN du compte** | `svc_glpi@tssr.lan` | Compte de service créé |
| **Mot de passe** | `Azerty123!`        | Mot de passe du compte |

```
┌─────────────────────────────────────────────────────────────────┐
│  Annuaire LDAP - Configuration                                  │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  Nom:              [Active Directory Ekoloclast        ]        │
│                                                                 │
│  Serveur:          [srvwin01.tssr.lan                  ]        │
│                                                                 │
│  Port:             [389                                ]        │
│                                                                 │
│  Filtre de         [(&(objectClass=user)(objectCategory=       │
│  connexion:         person)(!(userAccountControl:1.2.840.      │
│                     113556.1.4.803:=2)))               ]        │
│                                                                 │
│  BaseDN:           [DC=tssr,DC=lan                     ]        │
│                                                                 │
│  DN du compte:     [svc_glpi@tssr.lan                  ]        │
│                                                                 │
│  Mot de passe:     [************                       ]        │
│                                                                 │
│  Utiliser TLS:     ○ Oui  ● Non                                 │
│                                                                 │
│  Actif:            ● Oui  ○ Non                                 │
│                                                                 │
│                    [Enregistrer]  [Tester]                      │
└─────────────────────────────────────────────────────────────────┘
```

> ⚠️ **Cliquer sur "Tester" avant d'enregistrer** pour vérifier la connexion !

### Résultat du test

**Si succès :**
```
┌─────────────────────────────────────────────────────────────────┐
│  Test de connexion                                              │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  ✅ Connexion au serveur LDAP réussie                           │
│  ✅ Authentification réussie                                    │
│  ✅ X utilisateurs trouvés                                      │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

**Si échec - Erreurs courantes :**

| Erreur | Cause probable | Solution |
|--------|----------------|----------|
| "Can't contact LDAP server" | Connectivité réseau | Vérifier ping, firewall, port 389 |
| "Invalid credentials" | Mauvais compte/mdp | Vérifier svc_glpi et mot de passe |
| "No such object" | BaseDN incorrect | Vérifier DC=tssr,DC=lan |
| "0 utilisateurs" | Filtre trop restrictif | Simplifier le filtre |

## 2.4 Configurer les champs - Onglet "Utilisateurs"

Cliquer sur l'onglet **Utilisateurs** après avoir enregistré.

| Champ GLPI | Attribut LDAP | Explication |
|------------|---------------|-------------|
| **Champ de l'identifiant** | `samaccountname` | Login Windows (CRITIQUE !) |
| **Champ de synchronisation** | `objectguid` | ID unique AD |
| **Nom** | `sn` | Nom de famille |
| **Prénom** | `givenname` | Prénom |
| **Email** | `mail` | Adresse email |
| **Téléphone** | `telephonenumber` | Téléphone |
| **Téléphone mobile** | `mobile` | Mobile |
| **Titre** | `title` | Fonction |

```
┌─────────────────────────────────────────────────────────────────┐
│  Annuaire LDAP - Utilisateurs                                   │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  Champ de l'identifiant:    [samaccountname            ]        │
│                              ↑ TRÈS IMPORTANT !                 │
│                                                                 │
│  Champ de synchronisation:  [objectguid                ]        │
│                                                                 │
│  Nom:                       [sn                        ]        │
│                                                                 │
│  Prénom:                    [givenname                 ]        │
│                                                                 │
│  Email:                     [mail                      ]        │
│                                                                 │
│  Téléphone:                 [telephonenumber           ]        │
│                                                                 │
│                    [Enregistrer]                                │
└─────────────────────────────────────────────────────────────────┘
```

> ⚠️ **CRITIQUE** : Le champ `samaccountname` permet aux utilisateurs de se connecter avec leur login Windows (ex: k.kim)

## 2.5 Configurer les groupes (optionnel mais recommandé)

Onglet **Groupes** :

| Champ | Valeur |
|-------|--------|
| Type de recherche | Dans les groupes |
| Attribut utilisateur indiquant ses groupes | `memberof` |
| Filtre de recherche des groupes | `(&(objectClass=group))` |
| Utiliser le DN pour la recherche | Oui |

---

# PARTIE 3 : IMPORTER LES UTILISATEURS

## 3.1 Accéder à l'import LDAP

**Administration** → **Utilisateurs** → **Liaison annuaire LDAP**

Ou directement : `http://[IP-GLPI]/front/ldap.php`

```
┌─────────────────────────────────────────────────────────────────┐
│  Administration > Utilisateurs                                  │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  [Liaison annuaire LDAP]  ← Cliquer ici                         │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

## 3.2 Importer les utilisateurs

1. Sélectionner l'annuaire **Active Directory Ekoloclast**
2. Cliquer sur **Rechercher**

```
┌─────────────────────────────────────────────────────────────────┐
│  Import des utilisateurs depuis l'annuaire LDAP                 │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  Annuaire: [Active Directory Ekoloclast          ▼]             │
│                                                                 │
│  Filtre:   [                                      ]             │
│            (optionnel - pour filtrer par OU ou nom)             │
│                                                                 │
│                    [Rechercher]                                 │
│                                                                 │
├─────────────────────────────────────────────────────────────────┤
│  Résultats de la recherche:                                     │
│                                                                 │
│  ☐ Tout sélectionner                                            │
│                                                                 │
│  ☐ k.kim          Karim Kim           CEO                       │
│  ☐ l.fischer      Lilith Fischer      Directrice communication  │
│  ☐ p.rossi        Petra Rossi         DSI                       │
│  ☐ s.wilder       Safi Wilder         Admin System Reseau       │
│  ☐ a.abe          Abel Abe            Chargé de presse          │
│  ☐ a.akhtar       Aisha Akhtar        Responsable relation...   │
│  ...                                                            │
│                                                                 │
│                    [Importer]                                   │
└─────────────────────────────────────────────────────────────────┘
```

3. Cocher les utilisateurs à importer (ou "Tout sélectionner")
4. Cliquer sur **Importer**

## 3.3 Filtrer par OU (optionnel)

Pour importer uniquement certains départements :

**Filtre pour la DSI uniquement :**
```
(memberOf=CN=G_DSI,OU=Groupes,OU=_Ekoloclast,DC=tssr,DC=lan)
```

**Filtre par OU :**
Modifier temporairement le BaseDN :
```
OU=DSI,OU=Utilisateurs,OU=_Ekoloclast,DC=tssr,DC=lan
```

---

# PARTIE 4 : CONFIGURER LES PROFILS UTILISATEURS

## 4.1 Profils par défaut

Les utilisateurs importés ont le profil **Self-Service** par défaut (c'est correct pour les employés qui créent des tickets).

## 4.2 Modifier le profil d'un utilisateur

1. **Administration** → **Utilisateurs**
2. Cliquer sur l'utilisateur (ex: s.wilder)
3. Onglet **Autorisations**
4. Modifier le profil

```
┌─────────────────────────────────────────────────────────────────┐
│  Utilisateur: s.wilder - Autorisations                          │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  Profils:                                                       │
│                                                                 │
│  ┌────────────────────────────────────────────────────────┐     │
│  │ Entité           │ Profil        │ Récursif │ Défaut  │     │
│  │──────────────────┼───────────────┼──────────┼─────────│     │
│  │ Entité racine    │ Self-Service  │ Oui      │ Oui     │     │
│  └────────────────────────────────────────────────────────┘     │
│                                                                 │
│  [Ajouter un profil]                                            │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

## 4.3 Attribution des profils pour Ekoloclast

| Utilisateur | Profil recommandé | Raison |
|-------------|-------------------|--------|
| s.wilder (toi) | **Technicien** ou **Admin** | Équipe DSI |
| p.rossi | **Admin** | DSI (responsable) |
| k.kim | **Observer** | CEO (consultation) |
| l.fischer | **Self-Service** | Directrice Com (utilisateur) |
| Autres DSI | **Technicien** | Support IT |
| Autres employés | **Self-Service** | Création de tickets |

---

# PARTIE 5 : TESTER L'AUTHENTIFICATION

## 5.1 Se déconnecter de GLPI

Cliquer sur le nom d'utilisateur en haut à droite → **Se déconnecter**

## 5.2 Se connecter avec un compte AD

```
┌─────────────────────────────────────────────────────────────────┐
│  GLPI - Connexion                                               │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  Identifiant:    [k.kim                            ]            │
│                   ↑ Login Windows (sAMAccountName)              │
│                                                                 │
│  Mot de passe:   [************                     ]            │
│                   ↑ Mot de passe AD de l'utilisateur            │
│                                                                 │
│  Source:         [Active Directory Ekoloclast   ▼]              │
│                   ↑ Peut apparaître si plusieurs sources        │
│                                                                 │
│                    [Se connecter]                               │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

**Test avec :**
- Login : `k.kim`
- Mot de passe : Le mot de passe AD de Karim Kim

## 5.3 Vérifier l'accès Self-Service

L'utilisateur doit voir :

```
┌─────────────────────────────────────────────────────────────────┐
│  GLPI - Accueil (Self-Service)                                  │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  Bienvenue Karim Kim                                            │
│                                                                 │
│  ┌─────────────────────────────────────────────────────────┐    │
│  │ Créer un ticket                                          │    │
│  │ Mes tickets                                              │    │
│  │ FAQ                                                      │    │
│  │ Réservations                                             │    │
│  └─────────────────────────────────────────────────────────┘    │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

---

# PARTIE 6 : ACTIVER LA SYNCHRONISATION AUTOMATIQUE

## 6.1 Configurer la synchronisation

**Configuration** → **Authentification** → **Annuaires LDAP** → **Active Directory Ekoloclast**

Onglet **Réplication / Synchronisation** :

| Paramètre | Valeur recommandée |
|-----------|-------------------|
| Action lors de la suppression d'un utilisateur de l'annuaire | Désactiver l'utilisateur |
| Synchroniser les champs vides depuis le LDAP | Oui |

## 6.2 Lancer une synchronisation manuelle

**Administration** → **Utilisateurs** → **Liaison annuaire LDAP**

→ **Synchroniser les utilisateurs déjà importés**

---

# PARTIE 7 : CRÉER UN TICKET (TEST FINAL)

## 7.1 Se connecter en tant qu'utilisateur

Login : `l.fischer` (Lilith Fischer - Directrice Communication)

## 7.2 Créer un ticket

**Assistance** → **Créer un ticket**

```
┌─────────────────────────────────────────────────────────────────┐
│  Créer un ticket                                                │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  Type:         ● Incident  ○ Demande                            │
│                                                                 │
│  Catégorie:    [Incident matériel                    ▼]         │
│                                                                 │
│  Urgence:      [Moyenne                              ▼]         │
│                                                                 │
│  Titre:        [Mon PC ne démarre plus               ]          │
│                                                                 │
│  Description:                                                   │
│  ┌─────────────────────────────────────────────────────────┐    │
│  │ Depuis ce matin, mon ordinateur P0702 affiche un       │    │
│  │ écran bleu au démarrage. J'ai besoin de mon PC pour    │    │
│  │ une réunion importante cet après-midi.                 │    │
│  └─────────────────────────────────────────────────────────┘    │
│                                                                 │
│                    [Soumettre]                                  │
└─────────────────────────────────────────────────────────────────┘
```

## 7.3 Vérifier le ticket côté technicien

Se connecter avec `s.wilder` (profil Technicien)

→ **Assistance** → **Tickets** → Le ticket doit apparaître

---

# PARTIE 8 : DÉPANNAGE

## 8.1 Erreurs courantes LDAP

| Symptôme | Cause | Solution |
|----------|-------|----------|
| "Can't contact LDAP server" | Firewall ou DNS | Vérifier `ping srvwin01.tssr.lan` et port 389 |
| "Invalid credentials" | Mauvais compte | Vérifier `svc_glpi@tssr.lan` et mot de passe |
| "No such object" | BaseDN incorrect | Utiliser `DC=tssr,DC=lan` |
| 0 utilisateurs trouvés | Filtre trop restrictif | Tester avec filtre simple `(objectClass=user)` |
| Utilisateur ne peut pas se connecter | Champ identifiant | Vérifier `samaccountname` dans config |

## 8.2 Commandes de diagnostic sur SRVLX

```bash
# Test connexion LDAP
ldapsearch -x -H ldap://srvwin01.tssr.lan -D "svc_glpi@tssr.lan" -W -b "DC=tssr,DC=lan" "(objectClass=user)" sAMAccountName

# Si ldapsearch n'est pas installé
sudo apt install ldap-utils -y
```

## 8.3 Vérifier les logs GLPI

```bash
# Logs Apache
sudo tail -f /var/log/apache2/error.log

# Logs GLPI (si configuré)
sudo tail -f /var/www/glpi.tssr.lan/files/_log/php-errors.log
```

## 8.4 Vérifier le compte de service sur l'AD

Sur SRVWIN01 (PowerShell) :

```powershell
# Vérifier que le compte existe et est actif
Get-ADUser -Identity svc_glpi -Properties Enabled,PasswordNeverExpires

# Tester l'authentification
$cred = Get-Credential -UserName "svc_glpi@tssr.lan"
Get-ADUser -Identity svc_glpi -Credential $cred
```

---

# RÉCAPITULATIF

## Informations de configuration LDAP

| Paramètre | Valeur |
|-----------|--------|
| **Serveur LDAP** | srvwin01.tssr.lan |
| **Port** | 389 |
| **BaseDN** | DC=tssr,DC=lan |
| **Compte de liaison** | svc_glpi@tssr.lan |
| **Mot de passe** | Azerty123! |
| **Champ identifiant** | samaccountname |
| **Filtre** | (&(objectClass=user)(objectCategory=person)(!(userAccountControl:1.2.840.113556.1.4.803:=2))) |

## Checklist

| # | Étape | Statut |
|---|-------|--------|
| 1 | Module php-ldap installé | ☐ |
| 2 | Compte svc_glpi créé sur AD | ☐ |
| 3 | Connectivité SRVLX → SRVWIN01 port 389 | ☐ |
| 4 | Annuaire LDAP configuré dans GLPI | ☐ |
| 5 | Test de connexion LDAP réussi | ☐ |
| 6 | Champ identifiant = samaccountname | ☐ |
| 7 | Utilisateurs importés | ☐ |
| 8 | Profils attribués | ☐ |
| 9 | Connexion utilisateur AD testée | ☐ |
| 10 | Création de ticket testée | ☐ |

---

## DIFFÉRENCES AVEC LE GUIDE DU CAMARADE

| Aspect | Guide camarade | Mon guide |
|--------|----------------|-----------|
| **Compte de liaison** | Non mentionné | svc_glpi@tssr.lan (détaillé) |
| **BaseDN** | Non précisé | DC=tssr,DC=lan |
| **Filtre de connexion** | Incomplet | Filtre complet fourni |
| **Champs mapping** | Partiellement | Tous les champs détaillés |
| **Prérequis** | Non mentionnés | php-ldap, connectivité |
| **Dépannage** | Absent | Section complète |
| **Installation** | Docker | Apache/MariaDB (ta situation) |

---

**Document créé pour le projet Ekoloclast**
**Configuration LDAP GLPI - Installation Apache/MariaDB**
