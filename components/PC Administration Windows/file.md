SHELL=/bin/sh
PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

0 * * * * www-data cd /var/www/glpi && /usr/bin/php bin/console glpi:ldap:synchronize_users --no-interaction >> /var/log/glpi-ldap-sync.log 2>&1
