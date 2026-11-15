// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'login_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$LoginEvent {





@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is LoginEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'LoginEvent()';
}


}

/// @nodoc
class $LoginEventCopyWith<$Res>  {
$LoginEventCopyWith(LoginEvent _, $Res Function(LoginEvent) __);
}


/// Adds pattern-matching-related methods to [LoginEvent].
extension LoginEventPatterns on LoginEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( EmailChanged value)?  emailChanged,TResult Function( PasswordChanged value)?  passwordChanged,TResult Function( FormSubmitted value)?  formSubmitted,TResult Function( CleanState value)?  cleanState,required TResult orElse(),}){
final _that = this;
switch (_that) {
case EmailChanged() when emailChanged != null:
return emailChanged(_that);case PasswordChanged() when passwordChanged != null:
return passwordChanged(_that);case FormSubmitted() when formSubmitted != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( EmailChanged value)  emailChanged,required TResult Function( PasswordChanged value)  passwordChanged,required TResult Function( FormSubmitted value)  formSubmitted,required TResult Function( CleanState value)  cleanState,}){
final _that = this;
switch (_that) {
case EmailChanged():
return emailChanged(_that);case PasswordChanged():
return passwordChanged(_that);case FormSubmitted():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( EmailChanged value)?  emailChanged,TResult? Function( PasswordChanged value)?  passwordChanged,TResult? Function( FormSubmitted value)?  formSubmitted,TResult? Function( CleanState value)?  cleanState,}){
final _that = this;
switch (_that) {
case EmailChanged() when emailChanged != null:
return emailChanged(_that);case PasswordChanged() when passwordChanged != null:
return passwordChanged(_that);case FormSubmitted() when formSubmitted != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( String email)?  emailChanged,TResult Function( String password)?  passwordChanged,TResult Function()?  formSubmitted,TResult Function()?  cleanState,required TResult orElse(),}) {final _that = this;
switch (_that) {
case EmailChanged() when emailChanged != null:
return emailChanged(_that.email);case PasswordChanged() when passwordChanged != null:
return passwordChanged(_that.password);case FormSubmitted() when formSubmitted != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( String email)  emailChanged,required TResult Function( String password)  passwordChanged,required TResult Function()  formSubmitted,required TResult Function()  cleanState,}) {final _that = this;
switch (_that) {
case EmailChanged():
return emailChanged(_that.email);case PasswordChanged():
return passwordChanged(_that.password);case FormSubmitted():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( String email)?  emailChanged,TResult? Function( String password)?  passwordChanged,TResult? Function()?  formSubmitted,TResult? Function()?  cleanState,}) {final _that = this;
switch (_that) {
case EmailChanged() when emailChanged != null:
return emailChanged(_that.email);case PasswordChanged() when passwordChanged != null:
return passwordChanged(_that.password);case FormSubmitted() when formSubmitted != null:
return formSubmitted();case CleanState() when cleanState != null:
return cleanState();case _:
  return null;

}
}

}

/// @nodoc


class EmailChanged implements LoginEvent {
  const EmailChanged(this.email);
  

 final  String email;

/// Create a copy of LoginEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EmailChangedCopyWith<EmailChanged> get copyWith => _$EmailChangedCopyWithImpl<EmailChanged>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is EmailChanged&&(identical(other.email, email) || other.email == email));
}


@override
int get hashCode {
    return Object.hash(runtimeType,email);
}

@override
String toString() {
    return 'LoginEvent.emailChanged(email: $email)';
}


}

