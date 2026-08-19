import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:gse_base_app/presentation/blocs/forgot_password/forgot_password_bloc.dart';
import 'package:gse_base_app/presentation/screens/forgot_password/forgot_password_code.dart';
import 'package:gse_base_app/presentation/widgets/buttons/app_primary_button.dart';
import 'package:gse_base_app/presentation/widgets/inputs/email/email_text_field.dart';
import 'package:gse_base_app/presentation/widgets/inputs/email/field_email.dart';
import 'package:gse_base_app/presentation/widgets/utils/custom_appbar.dart';
import 'package:gse_design_system/gse_design_system.dart';
import 'package:gse_localization/generated/app_localizations.dart';

class ForgotPasswordUsername extends StatefulWidget {
  const ForgotPasswordUsername({
    this.email,
    super.key,
  });

  static const name = 'forgot-password-username-screen';
  static const route = '/forgot-password-username';

  final String? email;

  @override
  State<ForgotPasswordUsername> createState() => _ForgotPasswordUsernameState();
}

class _ForgotPasswordUsernameState extends State<ForgotPasswordUsername> {
  final _emailController = TextEditingController();

  @override
  void initState() {
    if (widget.email != null) {
      context.read<ForgotPasswordBloc>().add(EmailChanged(widget.email!));
      _emailController.text = widget.email!;
    }

    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _sendRecoveryCode() {
    context.read<ForgotPasswordBloc>().add(const CodeRequested());
    unawaited(context.push(ForgotPasswordCode.route));
  }

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
              l10n.loginScreenForgotPassword,
              style: context.textStyles.headLarge,
            ),
            SizedBox(height: context.h(2)),
            Text(
              l10n.forgotPasswordEmailSubtitle,
              style: context.textStyles.bodyMed,
            ),
            SizedBox(height: context.h(3)),
            BlocSelector<ForgotPasswordBloc, ForgotPasswordState, EmailInput>(
              selector: (state) => state.email,
              builder: (context, email) {
                return EmailTextField(
                  controller: _emailController,
                  onChanged: (value) => bloc.add(EmailChanged(value)),
                  errorText: email.errorMessage,
                );
              },
            ),
            SizedBox(height: context.h(2)),
            SizedBox(
              width: double.infinity,
              child:
                  BlocSelector<
                    ForgotPasswordBloc,
                    ForgotPasswordState,
                    EmailInput
                  >(
                    selector: (state) => state.email,
                    builder: (context, email) {
                      return AppPrimaryButton(
                        onPressed: _sendRecoveryCode,
                        enabled: email.value.isNotEmpty,
                        child: Text(
                          l10n.forgotPasswordSendButton,
                          style: context.textStyles.titleMed.semibold,
                        ),
                      );
                    },
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
