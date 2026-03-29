# Sous-réseautage IP — Méthode complète en 4 étapes

> **TSSR — Révision Examen**
> Couvre tous les CIDR de /1 à /32

---

## 1. Quel octet je touche ?

Avant tout calcul, il faut savoir **sur quel octet on travaille**. C'est le CIDR qui décide :

| CIDR      | Octet concerné | Position de référence |
| --------- | -------------- | --------------------- |
| /1 à /7   | **1er** octet  | **8**                 |
| /8 à /15  | **2ème** octet | **16**                |
| /16 à /23 | **3ème** octet | **24**                |
| /24 à /32 | **4ème** octet | **32**                |

La **position de référence**, c'est le nombre qu'on utilise à l'étape 1 pour calculer l'exposant. C'est toujours la borne haute de la plage (8, 16, 24 ou 32). Retiens ce tableau par cœur — c'est la base de tout.

---

## 2. La méthode en 4 étapes

### Étape 1 — Trouver l'exposant

```
Exposant = Position de référence - CIDR
```

C'est ce nombre qui détermine la taille des sous-réseaux.

### Étape 2 — Calculer le pas

```
Pas = 2 ^ exposant
```

Le **pas**, c'est l'écart entre chaque sous-réseau. Les réseaux se suivent en bonds réguliers : 0, pas, 2×pas, 3×pas…

### Étape 3 — Trouver l'adresse réseau

On prend **la valeur de l'octet concerné** et on fait :

```
Octet ÷ Pas = résultat → on garde la partie entière → on multiplie par le pas
```

Ça te fait "retomber" sur le début du bon sous-réseau.

### Étape 4 — Trouver le broadcast

```
Broadcast (sur l'octet concerné) = adresse réseau + pas - 1
```

**Règle importante pour les octets suivants :**
- Tous les octets **après** l'octet concerné sont à **0** pour le réseau
- Tous les octets **après** l'octet concerné sont à **255** pour le broadcast

---

## 3. Exemple détaillé pour chaque plage

### 🔹 4ème octet — `192.168.1.85 /26`

/26 → entre /24 et /32 → **4ème octet** (85), position de référence = **32**

```
Étape 1 : 32 - 26 = 6

Étape 2 : 2⁶ = 64

Étape 3 : 85 ÷ 64 = 1,32 → 1 × 64 = 64   → Réseau : 192.168.1.64

Étape 4 : 64 + 64 - 1 = 127                → Broadcast : 192.168.1.127
```

Pas d'octets après le 4ème, donc rien à ajouter.

---

### 🔹 3ème octet — `172.16.35.100 /20`

/20 → entre /16 et /23 → **3ème octet** (35), position de référence = **24**

```
Étape 1 : 24 - 20 = 4
Étape 2 : 2⁴ = 16
Étape 3 : 35 ÷ 16 = 2,18 → 2 × 16 = 32   → Réseau : 172.16.32.0
Étape 4 : 32 + 16 - 1 = 47                 → Broadcast : 172.16.47.255
```

Le 4ème octet est **après** l'octet concerné → **.0** pour le réseau, **.255** pour le broadcast.

---

### 🔹 2ème octet — `10.172.50.1 /12`

/12 → entre /8 et /15 → **2ème octet** (172), position de référence = **16**

```
Étape 1 : 16 - 12 = 4
Étape 2 : 2⁴ = 16
Étape 3 : 172 ÷ 16 = 10,75 → 10 × 16 = 160   → Réseau : 10.160.0.0
Étape 4 : 160 + 16 - 1 = 175                   → Broadcast : 10.175.255.255
```

Le 3ème et 4ème octets sont **après** → **.0.0** pour le réseau, **.255.255** pour le broadcast.

---

### 🔹 1er octet — `200.100.50.25 /5`

/5 → entre /1 et /7 → **1er octet** (200), position de référence = **8**

```
Étape 1 : 8 - 5 = 3
Étape 2 : 2³ = 8
Étape 3 : 200 ÷ 8 = 25 → 25 × 8 = 200    → Réseau : 200.0.0.0
Étape 4 : 200 + 8 - 1 = 207                → Broadcast : 207.255.255.255
```

