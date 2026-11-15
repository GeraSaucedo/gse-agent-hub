import 'package:gse_base_app/core/utils/json_parsers.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'user.freezed.dart';
part 'user.g.dart';

@freezed
abstract class User with _$User {
  const factory({
    @JsonKey(fromJson: idFromJson) required String id,
    required String name,
  }) = _User;

  factory fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
}
