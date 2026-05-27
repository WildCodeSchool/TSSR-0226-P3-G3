
 # Installation du rôle AD DS
------
 **Prérequis techniques :**
Avoir un Windows Server 2025 à jour

**Étapes à suivre :**

Le serveur doit avoir une adresse IP statique.
Le rôle DNS n'est pas installé.

Pour la suite on estime que ce serveur a une adresse fixe dans la plage IP des machines clientes, par exemple 172.16.10.0/24.

- Aller dans le Server Manager
- Cliquer sur Manage -> Add Roles and Features pour démarrer l'ajout du rôle Active Directory Domain Sevices
- Cliquer sur Next
- Laisser l'option sélectionnée par défaut Role-Based or feature-based installation et cliquer sur Next
- Garder le serveur sélectionné et cliquer sur Next
- Cocher les rôles Active Directory Domain Services et DNS Server
- Une fenêtre contextuelle va apparaître pour chaque rôle coché, il faut cliquer sur Add Features pour inclure les outils d'administration proposés
- Cliquer sur Next 4 fois
- Cliquer sur Install et ensuite sur Close pour laisser l'installation en arrière-plan
