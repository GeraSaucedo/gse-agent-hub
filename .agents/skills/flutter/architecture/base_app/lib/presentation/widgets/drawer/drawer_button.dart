import 'package:flutter/material.dart';
import 'package:gse_design_system/gse_design_system.dart';

class AppDrawerButton extends StatelessWidget {
  const AppDrawerButton({
    required this.icon,
    required this.text,
    this.onPressed,
    super.key,
  });

  final IconData icon;
  final String text;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    //final borderColor = context.colors.onSurface;
    final color = context.colors.textSecondary;
    final borderRadius = BorderRadius.circular(context.sp(12));

    return InkWell(
      borderRadius: borderRadius,
      onTap: onPressed,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: context.w(4),
          vertical: context.h(1.5),
        ),
        child: Row(
          children: [
            SizedBox(width: context.w(4)),
            Icon(
              icon,
              size: context.sp(18),
              color: color,
            ),
            SizedBox(width: context.w(3)),
            Text(
              text,
              style: context.textStyles.bodySmall
                  .c(color)
                  .copyWith(
                    fontSize: context.sp(14),
                  ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
