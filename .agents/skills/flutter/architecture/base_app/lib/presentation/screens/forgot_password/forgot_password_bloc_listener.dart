import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:go_router/go_router.dart';
import 'package:gse_localization/generated/app_localizations.dart';
import 'package:gse_base_app/data/repositories/recovery_code/recovery_code_failures.dart';
import 'package:gse_base_app/presentation/blocs/forgot_password/forgot_password_bloc.dart';
import 'package:gse_base_app/presentation/widgets/overlays/loading_overlay.dart';
import 'package:gse_base_app/presentation/widgets/utils/app_snackbar.dart';

class ForgotPasswordBlocListener extends StatelessWidget {
  const ForgotPasswordBlocListener({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<ForgotPasswordBloc>();

    return MultiBlocListener(
      listeners: [
        BlocListener<ForgotPasswordBloc, ForgotPasswordState>(
          listenWhen: (previous, current) => previous.status != current.status,
          listener: (context, state) {
            final status = state.status;

            if (status == FormzSubmissionStatus.inProgress) {
              LoadingOverlay.show(context);
            } else {
              LoadingOverlay.remove();
            }

            if (status == FormzSubmissionStatus.success) {
              bloc.add(const CleanState());
              final l10n = AppLocalizations.of(context)!;
              AppSnackbar.show(
                context,
                l10n.forgotPasswordUpdateSuccess,
                type: SnackbarType.success,
              );
              context.go('/login');
            }
          },
        ),
        BlocListener<ForgotPasswordBloc, ForgotPasswordState>(
          listenWhen: (previous, current) =>
              previous.failure != current.failure && current.failure != null,
          listener: (context, state) {
            final l10n = AppLocalizations.of(context)!;

            final message = switch (state.failure) {
              RecoveryCodeFailure.userNotFound => l10n.loginFailureUserNotFound,
              RecoveryCodeFailure.serverError => l10n.genericServerFailureError,
              RecoveryCodeFailure.networkError =>
                l10n.genericNetworkFailureError,
              RecoveryCodeFailure.unknownError =>
                l10n.genericUnknownFailureError,
              RecoveryCodeFailure.invalidForm => l10n.forgotPasswordInvalidForm,
              RecoveryCodeFailure.emptyUsername =>
                l10n.forgotPasswordEmptyUsername,
              _ => l10n.genericUnknownFailureError,
            };

            AppSnackbar.show(
              context,
              message,
            );
          },
        ),
      ],
      child: child,
    );
  }
}
