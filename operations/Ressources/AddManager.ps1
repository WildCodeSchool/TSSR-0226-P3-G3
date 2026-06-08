
######################################################################################################
#                                                                                                    #
#                           Ajout du manager de chaque utilisateur                                   #
#                                                                                                    #
######################################################################################################

$FilePath = [System.IO.Path]::GetDirectoryName($MyInvocation.MyCommand.Definition)

### Parametre(s) à modifier

$File = "C:\Users\Administrator\Documents\Scripts\Manager.csv" # Pointe vers le CSV

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
    $Texte = $Texte -replace '[\u2013\u2014]', '-'
    $d = $Texte.Normalize([Text.NormalizationForm]::FormD)
    -join ($d.ToCharArray() | Where-Object {
        [Globalization.CharUnicodeInfo]::GetUnicodeCategory($_) -ne 'NonSpacingMark'
        })
    }

Foreach ($User in $Users)
{
    $SamAccountName    = $User.Matricule.Substring(0,6) # Affichage pour session "Matricule" 
    $ManagerName       = $User.Manager.Trim() # Trim filtre les parasites (types retour à la ligne)
    $ManagerFind       = Get-ADUser -Filter "DisplayName -like '$ManagerName'" -Properties DisplayName # Viens récupérer le nom du manager dans l'AD (attention ne protege pas des doublons)
    if ($ManagerFind.Count -gt 1) {
        Write-Host "Attention, le Manager $ManagerName a au moins 1 homonyme !" -ForegroundColor Yellow
    }
    
    if ($ManagerFind) {
            Set-ADUser -Identity $SamAccountName -Manager $ManagerFind
            Write-Host "Le Manager $ManagerName de l'utilisateur $SamAccountName a bien été défini" -ForegroundColor Green
        } else {
            Write-Host "Le Manager $ManagerName de l'utilisateur $SamAccountName est introuvable" -ForegroundColor Red

        }

    
    $Count++
    sleep -Milliseconds 100
}
