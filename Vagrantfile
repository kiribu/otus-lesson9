# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure(2) do |config|

  config.vm.box = "centos/8"
  #config.vm.box_version = "20210210.0"
  config.vm.provider "virtualbox" do |v|
  v.memory = 512
  v.cpus = 1

end

config.vm.define "sysD" do |sysD|
  sysD.vm.network "private_network", ip: "192.168.22.10",
  virtualbox__intnet: "net1"
  sysD.vm.hostname = "sysD"
  sysD.vm.provision "shell", path: "script.sh"

end



end
