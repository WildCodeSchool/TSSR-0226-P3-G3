## **Sommaire**
- [Configuration post-installation](#Configuration-post-installation)
- [Listing des OU et des sous-OU](#Listing-des-OU-et-des-sous-OU)
- [Listing des Groupes de Sécurité](#Listing-des-Groupes-de-Sécurité)
- [Création de la Corbeille AD](#Création-de-la-Corbeille-AD)

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

          ├─ OU=ComptesDesactives (pas de sous-OU)

          ├─ OU=Securite (pas de sous-OU)

          ├─ OU=Utilisateurs
                    └─ OU = DevLogiciel
						|-- OU = Developpement
						|-- OU = AnalyseEtconception
						|-- OU = TestEtqualite
				
					|-- OU = SystemesInformation
						|-- OU = Data
						|-- OU = DeveloppementLogiciel
						|-- OU = T0
						|-- OU = T1
						|-- OU = T2
				
					|-- OU = R&D
						|-- OU = InnovationEtStrategie
						|-- OU = Laboratoire
				
					|-- OU = RessourcesHumaines
						|-- OU = Formation
						|-- OU = GestionDesPerformances
						|-- OU = Recrutement
						|-- OU = SanteEtSecuriteAuTravail
				
					|-- OU = DirectionFinanciere
						|-- OU = ControleDeGestion
						|-- OU = Finance
						|-- OU = ServiceComptabilite
				
					|-- OU = ServicesGeneraux
						|-- OU = GestionImmobiliere
						|-- OU = Logistique
				
					|-- OU = ServicesJuridique
						|-- OU = Contentieux
						|-- OU = Contrats
						|-- OU = ProprieteIntellectuelle
				
					|-- OU = DirectionGenerale
						|-- OU = Direction
						|-- OU = Secretaire
						|-- OU = DirecteurDeBranche
				
					|-- OU = VentesEtDeveloppementCommercial
						|-- OU = ADV
						|-- OU = B2B
						|-- OU = B2C
						|-- OU = DeveloppementInternational
						|-- OU = GrandsComptes
						|-- OU = ServiceAchat
						|-- OU = ServiceClient
					
					|-- OU = DirectionMarketing
						|-- OU = MarketingDigital
						|-- OU = MarketingOperationnel
						|-- OU = MarketingProduit
						|-- OU = MarketingStrategique
				
					|-- Communication
						|-- OU = GestionDesMarques
						|-- OU = Publicite
						|-- OU = RelationsMedias
						|-- OU = RelationPubliqueEtPresse


          ├─ OU=Ordinateurs
                    └─ OU = DevLogiciel
						|-- OU = Developpement
						|-- OU = AnalyseEtconception
						|-- OU = TestEtqualite
				
					|-- OU = SystemesInformation
						|-- OU = Data
						|-- OU = DeveloppementLogiciel
						|-- OU = T0
						|-- OU = T1
						|-- OU = T2
				
					|-- OU = R&D
						|-- OU = InnovationEtStrategie
						|-- OU = Laboratoire
				
					|-- OU = RessourcesHumaines
						|-- OU = Formation
						|-- OU = GestionDesPerformances
						|-- OU = Recrutement
						|-- OU = SanteEtSecuriteAuTravail
				
					|-- OU = DirectionFinanciere
						|-- OU = ControleDeGestion
						|-- OU = Finance
						|-- OU = ServiceComptabilite
				
					|-- OU = ServicesGeneraux
						|-- OU = GestionImmobiliere
						|-- OU = Logistique
				
					|-- OU = ServicesJuridique
						|-- OU = Contentieux
						|-- OU = Contrats
						|-- OU = ProprieteIntellectuelle
				
					|-- OU = DirectionGenerale
						|-- OU = Direction
						|-- OU = Secretaire
						|-- OU = DirecteurDeBranche
				
					|-- OU = VentesEtDeveloppementCommercial
						|-- OU = ADV
						|-- OU = B2B
						|-- OU = B2C
						|-- OU = DeveloppementInternational
						|-- OU = GrandsComptes
						|-- OU = ServiceAchat
						|-- OU = ServiceClient
					
					|-- OU = DirectionMarketing
						|-- OU = MarketingDigital
						|-- OU = MarketingOperationnel
						|-- OU = MarketingProduit
						|-- OU = MarketingStrategique
				
					|-- Communication
						|-- OU = GestionDesMarques
						|-- OU = Publicite
						|-- OU = RelationsMedias
						|-- OU = RelationPubliqueEtPresse
```

# Listing des Groupes de Sécurité

- GrpOrdinateurs -> Tous les Ordinateurs
- GrpOrdinateursAdmin -> Les Ordinateurs d'Administration
- GrpOrdinateursDirecteurDeBranche -> Les Ordinateurs des Directeurs de Branche
- GrpOrdinateursDirection -> Les Ordinateurs de la Direction
- GrpUtilisateurs -> Tous les Utilisateurs
- GrpUtilisateursAdmin -> Les Administrateurs
- GrpUtilisateursDirecteurDeBranche -> Les Utilisateurs de l'OU Directeurs de Branche
- GrpUtilisateursDirection -> Les Utilisateurs de l'OU Direction

# Création de la Corbeille AD


- Une fois l'installation terminée, pour ouvrir la **Corbeille**, cliquer sur **Tools** pour sélectionner **Active Directory Administrative Center**

<img width="1134" height="188" alt="Tuto Bin" src="https://github.com/user-attachments/assets/959576b6-20f7-4073-905b-0fe3e31cf3ea" />

- Ensuite dans l'onglet de gauche cliquer sur le _domaine local_ puis sur **Deleted Objects**

<img width="944" height="294" alt="Tuto Bin2" src="https://github.com/user-attachments/assets/a6ccefeb-f5c3-4ea2-9328-4ff913928264" />
