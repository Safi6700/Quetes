# 📗 GUIDE COMPLET - EXERCICE 2 : LINUX
## Manipulations pratiques sur VM Linux Debian - Serveur SRVLX01
### 👤 Guide personnalisé pour Safiullah

---

# 📋 INFORMATIONS SUR L'ENVIRONNEMENT

```
🖥️ SERVEUR LINUX :
- Nom d'hôte : SRVLX01
- Système : Debian GNU/Linux
- IP : 192.168.1.100 (à adapter selon votre réseau)

💻 MACHINE HÔTE :
- Système : Windows 11
- Utilisateur Windows : Safiullah

👤 UTILISATEUR À CRÉER SUR LINUX :
- Nom d'utilisateur : safiullah
- Rôle : Administrateur système (avec sudo)

🔌 CONNEXION :
- Protocole : SSH depuis Windows 11
- Outil : PowerShell (intégré Windows 11)
```

---

# 🚀 CONNEXION INITIALE AU SERVEUR

Avant de commencer les exercices, vous devez vous connecter au serveur Linux depuis Windows 11.

## Étape 1 : Ouvrir PowerShell sur Windows 11

```powershell
# Méthode 1 : Raccourci clavier
[Windows] + [X] → Sélectionner "Terminal Windows"

# Méthode 2 : Menu Démarrer
Cliquer sur Démarrer → Taper "powershell" → Entrée
```

## Étape 2 : Se connecter en SSH

```powershell
ssh root@192.168.1.100
# Remplacez 192.168.1.100 par l'IP de votre serveur
```

**Entrer le mot de passe root** (les caractères ne s'affichent pas)

**Vous êtes maintenant connecté au serveur SRVLX01 !**

```
root@SRVLX01:~# 
```

---

# 📂 PARTIE 1 : GESTION DES UTILISATEURS

---

## ❓ QUESTION 2.1.1

**Sur le serveur, créer un compte pour ton usage personnel.**

---

## ✅ RÉPONSE DÉTAILLÉE Q.2.1.1

### Objectif
Créer un compte utilisateur nommé **safiullah** sur le serveur Linux SRVLX01.

### Pourquoi créer un compte personnel ?

**Raisons de sécurité :**
- Ne **JAMAIS** utiliser root pour les tâches quotidiennes
- Root a tous les privilèges → une erreur peut détruire le système
- Un compte personnel permet la **traçabilité** (savoir qui a fait quoi)
- **Principe du moindre privilège** : utiliser les droits minimums nécessaires

### Commandes complètes à exécuter

#### Étape 1 : Créer l'utilisateur safiullah

```bash
useradd -m -s /bin/bash safiullah
```

**Explication détaillée :**
- `useradd` : commande pour créer un utilisateur
- `-m` : crée le répertoire personnel `/home/safiullah`
- `-s /bin/bash` : définit bash comme shell par défaut
- `safiullah` : nom de l'utilisateur

**Ce qui se passe en arrière-plan :**
1. Création de l'entrée dans `/etc/passwd`
2. Création du groupe `safiullah` dans `/etc/group`
3. Création du répertoire `/home/safiullah`
4. Copie des fichiers de configuration depuis `/etc/skel`

#### Étape 2 : Définir le mot de passe

```bash
passwd safiullah
```

**Vous serez invité à :**
```
New password: [tapez votre mot de passe]
Retype new password: [retapez le même]
```

**⚠️ Les caractères ne s'affichent pas quand vous tapez (sécurité normale)**

**Recommandations pour le mot de passe :**
- Minimum 12 caractères
- Mélange de majuscules, minuscules, chiffres et symboles
- Exemple : `Safi2025@Secure!`

#### Étape 3 : Ajouter safiullah au groupe sudo

```bash
usermod -aG sudo safiullah
```

**Explication :**
- `usermod` : modifier un utilisateur
- `-aG` : ajouter au groupe (sans retirer les autres groupes)
- `sudo` : nom du groupe
- `safiullah` : utilisateur à modifier

**Pourquoi sudo est important :**
- Permet d'exécuter des commandes administratives avec `sudo`
- Exemple : `sudo apt update`, `sudo systemctl restart ssh`
- Plus sécurisé que d'utiliser root directement

#### Étape 4 : Vérifier la création

```bash
# Vérifier que l'utilisateur existe
id safiullah
```

**Résultat attendu :**
```
uid=1001(safiullah) gid=1001(safiullah) groups=1001(safiullah),27(sudo)
```

✅ L'utilisateur est créé et membre du groupe sudo !

```bash
# Vérifier le répertoire personnel
ls -la /home/safiullah
```

**Résultat attendu :**
```
total 20
drwxr-xr-x 2 safiullah safiullah 4096 Feb 12 10:00 .
drwxr-xr-x 3 root      root      4096 Feb 12 10:00 ..
-rw-r--r-- 1 safiullah safiullah  220 Feb 12 10:00 .bash_logout
-rw-r--r-- 1 safiullah safiullah 3526 Feb 12 10:00 .bashrc
-rw-r--r-- 1 safiullah safiullah  807 Feb 12 10:00 .profile
```

✅ Le répertoire personnel existe avec les fichiers de configuration !

#### Étape 5 : Tester la connexion

```bash
# Basculer vers l'utilisateur safiullah
su - safiullah
```

**Vous devriez voir :**
```
safiullah@SRVLX01:~$ 
```

Le `$` (au lieu de `#`) indique que vous n'êtes plus root.

```bash
# Tester sudo
sudo whoami
```

**Entrer le mot de passe de safiullah**

**Résultat attendu :**
```
root
```

✅ Sudo fonctionne ! Safiullah peut exécuter des commandes administratives.

```bash
# Revenir en root
exit
```

### Récapitulatif des commandes

```bash
# 1. Créer l'utilisateur
useradd -m -s /bin/bash safiullah

# 2. Définir le mot de passe
passwd safiullah

# 3. Ajouter au groupe sudo
usermod -aG sudo safiullah

# 4. Vérifier
id safiullah
ls -la /home/safiullah

# 5. Tester
su - safiullah
sudo whoami
exit
```

---

## ❓ QUESTION 2.1.2

**Quelles préconisations proposes-tu concernant ce compte ?**

---

## ✅ RÉPONSE DÉTAILLÉE Q.2.1.2

### Objectif
Identifier les bonnes pratiques de sécurité pour le compte safiullah.

### Préconisations complètes de sécurité

#### 1️⃣ MOT DE PASSE FORT ET GESTION

**A) Caractéristiques d'un bon mot de passe**

```
✅ CRITÈRES OBLIGATOIRES :
- Longueur : minimum 12 caractères (recommandé : 16+)
- Majuscules ET minuscules
- Chiffres
- Caractères spéciaux (!@#$%^&*)
- Pas de mots du dictionnaire
- Pas d'informations personnelles (nom, date de naissance)

❌ À ÉVITER :
- safiullah123
- password
- 12345678
- qwerty
```

**B) Expiration et rotation du mot de passe**

```bash
# Forcer le changement de mot de passe tous les 90 jours
sudo chage -M 90 safiullah

# Minimum 1 jour entre deux changements (éviter le contournement)
sudo chage -m 1 safiullah

# Avertir 7 jours avant l'expiration
sudo chage -W 7 safiullah

# Voir la configuration actuelle
sudo chage -l safiullah
```

**Résultat de `chage -l` :**
```
Last password change                                    : Feb 12, 2026
Password expires                                        : May 13, 2026
Password inactive                                       : never
Account expires                                         : never
Minimum number of days between password change          : 1
Maximum number of days between password change          : 90
Number of days of warning before password expires       : 7
```

#### 2️⃣ UTILISER SUDO AU LIEU DE ROOT

**Principe :**
- **Ne JAMAIS** se connecter directement en root
- Toujours utiliser son compte personnel + sudo
- Traçabilité : toutes les commandes sudo sont loggées

