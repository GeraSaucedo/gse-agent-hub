import 'package:gse_base_app/presentation/screens/design_system_demo/design_system_demo_screen.dart';
import 'package:gse_base_app/presentation/screens/example_pagination/example_pagination_screen.dart';
import 'package:gse_base_app/presentation/screens/language/language_screen.dart';
import 'package:gse_base_app/presentation/widgets/drawer/drawer_button.dart';
import 'package:go_router/go_router.dart';
import 'package:gse_design_system/gse_design_system.dart';
import 'package:gse_localization/gse_localization.dart';
import 'package:material_ui/material_ui.dart';

class DrawerOptions extends StatelessWidget {
  const new({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    // Closes the drawer, then opens [route] on top of home.
    Future<void> open(String route) async {
      Navigator.of(context).pop();
      await context.push(route);
    }

    return Expanded(
      child: ListView(
        children: [
          Column(
            spacing: context.h(0.8),
            children: [
              const SizedBox.shrink(),
              AppDrawerButton(
                text: l10n.drawerPaginatedList,
                icon: Icons.store_outlined,
                onPressed: () => open(ExamplePaginationScreen.route),
              ),
              AppDrawerButton(
                text: l10n.drawerDesignSystem,
                icon: Icons.palette_outlined,
                onPressed: () => open(DesignSystemDemoScreen.route),
              ),
              AppDrawerButton(
                text: l10n.languageScreenTitle,
                icon: Icons.language,
                onPressed: () => open(LanguageScreen.route),
              ),
              AppDrawerButton(
                text: l10n.navigationPlaceholder,
                icon: Icons.fact_check_outlined,
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
          SizedBox(height: context.h(3)),
        ],
      ),
    );
  }
}
