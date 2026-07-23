enum RecoveryCodeFailure implements Exception {
  serverError,
  networkError,
  unknownError,
  userNotFound,
  emptyUsername,
  invalidForm,
}
