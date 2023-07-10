# Base image
FROM php:8.0-apache

# Set working directory
WORKDIR /var/www/html

# Install dependencies
RUN apt-get update && apt-get install -y \
    libzip-dev \
    unzip \
    && docker-php-ext-install pdo_mysql zip \
    && a2enmod rewrite

# Install Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Copy project files
COPY . /var/www/html

# Install project dependencies
RUN composer install --optimize-autoloader --no-dev

# Set file permissions
RUN chown -R www-data:www-data /var/www/html/storage /var/www/html/bootstrap/cache

# Set Apache document root
RUN sed -i -e 's/html/html\/public/g' /etc/apache2/sites-enabled/000-default.conf

# Expose port
EXPOSE 80

# Start Apache server
CMD ["apache2-foreground"]
