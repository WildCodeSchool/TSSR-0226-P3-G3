## Configuration du PC Admin Ubuntu
------------------------------------------------------------------------------------------
## Sommaire

- [Préparation et Ajout au Domaine](#Préparation-et-Ajout-au-Domaine)
- [Mise en place de GPO](#Mise-en-place-de-GPO)
- [FAQ](#FAQ)

------------------------------------------------------------------------------------------

## Préparation et Ajout au Domaine

- Vérifier la synchro horaire : ``` sudo apt install -y chrony
                                    timedatectl ```

- Installer les paquets nécessaires : ``` sudo apt install -y realmd sssd sssd-tools libnss-sss libpam-sss adcli samba-common-bin oddjob oddjob-mkhomedir packagekit krb5-user adsys ```

- Joindre le domaine (remplacer administrateur par le compte qui sert de passerelle) : ``` sudo realm join --verbose --user=administrateur pharmgreen.lan ```

- Vérifier l'état de la connection avec l'AD : ``` sudo systemctl status sssd ``` (doit être en running/enabled) et ``` klist -k ``` (voir si la machine a un compte côté AD)

- Pour permettre la connexion d'un utilisateur AD sans entrer "prenom@nom@domaine" et seulement le nom aller dans : ``` sudo nano /etc/sssd/sssd.conf ```
Puis dans [domain/pharmgreen.lan] ajouter/modifier :

```bash use_fully_qualified_names = False
fallback_homedir = /home/%u
```

Suivi de : ``` sudo systemctl restart sssd ```

- Activer UbuntuPro pour permettre l'application de GPO :
      -  ```bash sudo apt install ubuntu-advantage-tools -y ```
      - Se connecter sur le [site Ubuntu](https://ubuntu.com/pro) pour récupérer un token gratuit jusque 5 machines.
      - sudo pro attach LE_TOKEN_ICI
      - Vérifier avec ```bash pro status ```
  
- Générer les templates ADMX/ADML :

```bash mkdir ~/adsys-templates
sudo chown -R $USER:$USER ~/adsys-templates
cd ~/adsys-templates
sudo adsysctl policy admx all
```

- Les Récupérer sur le DC en les diffusant via http :

```bash
cd ~/adsys-templates
sudo python3 -m http.server 8333
```

- Depuis le DC ouvrir une page web "http://ipmachineubuntu:8333"
- Mettre les templates **ADMX/ADML** dans **PolicyDefinitions** sous **SYSVOL**

<img width="367" height="134" alt="Ubuntu gpo4 coller dans sysvol (dans le reseau) et dans policydefinitions" src="https://github.com/user-attachments/assets/0ba40a8f-9018-4500-8cfe-7499fd921ba2" />


------------------------------------------------------------------------------

## Mise en place de GPO

- Choisir une GPO de la meme maniere que pour une machine Windows, un menu Ubuntu apparaissant dans 

<img width="781" height="405" alt="image" src="https://github.com/user-attachments/assets/cba822ae-a422-4d76-87b6-e6ae32167747" />

- L'équivalent Ubuntu de gpupdate /force : ```bash sudo adsysctl policy update -av ```
- L'équivalent Ubuntu de gpresult /R : ```bash sudo adsysctl policy applied --details ```
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
