# Requirements: Profile, Payments, Content & Videos

## Overview
Complete requirements document for:
1. **User Profile Management**
2. **Payment Processing (WayForPay)**
3. **Content Management** (buyable content - single video or multiple videos/episodes)
4. **Video Content Management**

---

## 1. User Profile

### Fields
- ✅ Email (already exists)
- ✅ Name: firstName, lastName (already exists)
- ✅ Phone number (needs to be added)

### Features
- View own profile
- Edit own profile
- Simple profile - no extra fields needed for MVP

### API Endpoints Needed
- `GET /api/profile/me` - Get current user profile
- `PUT /api/profile/me` - Update current user profile

---

## 2. Payment Processing

### Payment Gateway
- ✅ **WayForPay (WFP)**

### Features
- Create payment for order
- Payment status tracking
- Payment callbacks/webhooks
- Payment history

### API Endpoints Needed
- `POST /api/orders/{orderId}/pay` - Initiate payment
- `POST /api/payments/wayforpay/callback` - Payment webhook
- `GET /api/orders/{orderId}/payment-status` - Get payment status
- `GET /api/payments/me` - Get payment history

---

## 3. Content Management

### Naming
- ✅ **"Content"** (replaces "courses")

### Content Types

#### Type 1: Single Video Content
- Single long video (webinar)
- Has: title, description, video URL, telegram group link, materials

#### Type 2: Multiple Videos Content
- Multiple videos organized as "episodes"
- Each episode is a separate entity
- Has: title, description, telegram group link
- Episodes have: title, description, video URL, materials (PDF, doc, images, links)
- Progress tracking: mark episodes as watched

### Content Structure

**Common fields for both types:**
- `id` - Unique identifier
- `title` - Content title
- `description` - Content description
- `telegram_group_link` - Link to Telegram group for discussions
- `price` - Price (can have multiple pricing tiers)
- `type` - Enum: `single_video` or `multiple_videos`
- `image` - Cover image
- `icon` - Icon
- `created_at`, `updated_at` - Timestamps

**For Single Video:**
- `video_url` - Direct video URL
- `materials` - JSON array of materials (PDFs, docs, images, links)

**For Multiple Videos:**
- Episodes stored separately (see Episode structure below)

### Episode Structure (for Multiple Videos Content)

**Episode fields:**
- `id` - Unique identifier
- `content_id` - Parent content ID
- `title` - Episode title
- `description` - Episode description
- `video_url` - Episode video URL
- `order_index` - Display order within content
- `materials` - JSON array of materials (PDFs, docs, images, links)
- `created_at`, `updated_at` - Timestamps

### Access Control

**Access Types:**
- ✅ **Immediate access** after payment
- ✅ **Available from user profile**
- ✅ **Lifetime access** OR **Time-limited access** (e.g., 6 months)
- ✅ **Multiple pricing tiers** per content:
  - Example: Course A
    - 100 UAH = 6 months access
    - 400 UAH = lifetime access

**Access Rules:**
- ✅ Users can re-watch if access is valid
- ✅ If time-limited access expired:
  - Still show in profile
  - Require repurchase to access
- ✅ Allow deletion of purchased content (for refunds?) - **Open question**

### Progress Tracking (Multiple Videos Only)

- Track which episodes are watched
- Mark episodes as watched/unwatched
- Show overall progress (X of Y episodes watched)

### API Endpoints Needed

**Content Management:**
- `GET /api/content` - List all content
- `GET /api/content/{contentId}` - Get content details
- `POST /api/content` - Create content (admin)
- `PUT /api/content/{contentId}` - Update content (admin)
- `DELETE /api/content/{contentId}` - Delete content (admin)

**Episodes (for Multiple Videos):**
- `GET /api/content/{contentId}/episodes` - Get all episodes
- `POST /api/content/{contentId}/episodes` - Create episode (admin)
- `PUT /api/content/{contentId}/episodes/{episodeId}` - Update episode (admin)
- `DELETE /api/content/{contentId}/episodes/{episodeId}` - Delete episode (admin)

**User Access:**
- `GET /api/content/my` - Get user's purchased content
- `GET /api/content/{contentId}/access` - Check access status
- `POST /api/content/{contentId}/episodes/{episodeId}/mark-watched` - Mark episode as watched
- `GET /api/content/{contentId}/progress` - Get progress (for multiple videos)

---

## 4. Video Hosting

