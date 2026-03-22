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
  String get notes => 'নোটস';

  @override
  String get todos => 'কাজ';

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
  String get delete => 'মুছে ফেলুন';

  @override
  String get edit => 'সম্পাদনা';

  @override
  String get share => 'শেয়ার করুন';

  @override
  String get copy => 'কপি করুন';

  @override
  String get unsavedChanges => 'অসংরক্ষিত পরিবর্তন';

  @override
  String get confirmDelete => 'মুছে ফেলার নিশ্চিতকরণ';

  @override
  String get discard => 'বাতিল';

  @override
  String get createPost => 'পোস্ট তৈরি করুন';

  @override
  String get post => 'পোস্ট';

  @override
  String get postingTo => 'পোস্ট করা হচ্ছে';

  @override
  String get whatsOnYourMind => 'আপনার মনে কি চলছে?';

  @override
  String get pickImages => 'ছবি নির্বাচন করুন';

  @override
  String get pickVideo => 'ভিডিও নির্বাচন করুন';

  @override
  String get camera => 'ক্যামেরা';

  @override
  String get gallery => 'গ্যালারি';

  @override
  String get search => 'খুঁজুন';

  @override
  String get pleaseEnterTask => 'অনুগ্রহ করে কাজ লিখুন';

  @override
  String get deleteTask => 'কাজ মুছে ফেলুন';

  @override
  String get selectItems => 'আইটেম নির্বাচন করুন';

  @override
  String get deleteAll => 'সব মুছে ফেলুন';

  @override
  String error(Object error) {
    return 'ত্রুটি: $error';
  }

  @override
  String get orderingOnlyAvailableInAllPosts =>
      'বিন্যাস শুধুমাত্র \'সব পোস্ট\'-এ উপলব্ধ';

  @override
  String get deletePost => 'পোস্ট মুছে ফেলুন';

  @override
  String get postDeleted => 'পোস্ট মুছে ফেলা হয়েছে';

  @override
  String get premiumFeatures => 'প্রিমিয়াম বৈশিষ্ট্য';

  @override
  String get manageCoinsAdsPremium =>
      'কয়েন, বিজ্ঞাপন এবং প্রিমিয়াম স্ট্যাটাস পরিচালনা করুন';

  @override
  String get themeMode => 'থিম মোড';

  @override
  String get accentColor => 'রঙ';

  @override
  String get backgroundDesign => 'ব্যাকগ্রাউন্ড ডিজাইন';

  @override
  String get pushNotifications => 'পুশ নোটিফিকেশন';

  @override
  String get recycleBin => 'রিসাইকেল বিন';

  @override
  String get exportData => 'ডেটা এক্সপোর্ট';

  @override
  String get importData => 'ডেটা ইম্পোর্ট';

  @override
  String get rateApp => 'অ্যাপ রেট করুন';

  @override
  String get sendFeedback => 'ফিডব্যাক পাঠান';

  @override
  String get privacyPolicy => 'গোপনীয়তা নীতি';

  @override
  String get version => 'সংস্করণ';

  @override
  String get buildNumber => 'বিল্ড নম্বর';

  @override
  String get system => 'সিস্টেম';

  @override
  String get light => 'লাইট';

  @override
  String get dark => 'ডার্ক';

  @override
  String get itemRestored => 'আইটেম পুনরুদ্ধার করা হয়েছে';

  @override
  String get recycleBinCleared => 'রিসাইকেল বিন সফলভাবে খালি করা হয়েছে';

  @override
  String get allPostsDeleted => 'সব পোস্ট মুছে ফেলা হয়েছে';

  @override
  String get newPost => 'নতুন পোস্ট';

  @override
  String get textCopiedToClipboardFacebook =>
      'টেক্সট ক্লিপবোর্ডে কপি করা হয়েছে (Facebook পলিসি)';

  @override
  String get tiktokSharingRequiresVideoImage =>
      'TikTok শেয়ারিংয়ের জন্য ভিডিও/ছবি প্রয়োজন';

  @override
  String errorSharing(Object error) {
    return 'শেয়ার করতে ত্রুটি: $error';
  }

  @override
  String shareToStory(Object platform) {
    return '$platform স্টোরিতে শেয়ার করুন';
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
    return 'আপনি $amount কয়েন অর্জন করেছেন!';
  }

  @override
  String get contentCopied => 'কন্টেন্ট কপি করা হয়েছে';

  @override
  String get selectDateTime => 'তারিখ এবং সময় নির্বাচন করুন';

  @override
  String get areYouSureYouWantToDeleteThisPost =>
      'আপনি কি নিশ্চিতভাবে এই পোস্টটি মুছে ফেলতে চান?';

  @override
  String get socialPosts => 'সোশ্যাল পোস্ট';

  @override
  String get watchAdToEarnCoins => 'কয়েন অর্জন করতে বিজ্ঞাপন দেখুন';

  @override
  String get premiumUnlocked => 'প্রিমিয়াম আনলক করা হয়েছে';

  @override
  String get removeAds => 'বিজ্ঞাপন সরান';

  @override
  String get unlimitedCloudStorage => 'অসীম ক্লাউড স্টোরেজ';

  @override
  String get deleteNote => 'নোট মুছে ফেলুন';

  @override
  String get shareNote => 'নোট শেয়ার করুন';

  @override
  String get editNote => 'নোট সম্পাদনা করুন';

  @override
  String get searchNotes => 'নোট খুঁজুন...';

  @override
  String get noNotesFound => 'কোনো নোট পাওয়া যায়নি';

  @override
  String get captureThoughts => 'আপনার চিন্তা ঝরঝরে করে রেকর্ড করুন।';

  @override
  String get createNote => 'নোট তৈরি করুন';

  @override
  String get customOrder => 'কাস্টম অর্ডার';

  @override
  String get newestFirst => 'নতুনগুলো আগে';

  @override
  String get oldestFirst => 'পুরানো গুলো আগে';

  @override
  String get titleAZ => 'শিরোনাম: A-Z';

  @override
  String get titleZA => 'শিরোনাম: Z-A';

  @override
  String get deleteAllQuestion => 'সব মুছে ফেলবেন?';

  @override
  String get moveToRecycleBin => 'সব নোট রিসাইকেল বিনে সরাবেন?';

  @override
  String get moveToBinQuestion => 'বিনে সরাবেন?';

  @override
  String get restoreNoteLater => 'আপনি পরে এই নোটটি পুনরুদ্ধার করতে পারবেন।';

  @override
  String get move => 'সরান';

  @override
  String get myThoughts => 'আমার চিন্তা';

  @override
  String get selected => 'নির্বাচিত';

  @override
  String get noContent => 'কোনো কন্টেন্ট নেই';

  @override
  String get untitled => 'শিরোনামহীন';

  @override
  String get chooseWallpapers => '১০+ ডায়নামিক ওয়ালপেপার থেকে বেছে নিন';

  @override
  String get backupData => 'ডেটা ব্যাকআপ';

  @override
  String get saveJsonFile =>
      'আপনার সমস্ত ডেটা সহ একটি JSON ফাইল সংরক্ষণ করবেন?';

  @override
  String get exportNow => 'এখনই এক্সপোর্ট করুন';

  @override
  String get importDataTitle => 'ডেটা ইম্পোর্ট';

  @override
  String get mergeBackupFile =>
      'আপনার বর্তমান আইটেমগুলোর সাথে ব্যাকআপ ফাইলটি মার্জ করবেন?';

  @override
  String get selectFile => 'ফাইল নির্বাচন করুন';

  @override
  String get backupSaved => 'ব্যাকআপ সফলভাবে সংরক্ষিত হয়েছে!';

  @override
  String get exportFailed => 'এক্সপোর্ট ব্যর্থ হয়েছে।';

  @override
  String importSuccess(Object count) {
    return '$count টি আইটেম সফলভাবে পুনরুদ্ধার করা হয়েছে!';
  }

  @override
  String get importFailed => 'ইম্পোর্ট ব্যর্থ হয়েছে।';

  @override
  String widgetAdded(String widget) {
    return 'উইজেট $widget হোম স্ক্রিনে যুক্ত করা হয়েছে!';
  }

  @override
  String get widgetRequestSent =>
      'উইজেট অনুরোধ পাঠানো হয়েছে। অনুগ্রহ করে আপনার হোম স্ক্রিন চেক করুন।';

  @override
  String get widgetAddFailed => 'উইজেট যুক্ত করতে ব্যর্থ';

  @override
  String get autoSaveEnabled => 'অটো-সেভ চালু করা হয়েছে।';

  @override
  String get autoSaveDisabled => 'অটো-সেভ বন্ধ করা হয়েছে।';

  @override
  String get homeScreenWidgets => 'হোম স্ক্রিন উইজেট';

  @override
  String get notificationsTitle => 'বিজ্ঞপ্তি';

  @override
  String get dataBackup => 'ডেটা এবং ব্যাকআপ';

  @override
  String get feedbackSupport => 'ফিডব্যাক এবং সমর্থন';

  @override
  String get creditsTitle => 'কৃতিত্ব';

  @override
  String get privacyMaintenance => 'গোপনীয়তা এবং রক্ষণাবেক্ষণ';

  @override
  String get aboutTitle => 'সম্পর্কে';

  @override
  String get premium => 'প্রিমিয়াম';

  @override
  String get appearanceTitle => 'বাহ্যিক রূপ';

  @override
  String get clipboardTitle => 'ক্লিপবোর্ড';

  @override
  String get settingsSubtitle => 'আপনার অভিজ্ঞতা কাস্টমাইজ করুন';

  @override
  String get welcomeTitle => 'CopyClip-এ স্বাগতম';

  @override
  String get welcomeDescription =>
      'আপনার চমত্কার উৎপাদনশীলতা সঙ্গী। আপনার দিন পরিচালনা করতে শক্তিশালী টুলস দিয়ে আপনাকে সেট আপ করি।';

  @override
  String get onboardingNotesTitle => 'স্মার্ট নোটস';

  @override
  String get onboardingNotesDesc =>
      'রিচ টেক্সট ফরম্যাটিং সহ চিন্তাগুলো ঝরঝরে করে রেকর্ড করুন। আপনার চিন্তাগুলি গুছিয়ে রাখুন এবং কোনো দারুণ ধারণা হারাবেন না।';

  @override
  String get onboardingTodosTitle => 'টাস্ক ম্যানেজমেন্ট';

  @override
  String get onboardingTodosDesc =>
      'আপনার কাজে এগিয়ে থাকুন। টু-ডু লিস্ট তৈরি করুন, গুরুত্ব নির্ধারণ করুন এবং আপনার লক্ষ্য পূরণ করুন।';

  @override
  String get onboardingExpensesTitle => 'ব্যয় ট্র্যাকিং';

  @override
  String get onboardingExpensesDesc =>
      'আপনার অর্থ নিয়ন্ত্রণে আনুন। আপনার খরচের অভ্যাস বোঝার জন্য আয় এবং ব্যয় সহজেই ট্র্যাক করুন।';

  @override
  String get onboardingJournalTitle => 'ব্যক্তিগত জার্নাল';

  @override
  String get onboardingJournalDesc =>
      'আপনার দিন সম্পর্কে চিন্তা করুন। আপনার স্মৃতি, আবেগ এবং দৈনন্দিন অভিজ্ঞতা লেখার জন্য একটি গোপনীয় স্থান।';

  @override
  String get onboardingCalendarTitle => 'ক্যালেন্ডার এবং ইভেন্টস';

  @override
  String get onboardingCalendarDesc =>
      'কোনো মুহূর্ত হারাবেন না। আপনার কাজের সময়সূচী গুছিয়ে রাখুন এবং গুরুত্বপূর্ণ ইভেন্টগুলোর ট্র্যাক রাখুন।';

  @override
  String get onboardingClipboardTitle => 'ক্লিপবোর্ড ম্যানেজার';

  @override
  String get onboardingClipboardDesc =>
      'একবার কপি করুন, যেকোনো জায়গায় পেস্ট করুন। আগে কপি করা অংশগুলো ফিরে পেতে আপনার ক্লিপবোর্ড ইতিহাস এক্সেস করুন।';

  @override
  String get onboardingCanvasTitle => 'ক্রিয়েটিভ ক্যানভাস';

  @override
  String get onboardingCanvasDesc =>
      'আপনার সৃজনশীলতা প্রকাশ করুন। ডিজিটাল ক্যানভাসে আপনার চিন্তাগুলো আঁকুন এবং স্কেচ করুন।';

  @override
  String get featuresNotesDesc => 'আপনার নোটস তৈরি করুন এবং পরিচালনা করুন';

  @override
  String get featuresTodosDesc => 'আপনার কাজের ট্র্যাক রাখুন';

  @override
  String get featuresExpensesDesc => 'আপনার ব্যয়ের উপর নজর রাখুন';

  @override
  String get featuresJournalDesc => 'আপনার চিন্তা লিখুন';

  @override
  String get featuresCalendarDesc => 'আপনার সময়সূচী গুছিয়ে রাখুন';

  @override
  String get featuresClipboardDesc => 'আপনার ক্লিপবোর্ড ইতিহাস এক্সেস করুন';

  @override
  String get featuresCanvasDesc => 'মুক্তভাবে আঁকুন এবং স্কেচ করুন';

  @override
  String get featuresSocialPost => 'সোশ্যাল পোস্ট';

  @override
  String get featuresSocialPostDesc =>
      'আকর্ষণীয় সোশ্যাল মিডিয়া কন্টেন্ট তৈরি করুন';

  @override
  String get chooseYourAura => 'আপনার আভা বেছে নিন';

  @override
  String get expressYourselfTheme => 'নতুন থিম রঙের সাথে নিজেকে প্রকাশ করুন!';

  @override
  String get level => 'লেভেল';

  @override
  String get xpToNextLevel => 'পরবর্তী লেভেলে যাওয়ার জন্য XP';

  @override
  String get checkUpcomingEvents => 'আসন্ন ইভেন্টগুলো চেক করুন';

  @override
  String get startNewSketch => 'নতুন স্কেচ শুরু করুন';

  @override
  String get noTransactionsMonth => 'এই মাসে কোনো লেনদেন নেই';

  @override
  String transactionsThisMonth(num count) {
    return 'এই মাসে $count টি লেনদেন';
  }

  @override
  String get autoSaveClipboard => 'ক্লিপবোর্ড অটো-সেভ';

  @override
  String get autoSaveClipboardDesc =>
      'কপি করা আইটেমগুলি স্বয়ংক্রিয়ভাবে সংরক্ষণ করুন';

  @override
  String get permissionDeniedSettings =>
      'অনুমতি স্থায়ীভাবে প্রত্যাখ্যান করা হয়েছে। অনুগ্রহ করে সেটিংস থেকে চালু করুন।';

  @override
  String get notificationsEnabled => 'বিজ্ঞপ্তি চালু করা হয়েছে!';

  @override
  String get redirectingToSettings =>
      'বিজ্ঞপ্তি বন্ধ করতে সেটিংসে পাঠানো হচ্ছে...';

  @override
  String get premiumAccess => 'প্রিমিয়াম এক্সেস';

  @override
  String get premiumActiveUntil => 'প্রিমিয়াম সক্রিয় আছে পর্যন্ত';

  @override
  String get unlockAllFeatures => 'সমস্ত বৈশিষ্ট্য আনলক করুন';

  @override
  String get buyPremium => 'প্রিমিয়াম কিনুন (৭ দিন)';

  @override
  String costCoins(Object cost) {
    return 'খরচ: $cost কয়েন';
  }

  @override
  String get premiumActivated => '৭ দিনের জন্য প্রিমিয়াম সক্রিয় করা হয়েছে!';

  @override
  String get premiumActive => 'প্রিমিয়াম সক্রিয়';

  @override
  String get expires => 'মেয়াদ শেষ:';

  @override
  String get temporaryAccess => 'অস্থায়ী এক্সেস';

  @override
  String get journalExpression => 'জার্নাল এবং প্রকাশ';

  @override
  String get artisticDesigns => 'শৈল্পিক ডিজাইন';

  @override
  String get artisticDesignsDesc => '১০+ অনন্য জার্নাল কার্ড থিম আনলক করুন';

  @override
  String get premiumLayouts => 'প্রিমিয়াম লেআউট';

  @override
  String get premiumLayoutsDesc => 'আপনার স্মৃতি দেখার বিশেষ উপায়';

  @override
  String get calendarTools => 'ক্যালেন্ডার এবং টুলস';

  @override
  String get fullCalendar => 'পূর্ণ ক্যালেন্ডার';

  @override
  String get fullCalendarDesc => 'সম্পূর্ণ ইভেন্ট ম্যানেজমেন্ট সিস্টেম';

  @override
  String get clipboardAutoSaveDesc =>
      'ব্যাকগ্রাউন্ড ক্লিপবোর্ড ইতিহাস ক্যাপচার';

  @override
  String get proWidgets => 'প্রো উইজেটস';

  @override
  String get proWidgetsDesc => 'আপনার হোম স্ক্রিনে সমস্ত বৈশিষ্ট্য উপলব্ধ';

  @override
  String get dataExport => 'ডেটা এবং এক্সপোর্ট';

  @override
  String get advancedBackup => 'উন্নত ব্যাকআপ';

  @override
  String get advancedBackupDesc => 'সমস্ত ডেটার নিরাপদ ইম্পোর্ট/এক্সপোর্ট';

  @override
  String get pdfExport => 'PDF এক্সপোর্ট';

  @override
  String get pdfExportDesc => 'নোটস এবং জার্নাল PDF-এ এক্সপোর্ট করুন';

  @override
  String get printReady => 'প্রিন্টের জন্য প্রস্তুত';

  @override
  String get printReadyDesc => 'সরাসরি প্রিন্টিং সমর্থন';

  @override
  String get richTextEditor => 'রিচ টেক্সট এডিটর';

  @override
  String get advancedSearch => 'উন্নত অনুসন্ধান';

  @override
  String get advancedSearchDesc =>
      'আপনার পাঠ্যের মধ্যে খুঁজুন এবং প্রতিস্থাপন করুন';

  @override
  String get richMedia => 'রিচ মিডিয়া';

  @override
  String get richMediaDesc => 'ছবি, ভিডিও এবং লিঙ্ক যোগ করুন';

  @override
  String get editorStyling => 'এডিটর স্টাইলিং';

  @override
  String get editorStylingDesc => 'কাস্টম টেক্সট এবং এডিটর ব্যাকগ্রাউন্ড';

  @override
  String get balance => 'ব্যালেন্স';

  @override
  String get loadingAd => 'বিজ্ঞাপন লোড হচ্ছে...';

  @override
  String watchAd(Object amount) {
    return 'বিজ্ঞাপন দেখুন (+$amount)';
  }

  @override
  String get loadAd => 'বিজ্ঞাপন লোড করুন';

  @override
  String get backupDataDesc => 'আপনার ডেটার JSON ফাইল সংরক্ষণ করুন';

  @override
  String get importDataDesc => 'ব্যাকআপ ফাইলটি CopyClip-এ মার্জ করুন';

  @override
  String get notificationPermissionDenied =>
      'বিজ্ঞপ্তির অনুমতি প্রত্যাখ্যান করা হয়েছে।';

  @override
  String get typeNewTask => 'নতুন কাজ লিখুন...';

  @override
  String get addTask => 'কাজ যোগ করুন';

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
    return 'কাজ সম্পন্ন হয়েছে! +$amount XP';
  }

  @override
  String get moveTasksToRecycleBin => 'সব সক্রিয় কাজ রিসাইকেল বিনে সরাবেন?';

  @override
  String get deleteAllPosts => 'সব পোস্ট মুছে ফেলুন';

  @override
  String get deleteAllPostsConfirmation =>
      'আপনি কি নিশ্চিতভাবে সমস্ত সোশ্যাল পোস্ট মুছে ফেলতে চান? এটি আর ফিরে পাওয়া যাবে না।';

  @override
  String get allPosts => 'সব পোস্ট';

  @override
  String get favorites => 'প্রিয়';

  @override
  String get drafts => 'ড্রাফট';

  @override
  String get noFavoritesYet => 'এখনো কোনো প্রিয় আইটেম নেই';

  @override
  String get noDraftsYet => 'এখনো কোনো ড্রাফট নেই';

  @override
  String get startSocialJourney => 'আপনার সোশ্যাল যাত্রা শুরু করুন!';

  @override
  String get draft => 'ড্রাফট';

  @override
  String attachmentCount(num count) {
    return '$count টি সংযুক্ত ফাইল';
  }

  @override
  String get pleaseAddContent =>
      'শেয়ার করার জন্য অনুগ্রহ করে কিছু টেক্সট বা মিডিয়া যোগ করুন';

  @override
  String fileNotFoundError(Object path) {
    return 'ত্রুটি: $path এ ফাইল পাওয়া যায়নি';
  }

  @override
  String get checkFacebookApp => 'Facebook অ্যাপ চেক করুন';

  @override
  String get systemShare => 'সিস্টেম শেয়ার';

  @override
  String get socialPost => 'সোশ্যাল পোস্ট';

  @override
  String get favorite => 'প্রিয়';

  @override
  String get saveDraft => 'ড্রাফট সংরক্ষণ করুন';

  @override
  String get entryCopied => 'এন্ট্রি কপি করা হয়েছে';

  @override
  String get moveEntriesToRecycleBin =>
      'সব সক্রিয় এন্ট্রি রিসাইকেল বিনে সরাবেন?';

  @override
  String get startWritingStory => 'আপনার গল্প লিখতে শুরু করুন';

  @override
  String get recordMemories => 'আপনার দৈনন্দিন স্মৃতি এবং আবেগ রেকর্ড করুন।';

  @override
  String get writeJournal => 'জার্নাল লিখুন';

  @override
  String get myMemories => 'আমার স্মৃতি';

  @override
  String get sortJournal => 'জার্নাল বিন্যাস করুন';

  @override
  String get byMood => 'মুড অনুযায়ী';

  @override
  String get searchMemories => 'স্মৃতি খুঁজুন...';

  @override
  String get selectAll => 'সব নির্বাচন করুন';

  @override
  String get deleteSelected => 'নির্বাচিত গুলো মুছে ফেলুন';

  @override
  String get taskCompletedExclamation => 'কাজ সম্পন্ন হয়েছে!';

  @override
  String get taskUncompletedExclamation => 'কাজ অসম্পূর্ণ';

  @override
  String get clipboardUpdatedExclamation => 'ক্লিপবোর্ড আপডেট করা হয়েছে!';

  @override
  String clipboardSavedContent(Object content) {
    return 'ক্লিপবোর্ড সংরক্ষিত হয়েছে: $content';
  }

  @override
  String get overview => 'সংক্ষিপ্ত বিবরণ';

  @override
  String get colorAurora => 'অরোরা';

  @override
  String get colorCosmic => 'কসমিক';

  @override
  String get colorNebula => 'নেবুলা';

  @override
  String get colorStarlight => 'স্টারলাইট';

  @override
  String get colorSolar => 'সোলার';

  @override
  String get colorNova => 'নোভা';

  @override
  String get loadingStepLoading => 'লোড হচ্ছে...';

  @override
  String get loadingStepDatabase => 'ডেটাবেস সেটআপ হচ্ছে...';

  @override
  String get loadingStepSystem => 'সিস্টেম কনফিগার হচ্ছে...';

  @override
  String get loadingStepReady => 'প্রস্তুত';

  @override
  String get productivityCompanion => 'আপনার উৎপাদনশীলতা সঙ্গী';

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
  String get exportAsPdf => 'PDF হিসেবে এক্সপোর্ট করুন';

  @override
  String get taskDueNow => 'কাজ করার সময় হয়েছে';

  @override
  String get moveTaskToBinTitle => 'কাজটি রিসাইকেল বিনে সরাবেন?';

  @override
  String get restoreTaskLater =>
      'আপনি পরে এটি সেটিংস থেকে পুনরুদ্ধার করতে পারেন।';

  @override
  String get newTask => 'নতুন কাজ';

  @override
  String get editTask => 'কাজ সম্পাদনা করুন';

  @override
  String get undo => 'পূর্বাবস্থায় ফেরান';

  @override
  String get redo => 'পুনরায় করুন';

  @override
  String get category => 'বিভাগ';

  @override
  String get categoryHint => 'যেমন: অফিস, জিম';

  @override
  String get whatNeedsToBeDone => 'কি করা প্রয়োজন?';

  @override
  String get enterTaskDetails => 'কাজের বিবরণ লিখুন...';

  @override
  String get setDueDate => 'তারিখ নির্ধারণ করুন';

  @override
  String get dueDate => 'নির্দিষ্ট তারিখ';

  @override
  String get expenseTitle => 'ব্যয়';

  @override
  String searchInCurrency(String currency) {
    return '$currency এ খুঁজুন...';
  }

  @override
  String get sortAndFilter => 'বিন্যাস এবং ফিল্টার';

  @override
  String get sortBy => 'এর মাধ্যমে বিন্যাস করুন';

  @override
  String get highestAmount => 'সর্বোচ্চ পরিমাণ';

  @override
  String get lowestAmount => 'সর্বনিম্ন পরিমাণ';

  @override
  String get moreFilters => 'আরো ফিল্টার...';

  @override
  String get filterExpenses => 'ব্যয় ফিল্টার করুন';

  @override
  String get transactionType => 'লেনদেনের ধরন';

  @override
  String get categories => 'বিভাগসমূহ';

  @override
  String get all => 'সব';

  @override
  String get income => 'আয়';

  @override
  String get expense => 'ব্যয়';

  @override
  String get reset => 'রিসেট';

  @override
  String get apply => 'প্রয়োগ করুন';

  @override
  String newExpense(String currency) {
    return 'নতুন $currency';
  }

  @override
  String errorLoadingData(String error) {
    return 'ডেটা লোড করতে ত্রুটি।\n\n$error';
  }

  @override
  String get dailyQuote1 =>
      'ভবিষ্যদ্বাণী করার সেরা উপায় হলো তা নিজেই তৈরি করা।';

  @override
  String get dailyQuote2 => 'সম্পদ মানে সব থাকা নয়, বরং কম চাওয়া থাকা।';

  @override
  String get dailyQuote3 => 'সময়ই হলো আসল সম্পদ।';

  @override
  String get dailyQuote4 => 'সাফল্যই শেষ নয়, ব্যর্থতা মানেই মৃত্যু নয়।';

  @override
  String get dailyQuote5 => 'সমস্যার বদলে সমাধানের দিকে মন দিন।';

  @override
  String get dailyQuote6 => 'আপনার নেটওয়ার্কই আপনার সম্পদ।';

  @override
  String get moodHappy => 'খুশি';

  @override
  String get moodExcited => 'উত্তেজিত';

  @override
  String get moodNeutral => 'স্বাভাবিক';

  @override
  String get moodSad => 'দুঃখিত';

  @override
  String get moodStressed => 'মানসিক চাপে';

  @override
  String exportDate(String date) {
    return '📅 $date';
  }

  @override
  String exportMood(String emoji, String mood) {
    return 'মুড: $emoji $mood';
  }

  @override
  String exportTitle(String title) {
    return 'শিরোনাম: $title';
  }

  @override
  String exportTags(String tags) {
    return '\nট্যাগ: $tags';
  }

  @override
  String get instagram => 'ইনস্টাগ্রাম';

  @override
  String get facebook => 'ফেসবুক';

  @override
  String get tiktok => 'TikTok';

  @override
  String get newSketch => 'নতুন স্কেচ';

  @override
  String get searchSketches => 'স্কেচ এবং ফোল্ডার খুঁজুন...';

  @override
  String get noResultsFound => 'কোনো ফলাফল পাওয়া যায়নি';

  @override
  String get noItems => 'কোনো আইটেম নেই';

  @override
  String get noDrawingsYet => 'এখনো কোনো ছবি নেই';

  @override
  String get canvasIntro => 'ক্যানভাসে আপনার সৃজনশীলতা প্রকাশ করুন!';

  @override
  String get newCanvas => 'নতুন ক্যানভাস';

  @override
  String get rename => 'নাম পরিবর্তন';

  @override
  String get deleteFolder => 'ফোল্ডার মুছে ফেলুন';

  @override
  String get deleteSketchesQuestion => 'স্কেচগুলো মুছে ফেলবেন?';

  @override
  String get deleteFolderConfirmation =>
      'এই ফোল্ডারের সমস্ত স্কেচ স্থায়ীভাবে মুছে ফেলা হবে।';

  @override
  String get renameFolder => 'ফোল্ডারের নাম পরিবর্তন করুন';

  @override
  String get chooseColor => 'রঙ বেছে নিন';

  @override
  String get deleteFolderQuestion => 'ফোল্ডার মুছে ফেলবেন?';

  @override
  String get searchClips => 'ক্লিপগুলো খুঁজুন...';

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
  String get restoreClipLater => 'আপনি পরে এই ক্লিপটি পুনরুদ্ধার করতে পারবেন।';

  @override
  String get upcomingEvents => 'আসন্ন ইভেন্টসমূহ';

  @override
  String get dataDistribution => 'ডেটা বন্টন';

  @override
  String get taskProgress => 'কাজের অগ্রগতি';

  @override
  String get quickStats => 'দ্রুত পরিসংখ্যান';

  @override
  String get taskCompletion => 'কাজ সম্পন্ন হওয়া';

  @override
  String get noItemsForDate => 'এই তারিখের জন্য কোনো আইটেম নেই';

  @override
  String get enjoyFreeTime => 'আপনার অবসর সময় উপভোগ করুন!';

  @override
  String get searchThisDay => 'এই দিনে খুঁজুন...';

  @override
  String get finance => 'অর্থনীতি';

  @override
  String get permanentlyDelete => 'স্থায়ীভাবে মুছে ফেলবেন?';

  @override
  String deleteSelectionConfirmation(int foldersCount, int sketchesCount) {
    return 'এর ফলে $foldersCount টি ফোল্ডার এবং $sketchesCount টি স্কেচ স্থায়ীভাবে মুছে ফেলা হবে। এটি আর ফিরে পাওয়া যাবে না।';
  }

  @override
  String get deleteForever => 'স্থায়ীভাবে মুছে ফেলুন';

  @override
  String selectedCount(int count) {
    return '$count টি নির্বাচিত';
  }

  @override
  String canvasStats(int notes, int folders) {
    return '$notes টি স্কেচ • $folders টি ফোল্ডার';
  }

  @override
  String get sortItems => 'আইটেম বিন্যাস করুন';

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
    return '$count টি স্কেচ মুছে ফেলবেন? এটি আর ফিরে পাওয়া যাবে না।';
  }

  @override
  String get noSketchesFound => 'কোনো স্কেচ পাওয়া যায়নি';

  @override
  String get noSketchesFoundSub =>
      'অনুগ্রহ করে আপনার অনুসন্ধান পরিবর্তন করুন বা নতুন একটি স্কেচ তৈরি করুন।';

  @override
  String searchInFolder(String folder) {
    return '$folder এ খুঁজুন...';
  }

  @override
  String sketchesCount(int count) {
    return '$count টি স্কেচ';
  }

  @override
  String get sortSketches => 'স্কেচ বিন্যাস করুন';

  @override
  String get calendarScreenTitle => 'ক্যালেন্ডার';

  @override
  String get dailyActivity => 'দৈনিক কার্যক্রম';

  @override
  String get deleteItemQuestion => 'আইটেম মুছে ফেলবেন?';

  @override
  String get deleteItemConfirmation => 'এর ফলে আইটেমটি রিসাইকেল বিনে চলে যাবে।';

  @override
  String get moveToBinItem => 'বিনে সরাবেন?';

  @override
  String get moveToBinConfirmation => 'আপনি পরে এটি পুনরুদ্ধার করতে পারেন।';

  @override
  String selectedItems(int count) {
    return '$count টি নির্বাচিত';
  }

  @override
  String get recentClips => 'সাম্প্রতিক ক্লিপগুলো';

  @override
  String get copied => 'কপি করা হয়েছে!';

  @override
  String get copiedPlainText => 'প্লেইন টেক্সট কপি করা হয়েছে';

  @override
  String get clipTheme => 'ক্লিপ থিম';

  @override
  String get justNow => 'এইমাত্র';

  @override
  String minutesAgo(Object count) {
    return '$count মিনিট আগে';
  }

  @override
  String hoursAgo(Object count) {
    return '$count ঘণ্টা আগে';
  }

  @override
  String daysAgo(Object count) {
    return '$count দিন আগে';
  }

  @override
  String get noTasksFound => 'কোনো কাজ পাওয়া যায়নি।';

  @override
  String get searchTasks => 'কাজ খুঁজুন...';

  @override
  String get taskReminder => 'কাজের রিমাইন্ডার';

  @override
  String get untitledNote => 'শিরোনামহীন নোট';

  @override
  String get dailyEntry => 'দৈনিক এন্ট্রি';

  @override
  String get clipboardHistory => 'ক্লিপবোর্ড ইতিহাস';

  @override
  String get deletePermanentlyContent => 'এই কাজটি আর ফিরে পাওয়া যাবে না।';

  @override
  String get emptyRecycleBinTitle => 'রিসাইকেল বিন খালি করবেন?';

  @override
  String emptyRecycleBinContent(Object count) {
    return 'সমস্ত $count টি আইটেম স্থায়ীভাবে মুছে ফেলা হবে।';
  }

  @override
  String get emptyBin => 'বিন খালি করুন';

  @override
  String get recycleBinEmpty => 'রিসাইকেল বিন খালি';

  @override
  String get deletedItemsAppearHere => 'মুছে ফেলা আইটেমগুলো এখানে দেখা যাবে।';

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
  String get saveTransactionQuestion => 'আপনি কি এই লেনদেনটি সংরক্ষণ করতে চান?';

  @override
  String get fillTitleAmount => 'অনুগ্রহ করে শিরোনাম এবং পরিমাণ লিখুন';

  @override
  String get invalidAmount => 'ভুল পরিমাণের ফরম্যাট';

  @override
  String get moveTransactionToBinTitle => 'লেনদেনটি রিসাইকেল বিনে সরাবেন?';

  @override
  String get restoreTransactionLater =>
      'আপনি পরে সেটিংস থেকে এই লেনদেনটি পুনরুদ্ধার করতে পারেন।';

  @override
  String get newTransaction => 'নতুন লেনদেন';

  @override
  String get whatIsThisFor => 'এটি কি জন্য?';

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
  String get totalExpense => 'মোট ব্যয়';

  @override
  String get analysis => 'বিশ্লেষণ';

  @override
  String get transactions => 'লেনদেনসমূহ';

  @override
  String get noExpensesFound => 'এই সময়ের জন্য কোনো ব্যয় পাওয়া যায়নি।';

  @override
  String get netBalance => 'নীট ব্যালেন্স';

  @override
  String get topCategories => 'শীর্ষ বিভাগসমূহ';

  @override
  String get spendingTrend => 'ব্যয়ের ধারা';

  @override
  String get insights => 'ইনসাইটস';

  @override
  String get noExpensesRecorded => 'কোনো ব্যয় রেকর্ড করা হয়নি';

  @override
  String get trackSpendingHabits => 'আপনার ব্যয়ের অভ্যাস সহজে ট্র্যাক করুন।';

  @override
  String get addExpense => 'ব্যয় যোগ করুন';

  @override
  String get noDataForPeriod => 'এই সময়ের জন্য কোনো তথ্য নেই';

  @override
  String get budget => 'বাজেট';

  @override
  String get spent => 'ব্যয় হয়েছে';

  @override
  String get limit => 'সীমা';

  @override
  String get overBudget => 'বাজেট ছাড়িয়ে গেছে!';

  @override
  String remainingBudget(Object percent) {
    return '$percent% বাকি';
  }

  @override
  String get savingsRate => 'সঞ্চয়ের হার';

  @override
  String get healthScore => 'হেলথ স্কোর';

  @override
  String get healthScoreExplanation =>
      'এই স্কোরটি আপনার সঞ্চয়ের হারের ওপর ভিত্তি করে।\n\n• > ৫০% সঞ্চয় = চমৎকার (১০০)\n• ০% সঞ্চয় = গড়পড়তা (৫০)\n• ব্যয় > আয় = দুর্বল (<৫০)';

  @override
  String get ok => 'ঠিক আছে';

  @override
  String get bulkImport => 'বাল্ক ইম্পোর্ট';
}

