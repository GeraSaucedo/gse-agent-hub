import 'package:flutter/material.dart';
import 'package:gse_design_system/gse_design_system.dart';

class ChipButton extends StatelessWidget {
  const ChipButton({
    required this.onPressed,
    required this.text,
    this.chipColor,
    this.textColor,
    super.key,
  });

  final VoidCallback onPressed;
  final String text;
  final Color? chipColor;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: EdgeInsets.symmetric(
          vertical: context.h(0.5),
          horizontal: context.w(2),
        ),
        decoration: BoxDecoration(
          color: chipColor ?? Theme.of(context).colorScheme.onPrimary,
          borderRadius: BorderRadius.circular(context.sp(100)),
        ),
        child: Text(
          text,
          style: context.textStyles.bodySmall.c(
            textColor ?? context.colors.disabled,
          ),
        ),
      ),
    );
  }
}
