/// User role constants
class Roles {
  static const String customer = 'customer';
  static const String admin = 'admin';
  static const String god = 'god';

  /// Check if a role has admin privileges
  static bool isAdmin(String roleId) {
    return roleId == admin || roleId == god;
  }

  /// Check if a role has god privileges
  static bool isGod(String roleId) {
    return roleId == god;
  }

  /// Get all valid roles
  static List<String> get all => [customer, admin, god];
}

