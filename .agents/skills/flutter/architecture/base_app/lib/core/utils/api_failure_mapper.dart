import 'package:gse_base_app/core/services/api/error_mapping.dart';
import 'package:gse_base_app/core/utils/result.dart';

/// Maps an error thrown by `ApiClient` to a typed repository failure.
///
/// `ApiClient` already converts every `DioException` into an [ApiException],
/// so repositories must match on [ApiException], never on `DioException`.
Result<Never, E> mapApiErrorToFailure<E extends Exception>(
  Object error, {
  required E networkError,
  required E serverError,
  required E unknownError,
  Map<int, E>? statusOverrides,
}) {
  if (error is NoInternetException ||
      error is ApiTimeoutException ||
      error is NetworkException) {
    return Failure(networkError);
  }

  if (error is ApiException) {
    final status = error.statusCode;
    if (status != null) {
      final override = statusOverrides?[status];
      if (override != null) return Failure(override);
      if (status >= 500) return Failure(serverError);
    }
  }

  return Failure(unknownError);
}
