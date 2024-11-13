#!/bin/bash

# Define VM IPs
master_ip="34.229.203.105"
slave_ip="52.3.77.245"
sonarqube_ip="34.229.141.142"
dev_vm_ip="54.221.3.93"

# Define PEM key file path
PEM_KEY_PATH="/home/venkat/pem/test.pem"

# sudo hostnamectl set-hostname new-hostname // setup the new hostname

# Jenkins_Master
echo "Copying and executing scripts on Jenkins Master..."
sudo scp -i "$PEM_KEY_PATH" mastersoftware.sh ubuntu@"${master_ip}":/home/ubuntu/
sudo scp -i "$PEM_KEY_PATH" rm_master_software.sh ubuntu@"${master_ip}":/home/ubuntu
sudo scp -i "$PEM_KEY_PATH" aws_config.json ubuntu@"${master_ip}":/home/ubuntu/


# Jenkins_Slave
echo "Copying and executing scripts on Jenkins Slave..."
sudo scp -i "$PEM_KEY_PATH" slavesoftware.sh ubuntu@"${slave_ip}":/home/ubuntu/
sudo scp -i "$PEM_KEY_PATH" slave_rm_software.sh ubuntu@"${slave_ip}":/home/ubuntu/
sudo scp -i "$PEM_KEY_PATH" aws_config.json ubuntu@"${slave_ip}":/home/ubuntu/


# Sonarqube_server
echo "Copying and executing scripts on SonarQube Server..."
sudo scp -i "$PEM_KEY_PATH" sonarqube-server-software.sh ubuntu@"${sonarqube_ip}":/home/ubuntu/
sudo scp -i "$PEM_KEY_PATH" sonar_rm_software.sh ubuntu@"${sonarqube_ip}":/home/ubuntu/
sudo scp -i "$PEM_KEY_PATH" aws_config.json ubuntu@"${sonarqube_ip}":/home/ubuntu/

# Dev_server
echo "Copying and executing scripts on Dev VM..."
sudo scp -i "$PEM_KEY_PATH" dev_vm_software.sh ubuntu@"${dev_vm_ip}":/home/ubuntu/
sudo scp -i "$PEM_KEY_PATH" rm_dev_software.sh ubuntu@"${dev_vm_ip}":/home/ubuntu/
sudo scp -i "$PEM_KEY_PATH" aws_config.json ubuntu@"${dev_vm_ip}":/home/ubuntu/


# Final message
echo "Scripts executed successfully on all VMs."
