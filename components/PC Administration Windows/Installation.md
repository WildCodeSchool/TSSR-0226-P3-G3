# Liste logiciels a installer sur le PC d'administration Windows 11



| Administration des serveurs windows   | Logiciels                                                  |
| ------------------------------------- | ---------------------------------------------------------- |
| RSAT                                  | Gestion de consoles serveurs distant (AD, DNS, DHCP, etc.) |
| Windows RDP                           | Prise de main à distance                                   |
| Remote Powershell                     | CLI à distance - Activation de WinRM                       |
| Serveur RDP                           | Portail RDP - Activation du Bureau à distance              |
| Suite Sysinternals                    | Suite d'outils - Utilitaires de résolution des problèmes   |
| **Administration des serveurs Linux** |                                                            |
| Git Bash                              | Shell bash et SSH/SCP                                      |
| Putty                                 | Connexion SSH                                              |
| Filezilla                             | Transfert de fichiers                                      |
| WSL                                   | Intégration de Linux dans Windows                          |
| VNC                                   | Prise en main à distance GUI                               |







## i. Administration des serveurs Windows

## 1. RSAT => Gestion de consoles serveurs distant (AD, DNS, DHCP, etc.)

outils AD DS et service LDS, gestionnaire de serveur, outils du serveur DNS, outils du serveur DHCP, outils de service de fichiers, outils des services Bureau a Distance, outils des services de certificats Active Directory.

=> Pour installer les fonctionnalités RSAT, suivre le chemin suivant : 

**Paramètres -> Applications -> Fonctionnalités facultatives -> Afficher les fonctionnalités ->
Rechercher RSAT**



