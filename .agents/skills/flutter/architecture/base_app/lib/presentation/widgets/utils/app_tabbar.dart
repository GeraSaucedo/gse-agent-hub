import 'package:flutter/material.dart';
import 'package:gse_design_system/gse_design_system.dart';

class AppTabBar extends StatefulWidget {
  const AppTabBar({
    required this.tabs,
    required this.views,
    this.onPressTab,
    this.alignment = TabAlignment.center,
    this.allowSwipeWithGesture = true,
    super.key,
  });

  final List<String> tabs;
  final List<Widget> views;
  final void Function(int)? onPressTab;
  final TabAlignment alignment;
  final bool allowSwipeWithGesture;

  @override
  State<AppTabBar> createState() => _AppTabBarState();
}

class _AppTabBarState extends State<AppTabBar>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();

    _tabController = TabController(length: widget.tabs.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: Colors.transparent,
      child: Column(
        children: [
          TabBar(
            isScrollable: true,
            tabAlignment: widget.alignment,
            controller: _tabController,
            labelColor: Theme.of(context).colorScheme.onSurface,
            dividerColor: context.colors.onSurfaceLow,
            unselectedLabelColor: context.colors.textSecondary,
            onTap: widget.onPressTab,
            tabs: widget.tabs.map((tabTitle) {
              return Padding(
                padding: EdgeInsets.symmetric(vertical: context.h(2)),
                child: Text(
                  tabTitle,
                  style: context.textStyles.titleSmall,
                ),
              );
            }).toList(),
          ),
          Expanded(
            child: TabBarView(
              physics: widget.allowSwipeWithGesture
                  ? null
                  : const NeverScrollableScrollPhysics(),
              controller: _tabController,
              children: widget.views,
            ),
          ),
        ],
      ),
    );
  }
}
