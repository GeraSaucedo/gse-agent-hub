import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:gse_design_system/gse_design_system.dart';
import 'package:gse_localization/gse_localization.dart';
import 'package:gse_base_app/core/constants/app_constants.dart';
import 'package:gse_base_app/presentation/blocs/login/login_bloc.dart';
import 'package:gse_base_app/presentation/screens/forgot_password/forgot_password_username.dart';
import 'package:gse_base_app/presentation/screens/register/register_screen.dart';
import 'package:gse_base_app/presentation/widgets/buttons/app_primary_button.dart';
import 'package:gse_base_app/presentation/widgets/inputs/email/email_text_field.dart';
import 'package:gse_base_app/presentation/widgets/inputs/password/password_text_field.dart';
import 'package:gse_base_app/presentation/widgets/utils/app_logo.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    final loginBloc = context.read<LoginBloc>();

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: context.w(4),
          vertical: context.h(2),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(),
            SizedBox(
              height: context.sp(52).clamp(130, 190),
              child: const AppLogo(),
            ),
            SizedBox(height: context.h(2)),
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  AppLocalizations.of(context)!.loginScreenTitle,
                  style: context.textStyles.headSmall,
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: context.h(0.5)),
                Text(
                  AppLocalizations.of(context)!.loginScreenSubtitle,
                  style: context.textStyles.bodySmall.c(
                    context.colors.textSecondary,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: context.h(5)),
                BlocBuilder<LoginBloc, LoginState>(
                  builder: (context, state) {
                    final bloc = context.read<LoginBloc>();

                    return Column(
                      children: [
                        EmailTextField(
                          enabled: !bloc.isLoading,
                          onChanged: (value) =>
                              loginBloc.add(EmailChanged(value)),
                          errorText: state.email.errorMessage,
                          showErrors: bloc.formSubmitted,
                        ),
                        SizedBox(height: context.h(2)),
                        PasswordTextField(
                          enabled: !bloc.isLoading,
                          onChanged: (value) =>
                              loginBloc.add(PasswordChanged(value)),
                          errorText: state.password.errorMessage,
                          showErrors: bloc.formSubmitted,
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () {
                              final email = state.email.value;
                              final route = email.isEmpty
                                  ? ForgotPasswordUsername.route
                                  : '${ForgotPasswordUsername.route}'
                                        '?email=$email';
                              unawaited(context.push(route));
                            },
                            child: Text(
                              AppLocalizations.of(
                                context,
                              )!.loginScreenForgotPassword,
                              style: context.textStyles.bodyMed.c(
                                Theme.of(context).colorScheme.primary,
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
                SizedBox(height: context.h(3)),
                AppPrimaryButton(
                  onPressed: () {
                    loginBloc.add(const FormSubmitted());
                  },
                  unfocusFields: true,
                  child: Text(
                    AppLocalizations.of(context)!.loginScreenLoginButton,
                    style: context.textStyles.titleMed.semibold,
                  ),
                ),
                SizedBox(height: context.h(2)),
                Row(
                  children: [
                    Expanded(
                      child: Divider(color: context.colors.textSecondary),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: context.w(3)),
                      child: Text(
                        AppLocalizations.of(context)!.loginOrDivider,
                        style: context.textStyles.bodySmall.c(
                          context.colors.textSecondary,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Divider(color: context.colors.textSecondary),
                    ),
                  ],
                ),
                SizedBox(height: context.h(2)),
                AppPrimaryButton(
                  onPressed: () => loginBloc.add(const GoogleSignInRequested()),
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black87,
                  child: Text(
                    AppLocalizations.of(context)!.loginContinueWithGoogle,
                    style: context.textStyles.titleMed.semibold,
                  ),
                ),
                SizedBox(height: context.h(1.5)),
                AppPrimaryButton(
                  onPressed: () => loginBloc.add(const AppleSignInRequested()),
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                  child: Text(
                    AppLocalizations.of(context)!.loginContinueWithApple,
                    style: context.textStyles.titleMed.semibold,
                  ),
                ),
                SizedBox(height: context.h(2.5)),
                Divider(color: context.colors.textSecondary),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      AppLocalizations.of(context)!.registerAlreadyHaveAccount,
                      style: context.textStyles.bodyMed,
                    ),
                    TextButton(
                      onPressed: () {
                        unawaited(context.push(RegisterScreen.route));
                      },
                      child: Text(
                        AppLocalizations.of(context)!.loginRegisterButton,
                        style: context.textStyles.bodyMed.c(
                          Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: context.h(1)),
                SizedBox(
                  width: double.infinity,
                  child: Text(
                    'v${AppConstants.version}',
                    textAlign: TextAlign.center,
                    style: context.textStyles.bodyMed,
                  ),
                ),
              ],
            ),
            const Spacer(flex: 3),
          ],
        ),
      ),
    );
  }
}
