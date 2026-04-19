# Horizontal Scaling Guide for Help4Kids Backend

## Overview

This guide explains how to scale your Dart Frog backend horizontally across multiple instances.

## How Dart Scales

### ✅ **Dart is Stateless by Default**
- No in-memory sessions (you use JWT - perfect!)
- Each request is independent
- No shared state between instances
- **This makes horizontal scaling straightforward**

### ✅ **Dart Performance Characteristics**
- **AOT Compilation**: Fast startup, efficient runtime
- **Event Loop**: Handles thousands of concurrent connections per instance
- **Memory Efficient**: Lower memory footprint than JVM-based languages
- **Single-threaded**: No thread synchronization overhead

### 📊 **Scaling Capacity**
- **Single Instance**: ~1,000-5,000 concurrent connections (depends on hardware)
- **Multiple Instances**: Linear scaling (2 instances = ~2x capacity)
- **Bottleneck**: Usually database connections, not Dart itself

---

## Architecture Comparison

### Current (Single Instance)
```
Internet → Nginx → Dart Instance (port 8080) → MySQL
```

### Horizontal Scaling (Multiple Instances)
```
Internet → Nginx (Load Balancer) → Multiple Dart Instances → MySQL
                                      ↓
                              [Instance 1:8080]
                              [Instance 2:8081]
                              [Instance 3:8082]
```

---

## Method 1: Multiple Instances on Same Server

### Step 1: Update Nginx Configuration

Edit `/etc/nginx/conf.d/help4kids.conf`:

```nginx
# Upstream with multiple backend instances
upstream help4kids_api {
    # Load balancing method: least_conn (best for database-heavy apps)
    least_conn;
    
    # Health check (optional, requires nginx-plus or custom module)
    # For now, Nginx will automatically remove failed servers
    
    # Multiple instances
    server localhost:8080 weight=1 max_fails=3 fail_timeout=30s;
    server localhost:8081 weight=1 max_fails=3 fail_timeout=30s;
    server localhost:8082 weight=1 max_fails=3 fail_timeout=30s;
    
    # Keep connections alive for better performance
    keepalive 32;
}

server {
    listen 80;
    server_name your-domain.com;

    # Frontend static files
    location / {
        root /opt/help4kids/frontend/build/web;
        try_files $uri $uri/ /index.html;
    }

    # Backend API with load balancing
    location /api {
        proxy_pass http://help4kids_api;
        proxy_http_version 1.1;
        
        # Connection reuse
        proxy_set_header Connection "";
        
        # Standard proxy headers
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
        
        # Timeouts
        proxy_connect_timeout 60s;
        proxy_send_timeout 60s;
        proxy_read_timeout 60s;
        
        # Buffer settings
        proxy_buffering on;
        proxy_buffer_size 4k;
        proxy_buffers 8 4k;
    }
}
```

### Step 2: Create Multiple Systemd Services

**Instance 1** (`/etc/systemd/system/help4kids-api-1.service`):
```ini
[Unit]
Description=Help4Kids API Server Instance 1
After=network.target mysql.service

[Service]
Type=simple
User=help4kids
Group=help4kids
WorkingDirectory=/opt/help4kids/backend
EnvironmentFile=/etc/help4kids/.env
Environment="PORT=8080"
ExecStart=/opt/help4kids/backend/bin/server
Restart=always
RestartSec=10
StandardOutput=journal
StandardError=journal

[Install]
WantedBy=multi-user.target
```

**Instance 2** (`/etc/systemd/system/help4kids-api-2.service`):
```ini
[Unit]
Description=Help4Kids API Server Instance 2
After=network.target mysql.service

[Service]
Type=simple
User=help4kids
Group=help4kids
WorkingDirectory=/opt/help4kids/backend
EnvironmentFile=/etc/help4kids/.env
Environment="PORT=8081"
ExecStart=/opt/help4kids/backend/bin/server
Restart=always
RestartSec=10
StandardOutput=journal
StandardError=journal

[Install]
WantedBy=multi-user.target
```

