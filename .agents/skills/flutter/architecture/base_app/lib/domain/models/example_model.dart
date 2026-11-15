import 'package:gse_base_app/core/utils/json_parsers.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'example_model.freezed.dart';
part 'example_model.g.dart';

/// Product from the DummyJSON example API, which names the text `title`.
@freezed
abstract class ExampleModel with _$ExampleModel {
  const factory({
    @JsonKey(fromJson: idFromJson) required String id,
    @JsonKey(name: 'title') required String text,
  }) = _ExampleModel;

  factory fromJson(Map<String, dynamic> json) => _$ExampleModelFromJson(json);
}
