import 'dart:async';
import 'package:flutter/widgets.dart';

/// Convierte un [Stream] en [ChangeNotifier] para usar como
/// [GoRouter.refreshListenable], re-evaluando el redirect en cada emisión.
class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<dynamic> stream) {
    _subscription = stream.listen((_) => notifyListeners());
  }

  late final StreamSubscription<dynamic> _subscription;

  @override
  void dispose() {
    unawaited(_subscription.cancel());
    super.dispose();
  }
}
