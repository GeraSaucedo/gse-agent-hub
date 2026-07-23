import 'package:flutter/material.dart';
import 'package:gse_design_system/gse_design_system.dart';
import 'package:gse_base_app/presentation/widgets/buttons/app_logout_button.dart';
import 'package:gse_base_app/presentation/widgets/drawer/drawer_options.dart';
import 'package:gse_base_app/presentation/widgets/drawer/widgets/app_drawer_header.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: context.h(2)),
          child: Column(
            children: [
              const AppDrawerHeader(),
              SizedBox(height: context.h(2)),
              Divider(
                color: context.colors.textSecondary.withAlpha(80),
              ),

              const DrawerOptions(),
              //DrawerMenu(),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: context.w(3)),
                child: const SizedBox(
                  width: double.infinity,
                  child: LogoutButton(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
