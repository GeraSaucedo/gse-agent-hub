// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appName => 'GSE App';

  @override
  String get title => 'Bienvenido';

  @override
  String get subtitle => 'Inicia sesión para continuar';

  @override
  String greeting(String name) {
    return 'Hola $name';
  }

  @override
  String itemCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count elementos',
      one: '1 elemento',
      zero: 'Sin elementos',
    );
    return '$_temp0';
  }

  @override
  String get loginScreenForgotPassword => '¿Olvidaste tu contraseña?';

  @override
  String get loginScreenUsernameHint => 'Usuario';

  @override
  String get loginScreenPasswordHint => 'Contraseña';

  @override
  String get forgotPasswordUsernameSubtitle =>
      'Ingresa tu usuario para recuperar tu contraseña';

  @override
  String get forgotPasswordEmailSubtitle =>
      'Ingresa tu correo para recuperar tu contraseña';

  @override
  String get forgotPasswordSendButton => 'Enviar código';

  @override
  String get forgotPasswordCheckEmailTitle => 'Revisa tu correo';

  @override
  String get forgotPasswordCheckEmailSubtitle =>
      'Ingresa el código de verificación enviado a tu correo';

  @override
  String get forgotPasswordCodeHint => 'Código de verificación';

  @override
  String get forgotPasswordContinueButton => 'Continuar';

  @override
  String get forgotPasswordDidNotReceiveCode => '¿No recibiste el código? ';

  @override
  String forgotPasswordResendIn(int seconds) {
    return 'Reenviar en ${seconds}s';
  }

  @override
  String get forgotPasswordResendEmail => 'Reenviar';

  @override
  String get forgotPasswordChangeTitle => 'Cambiar contraseña';

  @override
  String get forgotPasswordChangeSubtitle => 'Ingresa tu nueva contraseña';

  @override
  String get forgotPasswordNewPasswordHint => 'Nueva contraseña';

  @override
  String get forgotPasswordConfirmPasswordHint => 'Confirmar contraseña';

  @override
  String get forgotPasswordRequirements =>
      'La contraseña debe tener al menos 8 caracteres, mayúscula, minúscula, número y carácter especial';

  @override
  String get forgotPasswordUpdateButton => 'Actualizar contraseña';

  @override
  String get forgotPasswordUpdateSuccess =>
      'Contraseña actualizada correctamente';

  @override
  String get forgotPasswordInvalidForm =>
      'Por favor completa el formulario correctamente';

  @override
  String get forgotPasswordEmptyUsername => 'Por favor ingresa tu usuario';

  @override
  String get loginFailureInvalidCredentials =>
      'Correo o contraseña incorrectos';

  @override
  String get loginFailureInvalidForm =>
      'Por favor ingresa tu correo y contraseña';

  @override
  String get loginFailureConnectionTimeout =>
      'La conexión tardó demasiado. Intenta de nuevo';

  @override
  String get loginFailureUserNotFound => 'Usuario no encontrado';

  @override
  String get genericServerFailureError =>
      'Error del servidor. Intenta de nuevo';

  @override
  String get genericNetworkFailureError => 'Sin conexión a internet';

  @override
  String get genericUnknownFailureError =>
      'Error desconocido. Intenta de nuevo';

  @override
  String get verifyEmailTitle => 'Verifica tu correo';

  @override
  String get verifyEmailSubtitle =>
      'Ingresa el código de verificación enviado a tu correo electrónico';

  @override
  String get verifyEmailCodeHint => 'Código de verificación';

  @override
  String get verifyEmailVerifyButton => 'Verificar';

  @override
  String get verifyEmailDidNotReceiveCode => '¿No recibiste el código? ';

  @override
  String verifyEmailResendIn(int seconds) {
    return 'Reenviar en ${seconds}s';
  }

  @override
  String get verifyEmailResendEmail => 'Reenviar correo';

  @override
  String get verifyEmailInvalidCode => 'Código incorrecto o expirado';

  @override
  String get loginRegisterButton => 'Regístrate';

  @override
  String get registerTitle => 'Crear cuenta';

  @override
  String get registerSubtitle => 'Ingresa tus datos para crear tu cuenta';

  @override
  String get registerNameHint => 'Nombre completo';

  @override
  String get registerButton => 'Registrarse';

  @override
  String get registerAlreadyHaveAccount => '¿Ya tienes cuenta? ';

  @override
  String get registerLoginLink => 'Inicia sesión';

  @override
  String get registerFailureEmailAlreadyExists =>
      'Este correo ya está registrado';

  @override
  String get registerFailureInvalidData =>
      'Datos inválidos. Verifica tu información';

  @override
  String get loginScreenTitle => 'Inicio de sesión';

  @override
  String get loginScreenSubtitle =>
      'Es necesario que tengas una cuenta de colaborador.';

  @override
  String get loginScreenLoginButton => 'Ingresar';

  @override
  String get dialogCancelButton => 'Cancelar';

  @override
  String get dialogAcceptButton => 'Aceptar';

  @override
  String get logoutButton => 'Cerrar sesión';

  @override
  String get emailHint => 'Correo electrónico';

  @override
  String get emptyStateMessage => 'No se encontraron elementos';

  @override
  String get retryButton => 'Reintentar';

  @override
  String get errorLoadingElementsMessage =>
      'No se pudieron\nobtener los elementos';

  @override
  String get errorServerConnectionMessage =>
      'No fue posible\nconectar con el servidor';

  @override
  String get errorLoadingNewItemsMessage =>
      'Ocurrió un error al cargar nuevos elementos';

  @override
  String get selectElementTitle => 'Seleccionar elemento';

  @override
  String get searchHint => 'Buscar...';

  @override
  String get addArticleButton => 'Añadir artículo';

  @override
  String get classificationSelectionTitle => 'Selección de clasificación';

  @override
  String get imageLoadError => 'Error al cargar la imagen';

  @override
  String get serverConnectionError => 'Error al conectar con el servidor';

  @override
  String get selectorErrorMessage =>
      'Ocurrió un error al obtener los datos, inténtelo de nuevo';

  @override
  String get navigationPlaceholder => 'Navegación 3';

  @override
  String get dsTitle => 'Design System';

  @override
  String get dsTypography => 'Tipografía';

  @override
  String get dsWeights => 'Pesos';

  @override
  String get dsTextStyles => 'Estilos de texto';

  @override
  String get dsColors => 'Colores';

  @override
  String get dsOpacity => 'Opacidad';

  @override
  String get dsSpacing => 'Espaciado';

  @override
  String get dsBorderRadius => 'Border Radius';

  @override
  String get dsComponents => 'Componentes';

  @override
  String get dsExampleText => 'Ejemplo de texto';

  @override
  String dsWeightLabel(String name) {
    return 'Peso $name';
  }

  @override
  String get dsItalicText => 'Texto en itálica';

  @override
  String get dsUnderlineText => 'Texto subrayado';

  @override
  String get dsStrikethroughText => 'Texto tachado';

  @override
  String get dsCombinations => 'Combinaciones';

  @override
  String get dsSurfaces => 'Superficies';

  @override
  String get dsTextGroup => 'Texto';

  @override
  String get dsBrand => 'Marca';

  @override
  String get dsStateGroup => 'Estado';

  @override
  String get dsSemantic => 'Semántico';

  @override
  String get dsCardDescription =>
      'Superficie para agrupar contenido relacionado.';

  @override
  String get dsTextFieldHint => 'Ingresa texto...';

  @override
  String get dsActiveState => 'estado activo';

  @override
  String get languageScreenTitle => 'Idioma';

  @override
  String get languageSpanish => 'Español';

  @override
  String get languageEnglish => 'Inglés';

  @override
  String get onboardingSkip => 'Omitir';

  @override
  String get onboardingNext => 'Siguiente';

  @override
  String get onboardingBack => 'Regresar';

  @override
  String get onboardingStart => 'Comenzar';

  @override
  String get onboardingTitle1 => 'Bienvenido';

  @override
  String get onboardingDescription1 =>
      'Descubre todo lo que esta aplicación tiene para ofrecerte.';

  @override
  String get onboardingTitle2 => 'Seguro y confiable';

  @override
  String get onboardingDescription2 =>
      'Tu información está protegida con los más altos estándares de seguridad.';

  @override
  String get onboardingTitle3 => 'Todo listo';

  @override
  String get onboardingDescription3 =>
      'Estás a un paso de comenzar. ¡Crea tu cuenta o inicia sesión!';

  @override
  String get sessionExpiredTitle => 'Sesión expirada';

  @override
  String get sessionExpiredMessage =>
      'Tu sesión ha expirado. Inicia sesión nuevamente para continuar.';

  @override
  String get sessionExpiredAction => 'Iniciar sesión';
}
