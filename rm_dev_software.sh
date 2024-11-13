#!/bin/bash

# Ensure script is run as root
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 
   exit 1
fi

echo "Starting the cleanup and removal of installed packages and configurations..."

# Remove AWS CLI and configuration files
echo "Removing AWS CLI and configurations..."
apt remove --purge -y awscli
rm -rf ~/.aws
echo "AWS CLI and configurations removed."

# Remove Docker and its associated data
echo "Removing Docker and its data..."
apt remove --purge -y docker-ce docker-ce-cli containerd.io
rm -rf /var/lib/docker /etc/docker
rm -rf /run/docker /usr/share/keyrings/docker-archive-keyring.gpg
rm -f /etc/apt/sources.list.d/docker.list
echo "Docker and its data have been removed."

# Remove Python 3 and pip
echo "Removing Python 3 and pip..."
apt remove --purge -y python3 python3-pip
rm -rf ~/.local/lib/python3* ~/.cache/pip
echo "Python 3 and pip removed."

# Remove Java
echo "Removing Java..."
apt remove --purge -y fontconfig openjdk-17-jre openjdk-17-jdk-headless
echo "Java removed."

# Remove unnecessary packages and clean up
echo "Cleaning up residual packages..."
apt autoremove -y
apt clean

# Final message
echo "All specified packages and configurations have been successfully removed."
