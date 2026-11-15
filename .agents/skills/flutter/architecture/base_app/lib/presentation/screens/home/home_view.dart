import 'package:animate_do/animate_do.dart';
import 'package:gse_base_app/core/constants/app_constants.dart';
import 'package:gse_base_app/core/environments/env_config.dart';
import 'package:gse_base_app/presentation/widgets/drawer/app_drawer.dart';
import 'package:gse_base_app/presentation/widgets/utils/app_logo.dart';
import 'package:gse_design_system/gse_design_system.dart';
import 'package:gse_localization/gse_localization.dart';
import 'package:material_ui/material_ui.dart';

class HomeView extends StatelessWidget {
  const new({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const AppDrawer(),
      appBar: AppBar(),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: context.w(4)),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              const SizedBox(width: double.infinity),
              Column(
                children: [
                  SizedBox(
                    width: context.sp(45),
                    height: context.sp(45),
                    child: const AppLogo(),
                  ),
                  SizedBox(height: context.h(3)),
                  FadeInUp(
                    child: Text(
                      AppLocalizations.of(context)!.homeTitle,
                      style: context.textStyles.headSmall,
                    ),
                  ),
                  FadeInUp(
                    child: Text(
                      EnvConfig.environment.name,
                      style: context.textStyles.bodyMed,
                    ),
                  ),
                  SizedBox(height: context.h(8)),
                ],
              ),
              FadeIn(
                delay: const Duration(milliseconds: 500),
                child: Text(
                  'v${AppConstants.version}',
                  style: context.textStyles.bodySmall,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
