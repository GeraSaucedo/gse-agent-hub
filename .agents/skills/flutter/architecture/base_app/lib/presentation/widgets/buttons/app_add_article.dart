import 'package:gse_base_app/presentation/widgets/buttons/app_primary_button.dart';
import 'package:gse_design_system/gse_design_system.dart';
import 'package:gse_localization/gse_localization.dart';
import 'package:material_ui/material_ui.dart';

class AddArticleBtn extends StatelessWidget {
  const new({super.key, this.onPressed});

  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return AppPrimaryButton(
      backgroundColor: context.colors.surface,
      onPressed: onPressed,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.add,
            size: context.sp(20),
            color: context.colors.error,
          ),
          SizedBox(width: context.w(2)),
          Text(
            AppLocalizations.of(context)!.addArticleButton,
            style: context.textStyles.titleMed.semibold.c(context.colors.error),
          ),
        ],
      ),
    );
  }
}
