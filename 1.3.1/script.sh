#!/bin/bash

# Paso 1:

echo "-----------------------------------"
echo "Actualización de repositorios"
echo "-----------------------------------"

apt update

# Paso 2:

echo "-----------------------------------"
echo "Instalación de Apache2"
echo "-----------------------------------"

apt install apache2 -y

# Paso 3:

echo "-----------------------------------"
echo "Instalación de PHP"
echo "-----------------------------------"

apt install php libapache2-mod-php php-mysql -y

# Paso 4:

echo "-----------------------------------"
echo "Editar 000-default.conf"
echo "-----------------------------------"

sed -i '/DocumentRoot \/var\/www\/html/a DirectoryIndex index.html index.php' /etc/apache2/sites-available/000-default.conf

# Paso 5:

echo "-----------------------------------"
echo "Reiniciar servicio apache2"
echo "-----------------------------------"

systemctl restart apache2

# Paso 6:

echo "-----------------------------------"
echo "Crear página de prueba de PHP"
echo "-----------------------------------"

echo "<?php phpinfo(); ?>" > /var/www/html/info.php

# Paso 7:

echo "-----------------------------------"
echo "Instalación de MariaDB"
echo "-----------------------------------"

apt install -y mariadb-server mariadb-client

# Paso 8:

echo "-----------------------------------"
echo "Cambiar contraseña de MariaDB root"
echo "-----------------------------------"

clear
read contraseña_mariadb
echo "Introduce la contraseña del usuario: "$contraseña_mariadb
mysql -u root -e "ALTER USER 'root'@'localhost' IDENTIFIED BY '$contraseña_mariadb'; FLUSH PRIVILEGES;"

# Paso 9:

echo "-----------------------------------"
echo "Instalación de PHPMyAdmin"
echo "-----------------------------------"

apt install phpmyadmin php-mbstring php-zip php-gd php-json php-curl -y

# Paso 10:

echo "-----------------------------------"
echo "Creación y configuración de la base de datos para PHPMyAdmin"
echo "-----------------------------------"

mysql -u root -p -e "CREATE DATABASE phpmyadmin; USE phpmyadmin; CREATE USER 'phpmyadmin'@'localhost' IDENTIFIED BY 'Usuario@1'; GRANT ALL PRIVILEGES ON phpmyadmin.* TO 'phpmyadmin'@'localhost' WITH GRANT OPTION; FLUSH PRIVILEGES;"

# Paso 11:

echo "-----------------------------------"
echo "Descarga e instalación de PHPMyAdmin"
echo "-----------------------------------"

cd /var/www/html
apt install unzip -y
wget https://files.phpmyadmin.net/phpMyAdmin/5.2.0/phpMyAdmin-5.2.0-all-languages.zip
unzip phpMyAdmin-5.2.0-all-languages.zip
mv phpMyAdmin-5.2.0-all-languages phpmyadmin
chown -R www-data:www-data /var/www/html/phpmyadmin

# Paso 12:

echo "-----------------------------------"
echo "Reiniciar Apache2"
echo "-----------------------------------"

systemctl restart apache2

clear

echo "-----------------------------------"
echo "Instalación y configuración completadas."
echo "-----------------------------------"