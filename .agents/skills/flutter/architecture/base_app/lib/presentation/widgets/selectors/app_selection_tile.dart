import 'package:flutter/material.dart';
import 'package:gse_design_system/gse_design_system.dart';

class AppSelectionTile extends StatelessWidget {
  const AppSelectionTile({
    required this.fieldName,
    required this.value,
    this.onPressed,
    super.key,
  });

  final String fieldName;
  final String? value;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(context.sp(12)),
      ),
      tileColor: context.colors.surface,
      title: Text(
        fieldName,
        style: context.textStyles.bodyMed.c(context.colors.textSecondary),
      ),
      subtitle: Text(
        value ?? '-',
        style: context.textStyles.titleMed,
      ),
      trailing: onPressed != null
          ? Icon(
              Icons.edit_note_rounded,
              size: context.sp(21),
            )
          : null,
      onTap: onPressed,
      //contentPadding: EdgeInsets.zero,
    );
  }
}
