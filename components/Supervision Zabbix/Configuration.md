## **Sommaire**
- [Configuration de Zabbix](#Configuration-de-Zabbix)
- [Configuration de Zabbix depuis l'interface Web](#Configuration-de-Zabbix-depuis-l'interface-Web)
- [Installation et configuration de l'Agent Zabbix](#Installation-et-configuration-de-l'Agent-Zabbix)
- [Ajout d'un hôte et création d'un groupe](#Ajout-d'un-hôte-et-création-d'un-groupe)

# Configuration du serveur Zabbix

- Création et configuration de la base de données : 
```bash
mysql -uroot -p
password
mysql> create database zabbix character set utf8mb4 collate utf8mb4_bin;
mysql> create user nomutilisateur@localhost identified by 'motdepasse';
mysql> grant all privileges on zabbix.* to nomutilisateur@localhost;
mysql> set global log_bin_trust_function_creators = 1;
mysql> quit;
```
- Importation du schéma et des données :
```bash
zcat /usr/share/zabbix/sql-scripts/mysql/server.sql.gz | mysql --default-character-set=utf8mb4 -uzabbix -p zabbix
```
- Désactivation de la possibilité de modifier la configuration de la BD par des acteurs malveillants :
```bash
mysql -uroot -p
password
mysql> set global log_bin_trust_function_creators = 0;
mysql> quit;
```
- Edition du fichier de configuration de la BD du serveur Zabbix dans /etc/zabbix/zabbix_server.conf :
```bash
DBPassword=password
```
- Configuration de PHP pour accéder au frontend dans /etc/zabbix/nginx.conf :
```bash
listen 8080;
server_name <ici tu rentreras l'adresse IPv4 de ta machine>;
```
- Démarrage du server et des processus de l'agent :
```bash
systemctl restart zabbix-server zabbix-agent nginx php8.2-fpm
systemctl enable zabbix-server zabbix-agent nginx php8.2-fpm
```

# Configuration de Zabbix depuis l'interface Web

- Depuis un client entrer l'adresse du serveur dans un navigateur en ajoutant le port d'écoute :
X.X.X.X:8080

- A partir des boutons Next step, renseigner entre autres :
 - Le mot de passe de la base de donnée
 - Le nom du serveur Zabbix
 - Le fuseau horaire du serveur

# Installation et configuration de l'Agent Zabbix

- Télécharger l'agent Zabbix depuis le client Windows à l'adresse suivante : [Lien de téléchargement agent Zabbix](https://www.zabbix.com/download_agents)

- Lancer l'installation de l'agent sur ton client Windows.

- Durant l'installation, préciser l'adresse IP du serveur Zabbix dans le champ _Zabbix server IP/DNS:_

# Ajout d'un hôte et création d'un groupe

- Pour la 1ère connexion sur la WUI utiliser les identifiants par défaut :
  - Utilisateur : Admin
  - Mot de passe : zabbix

- Création de groupes d'hôtes :
  - Dans le menu _Data collection/Host groups_ :
   - Créer un groupe d'hôtes sous Windows en cliquant sur le bouton _Create host group_.
   - Appeller ce groupe _Windows hosts_.

- Ajout des hôtes :
  - Dans le menu Data _collection/Hosts_ :
   - Ajouter le client Windows en cliquant sur le bouton _Create host_.
   - Ajouter le dans le groupe créé précédemment.
   - Ajouter l'interface _Agent_.
   - Renseigner l'adresse IP du client.
