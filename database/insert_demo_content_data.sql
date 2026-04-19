-- Demo Data for Content Management System
-- This script inserts sample content, prices, episodes, and materials
-- Run this after creating the content tables

USE help4kids_db;

-- ============================================
-- SAMPLE CONTENTS
-- ============================================

-- Content 1: Single Video - Webinar about child sleep
SET @content1_id = UUID();
INSERT INTO contents (
  id, title, description, short_description, telegram_group_url, cover_image_url,
  content_type, video_url, video_provider, featured, ordering, is_active,
  created_at, updated_at
) VALUES (
  @content1_id,
  'Вебінар: Здоровий сон дитини',
  'Повний вебінар про те, як налагодити здоровий сон у вашої дитини. Ви дізнаєтесь про основні принципи сну, типові помилки батьків та практичні поради від досвідченого педіатра.',
  'Вебінар про здоровий сон дитини від к.м.н. Раковської Л.О.',
  'https://t.me/help4kids_sleep',
  '/images/covers/sleep-webinar.jpg',
  'single_video',
  'https://bunny.net/video/sleep-webinar-123',
  'bunny',
  TRUE,
  1,
  TRUE,
  NOW(),
  NOW()
);

-- Content 2: Multi-Episode - Course on child nutrition
SET @content2_id = UUID();
INSERT INTO contents (
  id, title, description, short_description, telegram_group_url, cover_image_url,
  content_type, featured, ordering, is_active,
  created_at, updated_at
) VALUES (
  @content2_id,
  'Курс: Правильне харчування дитини',
  'Комплексний курс про правильне харчування дітей від народження до підліткового віку. Курс включає 8 епізодів з практичними порадами, рецептами та рекомендаціями.',
  '8-епізодний курс про харчування дітей',
  'https://t.me/help4kids_nutrition',
  '/images/covers/nutrition-course.jpg',
  'multi_episode',
  TRUE,
  2,
  TRUE,
  NOW(),
  NOW()
);

-- Content 3: Single Video - First aid for children
SET @content3_id = UUID();
INSERT INTO contents (
  id, title, description, short_description, telegram_group_url, cover_image_url,
  content_type, video_url, video_provider, featured, ordering, is_active,
  created_at, updated_at
) VALUES (
  @content3_id,
  'Перша допомога дитині: Що робити в екстрених ситуаціях',
  'Детальний вебінар про надання першої допомоги дітям. Ви дізнаєтесь, як діяти при опіках, задишці, втраті свідомості та інших екстрених ситуаціях.',
  'Вебінар про першу допомогу дітям',
  'https://t.me/help4kids_firstaid',
  '/images/covers/firstaid-webinar.jpg',
  'single_video',
  'https://bunny.net/video/firstaid-webinar-456',
  'bunny',
  FALSE,
  3,
  TRUE,
  NOW(),
  NOW()
);

-- Content 4: Multi-Episode - Child development course
SET @content4_id = UUID();
INSERT INTO contents (
  id, title, description, short_description, telegram_group_url, cover_image_url,
  content_type, featured, ordering, is_active,
  created_at, updated_at
) VALUES (
  @content4_id,
  'Розвиток дитини: Від народження до 3 років',
  'Повний курс про фізичний, психічний та емоційний розвиток дитини. 12 епізодів з детальним розбором кожного етапу розвитку.',
  '12-епізодний курс про розвиток дитини',
  'https://t.me/help4kids_development',
  '/images/covers/development-course.jpg',
  'multi_episode',
  TRUE,
  4,
  TRUE,
  NOW(),
  NOW()
);

-- ============================================
-- CONTENT PRICES
-- ============================================

-- Prices for Content 1 (Sleep Webinar)
INSERT INTO content_prices (
  id, content_id, price, currency, access_type, access_duration_months,
  description, is_default, ordering, created_at, updated_at
) VALUES
(UUID(), @content1_id, 2000.00, 'UAH', 'lifetime', NULL, 'Довічний доступ', TRUE, 0, NOW(), NOW()),
(UUID(), @content1_id, 1200.00, 'UAH', 'time_limited', 6, 'Доступ на 6 місяців', FALSE, 1, NOW(), NOW());

