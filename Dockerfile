FROM php:7.2-apache

# Install dependencies
RUN apt-get update && apt-get install -y \
    libpng-dev \
    libjpeg-dev \
    libzip-dev \
    zip \
    libonig-dev \
    libmcrypt-dev \
    curl \
    libcurl4-openssl-dev \
    && rm -rf /var/lib/apt/lists/*

# PHP extensions
RUN docker-php-ext-configure gd --with-jpeg-dir=/usr/include/ \
    && docker-php-ext-install -j$(nproc) \
    gd \
    mysqli \
    pdo \
    pdo_mysql \
    zip \
    mbstring \
    session \
    curl

# Install Ioncube Loader 7.2
RUN cd /tmp \
    && curl -sS https://downloads.ioncube.com/loader_downloads/ioncube_loaders_lin_x86-64.tar.gz | tar xz \
    && PHP_EXT_DIR=$(php -i | grep "extension_dir" | head -n 1 | cut -d " " -f 3) \
    && cp ioncube/ioncube_loader_lin_7.2.so $PHP_EXT_DIR/ \
    && echo "zend_extension=$PHP_EXT_DIR/ioncube_loader_lin_7.2.so" > /usr/local/etc/php/conf.d/00-ioncube.ini \
    && echo "ioncube.loader.encoded_paths=/var/www/html" >> /usr/local/etc/php/conf.d/00-ioncube.ini \
    && rm -rf /tmp/ioncube \
    && php -m | grep -i ioncube

# Enable mod_rewrite for URL rewrites
RUN a2enmod rewrite

# Session & Cache directories
RUN mkdir -p /var/www/html/system/sessions \
    /var/www/html/application/cache \
    /var/www/html/application/logs

# Copy Apache configuration
COPY apache-vhost.conf /etc/apache2/sites-available/000-default.conf

# Create a custom php.ini file
COPY php.ini /usr/local/etc/php/conf.d/custom-php.ini

# Set proper permissions
RUN chown -R www-data:www-data /var/www/html \
    && chmod -R 755 /var/www/html \
    && chown -R www-data:www-data /var/www/html/system/sessions \
    && chmod -R 700 /var/www/html/system/sessions

# Start Apache
CMD ["apache2-foreground"]