Le 2ème, 3ème et 4ème octets sont **après** → **.0.0.0** pour le réseau, **.255.255.255** pour le broadcast.

---

## 4. Résumé visuel

```
IP : A.B.C.D /CIDR

Si /1-/7   → on calcule sur A   → réseau = X.0.0.0       broadcast = Y.255.255.255
Si /8-/15  → on calcule sur B   → réseau = A.X.0.0       broadcast = A.Y.255.255
Si /16-/23 → on calcule sur C   → réseau = A.B.X.0       broadcast = A.B.Y.255
Si /24-/32 → on calcule sur D   → réseau = A.B.C.X       broadcast = A.B.C.Y

X = partie entière de (octet ÷ pas) × pas
Y = X + pas - 1
```

---

## 5. Puissances de 2 à connaître

| Exposant | 2^n |
|----------|-----|
| 1 | 2 |
| 2 | 4 |
| 3 | 8 |
| 4 | 16 |
| 5 | 32 |
| 6 | 64 |
| 7 | 128 |
| 8 | 256 |

---

## 6. Exercices

---

### EX 01 — `192.168.5.200 /28` *(4ème octet)*

<details>
<summary>📖 Correction</summary>

```
Étape 1 : 32 - 28 = 4
Étape 2 : 2⁴ = 16
Étape 3 : 200 ÷ 16 = 12,5 → 12 × 16 = 192
Étape 4 : 192 + 16 - 1 = 207
```

| | |
|---|---|
| Réseau | **192.168.5.192** |
| Broadcast | **192.168.5.207** |
| 1ère IP | 192.168.5.193 |
| Dernière IP | 192.168.5.206 |
| Hôtes | 14 |

</details>

---

### EX 02 — `10.0.0.77 /27` *(4ème octet)*

<details>
<summary>📖 Correction</summary>

```
Étape 1 : 32 - 27 = 5
Étape 2 : 2⁵ = 32
Étape 3 : 77 ÷ 32 = 2,40 → 2 × 32 = 64
Étape 4 : 64 + 32 - 1 = 95
```

| | |
|---|---|
| Réseau | **10.0.0.64** |
| Broadcast | **10.0.0.95** |
| 1ère IP | 10.0.0.65 |
| Dernière IP | 10.0.0.94 |
| Hôtes | 30 |

</details>



```
32-27 = 5

2puissance5 = 32

77 / 32 = 2 = 2*32 = 64 -> 10.0.0.64

64 + 32 - 1
```



---

### EX 03 — `172.16.1.220 /30` *(4ème octet)*

<details>
<summary>📖 Correction</summary>

```
Étape 1 : 32 - 30 = 2
Étape 2 : 2² = 4
Étape 3 : 220 ÷ 4 = 55 → 55 × 4 = 220
Étape 4 : 220 + 4 - 1 = 223
```

| | |
|---|---|
| Réseau | **172.16.1.220** |
| Broadcast | **172.16.1.223** |
| 1ère IP | 172.16.1.221 |
| Dernière IP | 172.16.1.222 |
| Hôtes | 2 |

</details>


```
32 - 30 = 2

2*2 = 4

220 / 4 = 55 -> 55*4 = 220     @ RZO 172.16.1.220/30

220 + 4 - 1                    @ BROADCAST 172.16.1.223


```



---

### EX 04 — `192.168.0.130 /25` *(4ème octet)*

<details>
<summary>📖 Correction</summary>

```
Étape 1 : 32 - 25 = 7
Étape 2 : 2⁷ = 128
Étape 3 : 130 ÷ 128 = 1,01 → 1 × 128 = 128
Étape 4 : 128 + 128 - 1 = 255
```

| | |
|---|---|
| Réseau | **192.168.0.128** |
| Broadcast | **192.168.0.255** |
| 1ère IP | 192.168.0.129 |
| Dernière IP | 192.168.0.254 |
| Hôtes | 126 |

</details>



---

### EX 05 — `10.50.33.17 /20` *(3ème octet)*

