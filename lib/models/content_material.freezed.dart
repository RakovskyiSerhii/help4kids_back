// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'content_material.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ContentMaterial _$ContentMaterialFromJson(Map<String, dynamic> json) {
  return _ContentMaterial.fromJson(json);
}

/// @nodoc
mixin _$ContentMaterial {
  String get id => throw _privateConstructorUsedError;
  String? get contentId =>
      throw _privateConstructorUsedError; // NULL if attached to episode
  String? get episodeId =>
      throw _privateConstructorUsedError; // NULL if attached to content
  MaterialType get materialType => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  String? get fileUrl =>
      throw _privateConstructorUsedError; // For files stored on server
  String? get externalUrl =>
      throw _privateConstructorUsedError; // For external links
  int? get fileSizeBytes => throw _privateConstructorUsedError;
  String? get mimeType => throw _privateConstructorUsedError;
  int get ordering => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime get updatedAt => throw _privateConstructorUsedError;
  String? get createdBy => throw _privateConstructorUsedError;

  /// Serializes this ContentMaterial to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ContentMaterial
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ContentMaterialCopyWith<ContentMaterial> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ContentMaterialCopyWith<$Res> {
  factory $ContentMaterialCopyWith(
          ContentMaterial value, $Res Function(ContentMaterial) then) =
      _$ContentMaterialCopyWithImpl<$Res, ContentMaterial>;
  @useResult
  $Res call(
      {String id,
      String? contentId,
      String? episodeId,
      MaterialType materialType,
      String title,
      String? description,
      String? fileUrl,
      String? externalUrl,
      int? fileSizeBytes,
      String? mimeType,
      int ordering,
      DateTime createdAt,
      DateTime updatedAt,
      String? createdBy});
}

/// @nodoc
class _$ContentMaterialCopyWithImpl<$Res, $Val extends ContentMaterial>
    implements $ContentMaterialCopyWith<$Res> {
  _$ContentMaterialCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ContentMaterial
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? contentId = freezed,
    Object? episodeId = freezed,
    Object? materialType = null,
    Object? title = null,
    Object? description = freezed,
    Object? fileUrl = freezed,
    Object? externalUrl = freezed,
    Object? fileSizeBytes = freezed,
    Object? mimeType = freezed,
    Object? ordering = null,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? createdBy = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      contentId: freezed == contentId
          ? _value.contentId
          : contentId // ignore: cast_nullable_to_non_nullable
              as String?,
      episodeId: freezed == episodeId
          ? _value.episodeId
          : episodeId // ignore: cast_nullable_to_non_nullable
              as String?,
      materialType: null == materialType
          ? _value.materialType
          : materialType // ignore: cast_nullable_to_non_nullable
              as MaterialType,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      fileUrl: freezed == fileUrl
          ? _value.fileUrl
          : fileUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      externalUrl: freezed == externalUrl
          ? _value.externalUrl
          : externalUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      fileSizeBytes: freezed == fileSizeBytes
          ? _value.fileSizeBytes
          : fileSizeBytes // ignore: cast_nullable_to_non_nullable
              as int?,
      mimeType: freezed == mimeType
          ? _value.mimeType
          : mimeType // ignore: cast_nullable_to_non_nullable
              as String?,
      ordering: null == ordering
          ? _value.ordering
          : ordering // ignore: cast_nullable_to_non_nullable
              as int,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      createdBy: freezed == createdBy
          ? _value.createdBy
          : createdBy // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ContentMaterialImplCopyWith<$Res>
    implements $ContentMaterialCopyWith<$Res> {
  factory _$$ContentMaterialImplCopyWith(_$ContentMaterialImpl value,
          $Res Function(_$ContentMaterialImpl) then) =
      __$$ContentMaterialImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String? contentId,
      String? episodeId,
      MaterialType materialType,
      String title,
      String? description,
      String? fileUrl,
      String? externalUrl,
      int? fileSizeBytes,
      String? mimeType,
      int ordering,
      DateTime createdAt,
      DateTime updatedAt,
      String? createdBy});
}

