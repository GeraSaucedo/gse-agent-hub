// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'example_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ExampleModel {

 String get id; String get text;
/// Create a copy of ExampleModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ExampleModelCopyWith<ExampleModel> get copyWith => _$ExampleModelCopyWithImpl<ExampleModel>(this as ExampleModel, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as ExampleModel;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ExampleModel&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.text, _this.text) || other.text == _this.text));
}


@override
int get hashCode {
  final _this = this as ExampleModel;
  return Object.hash(runtimeType,_this.id,_this.text);
}

@override
String toString() {
  final _this = this as ExampleModel;
  return 'ExampleModel(id: ${_this.id}, text: ${_this.text})';
}


}

/// @nodoc
abstract mixin class $ExampleModelCopyWith<$Res>  {
  factory $ExampleModelCopyWith(ExampleModel value, $Res Function(ExampleModel) _then) = _$ExampleModelCopyWithImpl;
@useResult
$Res call({
 String id, String text
});




}
/// @nodoc
class _$ExampleModelCopyWithImpl<$Res>
    implements $ExampleModelCopyWith<$Res> {
  _$ExampleModelCopyWithImpl(this._self, this._then);

  final ExampleModel _self;
  final $Res Function(ExampleModel) _then;

/// Create a copy of ExampleModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? text = null,}) {
  return _then(ExampleModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [ExampleModel].
extension ExampleModelPatterns on ExampleModel {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ExampleModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ExampleModel() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ExampleModel value)  $default,){
final _that = this;
switch (_that) {
case _ExampleModel():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ExampleModel value)?  $default,){
final _that = this;
switch (_that) {
case _ExampleModel() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String text)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ExampleModel() when $default != null:
return $default(_that.id,_that.text);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String text)  $default,) {final _that = this;
switch (_that) {
case _ExampleModel():
return $default(_that.id,_that.text);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String text)?  $default,) {final _that = this;
switch (_that) {
case _ExampleModel() when $default != null:
return $default(_that.id,_that.text);case _:
  return null;

}
}

}

/// @nodoc


class _ExampleModel implements ExampleModel {
  const _ExampleModel({required this.id, required this.text});
  

@override final  String id;
@override final  String text;

/// Create a copy of ExampleModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ExampleModelCopyWith<_ExampleModel> get copyWith => __$ExampleModelCopyWithImpl<_ExampleModel>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ExampleModel&&(identical(other.id, id) || other.id == id)&&(identical(other.text, text) || other.text == text));
}


@override
int get hashCode {
    return Object.hash(runtimeType,id,text);
}

@override
String toString() {
    return 'ExampleModel(id: $id, text: $text)';
}


}

/// @nodoc
abstract mixin class _$ExampleModelCopyWith<$Res> implements $ExampleModelCopyWith<$Res> {
  factory _$ExampleModelCopyWith(_ExampleModel value, $Res Function(_ExampleModel) _then) = __$ExampleModelCopyWithImpl;
@override @useResult
$Res call({
 String id, String text
});




}
/// @nodoc
class __$ExampleModelCopyWithImpl<$Res>
    implements _$ExampleModelCopyWith<$Res> {
  __$ExampleModelCopyWithImpl(this._self, this._then);

  final _ExampleModel _self;
  final $Res Function(_ExampleModel) _then;

/// Create a copy of ExampleModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? text = null,}) {
  return _then(_ExampleModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
