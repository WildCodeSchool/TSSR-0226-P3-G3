# Installation des routeurs VyOS - Pharmgreen

## Template source

Les 3 routeurs sont clonés depuis le template **Template-Vyos-1.5** disponible sur le cluster Proxmox `wcs-infra-cyber-node1`.

## Déploiement d'un routeur

1. Dans Proxmox, clic droit sur **Template-Vyos-1.5** → **Clone**
2. Renseigner :
   - **VM ID** : selon le plan (333 pour R1, 334 pour R2, 335 pour R3)
   - **Name** : hostname selon la nomenclature (ex : `PG-00000-W00051`)
   - **Mode** : Full Clone
   - **Target Storage** : local
3. Cliquer **Clone**

## Configuration réseau Proxmox (bridges)

Avant de démarrer la VM, assigner les interfaces réseau aux bons bridges :

### R1 (VM 333)

| Interface VM | Bridge Proxmox | Réseau |
|-|-|-|
| net0 (eth0) | vmbr300 | LAN pfSense |
| net1 (eth1) | vmbr300 | VLAN12/13/14 Serveurs |
| net2 (eth2) | lien R1↔R2 |  |
| net3 (eth3) | lien R1↔R3 |  |

### R2 (VM 334)

| Interface VM | Bridge Proxmox | Réseau |
|-|-|-|
| net0 (eth0) | lien R1↔R2 |  |
| net1 (eth1) | vmbr301 | VLAN01 Dev |
| net2 (eth2) | lien R2↔R3 |  |
| net3 (eth3) | vmbr302 | VLAN02 SI |

### R3 (VM 335)

| Interface VM | Bridge Proxmox | Réseau |
|-|-|-|
| net0 (eth0) | lien R1↔R3 |  |
| net1 (eth1) | vmbr304 | VLAN04 RH |
| net2 (eth2) | lien R2↔R3 |  |

## Premier démarrage

1. Démarrer la VM → ouvrir la console
2. Login : `vyos` / `vyos`
3. Passer le clavier en français :

```
configure
set system option keyboard-layout fr
commit
save
exit
```

4. Passer à la configuration des interfaces → voir [Configuration.md](Configuration.md)
