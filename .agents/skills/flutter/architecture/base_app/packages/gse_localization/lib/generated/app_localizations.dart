import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_es.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('es'),
  ];

  /// Nombre de la aplicación
  ///
  /// In es, this message translates to:
  /// **'GSE App'**
  String get appName;

  /// Título principal
  ///
  /// In es, this message translates to:
  /// **'Bienvenido'**
  String get title;

  /// Subtítulo principal
  ///
  /// In es, this message translates to:
  /// **'Inicia sesión para continuar'**
  String get subtitle;

  /// Saludo con nombre del usuario
  ///
  /// In es, this message translates to:
  /// **'Hola {name}'**
  String greeting(String name);

  /// Cantidad de elementos con plural
  ///
  /// In es, this message translates to:
  /// **'{count, plural, =0{Sin elementos} =1{1 elemento} other{{count} elementos}}'**
  String itemCount(int count);

  /// Título pantalla olvidé contraseña
  ///
  /// In es, this message translates to:
  /// **'¿Olvidaste tu contraseña?'**
  String get loginScreenForgotPassword;

  /// Hint del campo usuario
  ///
  /// In es, this message translates to:
  /// **'Usuario'**
  String get loginScreenUsernameHint;

  /// Hint del campo contraseña
  ///
  /// In es, this message translates to:
  /// **'Contraseña'**
  String get loginScreenPasswordHint;

  /// Subtítulo de la pantalla de usuario
  ///
  /// In es, this message translates to:
  /// **'Ingresa tu usuario para recuperar tu contraseña'**
  String get forgotPasswordUsernameSubtitle;

  /// Subtítulo de la pantalla de correo
  ///
  /// In es, this message translates to:
  /// **'Ingresa tu correo para recuperar tu contraseña'**
  String get forgotPasswordEmailSubtitle;

  /// Botón para enviar código de recuperación
  ///
  /// In es, this message translates to:
  /// **'Enviar código'**
  String get forgotPasswordSendButton;

  /// Título pantalla de código
  ///
  /// In es, this message translates to:
  /// **'Revisa tu correo'**
  String get forgotPasswordCheckEmailTitle;

  /// Subtítulo pantalla de código
  ///
  /// In es, this message translates to:
  /// **'Ingresa el código de verificación enviado a tu correo'**
  String get forgotPasswordCheckEmailSubtitle;

  /// Hint del campo de código
  ///
  /// In es, this message translates to:
  /// **'Código de verificación'**
  String get forgotPasswordCodeHint;

  /// Botón continuar
  ///
  /// In es, this message translates to:
  /// **'Continuar'**
  String get forgotPasswordContinueButton;

  /// Texto antes del botón de reenviar
  ///
  /// In es, this message translates to:
  /// **'¿No recibiste el código? '**
  String get forgotPasswordDidNotReceiveCode;

  /// Texto de espera para reenviar
  ///
  /// In es, this message translates to:
  /// **'Reenviar en {seconds}s'**
  String forgotPasswordResendIn(int seconds);

  /// Botón para reenviar el código
  ///
  /// In es, this message translates to:
  /// **'Reenviar'**
  String get forgotPasswordResendEmail;

  /// Título pantalla de nueva contraseña
  ///
  /// In es, this message translates to:
  /// **'Cambiar contraseña'**
  String get forgotPasswordChangeTitle;

  /// Subtítulo pantalla de nueva contraseña
  ///
  /// In es, this message translates to:
  /// **'Ingresa tu nueva contraseña'**
  String get forgotPasswordChangeSubtitle;

  /// Hint del campo nueva contraseña
  ///
  /// In es, this message translates to:
  /// **'Nueva contraseña'**
  String get forgotPasswordNewPasswordHint;

  /// Hint del campo confirmar contraseña
  ///
  /// In es, this message translates to:
  /// **'Confirmar contraseña'**
  String get forgotPasswordConfirmPasswordHint;

  /// Requisitos de la contraseña
  ///
  /// In es, this message translates to:
  /// **'La contraseña debe tener al menos 8 caracteres, mayúscula, minúscula, número y carácter especial'**
  String get forgotPasswordRequirements;

  /// Botón actualizar contraseña
  ///
  /// In es, this message translates to:
  /// **'Actualizar contraseña'**
  String get forgotPasswordUpdateButton;

  /// Mensaje de éxito al actualizar contraseña
  ///
  /// In es, this message translates to:
  /// **'Contraseña actualizada correctamente'**
  String get forgotPasswordUpdateSuccess;

  /// Error de formulario inválido
  ///
  /// In es, this message translates to:
  /// **'Por favor completa el formulario correctamente'**
  String get forgotPasswordInvalidForm;

  /// Error de usuario vacío en recuperación de contraseña
  ///
  /// In es, this message translates to:
  /// **'Por favor ingresa tu usuario'**
  String get forgotPasswordEmptyUsername;

  /// Error de credenciales inválidas en login
  ///
  /// In es, this message translates to:
  /// **'Correo o contraseña incorrectos'**
  String get loginFailureInvalidCredentials;

  /// Error de formulario incompleto en login
  ///
  /// In es, this message translates to:
  /// **'Por favor ingresa tu correo y contraseña'**
  String get loginFailureInvalidForm;

  /// Error de timeout en login
  ///
  /// In es, this message translates to:
  /// **'La conexión tardó demasiado. Intenta de nuevo'**
  String get loginFailureConnectionTimeout;

  /// Error usuario no encontrado
  ///
  /// In es, this message translates to:
  /// **'Usuario no encontrado'**
  String get loginFailureUserNotFound;

  /// Error genérico de servidor
  ///
  /// In es, this message translates to:
  /// **'Error del servidor. Intenta de nuevo'**
  String get genericServerFailureError;

  /// Error de red
  ///
  /// In es, this message translates to:
  /// **'Sin conexión a internet'**
  String get genericNetworkFailureError;

  /// Error desconocido
  ///
  /// In es, this message translates to:
  /// **'Error desconocido. Intenta de nuevo'**
  String get genericUnknownFailureError;

  /// Título de la pantalla de verificación de correo
  ///
  /// In es, this message translates to:
  /// **'Verifica tu correo'**
  String get verifyEmailTitle;

  /// Subtítulo de la pantalla de verificación de correo
  ///
  /// In es, this message translates to:
  /// **'Ingresa el código de verificación enviado a tu correo electrónico'**
  String get verifyEmailSubtitle;

  /// Hint del campo de código de verificación
  ///
  /// In es, this message translates to:
  /// **'Código de verificación'**
  String get verifyEmailCodeHint;

  /// Botón para verificar el código
  ///
  /// In es, this message translates to:
  /// **'Verificar'**
  String get verifyEmailVerifyButton;

  /// Texto antes del botón de reenviar en verificación de correo
  ///
  /// In es, this message translates to:
  /// **'¿No recibiste el código? '**
  String get verifyEmailDidNotReceiveCode;

  /// Texto de espera para reenviar en verificación de correo
  ///
  /// In es, this message translates to:
  /// **'Reenviar en {seconds}s'**
  String verifyEmailResendIn(int seconds);

  /// Botón para reenviar el correo de verificación
  ///
  /// In es, this message translates to:
  /// **'Reenviar correo'**
  String get verifyEmailResendEmail;

  /// Error de código inválido en verificación de correo
  ///
  /// In es, this message translates to:
  /// **'Código incorrecto o expirado'**
  String get verifyEmailInvalidCode;

  /// Botón de registro en la pantalla de login
  ///
  /// In es, this message translates to:
  /// **'Regístrate'**
  String get loginRegisterButton;

  /// Título de la pantalla de registro
  ///
  /// In es, this message translates to:
  /// **'Crear cuenta'**
  String get registerTitle;

  /// Subtítulo de la pantalla de registro
  ///
  /// In es, this message translates to:
  /// **'Ingresa tus datos para crear tu cuenta'**
  String get registerSubtitle;

  /// Hint del campo nombre en registro
  ///
  /// In es, this message translates to:
  /// **'Nombre completo'**
  String get registerNameHint;

  /// Botón para registrarse
  ///
  /// In es, this message translates to:
  /// **'Registrarse'**
  String get registerButton;

  /// Texto antes del enlace de inicio de sesión en registro
  ///
  /// In es, this message translates to:
  /// **'¿Ya tienes cuenta? '**
  String get registerAlreadyHaveAccount;

  /// Enlace para ir a iniciar sesión desde registro
  ///
  /// In es, this message translates to:
  /// **'Inicia sesión'**
  String get registerLoginLink;

  /// Error cuando el correo ya existe en registro
  ///
  /// In es, this message translates to:
  /// **'Este correo ya está registrado'**
  String get registerFailureEmailAlreadyExists;

  /// Error de datos inválidos en registro
  ///
  /// In es, this message translates to:
  /// **'Datos inválidos. Verifica tu información'**
  String get registerFailureInvalidData;

  /// Título de la pantalla de login
  ///
  /// In es, this message translates to:
  /// **'Inicio de sesión'**
  String get loginScreenTitle;

  /// Subtítulo de la pantalla de login
  ///
  /// In es, this message translates to:
  /// **'Es necesario que tengas una cuenta de colaborador.'**
  String get loginScreenSubtitle;

  /// Botón de inicio de sesión
  ///
  /// In es, this message translates to:
  /// **'Ingresar'**
  String get loginScreenLoginButton;

  /// Botón cancelar en diálogos
  ///
  /// In es, this message translates to:
  /// **'Cancelar'**
  String get dialogCancelButton;

  /// Botón aceptar en diálogos
  ///
  /// In es, this message translates to:
  /// **'Aceptar'**
  String get dialogAcceptButton;

  /// Botón de cerrar sesión
  ///
  /// In es, this message translates to:
  /// **'Cerrar sesión'**
  String get logoutButton;

  /// Hint del campo de correo electrónico
  ///
  /// In es, this message translates to:
  /// **'Correo electrónico'**
  String get emailHint;

  /// Mensaje cuando no hay elementos
  ///
  /// In es, this message translates to:
  /// **'No se encontraron elementos'**
  String get emptyStateMessage;

  /// Botón de reintentar
  ///
  /// In es, this message translates to:
  /// **'Reintentar'**
  String get retryButton;

  /// Error al obtener elementos
  ///
  /// In es, this message translates to:
  /// **'No se pudieron\nobtener los elementos'**
  String get errorLoadingElementsMessage;

  /// Error de conexión con el servidor
  ///
  /// In es, this message translates to:
  /// **'No fue posible\nconectar con el servidor'**
  String get errorServerConnectionMessage;

  /// Error al cargar nuevos elementos en lista paginada
  ///
  /// In es, this message translates to:
  /// **'Ocurrió un error al cargar nuevos elementos'**
  String get errorLoadingNewItemsMessage;

  /// Título por defecto de selector
  ///
  /// In es, this message translates to:
  /// **'Seleccionar elemento'**
  String get selectElementTitle;

  /// Hint del campo de búsqueda
  ///
  /// In es, this message translates to:
  /// **'Buscar...'**
  String get searchHint;

  /// Botón de añadir artículo
  ///
  /// In es, this message translates to:
  /// **'Añadir artículo'**
  String get addArticleButton;

  /// Título del selector de clasificación
  ///
  /// In es, this message translates to:
  /// **'Selección de clasificación'**
  String get classificationSelectionTitle;

  /// Error al cargar imagen de red
  ///
  /// In es, this message translates to:
  /// **'Error al cargar la imagen'**
  String get imageLoadError;

  /// Error de conexión con el servidor
  ///
  /// In es, this message translates to:
  /// **'Error al conectar con el servidor'**
  String get serverConnectionError;

  /// Error en selectores al obtener datos
  ///
  /// In es, this message translates to:
  /// **'Ocurrió un error al obtener los datos, inténtelo de nuevo'**
  String get selectorErrorMessage;

  /// Placeholder de navegación en drawer
  ///
  /// In es, this message translates to:
  /// **'Navegación 3'**
  String get navigationPlaceholder;

  /// Título de la pantalla del design system
  ///
  /// In es, this message translates to:
  /// **'Design System'**
  String get dsTitle;

  /// Sección de tipografía
  ///
  /// In es, this message translates to:
  /// **'Tipografía'**
  String get dsTypography;

  /// Sección de pesos tipográficos
  ///
  /// In es, this message translates to:
  /// **'Pesos'**
  String get dsWeights;

  /// Sección de estilos de texto
  ///
  /// In es, this message translates to:
  /// **'Estilos de texto'**
  String get dsTextStyles;

  /// Sección de colores
  ///
  /// In es, this message translates to:
  /// **'Colores'**
  String get dsColors;

  /// Sección de opacidad
  ///
  /// In es, this message translates to:
  /// **'Opacidad'**
  String get dsOpacity;

  /// Sección de espaciado
  ///
  /// In es, this message translates to:
  /// **'Espaciado'**
  String get dsSpacing;

  /// Sección de border radius
  ///
  /// In es, this message translates to:
  /// **'Border Radius'**
  String get dsBorderRadius;

  /// Sección de componentes
  ///
  /// In es, this message translates to:
  /// **'Componentes'**
  String get dsComponents;

  /// Texto de ejemplo en tipografía
  ///
  /// In es, this message translates to:
  /// **'Ejemplo de texto'**
  String get dsExampleText;

  /// Etiqueta de peso tipográfico
  ///
  /// In es, this message translates to:
  /// **'Peso {name}'**
  String dsWeightLabel(String name);

  /// Texto de ejemplo en itálica
  ///
  /// In es, this message translates to:
  /// **'Texto en itálica'**
  String get dsItalicText;

  /// Texto de ejemplo subrayado
  ///
  /// In es, this message translates to:
  /// **'Texto subrayado'**
  String get dsUnderlineText;

  /// Texto de ejemplo tachado
  ///
  /// In es, this message translates to:
  /// **'Texto tachado'**
  String get dsStrikethroughText;

  /// Sección de combinaciones de estilos
  ///
  /// In es, this message translates to:
  /// **'Combinaciones'**
  String get dsCombinations;

  /// Grupo de colores de superficies
  ///
  /// In es, this message translates to:
  /// **'Superficies'**
  String get dsSurfaces;

  /// Grupo de colores de texto
  ///
  /// In es, this message translates to:
  /// **'Texto'**
  String get dsTextGroup;

  /// Grupo de colores de marca
  ///
  /// In es, this message translates to:
  /// **'Marca'**
  String get dsBrand;

  /// Grupo de colores de estado
  ///
  /// In es, this message translates to:
  /// **'Estado'**
  String get dsStateGroup;

  /// Grupo de colores semánticos
  ///
  /// In es, this message translates to:
  /// **'Semántico'**
  String get dsSemantic;

  /// Descripción del componente Card
  ///
  /// In es, this message translates to:
  /// **'Superficie para agrupar contenido relacionado.'**
  String get dsCardDescription;

  /// Hint del TextField en demo
  ///
  /// In es, this message translates to:
  /// **'Ingresa texto...'**
  String get dsTextFieldHint;

  /// Texto de ejemplo de estado activo
  ///
  /// In es, this message translates to:
  /// **'estado activo'**
  String get dsActiveState;

  /// Título de la pantalla de selección de idioma
  ///
  /// In es, this message translates to:
  /// **'Idioma'**
  String get languageScreenTitle;

  /// Nombre del idioma español
  ///
  /// In es, this message translates to:
  /// **'Español'**
  String get languageSpanish;

  /// Nombre del idioma inglés
  ///
  /// In es, this message translates to:
  /// **'Inglés'**
  String get languageEnglish;

  /// Botón para omitir el onboarding
  ///
  /// In es, this message translates to:
  /// **'Omitir'**
  String get onboardingSkip;

  /// Botón siguiente en onboarding
  ///
  /// In es, this message translates to:
  /// **'Siguiente'**
  String get onboardingNext;

  /// Botón regresar en onboarding
  ///
  /// In es, this message translates to:
  /// **'Regresar'**
  String get onboardingBack;

  /// Botón comenzar en la última página del onboarding
  ///
  /// In es, this message translates to:
  /// **'Comenzar'**
  String get onboardingStart;

  /// Título de la primera página del onboarding
  ///
  /// In es, this message translates to:
  /// **'Bienvenido'**
  String get onboardingTitle1;

  /// Descripción de la primera página del onboarding
  ///
  /// In es, this message translates to:
  /// **'Descubre todo lo que esta aplicación tiene para ofrecerte.'**
  String get onboardingDescription1;

  /// Título de la segunda página del onboarding
  ///
  /// In es, this message translates to:
  /// **'Seguro y confiable'**
  String get onboardingTitle2;

  /// Descripción de la segunda página del onboarding
  ///
  /// In es, this message translates to:
  /// **'Tu información está protegida con los más altos estándares de seguridad.'**
  String get onboardingDescription2;

  /// Título de la tercera página del onboarding
  ///
  /// In es, this message translates to:
  /// **'Todo listo'**
  String get onboardingTitle3;

  /// Descripción de la tercera página del onboarding
  ///
  /// In es, this message translates to:
  /// **'Estás a un paso de comenzar. ¡Crea tu cuenta o inicia sesión!'**
  String get onboardingDescription3;

  /// Título del diálogo cuando la sesión caduca
  ///
  /// In es, this message translates to:
  /// **'Sesión expirada'**
  String get sessionExpiredTitle;

  /// Mensaje del diálogo cuando la sesión caduca
  ///
  /// In es, this message translates to:
  /// **'Tu sesión ha expirado. Inicia sesión nuevamente para continuar.'**
  String get sessionExpiredMessage;

  /// Botón del diálogo de sesión expirada
  ///
  /// In es, this message translates to:
  /// **'Iniciar sesión'**
  String get sessionExpiredAction;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'es'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
