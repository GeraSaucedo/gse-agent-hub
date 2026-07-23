---
name: new-model
description: Generate a Flutter domain model using freezed + json_serializable following Clean Architecture conventions
argument-hint: <ModelName> [field:type ...] | <ModelName> --json '<json>' | <ModelName> --json-file <path> | <ModelName> --docs <url> [--path lib/domain/models/subfolder]
allowed-tools: [Read, Write, Glob, Grep, Bash, WebFetch]
---

# New Model

Generate a domain model using Freezed + json_serializable following the project's Clean Architecture conventions.

## Arguments

The user invoked this skill with: `$ARGUMENTS`

- `<ModelName>`: model name in PascalCase (e.g. `Invoice`)
- `[field:type ...]`: explicit fields (e.g. `id:String amount:double`)
- `[--json '<json>']`: infer fields from an inline JSON string
- `[--json-file <path>]`: infer fields from a JSON file
- `[--docs <url>]`: fetch API/object documentation from a URL and infer fields and nested types
- `[--path <dir>]`: output directory override (default: `lib/domain/models/<snake_name>/`)

If only `<ModelName>` is passed with no fields or JSON, a placeholder model with `required String id` is generated.

## Input Modes

The skill supports five input modes — detect which one the user is using:

### Mode A — Explicit fields
```
/new-model Invoice id:String clientName:String amount:double paid:bool
```

### Mode B — Inline JSON
```
/new-model Invoice --json '{"id": 1, "client_name": "Acme", "amount": 99.9, "paid": false}'
```

### Mode C — JSON file path
```
/new-model Invoice --json-file path/to/response.json
```

### Mode D — Name only (placeholder)
```
/new-model Invoice
```

### Mode E — API/object documentation URL
```
/new-model Invoice --docs https://stripe.com/docs/api/invoices/object
/new-model Post --docs https://jsonplaceholder.typicode.com/guide/
```

Use `WebFetch` to retrieve the page. From the documentation, extract:
- All fields of the object (name, type, nullable, description)
- Nested objects → generate as separate model files (same as Mode B nested object rule)
- If the page documents multiple objects, focus on the one matching `<ModelName>`

In all modes, `--path lib/domain/models/subfolder` is optional to override the output directory.

---

## Instructions

### Step 0 — Parse input mode

- If `--docs <url>` is present: fetch the URL with `WebFetch` → use **docs inference** (Step 1c)
- Else if `--json-file <path>` is present: read that file → use **JSON inference** (Step 1b)
- Else if `--json '<payload>'` is present: parse inline JSON → use **JSON inference** (Step 1b)
- Else if `name:type` pairs are present: use **explicit fields** (Step 1a)
- Else: use **placeholder** (single `required String id,` field)

### Step 1a — Explicit fields

Collect all `name:type` pairs from the arguments. Each field becomes a Dart parameter (see Field rules below).

### Step 1b — JSON inference

Given the JSON object, infer each field's Dart name and type:

- JSON key → Dart name: convert `snake_case` to `camelCase` (e.g. `client_name` → `clientName`)
- If the JSON key differs from the camelCase Dart name, add `@JsonKey(name: 'json_key')`
- Infer Dart type from JSON value:
  - `null` → `String?` (nullable String, ask user to refine if needed)
  - `true` / `false` → `bool`
  - integer number → `int`
  - decimal number → `double`
  - string → `String`
  - array → `List<dynamic>` (refine to `List<T>` if elements have a consistent type)
  - nested object → create a **separate model file** for the nested type and import it (see Nested objects below)
- If the JSON is a list (array at root), infer types from the first element

#### Nested objects

If a JSON value is itself an object:
- Name the nested class as `<ParentModel><FieldNamePascalCase>`, e.g. field `address: {...}` inside `Invoice` → class `InvoiceAddress`
- Generate a separate file for it following the same rules
- Import it in the parent model
- List all files to be created before writing any of them

### Step 1c — Docs inference (--docs)

Use `WebFetch` to fetch the URL. The page may be API reference docs (Stripe, Twilio, etc.), a guide (JSONPlaceholder), or any other format that describes an object's fields.

**Extraction rules:**

