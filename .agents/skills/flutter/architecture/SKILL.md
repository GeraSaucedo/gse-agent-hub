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
`gse_localization` local packages, `tools/setup_flavors.dart`, Android flavor config, assets,
and the project's `.claude/skills/` (the feature-generation commands). Native scaffolding
(Gradle wrappers, `ios/`) comes from `flutter create .`, which keeps the files the generator wrote. See `base_app/` for
the exact contents and `check-arch` for the full inventory.

## Steps
1. **Run the generator** (headless, no VSCode needed):
   ```bash
   node .agents/skills/flutter/architecture/generate.mjs <targetDir> [packageName] [androidNamespace]
   ```
   - `packageName` defaults to a sanitized `<targetDir>` basename; `androidNamespace` to `com.example.<packageName>`.
   - It copies `base_app/` and swaps `gse_base_app` → your package and `com.example.gse_base_app` → your namespace.
2. **Add native scaffolding, install deps & generate flavors** (the generator prints these):
   ```bash
   cd <targetDir>
   flutter create . --project-name <packageName> --org <org> --platforms=android,ios
   rm test/widget_test.dart               # default test references MyApp
   flutter pub get
   dart run tools/setup_flavors.dart      # dev / stg / prod  (see the flavors skill)
   ```
3. **Run codegen** for freezed models:
   ```bash
   dart run build_runner build --delete-conflicting-outputs
   ```
4. **Verify** with the `check-arch` skill — it reports any missing/incomplete files.

## Evolving the architecture
`base_app/` is a **real, editable Flutter project** and the single source of truth. To change
the base for all future projects, edit `base_app/` directly (open it, `flutter analyze`, etc.),
then commit. Never hand-edit generated projects and back-port — change the template.

## Definition of done
- Generator ran without errors; `flutter pub get`, flavor setup, and codegen succeeded.
- `check-arch` reports the architecture COMPLETE.

## Anti-patterns
- Recreating the base file-by-file by hand instead of running the generator (slow, drifts).
- Editing a generated project to "improve the architecture" — edit `base_app/` instead.
