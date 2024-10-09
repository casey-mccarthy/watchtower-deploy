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

# Function to load Docker images from the 'src' folder
load_docker_images() {
    local src_dir="./src"  # Set the directory containing the Docker images

    if [ -d "$src_dir" ]; then
        echo -e "${GREEN}Loading Docker images from $src_dir...${NC}"
        for image_file in "$src_dir"/*.tar; do
            if [ -f "$image_file" ]; then
                echo -e "${GREEN}Loading image: $image_file${NC}"
                docker load -i "$image_file" || { echo -e "${RED}Failed to load image: $image_file${NC}"; exit 1; }
            else
                echo -e "${RED}No .tar files found in $src_dir${NC}"
                exit 1
            fi
        done
        echo -e "${GREEN}All Docker images have been successfully loaded.${NC}"
    else
        echo -e "${RED}Source directory $src_dir does not exist. Please check the path.${NC}"
        exit 1
    fi
}
