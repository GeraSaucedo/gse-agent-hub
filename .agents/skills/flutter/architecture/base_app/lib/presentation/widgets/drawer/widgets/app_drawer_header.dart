import 'package:gse_design_system/gse_design_system.dart';
import 'package:material_ui/material_ui.dart';

class AppDrawerHeader extends StatelessWidget {
  const new({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: context.w(3)),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '-',
                  maxLines: 1,
                  overflow: TextOverflow.clip,
                  style: context.textStyles.titleMed,
                ),
                SizedBox(height: context.h(0.5)),
                Text(
                  '-',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: context.textStyles.labelMed.c(
                    context.colors.onSurfaceLow,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: context.w(4)),
          //LogoutButton()
        ],
      ),
    );
  }
}
