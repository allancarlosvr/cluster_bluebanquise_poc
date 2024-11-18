Vagrant.configure("2") do |config|
    # General settings for all VMs
    config.vm.provider "virtualbox" do |vb|
      vb.memory = "2048"
      vb.cpus = 1
    end
  
    # Master Node (Management Node)
    config.vm.define "master" do |master|
      master.vm.box = "generic/rocky9"
      master.vm.hostname = "master.cluster.local"
      master.vm.network "private_network", ip: "10.77.0.1"
      master.vm.provider "virtualbox" do |vb|
        vb.memory = "4096"
        vb.cpus = 2
        vb.name = "Master Node"
      end
      master.vm.provision "shell", inline: <<-SHELL
        sudo dnf install -y epel-release
        sudo dnf install -y httpd dhcp-server bind chrony nfs-utils tftp-server
        sudo systemctl disable firewalld
        sudo systemctl stop firewalld
        sudo hostnamectl set-hostname master.cluster.local
      SHELL
    end
  
    # Compute Nodes (Clients)
    (1..2).each do |i|
      config.vm.define "compute#{i}" do |node|
        node.vm.box = "generic/rocky9"
        node.vm.hostname = "compute#{i}.cluster.local"
        node.vm.network "private_network", ip: "10.77.0.#{i + 1}"
        node.vm.provider "virtualbox" do |vb|
          vb.name = "Compute Node #{i}"
        end
        node.vm.provision "shell", inline: <<-SHELL
          sudo dnf install -y epel-release
          sudo hostnamectl set-hostname compute#{i}.cluster.local
        SHELL
      end
    end
  end
  