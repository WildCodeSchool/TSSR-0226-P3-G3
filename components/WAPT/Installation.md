 ## Installation d'une Solution de Déploiement de Masse
------------------------------------------------------------------------------------------
## Sommaire
- [Installation de WAPT](#Installation-de-WAPT)
------------------------------------------------------------------------------------------
**Prérequis techniques :**

- Avoir une Debian13 à jour.
- Le serveur doit avoir une adresse IP statique.
- Le serveur doit faire parti d'un domaine et est sur le meme fuseau que le DC.
- Le DNS du serveur est configuré.
- Notre serveur hébergeant WAPT s'appellera "srv-wapt".

/!\ IMPORTANT /!\ Pour pouvoir déployer des OS automatiquement il est impératif de disposer d'une clé d'essaie WAPT ou de la version Premium du logiciel

-----------------------------------------------------------------------------------------

# Installation de WAPT

- Ajouter le dépôt de l'éditeur **Tranquil IT** de façon à récupérer les paquets d'installation de WAPT.

```bash
apt install apt-transport-https lsb-release gnupg wget -y
wget -O - https://wapt.tranquil.it/$(lsb_release -is)/tiswapt-pub.gpg | apt-key add -
echo "deb https://wapt.tranquil.it/$(lsb_release -is)/wapt-2.3/ $(lsb_release -c -s) main" > /etc/apt/sources.list.d/wapt.list
```
- Une fois que c'est fait, installer les paquets du **serveur WAPT**.

```bash
export DEBIAN_FRONTEND=noninteractive
apt update
apt install tis-waptserver tis-waptsetup -y
unset DEBIAN_FRONTEND
```

- À la fin, on doit voir le message "**Installation/Upgrade of waptserver is finished**". 

- Pour démarrer la **postconfiguration**, vous devez exécuter cette commande (avec les droits root) :

   ```bash
      /opt/wapt/waptserver/scripts/postconf.sh
   ```
- Répondre **Oui** à la première question pour lancer l'outil de configuration.
- Commencer par définir un mot de passe pour le compte administrateur du **serveur WAPT**.
- Choisir un type d'authentification pour les **agents WAPT**, c'est-à-dire pour les ordinateurs qui chercheront à s'enregistrer auprès du **serveur WAPT**.
- À l'étape suivante, indiquer **Oui** pour activer la fonctionnalité **Déploiement d'OS**
- Répondre **Oui** lorsqu'on propose de configurer **Nginx**.
- Vérifier que le nom du serveur est correct (nom **FQDN** !) et valider avec **Accepter**.
- Valider pour redémarrer **Nginx**.
- Valider encore pour que les démons **waptserver** et **wapttasks** soient démarrés à leur tour.
- A la fin, le message **Postconfiguration completed** apparait.
- Suite à la **postconfiguration**, le service **Nginx** est démarré donc vous pouvez accéder à l'**interface Web** du serveur WAPT à l'aide d'un navigateur en indiquant le nom du serveur, dans notre cas http://srv-wapt.pharmgreen.lan


   
