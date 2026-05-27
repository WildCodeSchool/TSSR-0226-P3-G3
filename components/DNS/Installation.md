## Installation DNS dans le Server Manager

**Prérequis techniques :**
Avoir un Windows Server 2025 à jour

**Étapes à suivre :**
- Aller dans le Server Manager
- Cliquer sur Manage -> Add Roles and Features pour démarrer l'ajout du rôle DNS
- Cliquer sur Next
- Laisser l'option sélectionnée par défaut Role-Based or feature-based installation et cliquer sur Next
- Garder le serveur sélectionné et cliquer sur Next
- Cocher le rôle DNS Server
- Une fenêtre contextuelle va apparaître, il faut cliquer sur Add Features pour inclure les outils d'administration proposés
- Cliquer sur Next 3 fois
- Cliquer sur Install et ensuite sur Close pour laisser l'installation en arrière-plan

Une fois l'installation terminée (quand DNS apparaît dans la partie gauche du Server Manager) il est possible d'ouvrir grâce à l'une de ces méthodes :
- Cliquer sur l'icone DNS dans le panneau gauche de la console :
    - Cliquer avec le bouton droit de la souris sur le serveur sélectionné
    - Cliquer sur DNS Manager
- Cliquer dans Tools puis sur DNS
