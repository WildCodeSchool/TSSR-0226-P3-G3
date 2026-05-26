

## 1. Nom de domaine

`@pharmgreen.lan` pour le nom de domaine FQDN de notre forêt.

## 2. OU

La hiérarchie des OU se composera de **3 niveaux**.

| Niveau | Contenu |
|---|---|
| DC | `pharmgreen.lan` |
| OU principales | OU=Ville / OU=Users / OU=Computers |
| Sous-OU de Lyon | Départements (11) |
| Sous-OU de Département | Services (50) |
| Sous-OU de service | Ou=Users / Ou=Computers |

```text
pharmgreen.lan
├─ OU=Users            ← ensemble des utilisateurs
├─ OU=Computers        ← ensemble des ordinateurs
└─ OU=<Ville>              ex : Lyon
     └─ OU=<Département>       ex : Communication
          └─ OU=<Service>          ex : Publicité
               ├─ OU=Users
               └─ OU=Computers
```

### Départements (sous-OU de Lyon)

| Code | Département |
|---|---|
| COM | Communication |
| DEV | Développement logiciel |
| FIN | Direction Financière |
| DIR | Direction Générale |
| MARK | Direction marketing |
| RD | R&D |
| RH | RH |
| JUR | Service Juridique |
| SG | Services Généraux |
| SI | Systèmes d'information |
| VDC | Vente et développement commercial |



### Schéma OU

```text
OU=service, OU=département, OU=ville, DC=pharmagreen, DC=lan
```

Exemple :
```text
OU=Publicité ; OU=Communication, OU=Lyon, DC=pharmagreen, DC=lan
```

## 3. Groupes de sécurité

| Type | Format | Exemple |
|---|---|---|
| Utilisateur | Type de groupe (Local, global, universel) - Département - fonction | `GL-COM-Photographe` |
| Ordinateur | Type de groupe (local, global, universel) - Département - service.type | `GL-DEV-Developpement.laptop` |
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
| Serveur de fichier pour la direction/Responsables | `LY-SRV-SDFD-S00619` |

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
| USER | Utilisateur |
| SERVEUR | Serveur |
| CLIENT | Clients |

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
