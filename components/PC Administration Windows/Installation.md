# Liste logiciels a installer sur le PC d'administration Windows 11

### Administration des serveurs Windows

1. RSAT => Gestion de consoles serveurs distant (AD, DNS, DHCP, etc.)
	- outils AD DS et service LDS, gestionnaire de serveur, outils du serveur DNS, outils du serveur DHCP, outils de service de fichiers, outils des services Bureau a Distance, outils des services de certificats Active Directory.

 ##### Pour installer les fonctionnalités RSAT, suivre le chemin suivant : 

**Paramètres -> Applications -> Fonctionnalités facultatives -> Afficher les fonctionnalités ->
Rechercher RSAT**


![[Installer RSAT GUI-3.png]](


![[Installer RSAT GUI -4.png]](


2. Windows RDP => Prise de main à distance.

### Activation de RDP sur Windows 11

# -  En graphique


Pour activer le service RDP (Remote Desktop Product) suivre le chemin a parcourir suivant :

Cliquer su démarrer -> Paramètres -> Système -> Bureau à distance -> Activer.

![[Activer bureau a distance RDP.png]](

# - En ligne de commande via PowerShell

Ouvrir Powers avec les privilèges administrateur et taper la commande suivante :

````
Enable-PSRemoting -Force
`````

![[Activer Remote Powershell-1.png]](

