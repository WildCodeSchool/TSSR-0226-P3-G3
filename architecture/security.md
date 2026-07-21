## Audits de Sécurité
------------------------------------------------------------------------------------------
## Sommaire
- [Audit des Web intranet et externe](#Audit-des-Web-intranet-et-externe)
- [](#Création-des-OU)
- [](#Création-des-Groupes-de-Sécurité)
------------------------------------------------------------------------------------------
**Prérequis techniques :**

Avoir une VM Admin sur la quelle est installée `shcheck.py` 

# Audit des Web intranet et externe

**Étapes à suivre :**

Pour auditer la page web intranet entrer la cmd suivante : (elle va lancer le diagnostic shcheck)

```bash
cd ~/shcheck
./shcheck.py -d -g https://intranet.pharmgreen.lan
```

<img width="1009" height="627" alt="ShCheck intra" src="https://github.com/user-attachments/assets/a4aa343c-c909-43df-8bdf-e9ff486daf09" />

Dans `/srv/intranet/Caddyfile`, un bloc snippet est défini une seule fois et importé dans chaque site :

```caddyfile
(security-headers) {
    header {
        # 1. Protection Clickjacking
        X-Frame-Options "SAMEORIGIN"

        # 2. Empêcher le MIME Sniffing
        X-Content-Type-Options "nosniff"

        # 3. Forcer le HTTPS (HSTS)
        Strict-Transport-Security "max-age=31536000; includeSubDomains"

        # 4. Politique de Referrer
        Referrer-Policy "no-referrer-when-downgrade"

        # 5. CSP de base (autorise le site lui-même + CDN icônes)
        Content-Security-Policy "default-src 'self'; img-src 'self' data: https://cdn.jsdelivr.net; script-src 'self' 'unsafe-inline'; style-src 'self' 'unsafe-inline'"

        # 6. Isolation d'origine (sans COEP, qui casse les assets externes)
        Cross-Origin-Opener-Policy "same-origin"
        Cross-Origin-Resource-Policy "same-site"

        # 7. Restriction des API navigateur sensibles
        Permissions-Policy "geolocation=(), microphone=(), camera=()"

        # Masquer la signature Caddy
        -Server
    }
}
```

Un second snippet bloque les méthodes HTTP dangereuses :

```caddyfile
(block-bad-methods) {
    @blockedMethods {
        method TRACE TRACK
    }
    respond @blockedMethods "Method Not Allowed" 405
}
```

<img width="699" height="217" alt="Blocage TRACE TRACK" src="https://github.com/user-attachments/assets/0eda6dae-04ed-4a3f-a854-ebfce044c7f4" />


**1.2 Recharger Caddy** (sans coupure de service)

```bash
docker exec -it intranet-caddy-1 caddy reload --config /etc/caddy/Caddyfile
```

Nettoyage du formatage (optionnel, corrige le warning `Caddyfile input is not formatted`) :
```bash
docker exec -it intranet-caddy-1 caddy fmt --overwrite --config /etc/caddy/Caddyfile
```

**1.3 Vérifier**

```bash
docker ps | grep caddy        # doit afficher "Up X minutes", pas "Restarting"
docker logs intranet-caddy-1 --tail 30
```

**1.4 Web Externe**

- Côté Apache le principe est le même mais les headers HTTP ne peuvent pas être ajoutés dans `index.html` — uniquement dans la config Apache, via le module `mod_headers`.
- 
**1.5 Localiser le bon vhost**

- Plusieurs fichiers existent dans `/etc/apache2/sites-available/`, mais seul celui avec `ServerName www.pharmgreen.lan` et le bon `DocumentRoot` est actif pour ce domaine :

```bash
ls /etc/apache2/sites-available/
# -> grav.conf (DocumentRoot /var/www/grav) = le bon fichier
```
- Activer le module headers

```bash
a2enmod headers
```

**1.6 Config finale de `grav.conf`**

```apache
<VirtualHost *:443>
    ServerName www.pharmgreen.lan
    DocumentRoot /var/www/grav

    SSLEngine on
    SSLCertificateFile /etc/ssl/pharmgreen/fullchain.www.pharmgreen.pem
    SSLCertificateKeyFile /etc/ssl/pharmgreen/www.pharmgreen.key

    # Protection Clickjacking
    Header always set X-Frame-Options "SAMEORIGIN"

    # Empêcher le MIME Sniffing
    Header always set X-Content-Type-Options "nosniff"

    # Forcer le HTTPS (HSTS)
    Header always set Strict-Transport-Security "max-age=31536000; includeSubDomains"

    # Politique de Referrer
    Header always set Referrer-Policy "no-referrer-when-downgrade"

    # CSP de base
    Header always set Content-Security-Policy "default-src 'self'; img-src 'self' data:; script-src 'self' 'unsafe-inline'; style-src 'self' 'unsafe-inline'"

    # Isolation d'origine
    Header always set Cross-Origin-Opener-Policy "same-origin"
    Header always set Cross-Origin-Resource-Policy "same-site"

    # Permissions
    Header always set Permissions-Policy "geolocation=(), microphone=(), camera=()"

    <Directory /var/www/grav>
        Require all granted
        AllowOverride All
    </Directory>
</VirtualHost>
```

**1.7 Masquer la version Apache** (optionnel)

Dans `/etc/apache2/conf-available/security.conf` :
```apache
ServerTokens Prod
ServerSignature Off
```

**1.8 Vérifier la syntaxe et recharger**

```bash
apache2ctl configtest
systemctl reload apache2
```
**1.9 Relancer les tests**

<img width="953" height="628" alt="ShCheck intra resolu" src="https://github.com/user-attachments/assets/f89123e7-1ada-4716-a3a9-7dcbc5b1d933" />

<img width="959" height="626" alt="ShCheck externe resolu" src="https://github.com/user-attachments/assets/f8443b4f-c109-4b1f-9944-3df8971aaa2f" />


## FAQ 

## Erreurs déjà rencontrées et solutions

| Symptôme | Cause | Solution |
|---|---|---|
| `caddy: command not found` sur l'hôte | Caddy tourne en conteneur Docker, pas installé nativement | Utiliser `docker exec -it <conteneur> caddy reload ...` |
| Conteneur Caddy en `Restarting` en boucle | Voir `docker logs <conteneur>` | Selon le message d'erreur |
| `tls: private key does not match public key` | Certificat et clé privée ne forment pas une paire cohérente | Régénérer une paire cohérente (CA interne ou `openssl req -x509 -newkey rsa:4096 ...`) |
| Conteneur reste bloqué en `Created` (jamais démarré) | Le conteneur n'a jamais été lancé après sa création | `docker start <conteneur>`, puis vérifier les logs |
| Un domaine ne renvoie aucun header alors que le snippet existe | Il n'y a pas de bloc dédié pour ce domaine dans le Caddyfile — Caddy sert un autre bloc par défaut/fallback | Créer un bloc explicite avec `import security-headers` + une directive de contenu (`reverse_proxy`, `file_server`, ou `redir`) |
| Logos/images cassés après ajout des headers | `Content-Security-Policy` (`img-src 'self' data:`) bloque les images chargées depuis un CDN externe | Ajouter le domaine du CDN à `img-src` (ex: `https://cdn.jsdelivr.net`) |
| Toujours cassé même après retrait de `Cross-Origin-*` | La vraie cause était la CSP, pas COOP/CORP/COEP | Toujours vérifier la console navigateur (F12 → Console, ou clic droit → Inspecter) pour voir le message d'erreur exact avant de changer un header au hasard |
| Attention typo | `https://dn.jsdelivr.net` au lieu de `https://cdn.jsdelivr.net` | Toujours relire la ligne CSP après modification |

**Méthode générale de debug d'un header CSP/CORS qui casse un affichage :**
1. Ouvrir la console développeur du navigateur (clic droit → Inspecter → onglet Console), recharger la page.
2. Lire le message d'erreur exact — il indique le header fautif et l'URL bloquée.
3. Corriger uniquement ce qui est nécessaire (ajouter la source manquante), plutôt que de retirer des headers en aveugle.
4. Recharger la config (`caddy reload` ou `systemctl reload apache2`) et retester.
