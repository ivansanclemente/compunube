#!/bin/bash
lxc launch ubuntu:20.04 web1 --target vm02 < /dev/null




lxc exec web1 -- apt update && apt upgrade -y
lxc exec web1 -- apt install apache2 -y
lxc exec web1 -- systemctl enable apache2
lxc list

sudo rm index.html
touch index.html
cat >> index.html << EOF
<!DOCTYPE html>
<html>
<body>
<h1>Bienvenido al Servidor Web1</h1>
<p>Microproyecto 1 - Computacion en la Nube</p>
</body>
</html>
EOF

lxc file push index.html web1/var/www/html/index.html



lxc exec web1 -- systemctl start apache2

lxc config device add web1 http proxy listen=tcp:0.0.0.0:5080 connect=tcp:127.0.0.1:80


#-----------------------------------------------------------------------------------------------------

