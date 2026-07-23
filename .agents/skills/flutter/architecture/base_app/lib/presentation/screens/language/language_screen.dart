import 'package:flutter/material.dart';
import 'package:gse_design_system/gse_design_system.dart';
import 'package:gse_localization/gse_localization.dart';

class LanguageScreen extends StatelessWidget {
  const LanguageScreen({super.key});

  static const name = 'language';
  static const route = '/language';

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final localeCtrl = LocaleSwitcherProvider.of(context);
    final currentLocale = localeCtrl.locale;

    final languages = [
      (const Locale('es'), l10n.languageSpanish),
      (const Locale('en'), l10n.languageEnglish),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(
          l10n.languageScreenTitle,
          style: context.textStyles.titleLarge.semibold,
        ),
      ),
      body: ListView.separated(
        padding: EdgeInsets.symmetric(vertical: context.spacing.md),
        itemCount: languages.length,
        separatorBuilder: (_, _) => Divider(
          height: 1,
          indent: context.spacing.lg,
          endIndent: context.spacing.lg,
          color: context.colors.onSurfaceLow,
        ),
        itemBuilder: (context, index) {
          final (locale, label) = languages[index];
          final isSelected = currentLocale.languageCode == locale.languageCode;

          return ListTile(
            contentPadding: EdgeInsets.symmetric(
              horizontal: context.spacing.lg,
            ),
            title: Text(
              label,
              style: context.textStyles.bodyLarge.copyWith(
                color: isSelected ? context.colors.primary : null,
              ),
            ),
            trailing: isSelected
                ? Icon(Icons.check, color: context.colors.primary)
                : null,
            onTap: () => localeCtrl.setLocale(locale),
          );
        },
      ),
    );
  }
}