/// @nodoc
class __$$ContentMaterialImplCopyWithImpl<$Res>
    extends _$ContentMaterialCopyWithImpl<$Res, _$ContentMaterialImpl>
    implements _$$ContentMaterialImplCopyWith<$Res> {
  __$$ContentMaterialImplCopyWithImpl(
      _$ContentMaterialImpl _value, $Res Function(_$ContentMaterialImpl) _then)
      : super(_value, _then);

  /// Create a copy of ContentMaterial
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? contentId = freezed,
    Object? episodeId = freezed,
    Object? materialType = null,
    Object? title = null,
    Object? description = freezed,
    Object? fileUrl = freezed,
    Object? externalUrl = freezed,
    Object? fileSizeBytes = freezed,
    Object? mimeType = freezed,
    Object? ordering = null,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? createdBy = freezed,
  }) {
    return _then(_$ContentMaterialImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      contentId: freezed == contentId
          ? _value.contentId
          : contentId // ignore: cast_nullable_to_non_nullable
              as String?,
      episodeId: freezed == episodeId
          ? _value.episodeId
          : episodeId // ignore: cast_nullable_to_non_nullable
              as String?,
      materialType: null == materialType
          ? _value.materialType
          : materialType // ignore: cast_nullable_to_non_nullable
              as MaterialType,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      fileUrl: freezed == fileUrl
          ? _value.fileUrl
          : fileUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      externalUrl: freezed == externalUrl
          ? _value.externalUrl
          : externalUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      fileSizeBytes: freezed == fileSizeBytes
          ? _value.fileSizeBytes
          : fileSizeBytes // ignore: cast_nullable_to_non_nullable
              as int?,
      mimeType: freezed == mimeType
          ? _value.mimeType
          : mimeType // ignore: cast_nullable_to_non_nullable
              as String?,
      ordering: null == ordering
          ? _value.ordering
          : ordering // ignore: cast_nullable_to_non_nullable
              as int,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      createdBy: freezed == createdBy
          ? _value.createdBy
          : createdBy // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ContentMaterialImpl implements _ContentMaterial {
  const _$ContentMaterialImpl(
      {required this.id,
      this.contentId,
      this.episodeId,
      required this.materialType,
      required this.title,
      this.description,
      this.fileUrl,
      this.externalUrl,
      this.fileSizeBytes,
      this.mimeType,
      this.ordering = 0,
      required this.createdAt,
      required this.updatedAt,
      this.createdBy});

  factory _$ContentMaterialImpl.fromJson(Map<String, dynamic> json) =>
      _$$ContentMaterialImplFromJson(json);

  @override
  final String id;
  @override
  final String? contentId;
// NULL if attached to episode
  @override
  final String? episodeId;
// NULL if attached to content
  @override
  final MaterialType materialType;
  @override
  final String title;
  @override
  final String? description;
  @override
  final String? fileUrl;
// For files stored on server
  @override
  final String? externalUrl;
// For external links
  @override
  final int? fileSizeBytes;
  @override
  final String? mimeType;
  @override
  @JsonKey()
  final int ordering;
  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;
  @override
  final String? createdBy;

  @override
  String toString() {
    return 'ContentMaterial(id: $id, contentId: $contentId, episodeId: $episodeId, materialType: $materialType, title: $title, description: $description, fileUrl: $fileUrl, externalUrl: $externalUrl, fileSizeBytes: $fileSizeBytes, mimeType: $mimeType, ordering: $ordering, createdAt: $createdAt, updatedAt: $updatedAt, createdBy: $createdBy)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ContentMaterialImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.contentId, contentId) ||
                other.contentId == contentId) &&
            (identical(other.episodeId, episodeId) ||
                other.episodeId == episodeId) &&
            (identical(other.materialType, materialType) ||
                other.materialType == materialType) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.fileUrl, fileUrl) || other.fileUrl == fileUrl) &&
            (identical(other.externalUrl, externalUrl) ||
                other.externalUrl == externalUrl) &&
            (identical(other.fileSizeBytes, fileSizeBytes) ||
                other.fileSizeBytes == fileSizeBytes) &&
            (identical(other.mimeType, mimeType) ||
                other.mimeType == mimeType) &&
            (identical(other.ordering, ordering) ||
                other.ordering == ordering) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.createdBy, createdBy) ||
                other.createdBy == createdBy));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      contentId,
      episodeId,
      materialType,
      title,
      description,
      fileUrl,
      externalUrl,
      fileSizeBytes,
      mimeType,
      ordering,
      createdAt,
      updatedAt,
      createdBy);

  /// Create a copy of ContentMaterial
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ContentMaterialImplCopyWith<_$ContentMaterialImpl> get copyWith =>
      __$$ContentMaterialImplCopyWithImpl<_$ContentMaterialImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ContentMaterialImplToJson(
      this,
    );
  }
}

abstract class _ContentMaterial implements ContentMaterial {
  const factory _ContentMaterial(
      {required final String id,
      final String? contentId,
      final String? episodeId,
      required final MaterialType materialType,
      required final String title,
      final String? description,
      final String? fileUrl,
      final String? externalUrl,
      final int? fileSizeBytes,
      final String? mimeType,
      final int ordering,
      required final DateTime createdAt,
      required final DateTime updatedAt,
      final String? createdBy}) = _$ContentMaterialImpl;

  factory _ContentMaterial.fromJson(Map<String, dynamic> json) =
      _$ContentMaterialImpl.fromJson;

  @override
  String get id;
  @override
  String? get contentId; // NULL if attached to episode
  @override
  String? get episodeId; // NULL if attached to content
  @override
  MaterialType get materialType;
  @override
  String get title;
  @override
  String? get description;
  @override
  String? get fileUrl; // For files stored on server
  @override
  String? get externalUrl; // For external links
  @override
  int? get fileSizeBytes;
  @override
  String? get mimeType;
  @override
  int get ordering;
  @override
  DateTime get createdAt;
  @override
  DateTime get updatedAt;
  @override
  String? get createdBy;

  /// Create a copy of ContentMaterial
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ContentMaterialImplCopyWith<_$ContentMaterialImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
