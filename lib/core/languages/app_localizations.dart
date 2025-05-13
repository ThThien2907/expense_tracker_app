import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_vi.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'languages/app_localizations.dart';
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
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

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
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('vi')
  ];

  ///
  ///
  /// In en, this message translates to:
  /// **'Gain total control of your money'**
  String get onboardingTitle1;

  ///
  ///
  /// In en, this message translates to:
  /// **'Know where your money goes'**
  String get onboardingTitle2;

  ///
  ///
  /// In en, this message translates to:
  /// **'Planning ahead'**
  String get onboardingTitle3;

  ///
  ///
  /// In en, this message translates to:
  /// **'Become your own money manager and make every cent count'**
  String get onboardingSubTitle1;

  ///
  ///
  /// In en, this message translates to:
  /// **'Track your transaction easily, with categories and financial report'**
  String get onboardingSubTitle2;

  ///
  ///
  /// In en, this message translates to:
  /// **'Setup your budget for each category so you in control'**
  String get onboardingSubTitle3;

  ///
  ///
  /// In en, this message translates to:
  /// **'Sign Up'**
  String get singUp;

  ///
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  ///
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  ///
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  ///
  ///
  /// In en, this message translates to:
  /// **'Full name'**
  String get fullName;

  ///
  ///
  /// In en, this message translates to:
  /// **'By signing up, you agree to the '**
  String get bySigningUpAgreeTo;

  ///
  ///
  /// In en, this message translates to:
  /// **'Terms of Service and Privacy Policy'**
  String get privacyPolicy;

  ///
  ///
  /// In en, this message translates to:
  /// **'Already have an account? '**
  String get alreadyHaveAnAccount;

  ///
  ///
  /// In en, this message translates to:
  /// **'Forgot Password?'**
  String get forgotPassword;

  ///
  ///
  /// In en, this message translates to:
  /// **'Don’t have an account yet? '**
  String get dontHaveAnAccount;

  ///
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  ///
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get loading;

  ///
  ///
  /// In en, this message translates to:
  /// **'This email has existed'**
  String get emailExisted;

  ///
  ///
  /// In en, this message translates to:
  /// **'Invalid login credentials'**
  String get invalidLoginCredentials;

  ///
  ///
  /// In en, this message translates to:
  /// **'Email not confirmed'**
  String get emailNotConfirmed;

  ///
  ///
  /// In en, this message translates to:
  /// **'Password should be at least 6 characters'**
  String get weakPassword;

  ///
  ///
  /// In en, this message translates to:
  /// **'Invalid email format'**
  String get invalidEmailFormat;

  ///
  ///
  /// In en, this message translates to:
  /// **'Please fill in all information'**
  String get fillIn;

  ///
  ///
  /// In en, this message translates to:
  /// **'Your email has been sent'**
  String get emailSent;

  ///
  ///
  /// In en, this message translates to:
  /// **'Check your email to verify your account before logging in'**
  String get checkYourEmail;

  ///
  ///
  /// In en, this message translates to:
  /// **'Back to Login'**
  String get backToLogin;

  ///
  ///
  /// In en, this message translates to:
  /// **'No internet connection, please check your connection'**
  String get noInternetConnection;

  ///
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  ///
  ///
  /// In en, this message translates to:
  /// **'Transactions'**
  String get transactions;

  ///
  ///
  /// In en, this message translates to:
  /// **'Budgets'**
  String get budgets;

  ///
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get account;

  ///
  ///
  /// In en, this message translates to:
  /// **'Total Balance'**
  String get totalBalance;

  ///
  ///
  /// In en, this message translates to:
  /// **'Income'**
  String get income;

  ///
  ///
  /// In en, this message translates to:
  /// **'Expense'**
  String get expense;

  ///
  ///
  /// In en, this message translates to:
  /// **'Wallet'**
  String get wallet;

  ///
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get category;

  ///
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get setting;

  ///
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en', 'vi'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en': return AppLocalizationsEn();
    case 'vi': return AppLocalizationsVi();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
