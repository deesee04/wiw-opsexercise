# -*- mode: ruby -*-
# vi: set ft=ruby :

## dc 
## v.01
## 2016

Vagrant.configure(2) do |config|

  # Box
  config.vm.box = "ubuntu/trusty64"

  # Ports
  config.vm.network :forwarded_port, guest:80, host:8080
  config.vm.network :forwarded_port, guest:2812, host:8081

  # Provider
  config.vm.provider "virtualbox" do |vb|
    # Metadata
    vb.name = "wiw"
    # Virtual Hardware
    vb.memory = 2048
  end

  # Berkshelf
  config.berkshelf.enabled = true

  # Provisioner
  config.vm.provision "chef_zero" do |chef|
    # Metadata
    chef.node_name = "wiw-blog"
    # Channel
    chef.channel = 'stable'
    chef.version = '12.10.24'
    # Paths
    chef.nodes_path = "nodes"
    chef.cookbooks_path = "cookbooks"
    chef.data_bags_path = "data_bags"
    # Secrets
    chef.encrypted_data_bag_secret_key_path = ".secrets/encrypted_data_bag_secret"

  end
end
