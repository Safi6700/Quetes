## 🎯 L'ESSENTIEL (5 points)

1. **Git** = logiciel de gestion de versions **décentralisé**, créé par **Linus Torvalds en 2005**
2. **GitHub** = service web basé sur Git, créé en 2008 (≠ Git !)
3. **3 arbres Git** : Répertoire de travail → Index (stage) → HEAD
4. **Branche main** = branche principale, doit TOUJOURS être fonctionnelle
5. **Décentralisé** = chaque poste a une copie complète du dépôt (pas besoin de serveur pour travailler)

---

## 🔄 ÉTATS DES FICHIERS

```
┌─────────────┐    ┌─────────────┐    ┌─────────────┐    ┌─────────────┐
│  Untracked  │───►│ Unmodified  │───►│  Modified   │───►│   Staged    │
│ (non suivi) │add │ (commité)   │edit│ (modifié)   │add │ (indexé)    │
└─────────────┘    └─────────────┘    └─────────────┘    └─────────────┘
                          ▲                                     │
                          └─────────────── commit ──────────────┘
```

**2 états principaux** : Tracked (suivi) / Untracked (non suivi)
**3 sous-états Tracked** : Unmodified, Modified, Staged

---

## 🔧 COMMANDES INDISPENSABLES

| Commande               | Rôle                              |
| ---------------------- | --------------------------------- |
| `git init`             | Initialiser un dépôt Git          |
| `git clone URL`        | Cloner un dépôt distant           |
| `git status`           | Voir l'état des fichiers          |
| `git add fichier`      | Ajouter à l'index (stage)         |
| `git commit -m "msg"`  | Valider les modifications         |
| `git log`              | Voir l'historique des commits     |
| `git branch`           | Lister les branches               |
| `git checkout branche` | Changer de branche                |
| `git merge branche`    | Fusionner une branche             |
| `git push`             | Envoyer vers le dépôt distant     |
| `git pull`             | Récupérer depuis le dépôt distant |
| `git remote`           | Gérer les dépôts distants         |

---

## ⚖️ CENTRALISÉ vs DÉCENTRALISÉ

| Centralisé (SVN, CVS) | Décentralisé (Git, Mercurial) |
|-----------------------|-------------------------------|
| 1 serveur central obligatoire | Chaque poste = copie complète |
| Connexion serveur requise | Travail hors-ligne possible |
| Lent (réseau) | Rapide (local) |

---

## 🌐 GIT ≠ GITHUB

| Git | GitHub |
|-----|--------|
| Logiciel en ligne de commande | Service web |
| Gestion de versions | Hébergement + collaboration |
| Local | En ligne |
| Créé en 2005 | Créé en 2008 |

**Alternatives à GitHub** : GitLab, Bitbucket

---

## 📋 VOCABULAIRE CLÉ

| Terme | Définition courte |
|-------|-------------------|
| **HEAD** | Pointeur vers le dernier commit de la branche actuelle |
| **Index/Stage** | Zone de préparation avant commit |
| **Commit** | Snapshot du projet avec ID + message |
| **Branch** | Ligne de développement indépendante |
| **Merge** | Fusion de deux branches |
| **Fork** | Copie d'un projet sur son compte GitHub |
| **Pull Request** | Demande de contribution vers le dépôt original |
| **Clone** | Copie complète d'un dépôt distant |

---

## ⚠️ PIÈGE CLASSIQUE

> **Git ≠ GitHub**
> - **Git** = logiciel de versioning (local)
> - **GitHub** = plateforme web d'hébergement (distant)
> 
> ⚠️ Ne jamais confondre les deux à l'oral !

---

## 📝 QUIZ Checkpoint

### Question 1
**C'est quoi Git ?**
> [!success]- 🔓 Réponse
> Logiciel de gestion de versions décentralisé, créé par Linus Torvalds en 2005

---

### Question 2
**C'est quoi GitHub ?**
> [!success]- 🔓 Réponse
> Service web d'hébergement de dépôts Git, créé en 2008

---

### Question 3
**Quels sont les 3 arbres de Git ?**
> [!success]- 🔓 Réponse
> 1. Répertoire de travail 2. Index (stage) 3. HEAD

---

### Question 4
**Quelle commande pour voir l'état des fichiers ?**
> [!success]- 🔓 Réponse
> `git status`

---

### Question 5
**Différence entre centralisé et décentralisé ?**
> [!success]- 🔓 Réponse
> Centralisé = serveur obligatoire (SVN) | Décentralisé = copie complète sur chaque poste (Git)

---

### Question 6
**C'est quoi un commit ?**
> [!success]- 🔓 Réponse
> Snapshot (sauvegarde) du projet avec un ID unique et un message

---

### Question 7
**C'est quoi un fork sur GitHub ?**
> [!success]- 🔓 Réponse
> Copie d'un projet open-source sur son propre compte GitHub

---

### Question 8
**Quelle branche doit toujours être fonctionnelle ?**
> [!success]- 🔓 Réponse
> La branche **main** (anciennement master)

---

## 🎤 À retenir pour l'oral

> **Git** = logiciel de gestion de versions **décentralisé**, créé par **Linus Torvalds en 2005**

> **GitHub** = service web basé sur Git, créé en 2008 (Git ≠ GitHub !)

> **Décentralisé** = chaque poste a une copie complète, pas besoin de serveur pour travailler

> **3 arbres** : Répertoire de travail → Index (stage) → HEAD

> **Workflow de base** : modifier → `git add` → `git commit` → `git push`

> **Branche main** = branche principale, doit TOUJOURS être fonctionnelle

> **Fork** = copier un projet | **Pull Request** = demander à contribuer