-- Prices for Content 2 (Nutrition Course)
INSERT INTO content_prices (
  id, content_id, price, currency, access_type, access_duration_months,
  description, is_default, ordering, created_at, updated_at
) VALUES
(UUID(), @content2_id, 4000.00, 'UAH', 'lifetime', NULL, 'Довічний доступ', TRUE, 0, NOW(), NOW()),
(UUID(), @content2_id, 2500.00, 'UAH', 'time_limited', 6, 'Доступ на 6 місяців', FALSE, 1, NOW(), NOW()),
(UUID(), @content2_id, 1500.00, 'UAH', 'time_limited', 3, 'Доступ на 3 місяці', FALSE, 2, NOW(), NOW());

-- Prices for Content 3 (First Aid)
INSERT INTO content_prices (
  id, content_id, price, currency, access_type, access_duration_months,
  description, is_default, ordering, created_at, updated_at
) VALUES
(UUID(), @content3_id, 1500.00, 'UAH', 'lifetime', NULL, 'Довічний доступ', TRUE, 0, NOW(), NOW()),
(UUID(), @content3_id, 900.00, 'UAH', 'time_limited', 6, 'Доступ на 6 місяців', FALSE, 1, NOW(), NOW());

-- Prices for Content 4 (Development Course)
INSERT INTO content_prices (
  id, content_id, price, currency, access_type, access_duration_months,
  description, is_default, ordering, created_at, updated_at
) VALUES
(UUID(), @content4_id, 5000.00, 'UAH', 'lifetime', NULL, 'Довічний доступ', TRUE, 0, NOW(), NOW()),
(UUID(), @content4_id, 3000.00, 'UAH', 'time_limited', 12, 'Доступ на 12 місяців', FALSE, 1, NOW(), NOW()),
(UUID(), @content4_id, 2000.00, 'UAH', 'time_limited', 6, 'Доступ на 6 місяців', FALSE, 2, NOW(), NOW());

-- ============================================
-- EPISODES (for multi-episode content)
-- ============================================

-- Episodes for Content 2 (Nutrition Course)
INSERT INTO episodes (
  id, content_id, title, description, video_url, video_provider,
  ordering, duration_seconds, created_at, updated_at
) VALUES
(UUID(), @content2_id, 'Епізод 1: Грудне вигодовування', 'Основні принципи грудного вигодовування, правильне прикладання, режим годування', 'https://bunny.net/video/nutrition-ep1', 'bunny', 1, 2400, NOW(), NOW()),
(UUID(), @content2_id, 'Епізод 2: Введення прикорму', 'Коли та як вводити прикорм, перші продукти, схема введення', 'https://bunny.net/video/nutrition-ep2', 'bunny', 2, 2700, NOW(), NOW()),
(UUID(), @content2_id, 'Епізод 3: Харчування від 1 до 3 років', 'Особливості харчування малюків, меню, корисні продукти', 'https://bunny.net/video/nutrition-ep3', 'bunny', 3, 3000, NOW(), NOW()),
(UUID(), @content2_id, 'Епізод 4: Харчування дошкільнят', 'Сбалансоване меню для дошкільнят, спосіб приготування страв', 'https://bunny.net/video/nutrition-ep4', 'bunny', 4, 2800, NOW(), NOW()),
(UUID(), @content2_id, 'Епізод 5: Алергії та непереносимість', 'Як розпізнати алергію, елімінаційна дієта, заміна продуктів', 'https://bunny.net/video/nutrition-ep5', 'bunny', 5, 3200, NOW(), NOW()),
(UUID(), @content2_id, 'Епізод 6: Вітаміни та мінерали', 'Необхідні вітаміни для дітей, джерела, симптоми дефіциту', 'https://bunny.net/video/nutrition-ep6', 'bunny', 6, 2600, NOW(), NOW()),
(UUID(), @content2_id, 'Епізод 7: Рецепти для дітей', 'Практичні рецепти здорового харчування для різних вікових груп', 'https://bunny.net/video/nutrition-ep7', 'bunny', 7, 3500, NOW(), NOW()),
(UUID(), @content2_id, 'Епізод 8: Питання та відповіді', 'Відповіді на найпоширеніші питання батьків про харчування дітей', 'https://bunny.net/video/nutrition-ep8', 'bunny', 8, 2200, NOW(), NOW());

