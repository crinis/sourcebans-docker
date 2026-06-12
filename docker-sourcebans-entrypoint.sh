#!/usr/bin/env bash
#
# Performs setup tasks on container start

set -euo pipefail

: "${INSTALL:=false}"
: "${SET_OWNER:=true}"
: "${SET_OWNER_UID:=33}"
: "${SET_OWNER_GID:=33}"

if [ "$INSTALL" = "true" ]; then
    # Forced install/update: replace all upstream-managed directories.
    echo >&2 "INSTALL=true: updating SourceBans++ sources in /var/www/html ..."
    rm -rf /var/www/html/themes/default /var/www/html/updater \
        /var/www/html/install /var/www/html/pages /var/www/html/includes
    cp -R /usr/src/sourcebans/. /var/www/html/
elif [ ! -e /var/www/html/index.php ]; then
    # First start against an empty docroot: install automatically.
    echo >&2 "No SourceBans++ installation found in /var/www/html: copying sources ..."
    cp -R /usr/src/sourcebans/. /var/www/html/
else
    # Normal start: make sure the web installer and updater are not exposed.
    rm -rf /var/www/html/install /var/www/html/updater
fi

# Temporary fix until https://github.com/sbpp/sourcebans-pp/issues/972 is resolved
mkdir -p /var/www/html/cache

if [ "$SET_OWNER" = "true" ] && [ "$(id -u)" -eq 0 ]; then
    chown -R "$SET_OWNER_UID:$SET_OWNER_GID" /var/www/html
fi

exec docker-php-entrypoint "$@"
