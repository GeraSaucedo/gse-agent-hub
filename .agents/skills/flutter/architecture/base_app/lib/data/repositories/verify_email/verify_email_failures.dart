enum VerifyEmailFailure implements Exception {
  serverError,
  networkError,
  unknownError,
  invalidCode,
}
