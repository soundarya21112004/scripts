#!/bin/bash

# Define SonarQube version
SONARQUBE_VERSION="9.9.1.69595"

# Ensure dependencies are installed
echo "Installing dependencies..."
apt update && apt install -y openjdk-17-jdk fontconfig jq \
    apt-transport-https ca-certificates curl gnupg lsb-release wget unzip || { echo "Dependency installation failed"; exit 1; }
sudo apt upgrade -y
# AWS Configure (optional, remove if not needed)
CONFIG_FILE="aws_config.json"
if [ -f "$CONFIG_FILE" ]; then
    echo "Configuring AWS CLI..."
    mkdir -p ~/.aws
    AWS_ACCESS_KEY_ID=$(jq -r '.aws_access_key_id' "$CONFIG_FILE")
    AWS_SECRET_ACCESS_KEY=$(jq -r '.aws_secret_access_key' "$CONFIG_FILE")
    REGION=$(jq -r '.region' "$CONFIG_FILE")
    OUTPUT=$(jq -r '.output' "$CONFIG_FILE")

    cat <<EOT > ~/.aws/credentials
[default]
aws_access_key_id = $AWS_ACCESS_KEY_ID
aws_secret_access_key = $AWS_SECRET_ACCESS_KEY
EOT

    cat <<EOT > ~/.aws/config
[default]
region = $REGION
output = $OUTPUT
EOT
else
    echo "AWS configuration file not found, skipping AWS configuration."
fi

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

# Install Docker
echo "Installing Docker..."
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" > /etc/apt/sources.list.d/docker.list

apt update && apt install -y docker-ce docker-ce-cli containerd.io || { echo "Docker installation failed"; exit 1; }

# Enable and start Docker service
echo "Starting Docker service..."
systemctl enable docker
systemctl start docker
docker --version || { echo "Docker installation verification failed"; exit 1; }

# create a 2 GB swap file for sonnarqube. Because sonarqube required 2 GB RAM.  
free -h

sudo fallocate -l 2G /swapfile
sudo chmod 600 /swapfile
sudo mkswap /swapfile
sudo swapon /swapfile

echo '/swapfile none swap sw 0 0' | sudo tee -a /etc/fstab

free -h

# Create a dedicated user for SonarQube
echo "Creating SonarQube user..."
useradd -m -d /opt/sonarqube -r -s /bin/bash sonarqube || { echo "Failed to create SonarQube user"; exit 1; }

# Download and install SonarQube
echo "Downloading and setting up SonarQube..."
cd /opt || exit
wget https://binaries.sonarsource.com/Distribution/sonarqube/sonarqube-$SONARQUBE_VERSION.zip || { echo "SonarQube download failed"; exit 1; }
unzip sonarqube-$SONARQUBE_VERSION.zip || { echo "Failed to unzip SonarQube"; exit 1; }
mv sonarqube-$SONARQUBE_VERSION sonarqube
chown -R sonarqube:sonarqube /opt/sonarqube

# Setup SonarQube as a systemd service
echo "Configuring SonarQube as a systemd service..."
cat <<EOT > /etc/systemd/system/sonarqube.service
[Unit]
Description=SonarQube service
After=syslog.target network.target

[Service]
Type=forking
ExecStart=/opt/sonarqube/sonarqube-9.9.1.69595/bin/linux-x86-64/sonar.sh start
ExecStop=/opt/sonarqube/sonarqube-9.9.1.69595/bin/linux-x86-64/sonar.sh stop
User=sonarqube
Group=sonarqube
Restart=on-failure
LimitNOFILE=65536

[Install]
WantedBy=multi-user.target
EOT

# Reload systemd to recognize the new service, enable and start SonarQube
echo "Starting SonarQube service..."
systemctl daemon-reload
systemctl enable sonarqube
systemctl start sonarqube || { echo "SonarQube failed to start"; exit 1; }

# Output the server's URL
echo "SonarQube server setup is complete. Access it at http://<your-server-ip>:9000"

# Verify SonarQube service status
systemctl status sonarqube --no-pager
