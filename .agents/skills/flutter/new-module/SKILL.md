---
name: new-module
description: Generate a complete feature module across all 4 layers — Model, Repository, BLoC, Screen — wiring each layer to the next
argument-hint: <domain> "<description>" [--model Name] [--repo Name] [--bloc Name] [--screen Name] [--json '<json>'] [--docs <url>] [--screen-variant form|data|simple] [--bloc-variant form|data|pagination]
allowed-tools: [Read, Write, Glob, Grep, Bash, WebFetch]
---

# New Module

Generate a complete feature module, wiring each layer to the one below it. Only the layers whose flag is present are generated — missing flags mean that layer already exists and should be auto-detected.

## Arguments

The user invoked this skill with: `$ARGUMENTS`

| Flag | Description | Example |
|---|---|---|
| `<domain>` | snake_case feature folder (required) | `purchase_orders` |
| `"<description>"` | plain-language feature description (required) | `"list of purchase orders with detail and approval"` |
| `--model <Name>` | generate domain model with this PascalCase name | `--model PurchaseOrder` |
| `--repo <Name>` | generate repository with this PascalCase name | `--repo PurchaseOrder` |
| `--bloc <Name>` | generate BLoC with this PascalCase name | `--bloc PurchaseOrderList` |
| `--screen <Name>` | generate screen with this PascalCase name | `--screen PurchaseOrderList` |
| `--json '<json>'` | JSON payload to infer model fields (only with `--model`) | `--json '{"id":"1","total":99.9}'` |
| `--docs <url>` | API documentation URL — infers model fields, API path, operations, and failure cases | `--docs https://stripe.com/docs/api/invoices` |
| `--screen-variant <v>` | `form` \| `data` \| `simple` (default: inferred) | `--screen-variant data` |
| `--bloc-variant <v>` | `form` \| `data` \| `pagination` (default: inferred) | `--bloc-variant pagination` |

### --docs flag behaviour

When `--docs <url>` is present, `WebFetch` is called **once** at the start (Step 0) and the result is shared across all layers that need it:

- **Model** (`--model`): extracts object fields and types from the docs page
- **Repository** (`--repo`): extracts base API path, HTTP operations, and error codes from the docs page
- **BLoC / Screen**: use what was inferred above — no additional fetch needed

`--docs` and `--json` are mutually exclusive. If both are present, `--docs` takes precedence.

**Examples:**

```bash
# Full stack — all 4 layers
/new-module purchase_orders "list and approval of purchase orders" --model PurchaseOrder --repo PurchaseOrder --bloc PurchaseOrderList --screen PurchaseOrderList --screen-variant data

# Only BLoC + Screen (model and repo already exist)
/new-module products "product detail with edit" --bloc ProductDetail --screen ProductDetail --screen-variant form

# Only Screen (bloc already exists)
/new-module invoices "invoice list" --screen InvoiceList --screen-variant data

# Full stack from API docs — model fields and repo operations inferred from the URL
/new-module posts "blog post list with create and delete" --model Post --repo Post --bloc PostList --screen PostList --docs https://jsonplaceholder.typicode.com/guide/

# Stripe invoices — full stack from Stripe docs
/new-module invoices "invoice management" --model Invoice --repo Invoice --bloc InvoiceList --screen InvoiceList --docs https://stripe.com/docs/api/invoices
```

---

## Step 0 — Setup

1. Read `pubspec.yaml` → extract `name:` as `<package_name>`
2. **If `--docs <url>` is present:** fetch the URL now with `WebFetch` and keep the result in context. Extract and note:
   - Object fields + types → used in model generation
   - Base API path + HTTP operations → used in repository generation
   - Documented error/status codes → used as failure enum cases
3. Determine which layers to generate from flags present in `$ARGUMENTS`:
   - `--model` present → **generate model**
   - `--repo` present → **generate repository**
   - `--bloc` present → **generate BLoC**
   - `--screen` present → **generate screen**
