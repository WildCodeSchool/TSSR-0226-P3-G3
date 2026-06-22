Get-ADUser -Filter * -SearchBase "OU=Utilisateurs,OU=Pharmgreen,DC=pharmgreen,DC=lan" -Properties mail |
Where-Object {$_.mail -match " "} | 
ForEach-Object { 
$newMail = $_.mail -replace " ", "" 
Set-ADUser $_ -EmailAddress $newMail 
Write-Host "Corrigé : $($_.mail) -> $newMail"
}