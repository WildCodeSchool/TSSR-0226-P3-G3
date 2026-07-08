# Routage - Pharmgreen

## Vue d'ensemble

Le routage inter-VLAN de l'infrastructure Pharmgreen repose sur 3 routeurs VyOS et le pfSense interne. Chaque routeur dessert un ou plusieurs VLANs utilisateurs et transfère le trafic vers le réseau serveurs (VLAN12) via R1.

## Architecture

```
Internet
   │
pfSense externe (10.0.0.3)
   │
pfSense interne (172.16.7.254/21) ◄── gateway par défaut
   │
R1 (172.16.7.253) ◄── routeur central
   ├── eth0 → pfSense (172.16.7.253/21)
   ├── eth1 → VLAN12 Serveurs (172.16.6.30/27)
   │          VLAN13 Serveurs admin (172.16.6.46/28)
   │          VLAN14 Bastion (172.16.6.54/29)
   ├── eth2 → R2 (172.16.7.249/30)
   └── eth3 → R3 (172.16.7.245/30)

R2 (172.16.7.250) ◄── VLANs Dev + SI
   ├── eth0 → R1 (172.16.7.250/30)
   ├── eth1 → VLAN01 Dev (172.16.1.62/26)
   ├── eth2 → R3 (172.16.7.241/30)
   └── eth3 → VLAN02 SI (172.16.1.126/26)

R3 (172.16.7.246) ◄── VLAN RH
   ├── eth0 → R1 (172.16.7.246/30)
   ├── eth1 → VLAN04 RH (172.16.3.62/26)
   └── eth2 → R2 (172.16.7.242/30)
```

## Équipements

| Équipement | VM Proxmox | Hostname | Rôle |
|-|-|-|-|
| R1 | 333 | PG-00000-W00051 | Routeur central, gateway VLAN12/13/14 |
| R2 | 334 | PG-00000-W00052 | Gateway VLAN01 Dev + VLAN02 SI |
| R3 | 335 | PG-00000-W00053 | Gateway VLAN04 RH |
| pfSense interne | 307 | PG-00512-X00005 | Frontière LAN/DMZ, routes statiques vers VLANs |

## Liaisons inter-routeurs

| Lien | IP côté A | IP côté B | Masque |
|-|-|-|-|
| R1 ↔ R2 | 172.16.7.249 | 172.16.7.250 | /30 |
| R1 ↔ R3 | 172.16.7.245 | 172.16.7.246 | /30 |
| R2 ↔ R3 | 172.16.7.241 | 172.16.7.242 | /30 |

## Fichiers

| Fichier | Contenu |
|-|-|
| `Installation.md` | Déploiement des routeurs VyOS depuis le template Proxmox |
| `Configuration.md` | Interfaces, routes statiques, DHCP relay, config pfSense |
