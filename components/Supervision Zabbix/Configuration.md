## **Sommaire**
- [Configuration de Zabbix](#Configuration-de-Zabbix)
- [Configuration de Zabbix depuis une interface Web](#Configuration-de-Zabbix-depuis-une-interface-Web)
- [Installation et configuration de l'Agent Zabbix](#Installation-et-configuration-de-lAgent-Zabbix)
- [Ajout d'un hôte et création d'un groupe](#Ajout-dun-hôte-et-création-dun-groupe)
- [Déploiement de Zabbix par GPO](#Déploiement-de-Zabbix-par-GPO)

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
---------------------------------------------------------------------

# Configuration de Zabbix depuis une interface Web

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
-------------------------------------------------------------
 
# Déploiement de Zabbix par GPO

- Téléchargez **l'agent Zabbix** depuis le site officiel [Zabbix](https://www.zabbix.com/fr/download_agents) et déplacez le fichier .msi dans un dossier partagé sur le réseau.
- Créez un groupe d'hôtes dans la configuration de Zabbix.
- Ajoutez un groupe pour les serveurs Windows et activez l'auto-registration.

<img width="1196" height="498" alt="Zabbix scan pc" src="https://github.com/user-attachments/assets/946d117b-32b3-41b7-a3b8-ed2ee7bb2346" />
<img width="1184" height="499" alt="Zabbix scan pc 2" src="https://github.com/user-attachments/assets/95aa1524-7ea9-443f-9ad1-40b2add4649b" />

- Créez un [script](https://github.com/WildCodeSchool/TSSR-0226-P3-G3/blob/main/operations/Ressources/ScriptZabbix.ps1) à joindre dans le dossier Zabbix du partage avec le _fichier d'installation msi_
- Créez une **GPO Ordinateur**, l'éditer dans **policies** -> **Windows Settings** -> **Scripts** -> dans l'onglet powershell entrer le chemin du script sur **le disque partagé** pour que les machines clientes puisse le récupérer
<img width="796" height="565" alt="Zabbix scan pc 3" src="https://github.com/user-attachments/assets/0613b70b-7d6a-4963-b648-023eba259041" />

