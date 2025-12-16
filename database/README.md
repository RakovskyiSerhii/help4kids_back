# Database Setup

This directory contains the database initialization script for the Help4Kids application.

## Quick Start

### Using MySQL Command Line

```bash
mysql -u root -p < database/init.sql
```

### Using MySQL Workbench or Other GUI Tools

1. Open the `database/init.sql` file
2. Execute the entire script in your MySQL client

### Using Docker (if you have MySQL in Docker)

```bash
docker exec -i <mysql_container_name> mysql -u root -p < database/init.sql
```

## What the Script Does

1. **Drops** the existing `help4kids_db` database (if it exists)
2. **Creates** a fresh `help4kids_db` database
3. **Creates** all 17 tables:
   - roles
   - users
   - activity_logs
   - service_categories
   - services
   - courses
   - consultations
   - orders
   - consultation_appointments
   - article_categories
   - articles
   - saved_articles
   - email_verification
   - staff
   - unit
   - social_contacts
   - finance_info

4. **Inserts** initial data:
   - 3 roles (god, admin, customer)
   - 1 unit (medical center location)
   - 3 staff members
   - 3 social contacts
   - 1 finance info record
   - 19 service categories with all services
   - 3 consultations

## Database Configuration

After running the script, make sure your application's environment variables match your MySQL setup:

```bash
DB_HOST=localhost
DB_PORT=3306
DB_USER=root
DB_PASSWORD=your_password
DB_NAME=help4kids_db
```

## Notes

- The script uses `UUID()` for generating unique IDs
- All timestamps use `NOW()` for current date/time
- The script is idempotent for roles (uses `INSERT IGNORE`)
- Service categories use MySQL variables (`@cat1`, `@cat2`, etc.) to maintain referential integrity

## Troubleshooting

If you encounter foreign key constraint errors:
- Make sure you're running the entire script in one transaction
- Check that all tables are created before data insertion
- Verify MySQL version supports JSON data type (5.7.8+)

