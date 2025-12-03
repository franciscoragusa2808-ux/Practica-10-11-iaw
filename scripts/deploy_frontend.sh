#!/bin/bash
set -ex

#Importamos las variables del entorno 
source .env

#Eliminamos las descargas previas de WP-CLI
rm -f /tmp/wp-cli.phar

#Descargamos WP-CLI
wget https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar -P /tmp

#Asignamos permisos de ejecución al archivo descargado
chmod +x /tmp/wp-cli.phar

#Movemos wp-cliri.phar a /usr/local/bin/wp para poder ejecutarlo desde cualquier ubicación
mv /tmp/wp-cli.phar /usr/local/bin/wp
#Eliminamos cualquier instalación previa de WordPress en /var/www/html
rm -rf /var/www/html/*

#Descargamos WordPress en español en  el directorio /var/www/html
wp core download --locale=es_ES --path=/var/www/html --allow-root
#Modificamos los permisos del directorio /var/www/html para que el servidor web pueda acceder a él
chown -R www-data:www-data /var/www/html




#Hacemos el wp-config.php 
wp config create \
  --dbname=$DB_NAME --dbuser=$DB_USER --dbpass=$DB_PASSWORD --dbhost=$DB_HOST --path=/var/www/html --allow-root

#Instalamos WordPress
wp core install \
  --url=$CERBOT_DOMAIN\
  --title=$WORDPRESS_TITTLE \
  --admin_user=$WORDPRESS_ADMIN_USER \
  --admin_password=$WORDPRESS_ADMIN_PASSWORD \
  --admin_email=$WORDPRESS_ADMIN_EMAIL \
  --path=/var/www/html \
  --allow-root  

  #Configuramos los enlaces permanentes
wp rewrite structure '/%postname%/' --path=/var/www/html --allow-root
#wp rewrite structure '/%postname%/' --path=/var/www/html --allow-root

#Instalamos el plugin de hide login para cambiar la URL de acceso al wp-admin
wp plugin install wps-hide-login --activate --path=/var/www/html --allow-root

#Cambiamos la URL de acceso al wp-admin
wp option update whl_page "$HIDELOGIN" --path=/var/www/html --allow-root
#Le damos los permisos adecuados al directorio de WordPress
chown -R www-data:www-data /var/www/html

#Añadimos un tema
wp theme install astra --activate --path=/var/www/html --allow-root
#Activamos el tema instalado
wp theme activate astra --path=/var/www/html --allow-root

#Copiamos nuestro archivo .htaccess personalizado
cp ../htaccess/.htaccess /var/www/html/

#Moficiamos el propietario y el grupo de /var/www/html a www-data
chown -R www-data:www-data /var/www/html