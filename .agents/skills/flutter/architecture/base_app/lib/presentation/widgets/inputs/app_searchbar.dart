import 'package:flutter/material.dart';
import 'package:gse_design_system/gse_design_system.dart';
import 'package:gse_localization/gse_localization.dart';

class AppSearchBar extends StatefulWidget {
  const AppSearchBar({
    super.key,
    this.onChanged,
    this.onSubmitted,
    this.hintText,
    this.fillColor,
    this.borderColor,
    this.textStyle,
    this.height,
    this.borderRadius,
    this.enabled = true,
  });

  final void Function(String)? onChanged;
  final void Function(String)? onSubmitted;
  final String? hintText;
  final Color? fillColor;
  final Color? borderColor;
  final TextStyle? textStyle;
  final double? height;
  final BorderRadius? borderRadius;
  final bool enabled;

  @override
  State<StatefulWidget> createState() => _AppSearchBarState();
}

class _AppSearchBarState extends State<AppSearchBar> {
  final TextEditingController _controller = TextEditingController();
  final _focusNode = FocusNode();
  late final ValueNotifier<bool> _hasTextNotifier;

  @override
  void initState() {
    super.initState();
    _hasTextNotifier = ValueNotifier<bool>(_controller.text.isNotEmpty);
    _controller.addListener(_updateHasText);
  }

  void _updateHasText() {
    final hasText = _controller.text.isNotEmpty;
    if (_hasTextNotifier.value != hasText) {
      _hasTextNotifier.value = hasText;
    }
  }

  @override
  void dispose() {
    _controller
      ..removeListener(_updateHasText)
      ..dispose();
    _focusNode.dispose();
    _hasTextNotifier.dispose();
    super.dispose();
  }

  void _clearText() {
    _controller.clear();
    widget.onChanged?.call('');
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      //height: widget.height ?? context.h(6),
      decoration: BoxDecoration(
        color: widget.fillColor ?? Theme.of(context).colorScheme.surface,
        borderRadius:
            widget.borderRadius ?? BorderRadius.circular(context.sp(20)),
        border: Border.all(
          color:
              widget.borderColor ??
              Theme.of(context).colorScheme.outline.withValues(alpha: 0.3),
        ),
      ),
      child: TextField(
        controller: _controller,
        focusNode: _focusNode,
        enabled: widget.enabled,
        onChanged: (value) {
          widget.onChanged?.call(value);
        },
        onSubmitted: widget.onSubmitted,
        style: widget.textStyle ?? context.textStyles.labelSmall,
        onTapOutside: (event) {
          _focusNode.unfocus();
        },
        decoration: InputDecoration(
          hintText: widget.hintText ?? AppLocalizations.of(context)!.searchHint,
          hintStyle:
              widget.textStyle?.copyWith(
                color: Theme.of(
                  context,
                ).colorScheme.onSurface.withValues(alpha: 0.5),
              ) ??
              context.textStyles.labelSmall.c(
                Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5),
              ),
          prefixIcon: Icon(
            Icons.search,
            color: Theme.of(
              context,
            ).colorScheme.onSurface.withValues(alpha: 0.7),
            size: context.sp(20),
          ),
          suffixIcon: ValueListenableBuilder<bool>(
            valueListenable: _hasTextNotifier,
            builder: (context, hasText, child) {
              return hasText
                  ? GestureDetector(
                      onTap: _clearText,
                      child: Icon(
                        Icons.close,
                        color: Theme.of(
                          context,
                        ).colorScheme.onSurface.withValues(alpha: 0.7),
                        size: context.sp(20),
                      ),
                    )
                  : const SizedBox.shrink();
            },
          ),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(
            vertical: context.h(1.5),
          ),
        ),
      ),
    );
  }
}
