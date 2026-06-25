
######################################################################################################
#                                                                                                    #
#                           Ajout du du tÃ©lÃ©phone de chaque utilisateur                                   #
#                                                                                                    #
######################################################################################################

$FilePath = [System.IO.Path]::GetDirectoryName($MyInvocation.MyCommand.Definition)

### Localisation du Fichier .CSV
# Le les utilisateurs doivent Ãªtre rangÃ© avec leur "Matricule" et les Managers avec leur "Prenom Nom" ou "Prenom Nom Matricule"
$File = "C:\Users\Administrator\Documents\Scripts\ListeRhVoIP.csv" # Pointe vers le CSV

### Main program

Clear-Host
#$User[0] | Format-List *  --> Pour voir si l'affichage du csv est correct
If (-not(Get-Module -Name activedirectory))
{
    Import-Module activedirectory
}

$Users = Import-Csv -Path $File -Delimiter ","
$count = 1

# Ajout des numÃ©ros de telephone mobile et IP pour les utilisateurs AD
Foreach ($User in $Users)
{
    $SamAccountName = $User.Matricule.Substring(0,6) # Affichage pour session "Matricule" 
    $Telephone      = $User.Telephone.Trim() # Trim filtre les parasites (types retour Ã  la ligne)
    $VoIP           = $User.Ipphone.Trim()
    
    try {
        if ($Telephone) {
            Set-ADUser -Identity $SamAccountName -Replace @{mobile = $Telephone}
        } else {
            Set-ADUser -Identity $SamAccountName -Clear mobile
        }
        if ($VoIP) {
                Set-ADUser -Identity $SamAccountName -Replace @{ipPhone = $VoIP}
            } else {
                Set-ADUser -Identity $SamAccountName -Clear ipPhone
            }
            Write-Host "Le téléphone $Telephone et l'Ipphone $VoIP de l'utilisateur $SamAccountName ont bien été configurés" -ForegroundColor Green
    } catch {
        Write-Host "La configuration pour l'utilisateur $SamAccountName a échoué : $($_.Exception.Message)" -ForegroundColor Red
    }
    
    $Count++
    sleep -Milliseconds 100
}
# Affichage des Utilisateurs sans VoIP (si tout est normal seuls les 4 Techs et les comptes de liaisons serveur apparaissent)
Get-ADUser -Filter * -Properties ipPhone, DisplayName -SearchBase "OU=Utilisateurs,OU=Pharmgreen,DC=pharmgreen,DC=lan" |
    Where-Object { $_.ipPhone -eq $null } |
    Select-Object DisplayName, SamAccountName
