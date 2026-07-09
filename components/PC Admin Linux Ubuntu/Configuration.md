## Configuration du PC Admin Ubuntu
------------------------------------------------------------------------------------------
## Sommaire

- [Préparation et Ajout au Domaine](#Préparation-et-Ajout-au-Domaine)
- [Mise en place de GPO](#Mise-en-place-de-GPO)
- [FAQ](#FAQ)

------------------------------------------------------------------------------------------

## Préparation et Ajout au Domaine

- Vérifier la synchro horaire : ```bash sudo apt install -y chrony
                                    timedatectl ```

- Installer les paquets nécessaires : ```bash sudo apt install -y realmd sssd sssd-tools libnss-sss libpam-sss adcli samba-common-bin oddjob oddjob-mkhomedir packagekit krb5-user adsys ```

- Joindre le domaine (remplacer administrateur par le compte qui sert de passerelle) : ```bash sudo realm join --verbose --user=administrateur pharmgreen.lan ```

- Vérifier l'état de la connection avec l'AD : ```bash sudo systemctl status sssd ``` (doit être en running/enabled) et ```bash klist -k ``` (voir si la machine a un compte côté AD)

- Pour permettre la connexion d'un utilisateur AD sans entrer "prenom@nom@domaine" et seulement le nom aller dans : ```bash sudo nano /etc/sssd/sssd.conf ```
Puis dans [domain/pharmgreen.lan] ajouter/modifier :

```bash use_fully_qualified_names = False
fallback_homedir = /home/%u ```

Suivi de : ```bash sudo systemctl restart sssd ```

- Générer les templates ADMX/ADML :

```bash mkdir ~/adsys-templates
sudo chown -R $USER:$USER ~/adsys-templates
cd ~/adsys-templates
sudo adsysctl policy admx all ```

- Les Récupérer sur le DC en les diffusant via http :

```bash
cd ~/adsys-templates
sudo python3 -m http.server 8333 ```

Depuis le DC ouvrir une page web "http://ipmachineubuntu:8333

Mettre les templates **ADMX/ADML** dans **PolicyDefinitions** sous **SYSVOL**

------------------------------------------------------------------------------

## Mise en place de GPO

------------------------------------------------------------------------------

## FAQ

- Si la machine était deja dans un précédent domaine entrer ces commandes pour le quitter et avant de réessayer de joindre le nouveau :

```bash
sudo systemctl stop sssd
sudo realm leave pharmgreen.lan
sudo rm -f /etc/krb5.keytab
sudo rm -f /etc/sssd/sssd.conf
sudo systemctl restart sssd
```
