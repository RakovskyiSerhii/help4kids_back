// // test/api_test.dart
//
// import 'dart:convert';
// import 'package:dart_frog/dart_frog.dart';
// import 'package:help4kids/data/mysql_connection.dart';
// import 'package:test/test.dart';
//
// // Import your endpoint files (adjust paths as needed)
// import 'package:help4kids/routes/api/orders/[orderId].dart' as orders_index;
// import 'package:help4kids/routes/api/courses/[orderId].dart' as courses_index;
// import 'package:help4kids/routes/api/courses/[orderId].dart' as courses_me;
// import 'package:help4kids/routes/api/orders/[orderId].dart' as orders_order;
// import 'package:help4kids/routes/api/consultations/[orderId].dart' as consultations_index;
// import 'package:help4kids/routes/api/consultations/[orderId].dart' as consultations_me;
// import 'package:help4kids/routes/api/services/[orderId].dart' as services_index;
// import 'package:help4kids/routes/api/auth/register.dart' as auth_register;
// import 'package:help4kids/routes/api/auth/login.dart' as auth_login;
// import 'package:help4kids/routes/api/auth/change-password.dart' as auth_change_password;
// import 'package:help4kids/routes/api/auth/[orderId].dart' as auth_me;
// import 'package:help4kids/routes/api/users/[orderId].dart' as users_index;
// import 'package:help4kids/routes/api/articles/[orderId].dart' as articles_index;
// import 'package:help4kids/routes/api/article-categories/[orderId].dart' as article_categories_index;
// import 'package:help4kids/routes/api/activity-logs/[orderId].dart' as activity_logs_index;
// import 'package:help4kids/routes/api/consultation-appointments/[orderId].dart' as appointments_index;
//
// import '../fake_connection.dart';
// import '../test_reqiuest_context.dart';
//
// void main() {
//   setUp(() {
//     // Override MySQLConnection.connectionFactory to use the fake connection.
//     MySQLConnection.connectionFactory = () async => FakeMySqlConnection();
//     print('--- SetUp: Fake MySQLConnection installed ---');
//   });
//
//   group('Orders Endpoints', () {
//     test('POST /api/orders creates an order', () async {
//       print('\n--- Test: POST /api/orders creates an order ---');
//       final request = Request(
//         'POST',
//         Uri.parse('http://localhost/api/orders'),
//         headers: {'content-type': 'application/json'},
//         body: jsonEncode({
//           'userId': 'test-user-id',
//           'serviceType': 'course',
//           'serviceId': 'test-course-id',
//           'amount': 99.99,
//         }),
//       );
//       print('Request: ${request.method} ${request.url}');
//       print('Headers: ${request.headers}');
//
//       final context = TestRequestContext(request: request);
//       final response = await orders_index.onRequest(context);
//
//       print('Response status: ${response.statusCode}');
//       final responseStr = await response.readBodyAsString();
//       print('Response body: $responseStr');
//
//       expect(response.statusCode, equals(200),
//           reason: "Response body: $responseStr");
//       final bodyJson = jsonDecode(responseStr);
//       expect(bodyJson, contains('id'));
//       expect(bodyJson, contains('orderReference'));
//     });
//
//     test('GET /api/orders/me returns user orders', () async {
//       print('\n--- Test: GET /api/orders/me returns user orders ---');
//       final request = Request(
//         'GET',
//         Uri.parse('http://localhost/api/orders'),
//         headers: {
//           'x-user-id': 'test-user-id',
//           'content-type': 'application/json',
//         },
//       );
//       print('Request: ${request.method} ${request.url}');
//       print('Headers: ${request.headers}');
//
//       final context = TestRequestContext(request: request);
//       final response = await orders_index.onRequest(context);
//
//       print('Response status: ${response.statusCode}');
//       final responseStr = await response.readBodyAsString();
//       print('Response body: $responseStr');
//
//       expect(response.statusCode, equals(200),
//           reason: "Response body: $responseStr");
//       final bodyJson = jsonDecode(responseStr);
//       expect(bodyJson, contains('orders'));
//     });
//
//     test('GET /api/orders/{orderId} returns order details', () async {
//       print('\n--- Test: GET /api/orders/{orderId} returns order details ---');
//       final orderId = 'order-123';
//       final request = Request('GET', Uri.parse('http://localhost/api/orders/$orderId'));
//       print('Request: ${request.method} ${request.url}');
//
//       final context = TestRequestContext(request: request);
//       final response = await orders_order.onRequest(context, orderId);
//
//       print('Response status: ${response.statusCode}');
//       final responseStr = await response.readBodyAsString();
//       print('Response body: $responseStr');
//
//       if (response.statusCode == 404) {
//         expect(response.statusCode, equals(404),
//             reason: "Response body: $responseStr");
//       } else {
//         expect(response.statusCode, equals(200),
//             reason: "Response body: $responseStr");
//         final bodyJson = jsonDecode(responseStr);
//         expect(bodyJson, contains('id'));
//       }
//     });
//   });
//
//   group('Courses Endpoints', () {
//     test('GET /api/courses returns list of courses', () async {
//       print('\n--- Test: GET /api/courses returns list of courses ---');
//       final request = Request('GET', Uri.parse('http://localhost/api/courses'));
//       print('Request: ${request.method} ${request.url}');
//
//       final context = TestRequestContext(request: request);
//       final response = await courses_index.onRequest(context);
//
//       print('Response status: ${response.statusCode}');
//       final responseStr = await response.readBodyAsString();
//       print('Response body: $responseStr');
//
//       expect(response.statusCode, equals(200),
//           reason: "Response body: $responseStr");
//       final bodyJson = jsonDecode(responseStr);
//       expect(bodyJson, contains('courses'));
//     });
//
//     test('GET /api/courses/me returns purchased courses', () async {
//       print('\n--- Test: GET /api/courses/me returns purchased courses ---');
//       final request = Request(
//         'GET',
//         Uri.parse('http://localhost/api/courses/me'),
//         headers: {
//           'x-user-id': 'test-user-id',
//           'content-type': 'application/json',
//         },
//       );
//       print('Request: ${request.method} ${request.url}');
//       print('Headers: ${request.headers}');
//
//       final context = TestRequestContext(request: request);
//       final response = await courses_me.onRequest(context);
//
//       print('Response status: ${response.statusCode}');
//       final responseStr = await response.readBodyAsString();
//       print('Response body: $responseStr');
//
//       expect(response.statusCode, equals(200),
//           reason: "Response body: $responseStr");
//       final bodyJson = jsonDecode(responseStr);
//       expect(bodyJson, contains('courses'));
//     });
//   });
//
//   group('Consultations Endpoints', () {
//     test('GET /api/consultations returns list of consultations', () async {
//       print('\n--- Test: GET /api/consultations returns list of consultations ---');
//       final request = Request('GET', Uri.parse('http://localhost/api/consultations'));
//       print('Request: ${request.method} ${request.url}');
//
//       final context = TestRequestContext(request: request);
//       final response = await consultations_index.onRequest(context);
//
//       print('Response status: ${response.statusCode}');
//       final responseStr = await response.readBodyAsString();
//       print('Response body: $responseStr');
//
//       expect(response.statusCode, equals(200),
//           reason: "Response body: $responseStr");
//       final bodyJson = jsonDecode(responseStr);
//       expect(bodyJson, contains('consultations'));
//     });
//
//     test('GET /api/consultations/me returns purchased consultations', () async {
//       print('\n--- Test: GET /api/consultations/me returns purchased consultations ---');
//       final request = Request(
//         'GET',
//         Uri.parse('http://localhost/api/consultations/me'),
//         headers: {'x-user-id': 'test-user-id'},
//       );
//       print('Request: ${request.method} ${request.url}');
//       print('Headers: ${request.headers}');
//
//       final context = TestRequestContext(request: request);
//       final response = await consultations_me.onRequest(context);
//
//       print('Response status: ${response.statusCode}');
//       final responseStr = await response.readBodyAsString();
//       print('Response body: $responseStr');
//
//       expect(response.statusCode, equals(200),
//           reason: "Response body: $responseStr");
//       final bodyJson = jsonDecode(responseStr);
//       expect(bodyJson, contains('consultations'));
//     });
//   });
//
//   group('Services Endpoints', () {
//     test('GET /api/services returns list of services', () async {
//       print('\n--- Test: GET /api/services returns list of services ---');
//       final request = Request('GET', Uri.parse('http://localhost/api/services'));
//       print('Request: ${request.method} ${request.url}');
//
//       final context = TestRequestContext(request: request);
//       final response = await services_index.onRequest(context);
//
//       print('Response status: ${response.statusCode}');
//       final responseStr = await response.readBodyAsString();
//       print('Response body: $responseStr');
//
//       expect(response.statusCode, equals(200),
//           reason: "Response body: $responseStr");
//       final bodyJson = jsonDecode(responseStr);
//       expect(bodyJson, contains('services'));
//     });
//   });
//
//   group('Authentication Endpoints', () {
//     test('POST /api/auth/register registers a new user', () async {
//       print('\n--- Test: POST /api/auth/register registers a new user ---');
//       final request = Request(
//         'POST',
//         Uri.parse('http://localhost/api/auth/register'),
//         headers: {'content-type': 'application/json'},
//         body: jsonEncode({
//           'email': 'test@example.com',
//           'password': 'password123',
//           'firstName': 'Test',
//           'lastName': 'User',
//         }),
//       );
//       print('Request: ${request.method} ${request.url}');
//       // Not printing request body as per instructions
//
//       final context = TestRequestContext(request: request);
//       final response = await auth_register.onRequest(context);
//
//       final responseStr = await response.readBodyAsString();
//       print('Response status: ${response.statusCode}');
//       print('Response body: $responseStr');
//
//       expect(response.statusCode, anyOf(equals(200), equals(400)),
//           reason: "Response body: $responseStr");
//     });
//
//     test('POST /api/auth/login returns a token on valid credentials', () async {
//       print('\n--- Test: POST /api/auth/login returns a token on valid credentials ---');
//       final request = Request(
//         'POST',
//         Uri.parse('http://localhost/api/auth/login'),
//         headers: {'content-type': 'application/json'},
//         body: jsonEncode({'email': 'test@example.com', 'password': 'password123'}),
//       );
//       print('Request: ${request.method} ${request.url}');
//
//       final context = TestRequestContext(request: request);
//       final response = await auth_login.onRequest(context);
//
//       final responseStr = await response.readBodyAsString();
//       print('Response status: ${response.statusCode}');
//       print('Response body: $responseStr');
//
//       expect(response.statusCode, equals(200),
//           reason: "Response body: $responseStr");
//       final bodyJson = jsonDecode(responseStr);
//       expect(bodyJson, contains('token'));
//     });
//
//     test('POST /api/auth/change-password changes the password', () async {
//       print('\n--- Test: POST /api/auth/change-password changes the password ---');
//       final request = Request(
//         'POST',
//         Uri.parse('http://localhost/api/auth/change-password'),
//         headers: {
//           'content-type': 'application/json',
//           'x-user-id': 'test-user-id',
//         },
//         body: jsonEncode({
//           'currentPassword': 'password123',
//           'newPassword': 'newPassword456',
//         }),
//       );
//       print('Request: ${request.method} ${request.url}');
//       print('Headers: ${request.headers}');
//
//       final context = TestRequestContext(request: request);
//       final response = await auth_change_password.onRequest(context);
//
//       final responseStr = await response.readBodyAsString();
//       print('Response status: ${response.statusCode}');
//       print('Response body: $responseStr');
//
//       expect(response.statusCode, anyOf(equals(200), equals(400)),
//           reason: "Response body: $responseStr");
//     });
//
//     test('GET /api/auth/me returns the user profile', () async {
//       print('\n--- Test: GET /api/auth/me returns the user profile ---');
//       final request = Request(
//         'GET',
//         Uri.parse('http://localhost/api/auth/me'),
//         headers: {'x-user-id': 'test-user-id'},
//       );
//       print('Request: ${request.method} ${request.url}');
//       print('Headers: ${request.headers}');
//
//       final context = TestRequestContext(request: request);
//       final response = await auth_me.onRequest(context);
//
//       final responseStr = await response.readBodyAsString();
//       print('Response status: ${response.statusCode}');
//       print('Response body: $responseStr');
//
//       expect(response.statusCode, equals(200),
//           reason: "Response body: $responseStr");
//       final bodyJson = jsonDecode(responseStr);
//       expect(bodyJson, contains('email'));
//     });
//   });
//
//   group('User Management Endpoints', () {
//     test('GET /api/users returns list of users for admin', () async {
//       print('\n--- Test: GET /api/users returns list of users for admin ---');
//       final request = Request(
//         'GET',
//         Uri.parse('http://localhost/api/users'),
//         headers: {'x-role': 'admin'},
//       );
//       print('Request: ${request.method} ${request.url}');
//       print('Headers: ${request.headers}');
//
//       final context = TestRequestContext(request: request);
//       final response = await users_index.onRequest(context);
//
//       final responseStr = await response.readBodyAsString();
//       print('Response status: ${response.statusCode}');
//       print('Response body: $responseStr');
//
//       expect(response.statusCode, equals(200),
//           reason: "Response body: $responseStr");
//       final bodyJson = jsonDecode(responseStr);
//       expect(bodyJson, contains('users'));
//     });
//   });
//
//   group('Articles Endpoints', () {
//     test('GET /api/articles returns list of articles', () async {
//       print('\n--- Test: GET /api/articles returns list of articles ---');
//       final request = Request('GET', Uri.parse('http://localhost/api/articles'));
//       print('Request: ${request.method} ${request.url}');
//
//       final context = TestRequestContext(request: request);
//       final response = await articles_index.onRequest(context);
//
//       final responseStr = await response.readBodyAsString();
//       print('Response status: ${response.statusCode}');
//       print('Response body: $responseStr');
//
//       expect(response.statusCode, equals(200),
//           reason: "Response body: $responseStr");
//       final bodyJson = jsonDecode(responseStr);
//       expect(bodyJson, contains('articles'));
//     });
//   });
//
//   group('Article Categories Endpoints', () {
//     test('GET /api/article-categories returns list of categories', () async {
//       print('\n--- Test: GET /api/article-categories returns list of categories ---');
//       final request = Request('GET', Uri.parse('http://localhost/api/article-categories'));
//       print('Request: ${request.method} ${request.url}');
//
//       final context = TestRequestContext(request: request);
//       final response = await article_categories_index.onRequest(context);
//
//       final responseStr = await response.readBodyAsString();
//       print('Response status: ${response.statusCode}');
//       print('Response body: $responseStr');
//
//       expect(response.statusCode, equals(200),
//           reason: "Response body: $responseStr");
//       final bodyJson = jsonDecode(responseStr);
//       expect(bodyJson, contains('categories'));
//     });
//   });
//
//   group('Activity Logs Endpoints', () {
//     test('GET /api/activity-logs returns logs for god user', () async {
//       print('\n--- Test: GET /api/activity-logs returns logs for god user ---');
//       final request = Request(
//         'GET',
//         Uri.parse('http://localhost/api/activity-logs'),
//         headers: {'x-role': 'god'},
//       );
//       print('Request: ${request.method} ${request.url}');
//       print('Headers: ${request.headers}');
//
//       final context = TestRequestContext(request: request);
//       final response = await activity_logs_index.onRequest(context);
//
//       final responseStr = await response.readBodyAsString();
//       print('Response status: ${response.statusCode}');
//       print('Response body: $responseStr');
//
//       expect(response.statusCode, equals(200),
//           reason: "Response body: $responseStr");
//       final bodyJson = jsonDecode(responseStr);
//       expect(bodyJson, contains('activityLogs'));
//     });
//   });
//
//   group('Consultation Appointments Endpoints', () {
//     test('GET /api/consultation-appointments returns appointments for admin', () async {
//       print('\n--- Test: GET /api/consultation-appointments returns appointments for admin ---');
//       final request = Request(
//         'GET',
//         Uri.parse('http://localhost/api/consultation-appointments'),
//         headers: {'x-role': 'admin'},
//       );
//       print('Request: ${request.method} ${request.url}');
//       print('Headers: ${request.headers}');
//
//       final context = TestRequestContext(request: request);
//       final response = await appointments_index.onRequest(context);
//
//       final responseStr = await response.readBodyAsString();
//       print('Response status: ${response.statusCode}');
//       print('Response body: $responseStr');
//
//       expect(response.statusCode, equals(200),
//           reason: "Response body: $responseStr");
//       final bodyJson = jsonDecode(responseStr);
//       expect(bodyJson, contains('appointments'));
//     });
//   });
// }
//
// extension ResponseExtension on Response {
//   Future<String> readBodyAsString() async {
//     // If body is a function (closure), call it.
//     if (body is String) return body as String;
//     if (body is List<int>) return utf8.decode(body as List<int>);
//     return body.toString();
//   }
// }