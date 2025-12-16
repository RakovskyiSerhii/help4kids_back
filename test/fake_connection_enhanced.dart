import 'dart:collection';
import 'package:mysql1/mysql1.dart';
import 'package:bcrypt/bcrypt.dart';

/// Enhanced fake MySQL connection for testing with parameterized queries
class EnhancedFakeMySqlConnection implements MySqlConnection {
  final Map<String, List<Map<String, dynamic>>> _data;
  final Map<String, Function> _queryHandlers;

  EnhancedFakeMySqlConnection({
    Map<String, List<Map<String, dynamic>>>? data,
    Map<String, Function>? queryHandlers,
  })  : _data = data ?? {},
        _queryHandlers = queryHandlers ?? {};

  @override
  Future<Results> query(String sql, [List<Object?>? params]) async {
    // Check for custom query handlers first
    if (_queryHandlers.containsKey(sql)) {
      final handler = _queryHandlers[sql]!;
      final result = handler(params ?? []);
      if (result is Results) return result;
      if (result is List<Map<String, dynamic>>) {
        return FakeResults(_createRows(result));
      }
    }

    // Handle parameterized queries
    final normalizedSql = _normalizeSql(sql);
    
    // Handle SELECT queries
    if (normalizedSql.startsWith('select')) {
      return _handleSelect(normalizedSql, params ?? []);
    }
    
    // Handle INSERT queries
    if (normalizedSql.startsWith('insert')) {
      return _handleInsert(normalizedSql, params ?? []);
    }
    
    // Handle UPDATE queries
    if (normalizedSql.startsWith('update')) {
      return _handleUpdate(normalizedSql, params ?? []);
    }
    
    // Handle DELETE queries
    if (normalizedSql.startsWith('delete')) {
      return _handleDelete(normalizedSql, params ?? []);
    }

    return FakeResults([]);
  }

  String _normalizeSql(String sql) {
    return sql.trim().toLowerCase().replaceAll(RegExp(r'\s+'), ' ');
  }

  Future<Results> _handleSelect(String sql, List<Object?> params) async {
    // Handle dashboard query with JOINs (consultation appointments)
    if (sql.contains('from consultation_appointments ca') && 
        sql.contains('join orders o') &&
        sql.contains('join users u')) {
      return _handleDashboardQuery(sql, params);
    }

    // Handle users table queries
    if (sql.contains('from users')) {
      if (sql.contains('where email = ?')) {
        final email = params[0] as String;
        final users = _data['users'] ?? [];
        final matching = users.where((u) => u['email'] == email).toList();
        return FakeResults(_createRows(matching));
      }
      if (sql.contains('where id = ?')) {
        final id = params[0] as String;
        final users = _data['users'] ?? [];
        final matching = users.where((u) => u['id'] == id).toList();
        return FakeResults(_createRows(matching));
      }
      if (sql == 'select * from users') {
        return FakeResults(_createRows(_data['users'] ?? []));
      }
    }

    // Handle roles table queries
    if (sql.contains('from roles') && sql.contains('where name = ?')) {
      final name = params[0] as String;
      final roles = _data['roles'] ?? [];
      final matching = roles.where((r) => r['name'] == name).toList();
      return FakeResults(_createRows(matching));
    }

    // Handle email_verification table queries
    if (sql.contains('from email_verification')) {
      if (sql.contains('where token = ?')) {
        final token = params[0] as String;
        final verifications = _data['email_verification'] ?? [];
        final matching = verifications.where((v) => v['token'] == token).toList();
        return FakeResults(_createRows(matching));
      }
      if (sql.contains('where user_id = ?')) {
        final userId = params[0] as String;
        final verifications = _data['email_verification'] ?? [];
        final matching = verifications.where((v) => v['user_id'] == userId).toList();
        return FakeResults(_createRows(matching));
      }
    }

    return FakeResults([]);
  }

