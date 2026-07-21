# Installer et Configurer Snort sur Pfsense
--------------------------------------------------------------------------
## Sommaire

- [Installation](#Installation)
- [Configuration](#Configuration)
--------------------------------------------------------------------------

## Installation

**1. Installer le package**
`System > Package Manager` → installer **Snort**.

**2. Global Settings**
`Services > Snort > Global Settings`

- Cocher **Snort GPLv2 Community Rules**
- Cocher **Emerging Threats Open Rules**
- Laisser décoché : Snort VRT (nécessite un compte snort.org / Oinkmaster code) et Emerging Threats Pro (payant)
- **Update Interval** : `12 hours`
- **Update Start Time** : valeur par défaut
- Cliquer **SAVE**

**3. Télécharger les règles**
`Services > Snort > Updates`

- Cliquer **Update Rules**
- Vérifier que le tableau affiche un hash MD5 + date pour chaque package, et **Result: Success**

**4. Créer l'interface Snort**
`Services > Snort > Snort Interfaces` → icône **+**

- Choisir l'interface **DMZ**
- Donner une description (ex: `DMZ`)
- **SAVE**

## Configuration

**5. Sélectionner les catégories de règles**
Éditer l'interface (icône crayon) → onglet **DMZ Categories**

Catégories cochées pour protéger des serveurs exposés :
- `emerging-attack_response`
- `emerging-exploit`
- `emerging-scan`
- `emerging-web_server`
- `emerging-web_specific_apps`
- `emerging-sql`
- `emerging-shellcode`
- `emerging-current_events`
- `emerging-icmp`

**SAVE**

## 6. Vérifier les variables réseau (DMZ Variables)
Onglet **DMZ Settings** → section "Choose the Networks Snort Should Inspect and Whitelist" :

- **Home Net** : `default` (pfSense détecte automatiquement les réseaux locaux, WAN IP, gateways, VPNs, VIPs — rien à changer)
- **External Net** : `default` (tout ce qui n'est pas Home Net)

Rien à modifier ici sauf besoin spécifique (serveur DNS/SQL dédié en DMZ à préciser dans "Define Servers").

## 7. Démarrer Snort
`Services > Snort > Snort Interfaces` → cliquer sur l'icône rouge ❌ à côté de la ligne DMZ → passe au vert ✅ une fois démarré.

Vérifier que **Blocking Mode = DISABLED** au départ (mode observation, pas de blocage automatique).

## 8. Tester que la détection fonctionne
Point clé : Snort ne voit que le trafic qui **traverse réellement l'interface pfSense** (pas le trafic intra-réseau/même sous-réseau, qui est commuté en direct au niveau 2).

Test simple et fiable, depuis une machine dont le trafic passe par la DMZ :
```
curl http://testmyids.com/
```
→ Doit générer une alerte `GPL ATTACK_RESPONSE id check returned root` (SID `1:2100498`) visible dans `Services > Snort > Alerts` (sélectionner l'interface DMZ).

Exemples d'Alertes constatées :

![Alertes](./Ressource/Alertes.png)

Exemples d'adresses bloquées :

![Blocages](./Ressource/Blocages.png)

Note : un simple ping ICMP ou un `nmap -sT` (connect scan poli) ne déclenchent généralement **aucune alerte** avec les catégories de base ci-dessus — c'est normal, pas un signe de mauvaise config.

## 9. Étapes suivantes (après quelques jours d'observation)
- **Suppression List** : ajouter les faux positifs identifiés (icône ➕ sur une alerte) plutôt que de désactiver toute une règle.
- **Pass Lists** : ajouter les IP de confiance (poste admin, supervision Zabbix, etc.) qui scannent régulièrement la DMZ, avant d'activer le blocage.
- **Block Offenders** : à activer une fois le tri des faux positifs terminé, pour bloquer automatiquement les IP déclenchant des règles critiques.
- **Log Mgmt** : vérifier la rotation/rétention des logs pour ne pas saturer le disque.
- Envisager une seconde instance Snort sur le **pfSense interne (LAN ↔ DMZ)** pour détecter un rebond depuis un serveur DMZ compromis vers le LAN (défense en profondeur).
