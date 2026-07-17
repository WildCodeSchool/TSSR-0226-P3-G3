
######################################################################################################
#                                                                                                    #
#   Création USER automatiquement avec fichier (avec suppression protection contre la suppression)   #
#                                   Merci Dominique                                                  #
######################################################################################################

# Script Automatisé = Si lancé manuellement rajouter "-Verbose" pour avoir les retours de Write-Verbose

$FilePath = $PSScriptRoot # Indique le chemin vers le dossier parent du Script lui-même

### Parametre(s) à modifier

$File = "C:\Ressources\Scripts\Scripts-Pharmgreen-Finaux\ListeRH.csv" # Pointe vers le CSV

### Main program


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
$ScriptName  = "LogsduScript-PHARMGREEN-AddUsersAndComputers"   # <-- A Changer dans chaque script
$LogFile     = Join-Path $LogFolder "$($ScriptName)_$(Get-Date -Format 'yyyy-MM-dd').log" # Format du fichier log
# Création du sous-dossier s'il n'existe pas
if (-not (Test-Path $LogFolder)) {
    New-Item -Path $LogFolder -ItemType Directory -Force | Out-Null
}

Clear-Host
#$User[0] | Format-List *  --> Pour voir si l'affichage du csv est correct
If (-not(Get-Module -Name activedirectory))
{
    Import-Module activedirectory
}

$Users = Import-Csv -Path $File -Delimiter ","
$ADUsers = Get-ADUser -Filter * -Properties *
$Ordis = Import-Csv -Path $File -Delimiter ","
$ADComputer = Get-ADComputer -Filter * -Properties *

# Suppression des espaces, accents et caractères spéciaux dans les prenoms/noms

function Format-AdString {
    param([string]$Texte)
    $Texte = $Texte -replace '[\u2013\u2014]', '-'
    $d = $Texte.Normalize([Text.NormalizationForm]::FormD)
    -join ($d.ToCharArray() | Where-Object {
        [Globalization.CharUnicodeInfo]::GetUnicodeCategory($_) -ne 'NonSpacingMark'
        })
    }
$Count = 1
Foreach ($User in $Users)
{
    Write-Progress -Activity "Création des utilisateurs dans l'OU" -Status "%effectué" -PercentComplete ($Count/$Users.Length*100)
    $Prenom            = Format-AdString $User.Prenom.Trim()
    $Nom               = Format-AdString $User.Nom.Trim()
    $Name              = Format-AdString "$Prenom $Nom"
    $DisplayName       = Format-AdString "$Prenom $Nom  $($User.Matricule)"  # Affichage "Prenom Nom Matricule"
    $SamAccountName    = Format-AdString $User.Matricule.Substring(0,6) # Affichage pour session "Matricule"
    $UserPrincipalName = Format-AdString (($Prenom.ToLower() + "." + $Nom.ToLower()) + "@" + (Get-ADDomain).Forest)
    $GivenName         = $Prenom.Trim()
    $Surname           = $Nom.Trim()
    $City              = $User.City.Trim()
    $Telephone         = $User.Telephone.Trim() # Trim filtre les parasites (types retour à la ligne)
    $VoIP              = $User.Ipphone.Trim()
    $OfficePhone       = $User.Telephone.Trim()
    $EmailAddress      = $UserPrincipalName.Trim()
    $Path              = "ou=$($User.Office),ou=$($User.Departement),ou=Utilisateurs,ou=Pharmgreen,dc=pharmgreen,dc=lan"
    $Company           = $User.Company.Trim()
    $Department        = Format-AdString $User.Departement.Trim()
    $Office            = Format-AdString $User.Office.Trim()
    $Fonction          = $User.Fonction.Trim()

    If ($Null -eq ($ADUsers | Where-Object {$_.SamAccountName -eq $SamAccountName}))
    {
        try {
            New-ADUser -Name $Name -DisplayName $DisplayName -SamAccountName $SamAccountName -UserPrincipalName $UserPrincipalName `
            -GivenName $GivenName -Surname $Surname -OfficePhone $OfficePhone -EmailAddress $EmailAddress -City $City `
            -Path $Path -AccountPassword (ConvertTo-SecureString -AsPlainText Azerty1* -Force) -Enabled $True `
            -Office $Office -Title $Fonction -mobile $Telephone `
            -OtherAttributes @{Company = $Company; Department = $Department; ipPhone = $VoIP} -ChangePasswordAtLogon $True -ErrorAction Stop


            Write-Verbose "Création du USER $SamAccountName" -ForegroundColor Green
            Write-Log "Création du USER $SamAccountName ($UserPrincipalName)" -Level SUCCESS
        }
        catch {
            Write-Verbose "ERREUR création $SamAccountName : $($_.Exception.Message)" -ForegroundColor Red
            Write-Log "ECHEC de création USER $SamAccountName - $($_.Exception.Message)" -Level ERROR

        }
    }
    Else
    {
        Write-Verbose "Le USER $SamAccountName existe déjà" -ForegroundColor Black -BackgroundColor Yellow
        Write-Log "USER $SamAccountName existe déjà, ignoré" -Level WARN
    }
    $Count++
    Start-Sleep -Milliseconds 100
}

$Count = 1
Foreach ($Ordi in $Ordis)
{
    Write-Progress -Activity "Création des ordinateurs dans l'OU" -Status "%effectué" -PercentComplete ($Count/$Ordis.Length*100)
    $Name              = $Ordi.Ordinateur
    $Path              = "ou=$($Ordi.Office),ou=$($Ordi.Departement),ou=Ordinateurs,ou=Pharmgreen,dc=pharmgreen,dc=lan"
    $Department        = $Ordi.Departement
    $Office           = $Ordi.Office

    If ($Null -eq ($ADComputer | Where-Object {$_.Name -eq $Name}))
    {
        try {
            New-ADComputer -Name $Name `
            -Path $Path -Enabled $True `
            -Description "$($Ordi.Departement) - $($Ordi.Office)" -ErrorAction Stop


            Write-Verbose "Création de l'Ordinateur $Name" -ForegroundColor Green
            Write-Log "Création de l'Ordinateur $Name" -Level SUCCESS
        }
        catch {
            Write-Verbose "ERREUR création $Name : $($_.Exception.Message)" -ForegroundColor Red
            Write-Log "ECHEC de création Ordinateur $Name existe déjà - $($_.Exception.Message)" -Level ERROR
        }
    }
    Else
    {
        Write-Verbose "L'Ordinateur $Name existe déjà" -ForegroundColor Black -BackgroundColor Yellow
        Write-Log "Ordinateur $Name existe déjà, ignoré" -Level WARN
    }
    $Count++
    Start-Sleep -Milliseconds 100
}