  Future<Results> _handleDashboardQuery(String sql, List<Object?> params) async {
    final appointments = _data['consultation_appointments'] ?? [];
    final orders = _data['orders'] ?? [];
    final users = _data['users'] ?? [];
    final staff = _data['staff'] ?? [];
    final consultations = _data['consultations'] ?? [];

    // Build joined results
    final results = <Map<String, dynamic>>[];
    for (final appt in appointments) {
      final order = orders.firstWhere(
        (o) => o['id'] == appt['order_id'],
        orElse: () => <String, dynamic>{},
      );
      final user = users.firstWhere(
        (u) => u['id'] == order['user_id'],
        orElse: () => <String, dynamic>{},
      );
      final doctor = appt['doctor_id'] != null
          ? staff.firstWhere(
              (s) => s['id'] == appt['doctor_id'],
              orElse: () => <String, dynamic>{},
            )
          : <String, dynamic>{};
      final consultation = consultations.firstWhere(
        (c) => c['id'] == appt['consultation_id'],
        orElse: () => <String, dynamic>{},
      );

      results.add({
        'id': appt['id'],
        'consultation_id': appt['consultation_id'],
        'appointment_datetime': appt['appointment_datetime'],
        'details': appt['details'],
        'order_id': appt['order_id'],
        'processed': appt['processed'],
        'processed_by': appt['processed_by'],
        'processed_at': appt['processed_at'],
        'doctor_id': appt['doctor_id'],
        'created_at': appt['created_at'],
        'updated_at': appt['updated_at'],
        'user_id': order['user_id'],
        'user_name': user['name'],
        'user_email': user['email'],
        'doctor_name': doctor['name'],
        'consultation_title': consultation['title'],
      });
    }

    // Apply filters based on params
    var filtered = results;
    var paramIndex = 0;

    // Filter by userId (o.user_id = ?)
    if (sql.contains('o.user_id = ?') && paramIndex < params.length) {
      final userId = params[paramIndex] as String?;
      if (userId != null) {
        filtered = filtered.where((r) => r['user_id'] == userId).toList();
        paramIndex++;
      }
    }

    // Filter by doctorId (ca.doctor_id = ?)
    if (sql.contains('ca.doctor_id = ?') && paramIndex < params.length) {
      final doctorId = params[paramIndex] as String?;
      if (doctorId != null) {
        filtered = filtered.where((r) => r['doctor_id'] == doctorId).toList();
        paramIndex++;
      }
    }

    // Filter by date ranges
    // The SQL has: ca.appointment_datetime >= ? AND ca.created_at >= ? (for from)
    // and: ca.appointment_datetime <= ? AND ca.created_at <= ? (for to)
    // Params order: [userId?, doctorId?, fromStr, fromStr, toStr, toStr, processed?]
    // OR: [userId?, doctorId?, toStr, toStr, processed?] if only 'to' is provided
    // OR: [userId?, doctorId?, fromStr, fromStr, processed?] if only 'from' is provided
    
    // Find date params by checking SQL conditions
    DateTime? fromDate;
    DateTime? toDate;
    
    // Check if SQL has from conditions
    final hasFrom = sql.contains('ca.appointment_datetime >= ?') && sql.contains('ca.created_at >= ?');
    // Check if SQL has to conditions  
    final hasTo = sql.contains('ca.appointment_datetime <= ?') && sql.contains('ca.created_at <= ?');
    
    // Find date strings in params - look for ISO 8601 format strings
    final dateStrings = <String>[];
    for (var param in params) {
      if (param is String) {
        // Try to parse as DateTime - if it succeeds, it's a date string
        try {
          final parsed = DateTime.parse(param);
          // Only add unique date strings (same date/time, not duplicates)
          if (!dateStrings.any((ds) => DateTime.parse(ds).isAtSameMomentAs(parsed))) {
            dateStrings.add(param);
          }
        } catch (e) {
          // Not a date, skip
        }
      }
    }
    
    // Assign dates based on SQL conditions and param order
    // Params order when both from and to: [userId?, doctorId?, fromStr, fromStr, toStr, toStr, processed?]
    // Params order when only from: [userId?, doctorId?, fromStr, fromStr, processed?]
    // Params order when only to: [userId?, doctorId?, toStr, toStr, processed?]
    if (hasFrom && dateStrings.isNotEmpty) {
      fromDate = DateTime.parse(dateStrings[0]);
    }
    if (hasTo) {
      // If we have from, toDate is the second unique date string, otherwise it's the first
      if (hasFrom && dateStrings.length > 1) {
        toDate = DateTime.parse(dateStrings[1]);
      } else if (!hasFrom && dateStrings.isNotEmpty) {
        toDate = DateTime.parse(dateStrings[0]);
      }
    }

    // Apply date filters
    // The SQL uses: ca.appointment_datetime >= ? AND ca.created_at >= ? (for from)
    // and: ca.appointment_datetime <= ? AND ca.created_at <= ? (for to)
    // BOTH conditions must be true (AND logic) as per SQL
    if (fromDate != null) {
      filtered = filtered.where((r) {
        final apptDt = r['appointment_datetime'] as DateTime;
        final createdDt = r['created_at'] as DateTime;
        // Both must be >= fromDate
        return (apptDt.isAfter(fromDate!) || apptDt.isAtSameMomentAs(fromDate!)) &&
               (createdDt.isAfter(fromDate!) || createdDt.isAtSameMomentAs(fromDate!));
      }).toList();
    }

    if (toDate != null) {
      filtered = filtered.where((r) {
        final apptDt = r['appointment_datetime'] as DateTime;
        final createdDt = r['created_at'] as DateTime;
        // Both must be <= toDate
        return (apptDt.isBefore(toDate!) || apptDt.isAtSameMomentAs(toDate!)) &&
               (createdDt.isBefore(toDate!) || createdDt.isAtSameMomentAs(toDate!));
      }).toList();
    }

    // Filter by processed (ca.processed = ?)
    if (sql.contains('ca.processed = ?')) {
      // Find processed param (look for 0 or 1)
      for (var i = 0; i < params.length; i++) {
        if (params[i] == 0 || params[i] == 1) {
          final processedValue = params[i] == 1;
          filtered = filtered.where((r) => r['processed'] == processedValue).toList();
          break;
        }
      }
    }

    // Sort by appointment_datetime DESC, created_at DESC
    filtered.sort((a, b) {
      final aDt = a['appointment_datetime'] as DateTime;
      final bDt = b['appointment_datetime'] as DateTime;
      final dtCompare = bDt.compareTo(aDt);
      if (dtCompare != 0) return dtCompare;
      final aCreated = a['created_at'] as DateTime;
      final bCreated = b['created_at'] as DateTime;
      return bCreated.compareTo(aCreated);
    });

    return FakeResults(_createRows(filtered));
  }

