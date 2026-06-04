# Configuration IP 

## Sommaire 

- [1. Référence rapide des équipement fixes](#1-Référence-rapide-des-équipements-fixes)
 
---


**Objectifs**

- Segmenter le réseau par département via des VLANs dédiés.
- Attribuer des plages IP adaptées à la taille de chaque département.
- Isoler les serveurs des postes utilisateurs.
- Sécuriser les accès via pfSense (WAN/LAN/DMZ).
- Anticiper la croissance future de l'entreprise.



## 1.Référence rapide des équipements fixes 

| Équipement      | Nom VM         | Adresse IP  | Masque          | GAWTEAY  | Statut |
| --------------- | -------------- | ----------- | --------------- | ----------- | ------ |
| ADDS + DNS     | PG-0005-X00001 | 172.16.6.1  | 255.255.255.224 | 172.16.6.30 | OPERATIONNEL      |
| DHCP            | PG-0002-X00002 | 172.16.6.2  | 255.255.255.224 | 172.16.6.30 | OPERATIONNEL      |
| Intranet Web    | PG-0016-X00003 | 172.16.6.3  | 255.255.255.224 | 172.16.6.30 | OPERATIONNEL      |
| Serveur fichier | PG-0032-X00018 | 172.16.6.13 | 255.255.255.224 | 172.16.6.30 | OPERATIONNEL      |

## Routeur VyOS

| Équipement | Nom VM         | Interface | Adresse IP   | Masque | Rôle           |
| ---------- | -------------- | --------- | ------------ | ------ | -------------- |
| R1         | PG-0000-W00051 | eth0      | 172.16.7.253 | /21    | > pfSense      |
| R1         | PG-0000-W00051 | eth1      | 172.16.6.30  | /27    | Gateway VLAN12 |
| R1         | PG-0000-W00051 | eth2      | 172.16.7.249 | /30    | Lien R1 \| R2  |
| R1         | PG-0000-W00051 | eth3      | 172.16.7.245 | /30    | Lien R1 \| R3  |
| R2         | PG-0000-W00052 | eth0      | 172.16.7.250 | /30    | Lien R2 \| R1  |
| R2         | PG-0000-W00052 | eth1      | 172.16.1.62  | /26    | Gateway VLAN01 |
| R2         | PG-0000-W00052 | eth2      | 172.16.7.241 | /30    | Lien R2 \| R3  |
| R3         | PG-0000-W00053 | eth0      | 172.16.7.246 | /30    | Lien R3 \| R1  |
| R3         | PG-0000-W00053 | eth1      | 172.16.3.62  | /26    | Gateway VLAN04 |
| R3         | PG-0000-W00053 | eth2      | 172.16.7.242 | /30    | Lien R3 \| R2  |

COnfiguration IP des équipements réseau 

pfSense principale :

| Interface | Bridge Proxmox | Adresse IP      | Réseau        |
| --------- | -------------- | --------------- | ------------- |
| WAN       | vmbr1          | 10.0.0.3/28     | 10.0.0.0/28   |
| LAN       | vmbr300        | 172.16.7.254/21 | 172.16.0.0/21 |

Routes statiques pfSense

| Destination | Masque | Gateway      | Description       | Statut |
| ----------- | ------ | ------------ | ----------------- | ------ |
| 172.16.1.0  | /26    | 172.16.7.253 | VLAN01 Dev via R1 | OPERATIONNEL      |
| 172.16.3.0  | /26    | 172.16.7.253 | VLAN04 RH via R1  | OPERATIONNEL      |












## Résumé des plages d'adressage par VLAN 

| Plage             | Usage                            |
| ---------------- | -------------------------------- |
| 172.16.1.0/26    | VLAN01 | Dev Logiciel            |
| 172.16.1.64/26   | VLAN02 | SI                      |
| 172.16.2.0/25    | VLAN03 | R&D                     |
| 172.16.3.0/26    | VLAN04 | RH                      |
| 172.16.3.64/26   | VLAN05 | Dir Financière          |
| 172.16.3.128/27  | VLAN06 | Services Généraux       |
| 172.16.3.160/27  | VLAN07 | Service Juridique       |
| 172.16.3.192/27  | VLAN08 | Direction Générale      |
| 172.16.4.0/25    | VLAN09 | Ventes & Dev Commercial |
| 172.16.5.0/26    | VLAN10 | Dir Marketing           |
| 172.16.5.64/26   | VLAN11 | Communication           |
| 172.16.6.0/27    | VLAN12 | Serveurs prod           |
| 172.16.6.32/28   | VLAN13 | Serveurs admin          |
| 192.168.100.0/28 | VLAN14 | DMZ                     |
| 172.16.7.240/30  | Liaison R1|R3                    |
| 172.16.7.244/30  | Liaison R1|R2                    |
| 172.16.7.248/30  | Liaison R2|R1                    |


















