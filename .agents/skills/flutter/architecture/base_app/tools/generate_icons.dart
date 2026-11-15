// Generates the AppIcons enum from the SVG files in assets/icons.
//
// Run from the project root: dart run tools/generate_icons.dart
import 'dart:io';

const _iconsDir = 'assets/icons';
const _outputFile = 'lib/core/icons/app_icon_name.dart';

void main() {
  final fileNames =
      Directory(_iconsDir)
          .listSync()
          .whereType<File>()
          .map((file) => file.uri.pathSegments.last)
          .where((name) => name.toLowerCase().endsWith('.svg'))
          .map((name) => name.substring(0, name.length - '.svg'.length))
          .toList()
        ..sort();

  // Value name -> SVG file name (without extension).
  final icons = <String, String>{};
  for (final fileName in fileNames) {
    final valueName = _toIdentifier(fileName);
    final existing = icons[valueName];
    if (existing != null) {
      throw StateError(
        '"$existing.svg" and "$fileName.svg" both generate "$valueName". '
        'Rename one of them.',
      );
    }
    icons[valueName] = fileName;
  }

  final values = icons.entries
      .map((icon) => "  ${icon.key}('${icon.value}')")
      .join(',\n');

  final source =
      '''
// GENERATED CODE - DO NOT MODIFY BY HAND
// Run `dart run tools/generate_icons.dart` after adding or removing an SVG.

/// Available icons in the application.
/// This enum is generated automatically from the SVG files in $_iconsDir.
/// Used by [AppIcon] widget to display SVG icons consistently across the app.
enum AppIcons {
$values;

  new(this.fileName);

  /// SVG file name in $_iconsDir, without the extension.
  final String fileName;
}
''';

  File(_outputFile)
    ..createSync(recursive: true)
    ..writeAsStringSync(source);
}

/// `arrow-left`, `arrow_left` or `arrow left` -> `arrowLeft`.
/// Names that start with a digit get an `icon` prefix: `3d-box` -> `icon3dBox`.
String _toIdentifier(String fileName) {
  final words = fileName
      .split(RegExp('[^A-Za-z0-9]+'))
      .where((word) => word.isNotEmpty)
      .toList();
  if (words.isEmpty) {
    throw StateError('"$fileName.svg" has no valid characters for a name.');
  }

  final name = [
    words.first.toLowerCase(),
    for (final word in words.skip(1))
      word[0].toUpperCase() + word.substring(1).toLowerCase(),
  ].join();

  return name.startsWith(RegExp('[0-9]'))
      ? 'icon${name[0].toUpperCase()}${name.substring(1)}'
      : name;
}
