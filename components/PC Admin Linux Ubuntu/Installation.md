La procédure d'installation suivante a été réalisé sur la version Ubuntu 24.04 LTS, cependant la version la plus récente actuellement disponible étant la version Ubuntu 26.04 LTS les pré-requis techniques seront ceux adaptés à cette nouvelle version.

Vous trouverez cette dernière version en [cliquant ici](https://ubuntu.com/download/desktop)
## Pré-requis techniques

-  Un processeur de 2 coeurs 2Ghz à minima
-  Au moins 6 GB de mémoire RAM
-  25 GB d'espace libre sur le disque dur de la machine


> A suivre : la procédure d'installation des outils d'administration système et réseau.
> Toutes les commandes sont à exécuter dans un terminal avec les droits `sudo`.

---

## Liste des logiciels

### c. Administration des serveurs Windows

| Logiciel | Rôle |
|---|---|
| **Remmina** (+ plugins RDP / VNC / secret) | Client RDP / SSH / VNC graphique |
| **FreeRDP** (`freerdp2-x11`) | Client RDP en ligne de commande |
| **rdesktop** | Client RDP léger |
| **PowerShell** | Shell et scripting cross-platform |

### b. Administration des serveurs Linux

| Logiciel | Rôle |
|---|---|
| **htop / iftop / ncdu** | Monitoring CPU-RAM / réseau / espace disque |
| **Cockpit** | Interface web d'administration système |
| **Netdata** | Monitoring en temps réel |

### c. Logiciels et outils multi-OS

| Logiciel | Rôle |
|---|---|
| **OpenSSH** (client + serveur) | Accès distant SSH |
| **Wireshark** | Analyse réseau |
| **Trippy** (binaire `trip`) | Diagnostic réseau (traceroute + ping en TUI) |

---

## Pré-requis

Mise à jour du système et installation des outils de base :

```bash
sudo apt update
sudo apt full-upgrade -y
sudo apt install -y ca-certificates curl wget gpg lsb-release \
  apt-transport-https software-properties-common
```

---

## 1. Administration des serveurs Windows

### Remmina (+ plugins)

```bash
sudo apt install -y remmina remmina-plugin-rdp remmina-plugin-vnc remmina-plugin-secret
```

### FreeRDP

```bash
sudo apt install -y freerdp2-x11
```

> Binaire : `xfreerdp`.
> Alternative plus récente sur 24.04 : `freerdp3-x11` (binaire `xfreerdp3`).

### rdesktop

```bash
sudo apt install -y rdesktop
```

### PowerShell

Installation via le paquet officiel Microsoft (auto-détecte la version d'Ubuntu) :

```bash
wget -q "https://packages.microsoft.com/config/ubuntu/$(lsb_release -rs)/packages-microsoft-prod.deb"
sudo dpkg -i packages-microsoft-prod.deb
rm packages-microsoft-prod.deb
sudo apt update
sudo apt install -y powershell
```

Lancement :

```bash
pwsh
```

---

## 2. Administration des serveurs Linux

### htop / iftop / ncdu

```bash
sudo apt install -y htop iftop ncdu
```

### Cockpit

```bash
sudo apt install -y cockpit
sudo systemctl enable --now cockpit.socket
```

> Accès web : `https://<IP_du_poste>:9090`

### Netdata

Installation via le script officiel `kickstart` :

```bash
wget -O /tmp/netdata-kickstart.sh https://get.netdata.cloud/kickstart.sh
sudo sh /tmp/netdata-kickstart.sh --dont-wait --disable-telemetry
```

> `--dont-wait` : pas de prompt interactif.
> `--disable-telemetry` : pas de remontée de stats anonymes.
> Dashboard local : `http://localhost:19999`

---

## 3. Logiciels et outils multi-OS

### OpenSSH (client + serveur)

```bash
sudo apt install -y openssh-client openssh-server
sudo systemctl enable --now ssh
```

### Wireshark

```bash
sudo apt install -y wireshark
```

> Répondre **Oui** à la question « *non-superusers should be able to capture packets* ».

Autoriser la capture sans `sudo` (à reconfigurer si tu as répondu Non) :

```bash
sudo dpkg-reconfigure wireshark-common
sudo usermod -aG wireshark $USER
```

> Déconnexion / reconnexion nécessaire pour que l'ajout au groupe soit pris en compte.

### Trippy

Installation via le PPA officiel du développeur (binaire `trip`) :

```bash
sudo add-apt-repository -y ppa:fujiapple/trippy
sudo apt update
sudo apt install -y trippy
```

Utilisation :

```bash
sudo trip 8.8.8.8
```


 *Si le PPA ne couvre pas ta version d'Ubuntu, alternative via cargo :*
```bash
sudo apt install -y cargo
cargo install trippy   # binaire dans ~/.cargo/bin/trip
```

