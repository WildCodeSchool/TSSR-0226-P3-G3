# Configuration IP 

## Sommaire 

1. [Référence rapide des équipements fixes](#1-référence-rapide-des-équipements-fixes)
2. [Vue d'ensemble du plan d'adressage](#2-vue-densemble-du-plan-dadressage)
3. [Configuration IP par VLAN](#3-configuration-ip-par-vlan)
   - 3.1 [VLANs utilisateurs](#31-vlans-utilisateurs)
   - 3.2 [VLANs serveurs et DMZ](#32-vlans-serveurs-et-dmz)
4. [Configuration IP des équipements réseau](#4-configuration-ip-des-équipements-réseau)
   - 4.1 [Firewalls pfSense](#41-firewalls-pfsense)
   - 4.2 [Routeurs VyOS](#42-routeurs-vyos)
   - 4.3 [Routes statiques](#43-routes-statiques)
   - 4.4 [Liaisons inter-routeurs](#44-liaisons-inter-routeurs)
5. [Configuration DHCP](#5-configuration-dhcp)
6. [Configuration DNS](#6-configuration-dns)
7. [Récapitulatif de l'utilisation des adresses](#7-récapitulatif-de-lutilisation-des-adresses)
   
---


**Objectifs**

- Segmenter le réseau par département via des VLANs dédiés.
- Attribuer des plages IP adaptées à la taille de chaque département.
- Isoler les serveurs des postes utilisateurs.
- Sécuriser les accès via pfSense (WAN/LAN/DMZ).
- Anticiper la croissance future de l'entreprise.



## 1. Référence rapide des équipements fixes 
<span id="Référence-rapide-des-équipements-fixes"></span>

## VLAN12 | Serveurs de production (172.16.6.0/27)

| Équipement      | Nom VM          | Adresse IP   | Masque          | GATEWAY     | Statut           | ID VM  |
| --------------- | --------------- | ------------ | --------------- | ----------- | ----------------   | ------ |
| DC1 ADDS + DNS  | PG-00005-X00001 | 172.16.6.1   | 255.255.255.224 | 172.16.6.30 | OPERATIONNEL       | 301    |
| DHCP            | PG-00002-X00002 | 172.16.6.2   | 255.255.255.224 | 172.16.6.30 | OPERATIONNEL    | 304             |
| Intranet Web    | PG-00016-X00003 | 172.16.6.3   | 255.255.255.224 | 172.16.6.30 | OPERATIONNEL    | 305             |
| DC2 Core        | PG-00001-X00006 | 172.16.6.4   | 255.255.255.224 | 172.16.6.30 | EN ATTENTE PROMOTION   | 317    |
| DC3 Core        | PG-00001-X00007 | 172.16.6.5   | 255.255.255.224 | 172.16.6.30 | EN ATTENTE PROMOTION   | 318    |
| Graylog         | PG-08192-X00009 | 172.16.6.10  | 255.255.255.224 | 172.16.6.30 | OPERATIONNEL       | 313    |
| Serveur fichier | PG-00032-X00021 | 172.16.6.13  | 255.255.255.224 | 172.16.6.30 | OPERATIONNEL       | 308    |
| Veeam B&R       | PG-00256-X00022 | 172.16.6.14  | 255.255.255.224 | 172.16.6.30 | OPERATIONNEL       | 310    |
| Veeam Repository| PG-00256-X00023 | 172.16.6.15  | 255.255.255.224 | 172.16.6.30 | OPERATIONNEL       | 311    |
| Zabbix (CT)     | PG-16384-X00019 | 172.16.6.19  | 255.255.255.224 | 172.16.6.30 | OPERATIONNEL       | CT 352 |
| VoIP FreePBX    | PG-32768-X00020 | 172.16.6.20  | 255.255.255.224 | 172.16.6.30 | OPERATIONNEL       | 314    |

## VLAN13 | Serveurs admin (172.16.6.32/28)

| Équipement      | Nom VM          | Adresse IP   | Masque          | GATEWAY     | Statut           | ID VM  |
| --------------- | --------------- | ------------ | --------------- | ----------- | ---------------- | ------ |
| GLPI            | PG-04096-X00004 | 172.16.6.34  | 255.255.255.240 | 172.16.6.30 | OPERATIONNEL     | 306    |

## VLAN14 | DMZ (192.168.100.0/28)

| Équipement      | Nom VM          | Adresse IP     | Masque          | GATEWAY        | Statut           | ID VM  |
| --------------- | --------------- | -------------- | --------------- | -------------- | ---------------- | ------ |
| Serveur Web     | PG-00016-X00012 | 192.168.100.2  | 255.255.255.240 | 192.168.100.14 | OPERATIONNEL     | 312    |
| pfSense DMZ     | PG-00512-X00005 | 192.168.100.14 | 255.255.255.240 | 10.0.0.1       | OPERATIONNEL     | 307    |

---
---

## 3. Configuration IP par VLAN

Réseau global : 172.16.0.0/21 DNS pour tous les VLANs : 172.16.6.1 (DC1 AD DS)

---

### 3.1 VLANs utilisateurs

| VLAN   | Département             | Réseau          | Masque          | Gateway      | Broadcast    | Plage utilisable            | Hôtes | Effectif | Bridge  | Statut       |
| ------ | ----------------------- | --------------- | --------------- | ------------ | ------------ | --------------------------- | ----- | -------- | ------- | ------------ |
| VLAN01 | Dev Logiciel            | 172.16.1.0/26   | 255.255.255.192 | 172.16.1.62  | 172.16.1.63  | 172.16.1.1 > 172.16.1.61    | 62    | 18       | vmbr301 | OPERATIONNEL |
| VLAN02 | SI                      | 172.16.1.64/26  | 255.255.255.192 | 172.16.1.126 | 172.16.1.127 | 172.16.1.65 > 172.16.1.125  | 62    | 6        | *       | EN ATTENTE   |
| VLAN03 | R&D                     | 172.16.2.0/25   | 255.255.255.128 | 172.16.2.126 | 172.16.2.127 | 172.16.2.1 > 172.16.2.125   | 126   | 29       | *       | EN ATTENTE   |
| VLAN04 | RH                      | 172.16.3.0/26   | 255.255.255.192 | 172.16.3.62  | 172.16.3.63  | 172.16.3.1 > 172.16.3.61    | 62    | 24       | vmbr304 | OPERATIONNEL |
| VLAN05 | Direction Financière    | 172.16.3.64/26  | 255.255.255.192 | 172.16.3.126 | 172.16.3.127 | 172.16.3.65 > 172.16.3.125  | 62    | 14       | *       | EN ATTENTE   |
| VLAN06 | Services Généraux       | 172.16.3.128/27 | 255.255.255.224 | 172.16.3.158 | 172.16.3.159 | 172.16.3.129 > 172.16.3.157 | 30    | 12       | *       | EN ATTENTE   |
| VLAN07 | Service Juridique       | 172.16.3.160/27 | 255.255.255.224 | 172.16.3.190 | 172.16.3.191 | 172.16.3.161 > 172.16.3.189 | 30    | 9        | *       | EN ATTENTE   |
| VLAN08 | Direction Générale      | 172.16.3.192/27 | 255.255.255.224 | 172.16.3.222 | 172.16.3.223 | 172.16.3.193 > 172.16.3.221 | 30    | 8        | *       | EN ATTENTE   |
| VLAN09 | Ventes & Dev Commercial | 172.16.4.0/25   | 255.255.255.128 | 172.16.4.126 | 172.16.4.127 | 172.16.4.1 > 172.16.4.125   | 126   | 46       | *       | EN ATTENTE   |
| VLAN10 | Direction Marketing     | 172.16.5.0/26   | 255.255.255.192 | 172.16.5.62  | 172.16.5.63  | 172.16.5.1 > 172.16.5.61    | 62    | 21       | *       | EN ATTENTE   |
| VLAN11 | Communication           | 172.16.5.64/26  | 255.255.255.192 | 172.16.5.126 | 172.16.5.127 | 172.16.5.65 > 172.16.5.125  | 62    | 24       | *       | EN ATTENTE   |

Routage :

- VLAN01 : gateway R2 eth1 (172.16.1.62), DHCP relay via R2 > 172.16.6.2
- VLAN04 : gateway R3 eth1 (172.16.3.62), DHCP relay via R3 > 172.16.6.2
- VLAN02-03, 05-11 : scopes DHCP créés sur 172.16.6.2, en attente déploiement routeurs/bridges

VMs clientes déployées :

|VM|Nom VM|IP|Gateway|VLAN|Bridge|Statut|
|---|---|---|---|---|---|---|
|320|PG-00000-Y00150|172.16.1.1 DHCP|172.16.1.62|VLAN01|vmbr301|Joint au domaine pharmgreen.lan|
|321|PG-00000-Y00151|172.16.3.1 DHCP|172.16.3.62|VLAN04|vmbr304|Joint au domaine pharmgreen.lan|

### 3.2 VLANs serveurs et DMZ

|VLAN|Zone|Réseau|Masque|Gateway|Broadcast|Plage utilisable|Hôtes|
|---|---|---|---|---|---|---|---|
|VLAN12|Serveurs prod|172.16.6.0/27|255.255.255.224|172.16.6.30|172.16.6.31|172.16.6.1 > 172.16.6.29|30|
|VLAN13|Serveurs admin|172.16.6.32/28|255.255.255.240|172.16.6.30|172.16.6.47|172.16.6.33 > 172.16.6.46|14|
|VLAN14|DMZ|192.168.100.0/28|255.255.255.240|192.168.100.14|192.168.100.15|192.168.100.1 > 192.168.100.13|14|

Gateway VLAN12 + VLAN13 : R1 eth1 (172.16.6.30) Gateway VLAN14 : pfSense externe (192.168.100.14)

### IPs libres :

- VLAN12 : .6-.9, .11-.12, .16-.18, .21-.29 (18 libres sur 30)
- VLAN13 : .33, .35-.46 (13 libres sur 14)
- VLAN14 : .3-.13 (11 libres sur 14)



## 4. Configuration IP des équipements réseau

### 4.1 Firewalls pfSense

Architecture : DMZ en sandwich (screened subnet) > la DMZ (192.168.100.0/28) est isolée entre deux firewalls pfSense, un côté LAN et un côté WAN.

---

#### pfSense interne (VM 307 | PG-00512-X00005)

Accessible via : https://172.16.7.254
Version : pfSense-CE-2.7.2-RELEASE (FreeBSD 14.0)

Interfaces :

| Interface | Label | Bridge Proxmox | Adresse IP       | Réseau           |
| --------- | ----- | -------------- | ---------------- | ---------------- |
| em1       | LAN   | vmbr300        | 172.16.7.254/21  | 172.16.0.0/21    |
| em0       | DMZ   | vmbr300        | 192.168.100.1/28 | 192.168.100.0/28 |

Gateways :

| Nom     | Interface | Gateway        | Rôle                | Statut       |
| ------- | --------- | -------------- | ------------------- | ------------ |
| WANGW_2 | DMZ       | 192.168.100.14 | Default (IPv4)      | OPERATIONNEL |
| R1VyOS  | LAN       | 172.16.7.253   | Next-hop vers VLANs | OPERATIONNEL |

Routes statiques :

| Destination | Masque | Gateway      | Description       | Statut       |
| ----------- | ------ | ------------ | ----------------- | ------------ |
| 172.16.1.0  | /26    | 172.16.7.253 | VLAN01 Dev via R1 | OPERATIONNEL |
| 172.16.3.0  | /26    | 172.16.7.253 | VLAN04 RH via R1  | OPERATIONNEL |

NAT Outbound : mode Automatic > trafic LAN NATté en 192.168.100.1 vers la DMZ

---

#### pfSense externe

Accessible via : https://192.168.100.14
Version : pfSense-CE-2.7.2-RELEASE (FreeBSD 14.0)

Interfaces :

| Interface | Label | Bridge Proxmox | Adresse IP        | Réseau           |
| --------- | ----- | -------------- | ----------------- | ---------------- |
| em0       | WAN   | vmbr1          | 10.0.0.3/28       | 10.0.0.0/28      |
| em1       | DMZ   | vmbr300        | 192.168.100.14/28 | 192.168.100.0/28 |

Gateway :

| Nom   | Interface | Gateway  | Rôle           | Statut       |
| ----- | --------- | -------- | -------------- | ------------ |
| WANGW | WAN       | 10.0.0.1 | Default (IPv4) | OPERATIONNEL |

Routes statiques : aucune

### 4.2 Routeurs VyOS   


R1 | PG-00000-W00051 (routeur central) | ID VM 333

| Interface | Adresse IP   | Masque | Rôle                    |
| --------- | ------------ | ------ | ----------------------- |
| eth0      | 172.16.7.253 | /21    | > pfSense LAN           |
| eth1      | 172.16.6.30  | /27    | Gateway VLAN12 + VLAN13 |
| eth2      | 172.16.7.249 | /30    | Lien R1 \| R2           |
| eth3      | 172.16.7.245 | /30    | Lien R1 \| R3           |

R2 | PG-00000-W00052 (passerelle VLAN01) | ID VM 334

| Interface | Adresse IP   | Masque | Rôle                     |
| --------- | ------------ | ------ | ------------------------ |
| eth0      | 172.16.7.250 | /30    | R1                       |
| eth1      | 172.16.1.62  | /26    | Gateway VLAN01 \| vmbr301|
| eth2      | 172.16.7.241 | /30    | Lien R2 \| R3            |

DHCP Relay : eth1 > upstream eth0 > server 172.16.6.2 > OPERATIONNEL

R3 | PG-00000-W00053 (passerelle VLAN04) | ID VM 335

| Interface | Adresse IP   | Masque | Rôle                     |
| --------- | ------------ | ------ | ------------------------ |
| eth0      | 172.16.7.246 | /30    | R1                       |
| eth1      | 172.16.3.62  | /26    | Gateway VLAN04 \| vmbr304|
| eth2      | 172.16.7.242 | /30    | Lien R3 \| R2            |

DHCP Relay : écoute sur eth1 > upstream eth0 > server 172.16.6.2 > OPERATIONNEL

### 4.3 Routes statiques

Routes statiques R1

| Destination   | Via          | Description   |
| ------------- | ------------ | ------------- |
| 0.0.0.0/0     | 172.16.7.254 | Default \| pfSense |
| 172.16.1.0/26 | 172.16.7.250 | VLAN01 via R2 |
| 172.16.3.0/26 | 172.16.7.246 | VLAN04 via R3 |

Routes statiques R2

| Destination   | Via          | Description   |
| ------------- | ------------ | ------------- |
| 0.0.0.0/0     | 172.16.7.249 | Default \| R1 |
| 172.16.3.0/26 | 172.16.7.242 | VLAN04 via R3 |

Routes statiques R3

| Destination   | Via          | Description   |
| ------------- | ------------ | ------------- |
| 0.0.0.0/0     | 172.16.7.245 | Default \| R1 |
| 172.16.1.0/26 | 172.16.7.241 | VLAN01 via R2 |

### 4.4 Liaisons inter-routeurs

| Lien       | IP >         | IP <         | Masque |
| ---------- | ------------ | ------------ | ------ |
| R1 \| R2   | 172.16.7.249 | 172.16.7.250 | /30    |
| R1 \| R3   | 172.16.7.245 | 172.16.7.246 | /30    |
| R2 \| R3   | 172.16.7.241 | 172.16.7.242 | /30    |

## 5. Configuration DHCP

Serveur DHCP : 172.16.6.2 (PG-00002-X00002 | Windows Server 2025) | ID VM 304

| VLAN   | Département            | Plage DHCP                   | Gateway      | DNS        | Relay      | Statut                 |
| ------ | ---------------------- | ---------------------------- | ------------ | ---------- | ---------- | ---------------------- |
| VLAN01 | Developpement Logiciel | 172.16.1.1 > 172.16.1.61    | 172.16.1.62  | 172.16.6.1 | R2 eth1 OK | OPERATIONNEL          |
| VLAN02 | SI                     | 172.16.1.65 > 172.16.1.125  | 172.16.1.126 | 172.16.6.1 | /          | Scope créé, en attente |
| VLAN03 | R&D                    | 172.16.2.1 > 172.16.2.125   | 172.16.2.126 | 172.16.6.1 | /          | Scope créé, en attente |
| VLAN04 | RH                     | 172.16.3.1 > 172.16.3.61    | 172.16.3.62  | 172.16.6.1 | R3 eth1 OK | OPERATIONNEL          |
| VLAN05 | Direction Financière   | 172.16.3.65 > 172.16.3.125  | 172.16.3.126 | 172.16.6.1 | /          | Scope créé, en attente |
| VLAN06 | Services Généraux      | 172.16.3.129 > 172.16.3.157 | 172.16.3.158 | 172.16.6.1 | /          | Scope créé, en attente |
| VLAN07 | Service Juridique      | 172.16.3.161 > 172.16.3.189 | 172.16.3.190 | 172.16.6.1 | /          | Scope créé, en attente |
| VLAN08 | Direction Générale     | 172.16.3.193 > 172.16.3.221 | 172.16.3.222 | 172.16.6.1 | /          | Scope créé, en attente |
| VLAN09 | Ventes & Dev Commercial| 172.16.4.1 > 172.16.4.125   | 172.16.4.126 | 172.16.6.1 | /          | Scope créé, en attente |
| VLAN10 | Direction Marketing    | 172.16.5.1 > 172.16.5.61    | 172.16.5.62  | 172.16.6.1 | /          | Scope créé, en attente |
| VLAN11 | Communication          | 172.16.5.65 > 172.16.5.125  | 172.16.5.126 | 172.16.6.1 | /          | Scope créé, en attente |

