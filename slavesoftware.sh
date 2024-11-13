#!/bin/bash

# Ensure dependencies are installed
apt update && apt install -y awscli jq \
    apt-transport-https ca-certificates curl gnupg lsb-release wget

# Update the package list
apt update

# Install Python 3
apt install -y python3

# Install pip for Python 3
apt install -y python3-pip

# Verify installations
python3 --version
pip3 --version

echo "Python 3 and pip have been installed successfully."

# AWS Configure
CONFIG_FILE="aws_config.json"

# Extract values from JSON
AWS_ACCESS_KEY_ID=$(jq -r '.aws_access_key_id' "$CONFIG_FILE")
AWS_SECRET_ACCESS_KEY=$(jq -r '.aws_secret_access_key' "$CONFIG_FILE")
REGION=$(jq -r '.region' "$CONFIG_FILE")
OUTPUT=$(jq -r '.output' "$CONFIG_FILE")

# Write to ~/.aws/credentials
mkdir -p ~/.aws
cat <<EOT > ~/.aws/credentials
[default]
aws_access_key_id = $AWS_ACCESS_KEY_ID
aws_secret_access_key = $AWS_SECRET_ACCESS_KEY
EOT

# Write to ~/.aws/config
cat <<EOT > ~/.aws/config
[default]
region = $REGION
output = $OUTPUT
EOT

# Install Docker
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" > /etc/apt/sources.list.d/docker.list

apt update && apt install -y docker-ce docker-ce-cli containerd.io

# Enable and start Docker service
systemctl enable docker
systemctl start docker
docker --version

# Java Installation
apt install -y fontconfig openjdk-17-jre openjdk-17-jdk-headless
java -version

# Maven Installation
wget https://dlcdn.apache.org/maven/maven-3/3.9.9/binaries/apache-maven-3.9.9-bin.tar.gz
tar -xvzf apache-maven-3.9.9-bin.tar.gz
mv apache-maven-3.9.9 /opt/maven

export M2_HOME=/opt/maven
export export PATH=$M2_HOME/bin:$PATH
which mvn
mvn --version

# Sonar Scanner CLI Installation
aws s3 cp s3://sonar-scanner-6/sonar-scanner-cli-6.1.0.4477-linux-x64.zip .
apt install unzip -y
unzip sonar-scanner-cli-6.1.0.4477-linux-x64.zip
mv sonar-scanner-6.1.0.4477-linux-x64 /opt/sonar-scanner
export SONAR_SCANNER_HOME=/opt/sonar-scanner
export PATH=$SONAR_SCANNER_HOME/bin:$PATH
which sonar-scanner