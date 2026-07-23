import 'package:flutter/material.dart';
import 'package:gse_design_system/gse_design_system.dart';

class AppTextButton extends StatelessWidget {
  const AppTextButton({
    required this.text,
    this.onPressed,
    super.key,
  });

  final String text;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      child: Text(
        text,
        style: context.textStyles.labelMed,
      ),
    );
  }
}
