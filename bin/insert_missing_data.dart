import 'dart:io';
import 'package:mysql1/mysql1.dart';
import '../lib/config/app_config.dart';

Future<void> main() async {
  print('Connecting to database...');
  print('Host: ${AppConfig.dbHost}');
  print('Port: ${AppConfig.dbPort}');
  print('User: ${AppConfig.dbUser}');
  print('Database: ${AppConfig.dbName}');
  
  try {
    final settings = ConnectionSettings(
      host: AppConfig.dbHost,
      port: AppConfig.dbPort,
      user: AppConfig.dbUser,
      password: AppConfig.dbPassword,
      db: AppConfig.dbName,
    );
    
    var conn = await MySqlConnection.connect(settings);
    print('Connected successfully!\n');
    
    // Read the SQL file
    final sqlFile = File('database/insert_missing_data.sql');
    if (!await sqlFile.exists()) {
      print('Error: database/insert_missing_data.sql not found');
      await conn.close();
      exit(1);
    }
    
    final sqlContent = await sqlFile.readAsString();
    
    // Remove comments and USE statement
    var cleanSql = sqlContent
        .split('\n')
        .where((line) {
          final trimmed = line.trim();
          return !trimmed.startsWith('--') && 
                 !trimmed.toLowerCase().startsWith('use ') &&
                 trimmed.isNotEmpty;
        })
        .join('\n');
    
    // Execute statements one by one, but keep connection alive
    final statements = cleanSql
        .split(';')
        .map((s) => s.trim())
        .where((s) => s.isNotEmpty)
        .toList();
    
    print('Executing ${statements.length} SQL statements...\n');
    
    int successCount = 0;
    int errorCount = 0;
    
    for (var i = 0; i < statements.length; i++) {
      final statement = statements[i];
      if (statement.isEmpty) continue;
      
      try {
        // Execute query and ensure connection stays open
        await conn.query(statement);
        successCount++;
        
        if (statement.toLowerCase().startsWith('insert')) {
          print('✓ Statement ${i + 1}/${statements.length} executed successfully');
        } else if (statement.toLowerCase().startsWith('set')) {
          print('✓ Variable set: ${statement.substring(0, 20)}...');
        } else {
          print('✓ Statement ${i + 1}/${statements.length} executed successfully');
        }
      } catch (e) {
        errorCount++;
        print('✗ Error in statement ${i + 1}/${statements.length}: $e');
        final preview = statement.length > 80 ? statement.substring(0, 80) : statement;
        print('  Statement: $preview...');
        
        // Try to reconnect if connection was lost
        if (e.toString().contains('closed') || e.toString().contains('Socket')) {
          print('  Attempting to reconnect...');
          try {
            await conn.close();
            conn = await MySqlConnection.connect(settings);
            print('  Reconnected successfully');
          } catch (reconnectError) {
            print('  Reconnection failed: $reconnectError');
            break;
          }
        }
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
    
    await conn.close();
  } catch (e) {
    print('Error connecting to database: $e');
    print('\nPlease check:');
    print('  1. Database is running');
    print('  2. Environment variables are set correctly (DB_HOST, DB_USER, DB_PASSWORD, DB_NAME)');
    print('  3. Database credentials are correct');
    exit(1);
  }
}

