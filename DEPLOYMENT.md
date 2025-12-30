# Deployment Guide for AlmaLinux 10 VPS

This guide covers deploying both the backend API and frontend on an AlmaLinux 10 VPS.

## Prerequisites

- AlmaLinux 10 VPS with root/sudo access
- Domain name (optional, for production)
- SSH access to the server

## Architecture Overview

```
┌─────────────────┐
│   Nginx (80/443)│  ← Reverse proxy & static files
└────────┬────────┘
         │
    ┌────┴────┐
    │        │
┌───▼───┐ ┌──▼──────┐
│Frontend│ │ Backend │  ← Dart Frog API (port 8080)
│(Static)│ │ (Dart)  │
└────────┘ └─────────┘
              │
         ┌────▼────┐
         │ MySQL   │
         └─────────┘
```

## Step 1: Install Required Software

### Install Dart SDK

```bash
# Add Dart repository
sudo dnf install -y curl
curl -fsSL https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo gpg --dearmor -o /usr/share/keyrings/dart.gpg
echo 'deb [signed-by=/usr/share/keyrings/dart.gpg arch=amd64] https://storage.googleapis.com/download.dartlang.org/linux/debian stable main' | sudo tee /etc/apt/sources.list.d/dart_stable.list

# For AlmaLinux, use the RPM method instead:
sudo dnf install -y wget
wget https://storage.googleapis.com/dart-archive/channels/stable/release/latest/linux_packages/dart-3.x.x-1.x86_64.rpm
sudo dnf install -y ./dart-*.rpm

# Or use snap (if available)
sudo dnf install -y snapd
sudo systemctl enable --now snapd
sudo snap install dart --classic
```

### Install MySQL

```bash
sudo dnf install -y mysql-server
sudo systemctl enable mysqld
sudo systemctl start mysqld

# Secure MySQL installation
sudo mysql_secure_installation
```

### Install Nginx

```bash
sudo dnf install -y nginx
sudo systemctl enable nginx
sudo systemctl start nginx
```

### Install Node.js (if frontend needs it for build)

```bash
sudo dnf install -y nodejs npm
```

## Step 2: Deploy Backend API

### Clone and Setup

```bash
# Create app directory
sudo mkdir -p /opt/help4kids
sudo chown $USER:$USER /opt/help4kids
cd /opt/help4kids

# Clone your repository
git clone <your-repo-url> backend
cd backend

# Install dependencies
dart pub get

# Build the application
dart compile exe bin/server.dart -o bin/server
```

### Create Environment File

```bash
sudo mkdir -p /etc/help4kids
sudo nano /etc/help4kids/.env
```

Add your environment variables:
```bash
DB_HOST=localhost
DB_PORT=3306
DB_USER=help4kids_user
DB_PASSWORD=your_secure_password
DB_NAME=help4kids_db
JWT_SECRET=your_very_secure_jwt_secret_here
JWT_ISSUER=help4kids.com
JWT_EXPIRATION_HOURS=24
PORT=8080
```

### Setup Database

```bash
# Create database and user
mysql -u root -p << EOF
CREATE DATABASE help4kids_db;
CREATE USER 'help4kids_user'@'localhost' IDENTIFIED BY 'your_secure_password';
GRANT ALL PRIVILEGES ON help4kids_db.* TO 'help4kids_user'@'localhost';
FLUSH PRIVILEGES;
EOF

# Run initialization script
mysql -u help4kids_user -p help4kids_db < database/init.sql
```

### Create Systemd Service

```bash
sudo nano /etc/systemd/system/help4kids-api.service
```

Add this content:
```ini
[Unit]
Description=Help4Kids API Server
After=network.target mysql.service

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

[Install]
WantedBy=multi-user.target
```

Create the service user:
```bash
sudo useradd -r -s /bin/false help4kids
sudo chown -R help4kids:help4kids /opt/help4kids/backend
```

Start the service:
```bash
sudo systemctl daemon-reload
sudo systemctl enable help4kids-api
sudo systemctl start help4kids-api
sudo systemctl status help4kids-api
```

## Step 3: Deploy Frontend

### Option A: Static Frontend (Flutter Web, React, Vue, etc.)

If your frontend is a static build:

