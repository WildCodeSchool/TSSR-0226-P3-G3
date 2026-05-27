## Installation DHCP dans le Server Manager

**Prérequis techniques :**
Avoir un Windows Server 2025 à jour
Le serveur doit avoir une adresse IP statique

**Étapes à suivre :**
- Aller dans le Server Manager
- Cliquer sur Manage -> Add Roles and Features pour démarrer l'ajout du rôle DHCP
- Cliquer sur Next
- Laisser l'option sélectionnée par défaut Role-Based or feature-based installation et cliquer sur Next
- Garder le serveur sélectionné et cliquer sur Next
- Cocher le rôle DHCP Server
- Une fenêtre contextuelle va apparaître, il faut cliquer sur Add Features pour inclure les outils d'administration proposés
- Cliquer sur Next 3 fois
- Cliquer sur Install et ensuite sur Close pour laisser l'installation en arrière-plan

Une fois que l'icone triangle jaune apparait en haut du Server Manager, cliquer dessus et cliquer sur Complete DHCP configuration
Cliquer sur Commit puis Close

Une fois l'installation terminée (quand DHCP apparaît dans la partie gauche du Server Manager) il est possible d'ouvrir grâce à l'une de ces méthodes :
- Cliquer sur l'icone DHCP dans le panneau gauche de la console
    - Cliquer avec le bouton droit de la souris sur le serveur sélectionné
    - Cliquer sur DHCP Manager
- Cliquer dans Tools puis sur DHCP
