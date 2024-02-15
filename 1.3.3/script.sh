#!/bin/bash

# Paso 1:

echo "-----------------------------------"
echo "DESINSTALACIÓN DE PAQUETES QUE PUEDEN ENTRAR EN CONFLICTO:"
echo "-----------------------------------"

for pkg in docker.io docker-doc docker-compose docker-compose-v2 podman-docker containerd runc; do sudo apt-get remove $pkg; done

# Paso 2:

echo "-----------------------------------"
echo "INSTALACIÓN USANDO UN REPOSITORIO"
echo "-----------------------------------"

apt-get update
apt-get install ca-certificates curl
install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
chmod a+r /etc/apt/keyrings/docker.asc

echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
apt-get update

# Paso 3:

echo "-----------------------------------"
echo "INSTALACIÓN DEL MOTOR DE DOCKER"
echo "-----------------------------------"

apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y

# Paso 4:

echo "-----------------------------------"
echo "COMPROBACIÓN INSTALACIÓN DOCKER"
echo "-----------------------------------"

docker version
docker run hello-world

echo "-----------------------------------"
echo "COMPROBACIÓN INSTALACIÓN DOCKER-COMPOSE"
echo "-----------------------------------"

docker compose version

# Paso 5:

echo "-----------------------------------"
echo "GESTIÓN DE DOCKER COMO USUARIO QUE NO SEA ROOT. AGREGAMOS NUESTRO USUARIO AL GRUPO DE DOCKER:"
echo "-----------------------------------"

echo "usermod -G docker ubuntu"
usermod -G docker ubuntu
echo "su ubuntu"
su ubuntu
echo "ejecuta:"
docker run hello-world

# Paso 6: 

echo "-----------------------------------"
echo " Creamos carpeta Wordpress"
echo "-----------------------------------"

mkdir wordpress
cd wordpress

echo "-----------------------------------"
echo " Creamos la base de datos:"
echo "-----------------------------------"

echo "MARIADB_DATABASE=wp_database200
MARIADB_USER=wp_user200
MARIADB_PASSWORD=alumno200
MARIADB_ROOT_PASSWORD=alumno200" >> .env

echo "version: '3.8'
services:
  wordpress:
    image: wordpress
    ports:
      - 80:80
    environment:
      - WORDPRESS_DB_HOST=mariadb
      - WORDPRESS_DB_NAME=${MARIADB_DATABASE}
      - WORDPRESS_DB_USER=${MARIADB_USER}
      - WORDPRESS_DB_PASSWORD=${MARIADB_PASSWORD}
    volumes:
      - wordpress_data:/var/www/html
    depends_on:
      - mariadb
    restart: always
  mariadb:
    image: mariadb
    ports:
      - 3306:3306
    environment:
      - MARIADB_ROOT_PASSWORD=${MARIADB_ROOT_PASSWORD}
      - MARIADB_DATABASE=${MARIADB_DATABASE}
      - MARIADB_USER=${MARIADB_USER}
      - MARIADB_PASSWORD=${MARIADB_PASSWORD}
    volumes:
      - mariadb_data:/var/lib/mysql
    restart: always
  phpmyadmin:
    image: phpmyadmin
    ports:
      - 8080:80
    environment:
      - PMA_ARBITRARY=1
    restart: always
volumes:
  mariadb_data:
  wordpress_data:" >> docker-compose.yml

echo "-----------------------------------"
echo " Ejecutamos el docker compose:"
echo "-----------------------------------"

docker compose up -d 

echo "-----------------------------------"
echo "Instalación y configuración completadas."
echo "-----------------------------------"