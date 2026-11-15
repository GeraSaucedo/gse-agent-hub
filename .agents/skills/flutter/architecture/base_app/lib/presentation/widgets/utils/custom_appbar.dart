import 'package:go_router/go_router.dart';
import 'package:gse_design_system/gse_design_system.dart';
import 'package:material_ui/material_ui.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const new({
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
    // AppBar only shows "back" when its own navigator can pop. The first page
    // of a ShellRoute (e.g. the forgot-password flow) lives in a nested
    // navigator, so ask go_router, which knows the whole stack.
    final router = GoRouter.maybeOf(context);
    final canPop =
        router != null && router.canPop() && !Navigator.of(context).canPop();
    final appbar = AppBar(
      backgroundColor: context.colors.scaffoldBackground,
      scrolledUnderElevation: 0,
      title: Text(
        title,
        style: context.textStyles.titleMed,
      ),
      centerTitle: true,
      actions: actions,
      leading: leading ?? (canPop ? BackButton(onPressed: router.pop) : null),
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
