#!/bin/bash
set -ex

source .env

apt update
apt upgrade -y

apt install nfs-common -y



# Montaje inicial de la carpeta NFS
mount $NFS_SERVER_IP:/var/www/html /var/www/html


