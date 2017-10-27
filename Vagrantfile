# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"
Vagrant.require_version  ">= 1.8"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
    config.vm.box = "CentOS6"
    #config.vm.network "forwarded_port", guest: 80, host: 8888
    config.vm.network "private_network", ip: "192.168.192.190"

    config.ssh.host = "192.168.192.190"
    config.ssh.port = "22"
    config.ssh.username = "root"
    config.ssh.password = "vagrant"

    config.vm.synced_folder "E:/code/lua/lua_vanilla", "/home/code/lua_vanilla2"

    # config.vm.provision "shell", inline: "vanilla start development", run: "always"

    config.vm.provider "virtualbox" do |vb|
      vb.memory = 2048
      vb.linked_clone = true
      vb.name = "lua"
      vb.gui = false
      vb.cpus = 2
    end
end
