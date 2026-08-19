// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'GSE App';

  @override
  String get title => 'Welcome';

  @override
  String get subtitle => 'Sign in to continue';

  @override
  String greeting(String name) {
    return 'Hello $name';
  }

  @override
  String itemCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count items',
      one: '1 item',
      zero: 'No items',
    );
    return '$_temp0';
  }

  @override
  String get loginScreenForgotPassword => 'Forgot your password?';

  @override
  String get loginScreenUsernameHint => 'Username';

  @override
  String get loginScreenPasswordHint => 'Password';

  @override
  String get forgotPasswordUsernameSubtitle =>
      'Enter your username to recover your password';

  @override
  String get forgotPasswordEmailSubtitle =>
      'Enter your email to recover your password';

  @override
  String get forgotPasswordSendButton => 'Send code';

  @override
  String get forgotPasswordCheckEmailTitle => 'Check your email';

  @override
  String get forgotPasswordCheckEmailSubtitle =>
      'Enter the verification code sent to your email';

  @override
  String get forgotPasswordCodeHint => 'Verification code';

  @override
  String get forgotPasswordContinueButton => 'Continue';

  @override
  String get forgotPasswordDidNotReceiveCode => 'Didn\'t receive the code? ';

  @override
  String forgotPasswordResendIn(int seconds) {
    return 'Resend in ${seconds}s';
  }

  @override
  String get forgotPasswordResendEmail => 'Resend';

  @override
  String get forgotPasswordChangeTitle => 'Change password';

  @override
  String get forgotPasswordChangeSubtitle => 'Enter your new password';

  @override
  String get forgotPasswordNewPasswordHint => 'New password';

  @override
  String get forgotPasswordConfirmPasswordHint => 'Confirm password';

  @override
  String get forgotPasswordRequirements =>
      'Password must have at least 8 characters, uppercase, lowercase, number and special character';

  @override
  String get forgotPasswordUpdateButton => 'Update password';

  @override
  String get forgotPasswordUpdateSuccess => 'Password updated successfully';

  @override
  String get forgotPasswordInvalidForm => 'Please complete the form correctly';

  @override
  String get forgotPasswordEmptyUsername => 'Please enter your username';

  @override
  String get loginFailureInvalidCredentials => 'Incorrect email or password';

  @override
  String get loginFailureInvalidForm => 'Please enter your email and password';

  @override
  String get loginFailureConnectionTimeout =>
      'Connection timed out. Please try again';

  @override
  String get loginFailureUserNotFound => 'User not found';

  @override
  String get genericServerFailureError => 'Server error. Please try again';

  @override
  String get genericNetworkFailureError => 'No internet connection';

  @override
  String get genericUnknownFailureError => 'Unknown error. Please try again';

  @override
  String get verifyEmailTitle => 'Verify your email';

  @override
  String get verifyEmailSubtitle =>
      'Enter the verification code sent to your email address';

  @override
  String get verifyEmailCodeHint => 'Verification code';

  @override
  String get verifyEmailVerifyButton => 'Verify';

  @override
  String get verifyEmailDidNotReceiveCode => 'Didn\'t receive the code? ';

  @override
  String verifyEmailResendIn(int seconds) {
    return 'Resend in ${seconds}s';
  }

  @override
  String get verifyEmailResendEmail => 'Resend email';

  @override
  String get verifyEmailInvalidCode => 'Incorrect or expired code';

  @override
  String get loginRegisterButton => 'Sign up';

  @override
  String get loginOrDivider => 'or';

  @override
  String get loginContinueWithGoogle => 'Continue with Google';

  @override
  String get loginContinueWithApple => 'Continue with Apple';

  @override
  String get registerTitle => 'Create account';

  @override
  String get registerSubtitle => 'Enter your details to create your account';

  @override
  String get registerNameHint => 'Full name';

  @override
  String get registerButton => 'Sign up';

  @override
  String get registerAlreadyHaveAccount => 'Already have an account? ';

  @override
  String get registerLoginLink => 'Sign in';

  @override
  String get registerFailureEmailAlreadyExists =>
      'This email is already registered';

  @override
  String get registerFailureInvalidData =>
      'Invalid data. Please check your information';

  @override
  String get loginScreenTitle => 'Sign in';

  @override
  String get loginScreenSubtitle => 'You must have a collaborator account.';

  @override
  String get loginScreenLoginButton => 'Sign in';

  @override
  String get dialogCancelButton => 'Cancel';

  @override
  String get dialogAcceptButton => 'Accept';

  @override
  String get logoutButton => 'Sign out';

  @override
  String get emailHint => 'Email address';

  @override
  String get emptyStateMessage => 'No items found';

  @override
  String get retryButton => 'Retry';

  @override
  String get errorLoadingElementsMessage => 'Could not\nload items';

  @override
  String get errorServerConnectionMessage => 'Unable to\nconnect to server';

  @override
  String get errorLoadingNewItemsMessage =>
      'An error occurred loading new items';

  @override
  String get selectElementTitle => 'Select an item';

  @override
  String get searchHint => 'Search...';

  @override
  String get addArticleButton => 'Add article';

  @override
  String get classificationSelectionTitle => 'Classification selection';

  @override
  String get imageLoadError => 'Error loading image';

  @override
  String get serverConnectionError => 'Error connecting to server';

  @override
  String get selectorErrorMessage =>
      'An error occurred getting data, please try again';

  @override
  String get navigationPlaceholder => 'Navigation 3';

  @override
  String get dsTitle => 'Design System';

  @override
  String get dsTypography => 'Typography';

  @override
  String get dsWeights => 'Weights';

  @override
  String get dsTextStyles => 'Text styles';

  @override
  String get dsColors => 'Colors';

  @override
  String get dsOpacity => 'Opacity';

  @override
  String get dsSpacing => 'Spacing';

  @override
  String get dsBorderRadius => 'Border Radius';

  @override
  String get dsComponents => 'Components';

  @override
  String get dsExampleText => 'Example text';

  @override
  String dsWeightLabel(String name) {
    return 'Weight $name';
  }

  @override
  String get dsItalicText => 'Italic text';

  @override
  String get dsUnderlineText => 'Underlined text';

  @override
  String get dsStrikethroughText => 'Strikethrough text';

  @override
  String get dsCombinations => 'Combinations';

  @override
  String get dsSurfaces => 'Surfaces';

  @override
  String get dsTextGroup => 'Text';

  @override
  String get dsBrand => 'Brand';

  @override
  String get dsStateGroup => 'State';

  @override
  String get dsSemantic => 'Semantic';

  @override
  String get dsCardDescription => 'Surface for grouping related content.';

  @override
  String get dsTextFieldHint => 'Enter text...';

  @override
  String get dsActiveState => 'active state';

  @override
  String get languageScreenTitle => 'Language';

  @override
  String get languageSpanish => 'Spanish';

  @override
  String get languageEnglish => 'English';

  @override
  String get onboardingSkip => 'Skip';

  @override
  String get onboardingNext => 'Next';

  @override
  String get onboardingBack => 'Back';

  @override
  String get onboardingStart => 'Get started';

  @override
  String get onboardingTitle1 => 'Welcome';

  @override
  String get onboardingDescription1 =>
      'Discover everything this app has to offer.';

  @override
  String get onboardingTitle2 => 'Safe and reliable';

  @override
  String get onboardingDescription2 =>
      'Your information is protected with the highest security standards.';

  @override
  String get onboardingTitle3 => 'All set';

  @override
  String get onboardingDescription3 =>
      'You\'re one step away from getting started. Create your account or sign in!';
}
