part of 'pagination_cubit.dart';

enum PaginationStatus {
  initial,
  loading,
  loaded,
  loadingMore,
  error,
  errorMore,
}

@immutable
class PaginationParams {
  const PaginationParams({this.searchQuery, this.filters});

  final String? searchQuery;
  final Map<String, dynamic>? filters;

  static const Object _undefined = Object();

  PaginationParams copyWith({
    Object? searchQuery = _undefined,
    Object? filters = _undefined,
  }) {
    return PaginationParams(
      searchQuery:
          identical(searchQuery, _undefined)
              ? this.searchQuery
              : searchQuery as String?,
      filters:
          identical(filters, _undefined)
              ? this.filters
              : filters as Map<String, dynamic>?,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PaginationParams &&
          searchQuery == other.searchQuery &&
          _mapsEqual(filters, other.filters);

  @override
  int get hashCode => Object.hash(searchQuery, filters);

  static bool _mapsEqual(
    Map<String, dynamic>? a,
    Map<String, dynamic>? b,
  ) {
    if (identical(a, b)) return true;
    if (a == null || b == null) return false;
    if (a.length != b.length) return false;
    for (final key in a.keys) {
      if (!b.containsKey(key) || a[key] != b[key]) return false;
    }
    return true;
  }
}

@immutable
class PaginationState<T> {
  const PaginationState({
    required this.items,
    required this.status,
    required this.nextPage,
    required this.hasMore,
    required this.params,
    this.error,
  });

  factory PaginationState.initial() => PaginationState<T>(
    items: const [],
    status: PaginationStatus.initial,
    nextPage: 0,
    hasMore: true,
    params: const PaginationParams(),
  );

  final List<T> items;
  final PaginationStatus status;
  final int nextPage;
  final bool hasMore;
  final PaginationParams params;
  final Object? error;

  static const Object _undefined = Object();

  PaginationState<T> copyWith({
    List<T>? items,
    PaginationStatus? status,
    int? nextPage,
    bool? hasMore,
    PaginationParams? params,
    Object? error = _undefined,
  }) {
    return PaginationState<T>(
      items: items ?? this.items,
      status: status ?? this.status,
      nextPage: nextPage ?? this.nextPage,
      hasMore: hasMore ?? this.hasMore,
      params: params ?? this.params,
      error: identical(error, _undefined) ? this.error : error,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PaginationState<T> &&
          listEquals(items, other.items) &&
          status == other.status &&
          nextPage == other.nextPage &&
          hasMore == other.hasMore &&
          params == other.params &&
          error == other.error;

  @override
  int get hashCode => Object.hash(
    Object.hashAll(items),
    status,
    nextPage,
    hasMore,
    params,
    error,
  );
}
