# Actividad-1.3.1: Instalación de la pila LAMP (Linux, apache, MariaDB y PHP) en una instancia EC2 de AWS con Debian Server.

## APACHE2 Y PHP:

### Actualizamos los repositorios e intalamos Apache2:
![Img](../img/1.PNG)

### Instalamos PHP:
![Img](../img/2.PNG)

### Buscamos en la ruta el sitio web por defecto (000-default.conf) y lo editamos añadiendo la la orden DirectoryIndex(Indicando la pagina php por defecto):
![Img](../img/3.PNG)

![Img](../img/4.PNG)

### Reiniciamos el servicio de Apache2 mediante el comando systemctl restart apache2 si quisieramos comprobar su estado lo hariamos mediante el comando "systemctl status apache2":
![Img](../img/5.PNG)

### Comprobacion de LAMP stack:
![Img](../img/6.PNG)
![Img](../img/7.PNG)

### Desde el navegador e incluimos la siguiente URL: http://ip_servidor/info.php
![Img](../img/8.PNG)

## MARIADB:

### Actualizamos los repositorios e instalación servidor de base de datos y cliente:
![Img](../img/9.PNG)
![Img](../img/10.PNG)

### Acceso a MariaDB desde consola servidor (como root):

![Img](../img/11.PNG)

### Cambiar la contraseña de root:
![Img](../img/12.PNG)

## PHPMYADMIN:

### Instalamos PHPMyadmin:
![Img](../img/13.PNG)

### Durante la instalacion de PHPMyadmin debemos escoger la opcion de apache2:
![Img](../img/14.PNG)

### Confirma que desea utilizar dbconfig-common para configurar la base de datos:
![Img](../img/15.PNG)

### Capturas de las opciones que se deben seguir durante el proceso de instalacion:
![Img](../img/16.PNG)
![Img](../img/17.PNG)
![Img](../img/18.PNG)
![Img](../img/19.PNG)
![Img](../img/20.PNG)
![Img](../img/21.PNG)

### Accedemos a PHPMyAdmin desde el navegador: http://ip_host/phpmyadmin/
![Img](../img/22.PNG)

### Esto es lo que se ve una vez dentro de PHPMyadmin:
![Img](../img/23.PNG)

### Contenido de los ficheros index.php e info.php
![Img](../img/23.2.PNG)
![Img](../img/23.3.PNG)
