import 'package:test/test.dart';
import 'package:help4kids/services/payment_service.dart';
import 'package:help4kids/models/payment.dart';
import 'package:help4kids/data/mysql_connection.dart';
import 'package:help4kids/config/app_config.dart';
import '../fake_connection_enhanced.dart' as fake_conn;

void main() {
  group('PaymentService', () {
    setUpAll(() {
      // Set test config for WayForPay
      // Note: In real tests, you'd use test credentials
    });

    setUp(() {
      // Create enhanced fake connection with test data
      final testData = <String, List<Map<String, dynamic>>>{
        'payments': [],
        'orders': [
          {
            'id': 'order-123',
            'user_id': 'user-123',
            'order_reference': 'ref-123',
            'service_type': 'course',
            'service_id': 'service-123',
            'amount': 1000.0,
            'status': 'pending',
            'purchase_date': DateTime.now(),
            'created_at': DateTime.now(),
            'updated_at': DateTime.now(),
          },
        ],
      };

      MySQLConnection.connectionFactory = () async =>
          fake_conn.EnhancedFakeMySqlConnection(data: testData);
    });

    test('createPayment creates payment with correct fields', () async {
      final payment = await PaymentService.createPayment(
        orderId: 'order-123',
        amount: 1000.0,
        currency: 'UAH',
        gateway: PaymentGateway.wayforpay,
      );

      expect(payment, isNotNull);
      expect(payment.orderId, equals('order-123'));
      expect(payment.amount, equals(1000.0));
      expect(payment.currency, equals('UAH'));
      expect(payment.gateway, equals(PaymentGateway.wayforpay));
      expect(payment.status, equals(PaymentStatus.initiated));
      expect(payment.gatewayInvoiceId, isNotEmpty);
    });

    test('mapWayForPayStatus maps approved to successful', () {
      final status = PaymentService.mapWayForPayStatus('Approved');
      expect(status, equals(PaymentStatus.successful));
    });

    test('mapWayForPayStatus maps declined to failed', () {
      final status = PaymentService.mapWayForPayStatus('Declined');
      expect(status, equals(PaymentStatus.failed));
    });

    test('mapWayForPayStatus maps expired to failed', () {
      final status = PaymentService.mapWayForPayStatus('Expired');
      expect(status, equals(PaymentStatus.failed));
    });

    test('mapWayForPayStatus maps inprocessing to processing', () {
      final status = PaymentService.mapWayForPayStatus('InProcessing');
      expect(status, equals(PaymentStatus.processing));
    });

    test('mapWayForPayStatus maps refunded to refunded', () {
      final status = PaymentService.mapWayForPayStatus('Refunded');
      expect(status, equals(PaymentStatus.refunded));
    });

    test('buildWayForPayRequest includes required fields', () {
      final request = PaymentService.buildWayForPayRequest(
        orderReference: 'test-ref-123',
        amount: 1000.0,
        currency: 'UAH',
        returnUrl: 'https://example.com/return',
        serviceUrl: 'https://example.com/callback',
        productNames: ['Test Product'],
        productPrices: [1000.0],
        productCounts: [1],
      );

      expect(request['merchantAccount'], isNotEmpty);
      expect(request['orderReference'], equals('test-ref-123'));
      expect(request['amount'], equals(1000.0));
      expect(request['currency'], equals('UAH'));
      expect(request['merchantSignature'], isNotEmpty);
    });

    test('buildWayForPayRequest includes optional client fields', () {
      final request = PaymentService.buildWayForPayRequest(
        orderReference: 'test-ref-123',
        amount: 1000.0,
        currency: 'UAH',
        returnUrl: 'https://example.com/return',
        serviceUrl: 'https://example.com/callback',
        productNames: ['Test Product'],
        productPrices: [1000.0],
        productCounts: [1],
        clientEmail: 'test@example.com',
        clientPhone: '+380501234567',
        clientFirstName: 'Test',
        clientLastName: 'User',
      );

      expect(request['clientEmail'], equals('test@example.com'));
      expect(request['clientPhone'], equals('+380501234567'));
      expect(request['clientFirstName'], equals('Test'));
      expect(request['clientLastName'], equals('User'));
    });

    test('generateWayForPaySignature creates valid signature', () {
      final data = {
        'merchantAccount': 'test_account',
        'orderReference': 'test-ref',
        'amount': 1000.0,
      };
      final signature = PaymentService.generateWayForPaySignature(data);
      expect(signature, isNotEmpty);
      expect(signature.length, greaterThan(0));
    });

    test('verifyWayForPaySignature verifies correct signature', () {
      final data = {
        'merchantAccount': 'test_account',
        'orderReference': 'test-ref',
        'amount': 1000.0,
      };
      final signature = PaymentService.generateWayForPaySignature(data);
      final isValid = PaymentService.verifyWayForPaySignature(data, signature);
      expect(isValid, isTrue);
    });

    test('verifyWayForPaySignature rejects incorrect signature', () {
      final data = {
        'merchantAccount': 'test_account',
        'orderReference': 'test-ref',
        'amount': 1000.0,
      };
      final isValid = PaymentService.verifyWayForPaySignature(
        data,
        'invalid-signature',
      );
      expect(isValid, isFalse);
    });
  });
}

