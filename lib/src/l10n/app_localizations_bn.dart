// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Bengali Bangla (`bn`).
class AppLocalizationsBn extends AppLocalizations {
  AppLocalizationsBn([String locale = 'bn']) : super(locale);

  @override
  String get settings => 'সেটিংস';

  @override
  String get language => 'ভাষা';

  @override
  String get systemDefault => 'সিস্টেম ডিফল্ট';

  @override
  String get notes => 'নোট';

  @override
  String get todos => 'করণীয়';

  @override
  String get expenses => 'খরচ';

  @override
  String get journal => 'জার্নাল';

  @override
  String get calendar => 'ক্যালেন্ডার';

  @override
  String get clipboard => 'ক্লিপবোর্ড';

  @override
  String get canvas => 'ক্যানভাস';

  @override
  String get save => 'সংরক্ষণ করুন';

  @override
  String get create => 'তৈরি করুন';

  @override
  String get cancel => 'বাতিল করুন';

  @override
  String get delete => 'মুছে দিন';

  @override
  String get edit => 'সম্পাদনা করুন';

  @override
  String get share => 'শেয়ার করুন';

  @override
  String get copy => 'কপি';

  @override
  String get unsavedChanges => 'অসংরক্ষিত পরিবর্তন';

  @override
  String get confirmDelete => 'মুছে ফেলা নিশ্চিত করুন';

  @override
  String get discard => 'বাতিল করুন';

  @override
  String get createPost => 'পোস্ট তৈরি করুন';

  @override
  String get post => 'পোস্ট';

  @override
  String get postingTo => 'পোস্ট করা হচ্ছে';

  @override
  String get whatsOnYourMind => 'আপনার মনে কি আছে?';

  @override
  String get pickImages => 'ছবি বাছাই করুন';

  @override
  String get pickVideo => 'ভিডিও বাছাই করুন';

  @override
  String get camera => 'ক্যামেরা';

  @override
  String get gallery => 'গ্যালারি';

  @override
  String get search => 'অনুসন্ধান করুন';

  @override
  String get pleaseEnterTask => 'একটি টাস্ক লিখুন';

  @override
  String get deleteTask => 'টাস্ক মুছুন';

  @override
  String get selectItems => 'আইটেম নির্বাচন করুন';

  @override
  String get deleteAll => 'সব মুছুন';

  @override
  String error(Object error) {
    return 'ত্রুটি: $error';
  }

  @override
  String get orderingOnlyAvailableInAllPosts =>
      'শুধুমাত্র \'\'সমস্ত পোস্টে\'\' অর্ডার পাওয়া যায়';

  @override
  String get deletePost => 'পোস্ট মুছুন';

  @override
  String get postDeleted => 'পোস্ট মুছে ফেলা হয়েছে';

  @override
  String get premiumFeatures => 'প্রিমিয়াম বৈশিষ্ট্য';

  @override
  String get manageCoinsAdsPremium =>
      'কয়েন, বিজ্ঞাপন এবং প্রিমিয়াম স্থিতি পরিচালনা করুন';

  @override
  String get themeMode => 'থিম মোড';

  @override
  String get accentColor => 'অ্যাকসেন্ট রঙ';

  @override
  String get backgroundDesign => 'ব্যাকগ্রাউন্ড ডিজাইন';

  @override
  String get pushNotifications => 'পুশ বিজ্ঞপ্তি';

  @override
  String get recycleBin => 'রিসাইকেল বিন';

  @override
  String get exportData => 'ডেটা রপ্তানি করুন';

  @override
  String get importData => 'ডেটা আমদানি করুন';

  @override
  String get rateApp => 'অ্যাপকে রেট দিন';

  @override
  String get sendFeedback => 'প্রতিক্রিয়া পাঠান';

  @override
  String get privacyPolicy => 'গোপনীয়তা নীতি';

  @override
  String get version => 'সংস্করণ';

  @override
  String get buildNumber => 'বিল্ড নম্বর';

  @override
  String get system => 'সিস্টেম';

  @override
  String get light => 'আলো';

  @override
  String get dark => 'অন্ধকার';

  @override
  String get itemRestored => 'আইটেম পুনরুদ্ধার করা হয়েছে';

  @override
  String get recycleBinCleared => 'রিসাইকেল বিন সফলভাবে পরিষ্কার করা হয়েছে৷';

  @override
  String get allPostsDeleted => 'সব পোস্ট মুছে ফেলা হয়েছে';

  @override
  String get newPost => 'নতুন পোস্ট';

  @override
  String get textCopiedToClipboardFacebook =>
      'ক্লিপবোর্ডে পাঠ্য অনুলিপি করা হয়েছে (ফেসবুক নীতি)';

  @override
  String get tiktokSharingRequiresVideoImage =>
      'TikTok শেয়ার করার জন্য একটি ভিডিও/ইমেজ প্রয়োজন';

  @override
  String errorSharing(Object error) {
    return 'ভাগ করার ত্রুটি: $error';
  }

  @override
  String shareToStory(Object platform) {
    return '$platform গল্পে শেয়ার করুন';
  }

  @override
  String shareToFeed(Object platform) {
    return '$platform ফিডে শেয়ার করুন';
  }

  @override
  String get unlockPermanently => 'স্থায়ীভাবে আনলক করুন';

  @override
  String get notEnoughCoins => 'পর্যাপ্ত কয়েন নেই!';

  @override
  String youEarnedCoins(Object amount) {
    return 'আপনি $amount কয়েন জিতেছেন!';
  }

  @override
  String get contentCopied => 'কন্টেন্ট কপি করা হয়েছে';

  @override
  String get selectDateTime => 'তারিখ এবং সময় নির্বাচন করুন';

  @override
  String get areYouSureYouWantToDeleteThisPost =>
      'আপনি কি এই পোস্টটি মুছে দেওয়ার বিষয়ে নিশ্চিত?';

  @override
  String get socialPosts => 'সামাজিক পোস্ট';

  @override
  String get watchAdToEarnCoins => 'কয়েন উপার্জন করতে বিজ্ঞাপন দেখুন';

  @override
  String get premiumUnlocked => 'প্রিমিয়াম আনলক করা হয়েছে';

  @override
  String get removeAds => 'বিজ্ঞাপনগুলি সরান';

  @override
  String get unlimitedCloudStorage => 'আনলিমিটেড ক্লাউড স্টোরেজ';

  @override
  String get deleteNote => 'নোট মুছুন';

  @override
  String get shareNote => 'নোট শেয়ার করুন';

  @override
  String get editNote => 'নোট সম্পাদনা করুন';

  @override
  String get searchNotes => 'নোট অনুসন্ধান করুন...';

  @override
  String get noNotesFound => 'কোন নোট পাওয়া যায়নি';

  @override
  String get captureThoughts => 'অবিলম্বে আপনার চিন্তা ক্যাপচার.';

  @override
  String get createNote => 'নোট তৈরি করুন';

  @override
  String get customOrder => 'কাস্টম অর্ডার';

  @override
  String get newestFirst => 'নতুন প্রথম';

  @override
  String get oldestFirst => 'প্রাচীনতম প্রথম';

  @override
  String get titleAZ => 'শিরোনাম: A-Z';

  @override
  String get titleZA => 'শিরোনাম: Z-A';

  @override
  String get deleteAllQuestion => 'সব মুছে ফেলবেন?';

  @override
  String get moveToRecycleBin => 'সমস্ত নোট রিসাইকেল বিনে সরান?';

  @override
  String get moveToBinQuestion => 'বিনে চলে যাবেন?';

  @override
  String get restoreNoteLater => 'আপনি পরে এই নোট পুনরুদ্ধার করতে পারেন.';

  @override
  String get move => 'সরান';

  @override
  String get myThoughts => 'আমার চিন্তা';

  @override
  String get selected => 'নির্বাচিত';

  @override
  String get noContent => 'কোন বিষয়বস্তু নেই';

  @override
  String get untitled => 'শিরোনামহীন';

  @override
  String get chooseWallpapers => '10+ ডাইনামিক ওয়ালপেপার থেকে বেছে নিন';

  @override
  String get backupData => 'ব্যাকআপ ডেটা';

  @override
  String get saveJsonFile =>
      'আপনার সমস্ত ডেটা ধারণকারী একটি JSON ফাইল সংরক্ষণ করবেন?';

  @override
  String get exportNow => 'এখন রপ্তানি করুন';

  @override
  String get importDataTitle => 'ডেটা আমদানি করুন';

