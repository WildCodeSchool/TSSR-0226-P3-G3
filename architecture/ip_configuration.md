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



## 1.Référence rapide des équipements fixes 
<span id="Référence-rapide-des-équipements-fixes"></span>

## VLAN12 | Serveurs de production (172.16.6.0/27)

| Équipement      | Nom VM          | Adresse IP   | Masque          | GATEWAY     | Statut           | ID VM  |
| --------------- | --------------- | ------------ | --------------- | ----------- | ----------------   | ------ |
| DC1 ADDS + DNS  | PG-00005-X00001 | 172.16.6.1   | 255.255.255.224 | 172.16.6.30 | OPERATIONNEL       | 301    |
| DHCP            | PG-00002-X00002 | 172.16.6.2   | 255.255.255.224 | 172.16.6.30 | OPERATIONNEL       | 304    |
| Intranet Web    | PG-00016-X00003 | 172.16.6.3   | 255.255.255.224 | 172.16.6.30 | OPERATIONNEL       | 305    |
| DC2 Core        | PG-00005-X00006 | 172.16.6.4   | 255.255.255.224 | 172.16.6.30 | EN ATTENTE PROMO   | 315    |
| DC3 Core        | PG-00005-X00007 | 172.16.6.5   | 255.255.255.224 | 172.16.6.30 | CONFIG EN COURS    | 316    |
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
| Web externe     | PG-00016-X00012 | 192.168.100.2  | 255.255.255.240 | 192.168.100.14 | OPERATIONNEL     | 312    |
| pfSense DMZ     | PG-00512-X00005 | 192.168.100.14 | 255.255.255.240 | 10.0.0.1       | OPERATIONNEL     | 307    |

---
---


