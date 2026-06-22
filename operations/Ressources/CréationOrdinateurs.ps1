
######################################################################################################
#                                                                                                    #
#                       Création Ordi automatiquement avec fichier                                   #
#                                                                                                    #
######################################################################################################

$FilePath = [System.IO.Path]::GetDirectoryName($MyInvocation.MyCommand.Definition)

### Parametre(s) à modifier

$File = "C:\Users\Administrator\Documents\Scripts\ListeComputer.csv" # Pointe vers le CSV

### Main program

Clear-Host
#$Ordi[0] | Format-List *  --> Pour voir si l'affichage du csv est correct
If (-not(Get-Module -Name activedirectory))
{
    Import-Module activedirectory
}

$Ordis = Import-Csv -Path $File -Delimiter ","
$ADComputer = Get-ADComputer -Filter * -Properties *
$Count = 1
function Format-AdString {
    param([string]$Texte)
    $Texte = $Texte -replace '[\u2013\u2014]', '-'
    $d = $Texte.Normalize([Text.NormalizationForm]::FormD)
    -join ($d.ToCharArray() | Where-Object {
        [Globalization.CharUnicodeInfo]::GetUnicodeCategory($_) -ne 'NonSpacingMark'
        })
    }

Foreach ($Ordi in $Ordis)
{
    Write-Progress -Activity "Création des ordinateurs dans l'OU" -Status "%effectué" -PercentComplete ($Count/$Ordis.Length*100)
    $Name              = $Ordi.Ordinateur
    $Path              = "ou=$($Ordi.Service),ou=$($Ordi.Departement),ou=Ordinateurs,ou=Pharmgreen,dc=pharmgreen,dc=lan"
    $Department        = $Ordi.Departement
    $Service           = $Ordi.Service
  
    If (($ADComputer | Where {$_.Name -eq $Name}) -eq $Null)
    {
        New-ADComputer -Name $Name `
        -Path $Path -Enabled $True `
        -Description "$($Ordi.Departement) - $($Ordi.Service)"

        
        Write-Host "Création de l'Ordinateur $Name" -ForegroundColor Green
    }
    Else
    {
        Write-Host "L'Ordinateur $Name existe déjà" -ForegroundColor Black -BackgroundColor Yellow
    }
    $Count++
    sleep -Milliseconds 100
}
