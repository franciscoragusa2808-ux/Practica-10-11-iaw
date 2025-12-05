#!/bin/bash
set -ex

source .env

apt update
apt upgrade -y

apt install nfs-common -y

# Crear el punto de montaje
mkdir -p /var/www/html

# Montaje inicial
mount $NFS_SERVER_IP:/var/www/html /var/www/html

# Copiamos la plantilla al fstab
cp ../nfs/fstab-entry /etc/fstab

# Sustituimos la IP en el archivo final
sed -i "s|PUT_NFS_SERVER_IP|$NFS_SERVER_IP|" /etc/fstab
