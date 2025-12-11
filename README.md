# Práctica-10-11-iaw

En está práctica realizamos un despliegue completo de un arquitectura web distribuida en 5 máquinas: un balanceador Nginx, dos máquinas fronted con Apache y Wordpress, una máquina  backend con Mysql y una máquina con servidor NFS que reparte el contenido web entre las dos máquinas frontales.

El objetivo de este despligue es automatizar cada servicio en máquinas diferentes y así dividir la carga entre máquinas, con el fin de conseguir una insfraestructa realista.


La estructura de la práctica es la siguiente:
```
Pr-ctica-10-11-iaw/
│
├── conf/
│   ├── 000-default.conf
│   └── load-balancer.conf
│
├── htaccess/
│   └── .htaccess
│
├── nfs/
│   ├── exports
│   └── fstab-entry
│
├── scripts/
│   ├── .env
│   ├── .env.example
│   ├── deploy_backend.sh
│   ├── deploy_frontend.sh
│   ├── frontend-nfs-client.sh
│   ├── install_lamp_backend.sh
│   ├── install_lamp_frontend.sh
│   ├── setup_letscrypt.sh
│   ├── setup_load_balancer.sh
│   └── setup_nfs_server.sh
│
└── README.md
```

# Directorio Conf 

Este directorio contiene los archivos de configuración personalizados que se utilizarán  en los frontales Apache y en el balanceador Nginx.
```
├── conf/
│   ├── 000-default.conf
│   └── load-balancer.conf
```
**000-default.conf**

Activa AllowOverride All para que funcione el .htaccess.

**load-balancer.conf**

Sustituye las IP de los frontales automáticamente.


# Directorio htaccess
```
├── htaccess/
│   └── .htaccess
```
**.htaccess**

El .htaccess permite el funcionamiento de los enlaces permanentes y del plugin que oculta el login.

# NFS
Este directorio contiene los archivos necesarios para preparar el servidor NFS y el montaje automatico en ambos frontales
```
├── nfs/
│   ├── exports
│   └── fstab-entry

```

**exports**
El servidor NFS usa este archivo para compartir /var/www/html en ambos frontales

**fstab-entry**
Sustituye la IP del servidor NFS  para que /var/www/html se monte automaticamente en cada reinicio del sistema.

# Directorio Scripts
Este directorio contiene todos los scripts necesarios para automatizar el despliegue de la práctica.

**.env**

Este archivo contiene todas las variables usadas en cada script.Por motivos seguridad no se sube al repositorio, ya que contiene mi infromación personal. .En su lugar debes usar la plantilla .env.example y se copia de la siguiente forma:

```
cp .env.example .env
```

**Script install_lamp_frontend.sh**

Este script instala el servidor web Apache y PHP en ambos frontales.

Lo que hace el script es lo siguiente:

1) Importa las variables del .env 

2) Actualiza los repositorios del sistema.

3) Instala Apache.

4) Habilita el módulo rewrite necesario para WordPress.

5) Instala PHP y las extensiones necesarias para que WordPress y MySQL funcionen correctamente.

6) Reinicia Apache para aplicar los cambios.

7) Ajusta los permisos del directorio /var/www/html asignando el propietario al usuario www-data.

Comprobación de que funciona el script:

**Script frontend-nfs-client.sh**

Este script hace que cada ambos fronatles puedan montar el contenido web desde el servidor NFS.

Lo que hace el script es lo siguiente:

1) Importa las variables del archivo .env.

2) Instala el paquete nfs-common.

3) Crea el directorio /var/www/html si no existe.

4) Realiza un montaje inicial del recurso NFS exportado por el servidor NFS.

5) Copia la plantilla fstab-entry al fichero /etc/fstab.

6) Sustituyela cadena  PUT_NFS_SERVER_IP por la IP real del servidor NFS

Comprobación de funcionamiento del script:


**Script deploy_frontend.sh**
Este script se encarga de instalar Wordpress de forma automatica mediante WP-CLI. Se recomienda desplegar en uno solo front-end

Lo que hace el script es lo siguiente:

1) Importa las variables del archivo .env.

2) Elimina cualquier descarga previa de WP-CLI y la vuelve a descargar desde el repositorio oficial.

3) Asigna permisos de ejecución y mueve el binario a /usr/local/bin/wp para ejecutarlo desde cualquier ubicación.

