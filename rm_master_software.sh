#!/bin/bash

# Stop and disable Docker
systemctl stop docker
systemctl disable docker

# Remove Docker packages
echo "Removing Docker installation..."
apt-get remove --purge -y docker-ce docker-ce-cli containerd.io
rm -rf /var/lib/docker
rm -rf /etc/docker
rm -rf /etc/apt/sources.list.d/docker.list
rm -rf /usr/share/keyrings/docker-archive-keyring.gpg
apt-get autoremove -y


# Stop and disable Jenkins
systemctl stop jenkins
systemctl disable jenkins

# Remove Jenkins package and configurations
apt-get purge -y jenkins
rm -f /etc/apt/sources.list.d/jenkins.list
rm -f /usr/share/keyrings/jenkins-keyring.asc
rm -rf /var/lib/jenkins
rm -rf /var/log/jenkins
rm -rf /etc/jenkins

# Remove Python 3 and pip
echo "Removing Python 3 and pip..."
apt remove --purge -y python3 python3-pip
rm -rf ~/.local/lib/python3* ~/.cache/pip
echo "Python 3 and pip removed."

# Remove Java
apt-get purge -y openjdk-17-jre fontconfig

# Clean up any remaining dependencies
apt-get autoremove -y
apt-get clean

echo "Docker, Java, and Jenkins have been removed."
