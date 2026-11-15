import 'package:gse_design_system/gse_design_system.dart';
import 'package:gse_localization/generated/app_localizations.dart';
import 'package:material_ui/material_ui.dart';

class PasswordTextField extends StatefulWidget {
  const new({
    super.key,
    this.controller,
    this.focusNode,
    this.hintText,
    this.onChanged,
    this.enabled = true,
    this.errorText,
    this.showErrors = false,
    this.readOnly = false,
    this.initialValue,
  });

  final TextEditingController? controller;
  final String? hintText;
  final void Function(String)? onChanged;
  final bool enabled;
  final String? errorText;
  final bool showErrors;
  final bool readOnly;
  final FocusNode? focusNode;
  final String? initialValue;

  @override
  State<PasswordTextField> createState() => _PasswordTextFieldState();
}

class _PasswordTextFieldState extends State<PasswordTextField> {
  bool _obscureText = true;
  // Only created (and disposed) when the parent doesn't pass one: a node
  // received from outside belongs to the parent.
  FocusNode? _ownFocusNode;

  FocusNode get _focusNode =>
      widget.focusNode ?? (_ownFocusNode ??= FocusNode());

  @override
  void dispose() {
    _ownFocusNode?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: widget.initialValue,
      controller: widget.controller,
      onChanged: widget.onChanged,
      enabled: widget.enabled,
      focusNode: _focusNode,
      obscureText: _obscureText,
      readOnly: widget.readOnly,
      maxLength: 40,
      onTapOutside: (event) {
        _focusNode.unfocus();
      },
      style: TextStyle(color: context.colors.textPrimary),
      decoration: InputDecoration(
        hintText:
            widget.hintText ??
            AppLocalizations.of(context)!.loginScreenPasswordHint,
        hintStyle: TextStyle(color: context.colors.textSecondary),
        errorText: widget.showErrors ? widget.errorText : null,
        suffixIcon: IconButton(
          icon: Icon(
            _obscureText
                ? Icons.visibility_off_outlined
                : Icons.visibility_outlined,
            color: context.colors.textSecondary,
          ),
          onPressed: () => setState(() => _obscureText = !_obscureText),
        ),
        counterText: '',
        filled: true,
        fillColor: context.colors.scaffoldBackground,
      ),
    );
  }
}
