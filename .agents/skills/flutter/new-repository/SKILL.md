---
name: new-repository
description: Generate a new API-only data repository following Clean Architecture conventions for the GSE Base App
argument-hint: <ResourceName> <api_path> "<operations>" | <ResourceName> --docs <url>
allowed-tools: [Read, Write, Glob, Grep, Bash, WebFetch]
---

# New Repository

Generate a new API-only data repository following the established conventions. Repositories never use local cache — all operations call the API directly.

## Arguments

The user invoked this skill with: `$ARGUMENTS`

- `<ResourceName>`: resource name in PascalCase (e.g. `Extension`, `CallGroup`)
- `<api_path>`: base API path (e.g. `/extensions`, `/call-groups`) — omit when using `--docs`
- `"<operations>"`: comma-separated list of operations to generate (e.g. `"getAll, getById, create, update, delete"`) — omit when using `--docs`
- `--docs <url>`: fetch API documentation from a URL and infer the base path, operations, and failure cases automatically

### --docs mode

When `--docs <url>` is present:

1. Use `WebFetch` to fetch the URL
2. Extract the **base API path** from the documented endpoints (e.g. `/v1/invoices`)
3. Extract each **HTTP operation** described and map it to a repository method:
   | HTTP | Method name |
   |---|---|
   | GET (list / collection) | `getAll` |
   | GET (single / `:id`) | `getById` |
   | POST | `create` |
   | PUT / PATCH | `update` |
   | DELETE | `delete` |
   | Any other named action | use the action name (e.g. `approve`, `cancel`, `send`) |
4. Extract documented **error codes** and map them to domain failure cases:
   | HTTP code | Failure case |
   |---|---|
   | 401 / 403 | `unauthorized` / `forbidden` |
   | 404 | `notFound` |
   | 409 | `conflict` or resource-specific name |
   | 422 | `invalidData` |
   | 400 | `badRequest` |
5. Use these inferred values as if the user had passed `<api_path>` and `"<operations>"` explicitly — continue with the standard generation steps below.

---

## File Locations to Generate

Always generate exactly these files:

1. `lib/data/repositories/<snake_name>/<snake_name>_failures.dart`
2. `lib/data/repositories/<snake_name>/<snake_name>_repository.dart`

And always update:

3. `lib/data/repositories/repositories_injector.dart` — add the new singleton registration

Where `<snake_name>` = resource name converted to snake_case (e.g. `CallGroup` → `call_group`).

---

## Step 1 — Read Current State First

Before generating any code:
1. Read `lib/data/repositories/repositories_injector.dart` to see current registrations
2. Read `lib/core/utils/result.dart` to confirm the Result type
3. Read `lib/core/utils/dio_exception_mapper.dart` to confirm mapper signature
4. Read `lib/core/environments/env_config.dart` to confirm apiUrl usage

Never guess — read the actual files.

---

## Step 2 — Failure Enum

**File:** `lib/data/repositories/<snake_name>/<snake_name>_failures.dart`

Always include these base failures:
- `serverError`
- `networkError`
- `unknownError`

Then infer additional failures from the operations and resource type. Common patterns:
- `notFound` — when a GET by ID or DELETE might return 404
- `conflict` / `emailAlreadyExists` — when creation might return 409 (duplicate)
- `forbidden` — when an operation might return 403
- `invalidData` — when the server returns 400 for bad input

**Template:**
```dart
enum <ResourceName>Failure implements Exception {
  serverError,
  networkError,
  unknownError,
  // resource-specific failures...
}
```

> The enum **must** `implements Exception` because `Result<S, E extends Exception>` requires it.

---

## Step 3 — Repository Class

**File:** `lib/data/repositories/<snake_name>/<snake_name>_repository.dart`

