import 'package:flutter/material.dart';
import 'package:gse_localization/gse_localization.dart';

/// Blocking dialog shown when the refresh token is rejected and the
/// session can no longer be renewed.
class SessionExpiredDialog extends StatelessWidget {
  const SessionExpiredDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return PopScope(
      canPop: false,
      child: AlertDialog(
        title: Text(l10n.sessionExpiredTitle),
        content: Text(l10n.sessionExpiredMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(l10n.sessionExpiredAction),
          ),
        ],
      ),
    );
  }

  static Future<void> show(BuildContext context) => showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (_) => const SessionExpiredDialog(),
  );
}
