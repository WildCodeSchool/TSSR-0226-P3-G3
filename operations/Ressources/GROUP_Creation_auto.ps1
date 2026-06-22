Clear-Host
#######################################
#                                     #
#   Création GROUPE automatiquement   #
#                                     #
#######################################

### Groupes distincts ou plus généraux ?

$OuSecurity = "Sécurité"
$Groups = "GrpUtilisateurs","GrpUtilisateursAdmin","GrpUtilisateursDirection","GrpUtilisateursDirecteurdeBranche","GrpOrdinateurs","GrpOrdinateursAdmin","GrpOrdinateursDirection","GrpOrdinateursDirecteurdeBranche"

### Initialisation

$DomainDN = (Get-ADDomain).DistinguishedName

### Main program

Foreach ($Group in $Groups)
{
    Try
    {
        New-AdGroup -Name $Group -Path "ou=$OuSecurity,ou=Pharmgreen,$DomainDN" -GroupScope Global -GroupCategory Security
        Write-Host "Création du GROUPE $Group dans l'OU ou=$OuSecurity,ou=Pharmgreen,$DomainDN"-ForegroundColor Green
    }
    Catch
    {
        Write-Host "Le GROUPE $Group existe déjà" -ForegroundColor Yellow -BackgroundColor Black
    }
}
