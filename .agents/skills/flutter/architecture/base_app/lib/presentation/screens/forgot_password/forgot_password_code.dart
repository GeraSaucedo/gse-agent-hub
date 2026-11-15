import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gse_base_app/presentation/blocs/forgot_password/forgot_password_bloc.dart';
import 'package:gse_base_app/presentation/screens/forgot_password/forgot_password_form.dart';
import 'package:gse_base_app/presentation/widgets/buttons/app_primary_button.dart';
import 'package:gse_base_app/presentation/widgets/buttons/resend_code_button.dart';
import 'package:gse_base_app/presentation/widgets/inputs/app_text_field.dart';
import 'package:gse_base_app/presentation/widgets/utils/custom_appbar.dart';
import 'package:go_router/go_router.dart';
import 'package:gse_design_system/gse_design_system.dart';
import 'package:gse_localization/generated/app_localizations.dart';
import 'package:material_ui/material_ui.dart';

class ForgotPasswordCode extends StatelessWidget {
  const new({
    super.key,
  });

  static const name = 'forgot-password-code-screen';
  static const route = '/forgot-password-code';

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<ForgotPasswordBloc>();
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: const CustomAppBar(title: ''),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: context.w(4)),
        child: Column(
          children: [
            SizedBox(height: context.h(4)),
            Text(
              l10n.forgotPasswordCheckEmailTitle,
              style: context.textStyles.headLarge,
            ),
            SizedBox(height: context.h(2)),
            Text(
              l10n.forgotPasswordCheckEmailSubtitle,
              style: context.textStyles.bodyMed,
            ),
            SizedBox(height: context.h(3)),
            BlocSelector<ForgotPasswordBloc, ForgotPasswordState, String>(
              selector: (state) {
                return state.code;
              },
              builder: (context, code) {
                return AppTextField(
                  hintText: l10n.forgotPasswordCodeHint,
                  filled: true,
                  onChanged: (value) => bloc.add(CodeChanged(value)),
                  initialValue: code,
                );
              },
            ),
            SizedBox(height: context.h(2)),
            SizedBox(
              width: double.infinity,
              child:
                  BlocSelector<ForgotPasswordBloc, ForgotPasswordState, String>(
                    selector: (state) {
                      return state.code;
                    },
                    builder: (context, code) {
                      return AppPrimaryButton(
                        onPressed: () {
                          unawaited(context.push(ForgotPasswordForm.route));
                        },
                        enabled: code.isNotEmpty,
                        child: Text(
                          l10n.forgotPasswordContinueButton,
                          style: context.textStyles.titleMed.semibold,
                        ),
                      );
                    },
                  ),
            ),
            SizedBox(height: context.h(2)),
            ResendCodeButton(
              prompt: l10n.forgotPasswordDidNotReceiveCode,
              resendText: l10n.forgotPasswordResendEmail,
              waitText: l10n.forgotPasswordResendIn,
              onResend: () => bloc.add(const CodeRequested()),
            ),
          ],
        ),
      ),
    );
  }
}
