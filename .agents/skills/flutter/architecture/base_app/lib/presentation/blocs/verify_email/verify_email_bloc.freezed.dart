// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'verify_email_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$VerifyEmailEvent {





@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is VerifyEmailEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'VerifyEmailEvent()';
}


}

/// @nodoc
class $VerifyEmailEventCopyWith<$Res>  {
$VerifyEmailEventCopyWith(VerifyEmailEvent _, $Res Function(VerifyEmailEvent) __);
}


/// Adds pattern-matching-related methods to [VerifyEmailEvent].
extension VerifyEmailEventPatterns on VerifyEmailEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( InitRequested value)?  initRequested,TResult Function( EmailSet value)?  emailSet,TResult Function( CodeChanged value)?  codeChanged,TResult Function( ResendRequested value)?  resendRequested,TResult Function( FormSubmitted value)?  formSubmitted,TResult Function( CleanState value)?  cleanState,required TResult orElse(),}){
final _that = this;
switch (_that) {
case InitRequested() when initRequested != null:
return initRequested(_that);case EmailSet() when emailSet != null:
return emailSet(_that);case CodeChanged() when codeChanged != null:
return codeChanged(_that);case ResendRequested() when resendRequested != null:
return resendRequested(_that);case FormSubmitted() when formSubmitted != null:
return formSubmitted(_that);case CleanState() when cleanState != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( InitRequested value)  initRequested,required TResult Function( EmailSet value)  emailSet,required TResult Function( CodeChanged value)  codeChanged,required TResult Function( ResendRequested value)  resendRequested,required TResult Function( FormSubmitted value)  formSubmitted,required TResult Function( CleanState value)  cleanState,}){
final _that = this;
switch (_that) {
case InitRequested():
return initRequested(_that);case EmailSet():
return emailSet(_that);case CodeChanged():
return codeChanged(_that);case ResendRequested():
return resendRequested(_that);case FormSubmitted():
return formSubmitted(_that);case CleanState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( InitRequested value)?  initRequested,TResult? Function( EmailSet value)?  emailSet,TResult? Function( CodeChanged value)?  codeChanged,TResult? Function( ResendRequested value)?  resendRequested,TResult? Function( FormSubmitted value)?  formSubmitted,TResult? Function( CleanState value)?  cleanState,}){
final _that = this;
switch (_that) {
case InitRequested() when initRequested != null:
return initRequested(_that);case EmailSet() when emailSet != null:
return emailSet(_that);case CodeChanged() when codeChanged != null:
return codeChanged(_that);case ResendRequested() when resendRequested != null:
return resendRequested(_that);case FormSubmitted() when formSubmitted != null:
return formSubmitted(_that);case CleanState() when cleanState != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( String email)?  initRequested,TResult Function( String email)?  emailSet,TResult Function( String code)?  codeChanged,TResult Function()?  resendRequested,TResult Function()?  formSubmitted,TResult Function()?  cleanState,required TResult orElse(),}) {final _that = this;
switch (_that) {
case InitRequested() when initRequested != null:
return initRequested(_that.email);case EmailSet() when emailSet != null:
return emailSet(_that.email);case CodeChanged() when codeChanged != null:
return codeChanged(_that.code);case ResendRequested() when resendRequested != null:
return resendRequested();case FormSubmitted() when formSubmitted != null:
return formSubmitted();case CleanState() when cleanState != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( String email)  initRequested,required TResult Function( String email)  emailSet,required TResult Function( String code)  codeChanged,required TResult Function()  resendRequested,required TResult Function()  formSubmitted,required TResult Function()  cleanState,}) {final _that = this;
switch (_that) {
case InitRequested():
return initRequested(_that.email);case EmailSet():
return emailSet(_that.email);case CodeChanged():
return codeChanged(_that.code);case ResendRequested():
return resendRequested();case FormSubmitted():
return formSubmitted();case CleanState():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( String email)?  initRequested,TResult? Function( String email)?  emailSet,TResult? Function( String code)?  codeChanged,TResult? Function()?  resendRequested,TResult? Function()?  formSubmitted,TResult? Function()?  cleanState,}) {final _that = this;
switch (_that) {
case InitRequested() when initRequested != null:
return initRequested(_that.email);case EmailSet() when emailSet != null:
return emailSet(_that.email);case CodeChanged() when codeChanged != null:
return codeChanged(_that.code);case ResendRequested() when resendRequested != null:
return resendRequested();case FormSubmitted() when formSubmitted != null:
return formSubmitted();case CleanState() when cleanState != null:
return cleanState();case _:
  return null;

}
}

}

/// @nodoc


class InitRequested implements VerifyEmailEvent {
  const InitRequested(this.email);
  

