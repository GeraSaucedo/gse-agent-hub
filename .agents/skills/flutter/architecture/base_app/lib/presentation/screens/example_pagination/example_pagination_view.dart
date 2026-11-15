import 'dart:async';

import 'package:gse_base_app/data/repositories/example/example_repository.dart';
import 'package:gse_base_app/domain/models/example_model.dart';
import 'package:gse_base_app/main_injector.dart';
import 'package:gse_base_app/presentation/blocs/pagination/pagination_cubit.dart';
import 'package:gse_base_app/presentation/widgets/inputs/app_searchbar.dart';
import 'package:gse_base_app/presentation/widgets/lists/paginated_list.dart';
import 'package:gse_design_system/gse_design_system.dart';
import 'package:gse_localization/gse_localization.dart';
import 'package:material_ui/material_ui.dart';

class ExamplePaginationView extends StatefulWidget {
  const new({super.key});

  @override
  State<ExamplePaginationView> createState() => _ExamplePaginationViewState();
}

class _ExamplePaginationViewState extends State<ExamplePaginationView> {
  static const int _debounceDurationMs = 500;

  late final PaginationCubit<ExampleModel> _cubit;
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _cubit = PaginationCubit<ExampleModel>(
      fetchPage: (page, pageSize, params) =>
          sl<ExampleRepository>().getProducts(
            page: page,
            pageSize: pageSize,
            searchQuery: params.searchQuery,
          ),
    );
  }

  @override
  void dispose() {
    unawaited(_cubit.close());
    _debounce?.cancel();
    super.dispose();
  }

  Future<void> _onCreate() async {
    final text = await _TextInputDialog.show(
      context,
      title: AppLocalizations.of(context)!.exampleCreateItem,
    );
    if (text == null) return;
    final id = DateTime.now().millisecondsSinceEpoch.toString();
    _cubit.addItem(ExampleModel(id: id, text: text), atStart: true);
  }

  Future<void> _onEdit(ExampleModel item) async {
    final text = await _TextInputDialog.show(
      context,
      title: AppLocalizations.of(context)!.exampleEditItem,
      initialValue: item.text,
    );
    if (text == null) return;
    _cubit.updateItem((e) => e.id == item.id, (e) => e.copyWith(text: text));
  }

  void _onDelete(ExampleModel item) {
    final l10n = AppLocalizations.of(context)!;
    _cubit.removeItem((e) => e.id == item.id);
    ScaffoldMessenger.of(context)
      ..clearSnackBars()
      ..showSnackBar(
        SnackBar(
          content: Text(l10n.exampleItemDeleted(item.text)),
          action: SnackBarAction(
            label: l10n.undoButton,
            onPressed: () => _cubit.addItem(item, atStart: true),
          ),
        ),
      );
  }

  void _showItemOptions(ExampleModel item) {
    final l10n = AppLocalizations.of(context)!;
    final danger = context.colors.error;
    showModalBottomSheet<void>(
      context: context,
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.edit_outlined),
              title: Text(l10n.editButton),
              onTap: () {
                Navigator.of(ctx).pop();
                unawaited(_onEdit(item));
              },
            ),
            ListTile(
              leading: Icon(Icons.delete_outline, color: danger),
              title: Text(l10n.deleteButton, style: TextStyle(color: danger)),
              onTap: () {
                Navigator.of(ctx).pop();
                _onDelete(item);
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: context.w(4),
                vertical: context.h(1),
              ),
              child: AppSearchBar(
                onChanged: (value) {
                  _debounce?.cancel();
                  _debounce = Timer(
                    const Duration(milliseconds: _debounceDurationMs),
                    () => unawaited(_cubit.search(value)),
                  );
                },
              ),
            ),
            Expanded(
              child: PaginatedList<ExampleModel>(
                cubit: _cubit,
                itemBuilder: (context, item, index) {
                  return ListTile(
                    leading: CircleAvatar(child: Text(item.id)),
                    title: Text(item.text),
                    subtitle: Text('ID: ${item.id}'),
                    onTap: () => _showItemOptions(item),
                  );
                },
              ),
            ),
          ],
        ),
        Positioned(
          right: context.w(4),
          bottom: context.h(2),
          child: FloatingActionButton(
            onPressed: () => unawaited(_onCreate()),
            child: const Icon(Icons.add),
          ),
        ),
      ],
    );
  }
}

/// Asks for a non-empty text. Owns its controller, so it is disposed with
/// the dialog (the old inline controller was never disposed).
class _TextInputDialog extends StatefulWidget {
  const new({required this.title, required this.initialValue});

  final String title;
  final String initialValue;

  /// The trimmed text, or `null` if cancelled.
  static Future<String?> show(
    BuildContext context, {
    required String title,
    String initialValue = '',
  }) => showDialog<String>(
    context: context,
    builder: (_) => _TextInputDialog(title: title, initialValue: initialValue),
  );

  @override
  State<_TextInputDialog> createState() => _TextInputDialogState();
}

class _TextInputDialogState extends State<_TextInputDialog> {
  late final _controller = TextEditingController(text: widget.initialValue);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _confirm() {
    final value = _controller.text.trim();
    if (value.isNotEmpty) Navigator.of(context).pop(value);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return AlertDialog(
      title: Text(widget.title),
      content: TextField(
        controller: _controller,
        autofocus: true,
        decoration: InputDecoration(hintText: l10n.exampleTextHint),
        onSubmitted: (_) => _confirm(),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(l10n.dialogCancelButton),
        ),
        TextButton(onPressed: _confirm, child: Text(l10n.dialogAcceptButton)),
      ],
    );
  }
}
