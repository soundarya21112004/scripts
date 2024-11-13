#!/bin/bash

# Stop SonarQube service if it's running
echo "Stopping SonarQube service..."
systemctl stop sonarqube
systemctl disable sonarqube

# Remove SonarQube service file
echo "Removing SonarQube systemd service..."
rm -f /etc/systemd/system/sonarqube.service

# Reload systemd daemon to remove the service reference
systemctl daemon-reload

# Remove SonarQube files
echo "Removing SonarQube installation files..."
rm -rf /opt/sonarqube*

# Remove SonarQube user
echo "Removing SonarQube user and group..."
userdel -r sonarqube

# Remove Java (optional, only if SonarQube was the sole application using it)
echo "Removing Java installation..."
apt-get remove --purge -y openjdk-17-jre openjdk-17-jdk-headless
apt-get autoremove -y

# Remove Docker if it was only installed for SonarQube (optional)
echo "Removing Docker installation..."
apt-get remove --purge -y docker-ce docker-ce-cli containerd.io
rm -rf /var/lib/docker
rm -rf /etc/docker
rm -rf /etc/apt/sources.list.d/docker.list
rm -rf /usr/share/keyrings/docker-archive-keyring.gpg
apt-get autoremove -y

# Remove Python 3 and pip
echo "Removing Python 3 and pip..."
apt remove --purge -y python3 python3-pip
rm -rf ~/.local/lib/python3* ~/.cache/pip
echo "Python 3 and pip removed."

# Remove temporary and cache files
echo "Cleaning up temporary files and package cache..."
apt-get clean
rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

echo "SonarQube and related components have been removed."
