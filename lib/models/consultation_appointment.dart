import 'package:freezed_annotation/freezed_annotation.dart';

part 'consultation_appointment.freezed.dart';
part 'consultation_appointment.g.dart';

@freezed
class ConsultationAppointment with _$ConsultationAppointment {
  const factory ConsultationAppointment({
    required String id,
    required String consultationId,
    required DateTime appointmentDatetime,
    String? details,
    required String orderId,
  }) = _ConsultationAppointment;

  factory ConsultationAppointment.fromJson(Map<String, dynamic> json) =>
      _$ConsultationAppointmentFromJson(json);
}