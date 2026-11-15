enum RecoveryCodeFailure implements Exception {
  server,
  network,
  unknown,
  userNotFound,
  emptyUsername,
  invalidForm,
}