**Instance 3** (`/etc/systemd/system/help4kids-api-3.service`):
```ini
[Unit]
Description=Help4Kids API Server Instance 3
After=network.target mysql.service

[Service]
Type=simple
User=help4kids
Group=help4kids
WorkingDirectory=/opt/help4kids/backend
EnvironmentFile=/etc/help4kids/.env
Environment="PORT=8082"
ExecStart=/opt/help4kids/backend/bin/server
Restart=always
RestartSec=10
StandardOutput=journal
StandardError=journal

[Install]
WantedBy=multi-user.target
```

### Step 3: Start All Instances

```bash
# Enable and start all instances
sudo systemctl daemon-reload
sudo systemctl enable help4kids-api-1
sudo systemctl enable help4kids-api-2
sudo systemctl enable help4kids-api-3

sudo systemctl start help4kids-api-1
sudo systemctl start help4kids-api-2
sudo systemctl start help4kids-api-3

# Check status
sudo systemctl status help4kids-api-1
sudo systemctl status help4kids-api-2
sudo systemctl status help4kids-api-3

# Reload Nginx
sudo nginx -t
sudo systemctl reload nginx
```

### Step 4: Verify Load Balancing

```bash
# Test multiple requests - should hit different instances
for i in {1..10}; do
  curl -s http://localhost/api/general_info | head -1
  sleep 0.5
done

# Check logs from different instances
sudo journalctl -u help4kids-api-1 -f
sudo journalctl -u help4kids-api-2 -f
```

---

## Method 2: Docker Compose (Recommended for Easy Scaling)

Create `docker-compose.yml`:

```yaml
version: '3.8'

services:
  # Backend Instance 1
  api-1:
    build: .
    container_name: help4kids-api-1
    ports:
      - "8080:8080"
    environment:
      - DB_HOST=mysql
      - DB_PORT=3306
      - DB_USER=${DB_USER}
      - DB_PASSWORD=${DB_PASSWORD}
      - DB_NAME=${DB_NAME}
      - JWT_SECRET=${JWT_SECRET}
      - JWT_ISSUER=${JWT_ISSUER}
      - PORT=8080
    depends_on:
      - mysql
    restart: unless-stopped
    networks:
      - help4kids-network

  # Backend Instance 2
  api-2:
    build: .
    container_name: help4kids-api-2
    ports:
      - "8081:8080"
    environment:
      - DB_HOST=mysql
      - DB_PORT=3306
      - DB_USER=${DB_USER}
      - DB_PASSWORD=${DB_PASSWORD}
      - DB_NAME=${DB_NAME}
      - JWT_SECRET=${JWT_SECRET}
      - JWT_ISSUER=${JWT_ISSUER}
      - PORT=8080
    depends_on:
      - mysql
    restart: unless-stopped
    networks:
      - help4kids-network

  # Backend Instance 3
  api-3:
    build: .
    container_name: help4kids-api-3
    ports:
      - "8082:8080"
    environment:
      - DB_HOST=mysql
      - DB_PORT=3306
      - DB_USER=${DB_USER}
      - DB_PASSWORD=${DB_PASSWORD}
      - DB_NAME=${DB_NAME}
      - JWT_SECRET=${JWT_SECRET}
      - JWT_ISSUER=${JWT_ISSUER}
      - PORT=8080
    depends_on:
      - mysql
    restart: unless-stopped
    networks:
      - help4kids-network

  # Load Balancer (Nginx)
  nginx:
    image: nginx:alpine
    container_name: help4kids-nginx
    ports:
      - "80:80"
      - "443:443"
    volumes:
      - ./nginx.conf:/etc/nginx/nginx.conf:ro
      - ./frontend/build/web:/usr/share/nginx/html:ro
    depends_on:
      - api-1
      - api-2
      - api-3
    restart: unless-stopped
    networks:
      - help4kids-network

  # MySQL Database
  mysql:
    image: mysql:8.0
    container_name: help4kids-mysql
    environment:
      - MYSQL_ROOT_PASSWORD=${MYSQL_ROOT_PASSWORD}
      - MYSQL_DATABASE=${DB_NAME}
      - MYSQL_USER=${DB_USER}
      - MYSQL_PASSWORD=${DB_PASSWORD}
    volumes:
      - mysql-data:/var/lib/mysql
      - ./database/init.sql:/docker-entrypoint-initdb.d/init.sql:ro
    ports:
      - "3306:3306"
    restart: unless-stopped
    networks:
      - help4kids-network

networks:
  help4kids-network:
    driver: bridge

volumes:
  mysql-data:
```

