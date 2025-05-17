FROM php:7.4-apache

# Create necessary directory for PHP extension configurations
RUN mkdir -p /usr/local/etc/php/conf.d/

# Install necessary packages and GD extension
RUN apt-get update && apt-get install -y \
    unzip \
    curl \
    vim \
    libfreetype6-dev \
    libjpeg62-turbo-dev \
    libpng-dev \
    libwebp-dev \
    && docker-php-ext-configure gd --with-freetype --with-jpeg --with-webp \
    && docker-php-ext-install -j$(nproc) gd

# Enable Apache mod_rewrite
RUN a2enmod rewrite

# Install PHP extensions
RUN docker-php-ext-install -j$(nproc) mysqli pdo pdo_mysql \
    && docker-php-ext-enable mysqli

# Install Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

WORKDIR /var/www/html

CMD ["apache2-foreground"]