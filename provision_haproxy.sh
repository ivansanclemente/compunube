#!/bin/bash

lxc launch ubuntu:20.04 haproxy --target vm01 < /dev/null



lxc exec haproxy -- apt update && apt upgrade -y 
lxc exec haproxy -- apt install haproxy -y
lxc exec haproxy -- systemctl enable haproxy

 

sudo rm haproxy.cfg
touch haproxy.cfg

cat >> haproxy.cfg << EOF
global
	log /dev/log	local0
	log /dev/log	local1 notice
	chroot /var/lib/haproxy
	stats socket /run/haproxy/admin.sock mode 660 level admin expose-fd listeners
	stats timeout 30s
	user haproxy
	group haproxy
	daemon

	# Default SSL material locations
	ca-base /etc/ssl/certs
	crt-base /etc/ssl/private

	# Default ciphers to use on SSL-enabled listening sockets.
	# For more information, see ciphers(1SSL). This list is from:
	#  https://hynek.me/articles/hardening-your-web-servers-ssl-ciphers/
	# An alternative list with additional directives can be obtained from
	#  https://mozilla.github.io/server-side-tls/ssl-config-generator/?server=haproxy
	ssl-default-bind-ciphers ECDH+AESGCM:DH+AESGCM:ECDH+AES256:DH+AES256:ECDH+AES128:DH+AES:RSA+AESGCM:RSA+AES:!aNULL:!MD5:!DSS
	ssl-default-bind-options no-sslv3

defaults
	log	global
	mode	http
	option	httplog
	option	dontlognull
        timeout connect 5000
        timeout client  50000
        timeout server  50000
	errorfile 400 /etc/haproxy/errors/400.http
	errorfile 403 /etc/haproxy/errors/403.http
	errorfile 408 /etc/haproxy/errors/408.http
	errorfile 500 /etc/haproxy/errors/500.http
	errorfile 502 /etc/haproxy/errors/502.http
	errorfile 503 /etc/haproxy/errors/503.http
	errorfile 504 /etc/haproxy/errors/504.http


backend web-backend
   balance roundrobin
   stats enable
   stats auth admin:admin
   stats uri /haproxy?stats

   server web1 192.168.200.3:5080 check
   server web2 192.168.200.4:5080 check
   server web1backup 192.168.200.3:3080 check backup
   server web2backup 192.168.200.4:3080 check backup
   

frontend http
  bind *:80
  default_backend web-backend

EOF

lxc file push haproxy.cfg haproxy/etc/haproxy/haproxy.cfg
lxc exec haproxy -- systemctl start haproxy
lxc config device add haproxy http proxy listen=tcp:0.0.0.0:1080 connect=tcp:127.0.0.1:80

#------------------------------------------------------------------------------------------------

echo "Configurar index.html Para manejar Errores de fallas en los Servidores"

touch 503.html

cat >> 503.html << EOF
HTTP/1.0 503 Service Unavailable
Cache-Control: no-cache
Connection: close
Content-Type: text/html

<html>
<body>
<h1>Error 503</h1>
<p></p>
</body>
</html>
EOF

lxc file push /home/vagrant/503.html haproxy/etc/haproxy/errors/503.http

#-----------------------------------------------------------------------------------------------
lxc exec haproxy -- systemctl restart haproxy