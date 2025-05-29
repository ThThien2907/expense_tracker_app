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

  /// No description provided for @onboardingTitle1.
  ///
  /// In en, this message translates to:
  /// **'Gain total control of your money'**
  String get onboardingTitle1;

  /// No description provided for @onboardingTitle2.
  ///
  /// In en, this message translates to:
  /// **'Know where your money goes'**
  String get onboardingTitle2;

  /// No description provided for @onboardingTitle3.
  ///
  /// In en, this message translates to:
  /// **'Planning ahead'**
  String get onboardingTitle3;

  /// No description provided for @onboardingSubTitle1.
  ///
  /// In en, this message translates to:
  /// **'Become your own money manager and make every cent count'**
  String get onboardingSubTitle1;

  /// No description provided for @onboardingSubTitle2.
  ///
  /// In en, this message translates to:
  /// **'Track your transaction easily, with categories and financial report'**
  String get onboardingSubTitle2;

  /// No description provided for @onboardingSubTitle3.
  ///
  /// In en, this message translates to:
  /// **'Setup your budget for each category so you in control'**
  String get onboardingSubTitle3;

  /// No description provided for @singUp.
  ///
  /// In en, this message translates to:
  /// **'Sign Up'**
  String get singUp;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @fullName.
  ///
  /// In en, this message translates to:
  /// **'Full name'**
  String get fullName;

  /// No description provided for @bySigningUpAgreeTo.
  ///
  /// In en, this message translates to:
  /// **'By signing up, you agree to the '**
  String get bySigningUpAgreeTo;

  /// No description provided for @privacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'Terms of Service and Privacy Policy'**
  String get privacyPolicy;

  /// No description provided for @alreadyHaveAnAccount.
  ///
  /// In en, this message translates to:
  /// **'Already have an account? '**
  String get alreadyHaveAnAccount;

  /// No description provided for @forgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot Password?'**
  String get forgotPassword;

  /// No description provided for @dontHaveAnAccount.
  ///
  /// In en, this message translates to:
  /// **'Don’t have an account yet? '**
  String get dontHaveAnAccount;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @loading.
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get loading;

  /// No description provided for @emailExisted.
  ///
  /// In en, this message translates to:
  /// **'This email has existed'**
  String get emailExisted;

  /// No description provided for @invalidLoginCredentials.
  ///
  /// In en, this message translates to:
  /// **'Invalid login credentials'**
  String get invalidLoginCredentials;

  /// No description provided for @emailNotConfirmed.
  ///
  /// In en, this message translates to:
  /// **'Email not confirmed'**
  String get emailNotConfirmed;

  /// No description provided for @weakPassword.
  ///
  /// In en, this message translates to:
  /// **'Password should be at least 6 characters'**
  String get weakPassword;

  /// No description provided for @invalidEmailFormat.
  ///
  /// In en, this message translates to:
  /// **'Invalid email format'**
  String get invalidEmailFormat;

  /// No description provided for @fillIn.
  ///
  /// In en, this message translates to:
  /// **'Please fill in all information'**
  String get fillIn;

  /// No description provided for @emailSent.
  ///
  /// In en, this message translates to:
  /// **'Your email has been sent'**
  String get emailSent;

  /// No description provided for @checkYourEmail.
  ///
  /// In en, this message translates to:
  /// **'Check your email to verify your account before logging in'**
  String get checkYourEmail;

  /// No description provided for @backToLogin.
  ///
  /// In en, this message translates to:
  /// **'Back to Login'**
  String get backToLogin;

  /// No description provided for @confirmLogout.
  ///
  /// In en, this message translates to:
  /// **'Are you sure do you wanna logout?'**
  String get confirmLogout;

  /// No description provided for @noInternetConnection.
  ///
  /// In en, this message translates to:
  /// **'No internet connection, please check your connection'**
  String get noInternetConnection;

  /// No description provided for @failureTryAgain.
  ///
  /// In en, this message translates to:
  /// **'Failure, please try again later'**
  String get failureTryAgain;

  /// No description provided for @yes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get yes;

  /// No description provided for @no.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get no;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @transactions.
  ///
  /// In en, this message translates to:
  /// **'Transactions'**
  String get transactions;

  /// No description provided for @budgets.
  ///
  /// In en, this message translates to:
  /// **'Budgets'**
  String get budgets;

  /// No description provided for @account.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get account;

  /// No description provided for @wallet.
  ///
  /// In en, this message translates to:
  /// **'Wallet'**
  String get wallet;

  /// No description provided for @category.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get category;

  /// No description provided for @setting.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get setting;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// No description provided for @myWallet.
  ///
  /// In en, this message translates to:
  /// **'My Wallet'**
  String get myWallet;

  /// No description provided for @addNewWallet.
  ///
  /// In en, this message translates to:
  /// **'Add new wallet'**
  String get addNewWallet;

  /// No description provided for @editWallet.
  ///
  /// In en, this message translates to:
  /// **'Edit wallet'**
  String get editWallet;

  /// No description provided for @balance.
  ///
  /// In en, this message translates to:
  /// **'Balance'**
  String get balance;

  /// No description provided for @name.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get name;

  /// No description provided for @walletType.
  ///
  /// In en, this message translates to:
  /// **'Wallet Type'**
  String get walletType;

  /// No description provided for @bank.
  ///
  /// In en, this message translates to:
  /// **'Bank'**
  String get bank;

  /// No description provided for @apply.
  ///
  /// In en, this message translates to:
  /// **'Apply'**
  String get apply;

  /// No description provided for @doNotHaveWallet.
  ///
  /// In en, this message translates to:
  /// **'You don\'t have a wallet yet, add one now'**
  String get doNotHaveWallet;

  /// No description provided for @removeThisWallet.
  ///
  /// In en, this message translates to:
  /// **'Remove this wallet?'**
  String get removeThisWallet;

  /// No description provided for @confirmRemoveWallet.
  ///
  /// In en, this message translates to:
  /// **'You will also delete all transactions related to with this wallet. Are you sure do you wanna remove this wallet?'**
  String get confirmRemoveWallet;

  /// No description provided for @seeYourFinancialReport.
  ///
  /// In en, this message translates to:
  /// **'See your financial report'**
  String get seeYourFinancialReport;

  /// No description provided for @recentTransaction.
  ///
  /// In en, this message translates to:
  /// **'Recent Transaction'**
  String get recentTransaction;

  /// No description provided for @seeAll.
  ///
  /// In en, this message translates to:
  /// **'See all'**
  String get seeAll;

  /// No description provided for @addNewExpense.
  ///
  /// In en, this message translates to:
  /// **'Add New Expense'**
  String get addNewExpense;

  /// No description provided for @editExpense.
  ///
  /// In en, this message translates to:
  /// **'Edit Expense'**
  String get editExpense;

  /// No description provided for @addNewIncome.
  ///
  /// In en, this message translates to:
  /// **'Add New Income'**
  String get addNewIncome;

  /// No description provided for @editIncome.
  ///
  /// In en, this message translates to:
  /// **'Edit Income'**
  String get editIncome;

  /// No description provided for @editTransaction.
  ///
  /// In en, this message translates to:
  /// **'Edit Transaction'**
  String get editTransaction;

  /// No description provided for @amount.
  ///
  /// In en, this message translates to:
  /// **'Amount'**
  String get amount;

  /// No description provided for @description.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get description;

  /// No description provided for @totalBalance.
  ///
  /// In en, this message translates to:
  /// **'Total Balance'**
  String get totalBalance;

  /// No description provided for @total.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get total;

  /// No description provided for @income.
  ///
  /// In en, this message translates to:
  /// **'Income'**
  String get income;

  /// No description provided for @expense.
  ///
  /// In en, this message translates to:
  /// **'Expense'**
  String get expense;

  /// No description provided for @type.
  ///
  /// In en, this message translates to:
  /// **'Type'**
  String get type;

  /// No description provided for @detailTransaction.
  ///
  /// In en, this message translates to:
  /// **'Detail Transaction'**
  String get detailTransaction;

  /// No description provided for @doNotHaveTransactionsThisMonth.
  ///
  /// In en, this message translates to:
  /// **'You don\'t have any transactions this month'**
  String get doNotHaveTransactionsThisMonth;

  /// No description provided for @doNotHaveRecentTransactions.
  ///
  /// In en, this message translates to:
  /// **'You don\'t have any recent transactions'**
  String get doNotHaveRecentTransactions;

  /// No description provided for @removeThisTransaction.
  ///
  /// In en, this message translates to:
  /// **'Remove this transaction?'**
  String get removeThisTransaction;

  /// No description provided for @confirmRemoveTransaction.
  ///
  /// In en, this message translates to:
  /// **'Are you sure do you wanna remove this transaction?'**
  String get confirmRemoveTransaction;

  /// No description provided for @detailBudget.
  ///
  /// In en, this message translates to:
  /// **'Detail Budget'**
  String get detailBudget;

  /// No description provided for @remaining.
  ///
  /// In en, this message translates to:
  /// **'Remaining'**
  String get remaining;

  /// No description provided for @overspent.
  ///
  /// In en, this message translates to:
  /// **'Overspent'**
  String get overspent;

  /// No description provided for @spent.
  ///
  /// In en, this message translates to:
  /// **'Spent'**
  String get spent;

  /// No description provided for @limit.
  ///
  /// In en, this message translates to:
  /// **'Limit'**
  String get limit;

  /// No description provided for @daysLeft.
  ///
  /// In en, this message translates to:
  /// **'days left'**
  String get daysLeft;

  /// No description provided for @budgetOf.
  ///
  /// In en, this message translates to:
  /// **'of'**
  String get budgetOf;

  /// No description provided for @exceededSpendingLimit.
  ///
  /// In en, this message translates to:
  /// **'You have exceeded your spending limit!'**
  String get exceededSpendingLimit;

  /// No description provided for @addNewBudget.
  ///
  /// In en, this message translates to:
  /// **'Add new budget'**
  String get addNewBudget;

  /// No description provided for @editBudget.
  ///
  /// In en, this message translates to:
  /// **'Edit budget'**
  String get editBudget;

  /// No description provided for @finishedBudget.
  ///
  /// In en, this message translates to:
  /// **'Finished Budget'**
  String get finishedBudget;

  /// No description provided for @doNotHaveBudget.
  ///
  /// In en, this message translates to:
  /// **'You don’t have a budget.'**
  String get doNotHaveBudget;

  /// No description provided for @startSavingMoneyByCreatingBudgets.
  ///
  /// In en, this message translates to:
  /// **'Start saving money by creating budgets.'**
  String get startSavingMoneyByCreatingBudgets;

  /// No description provided for @howMuchDoYouWantToSpend.
  ///
  /// In en, this message translates to:
  /// **'How much do yo want to spend?'**
  String get howMuchDoYouWantToSpend;

  /// No description provided for @startDate.
  ///
  /// In en, this message translates to:
  /// **'Start Date'**
  String get startDate;

  /// No description provided for @endDate.
  ///
  /// In en, this message translates to:
  /// **'End Date'**
  String get endDate;

  /// No description provided for @removeThisBudget.
  ///
  /// In en, this message translates to:
  /// **'Remove this budget?'**
  String get removeThisBudget;

  /// No description provided for @confirmRemoveBudget.
  ///
  /// In en, this message translates to:
  /// **'Are you sure do you wanna remove this budget?'**
  String get confirmRemoveBudget;

  /// No description provided for @endDateCanNotBeBeforeStartDate.
  ///
  /// In en, this message translates to:
  /// **'End date can\'t be before start date'**
  String get endDateCanNotBeBeforeStartDate;

  /// No description provided for @endDateCanNotBeLessThanToday.
  ///
  /// In en, this message translates to:
  /// **'End date can\'t be less than today'**
  String get endDateCanNotBeLessThanToday;

  /// No description provided for @currency.
  ///
  /// In en, this message translates to:
  /// **'Currency'**
  String get currency;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @vietnamese.
  ///
  /// In en, this message translates to:
  /// **'Vietnamese'**
  String get vietnamese;

  /// No description provided for @english.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @today.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get today;

  /// No description provided for @yesterday.
  ///
  /// In en, this message translates to:
  /// **'Yesterday'**
  String get yesterday;

  /// No description provided for @monday.
  ///
  /// In en, this message translates to:
  /// **'Monday'**
  String get monday;

  /// No description provided for @tuesday.
  ///
  /// In en, this message translates to:
  /// **'Tuesday'**
  String get tuesday;

  /// No description provided for @wednesday.
  ///
  /// In en, this message translates to:
  /// **'Wednesday'**
  String get wednesday;

  /// No description provided for @thursday.
  ///
  /// In en, this message translates to:
  /// **'Thursday'**
  String get thursday;

  /// No description provided for @friday.
  ///
  /// In en, this message translates to:
  /// **'Friday'**
  String get friday;

  /// No description provided for @saturday.
  ///
  /// In en, this message translates to:
  /// **'Saturday'**
  String get saturday;

  /// No description provided for @sunday.
  ///
  /// In en, this message translates to:
  /// **'Sunday'**
  String get sunday;

  /// No description provided for @categoryFoodBeverage.
  ///
  /// In en, this message translates to:
  /// **'Food & Beverage'**
  String get categoryFoodBeverage;

  /// No description provided for @categoryBillUtilities.
  ///
  /// In en, this message translates to:
  /// **'Bill & Utilities'**
  String get categoryBillUtilities;

  /// No description provided for @categoryShopping.
  ///
  /// In en, this message translates to:
  /// **'Shopping'**
  String get categoryShopping;

  /// No description provided for @categoryFamily.
  ///
  /// In en, this message translates to:
  /// **'Family'**
  String get categoryFamily;

  /// No description provided for @categoryTransportation.
  ///
  /// In en, this message translates to:
  /// **'Transportation'**
  String get categoryTransportation;

  /// No description provided for @categoryHealthFitness.
  ///
  /// In en, this message translates to:
  /// **'Health & Fitness'**
  String get categoryHealthFitness;

  /// No description provided for @categoryEducation.
  ///
  /// In en, this message translates to:
  /// **'Education'**
  String get categoryEducation;

  /// No description provided for @categoryEntertainment.
  ///
  /// In en, this message translates to:
  /// **'Entertainment'**
  String get categoryEntertainment;

  /// No description provided for @categoryInvestment.
  ///
  /// In en, this message translates to:
  /// **'Investment'**
  String get categoryInvestment;

  /// No description provided for @categoryOtherExpense.
  ///
  /// In en, this message translates to:
  /// **'Other Expense'**
  String get categoryOtherExpense;

  /// No description provided for @categoryOutgoingTransfer.
  ///
  /// In en, this message translates to:
  /// **'Outgoing transfer'**
  String get categoryOutgoingTransfer;

  /// No description provided for @categoryPayInterest.
  ///
  /// In en, this message translates to:
  /// **'Pay Interest'**
  String get categoryPayInterest;

  /// No description provided for @categoryLoan.
  ///
  /// In en, this message translates to:
  /// **'Loan'**
  String get categoryLoan;

  /// No description provided for @categoryRepayment.
  ///
  /// In en, this message translates to:
  /// **'Repayment'**
  String get categoryRepayment;

  /// No description provided for @categoryUncategorizedExpense.
  ///
  /// In en, this message translates to:
  /// **'Uncategorized Expense'**
  String get categoryUncategorizedExpense;

  /// No description provided for @categorySalary.
  ///
  /// In en, this message translates to:
  /// **'Salary'**
  String get categorySalary;

  /// No description provided for @categoryOtherIncome.
  ///
  /// In en, this message translates to:
  /// **'Other Income'**
  String get categoryOtherIncome;

  /// No description provided for @categoryIncomingTransfer.
  ///
  /// In en, this message translates to:
  /// **'Incoming transfer'**
  String get categoryIncomingTransfer;

  /// No description provided for @categoryCollectInterest.
  ///
  /// In en, this message translates to:
  /// **'Collect Interest'**
  String get categoryCollectInterest;

  /// No description provided for @categoryDebt.
  ///
  /// In en, this message translates to:
  /// **'Debt'**
  String get categoryDebt;

  /// No description provided for @categoryDebtCollection.
  ///
  /// In en, this message translates to:
  /// **'Debt Collection'**
  String get categoryDebtCollection;

  /// No description provided for @categoryUncategorizedIncome.
  ///
  /// In en, this message translates to:
  /// **'Uncategorized Income'**
  String get categoryUncategorizedIncome;
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