### Requirements
- ✅ **Private, purchasable access** (only purchasers can view)
- ✅ **Budget: $15/month maximum**
- ✅ **Single course: no limit** (unlimited storage per content)
- ✅ **Current: 30-40 videos** already exist

### Recommended Solutions (within budget)

**Option 1: Bunny.net Stream**
- ~$1 per 1000 minutes stored
- ~$0.01 per GB bandwidth
- Private videos with signed URLs
- **Estimated cost for 40 videos (avg 1 hour each): ~$5-10/month**

**Option 2: Cloudflare Stream**
- $1 per 1000 minutes stored
- $1 per 1000 minutes delivered
- Private videos with tokens
- **Estimated cost: ~$8-12/month**

**Option 3: Self-hosted with Bunny.net CDN**
- Store on server/VPS
- Use Bunny.net for delivery
- **Estimated cost: ~$5-8/month**

**Recommendation:** Start with **Bunny.net Stream** - fits budget, supports private videos, good performance.

### Video Features Needed
- Private video URLs (signed/tokenized)
- Video duration tracking (optional - not required for MVP)
- Thumbnail generation (optional)
- Basic video player
- **Focus:** Episode tracking (mark episodes as watched/unwatched)

---

## 5. Database Schema

### New/Updated Tables

#### 1. Users Table (Update)
```sql
ALTER TABLE users ADD COLUMN phone VARCHAR(50) NULL;
```

#### 2. Content Table (Rename from "courses")
- Keep existing structure but add:
  - `type` ENUM('single_video', 'multiple_videos')
  - `telegram_group_link` VARCHAR(512)
  - `materials` JSON (for single video case)
  - `access_type` ENUM('lifetime', 'time_limited')
  - `access_duration_days` INT (for time-limited, NULL for lifetime)

#### 3. Content Episodes Table (New)
```sql
CREATE TABLE content_episodes (
  id VARCHAR(36) PRIMARY KEY,
  content_id VARCHAR(36) NOT NULL,
  title VARCHAR(255) NOT NULL,
  description TEXT,
  video_url VARCHAR(512) NOT NULL,
  order_index INT NOT NULL DEFAULT 0,
  materials JSON,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY (content_id) REFERENCES content(id) ON DELETE CASCADE,
  INDEX idx_content_id (content_id),
  INDEX idx_order_index (content_id, order_index)
);
```

#### 4. Content Access Table (New)
```sql
CREATE TABLE content_access (
  id VARCHAR(36) PRIMARY KEY,
  user_id VARCHAR(36) NOT NULL,
  content_id VARCHAR(36) NOT NULL,
  order_id VARCHAR(36) NOT NULL,
  access_type ENUM('lifetime', 'time_limited') NOT NULL,
  expires_at TIMESTAMP NULL, -- NULL for lifetime, set date for time-limited
  purchased_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
  FOREIGN KEY (content_id) REFERENCES content(id) ON DELETE CASCADE,
  FOREIGN KEY (order_id) REFERENCES orders(id) ON DELETE CASCADE,
  UNIQUE KEY unique_user_content_order (user_id, content_id, order_id),
  INDEX idx_user_id (user_id),
  INDEX idx_content_id (content_id),
  INDEX idx_expires_at (expires_at)
);
```

#### 5. Episode Watch History Table (New)
```sql
CREATE TABLE episode_watch_history (
  id VARCHAR(36) PRIMARY KEY,
  user_id VARCHAR(36) NOT NULL,
  episode_id VARCHAR(36) NOT NULL,
  watched BOOLEAN NOT NULL DEFAULT FALSE,
  watched_at TIMESTAMP NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
  FOREIGN KEY (episode_id) REFERENCES content_episodes(id) ON DELETE CASCADE,
  UNIQUE KEY unique_user_episode (user_id, episode_id),
  INDEX idx_user_id (user_id),
  INDEX idx_episode_id (episode_id)
);
```

#### 6. Payments Table (New)
```sql
CREATE TABLE payments (
  id VARCHAR(36) PRIMARY KEY,
  order_id VARCHAR(36) NOT NULL,
  gateway VARCHAR(50) NOT NULL DEFAULT 'wayforpay',
  gateway_invoice_id VARCHAR(255) NOT NULL UNIQUE,
  amount DECIMAL(10, 2) NOT NULL,
  currency VARCHAR(3) NOT NULL DEFAULT 'UAH',
  status ENUM('initiated', 'processing', 'successful', 'failed', 'refunded') NOT NULL DEFAULT 'initiated',
  raw_gateway_payload JSON,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY (order_id) REFERENCES orders(id) ON DELETE CASCADE,
  INDEX idx_gateway_invoice (gateway, gateway_invoice_id),
  INDEX idx_order_id (order_id),
  INDEX idx_status (status)
);
```