  Future<Results> _handleInsert(String sql, List<Object?> params) async {
    if (sql.contains('into users')) {
      final users = _data['users'] ??= [];
      final newUser = {
        'id': params[0] as String,
        'email': params[1] as String,
        'password_hash': params[2] as String,
        'first_name': params[3] as String,
        'last_name': params[4] as String,
        'role_id': params[5] as String,
        'is_verified': false,
        'created_at': DateTime.now(),
        'updated_at': DateTime.now(),
      };
      users.add(newUser);
      return FakeResults([], 1, 1);
    }

    if (sql.contains('into email_verification')) {
      final verifications = _data['email_verification'] ??= [];
      final newVerification = {
        'id': params[0] as String,
        'user_id': params[1] as String,
        'token': params[2] as String,
        'created_at': DateTime.now(),
      };
      verifications.add(newVerification);
      return FakeResults([], 1, 1);
    }

      return FakeResults([], 0);
  }

  Future<Results> _handleUpdate(String sql, List<Object?> params) async {
    // Handle consultation_appointments updates (markProcessed)
    if (sql.contains('update consultation_appointments')) {
      if (sql.contains('where id = ?')) {
        final appointmentId = params.last as String;
        final appointments = _data['consultation_appointments'] ?? [];
        final index = appointments.indexWhere((a) => a['id'] == appointmentId);
        if (index != -1) {
          // Update processed fields
          if (sql.contains('processed = 1')) {
            appointments[index]['processed'] = true;
            if (sql.contains('processed_by = ?')) {
              // Find processed_by param (it's before appointmentId)
              final processedByIndex = params.length - 2;
              if (processedByIndex >= 0) {
                appointments[index]['processed_by'] = params[processedByIndex];
              }
            }
            appointments[index]['processed_at'] = DateTime.now();
            appointments[index]['updated_at'] = DateTime.now();
            return FakeResults([], 1);
          }
        }
      }
      return FakeResults([], 0);
    }

    if (sql.contains('update users')) {
      if (sql.contains('where id = ?')) {
        final userId = params.last as String;
        final users = _data['users'] ?? [];
        final userIndex = users.indexWhere((u) => u['id'] == userId);
        if (userIndex != -1) {
          // Update password hash
          if (sql.contains('password_hash = ?')) {
            users[userIndex]['password_hash'] = params[0] as String;
          }
          // Update is_verified
          if (sql.contains('is_verified = true')) {
            users[userIndex]['is_verified'] = true;
          }
          users[userIndex]['updated_at'] = DateTime.now();
            return FakeResults([], 1);
        }
      }
    }

      return FakeResults([], 0);
  }

