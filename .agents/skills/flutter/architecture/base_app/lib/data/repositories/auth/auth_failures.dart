enum AuthFailure implements Exception {
  unauthorized, // 401
  forbidden, // 403 — cuenta no verificada
  client, // 400
  server, // 500
  network,
  timeout,
  unknown,
  invalidForm, // validación client-side fallida
}
