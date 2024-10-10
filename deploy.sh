#!/bin/bash

# Define color codes for printed messages
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Load functions and environment setup script from the 'setup' directory
source ./setup/setup-docker.sh
source ./setup/setup-env.sh
source ./setup/setup-db.sh

# Check if Docker is installed, and install if it is not
check_docker_installed

# Check if Docker Compose is installed, and install if it is not
check_docker_compose_installed

# Determine if the script should run in offline or online mode
DOCKER_COMPOSE_CONTEXT=""
if [ "$MODE" == "offline" ]; then
  # Load Docker images from the 'containers' folder
  echo -e "${YELLOW}Running in offline mode. Loading Docker images from local tar files in container directory...${NC}"
  load_docker_images
  DOCKER_COMPOSE_CONTEXT="-f docker-compose.offline.yml"
else
  echo -e "${YELLOW}Running in online mode. Pulling Docker images from ghcr.io...${NC}"
  docker-compose pull
  DOCKER_COMPOSE_CONTEXT="-f docker-compose.yml"
fi

# Bring up the PostgreSQL container first
docker-compose $DOCKER_COMPOSE_CONTEXT up -d watchtower-db

# Wait for PostgreSQL to be ready
wait_for_postgres

# Check if the 'emm' database exists
check_and_create_database "emm"

# Bring up the rest of the Docker Compose stack
docker-compose $DOCKER_COMPOSE_CONTEXT up -d