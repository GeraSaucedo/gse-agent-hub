enum AuthFailure implements Exception {
  unauthorized, // credenciales inválidas / usuario no encontrado
  userNotConfirmed, // cuenta registrada pero sin verificar el email
  client, // parámetros/contraseña inválidos
  server, // límite excedido / error de servicio
  network,
  timeout,
  cancelled, // el usuario canceló el flujo social (Hosted UI)
  unknown,
  invalidForm, // validación client-side fallida
}
