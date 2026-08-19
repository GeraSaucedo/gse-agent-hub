import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:gse_base_app/presentation/blocs/forgot_password/forgot_password_bloc.dart';
import 'package:gse_base_app/presentation/widgets/buttons/app_primary_button.dart';
import 'package:gse_base_app/presentation/widgets/inputs/password/password_text_field.dart';
import 'package:gse_base_app/presentation/widgets/utils/custom_appbar.dart';
import 'package:gse_design_system/gse_design_system.dart';
import 'package:gse_localization/generated/app_localizations.dart';

class ForgotPasswordForm extends StatelessWidget {
  const ForgotPasswordForm({super.key});

  static const name = 'forgot-password-form-screen';
  static const route = '/forgot-password-form';

  @override
  Widget build(BuildContext context) {
    final formData = context.read<ForgotPasswordBloc>();

    return Scaffold(
      appBar: const CustomAppBar(title: ''),
      body: BlocBuilder<ForgotPasswordBloc, ForgotPasswordState>(
        builder: (context, state) {
          final l10n = AppLocalizations.of(context)!;

          return SingleChildScrollView(
            child: SizedBox(
              height: context.h(100) - kToolbarHeight,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: context.w(4)),
                child: FadeIn(
                  child: Column(
                    children: [
                      SizedBox(height: context.h(4)),
                      Text(
                        l10n.forgotPasswordChangeTitle,
                        style: context.textStyles.headLarge,
                      ),
                      SizedBox(height: context.h(2)),
                      Text(
                        l10n.forgotPasswordChangeSubtitle,
                        style: context.textStyles.bodyMed,
                      ),
                      SizedBox(height: context.h(3)),

                      PasswordTextField(
                        onChanged: (value) =>
                            formData.add(PasswordChanged(value)),
                        errorText: state.newPassword.errorMessage,
                        showErrors: state.status.isFailure,
                        initialValue: state.newPassword.value,
                        hintText: l10n.forgotPasswordNewPasswordHint,
                      ),
                      SizedBox(height: context.h(1)),
                      PasswordTextField(
                        onChanged: (value) =>
                            formData.add(ConfirmPasswordChanged(value)),
                        hintText: l10n.forgotPasswordConfirmPasswordHint,
                        initialValue: state.confirmedNewPassword.value,
                        showErrors: state.status.isFailure,
                        errorText: state.confirmedNewPassword.errorMessage,
                      ),
                      SizedBox(height: context.h(3)),
                      SizedBox(
                        width: double.infinity,

                        child: Text(
                          l10n.forgotPasswordRequirements,
                          style: TextStyle(fontSize: context.sp(14)),
                        ),
                      ),

                      SizedBox(height: context.h(3)),
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: context.w(1.5),
                        ),
                        child: SizedBox(
                          width: double.infinity,
                          child: AppPrimaryButton(
                            onPressed: () {
                              context.read<ForgotPasswordBloc>().add(
                                const FormSubmitted(),
                              );
                            },
                            child: Text(
                              l10n.forgotPasswordUpdateButton,
                              style: context.textStyles.titleMed.semibold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
