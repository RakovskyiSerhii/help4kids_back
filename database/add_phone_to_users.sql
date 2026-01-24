-- Migration: Add phone number field to users table
-- Run this migration to add phone support to user profiles

ALTER TABLE users 
ADD COLUMN phone VARCHAR(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL 
AFTER last_name;

