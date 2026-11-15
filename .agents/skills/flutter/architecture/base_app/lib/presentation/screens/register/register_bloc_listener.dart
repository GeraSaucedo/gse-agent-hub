import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gse_base_app/data/repositories/register/register_failures.dart';
import 'package:gse_base_app/presentation/blocs/register/register_bloc.dart';
import 'package:gse_base_app/presentation/screens/login/login_screen.dart';
import 'package:gse_base_app/presentation/screens/verify_email/verify_email_screen.dart';
import 'package:gse_base_app/presentation/widgets/overlays/loading_overlay.dart';
import 'package:gse_base_app/presentation/widgets/utils/app_snackbar.dart';
import 'package:formz/formz.dart';
import 'package:go_router/go_router.dart';
import 'package:gse_localization/generated/app_localizations.dart';
import 'package:material_ui/material_ui.dart';

class RegisterBlocListener extends StatelessWidget {
  const new({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<RegisterBloc>();

    return MultiBlocListener(
      listeners: [
        BlocListener<RegisterBloc, RegisterState>(
          listenWhen: (previous, current) => previous.status != current.status,
          listener: (context, state) async {
            final status = state.status;

            if (status == FormzSubmissionStatus.inProgress) {
              LoadingOverlay.show(context);
            } else {
              LoadingOverlay.remove();
            }

            if (status == FormzSubmissionStatus.success) {
              // The password stays in RegisterBloc; VerifyEmail only
              // verifies the code and returns `true`.
              final verified = await context.push<bool>(
                Uri(
                  path: VerifyEmailScreen.route,
                  queryParameters: {
                    'email': state.email.value,
                    'skipSend': 'true',
                  },
                ).toString(),
              );
              if (!context.mounted) return;
              if (verified ?? false) {
                bloc.add(const AutoLoginRequested());
              } else {
                // Left without verifying: the account exists, so continue
                // from login (it asks for verification again).
                bloc.add(const CleanState());
                context.go(LoginScreen.route);
              }
            }
          },
        ),
        BlocListener<RegisterBloc, RegisterState>(
          listenWhen: (previous, current) =>
              previous.failure != current.failure && current.failure != null,
          listener: (context, state) {
            final l10n = AppLocalizations.of(context)!;

            if (state.failure == RegisterFailure.autoLoginFailed) {
              // Account created and verified: just log in manually. Say so,
              // or the jump to login looks like the registration failed.
              AppSnackbar.show(
                context,
                l10n.registerAutoLoginFailed,
                type: SnackbarType.info,
              );
              context.go(LoginScreen.route);
              return;
            }

            final message = switch (state.failure) {
              RegisterFailure.emailAlreadyExists =>
                l10n.registerFailureEmailAlreadyExists,
              RegisterFailure.invalidData => l10n.registerFailureInvalidData,
              RegisterFailure.server => l10n.genericServerFailureError,
              RegisterFailure.network => l10n.genericNetworkFailureError,
              // `autoLoginFailed` is handled above.
              RegisterFailure.autoLoginFailed ||
              RegisterFailure.unknown ||
              null => l10n.genericUnknownFailureError,
            };

            AppSnackbar.show(context, message);
          },
        ),
      ],
      child: child,
    );
  }
}
