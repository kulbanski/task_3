#!/bin/bash

# Define Vars
SRVHOSTIP=${1}
DBNAME=${2}
DBUSER=${3}
DBPASSWD=${4}
DBHOSTIP=${5}

#sudo yum -y update

#install apache
sudo yum -y install httpd
sudo sed -i -e 's+DocumentRoot "/var/www/html"+DocumentRoot "/var/www/html/moodle"+g' /etc/httpd/conf/httpd.conf
sudo sed -i -e 's+DirectoryIndex index.html+DirectoryIndex index.php index.html index.htm+g' /etc/httpd/conf/httpd.conf
sudo setsebool -P httpd_can_network_connect=1
sudo systemctl enable httpd
sudo systemctl start httpd

#install php7 and include EPEL
sudo yum -y install epel-release.noarch
sudo yum -y install http://rpms.remirepo.net/enterprise/remi-release-7.rpm
sudo yum-config-manager --disable remi-php54
sudo yum-config-manager --enable remi-php73
sudo yum -y install php php-mcrypt php-cli php-gd php-curl php-ldap php-zip php-fileinfo \
    php-xml php-intl php-mbstring php-xmlrpc php-soap php-fpm \
    php-devel php-pear php-bcmath php-json php-pdo php-pgsql

#install moodle 36
sudo yum -y install wget
sudo wget https://download.moodle.org/download.php/direct/stable36/moodle-latest-36.tgz
sudo tar -xvzf moodle-latest-36.tgz -C /var/www/html/
sudo php /var/www/html/moodle/admin/cli/install.php --chmod=2770 \
 --lang=uk \
 --wwwroot=http://${SRVHOSTIP} \
 --dataroot=/var/moodledata \
 --dbtype=pgsql \
 --dbhost=${DBHOSTIP} \
 --dbname=${DBNAME} \
 --dbuser=${DBUSER} \
 --dbpass=${DBPASSWD} \
 --dbport=5432 \
 --fullname=Moodle \
 --shortname=moodle \
 --summary=Moodle \
 --adminuser=admin \
 --adminpass=Admin1 \
 --non-interactive \
 --agree-license
sudo chmod o+r /var/www/html/moodle/config.php
sudo chcon -R -t httpd_sys_rw_content_t /var/moodledata
sudo chown -R apache:apache /var/moodledata
sudo chown -R apache:apache /var/www/
sudo systemctl restart httpd

# Setup&Config Firewall
sudo systemctl enable firewalld
sudo systemctl start firewalld
sudo firewall-cmd --zone=public --add-service=ssh
sudo firewall-cmd --permanent --zone=public --add-service=http 
sudo firewall-cmd --permanent --zone=public --add-service=https
sudo firewall-cmd --reload