#!/bin/bash
set -ex
#Cargamos las variables de entorno
source .env

#Instalamos core
snap install core
snap refresh core
cp ../conf/000-default.conf /etc/apache2/sites-available/000-default.conf

#Actualizamos la plantilla del valor del ServerName
sed -i "s/PUT_YOUR_DOMAIN_HERE/$CERBOT_DOMAIN/" /etc/apache2/sites-available/000-default.conf

#eliminamos cualquier versión antigua de certbot
apt remove certbot -y

#Instalamos certbot cliente con snap
snap install --classic certbot

#obtenemos el cerificado y configuramos apache 
certbot --apache -m $CERBOT_EMAIL --agree-tos --no-eff-email -d $CERBOT_DOMAIN --non-interactive