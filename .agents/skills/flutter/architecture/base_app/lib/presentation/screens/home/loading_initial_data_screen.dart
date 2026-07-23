import 'package:flutter/material.dart';
import 'package:gse_design_system/gse_design_system.dart';
import 'package:gse_base_app/presentation/widgets/utils/app_loader.dart';
import 'package:gse_base_app/presentation/widgets/utils/app_logo.dart';

class LoadingInitialDataScreen extends StatelessWidget {
  const LoadingInitialDataScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: context.sp(60),
              child: const AppLogo(),
            ),
            SizedBox(height: context.h(4)),
            const Center(
              child: AppLoader(),
            ),
          ],
        ),
      ),
    );
  }
}
