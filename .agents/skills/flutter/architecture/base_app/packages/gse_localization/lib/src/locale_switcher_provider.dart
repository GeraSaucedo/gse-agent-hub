import 'package:flutter/widgets.dart';
import 'package:gse_localization/generated/app_localizations.dart';
import 'package:gse_localization/src/locale_controller.dart';

class _LocaleSwitcherInherited extends InheritedNotifier<LocaleController> {
  const _LocaleSwitcherInherited({
    required LocaleController controller,
    required super.child,
  }) : super(notifier: controller);
}

/// Provides a [LocaleController] to the widget tree via [InheritedNotifier].
class LocaleSwitcherProvider extends StatefulWidget {
  /// Creates a [LocaleSwitcherProvider] that wraps [child].
  const LocaleSwitcherProvider({
    required this.child,
    this.defaultLocale = const Locale('es'),
    super.key,
  });

  /// The widget below this provider in the tree.
  final Widget child;

  /// The default [Locale] before any saved preference is loaded.
  final Locale defaultLocale;

  /// Returns the nearest [LocaleController] in the widget tree.
  static LocaleController of(BuildContext context) {
    final inherited = context
        .dependOnInheritedWidgetOfExactType<_LocaleSwitcherInherited>();
    assert(inherited != null, 'No LocaleSwitcherProvider found in context');
    return inherited!.notifier!;
  }

  @override
  State<LocaleSwitcherProvider> createState() => _LocaleSwitcherProviderState();
}

class _LocaleSwitcherProviderState extends State<LocaleSwitcherProvider> {
  late final LocaleController _controller;

  @override
  void initState() {
    super.initState();
    _controller = LocaleController(
      supportedLocales: AppLocalizations.supportedLocales,
      defaultLocale: widget.defaultLocale,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _LocaleSwitcherInherited(
      controller: _controller,
      child: widget.child,
    );
  }
}
