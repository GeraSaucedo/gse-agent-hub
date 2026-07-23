import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:gse_base_app/presentation/widgets/buttons/app_primary_button.dart';
import 'package:gse_design_system/gse_design_system.dart';

class SelectionDialog<T> extends StatefulWidget {
  const SelectionDialog({
    required this.items,
    required this.itemBuilder,
    this.onSelectItem,
    this.title = 'Seleccionar elemento',
    this.subtitle,
    this.searchHint = 'Buscar',
    this.filterFunction,
    this.onPressedOption,
    this.optionBtnText = 'Añadir',
    super.key,
  });

  final List<T> items;
  final void Function(T)? onSelectItem;
  final String title;
  final String? subtitle;
  final String searchHint;

  final Widget Function(BuildContext, T) itemBuilder;
  final bool Function(T item, String query)? filterFunction;
  final VoidCallback? onPressedOption;
  final String optionBtnText;

  static Future<void> show<T>({
    required BuildContext context,
    required List<T> items,
    required Widget Function(BuildContext, T) itemBuilder,
    void Function(T)? onSelectItem,
    String title = 'Seleccionar elemento',
    String optionBtnText = 'Añadir',
    VoidCallback? onPressedOption,
    String? subtitle,
    String searchHint = 'Buscar',
    bool Function(T item, String query)? filterFunction,
  }) {
    return showDialog(
      context: context,
      builder: (context) => Dialog(
        insetPadding: EdgeInsets.symmetric(horizontal: context.w(4)),
        child: SelectionDialog<T>(
          items: items,
          onSelectItem: onSelectItem,
          itemBuilder: itemBuilder,
          title: title,
          subtitle: subtitle,
          searchHint: searchHint,
          filterFunction: filterFunction,
          onPressedOption: onPressedOption,
          optionBtnText: optionBtnText,
        ),
      ),
    );
  }

  @override
  State<SelectionDialog<T>> createState() => _SelectionDialogState<T>();
}

class _SelectionDialogState<T> extends State<SelectionDialog<T>> {
  late TextEditingController _searchController;
  late List<T> _filteredItems;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _filteredItems = widget.items;
  }

  @override
  void didUpdateWidget(SelectionDialog<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.items != widget.items) {
      _filteredItems = widget.items;
      _filterItems(_searchController.text);
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterItems(String query) {
    setState(() {
      if (widget.filterFunction != null) {
        _filteredItems = widget.items
            .where((item) => widget.filterFunction!(item, query))
            .toList();
      } else {
        _filteredItems = widget.items;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: context.h(80),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: context.h(3)),
          _buildHeader(),
          SizedBox(height: context.h(2)),
          _buildSearchBar(),
          Flexible(
            child: Builder(
              builder: (context) {
                if (_filteredItems.isEmpty) {
                  return Column(
                    children: [
                      SizedBox(height: context.h(4)),
                      const Text('No se encontraron elementos'),
                    ],
                  );
                }
                return _buildItemsList();
              },
            ),
          ),
          if (widget.onPressedOption != null)
            SizedBox(
              width: double.infinity,
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: context.w(4),
                  vertical: context.h(2),
                ),
                child: AppPrimaryButton(
                  onPressed: widget.onPressedOption,
                  child: Text(
                    widget.optionBtnText,
                    style: context.textStyles.titleMed.semibold,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: context.w(3)),
      child: Column(
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              Align(
                alignment: Alignment.centerRight,
                child: IconButton(
                  onPressed: () {
                    context.pop();
                  },
                  icon: Icon(
                    Icons.close,
                    size: context.sp(19),
                  ),
                ),
              ),
              Align(
                child: Text(
                  widget.title,
                  style: context.textStyles.titleSmall,
                ),
              ),
            ],
          ),
          if (widget.subtitle != null)
            Padding(
              padding: EdgeInsetsGeometry.symmetric(horizontal: context.w(6)),
              child: Text(
                widget.subtitle!,
                style: context.textStyles.bodyMed,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: context.w(6)),
      child: TextField(
        onTapOutside: (event) {
          FocusScope.of(context).unfocus();
        },
        controller: _searchController,
        onChanged: _filterItems,
        style: context.textStyles.titleMed,
        decoration: InputDecoration(
          hintText: widget.searchHint,
          prefixIcon: const Icon(Icons.search),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          contentPadding: EdgeInsets.symmetric(horizontal: context.w(4)),
          suffixIcon: _searchController.text.isEmpty
              ? null
              : IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () {
                    _searchController.clear();
                    _filterItems('');
                    setState(() {});
                  },
                ),
        ),
      ),
    );
  }

  Widget _buildItemsList() {
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      shrinkWrap: true,
      itemCount: _filteredItems.length,
      separatorBuilder: (context, index) => Padding(
        padding: EdgeInsets.symmetric(horizontal: context.w(3)),
        child: Divider(
          color: context.colors.disabled,
        ),
      ),
      itemBuilder: (context, index) {
        final item = _filteredItems[index];
        return InkWell(
          onTap: widget.onSelectItem != null
              ? () => widget.onSelectItem!(item)
              : null,
          child: widget.itemBuilder(context, item),
        );
      },
    );
  }
}
