import 'dart:collection';

import 'package:mysql1/mysql1.dart';
class FakeMySqlConnection implements MySqlConnection {
  @override
  Future<Results> query(String sql, [List<Object?>? params]) async {
    // Return an empty FakeResults instance or customize based on your test needs.
    return FakeResults([]);
  }

  @override
  Future close() async {
    // No action needed for the fake connection.
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

// test/fake_results.dart

// test/fake_results.dart

// test/fake_results.dart

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