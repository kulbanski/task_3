# DataBase credentials
DB_NAME = "moodle"
DB_USER = "moodle"
DB_PASSWD = "password"

NETWORK = "192.168.56."
DB_HOST_IP = "#{NETWORK}103"

Vagrant.configure("2") do |config|

config.vm.define "DB" do |db|
	db.vm.box = "centos/7"
	db.vm.network "private_network", ip:"#{DB_HOST_IP}"
	#db.vm.network "forwarded_port", guest:80,host:8083
	#db.vm.network "public_network"
  	db.vm.provision "shell", path:"scenario_BD.sh"
		db.vm.provider "virtualbox" do |name|
		name.name = "task3-db-postgresql"
		end
end  

config.vm.define "web1" do |web1|
	SRV_HOST_IP = "#{NETWORK}101"
	web1.vm.box = "centos/7"
	web1.vm.network "private_network", ip:"#{SRV_HOST_IP}"
	#web1.vm.network "forwarded_port", guest:80,host:8081
	#web1.vm.network "public_network"
  	web1.vm.provision "shell", path:"scenario_web.sh", :args => [SRV_HOST_IP, DB_NAME, DB_USER, DB_PASSWD, DB_HOST_IP]
		web1.vm.provider "virtualbox" do |name|
		name.name = "task3-web1-apache"
		end
end
config.vm.define "web2" do |web2|
	SRV_HOST_IP = "#{NETWORK}102"
	web2.vm.box = "centos/7"
	web2.vm.network "private_network", ip:"#{SRV_HOST_IP}"
	#web2.vm.network "forwarded_port", guest:80,host:8082
	#web2.vm.network "public_network"
  	web2.vm.provision "shell", path:"scenario_web.sh", :args => [SRV_HOST_IP, DB_NAME, DB_USER, DB_PASSWD, DB_HOST_IP]
		web2.vm.provider "virtualbox" do |name|
		name.name = "task3-web2-apache"
		end
end
config.vm.define "LB" do |lb|
	lb.vm.box = "centos/7"
	lb.vm.network "private_network", ip:"#{NETWORK}100"
	#lb.vm.network "forwarded_port", guest:80,host:8080
	#lb.vm.network "public_network"
  	lb.vm.provision "shell", path:"scenario_lb.sh"
		lb.vm.provider "virtualbox" do |name|
		name.name = "task3-LB-nginx"
		end
end
end