Create `nginx.conf` for Docker:

```nginx
events {
    worker_connections 1024;
}

http {
    upstream help4kids_api {
        least_conn;
        server api-1:8080;
        server api-2:8080;
        server api-3:8080;
        keepalive 32;
    }

    server {
        listen 80;
        server_name _;

        # Frontend
        location / {
            root /usr/share/nginx/html;
            try_files $uri $uri/ /index.html;
        }

        # Backend API
        location /api {
            proxy_pass http://help4kids_api;
            proxy_http_version 1.1;
            proxy_set_header Connection "";
            proxy_set_header Host $host;
            proxy_set_header X-Real-IP $remote_addr;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
            proxy_set_header X-Forwarded-Proto $scheme;
        }
    }
}
```

**Usage:**
```bash
# Scale up to 5 instances
docker-compose up -d --scale api-1=1 --scale api-2=1 --scale api-3=3

# Or use docker-compose scale (if supported)
docker-compose up -d
docker-compose scale api-1=2 api-2=2 api-3=2
```

---

## Method 3: Multiple Servers (True Horizontal Scaling)

### Architecture
```
Internet → Load Balancer (HAProxy/Nginx) → Server 1 (Dart Instance)
                                        → Server 2 (Dart Instance)
                                        → Server 3 (Dart Instance)
                                        → Shared MySQL (or MySQL Replication)
```

### Setup HAProxy (Better for Multi-Server)

Install HAProxy:
```bash
sudo dnf install -y haproxy
```

Configure `/etc/haproxy/haproxy.cfg`:
```haproxy
global
    log /dev/log local0
    maxconn 4096
    user haproxy
    group haproxy

defaults
    log global
    mode http
    option httplog
    option dontlognull
    timeout connect 5000ms
    timeout client 50000ms
    timeout server 50000ms

frontend http_front
    bind *:80
    default_backend help4kids_backend

backend help4kids_backend
    balance leastconn
    option httpchk GET /api/health
    http-check expect status 200
    
    server server1 192.168.1.10:8080 check
    server server2 192.168.1.11:8080 check
    server server3 192.168.1.12:8080 check
```

---

## Important Considerations

### 1. **Database Connection Pooling**

**Current Issue**: Each instance has its own connection pool (max 10 connections each)
- 3 instances = 30 total connections to MySQL
- MySQL default `max_connections` = 151

**Solution**: Adjust MySQL `max_connections`:
```sql
-- In MySQL
SET GLOBAL max_connections = 500;
-- Or in my.cnf
max_connections = 500
```

**Better Solution**: Use a connection pooler like **ProxySQL** or **PgBouncer** (for MySQL, use ProxySQL):
```
Dart Instances → ProxySQL → MySQL
```

### 2. **Connection Pool Size Per Instance**

With multiple instances, you can reduce pool size per instance:
```dart
// In connection_pool.dart
final int _maxPoolSize = 5;  // Reduced from 10
final int _minPoolSize = 1;  // Reduced from 2
```

### 3. **Health Check Endpoint**

Add a health check endpoint for load balancer:

Create `routes/api/health.dart`:
```dart
import 'package:dart_frog/dart_frog.dart';
import '../../lib/data/connection_pool.dart';

Future<Response> onRequest(RequestContext context) async {
  if (context.request.method == HttpMethod.get) {
    try {
      // Quick database check
      final pool = ConnectionPool();
      final stats = pool.getStats();
      
      return Response.json(
        body: {
          'status': 'healthy',
          'pool': stats,
          'timestamp': DateTime.now().toIso8601String(),
        },
      );
    } catch (e) {
      return Response.json(
        body: {'status': 'unhealthy', 'error': e.toString()},
        statusCode: 503,
      );
    }
  }
  return Response(statusCode: 405);
}
```

