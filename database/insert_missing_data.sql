-- ============================================
-- Insert Missing Data for General Info
-- ============================================
-- This script inserts the missing data for finance_info, consultations, and service_categories
-- Run this if your database tables are empty but the schema exists
-- ============================================

USE help4kids_db;

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

-- Insert Service Categories
-- Category 1: Консультативні прийоми лікарів-педіатрів в медичному центрі
SET @cat1 = UUID();
INSERT INTO service_categories (id, name, iconUrl, created_at, updated_at)
VALUES (@cat1, 'Консультативні прийоми лікарів-педіатрів в медичному центрі', 'ic_stethoscope.svg', NOW(), NOW());

-- Category 2: Гінекологія
SET @cat2 = UUID();
INSERT INTO service_categories (id, name, iconUrl, created_at, updated_at)
VALUES (@cat2, 'Гінекологія', 'ic_gynecology.svg', NOW(), NOW());

-- Category 3: Кардіолог
SET @cat3 = UUID();
INSERT INTO service_categories (id, name, iconUrl, created_at, updated_at)
VALUES (@cat3, 'Кардіолог', 'ic_heart_pulse.svg', NOW(), NOW());

-- Category 4: Невролог
SET @cat4 = UUID();
INSERT INTO service_categories (id, name, iconUrl, created_at, updated_at)
VALUES (@cat4, 'Невролог', 'ic_brain.svg', NOW(), NOW());

-- Category 5: Ортопед-травматолог
SET @cat5 = UUID();
INSERT INTO service_categories (id, name, iconUrl, created_at, updated_at)
VALUES (@cat5, 'Ортопед-травматолог', 'ic_bone.svg', NOW(), NOW());

-- Category 6: Хірург
SET @cat6 = UUID();
INSERT INTO service_categories (id, name, iconUrl, created_at, updated_at)
VALUES (@cat6, 'Хірург', 'ic_scalpel.svg', NOW(), NOW());

-- Category 7: Дерматолог
SET @cat7 = UUID();
INSERT INTO service_categories (id, name, iconUrl, created_at, updated_at)
VALUES (@cat7, 'Дерматолог', 'ic_skin.svg', NOW(), NOW());

-- Category 8: Фототерапія
SET @cat8 = UUID();
INSERT INTO service_categories (id, name, iconUrl, created_at, updated_at)
VALUES (@cat8, 'Фототерапія', 'ic_sun.svg', NOW(), NOW());

-- Category 9: УЗД діагностика
SET @cat9 = UUID();
INSERT INTO service_categories (id, name, iconUrl, created_at, updated_at)
VALUES (@cat9, 'УЗД діагностика', 'ic_monitor.svg', NOW(), NOW());

-- Category 10: Оформлення довідок
SET @cat10 = UUID();
INSERT INTO service_categories (id, name, iconUrl, created_at, updated_at)
VALUES (@cat10, 'Оформлення довідок', 'ic_document.svg', NOW(), NOW());

-- Category 11: Експрес-тести
SET @cat11 = UUID();
INSERT INTO service_categories (id, name, iconUrl, created_at, updated_at)
VALUES (@cat11, 'Експрес-тести', 'ic_flask.svg', NOW(), NOW());

-- Category 12: Тест глюкоза
SET @cat12 = UUID();
INSERT INTO service_categories (id, name, iconUrl, created_at, updated_at)
VALUES (@cat12, 'Тест глюкоза', 'ic_glucose.svg', NOW(), NOW());

-- Category 13: Клініка крові
SET @cat13 = UUID();
INSERT INTO service_categories (id, name, iconUrl, created_at, updated_at)
VALUES (@cat13, 'Клініка крові', 'ic_blood.svg', NOW(), NOW());

-- Category 14: Клініка сечі
SET @cat14 = UUID();
INSERT INTO service_categories (id, name, iconUrl, created_at, updated_at)
VALUES (@cat14, 'Клініка сечі', 'ic_urine.svg', NOW(), NOW());

-- Category 15: ЕКГ з розшифровкою
SET @cat15 = UUID();
INSERT INTO service_categories (id, name, iconUrl, created_at, updated_at)
VALUES (@cat15, 'ЕКГ з розшифровкою', 'ic_ecg.svg', NOW(), NOW());

-- Category 16: Маніпуляції
SET @cat16 = UUID();
INSERT INTO service_categories (id, name, iconUrl, created_at, updated_at)
VALUES (@cat16, 'Маніпуляції', 'ic_syringe.svg', NOW(), NOW());

-- Category 17: Прокол вух (система Studex75)
SET @cat17 = UUID();
INSERT INTO service_categories (id, name, iconUrl, created_at, updated_at)
VALUES (@cat17, 'Прокол вух (система Studex75)', 'ic_gem.svg', NOW(), NOW());

-- Category 18: Вакцинація
SET @cat18 = UUID();
INSERT INTO service_categories (id, name, iconUrl, created_at, updated_at)
VALUES (@cat18, 'Вакцинація', 'ic_syringe.svg', NOW(), NOW());

-- Category 19: Послуга вакцинації вакциєю, придбаною особисто
SET @cat19 = UUID();
INSERT INTO service_categories (id, name, iconUrl, created_at, updated_at)
VALUES (@cat19, 'Послуга вакцинації вакциєю, придбаною особисто', 'ic_syringe.svg', NOW(), NOW());

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