<details>
<summary>📖 Correction</summary>

```
Étape 1 : 24 - 20 = 4
Étape 2 : 2⁴ = 16
Étape 3 : 33 ÷ 16 = 2,06 → 2 × 16 = 32
Étape 4 : 32 + 16 - 1 = 47
```

| | |
|---|---|
| Réseau | **10.50.32.0** |
| Broadcast | **10.50.47.255** |
| 1ère IP | 10.50.32.1 |
| Dernière IP | 10.50.47.254 |
| Hôtes | 4094 |

</details>

---

### EX 06 — `172.16.100.200 /22` *(3ème octet)*

<details>
<summary>📖 Correction</summary>

```
Étape 1 : 24 - 22 = 2
Étape 2 : 2² = 4
Étape 3 : 100 ÷ 4 = 25 → 25 × 4 = 100
Étape 4 : 100 + 4 - 1 = 103
```

| | |
|---|---|
| Réseau | **172.16.100.0** |
| Broadcast | **172.16.103.255** |
| 1ère IP | 172.16.100.1 |
| Dernière IP | 172.16.103.254 |
| Hôtes | 1022 |

</details>

---

### EX 07 — `192.168.200.50 /17` *(3ème octet)*

<details>
<summary>📖 Correction</summary>

```
Étape 1 : 24 - 17 = 7
Étape 2 : 2⁷ = 128
Étape 3 : 200 ÷ 128 = 1,56 → 1 × 128 = 128
Étape 4 : 128 + 128 - 1 = 255
```

| | |
|---|---|
| Réseau | **192.168.128.0** |
| Broadcast | **192.168.255.255** |
| 1ère IP | 192.168.128.1 |
| Dernière IP | 192.168.255.254 |
| Hôtes | 32766 |

</details>



---

### EX 08 — `10.200.55.99 /21` *(3ème octet)*

<details>
<summary>📖 Correction</summary>

```
Étape 1 : 24 - 21 = 3
Étape 2 : 2³ = 8
Étape 3 : 55 ÷ 8 = 6,87 → 6 × 8 = 48
Étape 4 : 48 + 8 - 1 = 55
```

| | |
|---|---|
| Réseau | **10.200.48.0** |
| Broadcast | **10.200.55.255** |
| 1ère IP | 10.200.48.1 |
| Dernière IP | 10.200.55.254 |
| Hôtes | 2046 |

</details>


```
24-21=3

2*2*2=8

55 / 8 = 6 --> 8*6 = 48          @ RZO 10.200.48.0/21

48 + 8 - 1 = 55                  @ BRODCAST 10.200.55.255/21

10.200.48.1

10.200.55.254

32 - 21 = 11 bits 

2046




```



---

### EX 09 — `10.172.50.1 /12` *(2ème octet)*

<details>
<summary>📖 Correction</summary>

```
Étape 1 : 16 - 12 = 4
Étape 2 : 2⁴ = 16
Étape 3 : 172 ÷ 16 = 10,75 → 10 × 16 = 160
Étape 4 : 160 + 16 - 1 = 175
```

| | |
|---|---|
| Réseau | **10.160.0.0** |
| Broadcast | **10.175.255.255** |
| 1ère IP | 10.160.0.1 |
| Dernière IP | 10.175.255.254 |
| Hôtes | 1 048 574 |

</details>


```
16-12=4

2*4=16

172 / 16 = 10 -> 16*10 = 160 ---> @ RZO : 10.160.0.0/12

160 + 16 - 1 = 175 -------------> @ BRODCAST : 10.175.255.255/12

10.160.0.1/12

10.175.255.254/12





```


---

### EX 10 — `10.95.200.30 /10` *(2ème octet)*

<details>
<summary>📖 Correction</summary>

```
Étape 1 : 16 - 10 = 6
Étape 2 : 2⁶ = 64
Étape 3 : 95 ÷ 64 = 1,48 → 1 × 64 = 64
Étape 4 : 64 + 64 - 1 = 127
```

