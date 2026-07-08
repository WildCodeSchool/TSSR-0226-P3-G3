## Configuration de FreePBX
------------------------------------------------------------------------------------------
## Sommaire

- [Finaliser la configuration générale](#Finaliser-la-configuration-générale)
- [Quelques exemples de possibilités](#Quelques-exemples-de-possibilités)
- [FAQ](#FAQ)
------------------------------------------------------------------------------------------
## Finaliser la configuration générale

- Cette activation n'est pas obligatoire, mais elle permet d'avoir accès à l'ensemble des fonctionnalités du serveur. Aller dans le menu **Admin** puis **System Admin**
- Cliquer sur **Activation** puis **Activate** enfin, dans la fenêtre qui s'affiche, cliquer sur **Activate**
- Entrer une adresse email et attend quelques instant
- Dans la fenêtre qui s'affiche, renseigne les différentes informations, et :
          - Pour **Which best describes you** mettre **I use your products and services with my Business(s) and do not want to resell it**
          - Pour **Do you agree to receive product and marketing emails from Sangoma ?** cocher **No**
          - Cliquer sur **Create**
- La fenêtre de mise-à-jour des modules va s'afficher automatiquement, cliquer sur **Update Now**
- Une fois que tout est terminé, cliquer sur **Apply config**
- Dans la fenêtre d'activation, cliquer sur **Activate** et attendre que l'activation se fasse
- Dans les fenêtres qui s'affichent, cliquer sur **Skip**
- Côté AD, utiliser ce [script](#operations/Ressources/AddIpPhone.ps1) pour ajouter les Numéros de Téléphone Ip aux utilisateurs de l'AD
- Côté interface Web : **Configurer User Manager => Directories => Add** pour amorçer la synchronisation LDAPS
- Configuration à appliquer (à adapter selon l'environnement) :
   - Secure Connection Type : SSL
   - Host(s) : PG-00005-X00001.pharmgreen.lan (sans préfixe ldaps://)
   - Port : 636
   - Nom d'utilisateur : U00003@pharmgreen.lan
   - Mot de passe : *****
   - Base DN : ou=Pharmgreen,dc=pharmgreen,dc=lan
 - La synchronisation va se lancer (il se peut que l'interface web plante pendant le chargement des Objets AD, il faut juste laisser le temps au serveur de tout récupérer)

------------------------------------------------------------------------------------------

## Installation du logiciel SIP sur les postes clients
- Prendre la source chez [3CXPhone](https://3cxphone.software.informer.com/download/)
- Télécharger la version x86/x64 sur le DC et le déployer par GPO

<img width="689" height="276" alt="image" src="https://github.com/user-attachments/assets/e35c97b3-9e52-47d3-8e03-bc2f60ffeb00" />

- Sur l'écran du **SIP phone**, cliquer sur **Set account** pour avoir la fenêtre **Accounts**
- En cliquant sur **New**, la fenêtre de création de compte **Account settings** apparaît
- Pour configurer la ligne de l'utilisatrice Marie Dupont, rentre les informations comme ceci :
     - Account Name : Joséphine Angegardien
     - Caller ID : 10100
     - Extension : 10100
     - ID : 10100
     - Password : 1234
     - I am in the office - local IP : l'adresse IP du serveur soit 172.16.6.20
       
------------------------------------------------------------------------------------------

## Quelques exemples de possibilités

1 - **Création d'utilisateurs et de lignes sur le serveur** :
    - Aller dans le menu **Applications** puis **Extensions**
    - Aller sur l'onglet **SIP [chan_pjsip] Extensions** et cliquer sur le bouton **+Add New SIP [chan_pjsip] Extension**
    - Pour créer la 1ère ligne, celle de Joséphine Angegardien par exemple, renseigner les informations suivante :
            - User Extension : 10100
            - Display Name : Joséphine Angegardien
            - Secret : 1234
            - Password For New User : 1234
    - Cliquer sur le bouton **Submit** puis **Apply Config** pour enregistrer l'utilisateur

2 - **Renvois d'appel** :
    - Dans **Follow-Me List** mettre le numéro vers lequel renvoyer, par exemple 10200
    - **Initial Ring Time** est le temps en secondes avant le transfert d'appel, mettre 5
    - **Follow-Me Ring Time** est le temps (ajouté à **Initial Ring Time**) avant que l'appel s’arrête. Mettre 10.
    - Mettre **Yes** pour **Enable Followme**, cela active le transfert d'appel 
    - Cliquer sur **Submit** puis **Apply Config**
_L'appel vers 10100 sera alors transféré à 10200 si le premier ne décroche pas au bout des 5 secondes_

3 - **Pool d'appel** :
    - Aller dans **Applications -> Ring Groups** et cliquer sur **Add Ring Group**
    - Dans le menu :
          - Ring-Group Number : 20100
          - Group Description : Help-Desk (par exemple)
          - Extension List : 10100 et 10200 en dessous
          - Ring Strategy : ringall
          - Ring Time : 15
          - Destination if no answer : Terminate Call - Hangup
    - Cliquer sur **Submitpuis Apply Config**
_Si 10500 appelle le 20100 alors les téléphones de 10100 ET 10200 vont sonner en même temps_
