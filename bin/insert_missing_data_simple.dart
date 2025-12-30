import 'dart:io';
import 'package:mysql1/mysql1.dart';
import 'package:uuid/uuid.dart';
import '../lib/config/app_config.dart';
import '../lib/utils/db_helper.dart';

Future<void> main() async {
  print('Connecting to database...');
  print('Host: ${AppConfig.dbHost}');
  print('Port: ${AppConfig.dbPort}');
  print('User: ${AppConfig.dbUser}');
  print('Database: ${AppConfig.dbName}');
  
  try {
    print('Connected successfully!\n');
    
    final uuid = Uuid();
    int successCount = 0;
    int errorCount = 0;
    
    // Insert Finance Info
    print('Inserting finance info...');
    try {
      final result = await DbHelper.withConnection((conn) async {
        return await conn.query(
          "INSERT INTO finance_info (id, t_number, name, official_address, actual_address, created_at, updated_at) VALUES (?, ?, ?, ?, ?, NOW(), NOW())",
          [uuid.v4(), '2442100984', 'ФОП Раковська Л.О.', 'вул. Трудова 14, смт Високий, Харківський район, Харківська обл', 'Харківська обл., м.Мерефа, Вул. Дніпровська 131']
        );
      });
      successCount++;
      print('✓ Finance info inserted (${result.affectedRows} rows)');
    } catch (e) {
      errorCount++;
      print('✗ Error inserting finance info: $e');
    }
    
    // Insert Service Categories
    print('\nInserting service categories...');
    final categories = [
      ['Консультативні прийоми лікарів-педіатрів в медичному центрі', 'ic_stethoscope.svg'],
      ['Гінекологія', 'ic_gynecology.svg'],
      ['Кардіолог', 'ic_heart_pulse.svg'],
      ['Невролог', 'ic_brain.svg'],
      ['Ортопед-травматолог', 'ic_bone.svg'],
      ['Хірург', 'ic_scalpel.svg'],
      ['Дерматолог', 'ic_skin.svg'],
      ['Фототерапія', 'ic_sun.svg'],
      ['УЗД діагностика', 'ic_monitor.svg'],
      ['Оформлення довідок', 'ic_document.svg'],
      ['Експрес-тести', 'ic_flask.svg'],
      ['Тест глюкоза', 'ic_glucose.svg'],
      ['Клініка крові', 'ic_blood.svg'],
      ['Клініка сечі', 'ic_urine.svg'],
      ['ЕКГ з розшифровкою', 'ic_ecg.svg'],
      ['Маніпуляції', 'ic_syringe.svg'],
      ['Прокол вух (система Studex75)', 'ic_gem.svg'],
      ['Вакцинація', 'ic_syringe.svg'],
      ['Послуга вакцинації вакциєю, придбаною особисто', 'ic_syringe.svg'],
    ];
    
    for (var i = 0; i < categories.length; i++) {
      try {
        final result = await DbHelper.withConnection((conn) async {
          return await conn.query(
            "INSERT INTO service_categories (id, name, iconUrl, created_at, updated_at) VALUES (?, ?, ?, NOW(), NOW())",
            [uuid.v4(), categories[i][0], categories[i][1]]
          );
        });
        successCount++;
        print('✓ Category ${i + 1}/${categories.length}: ${categories[i][0]}');
      } catch (e) {
        errorCount++;
        print('✗ Error inserting category ${i + 1}: $e');
      }
    }
    
    // Insert Consultations
    print('\nInserting consultations...');
    final consultations = [
      [
        'Консультація зі сну',
        'Консультація з питань дитячого сну:\n\nпопередній аналіз анкети та щоденника сну\n\nконсультація тривалістю півтори години\n\nпідтримка протягом одного тижня з відповідями на уточнюючі запитання',
        'Якщо ваша дитина має проблеми зі сном – запишіться на консультацію по сну і ви отримаєте відповіді на питання:',
        2000.0,
        '1 година',
        '["Що робити щоб малюк краще спав?", "Як розділити грудне годування та засинання?", "Як навчити дитину спокійно засинати з мінімальною вашою допомогою, або самостійно?", "Як перестати носити на руках/колисати/гойдати/стрибати/годувати для того, щоб дитина заснула?", "Як перестати годувати вночі?", "Як перевести дитину спати в окреме ліжко?", "Як налагодити правильний режим?"]',
      ],
      [
        'Консультація з годування',
        null,
        'Якщо ви маєте питання або проблеми з годуванням дитини, або хочете більш детально дізнатись про розвиток – запишіться на онлайн консультацію. Ви отримаєте відповіді на питання:',
        1000.0,
        '1 година',
        '["Як правильно та безпечно ввести прикорм?", "Як покращити апетит дитині?", "Як привчити дитину до здорового харчування?", "Що робити, якщо ваша дитина малоїжка?", "Як зрозуміти, чи нормально розвинута ваша дитина?"]',
      ],
      [
        'Онлайн консультація',
        null,
        'Якщо ваша дитина захворіла і ви не маєте можливості звернутись до лікаря, замовте онлайн-консультацію і ви отримаєте відповіді на питання:',
        600.0,
        '30 хвилин',
        '["Що робити при гострому захворюванні?", "Як знизити температуру?", "Що робити, коли в дитини блювання та пронос?", "Що означають результати аналізів вашої дитини?", "До якого спеціаліста звернутись з вашою проблемою?"]',
      ],
    ];
    
    for (var i = 0; i < consultations.length; i++) {
      try {
        final result = await DbHelper.withConnection((conn) async {
          return await conn.query(
            "INSERT INTO consultations (id, title, short_description, description, price, featured, ordering, duration, question, created_at, updated_at) VALUES (?, ?, ?, ?, ?, FALSE, 0, ?, ?, NOW(), NOW())",
            [
              uuid.v4(),
              consultations[i][0] as String,
              consultations[i][1] as String?,
              consultations[i][2] as String,
              consultations[i][3] as double,
              consultations[i][4] as String,
              consultations[i][5] as String,
            ]
          );
        });
        successCount++;
        print('✓ Consultation ${i + 1}/${consultations.length}: ${consultations[i][0]}');
      } catch (e) {
        errorCount++;
        print('✗ Error inserting consultation ${i + 1}: $e');
      }
    }
    
    print('\n========================================');
    print('Summary:');
    print('  Successful: $successCount');
    print('  Errors: $errorCount');
    print('========================================\n');
    
    if (errorCount == 0) {
      print('✅ All data inserted successfully!');
      print('You can now restart your server and check /api/general_info');
    } else {
      print('⚠️  Some errors occurred. Please check the output above.');
    }
  } catch (e) {
    print('Error connecting to database: $e');
    print('\nPlease check:');
    print('  1. Database is running');
    print('  2. Environment variables are set correctly (DB_HOST, DB_USER, DB_PASSWORD, DB_NAME)');
    print('  3. Database credentials are correct');
    exit(1);
  }
}

