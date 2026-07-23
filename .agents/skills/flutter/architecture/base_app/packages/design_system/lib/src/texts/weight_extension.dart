import 'package:flutter/material.dart';

/// Fluent extensions for [TextStyle] manipulation.
///
/// **Semantic weight** — for readability:
/// ```dart
/// context.textStyles.bodyMed.bold
/// context.textStyles.labelSmall.semibold
/// ```
///
/// **Numeric weight** — for precision:
/// ```dart
/// context.textStyles.titleMed.w800
/// ```
///
/// **Style:**
/// ```dart
/// context.textStyles.bodyMed.italic
/// context.textStyles.bodyMed.underline
/// context.textStyles.labelMed.strikethrough
/// ```
///
/// **Color:**
/// ```dart
/// context.textStyles.bodyMed.c(context.colors.primary)
/// ```
///
/// Rule: extensions only modify **one property**. Size and line-height
/// are owned by the base token — never touched via extension.
extension TextStyleFluentX on TextStyle {
  // ── Semantic weights ────────────────────────────────────────────────────

  /// Thin weight (100).
  TextStyle get thin => copyWith(fontWeight: FontWeight.w100);

  /// Light weight (300).
  TextStyle get light => copyWith(fontWeight: FontWeight.w300);

  /// Regular weight (400).
  TextStyle get regular => copyWith(fontWeight: FontWeight.w400);

  /// Medium weight (500).
  TextStyle get medium => copyWith(fontWeight: FontWeight.w500);

  /// SemiBold weight (600).
  TextStyle get semibold => copyWith(fontWeight: FontWeight.w600);

  /// Bold weight (700).
  TextStyle get bold => copyWith(fontWeight: FontWeight.w700);

  /// Heavy weight (800).
  TextStyle get heavy => copyWith(fontWeight: FontWeight.w800);

  /// Black weight (900).
  TextStyle get black => copyWith(fontWeight: FontWeight.w900);

  // ── Numeric weights ─────────────────────────────────────────────────────

  /// Weight 100.
  TextStyle get w100 => copyWith(fontWeight: FontWeight.w100);

  /// Weight 200.
  TextStyle get w200 => copyWith(fontWeight: FontWeight.w200);

  /// Weight 300.
  TextStyle get w300 => copyWith(fontWeight: FontWeight.w300);

  /// Weight 400.
  TextStyle get w400 => copyWith(fontWeight: FontWeight.w400);

  /// Weight 500.
  TextStyle get w500 => copyWith(fontWeight: FontWeight.w500);

  /// Weight 600.
  TextStyle get w600 => copyWith(fontWeight: FontWeight.w600);

  /// Weight 700.
  TextStyle get w700 => copyWith(fontWeight: FontWeight.w700);

  /// Weight 800.
  TextStyle get w800 => copyWith(fontWeight: FontWeight.w800);

  /// Weight 900.
  TextStyle get w900 => copyWith(fontWeight: FontWeight.w900);

  // ── Style ───────────────────────────────────────────────────────────────

  /// Italic style.
  TextStyle get italic => copyWith(fontStyle: FontStyle.italic);

  /// Underline decoration.
  TextStyle get underline =>
      copyWith(decoration: TextDecoration.underline);

  /// Strikethrough decoration.
  TextStyle get strikethrough =>
      copyWith(decoration: TextDecoration.lineThrough);

  // ── Color ───────────────────────────────────────────────────────────────

  /// Applies [color] to the text.
  TextStyle c(Color color) => copyWith(color: color);
}

/// Extension on [String] for text transformations.
///
/// ```dart
/// Text('hello'.upper, style: context.textStyles.labelMed)
/// ```
extension StringCaseX on String {
  /// Returns the string in UPPERCASE.
  String get upper => toUpperCase();
}
