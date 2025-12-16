-- ============================================
-- Help4Kids Database Initialization Script
-- ============================================
-- This script creates the database schema and inserts initial data
-- Run this script to set up a fresh database instance
-- ============================================

-- Drop existing database if it exists
DROP DATABASE IF EXISTS help4kids_db;

-- Create the database
CREATE DATABASE help4kids_db;

-- Use the database
USE help4kids_db;

-- ============================================
-- TABLE CREATION
-- ============================================

-- 1. Roles Table
CREATE TABLE roles (
  id VARCHAR(36) PRIMARY KEY,
  name VARCHAR(50) NOT NULL UNIQUE,
  description TEXT
);

-- 2. Users Table
CREATE TABLE users (
  id VARCHAR(36) PRIMARY KEY,
  email VARCHAR(255) NOT NULL UNIQUE,
  password_hash TEXT NOT NULL,
  first_name VARCHAR(100) NOT NULL,
  last_name VARCHAR(100) NOT NULL,
  role_id VARCHAR(36) NOT NULL,
  is_verified BOOLEAN NOT NULL DEFAULT FALSE,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  created_by VARCHAR(36),
  updated_by VARCHAR(36),
  FOREIGN KEY (role_id) REFERENCES roles(id)
);

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
  name VARCHAR(255) NOT NULL,
  description TEXT,
  iconUrl VARCHAR(255),
  featured BOOLEAN NOT NULL DEFAULT FALSE,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- 5. Services Table
CREATE TABLE services (
  id VARCHAR(36) PRIMARY KEY,
  category_id VARCHAR(36) NOT NULL,
  title VARCHAR(255) NOT NULL,
  short_description TEXT,
  long_description TEXT,
  image VARCHAR(255),
  icon VARCHAR(255),
  price JSON NOT NULL,
  duration INT,
  featured BOOLEAN NOT NULL DEFAULT FALSE,
  ordering INT NOT NULL DEFAULT 0,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  created_by VARCHAR(36),
  updated_by VARCHAR(36),
  FOREIGN KEY (category_id) REFERENCES service_categories(id) ON DELETE CASCADE
);

-- 6. Courses Table
CREATE TABLE courses (
  id VARCHAR(36) PRIMARY KEY,
  title VARCHAR(255) NOT NULL,
  short_description TEXT, 
  description TEXT,
  long_description TEXT,
  image VARCHAR(255),
  icon VARCHAR(255) NOT NULL,
  price DECIMAL(10,2) NOT NULL,
  duration INT,
  content_url VARCHAR(255) NOT NULL,
  featured BOOLEAN NOT NULL DEFAULT FALSE,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  created_by VARCHAR(36),
  updated_by VARCHAR(36)
);

-- 7. Consultations Table
CREATE TABLE consultations (
  id VARCHAR(36) PRIMARY KEY,
  title VARCHAR(255) NOT NULL,
  short_description TEXT, 
  description TEXT,
  price DECIMAL(10,2) NOT NULL,
  featured BOOLEAN NOT NULL DEFAULT FALSE,
  ordering INT NOT NULL DEFAULT 0,
  duration VARCHAR(255) DEFAULT NULL,
  question JSON,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  created_by VARCHAR(36),
  updated_by VARCHAR(36)
);

-- 8. Orders Table
CREATE TABLE orders (
  id VARCHAR(36) PRIMARY KEY,
  user_id VARCHAR(36) NOT NULL,
  order_reference VARCHAR(255) NOT NULL UNIQUE,
  service_type ENUM('course','consultation','service') NOT NULL,
  service_id VARCHAR(36) NOT NULL,
  amount DECIMAL(10,2) NOT NULL,
  status ENUM('pending','paid','failed') NOT NULL DEFAULT 'pending',
  purchase_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY (user_id) REFERENCES users(id)
);

