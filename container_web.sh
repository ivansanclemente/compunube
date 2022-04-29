#!/bin/bash

#script instalacion contenedor LXD con web server
#echo "actualizando Ubuntu"
#sudo apt-get update -y

#echo "instalacion LXD"
#sudo apt-get install lxd -y
#sudo newgrp lxd
#sudo lxd init --auto

echo "configuracion container"
sudo lxc launch ubuntu:20.04 web1
#sudo lxc exec web -- apt-get install net-tools -y
sudo lxc exec web1 -- apt-get install apache2 -y
sudo lxc exec web1 -- systemctl enable apache2

echo "configuracion pagina web"
sudo lxc file push index.html web/var/www/html/index.html

echo "reiniciar servidor apache"
sudo lxc exec web1 -- systemctl restart apache2

echo "redireccionar puertos"
sudo lxc config device add web1 myport80 proxy listen=tcp:192.168.200.2:5080 connect=tcp:127.0.0.1:80 Device myport80 added to web
