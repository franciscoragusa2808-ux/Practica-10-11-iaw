#!/bin/bash
set -ex

#importamos variables de entorno
source .env

#Actualizamo paquetes 
apt update

apt upgrade -y

#Instalamos el servidor NFS
apt install nfs-kernel-server -y

#Creamos el directorio que vamos a compartir
mkdir -p /var/www/html

#Asignamos permisos al directorio del directorio /var/www/html
chown nobody:nogroup /var/www/html

#Copiamos nuestra plantilla del archivo exports ´
cp ../nfs/exports /etc

#Actualizamos el archivo exports con las IPs de los servidores frontend
sed -i "s|PUT_YOUR_FRONTEND_NETWORK|$FRONTEND_NETWORK|" /etc/exports

#Reinciiamos 1l servicio NFS para aplicar los cambios
systemctl restart nfs-kernel-server