  @override
  String get mergeBackupFile =>
      'আপনার বর্তমান আইটেমগুলির সাথে একটি ব্যাকআপ ফাইল মার্জ করবেন?';

  @override
  String get selectFile => 'ফাইল নির্বাচন করুন';

  @override
  String get backupSaved => 'ব্যাকআপ সফলভাবে সংরক্ষিত হয়েছে!';

  @override
  String get exportFailed => 'রপ্তানি ব্যর্থ হয়েছে৷';

  @override
  String importSuccess(Object count) {
    return '$countটি আইটেম সফলভাবে পুনরুদ্ধার করা হয়েছে!';
  }

  @override
  String get importFailed => 'আমদানি ব্যর্থ হয়েছে৷';

  @override
  String widgetAdded(String widget) {
    return 'হোম স্ক্রিনে উইজেট যোগ করা হয়েছে!';
  }

  @override
  String get widgetRequestSent =>
      'উইজেট অনুরোধ পাঠানো হয়েছে. আপনার হোম স্ক্রীন চেক করুন.';

  @override
  String get widgetAddFailed => 'উইজেট যোগ করতে ব্যর্থ হয়েছে';

  @override
  String get autoSaveEnabled => 'স্বতঃ-সংরক্ষণ সক্ষম।';

  @override
  String get autoSaveDisabled => 'স্বয়ংক্রিয় সংরক্ষণ নিষ্ক্রিয়।';

  @override
  String get homeScreenWidgets => 'হোম স্ক্রীন উইজেট';

  @override
  String get notificationsTitle => 'বিজ্ঞপ্তি';

  @override
  String get dataBackup => 'ডেটা এবং ব্যাকআপ';

  @override
  String get feedbackSupport => 'প্রতিক্রিয়া এবং সমর্থন';

  @override
  String get creditsTitle => 'ক্রেডিট';

  @override
  String get privacyMaintenance => 'গোপনীয়তা এবং রক্ষণাবেক্ষণ';

  @override
  String get aboutTitle => 'সম্পর্কে';

  @override
  String get premium => 'প্রিমিয়াম';

  @override
  String get appearanceTitle => 'চেহারা';

  @override
  String get clipboardTitle => 'ক্লিপবোর্ড';

  @override
  String get settingsSubtitle => 'আপনার অভিজ্ঞতা কাস্টমাইজ করুন';

  @override
  String get welcomeTitle => 'কপিক্লিপে স্বাগতম';

  @override
  String get welcomeDescription =>
      'আপনার চূড়ান্ত উত্পাদনশীলতা সহচর. আপনার দিন পরিচালনা করার জন্য শক্তিশালী সরঞ্জামগুলির সাথে আপনাকে সেট আপ করিয়ে দিন।';

  @override
  String get onboardingNotesTitle => 'স্মার্ট নোট';

  @override
  String get onboardingNotesDesc =>
      'রিচ টেক্সট ফরম্যাটিং সহ অবিলম্বে ধারণাগুলি ক্যাপচার করুন৷ আপনার চিন্তা সংগঠিত করুন এবং একটি মহান ধারণা আবার হারান.';

  @override
  String get onboardingTodosTitle => 'টাস্ক ম্যানেজমেন্ট';

  @override
  String get onboardingTodosDesc =>
      'আপনার খেলার শীর্ষে থাকুন। করণীয় তালিকা তৈরি করুন, অগ্রাধিকার সেট করুন এবং আপনার লক্ষ্যগুলিকে একবারে একটি চেকমার্ক করুন।';

  @override
  String get onboardingExpensesTitle => 'ব্যয় ট্র্যাকিং';

  @override
  String get onboardingExpensesDesc =>
      'আপনার আর্থিক নিয়ন্ত্রণ নিন. আপনার খরচের অভ্যাস বুঝতে সহজে আয় এবং খরচ ট্র্যাক করুন।';

  @override
  String get onboardingJournalTitle => 'ব্যক্তিগত জার্নাল';

  @override
  String get onboardingJournalDesc =>
      'আপনার দিনের প্রতিফলন. আপনার স্মৃতি, অনুভূতি এবং দৈনন্দিন অভিজ্ঞতা লিখতে একটি ব্যক্তিগত স্থান।';

  @override
  String get onboardingCalendarTitle => 'ক্যালেন্ডার এবং ইভেন্ট';

  @override
  String get onboardingCalendarDesc =>
      'একটি মুহূর্ত মিস করবেন না. আপনার সময়সূচী সংগঠিত করুন এবং গুরুত্বপূর্ণ আসন্ন ইভেন্টগুলির উপর নজর রাখুন।';

  @override
  String get onboardingClipboardTitle => 'ক্লিপবোর্ড ম্যানেজার';

  @override
  String get onboardingClipboardDesc =>
      'একবার কপি করুন, কোথাও পেস্ট করুন। আপনি আগে কপি করা স্নিপেটগুলি পুনরুদ্ধার করতে আপনার ক্লিপবোর্ড ইতিহাস অ্যাক্সেস করুন৷';

  @override
  String get onboardingCanvasTitle => 'সৃজনশীল ক্যানভাস';

  @override
  String get onboardingCanvasDesc =>
      'আপনার সৃজনশীলতা প্রকাশ করুন. একটি ফ্রি-ফর্ম ডিজিটাল ক্যানভাসে আপনার ধারণাগুলি আঁকুন, স্কেচ করুন এবং কল্পনা করুন৷';

  @override
  String get featuresNotesDesc => 'আপনার নোট তৈরি করুন এবং পরিচালনা করুন';

  @override
  String get featuresTodosDesc => 'আপনার কাজ ট্র্যাক রাখুন';

  @override
  String get featuresExpensesDesc => 'আপনার খরচ নিরীক্ষণ';

  @override
  String get featuresJournalDesc => 'আপনার চিন্তা লিখুন';

  @override
  String get featuresCalendarDesc => 'আপনার সময়সূচী সংগঠিত';

  @override
  String get featuresClipboardDesc => 'আপনার ক্লিপবোর্ড ইতিহাস অ্যাক্সেস করুন';

  @override
  String get featuresCanvasDesc => 'অবাধে আঁকা এবং স্কেচ';

  @override
  String get featuresSocialPost => 'সামাজিক পোস্ট';

  @override
  String get featuresSocialPostDesc =>
      'আকর্ষক সামাজিক মিডিয়া সামগ্রী তৈরি করুন';

  @override
  String get chooseYourAura => 'আপনার আভা চয়ন করুন';

  @override
  String get expressYourselfTheme =>
      'একটি নতুন থিম রঙ দিয়ে নিজেকে প্রকাশ করুন!';

  @override
  String get level => 'স্তর';

  @override
  String get xpToNextLevel => 'এক্সপি থেকে লেভেল';

  @override
  String get checkUpcomingEvents => 'আসন্ন ঘটনা চেক করুন';

  @override
  String get startNewSketch => 'একটি নতুন স্কেচ শুরু করুন';

  @override
  String get noTransactionsMonth => 'এই মাসে কোনো লেনদেন নেই';

  @override
  String transactionsThisMonth(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 's',
      one: '',
    );
    return '$count transaction$_temp0 this month';
  }

  @override
  String get autoSaveClipboard => 'অটো-সেভ ক্লিপবোর্ড';

  @override
  String get autoSaveClipboardDesc =>
      'স্বয়ংক্রিয়ভাবে অনুলিপি আইটেম সংরক্ষণ করুন';

  @override
  String get permissionDeniedSettings =>
      'অনুমতি স্থায়ীভাবে অস্বীকার করা হয়েছে. সেটিংস থেকে সক্রিয় করুন.';

  @override
  String get notificationsEnabled => 'বিজ্ঞপ্তি সক্রিয়!';

  @override
  String get redirectingToSettings =>
      'বিজ্ঞপ্তিগুলি অক্ষম করতে সেটিংসে পুনঃনির্দেশ করা হচ্ছে...';

  @override
  String get premiumAccess => 'প্রিমিয়াম অ্যাক্সেস';

  @override
  String get premiumActiveUntil => 'পর্যন্ত প্রিমিয়াম সক্রিয়';

  @override
  String get unlockAllFeatures => 'সমস্ত বৈশিষ্ট্য আনলক করুন';

  @override
  String get buyPremium => 'প্রিমিয়াম কিনুন (৭ দিন)';

  @override
  String costCoins(Object cost) {
    return 'খরচ: $cost কয়েন';
  }

  @override
  String get premiumActivated => 'প্রিমিয়াম 7 দিনের জন্য সক্রিয়!';

  @override
  String get premiumActive => 'প্রিমিয়াম সক্রিয়';

  @override
  String get expires => 'মেয়াদ শেষ:';

  @override
  String get temporaryAccess => 'অস্থায়ী অ্যাক্সেস';

  @override
  String get journalExpression => 'জার্নাল ও এক্সপ্রেশন';

  @override
  String get artisticDesigns => 'শৈল্পিক নকশা';

  @override
  String get artisticDesignsDesc => '10+ অনন্য জার্নাল কার্ড থিম আনলক করুন';

  @override
  String get premiumLayouts => 'প্রিমিয়াম লেআউট';

  @override
  String get premiumLayoutsDesc => 'আপনার স্মৃতি দেখার একচেটিয়া উপায়';

  @override
  String get calendarTools => 'ক্যালেন্ডার ও টুলস';

  @override
  String get fullCalendar => 'সম্পূর্ণ ক্যালেন্ডার';

  @override
  String get fullCalendarDesc => 'সম্পূর্ণ ইভেন্ট ম্যানেজমেন্ট সিস্টেম';

  @override
  String get clipboardAutoSaveDesc => 'পটভূমি ক্লিপবোর্ড ইতিহাস ক্যাপচার';

  @override
  String get proWidgets => 'প্রো উইজেট';

  @override
  String get proWidgetsDesc => 'আপনার হোম স্ক্রিনে উপলব্ধ সমস্ত বৈশিষ্ট্য';

  @override
  String get dataExport => 'ডেটা এবং রপ্তানি';

  @override
  String get advancedBackup => 'উন্নত ব্যাকআপ';

  @override
  String get advancedBackupDesc => 'সমস্ত ডেটা নিরাপদ আমদানি/রপ্তানি';

  @override
  String get pdfExport => 'পিডিএফ এক্সপোর্ট';

  @override
  String get pdfExportDesc => 'পিডিএফ-এ নোট এবং জার্নাল রপ্তানি করুন';

  @override
  String get printReady => 'প্রিন্ট রেডি';

  @override
  String get printReadyDesc => 'সরাসরি মুদ্রণ সমর্থন';

  @override
  String get richTextEditor => 'রিচ টেক্সট এডিটর';

  @override
  String get advancedSearch => 'উন্নত অনুসন্ধান';

  @override
  String get advancedSearchDesc =>
      'আপনার পাঠ্যের মধ্যে অনুসন্ধান করুন এবং প্রতিস্থাপন করুন';

  @override
  String get richMedia => 'রিচ মিডিয়া';

  @override
  String get richMediaDesc => 'ছবি, ভিডিও এবং লিঙ্ক সন্নিবেশ করান';

  @override
  String get editorStyling => 'সম্পাদক স্টাইলিং';

  @override
  String get editorStylingDesc => 'কাস্টম টেক্সট এবং এডিটর ব্যাকগ্রাউন্ড';

  @override
  String get balance => 'ভারসাম্য';

  @override
  String get loadingAd => 'বিজ্ঞাপন লোড হচ্ছে...';

  @override
  String watchAd(Object amount) {
    return 'বিজ্ঞাপন দেখুন (+$amount)';
  }

  @override
  String get loadAd => 'বিজ্ঞাপন লোড করুন';

  @override
  String get backupDataDesc => 'আপনার ডেটার একটি JSON ফাইল সংরক্ষণ করুন';

  @override
  String get importDataDesc => 'কপিক্লিপে একটি ব্যাকআপ ফাইল মার্জ করুন';

  @override
  String get notificationPermissionDenied =>
      'বিজ্ঞপ্তি অনুমতি অস্বীকার করা হয়েছে.';

  @override
  String get typeNewTask => 'একটি নতুন টাস্ক টাইপ করুন...';

  @override
  String get addTask => 'একটি টাস্ক যোগ করুন';

  @override
  String get completed => 'সম্পন্ন';

  @override
  String get greatJob => 'দারুণ কাজ!';

  @override
  String youEarnedXPNextTask(Object amount, Object date) {
    return 'আপনি $amount XP অর্জন করেছেন! পরবর্তী কাজ: $date';
  }

  @override
  String taskCompletedXP(Object amount) {
    return 'টাস্ক সম্পন্ন! +$amount XP';
  }

  @override
  String get moveTasksToRecycleBin => 'সমস্ত সক্রিয় কাজ রিসাইকেল বিনে সরান?';

  @override
  String get deleteAllPosts => 'সমস্ত পোস্ট মুছুন';

  @override
  String get deleteAllPostsConfirmation =>
      'আপনি কি নিশ্চিত যে আপনি সমস্ত সামাজিক পোস্ট মুছে ফেলতে চান? এটি পূর্বাবস্থায় ফেরানো যাবে না।';

  @override
  String get allPosts => 'সমস্ত পোস্ট';

  @override
  String get favorites => 'প্রিয়';

  @override
  String get drafts => 'খসড়া';

  @override
  String get noFavoritesYet => 'এখনও কোন প্রিয়';

  @override
  String get noDraftsYet => 'এখনও কোন খসড়া';

  @override
  String get startSocialJourney => 'আপনার সামাজিক যাত্রা শুরু করুন!';

  @override
  String get draft => 'খসড়া';

  @override
  String attachmentCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 's',
      one: '',
    );
    return '$count attachment$_temp0';
  }

  @override
  String get pleaseAddContent =>
      'শেয়ার করতে কিছু বিষয়বস্তু বা মিডিয়া যোগ করুন';

  @override
  String fileNotFoundError(Object path) {
    return 'ত্রুটি: ফাইল $path এ পাওয়া যায়নি';
  }

  @override
  String get checkFacebookApp => 'ফেসবুক অ্যাপ চেক করুন';

  @override
  String get systemShare => 'সিস্টেম শেয়ার';

  @override
  String get socialPost => 'সামাজিক পোস্ট';

  @override
  String get favorite => 'প্রিয়';

  @override
  String get saveDraft => 'খসড়া সংরক্ষণ করুন';

  @override
  String get entryCopied => 'এন্ট্রি কপি করা হয়েছে';

  @override
  String get moveEntriesToRecycleBin =>
      'সমস্ত সক্রিয় এন্ট্রি রিসাইকেল বিনে সরাতে চান?';

  @override
  String get startWritingStory => 'আপনার গল্প লিখতে শুরু করুন';

  @override
  String get recordMemories => 'আপনার দৈনন্দিন স্মৃতি এবং অনুভূতি রেকর্ড করুন.';

  @override
  String get writeJournal => 'জার্নাল লিখুন';

  @override
  String get myMemories => 'আমার স্মৃতি';

  @override
  String get sortJournal => 'বাছাই জার্নাল';

  @override
  String get byMood => 'মেজাজ দ্বারা';

  @override
  String get searchMemories => 'স্মৃতি অনুসন্ধান করুন...';

  @override
  String get selectAll => 'সব নির্বাচন করুন';

  @override
  String get deleteSelected => 'নির্বাচিত মুছুন';

  @override
  String get taskCompletedExclamation => 'টাস্ক সম্পন্ন!';

  @override
  String get taskUncompletedExclamation => 'কাজ অসম্পূর্ণ';

  @override
  String get clipboardUpdatedExclamation => 'ক্লিপবোর্ড আপডেট!';

  @override
  String clipboardSavedContent(Object content) {
    return 'ক্লিপবোর্ড সংরক্ষিত: $content';
  }

  @override
  String get overview => 'ওভারভিউ';

  @override
  String get colorAurora => 'অরোরা';

  @override
  String get colorCosmic => 'মহাজাগতিক';

  @override
  String get colorNebula => 'নীহারিকা';

  @override
  String get colorStarlight => 'তারার আলো';

  @override
  String get colorSolar => 'সৌর';

  @override
  String get colorNova => 'নতুন';

  @override
  String get loadingStepLoading => 'লোড হচ্ছে...';

  @override
  String get loadingStepDatabase => 'ডাটাবেস সেট আপ করা হচ্ছে...';

  @override
  String get loadingStepSystem => 'সিস্টেম কনফিগার করা হচ্ছে...';

  @override
  String get loadingStepReady => 'প্রস্তুত';

  @override
  String get productivityCompanion => 'আপনার উত্পাদনশীলতার সঙ্গী';

  @override
  String get done => 'সম্পন্ন';

  @override
  String get newNote => 'নতুন নোট';

  @override
  String get changeColor => 'রঙ পরিবর্তন করুন';

  @override
  String get copyContent => 'কন্টেন্ট কপি করুন';

  @override
  String get titleOptional => 'শিরোনাম (ঐচ্ছিক)';

  @override
  String get exportAsPdf => 'পিডিএফ হিসাবে রপ্তানি করুন';

  @override
  String get taskDueNow => 'টাস্ক ডিউ এখন';

  @override
  String get moveTaskToBinTitle => 'টাস্ককে রিসাইকেল বিনে সরান?';

  @override
  String get restoreTaskLater =>
      'আপনি পরে সেটিংস থেকে এই কাজটি পুনরুদ্ধার করতে পারেন।';

  @override
  String get newTask => 'নতুন টাস্ক';

  @override
  String get editTask => 'কাজ সম্পাদনা করুন';

  @override
  String get undo => 'পূর্বাবস্থায় ফেরান';

  @override
  String get redo => 'আবার করুন';

  @override
  String get category => 'শ্রেণী';

  @override
  String get categoryHint => 'যেমন কাজ, জিম';

  @override
  String get whatNeedsToBeDone => 'কি করা দরকার?';

  @override
  String get enterTaskDetails => 'কাজের বিবরণ লিখুন...';

  @override
  String get setDueDate => 'নির্ধারিত তারিখ নির্ধারণ করুন';

  @override
  String get dueDate => 'দুই তারিখ';

  @override
  String get expenseTitle => 'খরচ';

  @override
  String searchInCurrency(String currency) {
    return '$currency এ অনুসন্ধান করুন...';
  }

  @override
  String get sortAndFilter => 'বাছাই এবং ফিল্টার';

  @override
  String get sortBy => 'সাজান';

  @override
  String get highestAmount => 'সর্বোচ্চ পরিমাণ';

  @override
  String get lowestAmount => 'সর্বনিম্ন পরিমাণ';

  @override
  String get moreFilters => 'আরও ফিল্টার...';

  @override
  String get filterExpenses => 'ফিল্টার খরচ';

  @override
  String get transactionType => 'লেনদেনের ধরন';

  @override
  String get categories => 'ক্যাটাগরি';

  @override
  String get all => 'সব';

  @override
  String get income => 'আয়';

  @override
  String get expense => 'ব্যয়';

  @override
  String get reset => 'রিসেট করুন';

  @override
  String get apply => 'আবেদন করুন';

  @override
  String newExpense(String currency) {
    return 'নতুন $currency';
  }

  @override
  String errorLoadingData(String error) {
    return 'ডেটা লোড করার সময় ত্রুটি৷\n\n$error';
  }

  @override
  String get dailyQuote1 =>
      'ভবিষ্যতের ভবিষ্যদ্বাণী করার সর্বোত্তম উপায় হল এটি তৈরি করা।';

  @override
  String get dailyQuote2 =>
      'ধন-সম্পদ বড় সম্পদের মধ্যে থাকে না, কিন্তু অল্প কিছু চাওয়া পাওয়ার মধ্যে থাকে।';

  @override
  String get dailyQuote3 => 'সময়ই চূড়ান্ত মুদ্রা।';

  @override
  String get dailyQuote4 => 'সাফল্য চূড়ান্ত নয়, ব্যর্থতা মারাত্মক নয়।';

  @override
  String get dailyQuote5 => 'সমাধানের দিকে মনোযোগ দিন, সমস্যা নয়।';

  @override
  String get dailyQuote6 => 'আপনার নেটওয়ার্ক আপনার নেট মূল্য.';

  @override
  String get moodHappy => 'খুশি';

  @override
  String get moodExcited => 'উত্তেজিত';

  @override
  String get moodNeutral => 'নিরপেক্ষ';

  @override
  String get moodSad => 'দুঃখজনক';

  @override
  String get moodStressed => 'স্ট্রেসড';

  @override
  String exportDate(String date) {
    return '📅 $date';
  }

  @override
  String exportMood(String emoji, String mood) {
    return 'মেজাজ: $emoji $mood';
  }

  @override
  String exportTitle(String title) {
    return 'শিরোনাম: $title';
  }

  @override
  String exportTags(String tags) {
    return 'ট্যাগ: $tags';
  }

  @override
  String get instagram => 'ইনস্টাগ্রাম';

  @override
  String get facebook => 'ফেসবুক';

  @override
  String get tiktok => 'টিকটক';

  @override
  String get newSketch => 'নতুন স্কেচ';

  @override
  String get searchSketches => 'স্কেচ এবং ফোল্ডার অনুসন্ধান করুন...';

  @override
  String get noResultsFound => 'কোন ফলাফল পাওয়া যায়নি';

  @override
  String get noItems => 'কোনো আইটেম নেই';

  @override
  String get noDrawingsYet => 'এখনও কোন অঙ্কন';

  @override
  String get canvasIntro => 'ক্যানভাসে আপনার সৃজনশীলতা প্রকাশ করুন!';

  @override
  String get newCanvas => 'নতুন ক্যানভাস';

  @override
  String get rename => 'নাম পরিবর্তন করুন';

  @override
  String get deleteFolder => 'ফোল্ডার মুছুন';

  @override
  String get deleteSketchesQuestion => 'স্কেচ মুছবেন?';

  @override
  String get deleteFolderConfirmation =>
      'এই ফোল্ডারের সমস্ত স্কেচ স্থায়ীভাবে মুছে ফেলা হবে৷';

  @override
  String get renameFolder => 'ফোল্ডারের নাম পরিবর্তন করুন';

  @override
  String get chooseColor => 'রঙ চয়ন করুন';

  @override
  String get deleteFolderQuestion => 'ফোল্ডার মুছবেন?';

  @override
  String get searchClips => 'ক্লিপগুলি অনুসন্ধান করুন...';

  @override
  String get clipboardEmpty => 'ক্লিপবোর্ড খালি';

  @override
  String get addItem => 'আইটেম যোগ করুন';

  @override
  String get clipColor => 'ক্লিপ রঙ';

  @override
  String get newClip => 'নতুন ক্লিপ';

  @override
  String get editClip => 'ক্লিপ সম্পাদনা করুন';

  @override
  String get restoreClipLater => 'আপনি পরে এই ক্লিপ পুনরুদ্ধার করতে পারেন.';

  @override
  String get upcomingEvents => 'আসন্ন ইভেন্ট';

  @override
  String get dataDistribution => 'ডেটা বিতরণ';

  @override
  String get taskProgress => 'টাস্ক অগ্রগতি';

  @override
  String get quickStats => 'দ্রুত পরিসংখ্যান';

  @override
  String get taskCompletion => 'টাস্ক সমাপ্তি';

  @override
  String get noItemsForDate => 'এই তারিখের জন্য কোন আইটেম';

  @override
  String get enjoyFreeTime => 'আপনার বিনামূল্যে সময় উপভোগ করুন!';

  @override
  String get searchThisDay => 'এই দিনে অনুসন্ধান করুন...';

  @override
  String get finance => 'অর্থ';

  @override
  String get permanentlyDelete => 'স্থায়ীভাবে মুছে ফেলবেন?';

  @override
  String deleteSelectionConfirmation(int foldersCount, int sketchesCount) {
    return 'এটি স্থায়ীভাবে $foldersCount ফোল্ডার (এবং তাদের স্কেচ) এবং অন্যান্য $sketchesCount স্কেচগুলিকে মুছে ফেলবে৷\n\nএটি পূর্বাবস্থায় ফেরানো যাবে না।';
  }

  @override
  String get deleteForever => 'চিরতরে মুছুন';

  @override
  String selectedCount(int count) {
    return '$count নির্বাচিত';
  }

  @override
  String canvasStats(int notes, int folders) {
    return '$notes স্কেচ • $folders ফোল্ডার';
  }

  @override
  String get sortItems => 'সাজান আইটেম';

  @override
  String get sortNameAZ => 'নাম (A-Z)';

  @override
  String get sortNameZA => 'নাম (Z-A)';

  @override
  String get createFolder => 'ফোল্ডার তৈরি করুন';

  @override
  String get folderNameHint => 'ফোল্ডারের নাম...';

  @override
  String deleteSketchesConfirmation(int count) {
    return '$count স্কেচ মুছবেন? এটি পূর্বাবস্থায় ফেরানো যাবে না।';
  }

  @override
  String get noSketchesFound => 'কোন স্কেচ পাওয়া যায়নি';

  @override
  String get noSketchesFoundSub =>
      'আপনার অনুসন্ধান সামঞ্জস্য বা একটি নতুন স্কেচ তৈরি করার চেষ্টা করুন.';

  @override
  String searchInFolder(String folder) {
    return '$folder এ অনুসন্ধান করুন...';
  }

  @override
  String sketchesCount(int count) {
    return '$count স্কেচ';
  }

  @override
  String get sortSketches => 'সাজান স্কেচ';

  @override
  String get calendarScreenTitle => 'ক্যালেন্ডার';

  @override
  String get dailyActivity => 'দৈনিক কার্যকলাপ';

  @override
  String get deleteItemQuestion => 'আইটেম মুছবেন?';

  @override
  String get deleteItemConfirmation =>
      'এটি আইটেমটিকে রিসাইকেল বিনে নিয়ে যাবে।';

  @override
  String get moveToBinItem => 'বিনে চলে যাবেন?';

  @override
  String get moveToBinConfirmation => 'আপনি পরে এটি পুনরুদ্ধার করতে পারেন।';

  @override
  String selectedItems(int count) {
    return '$count নির্বাচিত';
  }

  @override
  String get recentClips => 'সাম্প্রতিক ক্লিপ';

  @override
  String get copied => 'অনুলিপি করা হয়েছে!';

  @override
  String get copiedPlainText => 'প্লেইন টেক্সট কপি করা হয়েছে';

  @override
  String get clipTheme => 'ক্লিপ থিম';

  @override
  String get justNow => 'এইমাত্র';

  @override
  String minutesAgo(Object count) {
    return '$countমি আগে';
  }

  @override
  String hoursAgo(Object count) {
    return '$countঘণ্টা আগে';
  }

  @override
  String daysAgo(Object count) {
    return '$countদিন আগে';
  }

  @override
  String get noTasksFound => 'কোনো কাজ পাওয়া যায়নি।';

  @override
  String get searchTasks => 'কাজ অনুসন্ধান করুন...';

  @override
  String get taskReminder => 'টাস্ক রিমাইন্ডার';

  @override
  String get untitledNote => 'শিরোনামহীন নোট';

  @override
  String get dailyEntry => 'দৈনিক এন্ট্রি';

  @override
  String get clipboardHistory => 'ক্লিপবোর্ড ইতিহাস';

  @override
  String get deletePermanentlyContent =>
      'এই ক্রিয়াটি পূর্বাবস্থায় ফেরানো যাবে না৷';

  @override
  String get emptyRecycleBinTitle => 'খালি রিসাইকেল বিন?';

  @override
  String emptyRecycleBinContent(Object count) {
    return 'সমস্ত $countটি আইটেম স্থায়ীভাবে মুছে ফেলা হবে৷';
  }

  @override
  String get emptyBin => 'খালি বিন';

  @override
  String get recycleBinEmpty => 'রিসাইকেল বিন খালি';

  @override
  String get deletedItemsAppearHere => 'মুছে ফেলা আইটেম এখানে প্রদর্শিত হবে.';

  @override
  String get empty => 'খালি';

  @override
  String get recent => 'সাম্প্রতিক';

  @override
  String categoryLabel(Object category) {
    return 'বিভাগ: $category';
  }

  @override
  String get general => 'সাধারণ';

  @override
  String get saveTransactionQuestion => 'আপনি কি এই লেনদেন সংরক্ষণ করতে চান?';

  @override
  String get fillTitleAmount => 'শিরোনাম এবং পরিমাণ পূরণ করুন';

  @override
  String get invalidAmount => 'অবৈধ পরিমাণ বিন্যাস';

  @override
  String get moveTransactionToBinTitle => 'রিসাইকেল বিনে লেনদেন সরান?';

  @override
  String get restoreTransactionLater =>
      'আপনি পরে সেটিংস থেকে এই লেনদেন পুনরুদ্ধার করতে পারেন।';

  @override
  String get newTransaction => 'নতুন লেনদেন';

  @override
  String get whatIsThisFor => 'এটা কিসের জন্য?';

  @override
  String get description => 'বর্ণনা';

  @override
  String get daily => 'দৈনিক';

  @override
  String get weekly => 'সাপ্তাহিক';

  @override
  String get monthly => 'মাসিক';

  @override
  String get yearly => 'বার্ষিক';

  @override
  String get totalIncome => 'মোট আয়';

  @override
  String get totalExpense => 'মোট খরচ';

  @override
  String get analysis => 'বিশ্লেষণ';

  @override
  String get transactions => 'লেনদেন';

  @override
  String get noExpensesFound => 'এই সময়ের জন্য কোন খরচ পাওয়া যায় নি.';

  @override
  String get netBalance => 'নেট ব্যালেন্স';

  @override
  String get topCategories => 'শীর্ষ বিভাগ';

  @override
  String get spendingTrend => 'খরচের প্রবণতা';

  @override
  String get insights => 'অন্তর্দৃষ্টি';

  @override
  String get noExpensesRecorded => 'কোন খরচ নথিভুক্ত';

  @override
  String get trackSpendingHabits => 'সহজেই আপনার খরচের অভ্যাস ট্র্যাক করুন।';

  @override
  String get addExpense => 'খরচ যোগ করুন';

  @override
  String get noDataForPeriod => 'এই সময়ের জন্য কোন তথ্য নেই';

  @override
  String get budget => 'বাজেট';

  @override
  String get spent => 'খরচ করেছে';

  @override
  String get limit => 'সীমা';

  @override
  String get overBudget => 'ওভার বাজেট!';

  @override
  String remainingBudget(Object percent) {
    return '$percent% বাকি';
  }

  @override
  String get savingsRate => 'সঞ্চয় হার';

  @override
  String get healthScore => 'স্বাস্থ্য স্কোর';

  @override
  String get healthScoreExplanation =>
      'এই স্কোর আপনার সঞ্চয় হারের উপর ভিত্তি করে।\n\n• > 50% সংরক্ষিত = চমৎকার (100)\n• 0% সংরক্ষিত = গড় (50)\n• খরচ > আয় = দরিদ্র (<50)';

  @override
  String get ok => 'ঠিক আছে';
}

/// The translations for Bengali Bangla, as used in Bangladesh (`bn_BD`).
class AppLocalizationsBnBd extends AppLocalizationsBn {
  AppLocalizationsBnBd() : super('bn_BD');

  @override
  String get settings => 'Settings';

  @override
  String get language => 'Language';

  @override
  String get systemDefault => 'System Default';

  @override
  String get notes => 'Notes';

  @override
  String get todos => 'To-Dos';

  @override
  String get expenses => 'Expenses';

  @override
  String get journal => 'Journal';

  @override
  String get calendar => 'Calendar';

  @override
  String get clipboard => 'Clipboard';

  @override
  String get canvas => 'Canvas';

  @override
  String get save => 'Save';

  @override
  String get create => 'Create';

  @override
  String get cancel => 'Cancel';

  @override
  String get delete => 'Delete';

  @override
  String get edit => 'Edit';

  @override
  String get share => 'Share';

  @override
  String get copy => 'Copy';

  @override
  String get unsavedChanges => 'Unsaved Changes';

  @override
  String get confirmDelete => 'Confirm Delete';

  @override
  String get discard => 'Discard';

  @override
  String get createPost => 'Create Post';

  @override
  String get post => 'Post';

  @override
  String get postingTo => 'Posting to';

  @override
  String get whatsOnYourMind => 'What\'\'s on your mind?';

  @override
  String get pickImages => 'Pick Images';

  @override
  String get pickVideo => 'Pick Video';

  @override
  String get camera => 'Camera';

  @override
  String get gallery => 'Gallery';

  @override
  String get search => 'Search';

  @override
  String get pleaseEnterTask => 'Please enter a task';

  @override
  String get deleteTask => 'Delete Task';

  @override
  String get selectItems => 'Select Items';

  @override
  String get deleteAll => 'Delete All';

  @override
  String error(Object error) {
    return 'Error: $error';
  }

  @override
  String get orderingOnlyAvailableInAllPosts =>
      'Ordering only available in \'\'All Posts\'\'';

  @override
  String get deletePost => 'Delete Post';

  @override
  String get postDeleted => 'Post deleted';

  @override
  String get premiumFeatures => 'Premium Features';

  @override
  String get manageCoinsAdsPremium => 'Manage coins, ads, and premium status';

  @override
  String get themeMode => 'Theme Mode';

  @override
  String get accentColor => 'Accent Color';

  @override
  String get backgroundDesign => 'Background Design';

  @override
  String get pushNotifications => 'Push Notifications';

  @override
  String get recycleBin => 'Recycle Bin';

  @override
  String get exportData => 'Export Data';

  @override
  String get importData => 'Import Data';

  @override
  String get rateApp => 'Rate App';

  @override
  String get sendFeedback => 'Send Feedback';

  @override
  String get privacyPolicy => 'Privacy Policy';

  @override
  String get version => 'Version';

  @override
  String get buildNumber => 'Build Number';

  @override
  String get system => 'System';

  @override
  String get light => 'Light';

  @override
  String get dark => 'Dark';

  @override
  String get itemRestored => 'Item restored';

  @override
  String get recycleBinCleared => 'Recycle Bin cleared successfully';

  @override
  String get allPostsDeleted => 'All posts deleted';

  @override
  String get newPost => 'New Post';

  @override
  String get textCopiedToClipboardFacebook =>
      'Text copied to clipboard (Facebook policy)';

  @override
  String get tiktokSharingRequiresVideoImage =>
      'TikTok sharing requires a video/image';

  @override
  String errorSharing(Object error) {
    return 'Error sharing: $error';
  }

  @override
  String shareToStory(Object platform) {
    return 'Share to $platform Story';
  }

  @override
  String shareToFeed(Object platform) {
    return 'Share to $platform Feed';
  }

  @override
  String get unlockPermanently => 'Unlock Permanently';

  @override
  String get notEnoughCoins => 'Not enough coins!';

  @override
  String youEarnedCoins(Object amount) {
    return 'You earned $amount coins!';
  }

  @override
  String get contentCopied => 'Content copied';

  @override
  String get selectDateTime => 'Select Date & Time';

  @override
  String get areYouSureYouWantToDeleteThisPost =>
      'Are you sure you want to delete this post?';

  @override
  String get socialPosts => 'Social Posts';

  @override
  String get watchAdToEarnCoins => 'Watch Ad to Earn Coins';

  @override
  String get premiumUnlocked => 'Premium Unlocked';

  @override
  String get removeAds => 'Remove Ads';

  @override
  String get unlimitedCloudStorage => 'Unlimited Cloud Storage';

  @override
  String get deleteNote => 'Delete Note';

  @override
  String get shareNote => 'Share Note';

  @override
  String get editNote => 'Edit Note';

  @override
  String get searchNotes => 'Search notes...';

  @override
  String get noNotesFound => 'No notes found';

  @override
  String get captureThoughts => 'Capture your thoughts instantly.';

  @override
  String get createNote => 'Create Note';

  @override
  String get customOrder => 'Custom Order';

  @override
  String get newestFirst => 'Newest First';

  @override
  String get oldestFirst => 'Oldest First';

  @override
  String get titleAZ => 'Title: A-Z';

  @override
  String get titleZA => 'Title: Z-A';

  @override
  String get deleteAllQuestion => 'Delete All?';

  @override
  String get moveToRecycleBin => 'Move all notes to Recycle Bin?';

  @override
  String get moveToBinQuestion => 'Move to Bin?';

  @override
  String get restoreNoteLater => 'You can restore this note later.';

  @override
  String get move => 'Move';

  @override
  String get myThoughts => 'My Thoughts';

  @override
  String get selected => 'Selected';

  @override
  String get noContent => 'No content';

  @override
  String get untitled => 'Untitled';

  @override
  String get chooseWallpapers => 'Choose from 10+ dynamic wallpapers';

  @override
  String get backupData => 'Backup Data';

  @override
  String get saveJsonFile => 'Save a JSON file containing all your data?';

  @override
  String get exportNow => 'Export Now';

  @override
  String get importDataTitle => 'Import Data';

  @override
  String get mergeBackupFile => 'Merge a backup file with your current items?';

  @override
  String get selectFile => 'Select File';

  @override
  String get backupSaved => 'Backup saved successfully!';

  @override
  String get exportFailed => 'Export failed.';

  @override
  String importSuccess(Object count) {
    return '$count items restored successfully!';
  }

  @override
  String get importFailed => 'Import failed.';

  @override
  String widgetAdded(String widget) {
    return 'Widget added to Home Screen!';
  }

  @override
  String get widgetRequestSent =>
      'Widget request sent. Please check your home screen.';

  @override
  String get widgetAddFailed => 'Failed to add widget';

  @override
  String get autoSaveEnabled => 'Auto-save enabled.';

  @override
  String get autoSaveDisabled => 'Auto-save disabled.';

  @override
  String get homeScreenWidgets => 'Home Screen Widgets';

  @override
  String get notificationsTitle => 'Notifications';

  @override
  String get dataBackup => 'Data & Backup';

  @override
  String get feedbackSupport => 'Feedback & Support';

  @override
  String get creditsTitle => 'Credits';

  @override
  String get privacyMaintenance => 'Privacy & Maintenance';

  @override
  String get aboutTitle => 'About';

  @override
  String get premium => 'Premium';

  @override
  String get appearanceTitle => 'Appearance';

  @override
  String get clipboardTitle => 'Clipboard';

  @override
  String get settingsSubtitle => 'Customize Your Experience';

  @override
  String get welcomeTitle => 'Welcome to CopyClip';

  @override
  String get welcomeDescription =>
      'Your ultimate productivity companion. Let\'\'s get you set up with powerful tools to manage your day.';

  @override
  String get onboardingNotesTitle => 'Smart Notes';

  @override
  String get onboardingNotesDesc =>
      'Capture ideas instantly with rich text formatting. Organize your thoughts and never lose a great idea again.';

  @override
  String get onboardingTodosTitle => 'Task Management';

  @override
  String get onboardingTodosDesc =>
      'Stay on top of your game. Create to-do lists, set priorities, and crush your goals one checkmark at a time.';

  @override
  String get onboardingExpensesTitle => 'Expense Tracking';

  @override
  String get onboardingExpensesDesc =>
      'Take control of your finances. Track income and expenses easily to understand your spending habits.';

  @override
  String get onboardingJournalTitle => 'Personal Journal';

  @override
  String get onboardingJournalDesc =>
      'Reflect on your day. A private space to write down your memories, feelings, and daily experiences.';

  @override
  String get onboardingCalendarTitle => 'Calendar & Events';

  @override
  String get onboardingCalendarDesc =>
      'Never miss a moment. Organize your schedule and keep track of important upcoming events.';

  @override
  String get onboardingClipboardTitle => 'Clipboard Manager';

  @override
  String get onboardingClipboardDesc =>
      'Copy once, paste anywhere. Access your clipboard history to retrieve snippets you copied earlier.';

  @override
  String get onboardingCanvasTitle => 'Creative Canvas';

  @override
  String get onboardingCanvasDesc =>
      'Unleash your creativity. Draw, sketch, and visualize your ideas on a free-form digital canvas.';

  @override
  String get featuresNotesDesc => 'Create and manage your notes';

  @override
  String get featuresTodosDesc => 'Keep track of your tasks';

  @override
  String get featuresExpensesDesc => 'Monitor your expenses';

  @override
  String get featuresJournalDesc => 'Write down your thoughts';

  @override
  String get featuresCalendarDesc => 'Organize your schedule';

  @override
  String get featuresClipboardDesc => 'Access your clipboard history';

  @override
  String get featuresCanvasDesc => 'Draw and sketch freely';

  @override
  String get featuresSocialPost => 'Social Post';

  @override
  String get featuresSocialPostDesc => 'Create engaging social media content';

  @override
  String get chooseYourAura => 'Choose Your Aura';

  @override
  String get expressYourselfTheme => 'Express yourself with a new theme color!';

  @override
  String get level => 'Level';

  @override
  String get xpToNextLevel => 'XP to Level';

  @override
  String get checkUpcomingEvents => 'Check upcoming events';

  @override
  String get startNewSketch => 'Start a new sketch';

  @override
  String get noTransactionsMonth => 'No transactions this month';

  @override
  String transactionsThisMonth(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 's',
      one: '',
    );
    return '$count transaction$_temp0 this month';
  }

  @override
  String get autoSaveClipboard => 'Auto-save Clipboard';

  @override
  String get autoSaveClipboardDesc => 'Automatically save copied items';

  @override
  String get permissionDeniedSettings =>
      'Permission permanently denied. Please enable in Settings.';

  @override
  String get notificationsEnabled => 'Notifications enabled!';

  @override
  String get redirectingToSettings =>
      'Redirecting to settings to disable notifications...';

  @override
  String get premiumAccess => 'Premium Access';

  @override
  String get premiumActiveUntil => 'Premium Active until';

  @override
  String get unlockAllFeatures => 'Unlock All Features';

  @override
  String get buyPremium => 'Buy Premium (7 Days)';

  @override
  String costCoins(Object cost) {
    return 'Cost: $cost Coins';
  }

  @override
  String get premiumActivated => 'Premium Activated for 7 days!';

  @override
  String get premiumActive => 'Premium Active';

  @override
  String get expires => 'Expires:';

  @override
  String get temporaryAccess => 'Temporary Access';

  @override
  String get journalExpression => 'Journal & Expression';

  @override
  String get artisticDesigns => 'Artistic Designs';

  @override
  String get artisticDesignsDesc => 'Unlock 10+ unique journal card themes';

  @override
  String get premiumLayouts => 'Premium Layouts';

  @override
  String get premiumLayoutsDesc => 'Exclusive ways to view your memories';

  @override
  String get calendarTools => 'Calendar & Tools';

  @override
  String get fullCalendar => 'Full Calendar';

  @override
  String get fullCalendarDesc => 'Complete event management system';

  @override
  String get clipboardAutoSaveDesc => 'Background clipboard history capture';

  @override
  String get proWidgets => 'Pro Widgets';

  @override
  String get proWidgetsDesc => 'All features available on your home screen';

  @override
  String get dataExport => 'Data & Export';

  @override
  String get advancedBackup => 'Advanced Backup';

  @override
  String get advancedBackupDesc => 'Secure import/export of all data';

  @override
  String get pdfExport => 'PDF Export';

  @override
  String get pdfExportDesc => 'Export notes & journals to PDF';

  @override
  String get printReady => 'Print Ready';

  @override
  String get printReadyDesc => 'Direct printing support';

  @override
  String get richTextEditor => 'Rich Text Editor';

  @override
  String get advancedSearch => 'Advanced Search';

  @override
  String get advancedSearchDesc => 'Search & Replace within your text';

  @override
  String get richMedia => 'Rich Media';

  @override
  String get richMediaDesc => 'Insert Images, Videos, and Links';

  @override
  String get editorStyling => 'Editor Styling';

  @override
  String get editorStylingDesc => 'Custom text and editor backgrounds';

  @override
  String get balance => 'Balance';

  @override
  String get loadingAd => 'Loading Ad...';

  @override
  String watchAd(Object amount) {
    return 'Watch Ad (+$amount)';
  }

  @override
  String get loadAd => 'Load Ad';

  @override
  String get backupDataDesc => 'Save a JSON file of your data';

  @override
  String get importDataDesc => 'Merge a backup file into CopyClip';

  @override
  String get notificationPermissionDenied => 'Notification permission denied.';

  @override
  String get typeNewTask => 'Type a new task...';

  @override
  String get addTask => 'Add a task';

  @override
  String get completed => 'Completed';

  @override
  String get greatJob => 'Great job!';

  @override
  String youEarnedXPNextTask(Object amount, Object date) {
    return 'You earned $amount XP! Next task: $date';
  }

  @override
  String taskCompletedXP(Object amount) {
    return 'Task completed! +$amount XP';
  }

  @override
  String get moveTasksToRecycleBin => 'Move all active tasks to Recycle Bin?';

  @override
  String get deleteAllPosts => 'Delete All Posts';

  @override
  String get deleteAllPostsConfirmation =>
      'Are you sure you want to delete ALL social posts? This cannot be undone.';

  @override
  String get allPosts => 'All Posts';

  @override
  String get favorites => 'Favorites';

  @override
  String get drafts => 'Drafts';

  @override
  String get noFavoritesYet => 'No favorites yet';

  @override
  String get noDraftsYet => 'No drafts yet';

  @override
  String get startSocialJourney => 'Start your social journey!';

  @override
  String get draft => 'DRAFT';

  @override
  String attachmentCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 's',
      one: '',
    );
    return '$count attachment$_temp0';
  }

  @override
  String get pleaseAddContent => 'Please add some content or media to share';

  @override
  String fileNotFoundError(Object path) {
    return 'Error: File not found at $path';
  }

  @override
  String get checkFacebookApp => 'Check Facebook app';

  @override
  String get systemShare => 'System Share';

  @override
  String get socialPost => 'Social Post';

  @override
  String get favorite => 'Favorite';

  @override
  String get saveDraft => 'Save Draft';

  @override
  String get entryCopied => 'Entry copied';

  @override
  String get moveEntriesToRecycleBin =>
      'Move all active entries to Recycle Bin?';

  @override
  String get startWritingStory => 'Start writing your story';

  @override
  String get recordMemories => 'Record your daily memories and feelings.';

  @override
  String get writeJournal => 'Write Journal';

  @override
  String get myMemories => 'My Memories';

  @override
  String get sortJournal => 'Sort Journal';

  @override
  String get byMood => 'By Mood';

  @override
  String get searchMemories => 'Search memories...';

  @override
  String get selectAll => 'Select All';

  @override
  String get deleteSelected => 'Delete Selected';

  @override
  String get taskCompletedExclamation => 'Task completed!';

  @override
  String get taskUncompletedExclamation => 'Task uncompleted';

  @override
  String get clipboardUpdatedExclamation => 'Clipboard updated!';

  @override
  String clipboardSavedContent(Object content) {
    return 'Clipboard saved: $content';
  }

  @override
  String get overview => 'Overview';

  @override
  String get colorAurora => 'Aurora';

  @override
  String get colorCosmic => 'Cosmic';

  @override
  String get colorNebula => 'Nebula';

  @override
  String get colorStarlight => 'Starlight';

  @override
  String get colorSolar => 'Solar';

  @override
  String get colorNova => 'Nova';

  @override
  String get loadingStepLoading => 'Loading...';

  @override
  String get loadingStepDatabase => 'Setting up database...';

  @override
  String get loadingStepSystem => 'Configuring system...';

  @override
  String get loadingStepReady => 'Ready';

  @override
  String get productivityCompanion => 'Your productivity companion';

  @override
  String get done => 'Done';

  @override
  String get newNote => 'New Note';

  @override
  String get changeColor => 'Change Color';

  @override
  String get copyContent => 'Copy Content';

  @override
  String get titleOptional => 'Title (Optional)';

  @override
  String get exportAsPdf => 'Export as PDF';

  @override
  String get taskDueNow => 'Task Due Now';

  @override
  String get moveTaskToBinTitle => 'Move Task to Recycle Bin?';

  @override
  String get restoreTaskLater =>
      'You can restore this task later from settings.';

  @override
  String get newTask => 'New Task';

  @override
  String get editTask => 'Edit Task';

  @override
  String get undo => 'Undo';

  @override
  String get redo => 'Redo';

  @override
  String get category => 'Category';

  @override
  String get categoryHint => 'e.g. Work, Gym';

  @override
  String get whatNeedsToBeDone => 'What needs to be done?';

  @override
  String get enterTaskDetails => 'Enter task details...';

  @override
  String get setDueDate => 'Set Due Date';

  @override
  String get dueDate => 'Due Date';

  @override
  String get expenseTitle => 'Expenses';

  @override
  String searchInCurrency(String currency) {
    return 'Search in $currency...';
  }

  @override
  String get sortAndFilter => 'Sort & Filter';

  @override
  String get sortBy => 'SORT BY';

  @override
  String get highestAmount => 'Highest Amount';

  @override
  String get lowestAmount => 'Lowest Amount';

  @override
  String get moreFilters => 'More Filters...';

  @override
  String get filterExpenses => 'Filter Expenses';

  @override
  String get transactionType => 'Transaction Type';

  @override
  String get categories => 'Categories';

  @override
  String get all => 'All';

  @override
  String get income => 'Income';

  @override
  String get expense => 'Expense';

  @override
  String get reset => 'Reset';

  @override
  String get apply => 'Apply';

  @override
  String newExpense(String currency) {
    return 'New $currency';
  }

  @override
  String errorLoadingData(String error) {
    return 'Error loading data.\n\n$error';
  }

  @override
  String get dailyQuote1 =>
      'The best way to predict the future is to create it.';

  @override
  String get dailyQuote2 =>
      'Wealth consists not in having great possessions, but in having few wants.';

  @override
  String get dailyQuote3 => 'Time is the ultimate currency.';

  @override
  String get dailyQuote4 => 'Success is not final, failure is not fatal.';

  @override
  String get dailyQuote5 => 'Focus on the solution, not the problem.';

  @override
  String get dailyQuote6 => 'Your network is your net worth.';

  @override
  String get moodHappy => 'Happy';

  @override
  String get moodExcited => 'Excited';

  @override
  String get moodNeutral => 'Neutral';

  @override
  String get moodSad => 'Sad';

  @override
  String get moodStressed => 'Stressed';

  @override
  String exportDate(String date) {
    return '📅 $date';
  }

  @override
  String exportMood(String emoji, String mood) {
    return 'Mood: $emoji $mood';
  }

  @override
  String exportTitle(String title) {
    return 'TITLE: $title';
  }

  @override
  String exportTags(String tags) {
    return '\nTags: $tags';
  }

  @override
  String get instagram => 'Instagram';

  @override
  String get facebook => 'Facebook';

  @override
  String get tiktok => 'TikTok';

  @override
  String get newSketch => 'New Sketch';

  @override
  String get searchSketches => 'Search sketches and folders...';

  @override
  String get noResultsFound => 'No results found';

  @override
  String get noItems => 'No items';

  @override
  String get noDrawingsYet => 'No drawings yet';

  @override
  String get canvasIntro => 'Unleash your creativity on the canvas!';

  @override
  String get newCanvas => 'New Canvas';

  @override
  String get rename => 'Rename';

  @override
  String get deleteFolder => 'Delete Folder';

  @override
  String get deleteSketchesQuestion => 'Delete Sketches?';

  @override
  String get deleteFolderConfirmation =>
      'All sketches in this folder will be deleted permanently.';

  @override
  String get renameFolder => 'Rename Folder';

  @override
  String get chooseColor => 'Choose Color';

  @override
  String get deleteFolderQuestion => 'Delete Folder?';

  @override
  String get searchClips => 'Search clips...';

  @override
  String get clipboardEmpty => 'Clipboard is empty';

  @override
  String get addItem => 'Add Item';

  @override
  String get clipColor => 'Clip Color';

  @override
  String get newClip => 'New Clip';

  @override
  String get editClip => 'Edit Clip';

  @override
  String get restoreClipLater => 'You can restore this clip later.';

  @override
  String get upcomingEvents => 'Upcoming Events';

  @override
  String get dataDistribution => 'DATA DISTRIBUTION';

  @override
  String get taskProgress => 'TASK PROGRESS';

  @override
  String get quickStats => 'QUICK STATS';

  @override
  String get taskCompletion => 'Task Completion';

  @override
  String get noItemsForDate => 'No items for this date';

  @override
  String get enjoyFreeTime => 'Enjoy your free time!';

  @override
  String get searchThisDay => 'Search in this day...';

  @override
  String get finance => 'Finance';

  @override
  String get permanentlyDelete => 'Permanently Delete?';

  @override
  String deleteSelectionConfirmation(int foldersCount, int sketchesCount) {
    return 'This will permanently delete $foldersCount folders (and their sketches) and $sketchesCount other sketches.\n\nThis cannot be undone.';
  }

  @override
  String get deleteForever => 'Delete Forever';

  @override
  String selectedCount(int count) {
    return '$count Selected';
  }

  @override
  String canvasStats(int notes, int folders) {
    return '$notes sketches • $folders folders';
  }

  @override
  String get sortItems => 'Sort Items';

  @override
  String get sortNameAZ => 'Name (A-Z)';

  @override
  String get sortNameZA => 'Name (Z-A)';

  @override
  String get createFolder => 'Create Folder';

  @override
  String get folderNameHint => 'Folder name...';

  @override
  String deleteSketchesConfirmation(int count) {
    return 'Delete $count sketches? This cannot be undone.';
  }

  @override
  String get noSketchesFound => 'No sketches found';

  @override
  String get noSketchesFoundSub =>
      'Try adjusting your search or creating a new sketch.';

  @override
  String searchInFolder(String folder) {
    return 'Search in $folder...';
  }

  @override
  String sketchesCount(int count) {
    return '$count sketches';
  }

  @override
  String get sortSketches => 'Sort Sketches';

  @override
  String get calendarScreenTitle => 'Calendar';

  @override
  String get dailyActivity => 'Daily Activity';

  @override
  String get deleteItemQuestion => 'Delete Item?';

  @override
  String get deleteItemConfirmation =>
      'This will move the item to the recycle bin.';

  @override
  String get moveToBinItem => 'Move to Bin?';

  @override
  String get moveToBinConfirmation => 'You can restore it later.';

  @override
  String selectedItems(int count) {
    return '$count Selected';
  }

  @override
  String get recentClips => 'Recent Clips';

  @override
  String get copied => 'Copied!';

  @override
  String get copiedPlainText => 'Copied plain text';

  @override
  String get clipTheme => 'Clip Theme';

  @override
  String get justNow => 'Just now';

  @override
  String minutesAgo(Object count) {
    return '${count}m ago';
  }

  @override
  String hoursAgo(Object count) {
    return '${count}h ago';
  }

  @override
  String daysAgo(Object count) {
    return '${count}d ago';
  }

  @override
  String get noTasksFound => 'No tasks found.';

  @override
  String get searchTasks => 'Search tasks...';

  @override
  String get taskReminder => 'Task Reminder';

  @override
  String get untitledNote => 'Untitled Note';

  @override
  String get dailyEntry => 'Daily Entry';

  @override
  String get clipboardHistory => 'Clipboard History';

  @override
  String get deletePermanentlyContent => 'This action cannot be undone.';

  @override
  String get emptyRecycleBinTitle => 'Empty Recycle Bin?';

  @override
  String emptyRecycleBinContent(Object count) {
    return 'All $count items will be permanently deleted.';
  }

  @override
  String get emptyBin => 'Empty Bin';

  @override
  String get recycleBinEmpty => 'Recycle Bin is empty';

  @override
  String get deletedItemsAppearHere => 'Deleted items will appear here.';

  @override
  String get empty => 'Empty';

  @override
  String get recent => 'Recent';

  @override
  String categoryLabel(Object category) {
    return 'Category: $category';
  }

  @override
  String get general => 'General';

  @override
  String get saveTransactionQuestion => 'Do you want to save this transaction?';

  @override
  String get fillTitleAmount => 'Please fill in title and amount';

  @override
  String get invalidAmount => 'Invalid amount format';

  @override
  String get moveTransactionToBinTitle => 'Move Transaction to Recycle Bin?';

  @override
  String get restoreTransactionLater =>
      'You can restore this transaction later from settings.';

  @override
  String get newTransaction => 'New Transaction';

  @override
  String get whatIsThisFor => 'What is this for?';

  @override
  String get description => 'Description';

  @override
  String get daily => 'Daily';

  @override
  String get weekly => 'Weekly';

  @override
  String get monthly => 'Monthly';

  @override
  String get yearly => 'Yearly';

  @override
  String get totalIncome => 'Total Income';

  @override
  String get totalExpense => 'Total Expense';

  @override
  String get analysis => 'Analysis';

  @override
  String get transactions => 'Transactions';

  @override
  String get noExpensesFound => 'No expenses found for this period.';

  @override
  String get netBalance => 'Net Balance';

  @override
  String get topCategories => 'Top Categories';

  @override
  String get spendingTrend => 'Spending Trend';

  @override
  String get insights => 'Insights';

  @override
  String get noExpensesRecorded => 'No expenses recorded';

  @override
  String get trackSpendingHabits => 'Track your spending habits easily.';

  @override
  String get addExpense => 'Add Expense';

  @override
  String get noDataForPeriod => 'No data for this period';

  @override
  String get budget => 'Budget';

  @override
  String get spent => 'Spent';

  @override
  String get limit => 'Limit';

  @override
  String get overBudget => 'Over Budget!';

  @override
  String remainingBudget(Object percent) {
    return '$percent% remaining';
  }

  @override
  String get savingsRate => 'Savings Rate';

  @override
  String get healthScore => 'Health Score';

  @override
  String get healthScoreExplanation =>
      'This score is based on your Savings Rate.\n\n• > 50% saved = Excellent (100)\n• 0% saved = Average (50)\n• Spending > Income = Poor (<50)';

  @override
  String get ok => 'OK';
}
