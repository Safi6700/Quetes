
---

## 🎯 L'essentiel (définitions courtes à apprendre)

1. **Conteneur** = environnement **isolé** qui exécute une application avec ses dépendances (plus léger qu'une VM)

2. **Docker** = plateforme pour **créer et gérer** des conteneurs (conteneurisation **applicative**)

3. **LXC** (Linux Containers) = conteneurisation **système** (ressemble à une VM mais sans hyperviseur)

4. **Image** = modèle **figé** pour créer un conteneur (comme un template)

5. **Dockerfile** = fichier texte avec les **instructions** pour construire une image

6. **Volume** = stockage **persistant** pour garder les données même si le conteneur est supprimé

---

## 📋 Solutions de conteneurisation (Question CP4 Q5.2)

| Solution | Type | Particularité |
|----------|------|---------------|
| **Docker** | Applicative | 1 processus principal, très léger |
| **LXC** | Système | Machine Linux complète sans hyperviseur |
| **LXD** | Système | Couche de gestion au-dessus de LXC |
| **Podman** | Applicative | Alternative à Docker (sans daemon) |

---

## 📋 VM vs Conteneur

| | VM | Conteneur |
|--|----|----|
| **Contient** | OS complet | Juste l'appli + dépendances |
| **Poids** | Lourd (Go) | Léger (Mo) |
| **Démarrage** | Minutes | **Secondes** |
| **Isolation** | Totale | Partage le noyau hôte |

---

## 🔧 Commandes Docker à retenir

| Commande | Usage |
|----------|-------|
| `docker pull image` | Télécharger une image |
| `docker run image` | Lancer un conteneur |
| `docker ps` | Voir les conteneurs actifs |
| `docker ps -a` | Voir tous les conteneurs |
| `docker stop id` | Arrêter un conteneur |
| `docker rm id` | Supprimer un conteneur |
| `docker images` | Voir les images locales |
| `docker build -t nom .` | Construire une image |

---

## 📄 Dockerfile (Question CP4 Q5.3)

```dockerfile
FROM ubuntu:latest        # Image de base
RUN apt-get update        # Exécuter commande
WORKDIR /data             # Dossier de travail
COPY fichier /data/       # Copier fichiers
CMD ["bash", "-i"]        # Commande au démarrage
```

**Comment l'utiliser ?** → `docker build -t mon_image .`

---

## ☁️ IaaS / PaaS / SaaS (Question CP4 Q5.5)

| Terme | Signifie | Tu gères | Exemple |
|-------|----------|----------|---------|
| **IaaS** | Infrastructure as a Service | OS, applis, données | AWS EC2, Azure VM |
| **PaaS** | Platform as a Service | Applis, données | Heroku, Azure App Service |
| **SaaS** | Software as a Service | Rien (juste utiliser) | Gmail, Office 365 |

---

## ⚠️ Piège classique

> **Conteneur ≠ VM**
> - Conteneur = **partage le noyau** de l'hôte (léger, rapide)
> - VM = **OS complet** virtualisé (lourd, lent)

---

## ✅ Checkpoint examen

**Questions Checkpoint 4 :**
- **Q5.2** : C'est quoi un conteneur ? Solutions de conteneurisation
- **Q5.3** : Lire un Dockerfile et expliquer comment l'utiliser
- **Q5.5** : Définir IaaS, PaaS, SaaS

---

## 📝 QUIZ Checkpoint

### Question 1
**C'est quoi un conteneur ?**
> [!success]- 🔓 Réponse
> Environnement **isolé** qui exécute une application avec ses dépendances. Plus léger qu'une VM.

---

### Question 2
**Quelles sont les solutions de conteneurisation ? (Question CP4)**
> [!success]- 🔓 Réponse
> - **Docker** = conteneurisation applicative (1 processus)
> - **LXC/LXD** = conteneurisation système (machine Linux complète)
> - Podman = alternative à Docker

---

### Question 3
**Différence VM et conteneur ?**
> [!success]- 🔓 Réponse
> - **VM** = OS complet, lourd, minutes au démarrage
> - **Conteneur** = partage le noyau, léger, **secondes** au démarrage

---

### Question 4
**C'est quoi un Dockerfile ? (Question CP4)**
> [!success]- 🔓 Réponse
> Fichier texte avec les **instructions** pour construire une image Docker.
> On l'utilise avec : `docker build -t nom_image .`

---

### Question 5
**C'est quoi IaaS, PaaS, SaaS ? (Question CP4)**
> [!success]- 🔓 Réponse
> - **IaaS** = Infrastructure (tu gères OS + applis)
> - **PaaS** = Plateforme (tu gères applis)
> - **SaaS** = Software (tu utilises juste)

---

### Question 6
**Quelle commande pour voir les conteneurs actifs ?**
> [!success]- 🔓 Réponse
> `docker ps` (ou `docker ps -a` pour tous)

---

### Question 7
**C'est quoi un volume Docker ?**
> [!success]- 🔓 Réponse
> Stockage **persistant** pour garder les données même si le conteneur est supprimé.

---

## 🎤 À retenir pour l'oral

> **Conteneur** = environnement isolé, plus léger qu'une VM (partage le noyau)

> **Solutions** : Docker (applicatif) / LXC-LXD (système)

> **Dockerfile** = instructions pour construire une image → `docker build`

> **IaaS** = Infrastructure / **PaaS** = Plateforme / **SaaS** = Software

> **docker ps** = conteneurs actifs / **docker images** = images locales

---