-- Episodes for Content 4 (Development Course)
INSERT INTO episodes (
  id, content_id, title, description, video_url, video_provider,
  ordering, duration_seconds, created_at, updated_at
) VALUES
(UUID(), @content4_id, 'Епізод 1: Розвиток у перші 3 місяці', 'Фізичний та психічний розвиток новонароджених, міленіуми', 'https://bunny.net/video/dev-ep1', 'bunny', 1, 3000, NOW(), NOW()),
(UUID(), @content4_id, 'Епізод 2: Розвиток від 3 до 6 місяців', 'Навички сидіння, перші звуки, соціальний розвиток', 'https://bunny.net/video/dev-ep2', 'bunny', 2, 3200, NOW(), NOW()),
(UUID(), @content4_id, 'Епізод 3: Розвиток від 6 до 9 місяців', 'Повзання, перші слова, розвиток моторики', 'https://bunny.net/video/dev-ep3', 'bunny', 3, 3100, NOW(), NOW()),
(UUID(), @content4_id, 'Епізод 4: Розвиток від 9 до 12 місяців', 'Перші кроки, активна мова, соціальні навички', 'https://bunny.net/video/dev-ep4', 'bunny', 4, 3300, NOW(), NOW()),
(UUID(), @content4_id, 'Епізод 5: Розвиток від 1 до 1.5 років', 'Ходьба, активна мова, самостійність', 'https://bunny.net/video/dev-ep5', 'bunny', 5, 3400, NOW(), NOW()),
(UUID(), @content4_id, 'Епізод 6: Розвиток від 1.5 до 2 років', 'Розвиток мови, фантазія, емоційний розвиток', 'https://bunny.net/video/dev-ep6', 'bunny', 6, 3500, NOW(), NOW()),
(UUID(), @content4_id, 'Епізод 7: Розвиток від 2 до 2.5 років', 'Криза 2 років, соціалізація, навички самообслуговування', 'https://bunny.net/video/dev-ep7', 'bunny', 7, 3600, NOW(), NOW()),
(UUID(), @content4_id, 'Епізод 8: Розвиток від 2.5 до 3 років', 'Підготовка до садочка, розвиток мислення, творчість', 'https://bunny.net/video/dev-ep8', 'bunny', 8, 3700, NOW(), NOW()),
(UUID(), @content4_id, 'Епізод 9: Моторний розвиток', 'Детальний розбір моторного розвитку, вправи та ігри', 'https://bunny.net/video/dev-ep9', 'bunny', 9, 2800, NOW(), NOW()),
(UUID(), @content4_id, 'Епізод 10: Мовний розвиток', 'Етапи розвитку мови, як стимулювати мовлення', 'https://bunny.net/video/dev-ep10', 'bunny', 10, 2900, NOW(), NOW()),
(UUID(), @content4_id, 'Епізод 11: Емоційний розвиток', 'Розвиток емоційного інтелекту, управління емоціями', 'https://bunny.net/video/dev-ep11', 'bunny', 11, 3000, NOW(), NOW()),
(UUID(), @content4_id, 'Епізод 12: Коли звертатися до спеціаліста', 'Червоні прапорці, коли потрібна допомога спеціаліста', 'https://bunny.net/video/dev-ep12', 'bunny', 12, 2500, NOW(), NOW());

-- ============================================
-- CONTENT MATERIALS
-- ============================================

-- Materials for Content 1 (Sleep Webinar)
SET @material1_1 = UUID();
SET @material1_2 = UUID();
INSERT INTO content_materials (
  id, content_id, episode_id, material_type, title, description,
  file_url, external_url, file_size_bytes, mime_type, ordering, created_at, updated_at
) VALUES
(@material1_1, @content1_id, NULL, 'pdf', 'Чек-лист: Налаштування режиму сну', 'Детальний чек-лист для налаштування режиму сну дитини', '/materials/sleep-checklist.pdf', NULL, 245760, 'application/pdf', 0, NOW(), NOW()),
(@material1_2, @content1_id, NULL, 'link', 'Корисні ресурси про сон', 'Посилання на додаткові матеріали та статті', NULL, 'https://help4kids.com/articles/sleep', NULL, NULL, 1, NOW(), NOW());

-- Materials for Content 2 (Nutrition Course) - Content level
SET @material2_1 = UUID();
INSERT INTO content_materials (
  id, content_id, episode_id, material_type, title, description,
  file_url, external_url, file_size_bytes, mime_type, ordering, created_at, updated_at
) VALUES
(@material2_1, @content2_id, NULL, 'pdf', 'Повний путівник з харчування', 'Детальний путівник з харчування дітей різного віку', '/materials/nutrition-guide.pdf', NULL, 1024000, 'application/pdf', 0, NOW(), NOW());

-- Materials for Content 2 Episodes
-- Get first episode ID for Content 2
SET @episode2_1 = (SELECT id FROM episodes WHERE content_id = @content2_id AND ordering = 1 LIMIT 1);
SET @episode2_2 = (SELECT id FROM episodes WHERE content_id = @content2_id AND ordering = 2 LIMIT 1);
SET @episode2_3 = (SELECT id FROM episodes WHERE content_id = @content2_id AND ordering = 3 LIMIT 1);

