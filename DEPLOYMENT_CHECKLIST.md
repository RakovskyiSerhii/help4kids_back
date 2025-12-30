# Backend Deployment Checklist

Quick reference checklist for deploying the backend on AlmaLinux 10.

## Pre-Deployment

- [ ] VPS server ready (AlmaLinux 10)
- [ ] SSH access configured
- [ ] Repository URL available
- [ ] Database credentials ready
- [ ] Domain name (optional)

## Installation Steps

### 1. Install Dependencies
```bash
# Install Dart (parse version from JSON)
DART_VERSION=$(curl -s https://storage.googleapis.com/dart-archive/channels/stable/release/latest/VERSION | grep -o '"version":"[^"]*' | cut -d'"' -f4)
cd /tmp
wget "https://storage.googleapis.com/dart-archive/channels/stable/release/$DART_VERSION/sdk/dartsdk-linux-x64-release.zip"
sudo unzip -q dartsdk-linux-x64-release.zip -d /usr/lib/
sudo ln -sf /usr/lib/dart-sdk/bin/dart /usr/local/bin/dart
export PATH=$PATH:/usr/lib/dart-sdk/bin

# Install MariaDB (MySQL-compatible on AlmaLinux)
sudo dnf install -y mariadb-server mariadb
sudo systemctl enable --now mariadb
```

### 2. Setup Database
```bash
# Create database and user
mysql -u root -p
CREATE DATABASE help4kids_db;
CREATE USER 'help4kids_user'@'localhost' IDENTIFIED BY 'password';
GRANT ALL PRIVILEGES ON help4kids_db.* TO 'help4kids_user'@'localhost';
FLUSH PRIVILEGES;
EXIT;
```

### 3. Deploy Application
```bash
# Clone repository
sudo mkdir -p /opt/help4kids
sudo chown $USER:$USER /opt/help4kids
cd /opt/help4kids
git clone <your-repo-url> backend
cd backend

# Install and build
dart pub get
dart pub global activate dart_frog_cli
export PATH="$PATH:$HOME/.pub-cache/bin"
dart_frog build
dart compile exe build/bin/server.dart -o bin/server
```

### 4. Configure Environment
```bash
# Create environment file
sudo mkdir -p /etc/help4kids
sudo nano /etc/help4kids/.env

# Add configuration (see BACKEND_DEPLOYMENT.md for template)
# Generate JWT secret:
openssl rand -base64 32

# Secure file
sudo chmod 600 /etc/help4kids/.env
```

### 5. Initialize Database
```bash
cd /opt/help4kids/backend
mysql -u help4kids_user -p help4kids_db < database/init.sql
mysql -u help4kids_user -p help4kids_db < database/insert_missing_data.sql
```

### 6. Create Systemd Service
```bash
# Copy service file from BACKEND_DEPLOYMENT.md or use deploy script
sudo nano /etc/systemd/system/help4kids-api.service

# Create service user
sudo useradd -r -s /bin/false help4kids
sudo chown -R help4kids:help4kids /opt/help4kids/backend
```

### 7. Start Service
```bash
sudo systemctl daemon-reload
sudo systemctl enable help4kids-api
sudo systemctl start help4kids-api
sudo systemctl status help4kids-api
```

### 8. Verify
```bash
# Check service
sudo systemctl is-active help4kids-api

# Check logs
sudo journalctl -u help4kids-api -f

# Test API
curl http://localhost:8080/api/general_info
```

## Quick Commands Reference

```bash
# View logs
sudo journalctl -u help4kids-api -f

# Restart service
sudo systemctl restart help4kids-api

# Stop service
sudo systemctl stop help4kids-api

# Update application
cd /opt/help4kids/backend
git pull
dart pub get
dart_frog build
dart compile exe build/bin/server.dart -o bin/server
sudo systemctl restart help4kids-api
```

## Environment Variables Required

```bash
DB_HOST=localhost
DB_PORT=3306
DB_USER=help4kids_user
DB_PASSWORD=your_password
DB_NAME=help4kids_db
JWT_SECRET=your_secret_min_32_chars
JWT_ISSUER=help4kids.com
JWT_EXPIRATION_HOURS=24
PORT=8080
```

## Troubleshooting

- **Service won't start**: Check logs with `journalctl -u help4kids-api -n 50`
- **Database connection error**: Verify credentials in `/etc/help4kids/.env`
- **Port in use**: Check with `sudo ss -tlnp | grep 8080`
- **Permission denied**: Fix ownership with `sudo chown -R help4kids:help4kids /opt/help4kids/backend`
- **Encoding issues**: Connection automatically sets utf8mb4, verify database charset
- **Foreign key errors**: Some tables reference others created later, script continues
- **dart_frog not found**: Install with `dart pub global activate dart_frog_cli`

## Automated Deployment

Use the provided script:
```bash
# Upload deploy-backend.sh to server
chmod +x deploy-backend.sh
sudo ./deploy-backend.sh
```


