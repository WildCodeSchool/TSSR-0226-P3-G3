
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


DC = Pharmgreen.lan


Pharmgreen.lan
```
└─ Conteneur=Pharmgreen
          ├─ OU=Utilisateurs
                    └─ OU = Dev Logiciel
						|-- OU = Developpement
						|-- OU = Analyse et conception
						|-- OU = Test et qualité
				
					|-- OU = SI
						|-- OU = Data
						|-- OU = Développement Logiciel
				
					|-- OU = R&D
						|-- OU = Innovation et Stratégie
						|-- OU = Laboratoire
				
					|-- OU = Ressources Humaines
						|-- OU = Formation
						|-- OU = Gestion des performances
						|-- OU = Recrutement
						|-- OU = Santé et Sécurité au travail
				
					|-- OU = Direction Financière
						|-- OU = Contrôle de Gestion
						|-- OU = Finance
						|-- OU = Service Comptabilité
				
					|-- OU = Services Généraux
						|-- OU = Gestion Immobilière
						|-- OU = Logistique
				
					|-- OU = Services Juridique
						|-- OU = Contentieux
						|-- OU = Contrats
						|-- OU = Propriété Intellectuelle
				
					|-- OU = Direction Générale ( pas de sous-OU)
				
					|-- OU = Ventes & Dev commerciale
						|-- OU = ADV
						|-- OU = B2B
						|-- OU = B2C
						|-- OU = Développement International
						|-- OU = Grands Comptes
						|-- OU = Service Achat
						|-- OU = Service Client
					
					|-- OU = Direction Marketing
						|-- OU = Marketing Digital
						|-- OU = Marketing Opérationnel
						|-- OU = Marketing Produit
						|-- OU = Marketing stratégique
				
					|-- Communication
						|-- OU = Gestion des marques
						|-- OU = Publicité
						|-- OU = Relations Médias
						|-- OU = Relation Publique et Presse


			├─ OU=Ordinateurs
                    └─ OU = Dev Logiciel
						|-- OU = Developpement
						|-- OU = Analyse et conception
						|-- OU = Test et qualité
				
					|-- OU = SI
						|-- OU = Data
						|-- OU = Développement Logiciel
				
					|-- OU = R&D
						|-- OU = Innovation et Stratégie
						|-- OU = Laboratoire
				
					|-- OU = Ressources Humaines
						|-- OU = Formation
						|-- OU = Gestion des performances
						|-- OU = Recrutement
						|-- OU = Santé et Sécurité au travail
				
					|-- OU = Direction Financière
						|-- OU = Contrôle de Gestion
						|-- OU = Finance
						|-- OU = Service Comptabilité
				
					|-- OU = Services Généraux
						|-- OU = Gestion Immobilière
						|-- OU = Logistique
				
					|-- OU = Services Juridique
						|-- OU = Contentieux
						|-- OU = Contrats
						|-- OU = Propriété Intellectuelle
				
					|-- OU = Direction Générale ( pas de sous-OU)
				
					|-- OU = Ventes & Dev commerciale
						|-- OU = ADV
						|-- OU = B2B
						|-- OU = B2C
						|-- OU = Développement International
						|-- OU = Grands Comptes
						|-- OU = Service Achat
						|-- OU = Service Client
					
					|-- OU = Direction Marketing
						|-- OU = Marketing Digital
						|-- OU = Marketing Opérationnel
						|-- OU = Marketing Produit
						|-- OU = Marketing stratégique
				
					|-- Communication
						|-- OU = Gestion des marques
						|-- OU = Publicité
						|-- OU = Relations Médias
						|-- OU = Relation Publique et Presse
```