4. Infer missing variants if not explicitly passed:
   - `--screen-variant`: if description contains words like "form", "create", "edit", "new" → `form`; if "list", "catalog", "pagination" → `data`; else default `data`
   - `--bloc-variant`: if `--screen-variant=form` → `form`; if description mentions "pagination" → `pagination`; else `data`
4. Create a plan:

```
Module: <domain>
Description: <description>
Layers to generate:
  [x/—] Model      → <ModelName> (lib/domain/models/<snake>/...)
  [x/—] Repository → <RepoName>Repository (lib/data/repositories/<domain>/...)
  [x/—] BLoC       → <BlocName>Bloc (lib/presentation/blocs/<domain>/...)
  [x/—] Screen     → <ScreenName>Screen (lib/presentation/screens/<domain>/...)
```

---

## Step 1 — Model (skip if `--model` not present)

### 1a — If `--model` IS present: generate

Read `.claude/skills/new-model.md` for the full generation rules. Apply them now for `<ModelName>` in `lib/domain/models/<snake_name>/`.

- If `--json` was passed: infer fields from the JSON payload
- Otherwise: infer fields from `<description>` (use reasonable types)
- Always include `id: String` as the first field
- Do NOT run `build_runner` yet — remind at the end

Output file: `lib/domain/models/<snake_name>/<snake_name>.dart`

### 1b — If `--model` NOT present: auto-detect

Search `lib/domain/models/` for an existing model matching the domain or the name that `--repo` / `--bloc` would use. Grep for the class name. Note the exact file path and class name — this will be used as the return type in the repository.

If no model is found, warn the user:
> ⚠️ No model found for `<domain>`. Repository will use `Map<String, dynamic>` as return type — replace once the model is created.

---

## Step 2 — Repository (skip if `--repo` not present)

### 2a — If `--repo` IS present: generate

Read `.claude/skills/new-repository.md` for the full generation rules. Apply them now for `<RepoName>Repository`.

**Cross-layer wiring:** Use the model class resolved in Step 1 as the return type for all operations. Import it correctly.

Infer the API base path from the description and domain name (e.g. domain `purchase_orders` → `/purchase-orders`).

Infer operations from the description:
- "list" / "catalog" / "all" → `getAll`
- "detail" / "by id" → `getById`
- "create" / "new" → `create`
- "edit" / "update" → `update`
- "delete" / "remove" → `delete`
- "approve" / "reject" / custom verb → add as a named method

Files to generate:
- `lib/data/repositories/<domain>/<snake_repo>_failures.dart`
- `lib/data/repositories/<domain>/<snake_repo>_repository.dart`
- Update `lib/data/repositories/repositories_injector.dart`

### 2b — If `--repo` NOT present: auto-detect

Grep `lib/data/repositories/<domain>/` for an existing repository. Note the class name and available methods — the BLoC will call these.

If not found, warn:
> ⚠️ No repository found in `lib/data/repositories/<domain>/`. BLoC will have TODO comments for repository calls.

---

## Step 3 — BLoC (skip if `--bloc` not present)

### 3a — If `--bloc` IS present: generate

Read `.claude/skills/new-bloc.md` for the full generation rules. Apply them for `<BlocName>Bloc` using `--bloc-variant`.

**Cross-layer wiring:**
- Import the repository resolved in Step 2 as the BLoC's dependency
- Use the model from Step 1 as the type for state list/item fields
- Import the failure enum from the repository generated in Step 2
- Wire handler TODOs to the actual repository methods found in Step 2b

Files to generate:
- `lib/presentation/blocs/<domain>/<snake_bloc>_bloc.dart`
- `lib/presentation/blocs/<domain>/<snake_bloc>_events.dart`
- `lib/presentation/blocs/<domain>/<snake_bloc>_state.dart`
- Update `lib/presentation/blocs/blocs_injector.dart`

### 3b — If `--bloc` NOT present: auto-detect

Grep `lib/presentation/blocs/<domain>/` for an existing BLoC. Read its state file to note available fields and status enum — the screen will use these.

---

## Step 4 — Screen (skip if `--screen` not present)

### 4a — If `--screen` IS present: generate

Read `.claude/skills/new-screen.md` for the full generation rules AND the localization key convention. Apply them for `<ScreenName>Screen` using `--screen-variant`.

