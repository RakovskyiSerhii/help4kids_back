// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'social_contact.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

SocialContact _$SocialContactFromJson(Map<String, dynamic> json) {
  return _SocialContact.fromJson(json);
}

/// @nodoc
mixin _$SocialContact {
  String get id => throw _privateConstructorUsedError;
  String get url => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;

  /// Serializes this SocialContact to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SocialContact
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SocialContactCopyWith<SocialContact> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SocialContactCopyWith<$Res> {
  factory $SocialContactCopyWith(
          SocialContact value, $Res Function(SocialContact) then) =
      _$SocialContactCopyWithImpl<$Res, SocialContact>;
  @useResult
  $Res call({String id, String url, String name});
}

/// @nodoc
class _$SocialContactCopyWithImpl<$Res, $Val extends SocialContact>
    implements $SocialContactCopyWith<$Res> {
  _$SocialContactCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SocialContact
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? url = null,
    Object? name = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      url: null == url
          ? _value.url
          : url // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SocialContactImplCopyWith<$Res>
    implements $SocialContactCopyWith<$Res> {
  factory _$$SocialContactImplCopyWith(
          _$SocialContactImpl value, $Res Function(_$SocialContactImpl) then) =
      __$$SocialContactImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String id, String url, String name});
}

/// @nodoc
class __$$SocialContactImplCopyWithImpl<$Res>
    extends _$SocialContactCopyWithImpl<$Res, _$SocialContactImpl>
    implements _$$SocialContactImplCopyWith<$Res> {
  __$$SocialContactImplCopyWithImpl(
      _$SocialContactImpl _value, $Res Function(_$SocialContactImpl) _then)
      : super(_value, _then);

  /// Create a copy of SocialContact
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? url = null,
    Object? name = null,
  }) {
    return _then(_$SocialContactImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      url: null == url
          ? _value.url
          : url // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SocialContactImpl implements _SocialContact {
  const _$SocialContactImpl(
      {required this.id, required this.url, required this.name});

  factory _$SocialContactImpl.fromJson(Map<String, dynamic> json) =>
      _$$SocialContactImplFromJson(json);

  @override
  final String id;
  @override
  final String url;
  @override
  final String name;

  @override
  String toString() {
    return 'SocialContact(id: $id, url: $url, name: $name)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SocialContactImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.url, url) || other.url == url) &&
            (identical(other.name, name) || other.name == name));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, url, name);

  /// Create a copy of SocialContact
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SocialContactImplCopyWith<_$SocialContactImpl> get copyWith =>
      __$$SocialContactImplCopyWithImpl<_$SocialContactImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SocialContactImplToJson(
      this,
    );
  }
}

abstract class _SocialContact implements SocialContact {
  const factory _SocialContact(
      {required final String id,
      required final String url,
      required final String name}) = _$SocialContactImpl;

  factory _SocialContact.fromJson(Map<String, dynamic> json) =
      _$SocialContactImpl.fromJson;

  @override
  String get id;
  @override
  String get url;
  @override
  String get name;

  /// Create a copy of SocialContact
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SocialContactImplCopyWith<_$SocialContactImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
