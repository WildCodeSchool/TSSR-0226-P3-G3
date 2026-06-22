powershell$user = Get-ADUser $env:USERNAME -Properties Department, Office
New-PSDrive -Name J -PSProvider FileSystem -Root "\\PG-00032-X00021\Service$$($user.Office)" -Persist
New-PSDrive -Name K -PSProvider FileSystem -Root "\\PG-00032-X00021\Departement$$($user.Department)" -Persist