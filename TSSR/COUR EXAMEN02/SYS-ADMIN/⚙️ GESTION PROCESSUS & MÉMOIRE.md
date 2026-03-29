

## 🎯 L'essentiel (6 points)

1. **Processus** = programme en cours d'exécution, identifié par un **PID**
2. **PID 1 = systemd (ou init)** = premier processus, parent de tous les autres
3. **Ordonnanceur Linux = CFS** (Completely Fair Scheduler)
4. **Mémoire virtuelle** = RAM + swap + pagination (via MMU)
5. **Ctrl+C = SIGINT** (interrompt) ≠ **Ctrl+Z = SIGTSTP** (met en pause)
6. **Service/démon** = processus lancé au boot, toujours actif

---

## 🔑 Commandes indispensables

| Commande | Rôle |
|----------|------|
| `ps` | Lister les processus |
| `top` | Processus par conso CPU (temps réel) |
| `fg` | Remettre en premier plan |
| `bg` | Reprendre en arrière plan |
| `kill PID` | Envoyer signal à un processus |
| `free` | Voir utilisation mémoire + swap |
| `systemctl status` | État d'un service |

---

## ⚠️ Pièges classiques

> **Ctrl+Z ≠ Ctrl+C**
> - Ctrl+C (SIGINT) = **interrompt** le processus
> - Ctrl+Z (SIGTSTP) = **met en pause** → reprendre avec `fg`
>
> **nohup ≠ &**
> - `&` = lance en arrière plan (meurt si terminal fermé)
> - `nohup` = détache de la session (continue même si terminal fermé)
>
> **swap ≠ RAM**
> - swap = mémoire sur disque, beaucoup plus lent
> - Trop de swap utilisé = besoin de plus de RAM
>
> **Tuer ≠ Pause**
> - `kill` = envoie un signal (pas forcément SIGKILL)
> - Ctrl+Z = pause, pas arrêt

---

## 📝 QUIZ Checkpoint (8 questions)

### Question 1
**C'est quoi un processus ?**
> [!success]- 🔓 Réponse
> Un programme en cours d'exécution

---

### Question 2
**Quel est le PID du premier processus (systemd) ?**
> [!success]- 🔓 Réponse
> PID = 1

---

### Question 3
**Quel est l'ordonnanceur principal de Linux ?**
> [!success]- 🔓 Réponse
> CFS (Completely Fair Scheduler)

---

### Question 4
**Différence entre Ctrl+C et Ctrl+Z ?**
> [!success]- 🔓 Réponse
> Ctrl+C = SIGINT (interrompt) | Ctrl+Z = SIGTSTP (met en pause)

---

### Question 5
**Comment reprendre un processus mis en pause avec Ctrl+Z ?**
> [!success]- 🔓 Réponse
> `fg` (premier plan) ou `bg` (arrière plan)

---

### Question 6
**C'est quoi le swap ?**
> [!success]- 🔓 Réponse
> Mémoire sur disque utilisée quand la RAM est pleine

---

### Question 7
**Commande pour voir l'utilisation mémoire et swap ?**
> [!success]- 🔓 Réponse
> `free`

---

### Question 8
**DIAGNOSTIC : Un processus ne répond plus après Ctrl+Z. Que s'est-il passé ?**
> [!success]- 🔓 Réponse
> Le processus est en **pause** (pas arrêté). Utiliser `fg` pour le reprendre ou `kill %1` pour le terminer.

---

## 🎤 À retenir pour l'oral

> **Processus** = programme en exécution, identifié par un **PID**

> **Ordonnanceur** = décide quel processus utilise le CPU (CFS = Completely Fair Scheduler sur Linux)

> **Mémoire virtuelle** = MMU traduit adresses virtuelles → physiques (pagination + swap)

> **Swap** = pages mémoire déportées sur disque quand RAM pleine

> **Défaut de page** = accès à une page sur disque → rechargement en RAM (lent !)

> **Service/Démon** = processus lancé au boot, toujours actif (géré par systemd)

> **Commandes** : `ps` (lister) | `top`/`htop` (conso CPU) | `fg`/`bg` (premier/arrière plan) | `nohup` (détacher du terminal)

---
