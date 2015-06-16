# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure(2) do |config|
  config.vm.box = "ubuntu/vivid64"

  config.vm.define "worker1" do |worker1|
    worker1.vm.network "private_network", ip: "192.168.33.11"
    worker1.vm.provision "shell", path: "provision_worker.sh"
  end

  config.vm.define "worker2" do |worker2|
    worker2.vm.network "private_network", ip: "192.168.33.12"
    worker2.vm.provision "shell", path: "provision_worker.sh"
  end

  config.vm.define "worker3" do |worker3|
    worker3.vm.network "private_network", ip: "192.168.33.13"
    worker3.vm.provision "shell", path: "provision_worker.sh"
  end

  config.vm.define "master" do |master|
    master.vm.network "private_network", ip: "192.168.33.10"
    master.vm.provision "shell", path: "provision_master.sh"
  end
end
