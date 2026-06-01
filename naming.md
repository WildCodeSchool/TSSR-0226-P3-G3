

## 1. Nom de domaine

`@pharmgreen.lan` pour le nom de domaine FQDN de notre forêt.

## 2. OU

La hiérarchie des OU se composera de **3 niveaux**.

| Niveau | Contenu |
|---|---|
| DC | `pharmgreen.lan` |
| OU principales | / OU=Utilisateurs / OU=Ordinateurs / OU=Administrateurs |
| Sous-OU | / OU=Département | / OU=Services (50) |

```text
pharmgreen.lan
 └─ Conteneur=Pharmgreen
          ├─ OU=Utilisateurs       ← ensemble des utilisateurs
                    └─ OU=<Département>          ex : Communication
                              └─ OU=<Service>    ex : Publicité
          ├─ OU=Ordinateurs        ← ensemble des ordinateurs
                    └─ OU=<Département>          ex : RH
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
| 6   | SERVEUR DIRECTION  | 64     |
| 7   | SERVEUR LOGICIEL   | 128    |
| 8   | BACK UP            | 256    |
| 9   | FIREWALL           | 512    |
| 10  | BASTION            | 1024   |
| 11  | JUMP SERVER        | 2048   |

Exemple : PG-0005-X00001 correspond au serveur DC + DNS (l'AD DS)
           (0001+0004)

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
| Portable de Romain Mathieu | `PG-0000-Y00618` |
| Serveur de fichier pour la direction/Responsables | `PG-0064-X00099` |
| Ordinateur de Saiah | `PG-0000-Z00001` |

## 5. Personnes

Mail : `prenom.nom@pharmgreen.fr`

En cas d'homonymie sur adresse mail, ajout d'un chiffre après le nom avec incrémentation.

#### Matricule

Ajout d'un matricule `U` + 5 chiffres pour utilisateurs lambda et `A` + 5 chiffres pour les Administrateurs. Le A est identique au U pour une question de simplicité.
Pour se connecter à la session : prenom.nom

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
