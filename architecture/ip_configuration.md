# Configuration IP 

## Sommaire 

---


**Objectifs**

- Segmenter le réseau par département via des VLANs dédiés.
- Attribuer des plages IP adaptées à la taille de chaque département.
- Isoler les serveurs des postes utilisateurs.
- Sécuriser les accès via pfSense (WAN/LAN/DMZ).
- Anticiper la croissance future de l'entreprise.


## Référence rapide des équipements fixe 

| Équipement      | Nom VM         | Adresse IP  | Masque          | GAWTEAY  | Statut |
| --------------- | -------------- | ----------- | --------------- | ----------- | ------ |
| ADDS + DNS     | PG-0005-X00001 | 172.16.6.1  | 255.255.255.224 | 172.16.6.30 | OPERATIONNEL      |
| DHCP            | PG-0002-X00002 | 172.16.6.2  | 255.255.255.224 | 172.16.6.30 | OPERATIONNEL      |
| Intranet Web    | PG-0016-X00003 | 172.16.6.3  | 255.255.255.224 | 172.16.6.30 | OPERATIONNEL      |
| Serveur fichier | PG-0032-X00018 | 172.16.6.13 | 255.255.255.224 | 172.16.6.30 | OPERATIONNEL      |


## Routeur VyOS

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

