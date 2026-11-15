// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'example_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ExampleModel _$ExampleModelFromJson(Map<String, dynamic> json) =>
    _ExampleModel(id: idFromJson(json['id']), text: json['title'] as String);

Map<String, dynamic> _$ExampleModelToJson(_ExampleModel instance) =>
    <String, dynamic>{'id': instance.id, 'title': instance.text};
