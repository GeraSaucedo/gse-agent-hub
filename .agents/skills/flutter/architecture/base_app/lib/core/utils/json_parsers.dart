/// Shared helpers for `@JsonKey(fromJson: ...)` in the domain models.
library;

/// Reads an `id` that the API may send as a number or a string and keeps it as
/// a `String`. Throws if the id is missing, like any other required field.
///
/// ```dart
/// @JsonKey(fromJson: idFromJson) required String id,
/// ```
String idFromJson(Object? value) => value!.toString();
