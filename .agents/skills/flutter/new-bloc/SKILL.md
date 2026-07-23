---
name: new-bloc
description: Generate a new BLoC or Cubit following Clean Architecture conventions for the GSE Base App
argument-hint: <BlocName> <domain> "<description>"
allowed-tools: [Read, Write, Glob, Grep, Bash]
---

# New BLoC

Generate a new BLoC or Cubit following the current architecture standards: Freezed for immutability, typed failure enums, and the `Result<S,E>` pattern.

## Arguments

The user invoked this skill with: `$ARGUMENTS`

- `<BlocName>`: class name in PascalCase (e.g. `SupplierOrders`)
- `<domain>`: subdirectory name in snake_case (e.g. `purchase_orders`)
- `"<description>"`: feature description used to infer events, state fields, and failure cases

Before generating any file, read `pubspec.yaml` to extract the `name:` field and use it as `<package_name>` in all import paths.

---

## Step 0: Decision — Bloc vs Cubit

State this at the top with one sentence justification:
- **Cubit** → simple state, no event transformers needed, no complex async flows
- **Bloc** → event traceability needed, pagination, concurrent event handling, stream subscriptions

---

## Step 1: Failure Enum

Create `lib/data/repositories/<domain>/<bloc_name_snake_case>_failures.dart`.

Infer the relevant failure cases from the feature description. Always include `serverError`, `networkError`, `unknownError`:

```dart
enum <BlocName>Failure {
  serverError,
  networkError,
  unknownError,
  // Add semantic cases based on the feature, e.g.:
  // notFound,
  // unauthorized,
}
```

**Rule:** Failure cases are semantic (what went wrong in the domain), NOT UI strings. The UI layer decides how to display them.

---

## Step 2: Files to generate

### Directory
`lib/presentation/blocs/<domain>/<bloc_name_snake_case>/`

### File list
- `<bloc_name_snake_case>_bloc.dart` — main class
- `<bloc_name_snake_case>_events.dart` — part file
- `<bloc_name_snake_case>_state.dart` — part file
- `<bloc_name_snake_case>_bloc.freezed.dart` — remind user to run `dart run build_runner build`

---

## File: `<bloc_name_snake_case>_bloc.dart`

```dart
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:<package_name>/core/services/logger/app_logger.dart';
import 'package:<package_name>/core/utils/result.dart';
// TODO: import the repository for this domain
// import 'package:<package_name>/data/repositories/<domain>/<repository>.dart';
import 'package:<package_name>/data/repositories/<domain>/<bloc_name_snake_case>_failures.dart';

part '<bloc_name_snake_case>_bloc.freezed.dart';
part '<bloc_name_snake_case>_events.dart';
part '<bloc_name_snake_case>_state.dart';

class <BlocName>Bloc extends Bloc<<BlocName>Event, <BlocName>State> {
  <BlocName>Bloc({
    required <RepositoryType> <repositoryName>,
  })  : _<repositoryName> = <repositoryName>,
        super(const <BlocName>State()) {
    // Choose transformer per event:
    // restartable() — cancels previous (searches, real-time filters)
    // droppable()   — ignores new while processing (form submits, mutations)
    // sequential()  — FIFO processing (ordered write operations)
    on<<BlocName>Fetched>(
      _on<BlocName>Fetched,
      transformer: restartable(),
    );
    on<<BlocName>StateReset>(_on<BlocName>StateReset);
  }

  final <RepositoryType> _<repositoryName>;

  Future<void> _on<BlocName>Fetched(
    <BlocName>Fetched event,
    Emitter<<BlocName>State> emit,
  ) async {
    // Guard: avoid duplicate in-flight requests
    if (state.status == <BlocName>Status.loading) return;

    emit(state.copyWith(status: <BlocName>Status.loading, failure: null));

    // TODO: call the repository
    // final result = await _<repositoryName>.get<BlocName>(...);

    // switch (result) {
    //   case Success(:final value):
    //     emit(state.copyWith(
    //       status: <BlocName>Status.success,
    //       // items: value,
    //     ));
    //   case Failure(:final exception):
    //     AppLogger.e('$runtimeType | _on<BlocName>Fetched()', error: exception, stackTrace: StackTrace.current);
    //     emit(state.copyWith(
    //       status: <BlocName>Status.failure,
    //       failure: exception, // typed enum — previous data is retained
    //     ));
    // }
  }

  void _on<BlocName>StateReset(
    <BlocName>StateReset event,
    Emitter<<BlocName>State> emit,
  ) {
    emit(const <BlocName>State());
  }
}
```

