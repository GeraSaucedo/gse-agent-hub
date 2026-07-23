import 'package:flutter/foundation.dart' show immutable, listEquals;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gse_base_app/core/services/logger/app_logger.dart';

part 'pagination_state.dart';

class PaginationCubit<T> extends Cubit<PaginationState<T>> {
  PaginationCubit({
    required Future<List<T>> Function(
      int page,
      int pageSize,
      PaginationParams params,
    ) fetchPage,
    this.pageSize = 20,
    this.firstPage = 0,
    bool Function(List<T> newItems, int pageSize)? getHasMore,
  }) : _fetchPage = fetchPage,
       _getHasMore = getHasMore ?? _defaultHasMore,
       super(
         PaginationState<T>(
           items: const [],
           status: PaginationStatus.initial,
           nextPage: firstPage,
           hasMore: true,
           params: const PaginationParams(),
         ),
       );

  final Future<List<T>> Function(
    int page,
    int pageSize,
    PaginationParams params,
  ) _fetchPage;
  final bool Function(List<T> newItems, int pageSize) _getHasMore;
  final int pageSize;
  final int firstPage;

  static bool _defaultHasMore<T>(List<T> items, int size) =>
      items.length >= size;

  Future<void> loadMore() async {
    final s = state;
    final isLoading =
        s.status == PaginationStatus.loading ||
        s.status == PaginationStatus.loadingMore;
    if (isLoading || !s.hasMore) return;

    final isFirstLoad =
        s.status == PaginationStatus.initial ||
        s.status == PaginationStatus.error;

    emit(
      s.copyWith(
        status:
            isFirstLoad
                ? PaginationStatus.loading
                : PaginationStatus.loadingMore,
        error: null,
      ),
    );

    try {
      final newItems = await _fetchPage(s.nextPage, pageSize, s.params);
      final allItems = isFirstLoad ? newItems : [...s.items, ...newItems];

      emit(
        state.copyWith(
          status: PaginationStatus.loaded,
          items: allItems,
          nextPage: s.nextPage + 1,
          hasMore: _getHasMore(newItems, pageSize),
          error: null,
        ),
      );
    } catch (e, stack) {
      AppLogger.e(
        'PaginationCubit error loading page',
        error: e,
        stackTrace: stack,
      );
      emit(
        state.copyWith(
          status:
              isFirstLoad
                  ? PaginationStatus.error
                  : PaginationStatus.errorMore,
          error: e,
        ),
      );
    }
  }

  PaginationState<T> _resetState({PaginationParams? params}) =>
      PaginationState<T>(
        items: const [],
        status: PaginationStatus.initial,
        nextPage: firstPage,
        hasMore: true,
        params: params ?? state.params,
      );

  Future<void> refresh() async {
    emit(_resetState());
    await loadMore();
  }

  Future<void> search(String query) async {
    final newParams = state.params.copyWith(
      searchQuery: query.isEmpty ? null : query,
    );
    emit(_resetState(params: newParams));
    await loadMore();
  }

  Future<void> filter(Map<String, dynamic> filters) async {
    final newParams = state.params.copyWith(filters: filters);
    emit(_resetState(params: newParams));
    await loadMore();
  }

  void addItem(T item, {bool atStart = false}) {
    final updated =
        atStart ? [item, ...state.items] : [...state.items, item];
    emit(state.copyWith(items: updated));
  }

  void removeItem(bool Function(T item) predicate) {
    final updated =
        state.items.where((item) => !predicate(item)).toList();
    emit(state.copyWith(items: updated));
  }

  void updateItem(
    bool Function(T item) predicate,
    T Function(T item) updater,
  ) {
    final updated =
        state.items
            .map((item) => predicate(item) ? updater(item) : item)
            .toList();
    emit(state.copyWith(items: updated));
  }
}
