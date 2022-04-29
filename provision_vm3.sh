#!/bin/bash
apt-get update

echo "Implementacion de Cluster"

#sudo snap install lxd
#sudo snap refresh lxd
sudo gpasswd -a vagrant lxd

sudo rm lxdconfig.yaml

clustercertificado=$(</vagrant/clustercer.crt)
echo "$clustercertificado"


cat >> lxdconfig.yaml << EOF
config: {}
networks: []
storage_pools: []
profiles: []
cluster:
  server_name: vm03
  enabled: true
  member_config:
  - entity: storage-pool
    name: local
    key: source
    value: ""
    description: '"source" property for storage pool "local"'
  cluster_address: 192.168.200.2:8443
  cluster_certificate: |
$clustercertificado
  server_address: 192.168.200.4:8443
  cluster_password: admin
  cluster_certificate_path: ""
  cluster_token: ""

EOF

echo "Inicializar LXD Usando Archivo Preseed"
cat lxdconfig.yaml |sudo lxd init --preseed
lxc cluster list