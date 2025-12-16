/// Service type constants (matching the ServiceType enum)
class ServiceTypes {
  static const String course = 'course';
  static const String consultation = 'consultation';
  static const String service = 'service';

  /// Get all valid service types
  static List<String> get all => [course, consultation, service];
}

