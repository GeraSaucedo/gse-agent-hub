import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:go_router/go_router.dart';
import 'package:gse_base_app/data/repositories/auth/auth_failures.dart';
import 'package:gse_base_app/presentation/blocs/login/login_bloc.dart';
import 'package:gse_base_app/presentation/widgets/overlays/loading_overlay.dart';
import 'package:gse_base_app/presentation/widgets/utils/app_snackbar.dart';
import 'package:gse_localization/generated/app_localizations.dart';

class LoginBlocListener extends StatelessWidget {
  const LoginBlocListener({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final loginBloc = context.read<LoginBloc>();

    return MultiBlocListener(
      listeners: [
        BlocListener<LoginBloc, LoginState>(
          listenWhen: (previous, current) => previous.status != current.status,
          listener: (context, state) {
            final status = state.status;
            if (status == FormzSubmissionStatus.inProgress) {
              LoadingOverlay.show(context);
            } else {
              LoadingOverlay.remove();
            }
            if (status == FormzSubmissionStatus.success) {
              loginBloc.add(const CleanState());
            }
          },
        ),
        BlocListener<LoginBloc, LoginState>(
          listenWhen: (previous, current) =>
              previous.failure != current.failure && current.failure != null,
          listener: (context, state) {
            final l10n = AppLocalizations.of(context)!;
            final message = switch (state.failure) {
              AuthFailure.unauthorized => l10n.loginFailureInvalidCredentials,
              AuthFailure.invalidForm  => l10n.loginFailureInvalidForm,
              AuthFailure.network      => l10n.genericNetworkFailureError,
              AuthFailure.timeout      => l10n.loginFailureConnectionTimeout,
              _                        => l10n.genericUnknownFailureError,
            };
            AppSnackbar.show(context, message);
          },
        ),
        BlocListener<LoginBloc, LoginState>(
          listenWhen: (previous, current) =>
              previous.unverifiedEmail != current.unverifiedEmail &&
              current.unverifiedEmail.isNotEmpty,
          listener: (context, state) async {
            final verified = await context.push<bool>(
              '/verify-email?email=${state.unverifiedEmail}',
              extra: <String, String>{
                'password': state.password.value,
              },
            );
            // Fallback: si el auto-login falló, reintentar login manualmente
            if ((verified ?? false) && context.mounted) {
              loginBloc.add(const FormSubmitted());
            }
          },
        ),
      ],
      child: child,
    );
  }
}
