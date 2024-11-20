#!/bin/bash

# Install necessary packages
dnf install -y epel-release
dnf install -y httpd dhcp-server bind chrony nfs-utils tftp-server

# Disable firewalld and configure rules
systemctl disable firewalld
systemctl stop firewalld

# Set hostname
hostnamectl set-hostname master.cluster.local

# Configure DHCP server
cat <<EOF > /etc/dhcp/dhcpd.conf
subnet 10.77.0.0 netmask 255.255.255.0 {
  range 10.77.0.100 10.77.0.200;
  option routers 10.77.0.10;
  option domain-name-servers 10.77.0.10;
}
EOF
systemctl enable dhcpd
systemctl start dhcpd
