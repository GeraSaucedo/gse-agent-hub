---
name: testing
description: How to write and run tests in a GSE Flutter project — bloc_test for BLoCs/Cubits, mocked dio for repositories, widget tests for screens. Use when adding tests or verifying a change.
---

# Skill: Testing in Flutter (GSE / BLoC)

Follow the Flutter `AGENTS.md` conventions. This skill covers the *how*.

## When to use
Writing tests for a change, or verifying a change works before review.

## Setup
- `flutter_test` (in the base) covers unit + widget tests.
- BLoCs/Cubits are tested with **`bloc_test`**, and collaborators are faked with **`mocktail`**.
  If they're not yet in `dev_dependencies`, adding them is a dependency change — **flag it for
  the human to approve**, don't add silently.

## Layout
- Mirror `lib/` under `test/`: `lib/presentation/blocs/login/...` → `test/presentation/blocs/login/...`.
- Name files `<thing>_test.dart`.

## Steps
1. **Test BLoCs/Cubits with `bloc_test`.** Inject mocked repositories. For each event, assert the
   emitted state sequence (e.g. loading → success/failure) and the resulting state fields. Cover the
   happy path and every failure case in the repository's `<Domain>Failure` enum.
2. **Test repositories through a real `ApiClient` over a fake `HttpClientAdapter`.** Stub status
   codes and connection errors; assert the repository returns the correct `Result` / `<Domain>Failure`
   (via `api_failure_mapper.dart`). Don't hit the network. Copy the pattern from
   `test/data/repositories/register/register_repository_test.dart` (it needs no extra dependency).
3. **Widget-test screens.** Use `testWidgets` + `WidgetTester`; provide the BLoC via a mocked instance
   (or `BlocProvider` with a fake) and drive states. Find by keys/semantics over raw text.
4. **Test behavior, not internals.** Assert emitted states / what the user sees — never private calls.
   Verify the local-mutation pattern (list updates without a re-fetch) where it applies.
5. **Run the suite.** `flutter test` (add `--coverage` when checking gaps). Capture real output.
6. **Report.** State the command, pass/fail counts, and paste any failure output verbatim. Never
   claim success without a green run.

## Definition of done
- New behavior has a failing-then-passing test; `flutter test` is green with no weakened assertions.
- Every new/changed BLoC handler and repository failure branch is covered.

## Anti-patterns
- Reporting "tests pass" without running them.
- Over-mocking so the test no longer exercises real behavior; asserting on internal calls.
- Hitting the real API/network instead of mocking `dio`.
