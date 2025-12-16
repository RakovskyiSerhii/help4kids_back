-- ============================================
-- Database Indexes for Performance Optimization
-- ============================================
-- Run this script after creating the database to add indexes
-- for frequently queried columns
-- ============================================

USE help4kids_db;

-- Users table indexes
CREATE INDEX idx_users_email ON users(email);
CREATE INDEX idx_users_role_id ON users(role_id);
CREATE INDEX idx_users_is_verified ON users(is_verified);

-- Orders table indexes
CREATE INDEX idx_orders_user_id ON orders(user_id);
CREATE INDEX idx_orders_status ON orders(status);
CREATE INDEX idx_orders_service_type ON orders(service_type);
CREATE INDEX idx_orders_service_id ON orders(service_id);
CREATE INDEX idx_orders_order_reference ON orders(order_reference);

-- Email verification indexes
CREATE INDEX idx_email_verification_token ON email_verification(token);
CREATE INDEX idx_email_verification_user_id ON email_verification(user_id);

-- Articles indexes
CREATE INDEX idx_articles_category_id ON articles(category_id);
CREATE INDEX idx_articles_featured ON articles(featured);

-- Saved articles indexes
CREATE INDEX idx_saved_articles_user_id ON saved_articles(user_id);
CREATE INDEX idx_saved_articles_article_id ON saved_articles(article_id);

-- Services indexes
CREATE INDEX idx_services_category_id ON services(category_id);
CREATE INDEX idx_services_featured ON services(featured);

-- Consultation appointments indexes
CREATE INDEX idx_consultation_appointments_consultation_id ON consultation_appointments(consultation_id);
CREATE INDEX idx_consultation_appointments_order_id ON consultation_appointments(order_id);
CREATE INDEX idx_consultation_appointments_datetime ON consultation_appointments(appointment_datetime);
CREATE INDEX idx_consultation_appointments_processed ON consultation_appointments(processed);
CREATE INDEX idx_consultation_appointments_processed_by ON consultation_appointments(processed_by);
CREATE INDEX idx_consultation_appointments_doctor_id ON consultation_appointments(doctor_id);
CREATE INDEX idx_consultation_appointments_created_at ON consultation_appointments(created_at);

-- Activity logs indexes
CREATE INDEX idx_activity_logs_user_id ON activity_logs(user_id);
CREATE INDEX idx_activity_logs_event_type ON activity_logs(event_type);
CREATE INDEX idx_activity_logs_event_timestamp ON activity_logs(event_timestamp);

-- Staff indexes
CREATE INDEX idx_staff_featured ON staff(featured);
CREATE INDEX idx_staff_ordering ON staff(ordering);

-- Courses indexes
CREATE INDEX idx_courses_featured ON courses(featured);

-- Consultations indexes
CREATE INDEX idx_consultations_featured ON consultations(featured);
CREATE INDEX idx_consultations_ordering ON consultations(ordering);

-- Service categories indexes
CREATE INDEX idx_service_categories_featured ON service_categories(featured);

-- Article categories indexes
CREATE INDEX idx_article_categories_featured ON article_categories(featured);

-- ============================================
-- Composite Indexes for Common Query Patterns
-- ============================================

-- For querying orders by user and status
CREATE INDEX idx_orders_user_status ON orders(user_id, status);

-- For querying featured content
CREATE INDEX idx_services_category_featured ON services(category_id, featured);
CREATE INDEX idx_articles_category_featured ON articles(category_id, featured);

-- ============================================
-- NOTES
-- ============================================
-- These indexes will improve query performance for:
-- 1. User lookups by email (login)
-- 2. Order queries by user
-- 3. Featured content queries
-- 4. Category-based filtering
-- 5. Token verification lookups
--
-- Monitor index usage with:
-- SHOW INDEX FROM table_name;
--
-- If indexes are not being used, consider removing them
-- as they add overhead to INSERT/UPDATE operations
-- ============================================

