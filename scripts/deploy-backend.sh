#!/bin/bash

# Backend Deployment Script for AlmaLinux 10
# This script automates the deployment process

set -e  # Exit on error

echo "=========================================="
echo "Help4Kids Backend Deployment Script"
echo "=========================================="

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Configuration
APP_DIR="/opt/help4kids/backend"
SERVICE_USER="help4kids"
SERVICE_NAME="help4kids-api"
ENV_FILE="/etc/help4kids/.env"

# Check if running as root
if [ "$EUID" -ne 0 ]; then 
    echo -e "${RED}Please run as root or with sudo${NC}"
    exit 1
fi

echo -e "${GREEN}Step 1: Checking prerequisites...${NC}"

# Check if Dart is installed
if ! command -v dart &> /dev/null; then
    echo -e "${YELLOW}Dart not found. Installing Dart...${NC}"
    if command -v snap &> /dev/null; then
        snap install dart --classic
    else
        echo -e "${RED}Snap not available. Please install Dart manually.${NC}"
        exit 1
    fi
fi

echo "✓ Dart installed: $(dart --version)"

# Check if MySQL is installed
if ! command -v mysql &> /dev/null; then
    echo -e "${YELLOW}MySQL not found. Installing MySQL...${NC}"
    dnf install -y mysql-server
    systemctl enable mysqld
    systemctl start mysqld
fi

echo "✓ MySQL installed"

echo -e "${GREEN}Step 2: Creating service user...${NC}"
if ! id "$SERVICE_USER" &>/dev/null; then
    useradd -r -s /bin/false -d "$APP_DIR" "$SERVICE_USER"
    echo "✓ User $SERVICE_USER created"
else
    echo "✓ User $SERVICE_USER already exists"
fi

echo -e "${GREEN}Step 3: Setting up application directory...${NC}"
mkdir -p "$(dirname $APP_DIR)"
if [ ! -d "$APP_DIR" ]; then
    echo -e "${YELLOW}Application directory not found. Please clone your repository to $APP_DIR${NC}"
    echo "Example: git clone <your-repo> $APP_DIR"
    exit 1
fi

echo "✓ Application directory exists"

echo -e "${GREEN}Step 4: Installing dependencies...${NC}"
cd "$APP_DIR"
dart pub get
echo "✓ Dependencies installed"

echo -e "${GREEN}Step 5: Building application...${NC}"
dart compile exe bin/server.dart -o bin/server
chmod +x bin/server
echo "✓ Application built"

echo -e "${GREEN}Step 6: Setting up environment file...${NC}"
if [ ! -f "$ENV_FILE" ]; then
    mkdir -p "$(dirname $ENV_FILE)"
    
    # Generate JWT secret
    JWT_SECRET=$(openssl rand -base64 32)
    
    cat > "$ENV_FILE" << EOF
# Database Configuration
DB_HOST=localhost
DB_PORT=3306
DB_USER=help4kids_user
DB_PASSWORD=CHANGE_ME
DB_NAME=help4kids_db

# JWT Configuration
JWT_SECRET=$JWT_SECRET
JWT_ISSUER=help4kids.com
JWT_EXPIRATION_HOURS=24

# Server Configuration
PORT=8080
EOF
    
    chmod 600 "$ENV_FILE"
    echo "✓ Environment file created at $ENV_FILE"
    echo -e "${YELLOW}⚠️  IMPORTANT: Edit $ENV_FILE and update DB_PASSWORD${NC}"
else
    echo "✓ Environment file already exists"
fi

echo -e "${GREEN}Step 7: Setting up systemd service...${NC}"
cat > "/etc/systemd/system/$SERVICE_NAME.service" << EOF
[Unit]
Description=Help4Kids API Server
After=network.target mysql.service
Requires=mysql.service

[Service]
Type=simple
User=$SERVICE_USER
Group=$SERVICE_USER
WorkingDirectory=$APP_DIR
EnvironmentFile=$ENV_FILE
ExecStart=$APP_DIR/bin/server
Restart=always
RestartSec=10
StandardOutput=journal
StandardError=journal
SyslogIdentifier=help4kids-api

# Security settings
NoNewPrivileges=true
PrivateTmp=true
ProtectSystem=strict
ProtectHome=true
ReadWritePaths=$APP_DIR

[Install]
WantedBy=multi-user.target
EOF

echo "✓ Systemd service file created"

echo -e "${GREEN}Step 8: Setting permissions...${NC}"
chown -R "$SERVICE_USER:$SERVICE_USER" "$APP_DIR"
echo "✓ Permissions set"

echo -e "${GREEN}Step 9: Enabling and starting service...${NC}"
systemctl daemon-reload
systemctl enable "$SERVICE_NAME"
systemctl start "$SERVICE_NAME"

sleep 2

if systemctl is-active --quiet "$SERVICE_NAME"; then
    echo -e "${GREEN}✓ Service is running${NC}"
else
    echo -e "${RED}✗ Service failed to start. Check logs with: journalctl -u $SERVICE_NAME${NC}"
    exit 1
fi

echo ""
echo -e "${GREEN}=========================================="
echo "Deployment Complete!"
echo "==========================================${NC}"
echo ""
echo "Service status:"
systemctl status "$SERVICE_NAME" --no-pager -l
echo ""
echo "Useful commands:"
echo "  View logs:    sudo journalctl -u $SERVICE_NAME -f"
echo "  Restart:      sudo systemctl restart $SERVICE_NAME"
echo "  Stop:         sudo systemctl stop $SERVICE_NAME"
echo "  Status:       sudo systemctl status $SERVICE_NAME"
echo ""
echo -e "${YELLOW}Next steps:${NC}"
echo "  1. Update database credentials in $ENV_FILE"
echo "  2. Initialize database: mysql -u help4kids_user -p help4kids_db < $APP_DIR/database/init.sql"
echo "  3. Test API: curl http://localhost:8080/api/general_info"
echo ""


