#!/usr/bin/env bash
#
# Performs setup tasks on container start

set -euo pipefail

# Copy Sourcebans sourcecode to docroot
if [ "true" == $INSTALL ]; then
    rm -rf /var/www/html/themes/default /var/www/html/updater /var/www/html/install /var/www/html/pages /var/www/html/includes
    cp -R /usr/src/sourcebans/* /var/www/html/
fi

# If $INSTALL is set to false or not set, remove the install and updater directories
if [ "false" == $INSTALL ] || [ -z ${INSTALL+x} ]; then
    if [ -d /var/www/html/install/ ]; then
        rm -R /var/www/html/install/
    fi
    if [ -d /var/www/html/updater/ ]; then
        rm -R /var/www/html/updater/
    fi
fi

# Temporary fix until https://github.com/sbpp/sourcebans-pp/issues/972 is resolved
if [ ! -d /var/www/html/cache ]; then
    mkdir /var/www/html/cache
fi

if [ "true" == $SET_OWNER ] && [ "$(id -u)" -eq 0 ]; then
    chown -R $SET_OWNER_UID:$SET_OWNER_GID /var/www/html
fi

exec "docker-php-entrypoint" $@
