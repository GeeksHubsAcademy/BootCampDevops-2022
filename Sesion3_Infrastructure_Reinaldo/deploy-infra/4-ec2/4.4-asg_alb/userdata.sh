#!/bin/bash

sudo yum install -y https://s3.amazonaws.com/ec2-downloads-windows/SSMAgent/latest/linux_amd64/amazon-ssm-agent.rpm
sudo start amazon-ssm-agent
sudo status amazon-ssm-agent

#######################################################
## Configuramos las métricas de CloudWatch ##
#######################################################
echo "* * * * *  /opt/aws/aws-scripts-mon/mon-put-instance-data.pl --mem-util --disk-space-util --disk-path=/ --auto-scaling --from-cron" >> /var/spool/cron/root

PASSWD=$(aws ssm get-parameter --name "/infraestructura/training/rds_passwd" --with-decryption --region eu-west-1 --query 'Parameter.Value' --output text)
HOST=$(aws ssm get-parameter --name "/infraestructura/training/rds_host" --with-decryption --region eu-west-1 --query 'Parameter.Value' --output text)

sed -i "s/RDSPASSWD/${PASSWD}/g" "/var/www/wordpress/wp-config.php"
sed -i "s/RDSHOST/${HOST}/g" "/var/www/wordpress/wp-config.php"

chown -R nginx:nginx /var/run/php-fpm/
service nginx restart
service php-fpm-7.2 restart