---

## File: `<bloc_name_snake_case>_events.dart`

Events use `@freezed` with factory constructors. Named in **past tense** (they already occurred from the BLoC's perspective):

```dart
part of '<bloc_name_snake_case>_bloc.dart';

@freezed
abstract class <BlocName>Event with _$<BlocName>Event {
  /// Triggered when data is requested (e.g., screen loads or user refreshes).
  /// Add required parameters inferred from the feature description.
  const factory <BlocName>Event.<blocNameCamelCase>Fetched({
    // required String exampleParam,
  }) = <BlocName>Fetched;

  /// Resets state to initial — call on screen dispose or re-entry.
  const factory <BlocName>Event.<blocNameCamelCase>StateReset() = <BlocName>StateReset;
}
```

---

## File: `<bloc_name_snake_case>_state.dart`

State uses `@freezed`. Status enum replaces boolean flags — prevents impossible states like `isLoading: true` + `isFailure: true` at the same time.

**Key rule:** On failure, previous data is **retained** — only `status` and `failure` are updated. The UI can show stale data alongside an error indicator.

```dart
part of '<bloc_name_snake_case>_bloc.dart';

enum <BlocName>Status { initial, loading, success, failure }

@freezed
abstract class <BlocName>State with _$<BlocName>State {
  const factory <BlocName>State({
    @Default(<BlocName>Status.initial) <BlocName>Status status,
    <BlocName>Failure? failure,
    // Add domain-specific fields with @Default() based on the feature description
    // @Default(<const []>) List<DomainModel> items,
  }) = _<BlocName>State;

  const <BlocName>State._(); // Required for custom getters with freezed

  // Convenience getters — keep UI code clean
  bool get isLoading => status == <BlocName>Status.loading;
  bool get isSuccess => status == <BlocName>Status.success;
  bool get isFailure => status == <BlocName>Status.failure;
}
```

---

## Preload + operation variant (forms with fetched initial data)

Use when the BLoC must **load existing data first** (e.g., edit form, detail screen with submit) AND perform mutations (save, delete, submit).

Two independent enums prevent conflating "data is loading" with "submit is in progress":

- `<BlocName>Status` — tracks the **preload** lifecycle. `loaded` means data is ready for the user to interact with.
- `<BlocName>OperationStatus` — tracks **mutation** lifecycle. `success` is intentionally transient — reset to `initial` after the UI reacts (e.g., on `cleanOperationStatus` event or screen pop).

```dart
part of '<bloc_name_snake_case>_bloc.dart';

enum <BlocName>Status { initial, loading, loaded, failure }
enum <BlocName>OperationStatus { initial, loading, success, failure }

@freezed
abstract class <BlocName>State with _$<BlocName>State {
  const factory <BlocName>State({
    @Default(<BlocName>Status.initial) <BlocName>Status status,
    @Default(<BlocName>OperationStatus.initial) <BlocName>OperationStatus operationStatus,
    <BlocName>Failure? failure,
    <BlocName>Failure? operationFailure,
    // Preloaded domain data:
    // SomeDomainModel? data,
  }) = _<BlocName>State;

  const <BlocName>State._();

  // Preload getters
  bool get isLoading => status == <BlocName>Status.loading;
  bool get isLoaded => status == <BlocName>Status.loaded;
  bool get isLoadFailure => status == <BlocName>Status.failure;

  // Operation getters
  bool get isOperating => operationStatus == <BlocName>OperationStatus.loading;
  bool get isOperationSuccess => operationStatus == <BlocName>OperationStatus.success;
  bool get isOperationFailure => operationStatus == <BlocName>OperationStatus.failure;
}
```

**Typical events for this variant:**
```dart
@freezed
abstract class <BlocName>Event with _$<BlocName>Event {
  /// Load initial data (e.g., screen opens with an existing record).
  const factory <BlocName>Event.<blocNameCamelCase>Loaded({
    required String id,
  }) = <BlocName>Loaded;

  /// Submit/save operation triggered by the user.
  const factory <BlocName>Event.<blocNameCamelCase>Submitted({
    // required fields from the form
  }) = <BlocName>Submitted;

  /// Reset operation status after UI has reacted (toast shown, dialog closed).
  const factory <BlocName>Event.<blocNameCamelCase>OperationStatusReset() = <BlocName>OperationStatusReset;

  /// Full state reset on screen dispose.
  const factory <BlocName>Event.<blocNameCamelCase>StateReset() = <BlocName>StateReset;
}
```

**Handler transformers:**
```dart
on<<BlocName>Loaded>(_on<BlocName>Loaded, transformer: restartable());
on<<BlocName>Submitted>(_on<BlocName>Submitted, transformer: droppable());
on<<BlocName>OperationStatusReset>(_on<BlocName>OperationStatusReset);
on<<BlocName>StateReset>(_on<BlocName>StateReset);
```

**Failure fields are independent:** `failure` belongs to the preload; `operationFailure` belongs to the mutation. On operation failure, preloaded data and `status` are untouched.

---

## Local state mutation after operation (list + mutation variant)

Use when a BLoC manages a **list of items** and also performs mutations (delete, update, create) on individual items.

**Rule:** After a successful mutation, update `state.items` directly — never re-fetch the entire list. This avoids an extra network request and gives instant feedback.

Only emit the local update inside `case Success` — if the API call fails, the original list is untouched and no rollback is needed.

### State requirements

The state must hold the list and independent operation status:

```dart
enum <BlocName>Status { initial, loading, success, failure }
enum <BlocName>OperationStatus { initial, loading, success, failure }

@freezed
abstract class <BlocName>State with _$<BlocName>State {
  const factory <BlocName>State({
    @Default(<BlocName>Status.initial) <BlocName>Status status,
    @Default(<BlocName>OperationStatus.initial) <BlocName>OperationStatus operationStatus,
    @Default([]) List<DomainModel> items,
    <BlocName>Failure? failure,
    <BlocName>Failure? operationFailure,
  }) = _<BlocName>State;

  const <BlocName>State._();

  bool get isLoading => status == <BlocName>Status.loading;
  bool get isSuccess => status == <BlocName>Status.success;
  bool get isFailure => status == <BlocName>Status.failure;
  bool get isOperating => operationStatus == <BlocName>OperationStatus.loading;
  bool get isOperationSuccess => operationStatus == <BlocName>OperationStatus.success;
  bool get isOperationFailure => operationStatus == <BlocName>OperationStatus.failure;
}
```

### Handler patterns per operation type

**DELETE — remove item from local list:**
```dart
Future<void> _on<BlocName>Deleted(
  <BlocName>Deleted event,
  Emitter<<BlocName>State> emit,
) async {
  emit(state.copyWith(operationStatus: <BlocName>OperationStatus.loading, operationFailure: null));

  final result = await _repository.delete(event.id);

  switch (result) {
    case Success():
      emit(state.copyWith(
        operationStatus: <BlocName>OperationStatus.success,
        items: state.items.where((i) => i.id != event.id).toList(),
      ));
    case Failure(:final exception):
      AppLogger.e('$runtimeType | _on<BlocName>Deleted()', error: exception, stackTrace: StackTrace.current);
      emit(state.copyWith(
        operationStatus: <BlocName>OperationStatus.failure,
        operationFailure: exception,
      ));
  }
}
```

**UPDATE — replace item in local list:**
```dart
Future<void> _on<BlocName>Updated(
  <BlocName>Updated event,
  Emitter<<BlocName>State> emit,
) async {
  emit(state.copyWith(operationStatus: <BlocName>OperationStatus.loading, operationFailure: null));

  final result = await _repository.update(event.id, event.data);

  switch (result) {
    case Success(:final value):
      emit(state.copyWith(
        operationStatus: <BlocName>OperationStatus.success,
        items: state.items.map((i) => i.id == value.id ? value : i).toList(),
      ));
    case Failure(:final exception):
      AppLogger.e('$runtimeType | _on<BlocName>Updated()', error: exception, stackTrace: StackTrace.current);
      emit(state.copyWith(
        operationStatus: <BlocName>OperationStatus.failure,
        operationFailure: exception,
      ));
  }
}
```

**CREATE — prepend new item to local list:**
```dart
Future<void> _on<BlocName>Created(
  <BlocName>Created event,
  Emitter<<BlocName>State> emit,
) async {
  emit(state.copyWith(operationStatus: <BlocName>OperationStatus.loading, operationFailure: null));

  final result = await _repository.create(event.data);

  switch (result) {
    case Success(:final value):
      emit(state.copyWith(
        operationStatus: <BlocName>OperationStatus.success,
        items: [value, ...state.items],
      ));
    case Failure(:final exception):
      AppLogger.e('$runtimeType | _on<BlocName>Created()', error: exception, stackTrace: StackTrace.current);
      emit(state.copyWith(
        operationStatus: <BlocName>OperationStatus.failure,
        operationFailure: exception,
      ));
  }
}
```

### Typical events for this variant

```dart
@freezed
abstract class <BlocName>Event with _$<BlocName>Event {
  /// Initial list fetch.
  const factory <BlocName>Event.<blocNameCamelCase>Fetched() = <BlocName>Fetched;

  /// Delete a single item by id.
  const factory <BlocName>Event.<blocNameCamelCase>Deleted({
    required String id,
  }) = <BlocName>Deleted;

  /// Update a single item.
  const factory <BlocName>Event.<blocNameCamelCase>Updated({
    required String id,
    // required fields from the form / payload
  }) = <BlocName>Updated;

  /// Create a new item.
  const factory <BlocName>Event.<blocNameCamelCase>Created({
    // required fields from the form / payload
  }) = <BlocName>Created;

  /// Reset operationStatus after UI has reacted (snackbar shown, dialog closed).
  const factory <BlocName>Event.<blocNameCamelCase>OperationStatusReset() = <BlocName>OperationStatusReset;

  /// Full state reset on screen dispose.
  const factory <BlocName>Event.<blocNameCamelCase>StateReset() = <BlocName>StateReset;
}
```

### Handler transformers

```dart
on<<BlocName>Fetched>(_on<BlocName>Fetched, transformer: restartable());
on<<BlocName>Deleted>(_on<BlocName>Deleted, transformer: droppable());
on<<BlocName>Updated>(_on<BlocName>Updated, transformer: droppable());
on<<BlocName>Created>(_on<BlocName>Created, transformer: droppable());
on<<BlocName>OperationStatusReset>(_on<BlocName>OperationStatusReset);
on<<BlocName>StateReset>(_on<BlocName>StateReset);
```

### BlocListener pattern for this variant

In `_bloc_listener.dart`, react to `operationStatus` for loading overlay and to `operationFailure` for snackbars — separate from the fetch `status` and `failure`:

```dart
// Operation loading overlay
BlocListener<<BlocName>Bloc, <BlocName>State>(
  listenWhen: (previous, current) => previous.operationStatus != current.operationStatus,
  listener: (context, state) {
    if (state.isOperating) {
      LoadingOverlay.show(context);
    } else {
      LoadingOverlay.remove();
    }
    if (state.isOperationSuccess) {
      context.read<<BlocName>Bloc>().add(const <BlocName>Event.<blocNameCamelCase>OperationStatusReset());
    }
  },
),
// Operation failure snackbar
BlocListener<<BlocName>Bloc, <BlocName>State>(
  listenWhen: (previous, current) =>
      previous.operationFailure != current.operationFailure && current.operationFailure != null,
  listener: (context, state) {
    final l10n = AppLocalizations.of(context)!;
    final message = switch (state.operationFailure) {
      <BlocName>Failure.networkError => l10n.genericNetworkFailureError,
      <BlocName>Failure.serverError  => l10n.genericServerFailureError,
      _                              => l10n.genericUnknownFailureError,
    };
    AppSnackbar.show(context, message);
  },
),
```

---

## Pagination variant

Add when the description mentions pagination or infinite scroll:

**Additional state fields:**
```dart
@Default(const []) List<DomainModel> items,
@Default(1) int currentPage,
@Default(1) int totalPages,
@Default(false) bool isLoadingMore,
```

**Additional getter:**
```dart
bool get hasReachedMax => currentPage >= totalPages;
```

**Additional event:**
```dart
const factory <BlocName>Event.moreFetched({
  required int page,
}) = <BlocName>MoreFetched;
```

**Handler registration:**
```dart
on<<BlocName>MoreFetched>(_on<BlocName>MoreFetched, transformer: droppable());
```

**Handler guard:**
```dart
Future<void> _on<BlocName>MoreFetched(...) async {
  if (state.hasReachedMax || state.isLoadingMore) return;
  // ...
}
```

---

## Stream subscription variant

Add when the BLoC must react to a repository stream (real-time updates):

```dart
import 'dart:async' show StreamSubscription;

// In constructor:
_<streamName>Subscription = _<repositoryName>.<streamGetter>.listen(
  (data) => add(<BlocName>Event.<internalEventName>(data)),
);

// Field:
late StreamSubscription<Type> _<streamName>Subscription;

// Override close():
@override
Future<void> close() {
  _<streamName>Subscription.cancel();
  return super.close();
}
```

---

## Result pattern reference

The `Result<S, E>` sealed class used in repositories:

```dart
// Usage in event handler — exhaustive switch, no try/catch needed at bloc level:
final result = await _repository.someMethod(...);

switch (result) {
  case Success(:final value):
    emit(state.copyWith(status: <BlocName>Status.success, items: value));
  case Failure(:final exception):
    AppLogger.e('$runtimeType | _onEventName()', error: exception, stackTrace: StackTrace.current);
    emit(state.copyWith(status: <BlocName>Status.failure, failure: exception));
}
```

---

## Testing scaffold

```dart
// test/presentation/blocs/<domain>/<bloc_name_snake_case>_bloc_test.dart

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class Mock<RepositoryType> extends Mock implements <RepositoryType> {}

void main() {
  late Mock<RepositoryType> mock<RepositoryType>;
  late <BlocName>Bloc bloc;

  setUp(() {
    mock<RepositoryType> = Mock<RepositoryType>();
    bloc = <BlocName>Bloc(<repositoryName>: mock<RepositoryType>);
  });

  tearDown(() => bloc.close());

  group('<BlocName>Bloc', () {
    test('initial state is correct', () {
      expect(bloc.state, const <BlocName>State());
    });

    blocTest<<BlocName>Bloc, <BlocName>State>(
      'emits [loading, success] when fetch succeeds',
      build: () {
        when(() => mock<RepositoryType>.get<BlocName>())
            .thenAnswer((_) async => const Success([]));
        return bloc;
      },
      act: (b) => b.add(const <BlocName>Event.<blocNameCamelCase>Fetched()),
      expect: () => [
        const <BlocName>State(status: <BlocName>Status.loading),
        const <BlocName>State(status: <BlocName>Status.success, items: []),
      ],
    );

    blocTest<<BlocName>Bloc, <BlocName>State>(
      'emits [loading, failure] and retains previous data when fetch fails',
      build: () {
        when(() => mock<RepositoryType>.get<BlocName>())
            .thenAnswer((_) async => const Failure(<BlocName>Failure.serverError));
        return bloc;
      },
      act: (b) => b.add(const <BlocName>Event.<blocNameCamelCase>Fetched()),
      expect: () => [
        const <BlocName>State(status: <BlocName>Status.loading),
        isA<<BlocName>State>()
            .having((s) => s.status, 'status', <BlocName>Status.failure)
            .having((s) => s.failure, 'failure', <BlocName>Failure.serverError),
      ],
    );
  });
}
```

---

## Registration checklist

Show this at the end:

- [ ] Run codegen: `dart run build_runner build --delete-conflicting-outputs`
- [ ] `lib/presentation/blocs/blocs_injector.dart`:
  ```dart
  sl..registerFactory(() => <BlocName>Bloc(<repositoryName>: sl()));
  ```
- [ ] `lib/presentation/blocs/app_blocs_provider.dart` (if global BLoC):
  ```dart
  BlocProvider(create: (_) => sl<<BlocName>Bloc>()),
  ```
- [ ] Create failure enum at `lib/data/repositories/<domain>/<bloc_name_snake_case>_failures.dart`
- [ ] Create test file at `test/presentation/blocs/<domain>/<bloc_name_snake_case>_bloc_test.dart`

---

## Form BLoC variant (formz)

Use when the BLoC handles user input fields (login, register, forgot password, etc.) with real-time field validation.

Instead of a custom status enum, use `FormzSubmissionStatus` from the `formz` package. Field inputs are `FormzInput` subclasses defined in `lib/data/inputs/`.

**Additional imports:**
```dart
import 'package:formz/formz.dart';
import 'package:<package_name>/data/inputs/field_email.dart';
import 'package:<package_name>/data/inputs/field_password.dart';
// import other inputs as needed
```

**State template:**
```dart
part of '<bloc_name_snake_case>_bloc.dart';

@freezed
abstract class <BlocName>State with _$<BlocName>State {
  const factory <BlocName>State({
    @Default(FormzSubmissionStatus.initial) FormzSubmissionStatus status,
    @Default(EmailInput.pure()) EmailInput email,
    @Default(PasswordInput.pure()) PasswordInput password,
    <BlocName>Failure? failure,
  }) = _<BlocName>State;
}
```

**Events template:**
```dart
part of '<bloc_name_snake_case>_bloc.dart';

@freezed
abstract class <BlocName>Event with _$<BlocName>Event {
  const factory <BlocName>Event.emailChanged(String email) = EmailChanged;
  const factory <BlocName>Event.passwordChanged(String password) = PasswordChanged;
  const factory <BlocName>Event.formSubmitted() = FormSubmitted;
  const factory <BlocName>Event.cleanState() = CleanState;
}
```

**Submit handler pattern:**
```dart
Future<void> _onFormSubmitted(
  FormSubmitted event,
  Emitter<<BlocName>State> emit,
) async {
  emit(state.copyWith(status: FormzSubmissionStatus.inProgress, failure: null));

  final isValid = Formz.validate([state.email, state.password]);
  if (!isValid) {
    emit(state.copyWith(
      status: FormzSubmissionStatus.failure,
      failure: <BlocName>Failure.invalidForm,
    ));
    return;
  }

  final result = await _repository.someMethod(
    email: state.email.value,
    password: state.password.value,
  );

  switch (result) {
    case Success():
      emit(state.copyWith(status: FormzSubmissionStatus.success));
    case Failure(:final exception):
      emit(state.copyWith(
        status: FormzSubmissionStatus.failure,
        failure: exception,
      ));
  }
}
```

**Field change handlers** do NOT use `FormzSubmissionStatus` — they just emit a new input value:
```dart
void _onEmailChanged(EmailChanged event, Emitter<<BlocName>State> emit) {
  emit(state.copyWith(email: EmailInput.dirty(event.email.trim())));
}
```

**When to use formz variant vs custom status:**
- `formz` → user input forms (login, register, forgot password, verify email)
- Custom status enum → data fetch BLoCs, non-form flows

---

## Rules summary

| Rule | Detail |
|---|---|
| Immutability | `@freezed` on all events and states |
| Error type | Typed `enum <BlocName>Failure?` — never `String errorMessage` |
| Status (simple) | `enum *Status { initial, loading, loaded, failure }` — fetch/read-only BLoCs |
| Status (preload+op) | `enum *Status { initial, loading, loaded, failure }` + `enum *OperationStatus { initial, loading, success, failure }` — forms with fetched data |
| Data on error | Retain previous data; only update `status` + `failure` |
| Import | `package:flutter_bloc/flutter_bloc.dart` — never `package:bloc/bloc.dart` |
| Result pattern | `switch (result) { case Success(:final value) / case Failure(:final exception) }` — exhaustive |
| Event naming | Past tense for data events: `*Fetched`, `*Deleted`; camelCase for form events: `emailChanged`, `formSubmitted` |
| Event style | `@freezed` factory constructors in part file |
| Transformer default | `restartable()` for fetches; `droppable()` for submits/mutations |
| Logging | `AppLogger.e('$runtimeType \| _onMethod()', error: exception, stackTrace: StackTrace.current)` |
| Stream subscriptions | Cancel in `close()` override |
| Codegen | Always remind to run `build_runner` after generation |

Now generate all files based on `$ARGUMENTS`. Label each with its full relative path. Show the registration checklist at the end.
