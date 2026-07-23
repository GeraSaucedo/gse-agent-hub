import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gse_design_system/gse_design_system.dart';
import 'package:gse_localization/gse_localization.dart';
import 'package:gse_base_app/presentation/widgets/buttons/app_primary_button.dart';

class EmptyView extends StatelessWidget {
  const EmptyView({
    super.key,
    this.text,
    this.onReintent,
    this.fullHeight = true,
  });

  final String? text;
  final VoidCallback? onReintent;
  final bool fullHeight;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: RefreshIndicator(
          onRefresh: () {
            onReintent?.call();
            return Future.value();
          },
          child: SingleChildScrollView(
            physics: onReintent != null
                ? const AlwaysScrollableScrollPhysics()
                : const NeverScrollableScrollPhysics(),
            child: SizedBox(
              height: fullHeight ? context.h(100) - kToolbarHeight : null,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(width: double.infinity),
                  SizedBox(
                    width: context.sp(50),
                    child: AspectRatio(
                      aspectRatio: 1,
                      child: FittedBox(
                        fit: BoxFit.cover,
                        child: SvgPicture.asset(
                          'assets/imgs/empty.svg',
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: context.h(3)),
                  Text(
                    text ?? AppLocalizations.of(context)!.emptyStateMessage,
                    textAlign: TextAlign.center,
                    style: context.textStyles.titleMed,
                  ),
                  SizedBox(height: context.h(3)),
                  if (onReintent != null)
                    AppPrimaryButton(
                      child: Text(
                        AppLocalizations.of(context)!.retryButton,
                        style: context.textStyles.titleMed.semibold,
                      ),
                      onPressed: () {
                        onReintent?.call();
                      },
                    ),
                  SizedBox(height: context.h(6)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
