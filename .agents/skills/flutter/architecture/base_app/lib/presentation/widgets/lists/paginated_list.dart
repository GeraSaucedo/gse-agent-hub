import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gse_base_app/presentation/blocs/pagination/pagination_cubit.dart';
import 'package:gse_base_app/presentation/widgets/views/empty_view.dart';
import 'package:gse_base_app/presentation/widgets/views/error_view.dart';
import 'package:gse_design_system/gse_design_system.dart';
import 'package:gse_localization/gse_localization.dart';

class PaginatedList<T> extends StatefulWidget {
  const PaginatedList({
    required this.cubit,
    required this.itemBuilder,
    this.invisibleItemsThreshold = 3,
    super.key,
  });

  final PaginationCubit<T> cubit;
  final Widget Function(BuildContext context, T item, int index) itemBuilder;
  final int invisibleItemsThreshold;

  @override
  State<PaginatedList<T>> createState() => _PaginatedListState<T>();
}

class _PaginatedListState<T> extends State<PaginatedList<T>> {
  @override
  void initState() {
    super.initState();
    unawaited(widget.cubit.loadMore());
  }

  void _triggerLoadMore() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      unawaited(widget.cubit.loadMore());
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PaginationCubit<T>, PaginationState<T>>(
      bloc: widget.cubit,
      builder: (context, state) {
        if (state.status == PaginationStatus.initial ||
            state.status == PaginationStatus.loading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state.status == PaginationStatus.error && state.items.isEmpty) {
          return ErrorView(onReintent: widget.cubit.refresh);
        }

        if (state.items.isEmpty) {
          return const EmptyView(fullHeight: false);
        }

        return ListView.builder(
          padding: EdgeInsets.symmetric(
            horizontal: context.w(4),
            vertical: context.h(1),
          ),
          itemCount: state.items.length + 1,
          itemBuilder: (ctx, index) {
            if (index < state.items.length) {
              if (state.hasMore &&
                  index ==
                      state.items.length - widget.invisibleItemsThreshold) {
                _triggerLoadMore();
              }
              return widget.itemBuilder(ctx, state.items[index], index);
            }
            return _buildFooter(ctx, state);
          },
        );
      },
    );
  }

  Widget _buildFooter(BuildContext ctx, PaginationState<T> state) {
    final l10n = AppLocalizations.of(ctx)!;
    return switch (state.status) {
      PaginationStatus.loadingMore => const Padding(
        padding: EdgeInsets.symmetric(vertical: 12),
        child: LinearProgressIndicator(),
      ),
      PaginationStatus.errorMore => Padding(
        padding: EdgeInsets.symmetric(vertical: ctx.h(1)),
        child: Column(
          children: [
            Text(
              l10n.errorLoadingNewItemsMessage,
              style: ctx.textStyles.labelMed,
            ),
            SizedBox(height: ctx.h(1)),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: widget.cubit.loadMore,
                child: Text(
                  l10n.retryButton,
                  style: ctx.textStyles.titleMed.semibold,
                ),
              ),
            ),
            SizedBox(height: ctx.h(1)),
          ],
        ),
      ),
      _ => const SizedBox.shrink(),
    };
  }
}
