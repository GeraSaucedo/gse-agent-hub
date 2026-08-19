---
name: architecture
description: Scaffold a new Flutter project with the GSE base architecture (Clean layer-first, BLoC, go_router, dio, get_it, design_system + gse_localization). Use when starting a new project or regenerating the base.
---

# Skill: Scaffold the GSE base architecture

Follow the Flutter `AGENTS.md` conventions. This skill creates the whole base of a new
project from the editable template in `base_app/`. It replaces the retired VSCode extension.

## When to use
Starting a new Flutter project, or laying down the base architecture into an empty repo.

## What gets generated
The full-setup base: `lib/{core,domain,data,presentation}`, the `design_system` and
`gse_localization` local packages, `tools/setup_flavors.dart`, the customized Android config,
assets, and the project's `.claude/skills/` (the feature-generation commands). See `base_app/`
for the exact contents and `check-arch` for the full inventory.

## Prerequisite — native scaffolding
`base_app/` is a **code + config overlay**: it ships the GSE `lib/`, packages, and the
*customized* `android/app/` files, but **not** the full native platform (no `ios/`, no
`android/settings.gradle.kts` / `MainActivity` / `res/` / gradle wrapper). Create those first
with the target Flutter version, then overlay:
```bash
# pin the Flutter version you want to stay current on, then create the native shell
flutter create --empty --org <org> --project-name <name> <targetDir>
cd <targetDir> && fvm use <version>    # e.g. 3.47.0 — writes .fvmrc
```
The generator's Android files (compileSdk, flavors, signing) assume the native shell was made
by that same Flutter version — mismatched versions break the Gradle build.

## Auth variant (ask the human first)
Before generating, ask **which auth the project needs**:
- **`jwt`** (default) — the base's own email/password auth over `dio` (REST backend).
- **`amplify`** — AWS Amplify + Amazon Cognito (email/password, Google, Apple). Pick this when
  the project authenticates against a Cognito User Pool. Pass `--auth amplify` to the generator.

The variant is a deterministic overlay in `auth_variants/<variant>/` applied on top of the JWT
base — no code is re-derived. `amplify` also needs an existing Cognito pool + native deep-link
wiring; see the `auth-cognito` skill for prerequisites and the post-scaffold steps.

## Steps
1. **Run the generator** over the created project (headless, no VSCode needed):
   ```bash
   node <hub>/.agents/skills/flutter/architecture/generate.mjs <targetDir> [packageName] [androidNamespace] [--auth jwt|amplify]
   ```
   - `packageName` defaults to a sanitized `<targetDir>` basename; `androidNamespace` to `com.example.<packageName>`.
     **Pass an `androidNamespace` that matches the `--org` you used** so the overlaid `build.gradle.kts` and the native `MainActivity` line up.
   - `--auth` defaults to `jwt`. With `--auth amplify` the generator overlays the Amplify auth
     files and removes the JWT-only ones (`jwt_utils`, `token_manager`, `refresh_token_interceptor`).
   - It copies `base_app/` (swapping `gse_base_app` → your package / namespace) **and then runs
     `flutter pub get` followed by `dart fix --apply` automatically** — the latter re-sorts imports
     for your package name (uses FVM when `.fvmrc` is present; falls back to PATH, or prints the
     commands if the toolchain isn't found).
2. **Generate flavors** and run codegen (the generator prints these):
   ```bash
   cd <targetDir>
   dart run tools/setup_flavors.dart                       # dev / stg / prod  (see the flavors skill)
   dart run build_runner build --delete-conflicting-outputs
   ```
3. **Verify** with the `check-arch` skill — it reports any missing/incomplete files.

## Evolving the architecture
`base_app/` is a **real, editable Flutter project** and the single source of truth. To change
the base for all future projects, edit `base_app/` directly (open it, `flutter analyze`, etc.),
then commit. Never hand-edit generated projects and back-port — change the template.

`auth_variants/amplify/` is the **same-source-of-truth for the Amplify auth** (it is also what
the `auth-cognito` retrofit skill produces). If a base change touches a file the overlay also
ships (auth repos, `login` bloc/view, injectors, `pubspec`, ARBs, manifest, `setup_flavors`),
update the overlay copy too, or it will silently override the base change on `--auth amplify`.

## Definition of done
- Native shell created for the target Flutter version; generator ran without errors
  (`flutter pub get` + `dart fix` auto-ran), flavor setup and codegen succeeded.
- `flutter analyze` is clean and `check-arch` reports the architecture COMPLETE.
- **`--auth amplify` only:** Cognito placeholders filled in `.vscode/defines/*.json`, the native
  redirect scheme set (Android manifest + iOS `Info.plist`), and Sign in with Apple capability
  added in Xcode — see the `auth-cognito` skill's post-scaffold checklist.

## Anti-patterns
- Recreating the base file-by-file by hand instead of running the generator (slow, drifts).
- Editing a generated project to "improve the architecture" — edit `base_app/` instead.
- Editing the Amplify overlay AND the base auth to diverge — the overlay must stay a clean
  superset of the base's non-auth conventions.
