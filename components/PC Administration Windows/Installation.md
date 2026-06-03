# Liste logiciels a installer sur le PC d'administration Windows 11

## i. Administration des serveurs Windows

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

#### -  En graphique

Pour activer le service RDP (Remote Desktop Product) suivre le chemin a parcourir suivant :

Cliquer su démarrer -> Paramètres -> Système -> Bureau à distance -> Activer.

![[Activer-RDP-Graphique-1.png]]

---
#### - En ligne de commande via PowerShell

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

---


# ii. Administration des serveurs Linux

## 1. Git Bash /  => Shell Bash et SSH/SCP


Ouvrir le navigateur internet et se rendre sur le site de Git afin de télécharger la version git Bash pour Windows 
"https://git-scm.com/install/windows"

![[Install-GitBash-Windows11-1.png]](components/PC Administration Windows/Ressources/Install-GitBash-Windows11-1.png)

Lancer le téléchargement et ensuite lancer l'installeur.

Premiere etape, Accepte la licence d'utilisation.

Puis, coche les options suivantes :

- Windows Explorer Integration
    - Git Bash Here
- Git LFS (Large File Support)
- Associate .git* configuration files with the default text editor
- Associate .sh files to be run with Bash
- Add a Git Bash Profile to Windows Terminal
- Scalar (Git add-on to manage large-scale repositories)

Esnuite, Choisis : "_Use Visual Studio Code as Git's default editor_".

=> Cliquer sur le lien et télécharger le logiciel via la page internet de l'éditeur du logiciel.

Une fois téléchargé, lancer l'installation du logiciel et suivre les étapes d'installation.


Puis revenir sur Git Bsah, choisir l'option "Override the default branch name for new repositories" en mettant comme nom de branche par défaut "main"

Ensuite , Coche l'option recommandée "_Git from the command line and also from 3rd-party software_"

Puis, Coche l'option "_Use bundled OpenSSH_".

Ensuite, Coche l'option "_Use the OpenSSL library_".

Puis, Coche l'option "_Checkout as-is, commit Unix-style line endings_".

Ensuite, Coche l'option "_Use MinTTY (the default terminal of MSYS2)_".

Puis, Garde l'option par défaut ("_Default (fast-forward or merge)_").

Ensuite, Sélectionne "_None_", il n'est pas utile d'installer le Git Credential Manager car tu verras comment mettre en place l'authentification par clé SSH par la suite.

Puis, Coche les deux options :

- Enable file system caching
- Enable symbolic links

Puis, Coche "_Enable experimental support for pseudo consoles_". Tu peux aussi si tu le souhaites cocher la seconde option "_Enable experimental built-in fyle system monitor_".

Il est très important à ce stade de bien cocher la première option, sinon tu risques d'avoir des problèmes pour utiliser certaines fonctionnalités et devoir préfixer la majorité de tes commandes par winpty. En activant le support expérimental, tu pourras utiliser normalement le terminal comme sur un système Unix.


Et enfin cliquer sur "install".



CONFIGURATION de Git Bash post-installation

Dans ton terminal, vérifie ton installation en tapant **git --version**

Puis dans ton terminal, tu vas renseigner ton nom d'utilisateur et ton email (les mêmes que sur la plateforme github)

1. Renseigne ton nom d'utilisateur: `git config --global user.name "FIRST_NAME LAST_NAME"`
2. Renseigne ton email : `git config --global user.email "MY_NAME@example.com"`
3. Ajoute aussi cette configuration (c'est un peu tôt pour t'expliquer en détail mais si tu ne le fais pas git va te poser la question quand tu essaieras de récupérer du code distant) `git config --global pull.rebase false`
4. Enfin, termine par cette dernière configuration, qui configure git pour utiliser le nom "main" et non plus "master" comme branche par défaut, ce qui te facilitera la vie quand tu vas utiliser Github (qui lui utilise le nom "main") `git config --global init.defaultBranch main`



