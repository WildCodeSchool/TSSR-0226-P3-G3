Import-Module ActiveDirectory
$users = Get-ADUser -Filter * -SearchBase "OU=Utilisateurs,OU=Pharmgreen,DC=pharmgreen,DC=lan"
$count = 1

foreach ($user in $users) {

    Write-Progress -Activity "Création de dossiers individuels" -Status "%effectué" -PercentComplete ($count/$users.Length*100)
    $path = "\\PG-0032-X00021\Individuel$\$($user.SamAccountName)"
    if (!(Test-Path $path)) {
        New-Item -Path $path -ItemType Directory -Force | Out-Null
        Write-Host "Le dossier $path a bien été créé" -ForegroundColor Green
    }
}