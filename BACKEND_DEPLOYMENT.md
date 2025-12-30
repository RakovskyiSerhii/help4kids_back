# Backend Deployment Guide for AlmaLinux 10

Step-by-step guide to deploy the Help4Kids API backend on AlmaLinux 10 VPS.

## Prerequisites Checklist

- [ ] AlmaLinux 10 VPS with root/sudo access
- [ ] SSH access to the server
- [ ] Domain name (optional, for production)
- [ ] MySQL database (can be on same server or remote)

## Step 1: Install Dart SDK

### Option A: Direct Download and Install (Recommended for AlmaLinux)

```bash
# Install prerequisites
sudo dnf install -y wget unzip curl

# Get latest Dart version (parse JSON response)
DART_VERSION=$(curl -s https://storage.googleapis.com/dart-archive/channels/stable/release/latest/VERSION | grep -o '"version":"[^"]*' | cut -d'"' -f4)
echo "Installing Dart version: $DART_VERSION"

# Download Dart SDK
cd /tmp
wget "https://storage.googleapis.com/dart-archive/channels/stable/release/$DART_VERSION/sdk/dartsdk-linux-x64-release.zip"

# Extract to /usr/lib
sudo unzip -q dartsdk-linux-x64-release.zip -d /usr/lib/

# Create symlinks
sudo ln -sf /usr/lib/dart-sdk/bin/dart /usr/local/bin/dart
sudo ln -sf /usr/lib/dart-sdk/bin/pub /usr/local/bin/pub

# Add to PATH (for current session)
export PATH=$PATH:/usr/lib/dart-sdk/bin

# Add to PATH permanently
echo 'export PATH=$PATH:/usr/lib/dart-sdk/bin' | sudo tee -a /etc/profile

# Verify installation
dart --version

# Cleanup
rm -f dartsdk-linux-x64-release.zip
```

### Option B: Using Snap (if snapd is installed)

```bash
# Install snapd first
sudo dnf install -y snapd
sudo systemctl enable --now snapd
sudo systemctl enable --now snapd.socket
sudo ln -s /var/lib/snapd/snap /snap

# Wait a moment, then install Dart
sleep 5
sudo snap install dart --classic

# Verify installation
dart --version
```

### Option C: Use Installation Script

```bash
# Upload and run the installation script
chmod +x scripts/install-dart-almalinux.sh
sudo ./scripts/install-dart-almalinux.sh
```

## Step 2: Install MariaDB (MySQL-compatible)

