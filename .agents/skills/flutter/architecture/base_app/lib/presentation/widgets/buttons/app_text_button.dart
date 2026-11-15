import 'package:gse_design_system/gse_design_system.dart';
import 'package:material_ui/material_ui.dart';

class AppTextButton extends StatelessWidget {
  const new({
    required this.text,
    this.onPressed,
    super.key,
  });

  final String text;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      child: Text(
        text,
        style: context.textStyles.labelMed,
      ),
    );
  }
}
