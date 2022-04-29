# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|

    config.vm.define :vm01 do |node|
      node.vm.box = "bento/ubuntu-20.04"
      node.vm.network :private_network, ip: "192.168.200.2"
      node.vm.provision "shell", path: "provision_vm1.sh"
      node.vm.provision "shell", path: "provision_haproxy.sh"
      node.vm.hostname = "vm01"
      node.vm.provider "virtualbox" do |v|
        v.name = "vm01"
        v.memory = 1024
        v.cpus = 1
      end
    end

  config.vm.define :vm02 do |node|
    node.vm.box = "bento/ubuntu-20.04"
    node.vm.network :private_network, ip: "192.168.200.3"
    node.vm.provision "shell", path: "provision_vm2.sh"
    node.vm.provision "shell", path: "provision_web1.sh"
    node.vm.provision "shell", path: "provision_web1_backup.sh"
    node.vm.hostname = "vm02"
    node.vm.provider "virtualbox" do |v|
      v.name = "vm02"
      v.memory = 1024
      v.cpus = 1
    end
  end

  config.vm.define :vm03 do |node|
    node.vm.box = "bento/ubuntu-20.04"
    node.vm.network :private_network, ip: "192.168.200.4"
    node.vm.provision "shell", path: "provision_vm3.sh"
    node.vm.provision "shell", path:"provision_web2.sh"
    node.vm.provision "shell", path: "provision_web2_backup.sh"
    node.vm.hostname = "vm03"
    node.vm.provider "virtualbox" do |v|
      v.name = "vm03"
      v.memory = 1024
      v.cpus = 1
    end
  end

end