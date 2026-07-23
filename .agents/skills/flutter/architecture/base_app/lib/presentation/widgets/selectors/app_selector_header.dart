import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:gse_design_system/gse_design_system.dart';

class SelectorHeader extends StatelessWidget {
  const SelectorHeader({
    required this.title,
    super.key,
    this.onRefresh,
  });

  final String title;
  final void Function()? onRefresh;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        if (onRefresh != null)
          IconButton(
            onPressed: onRefresh,
            icon: Icon(
              Icons.refresh,
              size: context.sp(19),
            ),
          ),
        Text(
          title,
          style: context.textStyles.titleMed,
        ),
        IconButton(
          onPressed: context.pop,
          icon: Icon(
            Icons.close,
            size: context.sp(19),
          ),
        ),
      ],
    );
  }
}
