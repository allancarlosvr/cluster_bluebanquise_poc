Vagrant.configure("2") do |config|
  # General VM settings
  config.vm.provider "virtualbox" do |vb|
    vb.memory = "2048"
    vb.cpus = 1
  end

  # Master Node
  config.vm.define "master" do |master|
    master.vm.box = "rockylinux/9"
    master.vm.box_version = "4.0.0"
    master.vm.hostname = "master.cluster.local"

    # Adapter 1: NAT for Internet access
    master.vm.network "private_network", type: "dhcp", auto_config: false

    # Adapter 2: Static IP for cluster communication
    master.vm.network "private_network", ip: "10.77.0.1"

    master.vm.provider "virtualbox" do |vb|
      vb.memory = "4096"
      vb.cpus = 2
      vb.name = "Master Node"
    end

    # Use external script for provisioning
    master.vm.provision "shell", path: "master_provision.sh"
  end

  # Compute Nodes
  (1..2).each do |i|
    config.vm.define "compute#{i}" do |node|
      node.vm.box = "rockylinux/9"
      node.vm.box_version = "4.0.0"
      node.vm.hostname = "compute#{i}.cluster.local"

      # Adapter for private network
      node.vm.network "private_network", type: "dhcp"

      node.vm.provider "virtualbox" do |vb|
        vb.name = "Compute Node #{i}"
        vb.customize ["modifyvm", :id, "--boot1", "disk"]
        vb.customize ["modifyvm", :id, "--boot2", "net"]
      end

      # Use external script for provisioning
      node.vm.provision "shell", path: "compute_provision.sh", args: [i]
    end
  end
end
