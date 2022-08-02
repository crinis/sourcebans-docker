FROM php:7.4-apache

ENV SOURCEBANS_VERSION=1.6.3 \
    REMOVE_SETUP_DIRS=false

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        wget \
    && \
    rm -rf /var/lib/apt/lists/*

RUN mkdir /usr/src/sourcebans-${SOURCEBANS_VERSION}/ && \
    wget -qO- https://github.com/sbpp/sourcebans-pp/releases/download/${SOURCEBANS_VERSION}/sourcebans-pp-${SOURCEBANS_VERSION}.webpanel-only.tar.gz | tar xvz -C /usr/src/sourcebans-${SOURCEBANS_VERSION}/ && \
    mkdir /docker/

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

COPY docker-sourcebans-entrypoint.sh /docker/docker-sourcebans-entrypoint.sh
COPY sourcebans.ini /usr/local/etc/php/conf.d/sourcebans.ini

RUN chmod +x /docker/docker-sourcebans-entrypoint.sh

ENTRYPOINT ["/docker/docker-sourcebans-entrypoint.sh"]
CMD ["apache2-foreground"]