**Exemple d'utilisation :**

```bash
# ❌ MAUVAIS : devenir root pour tout
sudo su -

# ✅ BON : utiliser sudo pour chaque commande
sudo apt update
sudo systemctl restart ssh
sudo nano /etc/ssh/sshd_config
```

**Avantages :**
- Chaque commande sudo est enregistrée dans `/var/log/auth.log`
- On sait exactement qui a fait quoi et quand
- Réduction des erreurs catastrophiques

#### 3️⃣ AUTHENTIFICATION PAR CLÉ SSH (À CONFIGURER EN Q.2.2.3)

**Principe :**
- Générer une paire de clés (privée/publique)
- Clé privée reste sur Windows 11
- Clé publique copiée sur le serveur
- Connexion sans mot de passe (mais plus sécurisée !)

**Avantages :**
- Impossible de "deviner" une clé (2048 ou 4096 bits)
- Pas de risque de keylogger
- Protection contre les attaques par force brute
- Peut être protégée par une passphrase additionnelle

#### 4️⃣ PERMISSIONS ET ISOLATION

**A) Vérifier les permissions du répertoire personnel**

```bash
# Le répertoire doit appartenir à safiullah
ls -ld /home/safiullah
```

**Résultat correct :**
```
drwxr-xr-x 2 safiullah safiullah 4096 Feb 12 10:00 /home/safiullah
```

**Signification :**
- `drwxr-xr-x` : propriétaire rwx (lecture/écriture/exécution), groupe rx, autres rx
- Propriétaire : safiullah ✅
- Groupe : safiullah ✅

**B) Protéger les fichiers sensibles**

```bash
# Permissions strictes pour les clés SSH (quand créées)
chmod 700 ~/.ssh
chmod 600 ~/.ssh/authorized_keys
chmod 600 ~/.ssh/id_rsa  # clé privée si elle existe
```

#### 5️⃣ JOURNALISATION ET AUDIT

**A) Toutes les connexions sont loggées**

```bash
# Voir les dernières connexions de safiullah
last safiullah

# Voir les tentatives échouées
sudo lastb safiullah

# Voir les commandes sudo exécutées
sudo grep safiullah /var/log/auth.log | grep sudo
```

**B) Activer l'historique des commandes**

```bash
# Vérifier la taille de l'historique
echo $HISTSIZE
# Devrait afficher 1000 ou plus

# Pour augmenter (optionnel)
echo "export HISTSIZE=5000" >> ~/.bashrc
echo "export HISTFILESIZE=10000" >> ~/.bashrc
source ~/.bashrc
```

#### 6️⃣ TIMEOUT DE SESSION (OPTIONNEL)

**Déconnexion automatique après inactivité**

```bash
# Éditer .bashrc
nano ~/.bashrc

# Ajouter à la fin :
export TMOUT=600
# Déconnexion après 10 minutes d'inactivité

# Activer immédiatement
source ~/.bashrc
```

#### 7️⃣ RESTRICTIONS SUPPLÉMENTAIRES (AVANCÉ)

**A) Limiter les ressources système**

```bash
# Éditer les limites
sudo nano /etc/security/limits.conf

# Ajouter :
safiullah soft nproc 100        # Max 100 processus
safiullah hard nproc 150
safiullah soft nofile 1024      # Max 1024 fichiers ouverts
safiullah hard nofile 2048
```

**B) Restrictions horaires (si nécessaire)**

```bash
# Configurer PAM pour limiter les heures de connexion
sudo nano /etc/security/time.conf

# Exemple : connexion uniquement en semaine 8h-18h
login;*;safiullah;Mo Tu We Th Fr0800-1800
```

#### 8️⃣ SURVEILLANCE ET MONITORING

**A) Installer et configurer fail2ban (recommandé)**

```bash
# Installer fail2ban
sudo apt update
sudo apt install fail2ban -y

# Fail2ban bannit automatiquement les IPs qui font
# trop de tentatives de connexion échouées
```

**B) Alertes par email (avancé)**

```bash
# Configurer des alertes pour les connexions SSH réussies
sudo nano /etc/ssh/sshrc

# Ajouter :
echo "SSH Login: $(date) - User: $USER - From: $SSH_CONNECTION" | \
mail -s "SSH Login on SRVLX01" admin@example.com
```

### Checklist de sécurité complète

```
☑ SÉCURITÉ DU COMPTE SAFIULLAH :

✅ Mot de passe fort (12+ caractères, complexe)
✅ Expiration du mot de passe (90 jours)
✅ Membre du groupe sudo
✅ Utilisation de sudo au lieu de root
✅ Authentification SSH par clé (à configurer en Q.2.2.3)
✅ Mot de passe SSH désactivé (à faire en Q.2.2.3)
✅ Permissions correctes sur /home/safiullah (755)
✅ Journalisation activée (auth.log)
✅ Historique des commandes activé
✅ Monitoring des connexions
✅ Timeout de session (optionnel)
✅ Fail2ban installé (recommandé)
✅ Limitations de ressources (optionnel)
```

### Récapitulatif

**Préconisations essentielles :**

1. **Mot de passe fort** avec expiration tous les 90 jours
2. **Utiliser sudo** et ne jamais se connecter en root
3. **Authentification par clé SSH** (partie 2)
4. **Permissions correctes** sur les fichiers et répertoires
5. **Surveillance** via les logs système
6. **Timeout** de session après inactivité
7. **Fail2ban** pour protection contre attaques

---

# 🔐 PARTIE 2 : CONFIGURATION DE SSH

---

## ❓ QUESTION 2.2.1

**Désactiver complètement l'accès à distance de l'utilisateur root.**

---

## ✅ RÉPONSE DÉTAILLÉE Q.2.2.1

### Objectif
Empêcher les connexions SSH en tant que root pour améliorer la sécurité du serveur.

### Pourquoi désactiver root via SSH ?

**Raisons de sécurité critiques :**

```
🎯 ROOT EST UNE CIBLE UNIVERSELLE :
- Tous les attaquants essaient "root" en premier
- Le nom d'utilisateur est connu (root existe sur tous les Linux)
- Les attaquants n'ont qu'à deviner le mot de passe

🛡️ AVEC ROOT DÉSACTIVÉ :
- Les attaquants doivent deviner DEUX choses :
  1. Le nom d'utilisateur (safiullah)
  2. Le mot de passe
- Surface d'attaque considérablement réduite

📊 TRAÇABILITÉ :
- Si tout le monde utilise root → impossible de savoir qui a fait quoi
- Avec des comptes personnels → chaque action est tracée

🔒 LIMITATION DES DÉGÂTS :
- Un compte normal ne peut pas tout détruire
- Même avec sudo, il faut explicitement taper "sudo"
- Réduit les erreurs catastrophiques
```

### Procédure complète étape par étape

#### Étape 1 : Sauvegarder la configuration SSH

**TOUJOURS faire une sauvegarde avant modification !**

```bash
sudo cp /etc/ssh/sshd_config /etc/ssh/sshd_config.backup
```

**Vérifier que la sauvegarde existe :**

```bash
ls -l /etc/ssh/sshd_config*
```

**Résultat attendu :**
```
-rw-r--r-- 1 root root 3300 Feb 12 10:30 /etc/ssh/sshd_config
-rw-r--r-- 1 root root 3300 Feb 12 10:35 /etc/ssh/sshd_config.backup
```

✅ La sauvegarde est créée !

#### Étape 2 : Éditer le fichier de configuration SSH

```bash
sudo nano /etc/ssh/sshd_config
```

**L'éditeur nano s'ouvre avec le fichier.**

#### Étape 3 : Rechercher la ligne PermitRootLogin

**Dans nano, utiliser la recherche :**

```
1. Appuyer sur [Ctrl] + [W]
2. Taper : PermitRootLogin
3. Appuyer sur [Enter]
```

