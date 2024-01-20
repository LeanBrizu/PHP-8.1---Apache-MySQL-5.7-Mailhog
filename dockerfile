# Usamos una imagen base de PHP con Apache, compatible con PHP 8.1
FROM php:8.1-apache

# Actualizamos e instalamos dependencias
RUN apt-get update && apt-get install -y \
        git \
        libzip-dev \
        zlib1g-dev \
        zip \
        unzip \
        nano \
		libonig-dev \
        libpng-dev \
        libjpeg-dev \
        libfreetype6-dev \
        libxml2-dev \
        default-mysql-client \
    && rm -rf /var/lib/apt/lists/*

# Instalamos extensiones para PHP
RUN docker-php-ext-install zip pdo_mysql mysqli
RUN docker-php-ext-configure gd --with-freetype --with-jpeg
RUN docker-php-ext-install gd

# Configuramos el document root de Apache
ENV APACHE_DOCUMENT_ROOT=/var/www/html/public
RUN sed -ri -e 's!/var/www/html!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/sites-available/*.conf
RUN a2enmod rewrite

# Establecemos el directorio de trabajo
WORKDIR /var/www/html

# Instalamos Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Copiamos el código fuente de la aplicación
COPY ./app/src/ /var/www/html/

# Damos permiso al directorio de la aplicación
RUN chown -R www-data:www-data /var/www/html

# Exponemos el puerto 80
EXPOSE 80
