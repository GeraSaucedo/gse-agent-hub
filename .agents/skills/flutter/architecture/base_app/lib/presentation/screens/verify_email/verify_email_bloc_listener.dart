import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gse_base_app/data/repositories/verify_email/verify_email_failures.dart';
import 'package:gse_base_app/presentation/blocs/verify_email/verify_email_bloc.dart';
import 'package:gse_base_app/presentation/screens/login/login_screen.dart';
import 'package:gse_base_app/presentation/widgets/overlays/loading_overlay.dart';
import 'package:gse_base_app/presentation/widgets/utils/app_snackbar.dart';
import 'package:formz/formz.dart';
import 'package:go_router/go_router.dart';
import 'package:gse_localization/generated/app_localizations.dart';
import 'package:material_ui/material_ui.dart';

class VerifyEmailBlocListener extends StatelessWidget {
  const new({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<VerifyEmailBloc>();

    return MultiBlocListener(
      listeners: [
        BlocListener<VerifyEmailBloc, VerifyEmailState>(
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
              // The screen that opened VerifyEmail logs in when it gets
              // `true`. Without a previous screen (e.g. deep link), the user
              // logs in manually.
              if (context.canPop()) {
                context.pop(true);
              } else {
                context.go(LoginScreen.route);
              }
            }
          },
        ),
        BlocListener<VerifyEmailBloc, VerifyEmailState>(
          listenWhen: (previous, current) =>
              previous.failure != current.failure && current.failure != null,
          listener: (context, state) {
            final l10n = AppLocalizations.of(context)!;

            final message = switch (state.failure) {
              VerifyEmailFailure.invalidCode => l10n.verifyEmailInvalidCode,
              VerifyEmailFailure.server => l10n.genericServerFailureError,
              VerifyEmailFailure.network => l10n.genericNetworkFailureError,
              VerifyEmailFailure.unknown ||
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
