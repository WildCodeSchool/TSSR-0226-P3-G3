
######################################################################################################
#                                                                                                    #
#   Création USER automatiquement avec fichier (avec suppression protection contre la suppression)   #
#                                   Merci Dominique                                                  #
######################################################################################################

$FilePath = [System.IO.Path]::GetDirectoryName($MyInvocation.MyCommand.Definition)

### Parametre(s) à modifier

$File = "C:\Users\Administrator\Documents\ListeRH2.csv" # Pointe vers le CSV

### Main program

Clear-Host
#$User[0] | Format-List *  --> Pour voir si l'affichage du csv est correct
If (-not(Get-Module -Name activedirectory))
{
    Import-Module activedirectory
}

$Users = Import-Csv -Path $File -Delimiter ","
$ADUsers = Get-ADUser -Filter * -Properties *
$count = 1
function Format-AdString {
    param([string]$Texte)
    $Texte = $Texte -replace '[\u2013\u2014]', '-', ' '
    $d = $Texte.Normalize([Text.NormalizationForm]::FormD)
    -join ($d.ToCharArray() | Where-Object {
        [Globalization.CharUnicodeInfo]::GetUnicodeCategory($_) -ne 'NonSpacingMark'
        })
    }

Foreach ($User in $Users)
{
    Write-Progress -Activity "Création des utilisateurs dans l'OU" -Status "%effectué" -PercentComplete ($Count/$Users.Length*100)
    $Prenom            = Format-AdString $User.Prenom
    $Nom               = Format-AdString $User.Nom
    $Name              = "$Prenom $Nom"
    $DisplayName       = "$Prenom $Nom  $($User.Matricule)"  # Affichage "Prenom Nom Matricule"
    $SamAccountName    = $User.Matricule.Substring(0,6) # Affichage pour session "prenom.nom" 
    $UserPrincipalName = (($Prenom.ToLower() + "." + $Nom.ToLower()) + "@" + (Get-ADDomain).Forest)
    $GivenName         = $Prenom
    $Surname           = $Nom
    $Matricule         = $User.Matricule
    $City              = $User.City
    $OfficePhone       = $User.Telephone
    $EmailAddress      = $UserPrincipalName
    $Path              = "ou=$($User.Office),ou=$($User.Departement),ou=Utilisateurs,ou=Pharmgreen,dc=pharmgreen,dc=lan"
    $Company           = $User.Company
    $Department        = $User.Departement
    $Office            = $User.Office
    $Fonction          = $User.Fonction
    #$ManagerName       = $User.Manager  --> test resolution pb de Manager
    #$ManagerDN         = (Get-ADUser -Filter {DisplayName -like $ManagerName} | Select -First 1).DistinguishedName  --> test resolution pb de Manager
    
    If (($ADUsers | Where {$_.SamAccountName -eq $SamAccountName}) -eq $Null)
    {
        New-ADUser -Name $Name -DisplayName $DisplayName -SamAccountName $SamAccountName -UserPrincipalName $UserPrincipalName `
        -GivenName $GivenName -Surname $Surname -OfficePhone $OfficePhone -EmailAddress $EmailAddress -City $City `
        -Path $Path -AccountPassword (ConvertTo-SecureString -AsPlainText Azerty1* -Force) -Enabled $True `
        -Office $Office -Title $Fonction `
        -OtherAttributes @{Company = $Company;Department = $Department} -ChangePasswordAtLogon $True

        
        Write-Host "Création du USER $SamAccountName" -ForegroundColor Green
    }
    Else
    {
        Write-Host "Le USER $SamAccountName existe déjà" -ForegroundColor Black -BackgroundColor Yellow
    }
    $Count++
    sleep -Milliseconds 100
}
Foreach ($u in $Users){
$sam = (($u.Prenom) + "." + ($u.Nom)).ToLower() 
if ($sam.Lengh -gt 20) {Write-Host "Trop Long"}
}
