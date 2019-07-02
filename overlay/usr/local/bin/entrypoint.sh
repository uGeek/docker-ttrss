#!/bin/bash

/usr/bin/gomplate -V -o /etc/php7/php.ini -f /etc/templates/php.ini.tmpl
/usr/bin/gomplate -V -o /var/www/app/config.php -f /etc/templates/config.php.tmpl

chown -R nginx:nginx /var/www/app/lock
chown -R nginx:nginx /var/www/app/cache
chown -R nginx:nginx /var/www/app/feed-icons

s6-setuidgid nginx php7 /var/www/app/docker_setup.php

exec /bin/s6-svscan /etc/services.d