// test/test_request_context.dart
import 'package:dart_frog/dart_frog.dart';

class TestRequestContext implements RequestContext {
  @override
  final Request request;

  final Map<Object, Object?> _properties;

  TestRequestContext({
    required this.request,
    Map<Object, Object?>? properties,
  }) : _properties = properties ?? {};

  Map<Object, Object?> get properties => _properties;

  RequestContext copyWith({
    Request? request,
    Map<Object, Object?>? properties,
  }) {
    return TestRequestContext(
      request: request ?? this.request,
      properties: properties ?? _properties,
    );
  }

  // @override
  // RequestContext provide<T extends Object>(T Function() create) {
  //   // Create an instance of T and store it keyed by its type
  //   final instance = create();
  //   _properties[T] = instance;
  //   return copyWith(properties: _properties);
  // }

  @override
  T read<T>() {
    // Attempt to retrieve the instance of type T from the properties map.
    final value = _properties[T];
    if (value is T) return value;
    throw Exception('No instance of type $T provided');
  }

  @override
  Map<String, String> get mountedParams => {};

  @override
  RequestContext provide<T extends Object?>(T Function() create) {
    // Create an instance of T and store it keyed by its type
    final instance = create();
    _properties[T] = instance;
    return copyWith(properties: _properties);
  }
}
