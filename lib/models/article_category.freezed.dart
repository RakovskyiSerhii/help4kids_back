// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'article_category.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ArticleCategory _$ArticleCategoryFromJson(Map<String, dynamic> json) {
  return _ArticleCategory.fromJson(json);
}

/// @nodoc
mixin _$ArticleCategory {
  String get id => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;

  /// Serializes this ArticleCategory to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ArticleCategory
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ArticleCategoryCopyWith<ArticleCategory> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ArticleCategoryCopyWith<$Res> {
  factory $ArticleCategoryCopyWith(
          ArticleCategory value, $Res Function(ArticleCategory) then) =
      _$ArticleCategoryCopyWithImpl<$Res, ArticleCategory>;
  @useResult
  $Res call({String id, String title, String? description});
}

/// @nodoc
class _$ArticleCategoryCopyWithImpl<$Res, $Val extends ArticleCategory>
    implements $ArticleCategoryCopyWith<$Res> {
  _$ArticleCategoryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ArticleCategory
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? description = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ArticleCategoryImplCopyWith<$Res>
    implements $ArticleCategoryCopyWith<$Res> {
  factory _$$ArticleCategoryImplCopyWith(_$ArticleCategoryImpl value,
          $Res Function(_$ArticleCategoryImpl) then) =
      __$$ArticleCategoryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String id, String title, String? description});
}

/// @nodoc
class __$$ArticleCategoryImplCopyWithImpl<$Res>
    extends _$ArticleCategoryCopyWithImpl<$Res, _$ArticleCategoryImpl>
    implements _$$ArticleCategoryImplCopyWith<$Res> {
  __$$ArticleCategoryImplCopyWithImpl(
      _$ArticleCategoryImpl _value, $Res Function(_$ArticleCategoryImpl) _then)
      : super(_value, _then);

  /// Create a copy of ArticleCategory
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? description = freezed,
  }) {
    return _then(_$ArticleCategoryImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ArticleCategoryImpl implements _ArticleCategory {
  const _$ArticleCategoryImpl(
      {required this.id, required this.title, this.description});

  factory _$ArticleCategoryImpl.fromJson(Map<String, dynamic> json) =>
      _$$ArticleCategoryImplFromJson(json);

  @override
  final String id;
  @override
  final String title;
  @override
  final String? description;

  @override
  String toString() {
    return 'ArticleCategory(id: $id, title: $title, description: $description)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ArticleCategoryImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.description, description) ||
                other.description == description));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, title, description);

  /// Create a copy of ArticleCategory
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ArticleCategoryImplCopyWith<_$ArticleCategoryImpl> get copyWith =>
      __$$ArticleCategoryImplCopyWithImpl<_$ArticleCategoryImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ArticleCategoryImplToJson(
      this,
    );
  }
}

abstract class _ArticleCategory implements ArticleCategory {
  const factory _ArticleCategory(
      {required final String id,
      required final String title,
      final String? description}) = _$ArticleCategoryImpl;

  factory _ArticleCategory.fromJson(Map<String, dynamic> json) =
      _$ArticleCategoryImpl.fromJson;

  @override
  String get id;
  @override
  String get title;
  @override
  String? get description;

  /// Create a copy of ArticleCategory
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ArticleCategoryImplCopyWith<_$ArticleCategoryImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
