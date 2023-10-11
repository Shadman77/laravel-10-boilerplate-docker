FROM php:8.2-apache
WORKDIR /

RUN apt-get update && apt-get upgrade -y

COPY app/ /var/www/html/

# Document Root
ENV APACHE_DOCUMENT_ROOT=/var/www/html/public
RUN sed -ri -e 's!/var/www/html!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/sites-available/*.conf
RUN sed -ri -e 's!/var/www/html!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/apache2.conf /etc/apache2/conf-available/*.conf
# Document Root

# Install Composer
RUN curl -sS https://getcomposer.org/installer -o /tmp/composer-setup.php
RUN php /tmp/composer-setup.php --install-dir=/usr/local/bin --filename=composer
# Install Composer

# Install Dependency and allow write
RUN apt install zip unzip

# Mysql Driver
RUN docker-php-ext-install pdo_mysql
RUN docker-php-ext-enable pdo_mysql

# Install Dependency and allow write
WORKDIR /var/www/html

# IP Routing Issue
RUN service apache2 stop
RUN a2enmod rewrite
RUN service apache2 start
# IP Routing Issue

EXPOSE 80
EXPOSE 443