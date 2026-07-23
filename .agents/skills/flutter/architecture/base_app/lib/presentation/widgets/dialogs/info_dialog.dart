import 'package:flutter/material.dart';
import 'package:gse_design_system/gse_design_system.dart';

class InfoDialog extends StatelessWidget {
  const InfoDialog({
    required this.text,
    super.key,
  });

  final String text;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(context.sp(14)),
          child: Material(
            child: Container(
              padding: EdgeInsets.only(
                left: context.w(4),
                right: context.w(4),
                top: context.h(2),
                bottom: context.h(1),
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(context.sp(14)),
                color: context.colors.surface,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.info_outline_rounded,
                    color: Theme.of(context).colorScheme.primary,
                    size: context.sp(19),
                  ),
                  SizedBox(width: context.w(3)),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          text,
                          style: context.textStyles.bodyLarge,
                        ),
                        SizedBox(height: context.h(2)),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text(
                                'Aceptar',
                                style: context.textStyles.labelLarge.c(
                                  context.colors.error,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  static Future<bool> show(BuildContext context, {required String text}) async {
    final result = await showDialog<bool>(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.7),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.symmetric(
            vertical: context.h(2),
            horizontal: context.w(4),
          ),
          child: InfoDialog(
            text: text,
          ),
        );
      },
    );

    return result ?? false;
  }
}