 final  String email;

/// Create a copy of VerifyEmailEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$InitRequestedCopyWith<InitRequested> get copyWith => _$InitRequestedCopyWithImpl<InitRequested>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is InitRequested&&(identical(other.email, email) || other.email == email));
}


@override
int get hashCode {
    return Object.hash(runtimeType,email);
}

@override
String toString() {
    return 'VerifyEmailEvent.initRequested(email: $email)';
}


}

/// @nodoc
abstract mixin class $InitRequestedCopyWith<$Res> implements $VerifyEmailEventCopyWith<$Res> {
  factory $InitRequestedCopyWith(InitRequested value, $Res Function(InitRequested) _then) = _$InitRequestedCopyWithImpl;
@useResult
$Res call({
 String email
});




}
/// @nodoc
class _$InitRequestedCopyWithImpl<$Res>
    implements $InitRequestedCopyWith<$Res> {
  _$InitRequestedCopyWithImpl(this._self, this._then);

  final InitRequested _self;
  final $Res Function(InitRequested) _then;

/// Create a copy of VerifyEmailEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? email = null,}) {
  return _then(InitRequested(
null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class EmailSet implements VerifyEmailEvent {
  const EmailSet(this.email);
  

 final  String email;

/// Create a copy of VerifyEmailEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EmailSetCopyWith<EmailSet> get copyWith => _$EmailSetCopyWithImpl<EmailSet>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is EmailSet&&(identical(other.email, email) || other.email == email));
}


@override
int get hashCode {
    return Object.hash(runtimeType,email);
}

@override
String toString() {
    return 'VerifyEmailEvent.emailSet(email: $email)';
}


}

/// @nodoc
abstract mixin class $EmailSetCopyWith<$Res> implements $VerifyEmailEventCopyWith<$Res> {
  factory $EmailSetCopyWith(EmailSet value, $Res Function(EmailSet) _then) = _$EmailSetCopyWithImpl;
@useResult
$Res call({
 String email
});




}
/// @nodoc
class _$EmailSetCopyWithImpl<$Res>
    implements $EmailSetCopyWith<$Res> {
  _$EmailSetCopyWithImpl(this._self, this._then);

  final EmailSet _self;
  final $Res Function(EmailSet) _then;

/// Create a copy of VerifyEmailEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? email = null,}) {
  return _then(EmailSet(
null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class CodeChanged implements VerifyEmailEvent {
  const CodeChanged(this.code);
  

 final  String code;

/// Create a copy of VerifyEmailEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CodeChangedCopyWith<CodeChanged> get copyWith => _$CodeChangedCopyWithImpl<CodeChanged>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is CodeChanged&&(identical(other.code, code) || other.code == code));
}


@override
int get hashCode {
    return Object.hash(runtimeType,code);
}

@override
String toString() {
    return 'VerifyEmailEvent.codeChanged(code: $code)';
}


}

/// @nodoc
abstract mixin class $CodeChangedCopyWith<$Res> implements $VerifyEmailEventCopyWith<$Res> {
  factory $CodeChangedCopyWith(CodeChanged value, $Res Function(CodeChanged) _then) = _$CodeChangedCopyWithImpl;
@useResult
$Res call({
 String code
});




}
/// @nodoc
class _$CodeChangedCopyWithImpl<$Res>
    implements $CodeChangedCopyWith<$Res> {
  _$CodeChangedCopyWithImpl(this._self, this._then);

  final CodeChanged _self;
  final $Res Function(CodeChanged) _then;

/// Create a copy of VerifyEmailEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? code = null,}) {
  return _then(CodeChanged(
null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class ResendRequested implements VerifyEmailEvent {
  const ResendRequested();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is ResendRequested);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'VerifyEmailEvent.resendRequested()';
}


}




/// @nodoc


class FormSubmitted implements VerifyEmailEvent {
  const FormSubmitted();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is FormSubmitted);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'VerifyEmailEvent.formSubmitted()';
}


}




/// @nodoc


class CleanState implements VerifyEmailEvent {
  const CleanState();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is CleanState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'VerifyEmailEvent.cleanState()';
}


}




/// @nodoc
mixin _$VerifyEmailState {

 FormzSubmissionStatus get status; String get email; String get code; VerifyEmailFailure? get failure;
/// Create a copy of VerifyEmailState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$VerifyEmailStateCopyWith<VerifyEmailState> get copyWith => _$VerifyEmailStateCopyWithImpl<VerifyEmailState>(this as VerifyEmailState, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as VerifyEmailState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is VerifyEmailState&&(identical(other.status, _this.status) || other.status == _this.status)&&(identical(other.email, _this.email) || other.email == _this.email)&&(identical(other.code, _this.code) || other.code == _this.code)&&(identical(other.failure, _this.failure) || other.failure == _this.failure));
}


@override
int get hashCode {
  final _this = this as VerifyEmailState;
  return Object.hash(runtimeType,_this.status,_this.email,_this.code,_this.failure);
}

@override
String toString() {
  final _this = this as VerifyEmailState;
  return 'VerifyEmailState(status: ${_this.status}, email: ${_this.email}, code: ${_this.code}, failure: ${_this.failure})';
}


}

/// @nodoc
abstract mixin class $VerifyEmailStateCopyWith<$Res>  {
  factory $VerifyEmailStateCopyWith(VerifyEmailState value, $Res Function(VerifyEmailState) _then) = _$VerifyEmailStateCopyWithImpl;
@useResult
$Res call({
 FormzSubmissionStatus status, String email, String code, VerifyEmailFailure? failure
});




}
/// @nodoc
class _$VerifyEmailStateCopyWithImpl<$Res>
    implements $VerifyEmailStateCopyWith<$Res> {
  _$VerifyEmailStateCopyWithImpl(this._self, this._then);

  final VerifyEmailState _self;
  final $Res Function(VerifyEmailState) _then;

/// Create a copy of VerifyEmailState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? status = null,Object? email = null,Object? code = null,Object? failure = freezed,}) {
  return _then(VerifyEmailState(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as FormzSubmissionStatus,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,failure: freezed == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as VerifyEmailFailure?,
  ));
}

}


