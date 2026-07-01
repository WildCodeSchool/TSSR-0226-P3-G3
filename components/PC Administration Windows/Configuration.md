
#requires -Version 5.1

# ============================================================
# Test de journalisation PowerShell - Projet 3
# Ce script ne modifie pas Active Directory.
# ============================================================

# Configuration de la journalisation
$DossierLogs = "C:\Projet3\Logs\Powershell"
$NomJournalWindows = "Application"
$SourceJournalWindows = "Projet3-Scripts-Powershell"

# Récupération automatique du nom du script
$NomScript = [System.IO.Path]::GetFileNameWithoutExtension($PSCommandPath)

# Un seul fichier de log pour ce script
$FichierLog = Join-Path $DossierLogs "$NomScript.log"

# Création du dossier des logs s'il n'existe pas
if (-not (Test-Path -LiteralPath $DossierLogs)) {
    New-Item -Path $DossierLogs -ItemType Directory -Force | Out-Null
}

function Write-Projet3Log {
    param(
        [Parameter(Mandatory = $true)]
        [ValidateSet("INFO", "WARNING", "ERROR")]
        [string]$Niveau,

        [Parameter(Mandatory = $true)]
        [string]$Message,

        [Parameter(Mandatory = $true)]
        [int]$EventId
    )

    # Informations ajoutées automatiquement
    $Horodatage = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $Utilisateur = "$env:USERDOMAIN\$env:USERNAME"

    # Ligne enregistrée dans le fichier .log
    $LigneLog = "$Horodatage | $Niveau | $NomScript.ps1 | $env:COMPUTERNAME | $Utilisateur | $Message"

    # Ajout dans le fichier propre au script
    Add-Content -LiteralPath $FichierLog -Value $LigneLog -Encoding UTF8

    # Correspondance avec les niveaux de Windows
    switch ($Niveau) {
        "INFO"    { $TypeEvenement = "Information" }
        "WARNING" { $TypeEvenement = "Warning" }
        "ERROR"   { $TypeEvenement = "Error" }
    }

    # Écriture dans l'Observateur d'événements
    if ([System.Diagnostics.EventLog]::SourceExists($SourceJournalWindows)) {
        Write-EventLog -LogName $NomJournalWindows -Source $SourceJournalWindows -EventId $EventId -EntryType $TypeEvenement -Message "[$NomScript.ps1] $Message"
    }
    else {
        $AlerteSource = "$Horodatage | WARNING | $NomScript.ps1 | Source Windows absente : $SourceJournalWindows"
        Add-Content -LiteralPath $FichierLog -Value $AlerteSource -Encoding UTF8
    }
}

# ============================================================
# Début du test
# ============================================================

Write-Projet3Log -Niveau "INFO" -Message "Début du script de test." -EventId 1000

Write-Projet3Log -Niveau "WARNING" -Message "Avertissement de test : aucune modification Active Directory n'est réalisée." -EventId 2000

try {
    # Recherche volontaire d'un fichier inexistant
    Get-Item -LiteralPath "C:\Projet3\Fichier_Inexistant_Test.txt" -ErrorAction Stop | Out-Null
}
catch {
    Write-Projet3Log -Niveau "ERROR" -Message "Erreur de test capturée : $($_.Exception.Message)" -EventId 3000
}

Write-Projet3Log -Niveau "INFO" -Message "Fin du script de test." -EventId 1001

Write-Host ""
Write-Host "Test de journalisation terminé."
Write-Host "Fichier de log : $FichierLog"
