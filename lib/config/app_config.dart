import 'dart:io';

class AppConfig {
  // Allow override for testing
  static String? _jwtSecretOverride;
  static String? _jwtIssuerOverride;

  // Database configuration
  static String get dbHost => Platform.environment['DB_HOST'] ?? 'localhost';
  static int get dbPort => int.tryParse(Platform.environment['DB_PORT'] ?? '3306') ?? 3306;
  static String get dbUser => Platform.environment['DB_USER'] ?? 'root';
  static String get dbPassword => Platform.environment['DB_PASSWORD'] ?? '';
  static String get dbName => Platform.environment['DB_NAME'] ?? 'help4kids_db';

  // JWT configuration
  static String get jwtSecret {
    if (_jwtSecretOverride != null) return _jwtSecretOverride!;
    final secret = Platform.environment['JWT_SECRET'];
    if (secret == null || secret.isEmpty) {
      throw Exception('JWT_SECRET environment variable is required');
    }
    return secret;
  }
  
  static String get jwtIssuer {
    if (_jwtIssuerOverride != null) return _jwtIssuerOverride!;
    return Platform.environment['JWT_ISSUER'] ?? 'help4kids.com';
  }
  
  static int get jwtExpirationHours => int.tryParse(Platform.environment['JWT_EXPIRATION_HOURS'] ?? '24') ?? 24;

  // Server configuration
  static int get serverPort => int.tryParse(Platform.environment['PORT'] ?? '8080') ?? 8080;

  // WayForPay configuration
  static String get wayforpayMerchantAccount => 
      Platform.environment['WAYFORPAY_MERCHANT_ACCOUNT'] ?? '';
  static String get wayforpaySecretKey => 
      Platform.environment['WAYFORPAY_SECRET_KEY'] ?? '';
  static String get wayforpayApiUrl => 
      Platform.environment['WAYFORPAY_API_URL'] ?? 'https://secure.wayforpay.com/pay';
  static String get wayforpayServiceUrl => 
      Platform.environment['WAYFORPAY_SERVICE_URL'] ?? '';
  static String get wayforpayMerchantDomainName => 
      Platform.environment['WAYFORPAY_MERCHANT_DOMAIN_NAME'] ?? 'help4kids.com';

  // For testing only
  static void setTestConfig({String? jwtSecret, String? jwtIssuer}) {
    _jwtSecretOverride = jwtSecret;
    _jwtIssuerOverride = jwtIssuer;
  }

  static void resetTestConfig() {
    _jwtSecretOverride = null;
    _jwtIssuerOverride = null;
  }
}

