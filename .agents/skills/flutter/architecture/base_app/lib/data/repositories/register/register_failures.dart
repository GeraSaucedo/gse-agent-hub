enum RegisterFailure implements Exception {
  emailAlreadyExists,
  invalidData,
  server,
  network,
  unknown,

  /// Registered and verified, but the automatic login failed.
  /// The user must log in manually.
  autoLoginFailed,
}
