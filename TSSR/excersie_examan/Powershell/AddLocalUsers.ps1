# =============================================================================
# AddLocalUsers.ps1 - Script de création d'utilisateurs locaux (version corrigée)
# =============================================================================
# Ce script lit un fichier CSV contenant des informations d'utilisateurs,
# vérifie leur existence sur la machine locale, et les crée si nécessaire.
# =============================================================================

# ----- Chemins des fichiers -----
$FilePath = "C:\Scripts\Users.csv"
$LogFile  = "C:\Scripts\log.txt"

# Q.2.7 - Intégration de la fonction Log depuis le module Functions.psm1
# Import-Module charge le module et rend la fonction Log() disponible
# Alternative : dot-sourcing avec . "C:\Scripts\Functions.psm1"
Import-Module "C:\Scripts\Functions.psm1"

# Q.2.8 - Journalisation du démarrage du script
Log -FilePath $LogFile -Content "========== Début du script AddLocalUsers =========="

# Q.2.3 - CORRECTION : Suppression de "| Select-Object -Skip 1"
#   Import-Csv utilise automatiquement la 1ère ligne comme en-tête.
#   Le -Skip 1 sautait le premier UTILISATEUR (Anna Dumas), pas l'en-tête.
#
# Q.2.5 - CORRECTION : Sélection uniquement des champs nécessaires
#   Le CSV contient 10 colonnes mais seuls prenom, nom et description
#   sont utilisés par le script. On filtre avec Select-Object.
$Users = Import-Csv -Path $FilePath -Delimiter ";" | Select-Object prenom, nom, description

# ----- Boucle de création des utilisateurs -----
ForEach ($User in $Users)
{
    # Construction du nom d'utilisateur : Prenom.Nom
    $Name     = "$($User.prenom).$($User.nom)"
    
    # Création du mot de passe sécurisé (SecureString obligatoire pour New-LocalUser)
    $Password = ConvertTo-SecureString "Azerty1*" -AsPlainText -Force

    # Vérification de l'existence de l'utilisateur
    # -ErrorAction SilentlyContinue : pas d'erreur affichée si l'utilisateur n'existe pas
    If (-not (Get-LocalUser -Name $Name -ErrorAction SilentlyContinue))
    {
        # --- L'utilisateur N'EXISTE PAS → on le crée ---

        # Q.2.4  - CORRECTION : Ajout du paramètre -Description (importé du CSV)
        # Q.2.11 - CORRECTION : Ajout de -PasswordNeverExpires
        #   Par défaut, Windows impose une expiration du mot de passe.
        #   Ce switch désactive l'expiration pour les comptes créés.
        New-LocalUser -Name $Name `
                      -Password $Password `
                      -FullName "$($User.prenom) $($User.nom)" `
                      -Description $User.description `
                      -PasswordNeverExpires

        # Q.2.10 - CORRECTION : Le groupe s'appelle "Utilisateurs" (avec un S)
        #   Sur Windows français : "Utilisateurs"
        #   Sur Windows anglais  : "Users"
        #   L'erreur originale : "Utilisateur" (sans S) → groupe introuvable
        Add-LocalGroupMember -Group "Utilisateurs" -Member $Name

        # Q.2.6 - CORRECTION : Affichage du mot de passe dans le message de succès
        Write-Host "Le compte $Name a été crée avec le mot de passe Azerty1*" -ForegroundColor Green

        # Q.2.8 - Journalisation de la création réussie
        Log -FilePath $LogFile -Content "Création réussie du compte $Name"
    }
    Else
    {
        # --- L'utilisateur EXISTE DÉJÀ → message d'alerte ---

        # Q.2.9 - CORRECTION : Ajout d'un message en rouge pour signaler le doublon
        #   Sans ce bloc Else, l'admin ne sait pas que l'utilisateur existait déjà
        Write-Host "Le compte $Name existe déjà" -ForegroundColor Red

        # Q.2.8 - Journalisation de l'existence du compte
        Log -FilePath $LogFile -Content "Le compte $Name existe déjà - non créé"
    }
}

# Q.2.8 - Journalisation de la fin du script
Log -FilePath $LogFile -Content "========== Fin du script AddLocalUsers =========="

# Pause pour permettre la lecture des messages avant fermeture
Read-Host "Appuyez sur Entrée pour fermer"
