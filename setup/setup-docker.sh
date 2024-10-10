#!/bin/bash

# Define color variables for output messages
RED='\033[0;31m'     # Red color for errors
GREEN='\033[0;32m'   # Green color for success
BLUE='\033[0;34m'    # Blue color for information
NC='\033[0m'         # No Color (reset to default)

# Detect the platform (Linux, macOS, or Windows)
PLATFORM="unknown"
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    PLATFORM="linux"
elif [[ "$OSTYPE" == "darwin"* ]]; then
    PLATFORM="macos"
elif [[ "$OSTYPE" == "cygwin" || "$OSTYPE" == "msys" || "$OSTYPE" == "win32" ]]; then
    PLATFORM="windows"
else
    echo -e "${RED}Unsupported platform: $OSTYPE${NC}"
    exit 1
fi

echo -e "${BLUE}Detected platform: $PLATFORM${NC}"

# Function to check if Docker is installed and enable Docker service
check_docker_installed() {
    if command -v docker &> /dev/null; then
        echo -e "${GREEN}Docker is already installed.${NC}"
    else
        echo -e "${RED}Docker is not installed. Installing Docker...${NC}"
        install_docker
    fi
}

# Function to install Docker based on the detected platform
install_docker() {
    if [ "$PLATFORM" == "linux" ]; then
        install_docker_linux
    elif [ "$PLATFORM" == "macos" ]; then
        install_docker_macos
    elif [ "$PLATFORM" == "windows" ]; then
        install_docker_windows
    else
        echo -e "${RED}Unsupported platform: $PLATFORM${NC}"
        exit 1
    fi
}

# Function to install Docker on Linux
install_docker_linux() {
    # Check which package manager is used (apt, yum, or dnf)
    if command -v apt-get &> /dev/null; then
        sudo apt-get update
        sudo apt-get install -y apt-transport-https ca-certificates curl software-properties-common
        curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
        sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
        sudo apt-get update
        sudo apt-get install -y docker-ce docker-ce-cli containerd.io
    elif command -v yum &> /dev/null; then
        sudo yum install -y yum-utils
        sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
        sudo yum install -y docker-ce docker-ce-cli containerd.io
    elif command -v dnf &> /dev/null; then
        sudo dnf -y install dnf-plugins-core
        sudo dnf config-manager --add-repo https://download.docker.com/linux/fedora/docker-ce.repo
        sudo dnf install -y docker-ce docker-ce-cli containerd.io
    else
        echo -e "${RED}Unsupported package manager. Please install Docker manually.${NC}"
        exit 1
    fi

    # Enable and start Docker service
    sudo systemctl enable docker
    sudo systemctl start docker

    echo -e "${GREEN}Docker has been installed successfully on Linux.${NC}"
}

# Function to install Docker on macOS
install_docker_macos() {
    # Use Homebrew to install Docker
    if command -v brew &> /dev/null; then
        brew install --cask docker
        echo -e "${GREEN}Docker has been installed successfully on macOS.${NC}"
    else
        echo -e "${RED}Homebrew is not installed. Please install Homebrew first.${NC}"
        exit 1
    fi
}

# Function to install Docker on Windows
install_docker_windows() {
    # Download and install Docker Desktop using wget
    echo -e "${GREEN}Downloading Docker Desktop installer...${NC}"
    wget -O DockerDesktopInstaller.exe "https://desktop.docker.com/win/stable/Docker%20Desktop%20Installer.exe"
    echo -e "${GREEN}Installing Docker Desktop...${NC}"
    start DockerDesktopInstaller.exe
    echo -e "${GREEN}Please follow the Docker Desktop installation instructions.${NC}"
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
    local src_dir="./containers"  # Set the directory containing the Docker images
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

# Check if Docker and Docker Compose are installed
check_docker_installed
check_docker_compose_installed