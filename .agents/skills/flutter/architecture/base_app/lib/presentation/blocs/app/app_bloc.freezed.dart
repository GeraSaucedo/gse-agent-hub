// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'app_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$AppEvent {





@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is AppEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'AppEvent()';
}


}

/// @nodoc
class $AppEventCopyWith<$Res>  {
$AppEventCopyWith(AppEvent _, $Res Function(AppEvent) __);
}


/// Adds pattern-matching-related methods to [AppEvent].
extension AppEventPatterns on AppEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( GetAppConfig value)?  getAppConfig,TResult Function( CleanState value)?  cleanState,required TResult orElse(),}){
final _that = this;
switch (_that) {
case GetAppConfig() when getAppConfig != null:
return getAppConfig(_that);case CleanState() when cleanState != null:
return cleanState(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( GetAppConfig value)  getAppConfig,required TResult Function( CleanState value)  cleanState,}){
final _that = this;
switch (_that) {
case GetAppConfig():
return getAppConfig(_that);case CleanState():
return cleanState(_that);case _:
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( GetAppConfig value)?  getAppConfig,TResult? Function( CleanState value)?  cleanState,}){
final _that = this;
switch (_that) {
case GetAppConfig() when getAppConfig != null:
return getAppConfig(_that);case CleanState() when cleanState != null:
return cleanState(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  getAppConfig,TResult Function()?  cleanState,required TResult orElse(),}) {final _that = this;
switch (_that) {
case GetAppConfig() when getAppConfig != null:
return getAppConfig();case CleanState() when cleanState != null:
return cleanState();case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  getAppConfig,required TResult Function()  cleanState,}) {final _that = this;
switch (_that) {
case GetAppConfig():
return getAppConfig();case CleanState():
return cleanState();case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  getAppConfig,TResult? Function()?  cleanState,}) {final _that = this;
switch (_that) {
case GetAppConfig() when getAppConfig != null:
return getAppConfig();case CleanState() when cleanState != null:
return cleanState();case _:
  return null;

}
}

}

/// @nodoc


class GetAppConfig implements AppEvent {
  const GetAppConfig();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is GetAppConfig);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'AppEvent.getAppConfig()';
}


}




/// @nodoc


class CleanState implements AppEvent {
  const CleanState();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is CleanState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'AppEvent.cleanState()';
}


}




/// @nodoc
mixin _$AppState {

 AppStatus get status; ConfigFailure? get failure;
/// Create a copy of AppState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AppStateCopyWith<AppState> get copyWith => _$AppStateCopyWithImpl<AppState>(this as AppState, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as AppState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AppState&&(identical(other.status, _this.status) || other.status == _this.status)&&(identical(other.failure, _this.failure) || other.failure == _this.failure));
}


@override
int get hashCode {
  final _this = this as AppState;
  return Object.hash(runtimeType,_this.status,_this.failure);
}

@override
String toString() {
  final _this = this as AppState;
  return 'AppState(status: ${_this.status}, failure: ${_this.failure})';
}


}

/// @nodoc
abstract mixin class $AppStateCopyWith<$Res>  {
  factory $AppStateCopyWith(AppState value, $Res Function(AppState) _then) = _$AppStateCopyWithImpl;
@useResult
$Res call({
 AppStatus status, ConfigFailure? failure
});




}
/// @nodoc
class _$AppStateCopyWithImpl<$Res>
    implements $AppStateCopyWith<$Res> {
  _$AppStateCopyWithImpl(this._self, this._then);

  final AppState _self;
  final $Res Function(AppState) _then;

/// Create a copy of AppState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? status = null,Object? failure = freezed,}) {
  return _then(AppState(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as AppStatus,failure: freezed == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as ConfigFailure?,
  ));
}

}


/// Adds pattern-matching-related methods to [AppState].
extension AppStatePatterns on AppState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AppState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AppState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AppState value)  $default,){
final _that = this;
switch (_that) {
case _AppState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AppState value)?  $default,){
final _that = this;
switch (_that) {
case _AppState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( AppStatus status,  ConfigFailure? failure)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AppState() when $default != null:
return $default(_that.status,_that.failure);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( AppStatus status,  ConfigFailure? failure)  $default,) {final _that = this;
switch (_that) {
case _AppState():
return $default(_that.status,_that.failure);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( AppStatus status,  ConfigFailure? failure)?  $default,) {final _that = this;
switch (_that) {
case _AppState() when $default != null:
return $default(_that.status,_that.failure);case _:
  return null;

}
}

}

/// @nodoc


class _AppState implements AppState {
  const _AppState({this.status = AppStatus.loading, this.failure});
  

@override@JsonKey() final  AppStatus status;
@override final  ConfigFailure? failure;

/// Create a copy of AppState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AppStateCopyWith<_AppState> get copyWith => __$AppStateCopyWithImpl<_AppState>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _AppState&&(identical(other.status, status) || other.status == status)&&(identical(other.failure, failure) || other.failure == failure));
}


@override
int get hashCode {
    return Object.hash(runtimeType,status,failure);
}

@override
String toString() {
    return 'AppState(status: $status, failure: $failure)';
}


}

/// @nodoc
abstract mixin class _$AppStateCopyWith<$Res> implements $AppStateCopyWith<$Res> {
  factory _$AppStateCopyWith(_AppState value, $Res Function(_AppState) _then) = __$AppStateCopyWithImpl;
@override @useResult
$Res call({
 AppStatus status, ConfigFailure? failure
});




}
/// @nodoc
class __$AppStateCopyWithImpl<$Res>
    implements _$AppStateCopyWith<$Res> {
  __$AppStateCopyWithImpl(this._self, this._then);

  final _AppState _self;
  final $Res Function(_AppState) _then;

/// Create a copy of AppState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = null,Object? failure = freezed,}) {
  return _then(_AppState(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as AppStatus,failure: freezed == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as ConfigFailure?,
  ));
}


}

// dart format on
