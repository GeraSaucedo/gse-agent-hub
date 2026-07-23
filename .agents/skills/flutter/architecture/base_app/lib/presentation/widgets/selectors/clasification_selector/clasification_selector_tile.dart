/* import 'package:flutter/material.dart';
import 'package:gse_design_system/gse_design_system.dart';

class ClasificationSelectorTile extends StatelessWidget {
  const ClasificationSelectorTile({
    required this.clasification,
    required this.onPressed,
    super.key,
  });

  final String clasification;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onPressed,
      title: Row(
        children: [
          Icon(
            Icons.app_registration_outlined,
            size: context.sp(22),
            color: context.colorScheme.primary,
          ),
          SizedBox(width: context.w(2)),
          Expanded(
            child: Text(
              clasification,
              style: context.textStyles.bodyMed,
            ),
          ),
        ],
      ),
    );
  }
}
 */
