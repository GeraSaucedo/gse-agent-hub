import 'package:flutter/material.dart';
import 'package:gse_design_system/gse_design_system.dart';

class AppDropdown<T> extends StatelessWidget {
  const AppDropdown({
    required this.items,
    required this.value,
    required this.labelBuilder,
    required this.onChanged,
    this.enabled = true,
    this.hint = '-',
    this.padding,
    super.key,
  });

  final List<T> items;
  final T value;
  final String Function(T) labelBuilder;
  final void Function(T?) onChanged;
  final String hint;
  final bool enabled;
  final EdgeInsets? padding;

  @override
  Widget build(BuildContext context) {
    final contentPadding =
        padding ?? EdgeInsets.only(left: context.w(2), right: context.w(2));

    return Container(
      //padding: contentPadding,
      decoration: BoxDecoration(
        //color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: context.colors.textSecondary),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<T>(
          padding: contentPadding,
          hint: Text(
            hint,
            style: TextStyle(color: context.colors.textSecondary),
          ),
          value: value,
          iconEnabledColor: Theme.of(context).colorScheme.primary,
          icon: const RotatedBox(
            quarterTurns: 1,
            child: Icon(
              Icons.chevron_right,
            ),
          ),
          items: items.map((item) {
            return DropdownMenuItem<T>(
              value: item,
              child: Text(
                labelBuilder(item),
                style: const TextStyle(
                  //color: Colors.black,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            );
          }).toList(),
          onChanged: enabled ? onChanged : null,
          //dropdownColor: Colors.green,
        ),
      ),
    );
  }
}
