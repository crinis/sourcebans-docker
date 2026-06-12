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

if [ "$SET_OWNER" = "true" ]; then
    if [ "$(id -u)" -eq 0 ]; then
        chown -R "$SET_OWNER_UID:$SET_OWNER_GID" /var/www/html
    else
        # Non-root runs (podman userns setups, docker --user, OpenShift):
        # give the container's group the owner's permissions so the webroot
        # stays writable when a later start is assigned a different UID with
        # the same group (e.g. GID 0 on OpenShift). Best effort: files owned
        # by a previous UID cannot be re-chmodded; use podman's :U volume
        # flag to re-own the volume when both UID and GID change.
        chmod -R g=u /var/www/html 2>/dev/null || true
    fi
fi

exec docker-php-entrypoint "$@"
