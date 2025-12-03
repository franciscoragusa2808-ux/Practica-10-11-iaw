#!/bin/bash
set -ex

#importamos variables de entorno
source .env

# Actualizamos repositoros

apt update

#Actualizamos los repositorios
apt upgrade -y

#Instalamos  MySQL Server
apt install mysql-server -y


#Modificamos el parametro bind-address para que acepte conexiones remotas
sed -i "s/127.0.0.1/$MYSQL_SERVER_PRIVATE_IP/" /etc/mysql/mysql.conf.d/mysqld.cnf

#Reiniciamos el servicio de MySQL
systemctl restart mysql