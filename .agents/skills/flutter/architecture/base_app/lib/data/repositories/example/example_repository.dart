import 'package:gse_base_app/core/services/api/dio_client.dart';
import 'package:gse_base_app/core/services/api/error_mapping.dart';
import 'package:gse_base_app/core/services/logger/app_logger.dart';
import 'package:gse_base_app/core/utils/result.dart';
import 'package:gse_base_app/data/repositories/example/example_failures.dart';
import 'package:gse_base_app/domain/models/example_model.dart';

/// Reference repository: copy this pattern for new features.
///
/// - Every public method returns a [Result] and never throws.
/// - `try/catch` lives only here; blocs/cubits just `switch` on the result.
class ExampleRepository {
  new({
    required ApiClient apiClient,
  }) : _api = apiClient;

  final ApiClient _api;

  static const _baseUrl = 'https://dummyjson.com';

  Future<Result<List<ExampleModel>, ExampleFailure>> getProducts({
    int page = 0,
    int pageSize = 20,
    String? searchQuery,
  }) async {
    try {
      final skip = page * pageSize;

      final data = await _api.get<Map<String, dynamic>>(
        '$_baseUrl/products/search',
        queryParameters: {
          'q': searchQuery ?? '',
          'limit': pageSize,
          'skip': skip,
        },
      );

      final results = data['products'] as List<dynamic>;

      return Success(
        results
            .map((e) => ExampleModel.fromJson(e as Map<String, dynamic>))
            .toList(),
      );
    } catch (e, stack) {
      AppLogger.e('ExampleRepository.getProducts', error: e, stackTrace: stack);
      return Failure(_toFailure(e));
    }
  }

  Future<Result<ExampleModel, ExampleFailure>> getProductById(String id) async {
    try {
      final data = await _api.get<Map<String, dynamic>>(
        '$_baseUrl/products/$id',
      );

      return Success(ExampleModel.fromJson(data));
    } catch (e, stack) {
      AppLogger.e(
        'ExampleRepository.getProductById',
        error: e,
        stackTrace: stack,
      );
      return Failure(_toFailure(e));
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
      AppLogger.e(
        'ExampleRepository.createProduct',
        error: e,
        stackTrace: stack,
      );
      return Failure(_toFailure(e));
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
      AppLogger.e(
        'ExampleRepository.updateProduct',
        error: e,
        stackTrace: stack,
      );
      return Failure(_toFailure(e));
    }
  }

  Future<Result<ExampleModel, ExampleFailure>> deleteProduct(String id) async {
    try {
      final data = await _api.delete<Map<String, dynamic>>(
        '$_baseUrl/products/$id',
      );

      return Success(ExampleModel.fromJson(data));
    } catch (e, stack) {
      AppLogger.e(
        'ExampleRepository.deleteProduct',
        error: e,
        stackTrace: stack,
      );
      return Failure(_toFailure(e));
    }
  }

  /// When several methods share the same mapping, keep it in one private
  /// function inside the repository.
  ExampleFailure _toFailure(Object e) => switch (e) {
    NetworkException() => ExampleFailure.network,
    ApiHttpException(statusCode: 404) => ExampleFailure.notFound,
    ApiHttpException(statusCode: >= 500) => ExampleFailure.server,
    _ => ExampleFailure.unknown,
  };
}
