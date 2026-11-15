import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gse_base_app/data/inputs/field_email.dart';
import 'package:gse_base_app/presentation/blocs/forgot_password/forgot_password_bloc.dart';
import 'package:gse_base_app/presentation/screens/forgot_password/forgot_password_code.dart';
import 'package:gse_base_app/presentation/widgets/buttons/app_primary_button.dart';
import 'package:gse_base_app/presentation/widgets/inputs/email/email_text_field.dart';
import 'package:gse_base_app/presentation/widgets/inputs/input_errors_l10n.dart';
import 'package:gse_base_app/presentation/widgets/utils/custom_appbar.dart';
import 'package:go_router/go_router.dart';
import 'package:gse_design_system/gse_design_system.dart';
import 'package:gse_localization/generated/app_localizations.dart';
import 'package:material_ui/material_ui.dart';

class ForgotPasswordUsername extends StatefulWidget {
  const new({
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
    super.initState();
    final email = widget.email;
    if (email != null) {
      context.read<ForgotPasswordBloc>().add(EmailChanged(email));
      _emailController.text = email;
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _sendRecoveryCode() {
    context.read<ForgotPasswordBloc>().add(const CodeRequested());
  }

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<ForgotPasswordBloc>();

    final l10n = AppLocalizations.of(context)!;

    // Move on only once the code was really sent. `isCurrent`: a "resend"
    // from the code screen also bumps `codesSent` while this page is below.
    return BlocListener<ForgotPasswordBloc, ForgotPasswordState>(
      listenWhen: (previous, current) =>
          previous.codesSent != current.codesSent &&
          (ModalRoute.of(context)?.isCurrent ?? false),
      listener: (context, _) =>
          unawaited(context.push(ForgotPasswordCode.route)),
      child: Scaffold(
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
                    errorText: email.errorText(l10n),
                  );
                },
              ),
              SizedBox(height: context.h(2)),
              SizedBox(
                width: double.infinity,
                child:
                    BlocSelector<ForgotPasswordBloc, ForgotPasswordState, bool>(
                      selector: (state) =>
                          state.email.value.isNotEmpty && !state.requestingCode,
                      builder: (context, canSend) {
                        return AppPrimaryButton(
                          onPressed: _sendRecoveryCode,
                          enabled: canSend,
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
      ),
    );
  }
}
