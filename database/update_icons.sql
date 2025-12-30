-- Update icon URLs for all service categories
-- Run this script to update existing database records with the new icon assignments

UPDATE service_categories 
SET iconUrl = 'ic_stethoscope.svg' 
WHERE name = 'Консультативні прийоми лікарів-педіатрів в медичному центрі';

UPDATE service_categories 
SET iconUrl = 'ic_gynecology.svg' 
WHERE name = 'Гінекологія';

UPDATE service_categories 
SET iconUrl = 'ic_heart_pulse.svg' 
WHERE name = 'Кардіолог';

UPDATE service_categories 
SET iconUrl = 'ic_brain.svg' 
WHERE name = 'Невролог';

UPDATE service_categories 
SET iconUrl = 'ic_bone.svg' 
WHERE name = 'Ортопед-травматолог';

UPDATE service_categories 
SET iconUrl = 'ic_scalpel.svg' 
WHERE name = 'Хірург';

UPDATE service_categories 
SET iconUrl = 'ic_skin.svg' 
WHERE name = 'Дерматолог';

UPDATE service_categories 
SET iconUrl = 'ic_sun.svg' 
WHERE name = 'Фототерапія';

UPDATE service_categories 
SET iconUrl = 'ic_monitor.svg' 
WHERE name = 'УЗД діагностика';

UPDATE service_categories 
SET iconUrl = 'ic_document.svg' 
WHERE name = 'Оформлення довідок';

UPDATE service_categories 
SET iconUrl = 'ic_flask.svg' 
WHERE name = 'Експрес-тести';

UPDATE service_categories 
SET iconUrl = 'ic_glucose.svg' 
WHERE name = 'Тест глюкоза';

UPDATE service_categories 
SET iconUrl = 'ic_blood.svg' 
WHERE name = 'Клініка крові';

UPDATE service_categories 
SET iconUrl = 'ic_urine.svg' 
WHERE name = 'Клініка сечі';

UPDATE service_categories 
SET iconUrl = 'ic_ecg.svg' 
WHERE name = 'ЕКГ з розшифровкою';

UPDATE service_categories 
SET iconUrl = 'ic_syringe.svg' 
WHERE name = 'Маніпуляції';

UPDATE service_categories 
SET iconUrl = 'ic_gem.svg' 
WHERE name = 'Прокол вух (система Studex75)';

UPDATE service_categories 
SET iconUrl = 'ic_syringe.svg' 
WHERE name = 'Вакцинація';

UPDATE service_categories 
SET iconUrl = 'ic_syringe.svg' 
WHERE name = 'Послуга вакцинації вакциєю, придбаною особисто';