**Vous trouverez une ligne comme :**

```
#PermitRootLogin prohibit-password
```

**OU**

```
PermitRootLogin yes
```

**Explication des valeurs possibles :**

```
PermitRootLogin yes
→ Root peut se connecter avec un mot de passe
→ ❌ DANGEREUX !

PermitRootLogin prohibit-password
→ Root peut se connecter UNIQUEMENT avec une clé SSH
→ ⚠️ Moyennement sécurisé

PermitRootLogin no
→ Root NE PEUT PAS se connecter du tout
→ ✅ RECOMMANDÉ ET SÉCURISÉ !
```

#### Étape 4 : Modifier la ligne

**Modifier pour avoir exactement :**

```
PermitRootLogin no
```

**Actions dans nano :**

1. Si la ligne commence par `#`, supprimer le `#`
2. Remplacer la valeur par `no`
3. S'assurer qu'il n'y a **pas** de `#` au début
4. S'assurer que la valeur est bien `no`

**Ligne finale :**
```
PermitRootLogin no
```

#### Étape 5 : Sauvegarder et quitter nano

```
1. [Ctrl] + [O] → Sauvegarder
2. [Enter] → Confirmer le nom du fichier
3. [Ctrl] + [X] → Quitter
```

#### Étape 6 : Vérifier la modification

```bash
grep "^PermitRootLogin" /etc/ssh/sshd_config
```

**Résultat attendu :**
```
PermitRootLogin no
```

✅ La ligne est correctement configurée (pas de `#`, valeur `no`) !

#### Étape 7 : Tester la configuration (TRÈS IMPORTANT)

**AVANT de redémarrer SSH, toujours tester la syntaxe :**

```bash
sudo sshd -t
```

**Si rien ne s'affiche :**
```
✅ La configuration est correcte !
```

**Si un message d'erreur apparaît :**
```
❌ Il y a une erreur de syntaxe
→ NE PAS redémarrer SSH !
→ Corriger l'erreur d'abord
→ Retester avec "sudo sshd -t"
```

#### Étape 8 : Redémarrer le service SSH

**⚠️ ATTENTION CRITIQUE :**

```
AVANT de redémarrer SSH, assurez-vous que :

1. ✅ L'utilisateur safiullah existe
2. ✅ Safiullah a un mot de passe défini
3. ✅ Safiullah est dans le groupe sudo
4. ✅ Vous avez testé la connexion avec safiullah
5. ✅ La commande "sudo sshd -t" ne retourne aucune erreur

SI L'UN DE CES POINTS N'EST PAS FAIT :
❌ Ne redémarrez PAS SSH !
❌ Vous risquez de vous bloquer hors du serveur !
```

**Redémarrer SSH :**

```bash
sudo systemctl restart sshd
```

**OU (selon la distribution) :**

```bash
sudo systemctl restart ssh
```

**Vérifier que SSH fonctionne :**

```bash
sudo systemctl status sshd
```

**Résultat attendu :**

```
● ssh.service - OpenBSD Secure Shell server
   Loaded: loaded (/lib/systemd/system/ssh.service; enabled)
   Active: active (running) since Wed 2026-02-12 10:40:00 CET; 5s ago
     Docs: man:sshd(8)
           man:sshd_config(5)
  Process: 1234 ExecStartPre=/usr/sbin/sshd -t (code=exited, status=0/SUCCESS)
 Main PID: 1235 (sshd)
    Tasks: 1 (limit: 4915)
   Memory: 2.1M
   CGroup: /system.slice/ssh.service
           └─1235 /usr/sbin/sshd -D

Feb 12 10:40:00 SRVLX01 systemd[1]: Starting OpenBSD Secure Shell server...
Feb 12 10:40:00 SRVLX01 sshd[1235]: Server listening on 0.0.0.0 port 22.
Feb 12 10:40:00 SRVLX01 sshd[1235]: Server listening on :: port 22.
Feb 12 10:40:00 SRVLX01 systemd[1]: Started OpenBSD Secure Shell server.
```

✅ **Active: active (running)** → SSH fonctionne correctement !

#### Étape 9 : Tester la désactivation de root

**⚠️ NE PAS FERMER VOTRE SESSION SSH ACTUELLE !**

**Ouvrir un NOUVEAU PowerShell sur Windows 11 :**

```powershell
# Tenter de se connecter en root
ssh root@192.168.1.100
```

**Résultat attendu (ROOT REFUSÉ) :**

```
root@192.168.1.100's password: [tapez le mot de passe]

Permission denied, please try again.
root@192.168.1.100's password: 

Permission denied, please try again.
root@192.168.1.100's password: 

root@192.168.1.100: Permission denied (publickey,password).
```

✅ **PARFAIT ! Root ne peut plus se connecter !**

**Maintenant tester avec safiullah :**

```powershell
ssh safiullah@192.168.1.100
```

**Résultat attendu (SAFIULLAH AUTORISÉ) :**

```
safiullah@192.168.1.100's password: [tapez le mot de passe de safiullah]

safiullah@SRVLX01:~$ 
```

✅ **PARFAIT ! Safiullah peut toujours se connecter !**

#### Étape 10 : Vérifier les logs

```bash
# Voir les tentatives de connexion root refusées
sudo grep "Failed password for root" /var/log/auth.log | tail -5
```

**Résultat (exemple) :**

```
Feb 12 10:45:15 SRVLX01 sshd[1250]: Failed password for root from 192.168.1.50 port 54321 ssh2
Feb 12 10:45:18 SRVLX01 sshd[1250]: Failed password for root from 192.168.1.50 port 54321 ssh2
Feb 12 10:45:21 SRVLX01 sshd[1250]: Failed password for root from 192.168.1.50 port 54321 ssh2
```

✅ Les tentatives root sont bien refusées et loggées !

### Récapitulatif complet

```bash
# 1. Sauvegarder la configuration
sudo cp /etc/ssh/sshd_config /etc/ssh/sshd_config.backup

# 2. Éditer la configuration
sudo nano /etc/ssh/sshd_config

# 3. Modifier la ligne (avec nano)
# Chercher : [Ctrl] + [W] → PermitRootLogin
# Modifier pour avoir : PermitRootLogin no

# 4. Sauvegarder dans nano
# [Ctrl] + [O] → [Enter] → [Ctrl] + [X]

# 5. Vérifier la modification
grep "^PermitRootLogin" /etc/ssh/sshd_config

# 6. Tester la syntaxe
sudo sshd -t

# 7. Redémarrer SSH
sudo systemctl restart sshd

# 8. Vérifier le statut
sudo systemctl status sshd

# 9. Tester (dans un NOUVEAU PowerShell)
# ssh root@IP → Doit ÉCHOUER
# ssh safiullah@IP → Doit RÉUSSIR
```

**Configuration finale dans /etc/ssh/sshd_config :**
```
PermitRootLogin no
```

✅ **Root ne peut plus se connecter via SSH !**
✅ **Safiullah peut toujours se connecter !**
✅ **Le serveur est plus sécurisé !**

---

## ❓ QUESTION 2.2.2

**Autoriser l'accès à distance à ton compte personnel uniquement.**

---

## ✅ RÉPONSE DÉTAILLÉE Q.2.2.2

### Objectif
Configurer SSH pour que SEUL safiullah puisse se connecter au serveur, et aucun autre utilisateur.

### Pourquoi limiter l'accès SSH ?

```
🛡️ PRINCIPE DE DÉFENSE EN PROFONDEUR :

1. RÉDUCTION DE LA SURFACE D'ATTAQUE
   - Moins d'utilisateurs autorisés = moins de cibles
   - Contrôle strict des accès

2. PROTECTION CONTRE LES COMPTES COMPROMIS
   - Si un autre compte est piraté, l'attaquant ne peut pas l'utiliser pour SSH
   - Même si le mot de passe d'un autre utilisateur est découvert

3. CONFORMITÉ ET AUDIT
   - On sait exactement qui peut se connecter
   - Facilite les audits de sécurité
   - Répond aux normes (ISO 27001, PCI-DSS)

4. SIMPLICITÉ
   - Configuration claire et compréhensible
   - Facilite le dépannage
```

