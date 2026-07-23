---
name: new-screen
description: Generate a new Screen + View + BlocListener following GSE Base App conventions
argument-hint: <ScreenName> <domain> <variant> "<description>"
allowed-tools: [Read, Write, Glob, Grep, Bash]
---

# New Screen

Generate a complete screen following the GSE Base App `_screen / _view / _bloc_listener` pattern.

## Arguments

The user invoked this skill with: `$ARGUMENTS`

- `<ScreenName>`: class name in PascalCase (e.g. `ProductDetail`, `InvoiceForm`)
- `<domain>`: subdirectory in snake_case (e.g. `products`, `invoices`)
- `<variant>`: one of `form` | `data` | `simple`
  - `form` — screen with Formz input fields, LoadingOverlay, submit button
  - `data` — screen that fetches and displays data (loading / error / success states)
  - `simple` — screen with static content, no BLoC required
- `"<description>"`: plain-language description of what the screen does

Before generating any file, read `pubspec.yaml` to extract the `name:` field and use it as `<package_name>` in all import paths.

---

## Design System reference

All generated code must use the GSE Design System tokens. Never use hardcoded pixel values, raw `Colors.*`, or inline `TextStyle(fontSize: ...)`.

### Import
```dart
import 'package:gse_design_system/gse_design_system.dart';
```

### Sizing (responsive)
| Token | Usage |
|---|---|
| `context.h(perc)` | % of screen height — use for vertical spacing and full-height containers |
| `context.w(perc)` | % of screen width — use for horizontal padding |
| `context.sp(size)` | responsive font size — only needed for custom TextStyle; prefer `context.textStyles.*` |
| `context.adaptive(size)` | scales ×1.25 on tablet — for icon sizes, avatar radii |

### Spacing tokens (prefer over `context.h/w` for fixed gaps)
| Token | Value (mobile) |
|---|---|
| `context.spacing.xs` | 4 |
| `context.spacing.sm` | 8 |
| `context.spacing.md` | 16 |
| `context.spacing.lg` | 24 |
| `context.spacing.xl` | 32 |
| `context.spacing.xxl` | 48 |

Use `SizedBox(height: context.spacing.md)` for standard gaps. Use `SizedBox(height: context.h(N))` for proportional full-screen layouts (e.g. login form centering).

### Text styles
Access via `context.textStyles.<token>`. All are responsive (use `sp()` internally).

| Token | Size / Weight |
|---|---|
| `headLarge` | 28sp w700 |
| `headMed` | 24sp w700 |
| `headSmall` | 20sp w600 |
| `titleLarge` | 18sp w600 |
| `titleMed` | 16sp w600 |
| `titleSmall` | 14sp w600 |
| `bodyLarge` | 16sp w400 |
| `bodyMed` | 14sp w400 |
| `bodySmall` | 12sp w400 |
| `labelLarge` | 14sp w500 |
| `labelMed` | 12sp w500 |
| `captionMed` | 12sp w400 |

Chainable modifiers: `.bold`, `.semibold`, `.italic`, `.c(color)` (set color).

Examples:
```dart
context.textStyles.headSmall
context.textStyles.titleMed.semibold
context.textStyles.bodyMed.c(context.colors.textSecondary)
```

### Colors
Access via `context.colors.<token>`:

| Token | Semantic use |
|---|---|
| `primary` / `onPrimary` | Brand CTA, active states |
| `secondary` / `onSecondary` | Secondary actions |
| `textPrimary` | Headings, high-contrast body text |
| `textSecondary` | Subtitles, supporting text, labels |
| `textDisabled` | Disabled elements |
| `surface` | Cards, bottom sheets, modals |
| `scaffoldBackground` | Page background |
| `onSurface` / `onSurfaceLow` | Borders, dividers |
| `error` / `onError` | Error states |
| `success` / `warning` / `info` | Semantic states |

---

## Localization reference

All user-facing strings must come from the localization package.

