import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:go_router/go_router.dart';
import 'package:gse_base_app/presentation/blocs/register/register_bloc.dart';
import 'package:gse_base_app/presentation/screens/register/register_bloc_listener.dart';
import 'package:gse_base_app/presentation/widgets/buttons/app_primary_button.dart';
import 'package:gse_base_app/presentation/widgets/inputs/app_text_field.dart';
import 'package:gse_base_app/presentation/widgets/inputs/email/email_text_field.dart';
import 'package:gse_base_app/presentation/widgets/inputs/password/password_text_field.dart';
import 'package:gse_base_app/presentation/widgets/utils/app_logo.dart';
import 'package:gse_base_app/presentation/widgets/utils/custom_appbar.dart';
import 'package:gse_base_app/presentation/widgets/utils/unfocus_on_tap.dart';
import 'package:gse_design_system/gse_design_system.dart';
import 'package:gse_localization/generated/app_localizations.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  static const name = 'register-screen';
  static const route = '/register';

  @override
  Widget build(BuildContext context) {
    return RegisterBlocListener(
      child: UnfocusOnTap(
        child: Scaffold(
          appBar: const CustomAppBar(title: ''),
          body: SingleChildScrollView(
            child: SizedBox(
              height: context.h(100),
              child: const _RegisterView(),
            ),
          ),
        ),
      ),
    );
  }
}

class _RegisterView extends StatelessWidget {
  const _RegisterView();

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<RegisterBloc>();
    final l10n = AppLocalizations.of(context)!;

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: context.w(4),
          vertical: context.h(2),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: context.h(2)),
            SizedBox(
              height: context.sp(40).clamp(80, 130),
              child: const AppLogo(),
            ),
            SizedBox(height: context.h(2)),
            Text(
              l10n.registerTitle,
              style: context.textStyles.headSmall,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: context.h(0.5)),
            Text(
              l10n.registerSubtitle,
              style: context.textStyles.bodySmall,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: context.h(4)),
            BlocBuilder<RegisterBloc, RegisterState>(
              builder: (context, state) {
                return Column(
                  children: [
                    AppTextField(
                      hintText: l10n.registerNameHint,
                      filled: true,
                      onChanged: (value) => bloc.add(NameChanged(value)),
                    ),
                    SizedBox(height: context.h(2)),
                    EmailTextField(
                      onChanged: (value) => bloc.add(EmailChanged(value)),
                      errorText: state.email.errorMessage,
                      showErrors: state.status == FormzSubmissionStatus.failure,
                    ),
                    SizedBox(height: context.h(2)),
                    PasswordTextField(
                      onChanged: (value) => bloc.add(PasswordChanged(value)),
                      errorText: state.password.errorMessage,
                      showErrors: state.status == FormzSubmissionStatus.failure,
                    ),
                  ],
                );
              },
            ),
            SizedBox(height: context.h(3)),
            AppPrimaryButton(
              unfocusFields: true,
              onPressed: () => bloc.add(const FormSubmitted()),
              child: Text(
                l10n.registerButton,
                style: context.textStyles.titleMed.semibold,
              ),
            ),
            SizedBox(height: context.h(2)),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  l10n.registerAlreadyHaveAccount,
                  style: context.textStyles.bodyMed,
                ),
                TextButton(
                  onPressed: () => context.pop(),
                  child: Text(
                    l10n.registerLoginLink,
                    style: context.textStyles.bodyMed.c(
                      Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
