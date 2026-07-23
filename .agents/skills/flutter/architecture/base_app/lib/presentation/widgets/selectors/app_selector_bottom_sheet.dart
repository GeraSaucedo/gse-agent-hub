import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:gse_design_system/gse_design_system.dart';
import 'package:gse_localization/gse_localization.dart';

class SelectionBottomSheet<T> extends StatefulWidget {
  const SelectionBottomSheet({
    required this.items,
    required this.onSelectItem,
    required this.itemBuilder,
    this.title,
    this.searchHint,
    this.filterFunction,
    super.key,
  });

  final List<T> items;
  final void Function(T) onSelectItem;
  final String? title;
  final String? searchHint;

  final Widget Function(BuildContext, T) itemBuilder;
  final bool Function(T item, String query)? filterFunction;

  static Future<void> show<T>({
    required BuildContext context,
    required List<T> items,
    required Widget Function(BuildContext, T) itemBuilder,
    void Function(T)? onSelectItem,
    String? title,
    String? searchHint,
    bool Function(T item, String query)? filterFunction,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (context) => SelectionBottomSheet<T>(
        items: items,
        onSelectItem: onSelectItem ?? (_) {},
        itemBuilder: itemBuilder,
        title: title,
        searchHint: searchHint,
        filterFunction: filterFunction,
      ),
    );
  }

  @override
  State<SelectionBottomSheet<T>> createState() =>
      _SelectionBottomSheetState<T>();
}

class _SelectionBottomSheetState<T> extends State<SelectionBottomSheet<T>> {
  late TextEditingController _searchController;
  late List<T> _filteredItems;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _filteredItems = widget.items;
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
    return SafeArea(
      child: Container(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: SizedBox(
          height: context.h(80),
          child: Column(
            children: [
              SizedBox(height: context.h(3)),
              _buildHeader(),
              SizedBox(height: context.h(2)),
              _buildSearchBar(),
              Expanded(
                child: Builder(
                  builder: (context) {
                    if (_filteredItems.isEmpty) {
                      return Column(
                        children: [
                          SizedBox(height: context.h(4)),
                          Text(AppLocalizations.of(context)!.emptyStateMessage),
                        ],
                      );
                    }
                    return _buildItemsList();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: context.w(3)),
      child: Stack(
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
              widget.title ?? AppLocalizations.of(context)!.selectElementTitle,
              style: context.textStyles.titleMed,
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
          hintText: widget.searchHint ??
              AppLocalizations.of(context)!.searchHint,
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
          onTap: () => widget.onSelectItem(item),
          child: widget.itemBuilder(context, item),
        );
      },
    );
  }
}
