# VPS Redeployment Guide

Complete step-by-step guide for redeploying the Help4Kids backend on VPS.

## Quick Redeploy (Automated)

**The easiest way** - Use the provided script:

```bash
# SSH into your VPS
ssh user@your-vps-ip

# Navigate to backend directory
cd /opt/help4kids/backend

# Make script executable (if not already)
chmod +x scripts/redeploy.sh

# Run redeployment script as root
sudo scripts/redeploy.sh
```

This script will:
1. ✅ Pull latest changes from git
2. ✅ Stop the API server
3. ✅ Drop and recreate database from `database/init.sql` (includes all your Alteg IDs!)
4. ✅ Install dependencies
5. ✅ Rebuild the server
6. ✅ Restart the service

---

## Manual Redeployment Steps

If you prefer to do it manually or the script fails:

### Step 1: SSH into VPS

```bash
ssh user@your-vps-ip
```

### Step 2: Pull Latest Code

```bash
cd /opt/help4kids/backend
git pull origin main
# Or if your branch is named differently:
# git pull origin master
```

### Step 3: Backup Database (Optional but Recommended)

```bash
# Create backup directory if it doesn't exist
sudo mkdir -p /opt/help4kids/backups

# Backup current database
mysqldump -u help4kids_user -p help4kids_db > /opt/help4kids/backups/backup_$(date +%Y%m%d_%H%M%S).sql

# Enter your database password when prompted
```

### Step 4: Stop the API Service

```bash
sudo systemctl stop help4kids-api
```

### Step 5: Recreate Database

```bash
cd /opt/help4kids/backend

# Drop and recreate database using init.sql
mysql -u help4kids_user -p help4kids_db < database/init.sql
# Enter your database password when prompted
```

**Note:** The `init.sql` script includes `DROP DATABASE IF EXISTS` at the beginning, so it will automatically drop and recreate everything with fresh data including all your Alteg service IDs.

### Step 6: Install Dependencies

```bash
cd /opt/help4kids/backend
dart pub get
```

### Step 7: Build the Application

```bash
cd /opt/help4kids/backend

# Make sure dart_frog is in PATH
export PATH="$PATH:$HOME/.pub-cache/bin"

# Build with dart_frog
dart_frog build

# Compile to executable
dart compile exe build/bin/server.dart -o bin/server
```

### Step 8: Restart the Service

```bash
sudo systemctl start help4kids-api
```

### Step 9: Verify Deployment

```bash
# Check service status
sudo systemctl status help4kids-api

# Check logs
sudo journalctl -u help4kids-api -f

# Test API endpoint
curl http://localhost:8080/api/general_info | jq .
```

---

## Troubleshooting

### Service Won't Start

```bash
# Check detailed logs
sudo journalctl -u help4kids-api -n 50

# Common issues:
# - Database connection error: Check /etc/help4kids/.env
# - Port already in use: sudo ss -tlnp | grep 8080
# - Permission issues: sudo chown -R help4kids:help4kids /opt/help4kids/backend
```

### Database Connection Failed

```bash
# Test MySQL connection manually
mysql -u help4kids_user -p help4kids_db

# Check if MySQL is running
sudo systemctl status mysqld

# Verify credentials in env file
sudo cat /etc/help4kids/.env
```

### Build Fails

```bash
# Make sure Dart is installed and in PATH
dart --version

# Check if dart_frog is installed
which dart_frog

# If not, install it:
dart pub global activate dart_frog_cli
export PATH="$PATH:$HOME/.pub-cache/bin"
```

### Git Pull Fails

```bash
# Check git status
git status

# If there are uncommitted changes, stash them:
git stash

# Or reset to remote (CAREFUL - loses local changes):
git fetch origin
git reset --hard origin/main
```

---

## What Gets Deployed

When you redeploy, the following happens:

1. **Database**: 
   - All tables are dropped and recreated
   - All data from `database/init.sql` is inserted
   - **All Alteg service IDs** (booking_id) are now in the database
   - Initial users, roles, categories, services, consultations are created

2. **Application**:
   - Latest code is pulled from git
   - Dependencies are installed
   - Server is rebuilt and recompiled
   - Service is restarted with new binary

---

## Pre-Deployment Checklist

Before redeploying, make sure:

- [ ] You've committed and pushed all changes to git (including the updated `database/init.sql`)
- [ ] You have SSH access to the VPS
- [ ] You know the database password (stored in `/etc/help4kids/.env`)
- [ ] You have a database backup (optional but recommended for production)
- [ ] No critical operations are running on the server

---

## Post-Deployment Verification

After redeployment, verify:

- [ ] Service is running: `sudo systemctl status help4kids-api`
- [ ] API responds: `curl http://localhost:8080/api/general_info`
- [ ] Database has services: `mysql -u help4kids_user -p help4kids_db -e "SELECT COUNT(*) FROM services;"`
- [ ] Services have booking_ids: `mysql -u help4kids_user -p help4kids_db -e "SELECT title, booking_id FROM services WHERE booking_id IS NOT NULL LIMIT 10;"`

---

## Quick Reference Commands

```bash
# View service logs
sudo journalctl -u help4kids-api -f

# Restart service
sudo systemctl restart help4kids-api

# Check service status
sudo systemctl status help4kids-api

# Test API
curl http://localhost:8080/api/general_info

# Check database connection
mysql -u help4kids_user -p help4kids_db

# View environment variables (read-only)
sudo cat /etc/help4kids/.env
```

---

## Environment Variables Location

Your environment variables are stored in:
```
/etc/help4kids/.env
```

They include:
- `DB_HOST`, `DB_PORT`, `DB_USER`, `DB_PASSWORD`, `DB_NAME`
- `JWT_SECRET`, `JWT_ISSUER`, `JWT_EXPIRATION_HOURS`
- `PORT`

**Do not commit this file to git!** It contains sensitive credentials.