### Import
```dart
import 'package:gse_localization/generated/app_localizations.dart';
```

### Access in a widget
```dart
final l10n = AppLocalizations.of(context)!;
```

### Pre-defined generic strings (use these for common failure messages)
| Key | Meaning |
|---|---|
| `l10n.genericServerFailureError` | Server error. Please try again |
| `l10n.genericNetworkFailureError` | No internet connection |
| `l10n.genericUnknownFailureError` | Unknown error. Please try again |

For screen-specific strings, instruct the user to add keys to:
- `packages/gse_localization/lib/l10n/app_en.arb`
- `packages/gse_localization/lib/l10n/app_es.arb`

Then regenerate: `flutter gen-l10n` inside the `packages/gse_localization/` directory.

---

## Localization key convention

All keys follow the pattern: `<featurePrefix><ElementType><Specifier?>` in camelCase.

### Prefix rules

| Source | Prefix | Example |
|---|---|---|
| Screen with "Screen" suffix where disambiguation is needed | `<name>Screen` | `LoginScreen` → `loginScreen` |
| Feature domain (no "Screen") | `<featureName>` | `ForgotPassword` → `forgotPassword`, `Register` → `register` |
| Domain-level failures | `<featureName>Failure` | `login` → `loginFailure`, `register` → `registerFailure` |
| Globally reusable | `generic` | `genericNetworkFailureError` |

**Rule of thumb:** If the screen name is `XxxScreen`, the prefix is `xxxScreen`. If the name describes the feature directly (`ForgotPassword`, `VerifyEmail`), the prefix is the feature name in camelCase.

### Suffix rules by element type

| Element | Suffix pattern | Example |
|---|---|---|
| Screen title | `Title` | `loginScreenTitle`, `registerTitle` |
| Screen subtitle | `Subtitle` | `loginScreenSubtitle`, `forgotPasswordChangeSubtitle` |
| Primary action button | `<Verb>Button` | `loginScreenLoginButton`, `forgotPasswordUpdateButton` |
| Secondary link/text button | `<Verb>Link` | `registerLoginLink` |
| Input field placeholder | `<Field>Hint` | `loginScreenUsernameHint`, `forgotPasswordCodeHint` |
| Success message | `<Action>Success` | `forgotPasswordUpdateSuccess` |
| Failure message | `Failure<PascalCaseName>` | `loginFailureInvalidCredentials`, `registerFailureEmailAlreadyExists` |

### Failure key derivation

Failure enum cases map to **human-readable** key names — not a direct transliteration of the enum value:

| Failure enum case | Key name | Rationale |
|---|---|---|
| `networkError` | `genericNetworkFailureError` | generic, already exists |
| `serverError` | `genericServerFailureError` | generic, already exists |
| `unknownError` | `genericUnknownFailureError` | generic, already exists |
| `unauthorized` | `<feature>FailureInvalidCredentials` | what it means for the user |
| `invalidForm` | `<feature>FailureInvalidForm` | |
| `emailAlreadyExists` | `<feature>FailureEmailAlreadyExists` | |
| `notFound` | `<feature>FailureNotFound` | |
| `timeout` | `<feature>FailureConnectionTimeout` | |
| `forbidden` | `<feature>FailureForbidden` | |

> `networkError`, `serverError`, and `unknownError` always map to the three generic keys — never create screen-specific duplicates for them.

### ARB entry format

Every new key must be added to **both** `app_en.arb` and `app_es.arb` with its `@` metadata entry:

```json
"<key>": "<EN value>",

"<key>": "<ES value>",
"@<key>": {
  "description": "<one-line description of where and how this string is used>"
},
```

The `@` metadata entry with `description` is required in **both** files (following the ES file convention).

### What to generate

When the skill creates a new screen, it must output the exact ARB entries to add — not just key names. For each string needed, produce:

```
// app_en.arb — add these entries:
"<key>": "<English text>",
"@<key>": { "description": "<description>" },

// app_es.arb — add these entries:
"<key>": "<Spanish text>",
"@<key>": { "description": "<descripción>" },
```

