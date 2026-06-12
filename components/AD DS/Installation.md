 ## Installation DNS dans le Server Manager
------------------------------------------------------------------------------------------
## Sommaire
[Installation de L'AD DS](#Installation-de-L'AD-DS)
[Création d'un OU](#Création-d'un-OU)
[Création d'un Groupe de Sécurité](#Création-d'un-Groupe-de-Sécurité)
------------------------------------------------------------------------------------------
**Prérequis techniques :**

Avoir un Windows Server 2025 à jour
Le serveur doit avoir une adresse IP statique.
Le rôle DNS n'est pas installé.
Il est recommandé d'installer les rôles AD DS et DNS en une seule fois.

# Installation de L'AD DS

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

# Création d'un OU

**Étapes à suivre :**
- Dans le Server Manager cliquer sur Tools puis sur Active Directory Users and Computers (Utilisateurs et Ordinateurs)
- Clique droit sur le Domaine en haut à gauche, puis New, puis Organizational Unit (voir photo ci-dessous)

<img width="660" height="539" alt="image" src="https://github.com/user-attachments/assets/36f2d42a-56ec-4d7c-b3fc-44c4658de98f" />

- Entrer le nom souhaité et décocher la protection contre la suppression (pour pouvoir corriger plus aisément si besoin)
- Appliquer ces étapes pour créer les OU et les sous-OU dans les emplacements voulus.

# Création d'un Groupe de Sécurité

**Étapes à suivre :**
- Dans le Server Manager cliquer sur Tools puis sur Group Policy Management
- Dérouler les onglets de gauche jusque l'OU souhaité, dans le domaine
- Faire un clique droit sur l'OU et sélectionner create a GPO and link it there (voir image ci-dessous)

<img width="633" height="510" alt="image" src="https://github.com/user-attachments/assets/a8b6f7f2-ee45-4cff-9de6-edb78b6cc6ee" />

- Nommer la GPO selon votre choix et clique droit dessus pour _Edit_ et mettre en place la sécurité désirée
