
######################################################################################################
#                                                                                                    #
#                           Ajout du manager de chaque utilisateur                                   #
#                                                                                                    #
######################################################################################################

# Script Automatisé = Si lancé manuellement rajouter "-Verbose" pour avoir les retours de Write-Verbose

$FilePath = $PSScriptRoot

### Localisation du Fichier .CSV
# Le les utilisateurs doivent être rangé avec leur "Matricule" et les Managers avec leur "Prenom Nom" ou "Prenom Nom Matricule"
$File = "C:\Ressources\Scripts\Scripts-Pharmgreen-Finaux\ListeRH.csv" # Pointe vers le CSV

# Logs de Script auto
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

### Configuration du log (à adapter dans chaque script)

$LogFolder   = Join-Path $FilePath "Les Logs Scripts" # Construit le chemin
$ScriptName  = "LogsduScript-PHARMGREEN-AddManager"   # <-- A Changer dans chaque script
$LogFile     = Join-Path $LogFolder "$($ScriptName)_$(Get-Date -Format 'yyyy-MM-dd').log" # Format du fichier log
# Création du sous-dossier s'il n'existe pas
if (-not (Test-Path $LogFolder)) {
    New-Item -Path $LogFolder -ItemType Directory -Force | Out-Null
}

### Main program

Clear-Host
#$User[0] | Format-List *  --> Pour voir si l'affichage du csv est correct
If (-not(Get-Module -Name activedirectory))
{
    Import-Module activedirectory
}

$Users = Import-Csv -Path $File -Delimiter ","
$count = 1
function Format-AdString {
    param([string]$Texte)
    $Texte = $Texte -replace '[\u2013\u2014]', '-'
    $d = $Texte.Normalize([Text.NormalizationForm]::FormD)
    -join ($d.ToCharArray() | Where-Object {
        [Globalization.CharUnicodeInfo]::GetUnicodeCategory($_) -ne 'NonSpacingMark'
        })
    }
# Ajout du Manager dans l'onglet AD, si un homonyme existe un message d'erreur l'annonce
Foreach ($User in $Users)
{
    $SamAccountName    = $User.Matricule.Substring(0,6) # Affichage pour session "Matricule"
    $ManagerName       = $User.Manager.Trim() # Trim filtre les parasites (types retour à la ligne)
    $ManagerFind       = Get-ADUser -Filter "DisplayName -like '$ManagerName *'" -Properties DisplayName # Viens récupérer le nom du manager dans l'AD (attention ne protege pas des doublons)
    if ($ManagerFind.Count -gt 1) {
        Write-Verbose "Attention, le Manager $ManagerName a au moins 1 homonyme !" -ForegroundColor Yellow
    }
    # Vérification de l'existence du Manager lui-même
    if ($ManagerFind) {
            Set-ADUser -Identity $SamAccountName -Manager $ManagerFind
            Write-Verbose "Le Manager $ManagerName de l'utilisateur $SamAccountName a bien été défini" -ForegroundColor Green
            Write-Log "Ajout du Manager $ManagerName de $SamAccountName" -Level SUCCESS
        } else {
            Write-Verbose "Le MANAGER $ManagerName de l'utilisateur $SamAccountName est introuvable" -ForegroundColor Red
            Write-Log "ECHEC d'ajout du MANAGER $ManagerName de $SamAccountName - $($_.Exception.Message)" -Level ERROR
        }

    $Count++
    Start-Sleep -Milliseconds 100
}
# Affichage des Utilisateurs sans Manager (si tout est normal seuls les 4 Techs apparaissent)
Get-ADUser -Filter * -Properties Manager, DisplayName -SearchBase "OU=Utilisateurs,OU=Pharmgreen,DC=pharmgreen,DC=lan" |
    Where-Object { $_.Manager -eq $null } |
    Select-Object DisplayName, SamAccountName
