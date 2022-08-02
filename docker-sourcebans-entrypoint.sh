#!/usr/bin/env bash
#
# Performs setup tasks on container start

set -euo pipefail

# Copy Sourcebans sourcecode to docroot
if [ "true" == "$UPDATE_SRC" ] || [ -z "$(ls -A /var/www/html/)" ]; then
    cp -R /usr/src/sourcebans-${SOURCEBANS_VERSION}/* /var/www/html/
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
