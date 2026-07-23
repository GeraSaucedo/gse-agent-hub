import 'package:flutter/material.dart';
import 'package:gse_design_system/gse_design_system.dart';
import 'package:gse_localization/gse_localization.dart';

class SelectorEmptyView extends StatelessWidget {
  const SelectorEmptyView({
    super.key,
    this.text,
  });

  final String? text;

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
            Icons.remove_from_queue_sharp,
            color: colorScheme.primary,
            size: context.sp(32),
          ),
          SizedBox(height: context.h(4)),
          Text(
            text ?? AppLocalizations.of(context)!.emptyStateMessage,
            style: textTheme.titleMedium,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