### Procédure complète étape par étape

#### Étape 1 : Éditer la configuration SSH

```bash
sudo nano /etc/ssh/sshd_config
```

#### Étape 2 : Rechercher ou ajouter la directive AllowUsers

**Dans nano, rechercher :**

```
[Ctrl] + [W]
Taper : AllowUsers
[Enter]
```

**Deux cas possibles :**

**CAS 1 : La ligne existe déjà**
```
#AllowUsers user1 user2
```

→ Modifier cette ligne

**CAS 2 : La ligne n'existe pas**
```
[ Search Wrapped ]
```

→ Ajouter une nouvelle ligne

#### Étape 3 : Ajouter ou modifier AllowUsers

**Où ajouter la ligne ?**

Ajouter vers la fin du fichier, avant les dernières lignes de commentaire.

**Exemple de positionnement :**

```
...
# Accept locale-related environment variables
AcceptEnv LANG LC_*

# override default of no subsystems
Subsystem       sftp    /usr/lib/openssh/sftp-server

AllowUsers safiullah

# Example of overriding settings on a per-user basis
#Match User anoncvs
#       X11Forwarding no
...
```

**Taper exactement :**

```
AllowUsers safiullah
```

**⚠️ IMPORTANT :**
- Pas de `#` au début
- Un espace entre `AllowUsers` et `safiullah`
- Respecter la casse (minuscules)

#### Étape 4 : Comprendre la directive AllowUsers

**Syntaxe générale :**

```bash
AllowUsers utilisateur1 utilisateur2 utilisateur3
```

**Exemples d'utilisation :**

```bash
# 1. Autoriser UN SEUL utilisateur (notre cas)
AllowUsers safiullah

# 2. Autoriser PLUSIEURS utilisateurs
AllowUsers safiullah admin backup

# 3. Autoriser avec restriction IP
AllowUsers safiullah@192.168.1.50
# → safiullah peut se connecter UNIQUEMENT depuis 192.168.1.50

# 4. Autoriser avec pattern
AllowUsers safi*
# → Autorise tous les utilisateurs commençant par "safi"
```

**Dans notre cas :**
```
AllowUsers safiullah
```

→ **SEUL** safiullah peut se connecter, depuis **n'importe quelle IP**

#### Étape 5 : Sauvegarder et quitter nano

```
[Ctrl] + [O] → Sauvegarder
[Enter] → Confirmer
[Ctrl] + [X] → Quitter
```

#### Étape 6 : Vérifier la modification

```bash
grep "^AllowUsers" /etc/ssh/sshd_config
```

**Résultat attendu :**
```
AllowUsers safiullah
```

✅ La configuration est correcte !

#### Étape 7 : Tester la syntaxe

```bash
sudo sshd -t
```

**Si rien ne s'affiche :**
```
✅ La configuration est syntaxiquement correcte !
```

#### Étape 8 : Redémarrer SSH

```bash
sudo systemctl restart sshd
```

**Vérifier le statut :**

```bash
sudo systemctl status sshd
```

**Résultat attendu :**
```
● ssh.service - OpenBSD Secure Shell server
   Active: active (running)
```

✅ SSH fonctionne correctement !

#### Étape 9 : Tests complets

**⚠️ TOUJOURS garder une session SSH ouverte pendant les tests !**

**Test 1 : root ne peut PAS se connecter**

```powershell
# Depuis Windows 11 (nouveau PowerShell)
ssh root@192.168.1.100
```

**Résultat attendu :**
```
root@192.168.1.100's password: [tapez]

Permission denied, please try again.
```

✅ Root est bien refusé (cumul avec Q.2.2.1) !

**Test 2 : safiullah PEUT se connecter**

```powershell
ssh safiullah@192.168.1.100
```

**Résultat attendu :**
```
safiullah@192.168.1.100's password: [tapez]

safiullah@SRVLX01:~$ 
```

✅ Safiullah est bien autorisé !

**Test 3 : Un autre utilisateur ne peut PAS se connecter**

**D'abord, créer un utilisateur de test :**

```bash
# Sur le serveur (session safiullah avec sudo)
sudo useradd -m testuser
sudo passwd testuser
# Définir un mot de passe
```

**Ensuite, tenter de se connecter :**

```powershell
# Depuis Windows 11
ssh testuser@192.168.1.100
```

**Résultat attendu :**
```
testuser@192.168.1.100's password: [tapez]

Permission denied, please try again.
```

✅ testuser est bien refusé !

**Supprimer l'utilisateur de test :**

```bash
sudo userdel -r testuser
```

### Scénarios avancés (optionnels)

#### Autoriser plusieurs utilisateurs

Si vous voulez autoriser safiullah ET admin :

```
AllowUsers safiullah admin
```

#### Restreindre par IP

Si safiullah doit se connecter UNIQUEMENT depuis un poste spécifique :

```
AllowUsers safiullah@192.168.1.50
```

→ Safiullah ne pourra se connecter QUE depuis 192.168.1.50

#### Combiner IP et utilisateurs multiples

```
AllowUsers safiullah@192.168.1.50 admin@192.168.1.51
```

### Vérification dans les logs

```bash
# Voir les tentatives refusées
sudo grep "User .* from .* not allowed" /var/log/auth.log | tail -10
```

**Résultat (exemple) :**
```
Feb 12 11:00:15 SRVLX01 sshd[1300]: User testuser from 192.168.1.50 not allowed because not listed in AllowUsers
Feb 12 11:00:18 SRVLX01 sshd[1301]: User root from 192.168.1.50 not allowed because not listed in AllowUsers
```

✅ Les utilisateurs non autorisés sont bien refusés et loggés !

### Récapitulatif complet

```bash
# 1. Éditer la configuration SSH
sudo nano /etc/ssh/sshd_config

# 2. Ajouter la ligne (si elle n'existe pas)
AllowUsers safiullah

# 3. Sauvegarder et quitter nano
# [Ctrl] + [O] → [Enter] → [Ctrl] + [X]

# 4. Vérifier la modification
grep "^AllowUsers" /etc/ssh/sshd_config

# 5. Tester la syntaxe
sudo sshd -t

# 6. Redémarrer SSH
sudo systemctl restart sshd

# 7. Tester les connexions
# safiullah → DOIT FONCTIONNER
# root → DOIT ÊTRE REFUSÉ
# autres → DOIVENT ÊTRE REFUSÉS
```

**Configuration finale dans /etc/ssh/sshd_config :**

```
PermitRootLogin no
AllowUsers safiullah
```

**Effet combiné :**
- Root ne peut PAS se connecter (Q.2.2.1)
- Safiullah PEUT se connecter (Q.2.2.2)
- TOUS les autres utilisateurs sont refusés

✅ **Sécurité maximale : un seul compte autorisé !**

---

## ❓ QUESTION 2.2.3

**Mettre en place une authentification par clé valide et désactiver l'authentification par mot de passe**

---

## ✅ RÉPONSE DÉTAILLÉE Q.2.2.3

### Objectifs
1. Générer une paire de clés SSH sur Windows 11
2. Copier la clé publique sur le serveur SRVLX01
3. Tester la connexion avec la clé
4. Désactiver l'authentification par mot de passe

### Pourquoi utiliser des clés SSH ?