```bash
# Create frontend directory
sudo mkdir -p /opt/help4kids/frontend
sudo chown $USER:$USER /opt/help4kids/frontend

# Upload your built frontend files
# (e.g., Flutter web build output, or React/Vue build)
cd /opt/help4kids/frontend
# Upload files via scp, git, or build directly on server
```

### Option B: Build Frontend on Server

If you need to build on the server:

```bash
cd /opt/help4kids
git clone <frontend-repo-url> frontend
cd frontend

# For Flutter web:
flutter build web --release
# Output will be in build/web/

# For React/Vue:
npm install
npm run build
# Output will be in dist/ or build/
```

## Step 4: Configure Nginx

```bash
sudo nano /etc/nginx/conf.d/help4kids.conf
```

Add this configuration:

```nginx
# Upstream for backend API
upstream help4kids_api {
    server localhost:8080;
}

# Frontend and API server
server {
    listen 80;
    server_name your-domain.com www.your-domain.com;

    # Frontend static files
    location / {
        root /opt/help4kids/frontend/build/web;  # or dist/ for React/Vue
        try_files $uri $uri/ /index.html;
        index index.html;
    }

    # Backend API
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
    }

    # Static assets (icons, etc.)
    location /assets {
        root /opt/help4kids/frontend/build/web;
        expires 30d;
        add_header Cache-Control "public, immutable";
    }
}
```

Test and reload Nginx:
```bash
sudo nginx -t
sudo systemctl reload nginx
```

## Step 5: Setup SSL (Let's Encrypt)

```bash
sudo dnf install -y certbot python3-certbot-nginx
sudo certbot --nginx -d your-domain.com -d www.your-domain.com
```

## Step 6: Firewall Configuration

```bash
sudo firewall-cmd --permanent --add-service=http
sudo firewall-cmd --permanent --add-service=https
sudo firewall-cmd --reload
```

## Step 7: Monitoring and Logs

### View Backend Logs
```bash
sudo journalctl -u help4kids-api -f
```

### View Nginx Logs
```bash
sudo tail -f /var/log/nginx/access.log
sudo tail -f /var/log/nginx/error.log
```

## Step 8: Update Deployment

### Backend Updates
```bash
cd /opt/help4kids/backend
git pull
dart pub get
dart compile exe bin/server.dart -o bin/server
sudo systemctl restart help4kids-api
```

### Frontend Updates
```bash
cd /opt/help4kids/frontend
git pull
# Rebuild frontend
# Copy new build to /opt/help4kids/frontend/build/web
sudo systemctl reload nginx
```

## Troubleshooting

### Backend not starting
```bash
# Check logs
sudo journalctl -u help4kids-api -n 50

# Check if port is in use
sudo netstat -tlnp | grep 8080

# Verify environment variables
sudo cat /etc/help4kids/.env
```

### Database connection issues
```bash
# Test MySQL connection
mysql -u help4kids_user -p help4kids_db

# Check MySQL status
sudo systemctl status mysqld
```

### Nginx issues
```bash
# Test configuration
sudo nginx -t

# Check error logs
sudo tail -f /var/log/nginx/error.log
```

## Performance Optimization

1. **Enable Nginx caching** for static assets
2. **Use connection pooling** (already implemented in your backend)
3. **Enable MySQL query cache**
4. **Consider using Redis** for session storage (if needed)
5. **Setup log rotation** to prevent disk space issues

## Security Checklist

- [ ] Change default MySQL root password
- [ ] Use strong JWT_SECRET
- [ ] Setup firewall rules
- [ ] Enable SSL/TLS
- [ ] Keep system packages updated
- [ ] Use non-root user for services
- [ ] Restrict database user permissions
- [ ] Setup regular backups
- [ ] Monitor logs for suspicious activity

## Backup Strategy

```bash
# Database backup script
#!/bin/bash
BACKUP_DIR="/opt/backups/help4kids"
mkdir -p $BACKUP_DIR
mysqldump -u help4kids_user -p help4kids_db > $BACKUP_DIR/db_$(date +%Y%m%d_%H%M%S).sql
# Keep only last 7 days
find $BACKUP_DIR -name "db_*.sql" -mtime +7 -delete
```

Add to crontab:
```bash
0 2 * * * /opt/backups/backup.sh
```


