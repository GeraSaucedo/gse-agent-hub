// tool/generate_icons.dart
import 'dart:io';

void main() {
  final iconFiles =
      Directory('assets/icons')
          .listSync()
          .whereType<File>()
          .where((file) => file.path.toLowerCase().endsWith('.svg'))
          .map((file) => file.uri.pathSegments.last.replaceAll('.svg', ''))
          .toList()
        ..sort();

  final buffer = StringBuffer()
    ..writeln('''
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: constant_identifier_names

/// Available icons in the application.
/// This enum is generated automatically from the SVG files in assets/icons directory.
/// Used by [AppIcon] widget to display SVG icons consistently across the app.
enum AppIcons {''')
    ..writeln(iconFiles.join(',\n  '))
    ..writeln('}');

  Directory('lib/core/theme/icons').createSync(recursive: true);
  File(
    'lib/core/theme/icons/app_icon_name.dart',
  ).writeAsStringSync(buffer.toString());
}
