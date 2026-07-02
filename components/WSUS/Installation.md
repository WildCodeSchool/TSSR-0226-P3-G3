 ## Installation WSUS dans le Server Manager
------------------------------------------------------------------------------------------
## Sommaire
- [Installation de WSUS](#Installation-de-WSUS)
------------------------------------------------------------------------------------------
**Prérequis techniques :**

Avoir un Windows Server 2025 à jour
Le serveur doit avoir une adresse IP statique.
Un espace disque de 200go dédié est recommandé par la documentation officielle Microsoft (dans notre cas le disque se nomme WSUS)
Le rôle WSUS étant gourmand en ressources il est recommandé de le mettre sur une machine dédiée uniquement à ce rôle
Un serveur avec le rôle AD DS dans le même domaine

-----------------------------------------------------------------------------------------

# Installation de WSUS

- Dans le disque dédié, créer un dossier, nous l'appellerons WSUS tout simplement
- À partir du **Server Manager**, installer le rôle **Windows Server Update Services**.
- Valider les fonctionnalités supplémentaires qui vont s'ajouter automatiquement.
- Sélectionner **WID Connectivity** et **WSUS Service**
- Indiquer le dossier, précédemment créé, pour l'emplacement du stockage des mises à jour.
- Terminer l'installation et redémarrer le serveur.
