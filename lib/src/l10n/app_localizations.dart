import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_de.dart';
import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_hi.dart';
import 'app_localizations_zh.dart';

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
    Locale('de'),
    Locale('en'),
    Locale('es'),
    Locale('fr'),
    Locale('hi'),
    Locale('zh'),
  ];

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @systemDefault.
  ///
  /// In en, this message translates to:
  /// **'System Default'**
  String get systemDefault;

  /// No description provided for @notes.
  ///
  /// In en, this message translates to:
  /// **'Notes'**
  String get notes;

  /// No description provided for @todos.
  ///
  /// In en, this message translates to:
  /// **'To-Dos'**
  String get todos;

  /// No description provided for @expenses.
  ///
  /// In en, this message translates to:
  /// **'Expenses'**
  String get expenses;

  /// No description provided for @journal.
  ///
  /// In en, this message translates to:
  /// **'Journal'**
  String get journal;

  /// No description provided for @calendar.
  ///
  /// In en, this message translates to:
  /// **'Calendar'**
  String get calendar;

  /// No description provided for @clipboard.
  ///
  /// In en, this message translates to:
  /// **'Clipboard'**
  String get clipboard;

  /// No description provided for @canvas.
  ///
  /// In en, this message translates to:
  /// **'Canvas'**
  String get canvas;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @create.
  ///
  /// In en, this message translates to:
  /// **'Create'**
  String get create;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

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

  /// No description provided for @share.
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get share;

  /// No description provided for @copy.
  ///
  /// In en, this message translates to:
  /// **'Copy'**
  String get copy;

  /// No description provided for @unsavedChanges.
  ///
  /// In en, this message translates to:
  /// **'Unsaved Changes'**
  String get unsavedChanges;

  /// No description provided for @confirmDelete.
  ///
  /// In en, this message translates to:
  /// **'Confirm Delete'**
  String get confirmDelete;

  /// No description provided for @discard.
  ///
  /// In en, this message translates to:
  /// **'Discard'**
  String get discard;

  /// No description provided for @createPost.
  ///
  /// In en, this message translates to:
  /// **'Create Post'**
  String get createPost;

  /// No description provided for @post.
  ///
  /// In en, this message translates to:
  /// **'Post'**
  String get post;

  /// No description provided for @postingTo.
  ///
  /// In en, this message translates to:
  /// **'Posting to'**
  String get postingTo;

  /// No description provided for @whatsOnYourMind.
  ///
  /// In en, this message translates to:
  /// **'What\'s on your mind?'**
  String get whatsOnYourMind;

  /// No description provided for @pickImages.
  ///
  /// In en, this message translates to:
  /// **'Pick Images'**
  String get pickImages;

  /// No description provided for @pickVideo.
  ///
  /// In en, this message translates to:
  /// **'Pick Video'**
  String get pickVideo;

  /// No description provided for @camera.
  ///
  /// In en, this message translates to:
  /// **'Camera'**
  String get camera;

  /// No description provided for @gallery.
  ///
  /// In en, this message translates to:
  /// **'Gallery'**
  String get gallery;

  /// No description provided for @search.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get search;

  /// No description provided for @pleaseEnterTask.
  ///
  /// In en, this message translates to:
  /// **'Please enter a task'**
  String get pleaseEnterTask;

  /// No description provided for @deleteTask.
  ///
  /// In en, this message translates to:
  /// **'Delete Task'**
  String get deleteTask;

  /// No description provided for @selectItems.
  ///
  /// In en, this message translates to:
  /// **'Select Items'**
  String get selectItems;

  /// No description provided for @deleteAll.
  ///
  /// In en, this message translates to:
  /// **'Delete All'**
  String get deleteAll;

  /// No description provided for @error.
  ///
  /// In en, this message translates to:
  /// **'Error: {error}'**
  String error(Object error);

  /// No description provided for @orderingOnlyAvailableInAllPosts.
  ///
  /// In en, this message translates to:
  /// **'Ordering only available in \'All Posts\''**
  String get orderingOnlyAvailableInAllPosts;

  /// No description provided for @deletePost.
  ///
  /// In en, this message translates to:
  /// **'Delete Post'**
  String get deletePost;

  /// No description provided for @postDeleted.
  ///
  /// In en, this message translates to:
  /// **'Post deleted'**
  String get postDeleted;

  /// No description provided for @premiumFeatures.
  ///
  /// In en, this message translates to:
  /// **'Premium Features'**
  String get premiumFeatures;

  /// No description provided for @manageCoinsAdsPremium.
  ///
  /// In en, this message translates to:
  /// **'Manage coins, ads, and premium status'**
  String get manageCoinsAdsPremium;

  /// No description provided for @themeMode.
  ///
  /// In en, this message translates to:
  /// **'Theme Mode'**
  String get themeMode;

  /// No description provided for @accentColor.
  ///
  /// In en, this message translates to:
  /// **'Accent Color'**
  String get accentColor;

  /// No description provided for @backgroundDesign.
  ///
  /// In en, this message translates to:
  /// **'Background Design'**
  String get backgroundDesign;

  /// No description provided for @pushNotifications.
  ///
  /// In en, this message translates to:
  /// **'Push Notifications'**
  String get pushNotifications;

  /// No description provided for @recycleBin.
  ///
  /// In en, this message translates to:
  /// **'Recycle Bin'**
  String get recycleBin;

  /// No description provided for @exportData.
  ///
  /// In en, this message translates to:
  /// **'Export Data'**
  String get exportData;

  /// No description provided for @importData.
  ///
  /// In en, this message translates to:
  /// **'Import Data'**
  String get importData;

  /// No description provided for @rateApp.
  ///
  /// In en, this message translates to:
  /// **'Rate App'**
  String get rateApp;

  /// No description provided for @sendFeedback.
  ///
  /// In en, this message translates to:
  /// **'Send Feedback'**
  String get sendFeedback;

  /// No description provided for @privacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get privacyPolicy;

  /// No description provided for @version.
  ///
  /// In en, this message translates to:
  /// **'Version'**
  String get version;

  /// No description provided for @buildNumber.
  ///
  /// In en, this message translates to:
  /// **'Build Number'**
  String get buildNumber;

  /// No description provided for @system.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get system;

  /// No description provided for @light.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get light;

  /// No description provided for @dark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get dark;

  /// No description provided for @itemRestored.
  ///
  /// In en, this message translates to:
  /// **'Item restored'**
  String get itemRestored;

  /// No description provided for @recycleBinCleared.
  ///
  /// In en, this message translates to:
  /// **'Recycle Bin cleared successfully'**
  String get recycleBinCleared;

  /// No description provided for @allPostsDeleted.
  ///
  /// In en, this message translates to:
  /// **'All posts deleted'**
  String get allPostsDeleted;

  /// No description provided for @newPost.
  ///
  /// In en, this message translates to:
  /// **'New Post'**
  String get newPost;

  /// No description provided for @textCopiedToClipboardFacebook.
  ///
  /// In en, this message translates to:
  /// **'Text copied to clipboard (Facebook policy)'**
  String get textCopiedToClipboardFacebook;

  /// No description provided for @tiktokSharingRequiresVideoImage.
  ///
  /// In en, this message translates to:
  /// **'TikTok sharing requires a video/image'**
  String get tiktokSharingRequiresVideoImage;

  /// No description provided for @errorSharing.
  ///
  /// In en, this message translates to:
  /// **'Error sharing: {error}'**
  String errorSharing(Object error);

  /// No description provided for @shareToStory.
  ///
  /// In en, this message translates to:
  /// **'Share to {platform} Story'**
  String shareToStory(Object platform);

  /// No description provided for @shareToFeed.
  ///
  /// In en, this message translates to:
  /// **'Share to {platform} Feed'**
  String shareToFeed(Object platform);

  /// No description provided for @unlockPermanently.
  ///
  /// In en, this message translates to:
  /// **'Unlock Permanently'**
  String get unlockPermanently;

  /// No description provided for @notEnoughCoins.
  ///
  /// In en, this message translates to:
  /// **'Not enough coins!'**
  String get notEnoughCoins;

  /// No description provided for @youEarnedCoins.
  ///
  /// In en, this message translates to:
  /// **'You earned {amount} coins!'**
  String youEarnedCoins(Object amount);

  /// No description provided for @contentCopied.
  ///
  /// In en, this message translates to:
  /// **'Content copied'**
  String get contentCopied;

  /// No description provided for @selectDateTime.
  ///
  /// In en, this message translates to:
  /// **'Select Date & Time'**
  String get selectDateTime;

  /// No description provided for @areYouSureYouWantToDeleteThisPost.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this post?'**
  String get areYouSureYouWantToDeleteThisPost;

  /// No description provided for @socialPosts.
  ///
  /// In en, this message translates to:
  /// **'Social Posts'**
  String get socialPosts;

  /// No description provided for @watchAdToEarnCoins.
  ///
  /// In en, this message translates to:
  /// **'Watch Ad to Earn Coins'**
  String get watchAdToEarnCoins;

  /// No description provided for @premiumUnlocked.
  ///
  /// In en, this message translates to:
  /// **'Premium Unlocked'**
  String get premiumUnlocked;

  /// No description provided for @removeAds.
  ///
  /// In en, this message translates to:
  /// **'Remove Ads'**
  String get removeAds;

  /// No description provided for @unlimitedCloudStorage.
  ///
  /// In en, this message translates to:
  /// **'Unlimited Cloud Storage'**
  String get unlimitedCloudStorage;

  /// No description provided for @deleteNote.
  ///
  /// In en, this message translates to:
  /// **'Delete Note'**
  String get deleteNote;

  /// No description provided for @shareNote.
  ///
  /// In en, this message translates to:
  /// **'Share Note'**
  String get shareNote;

  /// No description provided for @editNote.
  ///
  /// In en, this message translates to:
  /// **'Edit Note'**
  String get editNote;

  /// No description provided for @searchNotes.
  ///
  /// In en, this message translates to:
  /// **'Search notes...'**
  String get searchNotes;

  /// No description provided for @noNotesFound.
  ///
  /// In en, this message translates to:
  /// **'No notes found'**
  String get noNotesFound;

  /// No description provided for @captureThoughts.
  ///
  /// In en, this message translates to:
  /// **'Capture your thoughts instantly.'**
  String get captureThoughts;

  /// No description provided for @createNote.
  ///
  /// In en, this message translates to:
  /// **'Create Note'**
  String get createNote;

  /// No description provided for @customOrder.
  ///
  /// In en, this message translates to:
  /// **'Custom Order'**
  String get customOrder;

  /// No description provided for @newestFirst.
  ///
  /// In en, this message translates to:
  /// **'Newest First'**
  String get newestFirst;

  /// No description provided for @oldestFirst.
  ///
  /// In en, this message translates to:
  /// **'Oldest First'**
  String get oldestFirst;

  /// No description provided for @titleAZ.
  ///
  /// In en, this message translates to:
  /// **'Title: A-Z'**
  String get titleAZ;

  /// No description provided for @titleZA.
  ///
  /// In en, this message translates to:
  /// **'Title: Z-A'**
  String get titleZA;

  /// No description provided for @deleteAllQuestion.
  ///
  /// In en, this message translates to:
  /// **'Delete All?'**
  String get deleteAllQuestion;

  /// No description provided for @moveToRecycleBin.
  ///
  /// In en, this message translates to:
  /// **'Move all notes to Recycle Bin?'**
  String get moveToRecycleBin;

  /// No description provided for @moveToBinQuestion.
  ///
  /// In en, this message translates to:
  /// **'Move to Bin?'**
  String get moveToBinQuestion;

  /// No description provided for @restoreNoteLater.
  ///
  /// In en, this message translates to:
  /// **'You can restore this note later.'**
  String get restoreNoteLater;

  /// No description provided for @move.
  ///
  /// In en, this message translates to:
  /// **'Move'**
  String get move;

  /// No description provided for @myThoughts.
  ///
  /// In en, this message translates to:
  /// **'My Thoughts'**
  String get myThoughts;

  /// No description provided for @selected.
  ///
  /// In en, this message translates to:
  /// **'Selected'**
  String get selected;

  /// No description provided for @noContent.
  ///
  /// In en, this message translates to:
  /// **'No content'**
  String get noContent;

  /// No description provided for @untitled.
  ///
  /// In en, this message translates to:
  /// **'Untitled'**
  String get untitled;

  /// No description provided for @chooseWallpapers.
  ///
  /// In en, this message translates to:
  /// **'Choose from 10+ dynamic wallpapers'**
  String get chooseWallpapers;

  /// No description provided for @backupData.
  ///
  /// In en, this message translates to:
  /// **'Backup Data'**
  String get backupData;

  /// No description provided for @saveJsonFile.
  ///
  /// In en, this message translates to:
  /// **'Save a JSON file containing all your data?'**
  String get saveJsonFile;

  /// No description provided for @exportNow.
  ///
  /// In en, this message translates to:
  /// **'Export Now'**
  String get exportNow;

  /// No description provided for @importDataTitle.
  ///
  /// In en, this message translates to:
  /// **'Import Data'**
  String get importDataTitle;

  /// No description provided for @mergeBackupFile.
  ///
  /// In en, this message translates to:
  /// **'Merge a backup file with your current items?'**
  String get mergeBackupFile;

  /// No description provided for @selectFile.
  ///
  /// In en, this message translates to:
  /// **'Select File'**
  String get selectFile;

  /// No description provided for @backupSaved.
  ///
  /// In en, this message translates to:
  /// **'Backup saved successfully!'**
  String get backupSaved;

  /// No description provided for @exportFailed.
  ///
  /// In en, this message translates to:
  /// **'Export failed.'**
  String get exportFailed;

  /// No description provided for @importSuccess.
  ///
  /// In en, this message translates to:
  /// **'{count} items restored successfully!'**
  String importSuccess(Object count);

  /// No description provided for @importFailed.
  ///
  /// In en, this message translates to:
  /// **'Import failed.'**
  String get importFailed;

  /// No description provided for @widgetAdded.
  ///
  /// In en, this message translates to:
  /// **'Widget added to Home Screen!'**
  String widgetAdded(Object widget);

  /// No description provided for @widgetRequestSent.
  ///
  /// In en, this message translates to:
  /// **'Widget request sent. Please check your home screen.'**
  String get widgetRequestSent;

  /// No description provided for @widgetAddFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to add widget'**
  String get widgetAddFailed;

  /// No description provided for @autoSaveEnabled.
  ///
  /// In en, this message translates to:
  /// **'Auto-save enabled.'**
  String get autoSaveEnabled;

  /// No description provided for @autoSaveDisabled.
  ///
  /// In en, this message translates to:
  /// **'Auto-save disabled.'**
  String get autoSaveDisabled;

  /// No description provided for @homeScreenWidgets.
  ///
  /// In en, this message translates to:
  /// **'Home Screen Widgets'**
  String get homeScreenWidgets;

  /// No description provided for @notificationsTitle.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notificationsTitle;

  /// No description provided for @dataBackup.
  ///
  /// In en, this message translates to:
  /// **'Data & Backup'**
  String get dataBackup;

  /// No description provided for @feedbackSupport.
  ///
  /// In en, this message translates to:
  /// **'Feedback & Support'**
  String get feedbackSupport;

  /// No description provided for @creditsTitle.
  ///
  /// In en, this message translates to:
  /// **'Credits'**
  String get creditsTitle;

  /// No description provided for @privacyMaintenance.
  ///
  /// In en, this message translates to:
  /// **'Privacy & Maintenance'**
  String get privacyMaintenance;

  /// No description provided for @aboutTitle.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get aboutTitle;

  /// No description provided for @premium.
  ///
  /// In en, this message translates to:
  /// **'Premium'**
  String get premium;

  /// No description provided for @appearanceTitle.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get appearanceTitle;

  /// No description provided for @clipboardTitle.
  ///
  /// In en, this message translates to:
  /// **'Clipboard'**
  String get clipboardTitle;

  /// No description provided for @settingsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Customize Your Experience'**
  String get settingsSubtitle;

  /// No description provided for @welcomeTitle.
  ///
  /// In en, this message translates to:
  /// **'Welcome to CopyClip'**
  String get welcomeTitle;

  /// No description provided for @welcomeDescription.
  ///
  /// In en, this message translates to:
  /// **'Your ultimate productivity companion. Let\'s get you set up with powerful tools to manage your day.'**
  String get welcomeDescription;

  /// No description provided for @onboardingNotesTitle.
  ///
  /// In en, this message translates to:
  /// **'Smart Notes'**
  String get onboardingNotesTitle;

  /// No description provided for @onboardingNotesDesc.
  ///
  /// In en, this message translates to:
  /// **'Capture ideas instantly with rich text formatting. Organize your thoughts and never lose a great idea again.'**
  String get onboardingNotesDesc;

  /// No description provided for @onboardingTodosTitle.
  ///
  /// In en, this message translates to:
  /// **'Task Management'**
  String get onboardingTodosTitle;

  /// No description provided for @onboardingTodosDesc.
  ///
  /// In en, this message translates to:
  /// **'Stay on top of your game. Create to-do lists, set priorities, and crush your goals one checkmark at a time.'**
  String get onboardingTodosDesc;

  /// No description provided for @onboardingExpensesTitle.
  ///
  /// In en, this message translates to:
  /// **'Expense Tracking'**
  String get onboardingExpensesTitle;

  /// No description provided for @onboardingExpensesDesc.
  ///
  /// In en, this message translates to:
  /// **'Take control of your finances. Track income and expenses easily to understand your spending habits.'**
  String get onboardingExpensesDesc;

  /// No description provided for @onboardingJournalTitle.
  ///
  /// In en, this message translates to:
  /// **'Personal Journal'**
  String get onboardingJournalTitle;

  /// No description provided for @onboardingJournalDesc.
  ///
  /// In en, this message translates to:
  /// **'Reflect on your day. A private space to write down your memories, feelings, and daily experiences.'**
  String get onboardingJournalDesc;

  /// No description provided for @onboardingCalendarTitle.
  ///
  /// In en, this message translates to:
  /// **'Calendar & Events'**
  String get onboardingCalendarTitle;

  /// No description provided for @onboardingCalendarDesc.
  ///
  /// In en, this message translates to:
  /// **'Never miss a moment. Organize your schedule and keep track of important upcoming events.'**
  String get onboardingCalendarDesc;

  /// No description provided for @onboardingClipboardTitle.
  ///
  /// In en, this message translates to:
  /// **'Clipboard Manager'**
  String get onboardingClipboardTitle;

  /// No description provided for @onboardingClipboardDesc.
  ///
  /// In en, this message translates to:
  /// **'Copy once, paste anywhere. Access your clipboard history to retrieve snippets you copied earlier.'**
  String get onboardingClipboardDesc;

  /// No description provided for @onboardingCanvasTitle.
  ///
  /// In en, this message translates to:
  /// **'Creative Canvas'**
  String get onboardingCanvasTitle;

  /// No description provided for @onboardingCanvasDesc.
  ///
  /// In en, this message translates to:
  /// **'Unleash your creativity. Draw, sketch, and visualize your ideas on a free-form digital canvas.'**
  String get onboardingCanvasDesc;

  /// No description provided for @featuresNotesDesc.
  ///
  /// In en, this message translates to:
  /// **'Create and manage your notes'**
  String get featuresNotesDesc;

  /// No description provided for @featuresTodosDesc.
  ///
  /// In en, this message translates to:
  /// **'Keep track of your tasks'**
  String get featuresTodosDesc;

  /// No description provided for @featuresExpensesDesc.
  ///
  /// In en, this message translates to:
  /// **'Monitor your expenses'**
  String get featuresExpensesDesc;

  /// No description provided for @featuresJournalDesc.
  ///
  /// In en, this message translates to:
  /// **'Write down your thoughts'**
  String get featuresJournalDesc;

  /// No description provided for @featuresCalendarDesc.
  ///
  /// In en, this message translates to:
  /// **'Organize your schedule'**
  String get featuresCalendarDesc;

  /// No description provided for @featuresClipboardDesc.
  ///
  /// In en, this message translates to:
  /// **'Access your clipboard history'**
  String get featuresClipboardDesc;

  /// No description provided for @featuresCanvasDesc.
  ///
  /// In en, this message translates to:
  /// **'Draw and sketch freely'**
  String get featuresCanvasDesc;

  /// No description provided for @featuresSocialPost.
  ///
  /// In en, this message translates to:
  /// **'Social Post'**
  String get featuresSocialPost;

  /// No description provided for @featuresSocialPostDesc.
  ///
  /// In en, this message translates to:
  /// **'Create engaging social media content'**
  String get featuresSocialPostDesc;

  /// No description provided for @chooseYourAura.
  ///
  /// In en, this message translates to:
  /// **'Choose Your Aura'**
  String get chooseYourAura;

  /// No description provided for @expressYourselfTheme.
  ///
  /// In en, this message translates to:
  /// **'Express yourself with a new theme color!'**
  String get expressYourselfTheme;

  /// No description provided for @level.
  ///
  /// In en, this message translates to:
  /// **'Level'**
  String get level;

  /// No description provided for @xpToNextLevel.
  ///
  /// In en, this message translates to:
  /// **'XP to Level'**
  String get xpToNextLevel;

  /// No description provided for @checkUpcomingEvents.
  ///
  /// In en, this message translates to:
  /// **'Check upcoming events'**
  String get checkUpcomingEvents;

  /// No description provided for @startNewSketch.
  ///
  /// In en, this message translates to:
  /// **'Start a new sketch'**
  String get startNewSketch;

  /// No description provided for @noTransactionsMonth.
  ///
  /// In en, this message translates to:
  /// **'No transactions this month'**
  String get noTransactionsMonth;

  /// No description provided for @transactionsThisMonth.
  ///
  /// In en, this message translates to:
  /// **'{count} transaction{count, plural, =1{} other{s}} this month'**
  String transactionsThisMonth(num count);

  /// No description provided for @autoSaveClipboard.
  ///
  /// In en, this message translates to:
  /// **'Auto-save Clipboard'**
  String get autoSaveClipboard;

  /// No description provided for @autoSaveClipboardDesc.
  ///
  /// In en, this message translates to:
  /// **'Automatically save copied items'**
  String get autoSaveClipboardDesc;

  /// No description provided for @permissionDeniedSettings.
  ///
  /// In en, this message translates to:
  /// **'Permission permanently denied. Please enable in Settings.'**
  String get permissionDeniedSettings;

  /// No description provided for @notificationsEnabled.
  ///
  /// In en, this message translates to:
  /// **'Notifications enabled!'**
  String get notificationsEnabled;

  /// No description provided for @redirectingToSettings.
  ///
  /// In en, this message translates to:
  /// **'Redirecting to settings to disable notifications...'**
  String get redirectingToSettings;

  /// No description provided for @premiumAccess.
  ///
  /// In en, this message translates to:
  /// **'Premium Access'**
  String get premiumAccess;

  /// No description provided for @premiumActiveUntil.
  ///
  /// In en, this message translates to:
  /// **'Premium Active until'**
  String get premiumActiveUntil;

  /// No description provided for @unlockAllFeatures.
  ///
  /// In en, this message translates to:
  /// **'Unlock All Features'**
  String get unlockAllFeatures;

  /// No description provided for @buyPremium.
  ///
  /// In en, this message translates to:
  /// **'Buy Premium (7 Days)'**
  String get buyPremium;

  /// No description provided for @costCoins.
  ///
  /// In en, this message translates to:
  /// **'Cost: {cost} Coins'**
  String costCoins(Object cost);

  /// No description provided for @premiumActivated.
  ///
  /// In en, this message translates to:
  /// **'Premium Activated for 7 days!'**
  String get premiumActivated;

  /// No description provided for @premiumActive.
  ///
  /// In en, this message translates to:
  /// **'Premium Active'**
  String get premiumActive;

  /// No description provided for @expires.
  ///
  /// In en, this message translates to:
  /// **'Expires:'**
  String get expires;

  /// No description provided for @temporaryAccess.
  ///
  /// In en, this message translates to:
  /// **'Temporary Access'**
  String get temporaryAccess;

  /// No description provided for @journalExpression.
  ///
  /// In en, this message translates to:
  /// **'Journal & Expression'**
  String get journalExpression;

  /// No description provided for @artisticDesigns.
  ///
  /// In en, this message translates to:
  /// **'Artistic Designs'**
  String get artisticDesigns;

  /// No description provided for @artisticDesignsDesc.
  ///
  /// In en, this message translates to:
  /// **'Unlock 10+ unique journal card themes'**
  String get artisticDesignsDesc;

  /// No description provided for @premiumLayouts.
  ///
  /// In en, this message translates to:
  /// **'Premium Layouts'**
  String get premiumLayouts;

  /// No description provided for @premiumLayoutsDesc.
  ///
  /// In en, this message translates to:
  /// **'Exclusive ways to view your memories'**
  String get premiumLayoutsDesc;

  /// No description provided for @calendarTools.
  ///
  /// In en, this message translates to:
  /// **'Calendar & Tools'**
  String get calendarTools;

  /// No description provided for @fullCalendar.
  ///
  /// In en, this message translates to:
  /// **'Full Calendar'**
  String get fullCalendar;

  /// No description provided for @fullCalendarDesc.
  ///
  /// In en, this message translates to:
  /// **'Complete event management system'**
  String get fullCalendarDesc;

  /// No description provided for @clipboardAutoSaveDesc.
  ///
  /// In en, this message translates to:
  /// **'Background clipboard history capture'**
  String get clipboardAutoSaveDesc;

  /// No description provided for @proWidgets.
  ///
  /// In en, this message translates to:
  /// **'Pro Widgets'**
  String get proWidgets;

  /// No description provided for @proWidgetsDesc.
  ///
  /// In en, this message translates to:
  /// **'All features available on your home screen'**
  String get proWidgetsDesc;

  /// No description provided for @dataExport.
  ///
  /// In en, this message translates to:
  /// **'Data & Export'**
  String get dataExport;

  /// No description provided for @advancedBackup.
  ///
  /// In en, this message translates to:
  /// **'Advanced Backup'**
  String get advancedBackup;

  /// No description provided for @advancedBackupDesc.
  ///
  /// In en, this message translates to:
  /// **'Secure import/export of all data'**
  String get advancedBackupDesc;

  /// No description provided for @pdfExport.
  ///
  /// In en, this message translates to:
  /// **'PDF Export'**
  String get pdfExport;

  /// No description provided for @pdfExportDesc.
  ///
  /// In en, this message translates to:
  /// **'Export notes & journals to PDF'**
  String get pdfExportDesc;

  /// No description provided for @printReady.
  ///
  /// In en, this message translates to:
  /// **'Print Ready'**
  String get printReady;

  /// No description provided for @printReadyDesc.
  ///
  /// In en, this message translates to:
  /// **'Direct printing support'**
  String get printReadyDesc;

  /// No description provided for @richTextEditor.
  ///
  /// In en, this message translates to:
  /// **'Rich Text Editor'**
  String get richTextEditor;

  /// No description provided for @advancedSearch.
  ///
  /// In en, this message translates to:
  /// **'Advanced Search'**
  String get advancedSearch;

  /// No description provided for @advancedSearchDesc.
  ///
  /// In en, this message translates to:
  /// **'Search & Replace within your text'**
  String get advancedSearchDesc;

  /// No description provided for @richMedia.
  ///
  /// In en, this message translates to:
  /// **'Rich Media'**
  String get richMedia;

  /// No description provided for @richMediaDesc.
  ///
  /// In en, this message translates to:
  /// **'Insert Images, Videos, and Links'**
  String get richMediaDesc;

  /// No description provided for @editorStyling.
  ///
  /// In en, this message translates to:
  /// **'Editor Styling'**
  String get editorStyling;

  /// No description provided for @editorStylingDesc.
  ///
  /// In en, this message translates to:
  /// **'Custom text and editor backgrounds'**
  String get editorStylingDesc;

  /// No description provided for @balance.
  ///
  /// In en, this message translates to:
  /// **'Balance'**
  String get balance;

  /// No description provided for @loadingAd.
  ///
  /// In en, this message translates to:
  /// **'Loading Ad...'**
  String get loadingAd;

  /// No description provided for @watchAd.
  ///
  /// In en, this message translates to:
  /// **'Watch Ad (+{amount})'**
  String watchAd(Object amount);

  /// No description provided for @loadAd.
  ///
  /// In en, this message translates to:
  /// **'Load Ad'**
  String get loadAd;

  /// No description provided for @backupDataDesc.
  ///
  /// In en, this message translates to:
  /// **'Save a JSON file of your data'**
  String get backupDataDesc;

  /// No description provided for @importDataDesc.
  ///
  /// In en, this message translates to:
  /// **'Merge a backup file into CopyClip'**
  String get importDataDesc;

  /// No description provided for @notificationPermissionDenied.
  ///
  /// In en, this message translates to:
  /// **'Notification permission denied.'**
  String get notificationPermissionDenied;

  /// No description provided for @typeNewTask.
  ///
  /// In en, this message translates to:
  /// **'Type a new task...'**
  String get typeNewTask;

  /// No description provided for @addTask.
  ///
  /// In en, this message translates to:
  /// **'Add a task'**
  String get addTask;

  /// No description provided for @completed.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get completed;

  /// No description provided for @greatJob.
  ///
  /// In en, this message translates to:
  /// **'Great job!'**
  String get greatJob;

  /// No description provided for @youEarnedXPNextTask.
  ///
  /// In en, this message translates to:
  /// **'You earned {amount} XP! Next task: {date}'**
  String youEarnedXPNextTask(Object amount, Object date);

  /// No description provided for @taskCompletedXP.
  ///
  /// In en, this message translates to:
  /// **'Task completed! +{amount} XP'**
  String taskCompletedXP(Object amount);

  /// No description provided for @moveTasksToRecycleBin.
  ///
  /// In en, this message translates to:
  /// **'Move all active tasks to Recycle Bin?'**
  String get moveTasksToRecycleBin;

  /// No description provided for @deleteAllPosts.
  ///
  /// In en, this message translates to:
  /// **'Delete All Posts'**
  String get deleteAllPosts;

  /// No description provided for @deleteAllPostsConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete ALL social posts? This cannot be undone.'**
  String get deleteAllPostsConfirmation;

  /// No description provided for @allPosts.
  ///
  /// In en, this message translates to:
  /// **'All Posts'**
  String get allPosts;

  /// No description provided for @favorites.
  ///
  /// In en, this message translates to:
  /// **'Favorites'**
  String get favorites;

  /// No description provided for @drafts.
  ///
  /// In en, this message translates to:
  /// **'Drafts'**
  String get drafts;

  /// No description provided for @noFavoritesYet.
  ///
  /// In en, this message translates to:
  /// **'No favorites yet'**
  String get noFavoritesYet;

  /// No description provided for @noDraftsYet.
  ///
  /// In en, this message translates to:
  /// **'No drafts yet'**
  String get noDraftsYet;

  /// No description provided for @startSocialJourney.
  ///
  /// In en, this message translates to:
  /// **'Start your social journey!'**
  String get startSocialJourney;

  /// No description provided for @draft.
  ///
  /// In en, this message translates to:
  /// **'DRAFT'**
  String get draft;

  /// No description provided for @attachmentCount.
  ///
  /// In en, this message translates to:
  /// **'{count} attachment{count, plural, =1{} other{s}}'**
  String attachmentCount(num count);

  /// No description provided for @pleaseAddContent.
  ///
  /// In en, this message translates to:
  /// **'Please add some content or media to share'**
  String get pleaseAddContent;

  /// No description provided for @fileNotFoundError.
  ///
  /// In en, this message translates to:
  /// **'Error: File not found at {path}'**
  String fileNotFoundError(Object path);

  /// No description provided for @checkFacebookApp.
  ///
  /// In en, this message translates to:
  /// **'Check Facebook app'**
  String get checkFacebookApp;

  /// No description provided for @systemShare.
  ///
  /// In en, this message translates to:
  /// **'System Share'**
  String get systemShare;

  /// No description provided for @socialPost.
  ///
  /// In en, this message translates to:
  /// **'Social Post'**
  String get socialPost;

  /// No description provided for @favorite.
  ///
  /// In en, this message translates to:
  /// **'Favorite'**
  String get favorite;

  /// No description provided for @saveDraft.
  ///
  /// In en, this message translates to:
  /// **'Save Draft'**
  String get saveDraft;

  /// No description provided for @entryCopied.
  ///
  /// In en, this message translates to:
  /// **'Entry copied'**
  String get entryCopied;

  /// No description provided for @moveEntriesToRecycleBin.
  ///
  /// In en, this message translates to:
  /// **'Move all active entries to Recycle Bin?'**
  String get moveEntriesToRecycleBin;

  /// No description provided for @startWritingStory.
  ///
  /// In en, this message translates to:
  /// **'Start writing your story'**
  String get startWritingStory;

  /// No description provided for @recordMemories.
  ///
  /// In en, this message translates to:
  /// **'Record your daily memories and feelings.'**
  String get recordMemories;

  /// No description provided for @writeJournal.
  ///
  /// In en, this message translates to:
  /// **'Write Journal'**
  String get writeJournal;

  /// No description provided for @myMemories.
  ///
  /// In en, this message translates to:
  /// **'My Memories'**
  String get myMemories;

  /// No description provided for @sortJournal.
  ///
  /// In en, this message translates to:
  /// **'Sort Journal'**
  String get sortJournal;

  /// No description provided for @byMood.
  ///
  /// In en, this message translates to:
  /// **'By Mood'**
  String get byMood;

  /// No description provided for @searchMemories.
  ///
  /// In en, this message translates to:
  /// **'Search memories...'**
  String get searchMemories;

  /// No description provided for @selectAll.
  ///
  /// In en, this message translates to:
  /// **'Select All'**
  String get selectAll;

  /// No description provided for @deleteSelected.
  ///
  /// In en, this message translates to:
  /// **'Delete Selected'**
  String get deleteSelected;

  /// No description provided for @taskCompletedExclamation.
  ///
  /// In en, this message translates to:
  /// **'Task completed!'**
  String get taskCompletedExclamation;

  /// No description provided for @taskUncompletedExclamation.
  ///
  /// In en, this message translates to:
  /// **'Task uncompleted'**
  String get taskUncompletedExclamation;

  /// No description provided for @clipboardUpdatedExclamation.
  ///
  /// In en, this message translates to:
  /// **'Clipboard updated!'**
  String get clipboardUpdatedExclamation;

  /// No description provided for @clipboardSavedContent.
  ///
  /// In en, this message translates to:
  /// **'Clipboard saved: {content}'**
  String clipboardSavedContent(Object content);

  /// No description provided for @overview.
  ///
  /// In en, this message translates to:
  /// **'Overview'**
  String get overview;

  /// No description provided for @colorAurora.
  ///
  /// In en, this message translates to:
  /// **'Aurora'**
  String get colorAurora;

  /// No description provided for @colorCosmic.
  ///
  /// In en, this message translates to:
  /// **'Cosmic'**
  String get colorCosmic;

  /// No description provided for @colorNebula.
  ///
  /// In en, this message translates to:
  /// **'Nebula'**
  String get colorNebula;

  /// No description provided for @colorStarlight.
  ///
  /// In en, this message translates to:
  /// **'Starlight'**
  String get colorStarlight;

  /// No description provided for @colorSolar.
  ///
  /// In en, this message translates to:
  /// **'Solar'**
  String get colorSolar;

  /// No description provided for @colorNova.
  ///
  /// In en, this message translates to:
  /// **'Nova'**
  String get colorNova;

  /// No description provided for @loadingStepLoading.
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get loadingStepLoading;

  /// No description provided for @loadingStepDatabase.
  ///
  /// In en, this message translates to:
  /// **'Setting up database...'**
  String get loadingStepDatabase;

  /// No description provided for @loadingStepSystem.
  ///
  /// In en, this message translates to:
  /// **'Configuring system...'**
  String get loadingStepSystem;

  /// No description provided for @loadingStepReady.
  ///
  /// In en, this message translates to:
  /// **'Ready'**
  String get loadingStepReady;

  /// No description provided for @productivityCompanion.
  ///
  /// In en, this message translates to:
  /// **'Your productivity companion'**
  String get productivityCompanion;

  /// No description provided for @done.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get done;

  /// No description provided for @newNote.
  ///
  /// In en, this message translates to:
  /// **'New Note'**
  String get newNote;

  /// No description provided for @changeColor.
  ///
  /// In en, this message translates to:
  /// **'Change Color'**
  String get changeColor;

  /// No description provided for @copyContent.
  ///
  /// In en, this message translates to:
  /// **'Copy Content'**
  String get copyContent;

  /// No description provided for @titleOptional.
  ///
  /// In en, this message translates to:
  /// **'Title (Optional)'**
  String get titleOptional;

  /// No description provided for @exportAsPdf.
  ///
  /// In en, this message translates to:
  /// **'Export as PDF'**
  String get exportAsPdf;

  /// No description provided for @taskDueNow.
  ///
  /// In en, this message translates to:
  /// **'Task Due Now'**
  String get taskDueNow;

  /// No description provided for @moveTaskToBinTitle.
  ///
  /// In en, this message translates to:
  /// **'Move Task to Recycle Bin?'**
  String get moveTaskToBinTitle;

  /// No description provided for @restoreTaskLater.
  ///
  /// In en, this message translates to:
  /// **'You can restore this task later from settings.'**
  String get restoreTaskLater;

  /// No description provided for @newTask.
  ///
  /// In en, this message translates to:
  /// **'New Task'**
  String get newTask;

  /// No description provided for @editTask.
  ///
  /// In en, this message translates to:
  /// **'Edit Task'**
  String get editTask;

  /// No description provided for @undo.
  ///
  /// In en, this message translates to:
  /// **'Undo'**
  String get undo;

  /// No description provided for @redo.
  ///
  /// In en, this message translates to:
  /// **'Redo'**
  String get redo;

  /// No description provided for @category.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get category;

  /// No description provided for @categoryHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Work, Gym'**
  String get categoryHint;

  /// No description provided for @whatNeedsToBeDone.
  ///
  /// In en, this message translates to:
  /// **'What needs to be done?'**
  String get whatNeedsToBeDone;

  /// No description provided for @enterTaskDetails.
  ///
  /// In en, this message translates to:
  /// **'Enter task details...'**
  String get enterTaskDetails;

  /// No description provided for @setDueDate.
  ///
  /// In en, this message translates to:
  /// **'Set Due Date'**
  String get setDueDate;

  /// No description provided for @dueDate.
  ///
  /// In en, this message translates to:
  /// **'Due Date'**
  String get dueDate;

  /// No description provided for @expenseTitle.
  ///
  /// In en, this message translates to:
  /// **'Expenses'**
  String get expenseTitle;

  /// No description provided for @searchInCurrency.
  ///
  /// In en, this message translates to:
  /// **'Search in {currency}...'**
  String searchInCurrency(String currency);

  /// No description provided for @sortAndFilter.
  ///
  /// In en, this message translates to:
  /// **'Sort & Filter'**
  String get sortAndFilter;

  /// No description provided for @sortBy.
  ///
  /// In en, this message translates to:
  /// **'SORT BY'**
  String get sortBy;

  /// No description provided for @highestAmount.
  ///
  /// In en, this message translates to:
  /// **'Highest Amount'**
  String get highestAmount;

  /// No description provided for @lowestAmount.
  ///
  /// In en, this message translates to:
  /// **'Lowest Amount'**
  String get lowestAmount;

  /// No description provided for @moreFilters.
  ///
  /// In en, this message translates to:
  /// **'More Filters...'**
  String get moreFilters;

  /// No description provided for @filterExpenses.
  ///
  /// In en, this message translates to:
  /// **'Filter Expenses'**
  String get filterExpenses;

  /// No description provided for @transactionType.
  ///
  /// In en, this message translates to:
  /// **'Transaction Type'**
  String get transactionType;

  /// No description provided for @categories.
  ///
  /// In en, this message translates to:
  /// **'Categories'**
  String get categories;

  /// No description provided for @all.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get all;

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

  /// No description provided for @reset.
  ///
  /// In en, this message translates to:
  /// **'Reset'**
  String get reset;

  /// No description provided for @apply.
  ///
  /// In en, this message translates to:
  /// **'Apply'**
  String get apply;

  /// No description provided for @newExpense.
  ///
  /// In en, this message translates to:
  /// **'New {currency}'**
  String newExpense(String currency);

  /// No description provided for @errorLoadingData.
  ///
  /// In en, this message translates to:
  /// **'Error loading data.\n\n{error}'**
  String errorLoadingData(String error);

  /// No description provided for @dailyQuote1.
  ///
  /// In en, this message translates to:
  /// **'The best way to predict the future is to create it.'**
  String get dailyQuote1;

  /// No description provided for @dailyQuote2.
  ///
  /// In en, this message translates to:
  /// **'Wealth consists not in having great possessions, but in having few wants.'**
  String get dailyQuote2;

  /// No description provided for @dailyQuote3.
  ///
  /// In en, this message translates to:
  /// **'Time is the ultimate currency.'**
  String get dailyQuote3;

  /// No description provided for @dailyQuote4.
  ///
  /// In en, this message translates to:
  /// **'Success is not final, failure is not fatal.'**
  String get dailyQuote4;

  /// No description provided for @dailyQuote5.
  ///
  /// In en, this message translates to:
  /// **'Focus on the solution, not the problem.'**
  String get dailyQuote5;

  /// No description provided for @dailyQuote6.
  ///
  /// In en, this message translates to:
  /// **'Your network is your net worth.'**
  String get dailyQuote6;

  /// No description provided for @moodHappy.
  ///
  /// In en, this message translates to:
  /// **'Happy'**
  String get moodHappy;

  /// No description provided for @moodExcited.
  ///
  /// In en, this message translates to:
  /// **'Excited'**
  String get moodExcited;

  /// No description provided for @moodNeutral.
  ///
  /// In en, this message translates to:
  /// **'Neutral'**
  String get moodNeutral;

  /// No description provided for @moodSad.
  ///
  /// In en, this message translates to:
  /// **'Sad'**
  String get moodSad;

  /// No description provided for @moodStressed.
  ///
  /// In en, this message translates to:
  /// **'Stressed'**
  String get moodStressed;

  /// No description provided for @exportDate.
  ///
  /// In en, this message translates to:
  /// **'📅 {date}'**
  String exportDate(String date);

  /// No description provided for @exportMood.
  ///
  /// In en, this message translates to:
  /// **'Mood: {emoji} {mood}'**
  String exportMood(String emoji, String mood);

  /// No description provided for @exportTitle.
  ///
  /// In en, this message translates to:
  /// **'TITLE: {title}'**
  String exportTitle(String title);

  /// No description provided for @exportTags.
  ///
  /// In en, this message translates to:
  /// **'\nTags: {tags}'**
  String exportTags(String tags);

  /// No description provided for @instagram.
  ///
  /// In en, this message translates to:
  /// **'Instagram'**
  String get instagram;

  /// No description provided for @facebook.
  ///
  /// In en, this message translates to:
  /// **'Facebook'**
  String get facebook;

  /// No description provided for @tiktok.
  ///
  /// In en, this message translates to:
  /// **'TikTok'**
  String get tiktok;

  /// No description provided for @newSketch.
  ///
  /// In en, this message translates to:
  /// **'New Sketch'**
  String get newSketch;

  /// No description provided for @searchSketches.
  ///
  /// In en, this message translates to:
  /// **'Search sketches and folders...'**
  String get searchSketches;

  /// No description provided for @noResultsFound.
  ///
  /// In en, this message translates to:
  /// **'No results found'**
  String get noResultsFound;

  /// No description provided for @noItems.
  ///
  /// In en, this message translates to:
  /// **'No items'**
  String get noItems;

  /// No description provided for @noDrawingsYet.
  ///
  /// In en, this message translates to:
  /// **'No drawings yet'**
  String get noDrawingsYet;

  /// No description provided for @canvasIntro.
  ///
  /// In en, this message translates to:
  /// **'Unleash your creativity on the canvas!'**
  String get canvasIntro;

  /// No description provided for @newCanvas.
  ///
  /// In en, this message translates to:
  /// **'New Canvas'**
  String get newCanvas;

  /// No description provided for @rename.
  ///
  /// In en, this message translates to:
  /// **'Rename'**
  String get rename;

  /// No description provided for @deleteFolder.
  ///
  /// In en, this message translates to:
  /// **'Delete Folder'**
  String get deleteFolder;

  /// No description provided for @deleteSketchesQuestion.
  ///
  /// In en, this message translates to:
  /// **'Delete Sketches?'**
  String get deleteSketchesQuestion;

  /// No description provided for @deleteFolderConfirmation.
  ///
  /// In en, this message translates to:
  /// **'All sketches in this folder will be deleted permanently.'**
  String get deleteFolderConfirmation;

  /// No description provided for @renameFolder.
  ///
  /// In en, this message translates to:
  /// **'Rename Folder'**
  String get renameFolder;

  /// No description provided for @chooseColor.
  ///
  /// In en, this message translates to:
  /// **'Choose Color'**
  String get chooseColor;

  /// No description provided for @deleteFolderQuestion.
  ///
  /// In en, this message translates to:
  /// **'Delete Folder?'**
  String get deleteFolderQuestion;

  /// No description provided for @searchClips.
  ///
  /// In en, this message translates to:
  /// **'Search clips...'**
  String get searchClips;

  /// No description provided for @clipboardEmpty.
  ///
  /// In en, this message translates to:
  /// **'Clipboard is empty'**
  String get clipboardEmpty;

  /// No description provided for @addItem.
  ///
  /// In en, this message translates to:
  /// **'Add Item'**
  String get addItem;

  /// No description provided for @clipColor.
  ///
  /// In en, this message translates to:
  /// **'Clip Color'**
  String get clipColor;

  /// No description provided for @newClip.
  ///
  /// In en, this message translates to:
  /// **'New Clip'**
  String get newClip;

  /// No description provided for @editClip.
  ///
  /// In en, this message translates to:
  /// **'Edit Clip'**
  String get editClip;

  /// No description provided for @restoreClipLater.
  ///
  /// In en, this message translates to:
  /// **'You can restore this clip later.'**
  String get restoreClipLater;

  /// No description provided for @upcomingEvents.
  ///
  /// In en, this message translates to:
  /// **'Upcoming Events'**
  String get upcomingEvents;

  /// No description provided for @dataDistribution.
  ///
  /// In en, this message translates to:
  /// **'DATA DISTRIBUTION'**
  String get dataDistribution;

  /// No description provided for @taskProgress.
  ///
  /// In en, this message translates to:
  /// **'TASK PROGRESS'**
  String get taskProgress;

  /// No description provided for @quickStats.
  ///
  /// In en, this message translates to:
  /// **'QUICK STATS'**
  String get quickStats;

  /// No description provided for @taskCompletion.
  ///
  /// In en, this message translates to:
  /// **'Task Completion'**
  String get taskCompletion;

  /// No description provided for @noItemsForDate.
  ///
  /// In en, this message translates to:
  /// **'No items for this date'**
  String get noItemsForDate;

  /// No description provided for @enjoyFreeTime.
  ///
  /// In en, this message translates to:
  /// **'Enjoy your free time!'**
  String get enjoyFreeTime;

  /// No description provided for @searchThisDay.
  ///
  /// In en, this message translates to:
  /// **'Search in this day...'**
  String get searchThisDay;

  /// No description provided for @finance.
  ///
  /// In en, this message translates to:
  /// **'Finance'**
  String get finance;

  /// No description provided for @permanentlyDelete.
  ///
  /// In en, this message translates to:
  /// **'Permanently Delete?'**
  String get permanentlyDelete;

  /// No description provided for @deleteSelectionConfirmation.
  ///
  /// In en, this message translates to:
  /// **'This will permanently delete {foldersCount} folders (and their sketches) and {sketchesCount} other sketches.\n\nThis cannot be undone.'**
  String deleteSelectionConfirmation(int foldersCount, int sketchesCount);

  /// No description provided for @deleteForever.
  ///
  /// In en, this message translates to:
  /// **'Delete Forever'**
  String get deleteForever;

  /// No description provided for @selectedCount.
  ///
  /// In en, this message translates to:
  /// **'{count} Selected'**
  String selectedCount(int count);

  /// No description provided for @canvasStats.
  ///
  /// In en, this message translates to:
  /// **'{notes} sketches • {folders} folders'**
  String canvasStats(int notes, int folders);

  /// No description provided for @sortItems.
  ///
  /// In en, this message translates to:
  /// **'Sort Items'**
  String get sortItems;

  /// No description provided for @sortNameAZ.
  ///
  /// In en, this message translates to:
  /// **'Name (A-Z)'**
  String get sortNameAZ;

  /// No description provided for @sortNameZA.
  ///
  /// In en, this message translates to:
  /// **'Name (Z-A)'**
  String get sortNameZA;

  /// No description provided for @createFolder.
  ///
  /// In en, this message translates to:
  /// **'Create Folder'**
  String get createFolder;

  /// No description provided for @folderNameHint.
  ///
  /// In en, this message translates to:
  /// **'Folder name...'**
  String get folderNameHint;

  /// No description provided for @deleteSketchesConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Delete {count} sketches? This cannot be undone.'**
  String deleteSketchesConfirmation(int count);

  /// No description provided for @noSketchesFound.
  ///
  /// In en, this message translates to:
  /// **'No sketches found'**
  String get noSketchesFound;

  /// No description provided for @noSketchesFoundSub.
  ///
  /// In en, this message translates to:
  /// **'Try adjusting your search or creating a new sketch.'**
  String get noSketchesFoundSub;

  /// No description provided for @searchInFolder.
  ///
  /// In en, this message translates to:
  /// **'Search in {folder}...'**
  String searchInFolder(String folder);

  /// No description provided for @sketchesCount.
  ///
  /// In en, this message translates to:
  /// **'{count} sketches'**
  String sketchesCount(int count);

  /// No description provided for @sortSketches.
  ///
  /// In en, this message translates to:
  /// **'Sort Sketches'**
  String get sortSketches;

  /// No description provided for @calendarScreenTitle.
  ///
  /// In en, this message translates to:
  /// **'Calendar'**
  String get calendarScreenTitle;

  /// No description provided for @dailyActivity.
  ///
  /// In en, this message translates to:
  /// **'Daily Activity'**
  String get dailyActivity;

  /// No description provided for @deleteItemQuestion.
  ///
  /// In en, this message translates to:
  /// **'Delete Item?'**
  String get deleteItemQuestion;

  /// No description provided for @deleteItemConfirmation.
  ///
  /// In en, this message translates to:
  /// **'This will move the item to the recycle bin.'**
  String get deleteItemConfirmation;

  /// No description provided for @moveToBinItem.
  ///
  /// In en, this message translates to:
  /// **'Move to Bin?'**
  String get moveToBinItem;

  /// No description provided for @moveToBinConfirmation.
  ///
  /// In en, this message translates to:
  /// **'You can restore it later.'**
  String get moveToBinConfirmation;

  /// No description provided for @selectedItems.
  ///
  /// In en, this message translates to:
  /// **'{count} Selected'**
  String selectedItems(int count);

  /// No description provided for @recentClips.
  ///
  /// In en, this message translates to:
  /// **'Recent Clips'**
  String get recentClips;

  /// No description provided for @copied.
  ///
  /// In en, this message translates to:
  /// **'Copied!'**
  String get copied;

  /// No description provided for @copiedPlainText.
  ///
  /// In en, this message translates to:
  /// **'Copied plain text'**
  String get copiedPlainText;

  /// No description provided for @clipTheme.
  ///
  /// In en, this message translates to:
  /// **'Clip Theme'**
  String get clipTheme;

  /// No description provided for @justNow.
  ///
  /// In en, this message translates to:
  /// **'Just now'**
  String get justNow;

  /// No description provided for @minutesAgo.
  ///
  /// In en, this message translates to:
  /// **'{count}m ago'**
  String minutesAgo(Object count);

  /// No description provided for @hoursAgo.
  ///
  /// In en, this message translates to:
  /// **'{count}h ago'**
  String hoursAgo(Object count);

  /// No description provided for @daysAgo.
  ///
  /// In en, this message translates to:
  /// **'{count}d ago'**
  String daysAgo(Object count);

  /// No description provided for @noTasksFound.
  ///
  /// In en, this message translates to:
  /// **'No tasks found.'**
  String get noTasksFound;

  /// No description provided for @searchTasks.
  ///
  /// In en, this message translates to:
  /// **'Search tasks...'**
  String get searchTasks;

  /// No description provided for @taskReminder.
  ///
  /// In en, this message translates to:
  /// **'Task Reminder'**
  String get taskReminder;

  /// No description provided for @untitledNote.
  ///
  /// In en, this message translates to:
  /// **'Untitled Note'**
  String get untitledNote;

  /// No description provided for @dailyEntry.
  ///
  /// In en, this message translates to:
  /// **'Daily Entry'**
  String get dailyEntry;

  /// No description provided for @clipboardHistory.
  ///
  /// In en, this message translates to:
  /// **'Clipboard History'**
  String get clipboardHistory;

  /// No description provided for @deletePermanentlyContent.
  ///
  /// In en, this message translates to:
  /// **'This action cannot be undone.'**
  String get deletePermanentlyContent;

  /// No description provided for @emptyRecycleBinTitle.
  ///
  /// In en, this message translates to:
  /// **'Empty Recycle Bin?'**
  String get emptyRecycleBinTitle;

  /// No description provided for @emptyRecycleBinContent.
  ///
  /// In en, this message translates to:
  /// **'All {count} items will be permanently deleted.'**
  String emptyRecycleBinContent(Object count);

  /// No description provided for @emptyBin.
  ///
  /// In en, this message translates to:
  /// **'Empty Bin'**
  String get emptyBin;

  /// No description provided for @recycleBinEmpty.
  ///
  /// In en, this message translates to:
  /// **'Recycle Bin is empty'**
  String get recycleBinEmpty;

  /// No description provided for @deletedItemsAppearHere.
  ///
  /// In en, this message translates to:
  /// **'Deleted items will appear here.'**
  String get deletedItemsAppearHere;

  /// No description provided for @empty.
  ///
  /// In en, this message translates to:
  /// **'Empty'**
  String get empty;

  /// No description provided for @recent.
  ///
  /// In en, this message translates to:
  /// **'Recent'**
  String get recent;

  /// No description provided for @categoryLabel.
  ///
  /// In en, this message translates to:
  /// **'Category: {category}'**
  String categoryLabel(Object category);

  /// No description provided for @general.
  ///
  /// In en, this message translates to:
  /// **'General'**
  String get general;

  /// No description provided for @saveTransactionQuestion.
  ///
  /// In en, this message translates to:
  /// **'Do you want to save this transaction?'**
  String get saveTransactionQuestion;

  /// No description provided for @fillTitleAmount.
  ///
  /// In en, this message translates to:
  /// **'Please fill in title and amount'**
  String get fillTitleAmount;

  /// No description provided for @invalidAmount.
  ///
  /// In en, this message translates to:
  /// **'Invalid amount format'**
  String get invalidAmount;

  /// No description provided for @moveTransactionToBinTitle.
  ///
  /// In en, this message translates to:
  /// **'Move Transaction to Recycle Bin?'**
  String get moveTransactionToBinTitle;

  /// No description provided for @restoreTransactionLater.
  ///
  /// In en, this message translates to:
  /// **'You can restore this transaction later from settings.'**
  String get restoreTransactionLater;

  /// No description provided for @newTransaction.
  ///
  /// In en, this message translates to:
  /// **'New Transaction'**
  String get newTransaction;

  /// No description provided for @whatIsThisFor.
  ///
  /// In en, this message translates to:
  /// **'What is this for?'**
  String get whatIsThisFor;

  /// No description provided for @description.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get description;

  /// No description provided for @daily.
  ///
  /// In en, this message translates to:
  /// **'Daily'**
  String get daily;

  /// No description provided for @weekly.
  ///
  /// In en, this message translates to:
  /// **'Weekly'**
  String get weekly;

  /// No description provided for @monthly.
  ///
  /// In en, this message translates to:
  /// **'Monthly'**
  String get monthly;

  /// No description provided for @yearly.
  ///
  /// In en, this message translates to:
  /// **'Yearly'**
  String get yearly;

  /// No description provided for @totalIncome.
  ///
  /// In en, this message translates to:
  /// **'Total Income'**
  String get totalIncome;

  /// No description provided for @totalExpense.
  ///
  /// In en, this message translates to:
  /// **'Total Expense'**
  String get totalExpense;

  /// No description provided for @analysis.
  ///
  /// In en, this message translates to:
  /// **'Analysis'**
  String get analysis;

  /// No description provided for @transactions.
  ///
  /// In en, this message translates to:
  /// **'Transactions'**
  String get transactions;

  /// No description provided for @noExpensesFound.
  ///
  /// In en, this message translates to:
  /// **'No expenses found for this period.'**
  String get noExpensesFound;

  /// No description provided for @netBalance.
  ///
  /// In en, this message translates to:
  /// **'Net Balance'**
  String get netBalance;

  /// No description provided for @topCategories.
  ///
  /// In en, this message translates to:
  /// **'Top Categories'**
  String get topCategories;

  /// No description provided for @spendingTrend.
  ///
  /// In en, this message translates to:
  /// **'Spending Trend'**
  String get spendingTrend;

  /// No description provided for @insights.
  ///
  /// In en, this message translates to:
  /// **'Insights'**
  String get insights;

  /// No description provided for @noExpensesRecorded.
  ///
  /// In en, this message translates to:
  /// **'No expenses recorded'**
  String get noExpensesRecorded;

  /// No description provided for @trackSpendingHabits.
  ///
  /// In en, this message translates to:
  /// **'Track your spending habits easily.'**
  String get trackSpendingHabits;

  /// No description provided for @addExpense.
  ///
  /// In en, this message translates to:
  /// **'Add Expense'**
  String get addExpense;

  /// No description provided for @noDataForPeriod.
  ///
  /// In en, this message translates to:
  /// **'No data for this period'**
  String get noDataForPeriod;

  /// No description provided for @budget.
  ///
  /// In en, this message translates to:
  /// **'Budget'**
  String get budget;

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

  /// No description provided for @overBudget.
  ///
  /// In en, this message translates to:
  /// **'Over Budget!'**
  String get overBudget;

  /// No description provided for @remainingBudget.
  ///
  /// In en, this message translates to:
  /// **'{percent}% remaining'**
  String remainingBudget(Object percent);

  /// No description provided for @savingsRate.
  ///
  /// In en, this message translates to:
  /// **'Savings Rate'**
  String get savingsRate;

  /// No description provided for @healthScore.
  ///
  /// In en, this message translates to:
  /// **'Health Score'**
  String get healthScore;

  /// No description provided for @healthScoreExplanation.
  ///
  /// In en, this message translates to:
  /// **'This score is based on your Savings Rate.\n\n• > 50% saved = Excellent (100)\n• 0% saved = Average (50)\n• Spending > Income = Poor (<50)'**
  String get healthScoreExplanation;

  /// No description provided for @ok.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get ok;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>[
    'de',
    'en',
    'es',
    'fr',
    'hi',
    'zh',
  ].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'de':
      return AppLocalizationsDe();
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'fr':
      return AppLocalizationsFr();
    case 'hi':
      return AppLocalizationsHi();
    case 'zh':
      return AppLocalizationsZh();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
