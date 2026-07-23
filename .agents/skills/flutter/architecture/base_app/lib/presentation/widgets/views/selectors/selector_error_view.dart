import 'package:flutter/material.dart';
import 'package:gse_design_system/gse_design_system.dart';
import 'package:gse_localization/gse_localization.dart';

class SelectorErrorView extends StatelessWidget {
  const SelectorErrorView({
    super.key,
    this.text,
    this.onReintent,
  });

  final String? text;
  final VoidCallback? onReintent;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: context.w(12)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.warning_amber_rounded,
            color: colorScheme.error,
            size: context.sp(32),
          ),
          SizedBox(height: context.h(3)),
          Text(
            text ?? AppLocalizations.of(context)!.selectorErrorMessage,
            style: textTheme.titleMedium,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: context.h(6)),
          ElevatedButton(
            onPressed: onReintent,
            child: Text(AppLocalizations.of(context)!.retryButton),
          ),
        ],
      ),
    );
  }
}
