import 'package:flutter/material.dart';
import 'package:gse_design_system/gse_design_system.dart';

class AppPrimaryButton extends StatelessWidget {
  const AppPrimaryButton({
    super.key,
    this.onPressed,
    this.child,
    this.unfocusFields = false,
    this.enabled = true,
    this.foregroundColor,
    this.backgroundColor,
  });

  final void Function()? onPressed;
  final Widget? child;
  final bool unfocusFields;
  final bool enabled;
  final Color? foregroundColor;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: enabled
          ? () {
              if (unfocusFields) {
                FocusScope.of(context).unfocus();
              }

              if (onPressed == null) return;
              onPressed!();
            }
          : null,
      style: ElevatedButton.styleFrom(
        foregroundColor:
            foregroundColor ?? Theme.of(context).colorScheme.onPrimary,
        backgroundColor:
            backgroundColor ?? Theme.of(context).colorScheme.primary,
        disabledBackgroundColor: context.colors.disabled,
        disabledForegroundColor: context.colors.onDisabled,
        padding: const EdgeInsets.all(13),
      ),
      child: child,
    );
  }
}
