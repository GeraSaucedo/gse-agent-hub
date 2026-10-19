import 'package:gse_base_app/core/services/api/dio_client.dart';
import 'package:gse_base_app/core/services/logger/app_logger.dart';
import 'package:gse_base_app/core/utils/api_failure_mapper.dart';
import 'package:gse_base_app/core/utils/result.dart';
import 'package:gse_base_app/data/repositories/example/example_failures.dart';
import 'package:gse_base_app/domain/models/example_model.dart';

const String _repositoryName = 'ExampleRepository';

/// Reference repository (public demo API). It follows the same rules as every
/// real repository: methods return a [Result] with a typed failure and never
/// throw to the UI.
class ExampleRepository {
  ExampleRepository({
    required ApiClient apiClient,
  }) : _api = apiClient;

  final ApiClient _api;

  // Demo-only host so the example works without a backend. Real repositories
  // build their URLs from `EnvConfig.apiUrl`.
  static const _baseUrl = 'https://dummyjson.com';

  Failure<S, ExampleFailure> _failure<S>(
    String method,
    Object e,
    StackTrace s,
  ) {
    AppLogger.e('$_repositoryName.$method', error: e, stackTrace: s);
    final result = mapApiErrorToFailure(
      e,
      networkError: ExampleFailure.networkError,
      serverError: ExampleFailure.serverError,
      unknownError: ExampleFailure.unknownError,
      statusOverrides: {404: ExampleFailure.notFound},
    );
    return Failure<S, ExampleFailure>(
      (result as Failure<Never, ExampleFailure>).exception,
    );
  }

  Future<Result<List<ExampleModel>, ExampleFailure>> getProducts({
    int page = 0,
    int pageSize = 20,
    String? searchQuery,
  }) async {
    try {
      final data = await _api.get<Map<String, dynamic>>(
        '$_baseUrl/products/search',
        queryParameters: {
          'q': searchQuery ?? '',
          'limit': pageSize,
          'skip': page * pageSize,
        },
      );
      final results = data['products'] as List<dynamic>;
      return Success(
        results
            .map((e) => ExampleModel.fromJson(e as Map<String, dynamic>))
            .toList(),
      );
    } catch (e, stack) {
      return _failure('getProducts', e, stack);
    }
  }

  Future<Result<ExampleModel, ExampleFailure>> getProductById(String id) async {
    try {
      final data = await _api.get<Map<String, dynamic>>(
        '$_baseUrl/products/$id',
      );
      return Success(ExampleModel.fromJson(data));
    } catch (e, stack) {
      return _failure('getProductById', e, stack);
    }
  }

  Future<Result<ExampleModel, ExampleFailure>> createProduct({
    required String title,
  }) async {
    try {
      final data = await _api.post<Map<String, dynamic>>(
        '$_baseUrl/products/add',
        data: {'title': title},
      );
      return Success(ExampleModel.fromJson(data));
    } catch (e, stack) {
      return _failure('createProduct', e, stack);
    }
  }

  Future<Result<ExampleModel, ExampleFailure>> updateProduct({
    required String id,
    required String title,
  }) async {
    try {
      final data = await _api.put<Map<String, dynamic>>(
        '$_baseUrl/products/$id',
        data: {'title': title},
      );
      return Success(ExampleModel.fromJson(data));
    } catch (e, stack) {
      return _failure('updateProduct', e, stack);
    }
  }

  Future<Result<ExampleModel, ExampleFailure>> deleteProduct(String id) async {
    try {
      final data = await _api.delete<Map<String, dynamic>>(
        '$_baseUrl/products/$id',
      );
      return Success(ExampleModel.fromJson(data));
    } catch (e, stack) {
      return _failure('deleteProduct', e, stack);
    }
  }
}