/// @nodoc
abstract mixin class $EmailChangedCopyWith<$Res> implements $LoginEventCopyWith<$Res> {
  factory $EmailChangedCopyWith(EmailChanged value, $Res Function(EmailChanged) _then) = _$EmailChangedCopyWithImpl;
@useResult
$Res call({
 String email
});




}
/// @nodoc
class _$EmailChangedCopyWithImpl<$Res>
    implements $EmailChangedCopyWith<$Res> {
  _$EmailChangedCopyWithImpl(this._self, this._then);

  final EmailChanged _self;
  final $Res Function(EmailChanged) _then;

/// Create a copy of LoginEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? email = null,}) {
  return _then(EmailChanged(
null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class PasswordChanged implements LoginEvent {
  const PasswordChanged(this.password);
  

 final  String password;

/// Create a copy of LoginEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PasswordChangedCopyWith<PasswordChanged> get copyWith => _$PasswordChangedCopyWithImpl<PasswordChanged>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is PasswordChanged&&(identical(other.password, password) || other.password == password));
}


@override
int get hashCode {
    return Object.hash(runtimeType,password);
}

@override
String toString() {
    return 'LoginEvent.passwordChanged(password: $password)';
}


}

/// @nodoc
abstract mixin class $PasswordChangedCopyWith<$Res> implements $LoginEventCopyWith<$Res> {
  factory $PasswordChangedCopyWith(PasswordChanged value, $Res Function(PasswordChanged) _then) = _$PasswordChangedCopyWithImpl;
@useResult
$Res call({
 String password
});




}
/// @nodoc
class _$PasswordChangedCopyWithImpl<$Res>
    implements $PasswordChangedCopyWith<$Res> {
  _$PasswordChangedCopyWithImpl(this._self, this._then);

  final PasswordChanged _self;
  final $Res Function(PasswordChanged) _then;

/// Create a copy of LoginEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? password = null,}) {
  return _then(PasswordChanged(
null == password ? _self.password : password // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class FormSubmitted implements LoginEvent {
  const FormSubmitted();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is FormSubmitted);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'LoginEvent.formSubmitted()';
}


}




/// @nodoc


class CleanState implements LoginEvent {
  const CleanState();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is CleanState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'LoginEvent.cleanState()';
}


}




/// @nodoc
mixin _$LoginState {

 FormzSubmissionStatus get status; EmailInput get email; PasswordInput get password; AuthFailure? get failure; String get unverifiedEmail;
/// Create a copy of LoginState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LoginStateCopyWith<LoginState> get copyWith => _$LoginStateCopyWithImpl<LoginState>(this as LoginState, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as LoginState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LoginState&&(identical(other.status, _this.status) || other.status == _this.status)&&(identical(other.email, _this.email) || other.email == _this.email)&&(identical(other.password, _this.password) || other.password == _this.password)&&(identical(other.failure, _this.failure) || other.failure == _this.failure)&&(identical(other.unverifiedEmail, _this.unverifiedEmail) || other.unverifiedEmail == _this.unverifiedEmail));
}


@override
int get hashCode {
  final _this = this as LoginState;
  return Object.hash(runtimeType,_this.status,_this.email,_this.password,_this.failure,_this.unverifiedEmail);
}

@override
String toString() {
  final _this = this as LoginState;
  return 'LoginState(status: ${_this.status}, email: ${_this.email}, password: ${_this.password}, failure: ${_this.failure}, unverifiedEmail: ${_this.unverifiedEmail})';
}


}

