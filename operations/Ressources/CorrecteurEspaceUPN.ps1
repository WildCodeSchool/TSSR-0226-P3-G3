Get-ADUser -Filter * -SearchBase "OU=Utilisateurs,OU=Pharmgreen,DC=pharmgreen,DC=lan" -Properties UserPrincipalName |
Where-Object {$_.UserPrincipalName -match " "} | 
ForEach-Object { 
$newUPN = $_.UserPrincipalName -replace " ", "" 
Set-ADUser $_ -UserPrincipalName $newUPN 
Write-Host "Corrigé : $($_.UserPrincipalName) -> $newUPN"
}