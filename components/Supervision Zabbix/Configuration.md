## **Sommaire**
- [Configuration de Zabbix](#Configuration-de-Zabbix)
- [Listing des OU et des sous-OU](#Listing-des-OU-et-des-sous-OU)
- [Listing des Groupes de Sécurité](#Listing-des-Groupes-de-Sécurité)

# Configuration de Zabbix

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
