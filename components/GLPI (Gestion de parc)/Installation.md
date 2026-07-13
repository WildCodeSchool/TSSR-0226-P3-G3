
# Installation de GLPI

---

# Objectif

Installer une solution de gestion de parc informatique (GLPI) permettant :

- la gestion des utilisateurs ;
- la gestion des équipements ;
- la gestion des tickets ;
- la gestion des logiciels ;
- la gestion de l'inventaire automatique ;
- l'authentification via Active Directory.

---

# Prérequis

## Machine virtuelle

| Élément    | Valeur          |
| ---------- | --------------- |
| OS         | Debian 13       |
| Nom        | srv-glpi        |
| Adresse IP | XXX.XXX.XXX.XXX |
| Domaine    | pharmgreen.lan  |
| RAM        | 4 Go minimum    |
| CPU        | 2 vCPU          |
| Disque     | 40 Go           |


Le serveur doit disposer :

- d'une IP fixe

- d'un accès Internet

- d'une résolution DNS

- d'un accès au contrôleur de domaine

- d'un accès au serveur de base de données (local)

Nous allons utiliser une machine sous **Debian 13** et nous allons installer dessus **Apache2, PHP 8.4 ainsi que MariaDB**.

---

## Installer le socle LAMP

1. Nous allons commencer par l'installation par une **mise à jour des paquets sur la machine Debian 13**.

PS: Le compte étant loguer en root, il n'y a pas besoin de taper la commande sudo.

Dans le terminal taper cette commande : 
````
 apt-get update && sudo apt-get upgrade
`````

2. L'étape suivante consiste à installer les paquets du socle LAMP : **Linux Apache2 MariaDB PHP**.

Installer ces trois paquet avec la commande suivante:

```
 apt-get install apache2 php8.4-fpm mariadb-server
```

Puis, nous allons installer toutes les extensions nécessaires au bon fonctionnement de GLPI et qui ne sont pas intégrées au paquet **`php8.4-common`**.

```
 apt install php8.4-{curl,gd,intl,mysql,zip,bcmath,mbstring,xml,bz2}
```

Puis nous allons associer GLPI avec un annuaire LDAP comme l'Active Directory, vous devez installer l'extension LDAP de PHP:
```
 apt install php8.4-ldap
```

L'installation d' Apache2, MariaDB, PHP et un ensemble d'extensions.

---

## Préparer une base de données pour GLPI

Nous allons préparer MariaDB pour qu'il puisse héberger la base de données de GLPI. La première action à effectuer, c'est d'exécuter la commande ci-dessous pour **effectuer le minimum syndical en matière de sécurisation de MariaDB**.

```
mariadb-secure-installation
```

Répondre `Y` à toutes les questions qui seront posées pendant l'initialisation.

Suite à la question `Change the root password?` il faudra entrer le mot de passe de la base de données.

Ensuite nous allons nous connecter à la base de données :

```
mysql -u root -p
```

Puis, nous allons exécuter les **requêtes SQL** ci-dessous pour **créer la base de données `glpidb`** ainsi que **l'utilisateur `glpi_adm`** avec le **mot de passe "MotDePasseRobuste"** (que vous personnalisez, bien sûr). Cet utilisateur aura tous les droits sur cette base de données (et uniquement sur celle-ci).

```
1 CREATE DATABASE glpidb CHARACTER SET utf8 COLLATE utf8_bin;
2 grant all privileges on glpidb.* to glpi-adm@localhost identified by 'motDePasse';
3 flush privileges;
4 quit
```

---


## Télécharger GLPI via GitHub

On récupère la source :

```
wget https://github.com/glpi-project/glpi/releases/download/10.0.10/glpi-10.0.10.tgz
```

Mettre le contenu téléchargé dans un autre emplacement :
Ici nous allons lier ce serveur Glpi à notre domaine pharmgreen.lan

```
 mkdir /var/www/glpi.pharmgreen.lan
 tar -xzvf glpi-10.0.10.tgz
 cp -R glpi/* /var/www/glpi.pharmgreen.lan/
```

On va modifier les droits :

```
 chown -R www-data:www-data /var/www/glpi.pharmgreen.lan/
 chmod -R 775 /var/www/glpi.pharmgreen.lan/
```
---

## Configuration du site


```
  nano /etc/apache2/sites-available/000-default.conf
```

on va modifier le "documentroot" du site :  

DocumentRoot /var/www/glpi

---


## Configuration de PHP

On va tout d'abord éditer le fichier `php.ini` qui est sous `/etc/php/8.4/apache2/`  
Ensuite on va modifier les paramètres suivants :

- memory_limit = `64M`
- file_uploads = `on`
- max_execution_time = `600`
- session.auto_start = `0`
- session.use_trans_sid = `0`

Fermer le fichier et redémarrer la machine.

---


# Configuration Apache

Créer le VirtualHost.

```bash
nano /etc/apache2/sites-available/glpi.conf
```

Exemple.

```apache
<VirtualHost *:80>

ServerName glpi.lab.lan

DocumentRoot /var/www/glpi/public

<Directory /var/www/glpi/public>

Require all granted

AllowOverride All

</Directory>

</VirtualHost>
```

Activer le site.

```bash
a2ensite glpi.conf
```

Activer les modules.

```bash
a2enmod rewrite

a2enmod headers
```

Redémarrer Apache.

```bash
systemctl restart apache2
```

---

# Installation via navigateur

Accéder à :

```
http://glpi.pharmgreen.lan
```

Suivre l'assistant :

- langue française ;
- accepter la licence ;
- installation ;
- connexion à MariaDB ;
- sélectionner la base glpi ;
- terminer l'installation.

---

# Authentification Active Directory

Configurer LDAP.

Paramètres principaux :

- Serveur LDAP
- Domaine lab.lan
- Base DN
- Compte de lecture LDAP
- Synchronisation automatique des utilisateurs

Les utilisateurs Active Directory peuvent alors se connecter directement sur GLPI.

---

# Comptes par défaut

Après installation :

Utilisateur :

```
glpi
```

Mot de passe :

```
glpi
```

Ces comptes sont modifiés ou supprimés dès la première connexion.

---

# Vérifications

Vérifier :

- Apache actif

```bash
systemctl status apache2
```

- MariaDB actif

```bash
systemctl status mariadb
```

- Accès HTTPS

```
https://glpi.lab.lan
```

- Connexion LDAP

Importer un utilisateur Active Directory.

- Inventaire

Vérifier qu'un poste apparaît dans GLPI.

---

# Résultat attendu

Le serveur GLPI est opérationnel.

Les utilisateurs Active Directory peuvent s'authentifier.

Les postes clients remontent automatiquement leur inventaire.


