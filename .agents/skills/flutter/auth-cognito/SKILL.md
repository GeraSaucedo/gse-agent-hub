---
name: auth-cognito
description: Migrate the GSE base auth (custom JWT over dio) to AWS Amplify + Amazon Cognito, supporting email/password, Google, and Apple sign-in. Retrofit skill for an already-scaffolded GSE project against an existing Cognito User Pool.
argument-hint: [--providers email,google,apple] [--token id|access]
allowed-tools: [Read, Write, Edit, Glob, Grep, Bash, WebFetch]
---

# Auth → Cognito (Amplify)

Replace the GSE base's custom JWT auth (dio → REST: `/auth/login`, `/auth/refresh-token`,
`/auth/logout`, `/auth/register`, verify-email, recovery) with **AWS Amplify + Amazon Cognito**.
Auth becomes 100% Amplify; `dio` stays only for business APIs, carrying the Cognito token.

Follow the Flutter `AGENTS.md` conventions. This is a **retrofit** of one scaffolded project —
it does **not** touch the `base_app/` template and does **not** create AWS infrastructure.

**New projects don't need this skill.** Scaffold with the `architecture` skill and
`--auth amplify` — that overlays the same files deterministically. Use this skill only to
convert an **existing** JWT project. The canonical files live in
`architecture/auth_variants/amplify/`; prefer copying/adapting them over re-deriving by hand,
and keep the two in sync (that overlay is the single source of truth for the Amplify auth).

## Arguments
`--providers` selects social buttons to wire (default `email,google,apple`). `--token` picks
which Cognito JWT the dio Bearer interceptor sends: `id` (default, carries claims) or `access`.

## When to use
Converting an existing GSE app to Cognito. Skip if the project has no `data/repositories/auth/`
(scaffold the base first with the `architecture` skill).

## Prerequisites (verify with the human — do NOT provision)
- A **Cognito User Pool already exists**, with Google and Apple enabled as identity providers,
  a Hosted UI domain, and callback/sign-out URLs registered per platform.
- `amplifyconfiguration.dart` (or `.json`) is supplied by config/flavors at build time. Treat
  pool/app-client IDs as **opaque** — never read `.env`, env vars, or `--dart-define` values
  (root prohibitions). If the config is absent, stop and ask the human for it.
- Native deep-link wiring for the Hosted UI return (checklist — guide, don't guess IDs):
  - **iOS** `Info.plist`: URL scheme for the redirect; **Sign in with Apple** capability.
  - **Android** `AndroidManifest.xml`: `intent-filter` for the redirect scheme.

## Steps
1. **Dependencies** — in `pubspec.yaml` add `amplify_flutter` and `amplify_auth_cognito`.
   Remove `dart_jsonwebtoken` (no more manual JWT validation). Run `flutter pub get`.
2. **Configure Amplify once at startup** — add `_configureAmplify()` before `init()`/`runApp`
   (in `main.dart`/`main_app.dart`): `Amplify.addPlugin(AmplifyAuthCognito())` then
   `await Amplify.configure(amplifyconfig)`. Guard against double-configure on hot restart.
3. **AuthRepository** (`data/repositories/auth/auth_repository.dart`) — keep the **public shape**
   (`Result`/`AuthFailure`, `AuthStatus` + `authStatusStream`, `currentStatus`, `forceLogout`,
   `dispose`). Swap internals:
   - `loginWithEmailAndPassword` → `Amplify.Auth.signIn(username: email, password: ...)`.
   - New `loginWithGoogle` / `loginWithApple` → `Amplify.Auth.signInWithWebUI(provider:
     AuthProvider.google | AuthProvider.apple)`.
   - `isUserLogged` → `Amplify.Auth.fetchAuthSession()` → emit from `session.isSignedIn`.
   - `logout` → `Amplify.Auth.signOut()`.
   - **Delete** `_saveTokens`, `_verifyTokenValidation`, the manual refresh, and the local-token
     `useMockAuth` branch — Amplify owns session persistence and refresh.
   - Drive `AuthStatus` from the **Amplify Hub**: `Amplify.Hub.listen(HubChannel.Auth, ...)`
     mapping `signedIn` → authenticated, `signedOut`/`sessionExpired` → unauthenticated.
4. **AuthFailure** (`auth_failures.dart`) — map Amplify exceptions to cases (add the missing
   ones, e.g. `userNotConfirmed`, `cancelled`): `UserNotConfirmedException`,
   `NotAuthorizedException`, `UserNotFoundException`, `LimitExceededException`,
   `UserCancelledException`, `AuthException` (fallback → `unknown`).
5. **Adjacent auth repos** — replace their dio calls with Amplify, keeping `Result`/failure enums:
   - `register/register_repository.dart` → `Amplify.Auth.signUp(...)` with `userAttributes`
     (`email`, `name`).
   - `verify_email/verify_email_repository.dart` → `confirmSignUp(...)` + `resendSignUpCode(...)`.
   - `recovery_code/recovery_code_repository.dart` → `resetPassword(...)` + `confirmResetPassword(...)`.
   - **Delete** `data/repositories/auth/jwt_utils.dart`.
6. **dio / tokens**:
   - `interceptors/bearer_token_interceptor.dart` → read the token from Amplify:
     `fetchAuthSession()` → `CognitoAuthSession` → `userPoolTokensResult.value.idToken` (or
     `accessToken` per `--token`). No `TokenManager` dependency.
   - **Delete** `interceptors/refresh_token_interceptor.dart` — Amplify auto-refreshes; force
     logout is the Hub `sessionExpired` event.
   - `api/dio_client.dart` → drop `RefreshTokenInterceptor`, `TokenManager`, and `onRefreshFailed`
     from `ApiClient`; keep Bearer (+ logger in debug).
   - `storage/utils/token_manager.dart` → grep for other consumers; remove from the auth path,
     delete only if unused elsewhere.
7. **Injectors**:
   - `services/services_injector.dart` → remove `TokenManager` and `onRefreshFailed` from the
     `ApiClient` wiring.
   - `repositories/repositories_injector.dart` → `AuthRepository` no longer takes `tokenManager`;
     register/verify/recovery repos no longer take `apiClient` (they use Amplify).
8. **Routing (keep as-is)** — `routes/app_auth_redirect.dart`, `routes/auth_stream.dart`, and the
   `AuthStatus` stream are unchanged; only the *source* emitting states moves to the Hub. Confirm
   `GoRouterRefreshStream` still listens to `authStatusStream`.
9. **Presentation** — `login_bloc`, `register_bloc`, `verify_email_bloc`, `forgot_password_bloc`
   keep their shape. Add Google/Apple events + actions to login; render social buttons in
   `login_view` using `gse_design_system` styles and `gse_localization` strings (never hardcode).
10. **Codegen & verify** — `dart run build_runner build --delete-conflicting-outputs`;
    `flutter analyze` must be clean.

## Definition of done
- `flutter analyze` clean; codegen succeeded.
- Email/password, Google, and Apple sign-in work against the existing pool; register, verify,
  and password reset go through Cognito; logout clears the Amplify session.
- `go_router` redirects correctly on sign-in / sign-out / session-expired.
- No manual JWT, refresh interceptor, or `TokenManager` remain in the auth path.

## Anti-patterns
- Persisting Cognito tokens by hand or keeping the `RefreshTokenInterceptor` (Amplify owns both).
- Reading pool/client IDs from `.env` / `--dart-define`.
- Leaving the old REST auth wired alongside Cognito (two live auth systems).
- Editing `base_app/` here, or provisioning AWS infra — both are out of scope.
- Hardcoding social-button strings, colors, or sizes instead of using the design system / l10n.
