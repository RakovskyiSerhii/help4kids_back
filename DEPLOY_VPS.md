# VPS Deployment Commands

## Step 1: Pull Latest Changes

```bash
cd /opt/help4kids/backend
git pull origin latest-changes
```

## Step 2: Backup Existing Database (if exists)

```bash
# Backup current database
mysqldump -u help4kids_user -p help4kids_db > /opt/help4kids/backup_$(date +%Y%m%d_%H%M%S).sql
```

## Step 3: Drop and Recreate Database (Fresh Start)

```bash
# Drop existing database
mysql -u help4kids_user -p << EOF
DROP DATABASE IF EXISTS help4kids_db;
CREATE DATABASE help4kids_db DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
EOF

# Run initialization script
mysql -u help4kids_user -p help4kids_db < database/init.sql
```

## Step 4: Rebuild and Restart Service

```bash
# Add dart_frog to PATH (if not already added)
export PATH="$PATH:$HOME/.pub-cache/bin"

# Or use full path
# ~/.pub-cache/bin/dart_frog build

# Rebuild Dart application
dart_frog build

# Compile executable
dart compile exe build/bin/server.dart -o bin/server

# Restart service
sudo systemctl restart help4kids-api

# Check status
sudo systemctl status help4kids-api

# View logs if needed
sudo journalctl -u help4kids-api -f
```

## Step 5: Verify API is Working

```bash
# Test locally
curl http://localhost:8080/api/general_info | jq .

# Test remotely (from your machine)
curl http://173.242.53.114:8080/api/general_info | jq .
```

## All-in-One Script

```bash
#!/bin/bash
cd /opt/help4kids/backend

# Pull changes
echo "Pulling latest changes..."
git pull origin latest-changes

# Backup database
echo "Backing up database..."
mysqldump -u help4kids_user -p help4kids_db > /opt/help4kids/backup_$(date +%Y%m%d_%H%M%S).sql

# Drop and recreate
echo "Recreating database..."
mysql -u help4kids_user -p << EOF
DROP DATABASE IF EXISTS help4kids_db;
CREATE DATABASE help4kids_db DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
EOF

# Initialize
echo "Initializing database..."
mysql -u help4kids_user -p help4kids_db < database/init.sql

# Rebuild
echo "Rebuilding application..."
export PATH="$PATH:$HOME/.pub-cache/bin"
dart_frog build
dart compile exe build/bin/server.dart -o bin/server

# Restart
echo "Restarting service..."
sudo systemctl restart help4kids-api

echo "Deployment complete! Check status with: sudo systemctl status help4kids-api"
```