Then remind the user to run `flutter gen-l10n` inside `packages/gse_localization/`.

---

## Step 0 — Read existing state

1. Read `pubspec.yaml` → extract `name:` as `<package_name>`
2. Grep for the BLoC class the screen will use (search `lib/presentation/blocs/<domain>/`) to confirm it exists, its state fields, its events, and its failure enum
3. If `variant=form`: check `lib/data/inputs/` for available `FormzInput` subclasses
4. Scan the failure enum file to list all cases — these will drive the failure `switch` in `_bloc_listener.dart`
5. Read one existing screen in `lib/presentation/screens/` to confirm the import style

---

## Step 1 — Files to generate

| File | When |
|---|---|
| `lib/presentation/screens/<domain>/<screen_snake>_screen.dart` | Always |
| `lib/presentation/screens/<domain>/<screen_snake>_view.dart` | Always |
| `lib/presentation/screens/<domain>/<screen_snake>_bloc_listener.dart` | Only if `variant != simple` |

Where `<screen_snake>` = ScreenName converted to snake_case (e.g. `ProductDetail` → `product_detail`).

---

## Step 2 — Generate `_screen.dart`

The screen is responsible for:
- Declaring `static const name` and `static const route`
- Wrapping with `<ScreenName>BlocListener` (if not simple)
- Providing the `Scaffold` with optional `CustomAppBar`
- Rendering `<ScreenName>View()` as the body

**Template — form variant** (no AppBar, scrollable full-height body):
```dart
import 'package:flutter/material.dart';
import 'package:<package_name>/presentation/screens/<domain>/<screen_snake>_bloc_listener.dart';
import 'package:<package_name>/presentation/screens/<domain>/<screen_snake>_view.dart';
import 'package:gse_design_system/gse_design_system.dart';

class <ScreenName>Screen extends StatelessWidget {
  const <ScreenName>Screen({super.key});

  static const name = '<screen-kebab>-screen';
  static const route = '/<screen-kebab>';

  @override
  Widget build(BuildContext context) {
    return <ScreenName>BlocListener(
      child: Scaffold(
        body: SingleChildScrollView(
          child: SizedBox(
            height: context.h(100),
            child: const <ScreenName>View(),
          ),
        ),
      ),
    );
  }
}
```

**Template — data variant** (with CustomAppBar):
```dart
import 'package:flutter/material.dart';
import 'package:<package_name>/presentation/screens/<domain>/<screen_snake>_bloc_listener.dart';
import 'package:<package_name>/presentation/screens/<domain>/<screen_snake>_view.dart';
import 'package:<package_name>/presentation/widgets/utils/custom_appbar.dart';

class <ScreenName>Screen extends StatelessWidget {
  const <ScreenName>Screen({super.key});

  static const name = '<screen-kebab>-screen';
  static const route = '/<screen-kebab>';

  @override
  Widget build(BuildContext context) {
    return <ScreenName>BlocListener(
      child: const Scaffold(
        appBar: CustomAppBar(title: '<Human readable title>'),
        body: <ScreenName>View(),
      ),
    );
  }
}
```

**Template — simple variant** (no BlocListener):
```dart
import 'package:flutter/material.dart';
import 'package:<package_name>/presentation/screens/<domain>/<screen_snake>_view.dart';
import 'package:<package_name>/presentation/widgets/utils/custom_appbar.dart';

class <ScreenName>Screen extends StatelessWidget {
  const <ScreenName>Screen({super.key});

  static const name = '<screen-kebab>-screen';
  static const route = '/<screen-kebab>';

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: CustomAppBar(title: '<Human readable title>'),
      body: <ScreenName>View(),
    );
  }
}
```

> **Note:** Do NOT add `UnfocusOnTap`. The user adds it manually only when needed.

---

## Step 3 — Generate `_bloc_listener.dart`

The listener handles side effects only: loading overlay, snackbars, and navigation.

