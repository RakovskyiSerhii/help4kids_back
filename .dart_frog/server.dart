// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, implicit_dynamic_list_literal

import 'dart:io';

import 'package:dart_frog/dart_frog.dart';


import '../routes/api/users/index.dart' as api_users_index;
import '../routes/api/users/[userId].dart' as api_users_$user_id;
import '../routes/api/services/index.dart' as api_services_index;
import '../routes/api/services/[serviceId].dart' as api_services_$service_id;
import '../routes/api/orders/payment-callback.dart' as api_orders_payment_callback;
import '../routes/api/orders/me.dart' as api_orders_me;
import '../routes/api/orders/index.dart' as api_orders_index;
import '../routes/api/orders/confirm-payment.dart' as api_orders_confirm_payment;
import '../routes/api/orders/order/[orderId].dart' as api_orders_order_$order_id;
import '../routes/api/courses/me.dart' as api_courses_me;
import '../routes/api/courses/index.dart' as api_courses_index;
import '../routes/api/courses/course/[courseId].dart' as api_courses_course_$course_id;
import '../routes/api/consultations/me.dart' as api_consultations_me;
import '../routes/api/consultations/index.dart' as api_consultations_index;
import '../routes/api/consultations/consultation/[consultationId].dart' as api_consultations_consultation_$consultation_id;
import '../routes/api/consultation-appointments/index.dart' as api_consultation_appointments_index;
import '../routes/api/consultation-appointments/[appointmentId].dart' as api_consultation_appointments_$appointment_id;
import '../routes/api/auth/verify_email.dart' as api_auth_verify_email;
import '../routes/api/auth/resend_email.dart' as api_auth_resend_email;
import '../routes/api/auth/register.dart' as api_auth_register;
import '../routes/api/auth/me.dart' as api_auth_me;
import '../routes/api/auth/login.dart' as api_auth_login;
import '../routes/api/auth/change-password.dart' as api_auth_change_password;
import '../routes/api/articles/index.dart' as api_articles_index;
import '../routes/api/articles/[articleId]/save.dart' as api_articles_$article_id_save;
import '../routes/api/articles/[articleId]/index.dart' as api_articles_$article_id_index;
import '../routes/api/article-categories/index.dart' as api_article_categories_index;
import '../routes/api/article-categories/[categoryId].dart' as api_article_categories_$category_id;
import '../routes/api/activity-logs/index.dart' as api_activity_logs_index;


void main() async {
  final address = InternetAddress.tryParse('') ?? InternetAddress.anyIPv6;
  final port = int.tryParse(Platform.environment['PORT'] ?? '8080') ?? 8080;
  hotReload(() => createServer(address, port));
}

Future<HttpServer> createServer(InternetAddress address, int port) {
  final handler = Cascade().add(buildRootHandler()).handler;
  return serve(handler, address, port);
}

Handler buildRootHandler() {
  final pipeline = const Pipeline();
  final router = Router()
    ..mount('/api/activity-logs', (context) => buildApiActivityLogsHandler()(context))
    ..mount('/api/article-categories', (context) => buildApiArticleCategoriesHandler()(context))
    ..mount('/api/articles/<articleId>', (context,articleId,) => buildApiArticles$articleIdHandler(articleId,)(context))
    ..mount('/api/articles', (context) => buildApiArticlesHandler()(context))
    ..mount('/api/auth', (context) => buildApiAuthHandler()(context))
    ..mount('/api/consultation-appointments', (context) => buildApiConsultationAppointmentsHandler()(context))
    ..mount('/api/consultations/consultation', (context) => buildApiConsultationsConsultationHandler()(context))
    ..mount('/api/consultations', (context) => buildApiConsultationsHandler()(context))
    ..mount('/api/courses/course', (context) => buildApiCoursesCourseHandler()(context))
    ..mount('/api/courses', (context) => buildApiCoursesHandler()(context))
    ..mount('/api/orders/order', (context) => buildApiOrdersOrderHandler()(context))
    ..mount('/api/orders', (context) => buildApiOrdersHandler()(context))
    ..mount('/api/services', (context) => buildApiServicesHandler()(context))
    ..mount('/api/users', (context) => buildApiUsersHandler()(context));
  return pipeline.addHandler(router);
}

Handler buildApiActivityLogsHandler() {
  final pipeline = const Pipeline();
  final router = Router()
    ..all('/', (context) => api_activity_logs_index.onRequest(context,));
  return pipeline.addHandler(router);
}

