FROM php:7.1-apache

ENV SBPP_VERSION=1.6.3 \
    INSTALL=true

COPY docker-sbpp-entrypoint /usr/local/bin/
COPY sbpp.ini /usr/local/etc/php/conf.d/

WORKDIR /var/www/html/

RUN set -xe; \
        runDeps=' \
            mysql-client \
        '; \
        apt-get update && apt-get install -y $runDeps \
	        --no-install-recommends && rm -r /var/lib/apt/lists/* \
        && docker-php-ext-install mysqli pdo_mysql \
        && chmod +x /usr/local/bin/docker-sbpp-entrypoint \
        && curl -L https://github.com/sbpp/sourcebans-pp/releases/download/${SBPP_VERSION}/sourcebans-pp-${SBPP_VERSION}.webpanel-only.tar.gz -o sb.tar.gz \
        && tar -zxvf sb.tar.gz \
        && rm -rf sb.tar.gz \
        && chown -R www-data:www-data .

ENTRYPOINT ["docker-sbpp-entrypoint"]

CMD ["apache2-foreground"]
