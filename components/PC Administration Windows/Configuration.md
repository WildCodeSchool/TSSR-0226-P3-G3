
# ============================================================
# Fonction commune de journalisation - Projet 3
# Utilisable par les scripts PowerShell actuels et futurs.
# ============================================================

function Write-Projet3Log {
    param(
        [Parameter(Mandatory = $true)]
        [ValidateSet("INFO", "WARNING", "ERROR")]
        [string]$Niveau,

        [Parameter(Mandatory = $true)]
        [string]$Message,

        [Parameter(Mandatory = $true)]
        [int]$EventId,

        [Parameter(Mandatory = $true)]
        [string]$NomScript
    )

    $DossierLogs = "C:\Projet3\Logs\Powershell"
    $NomJournalWindows = "Application"
    $SourceJournalWindows = "Projet3-Scripts-Powershell"

    # Création du dossier central s'il n'existe pas
    if (-not (Test-Path -LiteralPath $DossierLogs)) {
        New-Item -Path $DossierLogs -ItemType Directory -Force | Out-Null
    }

    # Un seul fichier de log pour le script appelant
    $FichierLog = Join-Path $DossierLogs "$NomScript.log"

    $Horodatage = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $Utilisateur = "$env:USERDOMAIN\$env:USERNAME"

    $LigneLog = "$Horodatage | $Niveau | $NomScript.ps1 | $env:COMPUTERNAME | $Utilisateur | $Message"

    # Écriture dans le fichier propre au script
    Add-Content -LiteralPath $FichierLog -Value $LigneLog -Encoding UTF8

    # Correspondance entre nos niveaux et Windows
    switch ($Niveau) {
        "INFO"    { $TypeEvenement = "Information" }
        "WARNING" { $TypeEvenement = "Warning" }
        "ERROR"   { $TypeEvenement = "Error" }
    }

    # Écriture dans l'Observateur d'événements
    if ([System.Diagnostics.EventLog]::SourceExists($SourceJournalWindows)) {

        $MessageWindows = "[$NomScript.ps1] [$Niveau] [$env:COMPUTERNAME] [$Utilisateur] $Message"

        Write-EventLog `
            -LogName $NomJournalWindows `
            -Source $SourceJournalWindows `
            -EventId $EventId `
            -EntryType $TypeEvenement `
            -Message $MessageWindows
    }
    else {
        $Alerte = "$Horodatage | WARNING | $NomScript.ps1 | Source Windows absente : $SourceJournalWindows"
        Add-Content -LiteralPath $FichierLog -Value $Alerte -Encoding UTF8
    }
}
