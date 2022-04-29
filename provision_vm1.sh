#!/bin/bash

apt-get update

#sudo apt install sntp -y
#sudo sntp time.google.com

echo "Implementacion de Cluster"

#sudo snap install lxd
#sudo snap refresh lxd
sudo gpasswd -a vagrant lxd

sudo rm lxdconfig.yaml

cat >> lxdconfig.yaml << EOF
config:
  core.https_address: 192.168.200.2:8443
  core.trust_password: admin
networks:
- config:
    bridge.mode: fan
    fan.underlay_subnet: 192.168.200.0/24
  description: ""
  name: lxdfan0
  type: ""
storage_pools:
- config: {}
  description: ""
  name: local
  driver: dir
profiles:
- config: {}
  description: ""
  devices:
    eth0:
      name: eth0
      network: lxdfan0
      type: nic
    root:
      path: /
      pool: local
      type: disk
  name: default
cluster:
  server_name: vm01
  enabled: true
  member_config: []
  cluster_address: ""
  cluster_certificate: ""
  server_address: ""
  cluster_password: ""
  cluster_certificate_path: ""
  cluster_token: ""
EOF

echo "Inicializar LXD Usando Archivo Preseed"
cat lxdconfig.yaml | lxd init --preseed
lxc cluster list



sudo cp /var/snap/lxd/common/lxd/cluster.crt /vagrant/cluster.crt
#Se modifca la indentacion de todas las lineas hacia la derecha 4 espacios, usando sed. y el resultado se almacena en un nuevo archivo.
sed 's/^/    /g' /vagrant/cluster.crt > /vagrant/clustercer.crt

echo "Certificado creado"
