Clear-Host
##############################################
#                                            #
#   Remplissage des groupe automatiquement   #
#                                            #
##############################################

### Parametre(s) à modifier

$OuSecurity = "Securite"

### Initialisation

$DomainDN = (Get-ADDomain).DistinguishedName

### Main

$Groups = Get-ADGroup -Filter * -SearchBase "OU=$OuSecurity,OU=Pharmgreen,$DomainDN" | Select-Object Name
$Groups | ForEach-Object {
    $g = $_.Name
    Get-ADGroupMember -Identity $g | ForEach-Object {
        Remove-ADGroupMember -Identity $g -Members $_.SamAccountName -Confirm:$false
    }
}