import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:uuid/uuid.dart';
import '../data/mysql_connection.dart';
import '../models/payment.dart';
import '../models/order.dart';
import '../config/app_config.dart';

class PaymentService {
  // WayForPay configuration
  static String get merchantAccount => 
      AppConfig.wayforpayMerchantAccount;
  static String get merchantSecretKey => 
      AppConfig.wayforpaySecretKey;
  static String get wayforpayApiUrl => 
      AppConfig.wayforpayApiUrl;
  static String get serviceUrl => 
      AppConfig.wayforpayServiceUrl;

  /// Create a payment record for an order
  static Future<Payment> createPayment({
    required String orderId,
    required double amount,
    required String currency,
    required PaymentGateway gateway,
  }) async {
    final conn = await MySQLConnection.openConnection();
    try {
      final paymentId = Uuid().v4();
      final gatewayInvoiceId = '${Uuid().v4()}-${DateTime.now().millisecondsSinceEpoch}';
      
      await conn.query(
        '''
        INSERT INTO payments 
          (id, order_id, gateway, gateway_invoice_id, amount, currency, status, created_at, updated_at)
        VALUES 
          (?, ?, ?, ?, ?, ?, 'initiated', NOW(), NOW())
        ''',
        [
          paymentId,
          orderId,
          gateway.name,
          gatewayInvoiceId,
          amount,
          currency,
        ],
      );

      return Payment(
        id: paymentId,
        orderId: orderId,
        gateway: gateway,
        gatewayInvoiceId: gatewayInvoiceId,
        amount: amount,
        currency: currency,
        status: PaymentStatus.initiated,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
    } finally {
      await conn.close();
    }
  }

  /// Get payment by ID
  static Future<Payment?> getPaymentById(String paymentId) async {
    final conn = await MySQLConnection.openConnection();
    try {
      final results = await conn.query(
        'SELECT * FROM payments WHERE id = ?',
        [paymentId],
      );
      if (results.isEmpty) return null;
      final fields = results.first.fields;
      return _paymentFromRow(fields);
    } finally {
      await conn.close();
    }
  }

  /// Get payment by gateway invoice ID
  static Future<Payment?> getPaymentByGatewayInvoiceId(
    String gatewayInvoiceId,
  ) async {
    final conn = await MySQLConnection.openConnection();
    try {
      final results = await conn.query(
        'SELECT * FROM payments WHERE gateway_invoice_id = ?',
        [gatewayInvoiceId],
      );
      if (results.isEmpty) return null;
      final fields = results.first.fields;
      return _paymentFromRow(fields);
    } finally {
      await conn.close();
    }
  }

  /// Get payments by order ID
  static Future<List<Payment>> getPaymentsByOrderId(String orderId) async {
    final conn = await MySQLConnection.openConnection();
    try {
      final results = await conn.query(
        'SELECT * FROM payments WHERE order_id = ? ORDER BY created_at DESC',
        [orderId],
      );
      return results.map((row) => _paymentFromRow(row.fields)).toList();
    } finally {
      await conn.close();
    }
  }

  /// Update payment status
  static Future<bool> updatePaymentStatus({
    required String paymentId,
    required PaymentStatus status,
    Map<String, dynamic>? rawPayload,
  }) async {
    final conn = await MySQLConnection.openConnection();
    try {
      if (rawPayload != null) {
        final payloadJson = jsonEncode(rawPayload);
        await conn.query(
          '''
          UPDATE payments 
          SET status = ?, raw_gateway_payload = ?, updated_at = NOW()
          WHERE id = ?
          ''',
          [status.name, payloadJson, paymentId],
        );
      } else {
        await conn.query(
          'UPDATE payments SET status = ?, updated_at = NOW() WHERE id = ?',
          [status.name, paymentId],
        );
      }
      return true;
    } finally {
      await conn.close();
    }
  }

  /// Generate WayForPay signature
  static String generateWayForPaySignature(Map<String, dynamic> data) {
    // Sort keys alphabetically
    final sortedKeys = data.keys.toList()..sort();
    final signatureString = sortedKeys
        .map((key) => '$key=${data[key]}')
        .join(';');
    
    final bytes = utf8.encode(signatureString);
    final key = utf8.encode(merchantSecretKey);
    final hmac = Hmac(sha1, key);
    final digest = hmac.convert(bytes);
    
    return digest.toString();
  }

  /// Verify WayForPay signature
  static bool verifyWayForPaySignature(
    Map<String, dynamic> data,
    String receivedSignature,
  ) {
    final calculatedSignature = generateWayForPaySignature(data);
    return calculatedSignature == receivedSignature;
  }

  /// Build WayForPay payment request
  static Map<String, dynamic> buildWayForPayRequest({
    required String orderReference,
    required double amount,
    required String currency,
    required String returnUrl,
    required String serviceUrl,
    required List<String> productNames,
    required List<double> productPrices,
    required List<int> productCounts,
    String? clientEmail,
    String? clientPhone,
    String? clientFirstName,
    String? clientLastName,
  }) {
    final orderDate = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    
    final request = <String, dynamic>{
      'merchantAccount': merchantAccount,
      'merchantDomainName': AppConfig.wayforpayMerchantDomainName,
      'orderReference': orderReference,
      'orderDate': orderDate,
      'amount': amount,
      'currency': currency,
      'productName': productNames,
      'productPrice': productPrices,
      'productCount': productCounts,
      'returnUrl': returnUrl,
      'serviceUrl': serviceUrl,
    };

    if (clientEmail != null) request['clientEmail'] = clientEmail;
    if (clientPhone != null) request['clientPhone'] = clientPhone;
    if (clientFirstName != null) request['clientFirstName'] = clientFirstName;
    if (clientLastName != null) request['clientLastName'] = clientLastName;

    // Generate signature
    final signature = generateWayForPaySignature(request);
    request['merchantSignature'] = signature;

    return request;
  }

  /// Map WayForPay status to PaymentStatus
  static PaymentStatus mapWayForPayStatus(String wayforpayStatus) {
    switch (wayforpayStatus.toLowerCase()) {
      case 'approved':
        return PaymentStatus.successful;
      case 'declined':
      case 'expired':
        return PaymentStatus.failed;
      case 'inprocessing':
      case 'processing':
        return PaymentStatus.processing;
      case 'refunded':
        return PaymentStatus.refunded;
      default:
        return PaymentStatus.failed;
    }
  }

  /// Helper to create Payment from database row
  static Payment _paymentFromRow(Map<String, dynamic> fields) {
    return Payment(
      id: fields['id']?.toString() ?? '',
      orderId: fields['order_id']?.toString() ?? '',
      gateway: PaymentGateway.values.firstWhere(
        (e) => e.name == fields['gateway'],
        orElse: () => PaymentGateway.wayforpay,
      ),
      gatewayInvoiceId: fields['gateway_invoice_id']?.toString() ?? '',
      amount: double.tryParse(fields['amount']?.toString() ?? '0.0') ?? 0.0,
      currency: fields['currency']?.toString() ?? 'UAH',
      status: PaymentStatus.values.firstWhere(
        (e) => e.name == fields['status'],
        orElse: () => PaymentStatus.initiated,
      ),
      createdAt: DateTime.parse(fields['created_at'].toString()),
      updatedAt: DateTime.parse(fields['updated_at'].toString()),
      rawGatewayPayload: fields['raw_gateway_payload'] != null
          ? jsonDecode(fields['raw_gateway_payload'].toString())
              as Map<String, dynamic>
          : null,
    );
  }
}

