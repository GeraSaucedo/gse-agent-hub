import 'dart:convert';

import 'package:freezed_annotation/freezed_annotation.dart';

part 'user.freezed.dart';

@Freezed(fromJson: false, toJson: false)
abstract class User with _$User {
  const factory User({
    required String id,
    required String name,
  }) = _User;

  const User._();

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'] as String,
      name: map['name'] as String,
    );
  }

  factory User.fromJson(String source) => User.fromMap(
    json.decode(source) as Map<String, dynamic>,
  );

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
    };
  }

  String toJson() => json.encode(toMap());
}
