FROM docker.io/library/composer:2.10 AS composer
ARG CHECKOUT=1.8.4

RUN git clone https://github.com/sbpp/sourcebans-pp.git && \
    git -C sourcebans-pp checkout ${CHECKOUT} && \
    composer install --no-dev --no-interaction --no-progress --optimize-autoloader --ignore-platform-reqs --working-dir=sourcebans-pp/web/

# Build the actual image
FROM docker.io/library/php:8.3-apache

ENV INSTALL=false \
    SET_OWNER_UID=33 \
    SET_OWNER_GID=33 \
    SET_OWNER=true

RUN savedAptMark="$(apt-mark showmanual)" && \
    apt-get update && \
    apt-get install -y --no-install-recommends \
        libgmp-dev \
    && \
    rm -rf /var/lib/apt/lists/* && \
    docker-php-ext-configure gmp && \
    docker-php-ext-install gmp mysqli pdo_mysql bcmath && \
    apt-mark auto '.*' > /dev/null && \
    apt-mark manual $savedAptMark && \
    apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false

RUN mkdir /docker/ && \
    # Drop the base image's sticky bit: named volumes seeded from this
    # directory must let a container that is assigned a new UID (arbitrary-UID
    # platforms run with GID 0) replace entries left by a previous UID.
    chmod 0777 /var/www/html && \
    mv /usr/local/etc/php/php.ini-production /usr/local/etc/php/php.ini && \
    sed -i 's/Listen 80$/Listen 8080/' /etc/apache2/ports.conf && \
    sed -i 's/:80>/:8080>/' /etc/apache2/sites-enabled/000-default.conf && \
    echo 'ServerName localhost' > /etc/apache2/conf-available/servername.conf && \
    a2enconf servername

COPY --from=composer /app/sourcebans-pp/web /usr/src/sourcebans
COPY --chmod=0755 docker-sourcebans-entrypoint.sh /docker/docker-sourcebans-entrypoint.sh
COPY sourcebans.ini /usr/local/etc/php/conf.d/sourcebans.ini

EXPOSE 8080
HEALTHCHECK --interval=30s --timeout=5s --start-period=30s --retries=3 \
    CMD curl -fsS -o /dev/null http://127.0.0.1:8080/ || exit 1

ENTRYPOINT ["/docker/docker-sourcebans-entrypoint.sh"]
CMD ["apache2-foreground"]
