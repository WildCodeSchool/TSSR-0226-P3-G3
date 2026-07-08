# Installation du rôle DHCP — Pharmgreen

## Serveur cible

| Élément | Valeur |
|---|---|
| VM Proxmox | 304 |
| Hostname | PG-00002-X00002 |
| OS | Windows Server 2022 GUI |
| IP | 172.16.6.2/27 |
| Gateway | 172.16.6.30 |
| DNS | 172.16.6.1 (DC1) |
| Zone réseau | VLAN12 — Serveurs prod |

## Prérequis

- Le serveur est joint au domaine `pharmgreen.lan`
- L'adressage IP statique est configuré
- Connectivité réseau vers DC1 (172.16.6.1) confirmée

## 1. Ajout du rôle DHCP Server

1. Ouvrir **Server Manager** → cliquer sur **Manage** → **Add Roles and Features**


2. Dans le wizard :
   - **Installation Type** : Role-based or feature-based installation
   - **Server Selection** : sélectionner `PG-00002-X00002.pharmgreen.lan`
   - **Server Roles** : cocher **DHCP Server**


3. Un popup propose d'ajouter les outils de gestion (DHCP Management Tools) → cliquer **Add Features**

4. Poursuivre avec **Next** jusqu'à la page de confirmation → cliquer **Install**


5. Attendre la fin de l'installation — ne pas fermer la fenêtre

## 2. Configuration post-installation

Après l'installation, une notification apparaît dans Server Manager (drapeau jaune ⚠️).

1. Cliquer sur le **drapeau de notification** → **Complete DHCP configuration**


2. Le wizard de post-installation s'ouvre :
   - **Authorization** : le serveur DHCP est autorisé dans Active Directory avec les credentials de l'utilisateur connecté (doit être un compte admin du domaine)
   - Cliquer **Commit** → vérifier que les deux étapes affichent ✅ Done


3. Cliquer **Close**

## 3. Vérification

### Vérifier que la console DHCP est accessible

1. **Server Manager** → **Tools** → **DHCP**
2. La console DHCP s'ouvre avec le serveur `pg-00002-x00002.pharmgreen.lan` listé
3. Déplier le serveur → les nœuds **IPv4** et **IPv6** doivent être visibles avec une icône verte ✅

### Vérifier le service

Ouvrir **Services** (`services.msc`) et vérifier :

| Service | Nom | État attendu | Démarrage |
|---|---|---|---|
| DHCP Server | DHCPServer | Running | Automatic |

## Étape suivante

Le rôle est installé et autorisé → passer à la création des scopes dans [Configuration.md](Configuration.md).