**Note:** On AlmaLinux 10, use MariaDB instead of MySQL (they're compatible).

```bash
# Install MariaDB (MySQL-compatible)
sudo dnf install -y mariadb-server mariadb

# Start and enable MariaDB
sudo systemctl enable mariadb
sudo systemctl start mariadb

# Secure MariaDB installation
sudo mysql_secure_installation
```

## Step 3: Setup Database

```bash
# Login to MySQL
sudo mysql -u root -p

# Create database and user
CREATE DATABASE help4kids_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
CREATE USER 'help4kids_user'@'localhost' IDENTIFIED BY 'your_secure_password_here';
GRANT ALL PRIVILEGES ON help4kids_db.* TO 'help4kids_user'@'localhost';
FLUSH PRIVILEGES;
EXIT;
```

## Step 4: Deploy Application

```bash
# Create application directory
sudo mkdir -p /opt/help4kids
sudo chown $USER:$USER /opt/help4kids
cd /opt/help4kids

# Clone your repository (replace with your repo URL)
git clone <your-repository-url> backend
cd backend

# Install dependencies
dart pub get

# Install dart_frog CLI (required for building routes)
dart pub global activate dart_frog_cli
export PATH="$PATH:$HOME/.pub-cache/bin"

# Build routes (generates _handler.dart)
dart_frog build

# Compile the application
dart compile exe build/bin/server.dart -o bin/server

# Verify the executable was created
ls -lh bin/server
```

## Step 5: Create Environment Configuration

```bash
# Create environment file
sudo mkdir -p /etc/help4kids
sudo nano /etc/help4kids/.env
```

Add the following content (adjust values as needed):

```bash
# Database Configuration
DB_HOST=localhost
DB_PORT=3306
DB_USER=help4kids_user
DB_PASSWORD=your_secure_password_here
DB_NAME=help4kids_db

# JWT Configuration (IMPORTANT: Use a strong, random secret)
JWT_SECRET=your_very_secure_random_jwt_secret_minimum_32_characters
JWT_ISSUER=help4kids.com
JWT_EXPIRATION_HOURS=24

# Server Configuration
PORT=8080
```

**Generate a secure JWT secret:**
```bash
openssl rand -base64 32
```

**Secure the environment file:**
```bash
sudo chmod 600 /etc/help4kids/.env
sudo chown root:root /etc/help4kids/.env
```

## Step 6: Initialize Database

```bash
cd /opt/help4kids/backend

# Run initialization script
mysql -u help4kids_user -p help4kids_db < database/init.sql

# Note: If you get foreign key error for consultation_appointments -> staff,
# the staff table is created later. The script will continue after that error.
# You can manually add the FK later:
# ALTER TABLE consultation_appointments ADD FOREIGN KEY (doctor_id) REFERENCES staff(id);

# Insert missing data
mysql -u help4kids_user -p help4kids_db < database/insert_missing_data.sql
```

**Important:** The database connection automatically sets `utf8mb4` charset for proper encoding of Cyrillic characters. This is handled in the code.

## Step 7: Create Systemd Service

```bash
sudo nano /etc/systemd/system/help4kids-api.service
```

Add the following content:

```ini
[Unit]
Description=Help4Kids API Server
Documentation=https://github.com/your-org/help4kids
After=network.target mariadb.service
Requires=mariadb.service

[Service]
Type=simple
User=help4kids
Group=help4kids
WorkingDirectory=/opt/help4kids/backend
EnvironmentFile=/etc/help4kids/.env
ExecStart=/opt/help4kids/backend/bin/server
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
ReadWritePaths=/opt/help4kids/backend

[Install]
WantedBy=multi-user.target
```

## Step 8: Create Service User

```bash
# Create dedicated user for the service
sudo useradd -r -s /bin/false -d /opt/help4kids/backend help4kids

# Set ownership
sudo chown -R help4kids:help4kids /opt/help4kids/backend

# Ensure executable has proper permissions
sudo chmod +x /opt/help4kids/backend/bin/server
```

## Step 9: Start and Enable Service

```bash
# Reload systemd
sudo systemctl daemon-reload

# Enable service to start on boot
sudo systemctl enable help4kids-api

# Start the service
sudo systemctl start help4kids-api

# Check status
sudo systemctl status help4kids-api
```

## Step 10: Verify Deployment

```bash
# Check if service is running
sudo systemctl is-active help4kids-api

# Check logs
sudo journalctl -u help4kids-api -f

# Test API endpoint (from server)
curl http://localhost:8080/api/general_info

# Check if port is listening
sudo netstat -tlnp | grep 8080
# or
sudo ss -tlnp | grep 8080
```

## Step 11: Configure Firewall

```bash
# Allow port 8080 (if accessing directly)
sudo firewall-cmd --permanent --add-port=8080/tcp
sudo firewall-cmd --reload

# Or if using Nginx as reverse proxy, only allow HTTP/HTTPS
sudo firewall-cmd --permanent --add-service=http
sudo firewall-cmd --permanent --add-service=https
sudo firewall-cmd --reload
```

## Step 12: Setup Nginx Reverse Proxy (Optional but Recommended)

```bash
# Install Nginx
sudo dnf install -y nginx

# Create Nginx configuration
sudo nano /etc/nginx/conf.d/help4kids-api.conf
```

Add this configuration:

```nginx
upstream help4kids_api {
    server localhost:8080;
}

server {
    listen 80;
    server_name api.your-domain.com;  # Change to your domain

    # API endpoints
    location /api {
        proxy_pass http://help4kids_api;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
        proxy_cache_bypass $http_upgrade;
        
        # Timeouts
        proxy_connect_timeout 60s;
        proxy_send_timeout 60s;
        proxy_read_timeout 60s;
    }

    # Health check endpoint
    location /health {
        proxy_pass http://help4kids_api/api/general_info;
        access_log off;
    }
}
```

Test and reload:
```bash
sudo nginx -t
sudo systemctl enable nginx
sudo systemctl start nginx
```

## Step 13: Setup SSL with Let's Encrypt (Optional)

```bash
# Install certbot
sudo dnf install -y certbot python3-certbot-nginx

# Get SSL certificate
sudo certbot --nginx -d api.your-domain.com

# Auto-renewal is set up automatically
```

## Maintenance Commands

### View Logs
```bash
# Real-time logs
sudo journalctl -u help4kids-api -f

# Last 100 lines
sudo journalctl -u help4kids-api -n 100

# Logs since today
sudo journalctl -u help4kids-api --since today
```

### Restart Service
```bash
sudo systemctl restart help4kids-api
```

### Stop Service
```bash
sudo systemctl stop help4kids-api
```

### Update Application
```bash
cd /opt/help4kids/backend
git pull
dart pub get
dart_frog build
dart compile exe build/bin/server.dart -o bin/server
sudo systemctl restart help4kids-api
```

### Check Service Status
```bash
sudo systemctl status help4kids-api
```

## Troubleshooting

### Service won't start
```bash
# Check logs for errors
sudo journalctl -u help4kids-api -n 50

# Verify environment file
sudo cat /etc/help4kids/.env

# Test database connection manually
mysql -u help4kids_user -p help4kids_db -e "SELECT 1;"

# Check if port is already in use
sudo lsof -i :8080
```

### Database connection errors
```bash
# Test MariaDB connection
mysql -u help4kids_user -p help4kids_db

# Check MariaDB status
sudo systemctl status mariadb

# Check MariaDB logs
sudo tail -f /var/log/mariadb/mariadb.log
```

### Encoding issues (Cyrillic characters showing as ? or garbled)
The connection automatically sets `utf8mb4` charset. If you still see encoding issues:
- Verify database charset: `mysql -u help4kids_user -p -e "SHOW VARIABLES LIKE 'character_set%';"`
- Database should be `utf8mb4`, connection will be set automatically by the code

### Permission issues
```bash
# Fix ownership
sudo chown -R help4kids:help4kids /opt/help4kids/backend

# Fix permissions
sudo chmod +x /opt/help4kids/backend/bin/server
```

### Port already in use
```bash
# Find what's using port 8080
sudo lsof -i :8080
sudo netstat -tlnp | grep 8080
# or
sudo ss -tlnp | grep 8080

# Kill the process or change PORT in .env
```

### Service fails with exit code 203/EXEC
This usually means the executable doesn't exist or can't run:
```bash
# Rebuild the application
cd /opt/help4kids/backend
dart_frog build
dart compile exe build/bin/server.dart -o bin/server
chmod +x bin/server
sudo chown -R help4kids:help4kids /opt/help4kids/backend
sudo systemctl restart help4kids-api
```

## Security Checklist

- [ ] Changed default MySQL root password
- [ ] Created dedicated database user with limited privileges
- [ ] Used strong JWT_SECRET (minimum 32 characters)
- [ ] Environment file has restricted permissions (600)
- [ ] Service runs as non-root user
- [ ] Firewall configured properly
- [ ] SSL/TLS enabled (if using domain)
- [ ] Regular backups configured
- [ ] Logs are being monitored

## Backup Strategy

### Database Backup Script

Create `/opt/backups/backup-db.sh`:

```bash
#!/bin/bash
BACKUP_DIR="/opt/backups/help4kids"
DATE=$(date +%Y%m%d_%H%M%S)
mkdir -p $BACKUP_DIR

mysqldump -u help4kids_user -p'your_password' help4kids_db > $BACKUP_DIR/db_$DATE.sql
gzip $BACKUP_DIR/db_$DATE.sql

# Keep only last 7 days
find $BACKUP_DIR -name "db_*.sql.gz" -mtime +7 -delete

echo "Backup completed: db_$DATE.sql.gz"
```

Make it executable:
```bash
chmod +x /opt/backups/backup-db.sh
```

Add to crontab (daily at 2 AM):
```bash
sudo crontab -e
# Add this line:
0 2 * * * /opt/backups/backup-db.sh >> /var/log/help4kids-backup.log 2>&1
```

## Performance Monitoring

### Monitor Resource Usage
```bash
# CPU and Memory
top -p $(pgrep -f help4kids-api)

# Disk I/O
iotop -p $(pgrep -f help4kids-api)

# Network connections
netstat -an | grep 8080 | wc -l
```

### Database Monitoring
```bash
# Check active connections
mysql -u help4kids_user -p -e "SHOW PROCESSLIST;"

# Check database size
mysql -u help4kids_user -p -e "SELECT table_schema AS 'Database', ROUND(SUM(data_length + index_length) / 1024 / 1024, 2) AS 'Size (MB)' FROM information_schema.TABLES WHERE table_schema = 'help4kids_db';"
```

## Next Steps

1. ✅ Backend is deployed and running
2. ⏭️ Configure frontend (if applicable)
3. ⏭️ Setup monitoring (optional: Prometheus, Grafana)
4. ⏭️ Setup log aggregation (optional: ELK stack)
5. ⏭️ Configure automated deployments (optional: CI/CD)

