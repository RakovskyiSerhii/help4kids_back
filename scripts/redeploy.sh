#!/bin/bash

# ============================================
# Help4Kids Database Redeployment Script
# ============================================
# This script drops the database, recreates it from init.sql,
# and restarts the API server
# ============================================

set -e  # Exit on any error

# Configuration
DB_USER="help4kids_user"
DB_PASSWORD="hl4HetrPGg7yTJ8+X52Qc1n+2/VRwvl9"
DB_NAME="help4kids_db"
BACKEND_DIR="/opt/help4kids/backend"
SERVICE_NAME="help4kids-api"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${GREEN}========================================${NC}"
echo -e "${GREEN}Help4Kids Database Redeployment${NC}"
echo -e "${GREEN}========================================${NC}"
echo ""

# Check if running as root
if [ "$EUID" -ne 0 ]; then 
    echo -e "${RED}Error: This script must be run as root${NC}"
    exit 1
fi

# Check if backend directory exists
if [ ! -d "$BACKEND_DIR" ]; then
    echo -e "${RED}Error: Backend directory not found: $BACKEND_DIR${NC}"
    exit 1
fi

# Check if init.sql exists
INIT_SQL="$BACKEND_DIR/database/init.sql"
if [ ! -f "$INIT_SQL" ]; then
    echo -e "${RED}Error: init.sql not found: $INIT_SQL${NC}"
    exit 1
fi

echo -e "${YELLOW}Step 1: Stopping API server...${NC}"
systemctl stop "$SERVICE_NAME" || echo -e "${YELLOW}Warning: Service was not running${NC}"
sleep 2

echo -e "${YELLOW}Step 2: Dropping and recreating database...${NC}"
mysql -u "$DB_USER" -p"$DB_PASSWORD" < "$INIT_SQL"

if [ $? -eq 0 ]; then
    echo -e "${GREEN}✓ Database recreated successfully${NC}"
else
    echo -e "${RED}✗ Database recreation failed${NC}"
    exit 1
fi

echo -e "${YELLOW}Step 3: Rebuilding the server...${NC}"
cd "$BACKEND_DIR"

# Check if dart_frog is available
if ! command -v dart_frog &> /dev/null; then
    echo -e "${YELLOW}Warning: dart_frog not found in PATH, trying to use pub cache...${NC}"
    export PATH="$PATH:$HOME/.pub-cache/bin"
fi

# Build the server
dart_frog build
if [ $? -ne 0 ]; then
    echo -e "${RED}✗ Build failed${NC}"
    exit 1
fi

# Compile the executable
dart compile exe build/bin/server.dart -o bin/server
if [ $? -ne 0 ]; then
    echo -e "${RED}✗ Compilation failed${NC}"
    exit 1
fi

echo -e "${GREEN}✓ Server built successfully${NC}"

echo -e "${YELLOW}Step 4: Starting API server...${NC}"
systemctl start "$SERVICE_NAME"
sleep 3

# Check if service is running
if systemctl is-active --quiet "$SERVICE_NAME"; then
    echo -e "${GREEN}✓ Service is running${NC}"
else
    echo -e "${RED}✗ Service failed to start${NC}"
    echo -e "${YELLOW}Checking logs...${NC}"
    journalctl -u "$SERVICE_NAME" --no-pager -n 20
    exit 1
fi

echo ""
echo -e "${GREEN}========================================${NC}"
echo -e "${GREEN}Deployment completed successfully!${NC}"
echo -e "${GREEN}========================================${NC}"
echo ""
echo "Service status:"
systemctl status "$SERVICE_NAME" --no-pager -l | head -10
echo ""
echo "Test the API:"
echo "  curl http://localhost:8080/api/general_info"

