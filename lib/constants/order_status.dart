/// Order status constants (matching the OrderStatus enum)
class OrderStatuses {
  static const String pending = 'pending';
  static const String paid = 'paid';
  static const String cancelled = 'cancelled';
  static const String failed = 'failed';

  /// Get all valid order statuses
  static List<String> get all => [pending, paid, cancelled, failed];
}

