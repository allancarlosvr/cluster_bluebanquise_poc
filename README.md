# Cluster Blue Banquise POC

This project demonstrates a Proof of Concept (POC) for setting up a cluster using Blue Banquise with Vagrant and VirtualBox. The cluster consists of one management node (master) and two compute nodes (compute1 and compute2).

##  Prerequisites

- [Download and Install VirtualBox](https://www.virtualbox.org)
- [Download and Install Vagrant](https://www.vagrantup.com)

Install the Vagrant plugin for VirtualBox guest additions:

```sh
vagrant plugin install vagrant-vbguest
```
## Setup Steps

### Step 1: Create a Project Directory

```sh
mkdir cluster_bluebanquise_poc && cd cluster_bluebanquise_poc
```
### Step 2: Create and Configure the Vagrantfile:

```ruby
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
```
### Key Configuration Details:
- *Master Node:*

Static IP: 10.77.0.1
4GB memory and 2 CPUs for managing the cluster
Provisioning script: master_provision.sh

- *Compute Nodes:*

Dynamic IP addresses
Each node is provisioned using a unique script (compute_provision.sh)

### Step 3: Start the Virtual Machines

```sh
vagrant up
```

Vagrant will:

Download the specified base box (rockylinux/9)
Configure and provision the master and compute nodes


### Step 4: Access the Nodes

- Master Node:
```sh
vagrant ssh master
```

- Compute Nodes

```sh
vagrant ssh compute1
vagrant ssh compute2
```

## Notes

- The Vagrantfile uses external provisioning scripts (master_provision.sh and compute_provision.sh). Ensure these scripts are in the project directory.
Stop the virtual machines when not in use:

- Stop the virtual machines when not in use
```sh
vagrant halt
```
- Destroy the machines to reclaim resources:
```sh
vagrant destroy
```