**Rules (CRITICAL):**
- `final ApiClient _apiClient;` — only dependency (no local datasource, no database)
- All methods return `Future<Result<ReturnType, <ResourceName>Failure>>`
- Use `${EnvConfig.apiUrl}<api_path>` for base URL
- Use a general `catch (e, stack)` — never `on DioException catch`
- Inside catch: always call `AppLogger.e(...)`, then check `if (e is DioException)` to call `mapDioToFailure`
- Use `statusOverrides` in `mapDioToFailure` for specific HTTP codes (e.g. `409`, `404`)
- Always fall through to `return const Failure(<ResourceName>Failure.unknownError)` at the end of catch
- No cache, no local reads, no Drift, no SharedPreferences

**Standard operation signatures:**

| Operation | Method | Path | Return |
|-----------|--------|------|--------|
| getAll | GET | `<api_path>` | `Result<List<ResourceModel>, Failure>` |
| getById | GET | `<api_path>/<id>` | `Result<ResourceModel, Failure>` |
| create | POST | `<api_path>` | `Result<ResourceModel, Failure>` |
| update | PUT/PATCH | `<api_path>/<id>` | `Result<ResourceModel, Failure>` |
| delete | DELETE | `<api_path>/<id>` | `Result<void, Failure>` |

**Template:**
```dart
import 'package:dio/dio.dart';
import 'package:gse_base_app/core/environments/env_config.dart';
import 'package:gse_base_app/core/services/api/dio_client.dart';
import 'package:gse_base_app/core/services/logger/app_logger.dart';
import 'package:gse_base_app/core/utils/dio_exception_mapper.dart';
import 'package:gse_base_app/core/utils/result.dart';
import '<snake_name>_failures.dart';

const String _repositoryName = '<ResourceName>Repository';

class <ResourceName>Repository {
  <ResourceName>Repository({required ApiClient apiClient})
      : _apiClient = apiClient;

  final ApiClient _apiClient;

  static const _basePath = '<api_path>';

  // Methods follow below...
}
```

> Replace `gse_base_app` with the actual package name read from `pubspec.yaml`.

**Method template for a GET list:**
```dart
Future<Result<List<ResourceModel>, <ResourceName>Failure>> getAll() async {
  try {
    final data = await _apiClient.get<List<dynamic>>(
      '${EnvConfig.apiUrl}$_basePath',
    );
    final items = (data as List)
        .cast<Map<String, dynamic>>()
        .map(ResourceModel.fromJson)
        .toList();
    return Success(items);
  } catch (e, stack) {
    AppLogger.e('$_repositoryName.getAll', error: e, stackTrace: stack);
    if (e is DioException) {
      return mapDioToFailure(
        e,
        networkError: <ResourceName>Failure.networkError,
        serverError: <ResourceName>Failure.serverError,
        unknownError: <ResourceName>Failure.unknownError,
        // statusOverrides: {404: <ResourceName>Failure.notFound},
      );
    }
    return const Failure(<ResourceName>Failure.unknownError);
  }
}
```

**Important:** If the project already has a domain model class for the resource (check `lib/domain/`), use it as the return type. Read the model file to confirm its `fromJson` constructor before using it.

If the model does NOT exist yet, use `Map<String, dynamic>` and add a comment: `// TODO: replace with domain model once <ResourceName> is defined`.

---

## Step 4 — Update repositories_injector.dart

Add the new repository as a lazy singleton. Follow the existing registration style exactly (read the file first):

```dart
..registerLazySingleton(
  () => <ResourceName>Repository(
    apiClient: sl(),
  ),
)
```

Add it in alphabetical order relative to existing registrations.

---

## Step 5 — Output Summary

After generating all files, output:

```
Generated:
  lib/data/repositories/<snake_name>/<snake_name>_failures.dart
  lib/data/repositories/<snake_name>/<snake_name>_repository.dart

Updated:
  lib/data/repositories/repositories_injector.dart

Operations implemented: <list>
Failures defined: <list>
```

If a domain model was not found, call it out explicitly so the user knows to create it.
