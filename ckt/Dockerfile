FROM wordpress:php8.3-apache

# Trust Cloudflare HTTPS proxy header
RUN a2enmod remoteip \
    && printf 'SetEnvIf X-Forwarded-Proto https HTTPS=on\nRemoteIPHeader CF-Connecting-IP\n' \
       > /etc/apache2/conf-available/cloudflare.conf \
    && a2enconf cloudflare

# PHP tweaks for WooCommerce
RUN printf 'upload_max_filesize=64M\npost_max_size=64M\nmemory_limit=256M\nmax_execution_time=300\n' \
    > /usr/local/etc/php/conf.d/wordpress.ini

# Use our own wp-config (injected via env vars)
COPY wp-config.php /var/www/html/wp-config.php
