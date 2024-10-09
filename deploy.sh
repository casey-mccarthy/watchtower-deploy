#!/bin/bash

# Load functions from the functions.sh file
source ./functions.sh

# Check if Docker is installed, and install if it is not
check_docker_installed

# Check if Docker Compose is installed, and install if it is not
check_docker_compose_installed

# Load Docker images from the 'src' folder
load_docker_images

# Run the setup-env script to generate or update .env file
./setup-env.sh

# Bring up Docker Compose
docker-compose up -d