### Failure mapping rules

- Read the actual failure enum from `lib/data/repositories/<domain>/<bloc_snake>_failures.dart`
- Map each case explicitly in the `switch` — no `default:` that silently swallows cases
- Use `_` as the final catch-all only if there are genuinely unhandleable or future cases
- For common failures (`networkError`, `serverError`, `unknownError`), use the pre-defined generic l10n keys
- For domain-specific failures, leave a `// TODO: add to app_en.arb and app_es.arb` comment with the suggested key name

### Template — form variant

```dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:<package_name>/data/repositories/<domain>/<bloc_snake>_failures.dart';
import 'package:<package_name>/presentation/blocs/<domain>/<bloc_snake>_bloc.dart';
import 'package:<package_name>/presentation/widgets/overlays/loading_overlay.dart';
import 'package:<package_name>/presentation/widgets/utils/app_snackbar.dart';
import 'package:gse_localization/generated/app_localizations.dart';

class <ScreenName>BlocListener extends StatelessWidget {
  const <ScreenName>BlocListener({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<<BlocName>Bloc>();

    return MultiBlocListener(
      listeners: [
        // Loading overlay — reacts to status changes
        BlocListener<<BlocName>Bloc, <BlocName>State>(
          listenWhen: (previous, current) => previous.status != current.status,
          listener: (context, state) {
            if (state.status == FormzSubmissionStatus.inProgress) {
              LoadingOverlay.show(context);
            } else {
              LoadingOverlay.remove();
            }
            if (state.status == FormzSubmissionStatus.success) {
              bloc.add(const <BlocName>Event.cleanState());
              // TODO: navigate after success if needed (e.g. context.pop())
            }
          },
        ),
        // Failure messages — only fires when failure changes to a non-null value
        BlocListener<<BlocName>Bloc, <BlocName>State>(
          listenWhen: (previous, current) =>
              previous.failure != current.failure && current.failure != null,
          listener: (context, state) {
            final l10n = AppLocalizations.of(context)!;
            final message = switch (state.failure) {
              // TODO: map domain-specific failures to l10n keys (add keys to app_en.arb + app_es.arb)
              // <BlocName>Failure.someSpecificCase => l10n.<screenName>FailureSomeCase,
              <BlocName>Failure.networkError => l10n.genericNetworkFailureError,
              <BlocName>Failure.serverError  => l10n.genericServerFailureError,
              _                              => l10n.genericUnknownFailureError,
            };
            AppSnackbar.show(context, message);
          },
        ),
      ],
      child: child,
    );
  }
}
```

### Template — data variant

```dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:<package_name>/data/repositories/<domain>/<bloc_snake>_failures.dart';
import 'package:<package_name>/presentation/blocs/<domain>/<bloc_snake>_bloc.dart';
import 'package:<package_name>/presentation/widgets/utils/app_snackbar.dart';
import 'package:gse_localization/generated/app_localizations.dart';

class <ScreenName>BlocListener extends StatelessWidget {
  const <ScreenName>BlocListener({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<<BlocName>Bloc, <BlocName>State>(
          listenWhen: (previous, current) =>
              previous.failure != current.failure && current.failure != null,
          listener: (context, state) {
            final l10n = AppLocalizations.of(context)!;
            final message = switch (state.failure) {
              // TODO: map domain-specific failures to l10n keys
              <BlocName>Failure.networkError => l10n.genericNetworkFailureError,
              <BlocName>Failure.serverError  => l10n.genericServerFailureError,
              _                              => l10n.genericUnknownFailureError,
            };
            AppSnackbar.show(context, message);
          },
        ),
      ],
      child: child,
    );
  }
}
```

> If the data variant has mutations (preload + operation pattern), add a second `BlocListener` for `operationFailure` / `operationStatus` following the same structure.

---

## Step 4 — Generate `_view.dart`

### Form variant

`StatelessWidget`. Wrap **only the form fields** in `BlocBuilder` — not the entire screen.

