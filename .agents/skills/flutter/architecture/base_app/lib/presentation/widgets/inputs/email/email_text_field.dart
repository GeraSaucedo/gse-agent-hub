import 'package:flutter/material.dart';
import 'package:gse_design_system/gse_design_system.dart';
import 'package:gse_localization/gse_localization.dart';

class EmailTextField extends StatelessWidget {
  const EmailTextField({
    super.key,
    this.controller,
    this.hintText,
    this.onChanged,
    this.enabled = true,
    this.errorText,
    this.showErrors = false,
  });

  final TextEditingController? controller;
  final String? hintText;
  final void Function(String)? onChanged;
  final bool enabled;
  final String? errorText;
  final bool showErrors;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onChanged: onChanged,
      enabled: enabled,
      autocorrect: false,
      maxLength: 100,
      style: TextStyle(color: context.colors.textPrimary),
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        hintText: hintText ?? AppLocalizations.of(context)!.emailHint,
        hintStyle: TextStyle(color: context.colors.textSecondary),
        errorText: showErrors ? errorText : null,
        counterText: '',
        filled: true,
        fillColor: context.colors.scaffoldBackground,
      ),
    );
  }
}
