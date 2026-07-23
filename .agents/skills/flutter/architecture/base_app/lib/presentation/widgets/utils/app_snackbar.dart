import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gse_design_system/gse_design_system.dart';

class AppSnackbar {
  static void show(
    BuildContext context,
    String message, {
    bool asOverlay = false,
    SnackbarType type = SnackbarType.error,
  }) {
    Color backgroundColor;
    Color textColor;
    //IconData icon;

    final dsColors = context.colors;
    final colors = Theme.of(context).colorScheme;

    switch (type) {
      case SnackbarType.success:
        backgroundColor = dsColors.success;
        textColor = dsColors.onSuccess;
      //icon = Icons.check_circle;
      case SnackbarType.info:
        backgroundColor = dsColors.onSurfaceLow;
        textColor = dsColors.disabled;
      //icon = Icons.info;
      case SnackbarType.error:
        backgroundColor = colors.error;
        textColor = colors.onError;
      //icon = Icons.error;
    }

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
                        //textAlign: TextAlign.center,
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
          //Icon(icon, color: Colors.white),
          //const SizedBox(width: 8),
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
