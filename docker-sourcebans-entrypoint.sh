#!/usr/bin/env bash
#
# Performs setup tasks on container start

set -euo pipefail

# Copy Sourcebans sourcecode to docroot
if [ "true" == "$UPDATE_SRC" ] || [ -z "$(ls -A /var/www/html/)" ]; then
    rm -rf /var/www/html/themes/default /var/www/html/updater /var/www/html/install /var/www/html/pages /var/www/html/includes
    cp -R /usr/src/sourcebans-${SOURCEBANS_VERSION}/* /var/www/html/

    sed -i '/ini_set('display_errors', 1);/d' /var/www/html/install/init.php
    sed -i '/error_reporting(E_ALL);/d' /var/www/html/install/init.php
fi

# If $REMOVE_SETUP_DIRS is set remove the install and updater directories if they exist
if [ "true" == "$REMOVE_SETUP_DIRS" ]; then
    if [ -d /var/www/html/install/ ]; then
        rm -R /var/www/html/install/
    fi
    if [ -d /var/www/html/updater/ ]; then
        rm -R /var/www/html/updater/
    fi
fi

# Set directory owner for docroot recursively
chown -R www-data:www-data /var/www/html/

exec "docker-php-entrypoint" $@