| | |
|---|---|
| Réseau | **10.64.0.0** |
| Broadcast | **10.127.255.255** |
| 1ère IP | 10.64.0.1 |
| Dernière IP | 10.127.255.254 |
| Hôtes | 4 194 302 |

</details>

---

### EX 11 — `10.230.10.5 /9` *(2ème octet)*

<details>
<summary>📖 Correction</summary>

```
Étape 1 : 16 - 9 = 7
Étape 2 : 2⁷ = 128
Étape 3 : 230 ÷ 128 = 1,79 → 1 × 128 = 128
Étape 4 : 128 + 128 - 1 = 255
```

| | |
|---|---|
| Réseau | **10.128.0.0** |
| Broadcast | **10.255.255.255** |
| 1ère IP | 10.128.0.1 |
| Dernière IP | 10.255.255.254 |
| Hôtes | 8 388 606 |

</details>

---

### EX 12 — `200.100.50.25 /5` *(1er octet)*

<details>
<summary>📖 Correction</summary>

```
Étape 1 : 8 - 5 = 3
Étape 2 : 2³ = 8
Étape 3 : 200 ÷ 8 = 25 → 25 × 8 = 200
Étape 4 : 200 + 8 - 1 = 207
```

| | |
|---|---|
| Réseau | **200.0.0.0** |
| Broadcast | **207.255.255.255** |
| 1ère IP | 200.0.0.1 |
| Dernière IP | 207.255.255.254 |
| Hôtes | 134 217 726 |

</details>

---

### EX 13 — `150.80.40.20 /3` *(1er octet)*

<details>
<summary>📖 Correction</summary>

```
Étape 1 : 8 - 3 = 5
Étape 2 : 2⁵ = 32
Étape 3 : 150 ÷ 32 = 4,68 → 4 × 32 = 128
Étape 4 : 128 + 32 - 1 = 159
```

| | |
|---|---|
| Réseau | **128.0.0.0** |
| Broadcast | **159.255.255.255** |
| 1ère IP | 128.0.0.1 |
| Dernière IP | 159.255.255.254 |
| Hôtes | 536 870 910 |

</details>

---

### EX 14 — `120.50.30.10 /6` *(1er octet)*

<details>
<summary>📖 Correction</summary>

```
Étape 1 : 8 - 6 = 2
Étape 2 : 2² = 4
Étape 3 : 120 ÷ 4 = 30 → 30 × 4 = 120
Étape 4 : 120 + 4 - 1 = 123
```

| | |
|---|---|
| Réseau | **120.0.0.0** |
| Broadcast | **123.255.255.255** |
| 1ère IP | 120.0.0.1 |
| Dernière IP | 123.255.255.254 |
| Hôtes | 67 108 862 |

</details>

---

### EX 15 — `172.20.128.60 /18` *(3ème octet)*

<details>
<summary>📖 Correction</summary>

```
Étape 1 : 24 - 18 = 6
Étape 2 : 2⁶ = 64
Étape 3 : 128 ÷ 64 = 2 → 2 × 64 = 128
Étape 4 : 128 + 64 - 1 = 191
```

| | |
|---|---|
| Réseau | **172.20.128.0** |
| Broadcast | **172.20.191.255** |
| 1ère IP | 172.20.128.1 |
| Dernière IP | 172.20.191.254 |
| Hôtes | 16 382 |

</details>

---

### EX 16 — `10.10.10.100 /26` *(4ème octet)*

<details>
<summary>📖 Correction</summary>

```
Étape 1 : 32 - 26 = 6
Étape 2 : 2⁶ = 64
Étape 3 : 100 ÷ 64 = 1,56 → 1 × 64 = 64
Étape 4 : 64 + 64 - 1 = 127
```

| | |
|---|---|
| Réseau | **10.10.10.64** |
| Broadcast | **10.10.10.127** |
| 1ère IP | 10.10.10.65 |
| Dernière IP | 10.10.10.126 |
| Hôtes | 62 |

</details>

---

*Cours TSSR — Sous-réseautage IP — Méthode en 4 étapes — Tous les CIDR /1 à /32 — 16 exercices corrigés*
