#!/bin/bash
set -ex

# Actualizamos repositoros

apt update

#Actualizamos los repositorios
apt upgrade -y

#Instalamos el servidor apache 

apt install apache2 -y

#Habilitamos el módulo rewrite 
a2enmod rewrite

#Reiniciamos el servicio de apache
systemctl restart apache2

#Copiamos el archivo de configuración de apache
#cp ../conf/000-default.conf /etc/apache2/sites-available

#Instalamos PHP y el módulo de apache para PHP y el módulo de MySQL para PHP
sudo apt install php libapache2-mod-php php-mysql -y

#Reiniciamos el servicio de apache
systemctl restart apache2

#copiamos el archivo de index.php  a/var/www/html
#cp ../php/index.php /var/www/html/

#cambiamos el propietario de /var/www/html a www-data
chown -R www-data:www-data /var/www/html/