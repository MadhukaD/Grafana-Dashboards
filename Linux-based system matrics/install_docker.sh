#!/bin/bash

# Update the package list and install prerequisites
sudo apt update
sudo apt install -y apt-transport-https ca-certificates curl software-properties-common

# Add Docker's official GPG key
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

# Set up the stable repository
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu focal stable"

# Update the package list again
sudo apt update

# Install Docker CE
sudo apt install -y docker-ce

# Check Docker version
docker --version

# Check Docker status (non-interactive)
if systemctl is-active --quiet docker; then
    echo "Docker is running."
else
    echo "Docker is not running. Attempting to start Docker..."
    sudo systemctl start docker
    if systemctl is-active --quiet docker; then
        echo "Docker started successfully."
    else
        echo "Failed to start Docker."
        exit 1
    fi
fi

sudo groupadd docker
sudo usermod -aG docker ${USER}
docker run hello-world
echo "Docker installation and setup completed successfully."