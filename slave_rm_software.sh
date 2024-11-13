#!/bin/bash

# Remove AWS CLI configuration
echo "Removing AWS CLI configuration..."
rm -rf ~/.aws

# Uninstall Docker and remove Docker GPG key and repository
echo "Uninstalling Docker..."
echo "Removing Docker installation..."
apt-get remove --purge -y docker-ce docker-ce-cli containerd.io
rm -rf /var/lib/docker
rm -rf /etc/docker
rm -rf /etc/apt/sources.list.d/docker.list
rm -rf /usr/share/keyrings/docker-archive-keyring.gpg
apt-get autoremove -y


# Remove Java installations
echo "Removing Java installations..."
apt-get purge -y openjdk-17-jre openjdk-17-jdk-headless fontconfig

# Remove Maven
echo "Removing Maven..."
rm -rf /opt/maven
sed -i '/M2_HOME/d' ~/.bashrc
sed -i '/M2_HOME\/bin/d' ~/.bashrc

# Remove Sonar Scanner
echo "Removing Sonar Scanner..."
rm -rf /opt/sonar-scanner
sed -i '/SONAR_SCANNER_HOME/d' ~/.bashrc
sed -i '/SONAR_SCANNER_HOME\/bin/d' ~/.bashrc

# Clean up downloaded files
echo "Cleaning up downloaded files..."
rm -f apache-maven-3.9.9-bin.tar.gz
rm -f sonar-scanner-cli-6.1.0.4477-linux-x64.zip

# Update package list and remove unnecessary packages
echo "Cleaning up package lists and unnecessary packages..."
apt-get update
apt-get autoremove -y
apt-get clean

# Remove Python 3 and pip
echo "Removing Python 3 and pip..."
apt remove --purge -y python3 python3-pip
rm -rf ~/.local/lib/python3* ~/.cache/pip
echo "Python 3 and pip removed."

# Reload ~/.bashrc to apply changes
echo "Reloading environment variables..."
source ~/.bashrc

echo "Removal and cleanup complete."
