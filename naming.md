

## 1. Nom de domaine

`@pharmgreen.lan` pour le nom de domaine FQDN de notre forêt.

## 2. OU

La hiérarchie des OU se composera de **2 niveaux**.

| Niveau | Contenu |
|---|---|
| DC | `pharmgreen.lan` |
| OU principales | / OU=Utilisateurs / OU=Ordinateurs / OU=Administrateurs / OU=Département |
| Sous-OU de Département | Services (50) |

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

| Code | Ville |
|---|---|
| LY | Lyon |

### Type Client vs serveur

| Code | Type |
|---|---|
| CLT | Client |
| SRV | Serveur |

### Fonction si serveur

| Bit | ROLE               | VALEUR |
| --- | ------------------ | ------ |
| 0   | CONTROLEUR DOMAINE | 1      |
| 1   | WEB                | 2      |
| 2   | DNS                | 4      |
| 3   | MAIL               | 8      |
| 4   | DHCP               | 16     |
| 5   | SERVEUR FICHIER    | 32     |
| 6   | SERVEUR LOGICIEL   | 64     |
| 7   | BACK UP            | 128    |
| 8   | FIREWALL           | 256    |


| Code | Fonction |
|---|---|
| WEB | site web (intra ou extra) |
| MAIL | Messagerie |
| DC | Contrôleur de domaine (AD DS) |
| DNS | DNS |
| DHCP | DHCP |
| SDF | Serveur de fichiers |
| SDFD | Serveurs de fichiers Direction/Responsables |
| SAAS | Serveurs logiciel (Software as a service) |
| BAK | Backup |
| FIR | Firewall |

### Matricule / Nom machine

Une lettre (V, P, F, S, M, T) associée à un numéro unique en liste commençant à `00001`.

| Lettre | Type |
|---|---|
| V | VM |
| P | Portable |
| F | Ordinateur fixe |
| S | Serveur |
| M | Mobile |
| T | Tablette |

**Exemples :**

| Cas | Nom machine |
|---|---|
| Portable de Romain Mathieu | `LY-CLT-P00618` |
| Serveur de fichier pour la direction/Responsables | `LY-SRV-SDFD-S99` |

## 5. Personnes

Mail : `prenom.nom@pharmgreen.fr`

En cas d'homonymie sur adresse mail, ajout d'un chiffre après le nom avec incrémentation.

#### Matricule

Ajout d'un matricule `U` + 5 chiffres pour utilisateurs lambda et `A` + 5 chiffres pour les Administrateurs. Le A est identique au U pour une question de simplicité.

**Exemples :**

| Personne | Adresse mail | Matricule |
|---|---|---|
| John Doe (Communication) | `john.doe@pharmgreen.fr` | `U00042` |
| Cédric Bourré (Technicien support) | `cedric.bourre@pharmgreen.fr` | `U00108` (utilisateur) / `A00108` (infrastructure) |

## 6. GPO

### Cible

| Valeur | Cible |
|---|---|
| USER | Utilisateurs |
| COMPUTER | Ordinateurs |

### Type

| Type |
|---|
| STANDARD |
| SECURITE |

### Portée

| Valeur | Portée |
|---|---|
| LOCAL | Local |
| GLOBAL | Global |

### Département

Voir naming point 2

### Fonction

La fonction du GPOestexplicitement détailléen quelques mots attachés

### Date de révision

`YYYYMMDD` au format ISO 8601 pour faliciter le tri chronologique.

### Exemple

GPO définissant la longueur et composition des mots de passe :

```text
USER-SECURITE-GLOBAL-strategiemotdepasse-20260525
```
