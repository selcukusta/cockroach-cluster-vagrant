# -*- mode: ruby -*-
# vi: set ft=ruby :

### configuration parameters
BOX_BASE = "ubuntu/xenial64"
BOX_CPU_COUNT = 1
BOX_RAM_MB = "512"

### replica nodes configuration
NODE_IP_PATTERN = "172.81.81."
NODE_COUNT = 4
NODE_PREFIX = "node0"

$script = <<-SCRIPT
counter=1
while [ $counter -le $1 ]
  do
    ip=$2$((counter+2))
    echo $ip$'\t'$3$counter >> /etc/hosts
    ((counter++))
  done
SCRIPT

Vagrant.require_version ">= 2.0.0"

Vagrant.configure("2") do |config|

  config.vm.provider "virtualbox" do |vb|
    vb.cpus = BOX_CPU_COUNT
    vb.memory = BOX_RAM_MB
  end

  (1..NODE_COUNT).each do |i|
    config.vm.define "#{NODE_PREFIX}#{i}" do |node|
      node.vm.box = BOX_BASE
      node.vm.box_check_update = false
      node.vm.hostname = "#{NODE_PREFIX}#{i}"
      node.vm.network "private_network", ip: "#{NODE_IP_PATTERN}#{i+2}", netmask: "255.255.255.0"
      node.vm.provision "shell" do |s|
        s.inline = $script
        s.args = [NODE_COUNT, NODE_IP_PATTERN, NODE_PREFIX]
      end
      node.vm.provision "shell", path: "scripts/create-service.sh", args: [NODE_COUNT, NODE_PREFIX, "#{NODE_PREFIX}#{i}"]
      node.vm.provision "shell", path: "scripts/install.sh"
      if NODE_COUNT == i
        node.vm.provision "shell", path: "scripts/start-cluster.sh", args: ["#{NODE_PREFIX}#{i}"]
      end
    end
  end
end