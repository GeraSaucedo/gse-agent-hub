import 'package:cupertino_ui/cupertino_ui.dart';
import 'package:flutter_localizations/flutter_localizations.dart'
    show GlobalWidgetsLocalizations;
import 'package:gse_localization/generated/app_localizations.dart';
import 'package:material_ui/material_ui.dart';

/// Localization delegates for the app.
///
/// Replaces `AppLocalizations.localizationsDelegates`, which `flutter gen-l10n`
/// still generates with the deprecated `flutter_localizations` delegates for
/// Material and Cupertino. This list uses the ones from `material_ui` and
/// `cupertino_ui` instead.
const List<LocalizationsDelegate<dynamic>> appLocalizationsDelegates =
    <LocalizationsDelegate<dynamic>>[
      AppLocalizations.delegate,
      GlobalMaterialLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
    ];