/// The translations for Bengali Bangla, as used in Bangladesh (`bn_BD`).
class AppLocalizationsBnBd extends AppLocalizationsBn {
  AppLocalizationsBnBd() : super('bn_BD');

  @override
  String get settings => 'সেটিংস';

  @override
  String get language => 'ভাষা';

  @override
  String get systemDefault => 'সিস্টেম ডিফল্ট';

  @override
  String get notes => 'নোটস';

  @override
  String get todos => 'কাজ';

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
  String get delete => 'মুছে ফেলুন';

  @override
  String get edit => 'সম্পাদনা';

  @override
  String get share => 'শেয়ার করুন';

  @override
  String get copy => 'কপি করুন';

  @override
  String get unsavedChanges => 'অসংরক্ষিত পরিবর্তন';

  @override
  String get confirmDelete => 'মুছে ফেলার নিশ্চিতকরণ';

  @override
  String get discard => 'বাতিল';

  @override
  String get createPost => 'পোস্ট তৈরি করুন';

  @override
  String get post => 'পোস্ট';

  @override
  String get postingTo => 'পোস্ট করা হচ্ছে';

  @override
  String get whatsOnYourMind => 'আপনার মনে কি চলছে?';

  @override
  String get pickImages => 'ছবি নির্বাচন করুন';

