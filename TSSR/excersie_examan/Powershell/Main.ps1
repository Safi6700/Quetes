# =============================================================================
# Main.ps1 - Script de lancement avec élévation de privilèges
# =============================================================================
# Ce script est exécuté par un utilisateur standard (non-admin).
# Il lance AddLocalUsers.ps1 avec des droits administrateur via UAC.
# =============================================================================

# Q.2.2 - Correction du chemin : C:\Temp → C:\Scripts
# Le script AddLocalUsers.ps1 se trouve dans le dossier C:\Scripts,
# et non dans C:\Temp comme indiqué dans la version originale.
# -FilePath "powershell.exe"  → Lance une nouvelle instance PowerShell
# -ArgumentList               → Le script à exécuter dans cette instance
# -Verb RunAs                 → Déclenche l'élévation de privilèges (UAC)
# -WindowStyle Maximized      → Fenêtre en plein écran pour voir les résultats
Start-Process -FilePath "powershell.exe" -ArgumentList "C:\Scripts\AddLocalUsers.ps1" -Verb RunAs -WindowStyle Maximized
