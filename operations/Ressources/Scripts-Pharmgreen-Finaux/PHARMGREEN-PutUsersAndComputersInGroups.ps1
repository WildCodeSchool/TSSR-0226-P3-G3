Clear-Host
##############################################
#                                            #
#   Remplissage des groupe automatiquement   #
#                                            #
##############################################

### Parametre(s) à modifier

$OuSecurity = "Securite"

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

$LogFolder   = Join-Path $PSScriptRoot "Les Logs Scripts" # Construit le chemin
$ScriptName  = "LogsduScript-PHARMGREEN-PutUsersAndComputersInGroups"   # <-- A Changer dans chaque script
$LogFile     = Join-Path $LogFolder "$($ScriptName)_$(Get-Date -Format 'yyyy-MM-dd').log" # Format du fichier log
# Création du sous-dossier s'il n'existe pas
if (-not (Test-Path $LogFolder)) {
    New-Item -Path $LogFolder -ItemType Directory -Force | Out-Null
}





### Initialisation

$DomainDN = (Get-ADDomain).DistinguishedName

### Main

$Groups = Get-ADGroup -Filter * -SearchBase "OU=$OuSecurity,OU=Pharmgreen,$DomainDN" | Select-Object Name
$AllUsers = Get-ADUser -Filter * -SearchBase "OU=Utilisateurs,OU=Pharmgreen,$DomainDN" | Select-Object -ExpandProperty SamAccountName
$AdminUsers = Get-ADUser -Filter * -SearchBase "OU=T0,OU=SystemesInformation,OU=Utilisateurs,OU=Pharmgreen,$DomainDN" -SearchScope OneLevel | Select-Object -ExpandProperty SamAccountName
$DirectionUsers = Get-ADUser -Filter * -SearchBase "OU=Direction,OU=Direction Generale,OU=Utilisateurs,OU=Pharmgreen,$DomainDN" -SearchScope OneLevel | Select-Object -ExpandProperty SamAccountName
$BrancheAdmin = Get-ADUser -Filter * -SearchBase "OU=DirecteurDeBranche,OU=DirectionGenerale,OU=Utilisateurs,OU=Pharmgreen,$DomainDN" -SearchScope OneLevel | Select-Object -ExpandProperty SamAccountName
$AllComputers = Get-ADComputer -Filter * -SearchBase "OU=Ordinateurs,OU=Pharmgreen,$DomainDN" | Select-Object -ExpandProperty SamAccountName
$AdminComputers = Get-ADComputer -Filter * -SearchBase "OU=T0,OU=SystemesInformation,OU=Ordinateurs,OU=Pharmgreen,$DomainDN" -SearchScope OneLevel | Select-Object -ExpandProperty SamAccountName
$DirectionComputers = Get-ADComputer -Filter * -SearchBase "OU=Direction,OU=DirectionGenerale,OU=Ordinateurs,OU=Pharmgreen,$DomainDN" -SearchScope OneLevel | Select-Object -ExpandProperty SamAccountName
$BrancheAdmin = Get-ADComputer -Filter * -SearchBase "OU=DirecteurdeBranche,OU=DirectionGenerale,OU=Ordinateurs,OU=Pharmgreen,$DomainDN" -SearchScope OneLevel | Select-Object -ExpandProperty SamAccountName

# Parcourir les groupes
ForEach ($Group in $Groups.Name)
{
    Switch ($group)
    {
        {$_ -like "*GrpUtilisateursAdmin*"} {
        # Ajout des objets utilisateurs dans les groupes utilisateurs GrpUsers
        $AdminUsers | ForEach-Object {Add-ADGroupMember -Identity $group -Members $_}
        break
                            }
        {$_ -like "*GrpUtilisateursDirection*"} {
        # Ajout des objets utilisateurs dans les groupes utilisateurs GrpUsers
        $DirectionUsers | ForEach-Object {Add-ADGroupMember -Identity $group -Members $_}
        break
                            }
        {$_ -like "*GrpUtilisateursDirecteurdeBranche*"} {
        # Ajout des objets utilisateurs dans les groupes utilisateurs GrpUsers
        $BrancheAdmin | ForEach-Object {Add-ADGroupMember -Identity $group -Members $_}
        break
                            }
        {$_ -like "*GrpUtilisateurs*"} {
        # Ajout des objets utilisateurs dans les groupes utilisateurs GrpUsers
        $AllUsers | ForEach-Object {Add-ADGroupMember -Identity $group -Members $_}
        break
                            }
        {$_ -like "*GrpOrdinateursAdmin*"} {
        # Ajout des objets Ordinateurs dans les groupes Ordinateurs GrpComputers Admin
        $AdminComputers | ForEach-Object {Add-ADGroupMember -Identity $group -Members $_}
        break
                            }
        {$_ -like "*GrpOrdinateursDirection*"} {
        # Ajout des objets Ordinateurs dans les groupes Ordinateurs GrpComputers Direction
        $DirectionComputers | ForEach-Object {Add-ADGroupMember -Identity $group -Members $_}
        break
                            }
        {$_ -like "*GrpOrdinateursDirecteurdeBranche*"} {
        # Ajout des objets Ordinateurs dans les groupes Ordinateurs GrpComputers DirecteurDeBranche
        $BrancheAdmin | ForEach-Object {Add-ADGroupMember -Identity $group -Members $_}
        break
                            }
        {$_ -like "*GrpOrdinateurs*"} {
        # Ajout des objets Ordinateurs dans les groupes Ordinateurs GrpComputers ALL
        $AllComputers | ForEach-Object {Add-ADGroupMember -Identity $group -Members $_}
        break
                            }
        Default {Write-Warning "Groupe non reconnu : $group"}
    }
}
