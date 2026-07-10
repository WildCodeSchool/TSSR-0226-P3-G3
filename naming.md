

## 1. Nom de domaine

`@pharmgreen.lan` pour le nom de domaine FQDN de notre forêt.

## 2. OU

La hiérarchie des OU se composera de **3 niveaux**.

| Niveau | Contenu |
|---|---|
| DC | `pharmgreen.lan` |
| OU principale | Pharmgreen |
| OU | / OU=Utilisateurs / OU=Ordinateurs / OU=Securite |
| Sous-OU | / OU=Departement | / OU=Services (50) |

```text
pharmgreen.lan
 └─ Conteneur=Pharmgreen
          ├─ OU=Securite ← ensemble des GrpDeSecurite
          ├─ OU=Utilisateurs       ← ensemble des utilisateurs
                    └─ OU=<Departement>          ex : Communication
                              └─ OU=<Service>    ex : Publicite
          ├─ OU=Ordinateurs        ← ensemble des ordinateurs
                    └─ OU=<Departement>          ex : RH
                              └─ OU=<Service>    ex : Formation
```

### Départements (sous-OU de Lyon)

| Code | Département |
|---|---|
| COM | Communication |
| DEV | Développement logiciel |
| FIN | Direction Financière |
| DIR | Direction Générale |
| MKT | Direction marketing |
| RND | R&D |
| RHU | RH |
| JUR | Service Juridique |
| SGX | Services Généraux |
| SIN | Systèmes d'information |
| VDC | Vente et développement commercial |



### Schéma OU

```text
OU=service, OU=département, DC=pharmagreen, DC=lan
```

Exemple :
```text
OU=Publicité , OU=Communication, DC=pharmagreen, DC=lan
```

## 3. Groupes de sécurité

| Type | Format | Exemple |
|---|---|---|
| Utilisateur | Type de groupe User - Descriptif de l'Action | `GrpUserWallpaper` |
| Ordinateur | Type de groupe Computer - Descriptif de l'Action | `GrpComputerFirefox` |
| Fonctionnalité | | |

## 4. Ordinateurs

### Plages de numérotation

| Plage | Lettre | Type |
|-------|------|------|
| 00001 &rarr; 00049 | X | Serveurs |
| 00050 &rarr; 00099 | W | Équipements réseau |
| 00100 &rarr; 00149 | Z | Admins |
| 00150 &rarr; 99999 | Y | Clients |

### Localisation

| Code | Entreprise |
|---|---|
| PG | Pharmgreen |

### Fonction si serveur

| Bit | ROLE               | VALEUR |
| --- | ------------------ | ------ |
| 0   | CONTROLEUR DOMAINE | 1      |
| 1   | DHCP               | 2      |
| 2   | DNS                | 4      |
| 3   | MESSAGERIE         | 8      |
| 4   | WEB                | 16     |
| 5   | SERVEUR FICHIER    | 32     |
| 6   | SERVEUR DE MOT DE PASSE | 64     |
| 7   | DEPLOIEMENT   | 128    |
| 8   | BACK UP            | 256    |
| 9   | FIREWALL           | 512    |
| 10  | BASTION            | 1024   |
| 11  | JUMP SERVER        | 2048   |
| 12  | GESTIONNAIRE DE PARC INFORMATIQUE | 4096   |
| 13  | GESTION DES LOGS |  8192   |
| 14  | SUPERVISION |  16384   |
| 15  | VOIP |  32768   |
| 16  | DETECTION D'INTRUSION |  65536   |

Exemple : PG-00005-X00001 correspond au serveur DC + DNS (l'AD DS)
           (00001+00004)

### Matricule / Nom machine

Une lettre (X,Y,Z) associée à un numéro unique en liste commençant à `00001` pour les Serveurs.
Les ordinateurs Standards sont tous à `00000`

| Lettre | Type |
|---|---|
| X | Serveur |
| Y | Client  |
| Z | Admin   |
| W | Equipement réseau   |

**Exemples :**

| Cas | Nom machine |
|---|---|
| Portable de Romain Mathieu | `PG-000000-Y00618` |
| Serveur de fichier pour la direction/Responsables | `PG-000064-X00099` |
| Ordinateur de Saiah | `PG-000000-Z00001` |

## 5. Personnes

Mail : `prenom.nom@pharmgreen.fr`

En cas d'homonymie sur adresse mail, ajout d'un chiffre après le nom avec incrémentation.

#### Matricule

Ajout d'un matricule `U` + 5 chiffres pour utilisateurs lambda et `A` + 5 chiffres pour les Administrateurs. Le A est identique au U pour une question de simplicité.
Pour se connecter à la session : Matricule (SamAccountName)

**Exemples :**

| Personne | Adresse mail | Matricule |
|---|---|---|
| John Doe (Communication) | `john.doe@pharmgreen.fr` | `U00042` |
| Cédric Bourré (Technicien support) | `cedric.bourre@pharmgreen.fr` | `U00108` (utilisateur) / `A00108` (infrastructure) |

## 6. GPO

### Cible

| Valeur | Cible |
|---|---|
| USER | Utilisateurs    |
| COMPUTER | Ordinateurs |

### Type

| Type |
|---|
| STANDARD |
| SECURITE |

### Portée

| Valeur | Portée |
|---|---|
| LOCAL | Local   |
| GLOBAL | Global |

### Département

Voir naming point 2

### Fonction

La fonction du GPOestexplicitement détaillé en quelques mots attachés

### Date de révision

`YYYYMMDD` au format ISO 8601 pour faciliter le tri chronologique.

### Exemple

GPO définissant la longueur et composition des mots de passe :

```text
USER-SECURITE-GLOBAL-strategiemotdepasse-20260525
```
