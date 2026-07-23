# AGENTS.md — Flutter / Dart conventions (GSE architecture)

Stack-specific standards for the GSE base architecture. Assumed by every skill in this
folder. Read before any Flutter work. The `architecture` skill scaffolds a project with
this exact shape; `check-arch` verifies it.

## Language & tooling
- Dart with sound null safety. Format with `dart format`; lint with `flutter analyze` (zero warnings). Lints: `very_good_analysis`.
- State management: **BLoC / Cubit** (`flutter_bloc`). BLoC for flows with distinct events; Cubit for simple state (e.g. `auth`, `pagination`). Don't introduce another state solution.
- Immutable models & states with **`freezed`**. Codegen: `dart run build_runner build --delete-conflicting-outputs`.
- Routing: **`go_router`** (`lib/core/routes/app_router.dart`) with an auth redirect guard. DI: **`get_it`** via the injectors. HTTP: **`dio`** with interceptors. Forms: **`formz`** inputs.
- **Never read `.env`, environment variables, or `--dart-define` / `String.fromEnvironment` values** (see root prohibitions). Flavors inject config at build time; treat config keys as opaque.

## Project layout (layer-first)
```
lib/
  core/          # constants, environments (flavor config), extensions, icons,
                 # routes (go_router), services (api/dio, storage, logger), utils (Result)
  domain/models/ # freezed models (fromJson/toJson/copyWith)
  data/          # inputs (formz), repositories/<domain>/ (…_repository.dart + …_failures.dart)
  presentation/  # blocs/<domain>/, screens/<domain>/, widgets/<category>/
  main.dart · main_app.dart · main_injector.dart
packages/design_system/     # gse_design_system (theme, colors, sizes, texts)
packages/gse_localization/  # ARB l10n (app_en, app_es)
tools/setup_flavors.dart    # generates dev/stg/prod flavor config
```

## Conventions
- **Layers depend inward:** presentation → data → domain. Screens never call `dio` directly; they go through a BLoC → repository.
- **Repositories return a `Result`** and a typed `<Domain>Failure` enum — never throw raw exceptions to the UI. Map Dio errors in `core/services/api/error_mapping.dart`.
- **Register everything in its injector** (`services_injector`, `repositories_injector`, `blocs_injector`, wired by `main_injector`). No manual singletons.
- **One public widget per file**, `snake_case.dart` ↔ `PascalCase`. Widgets `const` where possible; extract sub-widgets over deep build methods. No business logic in widgets.
- **User-facing strings** come from `gse_localization` ARB files — never hardcoded. Colors/sizes/text styles come from `gse_design_system`, not magic numbers.
- **List + mutation** (create/update/delete): mutate `state.items` locally on success; do NOT re-fetch the list (see `new-bloc` / `new-module`).

## Skills in this folder
- **architecture** — scaffold a new project (the base). · **flavors** — generate dev/stg/prod.
- **new-module** — full feature across all 4 layers (calls the four below). · **new-model** · **new-repository** · **new-bloc** · **new-screen**.
- **check-arch** — verify the base is complete. · **clean-code** — quality pass. · **testing** — BLoC/widget tests.

## Testing
- `flutter test`; mirror `lib/` under `test/`. BLoCs/Cubits tested with `bloc_test`; repositories with mocked `dio`. See the `testing` skill.
