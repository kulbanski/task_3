#!/bin/bash

sudo yum -y update
sudo yum -y install epel-release

#install nginx
sudo yum -y install nginx
sudo systemctl start nginx
sudo systemctl enable nginx

#change config lb
sudo cat << EOF | sudo tee -a /etc/nginx/conf.d/mymoodle.conf
upstream moodle {
        server 192.168.56.101:80;
        server 192.168.56.102:80;
    }
    server {
        listen 80;
        server_name 192.168.56.100;
            location / {
             proxy_pass http://moodle;
       }
   }
EOF
sudo systemctl restart nginx

#config Firewall
sudo systemctl enable firewalld
sudo systemctl start firewalld
sudo firewall-cmd --zone=public --add-service=ssh
sudo firewall-cmd --permanent --zone=public --add-service=http 
sudo firewall-cmd --permanent --zone=public --add-service=https
sudo firewall-cmd --reload