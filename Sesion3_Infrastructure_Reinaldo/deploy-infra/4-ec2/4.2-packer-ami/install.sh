#!/bin/bash

#################################################
#												#
#         INSTALACIÓN DE WORDPRESS		 		#
#     NGINX - PHP-FPM - MYSQL-CLIENT	 		#
# 												#
#        Reinaldo León Revisión (1)				#
# Amazon Linux AMI 2017.09.1 - ami-1a962263		#
#												#
#################################################

echo "INSTALACIÓN DE WORDPRESS LATEST"
echo "Nginx (Virtual Host) - PHP-FPM " 
sleep 2

#INSTALACION DEL NGINX

sudo yum update -y
sudo yum -y install nginx
sudo chkconfig --add nginx 
sudo chkconfig nginx on

vhost=wordpress
domain=devopsgeekshubsacademy.click

sudo cp /tmp/wordpress.crt /etc/ssl/
sudo cp /tmp/wordpress.key /etc/ssl/
#Vhost

sudo cp /tmp/wordpress.conf /etc/nginx/conf.d/wordpress.conf
 
#Sustituimos el default server al virtualhost

sudo sed -i 's/listen       80 default_server;/listen       80;/g' "/etc/nginx/nginx.conf"

#Habilitar el repositorio Epel
sudo yum-config-manager --enable epel

#INSTALAR PHP7, MySQL-Client

sudo yum -y install php72-fpm php72-pecl-mcrypt php72-cli php72-mysqlnd php72-gd  php72-json php72-intl php7-pear php72-devel php72-mbstring php72-soap mysql
sudo chkconfig  --add php-fpm
sudo chkconfig php-fpm on
sudo cp /etc/php-fpm-7.2.conf /etc/php-fpm.conf
sudo /etc/init.d/php-fpm-7.2 restart


#Editamos el fichero /etc/php-fpm.d/www.conf
sleep 5
sudo sed -i 's/user = apache/user = nginx/g' "/etc/php-fpm.d/www.conf"
#user = nginx 
sudo sed -i 's/group = apache/group = nginx/g' "/etc/php-fpm.d/www.conf"
#group = nginx
sudo sed -i 's/listen = 127.0.0.1:9000/;listen = 127.0.0.1:9000/g' "/etc/php-fpm-7.2.d/www.conf"
sudo sed -i '/;listen = 127.0.0.1:9000/a listen = /var/run/php-fpm-7.2/php-fpm.sock'  /etc/php-fpm.d/www.conf
#listen = /var/run/php/php-fpm.sock
sudo sed -i 's/;listen.owner = nobody/listen.owner = nginx/g' "/etc/php-fpm-7.2.d/www.conf"
#listen.owner = nginx 
sudo sed -i 's/;listen.group = nobody/listen.group = nginx/g' "/etc/php-fpm-7.2.d/www.conf"
#listen.group = nginx 
sudo sed -i 's/;listen.mode = 0660/listen.mode = 0660/g' "/etc/php-fpm-7.2.d/www.conf"
#listen.mode = 0660


#DESCARGAR LA ULTIMA VERSION DEL WORDPRESS

sudo mkdir -p /var/www/
cd /var/www/
sudo wget http://wordpress.org/latest.tar.gz
sudo tar -xvzf latest.tar.gz
sudo mv wordpress /var/www/$vhost
sudo chown -R nginx:nginx /var/www/$vhost/
sudo chmod 755 /var/www/$vhost/

sudo service nginx start
sudo service php-fpm start

sudo cp /tmp/wp-config.php /var/www/$vhost/
sudo cat /var/www/$vhost/wp-config.php
sudo chown nginx:nginx /var/www/$vhost/wp-config.php
echo "FINAL"
sleep 5

