import 'package:flutter/foundation.dart' show immutable, listEquals;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gse_base_app/core/utils/result.dart';

part 'pagination_state.dart';

class PaginationCubit<T> extends Cubit<PaginationState<T>> {
  new({
    required this._fetchPage,
    this.pageSize = 20,
    this.firstPage = 0,
    bool Function(List<T> newItems, int pageSize)? getHasMore,
  }) : _getHasMore = getHasMore ?? _defaultHasMore,
       super(
         PaginationState<T>(
           items: const [],
           status: PaginationStatus.initial,
           nextPage: firstPage,
           hasMore: true,
           params: const PaginationParams(),
         ),
       );

  /// Usually a repository method, e.g. `ExampleRepository.getProducts`.
  final Future<Result<List<T>, Exception>> Function(
    int page,
    int pageSize,
    PaginationParams params,
  )
  _fetchPage;
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
        status: isFirstLoad
            ? PaginationStatus.loading
            : PaginationStatus.loadingMore,
        error: null,
      ),
    );

    final generation = _generation;
    final result = await _fetchPage(s.nextPage, pageSize, s.params);

    // A refresh/search/filter started while this page was loading: its
    // results belong to the old query, so drop them.
    if (isClosed || generation != _generation) return;

    switch (result) {
      case Success(value: final newItems):
        emit(
          state.copyWith(
            status: PaginationStatus.loaded,
            // `state.items`, not `s.items`: keeps local mutations
            // (addItem/removeItem/updateItem) made while loading.
            items: isFirstLoad ? newItems : [...state.items, ...newItems],
            nextPage: s.nextPage + 1,
            hasMore: _getHasMore(newItems, pageSize),
            error: null,
          ),
        );
      case Failure(:final exception):
        emit(
          state.copyWith(
            status: isFirstLoad
                ? PaginationStatus.error
                : PaginationStatus.errorMore,
            error: exception,
          ),
        );
    }
  }

  /// Bumped on every reset, so in-flight requests can tell they are stale.
  int _generation = 0;

  Future<void> _reset({PaginationParams? params}) async {
    _generation++;
    emit(
      PaginationState<T>(
        items: const [],
        status: PaginationStatus.initial,
        nextPage: firstPage,
        hasMore: true,
        params: params ?? state.params,
      ),
    );
    await loadMore();
  }

  Future<void> refresh() => _reset();

  Future<void> search(String query) => _reset(
    params: state.params.copyWith(searchQuery: query.isEmpty ? null : query),
  );

  Future<void> filter(Map<String, dynamic> filters) =>
      _reset(params: state.params.copyWith(filters: filters));

  void addItem(T item, {bool atStart = false}) {
    final updated = atStart ? [item, ...state.items] : [...state.items, item];
    emit(state.copyWith(items: updated));
  }

  void removeItem(bool Function(T item) predicate) {
    final updated = state.items.where((item) => !predicate(item)).toList();
    emit(state.copyWith(items: updated));
  }

  void updateItem(
    bool Function(T item) predicate,
    T Function(T item) updater,
  ) {
    final updated = state.items
        .map((item) => predicate(item) ? updater(item) : item)
        .toList();
    emit(state.copyWith(items: updated));
  }
}
