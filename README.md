# Windows File Sharing
---
##Configuration d'un serveur de fichiers SMB sur **Windows Server 2022** avec gestion des permissions NTFS par groupe Active Directory.

### Partage SMB côté serveur (Server Manager)

![Partage SMB - Server Manager](1serveur.png)

### Vérification du partage avec Get-SmbShare

![Get-SmbShare](smb_share.png)

### Permissions NTFS avec Get-Acl

![Permissions NTFS](smb_share_et_droit_ntfs.png)

### Accès client via `\\SRVWIN01\Docs`

![Client - accès au partage](client.png)

### Test de restriction d'accès (accès refusé au dossier Direction)

![Accès refusé](autorisa.png)

---
## 🛠️ Commandes PowerShell clés


# Création du partage
New-SmbShare -Name "Docs" -Path "C:\Documents_Enterprise" -FullAccess "Everyone"

# Vérification des partages
Get-SmbShare

# Vérification des permissions NTFS
(Get-Acl "C:\Documents_Enterprise\RH").Access | Format-Table IdentityReference, FileSystemRights, AccessControlType

# Mapper un lecteur réseau (côté client)
New-PSDrive -Name "Z" -PSProvider FileSystem -Root "\\SRVWIN01\Docs" -Persist


## ✅ Résultat

Les permissions NTFS sont correctement appliquées : chaque groupe accède uniquement aux dossiers autorisés, l'accès est refusé pour les autres.
