#!/bin/bash

# Define color variables for output messages
RED='\033[0;31m'     # Red color for errors
GREEN='\033[0;32m'   # Green color for success
NC='\033[0m'         # No Color (reset to default)

# Function to check if Docker is installed
check_docker_installed() {
    if command -v docker &> /dev/null; then
        echo -e "${GREEN}Docker is already installed.${NC}"
    else
        echo -e "${RED}Docker is not installed. Installing Docker...${NC}"
        install_docker
    fi
}

# Function to install Docker (example for Ubuntu)
install_docker() {
    # Update package index and install prerequisites
    sudo apt-get update
    sudo apt-get install -y apt-transport-https ca-certificates curl software-properties-common

    # Add Docker's official GPG key and repository
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
    sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"

    # Install Docker
    sudo apt-get update
    sudo apt-get install -y docker-ce docker-ce-cli containerd.io

    # Enable and start Docker service
    sudo systemctl enable docker
    sudo systemctl start docker

    echo -e "${GREEN}Docker has been installed successfully.${NC}"
}

# Function to check if Docker Compose is installed
check_docker_compose_installed() {
    if command -v docker-compose &> /dev/null; then
        echo -e "${GREEN}Docker Compose is already installed.${NC}"
    else
        echo -e "${RED}Docker Compose is not installed. Installing Docker Compose...${NC}"
        install_docker_compose
    fi
}

# Function to install Docker Compose
install_docker_compose() {
    # Download and install Docker Compose
    sudo curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
    sudo chmod +x /usr/local/bin/docker-compose

    # Verify Docker Compose installation
    if command -v docker-compose &> /dev/null; then
        echo -e "${GREEN}Docker Compose has been installed successfully.${NC}"
    else
        echo -e "${RED}Failed to install Docker Compose. Please check your configuration.${NC}"
        exit 1
    fi
}

# Check if Docker is installed, and install if it is not
check_docker_installed

# Check if Docker Compose is installed, and install if it is not
check_docker_compose_installed

# Run the setup-env script to generate or update .env file
./setup-env.sh

# Bring up Docker Compose
docker-compose up -d
