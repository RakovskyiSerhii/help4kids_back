-- Migration: Create content management tables
-- This script creates tables for managing paid content (videos, courses, etc.)

-- 1. Contents Table
-- Stores main content information (single video or multi-episode content)
CREATE TABLE IF NOT EXISTS contents (
  id VARCHAR(36) PRIMARY KEY,
  title VARCHAR(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  description TEXT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  short_description TEXT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  telegram_group_url VARCHAR(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  cover_image_url VARCHAR(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  content_type ENUM('single_video', 'multi_episode') NOT NULL DEFAULT 'single_video',
  -- For single video content
  video_url VARCHAR(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  video_provider VARCHAR(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci, -- e.g., 'bunny', 'youtube', etc.
  -- Status and ordering
  featured BOOLEAN NOT NULL DEFAULT FALSE,
  ordering INT NOT NULL DEFAULT 0,
  is_active BOOLEAN NOT NULL DEFAULT TRUE,
  -- Metadata
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  created_by VARCHAR(36),
  updated_by VARCHAR(36),
  FOREIGN KEY (created_by) REFERENCES users(id),
  FOREIGN KEY (updated_by) REFERENCES users(id),
  INDEX idx_content_type (content_type),
  INDEX idx_featured (featured),
  INDEX idx_is_active (is_active)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- 2. Content Prices Table
-- Stores multiple price options for a single content (e.g., 100 UAH for 6 months, 400 UAH for lifetime)
CREATE TABLE IF NOT EXISTS content_prices (
  id VARCHAR(36) PRIMARY KEY,
  content_id VARCHAR(36) NOT NULL,
  price DECIMAL(10, 2) NOT NULL,
  currency VARCHAR(3) NOT NULL DEFAULT 'UAH',
  access_type ENUM('lifetime', 'time_limited') NOT NULL DEFAULT 'lifetime',
  access_duration_months INT NULL, -- NULL for lifetime, number of months for time_limited
  description VARCHAR(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci, -- e.g., "Доступ на 6 місяців"
  is_default BOOLEAN NOT NULL DEFAULT FALSE, -- One price should be default
  ordering INT NOT NULL DEFAULT 0,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY (content_id) REFERENCES contents(id) ON DELETE CASCADE,
  INDEX idx_content_id (content_id),
  INDEX idx_is_default (is_default)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- 3. Episodes Table
-- Stores episodes for multi-episode content
CREATE TABLE IF NOT EXISTS episodes (
  id VARCHAR(36) PRIMARY KEY,
  content_id VARCHAR(36) NOT NULL,
  title VARCHAR(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  description TEXT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  video_url VARCHAR(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  video_provider VARCHAR(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  ordering INT NOT NULL DEFAULT 0,
  duration_seconds INT, -- Video duration in seconds
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  created_by VARCHAR(36),
  updated_by VARCHAR(36),
  FOREIGN KEY (content_id) REFERENCES contents(id) ON DELETE CASCADE,
  FOREIGN KEY (created_by) REFERENCES users(id),
  FOREIGN KEY (updated_by) REFERENCES users(id),
  INDEX idx_content_id (content_id),
  INDEX idx_ordering (content_id, ordering)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- 4. Content Materials Table
-- Stores materials (PDFs, documents, images, links) for content or episodes
CREATE TABLE IF NOT EXISTS content_materials (
  id VARCHAR(36) PRIMARY KEY,
  content_id VARCHAR(36) NULL, -- NULL if attached to episode
  episode_id VARCHAR(36) NULL, -- NULL if attached to content
  material_type ENUM('pdf', 'document', 'image', 'link', 'other') NOT NULL,
  title VARCHAR(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  description TEXT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  file_url VARCHAR(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci, -- For files stored on server
  external_url VARCHAR(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci, -- For external links
  file_size_bytes BIGINT, -- File size in bytes
  mime_type VARCHAR(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  ordering INT NOT NULL DEFAULT 0,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  created_by VARCHAR(36),
  FOREIGN KEY (content_id) REFERENCES contents(id) ON DELETE CASCADE,
  FOREIGN KEY (episode_id) REFERENCES episodes(id) ON DELETE CASCADE,
  FOREIGN KEY (created_by) REFERENCES users(id),
  -- Ensure material is attached to either content or episode, but not both
  CONSTRAINT chk_content_or_episode CHECK (
    (content_id IS NOT NULL AND episode_id IS NULL) OR
    (content_id IS NULL AND episode_id IS NOT NULL)
  ),
  INDEX idx_content_id (content_id),
  INDEX idx_episode_id (episode_id)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- 5. User Content Access Table
-- Tracks which users have access to which content and when access expires
CREATE TABLE IF NOT EXISTS user_content_access (
  id VARCHAR(36) PRIMARY KEY,
  user_id VARCHAR(36) NOT NULL,
  content_id VARCHAR(36) NOT NULL,
  content_price_id VARCHAR(36) NOT NULL, -- Which price option was purchased
  order_id VARCHAR(36) NULL, -- Link to order if purchased through system
  access_type ENUM('lifetime', 'time_limited') NOT NULL,
  access_granted_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  access_expires_at TIMESTAMP NULL, -- NULL for lifetime access
  is_active BOOLEAN NOT NULL DEFAULT TRUE, -- Can be deactivated for refunds
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
  FOREIGN KEY (content_id) REFERENCES contents(id) ON DELETE CASCADE,
  FOREIGN KEY (content_price_id) REFERENCES content_prices(id),
  FOREIGN KEY (order_id) REFERENCES orders(id),
  INDEX idx_user_id (user_id),
  INDEX idx_content_id (content_id),
  INDEX idx_user_content (user_id, content_id),
  INDEX idx_expires_at (access_expires_at)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- 6. Episode Progress Table
-- Tracks which episodes a user has watched (for multi-episode content)
CREATE TABLE IF NOT EXISTS episode_progress (
  id VARCHAR(36) PRIMARY KEY,
  user_id VARCHAR(36) NOT NULL,
  episode_id VARCHAR(36) NOT NULL,
  watched_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  progress_percentage INT DEFAULT 0, -- 0-100, how much of episode was watched
  last_position_seconds INT DEFAULT 0, -- Last watched position in seconds
  is_completed BOOLEAN NOT NULL DEFAULT FALSE,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
  FOREIGN KEY (episode_id) REFERENCES episodes(id) ON DELETE CASCADE,
  UNIQUE KEY unique_user_episode (user_id, episode_id),
  INDEX idx_user_id (user_id),
  INDEX idx_episode_id (episode_id)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

