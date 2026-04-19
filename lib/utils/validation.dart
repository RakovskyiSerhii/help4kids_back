/// Input validation utilities
class Validation {
  /// Validates email format
  static bool isValidEmail(String email) {
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    return emailRegex.hasMatch(email);
  }

  /// Validates password strength
  /// Minimum 8 characters
  static bool isValidPassword(String password) {
    return password.length >= 8;
  }

  /// Validates UUID format
  static bool isValidUuid(String uuid) {
    final uuidRegex = RegExp(
      r'^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$',
      caseSensitive: false,
    );
    return uuidRegex.hasMatch(uuid);
  }

  /// Validates that a string is not empty or whitespace
  static bool isNotEmpty(String? value) {
    return value != null && value.trim().isNotEmpty;
  }

  /// Validates that a number is positive
  static bool isPositive(num value) {
    return value > 0;
  }

  /// Validates that a number is non-negative
  static bool isNonNegative(num value) {
    return value >= 0;
  }

  /// Validates phone number format (basic validation)
  /// Accepts international format with optional + prefix
  static bool isValidPhone(String? phone) {
    if (phone == null || phone.isEmpty) return true; // Optional field
    // Basic validation: allows digits, spaces, dashes, parentheses, and +
    final phoneRegex = RegExp(r'^\+?[\d\s\-\(\)]{7,50}$');
    return phoneRegex.hasMatch(phone);
  }
}

