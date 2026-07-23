# GSE Localization

Localization package for GSE Base App. Provides translations for Spanish (es) and English (en) using Flutter's internationalization system.

## Installation

Add the dependency in your app's `pubspec.yaml`:

```yaml
dependencies:
  gse_localization:
    path: packages/gse_localization
```

Then run:

```bash
flutter pub get
```

## Setup

Wrap your app with `LocaleSwitcherProvider` and wire it to `MaterialApp`:

```dart
import 'package:gse_localization/gse_localization.dart';

LocaleSwitcherProvider(
  child: Builder(
    builder: (context) {
      final localeCtrl = LocaleSwitcherProvider.of(context);
      return MaterialApp(
        locale: localeCtrl.locale,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: const MyApp(),
      );
    },
  ),
);
```

## Usage

Access translations from any widget with `BuildContext`:

```dart
import 'package:gse_localization/gse_localization.dart';

final l10n = AppLocalizations.of(context)!;

Text(l10n.appName);   // "GSE App"
Text(l10n.title);     // "Bienvenido" / "Welcome"
Text(l10n.subtitle);  // "Inicia sesión para continuar" / "Sign in to continue"
```

## Switching Language

Change the locale at runtime. The selection is persisted in `SharedPreferences`:

```dart
// Switch to English
LocaleSwitcherProvider.of(context).setLocale(const Locale('en'));

// Switch to Spanish
LocaleSwitcherProvider.of(context).setLocale(const Locale('es'));
```

## Available Strings

| Key | Spanish | English |
|---|---|---|
| `appName` | GSE App | GSE App |
| `title` | Bienvenido | Welcome |
| `subtitle` | Inicia sesión para continuar | Sign in to continue |

## Adding New Strings

1. Add the key and its value in the template file `lib/l10n/app_es.arb`:

```json
{
  "newText": "Valor en español",
  "@newText": {
    "description": "Description of the text"
  }
}
```

2. Add the translation in `lib/l10n/app_en.arb`:

```json
{
  "newText": "Value in English"
}
```

3. Regenerate the localization files:

```bash
cd packages/gse_localization
flutter gen-l10n
```

The generated files in `lib/generated/` will be updated automatically.

## Adding a New Language

1. Create a new ARB file, for example `lib/l10n/app_fr.arb`:

```json
{
  "@@locale": "fr",
  "appName": "GSE App",
  "title": "Bienvenue",
  "subtitle": "Connectez-vous pour continuer"
}
```

2. Run `flutter gen-l10n` to regenerate the files.

## Structure

```
gse_localization/
├── l10n.yaml                          # gen-l10n configuration
├── lib/
│   ├── gse_localization.dart          # Barrel export
│   ├── src/
│   │   ├── locale_controller.dart     # Locale state + persistence
│   │   └── locale_switcher_provider.dart # InheritedNotifier provider
│   ├── l10n/
│   │   ├── app_es.arb                 # Spanish (template)
│   │   └── app_en.arb                 # English
│   └── generated/                     # Auto-generated files
│       ├── app_localizations.dart
│       ├── app_localizations_es.dart
│       └── app_localizations_en.dart
```

> **Note:** Do not manually edit the files in `lib/generated/`. They are regenerated with `flutter gen-l10n`.
