 ## Installation Superviseur Zabbix
------------------------------------------------------------------------------------------
## Sommaire
- [Installation du Serveur Zabbix](#Installation-du-Serveur-Zabbix)
- [Installation du SGBD :](#Installation-du-SGBD-:)
------------------------------------------------------------------------------------------
**Prérequis techniques :**

Un serveur avec une distribution Linux mis à jour ( Conteneur Debian dans notre cas) 
Un serveur web (Nginx dans notre cas)
Un SGBD (MariaDB/MySQL dans notre cas)
Une machine Windows 11 qui servira d'interface graphique une fois l'installation Zabbix terminée.
Le serveur doit avoir une adresse IP statique.

## Installation du Serveur Zabbix

- Installation du dépôt de Zabbix dans le système : (les données sont à mettre à jour en fonction de la version actuellement disponble, 8.4 dans notre cas sur debian 13)
```bash
wget https://repo.zabbix.com/zabbix/8.4/release/debian/pool/main/z/zabbix-release/zabbix-release_latest_8.4+debian13_all.deb
dpkg -i zabbix-release_latest_8.4+debian13_all.deb
```
- Mettre à jour les paquets :
```bash
apt update && apt upgrade -y
```
- Installation de Zabbix server, du frontend, et de l'agent :
```bash
apt install zabbix-server-mysql zabbix-frontend-php zabbix-nginx-conf zabbix-sql-scripts zabbix-agent
```
## Installation du SGBD :

```bash
apt install mariadb-server
```
