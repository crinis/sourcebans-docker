#!/usr/bin/env bash
#
# Performs certain startup tasks including installing TYPO3 source, setting up the TYPO3 database, copying important files, changing LocalConfiguration.php settings

set -euo pipefail

if [ -z "$(ls -A /var/www/html/)" ]; then
    cp -R /usr/src/sourcebans-${SOURCEBANS_VERSION}/* /var/www/html/
fi

if [ "true" == "$REMOVE_SETUP_DIRS" ] || ( [ ! -z ${INSTALL+x} ] && ["true" != "$INSTALL"] ); then
    if [ -d /var/www/html/install/ ]; then
        rm -R /var/www/html/install/
    fi
    if [ -d /var/www/html/updater/ ]; then
        rm -R /var/www/html/updater/
    fi
fi

chown -R www-data:www-data /var/www/html/

exec "docker-php-entrypoint" $@
