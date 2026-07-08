# Service DHCP | Pharmgreen

## Vue d'ensemble

Le service DHCP centralise l'attribution dynamique d'adresses IP pour l'ensemble des VLANs utilisateurs (VLAN01 à VLAN11) de l'infrastructure Pharmgreen.

|Élément|Détail|
|---|---|
|**Serveur**|PG-00002-X00002 (VM 304)|
|**OS**|Windows Server 2022|
|**IP**|172.16.6.2/27|
|**Gateway**|172.16.6.30 (R1 eth1)|
|**Zone réseau**|VLAN12 — Serveurs prod|
|**Domaine**|pharmgreen.lan|
|**Nombre de scopes**|11 (un par VLAN utilisateur)|

## Architecture DHCP Relay

Les clients des différents VLANs n'étant pas sur le même sous-réseau que le serveur DHCP, des relais DHCP sont configurés pour transférer les requêtes :

```
Client VLAN01 (172.16.1.0/26)
    └──► R2 eth1 (DHCP relay) ──► 172.16.6.2

Client VLAN02 (172.16.1.64/26)
    └──► R2 eth3 (DHCP relay) ──► 172.16.6.2

Client VLAN04 (172.16.3.0/26)
    └──► R3 eth1 (DHCP relay) ──► 172.16.6.2

Autres VLANs (03, 05-11)
    └──► pfSense interne LAN (DHCP relay) ──► 172.16.6.2
```

## Fichiers

|Fichier|Contenu|
|---|---|
|`INSTALL.md`|Procédure d'installation du rôle DHCP sur Windows Server|
|`CONFIG.md`|Configuration des scopes, options et relais DHCP|

## Prérequis

- Windows Server 2022 joint au domaine `pharmgreen.lan`
- Adressage IP statique configuré (172.16.6.2/27, GW 172.16.6.30, DNS 172.16.6.1)
- Connectivité réseau vers les routeurs VyOS et le pfSense interne
