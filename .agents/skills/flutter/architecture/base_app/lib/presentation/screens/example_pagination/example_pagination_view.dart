import 'dart:async';

import 'package:flutter/material.dart';
import 'package:gse_design_system/gse_design_system.dart';
import 'package:gse_base_app/data/repositories/example/example_repository.dart';
import 'package:gse_base_app/core/utils/result.dart';
import 'package:gse_base_app/domain/models/example_model.dart';
import 'package:gse_base_app/main_injector.dart';
import 'package:gse_base_app/presentation/blocs/pagination/pagination_cubit.dart';
import 'package:gse_base_app/presentation/widgets/inputs/app_searchbar.dart';
import 'package:gse_base_app/presentation/widgets/lists/paginated_list.dart';

class ExamplePaginationView extends StatefulWidget {
  const ExamplePaginationView({super.key});

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
      fetchPage: (page, pageSize, params) async {
        final result = await sl<ExampleRepository>().getProducts(
          page: page,
          pageSize: pageSize,
          searchQuery: params.searchQuery,
        );
        // PaginationCubit reports thrown errors as its error state.
        return switch (result) {
          Success(:final value) => value,
          Failure(:final exception) => throw exception,
        };
      },
    );
  }

  @override
  void dispose() {
    unawaited(_cubit.close());
    _debounce?.cancel();
    super.dispose();
  }

  void _onCreate() {
    _showTextDialog(
      title: 'Crear elemento',
      onConfirm: (text) {
        final id = DateTime.now().millisecondsSinceEpoch.toString();
        _cubit.addItem(
          ExampleModel(id: id, text: text),
          atStart: true,
        );
      },
    );
  }

  void _onEdit(ExampleModel item) {
    _showTextDialog(
      title: 'Editar elemento',
      initialValue: item.text,
      onConfirm: (text) {
        _cubit.updateItem(
          (e) => e.id == item.id,
          (e) => e.copyWith(text: text),
        );
      },
    );
  }

  void _onDelete(ExampleModel item) {
    _cubit.removeItem((e) => e.id == item.id);
    ScaffoldMessenger.of(context)
      ..clearSnackBars()
      ..showSnackBar(
        SnackBar(
          content: Text('Elemento "${item.text}" eliminado'),
          action: SnackBarAction(
            label: 'Deshacer',
            onPressed: () => _cubit.addItem(item, atStart: true),
          ),
        ),
      );
  }

  void _showTextDialog({
    required String title,
    required ValueChanged<String> onConfirm,
    String initialValue = '',
  }) {
    final controller = TextEditingController(text: initialValue);
    unawaited(
      showDialog<void>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text(title),
          content: TextField(
            controller: controller,
            autofocus: true,
            decoration: const InputDecoration(hintText: 'Texto'),
            onSubmitted: (_) {
              final value = controller.text.trim();
              if (value.isNotEmpty) {
                onConfirm(value);
                Navigator.of(ctx).pop();
              }
            },
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                final value = controller.text.trim();
                if (value.isNotEmpty) {
                  onConfirm(value);
                  Navigator.of(ctx).pop();
                }
              },
              child: const Text('Aceptar'),
            ),
          ],
        ),
      ),
    );
  }

  void _showItemOptions(ExampleModel item) {
    unawaited(
      showModalBottomSheet<void>(
        context: context,
        builder: (ctx) => SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.edit_outlined),
                title: const Text('Editar'),
                onTap: () {
                  Navigator.of(ctx).pop();
                  _onEdit(item);
                },
              ),
              ListTile(
                leading: const Icon(Icons.delete_outline, color: Colors.red),
                title: const Text(
                  'Eliminar',
                  style: TextStyle(color: Colors.red),
                ),
                onTap: () {
                  Navigator.of(ctx).pop();
                  _onDelete(item);
                },
              ),
            ],
          ),
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
            onPressed: _onCreate,
            child: const Icon(Icons.add),
          ),
        ),
      ],
    );
  }
}
