---
name: clean-code
description: Detects Widget-BLoC coupling and duplicated logic in GSE Base App Flutter code
argument-hint: [path/to/file_or_folder]
allowed-tools: [Read, Glob, Grep, TodoWrite]
---

# Clean Code Check — Widget-BLoC Coupling & Logic Duplication

Analyze the indicated Flutter code and detect two recurring problems:
1. **Widget-BLoC coupling** — widgets that access BLoCs directly instead of receiving data via constructor parameters
2. **Duplicated logic** — code that already exists in a utility, extension, or base widget

## Arguments

The user invoked this skill with: `$ARGUMENTS`

- If a path (file or folder) is passed, analyze only that scope.
- If nothing is passed, analyze all of `lib/presentation/widgets/` and `lib/presentation/screens/`.

---

## Project rules (context)

### Rule 1 — Widgets must be decoupled from BLoCs

**Forbidden inside `lib/presentation/widgets/`:**
- `context.read<XxxBloc>()` — direct BLoC access from a reusable widget
- `context.watch<XxxBloc>()` or `context.select(...)`
- `BlocProvider.of<XxxBloc>(context)`
- `BlocBuilder<XxxBloc, ...>`, `BlocListener<XxxBloc, ...>`, or `BlocConsumer<XxxBloc, ...>` inside a generic widget

**Allowed only in:**
- `lib/presentation/screens/` — full screens that orchestrate BLoCs
- `lib/presentation/blocs/` — the BLoC files themselves
- `lib/presentation/widgets/buttons/app_logout_button.dart` — explicit design exception

**Correct pattern:** A reusable widget receives data and callbacks via its constructor. The screen reads the BLoC and passes the values down.

```dart
// BAD — coupled widget
class MyCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final state = context.watch<ProductBloc>().state; // COUPLING
    return Text(state.product.name);
  }
}

// GOOD — decoupled widget
class MyCard extends StatelessWidget {
  const MyCard({required this.name});
  final String name;
  @override
  Widget build(BuildContext context) => Text(name);
}
// The Screen reads the BLoC and passes `name`
```

---

### Rule 2 — Do not duplicate existing logic

Before creating something new, the following already exists in the codebase:

| What you might need | Already exists in |
|---|---|
| Format dates | `AppDateTimeExt` in `lib/core/extensions/date_extension.dart` |
| Parse string to DateTime | `AppStringDateExt.toDateTime()` in `lib/core/extensions/date_extension.dart` |
| Log in debug mode | `AppLogger.i/w/e` in `lib/core/services/logger/app_logger.dart` |
| Show snackbar | `AppSnackbar.success/info/error` in `lib/presentation/widgets/utils/app_snackbar.dart` |
| Show loading overlay | `LoadingOverlay.show/remove` in `lib/presentation/widgets/overlays/loading_overlay.dart` |
| Confirmation dialog | `ConfirmDialog.show()` in `lib/presentation/widgets/dialogs/confirm_dialog.dart` |
| Info dialog | `InfoDialog.show()` in `lib/presentation/widgets/dialogs/info_dialog.dart` |
| Paginated list | `PaginatedList<T>` in `lib/presentation/widgets/lists/paginated_list.dart` |
| Selection bottom sheet | `SelectionBottomSheet<T>.show()` in `lib/presentation/widgets/bottom_sheets/selection_bottom_sheet.dart` |
| AppBar with centered title | `CustomAppBar` in `lib/presentation/widgets/utils/custom_appbar.dart` |
| Loading spinner | `AppLoader` in `lib/presentation/widgets/utils/app_loader.dart` |
| Dismiss keyboard on tap outside | `UnfocusOnTap` in `lib/presentation/widgets/utils/unfocus_on_tap.dart` |
| Empty list view | `EmptyView` in `lib/presentation/widgets/views/empty_view.dart` |
| Error state view | `ErrorView` in `lib/presentation/widgets/views/error_view.dart` |
| Email input field | `EmailTextField` in `lib/presentation/widgets/inputs/email_text_field.dart` |
| Password input field | `PasswordTextField` in `lib/presentation/widgets/inputs/password_text_field.dart` |
| Search bar | `AppSearchbar` in `lib/presentation/widgets/inputs/app_searchbar.dart` |
| Primary button | `AppPrimaryButton` in `lib/presentation/widgets/buttons/app_primary_button.dart` |
| Text button | `AppTextButton` in `lib/presentation/widgets/buttons/app_text_button.dart` |
| Generic dropdown | `AppDropdown<T>` in `lib/presentation/widgets/selectors/app_dropdown.dart` |
| Zoomable image viewer | `AppImageViewer` in `lib/presentation/widgets/utils/app_image_viewer.dart` |
| SVG icon | `AppIcon(icon: AppIcons.xxx)` in `lib/core/theme/icons/app_icon.dart` |
| Theme colors | `context.colors` — `ColorDataExtension` |
| Text styles | `context.textstyles` — `TextStyles` |
| Container BoxDecoration | `context.styles.primaryContainer / secondaryContainer` |

