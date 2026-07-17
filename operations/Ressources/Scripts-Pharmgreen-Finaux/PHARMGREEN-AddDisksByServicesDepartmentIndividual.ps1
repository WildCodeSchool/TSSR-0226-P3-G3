
######################################################################################################
#                                                                                                    #
#            Création Disques Partagés par Services / Départements et Individuels                    #
#                                                                                                    #
######################################################################################################

# Script Automatisé = Si lancé manuellement rajouter "-Verbose" pour avoir les retours de Write-Verbose


### Configuration du log (à adapter dans chaque script)

$LogFolder   = Join-Path $PSScriptRoot "Les Logs Scripts" # Construit le chemin
$ScriptName  = "LogsduScript-PHARMGREEN-AddDisksByServicesDepartmentIndividual"   # <-- A Changer dans chaque script
$LogFile     = Join-Path $LogFolder "$($ScriptName)_$(Get-Date -Format 'yyyy-MM-dd').log" # Format du fichier log

# Création du sous-dossier s'il n'existe pas
if (-not (Test-Path $LogFolder)) {
    New-Item -Path $LogFolder -ItemType Directory -Force | Out-Null
}

function Write-Log {
    param(
        [string]$Message,
        [ValidateSet("INFO","SUCCESS","ERROR","WARN")]
        [string]$Level = "INFO"
    )
    $Timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $Line = "[$Timestamp] [$Level] $Message"
    Add-Content -Path $LogFile -Value $Line
}




Import-Module ActiveDirectory
$userssrv = Get-ADUser -Filter * -SearchBase "OU=Utilisateurs,OU=Pharmgreen,DC=pharmgreen,DC=lan" -Properties physicalDeliveryOfficeName
$usersdpt = Get-ADUser -Filter * -SearchBase "OU=Utilisateurs,OU=Pharmgreen,DC=pharmgreen,DC=lan" -Properties department
$usersindiv = Get-ADUser -Filter * -SearchBase "OU=Utilisateurs,OU=Pharmgreen,DC=pharmgreen,DC=lan"
$count = 1

# Création du dossier par Service
foreach ($userS in $userssrv) {
    Write-Progress -Activity "Création de dossiers Services" -Status "%effectué" -PercentComplete ($count/$userssrv.Length*100)
    $path = "\\PG-00032-X00021\Service$\$($user.physicalDeliveryOfficeName)"
    if (!(Test-Path $path)) {
        New-Item -Path $path -ItemType Directory -Force | Out-Null
        Write-Verbose "Le dossier $path a bien été créé" -ForegroundColor Green
        Write-Log "CREATION DE $path" -Level SUCCESS
    }
    else {
    Write-Verbose "Le Dossier $path existe deja" -ForegroundColor
    Write-Log "CREATION DE $path existe deja" -Level ERROR
    }
}

$count = 1
# Création du dossier par Individu
foreach ($userI in $usersindiv) {
    Write-Progress -Activity "Création de dossiers individuels" -Status "%effectué" -PercentComplete ($count/$usersindiv.Length*100)
    $path = "\\PG-00032-X00021\Individuel$\$($userI.SamAccountName)"
    if (!(Test-Path $path)) {
        New-Item -Path $path -ItemType Directory -Force | Out-Null
        Write-Verbose "Le dossier $path a bien été créé" -ForegroundColor
        Write-Log "CREATION DE $path" -Level SUCCESS
    }
    else {
    Write-Verbose "Le Dossier $path existe deja" -ForegroundColor Yellow
    Write-Log "CREATION DE $path existe deja" -Level ERROR
    }
}

$count = 1
# Création du dossier par Département
foreach ($userD in $usersdpt) {
    Write-Progress -Activity "Création de dossiers Departements" -Status "%effectué" -PercentComplete ($count/$usersdpt.Length*100)
    $path = "\\PG-00032-X00021\Departement$\$($user.department)"
    if (!(Test-Path $path)) {
        New-Item -Path $path -ItemType Directory -Force | Out-Null
        Write-Verbose "Le dossier $path a bien été créé" -ForegroundColor Green
        Write-Log "CREATION DE $path" -Level SUCCESS
    }
    else {
    Write-Verbose "Le Dossier $path existe deja" -ForegroundColor Yellow
    Write-Log "CREATION DE $path existe deja" -Level ERROR
    }
}
