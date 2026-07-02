## Configuration de Windows Server Update Services
------------------------------------------------------------------------------------------
## Sommaire

- [Configuration du service WSUS](#Configuration-du-service-WSUS)
- [Liaison avec les ordinateurs du domaine](#Liaison-avec-les-ordinateurs-du-domaine)
- [Gestion des mises à jour](#Gestion-des-mises-à-jour)
------------------------------------------------------------------------------------------

# Configuration du service WSUS

- Lancer la tâche **Post Deployment Configuration for WSUS** dans le **Server Manager**.
- Dans l'onglet de gauche, aller dans **WSUS**
- Avec le bouton droit sélectionner **Windows Server Update Services** cela va lancer automatiquement l'assistant de configuration
  Dans l'assistant :
    - Décocher la case **Yes, I would like to join the Microsoft Update Improvement Program**
    - Laisser sélectionné la case **Synchronize from Microsoft Update**
    - Ne pas mettre de proxy
    - À la fin, cliquer sur **Start Connecting**. Cette action peut être longue (_plusieurs dizaines de minutes_)
    - Si cela ne fonctionne pas, vérifier la connexion internet
    - Après, sélectionner les langues **English** et **French**
    - Dans la fenêtre d'après, sélectionner les produits pour lesquels des mises à jour sont souhaitées. Ici on peut choisir parmi les produits Windows 10 et les serveurs
    - Pour les classifications laisser les choix par défaut
    - Pour la synchronisation, choisir le nombre désiré en temps voulu (_4 synchronisations par jour, à partir de 2h dans notre cas_)
    - Enfin cocher la case **Begin initial synchronization** et cliquer sur **Finish**
 
Il est possible de voir l'état de la synchronisation en cliquant sur _le nom du serveur_ dans la fenêtre, l'état de la synchronisation s'affiche avec le widget **Synchronization Status**.
- Aller dans **Options**, puis **Automatic Approvals**.
- Dans l'onglet **Update Rules**, cocher **Default Automatic Approval Rule** (Cela permet d'approuver automatiquement les mises à jour suivant les règles de la section Rule Properties se trouvant en dessous. Par défaut, une mise à jour Critique ou de Sécurité sont Approuvées sur tout les ordinateurs)
- Cliquer sur **Run Rules**
- Cliquer sur **Apply** et **OK**

<img width="596" height="537" alt="WSUS 2" src="https://github.com/user-attachments/assets/30840806-d51d-4997-a6f6-0886d65a0aa2" />

------------------------------------------------------------------------------------------

# Liaison avec les ordinateurs du domaine

Sur le serveur WSUS :
- Aller dans **Options**, puis **Computers**.
- Cocher l'option **Use Group Policy**... et valider
- Dans l'arborescence des ordinateurs, sous **All Computers**, créer les groupes souhaités avec **Add Computer Group** :
  - GrpOrdinateurs
  - GrpOrdinateursAdmin
  - GrpServeursDC
  - GrpServeursNotDC

## Application par GPO

- Sur l'**AD**, créer une GPO pour chaque groupe créé dans le serveur WSUS (par exemple **Computers-Standard-wsusGrpOrdinateurs-20260625**)
- Aller dans **Computer Configuration--> Policies--> Administrative Templates--> Windows Components--> Windows update**
- Le paramétrage ci-dessous est commun à toutes les **GPO** :
  - Aller dans **Specify intranet Microsoft update service location**, qui indiquera où est le serveur de mise à jour.
    - Cocher **Enabled**
    - Dans les options, pour les 2 premiers champs, mettre l'URL avec le nom du serveur sous sa forme **FQDN**, ajouter le numéro du port **8530**
      - Valider la configuration
  - Aller dans **Do not connect to any Windows Update Internet locations** qui bloque la connexion aux serveurs de Microsoft
    - Cocher **Enabled** et valider la configuration
  - Le paramétrage ci-dessous est _spécifique_ à cette GPO :
  - Aller dans **Configure Automatic Updates**
    - Cocher **Enabled**
    - Dans les options mettre :
      - Dans **Configure automatic updating** sélectionner **4- Auto Download and schedule the install**
      - Dans **Scheduled install day** mettre **0 - Every day** pour une mise à jour quotidienne
      - Dans **Scheduled install time** mettre l'heure désirée (par exemple **07:00**)
      - Cocher **Every week**
      - Cocher **Install updates for other Microsoft Products**
  - Aller dans **Enable client-side targeting** qui fait la liaison avec les groupes crées dans **WSUS**
    - Cocher **Enabled**
    - Dans les options, mettre le nom du groupe WSUS pour les ordinateurs cible
    - Valider la configuration
  - Aller dans **Turn off auto-restart for updates during active hours** qui permet d'empêcher les machines de redémarrer après l'installation d'une mise à jour pendant leurs heures d'utilisations
    - Cocher **Enabled**
    - Dans les options, mettre (par exemple) **8 AM - 6 PM**

Adapter une nouvelle GPO, basée sur celle précédemment créée, pour le groupe **GrpOrdinateursAdmin**

Pour le groupe **GrpServeursNotDC** : 
- Copier la GPO Ordinateurs, la renommer pour quelle s'adapte à ce groupe 
- Ne pas toucher à la partie commune et modifier uniquement la partie spécifique à cette GPO :
  - Aller dans **Configure Automatic Updates**
    - Dans les options mettre :
      - Dans **Configure automatic updating** sélectionner **7- Auto Download, Notify to restart**
      - Dans **Scheduled install day** mettre **0 - Every day**
      - Dans **Scheduled install time** mettre l'heure désirée (par exemple **07:00**)
      - Cocher **Every week**
      - Ne pas cocher **Install updates for other Microsoft Products**
  - Aller dans **Enable client-side targeting** qui fait la liaison avec les groupes crées dans **WSUS**
    - Coche **Enabled**
    - Dans les options, mettre le nom du groupe WSUS pour les ordinateurs cible, dont ici les serveurs
    - Valide la configuration

Pour le groupe **GrpServeursDC** :
- Copier la GPO Serveur non DC, la renommer pour quelle s'adapte à ce groupe
- Ne pas toucher à la partie commune et modifier uniquement la partie spécifique à cette GPO :
  - Aller dans **Enable client-side targeting** qui fait la liaison avec les groupes crées dans **WSUS**
    - Coche **Enabled**
    - Dans les options, mettre le nom du groupe WSUS pour les ordinateurs cible, dont ici les contrôleurs de domaine
    - Valide la configuration

Une fois les GPO crées et configurées, lie les aux OU dans lesquelles sont tes machines clientes puis mettre à jour les GPO sur les machines clientes

# Gestion des mises à jour

Sur le serveur **WSUS**, aller dans la partie **Updates** et sélectionner **Security Updates**.
Sélectionner des mises à jour et ouvrir le menu d'approbation avec le clic droit de la souris.
On peut retrouver les groupes que précédemmet créés sous l'arborescence **All Computers**.
On peut, pour chacun des groupes, appliquer les différentes mises à jour ou bien les bloquer.
