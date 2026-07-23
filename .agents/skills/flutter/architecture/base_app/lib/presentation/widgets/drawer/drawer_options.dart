import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:gse_design_system/gse_design_system.dart';
import 'package:gse_localization/gse_localization.dart';
import 'package:gse_base_app/presentation/screens/language/language_screen.dart';
import 'package:gse_base_app/presentation/widgets/drawer/drawer_button.dart';

class DrawerOptions extends StatelessWidget {
  const DrawerOptions({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView(
        children: [
          Column(
            spacing: context.h(0.8),
            children: [
              const SizedBox.shrink(),
              AppDrawerButton(
                text: 'Paginated list',
                icon: Icons.store_outlined,
                onPressed: () async {
                  Navigator.of(context).pop();
                  await context.push('/pagination-example');
                },
              ),
              AppDrawerButton(
                text: 'Design System',
                icon: Icons.palette_outlined,
                onPressed: () async {
                  Navigator.of(context).pop();
                  await context.push('/design-system-demo');
                },
              ),
              AppDrawerButton(
                text: AppLocalizations.of(context)!.languageScreenTitle,
                icon: Icons.language,
                onPressed: () async {
                  Navigator.of(context).pop();
                  await context.push(LanguageScreen.route);
                },
              ),
              AppDrawerButton(
                text: AppLocalizations.of(context)!.navigationPlaceholder,
                icon: Icons.fact_check_outlined,
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),

          SizedBox(height: context.h(3)),
        ],
      ),
    );
  }
}
