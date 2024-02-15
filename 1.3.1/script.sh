#!/bin/bash

# Paso 1:
echo "Actualización de repositorios"
apt update

# Paso 2:
echo "Instalación de Apache2"
apt install apache2 -y

# Paso 3:
echo "Instalación de PHP"
apt install php libapache2-mod-php php-mysql -y

# Paso 4:
echo "Editar 000-default.conf"
sed -i '/DocumentRoot \/var\/www\/html/a DirectoryIndex index.html index.php' /etc/apache2/sites-available/000-default.conf

# Paso 5:
echo "Reiniciar servicio apache2"
systemctl restart apache2

# Paso 6:
echo "Crear página de prueba de PHP"
echo "<?php phpinfo(); ?>" > /var/www/html/info.php

# Paso 7:
echo "Instalación de MariaDB"
apt install -y mariadb-server mariadb-client

# Paso 8:
echo "Cambiar contraseña de MariaDB root"
read contraseña_mariadb
echo "Introduce la contraseña del usuario: "$contraseña_mariadb
mysql -u root -e "ALTER USER 'root'@'localhost' IDENTIFIED BY '$contraseña_mariadb'; FLUSH PRIVILEGES;"

# Paso 9:
echo "Instalación de PHPMyAdmin"
apt install phpmyadmin php-mbstring php-zip php-gd php-json php-curl -y

# Paso 10:
echo "Creación y configuración de la base de datos para PHPMyAdmin"
read contraseña_PHPMyAdmin
echo "Introduce la contraseña del usuario: "$contraseña_PHPMyAdmin
mysql -u root -p -e "CREATE DATABASE phpmyadmin; USE phpmyadmin; CREATE USER 'phpmyadmin'@'localhost' IDENTIFIED BY '$contraseña_PHPMyAdmin'; GRANT ALL PRIVILEGES ON phpmyadmin.* TO 'phpmyadmin'@'localhost' WITH GRANT OPTION; FLUSH PRIVILEGES;"

# Paso 11:
echo "Descarga e instalación de PHPMyAdmin"
cd /var/www/html
wget https://files.phpmyadmin.net/phpMyAdmin/5.2.0/phpMyAdmin-5.2.0-all-languages.zip
unzip phpMyAdmin-5.2.0-all-languages.zip
mv phpMyAdmin-5.2.0-all-languages phpmyadmin
chown -R www-data:www-data /var/www/html/phpmyadmin

# Paso 12:
echo "Reiniciar Apache2"
systemctl restart apache2

echo "Instalación y configuración completadas."
