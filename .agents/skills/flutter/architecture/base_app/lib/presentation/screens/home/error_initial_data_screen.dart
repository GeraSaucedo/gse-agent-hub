import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gse_base_app/presentation/blocs/app/app_bloc.dart';
import 'package:gse_base_app/presentation/widgets/buttons/app_logout_button.dart';
import 'package:gse_base_app/presentation/widgets/buttons/app_primary_button.dart';
import 'package:gse_design_system/gse_design_system.dart';
import 'package:gse_localization/gse_localization.dart';

class ErrorInitialDataScreen extends StatelessWidget {
  const ErrorInitialDataScreen({
    super.key,
    this.text,
  });

  final String? text;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: context.sp(50),
              child: AspectRatio(
                aspectRatio: 1,
                child: FittedBox(
                  fit: BoxFit.cover,
                  child: SvgPicture.asset(
                    'assets/imgs/error.svg',
                  ),
                ),
              ),
            ),
            SizedBox(height: context.h(5)),
            Text(
              text ??
                  AppLocalizations.of(context)!
                      .errorServerConnectionMessage,
              textAlign: TextAlign.center,
              style: context.textStyles.bodyMed,
            ),
            SizedBox(height: context.h(3)),
            AppPrimaryButton(
              child: Text(
                AppLocalizations.of(context)!.retryButton,
                style: context.textStyles.titleMed.semibold,
              ),
              onPressed: () {
                context.read<AppBloc>().add(const GetAppConfig());
              },
            ),
            SizedBox(height: context.h(6)),
            const LogoutButton(),
          ],
        ),
      ),
    );
  }
}
