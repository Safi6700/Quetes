
---

## 🎯 L'essentiel (5 points)

1. **VM** = ordinateur virtuel avec son propre OS (guest) sur une machine physique (host)
2. **Hyperviseur Type 1** (bare metal) = directement sur le matériel → meilleures performances
3. **Hyperviseur Type 2** (hébergé) = installé sur un OS → plus simple mais moins performant
4. **Overhead** = ressources consommées par l'hyperviseur lui-même
5. **Proxmox** = solution open-source Type 1 utilisée en formation (KVM + LXC)

---

## 📝 Vocabulaire clé

| Terme | Définition |
|-------|------------|
| **Host OS** | Système d'exploitation de la machine physique |
| **Guest OS** | Système installé dans la VM |
| **VM** | Machine virtuelle |
| **Hyperviseur** | Couche logicielle qui gère les VM |
| **Overhead** | Coût en ressources pour gérer la virtualisation |

---

## 🔄 Hyperviseur Type 1 vs Type 2

```json
TYPE 1 (Bare Metal)                    TYPE 2 (Hébergé)
┌─────────────────────┐                ┌─────────────────────┐
│    VM1     VM2      │                │    VM1     VM2      │
├─────────────────────┤                ├─────────────────────┤
│    HYPERVISEUR      │                │    HYPERVISEUR      │
├─────────────────────┤                ├─────────────────────┤
│    MATÉRIEL         │                │    OS HÔTE          │
└─────────────────────┘                ├─────────────────────┤
                                       │    MATÉRIEL         │
                                       └─────────────────────┘
```

| | Type 1 | Type 2 |
|--|--------|--------|
| **Autre nom** | Bare metal | Architecture hébergée |
| **Installation** | Direct sur matériel | Sur un OS existant |
| **Performance** | Excellente | Moins bonne |
| **Usage** | Datacenter, production | Développement, test |
| **Exemples** | VMware ESXi, Hyper-V, Proxmox, KVM | VirtualBox, VMware Workstation |

---

## 📝 Logiciels de virtualisation

| Type | Logiciels | Licence |
|------|-----------|---------|
| **Type 1** | VMware ESXi | Payant |
| | Microsoft Hyper-V | Payant |
| | Proxmox VE | Gratuit |
| | KVM | Gratuit |
| | Citrix Xen Server | Gratuit |
| **Type 2** | VirtualBox | Gratuit |
| | VMware Workstation | Payant |
| | Parallels Desktop | Payant |

---

## 📝 Proxmox VE (utilisé en formation)

| Caractéristique | Description |
|-----------------|-------------|
| **Type** | Hyperviseur Type 1 (basé sur KVM) |
| **Licence** | Open-source (gratuit) |
| **Interface** | Web |
| **Fonctionnalités** | VM (KVM), Conteneurs (LXC), Clustering, Migration à chaud |

---

## 📝 Avantages / Inconvénients

| Avantages | Inconvénients |
|-----------|---------------|
| Consolidation serveurs | Overhead (ressources pour l'hyperviseur) |
| Isolation entre VM | Besoin de machines puissantes |
| Snapshots / Sauvegardes faciles | Complexité de gestion |
| Migration à chaud | Point de défaillance unique (host) |
| Reprise sur incident rapide | Coût des licences (certains) |

---

## ⚠️ Piège classique

> **Type 1 ≠ Type 2** : Type 1 = directement sur matériel (datacenter) / Type 2 = sur un OS (poste de travail)

> **VirtualBox = Type 2** (pas Type 1 !)

> **Proxmox = Type 1** basé sur KVM (Linux)

---

## 📝 QUIZ Checkpoint

### Question 1
**C'est quoi un hyperviseur ?**

> [!success]- 🔓 Réponse
> Couche logicielle qui permet à plusieurs VM de fonctionner simultanément sur une même machine physique

---

### Question 2
**Différence entre hyperviseur Type 1 et Type 2 ?**

> [!success]- 🔓 Réponse
> - **Type 1** (bare metal) : s'installe directement sur le matériel → meilleures performances
> - **Type 2** (hébergé) : s'installe sur un OS existant → plus simple mais moins performant

---

### Question 3
**VirtualBox est de quel type ?**

> [!success]- 🔓 Réponse
> **Type 2** (hébergé) — il s'installe sur Windows/Linux/Mac

---

### Question 4
**Donne 3 exemples d'hyperviseurs Type 1**

> [!success]- 🔓 Réponse
> - VMware ESXi
> - Microsoft Hyper-V
> - Proxmox VE
> - KVM
> - Citrix Xen

---

### Question 5
**C'est quoi l'overhead en virtualisation ?**

> [!success]- 🔓 Réponse
> Les ressources (CPU, RAM) consommées par l'hyperviseur lui-même pour gérer la virtualisation  
> = coût supplémentaire en plus des VM

---

### Question 6
**C'est quoi Proxmox ?**

> [!success]- 🔓 Réponse
> Solution de virtualisation **open-source Type 1** basée sur KVM  
> Gère VM et conteneurs (LXC), interface web, clustering, migration à chaud

---

### Question 7
**Différence entre Host OS et Guest OS ?**

> [!success]- 🔓 Réponse
> - **Host OS** : système d'exploitation de la machine physique
> - **Guest OS** : système installé à l'intérieur d'une VM

---

### Question 8
**Quel hyperviseur est utilisé par AWS, Azure, GCP ?**

> [!success]- 🔓 Réponse
> Des **hyperviseurs Type 1** pour les performances  
> (AWS utilise Xen/KVM, Azure utilise Hyper-V, GCP utilise KVM)

---

## 🎤 À retenir pour l'oral

> **VM** = ordinateur virtuel avec son propre OS (guest) sur une machine physique (host)

> **Hyperviseur Type 1** (bare metal) = directement sur le matériel → meilleures performances (ESXi, Hyper-V, Proxmox, KVM)

> **Hyperviseur Type 2** (hébergé) = installé sur un OS existant → plus simple mais moins performant (VirtualBox, VMware Workstation)

> **Overhead** = ressources consommées par l'hyperviseur lui-même

> **Proxmox** = solution open-source Type 1 basée sur KVM, gère VM + conteneurs (LXC)

> **VirtualBox = Type 2** (piège classique !)
