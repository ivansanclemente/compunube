#!/bin/bash

lxc launch ubuntu:20.04 web2backup --target vm03 < /dev/null

lxc exec web2backup -- apt update && apt upgrade -y
lxc exec web2backup -- apt install apache2 -y
lxc exec web2backup -- systemctl enable apache2
lxc list

sudo rm index.html
touch index.html
cat >> index.html << EOF
<!DOCTYPE html>
<html>
<body>
<h1>Bienvenido al Servidor Web2-Backup</h1>
<p>Microproyecto 1 - Computacion en la Nube</p>
</body>
</html>
EOF

lxc file push index.html web2backup/var/www/html/index.html

lxc exec web2backup -- systemctl start apache2

lxc config device add web2backup http proxy listen=tcp:0.0.0.0:3080 connect=tcp:127.0.0.1:80