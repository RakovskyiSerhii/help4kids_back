import 'package:uuid/uuid.dart';
import '../data/mysql_connection.dart';
import '../models/order.dart';

class OrderService {
  static Future<Order> createOrder({
    required String userId,
    required String orderReference,
    required ServiceType serviceType,
    required String serviceId,
    required double amount,
  }) async {
    final conn = await MySQLConnection.openConnection();
    try {
      final orderId = Uuid().v4();
      await conn.query(
        '''
        INSERT INTO orders 
          (id, user_id, order_reference, service_type, service_id, amount, status, purchase_date, created_at, updated_at)
        VALUES 
          (?, ?, ?, ?, ?, ?, 'pending', NOW(), NOW(), NOW())
        ''',
        [orderId, userId, orderReference, serviceType.name, serviceId, amount],
      );

      return Order(
        id: orderId,
        userId: userId,
        orderReference: orderReference,
        serviceType: serviceType,
        serviceId: serviceId,
        amount: amount,
        status: OrderStatus.pending,
        purchaseDate: DateTime.now(),
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
    } finally {
      await conn.close();
    }
  }

  static Future<List<Order>> getOrdersByUser(String userId) async {
    final conn = await MySQLConnection.openConnection();
    try {
      final results = await conn.query(
        'SELECT * FROM orders WHERE user_id = ?',
        [userId],
      );
      return results.map((row) {
        final fields = row.fields;
        return Order(
          id: fields['id']?.toString() ?? '',
          userId: fields['user_id']?.toString() ?? '',
          orderReference: fields['order_reference']?.toString() ?? '',
          serviceType: ServiceType.values.firstWhere((e) => e.name == fields['service_type']),
          serviceId: fields['service_id']?.toString() ?? '',
          amount: double.tryParse(fields['amount']?.toString() ?? '0.0') ?? 0.0,
          status: OrderStatus.values.firstWhere((e) => e.name == fields['status']),
          purchaseDate: DateTime.parse(fields['purchase_date'].toString()),
          createdAt: DateTime.parse(fields['created_at'].toString()),
          updatedAt: DateTime.parse(fields['updated_at'].toString()),
        );
      }).toList();
    } finally {
      await conn.close();
    }
  }

  static Future<Order?> getOrderById(String orderId) async {
    final conn = await MySQLConnection.openConnection();
    try {
      final results = await conn.query(
        'SELECT * FROM orders WHERE id = ?',
        [orderId],
      );
      if (results.isEmpty) return null;
      final fields = results.first.fields;
      return Order(
        id: fields['id']?.toString() ?? '',
        userId: fields['user_id']?.toString() ?? '',
        orderReference: fields['order_reference']?.toString() ?? '',
        serviceType: ServiceType.values.firstWhere((e) => e.name == fields['service_type']),
        serviceId: fields['service_id']?.toString() ?? '',
        amount: double.tryParse(fields['amount']?.toString() ?? '0.0') ?? 0.0,
        status: OrderStatus.values.firstWhere((e) => e.name == fields['status']),
        purchaseDate: DateTime.parse(fields['purchase_date'].toString()),
        createdAt: DateTime.parse(fields['created_at'].toString()),
        updatedAt: DateTime.parse(fields['updated_at'].toString()),
      );
    } finally {
      await conn.close();
    }
  }

  static Future<bool> handlePaymentCallback(Map<String, dynamic> data) async {
    final orderReference = data['orderReference'] as String?;
    final paymentStatus = data['status'] as String?;
    if (orderReference == null || paymentStatus == null) return false;

    final conn = await MySQLConnection.openConnection();
    try {
      final result = await conn.query(
        'UPDATE orders SET status = ? WHERE order_reference = ?',
        [paymentStatus, orderReference],
      );
      return result.affectedRows! > 0;
    } finally {
      await conn.close();
    }
  }

  static Future<bool> confirmPayment(String orderReference) async {
    final conn = await MySQLConnection.openConnection();
    try {
      final result = await conn.query(
        "UPDATE orders SET status = 'paid' WHERE order_reference = ?",
        [orderReference],
      );
      return result.affectedRows! > 0;
    } finally {
      await conn.close();
    }
  }
}