```
🔐 AVANTAGES DES CLÉS SSH :

1. SÉCURITÉ MAXIMALE
   ✅ Clé de 2048 ou 4096 bits (vs mot de passe de quelques caractères)
   ✅ Impossible à "deviner" par force brute
   ✅ Pas de risque de keylogger
   ✅ Peut être protégée par une passphrase additionnelle

2. CONFORT
   ✅ Connexion automatique (ou avec passphrase courte)
   ✅ Pas besoin de retaper le mot de passe à chaque fois

3. AUDIT ET CONTRÔLE
   ✅ Chaque clé est unique et traçable
   ✅ Révocation simple en cas de compromission
   ✅ Gestion centralisée possible

4. MEILLEURE PRATIQUE
   ✅ Recommandé par NIST, ANSSI, toutes les normes de sécurité
   ✅ Standard dans les environnements professionnels
```

### PHASE 1 : Générer la paire de clés (sur Windows 11)

#### Étape 1 : Ouvrir PowerShell sur Windows 11

```powershell
# Raccourci clavier
[Windows] + [X] → Terminal Windows
```

#### Étape 2 : Vérifier si des clés existent déjà

```powershell
# Vérifier si le dossier .ssh existe
Test-Path $env:USERPROFILE\.ssh
```

**Si "True" :**
```powershell
# Voir les clés existantes
dir $env:USERPROFILE\.ssh
```

**Si vous voyez `id_rsa` et `id_rsa.pub` :**
→ Des clés existent déjà, vous pouvez les réutiliser OU en générer de nouvelles

#### Étape 3 : Générer une nouvelle paire de clés

```powershell
ssh-keygen -t rsa -b 4096 -C "safiullah@windows11"
```

**Explication détaillée :**
- `ssh-keygen` : programme de génération de clés
- `-t rsa` : type de clé RSA (le plus universel)
- `-b 4096` : taille 4096 bits (très sécurisé)
- `-C "safiullah@windows11"` : commentaire pour identifier la clé

**PROCESSUS INTERACTIF :**

**Question 1 : Emplacement**

```
Generating public/private rsa key pair.
Enter file in which to save the key (C:\Users\Safiullah\.ssh\id_rsa):
```

→ **Appuyer sur [Enter]** pour accepter l'emplacement par défaut

**Question 2 : Passphrase (protection supplémentaire)**

```
Enter passphrase (empty for no passphrase):
```

**DEUX OPTIONS :**

**Option A : Sans passphrase (connexion automatique)**
```
→ Appuyer sur [Enter] (laisser vide)
→ Appuyer sur [Enter] encore une fois

✅ Connexion totalement automatique
❌ Si quelqu'un vole le fichier id_rsa, il peut l'utiliser
```

**Option B : Avec passphrase (recommandé pour plus de sécurité)**
```
→ Taper une passphrase forte (ex: "MaCle2025SSH!Secure")
→ Retaper la même passphrase

✅ Double protection : fichier + passphrase
✅ Si fichier volé, inutilisable sans passphrase
⚠️ Vous devrez taper la passphrase à chaque connexion
   (mais elle est plus courte qu'un mot de passe complet)
```

**Génération terminée :**

```
Your identification has been saved in C:\Users\Safiullah\.ssh\id_rsa
Your public key has been saved in C:\Users\Safiullah\.ssh\id_rsa.pub
The key fingerprint is:
SHA256:xXxXxXxXxXxXxXxXxXxXxXxXxXxXxXxXxXxXxXxXxXx safiullah@windows11
The key's randomart image is:
+---[RSA 4096]----+
|        .o+o     |
|       . =+.     |
|      . +.=      |
|     . + B o     |
|      = S = .    |
|     . = O +     |
|      + B * .    |
|     . * + .     |
|      E.o        |
+----[SHA256]-----+
```

✅ **La paire de clés est générée !**

#### Étape 4 : Vérifier les clés créées

```powershell
dir $env:USERPROFILE\.ssh
```

**Résultat attendu :**
```
Mode                 LastWriteTime         Length Name
----                 -------------         ------ ----
-a---          12/02/2026    11:00           3389 id_rsa
-a---          12/02/2026    11:00            753 id_rsa.pub
```

✅ **Deux fichiers créés :**
- `id_rsa` : Clé PRIVÉE (à garder SECRÈTE, ne JAMAIS partager !)
- `id_rsa.pub` : Clé PUBLIQUE (à copier sur le serveur)

#### Étape 5 : Voir le contenu de la clé publique

```powershell
cat $env:USERPROFILE\.ssh\id_rsa.pub
```

**Résultat (exemple) :**
```
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDGxxxxxxxxxxxxxxxxxxxx
xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx safiullah@windows11
```

📝 **C'est cette longue chaîne qu'on va copier sur le serveur**

### PHASE 2 : Copier la clé publique sur le serveur

#### Étape 1 : Se connecter au serveur

```powershell
ssh safiullah@192.168.1.100
```

**Entrer le mot de passe de safiullah**

```
safiullah@SRVLX01:~$ 
```

✅ Connecté au serveur !

#### Étape 2 : Créer le répertoire .ssh (si nécessaire)

```bash
# Vérifier si .ssh existe
ls -la ~/.ssh
```

**Si erreur "No such file or directory" :**

```bash
# Créer le répertoire
mkdir -p ~/.ssh

# Définir les permissions correctes
chmod 700 ~/.ssh
```

**Explication des permissions :**
- `700` = Propriétaire : rwx, Groupe : ---, Autres : ---
- Important pour la sécurité SSH !

#### Étape 3 : Créer le fichier authorized_keys

```bash
touch ~/.ssh/authorized_keys
chmod 600 ~/.ssh/authorized_keys
```

**Explication :**
- `600` = Propriétaire : rw-, Groupe : ---, Autres : ---
- Ce fichier contiendra les clés publiques autorisées

#### Étape 4 : Copier la clé publique

**MÉTHODE 1 : Copier-coller (RECOMMANDÉ)**

**Sur Windows 11 (nouveau PowerShell) :**

```powershell
# Copier la clé dans le presse-papiers Windows
cat $env:USERPROFILE\.ssh\id_rsa.pub | clip
```

✅ **La clé est maintenant dans votre presse-papiers !**

**Sur le serveur SRVLX01 (session SSH safiullah) :**

```bash
nano ~/.ssh/authorized_keys
```

**Dans nano :**
1. **Clic droit** dans la fenêtre → La clé se colle automatiquement
   
   OU
   
2. **[Ctrl] + [Shift] + [V]** → Coller

**Vous devriez voir :**
```
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDGxxxx... safiullah@windows11
```

3. **[Ctrl] + [O]** → Sauvegarder
4. **[Enter]** → Confirmer
5. **[Ctrl] + [X]** → Quitter

#### Étape 5 : Vérifier la clé copiée

```bash
cat ~/.ssh/authorized_keys
```

**Résultat attendu :**
```
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDGxxxx... safiullah@windows11
```

✅ La clé publique est bien présente !

#### Étape 6 : Vérifier les permissions

```bash
ls -la ~/.ssh/
```

**Résultat attendu :**
```
drwx------ 2 safiullah safiullah 4096 Feb 12 11:15 .
drwxr-xr-x 3 safiullah safiullah 4096 Feb 12 11:15 ..
-rw------- 1 safiullah safiullah  753 Feb 12 11:15 authorized_keys
```

**Vérifications :**
- `drwx------` : .ssh/ a les permissions 700 ✅
- `-rw-------` : authorized_keys a les permissions 600 ✅
- Propriétaire : safiullah ✅

✅ **Permissions correctes !**

### PHASE 3 : Tester la connexion par clé

#### Étape 1 : Se déconnecter du serveur

```bash
exit
```

**Retour sur Windows 11 :**
```
PS C:\Users\Safiullah>
```

#### Étape 2 : Tester la connexion SSH avec la clé

```powershell
ssh safiullah@192.168.1.100
```

**SCÉNARIOS POSSIBLES :**

**SCÉNARIO A : Avec passphrase**
```
Enter passphrase for key 'C:\Users\Safiullah\.ssh\id_rsa':
→ [Taper votre passphrase]

safiullah@SRVLX01:~$
```