Handler buildApiArticleCategoriesHandler() {
  final pipeline = const Pipeline();
  final router = Router()
    ..all('/', (context) => api_article_categories_index.onRequest(context,))..all('/<categoryId>', (context,categoryId,) => api_article_categories_$category_id.onRequest(context,categoryId,));
  return pipeline.addHandler(router);
}

Handler buildApiArticles$articleIdHandler(String articleId,) {
  final pipeline = const Pipeline();
  final router = Router()
    ..all('/save', (context) => api_articles_$article_id_save.onRequest(context,articleId,))..all('/', (context) => api_articles_$article_id_index.onRequest(context,articleId,));
  return pipeline.addHandler(router);
}

Handler buildApiArticlesHandler() {
  final pipeline = const Pipeline();
  final router = Router()
    ..all('/', (context) => api_articles_index.onRequest(context,));
  return pipeline.addHandler(router);
}

Handler buildApiAuthHandler() {
  final pipeline = const Pipeline();
  final router = Router()
    ..all('/verify_email', (context) => api_auth_verify_email.onRequest(context,))..all('/resend_email', (context) => api_auth_resend_email.onRequest(context,))..all('/register', (context) => api_auth_register.onRequest(context,))..all('/me', (context) => api_auth_me.onRequest(context,))..all('/login', (context) => api_auth_login.onRequest(context,))..all('/change-password', (context) => api_auth_change_password.onRequest(context,));
  return pipeline.addHandler(router);
}

Handler buildApiConsultationAppointmentsHandler() {
  final pipeline = const Pipeline();
  final router = Router()
    ..all('/', (context) => api_consultation_appointments_index.onRequest(context,))..all('/<appointmentId>', (context,appointmentId,) => api_consultation_appointments_$appointment_id.onRequest(context,appointmentId,));
  return pipeline.addHandler(router);
}

Handler buildApiConsultationsConsultationHandler() {
  final pipeline = const Pipeline();
  final router = Router()
    ..all('/<consultationId>', (context,consultationId,) => api_consultations_consultation_$consultation_id.onRequest(context,consultationId,));
  return pipeline.addHandler(router);
}

Handler buildApiConsultationsHandler() {
  final pipeline = const Pipeline();
  final router = Router()
    ..all('/me', (context) => api_consultations_me.onRequest(context,))..all('/', (context) => api_consultations_index.onRequest(context,));
  return pipeline.addHandler(router);
}

Handler buildApiCoursesCourseHandler() {
  final pipeline = const Pipeline();
  final router = Router()
    ..all('/<courseId>', (context,courseId,) => api_courses_course_$course_id.onRequest(context,courseId,));
  return pipeline.addHandler(router);
}

Handler buildApiCoursesHandler() {
  final pipeline = const Pipeline();
  final router = Router()
    ..all('/me', (context) => api_courses_me.onRequest(context,))..all('/', (context) => api_courses_index.onRequest(context,));
  return pipeline.addHandler(router);
}

Handler buildApiOrdersOrderHandler() {
  final pipeline = const Pipeline();
  final router = Router()
    ..all('/<orderId>', (context,orderId,) => api_orders_order_$order_id.onRequest(context,orderId,));
  return pipeline.addHandler(router);
}

Handler buildApiOrdersHandler() {
  final pipeline = const Pipeline();
  final router = Router()
    ..all('/payment-callback', (context) => api_orders_payment_callback.onRequest(context,))..all('/me', (context) => api_orders_me.onRequest(context,))..all('/', (context) => api_orders_index.onRequest(context,))..all('/confirm-payment', (context) => api_orders_confirm_payment.onRequest(context,));
  return pipeline.addHandler(router);
}

Handler buildApiServicesHandler() {
  final pipeline = const Pipeline();
  final router = Router()
    ..all('/', (context) => api_services_index.onRequest(context,))..all('/<serviceId>', (context,serviceId,) => api_services_$service_id.onRequest(context,serviceId,));
  return pipeline.addHandler(router);
}

Handler buildApiUsersHandler() {
  final pipeline = const Pipeline();
  final router = Router()
    ..all('/', (context) => api_users_index.onRequest(context,))..all('/<userId>', (context,userId,) => api_users_$user_id.onRequest(context,userId,));
  return pipeline.addHandler(router);
}

