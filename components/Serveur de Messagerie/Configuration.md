# Configuration du serveur de messagerie

Paramétrage des services du serveur de messagerie : OpenSMTPD, Dovecot, authentification Active Directory (LDAPS), livraison LMTP, sécurités et validation.
 
> **Note —** Ce document suppose l'environnement déjà en place (voir [`installation.md`](installation.md)) : paquets installés, utilisateur/stockage `vmail` créés, CA racine approuvée, services lancés avec leur configuration **par défaut** (certificat auto-signé, authentification PAM locale).
 
## Sommaire
 
- [1. Configuration OpenSMTPD](#1-configuration-opensmtpd)
- [2. Configuration Dovecot (base IMAP + Maildir)](#2-configuration-dovecot-base-imap--maildir)
- [3. Authentification Active Directory (LDAPS)](#3-authentification-active-directory-ldaps)
- [4. Livraison LMTP (OpenSMTPD vers Dovecot)](#4-livraison-lmtp-opensmtpd-vers-dovecot)
- [5. Sécurités et durcissement](#5-sécurités-et-durcissement)
- [6. Validation de bout en bout](#6-validation-de-bout-en-bout)
- [7. Retours d'expérience](#7-retours-dexpérience)
- [8. Compétences REAC](#8-compétences-reac)
---
 
## 1. Configuration OpenSMTPD
 
### 1.1 `/etc/smtpd.conf` (version finale, utilisateurs virtuels)
 
```nginx
# Tables
table aliases  file:/etc/aliases
table virtuals { "@pharmgreen.lan" = vmail }
 
# Écoute
listen on localhost
listen on eth0
 
# Actions
action "local" lmtp "/var/run/dovecot/lmtp" rcpt-to virtual <virtuals>
action "relay" relay
 
# Règles de routage (match)
match from any   for domain "pharmgreen.lan" action "local"
match from local for any                     action "relay"
```
 
> **Important —**
> - `listen on eth0` écoute le service, **pas** une IP de pfSense.
> - `table virtuals { "@pharmgreen.lan" = vmail }` : catch-all. Toute adresse `@pharmgreen.lan` est déclarée valide et rattachée à l'utilisateur système `vmail`. Sans cette table, OpenSMTPD tente un `getpwnam()` (résolution dans `/etc/passwd`) et **rejette** les destinataires virtuels avec `550 Invalid recipient`.
> - `virtual <virtuals>` sur l'action active l'expansion virtuelle (au lieu de `/etc/passwd`).
> - `rcpt-to` transmet l'adresse complète à Dovecot pour le routage final.
> - `from local for any → relay` : seul le relais local est autorisé. Ne **jamais** mettre `from any ... relay` (open-relay).
 
### 1.2 Validation syntaxe + redémarrage
 
```bash
smtpd -n            # doit afficher : configuration OK
systemctl restart opensmtpd
```
 
---
 
## 2. Configuration Dovecot (base IMAP + Maildir)
 
### 2.1 `/etc/dovecot/conf.d/10-mail.conf`
 
> **Attention —** Rupture de syntaxe Dovecot 2.4 : `mail_location` est éclaté en plusieurs réglages. La plupart des tutoriels en ligne (2.3) sont périmés. Vérifier systématiquement avec `doveconf -n` avant tout redémarrage.
 
```ini
mail_driver = maildir
mail_home   = /var/vmail/%{user}
mail_path   = %{home}/Maildir
```
 
### 2.2 Vérification
 
```bash
doveconf -n          # juge de paix : affiche la configuration effective
```
 
---
 
## 3. Authentification Active Directory (LDAPS)
 
Modèle **utilisateurs virtuels** : l'authentification (passdb LDAP → AD) et le stockage (userdb static → `vmail`) sont découplés. Créer un utilisateur dans l'AD le rend automatiquement « mailable » sans toucher au serveur.
 
> **Note —** La confiance envers la CA racine du DC a été établie à l'installation (`update-ca-certificates`). On configure ici l'authentification elle-même.
 
### 3.1 Compte de service AD (moindre privilège)
 
| Attribut | Valeur |
|---|---|
| Nom | `MAILsync` |
| DN | `CN=MAILsync,OU=ComptesServices,OU=Pharmgreen,DC=pharmgreen,DC=lan` |
| Bind (UPN) | `MAILsync@pharmgreen.lan` |
| Droits | lecture seule, `Domain Users` uniquement, mot de passe non expirant |
 
> **Astuce —** Bonne pratique AD : OU dédiée `ComptesServices`. Une OU définit un périmètre de gestion (GPO, délégation), pas l'organigramme RH. Compte de service en lecture seule = moindre privilège.
 
### 3.2 Vérifier le bind LDAPS
 
> **Attention —** L'AD refuse le LDAP en clair. Le contrôleur de domaine refuse le bind LDAP simple (389) : `Strong(er) authentication required`. **LDAPS (636) est obligatoire** d'emblée. C'est un durcissement attendu, pas un défaut.
 
Test (doit réussir **sans** `LDAPTLS_REQCERT=never`, grâce à la CA approuvée) :
 
```bash
ldapsearch -H ldaps://pg-00005-x00001.pharmgreen.lan \
  -D "MAILsync@pharmgreen.lan" -W \
  -b "OU=Utilisateurs,OU=Pharmgreen,DC=pharmgreen,DC=lan" \
  "(objectClass=user)" cn
# attendu : result: 0 Success
```
 
> **Important —** Le nom doit matcher le certificat. Le FQDN (`pg-00005-x00001.pharmgreen.lan`) doit correspondre exactement au CN/SAN du certificat LDAPS du DC. Créer un **Host Override** sur le pfSense externe (résolveur du CT) si nécessaire.
 
### 3.3 `/etc/dovecot/conf.d/auth-ldap.conf.ext`
 
> **Note —** Découverte importante : le `sAMAccountName` des comptes est un matricule (ex. `U00194`), illisible. Les comptes ont un `userPrincipalName` = `prenom.nom@pharmgreen.lan`. On filtre donc sur `userPrincipalName` (canonique, toujours renseigné).
 
```ini
ldap_uris             = ldaps://pg-00005-x00001.pharmgreen.lan
ldap_auth_dn          = MAILsync@pharmgreen.lan
ldap_auth_dn_password = <mot_de_passe_MAILsync>
ldap_base             = OU=Utilisateurs,OU=Pharmgreen,DC=pharmgreen,DC=lan
 
passdb ldap {
  bind   = yes
  filter = (&(objectClass=user)(userPrincipalName=%{user}))
}
 
userdb static {
  fields {
    uid  = vmail
    gid  = vmail
    home = /var/vmail/%{user}
  }
}
```
 
Permissions (le fichier contient le mot de passe en clair) :
 
```bash
chmod 640 /etc/dovecot/conf.d/auth-ldap.conf.ext
chown root:dovecot /etc/dovecot/conf.d/auth-ldap.conf.ext
```
 
> **Attention —** Syntaxe Dovecot 2.4 :
> - Variables : `%{user}` (et non `%u`).
> - `args = fichier` n'existe plus → configuration **inline** directe (comme ci-dessus).
> - En cas d'erreur `Unknown setting`, lire le message complet : il suggère souvent le nouveau nom.
 
### 3.4 Activer LDAP, désactiver PAM
 
Dans `/etc/dovecot/conf.d/10-auth.conf` :
 
```ini
!include auth-ldap.conf.ext
#!include auth-system.conf.ext
```
 
### 3.5 Test d'authentification
 
```bash
systemctl restart dovecot
doveadm auth test lukas.rousseau@pharmgreen.lan
# attendu : auth succeeded
```
 
> **Important —** Format d'identité : l'identifiant est l'UPN complet avec `@domaine`. Ce format doit rester cohérent entre IMAP et LMTP (voir §4), sinon un même utilisateur aurait deux boîtes distinctes selon qu'il reçoit ou consulte.
 
---
 
## 4. Livraison LMTP (OpenSMTPD vers Dovecot)
 
OpenSMTPD livre à Dovecot via le socket LMTP `/var/run/dovecot/lmtp` (déjà câblé dans `action "local"`, §1.1).
 
### 4.1 Le piège de la troncature du domaine
 
> **Attention —** `auth_username_format`. Par défaut, le protocole LMTP de Dovecot applique un filtre qui coupe le domaine :
> `auth_username_format = %{user | username | lower}`
> Le filtre `username` retire `@pharmgreen.lan`. La recherche LDAP devient `(userPrincipalName=lukas.rousseau)` (sans domaine) → aucune correspondance → `550 User doesn't exist`. En IMAP, l'utilisateur se connecte avec l'UPN complet : pas de troncature, ça marche. D'où l'asymétrie IMAP OK / LMTP KO.
 
**Correction** — `/etc/dovecot/conf.d/20-lmtp.conf`, retirer `username` pour conserver l'adresse complète :
 
```ini
auth_username_format = %{user | lower}
```
 
```bash
doveconf -n | grep -A2 'protocol lmtp'   # vérifier le format
systemctl restart dovecot
```
 
### 4.2 Test LMTP direct (court-circuite OpenSMTPD)
 
```bash
nc -U /var/run/dovecot/lmtp <<'EOF'
LHLO test
MAIL FROM:<root@mail.pharmgreen.lan>
RCPT TO:<lukas.rousseau@pharmgreen.lan>
QUIT
EOF
# attendu au RCPT TO : 250 2.1.5 OK   (et non 550)
```
 
> **Astuce —** Méthode de diagnostic : parler LMTP directement au socket isole Dovecot seul et affiche l'erreur réelle en clair, là où OpenSMTPD masque le problème derrière un faux positif `Message accepted for delivery`.
 
---
 
## 5. Sécurités et durcissement
 
| Mesure | Détail |
|---|---|
| LDAPS obligatoire | bind chiffré (636) ; le LDAP clair (389) est refusé par l'AD |
| CA interne approuvée | CA racine AD CS déposée via `update-ca-certificates` ; validation du certificat du DC sans contournement |
| Compte de service à privilèges réduits | `MAILsync` en lecture seule, OU dédiée, mot de passe non expirant |
| Cloisonnement DMZ → LAN | seuls les ports LDAPS (636) ouverts du serveur mail vers le DC ; route hôte `/32` |
| Pas d'open-relay | relais autorisé uniquement `from local` |
| Stockage isolé | utilisateur `vmail` dédié, `nologin`, permissions `770` |
| Secrets protégés | `auth-ldap.conf.ext` en `640 root:dovecot` |

## 6. Validation de bout en bout
 
```bash
swaks --to lukas.rousseau@pharmgreen.lan --server localhost
ls -la /var/vmail/lukas.rousseau@pharmgreen.lan/Maildir/new/
```
 
Résultat attendu : un fichier de mail dans `new/`, propriété `vmail:vmail`.
 
> **Attention —** « Message accepted » ≠ livré. `250 Message accepted for delivery` signifie qu'OpenSMTPD a pris en charge, pas que Dovecot a rangé le mail. Toujours vérifier le fichier physique dans `Maildir/new/` et le log :
> ```
> journalctl -u dovecot -f   # chercher : lmtp ... result=Ok
> ```
 
### Validation client
 
Test CLI (tranche tout) :
 
```bash
openssl s_client -connect mail.pharmgreen.lan:143 -starttls imap
# puis : a login lukas.rousseau@pharmgreen.lan <mdp>  →  a OK Logged in
```
 
> **Astuce —** CLI OK + client GUI KO = problème client. Si `openssl s_client` / `doveadm` passent mais qu'un client graphique échoue, le problème est côté client. **Evolution** est le client validé (IMAP 143 STARTTLS). Le **« nouvel Outlook » (Windows 11) est incompatible** : il route la connexion par Microsoft Cloud, qui ne peut pas joindre un serveur interne (`mail.pharmgreen.lan` non résoluble depuis Internet, IP privée, CA interne inconnue). Utiliser Outlook classique ou un client respectant les standards IMAP/SMTP.
