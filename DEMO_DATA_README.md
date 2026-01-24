# Demo Data for Content Management System

## Overview

This document describes the demo data inserted by `database/insert_demo_content_data.sql`.

## Demo Content Created

### 1. **Вебінар: Здоровий сон дитини** (Single Video)
- **Type**: Single video content
- **Description**: Webinar about healthy child sleep
- **Featured**: Yes
- **Prices**:
  - 2000 UAH - Lifetime access (default)
  - 1200 UAH - 6 months access
- **Materials**:
  - PDF: Sleep schedule checklist
  - Link: Additional sleep resources

### 2. **Курс: Правильне харчування дитини** (Multi-Episode)
- **Type**: Multi-episode course
- **Description**: 8-episode course on child nutrition
- **Featured**: Yes
- **Episodes**: 8 episodes covering:
  1. Breastfeeding
  2. Introducing solid foods
  3. Nutrition for 1-3 years
  4. Nutrition for preschoolers
  5. Allergies and intolerances
  6. Vitamins and minerals
  7. Recipes for children
  8. Q&A session
- **Prices**:
  - 4000 UAH - Lifetime access (default)
  - 2500 UAH - 6 months access
  - 1500 UAH - 3 months access
- **Materials**:
  - Content level: Full nutrition guide PDF
  - Episode materials: Schedules, tables, menu examples

### 3. **Перша допомога дитині** (Single Video)
- **Type**: Single video content
- **Description**: First aid for children in emergencies
- **Featured**: No
- **Prices**:
  - 1500 UAH - Lifetime access (default)
  - 900 UAH - 6 months access
- **Materials**:
  - PDF: Quick reference guide for first aid
  - Link: Emergency contact numbers

### 4. **Розвиток дитини: Від народження до 3 років** (Multi-Episode)
- **Type**: Multi-episode course
- **Description**: 12-episode course on child development
- **Featured**: Yes
- **Episodes**: 12 episodes covering:
  1. Development in first 3 months
  2. Development 3-6 months
  3. Development 6-9 months
  4. Development 9-12 months
  5. Development 1-1.5 years
  6. Development 1.5-2 years
  7. Development 2-2.5 years
  8. Development 2.5-3 years
  9. Motor development
  10. Language development
  11. Emotional development
  12. When to consult a specialist
- **Prices**:
  - 5000 UAH - Lifetime access (default)
  - 3000 UAH - 12 months access
  - 2000 UAH - 6 months access
- **Materials**:
  - Content level: Development calendar PDF
  - Episode materials: Checklists, exercises, games

## Statistics

After running the script, you'll have:
- **4 Contents** (2 single video, 2 multi-episode)
- **11 Price Options** (multiple prices per content)
- **20 Episodes** (8 for nutrition course, 12 for development course)
- **13 Materials** (PDFs, images, links)

## How to Use

1. **First, create the tables** (if not already done):
   ```bash
   mysql -u your_user -p help4kids_db < database/create_content_tables.sql
   ```

2. **Then, insert demo data**:
   ```bash
   mysql -u your_user -p help4kids_db < database/insert_demo_content_data.sql
   ```

3. **Verify the data**:
   ```sql
   SELECT COUNT(*) as total_contents FROM contents;
   SELECT COUNT(*) as total_prices FROM content_prices;
   SELECT COUNT(*) as total_episodes FROM episodes;
   SELECT COUNT(*) as total_materials FROM content_materials;
   ```

## Testing the API

After inserting demo data, you can test the admin endpoints:

### List all contents
```bash
GET /api/admin/contents
Authorization: Bearer <admin_token>
```

### Get specific content with all details
```bash
GET /api/admin/contents/{contentId}
Authorization: Bearer <admin_token>
```

### Get episodes for a content
```bash
GET /api/admin/contents/{contentId}/episodes
Authorization: Bearer <admin_token>
```

### Get prices for a content
```bash
GET /api/admin/contents/{contentId}/prices
Authorization: Bearer <admin_token>
```

## Notes

- All demo content is marked as `is_active = TRUE`
- Featured content is marked appropriately
- Video URLs are placeholder URLs (you'll need to replace with actual video URLs)
- Material file paths are relative paths (you'll need to ensure files exist or update paths)
- Telegram group URLs are placeholder URLs
- Cover image URLs are relative paths (you'll need to ensure images exist or update paths)

## Customization

You can modify the demo data script to:
- Add more content
- Change prices
- Add more episodes
- Add more materials
- Update URLs to match your actual resources

The script uses MySQL variables (`@content1_id`, etc.) to maintain referential integrity between related records.

