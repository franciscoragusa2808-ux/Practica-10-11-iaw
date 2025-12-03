#!/bin/bash
set -ex
#Cargamos las variables de entorno
source .env

#Actualizamos los paquetes
apt update

#Instalamos el servidor web nginx
apt install -y nginx

#Deshabbilitamos el virtual host por defecto en el caso que exista
if [ -f "/etc/nginx/sites-enabled/default" ]; then
    unlink /etc/nginx/sites-enabled/default
fi

#Copiamos el archivo de configuracion "plantilla" de   nginx 
cp ../conf/load-balancer.conf /etc/nginx/sites-available

#Buscamos y reemplazamos los valores de las IPs de forntales
sed -i "s/IP_FRONTEND_1/$IP_FRONTEND_1/" /etc/nginx/sites-available/load-balancer.conf
sed -i "s/IP_FRONTEND_2/$IP_FRONTEND_2/" /etc/nginx/sites-available/load-balancer.conf

# Habilitamos el archivo de configuracion que hemos creado para el balanceador
ln -s -f  /etc/nginx/sites-available/load-balancer.conf /etc/nginx/sites-enabled/

#Reiniciamos el servicio de nginx para aplicar los cambios
systemctl restart nginx
