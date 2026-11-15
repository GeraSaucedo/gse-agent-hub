import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:gse_design_system/gse_design_system.dart';
import 'package:material_ui/material_ui.dart';

class AppSnackbar {
  static void show(
    BuildContext context,
    String message, {
    bool asOverlay = false,
    SnackbarType type = SnackbarType.error,
  }) {
    final colors = context.colors;
    final (backgroundColor, textColor) = switch (type) {
      SnackbarType.success => (colors.success, colors.onSuccess),
      SnackbarType.info => (colors.info, colors.onInfo),
      SnackbarType.error => (colors.error, colors.onError),
    };

    if (asOverlay) {
      final overlay = Overlay.of(context);
      OverlayEntry? entry;

      entry = OverlayEntry(
        builder: (context) => Positioned(
          bottom: MediaQuery.of(context).viewInsets.bottom + context.h(2),
          left: 16,
          right: 16,
          child: GestureDetector(
            onVerticalDragEnd: (details) {
              if (details.velocity.pixelsPerSecond.dy > 50) {
                entry?.remove();
              }
            },
            child: Material(
              color: Colors.transparent,
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: context.w(4),
                  vertical: context.h(2),
                ),
                decoration: BoxDecoration(
                  color: backgroundColor,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        message,
                        style: TextStyle(
                          color: textColor,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );

      overlay.insert(entry);

      Future.delayed(const Duration(seconds: 5), () {
        try {
          entry?.remove();
        } catch (e) {
          if (kDebugMode) log('Error on remove snackbar overlay');
        }
      });
      return;
    }

    final snackbar = SnackBar(
      content: Row(
        children: [
          Expanded(
            child: Text(
              message,
              style: TextStyle(color: textColor),
            ),
          ),
        ],
      ),
      backgroundColor: backgroundColor,
      duration: const Duration(seconds: 5),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackbar);
  }
}

enum SnackbarType { success, info, error }
