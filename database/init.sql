-- ============================================
-- Help4Kids Database Initialization Script
-- ============================================
-- This script creates the database schema and inserts initial data
-- Run this script to set up a fresh database instance
-- ============================================

-- Drop existing database if it exists
DROP DATABASE IF EXISTS help4kids_db;

-- Create the database with utf8mb4 charset
CREATE DATABASE help4kids_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- Use the database
USE help4kids_db;

-- Set default charset for session
SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci;

-- ============================================
-- TABLE CREATION
-- ============================================

-- 1. Roles Table
CREATE TABLE roles (
  id VARCHAR(36) PRIMARY KEY,
  name VARCHAR(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL UNIQUE,
  description TEXT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- 2. Users Table
CREATE TABLE users (
  id VARCHAR(36) PRIMARY KEY,
  email VARCHAR(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL UNIQUE,
  password_hash TEXT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  first_name VARCHAR(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  last_name VARCHAR(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  role_id VARCHAR(36) NOT NULL,
  is_verified BOOLEAN NOT NULL DEFAULT FALSE,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  created_by VARCHAR(36),
  updated_by VARCHAR(36),
  FOREIGN KEY (role_id) REFERENCES roles(id)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- 3. Activity Logs Table
CREATE TABLE activity_logs (
  id VARCHAR(36) PRIMARY KEY,
  user_id VARCHAR(36) NOT NULL,
  event_type ENUM('registration','password_change','profile_update','role_change','course_purchase','article_save') NOT NULL,
  event_timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (user_id) REFERENCES users(id)
);

-- 4. Service Categories Table
CREATE TABLE service_categories (
  id VARCHAR(36) PRIMARY KEY,
  name VARCHAR(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  description TEXT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  iconUrl VARCHAR(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  featured BOOLEAN NOT NULL DEFAULT FALSE,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- 5. Services Table
CREATE TABLE services (
  id VARCHAR(36) PRIMARY KEY,
  category_id VARCHAR(36) NOT NULL,
  title VARCHAR(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  short_description TEXT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  long_description TEXT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  image VARCHAR(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  icon VARCHAR(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  price JSON NOT NULL,
  duration INT,
  featured BOOLEAN NOT NULL DEFAULT FALSE,
  ordering INT NOT NULL DEFAULT 0,
  booking_id VARCHAR(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  created_by VARCHAR(36),
  updated_by VARCHAR(36),
  FOREIGN KEY (category_id) REFERENCES service_categories(id) ON DELETE CASCADE
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- 6. Courses Table
CREATE TABLE courses (
  id VARCHAR(36) PRIMARY KEY,
  title VARCHAR(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  short_description TEXT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci, 
  description TEXT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  long_description TEXT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  image VARCHAR(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  icon VARCHAR(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  price DECIMAL(10,2) NOT NULL,
  duration INT,
  content_url VARCHAR(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  featured BOOLEAN NOT NULL DEFAULT FALSE,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  created_by VARCHAR(36),
  updated_by VARCHAR(36)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- 7. Consultations Table
CREATE TABLE consultations (
  id VARCHAR(36) PRIMARY KEY,
  title VARCHAR(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  short_description TEXT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci, 
  description TEXT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  price DECIMAL(10,2) NOT NULL,
  featured BOOLEAN NOT NULL DEFAULT FALSE,
  ordering INT NOT NULL DEFAULT 0,
  duration VARCHAR(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  question JSON,
  booking_id VARCHAR(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  payment_url VARCHAR(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  created_by VARCHAR(36),
  updated_by VARCHAR(36)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- 8. Orders Table
CREATE TABLE orders (
  id VARCHAR(36) PRIMARY KEY,
  user_id VARCHAR(36) NOT NULL,
  order_reference VARCHAR(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL UNIQUE,
  service_type ENUM('course','consultation','service') NOT NULL,
  service_id VARCHAR(36) NOT NULL,
  amount DECIMAL(10,2) NOT NULL,
  status ENUM('pending','paid','failed') NOT NULL DEFAULT 'pending',
  purchase_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY (user_id) REFERENCES users(id)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- 9. Consultation Appointments Table (created after staff table)
CREATE TABLE consultation_appointments (
  id VARCHAR(36) PRIMARY KEY,
  consultation_id VARCHAR(36) NOT NULL,
  appointment_datetime TIMESTAMP NOT NULL,
  details TEXT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  order_id VARCHAR(36) NOT NULL,
  -- Processing / dashboard fields
  processed BOOLEAN NOT NULL DEFAULT FALSE,
  processed_by VARCHAR(36),
  processed_at TIMESTAMP NULL,
  doctor_id VARCHAR(36),
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY (consultation_id) REFERENCES consultations(id),
  FOREIGN KEY (order_id) REFERENCES orders(id),
  FOREIGN KEY (processed_by) REFERENCES users(id)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- 10. Article Categories Table
CREATE TABLE article_categories (
  id VARCHAR(36) PRIMARY KEY,
  title VARCHAR(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  description TEXT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  featured BOOLEAN NOT NULL DEFAULT FALSE,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- 11. Articles Table
CREATE TABLE articles (
  id VARCHAR(36) PRIMARY KEY,
  title VARCHAR(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  content TEXT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  category_id VARCHAR(36) NOT NULL,
  long_description TEXT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  featured BOOLEAN NOT NULL DEFAULT FALSE,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  created_by VARCHAR(36),
  updated_by VARCHAR(36),
  FOREIGN KEY (category_id) REFERENCES article_categories(id)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- 12. Saved Articles Table
CREATE TABLE saved_articles (
  id VARCHAR(36) PRIMARY KEY,
  user_id VARCHAR(36) NOT NULL,
  article_id VARCHAR(36) NOT NULL,
  saved_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (user_id) REFERENCES users(id),
  FOREIGN KEY (article_id) REFERENCES articles(id)
);

-- 13. Email Verification Table
CREATE TABLE email_verification (
  id VARCHAR(36) PRIMARY KEY,
  user_id VARCHAR(36) NOT NULL,
  token VARCHAR(255) NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

-- 14. Staff Table
CREATE TABLE staff (
  id VARCHAR(36) PRIMARY KEY,
  name VARCHAR(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  content TEXT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  photo_url VARCHAR(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  featured BOOLEAN NOT NULL DEFAULT FALSE,
  ordering INT NOT NULL DEFAULT 0,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- Add foreign key for consultation_appointments.doctor_id after staff table is created
ALTER TABLE consultation_appointments ADD FOREIGN KEY (doctor_id) REFERENCES staff(id);

-- 15. Unit Table
CREATE TABLE unit (
  id VARCHAR(36) PRIMARY KEY,
  address VARCHAR(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  working_time JSON NOT NULL,
  contact_phone VARCHAR(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  social_url VARCHAR(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  email VARCHAR(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- 16. Social Contacts Table
CREATE TABLE social_contacts (
  id VARCHAR(36) PRIMARY KEY,
  url VARCHAR(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  name VARCHAR(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- 17. Finance Info Table
CREATE TABLE finance_info (
  id VARCHAR(36) PRIMARY KEY,
  t_number VARCHAR(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  name VARCHAR(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  official_address VARCHAR(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  actual_address VARCHAR(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- ============================================
-- INITIAL DATA INSERTION
-- ============================================

-- Insert Roles
INSERT IGNORE INTO roles (id, name, description)
VALUES
  ('00000000-0000-0000-0000-000000000001','god','God user with all privileges'),
  ('00000000-0000-0000-0000-000000000002','admin','Administrator with full privileges'),
  ('00000000-0000-0000-0000-000000000003','customer','Regular customer with limited access');

-- Insert initial users (one god, one admin) with simple bcrypt-hashed passwords.
-- Password for both users: "password"
INSERT IGNORE INTO users (
  id,
  email,
  password_hash,
  first_name,
  last_name,
  role_id,
  is_verified,
  created_at,
  updated_at
)
VALUES
  (
    '11111111-1111-1111-1111-111111111111',
    'god@help4kids.local',
    '$2b$10$CwTycUXWue0Thq9StjUM0uJ8e3.uV1YxDCEV4VpWw2X2gYdExgktO',
    'God',
    'User',
    '00000000-0000-0000-0000-000000000001', -- god role
    TRUE,
    NOW(),
    NOW()
  ),
  (
    '22222222-2222-2222-2222-222222222222',
    'admin@help4kids.local',
    '$2b$10$CwTycUXWue0Thq9StjUM0uJ8e3.uV1YxDCEV4VpWw2X2gYdExgktO',
    'Admin',
    'User',
    '00000000-0000-0000-0000-000000000002', -- admin role
    TRUE,
    NOW(),
    NOW()
  );

-- Insert Unit
INSERT INTO unit (
  id,
  address,
  working_time,
  contact_phone,
  social_url,
  email,
  created_at,
  updated_at
) VALUES (
  UUID(), 
  'м. Мерефа, вул Дніпровська 131, 3й поверх, офіс 4-5, Харківська обл, Харківський район, 62472', 
  '{"workdays": "8.00 – 18.00", "Saturday": "9.00 – 13.00", "Sunday": null}', 
  '+38(073)306-09-06', 
  'https://www.instagram.com/helpkids.merefa/',
  'merefa.help4kids@gmail.com', 
  NOW(), 
  NOW()
);

-- Insert Staff
INSERT INTO staff (id, name, content, photo_url, featured, ordering, created_at, updated_at)
VALUES 
(UUID(), 'Раковська Людмила Олександрівна', 'Керівник медичного центру. Лікар-педіатр, к.мед.н., доцент кафедри педіатрії. Консультант з дитячого сну з досвідом понад 25 років.', NULL, FALSE, 1, NOW(), NOW()),
(UUID(), 'Пономаренко Олена Вікторівна', 'Лікар УЗД, терапевт та дієтолог з досвідом понад 15 років. Проводить УЗД усіх органів та систем дорослим та дітям, а також консультує з харчування.', NULL, FALSE, 2, NOW(), NOW()),
(UUID(), 'Евтушенко Людмила Анатольевна', 'Лікар акушер-гінеколог та лікар УЗД з досвідом більше 15 років роботи у пологовому будинку та жіночій консультації.', NULL, FALSE, 3, NOW(), NOW());

-- Insert Social Contacts
INSERT INTO social_contacts (id, url, name, created_at, updated_at)
VALUES (UUID(), 'https://www.instagram.com/medhelp4kids/', 'medhelp4kids', NOW(), NOW());

INSERT INTO social_contacts (id, url, name, created_at, updated_at)
VALUES (UUID(), 'https://www.instagram.com/helpkids.merefa/', 'helpkids.merefa', NOW(), NOW());

INSERT INTO social_contacts (id, url, name, created_at, updated_at)
VALUES (UUID(), 'https://www.instagram.com/helpkids.alekseevka/', 'helpkids.alekseevka', NOW(), NOW());

-- Insert Finance Info
INSERT INTO finance_info (
  id,
  t_number,
  name,
  official_address,
  actual_address,
  created_at,
  updated_at
) VALUES (
  UUID(),
  '2442100984',
  'ФОП Раковська Л.О.',
  'вул. Трудова 14, смт Високий, Харківський район, Харківська обл',
  'Харківська обл., м.Мерефа, Вул. Дніпровська 131',
  NOW(),
  NOW()
);

-- Insert Service Categories and Services
-- Category 1: Консультативні прийоми лікарів-педіатрів в медичному центрі
SET @cat1 = UUID();
INSERT INTO service_categories (id, name, iconUrl, created_at, updated_at)
VALUES (@cat1, 'Консультативні прийоми лікарів-педіатрів в медичному центрі', 'ic_stethoscope.svg', NOW(), NOW());

INSERT INTO services (id, category_id, title, short_description, price, duration, created_at, updated_at)
VALUES 
(UUID(), @cat1, 'Консультація педіатра по хворобі (15-30 хв)', 'первинна/повторна', '{"price":600, "repeatPrice":550}', 15, NOW(), NOW()),
(UUID(), @cat1, 'Консультація педіатра розширена/щомісячний патронаж/первинний огляд новонародженого (45 хв)', NULL, '{"price":900}', 45, NOW(), NOW()),
(UUID(), @cat1, 'Консультація з рухового розвитку (45 хв)', NULL, '{"price":1200}', 45, NOW(), NOW()),
(UUID(), @cat1, 'Консультація педіатра, к.м.н. Раковської Людмили Олександрівни', 'первинна/повторна', '{"price":750, "repeatPrice":700}', NULL, NOW(), NOW()),
(UUID(), @cat1, 'Консультація к.м.н. Раковської Людмили Олександрівни розширена (60хв)', NULL, '{"price":1200}', 60, NOW(), NOW()),
(UUID(), @cat1, 'Консультація педіатра, к.м.н. Раковської Людмили Олександрівни патронаж/плановий огляд (40 хв)', NULL, '{"price":1000}', 40, NOW(), NOW()),
(UUID(), @cat1, 'Консультація зі сну (90хв)', 'Тільки онлайн', '{"price":2000}', 90, NOW(), NOW()),
(UUID(), @cat1, 'Повторна консультація зі сну (60хв)', 'Тільки онлайн', '{"price":1200}', 60, NOW(), NOW()),
(UUID(), @cat1, 'Онлайн підтримка педіатра Анастасії Сергіївни 3 місяці', 'Всі питання по хворобі/аналізам/харчуванню/розвитку в месенджері + 1 велика консультація/ місяць по телефону відео/аудіо формат', '{"price":4500}', NULL, NOW(), NOW()),
(UUID(), @cat1, 'Онлайн підтримка педіатра Анастасії Сергіївни 6 місяців', NULL, '{"price":7500}', NULL, NOW(), NOW()),
(UUID(), @cat1, 'Онлайн підтримка педіатра Анастасії Сергіївни 12 місяців', NULL, '{"price":14000}', NULL, NOW(), NOW());

-- Category 2: Гінекологія
SET @cat2 = UUID();
INSERT INTO service_categories (id, name, iconUrl, created_at, updated_at)
VALUES (@cat2, 'Гінекологія', 'ic_gynecology.svg', NOW(), NOW());

INSERT INTO services (id, category_id, title, price, created_at, updated_at)
VALUES 
(UUID(), @cat2, 'Консультауія гінеколога', '{"price":600}', NOW(), NOW()),
(UUID(), @cat2, 'Консультауія гінеколога по вагітності (хто на обліку)', '{"price":500}', NOW(), NOW()),
(UUID(), @cat2, 'УЗД органів малого тазу', '{"price":500}', NOW(), NOW()),
(UUID(), @cat2, 'Кольпоскопія', '{"price":400}', NOW(), NOW()),
(UUID(), @cat2, 'ПАП-тест класичний (мазок на склі)', '{"price":300}', NOW(), NOW()),
(UUID(), @cat2, 'ПАП-тест на основі рідинної цтології', '{"price":700}', NOW(), NOW()),
(UUID(), @cat2, 'Консультація+УЗД', '{"price":950}', NOW(), NOW()),
(UUID(), @cat2, 'Забір матеріалу на мікрофлору', '{"price":300}', NOW(), NOW()),
(UUID(), @cat2, 'Ph-метрія', '{"price":100}', NOW(), NOW()),
(UUID(), @cat2, 'Введення ВМС', '{"price":800}', NOW(), NOW()),
(UUID(), @cat2, 'Видалення ВМС', '{"price":600}', NOW(), NOW()),
(UUID(), @cat2, 'Конізація шийки матки', '{"price":2500}', NOW(), NOW()),
(UUID(), @cat2, 'Діагностичне вишкрібання порожнини матки', '{"price":2900}', NOW(), NOW()),
(UUID(), @cat2, 'Поліпектомія', '{"price":1200}', NOW(), NOW()),
(UUID(), @cat2, 'Введення маточного кільця', '{"price":350}', NOW(), NOW()),
(UUID(), @cat2, 'Роз''єднання синехій', '{"price":900}', NOW(), NOW()),
(UUID(), @cat2, 'Пайпель біопсія', '{"price":1500}', NOW(), NOW()),
(UUID(), @cat2, 'Медикаментозне переривання вагітності', '{"price":3500}', NOW(), NOW()),
(UUID(), @cat2, 'Вакуум аспірація шприцем', '{"price":2800}', NOW(), NOW()),
(UUID(), @cat2, 'Постановка на облік по вагітності', '{"price":3000}', NOW(), NOW());

-- Category 3: Кардіолог
SET @cat3 = UUID();
INSERT INTO service_categories (id, name, iconUrl, created_at, updated_at)
VALUES (@cat3, 'Кардіолог', 'ic_heart_pulse.svg', NOW(), NOW());

INSERT INTO services (id, category_id, title, price, created_at, updated_at)
VALUES 
(UUID(), @cat3, 'Прийом (30хв)', '{"price":600}', NOW(), NOW()),
(UUID(), @cat3, 'УЗД', '{"price":500}', NOW(), NOW()),
(UUID(), @cat3, 'Прийом + УЗД', '{"price":1000}', NOW(), NOW());

-- Category 4: Невролог
SET @cat4 = UUID();
INSERT INTO service_categories (id, name, iconUrl, created_at, updated_at)
VALUES (@cat4, 'Невролог', 'ic_brain.svg', NOW(), NOW());

INSERT INTO services (id, category_id, title, price, created_at, updated_at)
VALUES 
(UUID(), @cat4, 'Прийом (30хв)', '{"price":650}', NOW(), NOW()),
(UUID(), @cat4, 'Прийом + УЗД', '{"price":800}', NOW(), NOW()),
(UUID(), @cat4, 'Нейросонографія (узд головного мозку доки відкрит родничок)', '{"price":500}', NOW(), NOW()),
(UUID(), @cat4, 'ЕЕГ (20хв)', '{"customRangePrices": {"до 5 років":550, "після 5 років":450}, "price":0}', NOW(), NOW());

-- Category 5: Ортопед-травматолог
SET @cat5 = UUID();
INSERT INTO service_categories (id, name, iconUrl, created_at, updated_at)
VALUES (@cat5, 'Ортопед-травматолог', 'ic_bone.svg', NOW(), NOW());

INSERT INTO services (id, category_id, title, price, created_at, updated_at)
VALUES 
(UUID(), @cat5, 'Прийом (20хв)', '{"price":600}', NOW(), NOW()),
(UUID(), @cat5, 'УЗД', '{"price":500}', NOW(), NOW()),
(UUID(), @cat5, 'Прийом+УЗД', '{"price":1000}', NOW(), NOW());

-- Category 6: Хірург
SET @cat6 = UUID();
INSERT INTO service_categories (id, name, iconUrl, created_at, updated_at)
VALUES (@cat6, 'Хірург', 'ic_scalpel.svg', NOW(), NOW());

INSERT INTO services (id, category_id, title, price, created_at, updated_at)
VALUES 
(UUID(), @cat6, 'Прийом (15хв)', '{"price":600}', NOW(), NOW()),
(UUID(), @cat6, 'Виправлення фімоза', '{"price":600}', NOW(), NOW());

-- Category 7: Дерматолог
SET @cat7 = UUID();
INSERT INTO service_categories (id, name, iconUrl, created_at, updated_at)
VALUES (@cat7, 'Дерматолог', 'ic_skin.svg', NOW(), NOW());

INSERT INTO services (id, category_id, title, price, created_at, updated_at)
VALUES 
(UUID(), @cat7, 'Прийом', '{"price":600}', NOW(), NOW()),
(UUID(), @cat7, 'Прийом з дерматоскопією до 5 новоутворень', '{"price":700}', NOW(), NOW()),
(UUID(), @cat7, 'Прийом з дерматоскопією більше 5 новоутворень', '{"price":900}', NOW(), NOW()),
(UUID(), @cat7, 'Видалення родимки до 0,5 см (радіохвильовий аппарат)', '{"price":500}', NOW(), NOW()),
(UUID(), @cat7, 'Видалення родимки 0,6-1 см (радіохвильовий аппарат)', '{"price":650}', NOW(), NOW()),
(UUID(), @cat7, 'Видалення родимки < 1 см (радіохвильовий аппарат)', '{"price":800}', NOW(), NOW()),
(UUID(), @cat7, 'Видалення папіломи', '{"price":250}', NOW(), NOW()),
(UUID(), @cat7, 'Видалення папілом < 10 шт', '{"price":0, "customPriceString":"150/шт"}', NOW(), NOW()),
(UUID(), @cat7, 'Знеболення', '{"price":150}', NOW(), NOW());

-- Category 8: Фототерапія
SET @cat8 = UUID();
INSERT INTO service_categories (id, name, iconUrl, created_at, updated_at)
VALUES (@cat8, 'Фототерапія', 'ic_sun.svg', NOW(), NOW());

INSERT INTO services (id, category_id, title, price, created_at, updated_at)
VALUES 
(UUID(), @cat8, '1 сеанс', '{"price":300}', NOW(), NOW()),
(UUID(), @cat8, '5 сеансів', '{"price":0, "customPriceString":"по 250"}', NOW(), NOW()),
(UUID(), @cat8, '10 сеансів', '{"price":0, "customPriceString":"по 200"}', NOW(), NOW());

-- Category 9: УЗД діагностика
SET @cat9 = UUID();
INSERT INTO service_categories (id, name, iconUrl, created_at, updated_at)
VALUES (@cat9, 'УЗД діагностика', 'ic_monitor.svg', NOW(), NOW());

INSERT INTO services (id, category_id, title, price, created_at, updated_at)
VALUES 
(UUID(), @cat9, 'УЗД органів черевної порожнини (печінка, підшлункова залоза, жовчний міхур, жовчні протоки і селезінка)', '{"price":500}', NOW(), NOW()),
(UUID(), @cat9, 'УЗД одного органу черевної порожнини', '{"price":250}', NOW(), NOW()),
(UUID(), @cat9, 'УЗД серце ( +доплерографія)', '{"price":550}', NOW(), NOW()),
(UUID(), @cat9, 'УЗД нирки ( +доплерографія)', '{"price":400}', NOW(), NOW()),
(UUID(), @cat9, 'УЗД наднирники', '{"price":300}', NOW(), NOW()),
(UUID(), @cat9, 'УЗД щитоподібна залоза', '{"price":400}', NOW(), NOW()),
(UUID(), @cat9, 'УЗД молочних залоз', '{"price":400}', NOW(), NOW()),
(UUID(), @cat9, 'УЗД органів малого тазу', '{"price":500}', NOW(), NOW()),
(UUID(), @cat9, 'УЗД простата', '{"price":450}', NOW(), NOW()),
(UUID(), @cat9, 'УЗД калитки (мошонка)', '{"price":400}', NOW(), NOW()),
(UUID(), @cat9, 'УЗД лімфатичних вузлів (зона)', '{"price":300}', NOW(), NOW()),
(UUID(), @cat9, 'УЗД лімфатичних вузлів (комплекс)', '{"price":550}', NOW(), NOW()),
(UUID(), @cat9, 'УЗД судин шиї ( +доплерографія)', '{"price":500}', NOW(), NOW()),
(UUID(), @cat9, 'УЗД легені', '{"price":500}', NOW(), NOW()),
(UUID(), @cat9, 'УЗД нирки + сечовий міхур', '{"price":550}', NOW(), NOW()),
(UUID(), @cat9, 'УЗД органів черевної порожнини + нирки', '{"price":800}', NOW(), NOW()),
(UUID(), @cat9, 'УЗД органів черевної порожнини + нирки + щитоподібна залоза', '{"price":1000}', NOW(), NOW()),
(UUID(), @cat9, 'УЗД органів черевної порожнини + нирки + щитоподібна залоза + серце', '{"price":1500}', NOW(), NOW());

-- Category 10: Оформлення довідок
SET @cat10 = UUID();
INSERT INTO service_categories (id, name, iconUrl, created_at, updated_at)
VALUES (@cat10, 'Оформлення довідок', 'ic_document.svg', NOW(), NOW());

INSERT INTO services (id, category_id, title, short_description, price, duration, created_at, updated_at)
VALUES 
(UUID(), @cat10, 'Оформлення довідки 086 для вступу в дитячий садок, школу (медогляд)', 'При собі потрібно мати форму 063 або фото щеплень за віком або паспорт вакцинації; Огляд включає: оцінку стану здоров''я, вимірювання зросту і ваги, перевірка зору, слуху, постави, рекомендації по аналізам та подальшим щепленням за потреби.', '{"price":1000}', NULL, NOW(), NOW()),
(UUID(), @cat10, 'Оформлення довідки в бассейн', 'тільки за умови огляду дитини педіатром; Попередньо слід здати кал на яйця глистів або зішкріб на ентеробіоз в будь-якій лабораторії і з результатами записатися на прийом до нас', '{"price":0, "customPriceString":"безкоштовно"}', NULL, NOW(), NOW()),
(UUID(), @cat10, 'Оформлення довідки 063 про щеплення', 'при проведенні трьох і більше щеплень в медцентрі - безкоштовно', '{"price":300}', NULL, NOW(), NOW()),
(UUID(), @cat10, 'Оформлення довідки 063 про щеплення на англ. мові', NULL, '{"price":600}', NULL, NOW(), NOW()),
(UUID(), @cat10, 'Оформлення міжнародного паспорту вакцинації з перенесенням попередніх вакцин', 'при проведенні першої вакцинації в нашому МЦ - безкоштовно', '{"price":500}', NULL, NOW(), NOW()),
(UUID(), @cat10, 'Видача довідок в дитячий садок або школу після хвороби', 'за умови спостереження лікарем медичного центру під час хвороби', '{"price":0, "customPriceString":"безкоштовно"}', NULL, NOW(), NOW()),
(UUID(), @cat10, 'Видача довідки в дитячий табір (форма 079/о)', 'при огляді дитини на консультації', '{"price":0, "customPriceString":"безкоштовно"}', NULL, NOW(), NOW());

-- Category 11: Експрес-тести
SET @cat11 = UUID();
INSERT INTO service_categories (id, name, iconUrl, created_at, updated_at)
VALUES (@cat11, 'Експрес-тести', 'ic_flask.svg', NOW(), NOW());

INSERT INTO services (id, category_id, title, short_description, price, duration, created_at, updated_at)
VALUES 
(UUID(), @cat11, 'Експрес-тест на виявлення стрептококу гр А', 'мазок з носоглотки', '{"price":250}', NULL, NOW(), NOW()),
(UUID(), @cat11, 'Тест на виявлення грипу А/В', 'мазок з носоглотки', '{"price":250}', NULL, NOW(), NOW()),
(UUID(), @cat11, 'Швидкий тест на виявлення Ковід', 'мазок з носоглотки', '{"price":0}', NULL, NOW(), NOW()),
(UUID(), @cat11, 'Швидкий тест на виявлення грип + Ковід (4в1)', 'мазок з носоглотки', '{"price":300}', NULL, NOW(), NOW()),
(UUID(), @cat11, 'Швидкий тест для визначення с-реактивного білка', 'аналіз крові з пальця', '{"price":250}', NULL, NOW(), NOW()),
(UUID(), @cat11, 'Швидкий тест на віт Д', 'аналіз крові з пальця', '{"price":250}', NULL, NOW(), NOW()),
(UUID(), @cat11, 'Швидкий тест на феритин', 'аналіз крові з пальця', '{"price":250}', NULL, NOW(), NOW()),
(UUID(), @cat11, 'Експрес-тест сечі на ацетон', NULL, '{"price":50}', NULL, NOW(), NOW()),
(UUID(), @cat11, 'Експрес-тест сечі 10 параметрів', 'лейкоцити, нітріти, білок, рН кров (клітини еритроцитів), глюкоза, питома вага, уробіліноген, кетони, білірубін', '{"price":100}', NULL, NOW(), NOW()),
(UUID(), @cat11, 'Експрес-тест на тропонін І', 'немає наразі', '{"price":0}', NULL, NOW(), NOW());

-- Category 12: Тест глюкоза
SET @cat12 = UUID();
INSERT INTO service_categories (id, name, iconUrl, created_at, updated_at)
VALUES (@cat12, 'Тест глюкоза', 'ic_glucose.svg', NOW(), NOW());

INSERT INTO services (id, category_id, title, price, created_at, updated_at)
VALUES (UUID(), @cat12, 'Тест глюкоза', '{"price":150}', NOW(), NOW());

-- Category 13: Клініка крові
SET @cat13 = UUID();
INSERT INTO service_categories (id, name, iconUrl, created_at, updated_at)
VALUES (@cat13, 'Клініка крові', 'ic_blood.svg', NOW(), NOW());

INSERT INTO services (id, category_id, title, price, created_at, updated_at)
VALUES (UUID(), @cat13, 'Клініка крові', '{"price":260}', NOW(), NOW());

-- Category 14: Клініка сечі
SET @cat14 = UUID();
INSERT INTO service_categories (id, name, iconUrl, created_at, updated_at)
VALUES (@cat14, 'Клініка сечі', 'ic_urine.svg', NOW(), NOW());

INSERT INTO services (id, category_id, title, price, created_at, updated_at)
VALUES (UUID(), @cat14, 'Клініка сечі', '{"price":150}', NOW(), NOW());

-- Category 15: ЕКГ з розшифровкою
SET @cat15 = UUID();
INSERT INTO service_categories (id, name, iconUrl, created_at, updated_at)
VALUES (@cat15, 'ЕКГ з розшифровкою', 'ic_ecg.svg', NOW(), NOW());

INSERT INTO services (id, category_id, title, price, created_at, updated_at)
VALUES (UUID(), @cat15, 'ЕКГ з розшифровкою', '{"price":200}', NOW(), NOW());

-- Category 16: Маніпуляції
SET @cat16 = UUID();
INSERT INTO service_categories (id, name, iconUrl, created_at, updated_at)
VALUES (@cat16, 'Маніпуляції', 'ic_syringe.svg', NOW(), NOW());

INSERT INTO services (id, category_id, title, short_description, price, duration, created_at, updated_at)
VALUES 
(UUID(), @cat16, 'Внутрішньом''язова або підшкірна ін''єкції', 'вартість препарату сплачується окремо', '{"price":100}', NULL, NOW(), NOW()),
(UUID(), @cat16, 'Внутрішньовенна інʼєкція', NULL, '{"price":200}', NULL, NOW(), NOW()),
(UUID(), @cat16, 'Введення протиблювотного препарату (в/м)', 'вартість препарату враховано', '{"price":200}', NULL, NOW(), NOW()),
(UUID(), @cat16, 'Введення жарознижувального препарату (в/м)', 'вартість препарату враховано', '{"price":200}', NULL, NOW(), NOW()),
(UUID(), @cat16, 'Видалення кліща', NULL, '{"price":700}', NULL, NOW(), NOW()),
(UUID(), @cat16, 'Промивання носа', 'вартість шприца для промивання враховано', '{"price":150}', NULL, NOW(), NOW()),
(UUID(), @cat16, 'Промивання вух', 'вартість шприца для промивання враховано', '{"price":150}', NULL, NOW(), NOW()),
(UUID(), @cat16, 'Оренда спейсера', 'тиждень', '{"price":150}', NULL, NOW(), NOW()),
(UUID(), @cat16, 'Оренда небулайзера', 'тиждень', '{"price":250}', NULL, NOW(), NOW());

-- Category 17: Прокол вух (система Studex75)
SET @cat17 = UUID();
INSERT INTO service_categories (id, name, iconUrl, created_at, updated_at)
VALUES (@cat17, 'Прокол вух (система Studex75)', 'ic_gem.svg', NOW(), NOW());

INSERT INTO services (id, category_id, title, short_description, price, duration, created_at, updated_at)
VALUES 
(UUID(), @cat17, 'Прокол', NULL, '{"price":800}', NULL, NOW(), NOW()),
(UUID(), @cat17, 'Прокол 1 вуха', NULL, '{"price":500}', NULL, NOW(), NOW()),
(UUID(), @cat17, 'Сережки', NULL, '{"price":0, "customPriceString":"від 500"}', NULL, NOW(), NOW());

-- Category 18: Вакцинація
SET @cat18 = UUID();
INSERT INTO service_categories (id, name, iconUrl, created_at, updated_at)
VALUES (@cat18, 'Вакцинація', 'ic_syringe.svg', NOW(), NOW());

INSERT INTO services (id, category_id, title, short_description, price, duration, created_at, updated_at)
VALUES 
(UUID(), @cat18, 'Гексаксим АаКДП+ІПВ+ХІБ+гепВ (Франція) (правець, дифтерія, кашлюк, поліоміеліт, гепатит В, гемофільна інфекція) до 2х років', NULL, '{"price":2400}', NULL, NOW(), NOW()),
(UUID(), @cat18, 'Інфанрикс Гекса АаКДП+ІПВ+ХІБ+гепВ (Бельгія) (правець, дифтерія, кашлюк, поліоміеліт, гепатит В, гемофільна інфекція) до 36 місяців', NULL, '{"price":2600}', NULL, NOW(), NOW()),
(UUID(), @cat18, 'Пентаксим АаКДП+ІПВ+ХІБ (Франція) (правець, дифтерія, кашлюк, поліоміеліт, гемофільна інфекція) до 4 років 11 міс', NULL, '{"price":2200}', NULL, NOW(), NOW()),
(UUID(), @cat18, 'Інфанрикс ІПВ ХІБ АаКДП+ІПВ+ХІБ  (Бельгія) (правець, дифтерія, кашлюк, поліоміеліт, гемофільна інфекція) до 3х років', NULL, '{"price":2400}', NULL, NOW(), NOW()),
(UUID(), @cat18, 'Бустрикс Поліо АаКДП+ІПВ (Бельгія) (правець, дифтерія, кашлюк + поліоміеліт) (з 3 років)', NULL, '{"price":1900}', NULL, NOW(), NOW()),
(UUID(), @cat18, 'Тетраксим АаКДП+ІПВ (Франція) (правець, дифтерія, кашлюк + поліоміеліт) до 6 років 11 місяц', NULL, '{"price":2000}', NULL, NOW(), NOW()),
(UUID(), @cat18, 'Інфанрикс ІПВ АаКДП+ІПВ (Бельгія) (правець, дифтерія, кашлюк + поліоміеліт) до 13 років', NULL, '{"price":2100}', NULL, NOW(), NOW()),
(UUID(), @cat18, 'Бустрикс (Бельгія) (правець, дифтерія, кашлюк)', NULL, '{"price":1700}', NULL, NOW(), NOW()),
(UUID(), @cat18, 'Інфанрикс АаКДП (Бельгія) (правець, дифтерія, кашлюк) до 6 років 11 місяців', NULL, '{"price":1700}', NULL, NOW(), NOW()),
(UUID(), @cat18, 'Пріорикс (Бельгія) (кір, паротит, краснуха)', NULL, '{"price":1700}', NULL, NOW(), NOW()),
(UUID(), @cat18, 'М-М-РВАКСПРО (США) (кір, паротит, краснуха)', NULL, '{"price":0}', NULL, NOW(), NOW()),
(UUID(), @cat18, 'Ротарикс (Бельгія) (3 штами / 2 дози до 5,5 місяців)', NULL, '{"price":1800}', NULL, NOW(), NOW()),
(UUID(), @cat18, 'Ротатек (США)  (5 штамів / 3 дози до 8 місяців)', NULL, '{"price":2000}', NULL, NOW(), NOW()),
(UUID(), @cat18, 'Менактра (США) (менінгокок)', NULL, '{"price":0}', NULL, NOW(), NOW()),
(UUID(), @cat18, 'Німенрикс (Бельгія) (менінгокок)', NULL, '{"price":2700}', NULL, NOW(), NOW()),
(UUID(), @cat18, 'Бексеро () (менінгокок В)', NULL, '{"price":4750}', NULL, NOW(), NOW()),
(UUID(), @cat18, 'Синфлорикс (Бельгія) (пневмокок 10 серотипів)', NULL, '{"price":2500}', NULL, NOW(), NOW()),
(UUID(), @cat18, 'Превенар 13 (Великобританія) (пневмокок 13 серотипів)', NULL, '{"price":3700}', NULL, NOW(), NOW()),
(UUID(), @cat18, 'Ваксньюванс (Нідерланди) (пневмокок 15 серотипів)', NULL, '{"price":3650}', NULL, NOW(), NOW()),
(UUID(), @cat18, 'Церварикс (Бельгія) (папіломавірус 16 і 18 типів)', NULL, '{"price":2500}', NULL, NOW(), NOW()),
(UUID(), @cat18, 'Гардасил (США) (папіломавірус 6, 11, 16 і 18 типів)', NULL, '{"price":6100}', NULL, NOW(), NOW()),
(UUID(), @cat18, 'Гардасил 9', NULL, '{"price":6800}', NULL, NOW(), NOW()),
(UUID(), @cat18, 'Хаврикс 720 (Бельгія) (гепатит А)', NULL, '{"price":1700}', NULL, NOW(), NOW()),
(UUID(), @cat18, 'Хаврикс 1440(Бельгія) (гепатит А)', NULL, '{"price":1800}', NULL, NOW(), NOW()),
(UUID(), @cat18, 'Твінрикс (Бельгія) (гепатит А+В)', NULL, '{"price":2400}', NULL, NOW(), NOW()),
(UUID(), @cat18, 'Енджерикс дитячий 0,5мл', NULL, '{"price":1100}', NULL, NOW(), NOW()),
(UUID(), @cat18, 'Енджерикс дорослий 1мл', NULL, '{"price":1250}', NULL, NOW(), NOW()),
(UUID(), @cat18, 'Хіберікс (Бельгія) (гемофільна інфекція)', NULL, '{"price":0}', NULL, NOW(), NOW()),
(UUID(), @cat18, 'Варілрикс (Бельгія) (вітряна віспа)', NULL, '{"price":2500}', NULL, NOW(), NOW()),
(UUID(), @cat18, 'Варівакс (Нідерланди) (вітряна віспа)', NULL, '{"price":4000}', NULL, NOW(), NOW()),
(UUID(), @cat18, 'Ваксігрип (Франція)', NULL, '{"price":0}', NULL, NOW(), NOW()),
(UUID(), @cat18, 'Джи Сі Флю (Корея)', NULL, '{"price":950}', NULL, NOW(), NOW());

-- Category 19: Послуга вакцинації вакциєю, придбаною особисто
SET @cat19 = UUID();
INSERT INTO service_categories (id, name, iconUrl, created_at, updated_at)
VALUES (@cat19, 'Послуга вакцинації вакциєю, придбаною особисто', 'ic_syringe.svg', NOW(), NOW());

INSERT INTO services (id, category_id, title, short_description, price, duration, created_at, updated_at)
VALUES 
(UUID(), @cat19, 'Послуга вакцинації вакциною, придбаною особисто', NULL, '{"price":0, "customPriceString":"Вартість консультації лікаря + 100 грн введення внутрішньом''язової ін''єкції.За наявності чеку з аптеки та сертифікату на вакцину, а також за умови доставки вакцини з виконанням вимог холодового ланцюга."}', NULL, NOW(), NOW());

-- Insert Consultations
INSERT INTO consultations (
  id,
  title,
  short_description,
  description,
  price,
  featured,
  ordering,
  duration,
  question,
  payment_url,
  created_at,
  updated_at
)
VALUES
(
  UUID(),
  'Консультація зі сну',
  'Консультація з питань дитячого сну:\n\nпопередній аналіз анкети та щоденника сну\n\nконсультація тривалістю півтори години\n\nпідтримка протягом одного тижня з відповідями на уточнюючі запитання',
  'Якщо ваша дитина має проблеми зі сном – запишіться на консультацію по сну і ви отримаєте відповіді на питання:',
  2000,
  FALSE,
  0,
  '1 година',
  '["Що робити щоб малюк краще спав?", "Як розділити грудне годування та засинання?", "Як навчити дитину спокійно засинати з мінімальною вашою допомогою, або самостійно?", "Як перестати носити на руках/колисати/гойдати/стрибати/годувати для того, щоб дитина заснула?", "Як перестати годувати вночі?", "Як перевести дитину спати в окреме ліжко?", "Як налагодити правильний режим?"]',
  'https://secure.wayforpay.com/button/b60f66fd4231b',
  NOW(),
  NOW()
),
(
  UUID(),
  'Консультація з годування',
  NULL,
  'Якщо ви маєте питання або проблеми з годуванням дитини, або хочете більш детально дізнатись про розвиток – запишіться на онлайн консультацію. Ви отримаєте відповіді на питання:',
  1200,
  FALSE,
  0,
  '1 година',
  '["Як правильно та безпечно ввести прикорм?", "Як покращити апетит дитині?", "Як привчити дитину до здорового харчування?", "Що робити, якщо ваша дитина малоїжка?", "Як зрозуміти, чи нормально розвинута ваша дитина?"]',
  'https://secure.wayforpay.com/button/bcd819561e16e',
  NOW(),
  NOW()
),
(
  UUID(),
  'Онлайн консультація',
  NULL,
  'Якщо ваша дитина захворіла і ви не маєте можливості звернутись до лікаря, замовте онлайн-консультацію і ви отримаєте відповіді на питання:',
  700,
  FALSE,
  0,
  '30 хвилин',
  '["Що робити при гострому захворюванні?", "Як знизити температуру?", "Що робити, коли в дитини блювання та пронос?", "Що означають результати аналізів вашої дитини?", "До якого спеціаліста звернутись з вашою проблемою?"]',
  'https://secure.wayforpay.com/button/b8b749ca79951',
  NOW(),
  NOW()
);

-- Update all services' updated_at to 14.01.2026
UPDATE services SET updated_at = '2026-01-14';

-- ============================================
-- SCRIPT COMPLETED
-- ============================================
-- Database 'help4kids_db' has been created with all tables and initial data
-- ============================================

