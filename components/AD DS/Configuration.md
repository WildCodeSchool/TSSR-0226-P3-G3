## **Sommaire**
- [Configuration post-installation](#Configuration-post-installation)
- [Listing des OU et des sous-OU](#Listing-des-OU-et-des-sous-OU)
- [Listing des Groupes de Sécurité](#Listing-des-Groupes-de-Sécurité)
- [Création de la Corbeille AD](#Création-de-la-Corbeille-AD)
- [Restrictions Horaires](#Restrictions-Horaires)

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


# Restrictions Horaires

- Ouvrir l'onglet **Tools** et sélectionner **AD Administrative Center**

<img width="1048" height="265" alt="1 1" src="https://github.com/user-attachments/assets/a04df373-e5f6-4961-8557-8bfbe40b43e3" />

- Aller dans l'OU souhaité pour pouvoir y sélectionner les Utilisateurs voulus

<img width="854" height="485" alt="1 1 2" src="https://github.com/user-attachments/assets/d7dd973d-8f10-4548-aa80-08a5b52820c8" />

- Cliquer sur **Propriétés** puis cliquer sur **logonHours** pour restreindre de manière désirée

<img width="658" height="315" alt="1 2" src="https://github.com/user-attachments/assets/05547cb8-c7f6-403b-ae64-c93f257a0169" />

