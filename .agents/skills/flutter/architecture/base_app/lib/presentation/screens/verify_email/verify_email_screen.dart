import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gse_base_app/presentation/blocs/verify_email/verify_email_bloc.dart';
import 'package:gse_base_app/presentation/widgets/buttons/app_primary_button.dart';
import 'package:gse_base_app/presentation/widgets/buttons/resend_code_button.dart';
import 'package:gse_base_app/presentation/widgets/inputs/app_text_field.dart';
import 'package:gse_base_app/presentation/widgets/utils/custom_appbar.dart';
import 'package:gse_design_system/gse_design_system.dart';
import 'package:gse_localization/generated/app_localizations.dart';
import 'package:material_ui/material_ui.dart';

class VerifyEmailScreen extends StatefulWidget {
  const new({
    required this.email,
    this.skipSend = false,
    super.key,
  });

  final String email;
  final bool skipSend;

  static const name = 'verify-email-screen';
  static const route = '/verify-email';

  @override
  State<VerifyEmailScreen> createState() => _VerifyEmailScreenState();
}

class _VerifyEmailScreenState extends State<VerifyEmailScreen> {
  @override
  void initState() {
    super.initState();
    final bloc = context.read<VerifyEmailBloc>();
    if (widget.skipSend) {
      bloc.add(EmailSet(widget.email));
    } else {
      bloc.add(InitRequested(widget.email));
    }
  }

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<VerifyEmailBloc>();
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: const CustomAppBar(title: ''),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: context.w(4)),
        child: Column(
          children: [
            SizedBox(height: context.h(4)),
            Text(
              l10n.verifyEmailTitle,
              style: context.textStyles.headLarge,
            ),
            SizedBox(height: context.h(2)),
            Text(
              l10n.verifyEmailSubtitle,
              style: context.textStyles.bodyMed,
            ),
            SizedBox(height: context.h(3)),
            BlocSelector<VerifyEmailBloc, VerifyEmailState, String>(
              selector: (state) => state.code,
              builder: (context, code) {
                return AppTextField(
                  hintText: l10n.verifyEmailCodeHint,
                  filled: true,
                  onChanged: (value) => bloc.add(CodeChanged(value)),
                  initialValue: code,
                );
              },
            ),
            SizedBox(height: context.h(2)),
            SizedBox(
              width: double.infinity,
              child: BlocSelector<VerifyEmailBloc, VerifyEmailState, String>(
                selector: (state) => state.code,
                builder: (context, code) {
                  return AppPrimaryButton(
                    onPressed: () => bloc.add(const FormSubmitted()),
                    enabled: code.isNotEmpty,
                    child: Text(
                      l10n.verifyEmailVerifyButton,
                      style: context.textStyles.titleMed.semibold,
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: context.h(2)),
            ResendCodeButton(
              prompt: l10n.verifyEmailDidNotReceiveCode,
              resendText: l10n.verifyEmailResendEmail,
              waitText: l10n.verifyEmailResendIn,
              onResend: () => bloc.add(const ResendRequested()),
              // With skipSend the code was sent by register, not here.
              startCoolingDown: !widget.skipSend,
            ),
          ],
        ),
      ),
    );
  }
}
