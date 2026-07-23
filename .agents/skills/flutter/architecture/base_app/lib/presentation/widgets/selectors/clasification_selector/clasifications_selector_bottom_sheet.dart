/* import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gse_base_app/main_injector.dart';
import 'package:gse_base_app/presentation/widgets/selectors/clasification_selector/clasification_selector_tile.dart';
import 'package:gse_base_app/presentation/widgets/views/selectors/selector_empty_view.dart';
import 'package:gse_base_app/presentation/widgets/views/selectors/selector_error_view.dart';
import 'package:gse_base_app/presentation/widgets/views/selectors/selector_loading_view.dart';
import 'package:gse_design_system/gse_design_system.dart';

class ClasificationSelector extends StatefulWidget {
  const ClasificationSelector({
    required this.onSelectClasification,
    required this.department,
    super.key,
  });

  final void Function(NSClasification) onSelectClasification;
  final NSDepartment department;

  static Future<void> show(
    BuildContext context, {
    required void Function(NSClasification) onSelectClasification,
    required NSDepartment department,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (context) => BlocProvider(
        create: (context) => ClasificationsCatalogBloc(
          transferOrdersRepository: sl(),
        ),
        child: SizedBox(
          height: context.h(90),
          child: Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: ClasificationSelector(
              onSelectClasification: onSelectClasification,
              department: department,
            ),
          ),
        ),
      ),
      showDragHandle: true,
    );
  }

  @override
  State<ClasificationSelector> createState() => _ClasificationSelectorState();
}

class _ClasificationSelectorState extends State<ClasificationSelector> {
  final _searchController = TextEditingController();
  final _searchFocusNode = FocusNode();

  @override
  void initState() {
    context.read<ClasificationsCatalogBloc>().add(
      ClasificationsRetrived(
        department: widget.department,
      ),
    );
    super.initState();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: context.w(1)),
      child: Column(
        spacing: context.h(2),
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [_buildHeader(), _buildSearchBar(), _buildItemsList()],
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      spacing: context.w(2),
      children: [
        IconButton(
          onPressed: () {
            context.read<ClasificationsCatalogBloc>().add(
              ClasificationsRetrived(
                department: widget.department,
              ),
            );
          },
          icon: const Icon(Icons.refresh),
        ),
        Expanded(
          child: Text(
            'Selección de clasificación',
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(
              context,
            ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
        ),
        IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(Icons.close),
        ),
      ],
    );
  }

  Widget _buildSearchBar() {
    return BlocBuilder<ClasificationsCatalogBloc, ClasificationsCatalogState>(
      buildWhen: (previous, current) {
        return previous.isLoading != current.isLoading ||
            previous.clasifications != current.clasifications ||
            previous.query != current.query;
      },
      builder: (context, state) {
        final txtFieldEnabled =
            !state.isLoading && state.clasifications.isNotEmpty;

        return Padding(
          padding: EdgeInsets.symmetric(horizontal: context.w(3)),
          child: TextField(
            enabled: txtFieldEnabled,
            controller: _searchController,
            focusNode: _searchFocusNode,
            autofocus: true,
            onTapOutside: (event) {
              FocusScope.of(context).unfocus();
            },
            onChanged: (value) {
              context.read<ClasificationsCatalogBloc>().add(
                SearchQueryChanged(value),
              );
            },
            //style: context.textStyles.titleMed,
            decoration: InputDecoration(
              hintText: 'Buscar...',
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              contentPadding: EdgeInsets.symmetric(horizontal: context.w(4)),
              suffixIcon: state.query.isEmpty
                  ? null
                  : IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () {
                        context.read<ClasificationsCatalogBloc>().add(
                          SearchQueryChanged(''),
                        );
                        _searchController.clear();
                      },
                    ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildItemsList() {
    return Expanded(
      child: BlocBuilder<ClasificationsCatalogBloc, ClasificationsCatalogState>(
        /* buildWhen: (previous, current) {
          return previous.clasifications != current.clasifications;
        }, */
        builder: (context, state) {
          if (state.isLoading) {
            return const SelectorLoadingView();
          }

          if (state.errorMessage != '') {
            return SelectorErrorView(
              onReintent: () {
                context.read<ClasificationsCatalogBloc>().add(
                  ClasificationsRetrived(
                    department: widget.department,
                  ),
                );
              },
            );
          }

          final clasifications = state.clasifications
              .where(
                (clasification) => clasification.name.toLowerCase().contains(
                  state.query.toLowerCase(),
                ) /* ||
                    clasification.id.toString().contains(
                      state.query.toLowerCase(),
                    ), */,
              )
              .toList();

          if (clasifications.isEmpty) {
            return const SelectorEmptyView();
          }

          return ListView.separated(
            itemCount: clasifications.length,
            separatorBuilder: (context, index) => Padding(
              padding: EdgeInsets.symmetric(horizontal: context.w(3)),
              child: Divider(
                color: Theme.of(context).colorScheme.outline.withAlpha(150),
              ),
            ),
            itemBuilder: (context, index) {
              final item = clasifications[index];
              return ClasificationSelectorTile(
                clasification: item,
                onPressed: () {
                  widget.onSelectClasification(item);
                },
              );
            },
          );
        },
      ),
    );
  }
}
 */
