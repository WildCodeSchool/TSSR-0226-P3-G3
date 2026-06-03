# Liste logiciels a installer sur le PC d'administration Windows 11

## Administration des serveurs Windows

## 1. RSAT => Gestion de consoles serveurs distant (AD, DNS, DHCP, etc.)

outils AD DS et service LDS, gestionnaire de serveur, outils du serveur DNS, outils du serveur DHCP, outils de service de fichiers, outils des services Bureau a Distance, outils des services de certificats Active Directory.

=> Pour installer les fonctionnalités RSAT, suivre le chemin suivant : 

**Paramètres -> Applications -> Fonctionnalités facultatives -> Afficher les fonctionnalités ->
Rechercher RSAT**



![[Installer-RSAT-GUI-3.png]]


![[Installer-RSAT-GUI -4.png]]


---
## 2.  Windows RDP => Prise de main à distance.

### Activation de RDP sur Windows 11

# -  En graphique

Pour activer le service RDP (Remote Desktop Product) suivre le chemin a parcourir suivant :

Cliquer su démarrer -> Paramètres -> Système -> Bureau à distance -> Activer.

![[Activer-RDP-Graphique-1.png]]

---
# - En ligne de commande via PowerShell

Ouvrir Powers avec les privilèges administrateur et taper la commande suivante :

````
Enable-PSRemoting -Force
`````


![[Activer-RDP-Powershell-2.png]]


---
## 3. Remote PowerShell => CLI à distance => Activation de WinRM


Pour vérifier si le service WinRM existe ou non sur votre machine, saisissez la commande PowerShell suivante :

````
Get-Service WinRM
````

![[Install-WinRM-Status-1.png]]

#### Configuration de WinRM

Pour commencer la configuration, nous allons activer le _PSRemoting via WinRM_.
Pour cela, ouvrez une console PowerShell en tant qu'Administrateur puis saisissez la commande suivante :

````
Enable-PSRemoting
````

![[Install-WinRM-config-2.png]]

