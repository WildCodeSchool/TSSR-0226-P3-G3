## **Sommaire**
- [Configuration post-installation](#Configuration-post-installation)
- [Listing des OU et des sous-OU](#Listing-des-OU-et-des-sous-OU)

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
