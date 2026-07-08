## Configuration de WAPT
------------------------------------------------------------------------------------------
## Sommaire

- [Finaliser la configuration de la partie serveur](#Finaliser-la-configuration-de-la-partie-serveur)
- [Configurer la console WAPT](#Configurer-la-console-WAPT)
- [FAQ](#FAQ)
------------------------------------------------------------------------------------------
## Finaliser la configuration de la partie serveur

- Installer l'outil Kerberos pour Linux 
```bash
apt-get install krb5-user msktutil
```
- Editer le fichier ```bash nano /etc/krb5.conf ``` en supprimant tout son contenu pour ne laisser que ça :
  ```bash
  [libdefaults]
  default_realm = PHARMGREEN.LAN
  dns_lookup_kdc = true
  dns_lookup_realm=false
  ```
- Dans l'OU qui stock les comptes de service (Transmission dans notre exemple) créer un compte utilisateur (par exemple "WaptAdmin") qui servira uniquement à connecter le serveur à l'AD
- Ensuite coté Serveur entrer :
```bash
kinit WaptAdmin
```
- Puis pour vérifier que l'ajout s'est bien passé
```bash
klist
```
- Ces commandes vont créer le http Keytab permettant au serveur WAPT de valider les demandes d'authentification
```bash
msktutil --server nomduserveur.votredomaine --precreate --host $(hostname) -b ou=Transmission,dc=pharmgreen,dc=lan --service HTTP --description "host account for wapt server" --enctypes 24 -N
msktutil --server nomduserveur.votredomaine --auto-update --keytab /etc/nginx/http-krb5.keytab --host $(hostname) -N
```
- Vérifier la présence de clé :
- <img width="575" height="209" alt="WAPT vérifier la présence de clé" src="https://github.com/user-attachments/assets/a2a73520-5b8d-4c0e-92b3-ede034594331" />

- Pour finir, sécuriser le fichier Keytab (en adaptant avec le bon chemin si besoin) :
```bash
chmod 640 /etc/nginx/http-krb5.keytab
chown root:www-data /etc/nginx/http-krb5.keytab
```
-------------------------------------------------------------

## Configurer la console WAPT

- La console WAPT doit être installée sur une machine différente du serveur WAPT, essentiellemnt une Windows 11 intégrée au domaine.
- Entrer le nomduserveur.nomdudomaine dans une barre de recherche pour accéder à la page web du serveur WAPT
- Dans le menu **WAPTSERVER**, cliquer sur **WAPTsetup**
- Lancer l'exécutable et accepter l'accord de licence
- Cocher l'option **Installer le service WAPT** et poursuivre
- Choisir **URLS WAPT statiques** et indiquez l'URL de votre serveur pour le dépôt et le serveur, en respectant le format "https://srv-wapt.pharmgreen.lan/wapt"
- Patienter pendant l'installation, puis cliquer sur **Terminer**
- La console WAPT maintenant accessible, la lancer (waptconsole.exe), indiquer le mot de passe admin de votre serveur WAPT et cliquer sur **OK**.
- En cliquant sur les outils la console doit s'afficher comme ça ( Si ce n'est pas au vert le chemin n'est pas bon) : 

<img width="676" height="275" alt="Correctif pour réparer le lien WAPT" src="https://github.com/user-attachments/assets/763d984e-5500-42e8-895d-8d508fab0a54" />

- Récupérer un ISO de Windows 11 sur le site de [Microsoft](https://www.microsoft.com/fr-ca/software-download/windows11?msockid=032839c81d9e6dbd3e492f6a1cf16c65)

- Créer le WinPE et l'uploader sur le serveur :
  - Dans la console WAPT, onglet Déploiement d'OS, cliquer sur **Upload WinPE** (une fenêtre s'ouvre automatiquement si aucun WinPE n'existe encore). **Configurer** :
  - Disposition clavier : fr
  - Certificat : sélectionner le certificat personnel
  - Pilotes réseau : pour Proxmox, le pilote réseau VirtIO ou E1000 de QEMU est généralement déjà inclus dans WinPE — si le boot PXE échoue plus tard, c'est ici qu'il faudra ajouter les pilotes réseau de la VM
  - Attendre que le fichier WinPE soit téléchargé sur l'ordinateur d'administration WAPT, puis sur le serveur WADS.

- Configurer le DHCP sur ton DC pour le boot PXE :
 - Dans PowerShell sur le serveur DHCP entrer les commandes suivantes
```powershell
$waptserver_ipaddress_tftp = "172.16.6.18"  # IP de srv-wapt
$url_waptserver = "http://srv-wapt.pharmgreen.lan"
$keymap = "fr"

Add-DhcpServerv4Class -Name "legacy_bios" -Type Vendor -Data "PXEClient:Arch:00000"
Add-DhcpServerv4Class -Name "iPXE" -Type User -Data "iPXE"

Set-DhcpServerv4OptionValue -OptionId 66 -Value "$waptserver_ipaddress_tftp"

Add-DhcpServerv4Policy -Name "wapt-ipxe-url-legacy" -Condition AND -UserClass EQ,iPXE
Set-DhcpServerv4OptionValue -PolicyName "wapt-ipxe-url-legacy" -OptionID 67 -Value "http://srv-wapt.pharmgreen.lan/ipxe/undionly.kpxe" # (Note : Tronqué sur l'image, complété par logique WAPT)

Add-DhcpServerv4Policy -Name "wapt-ipxe-url-uefi" -Condition AND -UserClass EQ,iPXE
Set-DhcpServerv4OptionValue -PolicyName "wapt-ipxe-url-uefi" -OptionID 67 -Value "$url_waptserve
```

- Dans l'onglet **Déploiement d'OS** cliquer sur **Importer une ISO** et sélectionner l'ISO Windows11 (Lors du téléchargement, le fichier ISO est signé avec le certificat sélectionné, puis téléchargé sur le serveur WADS.):

<img width="766" height="535" alt="WAPT chargement de l&#39;OS" src="https://github.com/user-attachments/assets/2fa87e90-6754-42eb-8ae8-b7b5d6cbfa86" />

- Maintenant il va s'agir de configurer le master qui va être déployé en cliquant sur le crayon dans le sous onglet de droite **Configuration**. Les Options sont multiples et doivent être entrées dans un fichier au format XML voici quelques données de base pour exemple :

<img width="662" height="190" alt="WAPT configuration de l&#39;OS 1" src="https://github.com/user-attachments/assets/ed0a48e3-4409-49c7-9186-c460a907b2fc" />
<img width="539" height="237" alt="WAPT configuration de l&#39;OS 2" src="https://github.com/user-attachments/assets/45277ad9-10ad-4657-a70b-25389d651d56" />

- Préparer la VM cible dans Proxmox :
   - Crée une nouvelle VM vide dans Proxmox (sans ISO attachée) :
   - BIOS : OVMF (UEFI) recommandé
   - VirtlO RNG
   - Réseau : E1000
   - Boot order : réseau en premier (net0 avant le disque)
   - Disque : 64 Go recommandé
- Enregistrer la VM et lancer le déploiement :
  - Démarre la VM, elle va booter en PXE, récupérer iPXE depuis le TFTP du serveur WAPT, puis charger WinPE.
  - Une fenêtre texte apparaît, saisir le nom à donner à cette machine.
  - Revenir sur la console WAPT,rafraîchir, la VM apparaît dans l'onglet Déploiement d'OS.
  - Puis :
      - Clic droit puis **Select a Configuration** => choisir la configuration XML
      - Clic droit puis **Change Drivers** => assigner les pilotes VirtIO si besoin
      - Clic droit puis **Prepare Djoin** => indiquer le DC, connecte-toi au domaine, sélectionner l'OU cible dans pharmgreen.lan WAPT
      - Clic droit puis **Start Deploy**
   
A ce moment là la VM va redémarrer, Windows11 va s'installer automatiquement, rejoindre le domaine et remonter dans l'inventaire WAPT

-------------------------------------------------------------
## FAQ
-------------------------------------------------------------
### En cas de problèmes avec l'encryption pendant le premier contacte entre le serveur WAPT et l'AD, suivre ce guide

Configurer la délégation spécifique sur l'OU Transmission : 
- Ouvrir **Utilisateurs et ordinateurs Active Directory**.
- S'assurer que le menu **Affichage > Fonctionnalités avancées** est bien coché.
- Faites un **clic droit** sur votre **OU Transmission** -> **Déléguer le contrôle**.
- Cliquer sur **Suivant**, ajoutez votre **utilisateur WaptAdmin**, puis cliquez sur **Suivant**.
- À l'étape **Tâches à déléguer**, cochez la **deuxième option : Créer une tâche personnalisée à déléguer** et faites **Suivant**.
- **Sélectionner Uniquement** les objets suivants dans le dossier et cochez tout en bas de la liste : **Objets Ordinateur** (Computer objects). Cochez également la case **Créer les objets sélectionnés dans ce dossier**. Cliquez sur **Suivant**.
- À l'étape des Autorisations, **décocher Général** et **cocher** uniquement la case : **Autorisations spécifiques aux propriétés** (Property-specific).
- Dans la très grande liste qui s'affiche en dessous, faites **défiler** vers le bas (l'ordre est alphabétique, cherchez à la lettre M) et **cocher** les deux cases suivantes :
  - [x] **Lire msDS-SupportedEncryptionTypes** (Read msDS-SupportedEncryptionTypes)
  - [x] **Écrire msDS-SupportedEncryptionTypes** (Write msDS-SupportedEncryptionTypes)
- Cliquer sur **Suivant** puis sur **Terminer**.

-------------------------------------------------------------
### En cas de problème pour récupérer les paquets sur le dépôt WAPT (version pas à jour sur le tutoriel par exemple)

Il suffit de remplir le fichier ```bash /opt/wapt/wapt-get.ini ``` pour qu'il ressemble à ceci : 
```bash
[global]
repo_url=https://wapt.tranquil.it/wapt
wapt_server=https://localhost
```
Pointer temporairement sur le dépôt officiel de Tranquil IT va permettre à votre serveur de le télécharger directement sur Internet.