  @override
  String get pickVideo => 'ভিডিও নির্বাচন করুন';

  @override
  String get camera => 'ক্যামেরা';

  @override
  String get gallery => 'গ্যালারি';

  @override
  String get search => 'খুঁজুন';

  @override
  String get pleaseEnterTask => 'অনুগ্রহ করে কাজ লিখুন';

  @override
  String get deleteTask => 'কাজ মুছে ফেলুন';

  @override
  String get selectItems => 'আইটেম নির্বাচন করুন';

  @override
  String get deleteAll => 'সব মুছে ফেলুন';

  @override
  String error(Object error) {
    return 'ত্রুটি: $error';
  }

  @override
  String get orderingOnlyAvailableInAllPosts =>
      'বিন্যাস শুধুমাত্র \'সব পোস্ট\'-এ উপলব্ধ';

  @override
  String get deletePost => 'পোস্ট মুছে ফেলুন';

  @override
  String get postDeleted => 'পোস্ট মুছে ফেলা হয়েছে';

  @override
  String get premiumFeatures => 'প্রিমিয়াম বৈশিষ্ট্য';

  @override
  String get manageCoinsAdsPremium =>
      'কয়েন, বিজ্ঞাপন এবং প্রিমিয়াম স্ট্যাটাস পরিচালনা করুন';