✅ **Connexion réussie avec la clé + passphrase !**
✅ **Pas de mot de passe demandé !**

**SCÉNARIO B : Sans passphrase**
```
safiullah@SRVLX01:~$
```

✅ **Connexion AUTOMATIQUE sans rien taper !**
✅ **Pas de mot de passe, pas de passphrase !**

**SCÉNARIO C : Mot de passe encore demandé (problème)**
```
safiullah@192.168.1.100's password:
```

❌ **La connexion par clé ne fonctionne PAS**
→ SSH retombe sur le mot de passe

**CAUSES POSSIBLES :**
- Clé publique mal copiée dans authorized_keys
- Permissions incorrectes
- Erreur de syntaxe dans authorized_keys

**SOLUTION : Voir dépannage ci-dessous**

#### Étape 3 : Vérifier en mode verbeux (si problème)

```powershell
ssh -v safiullah@192.168.1.100
```

**Chercher dans la sortie :**

```
...
debug1: Offering public key: C:/Users/Safiullah/.ssh/id_rsa RSA SHA256:xxxxx
debug1: Server accepts key: C:/Users/Safiullah/.ssh/id_rsa RSA SHA256:xxxxx
debug1: Authentication succeeded (publickey).
...
```

✅ **"Authentication succeeded (publickey)"** = La clé fonctionne !

### PHASE 4 : Désactiver l'authentification par mot de passe

**⚠️ ATTENTION CRITIQUE :**

```
🚨 AVANT DE DÉSACTIVER LES MOTS DE PASSE :

1. ✅ La connexion par clé DOIT fonctionner parfaitement
2. ✅ Testez plusieurs fois avec la clé
3. ✅ GARDEZ UNE SESSION SSH OUVERTE pendant la config
4. ✅ Ayez un accès physique/console au serveur en backup

SI VOUS DÉSACTIVEZ LES MOTS DE PASSE ET QUE LA CLÉ NE MARCHE PAS :
❌ Vous serez BLOQUÉ hors du serveur !
❌ Vous devrez accéder physiquement au serveur pour corriger !
```

#### Étape 1 : Éditer la configuration SSH

```bash
sudo nano /etc/ssh/sshd_config
```

#### Étape 2 : Modifier les paramètres

**Rechercher et modifier 3 lignes :**

**Ligne 1 : PasswordAuthentication**

```
[Ctrl] + [W] → PasswordAuthentication → [Enter]
```

**Modifier pour avoir :**
```
PasswordAuthentication no
```

**Ligne 2 : ChallengeResponseAuthentication**

```
[Ctrl] + [W] → ChallengeResponseAuthentication → [Enter]
```

**Modifier pour avoir :**
```
ChallengeResponseAuthentication no
```

**Ligne 3 : PubkeyAuthentication (vérifier)**

```
[Ctrl] + [W] → PubkeyAuthentication → [Enter]
```

**S'assurer qu'elle est activée :**
```
PubkeyAuthentication yes
```

**Ligne 4 : UsePAM (optionnel mais recommandé)**

```
[Ctrl] + [W] → UsePAM → [Enter]
```

**Modifier pour :**
```
UsePAM no
```

📝 **UsePAM yes peut permettre l'authentification par mot de passe même si PasswordAuthentication est sur no**

#### Étape 3 : Sauvegarder

```
[Ctrl] + [O] → [Enter] → [Ctrl] + [X]
```

#### Étape 4 : Vérifier les modifications

```bash
grep "^PasswordAuthentication\|^ChallengeResponseAuthentication\|^PubkeyAuthentication\|^UsePAM" /etc/ssh/sshd_config
```

**Résultat attendu :**
```
PasswordAuthentication no
ChallengeResponseAuthentication no
PubkeyAuthentication yes
UsePAM no
```

✅ **Configuration correcte !**

#### Étape 5 : Tester la syntaxe

```bash
sudo sshd -t
```

**Si rien :**
✅ Syntaxe correcte !

#### Étape 6 : Redémarrer SSH

```bash
sudo systemctl restart sshd
```

**Vérifier :**

```bash
sudo systemctl status sshd
```

```
● ssh.service - OpenBSD Secure Shell server
   Active: active (running)
```

✅ SSH fonctionne !

### PHASE 5 : Tests de sécurité

#### Test 1 : Connexion avec clé (doit fonctionner)

**Nouveau PowerShell :**

```powershell
ssh safiullah@192.168.1.100
```

**Résultat attendu :**
```
Enter passphrase... (si passphrase)
OU
Connexion directe (si sans passphrase)

safiullah@SRVLX01:~$
```

✅ **La connexion par clé fonctionne !**

#### Test 2 : Forcer le mot de passe (doit échouer)

```powershell
ssh -o PubkeyAuthentication=no safiullah@192.168.1.100
```

**Résultat attendu :**
```
safiullah@192.168.1.100: Permission denied (publickey).
```

✅ **L'authentification par mot de passe est DÉSACTIVÉE !**

### Dépannage

**PROBLÈME : La clé ne fonctionne pas**

```bash
# Vérifier les permissions
ls -la ~/.ssh/

# Corriger si nécessaire
chmod 700 ~/.ssh
chmod 600 ~/.ssh/authorized_keys
chown -R safiullah:safiullah ~/.ssh

# Vérifier le contenu
cat ~/.ssh/authorized_keys
# La clé doit être sur UNE SEULE ligne, pas de retour à la ligne au milieu

# Vérifier les logs
sudo tail -50 /var/log/auth.log
```

**PROBLÈME : Bloqué hors du serveur**

```
SI VOUS ÊTES BLOQUÉ :

1. Accès physique ou console VM
2. Se connecter localement
3. Éditer /etc/ssh/sshd_config
4. Réactiver temporairement :
   PasswordAuthentication yes
5. Redémarrer SSH
6. Corriger le problème de clé
7. Retester
8. Désactiver à nouveau les mots de passe
```

### Récapitulatif complet

```powershell
# === SUR WINDOWS 11 ===

# 1. Générer la clé
ssh-keygen -t rsa -b 4096 -C "safiullah@windows11"

# 2. Copier dans le presse-papiers
cat $env:USERPROFILE\.ssh\id_rsa.pub | clip
```

```bash
# === SUR LE SERVEUR SRVLX01 ===

# 3. Créer le répertoire et fichier
mkdir -p ~/.ssh
chmod 700 ~/.ssh
touch ~/.ssh/authorized_keys
chmod 600 ~/.ssh/authorized_keys

# 4. Coller la clé
nano ~/.ssh/authorized_keys
# [Clic droit ou Ctrl+Shift+V] → Coller
# [Ctrl+O] → [Enter] → [Ctrl+X]

# 5. Tester la connexion par clé
# (depuis Windows) : ssh safiullah@IP

# 6. Désactiver les mots de passe
sudo nano /etc/ssh/sshd_config
# Modifier :
# PasswordAuthentication no
# ChallengeResponseAuthentication no
# PubkeyAuthentication yes
# UsePAM no

# 7. Redémarrer SSH
sudo sshd -t
sudo systemctl restart sshd

# 8. Tester
# Connexion par clé : DOIT FONCTIONNER
# Connexion par mot de passe : DOIT ÉCHOUER
```

**Configuration SSH finale :**
```
PermitRootLogin no
AllowUsers safiullah
PasswordAuthentication no
ChallengeResponseAuthentication no
PubkeyAuthentication yes
UsePAM no
```

✅ **Sécurité maximale atteinte !**
✅ **Connexion uniquement par clé SSH !**
✅ **Mots de passe désactivés !**

---

# 💾 PARTIE 3 : ANALYSE DU STOCKAGE

---

## ❓ QUESTION 2.3.1

**Quels sont les systèmes de fichiers actuellement montés ?**

---

## ✅ RÉPONSE DÉTAILLÉE Q.2.3.1

