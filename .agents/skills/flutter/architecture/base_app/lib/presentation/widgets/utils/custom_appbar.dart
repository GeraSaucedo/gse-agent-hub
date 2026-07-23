import 'package:flutter/material.dart';
import 'package:gse_design_system/gse_design_system.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({
    required this.title,
    super.key,
    this.actions,
    this.leading,
    this.useHero = false,
  });

  final String title;
  final List<Widget>? actions;
  final Widget? leading;
  final bool useHero;

  @override
  Widget build(BuildContext context) {
    final appbar = AppBar(
      backgroundColor: context.colors.scaffoldBackground,
      scrolledUnderElevation: 0,
      title: Text(
        title,
        style: context.textStyles.titleMed,
      ),
      centerTitle: true,
      actions: actions,
      leading: leading,
    );

    return useHero
        ? Hero(
            tag: 'appbar-hero',
            child: appbar,
          )
        : appbar;
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