Capture the bloc **outside** the builder (`context.read<XxxBloc>()`) so events are dispatched on the cached instance, not rebuilding on every event.

```dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:<package_name>/presentation/blocs/<domain>/<bloc_snake>_bloc.dart';
import 'package:<package_name>/presentation/widgets/buttons/app_primary_button.dart';
// TODO: import specific input widgets (EmailTextField, PasswordTextField, etc.)
import 'package:gse_design_system/gse_design_system.dart';
import 'package:gse_localization/generated/app_localizations.dart';

class <ScreenName>View extends StatelessWidget {
  const <ScreenName>View({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final bloc = context.read<<BlocName>Bloc>();

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: context.w(4),
          vertical: context.h(2),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // TODO: add header / logo / title here if needed
            Text(
              l10n.<screenTitle>,
              style: context.textStyles.headSmall,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: context.spacing.xs),
            Text(
              l10n.<screenSubtitle>,
              style: context.textStyles.bodySmall.c(context.colors.textSecondary),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: context.h(5)),

            BlocBuilder<<BlocName>Bloc, <BlocName>State>(
              builder: (context, state) {
                return Column(
                  children: [
                    // TODO: add Formz-connected fields following this pattern:
                    //
                    // SomeTextField(
                    //   enabled: !bloc.isLoading,
                    //   onChanged: (value) => bloc.add(<BlocName>Event.fieldChanged(value)),
                    //   errorText: state.fieldName.errorMessage,
                    //   showErrors: bloc.formSubmitted,
                    // ),
                    // SizedBox(height: context.spacing.md),
                  ],
                );
              },
            ),

            SizedBox(height: context.h(3)),

            AppPrimaryButton(
              onPressed: () => bloc.add(const <BlocName>Event.formSubmitted()),
              unfocusFields: true,
              child: Text(
                l10n.<submitButtonKey>,
                style: context.textStyles.titleMed.semibold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
```

#### Form field connection rules

For each Formz input field, apply this exact pattern:

```dart
SomeTextField(
  enabled: !bloc.isLoading,              // getter on the BLoC class, not state
  onChanged: (value) => bloc.add(<BlocName>Event.fieldChanged(value)),
  errorText: state.fieldName.errorMessage,
  showErrors: bloc.formSubmitted,        // getter on the BLoC class
),
```

- `bloc.isLoading` and `bloc.formSubmitted` are **BLoC class getters**, not state getters — capture with `context.read<XxxBloc>()` outside the builder
- `state.fieldName.errorMessage` is a `FormzInput` getter — accessed inside the builder where `state` is fresh
- `showErrors: bloc.formSubmitted` controls whether the error text is visible; the `FormzInput` itself decides what the error is

If `formSubmitted` is missing on the BLoC, remind the user to add:
```dart
bool get formSubmitted =>
    state.status == FormzSubmissionStatus.failure ||
    state.status == FormzSubmissionStatus.success;
```

---

### Data variant

`StatefulWidget` when `initState` fires the initial event. `StatelessWidget` otherwise.

```dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:<package_name>/presentation/blocs/<domain>/<bloc_snake>_bloc.dart';
import 'package:<package_name>/presentation/widgets/views/empty_view.dart';
import 'package:<package_name>/presentation/widgets/views/error_view.dart';
import 'package:<package_name>/presentation/widgets/utils/app_loader.dart';
import 'package:gse_design_system/gse_design_system.dart';

class <ScreenName>View extends StatefulWidget {
  const <ScreenName>View({super.key});

  @override
  State<<ScreenName>View> createState() => _<ScreenName>ViewState();
}

class _<ScreenName>ViewState extends State<<ScreenName>View> {
  @override
  void initState() {
    super.initState();
    context.read<<BlocName>Bloc>().add(const <BlocName>Event.<blocNameCamelCase>Fetched());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<<BlocName>Bloc, <BlocName>State>(
      builder: (context, state) {
        if (state.isLoading) {
          return const Center(child: AppLoader());
        }

        if (state.isFailure && state.items.isEmpty) {
          return ErrorView(
            onRetry: () => context
                .read<<BlocName>Bloc>()
                .add(const <BlocName>Event.<blocNameCamelCase>Fetched()),
          );
        }

        if (state.items.isEmpty) {
          return const EmptyView();
        }

        return Padding(
          padding: EdgeInsets.symmetric(horizontal: context.w(4)),
          child: ListView.builder(
            itemCount: state.items.length,
            itemBuilder: (context, index) {
              final item = state.items[index];
              // TODO: replace with actual item widget
              return ListTile(title: Text(item.toString()));
            },
          ),
        );
      },
    );
  }
}
```

