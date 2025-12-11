#!/bin/bash
set -ex

source .env

# Actualizar sistema
apt update
apt upgrade -y

# Instalar NFS server
apt install nfs-kernel-server -y

# Crear directorio compartido
mkdir -p /var/www/html
chown nobody:nogroup /var/www/html

# Configurar /etc/exports
echo "/var/www/html ${FRONTEND_NETWORK}(rw,sync,no_subtree_check,no_root_squash)" > /etc/exports

# Aplicar exportación
exportfs -ra

# Reiniciar servicios NFS
systemctl restart nfs-server
systemctl enable nfs-server
