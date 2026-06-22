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
$AllUsers = Get-ADUser -Filter * -SearchBase "OU=Utilisateurs,OU=Pharmgreen,$DomainDN" | Select-Object -ExpandProperty SamAccountName
$AdminUsers = Get-ADUser -Filter * -SearchBase "OU=T0,OU=SystemesInformation,OU=Utilisateurs,OU=Pharmgreen,$DomainDN" -SearchScope OneLevel | Select-Object -ExpandProperty SamAccountName
$DirectionUsers = Get-ADUser -Filter * -SearchBase "OU=Direction,OU=Direction Generale,OU=Utilisateurs,OU=Pharmgreen,$DomainDN" -SearchScope OneLevel | Select-Object -ExpandProperty SamAccountName
$BrancheAdmin = Get-ADUser -Filter * -SearchBase "OU=DirecteurDeBranche,OU=DirectionGenerale,OU=Utilisateurs,OU=Pharmgreen,$DomainDN" -SearchScope OneLevel | Select-Object -ExpandProperty SamAccountName
# $LabComputers = Get-ADComputer -Filter * -SearchBase "OU=Ordinateurs,$DomainDN" | Select-Object -ExpandProperty SamAccountName

# Parcourir les groupes
Foreach ($Group in $Groups.Name)
{
    Switch ($group)
    {
        {$_ -like "*GrpUtilisateursAdmin*"} {
        # Ajout des objets utilisateurs dans les groupes utilisateurs GrpUsers
        $AdminUsers | ForEach {Add-ADGroupMember -Identity $group -Members $_}
        break
                            }
        {$_ -like "*GrpUtilisateursDirection*"} {
        # Ajout des objets utilisateurs dans les groupes utilisateurs GrpUsers
        $DirectionUsers | ForEach {Add-ADGroupMember -Identity $group -Members $_}
        break                    
                            }
        {$_ -like "*GrpUtilisateursDirecteurdeBranche*"} {
        # Ajout des objets utilisateurs dans les groupes utilisateurs GrpUsers
        $BrancheAdmin | ForEach {Add-ADGroupMember -Identity $group -Members $_}
        break                    
                            }
        {$_ -like "*GrpUtilisateurs*"} {
        # Ajout des objets utilisateurs dans les groupes utilisateurs GrpUsers
        $AllUsers | ForEach {Add-ADGroupMember -Identity $group -Members $_}
        break                    
                            }
        #{$_ -like "*GrpComputers*"} {
            # Ajout des objets ordinateurs dans les groupes ordinateurs GrpComputers
         #   $LabComputers | ForEach {Add-ADGroupMember -Identity $group -Members $_}
        #                   }
        Default {Write-Warning "Groupe non reconnu : $group"}
    }
}