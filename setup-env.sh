#!/bin/bash

# Define color variables
RED='\033[0;31m'     # Red color for errors
GREEN='\033[0;32m'   # Green color for success
NC='\033[0m'         # No Color (reset to default)

# Check if the .env file exists, if not create it
if [ ! -f .env ]; then
    echo -e "${RED}.env file not found. Creating a new one...${NC}"
    touch .env
    echo -e "${GREEN}Created .env file.${NC}"
else
    echo -e "${GREEN}.env file found.${NC}"
fi

# Function to generate a random password
generate_password() {
    openssl rand -base64 12 | tr -d -c 'a-zA-Z0-9'
}

# Check and set POSTGRES_PASSWORD if not already set
if ! grep -q "^POSTGRES_PASSWORD" .env; then
    POSTGRES_PASSWORD=$(generate_password)
    echo "POSTGRES_PASSWORD=$POSTGRES_PASSWORD" >> .env
    echo -e "${GREEN}Generated POSTGRES_PASSWORD: $POSTGRES_PASSWORD${NC}"
else
    POSTGRES_PASSWORD=$(grep "^POSTGRES_PASSWORD" .env | cut -d '=' -f2)
    echo -e "${GREEN}Using existing POSTGRES_PASSWORD: $POSTGRES_PASSWORD${NC}"
fi

# Check and set WT_API_PASSWORD if not already set
if ! grep -q "^WT_API_PASSWORD" .env; then
    WT_API_PASSWORD=$(generate_password)
    echo "WT_API_PASSWORD=$WT_API_PASSWORD" >> .env
    echo -e "${GREEN}Generated WT_API_PASSWORD: $WT_API_PASSWORD${NC}"
else
    WT_API_PASSWORD=$(grep "^WT_API_PASSWORD" .env | cut -d '=' -f2)
    echo -e "${GREEN}Using existing WT_API_PASSWORD: $WT_API_PASSWORD${NC}"
fi

# Display the final .env file content for confirmation
echo -e "${GREEN}Final .env file content:${NC}"
cat .env
