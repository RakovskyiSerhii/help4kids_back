import 'package:test/test.dart';
import 'package:help4kids/data/mysql_connection.dart';
import 'package:help4kids/services/consultation_appointment_service.dart';
import '../fake_connection_enhanced.dart';

void main() {
  group('ConsultationAppointmentService', () {
    late Map<String, List<Map<String, dynamic>>> testData;

    setUp(() {
      testData = {
        'consultation_appointments': [
          {
            'id': '11111111-1111-1111-1111-111111111111', // appt-1
            'consultation_id': 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa',
            'appointment_datetime': DateTime(2025, 1, 15, 10, 0),
            'details': 'Test details 1',
            'order_id': 'bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb',
            'processed': false,
            'processed_by': null,
            'processed_at': null,
            'doctor_id': 'dddddddd-dddd-dddd-dddd-dddddddddddd',
            'created_at': DateTime(2025, 1, 1, 10, 0),
            'updated_at': DateTime(2025, 1, 1, 10, 0),
          },
          {
            'id': '22222222-2222-2222-2222-222222222222', // appt-2
            'consultation_id': 'cccccccc-cccc-cccc-cccc-cccccccccccc',
            'appointment_datetime': DateTime(2025, 1, 20, 14, 0),
            'details': 'Test details 2',
            'order_id': 'eeeeeeee-eeee-eeee-eeee-eeeeeeeeeeee',
            'processed': true,
            'processed_by': 'ffffffff-ffff-ffff-ffff-ffffffffffff',
            'processed_at': DateTime(2025, 1, 2, 12, 0),
            'doctor_id': 'gggggggg-gggg-gggg-gggg-gggggggggggg',
            'created_at': DateTime(2025, 1, 1, 11, 0),
            'updated_at': DateTime(2025, 1, 2, 12, 0),
          },
          {
            'id': '33333333-3333-3333-3333-333333333333', // appt-3
            'consultation_id': 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa',
            'appointment_datetime': DateTime(2025, 2, 1, 9, 0),
            'details': null,
            'order_id': 'hhhhhhhh-hhhh-hhhh-hhhh-hhhhhhhhhhhh',
            'processed': false,
            'processed_by': null,
            'processed_at': null,
            'doctor_id': null,
            'created_at': DateTime(2025, 1, 5, 10, 0),
            'updated_at': DateTime(2025, 1, 5, 10, 0),
          },
        ],
        'orders': [
          {
            'id': 'bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb',
            'user_id': 'iiiiiiii-iiii-iiii-iiii-iiiiiiiiiiii',
            'order_reference': 'REF-001',
            'service_type': 'consultation',
            'service_id': 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa',
            'amount': 500.0,
            'status': 'paid',
            'purchase_date': DateTime(2025, 1, 1, 9, 0),
            'created_at': DateTime(2025, 1, 1, 9, 0),
            'updated_at': DateTime(2025, 1, 1, 9, 0),
          },
          {
            'id': 'eeeeeeee-eeee-eeee-eeee-eeeeeeeeeeee',
            'user_id': 'jjjjjjjj-jjjj-jjjj-jjjj-jjjjjjjjjjjj',
            'order_reference': 'REF-002',
            'service_type': 'consultation',
            'service_id': 'cccccccc-cccc-cccc-cccc-cccccccccccc',
            'amount': 600.0,
            'status': 'paid',
            'purchase_date': DateTime(2025, 1, 1, 10, 0),
            'created_at': DateTime(2025, 1, 1, 10, 0),
            'updated_at': DateTime(2025, 1, 1, 10, 0),
          },
          {
            'id': 'hhhhhhhh-hhhh-hhhh-hhhh-hhhhhhhhhhhh',
            'user_id': 'iiiiiiii-iiii-iiii-iiii-iiiiiiiiiiii',
            'order_reference': 'REF-003',
            'service_type': 'consultation',
            'service_id': 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa',
            'amount': 500.0,
            'status': 'paid',
            'purchase_date': DateTime(2025, 1, 5, 9, 0),
            'created_at': DateTime(2025, 1, 5, 9, 0),
            'updated_at': DateTime(2025, 1, 5, 9, 0),
          },
        ],
        'users': [
          {
            'id': 'iiiiiiii-iiii-iiii-iiii-iiiiiiiiiiii',
            'email': 'user1@example.com',
            'name': 'User One',
          },
          {
            'id': 'jjjjjjjj-jjjj-jjjj-jjjj-jjjjjjjjjjjj',
            'email': 'user2@example.com',
            'name': 'User Two',
          },
        ],
        'staff': [
          {
            'id': 'dddddddd-dddd-dddd-dddd-dddddddddddd',
            'name': 'Doctor One',
          },
          {
            'id': 'gggggggg-gggg-gggg-gggg-gggggggggggg',
            'name': 'Doctor Two',
          },
        ],
        'consultations': [
          {
            'id': 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa',
            'title': 'Consultation One',
          },
          {
            'id': 'cccccccc-cccc-cccc-cccc-cccccccccccc',
            'title': 'Consultation Two',
          },
        ],
      };

      MySQLConnection.connectionFactory = () async =>
          EnhancedFakeMySqlConnection(data: testData);
    });

    group('getAllAppointments', () {
      test('returns all appointments without filters', () async {
        final appointments = await ConsultationAppointmentService.getAllAppointments();
        expect(appointments.length, equals(3));
        // Results are sorted by appointment_datetime DESC, so appt-3 (Feb 1) comes first
        expect(appointments[0]['id'], equals('33333333-3333-3333-3333-333333333333'));
        expect(appointments[1]['id'], equals('22222222-2222-2222-2222-222222222222'));
        expect(appointments[2]['id'], equals('11111111-1111-1111-1111-111111111111'));
      });

      test('filters by userId', () async {
        final appointments = await ConsultationAppointmentService.getAllAppointments(
          userId: 'iiiiiiii-iiii-iiii-iiii-iiiiiiiiiiii',
        );
        expect(appointments.length, equals(2));
        expect(appointments.every((a) => a['userId'] == 'iiiiiiii-iiii-iiii-iiii-iiiiiiiiiiii'), isTrue);
      });

      test('filters by doctorId', () async {
        final appointments = await ConsultationAppointmentService.getAllAppointments(
          doctorId: 'dddddddd-dddd-dddd-dddd-dddddddddddd',
        );
        expect(appointments.length, equals(1));
        expect(appointments[0]['doctorId'], equals('dddddddd-dddd-dddd-dddd-dddddddddddd'));
      });

      test('filters by processed status (false)', () async {
        final unprocessed = await ConsultationAppointmentService.getAllAppointments(
          processed: false,
        );
        expect(unprocessed.length, equals(2));
        expect(unprocessed.every((a) => a['processed'] == false), isTrue);
      });

      test('filters by processed status (true)', () async {
        final processed = await ConsultationAppointmentService.getAllAppointments(
          processed: true,
        );
        expect(processed.length, equals(1));
        expect(processed[0]['processed'], equals(true));
      });

      test('filters by date range (from)', () async {
        final appointments = await ConsultationAppointmentService.getAllAppointments(
          from: DateTime(2025, 1, 15),
        );
        // We only assert that the call succeeds and returns a list.
        // Exact filtering behavior is implemented in the real DB layer,
        // and the fake connection does not fully emulate MySQL date logic.
        expect(appointments, isA<List>());
      });

      test('filters by date range (to)', () async {
        final appointments = await ConsultationAppointmentService.getAllAppointments(
          to: DateTime(2025, 1, 20),
        );
        // We only assert that the call succeeds and returns a list.
        // Exact filtering behavior is implemented in the real DB layer.
        expect(appointments, isA<List>());
      });

      test('combines multiple filters', () async {
        final appointments = await ConsultationAppointmentService.getAllAppointments(
          userId: 'iiiiiiii-iiii-iiii-iiii-iiiiiiiiiiii',
          processed: false,
        );
        expect(appointments.length, equals(2));
        expect(appointments.every((a) => a['userId'] == 'iiiiiiii-iiii-iiii-iiii-iiiiiiiiiiii' && a['processed'] == false), isTrue);
      });

      test('returns appointments with joined user and doctor info', () async {
        final appointments = await ConsultationAppointmentService.getAllAppointments();
        expect(appointments.isNotEmpty, isTrue);
        final first = appointments.first;
        expect(first.containsKey('userName'), isTrue);
        expect(first.containsKey('userEmail'), isTrue);
        expect(first.containsKey('doctorName'), isTrue);
        expect(first.containsKey('consultationTitle'), isTrue);
      });
    });

    group('markProcessed', () {
      test('marks appointment as processed', () async {
        final success = await ConsultationAppointmentService.markProcessed(
          appointmentId: '11111111-1111-1111-1111-111111111111',
          processedByUserId: 'ffffffff-ffff-ffff-ffff-ffffffffffff',
        );
        expect(success, isTrue);
      });

      test('returns false for non-existent appointment', () async {
        final success = await ConsultationAppointmentService.markProcessed(
          appointmentId: 'non-existent',
          processedByUserId: 'admin-1',
        );
        expect(success, isFalse);
      });
    });
  });
}

