---
name: flavors
description: Generate or regenerate the dev/stg/prod Flutter flavors for a GSE project (Android, iOS, VSCode launch configs, and env_config.dart). Use when setting up flavors or changing environment config.
---

# Skill: Generate Flutter flavors (dev / stg / prod)

Follow the Flutter `AGENTS.md` conventions. Flavors are driven by a Dart script that ships
in the base architecture — no VSCode extension required.

## When to use
Setting up flavors on a freshly generated project, or regenerating them after editing the
flavor definitions.

## Prerequisite
The project must contain `tools/setup_flavors.dart` (present in any project scaffolded by the
`architecture` skill). If missing, the project wasn't generated from the GSE base.

## Steps
1. From the project root, run:
   ```bash
   dart run tools/setup_flavors.dart
   ```
2. This generates/overwrites (confirm with `git diff`):
   - `lib/core/environments/env_config.dart` — `EnvConfig`, `Environment` enum, `API_URL`, `ENVIRONMENT`.
   - `.vscode/defines/{dev,stg,prod}.json` and `.vscode/launch.json` — per-flavor run configs.
   - `android/app/flavor_config.gradle.kts` — Android product flavors.
3. Run each flavor via its VSCode launch config, or:
   ```bash
   flutter run --flavor dev   # (stg / prod)
   ```

## Config values & secrets
- Per-environment values live in the generated define JSONs and are injected at build time.
- **Never read `.env`, `--dart-define`, or `String.fromEnvironment` values** (root prohibition).
  Treat config keys as opaque names — flag code that exposes them, don't read the values.

## Definition of done
- `dart run tools/setup_flavors.dart` completed without errors.
- `env_config.dart` and the three flavors exist; `flutter run --flavor dev` starts the app.

## Anti-patterns
- Hand-editing `env_config.dart` (it's generated — change the script/flavor definitions instead).
- Hardcoding environment URLs or secrets in Dart source instead of the flavor config.
