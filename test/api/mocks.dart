// // test/mock_services.dart
//
// import 'package:help4kids/models/order.dart';
// import 'package:help4kids/models/course.dart';
// import 'package:help4kids/models/consultation.dart';
// import 'package:help4kids/models/service.dart';
// import 'package:help4kids/models/user.dart';
// import 'package:help4kids/models/article.dart';
// import 'package:help4kids/models/article_category.dart';
// import 'package:help4kids/models/activity_log.dart';
// import 'package:help4kids/models/consultation_appointment.dart';
//
// // -----------------------
// // Mock for Order Service
// // -----------------------
// // lib/services/order_service.dart
//
// abstract class OrderServiceInterface {
//   Future<Order> createOrder({
//     required String userId,
//     required String orderReference,
//     required String serviceType, // 'course', 'consultation', 'service'
//     required String serviceId,
//     required double amount,
//   });
//   Future<List<Order>> getOrdersByUser(String userId);
//   Future<Order?> getOrderById(String orderId);
//   Future<bool> handlePaymentCallback(Map<String, dynamic> data);
//   Future<bool> confirmPayment(String orderReference);
// }
//
// class MockOrderService implements OrderServiceInterface {
//   @override
//   Future<Order> createOrder({
//     required String userId,
//     required String orderReference,
//     required String serviceType,
//     required String serviceId,
//     required double amount,
//   }) async {
//     return Order(
//       id: 'mock-order-123',
//       userId: userId,
//       orderReference: orderReference,
//       serviceType: serviceType == 'course'
//           ? ServiceType.course
//           : serviceType == 'consultation'
//           ? ServiceType.consultation
//           : ServiceType.service,
//       serviceId: serviceId,
//       amount: amount,
//       status: OrderStatus.paid,
//       purchaseDate: DateTime.now(),
//       createdAt: DateTime.now(),
//       updatedAt: DateTime.now(),
//     );
//   }
//
//   @override
//   Future<List<Order>> getOrdersByUser(String userId) async {
//     return [
//       Order(
//         id: 'mock-order-123',
//         userId: userId,
//         orderReference: 'mock-ref-123',
//         serviceType: ServiceType.course,
//         serviceId: 'course-123',
//         amount: 99.99,
//         status: OrderStatus.paid,
//         purchaseDate: DateTime.now(),
//         createdAt: DateTime.now(),
//         updatedAt: DateTime.now(),
//       )
//     ];
//   }
//
//   @override
//   Future<Order?> getOrderById(String orderId) async {
//     if (orderId == 'mock-order-123') {
//       return Order(
//         id: 'mock-order-123',
//         userId: 'test-user-id',
//         orderReference: 'mock-ref-123',
//         serviceType: ServiceType.course,
//         serviceId: 'course-123',
//         amount: 99.99,
//         status: OrderStatus.paid,
//         purchaseDate: DateTime.now(),
//         createdAt: DateTime.now(),
//         updatedAt: DateTime.now(),
//       );
//     }
//     return null;
//   }
//
//   @override
//   Future<bool> handlePaymentCallback(Map<String, dynamic> data) async {
//     return true;
//   }
//
//   @override
//   Future<bool> confirmPayment(String orderReference) async {
//     return true;
//   }
// }
//
// // -----------------------
// // Mock for Course Service
// // -----------------------
//
// class MockCourseService {
//   Future<List<Course>> getAllCourses() async {
//     return [
//       Course(
//         id: 'course-123',
//         title: 'Mock Course',
//         shortDescription: 'A mock course description',
//         longDescription: 'A detailed mock course description.',
//         image: 'http://example.com/course.png',
//         icon: 'course_icon.png',
//         price: 99.99,
//         duration: 120,
//         contentUrl: 'http://youtube.com/mockcourse',
//         createdAt: DateTime.now(),
//         updatedAt: DateTime.now(),
//         createdBy: 'admin',
//         updatedBy: 'admin',
//       )
//     ];
//   }
//
//   Future<List<Course>> getPurchasedCourses(String userId) async {
//     // For simplicity, return the same dummy course.
//     return await getAllCourses();
//   }
// }
//
// // -----------------------
// // Mock for Consultation Service
// // -----------------------
//
// class MockConsultationService {
//   Future<List<Consultation>> getAllConsultations() async {
//     return [
//       Consultation(
//         id: 'consult-123',
//         title: 'Mock Consultation',
//         shortDescription: 'A mock consultation description',
//         price: 49.99,
//         createdAt: DateTime.now(),
//         updatedAt: DateTime.now(),
//         createdBy: 'admin',
//         updatedBy: 'admin',
//       )
//     ];
//   }
//
//   Future<List<Consultation>> getPurchasedConsultations(String userId) async {
//     return await getAllConsultations();
//   }
// }
//
// // -----------------------
// // Mock for Featured (General) Service
// // -----------------------
//
// class MockFeaturedService {
//   Future<List<Service>> getAllServices() async {
//     return [
//       Service(
//         id: 'service-123',
//         title: 'Mock Service',
//         shortDescription: 'A mock service description',
//         longDescription: 'A detailed description of the mock service.',
//         image: 'http://example.com/service.png',
//         icon: 'service_icon.png',
//         price: 199.99,
//         duration: 60,
//         categoryId: 'cat-123',
//         createdAt: DateTime.now(),
//         updatedAt: DateTime.now(),
//         createdBy: 'admin',
//         updatedBy: 'admin',
//       )
//     ];
//   }
// }
//
// // -----------------------
// // Mock for Auth Service
// // -----------------------
//
// class MockAuthService {
//   Future<User?> login(String email, String password) async {
//     if (email == 'test@example.com' && password == 'password123') {
//       return User(
//         id: 'test-user-id',
//         email: email,
//         passwordHash: 'hashed', // Dummy value
//         firstName: 'Test',
//         lastName: 'User',
//         roleId: 'customer',
//         createdAt: DateTime.now(),
//         updatedAt: DateTime.now(),
//         createdBy: 'system',
//         updatedBy: 'system',
//       );
//     }
//     return null;
//   }
// }
//
// // -----------------------
// // Mock for User Service
// // -----------------------
//
// class MockUserService {
//   Future<List<User>> getAllUsers() async {
//     return [
//       User(
//         id: 'test-user-id',
//         email: 'test@example.com',
//         passwordHash: 'hashed',
//         firstName: 'Test',
//         lastName: 'User',
//         roleId: 'customer',
//         createdAt: DateTime.now(),
//         updatedAt: DateTime.now(),
//         createdBy: 'system',
//         updatedBy: 'system',
//       )
//     ];
//   }
//
//   Future<User?> getUserById(String userId) async {
//     if (userId == 'test-user-id') {
//       return User(
//         id: 'test-user-id',
//         email: 'test@example.com',
//         passwordHash: 'hashed',
//         firstName: 'Test',
//         lastName: 'User',
//         roleId: 'customer',
//         createdAt: DateTime.now(),
//         updatedAt: DateTime.now(),
//         createdBy: 'system',
//         updatedBy: 'system',
//       );
//     }
//     return null;
//   }
// }
//
// // -----------------------
// // Mock for Article Service
// // -----------------------
//
// class MockArticleService {
//   Future<List<Article>> getAllArticles() async {
//     return [
//       Article(
//         id: 'article-123',
//         title: 'Mock Article',
//         content: 'Content of the mock article.',
//         categoryId: 'artcat-123',
//         // longDescription: 'A long description for the mock article.',
//         createdAt: DateTime.now(),
//         updatedAt: DateTime.now(),
//         createdBy: 'admin',
//         updatedBy: 'admin',
//       )
//     ];
//   }
// }
//
// // -----------------------
// // Mock for Article Category Service
// // -----------------------
//
// class MockArticleCategoryService {
//   Future<List<ArticleCategory>> getAllArticleCategories() async {
//     return [
//       ArticleCategory(
//         id: 'artcat-123',
//         title: 'Mock Category',
//         description: 'Description for the mock category.',
//       )
//     ];
//   }
// }
//
// // -----------------------
// // Mock for Activity Log Service
// // -----------------------
//
// class MockActivityLogService {
//   Future<List<ActivityLog>> getAllActivityLogs() async {
//     return [
//       ActivityLog(
//         id: 'log-123',
//         userId: 'test-user-id',
//         eventType: ActivityEventType.registration,
//         eventTimestamp: DateTime.now(),
//       )
//     ];
//   }
// }
//
// // -----------------------
// // Mock for Consultation Appointment Service
// // -----------------------
//
// class MockConsultationAppointmentService {
//   Future<List<ConsultationAppointment>> getAllAppointments() async {
//     return [
//       ConsultationAppointment(
//         id: 'appt-123',
//         consultationId: 'consult-123',
//         appointmentDatetime: DateTime.now(),
//         details: 'Mock appointment details',
//         orderId: 'mock-order-123',
//       )
//     ];
//   }
// }