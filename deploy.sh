#!/bin/bash

# Load functions and environment setup script from the 'setup' directory
source ./setup/functions.sh
source ./setup/setup-env.sh

# Check if Docker is installed, and install if it is not
check_docker_installed

# Check if Docker Compose is installed, and install if it is not
check_docker_compose_installed

# Load Docker images from the 'src' folder
#load_docker_images

# Bring up the PostgreSQL container first
docker-compose up -d watchtower-db

# Wait for PostgreSQL to be ready
echo "Waiting for PostgreSQL to initialize..."
until docker exec watchtower-db pg_isready -U postgres; do
  echo "PostgreSQL is not ready yet. Waiting..."
  sleep 2
done

# Check if the 'emm' database exists
DB_EXISTS=$(docker exec watchtower-db psql -U postgres -tAc "SELECT 1 FROM pg_database WHERE datname='emm'")

# If the database doesn't exist, create it
if [ "$DB_EXISTS" != "1" ]; then
    echo "Creating database 'emm'..."
    docker exec watchtower-db psql -U postgres -c "CREATE DATABASE emm;"
    echo -e "${GREEN}Database 'emm' created successfully.${NC}"
else
    echo -e "${GREEN}Database 'emm' already exists. Skipping creation.${NC}"
fi

# Bring up the rest of the Docker Compose stack
docker-compose up -d