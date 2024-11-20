#!/bin/bash

NODE_NUM=$1

# Set hostname
hostnamectl set-hostname compute${NODE_NUM}.cluster.local

# Install cluster utilities if needed
dnf install -y nfs-utils chrony
