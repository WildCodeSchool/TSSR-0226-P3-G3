
# Configuration post-installation

- Cliquer sur l'icône ronde avec des flèches à l’intérieur qui tournent pour rafraîchir l'affichage
- Attendre l'icone de notification (triangle jaune)
- Une fois que l'icone apparaît, cliquer dessus et cliquer sur Promote this server to a domain controller
- Une fenêtre va apparaître
- Sélectionner Add a new forest et dans Root domain name mettre le nom du domaine, par exemple wilders.lan
- Cliquer sur Next
- Laisser les options par défaut et mettre (2 fois) le mot de passe pour le DSRM
- Cliquer sur Next 5 fois (laisser toutes les options par défaut)
- Cliquer sur Install
- Une fois que l'installation est terminé, le serveur redémarre
---

# Listing des OU et des sous-OU


Pharmgreen.lan

|--OU = Administrator
|--OU = Users
|--OU = Computers
|--OU = Lyon
	|--OU = Dev Logiciel
		|-- OU = Gestion des marques
			|-- OU = Users
			|-- OU = Computers
		|-- OU = Publicité
			|-- OU = Users
			|-- OU = Computers
		|-- OU = Relation Médias
			|-- OU = Users
			|-- OU = Computers
		|-- OU = Relation Publique et Presse
			|-- OU = Users
			|-- OU = Computers
	|-- OU = SI
		|-- OU = Data
			|-- OU = Users
			|-- OU = Computers
		|-- OU = Développement Logiciel
			|-- OU = Users
			|-- OU = Computers
	|-- OU = R&D
		|-- OU = Innovation et Stratégie
			|-- OU = Users
			|-- OU = Computers
		|-- OU = Laboratoire
			|-- OU = Users
			|-- OU = Computers
	|-- OU = Ressources Humaines
		|-- OU = Formation
			|-- OU = Users
			|-- OU = Computers
		|-- OU = Gestion des performances
			|-- OU = Users
			|-- OU = Computers
		|-- OU = Recrutement
			|-- OU = Users
			|-- OU = Computers
		|-- OU = Santé et Sécurité au travail
			|-- OU = Users
			|-- OU = Computers
	|-- OU = Direction Financière
		|-- OU = Contrôle de Gestion
			|-- OU = Users
			|-- OU = Computers
		|-- OU = Finance
			|-- OU = Users
			|-- OU = Computers
		|-- OU = Service Comptabilité
			|-- OU = Users
			|-- OU = Computers
	|-- OU = Services Généraux
		|-- OU = Gestion Immobilière
			|-- OU = Users
			|-- OU = Computers
		|-- OU = Logistique
			|-- OU = Users
			|-- OU = Computers
	|-- OU = Services Juridique
		|-- OU = Contentieux
			|-- OU = Users
			|-- OU = Computers
		|-- OU = Contrats
			|-- OU = Users
			|-- OU = Computers
		|-- OU = Propriété Intellectuelle
			|-- OU = Users
			|-- OU = Computers
	|-- OU = Direction Générale ( pas de sous-OU)
			|-- OU = Users
			|-- OU = Computers
	|-- OU = Ventes & Dev commerciale
		|-- OU = ADV
			|-- OU = Users
			|-- OU = Computers
		|-- OU = B2B
			|-- OU = Users
			|-- OU = Computers
		|-- OU = B2C
			|-- OU = Users
			|-- OU = Computers
		|-- OU = Développement International
			|-- OU = Users
			|-- OU = Computers
		|-- OU = Grands Comptes
			|-- OU = Users
			|-- OU = Computers
		|-- OU = Service Achat
			|-- OU = Users
			|-- OU = Computers
		|-- OU = Service Client
			|-- OU = Users
			|-- OU = Computers		
	|-- OU = Direction Marketing
		|-- OU = Marketing Digital
			|-- OU = Users
			|-- OU = Computers
		|-- OU = Marketing Opérationnel
			|-- OU = Users
			|-- OU = Computers
		|-- OU = Marketing Produit
			|-- OU = Users
			|-- OU = Computers
		|-- OU = Marketing stratégique
			|-- OU = Users
			|-- OU = Computers
	|-- Communication
		|-- OU = Gestion des marques
			|-- OU = Users
			|-- OU = Computers
		|-- OU = Publicité
			|-- OU = Users
			|-- OU = Computers
		|-- OU = Relations Médias
			|-- OU = Users
			|-- OU = Computers
		|-- OU = Relation Publique et Presse
			|-- OU = Users
			|-- OU = Computers
