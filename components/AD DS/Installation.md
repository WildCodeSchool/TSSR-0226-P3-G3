 ## Installation DNS dans le Server Manager

**Prérequis techniques :**

Avoir un Windows Server 2025 à jour
Le serveur doit avoir une adresse IP statique.
Le rôle DNS n'est pas installé.
Il est recommandé d'installer les rôles AD DS et DNS en une seule fois.

**Étapes à suivre :**
- Aller dans le Server Manager
- Cliquer sur Manage -> Add Roles and Features pour démarrer l'ajout du rôle Active Directory Domain Sevices
- Cliquer sur Next
- Laisser l'option sélectionnée par défaut Role-Based or feature-based installation et cliquer sur Next
- Garder le serveur sélectionné et cliquer sur Next
- Cocher les rôles Active Directory Domain Services et DNS Server
- Une fenêtre contextuelle va apparaître pour chaque rôle coché, il faut cliquer sur Add Features pour inclure les outils d'administration proposés
- Cliquer sur Next 4 fois
- Cliquer sur Install et ensuite sur Close pour laisser l'installation en arrière-plan


Une fois l'installation terminée l'icone drapeau jaune apparaît, cliquer dessus et cliquer sur Promote this server to a domain controller :
- Une fenêtre va apparaître
- Sélectionner Add a new forest et dans Root domain name mettre le nom du domaine, par exemple Pharmgreen.lan
- Cliquer sur Next
- Laisser les options par défaut et mettre (2 fois) le mot de passe pour le DSRM
- Cliquer sur Next 5 fois (laisser toutes les options par défaut)
- Cliquer sur Install
- Une fois que l'installation est terminé, le serveur redémarre
