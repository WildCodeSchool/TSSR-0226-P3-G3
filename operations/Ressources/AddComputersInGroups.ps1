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
$AllComputers = Get-ADComputer -Filter * -SearchBase "OU=Ordinateurs,OU=Pharmgreen,$DomainDN" | Select-Object -ExpandProperty SamAccountName
$AdminComputers = Get-ADComputer -Filter * -SearchBase "OU=T0,OU=SystemesInformation,OU=Ordinateurs,OU=Pharmgreen,$DomainDN" -SearchScope OneLevel | Select-Object -ExpandProperty SamAccountName
$DirectionComputers = Get-ADComputer -Filter * -SearchBase "OU=Direction,OU=DirectionGenerale,OU=Ordinateurs,OU=Pharmgreen,$DomainDN" -SearchScope OneLevel | Select-Object -ExpandProperty SamAccountName
$BrancheAdmin = Get-ADComputer -Filter * -SearchBase "OU=DirecteurdeBranche,OU=DirectionGenerale,OU=Ordinateurs,OU=Pharmgreen,$DomainDN" -SearchScope OneLevel | Select-Object -ExpandProperty SamAccountName
# $LabComputers = Get-ADComputer -Filter * -SearchBase "OU=Ordinateurs,$DomainDN" | Select-Object -ExpandProperty SamAccountName

# Parcourir les groupes
Foreach ($Group in $Groups.Name)
{
    Switch ($group)
    {
        {$_ -like "*GrpOrdinateursAdmin*"} {
        # Ajout des objets Ordinateurs dans les groupes Ordinateurs GrpComputers Admin
        $AdminComputers | ForEach {Add-ADGroupMember -Identity $group -Members $_}
        break
                            }
        {$_ -like "*GrpOrdinateursDirection*"} {
        # Ajout des objets Ordinateurs dans les groupes Ordinateurs GrpComputers Direction
        $DirectionComputers | ForEach {Add-ADGroupMember -Identity $group -Members $_}
        break                    
                            }
        {$_ -like "*GrpOrdinateursDirecteurdeBranche*"} {
        # Ajout des objets Ordinateurs dans les groupes Ordinateurs GrpComputers DirecteurDeBranche
        $BrancheAdmin | ForEach {Add-ADGroupMember -Identity $group -Members $_}
        break                    
                            }
        {$_ -like "*GrpOrdinateurs*"} {
        # Ajout des objets Ordinateurs dans les groupes Ordinateurs GrpComputers ALL
        $AllComputers | ForEach {Add-ADGroupMember -Identity $group -Members $_}
        break                    
                            }
        #{$_ -like "*GrpComputers*"} {
            # Ajout des objets ordinateurs dans les groupes ordinateurs GrpComputers
         #   $LabComputers | ForEach {Add-ADGroupMember -Identity $group -Members $_}
        #                   }
        Default {Write-Warning "Groupe non reconnu : $group"}
    }
}