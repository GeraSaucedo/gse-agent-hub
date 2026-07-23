import 'package:freezed_annotation/freezed_annotation.dart';

part 'example_model.freezed.dart';

@freezed
abstract class ExampleModel with _$ExampleModel {
  const factory ExampleModel({
    required String id,
    required String text,
  }) = _ExampleModel;

  factory ExampleModel.fromJson(Map<String, dynamic> json) {
    return ExampleModel(
      id: json['id'].toString(),
      text: json['title'] as String? ?? '',
    );
  }
}
