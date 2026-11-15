import 'package:gse_base_app/presentation/widgets/utils/app_loader.dart';
import 'package:material_ui/material_ui.dart';

/// Full-screen, non-dismissible loader.
///
/// It is a route (not a bare [OverlayEntry]) so that:
/// - the system back button can't leave the screen behind it, which used to
///   leave the loader on top of the app forever;
/// - if the navigator drops the page under it (e.g. the auth redirect), the
///   loader goes away with it instead of staying orphaned.
class LoadingOverlay {
  static Route<void>? _route;

  static bool get _isVisible => _route?.isActive ?? false;

  static void show(BuildContext context) {
    if (_isVisible) return;

    final route = DialogRoute<void>(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black.withValues(alpha: 0.75),
      builder: (context) => PopScope(
        canPop: false,
        child: Center(
          child: AppLoader(color: Theme.of(context).colorScheme.primary),
        ),
      ),
    );
    _route = route;
    Navigator.of(context, rootNavigator: true).push(route);
  }

  static void remove() {
    final route = _route;
    _route = null;
    // `removeRoute`, not `pop`: never closes whatever else is on top.
    if (route != null && route.isActive) {
      route.navigator?.removeRoute(route);
    }
  }
}
