import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gse_base_app/presentation/widgets/buttons/app_primary_button.dart';
import 'package:gse_design_system/gse_design_system.dart';
import 'package:gse_localization/gse_localization.dart';

class ErrorView extends StatelessWidget {
  const ErrorView({
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
    return Center(
      child: RefreshIndicator(
        onRefresh: () {
          onReintent?.call();
          return Future.value();
        },
        child: SingleChildScrollView(
          physics: onReintent != null
              ? const AlwaysScrollableScrollPhysics()
              : null,
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
                        'assets/imgs/error.svg',
                      ),
                    ),
                  ),
                ),
                SizedBox(height: context.h(5)),
                Text(
                  text ??
                      AppLocalizations.of(context)!
                          .errorLoadingElementsMessage,
                  textAlign: TextAlign.center,
                  style: context.textStyles.titleMed,
                ),
                SizedBox(height: context.h(5)),
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
