import 'package:flutter/material.dart';
import 'package:gse_design_system/gse_design_system.dart';

class AppTextField extends StatefulWidget {
  const AppTextField({
    super.key,
    this.controller,
    this.hintText,
    this.onChanged,
    this.enabled = true,
    this.errorText,
    this.filled = false,
    this.initialValue,
  });

  final TextEditingController? controller;
  final String? hintText;
  final void Function(String)? onChanged;
  final bool enabled;
  final String? errorText;
  final bool filled;
  final String? initialValue;

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  TextEditingController? _internalController;

  @override
  void initState() {
    super.initState();
    if (widget.controller == null && widget.initialValue != null) {
      _internalController =
          TextEditingController(text: widget.initialValue);
    }
  }

  @override
  void dispose() {
    _internalController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _internalController ?? widget.controller,
      onChanged: widget.onChanged,
      enabled: widget.enabled,
      style: TextStyle(color: context.colors.textPrimary),
      decoration: InputDecoration(
        hintText: widget.hintText,
        hintStyle: TextStyle(color: context.colors.textSecondary),
        errorText: widget.errorText,
        filled: widget.filled,
        fillColor:
            widget.filled ? context.colors.scaffoldBackground : null,
      ),
    );
  }
}
