import 'package:gse_base_app/core/services/api/dio_client.dart';
import 'package:gse_base_app/core/services/logger/app_logger.dart';
import 'package:gse_base_app/domain/models/example_model.dart';

class ExampleRepository {
  ExampleRepository({
    required ApiClient apiClient,
  }) : _api = apiClient;

  final ApiClient _api;

  static const _baseUrl = 'https://dummyjson.com';

  Future<List<ExampleModel>> getProducts({
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

      return results
          .map((e) => ExampleModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (e, stack) {
      AppLogger.e(
        'getProducts Error',
        error: e,
        stackTrace: stack,
      );
      rethrow;
    }
  }

  Future<ExampleModel> getProductById(String id) async {
    try {
      final data = await _api.get<Map<String, dynamic>>(
        '$_baseUrl/products/$id',
      );

      return ExampleModel.fromJson(data);
    } catch (e, stack) {
      AppLogger.e(
        'getProductById Error',
        error: e,
        stackTrace: stack,
      );
      rethrow;
    }
  }

  Future<ExampleModel> createProduct({
    required String title,
  }) async {
    try {
      final data = await _api.post<Map<String, dynamic>>(
        '$_baseUrl/products/add',
        data: {'title': title},
      );

      return ExampleModel.fromJson(data);
    } catch (e, stack) {
      AppLogger.e(
        'createProduct Error',
        error: e,
        stackTrace: stack,
      );
      rethrow;
    }
  }

  Future<ExampleModel> updateProduct({
    required String id,
    required String title,
  }) async {
    try {
      final data = await _api.put<Map<String, dynamic>>(
        '$_baseUrl/products/$id',
        data: {'title': title},
      );

      return ExampleModel.fromJson(data);
    } catch (e, stack) {
      AppLogger.e(
        'updateProduct Error',
        error: e,
        stackTrace: stack,
      );
      rethrow;
    }
  }

  Future<ExampleModel> deleteProduct(String id) async {
    try {
      final data = await _api.delete<Map<String, dynamic>>(
        '$_baseUrl/products/$id',
      );

      return ExampleModel.fromJson(data);
    } catch (e, stack) {
      AppLogger.e(
        'deleteProduct Error',
        error: e,
        stackTrace: stack,
      );
      rethrow;
    }
  }
}
