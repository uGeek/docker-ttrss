#!/bin/sh
/usr/local/bin/gomplate -V -o /etc/php7/php.ini -f /etc/templates/php.ini.tmpl
/usr/local/bin/gomplate -V -o /var/www/app/config.php -f /etc/templates/config.php.tmpl

# ensure lock folders exists
mkdir -p /var/www/app/cache/images
mkdir -p /var/www/app/cache/upload
mkdir -p /var/www/app/cache/export

chown -R nginx:nginx /var/www/app/lock
chown -R nginx:nginx /var/www/app/cache
chown -R nginx:nginx /var/www/app/feed-icons
chown -R nginx:nginx /var/www/app/plugins.local
chown -R nginx:nginx /var/www/app/themes.local

s6-setuidgid nginx php /var/www/app/docker_setup.php

exec /bin/s6-svscan /etc/services.d