### Objectif
Lister tous les systèmes de fichiers montés sur le serveur SRVLX01 et comprendre leur utilisation.

### Commande principale

```bash
df -h
```

**Explication :**
- `df` = Disk Free (espace disque)
- `-h` = Human readable (Go, Mo au lieu d'octets)

### Résultat type (exemple)

```
Filesystem                Size  Used Avail Use% Mounted on
udev                      4.0M     0  4.0M   0% /dev
tmpfs                     380M   59M  322M  16% /run
/dev/mapper/cp5--vg-root  4.0G  1.5G  1.1G  60% /
tmpfs                     5.0M     0  5.0M   0% /run/lock
/dev/md0p1                485M   47M  413M  11% /boot
tmpfs                      1M     0    1M   0% /run/user/0
```

### Analyse ligne par ligne

#### 1. udev (Gestionnaire de périphériques)

```
udev                      4.0M     0  4.0M   0% /dev
```

**Description :**
- Système de fichiers virtuel en RAM
- Gère les périphériques matériels
- Monté sur `/dev`
- Contient les fichiers de périphériques (/dev/sda, /dev/tty, etc.)

**Type :** devtmpfs (système virtuel)

#### 2. tmpfs sur /run (Fichiers temporaires)

```
tmpfs                     380M   59M  322M  16% /run
```

**Description :**
- Système de fichiers temporaire en RAM
- Contient des fichiers d'exécution du système
- PID files, sockets, etc.
- Effacé à chaque redémarrage

**Type :** tmpfs (temporaire en mémoire)

#### 3. Système racine / (Principal)

```
/dev/mapper/cp5--vg-root  4.0G  1.5G  1.1G  60% /
```

**Description :**
- **SYSTÈME PRINCIPAL** contenant tout le système d'exploitation
- Volume logique LVM nommé "root"
- Taille : 4 Go
- Utilisé : 1.5 Go (60%)
- Disponible : 1.1 Go

**Type :** ext4 (Extended File System version 4)

**Contenu :**
```
/home      → Répertoires utilisateurs
/etc       → Configuration système
/var       → Logs et données variables
/usr       → Programmes et bibliothèques
/opt       → Logiciels optionnels
/tmp       → Fichiers temporaires
...etc
```

#### 4. tmpfs sur /run/lock (Verrous)

```
tmpfs                     5.0M     0  5.0M   0% /run/lock
```

**Description :**
- Système de fichiers pour les fichiers de verrouillage
- Utilisé pour la synchronisation entre processus
- Très petit (5 Mo)

**Type :** tmpfs

#### 5. /boot (Partition de démarrage)

```
/dev/md0p1                485M   47M  413M  11% /boot
```

**Description :**
- Partition séparée pour le démarrage
- Contient le noyau Linux (vmlinuz)
- Fichiers de démarrage (initrd)
- Configuration GRUB
- **SUR UN RAID** (md0)

**Type :** ext2 (Extended File System version 2)

**Contenu :**
```bash
ls /boot
```

```
config-5.10.0
grub/
initrd.img-5.10.0
System.map-5.10.0
vmlinuz-5.10.0
```

#### 6. tmpfs utilisateur root

```
tmpfs                      1M     0    1M   0% /run/user/0
```

**Description :**
- Fichiers temporaires de session pour root (UID 0)
- Utilisé pour les données de session
- 1 Mo par utilisateur

**Type :** tmpfs

### Commande alternative (avec types)

```bash
df -hT
```

**Résultat :**

```
Filesystem              Type      Size  Used Avail Use% Mounted on
udev                    devtmpfs  4.0M     0  4.0M   0% /dev
tmpfs                   tmpfs     380M   59M  322M  16% /run
/dev/mapper/cp5--vg-root ext4     4.0G  1.5G  1.1G  60% /
tmpfs                   tmpfs     5.0M     0  5.0M   0% /run/lock
/dev/md0p1              ext2      485M   47M  413M  11% /boot
tmpfs                   tmpfs      1M     0    1M   0% /run/user/0
```

**Types de systèmes de fichiers identifiés :**
- `devtmpfs` : Périphériques virtuels
- `tmpfs` : Temporaires en RAM
- `ext4` : Système racine (moderne, avec journalisation)
- `ext2` : /boot (simple, pas de journalisation)

### Voir tous les montages (détaillé)

```bash
mount | grep "^/"
```

**Affiche tous les systèmes montés avec options**

### Récapitulatif

```
SYSTÈMES DE FICHIERS MONTÉS SUR SRVLX01 :

1. /dev (udev, devtmpfs)
   → Périphériques matériels

2. /run (tmpfs)
   → Fichiers d'exécution temporaires

3. / (ext4, LVM)
   → Système racine principal
   → 4 Go, 60% utilisé

4. /run/lock (tmpfs)
   → Fichiers de verrouillage

5. /boot (ext2, RAID md0)
   → Partition de démarrage
   → 485 Mo, 11% utilisé

6. /run/user/0 (tmpfs)
   → Session utilisateur root
```

**Commandes utilisées :**
```bash
df -h        # Liste simple
df -hT       # Avec types
mount        # Tous les montages
```

---

## ❓ QUESTION 2.3.2

**Quel type de système de stockage ils utilisent ?**

---

## ✅ RÉPONSE DÉTAILLÉE Q.2.3.2

### Objectif
Identifier les technologies de stockage utilisées : RAID, LVM, partitions simples.

### Commande pour voir la structure

```bash
lsblk
```

**Résultat type :**

```
NAME                 MAJ:MIN RM  SIZE RO TYPE MOUNTPOINT
sda                    8:0    0   20G  0 disk
├─sda1                 8:1    0  500M  0 part
│ └─md0                9:0    0  498M  0 raid1
│   └─md0p1            9:1    0  485M  0 md   /boot
├─sda2                 8:2    0 18.5G  0 part
│ └─cp5--vg-root     253:0    0    4G  0 lvm  /
└─sda3                 8:3    0    1G  0 part
  └─cp5--vg-swap_1   253:1    0  980M  0 lvm  [SWAP]
sdb                    8:16   0   20G  0 disk
```

### Analyse de la structure complète

#### Disque physique sda (20 Go)

**Partitions :**

**1. sda1 (500 Mo) → Utilisée pour RAID**

```
sda1 → md0 (RAID1) → md0p1 → /boot
```

**Détails :**
- Type : RAID 1 (miroir)
- Volume : md0
- Montage : /boot
- Taille : ~500 Mo
- FS : ext2

**2. sda2 (18.5 Go) → Utilisée pour LVM**

```
sda2 → cp5-vg (Volume Group) → root (4 Go) → /
```

**Détails :**
- Type : LVM (Logical Volume Manager)
- VG : cp5-vg
- LV : root
- Montage : /
- Taille : 4 Go
- FS : ext4

**3. sda3 (1 Go) → Utilisée pour LVM (swap)**

```
sda3 → cp5-vg → swap_1 (980 Mo) → [SWAP]
```

**Détails :**
- Type : LVM
- VG : cp5-vg
- LV : swap_1
- Usage : Mémoire d'échange (swap)
- Taille : 980 Mo

#### Disque physique sdb (20 Go)

```
sdb                    8:16   0   20G  0 disk
```

**État : Non utilisé actuellement**
- Pas de partitions
- Pas formaté
- Disponible pour extension

### Type 1 : RAID 1 (Miroir)

#### Vérifier l'état du RAID

```bash
cat /proc/mdstat
```

**Résultat :**

```
Personalities : [raid1]
md0 : active raid1 sda1[0]
      498688 blocks super 1.2 [2/1] [U_]
      bitmap: 0/1 pages [0KB], 65536KB chunk

unused devices: <none>
```

**Analyse :**

```
md0 : active raid1 sda1[0]
│     │      │     │
│     │      │     └─ Disque actif : sda1 (disque 0)
│     │      └─ Type : RAID 1 (miroir)
│     └─ État : actif
└─ Nom du volume RAID

498688 blocks
└─ Taille : ~500 Mo

[2/1] [U_]
 │ │   │ │
 │ │   │ └─ _ = Disque manquant
 │ │   └─ U = Disque Up (actif)
 │ └─ 1 disque actif
 └─ 2 disques prévus

⚠️ LE RAID EST DÉGRADÉ ! Il manque un disque !
```

**Qu'est-ce que RAID 1 ?**

```
RAID 1 = MIRRORING (Miroir)

┌─────────────┐     ┌─────────────┐
│   Disque 1  │ ←→  │   Disque 2  │
│   (sda1)    │     │   (manque)  │
│             │     │             │
│  DONNÉES    │     │  DONNÉES    │
│  IDENTIQUES │     │  IDENTIQUES │
└─────────────┘     └─────────────┘

AVANTAGES :
✅ Tolérance aux pannes : si un disque meurt, les données sont sur l'autre
✅ Lecture rapide : peut lire depuis les deux disques
✅ Simplicité

INCONVÉNIENTS :
❌ Capacité = taille d'un seul disque (pas de gain d'espace)
❌ Coût : besoin de 2x la capacité
```

### Type 2 : LVM (Logical Volume Manager)

#### Physical Volumes (PV)

```bash
sudo pvdisplay
```

**Résultat :**

```
  --- Physical volume ---
  PV Name               /dev/sda2
  VG Name               cp5-vg
  PV Size               18.50 GiB / not usable 3.00 MiB
  Allocatable           yes
  PE Size               4.00 MiB
  Total PE              4735
  Free PE               3735
  Allocated PE          1000
```

**Analyse :**
- Physical Volume : /dev/sda2
- Appartient au Volume Group : cp5-vg
- Taille : 18.50 Go
- PE libres : 3735 (espace disponible)

#### Volume Groups (VG)

```bash
sudo vgdisplay
```

**Résultat :**

```
  --- Volume group ---
  VG Name               cp5-vg
  System ID
  Format                lvm2
  Metadata Areas        1
  Metadata Sequence No  4
  VG Access             read/write
  VG Status             resizable
  MAX LV                0
  Cur LV                2
  Open LV               2
  Max PV                0
  Cur PV                1
  Act PV                1
  VG Size               18.50 GiB
  PE Size               4.00 MiB
  Total PE              4735
  Alloc PE / Size       1000 / 3.91 GiB
  Free  PE / Size       3735 / 14.59 GiB
```

**Analyse :**
- Nom : cp5-vg
- Taille totale : 18.50 Go
- Utilisé : 3.91 Go
- **Libre : 14.59 Go** ✅
- Volumes logiques : 2 (root + swap)

#### Logical Volumes (LV)

```bash
sudo lvdisplay
```

**Résultat :**

```
  --- Logical volume ---
  LV Path                /dev/cp5-vg/root
  LV Name                root
  VG Name                cp5-vg
  LV UUID                xxxx-xxxx-xxxx
  LV Write Access        read/write
  LV Creation host, time SRVLX01, 2024-01-15 10:00:00
  LV Status              available
  # open                 1
  LV Size                4.00 GiB
  Current LE             1000
  Segments               1
  Allocation             inherit
  Read ahead sectors     auto
  - currently set to     256
  Block device           253:0

  --- Logical volume ---
  LV Path                /dev/cp5-vg/swap_1
  LV Name                swap_1
  VG Name                cp5-vg
  ...
  LV Size                980.00 MiB
```

**Deux volumes logiques :**
1. **root** : 4 Go → Système racine (/)
2. **swap_1** : 980 Mo → Mémoire d'échange

**Qu'est-ce que LVM ?**

```
LVM = Logical Volume Manager

COUCHES :
┌─────────────────────────────────────────────┐
│  LOGICAL VOLUMES (LV)                       │
│  - root (4 Go) → /                          │
│  - swap_1 (980 Mo) → [SWAP]                 │
├─────────────────────────────────────────────┤
│  VOLUME GROUP (VG) : cp5-vg                 │
│  Taille : 18.50 Go                          │
├─────────────────────────────────────────────┤
│  PHYSICAL VOLUMES (PV)                      │
│  - /dev/sda2 (18.5 Go)                      │
└─────────────────────────────────────────────┘

AVANTAGES :
✅ Flexibilité : redimensionner facilement
✅ Snapshots : sauvegardes instantanées
✅ Plusieurs disques = un seul espace
✅ Ajouter des disques sans tout reconfigurer

UTILISATION TYPIQUE :
- Serveurs
- Environnements qui évoluent
- Besoin de snapshots
```

### Schéma complet de la structure

```
┌─────────────────────────────────────────────────────────┐
│                  DISQUES PHYSIQUES                       │
├─────────────────────────────────────────────────────────┤
│                                                          │
│  ┌─────────────────┐        ┌─────────────────┐        │
│  │  /dev/sda (20G) │        │  /dev/sdb (20G) │        │
│  └────────┬────────┘        └─────────────────┘        │
│           │                        (non utilisé)        │
│  ┌────────┼────────────────────────┐                    │
│  │        │                        │                    │
│  │  ┌─────▼────┐  ┌──────▼──────┐ ┌──▼───┐            │
│  │  │  sda1    │  │    sda2     │ │ sda3 │            │
│  │  │  500M    │  │   18.5G     │ │  1G  │            │
│  │  └─────┬────┘  └──────┬──────┘ └──┬───┘            │
│  └────────┼───────────────┼───────────┼────────────────┘
│           │               │           │                  
│     ┌─────▼──────┐        │           │                  
│     │  RAID 1    │        │           │                  
│     │   (md0)    │        │           │                  
│     └─────┬──────┘        │           │                  
│           │               │           │                  
│     ┌─────▼──────┐  ┌─────▼───────────▼────┐           
│     │  md0p1     │  │     LVM (cp5-vg)     │           
│     │  /boot     │  │      18.5 GiB        │           
│     │  (ext2)    │  └──────┬────────┬──────┘           
│     └────────────┘  ┌──────▼────┐ ┌▼──────┐            
│                     │   root    │ │ swap_1│            
│                     │    4 GB   │ │ 980MB │            
│                     │    (/)    │ │[SWAP] │            
│                     │   ext4    │ │       │            
│                     └───────────┘ └───────┘            
└──────────────────────────────────────────────────────────┘
```

### Récapitulatif

```
TYPES DE STOCKAGE UTILISÉS SUR SRVLX01 :

1. 📀 RAID 1 (Miroir)
   - Volume : md0
   - Périphériques : sda1 (+ un disque manquant)
   - Usage : /boot
   - Taille : ~500 Mo
   - FS : ext2
   - État : DÉGRADÉ (1/2 disques) ⚠️

2. 🔷 LVM (Logical Volume Manager)
   - Physical Volume : /dev/sda2
   - Volume Group : cp5-vg (18.5 Go)
   - Logical Volumes :
     • root (4 Go) → / (ext4)
     • swap_1 (980 Mo) → [SWAP]
   - Espace libre : 14.59 Go ✅

3. 💾 Systèmes de fichiers
   - ext2 : /boot (RAID)
   - ext4 : / (LVM)
   - swap : Mémoire virtuelle (LVM)
   - tmpfs : Systèmes temporaires en RAM

COMMANDES UTILISÉES :
- lsblk                → Structure des disques
- cat /proc/mdstat     → État du RAID
- sudo pvdisplay       → Physical Volumes LVM
- sudo vgdisplay       → Volume Groups LVM
- sudo lvdisplay       → Logical Volumes LVM
```

---

[Continue avec les questions suivantes... Le fichier est trop long, je vais devoir le créer en plusieurs parties]

Voulez-vous que je continue avec les questions restantes (2.3.3 à 2.6.1) ?