**Cross-layer wiring:**
- Import the BLoC resolved in Step 3
- Use the actual state fields from Step 3 in the BlocBuilder (real field names, not placeholders)
- Use the actual failure enum cases from Step 2 in the BlocListener switch (no generic `_` catch-all for known cases)
- Use the actual events from Step 3 in `onChanged` / `onPressed` handlers

Files to generate:
- `lib/presentation/screens/<domain>/<snake_screen>_screen.dart`
- `lib/presentation/screens/<domain>/<snake_screen>_view.dart`
- `lib/presentation/screens/<domain>/<snake_screen>_bloc_listener.dart`

### 4b — Localization keys

Following the key convention from `new-screen.md`, generate the exact ARB entries for every user-facing string in the screen. Output them ready to paste:

```
// app_en.arb — paste these entries:
"<key>": "<English value>",
"@<key>": { "description": "<description>" },
...

// app_es.arb — paste these entries:
"<key>": "<Spanish value>",
"@<key>": { "description": "<descripción>" },
...
```

---

## Step 5 — Final report

```
## Module generated: <domain>

### Layers
✅ Model      → lib/domain/models/<snake>/<snake>.dart
✅ Repository → lib/data/repositories/<domain>/<snake>_repository.dart
✅ BLoC       → lib/presentation/blocs/<domain>/<snake>_bloc.dart
✅ Screen     → lib/presentation/screens/<domain>/<snake>_screen.dart
— (skipped)

### ARB entries to paste
[output from Step 4b]

### Post-generation checklist
[ ] Run codegen (if model was generated):
    dart run build_runner build --delete-conflicting-outputs
[ ] Add route to lib/core/routes/app_router.dart
[ ] Paste ARB entries and run: flutter gen-l10n (inside packages/gse_localization/)
[ ] Register BLoC in blocs_injector.dart (already done if --bloc was passed)
[ ] Register Repository in repositories_injector.dart (already done if --repo was passed)
[ ] Replace any TODO comments in the generated files
```

---

## Wiring rules summary

| From | To | What to connect |
|---|---|---|
| Model → Repository | Return type of all methods | Import model, use `ModelName.fromJson(...)` |
| Repository → BLoC | Dependency injection + method calls | Constructor param, call actual methods in handlers |
| Repository → BLoC | Failure enum | Import `<RepoName>Failure`, use in state |
| BLoC → Screen | State fields | Use real field names in BlocBuilder, not `state.items` if the field is named differently |
| BLoC → Screen | Events | Use actual event constructors, not placeholders |
| BLoC → BlocListener | Failure cases | Exhaustive switch on all known failure cases |

---

## Local state mutation rule

When the module includes **list + mutation** operations (delete, update, create), apply the local state mutation pattern — do NOT re-fetch the list after a successful operation.

### Detect when to apply

Apply this pattern when the description mentions any of:
- "delete", "remove", "eliminar" → DELETE handler
- "edit", "update", "actualizar", "modificar" → UPDATE handler
- "create", "add", "new", "agregar", "crear" → CREATE handler

### How to apply in each layer

**BLoC (Step 3):** Use the `local state mutation` variant documented in `new-bloc.md`. Generate the appropriate handlers (`Deleted`, `Updated`, `Created`) with `operationStatus` independent from fetch `status`. Each `case Success` must mutate `state.items` directly:

```dart
// DELETE
items: state.items.where((i) => i.id != event.id).toList()

// UPDATE
items: state.items.map((i) => i.id == value.id ? value : i).toList()

// CREATE
items: [value, ...state.items]
```

**BlocListener (Step 4):** Generate two additional listeners beyond the fetch failure listener:
1. `operationStatus` listener → `LoadingOverlay` + reset on success
2. `operationFailure` listener → `AppSnackbar` with exhaustive switch on failure cases

**View (Step 4):** Wire action triggers (delete button, confirm dialog, form submit) to dispatch the correct mutation event. After dispatch, the UI updates automatically via `BlocBuilder` reacting to the new `state.items` — no manual refresh needed.
