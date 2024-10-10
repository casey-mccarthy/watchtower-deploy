#!/bin/bash

# Define color codes for printed messages
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to wait for PostgreSQL to be ready
wait_for_postgres() {
  echo -e "${YELLOW}Waiting for PostgreSQL to initialize...${NC}"
  until docker exec watchtower-db pg_isready -U postgres; do
    echo -e "${YELLOW}PostgreSQL is not ready yet. Waiting...${NC}"
    sleep 2
  done
}

# Function to check if a database exists and create it if it doesn't
check_and_create_database() {
  local DB_NAME=$1
  DB_EXISTS=$(docker exec watchtower-db psql -U postgres -tAc "SELECT 1 FROM pg_database WHERE datname='${DB_NAME}'")

  if [ "$DB_EXISTS" != "1" ]; then
    echo -e "${BLUE}Creating database '${DB_NAME}'...${NC}"
    docker exec watchtower-db psql -U postgres -c "CREATE DATABASE ${DB_NAME};"
    echo -e "${GREEN}Database '${DB_NAME}' created successfully.${NC}"
  else
    echo -e "${GREEN}Database '${DB_NAME}' already exists. Skipping creation.${NC}"
  fi
}
