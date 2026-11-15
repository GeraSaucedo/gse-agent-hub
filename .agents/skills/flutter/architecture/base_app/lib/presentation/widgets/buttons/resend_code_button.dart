import 'dart:async';

import 'package:gse_design_system/gse_design_system.dart';
import 'package:material_ui/material_ui.dart';

/// "Didn't get the code? Resend" with a cooldown between sends.
class ResendCodeButton extends StatefulWidget {
  const new({
    required this.prompt,
    required this.resendText,
    required this.waitText,
    required this.onResend,
    this.startCoolingDown = true,
    this.cooldownSeconds = 60,
    super.key,
  });

  /// Text before the button, e.g. "Didn't get the code?".
  final String prompt;
  final String resendText;

  /// Text while waiting, given the seconds left.
  final String Function(int seconds) waitText;
  final VoidCallback onResend;

  /// `true` when a code was just sent, so the first resend waits too.
  final bool startCoolingDown;
  final int cooldownSeconds;

  @override
  State<ResendCodeButton> createState() => _ResendCodeButtonState();
}

class _ResendCodeButtonState extends State<ResendCodeButton> {
  Timer? _timer;
  int _secondsLeft = 0;

  @override
  void initState() {
    super.initState();
    if (widget.startCoolingDown) _startCooldown();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startCooldown() {
    _timer?.cancel();
    setState(() => _secondsLeft = widget.cooldownSeconds);
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() => _secondsLeft--);
      if (_secondsLeft <= 0) timer.cancel();
    });
  }

  void _resend() {
    widget.onResend();
    _startCooldown();
  }

  @override
  Widget build(BuildContext context) {
    final waiting = _secondsLeft > 0;
    final colors = context.colors;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Flexible(
          child: Text(widget.prompt, style: context.textStyles.bodyMed),
        ),
        TextButton(
          onPressed: waiting ? null : _resend,
          child: Text(
            waiting ? widget.waitText(_secondsLeft) : widget.resendText,
            style: context.textStyles.bodyMed.copyWith(
              color: waiting ? colors.textDisabled : colors.primary,
              decoration: waiting ? null : TextDecoration.underline,
              decorationColor: colors.primary,
            ),
          ),
        ),
      ],
    );
  }
}
