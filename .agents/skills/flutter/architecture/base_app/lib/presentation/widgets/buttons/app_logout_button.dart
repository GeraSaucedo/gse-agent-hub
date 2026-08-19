import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gse_base_app/presentation/blocs/app/app_bloc.dart';
import 'package:gse_base_app/presentation/blocs/auth/auth_cubit.dart';
import 'package:gse_design_system/gse_design_system.dart';
import 'package:gse_localization/gse_localization.dart';

class LogoutButton extends StatelessWidget {
  const LogoutButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: () async {
        context.read<AppBloc>().add(const CleanState());
        await context.read<AuthCubit>().logout();
      },
      style: OutlinedButton.styleFrom(
        foregroundColor: Theme.of(context).colorScheme.primary,
        side: BorderSide(color: Theme.of(context).colorScheme.primary),
      ),
      child: SizedBox(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 12, horizontal: context.w(2)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.logout,
                size: context.sp(20),
              ),
              SizedBox(width: context.w(3)),
              Text(
                AppLocalizations.of(context)!.logoutButton,
                style: context.textStyles.labelMed,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