-- 9. Consultation Appointments Table
CREATE TABLE consultation_appointments (
  id VARCHAR(36) PRIMARY KEY,
  consultation_id VARCHAR(36) NOT NULL,
  appointment_datetime TIMESTAMP NOT NULL,
  details TEXT,
  order_id VARCHAR(36) NOT NULL,
  FOREIGN KEY (consultation_id) REFERENCES consultations(id),
  FOREIGN KEY (order_id) REFERENCES orders(id)
);

-- 10. Article Categories Table
CREATE TABLE article_categories (
  id VARCHAR(36) PRIMARY KEY,
  title VARCHAR(255) NOT NULL,
  description TEXT,
  featured BOOLEAN NOT NULL DEFAULT FALSE,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- 11. Articles Table
CREATE TABLE articles (
  id VARCHAR(36) PRIMARY KEY,
  title VARCHAR(255) NOT NULL,
  content TEXT NOT NULL,
  category_id VARCHAR(36) NOT NULL,
  long_description TEXT,
  featured BOOLEAN NOT NULL DEFAULT FALSE,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  created_by VARCHAR(36),
  updated_by VARCHAR(36),
  FOREIGN KEY (category_id) REFERENCES article_categories(id)
);

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
  name VARCHAR(255) NOT NULL,
  content TEXT,
  photo_url VARCHAR(255),
  featured BOOLEAN NOT NULL DEFAULT FALSE,
  ordering INT NOT NULL DEFAULT 0,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- 15. Unit Table
CREATE TABLE unit (
  id VARCHAR(36) PRIMARY KEY,
  address VARCHAR(255) NOT NULL,
  working_time JSON NOT NULL,
  contact_phone VARCHAR(50) NOT NULL,
  social_url VARCHAR(255),
  email VARCHAR(255) NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- 16. Social Contacts Table
CREATE TABLE social_contacts (
  id VARCHAR(36) PRIMARY KEY,
  url VARCHAR(255) NOT NULL,
  name VARCHAR(100) NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- 17. Finance Info Table
CREATE TABLE finance_info (
  id VARCHAR(36) PRIMARY KEY,
  t_number VARCHAR(100) NOT NULL,
  name VARCHAR(255) NOT NULL,
  official_address VARCHAR(255) NOT NULL,
  actual_address VARCHAR(255) NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

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
INSERT INTO service_categories (id, name, created_at, updated_at)
VALUES (@cat1, 'Консультативні прийоми лікарів-педіатрів в медичному центрі', NOW(), NOW());

INSERT INTO services (id, category_id, title, price, created_at, updated_at)
VALUES 
(UUID(), @cat1, 'Консультація педіатра', '{"price":600, "repeatPrice":500}', NOW(), NOW()),
(UUID(), @cat1, 'Консультація педіатра розширена (40-60 хв)', '{"price":700}', NOW(), NOW()),
(UUID(), @cat1, 'Консультація педіатра, к.м.н. Раковської Людмили Олександрівни', '{"price":700, "repeatPrice":600}', NOW(), NOW()),
(UUID(), @cat1, 'Консультація педіатра, к.м.н. Раковської Людмили Олександрівни 40 хв', '{"price":800}', NOW(), NOW()),
(UUID(), @cat1, 'Консультація к.м.н. Раковської Людмили Олександрівни розширена (до 60хв)', '{"price":1200}', NOW(), NOW());

-- Category 2: Гінекологія
SET @cat2 = UUID();
INSERT INTO service_categories (id, name, created_at, updated_at)
VALUES (@cat2, 'Гінекологія', NOW(), NOW());

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
INSERT INTO service_categories (id, name, created_at, updated_at)
VALUES (@cat3, 'Кардіолог', NOW(), NOW());

INSERT INTO services (id, category_id, title, price, created_at, updated_at)
VALUES 
(UUID(), @cat3, 'Прийом (30хв)', '{"price":600}', NOW(), NOW()),
(UUID(), @cat3, 'УЗД', '{"price":500}', NOW(), NOW()),
(UUID(), @cat3, 'Прийом + УЗД', '{"price":1000}', NOW(), NOW());

-- Category 4: Невролог
SET @cat4 = UUID();
INSERT INTO service_categories (id, name, created_at, updated_at)
VALUES (@cat4, 'Невролог', NOW(), NOW());

INSERT INTO services (id, category_id, title, price, created_at, updated_at)
VALUES 
(UUID(), @cat4, 'Прийом (30хв)', '{"price":650}', NOW(), NOW()),
(UUID(), @cat4, 'Прийом + УЗД', '{"price":800}', NOW(), NOW()),
(UUID(), @cat4, 'Нейросонографія (узд головного мозку доки відкрит родничок)', '{"price":500}', NOW(), NOW()),
(UUID(), @cat4, 'ЕЕГ (20хв)', '{"customRangePrices": {"до 5 років":550, "після 5 років":450}, "price":0}', NOW(), NOW());

-- Category 5: Ортопед-травматолог
SET @cat5 = UUID();
INSERT INTO service_categories (id, name, created_at, updated_at)
VALUES (@cat5, 'Ортопед-травматолог', NOW(), NOW());

INSERT INTO services (id, category_id, title, price, created_at, updated_at)
VALUES 
(UUID(), @cat5, 'Прийом (20хв)', '{"price":600}', NOW(), NOW()),
(UUID(), @cat5, 'УЗД', '{"price":500}', NOW(), NOW()),
(UUID(), @cat5, 'Прийом+УЗД', '{"price":1000}', NOW(), NOW());

-- Category 6: Хірург
SET @cat6 = UUID();
INSERT INTO service_categories (id, name, created_at, updated_at)
VALUES (@cat6, 'Хірург', NOW(), NOW());

INSERT INTO services (id, category_id, title, price, created_at, updated_at)
VALUES 
(UUID(), @cat6, 'Прийом (15хв)', '{"price":600}', NOW(), NOW()),
(UUID(), @cat6, 'Виправлення фімоза', '{"price":600}', NOW(), NOW());

-- Category 7: Дерматолог
SET @cat7 = UUID();
INSERT INTO service_categories (id, name, created_at, updated_at)
VALUES (@cat7, 'Дерматолог', NOW(), NOW());

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
INSERT INTO service_categories (id, name, created_at, updated_at)
VALUES (@cat8, 'Фототерапія', NOW(), NOW());

INSERT INTO services (id, category_id, title, price, created_at, updated_at)
VALUES 
(UUID(), @cat8, '1 сеанс', '{"price":300}', NOW(), NOW()),
(UUID(), @cat8, '5 сеансів', '{"price":0, "customPriceString":"по 250"}', NOW(), NOW()),
(UUID(), @cat8, '10 сеансів', '{"price":0, "customPriceString":"по 200"}', NOW(), NOW());

-- Category 9: УЗД діагностика
SET @cat9 = UUID();
INSERT INTO service_categories (id, name, created_at, updated_at)
VALUES (@cat9, 'УЗД діагностика', NOW(), NOW());

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
INSERT INTO service_categories (id, name, created_at, updated_at)
VALUES (@cat10, 'Оформлення довідок', NOW(), NOW());

INSERT INTO services (id, category_id, title, price, created_at, updated_at)
VALUES 
(UUID(), @cat10, 'Оформлення довідки 086 для вступу в дитячий садок, школу (медогляд ''Все включено'') + клініка крові, сечі, глюкоза крові', '{"price":1000}', NOW(), NOW()),
(UUID(), @cat10, 'Оформлення довідки 086 Раковська Л. О.', '{"price":1200}', NOW(), NOW()),
(UUID(), @cat10, 'Оформлення довідки в бассейн', '{"price":0, "customPriceString":"безкоштовно"}', NOW(), NOW()),
(UUID(), @cat10, 'Оформлення довідки 063 про щеплення', '{"price":200}', NOW(), NOW()),
(UUID(), @cat10, 'Оформлення довідки 063 про щеплення на англ. мові', '{"price":600}', NOW(), NOW()),
(UUID(), @cat10, 'Видача довідок в дитячий садок або школу після хвороби', '{"price":0, "customPriceString":"безкоштовно"}', NOW(), NOW()),
(UUID(), @cat10, 'Видача довідки в лагерь', '{"price":0, "customPriceString":"безкоштовно"}', NOW(), NOW());

-- Category 11: Експрес-тести
SET @cat11 = UUID();
INSERT INTO service_categories (id, name, created_at, updated_at)
VALUES (@cat11, 'Експрес-тести', NOW(), NOW());

INSERT INTO services (id, category_id, title, price, created_at, updated_at)
VALUES 
(UUID(), @cat11, 'Експрес-тест на виявлення стрептококу гр А', '{"price":250}', NOW(), NOW()),
(UUID(), @cat11, 'Тест на виявлення грипу А/В', '{"price":250}', NOW(), NOW()),
(UUID(), @cat11, 'Швидкий тест на виявлення Ковід', '{"price":400}', NOW(), NOW()),
(UUID(), @cat11, 'Швидкий тест на виявлення грип + Ковід', '{"price":300}', NOW(), NOW()),
(UUID(), @cat11, 'Швидкий тест для визначення с-реактивного білка', '{"price":250}', NOW(), NOW()),
(UUID(), @cat11, 'Швидкий тест на віт Д', '{"price":250}', NOW(), NOW()),
(UUID(), @cat11, 'Швидкий тест на феритин', '{"price":250}', NOW(), NOW()),
(UUID(), @cat11, 'Експрес-тест сечі на ацетон', '{"price":50}', NOW(), NOW()),
(UUID(), @cat11, 'Експрес-тест сечі 10 параметрів', '{"price":100}', NOW(), NOW()),
(UUID(), @cat11, 'Експрес-тест на тропонін І', '{"price":0}', NOW(), NOW());

-- Category 12: Тест глюкоза
SET @cat12 = UUID();
INSERT INTO service_categories (id, name, created_at, updated_at)
VALUES (@cat12, 'Тест глюкоза', NOW(), NOW());

INSERT INTO services (id, category_id, title, price, created_at, updated_at)
VALUES (UUID(), @cat12, 'Тест глюкоза', '{"price":150}', NOW(), NOW());

-- Category 13: Клініка крові
SET @cat13 = UUID();
INSERT INTO service_categories (id, name, created_at, updated_at)
VALUES (@cat13, 'Клініка крові', NOW(), NOW());

INSERT INTO services (id, category_id, title, price, created_at, updated_at)
VALUES (UUID(), @cat13, 'Клініка крові', '{"price":260}', NOW(), NOW());

-- Category 14: Клініка сечі
SET @cat14 = UUID();
INSERT INTO service_categories (id, name, created_at, updated_at)
VALUES (@cat14, 'Клініка сечі', NOW(), NOW());

INSERT INTO services (id, category_id, title, price, created_at, updated_at)
VALUES (UUID(), @cat14, 'Клініка сечі', '{"price":150}', NOW(), NOW());

-- Category 15: ЕКГ з розшифровкою
SET @cat15 = UUID();
INSERT INTO service_categories (id, name, created_at, updated_at)
VALUES (@cat15, 'ЕКГ з розшифровкою', NOW(), NOW());

INSERT INTO services (id, category_id, title, price, created_at, updated_at)
VALUES (UUID(), @cat15, 'ЕКГ з розшифровкою', '{"price":200}', NOW(), NOW());

-- Category 16: Маніпуляції
SET @cat16 = UUID();
INSERT INTO service_categories (id, name, created_at, updated_at)
VALUES (@cat16, 'Маніпуляції', NOW(), NOW());

INSERT INTO services (id, category_id, title, price, created_at, updated_at)
VALUES 
(UUID(), @cat16, 'Внутрішньом''язова або підшкірна ін''єкції', '{"price":100}', NOW(), NOW()),
(UUID(), @cat16, 'Внутрішньовенна інʼєкція', '{"price":200}', NOW(), NOW()),
(UUID(), @cat16, 'Внутрішньовенна інфузія', '{"price":300}', NOW(), NOW()),
(UUID(), @cat16, 'Введення протиблювотного препарату (в/м)', '{"price":200}', NOW(), NOW()),
(UUID(), @cat16, 'Введення жарознижувального препарату (в/м)', '{"price":200}', NOW(), NOW()),
(UUID(), @cat16, 'Забір аналізів', '{"price":0, "customPriceString":"50-200"}', NOW(), NOW());

-- Category 17: Прокол вух (система Studex75)
SET @cat17 = UUID();
INSERT INTO service_categories (id, name, created_at, updated_at)
VALUES (@cat17, 'Прокол вух (система Studex75)', NOW(), NOW());

INSERT INTO services (id, category_id, title, price, created_at, updated_at)
VALUES 
(UUID(), @cat17, 'Прокол', '{"price":400}', NOW(), NOW()),
(UUID(), @cat17, 'Прокол 1 вуха', '{"price":300}', NOW(), NOW()),
(UUID(), @cat17, 'Сережки', '{"price":0, "customPriceString":"від 500"}', NOW(), NOW());

-- Category 18: Вакцинація
SET @cat18 = UUID();
INSERT INTO service_categories (id, name, created_at, updated_at)
VALUES (@cat18, 'Вакцинація', NOW(), NOW());

INSERT INTO services (id, category_id, title, price, created_at, updated_at)
VALUES 
(UUID(), @cat18, 'Гексаксим (Франція)', '{"price":2300}', NOW(), NOW()),
(UUID(), @cat18, 'Інфанрикс Гекса (Бельгія)', '{"price":2500}', NOW(), NOW()),
(UUID(), @cat18, 'Пентаксим (Франція)', '{"price":2000}', NOW(), NOW()),
(UUID(), @cat18, 'Інфанрикс ІПВ ХІБ (Бельгія)', '{"price":2300}', NOW(), NOW()),
(UUID(), @cat18, 'Бустрикс Поліо (Бельгія)', '{"price":1800}', NOW(), NOW()),
(UUID(), @cat18, 'Тетраксим (Франція)', '{"price":1800}', NOW(), NOW()),
(UUID(), @cat18, 'Інфанрикс ІПВ (Бельгія)', '{"price":2000}', NOW(), NOW()),
(UUID(), @cat18, 'Бустрикс (Бельгія)', '{"price":1500}', NOW(), NOW()),
(UUID(), @cat18, 'Інфанрикс (Бельгія)', '{"price":1650}', NOW(), NOW()),
(UUID(), @cat18, 'Пріорикс (Бельгія)', '{"price":1300}', NOW(), NOW()),
(UUID(), @cat18, 'М-М-РВАКСПРО (США)', '{"price":0}', NOW(), NOW()),
(UUID(), @cat18, 'Ротарикс (Бельгія)', '{"price":1600}', NOW(), NOW()),
(UUID(), @cat18, 'Ротатек (США)', '{"price":1700}', NOW(), NOW()),
(UUID(), @cat18, 'Менактра (США)', '{"price":2100}', NOW(), NOW()),
(UUID(), @cat18, 'Німенрикс (Бельгія)', '{"price":2500}', NOW(), NOW()),
(UUID(), @cat18, 'Бексеро (Великобританія)', '{"price":4750}', NOW(), NOW()),
(UUID(), @cat18, 'Синфлорикс (Бельгія)', '{"price":1900}', NOW(), NOW()),
(UUID(), @cat18, 'Превенар 13 (Великобританія)', '{"price":3500}', NOW(), NOW()),
(UUID(), @cat18, 'Церварикс (Бельгія)', '{"price":2500}', NOW(), NOW()),
(UUID(), @cat18, 'Гардасил (США)', '{"price":6100}', NOW(), NOW()),
(UUID(), @cat18, 'Хаврикс 720 (Бельгія)', '{"price":1700}', NOW(), NOW()),
(UUID(), @cat18, 'Хаврикс 1440 (Бельгія)', '{"price":1800}', NOW(), NOW()),
(UUID(), @cat18, 'Твінрикс (Бельгія)', '{"price":2200}', NOW(), NOW()),
(UUID(), @cat18, 'Енджерикс дитячий 0,5мл', '{"price":1100}', NOW(), NOW()),
(UUID(), @cat18, 'Енджерикс дорослий 1мл', '{"price":1200}', NOW(), NOW()),
(UUID(), @cat18, 'Хіберікс (Бельгія)', '{"price":0}', NOW(), NOW()),
(UUID(), @cat18, 'Варілрикс (Бельгія)', '{"price":2500}', NOW(), NOW()),
(UUID(), @cat18, 'Ваксігрип (Франція)', '{"price":0, "customPriceString":"1000* (від 2 доз - 950; від 3 доз - 900; дітям до 9 років при першій вакцинації - по 900)"}', NOW(), NOW()),
(UUID(), @cat18, 'Джи Сі Флю (Корея)', '{"price":0, "customPriceString":"850* (від 2 доз - 800; від 3 доз - 750; дітям до 9 років при першій вакцинації - по 700)"}', NOW(), NOW());

-- Category 19: Послуга вакцинації вакциєю, придбаною особисто
SET @cat19 = UUID();
INSERT INTO service_categories (id, name, created_at, updated_at)
VALUES (@cat19, 'Послуга вакцинації вакциєю, придбаною особисто', NOW(), NOW());

INSERT INTO services (id, category_id, title, price, created_at, updated_at)
VALUES 
(UUID(), @cat19, 'Послуга вакцинації вакциєю, придбаною особисто', '{"price":0, "customPriceString":"Вартість консультації лікаря + 100 грн введення внутрішньом''язової ін''єкції. За наявності чеку з аптеки та сертифікату на вакцину, а також за умови доставки вакцини з виконанням вимог холодового ланцюга."}', NOW(), NOW());

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
  NOW(),
  NOW()
),
(
  UUID(),
  'Консультація з годування',
  NULL,
  'Якщо ви маєте питання або проблеми з годуванням дитини, або хочете більш детально дізнатись про розвиток – запишіться на онлайн консультацію. Ви отримаєте відповіді на питання:',
  1000,
  FALSE,
  0,
  '1 година',
  '["Як правильно та безпечно ввести прикорм?", "Як покращити апетит дитині?", "Як привчити дитину до здорового харчування?", "Що робити, якщо ваша дитина малоїжка?", "Як зрозуміти, чи нормально розвинута ваша дитина?"]',
  NOW(),
  NOW()
),
(
  UUID(),
  'Онлайн консультація',
  NULL,
  'Якщо ваша дитина захворіла і ви не маєте можливості звернутись до лікаря, замовте онлайн-консультацію і ви отримаєте відповіді на питання:',
  600,
  FALSE,
  0,
  '30 хвилин',
  '["Що робити при гострому захворюванні?", "Як знизити температуру?", "Що робити, коли в дитини блювання та пронос?", "Що означають результати аналізів вашої дитини?", "До якого спеціаліста звернутись з вашою проблемою?"]',
  NOW(),
  NOW()
);

-- ============================================
-- SCRIPT COMPLETED
-- ============================================
-- Database 'help4kids_db' has been created with all tables and initial data
-- ============================================