---

### Simple variant

`StatelessWidget` with no BLoC — layout and static content only.

```dart
import 'package:flutter/material.dart';
import 'package:gse_design_system/gse_design_system.dart';

class <ScreenName>View extends StatelessWidget {
  const <ScreenName>View({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: context.w(4)),
      child: const Column(
        children: [
          // TODO: add content
        ],
      ),
    );
  }
}
```

---

## Step 5 — Registration checklist

Show this at the end:

```
Generated:
  lib/presentation/screens/<domain>/<screen_snake>_screen.dart
  lib/presentation/screens/<domain>/<screen_snake>_view.dart
  lib/presentation/screens/<domain>/<screen_snake>_bloc_listener.dart  (if applicable)

Registration checklist:
  [ ] Add route to lib/core/routes/app_router.dart:
      GoRoute(
        path: <ScreenName>Screen.route,
        name: <ScreenName>Screen.name,
        builder: (_, __) => const <ScreenName>Screen(),
      ),
  [ ] If BLoC is screen-scoped, provide it at the route level:
      builder: (_, __) => BlocProvider(
        create: (_) => sl<<BlocName>Bloc>(),
        child: const <ScreenName>Screen(),
      ),
  [ ] Paste the generated ARB entries into:
      packages/gse_localization/lib/l10n/app_en.arb
      packages/gse_localization/lib/l10n/app_es.arb
      Then run: flutter gen-l10n (inside packages/gse_localization/)
  [ ] Map all <BlocName>Failure cases in _bloc_listener.dart
  [ ] Fill in form fields / list items / content in _view.dart
```

---

## Rules summary

| Rule | Detail |
|---|---|
| Screen responsibility | `static const name/route`, BlocListener wrapper, Scaffold + optional CustomAppBar |
| View responsibility | Content — BlocBuilder for state, form fields, list rendering |
| BlocListener | Separate widget accepting `child`; `MultiBlocListener`; one listener per concern with `listenWhen` |
| Bloc reference in view | `context.read<XxxBloc>()` **outside** the `BlocBuilder` builder function |
| Form fields | `enabled: !bloc.isLoading`, `onChanged` adds event, `errorText: state.field.errorMessage`, `showErrors: bloc.formSubmitted` |
| Loading overlay | Show on `inProgress`, remove on any other status — in listener, not in builder |
| Failure display | `AppSnackbar.show(context, message)` with exhaustive `switch` on typed failure enum |
| Failure l10n | Generic failures → `l10n.genericNetworkFailureError / genericServerFailureError / genericUnknownFailureError`; domain-specific → add to ARB files |
| Spacing | `context.spacing.*` for standard gaps; `context.h(N)` for proportional full-screen layouts |
| Text styles | Always `context.textStyles.<token>` — never inline `TextStyle(fontSize: ...)` |
| Colors | Always `context.colors.<token>` — never `Colors.*` |
| No UnfocusOnTap | Do NOT add it — user adds manually if needed |
| StatefulWidget for view | Only when `initState` is needed (initial data fetch); otherwise StatelessWidget |
| Route name | kebab-case + `-screen` suffix (e.g. `product-detail-screen`) |
| Route path | kebab-case with leading slash (e.g. `/product-detail`) |