  @override
  String get themeMode => 'থিম মোড';

  @override
  String get accentColor => 'রঙ';

  @override
  String get backgroundDesign => 'ব্যাকগ্রাউন্ড ডিজাইন';

  @override
  String get pushNotifications => 'পুশ নোটিফিকেশন';

  @override
  String get recycleBin => 'রিসাইকেল বিন';

  @override
  String get exportData => 'ডেটা এক্সপোর্ট';

  @override
  String get importData => 'ডেটা ইম্পোর্ট';

  @override
  String get rateApp => 'অ্যাপ রেট করুন';

  @override
  String get sendFeedback => 'ফিডব্যাক পাঠান';

  @override
  String get privacyPolicy => 'গোপনীয়তা নীতি';

  @override
  String get version => 'সংস্করণ';

  @override
  String get buildNumber => 'বিল্ড নম্বর';

  @override
  String get system => 'সিস্টেম';

  @override
  String get light => 'লাইট';

  @override
  String get dark => 'ডার্ক';

  @override
  String get itemRestored => 'আইটেম পুনরুদ্ধার করা হয়েছে';

  @override
  String get recycleBinCleared => 'রিসাইকেল বিন সফলভাবে খালি করা হয়েছে';

  @override
  String get allPostsDeleted => 'সব পোস্ট মুছে ফেলা হয়েছে';

