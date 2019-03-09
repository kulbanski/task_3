#!/bin/bash
sudo yum -y update

#install postgresql
sudo yum -y install https://download.postgresql.org/pub/repos/yum/11/redhat/rhel-7-x86_64/pgdg-redhat11-11-2.noarch.rpm
sudo yum -y install postgresql11-server
sudo /usr/pgsql-11/bin/postgresql-11-setup initdb
sudo systemctl start postgresql-11
sudo systemctl enable postgresql-11

#create database
sudo -u postgres psql -c "CREATE USER moodle WITH ENCRYPTED PASSWORD 'password';"
sudo -u postgres psql -c "CREATE DATABASE moodle WITH OWNER moodle;"
sudo -u postgres psql -c "GRANT ALL PRIVILEGES ON DATABASE moodle to moodle;"

sudo sed -i -e "s/#listen_addresses = 'localhost'/listen_addresses = '*'/g" /var/lib/pgsql/11/data/postgresql.conf
sudo sed -i -e "s/#port = 5432/port = 5432/g" /var/lib/pgsql/11/data/postgresql.conf
sudo cat <<EOF | sudo tee -a /var/lib/pgsql/11/data/pg_hba.conf
host    all             all              192.168.56.101/32        password
host    all             all              192.168.56.102/32        password
EOF
sudo systemctl restart postgresql-11
