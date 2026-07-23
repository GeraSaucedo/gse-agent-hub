import 'package:flutter/material.dart';
import 'package:gse_base_app/presentation/widgets/utils/app_loader.dart';

class LoadingOverlay {
  static OverlayEntry? _overlayEntry;
  static bool _isVisible = false;

  static void show(BuildContext context) {
    if (_isVisible) return;

    _overlayEntry = OverlayEntry(
      builder: (context) => Stack(
        children: [
          ModalBarrier(
            dismissible: false,
            color: Colors.black.withValues(alpha:0.75),
          ),
          Center(
            child: AppLoader(
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ],
      ),
    );

    _isVisible = true;
    Overlay.of(context).insert(_overlayEntry!);
  }

  static void remove() {
    _overlayEntry?.remove();
    _overlayEntry = null;
    _isVisible = false;
  }
}
