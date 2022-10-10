#!/bin/bash

################################
## INSTALACION AMAZON LINUX 2 ##
##        AMI PACKER          ##
################################
sudo yum update -y
sudo amazon-linux-extras install epel -y

#############################
## HERRAMIENTAS NECESARIAS ##
#############################
sudo yum install -y zip unzip git htop

## ESTABLECEMOS HUSO HORARIO
rm -rf /etc/localtime
ln -s /usr/share/zoneinfo/Europe/Madrid /etc/localtime

#######################
## INSTALACION NGINX ##
#######################
sudo yum install -y nginx
sudo systemctl stop nginx

############################
##### APP INSTALL ######
############################
rm -rf /usr/share/nginx/html
mkdir -p /usr/share/nginx/html
cd /usr/share/nginx/html
aws s3 cp s3://terraform-devops-dev/ha/ha.zip .
unzip ha.zip
chown -R nginx:nginx ../../nginx

#######################
## INITIAL NGINX ##
#######################
sudo systemctl start nginx 
sudo systemctl enable nginx
sudo systemctl status nginx
sudo chkconfig nginx on