/// @nodoc
abstract mixin class $LoginStateCopyWith<$Res>  {
  factory $LoginStateCopyWith(LoginState value, $Res Function(LoginState) _then) = _$LoginStateCopyWithImpl;
@useResult
$Res call({
 FormzSubmissionStatus status, EmailInput email, PasswordInput password, AuthFailure? failure, String unverifiedEmail
});




}
/// @nodoc
class _$LoginStateCopyWithImpl<$Res>
    implements $LoginStateCopyWith<$Res> {
  _$LoginStateCopyWithImpl(this._self, this._then);

  final LoginState _self;
  final $Res Function(LoginState) _then;

/// Create a copy of LoginState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? status = null,Object? email = null,Object? password = null,Object? failure = freezed,Object? unverifiedEmail = null,}) {
  return _then(LoginState(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as FormzSubmissionStatus,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as EmailInput,password: null == password ? _self.password : password // ignore: cast_nullable_to_non_nullable
as PasswordInput,failure: freezed == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as AuthFailure?,unverifiedEmail: null == unverifiedEmail ? _self.unverifiedEmail : unverifiedEmail // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [LoginState].
extension LoginStatePatterns on LoginState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LoginState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LoginState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LoginState value)  $default,){
final _that = this;
switch (_that) {
case _LoginState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LoginState value)?  $default,){
final _that = this;
switch (_that) {
case _LoginState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( FormzSubmissionStatus status,  EmailInput email,  PasswordInput password,  AuthFailure? failure,  String unverifiedEmail)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LoginState() when $default != null:
return $default(_that.status,_that.email,_that.password,_that.failure,_that.unverifiedEmail);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( FormzSubmissionStatus status,  EmailInput email,  PasswordInput password,  AuthFailure? failure,  String unverifiedEmail)  $default,) {final _that = this;
switch (_that) {
case _LoginState():
return $default(_that.status,_that.email,_that.password,_that.failure,_that.unverifiedEmail);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( FormzSubmissionStatus status,  EmailInput email,  PasswordInput password,  AuthFailure? failure,  String unverifiedEmail)?  $default,) {final _that = this;
switch (_that) {
case _LoginState() when $default != null:
return $default(_that.status,_that.email,_that.password,_that.failure,_that.unverifiedEmail);case _:
  return null;

}
}

}

/// @nodoc


class _LoginState implements LoginState {
  const _LoginState({this.status = FormzSubmissionStatus.initial, this.email = const EmailInput.pure(), this.password = const PasswordInput.pure(), this.failure, this.unverifiedEmail = ''});
  

@override@JsonKey() final  FormzSubmissionStatus status;
@override@JsonKey() final  EmailInput email;
@override@JsonKey() final  PasswordInput password;
@override final  AuthFailure? failure;
@override@JsonKey() final  String unverifiedEmail;

/// Create a copy of LoginState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LoginStateCopyWith<_LoginState> get copyWith => __$LoginStateCopyWithImpl<_LoginState>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _LoginState&&(identical(other.status, status) || other.status == status)&&(identical(other.email, email) || other.email == email)&&(identical(other.password, password) || other.password == password)&&(identical(other.failure, failure) || other.failure == failure)&&(identical(other.unverifiedEmail, unverifiedEmail) || other.unverifiedEmail == unverifiedEmail));
}


@override
int get hashCode {
    return Object.hash(runtimeType,status,email,password,failure,unverifiedEmail);
}

@override
String toString() {
    return 'LoginState(status: $status, email: $email, password: $password, failure: $failure, unverifiedEmail: $unverifiedEmail)';
}


}

/// @nodoc
abstract mixin class _$LoginStateCopyWith<$Res> implements $LoginStateCopyWith<$Res> {
  factory _$LoginStateCopyWith(_LoginState value, $Res Function(_LoginState) _then) = __$LoginStateCopyWithImpl;
@override @useResult
$Res call({
 FormzSubmissionStatus status, EmailInput email, PasswordInput password, AuthFailure? failure, String unverifiedEmail
});




}
/// @nodoc
class __$LoginStateCopyWithImpl<$Res>
    implements _$LoginStateCopyWith<$Res> {
  __$LoginStateCopyWithImpl(this._self, this._then);

  final _LoginState _self;
  final $Res Function(_LoginState) _then;

/// Create a copy of LoginState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = null,Object? email = null,Object? password = null,Object? failure = freezed,Object? unverifiedEmail = null,}) {
  return _then(_LoginState(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as FormzSubmissionStatus,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as EmailInput,password: null == password ? _self.password : password // ignore: cast_nullable_to_non_nullable
as PasswordInput,failure: freezed == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as AuthFailure?,unverifiedEmail: null == unverifiedEmail ? _self.unverifiedEmail : unverifiedEmail // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
