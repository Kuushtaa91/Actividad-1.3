#!/bin/bash

# Paso 1: Instalación de paquetes PHP necesarios
apt install php-curl php-gd php-mbstring php-xml php-xmlrpc php-soap php-intl php-zip -y

# Verificar si la instalación fue exitosa
if [ $? -ne 0 ]; then
    echo "Ha ocurrido un error durante la instalación de los paquetes PHP necesarios."
    exit 1
fi

# Paso 2: Configuración de la base de datos MySQL

# Solicitar al usuario que introduzca los valores de las variables
read -p "Introduce el nombre de la base de datos: " WORDPRESS_DB_NAME
read -p "Introduce el nombre del usuario: " WORDPRESS_DB_USER
read -p "Introduce la contraseña del usuario: " WORDPRESS_DB_PASSWORD
read -p "Introduce la dirección IP o nombre del equipo desde el que conectarte (Lo más habitual es 'localhost'): " IP_CLIENTE_MYSQL

# Escribir las variables y sus valores en el archivo datos.env
echo "WORDPRESS_DB_NAME=$WORDPRESS_DB_NAME" > datos.env
echo "WORDPRESS_DB_USER=$WORDPRESS_DB_USER" >> datos.env
echo "WORDPRESS_DB_PASSWORD=$WORDPRESS_DB_PASSWORD" >> datos.env
echo "IP_CLIENTE_MYSQL=$IP_CLIENTE_MYSQL" >> datos.env

echo "Variables guardadas en datos.env."

source datos.env

mysql -u root <<< "DROP DATABASE IF EXISTS $WORDPRESS_DB_NAME"
mysql -u root <<< "CREATE DATABASE $WORDPRESS_DB_NAME"
mysql -u root <<< "DROP USER IF EXISTS $WORDPRESS_DB_USER@$IP_CLIENTE_MYSQL"
mysql -u root <<< "CREATE USER $WORDPRESS_DB_USER@$IP_CLIENTE_MYSQL IDENTIFIED BY '$WORDPRESS_DB_PASSWORD'"

# Verificar si la configuración de la base de datos fue exitosa
if [ $? -ne 0 ]; then
    echo "Ha ocurrido un error durante la configuración de la base de datos."
    exit 1
fi

# Paso 3: Configuración de Apache2
cat <<EOF > /etc/apache2/sites-available/000-default.conf
<VirtualHost *:80>
    ServerAdmin webmaster@localhost
    DocumentRoot /var/www/html
    DirectoryIndex index.html index.php
    <Directory /var/www/html/>
        AllowOverride All
    </Directory>
</VirtualHost>
EOF

# Añadir configuración adicional al archivo 000-default.conf
sed -i '/DocumentRoot \/var\/www\/html/a \ \ DirectoryIndex index.html index.php\n\ \ <Directory \/var\/www\/html\/>\n\ \ \ \ AllowOverride All\n\ \ <\/Directory>' /etc/apache2/sites-available/000-default.conf

# Reiniciar Apache2
systemctl restart apache2

# Verificar si la configuración de Apache2 fue exitosa
if [ $? -ne 0 ]; then
    echo "Ha ocurrido un error durante la configuración de Apache2."
    exit 1
fi

# Paso 4: Descarga e instalación de WordPress
apt install wget unzip -y
wget https://es.wordpress.org/latest-es_ES.zip -P /tmp
unzip /tmp/latest-es_ES.zip -d /var/www/html
cp /var/www/html/wp-config-sample.php /var/www/html/wp-config.php
sed -i "s/database_name_here/$WORDPRESS_DB_NAME/" /var/www/html/wp-config.php
sed -i "s/username_here/$WORDPRESS_DB_USER/" /var/www/html/wp-config.php
sed -i "s/password_here/$WORDPRESS_DB_PASSWORD/" /var/www/html/wp-config.php
sed -i "s/localhost/$IP_CLIENTE_MYSQL/" /var/www/html/wp-config.php
chown -R www-data:www-data /var/www/html

# Verificar si la instalación de WordPress fue exitosa
if [ $? -eq 0 ]; then
    echo "¡La instalación de WordPress ha finalizado con éxito! Ahora accede a tu navegador web e ingresa la dirección IP del servidor para completar la configuración."
else
    echo "Ha ocurrido un error durante la instalación de WordPress."
    exit 1
fi