1. **Locate the object** matching `<ModelName>` on the page. If the page describes a single resource, use that. If it describes multiple, pick the one whose name matches.

2. **Extract each field:**
   - Field name → convert to camelCase Dart name; if the API uses snake_case, add `@JsonKey(name: 'api_key')`
   - Type → map from the doc's type system to Dart:
     | Doc type | Dart type |
     |---|---|
     | string / text | `String` |
     | integer / int | `int` |
     | number / float / decimal | `double` |
     | boolean / bool | `bool` |
     | array / list of X | `List<X>` |
     | object / hash / dict | nested model (separate file) |
     | timestamp / unix time | `int` (store as epoch) or `String` (ISO) — pick based on doc example |
     | enum / one of "a","b" | `String` (document valid values in a comment) |
     | nullable / optional | append `?` to the Dart type |

3. **Nested objects** — apply the same rule as Step 1b: `<ParentModel><FieldNamePascalCase>`, separate file.

4. **Infer operations for the repository** (if `--repo` is also being generated): scan the page for described endpoints or HTTP methods (GET /resource, POST /resource, DELETE /resource/:id, etc.) and note them — they will be used in Step 2 (repository generation).

5. **If the page is a guide** (e.g. JSONPlaceholder) rather than a single object reference: find the example response JSON embedded in the page, extract it, and apply Step 1b JSON inference rules on it.

6. **If the page requires authentication or is unavailable:** warn the user and fall back to Mode D (placeholder with a TODO comment listing what fields to add).

---

### Step 2 — Resolve output path

- If `--path` is provided, use that directory.
- Otherwise: `lib/domain/models/<snake_case_name>/`
- Confirm the `lib/domain/models/` directory exists before writing.

### Step 3 — Determine the package name

Read `pubspec.yaml` and extract `name:`. Use it as the package prefix in imports.

### Step 4 — Detect existing conventions

Scan one or two existing model files under `lib/domain/models/` to check:
- Whether `idFromJson`/`idToJson` helpers from `parser.dart` are used for `id` fields
- The exact `part` directive pattern in use

### Step 5 — Generate the model file(s)

For each model (parent + any nested), create `lib/domain/models/<snake_name>/<snake_name>.dart`:

```dart
import 'package:freezed_annotation/freezed_annotation.dart';
// Additional imports for nested models or parser.dart

part '<snake_name>.freezed.dart';
part '<snake_name>.g.dart';

@freezed
abstract class <ModelName> with _$<ModelName> {
  const factory <ModelName>({
    // Fields
  }) = _<ModelName>;

  factory <ModelName>.fromJson(Map<String, dynamic> json) =>
      _$<ModelName>FromJson(json);
}
```

#### Field rules

- Required non-nullable: `required String name,`
- Required nullable: `required String? name,`
- `id` field with project parser helpers: `@JsonKey(fromJson: idFromJson, toJson: idToJson) required String id,` + import parser
- JSON key differs from Dart name: `@JsonKey(name: 'json_key') required String dartName,`
- Both conditions apply: combine both annotations or use `@JsonKey(name: 'json_key', fromJson: ..., toJson: ...)`

### Step 6 — Announce results

After writing all files:

```
Created:
  lib/domain/models/<snake_name>/<snake_name>.dart
  lib/domain/models/<nested_snake>/<nested_snake>.dart  (if any)

Next steps:
  1. Run: dart run build_runner build --delete-conflicting-outputs
  2. Register models in your repository if needed.
```

Do NOT create `.freezed.dart` or `.g.dart` files — those are generated by `build_runner`.

---

## Examples

```
# Explicit fields
/new-model Invoice id:String clientName:String amount:double paid:bool

# Inline JSON
/new-model Invoice --json '{"id": "abc", "client_name": "Acme", "amount": 99.9, "paid": false}'

# JSON file
/new-model Invoice --json-file assets/mock/invoice.json

# JSON with nested object (generates Invoice + InvoiceAddress)
/new-model Invoice --json '{"id": "1", "address": {"street": "Main St", "city": "NY"}}'

# Custom path
/new-model Product id:String name:String --path lib/domain/models/catalog
```