#### 7. Orders Table (Update)
```sql
ALTER TABLE orders 
  MODIFY COLUMN status ENUM('pending', 'awaiting_payment', 'paid', 'failed', 'cancelled', 'refunded') NOT NULL DEFAULT 'pending',
  ADD COLUMN currency VARCHAR(3) NOT NULL DEFAULT 'UAH' AFTER amount,
  ADD COLUMN access_type ENUM('lifetime', 'time_limited') NULL AFTER currency,
  ADD COLUMN access_duration_days INT NULL AFTER access_type;
```

---

## 6. Implementation Phases

### Phase 1: Foundation (Week 1)
1. ✅ Database schema updates
2. ✅ User profile (add phone field)
3. ✅ Profile API endpoints

### Phase 2: Payment Integration (Week 2)
1. ✅ Payment model and service
2. ✅ WayForPay integration
3. ✅ Payment endpoints
4. ✅ Webhook handling

### Phase 3: Content Structure (Week 3)
1. ✅ Rename "courses" to "content" (or keep both for backward compatibility)
2. ✅ Add content type (single_video vs multiple_videos)
3. ✅ Add telegram group link
4. ✅ Add materials support
5. ✅ Create episodes table and model

### Phase 4: Access Control (Week 4)
1. ✅ Content access table
2. ✅ Access validation logic
3. ✅ Time-limited vs lifetime access
4. ✅ Multiple pricing tiers per content

### Phase 5: Video & Progress (Week 5)
1. ✅ Video hosting integration (Bunny.net or chosen provider)
2. ✅ Episode watch tracking
3. ✅ Progress tracking for multiple videos
4. ✅ User profile content list

---

## 7. Open Questions

1. **Refunds:** Allow deletion of purchased content for refunds? How to handle?
2. **Video hosting:** Final decision on provider (Bunny.net recommended)

## 8. Materials Storage

### Decision: Store on Same VPS as Backend
- ✅ **Materials (PDFs, docs, images) will be stored on the same VPS where backend is running**
- Store in a dedicated directory (e.g., `/var/www/help4kids/storage/materials/`)
- Serve via backend API endpoint `GET /api/materials/{materialId}` with access control
- File organization: `/storage/materials/{contentId}/{episodeId?}/{filename}`
- Benefits:
  - No additional storage costs
  - Simple to implement
  - Full control over access
- Considerations:
  - Need to ensure VPS has enough storage space
  - Should implement proper file organization (by content ID, episode ID)
  - Need backup strategy for materials
  - API endpoint must verify user has access to content before serving file

---

## 9. API Summary

### Profile
- `GET /api/profile/me` - Get profile
- `PUT /api/profile/me` - Update profile

### Payments
- `POST /api/orders/{orderId}/pay` - Initiate payment
- `POST /api/payments/wayforpay/callback` - Webhook
- `GET /api/orders/{orderId}/payment-status` - Payment status
- `GET /api/payments/me` - Payment history

### Content
- `GET /api/content` - List content
- `GET /api/content/{id}` - Get content
- `GET /api/content/my` - My purchased content
- `GET /api/content/{id}/access` - Check access
- `GET /api/content/{id}/episodes` - Get episodes
- `GET /api/content/{id}/progress` - Get progress
- `POST /api/content/{id}/episodes/{episodeId}/mark-watched` - Mark watched
- `GET /api/materials/{materialId}` - Download material file (with access control)

### Admin
- `POST /api/content` - Create content
- `PUT /api/content/{id}` - Update content
- `DELETE /api/content/{id}` - Delete content
- `POST /api/content/{id}/episodes` - Create episode
- `PUT /api/content/{id}/episodes/{episodeId}` - Update episode
- `DELETE /api/content/{id}/episodes/{episodeId}` - Delete episode

---

## Notes

- Content can be single video (webinar) or multiple videos (episodes)
- Both types have title, description, telegram group link
- Episodes have their own title, description, materials
- Progress tracking only for multiple videos (episodes) - focus on episode watch status
- Video duration tracking is optional (not required for MVP)
- Access can be lifetime or time-limited with different pricing
- Videos must be private and accessible only to purchasers
- Budget constraint: $15/month for video hosting
- Materials (PDFs, docs, images) stored on same VPS as backend
- Materials served via backend API with access control

