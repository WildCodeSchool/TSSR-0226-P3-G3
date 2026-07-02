# ============================================================
# Script de test des blocs de début et de fin
# Aucune modification Active Directory
# ============================================================

# Début de la journalisation
$Projet3JournalisationDisponible = $false

try {
    . "C:\Projet3\Scripts\Journalisation\Write-Projet3Log.ps1"

    $Projet3NomScript = [System.IO.Path]::GetFileNameWithoutExtension(
        $PSCommandPath
    )

    Write-Projet3Log `
        -Niveau "INFO" `
        -Message "Démarrage du script." `
        -EventId 1000 `
        -NomScript $Projet3NomScript

    $Projet3JournalisationDisponible = $true
}
catch {
    Write-Warning "La journalisation de début a échoué : $($_.Exception.Message)"
}

# ============================================================
# Action sans danger servant uniquement de test
# ============================================================

Write-Host "Le contenu principal du script est en cours d'exécution."
Start-Sleep -Seconds 2
Write-Host "Le contenu principal du script est terminé."

# ============================================================
# Fin de la journalisation
# ============================================================

if ($Projet3JournalisationDisponible) {
    try {
        Write-Projet3Log `
            -Niveau "INFO" `
            -Message "Le script a atteint la fin de son exécution." `
            -EventId 1001 `
            -NomScript $Projet3NomScript
    }
    catch {
        Write-Warning "La journalisation de fin a échoué : $($_.Exception.Message)"
    }
}
