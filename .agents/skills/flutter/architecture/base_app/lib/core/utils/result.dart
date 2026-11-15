/// Outcome of an operation that can fail: [Success] or [Failure].
///
/// Rules:
/// - Repositories return `Result` and never throw. `try/catch` lives
///   **only** in the repository.
/// - [E] is the feature failure enum (e.g. `RegisterFailure`), never a
///   Dio or API type.
/// - For methods without a value, use `Result<void, E>` and
///   `return const Success(null);`.
///
/// Repository:
/// ```dart
/// Future<Result<User, ProfileFailure>> getProfile() async {
///   try {
///     final data = await _api.get<Map<String, dynamic>>('/profile');
///     return Success(User.fromJson(data));
///   } catch (e, stack) {
///     AppLogger.e('ProfileRepository', error: e, stackTrace: stack);
///     return Failure(switch (e) {
///       NetworkException() => ProfileFailure.network,
///       ApiHttpException(statusCode: 404) => ProfileFailure.notFound,
///       _ => ProfileFailure.unknown,
///     });
///   }
/// }
/// ```
///
/// Bloc / cubit (no `try/catch`):
/// ```dart
/// switch (await _repository.getProfile()) {
///   case Success(:final value):
///     emit(state.copyWith(user: value));
///   case Failure(:final exception):
///     emit(state.copyWith(failure: exception));
/// }
/// ```
sealed class Result<S, E extends Exception> {
  const new();
}

final class Success<S, E extends Exception> extends Result<S, E> {
  const new(this.value);
  final S value;
}

final class Failure<S, E extends Exception> extends Result<S, E> {
  const new(this.exception);
  final E exception;
}