---

## Analysis instructions

### Step 0 — Prepare tasks

Use `TodoWrite` with:
1. Detect files to analyze
2. Scan for Widget-BLoC coupling
3. Scan for duplicated logic
4. Generate final report

### Step 1 — Detect scope

- If `$ARGUMENTS` contains a path: use that path
- Otherwise: scope = `lib/presentation/widgets/` + `lib/presentation/screens/`

List `.dart` files in the scope with `Glob`.

### Step 2 — Scan for Widget-BLoC coupling

For each file inside `lib/presentation/widgets/` (except `app_logout_button.dart`):

Search with `Grep` for these patterns:
- `context\.read<`
- `context\.watch<`
- `context\.select`
- `BlocProvider\.of`
- `BlocBuilder<`
- `BlocListener<`
- `BlocConsumer<`

For each match: record the file, line number, and pattern found.

### Step 3 — Scan for duplicated logic

Read the files in scope. For each code fragment, identify whether it reimplements something from the Rule 2 table:

Signals of duplication:
- `CircularProgressIndicator` defined inline → should be `AppLoader`
- `ScaffoldMessenger.of(context).showSnackBar(...)` → should be `AppSnackbar`
- `showDialog(...)` constructing a custom AlertDialog → check if `InfoDialog` or `ConfirmDialog` already covers it
- `showModalBottomSheet(...)` with a filterable list → may be `SelectionBottomSheet`
- `DateFormat(...).format(date)` or manual date parsing → use `AppDateTimeExt` extensions
- `print(...)` or `debugPrint(...)` → use `AppLogger`
- `AppBar(title: ..., centerTitle: true)` inline in a Scaffold → use `CustomAppBar`
- `GestureDetector` whose sole purpose is `FocusScope.of(context).unfocus()` → use `UnfocusOnTap`
- Manual ListView/GridView with pagination logic → check if `PaginatedList` applies
- `Image.asset(...)` wrapped in `InteractiveViewer` → use `AppImageViewer`
- `SvgPicture.asset('assets/icons/...')` called directly → use `AppIcon`

### Step 4 — Report

Generate the report in this format:

```
## Clean Code Check — GSE Base App

### Scope analyzed
lib/presentation/widgets/ + lib/presentation/screens/  (or the indicated path)
X files scanned

---

### Widget-BLoC Coupling
(List each violation)
❌ lib/presentation/widgets/foo/bar_widget.dart:42
   `context.read<FooBloc>()` — reusable widgets must NOT access BLoCs directly.
   Fix: receive the needed data as a constructor parameter; the screen reads the BLoC.

(If no violations found)
✅ No coupled widgets found.

---

### Duplicated Logic
(List each case)
⚠️  lib/presentation/screens/home/home_screen.dart:88
   `CircularProgressIndicator()` inline — `AppLoader` already exists at lib/presentation/widgets/utils/app_loader.dart
   Fix: replace with `AppLoader()` or `AppLoader(color: ...)`.

(If no duplications found)
✅ No known duplicated logic found.

---

### Verdict
✅ CLEAN — No problems found.
❌ NEEDS ATTENTION — X coupling issue(s), Y duplication(s) detected.
```

If no problems are found in either category, the verdict is clean.
If there are problems, list each concrete fix with the exact file and line number.
