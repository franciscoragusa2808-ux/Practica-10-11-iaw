#!/bin/bash
set -ex

source .env

apt update
apt upgrade -y

apt install nfs-common -y

mkdir -p /var/www/html

mount $NFS_SERVER_IP:/var/www/html /var/www/html

echo "$NFS_SERVER_IP:/var/www/html /var/www/html nfs defaults 0 0" >> /etc/fstab
