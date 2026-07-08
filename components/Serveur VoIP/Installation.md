 ## Installation Serveur de VoIP
------------------------------------------------------------------------------------------
## Sommaire
- [Installation du Serveur](#Installation-du-Serveur)
- [FAQ](#FAQ)
------------------------------------------------------------------------------------------
**Prérequis techniques :**

Une VM avec une distribution Linux mis à jour avec 20Go d'espace disque
Un ISO [FreePBX](https://www.freepbx.org/downloads/)
Une machine Windows 11 qui servira d'interface graphique une fois l'installation FreePBX terminée.
Le serveur doit avoir une adresse IP statique.

## Installation du Serveur

- Au démarrage de la VM, dans la liste, choisir la version recommandée.
- Puis sélectionner **Graphical Installation - Output to VGA**
- Enfin choisir **FreePBX Standard**
- Pendant l'installation, il faut configurer le mot de passe root, cliquer sur **ROOT PASSWORD** et entrer un mot de passe. (Attention le clavier est en Qwerty par défaut)
- Une fois l'installation terminée, éteindre la VM, retirer l'ISO du lecteur et redémarrer la VM
- Une fois connecté en root, modifier la langue du clavier (```bash localectl ``` pour vérifier) :
```bash
     localectl set-locale LANG=fr_FR.utf8
     localectl set-keymap fr
     localectl set-x11-keymap fr
```
- Configurer le DNS dans : /etc/resolv.conf
Quelques commandes :
    - Pour mettre à jour FreePBX : ```bash yum update -y ```
    - Pour mettre à jour le module : ```bash fwconsole ma upgrade framework ```
    - Pour mettre à jour tous les modules : ```bash fwconsole ma upgradeall ```
    - Pour vérifier que tout est en marche : ```bash fwconsole ma list ```
- Après la mise à jour complète faire un reboot
- Etablir une connexion ssh sécurisée entre le serveur PBX
- Transférer le certificat vers le serveur FreePBX via scp par exemple : ```bash scp moncertificat.cer root@<IP_FreePBX>:/tmp/ ```
- Installer le certificat sur le système FreePBX : ```bash cp /tmp/moncertificat.cer /etc/pki/ca-trust/source/anchors/pharmgreen-ca.crt
                                                      update-ca-trust extract ```
- Configurer OpenLDAP pour utiliser ce certificat : ```bash nano /etc/openldap/ldap.conf ```
- Ajoutez ou modifiez ces lignes : ```bash TLS_CACERT /etc/pki/ca-trust/source/anchors/pharmgreen-ca.crt
                                           TLS_REQCERT demand ```
- Tester la connexion LDAPS manuellement avant de configurer User Manager : ```bash ldapsearch -H ldaps://<IP_ou_FQDN_DC>:636 -x -b "dc=pharmgreen,dc=lan" -D "CN=Administrator,CN=Users,DC=pharmgreen,DC=lan" -W ```

-------------------------------------------------------------------------------

## FAQ 

### Problème de mise à jour

Si l'iso choisi n'est pas récent il se peut que le dépôt de FreePBX ne soit plus à jour
Nous allons devoir recréer la synchronisation entre la version enregistrée dans la table modules en base MySQL/MariaDB et la version réelle des fichiers sur disque
Pour vérifier cela voici la marche à suivre : 
  - Regarder directement la version utilisée : ```bash fwconsole ma list | grep -i core ``` => admettons que la commande renvoie "16.0.68.40"
  - Forcer le match : ```bash mysql -u root asterisk -e "UPDATE modules SET version='16.0.68.40' WHERE modulename='core';" ```
  - Relancer l'upgrade : ```bash fwconsole ma upgradeall ``` puis ```bash fwconsole restart ```