  Future<Results> _handleDelete(String sql, List<Object?> params) async {
    if (sql.contains('from email_verification')) {
      final verifications = _data['email_verification'] ?? [];
      int deleted = 0;
      
      if (sql.contains('where token = ?')) {
        final token = params[0] as String;
        verifications.removeWhere((v) {
          if (v['token'] == token) {
            deleted++;
            return true;
          }
          return false;
        });
      } else if (sql.contains('where user_id = ?')) {
        final userId = params[0] as String;
        verifications.removeWhere((v) {
          if (v['user_id'] == userId) {
            deleted++;
            return true;
          }
          return false;
        });
      }

        return FakeResults([], deleted);
    }

      return FakeResults([], 0);
  }

  List<ResultRow> _createRows(List<Map<String, dynamic>> data) {
    // Create a simple wrapper that provides the fields we need
    return data.map((row) {
      // Use a simple implementation that just provides field access
      return _SimpleResultRow(row);
    }).toList();
  }

  @override
  Future close() async {
    // No action needed
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

// Simple ResultRow implementation for testing
// We'll use a Map-based approach that works with the existing code
class _SimpleResultRow extends ResultRow {
  final Map<String, dynamic> _data;

  _SimpleResultRow(this._data);

  @override
  dynamic operator [](Object? key) {
    if (key is String) {
      return _data[key];
    }
    // For integer keys, return by index
    if (key is int) {
      final values = _data.values.toList();
      if (key < values.length) {
        return values[key];
      }
    }
    return null;
  }

  @override
  Map<String, dynamic> get fields => _data;

  @override
  List<Object?>? get values => _data.values.toList();

  @override
  int get length => _data.length;

  @override
  set length(int newLength) {
    // Not implemented for fake - read-only
  }

  @override
  void operator []=(int index, dynamic value) {
    // Not implemented for fake - read-only
  }

  @override
  Object? readField(Field field, dynamic buffer) {
    // Not implemented for fake
    return _data[field.name];
  }
}

class FakeResults extends ListBase<ResultRow> implements Results {
  final List<ResultRow> _rows;
  final int? _affectedRows;
  final int? _insertId;
  final List<Field> _fields;

  FakeResults([
    List<ResultRow>? rows,
    int? affectedRows,
    int? insertId,
    List<Field>? fields,
  ])  : _rows = rows ?? [],
        _affectedRows = affectedRows,
        _insertId = insertId,
        _fields = fields ?? [];

  @override
  int get length => _rows.length;

  @override
  set length(int newLength) {
    _rows.length = newLength;
  }

  @override
  ResultRow operator [](int index) => _rows[index];

  @override
  void operator []=(int index, ResultRow value) {
    _rows[index] = value;
  }

  @override
  int? get affectedRows => _affectedRows ?? _rows.length;

  @override
  List<Field> get fields => _fields;

  @override
  int? get insertId => _insertId;
}