INSERT INTO content_materials (
  id, content_id, episode_id, material_type, title, description,
  file_url, external_url, file_size_bytes, mime_type, ordering, created_at, updated_at
) VALUES
(UUID(), NULL, @episode2_1, 'pdf', 'Схема грудного вигодовування', 'Детальна схема режиму грудного вигодовування', '/materials/breastfeeding-schedule.pdf', NULL, 153600, 'application/pdf', 0, NOW(), NOW()),
(UUID(), NULL, @episode2_2, 'pdf', 'Таблиця введення прикорму', 'Покрокова таблиця введення прикорму по місяцях', '/materials/solid-food-table.pdf', NULL, 204800, 'application/pdf', 0, NOW(), NOW()),
(UUID(), NULL, @episode2_3, 'image', 'Приклади меню для малюків', 'Зображення з прикладами збалансованого меню', '/materials/menu-examples.jpg', NULL, 512000, 'image/jpeg', 0, NOW(), NOW());

-- Materials for Content 3 (First Aid)
SET @material3_1 = UUID();
SET @material3_2 = UUID();
INSERT INTO content_materials (
  id, content_id, episode_id, material_type, title, description,
  file_url, external_url, file_size_bytes, mime_type, ordering, created_at, updated_at
) VALUES
(@material3_1, @content3_id, NULL, 'pdf', 'Швидкий довідник першої допомоги', 'Компактний довідник з алгоритмами першої допомоги', '/materials/firstaid-quickref.pdf', NULL, 307200, 'application/pdf', 0, NOW(), NOW()),
(@material3_2, @content3_id, NULL, 'link', 'Номери екстрених служб', 'Посилання з номерами екстрених служб та інструкціями', NULL, 'https://help4kids.com/emergency-contacts', NULL, NULL, 1, NOW(), NOW());

-- Materials for Content 4 (Development Course) - Content level
SET @material4_1 = UUID();
INSERT INTO content_materials (
  id, content_id, episode_id, material_type, title, description,
  file_url, external_url, file_size_bytes, mime_type, ordering, created_at, updated_at
) VALUES
(@material4_1, @content4_id, NULL, 'pdf', 'Календар розвитку дитини', 'Повний календар міленіумів розвитку від 0 до 3 років', '/materials/development-calendar.pdf', NULL, 819200, 'application/pdf', 0, NOW(), NOW());

-- Materials for Content 4 Episodes
-- Get some episode IDs for Content 4
SET @episode4_1 = (SELECT id FROM episodes WHERE content_id = @content4_id AND ordering = 1 LIMIT 1);
SET @episode4_5 = (SELECT id FROM episodes WHERE content_id = @content4_id AND ordering = 5 LIMIT 1);
SET @episode4_10 = (SELECT id FROM episodes WHERE content_id = @content4_id AND ordering = 10 LIMIT 1);

INSERT INTO content_materials (
  id, content_id, episode_id, material_type, title, description,
  file_url, external_url, file_size_bytes, mime_type, ordering, created_at, updated_at
) VALUES
(UUID(), NULL, @episode4_1, 'pdf', 'Чек-лист розвитку новонародженого', 'Чек-лист для відстеження розвитку в перші 3 місяці', '/materials/newborn-checklist.pdf', NULL, 128000, 'application/pdf', 0, NOW(), NOW()),
(UUID(), NULL, @episode4_5, 'pdf', 'Вправи для розвитку ходьби', 'Комплекс вправ для розвитку навичок ходьби', '/materials/walking-exercises.pdf', NULL, 256000, 'application/pdf', 0, NOW(), NOW()),
(UUID(), NULL, @episode4_10, 'link', 'Ігри для розвитку мови', 'Посилання на колекцію ігор для стимуляції мовного розвитку', NULL, 'https://help4kids.com/games/language', NULL, NULL, 0, NOW(), NOW());

-- ============================================
-- DEMO DATA INSERTION COMPLETE
-- ============================================

SELECT 'Demo content data inserted successfully!' AS status;
SELECT 
  (SELECT COUNT(*) FROM contents) AS total_contents,
  (SELECT COUNT(*) FROM content_prices) AS total_prices,
  (SELECT COUNT(*) FROM episodes) AS total_episodes,
  (SELECT COUNT(*) FROM content_materials) AS total_materials;

