import 'package:mysql1/mysql1.dart';

typedef MySQLConnectionFactory = Future<MySqlConnection> Function();

class MySQLConnection {
  // A mutable static field that can be overridden in tests.
  static MySQLConnectionFactory connectionFactory = _defaultConnectionFactory;

  static Future<MySqlConnection> _defaultConnectionFactory() async {
    final settings = ConnectionSettings(
      host: 'localhost',       // Replace with your actual host
      port: 3306,              // Your MySQL port (default: 3306)
      user: 'root',       // Your MySQL username
      password: 'Spmj77jpk##)*', // Your MySQL password
      db: 'hel4kids_db',     // Your database name
    );
    return MySqlConnection.connect(settings).then((value) async {
      await Future.delayed(Duration(milliseconds: 100));
      return value;
    },);
  }

  static Future<MySqlConnection> openConnection() async => await connectionFactory();
}