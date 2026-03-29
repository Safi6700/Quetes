
# 1. Dossiers partagés

- Sur un DC ajouter un 2èm disque sur lequel sont hébergés les dossiers partagés :
	- Un **dossier individuel** , avec une lettre de mappage réseau **I**, accessible uniquement par cet utilisateur
- Mappage des lecteurs sur les clients (au choix) :
	- GPO
	- Script PowerShell/batch
	- Profil utilisateur AD

# 2. Redondence de serveurs AD DS

Créer 2 serveurs SRVWIN02 et SRVWIN03 :
- OS : Windows Server 2022 CORE
- Rôle DNS et AD DS sur chacun
- Répartition des rôles FSMO sur chacun

# 3. Restriction d'utilisation

- Pour les utilisateurs standard : connexion autorisée de 7h30 à 20h, du lundi au samedi sur les clients (bloquée le reste du temps)

# 4. NTP

Mise en place d'une synchronisation avec un rôle NTP.

# 5. WSUS

- Synchronisation AD DS et WSUS
- Mise en place par GPO
- Gestion de MAJ de sécurité par patch

# 6. WEB interne

- Mise en place d'un serveur web interne sur le LAN

# 7. WEB externe

- Mise en place d'un serveur web externe sur la DMZ

# 8. GLPI

Synchronisation AD

# 9. Réseau

- Mise en place de switch virtuel (Virtualbox, Hyper-V, etc.)
- Mise en place de routeur avec Vyos