![[Installer-RSAT-GUI-3.png]](


![[Installer-RSAT-GUI -4.png]](


---
## 2.  Windows RDP => Prise de main à distance.

### Activation de RDP sur Windows 11

#### -  En graphique

Pour activer le service RDP (Remote Desktop Product) suivre le chemin a parcourir suivant :

Cliquer su démarrer -> Paramètres -> Système -> Bureau à distance -> Activer.

![[Activer-RDP-Graphique-1.png]](

---
#### - En ligne de commande via PowerShell

Ouvrir Powers avec les privilèges administrateur et taper la commande suivante :

````
Enable-PSRemoting -Force
`````


![[Activer-RDP-Powershell-2.png]](


---
## 3. Remote PowerShell => CLI à distance => Activation de WinRM


Pour vérifier si le service WinRM existe ou non sur votre machine, saisissez la commande PowerShell suivante :

````
Get-Service WinRM
````

![[Install-WinRM-Status-1.png]](

#### Configuration de WinRM

Pour commencer la configuration, nous allons activer le _PSRemoting via WinRM_.
Pour cela, ouvrez une console PowerShell en tant qu'Administrateur puis saisissez la commande suivante :

````
Enable-PSRemoting
````

![[Install-WinRM-config-2.png]](

---

## 4. Serveur RDP => Portail RDP

- #### Activer le Bureau à distance sous Windows 11

Sur Windows 11, l'accès RDP s'active dans les "**Paramètres**" du système en suivant le chemin suivant : **Paramètres > Système > Bureau à distance**.

![[Activer-RDP-Graphique-1 1.png]](


---

## 5. Suite logiciels Sysinternals => Suite d'outils

Les Utilitaires de résolution des problèmes de Sysinternals ont été regroupés dans une seule suite d’outils. Ce fichier contient les outils de résolution des problèmes individuels et des fichiers d’aide.

Il est possible de télécharger Sysinternals Suite a partir du Microsoft Store

![[Install-SysinternalsSuite-WindowsStore-1.png]](

---



# ii. Administration des serveurs Linux

## 1. Git Bash /  => Shell Bash et SSH/SCP


Ouvrir le navigateur internet et se rendre sur le site de Git afin de télécharger la version git Bash pour Windows 
"https://git-scm.com/install/windows"

![[Install-GitBash-Windows11-1.png]](

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

---


## 2. Putty => Connexion SSH

## Installation PuTTY
<span id="Installation-PuTTY"></span>

**Prérequis techniques :**
- Système d'exploitation Windows 64 bits
- *Une version pour système 32 bits est à disposition sur le site internet*

Vous pouvez télécharger la dernière version de PuTTY directement depuis le [Miscrosoft Store](https://apps.microsoft.com/detail/xpfnzksklbp7rj?hl=fr-FR&gl=FR) ou télécharger l'installeur depuis [le site officiel de Putty](https://putty.org/index.html)


Si vous utilisez Microsoft Store vous pouvez suivre l'installation à partir de l'étape 3, sinon voici la procédure :

**1** -  Sur la page d'accueil cliquer sur "Download PuTTY"

**2** -  Dans la rubrique "Package Files" cliquer sur le premier lien "putty-64bit-0.83-installer.msi" afin de télécharger l'installeur 

**3** -  Lancer l'installation en double-cliquant sur le fichier téléchargé, cliquer sur "Next" sur la première page

**4** -  Sélectionner le chemin d'installation du logiciel (Ne modifier qu'en cas d'installation particulière)

**5** -  Pour ajouter un raccourci sur le bureau, dans la page "Product Features" cliquer sur le second titre "Add shortcut to PuTTY on the desktop" et sélectionner "Will be installed on local hard drive"

**6** -  Cliquer sur "Yes" afin d'accepter l'installation du logiciel

**7** -  Cliquer sur "Finish" afin de terminer l'installation, penser à décocher "view Readme File" pour ne pas déclencher l'ouverture du manuel d'utilisation - si non souhaité


---

### 3. FileZilla => Transfert de fichiers

1. [Téléchargez le fichier](https://filezilla-project.org/download.php?show_all=1) Filezilla FTP Client Installer pour votre système d'exploitation Windows.
  
2. Double-cliquez pour exécuter le fichier d'installation FTP de FileZilla. Il affichera un avertissement de sécurité. Veuillez le lire et l'accepter ou cliquez sur l'option Exécuter.

3. Le client FileZilla affichera un contrat de licence. Veuillez le lire et accepter l'accord pour installer le client FileZilla sur votre PC.
 4. Cliquez sur le bouton Suivant jusqu'à ce qu'il affiche le bouton Installer. Cliquez ensuite dessus.
5. L'installation peut prendre quelques secondes mais dépendra de votre PC. Une fois terminé, cliquez sur le bouton Terminer.

Félicitations. Vous avez installé avec succès le client FileZilla sur votre système d'exploitation Windows. Vous pouvez maintenant commencer à l'utiliser.




### 4. WSL (Windows Subsystem for Linux) => Intégration de Linux dans Windows

## Conditions préalables

Vous devez exécuter Windows 10 version 2004 et ultérieure ou Windows 11 pour utiliser les commandes ci-dessous.

## Installer la commande WSL

Vous pouvez maintenant installer tout ce dont vous avez besoin pour exécuter WSL avec une seule commande. Ouvrez PowerShell en mode **Administrateur** en cliquant avec le bouton droit et en sélectionnant « Exécuter en tant qu’administrateur », entrez la commande wsl --install, puis redémarrez votre ordinateur.

PowerShell

```
wsl --install
```

Cette commande active les fonctionnalités nécessaires pour exécuter WSL et installer la distribution Ubuntu de Linux.

## installer votre distribution Linux de votre choix

1. Ouvrez le [microsoft Store](ms-windows-store://collection?CollectionId=LinuxDistros) et sélectionnez votre distribution Linux préférée.
2. Ici Je selectionne Ubuntu dans la barre de recherche et lance l'installaion.
3. Une fois l'installation terminée, aller dans "démarrer", lancer Ubuntu.
4. Configurer le nom d'utilisateur et le mot de passe et valider.

![[Windows-Ubuntu-lancement.png]](Windows-Ubuntu-lancement.png)

## Mettre à jour et mettre à niveau des packages

Nous vous recommandons de mettre régulièrement à jour et à niveau vos packages à l’aide du gestionnaire de package préféré pour la distribution. Pour Ubuntu, utilisez la commande :

Bash

```
sudo apt update && sudo apt upgrade
```

Windows ne met pas automatiquement à jour ou à niveau vos distributions Linux. Il s’agit d’une tâche que la plupart des utilisateurs Linux préfèrent contrôler eux-mêmes.


## Modifier la distribution Linux par défaut installée

Par défaut, la distribution Linux installée sera Ubuntu. Cela peut être modifié à l’aide de l’indicateur `-d` .

- Pour modifier la distribution installée, entrez :

```
wsl.exe --install -d [Distro]
```

 
Remplacez `[Distro]` par le nom de la distribution que vous souhaitez installer.
 
- Pour afficher la liste des distributions Linux disponibles disponibles à télécharger via le magasin en ligne, entrez :

```
wsl.exe --list --online
```

---

### 5. VNC (et dérivés...) => Prise en main à distance GUI

Utilisation ici du logiciel "TightVNC"

TightVNC est disponible au téléchargement depuis l’adresse suivante : 

[https://www.tightvnc.com/download.php](https://www.tightvnc.com/download.php).


Lancer l'installeur téléchargé.
#### Etape 1

Le programme d’installation propose **3 options** classiques :

- L’installation **typique**, tout se passe de manière automatique avec les composants et leurs valeurs par défaut (partie serveur, partie cliente, mot de passe, emplacement sur le disque, etc.) ;
    
- L’installation **personnalisée,** ici le programme demande confirmation et de chaque étape ;
    
- L’installation **complète,** identique à la première option, mais en incluant tous les composants disponibles.

Dans notre cas, je choisi de passer par **l’installation personnalisée**.

il s’agit du poste avec lequel nous allons  **prendre le contrôle** à distance d’un autre, il faut installer TightVNC **Client/Viewer.**

#### Etape 2

Le programme d’installer propose ensuite la configuration de **4 options distinctes** :

- **L’association des fichiers avec une extension .vnc** est pratique, vous pouvez garder cette option ;
    
- **Déclarer TightVNC en tant que service** va dépendre de vos contraintes de sécurité. Dans le cas où vous souhaitez démarrer les programmes TightVNC de manière automatique avec le poste, il faut cocher cette option. Je reviendrai plus en détail sur cet aspect dans le chapitre suivant ;
    
- L’option suivante autorise les programmes TightVNC à exécuter la séquence « **Ctrl-Alt-Del** » bien connue permettant notamment d’envoyer un ordre de redémarrage au système d’exploitation. En la cochant, vous autorisez l’utilisateur ayant le contrôle du poste à effectuer cette opération ;
    
- Enfin, dernière option, il s’agit d’ajouter une règle dans le **Firewall** Windows afin de **laisser passer les flux réseaux** concernant TightVNC. Je valide cette option.

#### Etape 3

Le panneau suivant est important car il permet de **sécuriser** l’installation de TightVNC sur le poste. Il s’agit ici de définir **deux mots de passe différents** :

- **Le premier** mot de passe va permettre de **sécuriser la prise de contrôle** à distance sur ce poste. **Chaque client** VNC souhaitant s’y connecter devra connaître ce mot de passe ;
    
- **Le second** permet de **sécuriser le comportement et la configuration** de TighVNC sur ce poste. **Chaque modification** dans la configuration ou l’exécution du serveur TightVNC devra être confirmée avec ce mot de passe.

#### Etape 4

 L’installation se termine ici.

---