  @override
  String get newPost => 'নতুন পোস্ট';

  @override
  String get textCopiedToClipboardFacebook =>
      'টেক্সট ক্লিপবোর্ডে কপি করা হয়েছে (Facebook পলিসি)';

  @override
  String get tiktokSharingRequiresVideoImage =>
      'TikTok শেয়ারিংয়ের জন্য ভিডিও/ছবি প্রয়োজন';

  @override
  String errorSharing(Object error) {
    return 'শেয়ার করতে ত্রুটি: $error';
  }

  @override
  String shareToStory(Object platform) {
    return '$platform স্টোরিতে শেয়ার করুন';
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
    return 'আপনি $amount কয়েন অর্জন করেছেন!';
  }

  @override
  String get contentCopied => 'কন্টেন্ট কপি করা হয়েছে';

  @override
  String get selectDateTime => 'তারিখ এবং সময় নির্বাচন করুন';

  @override
  String get areYouSureYouWantToDeleteThisPost =>
      'আপনি কি নিশ্চিতভাবে এই পোস্টটি মুছে ফেলতে চান?';

  @override
  String get socialPosts => 'সোশ্যাল পোস্ট';

  @override
  String get watchAdToEarnCoins => 'কয়েন অর্জন করতে বিজ্ঞাপন দেখুন';

  @override
  String get premiumUnlocked => 'প্রিমিয়াম আনলক করা হয়েছে';

  @override
  String get removeAds => 'বিজ্ঞাপন সরান';

  @override
  String get unlimitedCloudStorage => 'অসীম ক্লাউড স্টোরেজ';

  @override
  String get deleteNote => 'নোট মুছে ফেলুন';

  @override
  String get shareNote => 'নোট শেয়ার করুন';

  @override
  String get editNote => 'নোট সম্পাদনা করুন';

  @override
  String get searchNotes => 'নোট খুঁজুন...';

  @override
  String get noNotesFound => 'কোনো নোট পাওয়া যায়নি';

  @override
  String get captureThoughts => 'আপনার চিন্তা ঝরঝরে করে রেকর্ড করুন।';

  @override
  String get createNote => 'নোট তৈরি করুন';

  @override
  String get customOrder => 'কাস্টম অর্ডার';

  @override
  String get newestFirst => 'নতুনগুলো আগে';

  @override
  String get oldestFirst => 'পুরানো গুলো আগে';

  @override
  String get titleAZ => 'শিরোনাম: A-Z';

  @override
  String get titleZA => 'শিরোনাম: Z-A';

  @override
  String get deleteAllQuestion => 'সব মুছে ফেলবেন?';

  @override
  String get moveToRecycleBin => 'সব নোট রিসাইকেল বিনে সরাবেন?';

  @override
  String get moveToBinQuestion => 'বিনে সরাবেন?';

  @override
  String get restoreNoteLater => 'আপনি পরে এই নোটটি পুনরুদ্ধার করতে পারবেন।';

  @override
  String get move => 'সরান';

  @override
  String get myThoughts => 'আমার চিন্তা';

  @override
  String get selected => 'নির্বাচিত';

  @override
  String get noContent => 'কোনো কন্টেন্ট নেই';

  @override
  String get untitled => 'শিরোনামহীন';

  @override
  String get chooseWallpapers => '১০+ ডায়নামিক ওয়ালপেপার থেকে বেছে নিন';

  @override
  String get backupData => 'ডেটা ব্যাকআপ';

  @override
  String get saveJsonFile =>
      'আপনার সমস্ত ডেটা সহ একটি JSON ফাইল সংরক্ষণ করবেন?';

  @override
  String get exportNow => 'এখনই এক্সপোর্ট করুন';

  @override
  String get importDataTitle => 'ডেটা ইম্পোর্ট';

  @override
  String get mergeBackupFile =>
      'আপনার বর্তমান আইটেমগুলোর সাথে ব্যাকআপ ফাইলটি মার্জ করবেন?';

  @override
  String get selectFile => 'ফাইল নির্বাচন করুন';

  @override
  String get backupSaved => 'ব্যাকআপ সফলভাবে সংরক্ষিত হয়েছে!';

  @override
  String get exportFailed => 'এক্সপোর্ট ব্যর্থ হয়েছে।';

  @override
  String importSuccess(Object count) {
    return '$count টি আইটেম সফলভাবে পুনরুদ্ধার করা হয়েছে!';
  }

  @override
  String get importFailed => 'ইম্পোর্ট ব্যর্থ হয়েছে।';

  @override
  String widgetAdded(String widget) {
    return 'উইজেট $widget হোম স্ক্রিনে যুক্ত করা হয়েছে!';
  }

  @override
  String get widgetRequestSent =>
      'উইজেট অনুরোধ পাঠানো হয়েছে। অনুগ্রহ করে আপনার হোম স্ক্রিন চেক করুন।';

  @override
  String get widgetAddFailed => 'উইজেট যুক্ত করতে ব্যর্থ';

  @override
  String get autoSaveEnabled => 'অটো-সেভ চালু করা হয়েছে।';

  @override
  String get autoSaveDisabled => 'অটো-সেভ বন্ধ করা হয়েছে।';

  @override
  String get homeScreenWidgets => 'হোম স্ক্রিন উইজেট';

  @override
  String get notificationsTitle => 'বিজ্ঞপ্তি';

  @override
  String get dataBackup => 'ডেটা এবং ব্যাকআপ';

  @override
  String get feedbackSupport => 'ফিডব্যাক এবং সমর্থন';

  @override
  String get creditsTitle => 'কৃতিত্ব';

  @override
  String get privacyMaintenance => 'গোপনীয়তা এবং রক্ষণাবেক্ষণ';

  @override
  String get aboutTitle => 'সম্পর্কে';

  @override
  String get premium => 'প্রিমিয়াম';

  @override
  String get appearanceTitle => 'বাহ্যিক রূপ';

  @override
  String get clipboardTitle => 'ক্লিপবোর্ড';

  @override
  String get settingsSubtitle => 'আপনার অভিজ্ঞতা কাস্টমাইজ করুন';

  @override
  String get welcomeTitle => 'CopyClip-এ স্বাগতম';

  @override
  String get welcomeDescription =>
      'আপনার চমত্কার উৎপাদনশীলতা সঙ্গী। আপনার দিন পরিচালনা করতে শক্তিশালী টুলস দিয়ে আপনাকে সেট আপ করি।';

  @override
  String get onboardingNotesTitle => 'স্মার্ট নোটস';

  @override
  String get onboardingNotesDesc =>
      'রিচ টেক্সট ফরম্যাটিং সহ চিন্তাগুলো ঝরঝরে করে রেকর্ড করুন। আপনার চিন্তাগুলি গুছিয়ে রাখুন এবং কোনো দারুণ ধারণা হারাবেন না।';

  @override
  String get onboardingTodosTitle => 'টাস্ক ম্যানেজমেন্ট';

  @override
  String get onboardingTodosDesc =>
      'আপনার কাজে এগিয়ে থাকুন। টু-ডু লিস্ট তৈরি করুন, গুরুত্ব নির্ধারণ করুন এবং আপনার লক্ষ্য পূরণ করুন।';

  @override
  String get onboardingExpensesTitle => 'ব্যয় ট্র্যাকিং';

  @override
  String get onboardingExpensesDesc =>
      'আপনার অর্থ নিয়ন্ত্রণে আনুন। আপনার খরচের অভ্যাস বোঝার জন্য আয় এবং ব্যয় সহজেই ট্র্যাক করুন।';

  @override
  String get onboardingJournalTitle => 'ব্যৌক্তিক জার্নাল';

  @override
  String get onboardingJournalDesc =>
      'আপনার দিন সম্পর্কে চিন্তা করুন। আপনার স্মৃতি, আবেগ এবং দৈনন্দিন অভিজ্ঞতা লেখার জন্য একটি গোপনীয় স্থান।';

  @override
  String get onboardingCalendarTitle => 'ক্যালেন্ডার এবং ইভেন্টস';

  @override
  String get onboardingCalendarDesc =>
      'কোনো মুহূর্ত হারাবেন না। আপনার কাজের সময়সূচী গুছিয়ে রাখুন এবং গুরুত্বপূর্ণ ইভেন্টগুলোর ট্র্যাক রাখুন।';

  @override
  String get onboardingClipboardTitle => 'ক্লিপবোর্ড ম্যানেজার';

  @override
  String get onboardingClipboardDesc =>
      'একবার কপি করুন, যেকোনো জায়গায় পেস্ট করুন। আগে কপি করা অংশগুলো ফিরে পেতে আপনার ক্লিপবোর্ড ইতিহাস এক্সেস করুন।';

  @override
  String get onboardingCanvasTitle => 'ক্রিয়েটিভ ক্যানভাস';

  @override
  String get onboardingCanvasDesc =>
      'আপনার সৃজনশীলতা প্রকাশ করুন। ডিজিটাল ক্যানভাসে আপনার চিন্তাগুলো আঁকুন এবং স্কেচ করুন।';

  @override
  String get featuresNotesDesc => 'আপনার নোটস তৈরি করুন এবং পরিচালনা করুন';

  @override
  String get featuresTodosDesc => 'আপনার কাজের ট্র্যাক রাখুন';

  @override
  String get featuresExpensesDesc => 'আপনার ব্যয়ের উপর নজর রাখুন';

  @override
  String get featuresJournalDesc => 'আপনার চিন্তা লিখুন';

  @override
  String get featuresCalendarDesc => 'আপনার সময়সূচী গুছিয়ে রাখুন';

  @override
  String get featuresClipboardDesc => 'আপনার ক্লিপবোর্ড ইতিহাস এক্সেস করুন';

  @override
  String get featuresCanvasDesc => 'মুক্তভাবে আঁকুন এবং স্কেচ করুন';

  @override
  String get featuresSocialPost => 'সোশ্যাল পোস্ট';

  @override
  String get featuresSocialPostDesc =>
      'আকর্ষণীয় সোশ্যাল মিডিয়া কন্টেন্ট তৈরি করুন';

  @override
  String get chooseYourAura => 'আপনার আভা বেছে নিন';

  @override
  String get expressYourselfTheme => 'নতুন থিম রঙের সাথে নিজেকে প্রকাশ করুন!';

  @override
  String get level => 'লেভেল';

  @override
  String get xpToNextLevel => 'পরবর্তী লেভেলে যাওয়ার জন্য XP';

  @override
  String get checkUpcomingEvents => 'আসন্ন ইভেন্টগুলো চেক করুন';

  @override
  String get startNewSketch => 'নতুন স্কেচ শুরু করুন';

  @override
  String get noTransactionsMonth => 'এই মাসে কোনো লেনদেন নেই';

  @override
  String transactionsThisMonth(num count) {
    return 'এই মাসে $count টি লেনদেন';
  }

  @override
  String get autoSaveClipboard => 'ক্লিপবোর্ড অটো-সেভ';

  @override
  String get autoSaveClipboardDesc =>
      'কপি করা আইটেমগুলি স্বয়ংক্রিয়ভাবে সংরক্ষণ করুন';

  @override
  String get permissionDeniedSettings =>
      'অনুমতি স্থায়ীভাবে প্রত্যাখ্যান করা হয়েছে। অনুগ্রহ করে সেটিংস থেকে চালু করুন।';

  @override
  String get notificationsEnabled => 'বিজ্ঞপ্তি চালু করা হয়েছে!';

  @override
  String get redirectingToSettings =>
      'বিজ্ঞপ্তি বন্ধ করতে সেটিংসে পাঠানো হচ্ছে...';

  @override
  String get premiumAccess => 'প্রিমিয়াম এক্সেস';

  @override
  String get premiumActiveUntil => 'প্রিমিয়াম সক্রিয় আছে পর্যন্ত';

  @override
  String get unlockAllFeatures => 'সমস্ত বৈশিষ্ট্য আনলক করুন';

  @override
  String get buyPremium => 'প্রিমিয়াম কিনুন (৭ দিন)';

  @override
  String costCoins(Object cost) {
    return 'খরচ: $cost কয়েন';
  }

  @override
  String get premiumActivated => '৭ দিনের জন্য প্রিমিয়াম সক্রিয় করা হয়েছে!';

  @override
  String get premiumActive => 'প্রিমিয়াম সক্রিয়';

  @override
  String get expires => 'মেয়াদ শেষ:';

  @override
  String get temporaryAccess => 'অস্থায়ী এক্সেস';

  @override
  String get journalExpression => 'জার্নাল এবং প্রকাশ';

  @override
  String get artisticDesigns => 'শৈল্পিক ডিজাইন';

  @override
  String get artisticDesignsDesc => '১০+ অনন্য জার্নাল কার্ড থিম আনলক করুন';

  @override
  String get premiumLayouts => 'প্রিমিয়াম লেআউট';

  @override
  String get premiumLayoutsDesc => 'আপনার স্মৃতি দেখার বিশেষ উপায়';

  @override
  String get calendarTools => 'ক্যালেন্ডার এবং টুলস';

  @override
  String get fullCalendar => 'পূর্ণ ক্যালেন্ডার';

  @override
  String get fullCalendarDesc => 'সম্পূর্ণ ইভেন্ট ম্যানেজমেন্ট সিস্টেম';

  @override
  String get clipboardAutoSaveDesc =>
      'ব্যাকগ্রাউন্ড ক্লিপবোর্ড ইতিহাস ক্যাপচার';

  @override
  String get proWidgets => 'প্রো উইজেটস';

  @override
  String get proWidgetsDesc => 'আপনার হোম স্ক্রিনে সমস্ত বৈশিষ্ট্য উপলব্ধ';

  @override
  String get dataExport => 'ডেটা এবং এক্সপোর্ট';

  @override
  String get advancedBackup => 'উন্নত ব্যাকআপ';

  @override
  String get advancedBackupDesc => 'সমস্ত ডেটার নিরাপদ ইম্পোর্ট/এক্সপোর্ট';

  @override
  String get pdfExport => 'PDF এক্সপোর্ট';

  @override
  String get pdfExportDesc => 'নোটস এবং জার্নাল PDF-এ এক্সপোর্ট করুন';

  @override
  String get printReady => 'প্রিন্টের জন্য প্রস্তুত';

  @override
  String get printReadyDesc => 'সরাসরি প্রিন্টিং সমর্থন';

  @override
  String get richTextEditor => 'রিচ টেক্সট এডিটর';

  @override
  String get advancedSearch => 'উন্নত অনুসন্ধান';

  @override
  String get advancedSearchDesc =>
      'আপনার পাঠ্যের মধ্যে খুঁজুন এবং প্রতিস্থাপন করুন';

  @override
  String get richMedia => 'রিচ মিডিয়া';

  @override
  String get richMediaDesc => 'ছবি, ভিডিও এবং লিঙ্ক যোগ করুন';

  @override
  String get editorStyling => 'এডিটর স্টাইলিং';

  @override
  String get editorStylingDesc => 'কাস্টম টেক্সট এবং এডিটর ব্যাকগ্রাউন্ড';

  @override
  String get balance => 'ব্যালেন্স';

  @override
  String get loadingAd => 'বিজ্ঞাপন লোড হচ্ছে...';

  @override
  String watchAd(Object amount) {
    return 'বিজ্ঞাপন দেখুন (+$amount)';
  }

  @override
  String get loadAd => 'বিজ্ঞাপন লোড করুন';

  @override
  String get backupDataDesc => 'আপনার ডেটার JSON ফাইল সংরক্ষণ করুন';

  @override
  String get importDataDesc => 'ব্যাকআপ ফাইলটি CopyClip-এ মার্জ করুন';

  @override
  String get notificationPermissionDenied =>
      'বিজ্ঞপ্তির অনুমতি প্রত্যাখ্যান করা হয়েছে।';

  @override
  String get typeNewTask => 'নতুন কাজ লিখুন...';

  @override
  String get addTask => 'কাজ যোগ করুন';

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
    return 'কাজ সম্পন্ন হয়েছে! +$amount XP';
  }

  @override
  String get moveTasksToRecycleBin => 'সব সক্রিয় কাজ রিসাইকেল বিনে সরাবেন?';

  @override
  String get deleteAllPosts => 'সব পোস্ট মুছে ফেলুন';

  @override
  String get deleteAllPostsConfirmation =>
      'আপনি কি নিশ্চিতভাবে সমস্ত সোশ্যাল পোস্ট মুছে ফেলতে চান? এটি আর ফিরে পাওয়া যাবে না।';

  @override
  String get allPosts => 'সব পোস্ট';

  @override
  String get favorites => 'প্রিয়';

  @override
  String get drafts => 'ড্রাফট';

  @override
  String get noFavoritesYet => 'এখনো কোনো প্রিয় আইটেম নেই';

  @override
  String get noDraftsYet => 'এখনো কোনো ড্রাফট নেই';

  @override
  String get startSocialJourney => 'আপনার সোশ্যাল যাত্রা শুরু করুন!';

  @override
  String get draft => 'ড্রাফট';

  @override
  String attachmentCount(num count) {
    return '$count টি সংযুক্ত ফাইল';
  }

  @override
  String get pleaseAddContent =>
      'শেয়ার করার জন্য অনুগ্রহ করে কিছু টেক্সট বা মিডিয়া যোগ করুন';

  @override
  String fileNotFoundError(Object path) {
    return 'ত্রুটি: $path এ ফাইল পাওয়া যায়নি';
  }

  @override
  String get checkFacebookApp => 'Facebook অ্যাপ চেক করুন';

  @override
  String get systemShare => 'সিস্টেম শেয়ার';

  @override
  String get socialPost => 'সো্যাল পোস্ট';

  @override
  String get favorite => 'প্রিয়';

  @override
  String get saveDraft => 'ড্রাফট সংরক্ষণ করুন';

  @override
  String get entryCopied => 'এন্ট্রি কপি করা হয়েছে';

  @override
  String get moveEntriesToRecycleBin =>
      'সব সক্রিয় এন্ট্রি রিসাইকেল বিনে সরাবেন?';

  @override
  String get startWritingStory => 'আপনার গল্প লিখতে শুরু করুন';

  @override
  String get recordMemories => 'আপনার দৈনন্দিন স্মৃতি এবং আবেগ রেকর্ড করুন।';

  @override
  String get writeJournal => 'জার্নাল লিখুন';

  @override
  String get myMemories => 'আমার স্মৃতি';

  @override
  String get sortJournal => 'জার্নাল বিন্যাস করুন';

  @override
  String get byMood => 'মুড অনুযায়ী';

  @override
  String get searchMemories => 'স্মৃতি খুঁজুন...';

  @override
  String get selectAll => 'সব নির্বাচন করুন';

  @override
  String get deleteSelected => 'নির্বাচিত গুলো মুছে ফেলুন';

  @override
  String get taskCompletedExclamation => 'কাজ সম্পন্ন হয়েছে!';

  @override
  String get taskUncompletedExclamation => 'কাজ অসম্পূর্ণ';

  @override
  String get clipboardUpdatedExclamation => 'ক্লিপবোর্ড আপডেট করা হয়েছে!';

  @override
  String clipboardSavedContent(Object content) {
    return 'ক্লিপবোর্ড সংরক্ষিত হয়েছে: $content';
  }

  @override
  String get overview => 'সংক্ষিপ্ত বিবরণ';

  @override
  String get colorAurora => 'অরোরা';

  @override
  String get colorCosmic => 'কসমিক';

  @override
  String get colorNebula => 'নেবুলা';

  @override
  String get colorStarlight => 'স্টারলাইট';

  @override
  String get colorSolar => 'সোলার';

  @override
  String get colorNova => 'নোভা';

  @override
  String get loadingStepLoading => 'লোড হচ্ছে...';

  @override
  String get loadingStepDatabase => 'ডেটাবেস সেটআপ হচ্ছে...';

  @override
  String get loadingStepSystem => 'সিস্টেম কনফিগার হচ্ছে...';

  @override
  String get loadingStepReady => 'প্রস্তুত';

  @override
  String get productivityCompanion => 'আপনার উৎপাদনশীলতা সঙ্গী';

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
  String get exportAsPdf => 'PDF হিসেবে এক্সপোর্ট করুন';

  @override
  String get taskDueNow => 'কাজ করার সময় হয়েছে';

  @override
  String get moveTaskToBinTitle => 'কাজটি রিসাইকেল বিনে সরাবেন?';

  @override
  String get restoreTaskLater =>
      'আপনি পরে এটি সেটিংস থেকে পুনরুদ্ধার করতে পারেন।';

  @override
  String get newTask => 'নতুন কাজ';

  @override
  String get editTask => 'কাজ সম্পাদনা করুন';

  @override
  String get undo => 'পূর্বাবস্থায় ফেরান';

  @override
  String get redo => 'পুনরায় করুন';

  @override
  String get category => 'বিভাগ';

  @override
  String get categoryHint => 'যেমন: অফিস, জিম';

  @override
  String get whatNeedsToBeDone => 'কি করা প্রয়োজন?';

  @override
  String get enterTaskDetails => 'কাজের বিবরণ লিখুন...';

  @override
  String get setDueDate => 'তারিখ নির্ধারণ করুন';

  @override
  String get dueDate => 'নির্দিষ্ট তারিখ';

  @override
  String get expenseTitle => 'ব্যয়';

  @override
  String searchInCurrency(String currency) {
    return '$currency এ খুঁজুন...';
  }

  @override
  String get sortAndFilter => 'বিন্যাস এবং ফিল্টার';

  @override
  String get sortBy => 'এর মাধ্যমে বিন্যাস করুন';

  @override
  String get highestAmount => 'সর্বোচ্চ পরিমাণ';

  @override
  String get lowestAmount => 'সর্বনিম্ন পরিমাণ';

  @override
  String get moreFilters => 'আরো ফিল্টার...';

  @override
  String get filterExpenses => 'ব্যয় ফিল্টার করুন';

  @override
  String get transactionType => 'লেনদেনের ধরন';

  @override
  String get categories => 'বিভাগসমূহ';

  @override
  String get all => 'সব';

  @override
  String get income => 'আয়';

  @override
  String get expense => 'ব্যয়';

  @override
  String get reset => 'রিসেট';

  @override
  String get apply => 'প্রয়োগ করুন';

  @override
  String newExpense(String currency) {
    return 'নতুন $currency';
  }

  @override
  String errorLoadingData(String error) {
    return 'ডেটা লোড করতে ত্রুটি।\n\n$error';
  }

  @override
  String get dailyQuote1 =>
      'ভবিষ্যদ্বাণী করার সেরা উপায় হলো তা নিজেই তৈরি করা।';

  @override
  String get dailyQuote2 => 'সম্পদ মানে সব থাকা নয়, বরং কম চাওয়া থাকা।';

  @override
  String get dailyQuote3 => 'সময়ই হলো আসল সম্পদ।';

  @override
  String get dailyQuote4 => 'সাফল্যই শেষ নয়, ব্যর্থতা মানেই মৃত্যু নয়।';

  @override
  String get dailyQuote5 => 'সমস্যার বদলে সমাধানের দিকে মন দিন।';

  @override
  String get dailyQuote6 => 'আপনার নেটওয়ার্কই আপনার সম্পদ।';

  @override
  String get moodHappy => 'খুশি';

  @override
  String get moodExcited => 'উত্তেজিত';

  @override
  String get moodNeutral => 'স্বাভাবিক';

  @override
  String get moodSad => 'দুঃখিত';

  @override
  String get moodStressed => 'মানসিক চাপে';

  @override
  String exportDate(String date) {
    return '📅 $date';
  }

  @override
  String exportMood(String emoji, String mood) {
    return 'মুড: $emoji $mood';
  }

  @override
  String exportTitle(String title) {
    return 'শিরোনাম: $title';
  }

  @override
  String exportTags(String tags) {
    return '\nট্যাগ: $tags';
  }

  @override
  String get instagram => 'ইনস্টাগ্রাম';

  @override
  String get facebook => 'ফেসবুক';

  @override
  String get tiktok => 'TikTok';

  @override
  String get newSketch => 'নতুন স্কেচ';

  @override
  String get searchSketches => 'স্কেচ এবং ফোল্ডার খুঁজুন...';

  @override
  String get noResultsFound => 'কোনো ফলাফল পাওয়া যায়নি';

  @override
  String get noItems => 'কোনো আইটেম নেই';

  @override
  String get noDrawingsYet => 'এখনো কোনো ছবি নেই';

  @override
  String get canvasIntro => 'ক্যানভাসে আপনার সৃজনশীলতা প্রকাশ করুন!';

  @override
  String get newCanvas => 'নতুন ক্যানভাস';

  @override
  String get rename => 'নাম পরিবর্তন';

  @override
  String get deleteFolder => 'ফোল্ডার মুছে ফেলুন';

  @override
  String get deleteSketchesQuestion => 'স্কেচগুলো মুছে ফেলবেন?';

  @override
  String get deleteFolderConfirmation =>
      'এই ফোল্ডারের সমস্ত স্কেচ স্থায়ীভাবে মুছে ফেলা হবে।';

  @override
  String get renameFolder => 'ফোল্ডারের নাম পরিবর্তন করুন';

  @override
  String get chooseColor => 'রঙ বেছে নিন';

  @override
  String get deleteFolderQuestion => 'ফোল্ডার মুছে ফেলবেন?';

  @override
  String get searchClips => 'ক্লিপগুলো খুঁজুন...';

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
  String get restoreClipLater => 'আপনি পরে এই ক্লিপটি পুনরুদ্ধার করতে পারবেন।';

  @override
  String get upcomingEvents => 'আসন্ন ইভেন্টসমূহ';

  @override
  String get dataDistribution => 'ডেটা বন্টন';

  @override
  String get taskProgress => 'কাজের অগ্রগতি';

  @override
  String get quickStats => 'দ্রুত পরিসংখ্যান';

  @override
  String get taskCompletion => 'কাজ সম্পন্ন হওয়া';

  @override
  String get noItemsForDate => 'এই তারিখের জন্য কোনো আইটেম নেই';

  @override
  String get enjoyFreeTime => 'আপনার অবসর সময় উপভোগ করুন!';

  @override
  String get searchThisDay => 'এই দিনে খুঁজুন...';

  @override
  String get finance => 'অর্থনীতি';

  @override
  String get permanentlyDelete => 'স্থায়ীভাবে মুছে ফেলবেন?';

  @override
  String deleteSelectionConfirmation(int foldersCount, int sketchesCount) {
    return 'এর ফলে $foldersCount টি ফোল্ডার এবং $sketchesCount টি স্কেচ স্থায়ীভাবে মুছে ফেলা হবে। এটি আর ফিরে পাওয়া যাবে না।';
  }

  @override
  String get deleteForever => 'স্থায়ীভাবে মুছে ফেলুন';

  @override
  String selectedCount(int count) {
    return '$count টি নির্বাচিত';
  }

  @override
  String canvasStats(int notes, int folders) {
    return '$notes টি স্কেচ • $folders টি ফোল্ডার';
  }

  @override
  String get sortItems => 'আইটেম বিন্যাস করুন';

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
    return '$count টি স্কেচ মুছে ফেলবেন? এটি আর ফিরে পাওয়া যাবে না।';
  }

  @override
  String get noSketchesFound => 'কোনো স্কেচ পাওয়া যায়নি';

  @override
  String get noSketchesFoundSub =>
      'অনুগ্রহ করে আপনার অনুসন্ধান পরিবর্তন করুন বা নতুন একটি স্কেচ তৈরি করুন।';

  @override
  String searchInFolder(String folder) {
    return '$folder এ খুঁজুন...';
  }

  @override
  String sketchesCount(int count) {
    return '$count টি স্কেচ';
  }

  @override
  String get sortSketches => 'স্কেচ বিন্যাস করুন';

  @override
  String get calendarScreenTitle => 'ক্যালেন্ডার';

  @override
  String get dailyActivity => 'দৈনিক কার্যক্রম';

  @override
  String get deleteItemQuestion => 'আইটেম মুছে ফেলবেন?';

  @override
  String get deleteItemConfirmation => 'এর ফলে আইটেমটি রিসাইকেল বিনে চলে যাবে।';

  @override
  String get moveToBinItem => 'বিনে সরাবেন?';

  @override
  String get moveToBinConfirmation => 'আপনি পরে এটি পুনরুদ্ধার করতে পারেন।';

  @override
  String selectedItems(int count) {
    return '$count টি নির্বাচিত';
  }

  @override
  String get recentClips => 'সাম্প্রতিক ক্লিপগুলো';

  @override
  String get copied => 'কপি করা হয়েছে!';

  @override
  String get copiedPlainText => 'প্লেইন টেক্সট কপি করা হয়েছে';

  @override
  String get clipTheme => 'ক্লিপ থিম';

  @override
  String get justNow => 'এইমাত্র';

  @override
  String minutesAgo(Object count) {
    return '$count মিনিট আগে';
  }

  @override
  String hoursAgo(Object count) {
    return '$count ঘণ্টা আগে';
  }

  @override
  String daysAgo(Object count) {
    return '$count দিন আগে';
  }

  @override
  String get noTasksFound => 'কোনো কাজ পাওয়া যায়নি।';

  @override
  String get searchTasks => 'কাজ খুঁজুন...';

  @override
  String get taskReminder => 'কাজের রিমাইন্ডার';

  @override
  String get untitledNote => 'শিরোনামহীন নোট';

  @override
  String get dailyEntry => 'দৈনিক এন্ট্রি';

  @override
  String get clipboardHistory => 'ক্লিপবোর্ড ইতিহাস';

  @override
  String get deletePermanentlyContent => 'এই কাজটি আর ফিরে পাওয়া যাবে না।';

  @override
  String get emptyRecycleBinTitle => 'রিসাইকেল বিন খালি করবেন?';

  @override
  String emptyRecycleBinContent(Object count) {
    return 'সমস্ত $count টি আইটেম স্থায়ীভাবে মুছে ফেলা হবে।';
  }

  @override
  String get emptyBin => 'বিন খালি করুন';

  @override
  String get recycleBinEmpty => 'রিসাইকেল বিন খালি';

  @override
  String get deletedItemsAppearHere => 'মুছে ফেলা আইটেমগুলো এখানে দেখা যাবে।';

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
  String get saveTransactionQuestion => 'আপনি কি এই লেনদেনটি সংরক্ষণ করতে চান?';

  @override
  String get fillTitleAmount => 'অনুগ্রহ করে শিরোনাম এবং পরিমাণ লিখুন';

  @override
  String get invalidAmount => 'ভুল পরিমাণের ফরম্যাট';

  @override
  String get moveTransactionToBinTitle => 'লেনদেনটি রিসাইকেল বিনে সরাবেন?';

  @override
  String get restoreTransactionLater =>
      'আপনি পরে সেটিংস থেকে এই লেনদেনটি পুনরুদ্ধার করতে পারেন।';

  @override
  String get newTransaction => 'নতুন লেনদেন';

  @override
  String get whatIsThisFor => 'এটি কি জন্য?';

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
  String get totalExpense => 'মোট ব্যয়';

  @override
  String get analysis => 'বিশ্লেষণ';

  @override
  String get transactions => 'লেনদেনসমূহ';

  @override
  String get noExpensesFound => 'এই সময়ের জন্য কোনো ব্যয় পাওয়া যায়নি।';

  @override
  String get netBalance => 'নীট ব্যালেন্স';

  @override
  String get topCategories => 'শীর্ষ বিভাগসমূহ';

  @override
  String get spendingTrend => 'ব্যয়ের ধারা';

  @override
  String get insights => 'ইনসাইটস';

  @override
  String get noExpensesRecorded => 'কোনো ব্যয় রেকর্ড করা হয়নি';

  @override
  String get trackSpendingHabits => 'আপনার ব্যয়ের অভ্যাস সহজে ট্র্যাক করুন।';

  @override
  String get addExpense => 'ব্যয় যোগ করুন';

  @override
  String get noDataForPeriod => 'এই সময়ের জন্য কোনো তথ্য নেই';

  @override
  String get budget => 'বাজেট';

  @override
  String get spent => 'ব্যয় হয়েছে';

  @override
  String get limit => 'সীমা';

  @override
  String get overBudget => 'বাজেট ছাড়িয়ে গেছে!';

  @override
  String remainingBudget(Object percent) {
    return '$percent% বাকি';
  }

  @override
  String get savingsRate => 'সঞ্চয়ের হার';

  @override
  String get healthScore => 'হেলথ স্কোর';

  @override
  String get healthScoreExplanation =>
      'এই স্কোরটি আপনার সঞ্চয়ের হারের ওপর ভিত্তি করে।\n\n• > ৫০% সঞ্চয় = চমৎকার (১০০)\n• ০% সঞ্চয় = গড়পড়তা (৫০)\n• ব্যয় > আয় = দুর্বল (<৫০)';

  @override
  String get ok => 'ঠিক আছে';

  @override
  String get bulkImport => 'বাল্ক ইম্পোর্ট';
}
