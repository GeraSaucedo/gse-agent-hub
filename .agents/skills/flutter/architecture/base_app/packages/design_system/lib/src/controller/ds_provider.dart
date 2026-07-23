import 'package:flutter/material.dart';
import 'package:gse_design_system/src/controller/ds_controller.dart';

class _DSInherited extends InheritedNotifier<DSController> {
  const _DSInherited({
    required DSController controller,
    required super.child,
  }) : super(notifier: controller);
}

/// Provides a [DSController] to the widget tree via [InheritedNotifier].
///
/// Place this widget above `MaterialApp` and use [DSProvider.of]
/// to access the controller from any descendant widget.
///
/// ```dart
/// DSProvider(
///   controller: widget.dsController,
///   child: Builder(
///     builder: (context) {
///       final ds = DSProvider.of(context);
///       return MaterialApp(
///         theme:     ds.lightTheme,
///         darkTheme: ds.darkTheme,
///         themeMode: ds.themeMode,
///       );
///     },
///   ),
/// );
/// ```
class DSProvider extends StatefulWidget {
  /// Creates a [DSProvider] that wraps [child].
  ///
  /// If a pre-loaded [controller] is provided (via `DSController.preload`),
  /// it is used directly. Otherwise, one is created internally using
  /// [defaultThemeMode] as the initial value.
  const DSProvider({
    required this.child,
    this.controller,
    this.defaultThemeMode = ThemeMode.dark,
    super.key,
  });

  /// The child widget.
  final Widget child;

  /// Pre-loaded controller. If `null`, one is created internally.
  final DSController? controller;

  /// Default theme mode when no [controller] is provided.
  final ThemeMode defaultThemeMode;

  /// Returns the nearest [DSController] in the widget tree.
  static DSController of(BuildContext context) {
    final inherited =
        context.dependOnInheritedWidgetOfExactType<_DSInherited>();
    assert(inherited != null, 'No DSProvider found in context');
    return inherited!.notifier!;
  }

  @override
  State<DSProvider> createState() => _DSProviderState();
}

/// [BuildContext] extension for accessing the active [DSController].
///
/// ```dart
/// context.ds.toggleTheme();
/// context.ds.isDark;
/// ```
extension DSProviderX on BuildContext {
  /// Returns the nearest [DSController] in the widget tree.
  DSController get ds => DSProvider.of(this);
}

class _DSProviderState extends State<DSProvider> {
  late final DSController _controller;
  late final bool _ownsController;

  @override
  void initState() {
    super.initState();
    if (widget.controller != null) {
      _controller = widget.controller!;
      _ownsController = false;
    } else {
      _controller = DSController(defaultTheme: widget.defaultThemeMode);
      _ownsController = true;
    }
  }

  @override
  void dispose() {
    if (_ownsController) _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _DSInherited(
      controller: _controller,
      child: widget.child,
    );
  }
}
