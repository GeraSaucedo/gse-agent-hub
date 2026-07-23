import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gse_design_system/gse_design_system.dart';
import 'package:gse_localization/generated/app_localizations.dart';
import 'package:gse_base_app/presentation/blocs/verify_email/verify_email_bloc.dart';
import 'package:gse_base_app/presentation/widgets/buttons/app_primary_button.dart';
import 'package:gse_base_app/presentation/widgets/inputs/app_text_field.dart';
import 'package:gse_base_app/presentation/widgets/utils/custom_appbar.dart';

class VerifyEmailScreen extends StatefulWidget {
  const VerifyEmailScreen({
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
  Timer? _resendTimer;
  int _resendCooldown = 0;

  @override
  void initState() {
    super.initState();
    final bloc = context.read<VerifyEmailBloc>();
    if (widget.skipSend) {
      bloc.add(EmailSet(widget.email));
    } else {
      bloc.add(InitRequested(widget.email));
      _startResendCooldown();
    }
  }

  void _startResendCooldown() {
    setState(() => _resendCooldown = 60);
    _resendTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _resendCooldown--;
        if (_resendCooldown <= 0) {
          timer.cancel();
        }
      });
    });
  }

  @override
  void dispose() {
    _resendTimer?.cancel();
    super.dispose();
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
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  l10n.verifyEmailDidNotReceiveCode,
                  style: context.textStyles.bodyMed,
                ),
                TextButton(
                  onPressed: _resendCooldown > 0
                      ? null
                      : () {
                          bloc.add(const ResendRequested());
                          _startResendCooldown();
                        },
                  child: Text(
                    _resendCooldown > 0
                        ? l10n.verifyEmailResendIn(_resendCooldown)
                        : l10n.verifyEmailResendEmail,
                    style: context.textStyles.bodyMed.copyWith(
                      color: _resendCooldown > 0
                          ? Theme.of(
                              context,
                            ).colorScheme.onSurface.withValues(alpha: 0.4)
                          : Theme.of(context).colorScheme.primary,
                      decoration: _resendCooldown > 0
                          ? null
                          : TextDecoration.underline,
                      decorationColor: Theme.of(context).colorScheme.primary,
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
