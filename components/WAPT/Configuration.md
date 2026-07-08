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
Pour finir, sécuriser le fichier Keytab (en adaptant avec le bon chemin si besoin) :
```bash
chmod 640 /etc/nginx/http-krb5.keytab
chown root:www-data /etc/nginx/http-krb5.keytab
```
-------------------------------------------------------------

## Configurer la console WAPT


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
