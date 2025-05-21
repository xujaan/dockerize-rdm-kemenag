FROM php:7.4-apache

# Install dependencies
RUN apt-get update && apt-get install -y \
    libpng-dev \
    libjpeg-dev \
    libzip-dev \
    zip \
    libonig-dev \
    libmcrypt-dev \
    && rm -rf /var/lib/apt/lists/*

# PHP extensions
RUN docker-php-ext-configure gd --with-jpeg \
    && docker-php-ext-install -j$(nproc) \
    gd \
    mysqli \
    pdo \
    pdo_mysql \
    zip \
    mbstring \
    session

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

# Start Apache
CMD ["apache2-foreground"]