### 4. **Sticky Sessions (Not Needed for Your App)**

Since you use JWT (stateless), you **don't need** sticky sessions. Each request is independent.

### 5. **Shared Resources**

✅ **No changes needed**:
- JWT tokens (stateless)
- Database (shared MySQL)
- File uploads (if any, use shared storage like S3 or NFS)

---

## Load Balancing Algorithms

### 1. **Least Connections** (Recommended for Database-Heavy Apps)
```nginx
upstream help4kids_api {
    least_conn;  # Routes to instance with fewest active connections
    server localhost:8080;
    server localhost:8081;
    server localhost:8082;
}
```

### 2. **Round Robin** (Default)
```nginx
upstream help4kids_api {
    # Round robin is default
    server localhost:8080;
    server localhost:8081;
    server localhost:8082;
}
```

### 3. **IP Hash** (For Sticky Sessions - Not needed for you)
```nginx
upstream help4kids_api {
    ip_hash;  # Routes same IP to same server
    server localhost:8080;
    server localhost:8081;
}
```

---

## Monitoring Multiple Instances

### Check All Instance Status
```bash
# Create a script to check all instances
#!/bin/bash
for i in {1..3}; do
  echo "Instance $i:"
  systemctl status help4kids-api-$i --no-pager | grep Active
done
```

### View Logs from All Instances
```bash
# All logs together
sudo journalctl -u help4kids-api-1 -u help4kids-api-2 -u help4kids-api-3 -f

# Individual logs
sudo journalctl -u help4kids-api-1 -f
```

### Connection Pool Stats
Add an endpoint to check pool stats (see health check example above).

---

## Performance Expectations

### Single Instance
- **Concurrent Users**: ~50-200
- **Requests/Second**: ~100-500
- **Database Connections**: 10 max

### 3 Instances (Horizontal Scaling)
- **Concurrent Users**: ~150-600 (3x)
- **Requests/Second**: ~300-1,500 (3x)
- **Database Connections**: 30 max (3 × 10)

### Bottlenecks
1. **Database**: First bottleneck (increase `max_connections` or use connection pooler)
2. **Network**: Usually not an issue
3. **CPU/Memory**: Monitor per instance

---

## Auto-Scaling (Advanced)

### Using Kubernetes
```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: help4kids-api
spec:
  replicas: 3
  selector:
    matchLabels:
      app: help4kids-api
  template:
    metadata:
      labels:
        app: help4kids-api
    spec:
      containers:
      - name: api
        image: help4kids-api:latest
        resources:
          requests:
            memory: "256Mi"
            cpu: "250m"
          limits:
            memory: "512Mi"
            cpu: "500m"
---
apiVersion: autoscaling/v2
kind: HorizontalPodAutoscaler
metadata:
  name: help4kids-api-hpa
spec:
  scaleTargetRef:
    apiVersion: apps/v1
    kind: Deployment
    name: help4kids-api
  minReplicas: 3
  maxReplicas: 10
  metrics:
  - type: Resource
    resource:
      name: cpu
      target:
        type: Utilization
        averageUtilization: 70
```

---

## Summary

✅ **Dart scales well horizontally** because:
- Stateless architecture
- JWT authentication (no session store needed)
- Efficient event loop
- AOT compilation

✅ **Easy to implement**:
- Just run multiple instances
- Use Nginx/HAProxy for load balancing
- No code changes needed!

⚠️ **Watch out for**:
- Database connection limits
- Shared resources (file uploads, etc.)
- Monitoring all instances

🚀 **Next Steps**:
1. Start with 2-3 instances on same server
2. Monitor database connections
3. Scale to multiple servers if needed
4. Consider connection pooler (ProxySQL) for many instances

