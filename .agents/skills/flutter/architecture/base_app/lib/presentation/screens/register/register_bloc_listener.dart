import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:go_router/go_router.dart';
import 'package:gse_localization/generated/app_localizations.dart';
import 'package:gse_base_app/data/repositories/register/register_failures.dart';
import 'package:gse_base_app/presentation/blocs/register/register_bloc.dart';
import 'package:gse_base_app/presentation/screens/verify_email/verify_email_screen.dart';
import 'package:gse_base_app/presentation/widgets/overlays/loading_overlay.dart';
import 'package:gse_base_app/presentation/widgets/utils/app_snackbar.dart';

class RegisterBlocListener extends StatelessWidget {
  const RegisterBlocListener({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<RegisterBloc>();

    return MultiBlocListener(
      listeners: [
        BlocListener<RegisterBloc, RegisterState>(
          listenWhen: (previous, current) =>
              previous.status != current.status,
          listener: (context, state) {
            final status = state.status;

            if (status == FormzSubmissionStatus.inProgress) {
              LoadingOverlay.show(context);
            } else {
              LoadingOverlay.remove();
            }

            if (status == FormzSubmissionStatus.success) {
              final email = state.email.value;
              final password = state.password.value;
              bloc.add(const CleanState());
              context.go(
                '${VerifyEmailScreen.route}?email=$email&skipSend=true',
                extra: {'password': password},
              );
            }
          },
        ),
        BlocListener<RegisterBloc, RegisterState>(
          listenWhen: (previous, current) =>
              previous.failure != current.failure && current.failure != null,
          listener: (context, state) {
            final l10n = AppLocalizations.of(context)!;

            final message = switch (state.failure) {
              RegisterFailure.emailAlreadyExists =>
                l10n.registerFailureEmailAlreadyExists,
              RegisterFailure.invalidData => l10n.registerFailureInvalidData,
              RegisterFailure.serverError => l10n.genericServerFailureError,
              RegisterFailure.networkError => l10n.genericNetworkFailureError,
              _ => l10n.genericUnknownFailureError,
            };

            AppSnackbar.show(context, message);
          },
        ),
      ],
      child: child,
    );
  }
}