4) Elimina cualquier instalación previa de WordPress en /var/www/html.

5) Descarga la última versión de WordPress en español dentro del directorio /var/www/html.

6) Asigna permisos adecuados al directorio para el usuario www-data.

7) Crea la base de datos y el usuario definidos en el archivo .env.

8) Genera el archivo wp-config.php con los parámetros definidos en .env.

9) Instala WordPress automáticamente configurando el título, el usuario administrador, la contraseña, el correo y el dominio.

10) Configura los enlaces permanentes con la estructura /%postname%/.

11) Instala y activa el plugin wps-hide-login para ocultar el acceso a wp-admin.

12) Cambia la URL de acceso al panel de administración según la variable HIDELOGIN.

13) Instala y activa el tema Astra.

14) Ajusta los permisos finales del directorio para Apache

Comprobación de funcionamiento del script


**install_lamp_backend.sh**

Este script instala y configura MySQL en la máquina backend

Lo que hace es lo siguiente:

1) Actualiza los repositorios del sistema.

2) Instala MySQL Server.

3) Modifica el parámetro bind-address en el archivo de configuración de MySQL para permitir conexiones remotas desde los frontales.

4) Usa la IP privada del backend definida en .env para reemplazar la dirección local.

5) Reinicia el servicio de MySQL para aplicar los cambios.

Comprobación de funcionamiento del script:


**Script deploy_backend.sh**

Este script prepara la base de datos y el usuario que WordPress utilizará.


Lo que hace el script es lo siguiente:

1) Importa las variables definidas en el archivo .env.

2) Elimina la base de datos previa en caso de existir.

3) Crea la nueva base de datos para WordPress.

4) Elimina el usuario previo si existe.

5) Crea un usuario MySQL restringido a la subred de los frontales.

6) Otorga permisos completos a ese usuario sobre la base de datos recién creada.

Comprobación de funcionamiento del script:

**Script setup_nfs_server.sh**

Este script configura la máquina que actuará como servidor NFS.

Lo que hace es lo siguiente:

1) Actualiza los repositorios.

2) Instala los paquetes necesarios para NFS.

3) Crea o verifica la existencia del directorio /var/www/html que será compartido.

4) Copia el archivo exports al directorio correspondiente del servidor NFS.

5) Aplica la configuración exportando el directorio.

Comprobación de funcionamiento del script:

**Script setup_load_balancer.sh**

Este script configura la máquina que actuará como balanceador utilizando Nginx.

Lo que hace el script es lo siguiente:

1) Actualiza los paquetes del sistema.

2) Instala el servidor Nginx.

3) Elimina el sitio por defecto de Nginx si está habilitado.

4) Copia el archivo load-balancer.conf desde el directorio conf.

5) Sustituye los valores IP_FRONTEND_1 y IP_FRONTEND_2 por las IP reales definidas en el archivo .env.

6) Habilita la configuración del balanceador en /etc/nginx/sites-enabled.

7) Reinicia el servicio de Nginx para aplicar los cambios.

Comprobación de funcionamiento del script:


**Script setup_letscrypt.sh**

Lo que hace el script es lo siguiente:

1) Importa las variables del archivo .env.

2) Instala y actualiza el paquete core mediante snap.

3) Sustituye el valor del ServerName en la configuración del balanceador con el dominio real.

4) Elimina versiones antiguas de Certbot instaladas en el sistema.

5) Instala Certbot usando Snap.

6) Ejecuta Certbot para obtener el certificado SSL y configurarlo automáticamente en Nginx.

Comprobación de funcionamiento del script:


# Dominio 
En esta práctica se utiliza un dominio gratuito de No-IP definido en el archivo .env dentro de la variable CERBOT_DOMAIN. Este dominio es el que se emplea para acceder al sitio WordPress una vez completado el despliegue.


# Resultado
El orden de ejecución de lo sscripts es el siguiente:

1. Ejecutamos los scripts del balanceador (setup_load_balancer.sh y setup_letscrypt.sh).

2. Ejecutamos los  dos scripts del backend para MySQL.

3. Ejecutamos el script setup_nfs_server.sh en la máquina NFS.

4. Ejecutamos el script frontend-nfs-client.sh en ambos frontales.

5. Ejecutamos  deploy_frontend.sh en uno de los frontales para instalar WordPress.

Comprobación final: