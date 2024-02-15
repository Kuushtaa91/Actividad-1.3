#!/bin/bash

# Paso 1: 

echo "-----------------------------------"
echo "Instalación de paquetes PHP necesarios"
echo "-----------------------------------"

apt install php-curl php-gd php-mbstring php-xml php-xmlrpc php-soap php-intl php-zip -y

# Paso 2:

echo "-----------------------------------"
echo "Verificar si la instalación fue exitosa"
echo "-----------------------------------"

if [ $? -ne 0 ]; then
    echo "Ha ocurrido un error durante la instalación de los paquetes PHP necesarios."
    exit 1
fi

# Paso 3: 

echo "-----------------------------------"
echo "Creación y configuración de la base de datos MySQL"
echo "-----------------------------------"

mysql -u root <<< "DROP DATABASE IF EXISTS $WORDPRESS_DB_NAME"
mysql -u root <<< "CREATE DATABASE $WORDPRESS_DB_NAME"
mysql -u root <<< "DROP USER IF EXISTS $WORDPRESS_DB_USER@$IP_CLIENTE_MYSQL"
mysql -u root <<< "CREATE USER $WORDPRESS_DB_USER@$IP_CLIENTE_MYSQL IDENTIFIED BY '$WORDPRESS_DB_PASSWORD'"
mysql -u root <<< "GRANT ALL PRIVILEGES ON $WORDPRESS_DB_NAME.* TO $WORDPRESS_DB_USER@$IP_CLIENTE_MYSQL"

# Paso 4: 

echo "-----------------------------------"
echo "Verificar si la configuración de la base de datos fue exitosa"
echo "-----------------------------------"

if [ $? -ne 0 ]; then
    echo "Ha ocurrido un error durante la configuración de la base de datos."
    exit 1
fi

# Paso 5: 

echo "-----------------------------------"
echo "Añadiendo configuración a 000-default.conf"
echo "-----------------------------------"

sed -i '/<VirtualHost \*:80>/a \ \n ServerAdmin webmaster@localhost \n DocumentRoot /var/www/html \n <Directory /var/www/html/> \n AllowOverride All \n </Directory>' /etc/apache2/sites-available/000-default.conf

# Paso 6:

echo "-----------------------------------"
echo "Reiniciar Apache2"
echo "-----------------------------------"

systemctl restart apache2

# Paso 7:

echo "-----------------------------------"
echo "Verificar si la configuración de Apache2 fue exitosa"
echo "-----------------------------------"

if [ $? -ne 0 ]; then
    echo "Ha ocurrido un error durante la configuración de Apache2."
    exit 1
fi

# Paso 8: 

echo "-----------------------------------"
echo "Descarga e instalación de WordPress"
echo "-----------------------------------"

apt install wget unzip -y
wget https://es.wordpress.org/latest-es_ES.zip -P /tmp
unzip /tmp/latest-es_ES.zip -d /var/www/html
cp /var/www/html/wp-config-sample.php /var/www/html/wp-config.php
sed -i "s/$WORDPRESS_DB_NAME/" /var/www/html/wp-config.php
sed -i "s/$WORDPRESS_DB_USER/" /var/www/html/wp-config.php
sed -i "s/$WORDPRESS_DB_PASSWORD/" /var/www/html/wp-config.php
sed -i "s/$WORDPRESS_DB_HOST/" /var/www/html/wp-config.php

# Paso 9:

echo "-----------------------------------"
echo "Verificar si la instalación de WordPress fue exitosa"
echo "-----------------------------------"

if [ $? -eq 0 ]; then
    echo "-----------------------------------"
    echo "¡La instalación de WordPress ha finalizado con éxito! Ahora accede a tu navegador web e ingresa la dirección IP del servidor para completar la configuración."
    echo "-----------------------------------"
else
    echo "-----------------------------------"
    echo "Ha ocurrido un error durante la instalación de WordPress."
    echo "-----------------------------------"
    exit 1
fi