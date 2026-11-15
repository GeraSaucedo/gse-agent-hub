enum AuthFailure implements Exception {
  /// 401: wrong credentials.
  unauthorized,

  /// 403: account not verified.
  forbidden,

  /// 400: invalid request.
  client,
  server,
  network,
  timeout,
  unknown,

  /// Client-side form validation failed.
  invalidForm,
}
