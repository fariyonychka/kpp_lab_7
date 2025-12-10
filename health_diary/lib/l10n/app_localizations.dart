import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_uk.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
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
    Locale('uk')
  ];

  /// No description provided for @foodRecord.
  ///
  /// In en, this message translates to:
  /// **'Food record'**
  String get foodRecord;

  /// No description provided for @whatDidYouEat.
  ///
  /// In en, this message translates to:
  /// **'What did you eat?'**
  String get whatDidYouEat;

  /// No description provided for @dateTime.
  ///
  /// In en, this message translates to:
  /// **'Date and time'**
  String get dateTime;

  /// No description provided for @selectDateTime.
  ///
  /// In en, this message translates to:
  /// **'Select date and time'**
  String get selectDateTime;

  /// No description provided for @today.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get today;

  /// No description provided for @dishName.
  ///
  /// In en, this message translates to:
  /// **'Dish name'**
  String get dishName;

  /// No description provided for @calories.
  ///
  /// In en, this message translates to:
  /// **'Calories'**
  String get calories;

  /// No description provided for @proteins.
  ///
  /// In en, this message translates to:
  /// **'Proteins (g)'**
  String get proteins;

  /// No description provided for @fats.
  ///
  /// In en, this message translates to:
  /// **'Fats (g)'**
  String get fats;

  /// No description provided for @carbs.
  ///
  /// In en, this message translates to:
  /// **'Carbs (g)'**
  String get carbs;

  /// No description provided for @notes.
  ///
  /// In en, this message translates to:
  /// **'Additional notes'**
  String get notes;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @foodSaved.
  ///
  /// In en, this message translates to:
  /// **'Food record saved'**
  String get foodSaved;

  /// No description provided for @moodRecord.
  ///
  /// In en, this message translates to:
  /// **'Mood record'**
  String get moodRecord;

  /// No description provided for @howDoYouFeel.
  ///
  /// In en, this message translates to:
  /// **'How do you feel?'**
  String get howDoYouFeel;

  /// No description provided for @happy.
  ///
  /// In en, this message translates to:
  /// **'Happy'**
  String get happy;

  /// No description provided for @neutral.
  ///
  /// In en, this message translates to:
  /// **'Neutral'**
  String get neutral;

  /// No description provided for @sad.
  ///
  /// In en, this message translates to:
  /// **'Sad'**
  String get sad;

  /// No description provided for @stressed.
  ///
  /// In en, this message translates to:
  /// **'Stressed'**
  String get stressed;

  /// No description provided for @energy.
  ///
  /// In en, this message translates to:
  /// **'Energy'**
  String get energy;

  /// No description provided for @energyLevel.
  ///
  /// In en, this message translates to:
  /// **'Energy level: {level}/10'**
  String energyLevel(Object level);

  /// No description provided for @physicalState.
  ///
  /// In en, this message translates to:
  /// **'Physical state'**
  String get physicalState;

  /// No description provided for @bad.
  ///
  /// In en, this message translates to:
  /// **'Bad'**
  String get bad;

  /// No description provided for @good.
  ///
  /// In en, this message translates to:
  /// **'Good'**
  String get good;

  /// No description provided for @goodState.
  ///
  /// In en, this message translates to:
  /// **'Good'**
  String get goodState;

  /// No description provided for @excellent.
  ///
  /// In en, this message translates to:
  /// **'Excellent'**
  String get excellent;

  /// No description provided for @moodSaved.
  ///
  /// In en, this message translates to:
  /// **'Mood saved'**
  String get moodSaved;

  /// No description provided for @sleepRecord.
  ///
  /// In en, this message translates to:
  /// **'Sleep record'**
  String get sleepRecord;

  /// No description provided for @howDidYouSleep.
  ///
  /// In en, this message translates to:
  /// **'How did you sleep?'**
  String get howDidYouSleep;

  /// No description provided for @duration.
  ///
  /// In en, this message translates to:
  /// **'Sleep duration (hours)'**
  String get duration;

  /// No description provided for @quality.
  ///
  /// In en, this message translates to:
  /// **'Sleep quality'**
  String get quality;

  /// No description provided for @poor.
  ///
  /// In en, this message translates to:
  /// **'Poor'**
  String get poor;

  /// No description provided for @great.
  ///
  /// In en, this message translates to:
  /// **'Great'**
  String get great;

  /// No description provided for @sleepSaved.
  ///
  /// In en, this message translates to:
  /// **'Sleep record saved'**
  String get sleepSaved;

  /// No description provided for @sleepExcellent.
  ///
  /// In en, this message translates to:
  /// **'Excellent'**
  String get sleepExcellent;

  /// No description provided for @historyTitle.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get historyTitle;

  /// No description provided for @all.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get all;

  /// No description provided for @noRecords.
  ///
  /// In en, this message translates to:
  /// **'No records'**
  String get noRecords;

  /// No description provided for @loadingError.
  ///
  /// In en, this message translates to:
  /// **'Loading error'**
  String get loadingError;

  /// No description provided for @resetPassword.
  ///
  /// In en, this message translates to:
  /// **'Reset password'**
  String get resetPassword;

  /// No description provided for @enterEmail.
  ///
  /// In en, this message translates to:
  /// **'Enter email to get instructions'**
  String get enterEmail;

  /// No description provided for @sendInstructions.
  ///
  /// In en, this message translates to:
  /// **'Send instructions'**
  String get sendInstructions;

  /// No description provided for @backToLogin.
  ///
  /// In en, this message translates to:
  /// **'Back to login'**
  String get backToLogin;

  /// No description provided for @requiredField.
  ///
  /// In en, this message translates to:
  /// **'Required field'**
  String get requiredField;

  /// No description provided for @passwordMin6.
  ///
  /// In en, this message translates to:
  /// **'At least 6 characters'**
  String get passwordMin6;

  /// No description provided for @ageInvalid.
  ///
  /// In en, this message translates to:
  /// **'Invalid age'**
  String get ageInvalid;

  /// No description provided for @nameHint.
  ///
  /// In en, this message translates to:
  /// **'Your name'**
  String get nameHint;

  /// No description provided for @dishHint.
  ///
  /// In en, this message translates to:
  /// **'For example: Caesar salad'**
  String get dishHint;

  /// No description provided for @notesHint.
  ///
  /// In en, this message translates to:
  /// **'Tell more...'**
  String get notesHint;

  /// No description provided for @moodNotesHint.
  ///
  /// In en, this message translates to:
  /// **'Tell more about your mood...'**
  String get moodNotesHint;

  /// No description provided for @sleepNotesHint.
  ///
  /// In en, this message translates to:
  /// **'Tell more about your sleep...'**
  String get sleepNotesHint;

  /// No description provided for @sortByDate.
  ///
  /// In en, this message translates to:
  /// **'Sort by date'**
  String get sortByDate;

  /// No description provided for @emailSent.
  ///
  /// In en, this message translates to:
  /// **'Email sent! Check your inbox or spam'**
  String get emailSent;

  /// No description provided for @loginSuccess.
  ///
  /// In en, this message translates to:
  /// **'Login successful!'**
  String get loginSuccess;

  /// No description provided for @registerSuccess.
  ///
  /// In en, this message translates to:
  /// **'Registration successful!'**
  String get registerSuccess;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @myData.
  ///
  /// In en, this message translates to:
  /// **'My data'**
  String get myData;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Log out'**
  String get logout;

  /// No description provided for @logoutSuccess.
  ///
  /// In en, this message translates to:
  /// **'You have logged out'**
  String get logoutSuccess;

  /// No description provided for @english.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @ukrainian.
  ///
  /// In en, this message translates to:
  /// **'Українська'**
  String get ukrainian;

  /// No description provided for @yearsOld.
  ///
  /// In en, this message translates to:
  /// **'years old'**
  String get yearsOld;

  /// No description provided for @femaleGender.
  ///
  /// In en, this message translates to:
  /// **'Female'**
  String get femaleGender;

  /// No description provided for @testCrash.
  ///
  /// In en, this message translates to:
  /// **'Test Crash (Sentry)'**
  String get testCrash;

  /// No description provided for @notRealeasedNow.
  ///
  /// In en, this message translates to:
  /// **'Not realeased yet'**
  String get notRealeasedNow;

  /// No description provided for @january.
  ///
  /// In en, this message translates to:
  /// **'January'**
  String get january;

  /// No description provided for @february.
  ///
  /// In en, this message translates to:
  /// **'February'**
  String get february;

  /// No description provided for @march.
  ///
  /// In en, this message translates to:
  /// **'March'**
  String get march;

  /// No description provided for @april.
  ///
  /// In en, this message translates to:
  /// **'April'**
  String get april;

  /// No description provided for @may.
  ///
  /// In en, this message translates to:
  /// **'May'**
  String get may;

  /// No description provided for @june.
  ///
  /// In en, this message translates to:
  /// **'June'**
  String get june;

  /// No description provided for @july.
  ///
  /// In en, this message translates to:
  /// **'July'**
  String get july;

  /// No description provided for @august.
  ///
  /// In en, this message translates to:
  /// **'August'**
  String get august;

  /// No description provided for @september.
  ///
  /// In en, this message translates to:
  /// **'September'**
  String get september;

  /// No description provided for @october.
  ///
  /// In en, this message translates to:
  /// **'October'**
  String get october;

  /// No description provided for @november.
  ///
  /// In en, this message translates to:
  /// **'November'**
  String get november;

  /// No description provided for @december.
  ///
  /// In en, this message translates to:
  /// **'December'**
  String get december;

  /// No description provided for @invalidDuration.
  ///
  /// In en, this message translates to:
  /// **'Invalid duration'**
  String get invalidDuration;

  /// No description provided for @recordSaved.
  ///
  /// In en, this message translates to:
  /// **'Record saved successfully'**
  String get recordSaved;

  /// No description provided for @errorSaving.
  ///
  /// In en, this message translates to:
  /// **'Error saving record'**
  String get errorSaving;

  /// No description provided for @fillAllFields.
  ///
  /// In en, this message translates to:
  /// **'Please fill all required fields'**
  String get fillAllFields;

  /// No description provided for @fieldRequired.
  ///
  /// In en, this message translates to:
  /// **'Field is required'**
  String get fieldRequired;

  /// No description provided for @enterDishName.
  ///
  /// In en, this message translates to:
  /// **'Enter dish name'**
  String get enterDishName;

  /// No description provided for @enterCalories.
  ///
  /// In en, this message translates to:
  /// **'Enter calories'**
  String get enterCalories;

  /// No description provided for @enterValidNumber.
  ///
  /// In en, this message translates to:
  /// **'Enter valid number'**
  String get enterValidNumber;

  /// No description provided for @enterNotes.
  ///
  /// In en, this message translates to:
  /// **'Enter notes (optional)'**
  String get enterNotes;

  /// No description provided for @deleteRecord.
  ///
  /// In en, this message translates to:
  /// **'Delete Record'**
  String get deleteRecord;

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Health Diary'**
  String get appTitle;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Log in'**
  String get login;

  /// No description provided for @register.
  ///
  /// In en, this message translates to:
  /// **'Register'**
  String get register;

  /// No description provided for @forgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot password?'**
  String get forgotPassword;

  /// No description provided for @noAccount.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account?'**
  String get noAccount;

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

  /// No description provided for @emailInvalid.
  ///
  /// In en, this message translates to:
  /// **'Invalid email'**
  String get emailInvalid;

  /// No description provided for @createAccount.
  ///
  /// In en, this message translates to:
  /// **'Create account'**
  String get createAccount;

  /// No description provided for @joinHealthyLife.
  ///
  /// In en, this message translates to:
  /// **'Join a healthy lifestyle'**
  String get joinHealthyLife;

  /// No description provided for @name.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get name;

  /// No description provided for @age.
  ///
  /// In en, this message translates to:
  /// **'Age'**
  String get age;

  /// No description provided for @gender.
  ///
  /// In en, this message translates to:
  /// **'Gender'**
  String get gender;

  /// No description provided for @male.
  ///
  /// In en, this message translates to:
  /// **'Male'**
  String get male;

  /// No description provided for @female.
  ///
  /// In en, this message translates to:
  /// **'Female'**
  String get female;

  /// No description provided for @other.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get other;

  /// No description provided for @registerButton.
  ///
  /// In en, this message translates to:
  /// **'Register'**
  String get registerButton;

  /// No description provided for @haveAccount.
  ///
  /// In en, this message translates to:
  /// **'Already have an account? Log in'**
  String get haveAccount;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @sleep.
  ///
  /// In en, this message translates to:
  /// **'Sleep'**
  String get sleep;

  /// No description provided for @food.
  ///
  /// In en, this message translates to:
  /// **'Food'**
  String get food;

  /// No description provided for @mood.
  ///
  /// In en, this message translates to:
  /// **'Mood'**
  String get mood;

  /// No description provided for @history.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get history;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @goodMorning.
  ///
  /// In en, this message translates to:
  /// **'Good morning, {name}!'**
  String goodMorning(Object name);

  /// No description provided for @howAreYou.
  ///
  /// In en, this message translates to:
  /// **'How is your health?'**
  String get howAreYou;

  /// No description provided for @recordSleep.
  ///
  /// In en, this message translates to:
  /// **'Record sleep'**
  String get recordSleep;

  /// No description provided for @sleepSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Track quality and duration\nof your sleep'**
  String get sleepSubtitle;

  /// No description provided for @recordFood.
  ///
  /// In en, this message translates to:
  /// **'Record food'**
  String get recordFood;

  /// No description provided for @foodSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Add info about\nyour meals'**
  String get foodSubtitle;

  /// No description provided for @recordMood.
  ///
  /// In en, this message translates to:
  /// **'Rate mood'**
  String get recordMood;

  /// No description provided for @moodSubtitle.
  ///
  /// In en, this message translates to:
  /// **'How do you feel?'**
  String get moodSubtitle;

  /// No description provided for @recentRecords.
  ///
  /// In en, this message translates to:
  /// **'Recent records'**
  String get recentRecords;

  /// No description provided for @todayRecords.
  ///
  /// In en, this message translates to:
  /// **'Today: {sleep}h sleep, {meals} meals'**
  String todayRecords(Object meals, Object sleep);

  /// No description provided for @deleteConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this record?'**
  String get deleteConfirmation;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @recordDeleted.
  ///
  /// In en, this message translates to:
  /// **'Record deleted successfully'**
  String get recordDeleted;

  /// No description provided for @recordDetails.
  ///
  /// In en, this message translates to:
  /// **'Record details'**
  String get recordDetails;

  /// No description provided for @errorDeleting.
  ///
  /// In en, this message translates to:
  /// **'Error deleting record'**
  String get errorDeleting;

  /// No description provided for @saving.
  ///
  /// In en, this message translates to:
  /// **'Saving...'**
  String get saving;

  /// No description provided for @hours.
  ///
  /// In en, this message translates to:
  /// **'h'**
  String get hours;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en', 'uk'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en': return AppLocalizationsEn();
    case 'uk': return AppLocalizationsUk();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
