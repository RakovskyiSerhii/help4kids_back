// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'consultation_appointment.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ConsultationAppointment _$ConsultationAppointmentFromJson(
    Map<String, dynamic> json) {
  return _ConsultationAppointment.fromJson(json);
}

/// @nodoc
mixin _$ConsultationAppointment {
  String get id => throw _privateConstructorUsedError;
  String get consultationId => throw _privateConstructorUsedError;
  DateTime get appointmentDatetime => throw _privateConstructorUsedError;
  String? get details => throw _privateConstructorUsedError;
  String get orderId => throw _privateConstructorUsedError;

  /// Serializes this ConsultationAppointment to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ConsultationAppointment
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ConsultationAppointmentCopyWith<ConsultationAppointment> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ConsultationAppointmentCopyWith<$Res> {
  factory $ConsultationAppointmentCopyWith(ConsultationAppointment value,
          $Res Function(ConsultationAppointment) then) =
      _$ConsultationAppointmentCopyWithImpl<$Res, ConsultationAppointment>;
  @useResult
  $Res call(
      {String id,
      String consultationId,
      DateTime appointmentDatetime,
      String? details,
      String orderId});
}

/// @nodoc
class _$ConsultationAppointmentCopyWithImpl<$Res,
        $Val extends ConsultationAppointment>
    implements $ConsultationAppointmentCopyWith<$Res> {
  _$ConsultationAppointmentCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ConsultationAppointment
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? consultationId = null,
    Object? appointmentDatetime = null,
    Object? details = freezed,
    Object? orderId = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      consultationId: null == consultationId
          ? _value.consultationId
          : consultationId // ignore: cast_nullable_to_non_nullable
              as String,
      appointmentDatetime: null == appointmentDatetime
          ? _value.appointmentDatetime
          : appointmentDatetime // ignore: cast_nullable_to_non_nullable
              as DateTime,
      details: freezed == details
          ? _value.details
          : details // ignore: cast_nullable_to_non_nullable
              as String?,
      orderId: null == orderId
          ? _value.orderId
          : orderId // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ConsultationAppointmentImplCopyWith<$Res>
    implements $ConsultationAppointmentCopyWith<$Res> {
  factory _$$ConsultationAppointmentImplCopyWith(
          _$ConsultationAppointmentImpl value,
          $Res Function(_$ConsultationAppointmentImpl) then) =
      __$$ConsultationAppointmentImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String consultationId,
      DateTime appointmentDatetime,
      String? details,
      String orderId});
}

/// @nodoc
class __$$ConsultationAppointmentImplCopyWithImpl<$Res>
    extends _$ConsultationAppointmentCopyWithImpl<$Res,
        _$ConsultationAppointmentImpl>
    implements _$$ConsultationAppointmentImplCopyWith<$Res> {
  __$$ConsultationAppointmentImplCopyWithImpl(
      _$ConsultationAppointmentImpl _value,
      $Res Function(_$ConsultationAppointmentImpl) _then)
      : super(_value, _then);

  /// Create a copy of ConsultationAppointment
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? consultationId = null,
    Object? appointmentDatetime = null,
    Object? details = freezed,
    Object? orderId = null,
  }) {
    return _then(_$ConsultationAppointmentImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      consultationId: null == consultationId
          ? _value.consultationId
          : consultationId // ignore: cast_nullable_to_non_nullable
              as String,
      appointmentDatetime: null == appointmentDatetime
          ? _value.appointmentDatetime
          : appointmentDatetime // ignore: cast_nullable_to_non_nullable
              as DateTime,
      details: freezed == details
          ? _value.details
          : details // ignore: cast_nullable_to_non_nullable
              as String?,
      orderId: null == orderId
          ? _value.orderId
          : orderId // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ConsultationAppointmentImpl implements _ConsultationAppointment {
  const _$ConsultationAppointmentImpl(
      {required this.id,
      required this.consultationId,
      required this.appointmentDatetime,
      this.details,
      required this.orderId});

  factory _$ConsultationAppointmentImpl.fromJson(Map<String, dynamic> json) =>
      _$$ConsultationAppointmentImplFromJson(json);

  @override
  final String id;
  @override
  final String consultationId;
  @override
  final DateTime appointmentDatetime;
  @override
  final String? details;
  @override
  final String orderId;

  @override
  String toString() {
    return 'ConsultationAppointment(id: $id, consultationId: $consultationId, appointmentDatetime: $appointmentDatetime, details: $details, orderId: $orderId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ConsultationAppointmentImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.consultationId, consultationId) ||
                other.consultationId == consultationId) &&
            (identical(other.appointmentDatetime, appointmentDatetime) ||
                other.appointmentDatetime == appointmentDatetime) &&
            (identical(other.details, details) || other.details == details) &&
            (identical(other.orderId, orderId) || other.orderId == orderId));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, id, consultationId, appointmentDatetime, details, orderId);

  /// Create a copy of ConsultationAppointment
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ConsultationAppointmentImplCopyWith<_$ConsultationAppointmentImpl>
      get copyWith => __$$ConsultationAppointmentImplCopyWithImpl<
          _$ConsultationAppointmentImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ConsultationAppointmentImplToJson(
      this,
    );
  }
}

abstract class _ConsultationAppointment implements ConsultationAppointment {
  const factory _ConsultationAppointment(
      {required final String id,
      required final String consultationId,
      required final DateTime appointmentDatetime,
      final String? details,
      required final String orderId}) = _$ConsultationAppointmentImpl;

  factory _ConsultationAppointment.fromJson(Map<String, dynamic> json) =
      _$ConsultationAppointmentImpl.fromJson;

  @override
  String get id;
  @override
  String get consultationId;
  @override
  DateTime get appointmentDatetime;
  @override
  String? get details;
  @override
  String get orderId;

  /// Create a copy of ConsultationAppointment
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ConsultationAppointmentImplCopyWith<_$ConsultationAppointmentImpl>
      get copyWith => throw _privateConstructorUsedError;
}