/// Adds pattern-matching-related methods to [VerifyEmailState].
extension VerifyEmailStatePatterns on VerifyEmailState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _VerifyEmailState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _VerifyEmailState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _VerifyEmailState value)  $default,){
final _that = this;
switch (_that) {
case _VerifyEmailState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _VerifyEmailState value)?  $default,){
final _that = this;
switch (_that) {
case _VerifyEmailState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( FormzSubmissionStatus status,  String email,  String code,  VerifyEmailFailure? failure)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _VerifyEmailState() when $default != null:
return $default(_that.status,_that.email,_that.code,_that.failure);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( FormzSubmissionStatus status,  String email,  String code,  VerifyEmailFailure? failure)  $default,) {final _that = this;
switch (_that) {
case _VerifyEmailState():
return $default(_that.status,_that.email,_that.code,_that.failure);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( FormzSubmissionStatus status,  String email,  String code,  VerifyEmailFailure? failure)?  $default,) {final _that = this;
switch (_that) {
case _VerifyEmailState() when $default != null:
return $default(_that.status,_that.email,_that.code,_that.failure);case _:
  return null;

}
}

}

/// @nodoc


class _VerifyEmailState implements VerifyEmailState {
  const _VerifyEmailState({this.status = FormzSubmissionStatus.initial, this.email = '', this.code = '', this.failure});
  

@override@JsonKey() final  FormzSubmissionStatus status;
@override@JsonKey() final  String email;
@override@JsonKey() final  String code;
@override final  VerifyEmailFailure? failure;

/// Create a copy of VerifyEmailState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$VerifyEmailStateCopyWith<_VerifyEmailState> get copyWith => __$VerifyEmailStateCopyWithImpl<_VerifyEmailState>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _VerifyEmailState&&(identical(other.status, status) || other.status == status)&&(identical(other.email, email) || other.email == email)&&(identical(other.code, code) || other.code == code)&&(identical(other.failure, failure) || other.failure == failure));
}


@override
int get hashCode {
    return Object.hash(runtimeType,status,email,code,failure);
}

@override
String toString() {
    return 'VerifyEmailState(status: $status, email: $email, code: $code, failure: $failure)';
}


}

/// @nodoc
abstract mixin class _$VerifyEmailStateCopyWith<$Res> implements $VerifyEmailStateCopyWith<$Res> {
  factory _$VerifyEmailStateCopyWith(_VerifyEmailState value, $Res Function(_VerifyEmailState) _then) = __$VerifyEmailStateCopyWithImpl;
@override @useResult
$Res call({
 FormzSubmissionStatus status, String email, String code, VerifyEmailFailure? failure
});




}
/// @nodoc
class __$VerifyEmailStateCopyWithImpl<$Res>
    implements _$VerifyEmailStateCopyWith<$Res> {
  __$VerifyEmailStateCopyWithImpl(this._self, this._then);

  final _VerifyEmailState _self;
  final $Res Function(_VerifyEmailState) _then;

/// Create a copy of VerifyEmailState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = null,Object? email = null,Object? code = null,Object? failure = freezed,}) {
  return _then(_VerifyEmailState(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as FormzSubmissionStatus,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,failure: freezed == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as VerifyEmailFailure?,
  ));
}


}

// dart format on
