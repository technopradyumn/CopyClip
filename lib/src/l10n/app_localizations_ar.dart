// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get settings => 'إعدادات';

  @override
  String get language => 'لغة';

  @override
  String get systemDefault => 'النظام الافتراضي';

  @override
  String get notes => 'ملحوظات';

  @override
  String get todos => 'المهام';

  @override
  String get expenses => 'نفقات';

  @override
  String get journal => 'مجلة';

  @override
  String get calendar => 'تقويم';

  @override
  String get clipboard => 'الحافظة';

  @override
  String get canvas => 'قماش';

  @override
  String get save => 'حفظ';

  @override
  String get create => 'إنشاء';

  @override
  String get cancel => 'إلغاء';

  @override
  String get delete => 'حذف';

  @override
  String get edit => 'تعديل';

  @override
  String get share => 'مشاركة';

  @override
  String get copy => 'نسخ';

  @override
  String get unsavedChanges => 'تغييرات غير محفوظة';

  @override
  String get confirmDelete => 'تأكيد الحذف';

  @override
  String get discard => 'تجاهل';

  @override
  String get createPost => 'إنشاء منشور';

  @override
  String get post => 'منشور';

  @override
  String get postingTo => 'النشر في';

  @override
  String get whatsOnYourMind => 'ماذا يدور في ذهنك؟';

  @override
  String get pickImages => 'اختر صورًا';

  @override
  String get pickVideo => 'اختر فيديو';

  @override
  String get camera => 'كاميرا';

  @override
  String get gallery => 'معرض الصور';

  @override
  String get search => 'بحث';

  @override
  String get pleaseEnterTask => 'يرجى إدخال مهمة';

  @override
  String get deleteTask => 'حذف المهمة';

  @override
  String get selectItems => 'حدد العناصر';

  @override
  String get deleteAll => 'حذف الكل';

  @override
  String error(Object error) {
    return 'خطأ: $error';
  }

  @override
  String get orderingOnlyAvailableInAllPosts =>
      'الترتيب متاح فقط في \"جميع المنشورات\"';

  @override
  String get deletePost => 'حذف المنشور';

  @override
  String get postDeleted => 'تم حذف المنشور';

  @override
  String get premiumFeatures => 'ميزات بريميوم';

  @override
  String get manageCoinsAdsPremium =>
      'إدارة العملات والإعلانات وحالة البريميوم';

  @override
  String get themeMode => 'وضع المظهر';

  @override
  String get accentColor => 'لون التمييز';

  @override
  String get backgroundDesign => 'تصميم الخلفية';

  @override
  String get pushNotifications => 'إشعارات الدفع';

  @override
  String get recycleBin => 'سلة المحذوفات';

  @override
  String get exportData => 'تصدير البيانات';

  @override
  String get importData => 'استيراد البيانات';

  @override
  String get rateApp => 'تقييم التطبيق';

  @override
  String get sendFeedback => 'إرسال تعليقات';

  @override
  String get privacyPolicy => 'سياسة الخصوصية';

  @override
  String get version => 'الإصدار';

  @override
  String get buildNumber => 'رقم البناء';

  @override
  String get system => 'النظام';

  @override
  String get light => 'فاتح';

  @override
  String get dark => 'داكن';

  @override
  String get itemRestored => 'تمت استعادة العنصر';

  @override
  String get recycleBinCleared => 'تم إفراغ سلة المحذوفات بنجاح';

  @override
  String get allPostsDeleted => 'تم حذف جميع المنشورات';

  @override
  String get newPost => 'منشور جديد';

  @override
  String get textCopiedToClipboardFacebook =>
      'تم نسخ النص إلى الحافظة (سياسة فيسبوك)';

  @override
  String get tiktokSharingRequiresVideoImage =>
      'تتطلب مشاركة TikTok فيديو/صورة';

  @override
  String errorSharing(Object error) {
    return 'خطأ في المشاركة: $error';
  }

  @override
  String shareToStory(Object platform) {
    return 'مشاركة في قصة $platform';
  }

  @override
  String shareToFeed(Object platform) {
    return 'مشاركة في موجز $platform';
  }

  @override
  String get unlockPermanently => 'فتح بشكل دائم';

  @override
  String get notEnoughCoins => 'لا توجد عملات كافية!';

  @override
  String youEarnedCoins(Object amount) {
    return 'لقد ربحت $amount من العملات!';
  }

  @override
  String get contentCopied => 'تم نسخ المحتوى';

  @override
  String get selectDateTime => 'حدد التاريخ والوقت';

  @override
  String get areYouSureYouWantToDeleteThisPost =>
      'هل أنت متأكد أنك تريد حذف هذا المنشور؟';

  @override
  String get socialPosts => 'منشورات اجتماعية';

  @override
  String get watchAdToEarnCoins => 'شاهد إعلانًا لربح العملات';

  @override
  String get premiumUnlocked => 'تم فتح البريميوم';

  @override
  String get removeAds => 'إزالة الإعلانات';

  @override
  String get unlimitedCloudStorage => 'تخزين سحابي غير محدود';

  @override
  String get deleteNote => 'حذف الملاحظة';

  @override
  String get shareNote => 'مشاركة الملاحظة';

  @override
  String get editNote => 'تعديل الملاحظة';

  @override
  String get searchNotes => 'البحث في الملاحظات...';

  @override
  String get noNotesFound => 'لم يتم العثور على ملاحظات';

  @override
  String get captureThoughts => 'سجل أفكارك فورا.';

  @override
  String get createNote => 'إنشاء ملاحظة';

  @override
  String get customOrder => 'ترتيب مخصص';

  @override
  String get newestFirst => 'الأحدث أولاً';

  @override
  String get oldestFirst => 'الأقدم أولاً';

  @override
  String get titleAZ => 'العنوان: أ-ي';

  @override
  String get titleZA => 'العنوان: ي-أ';

  @override
  String get deleteAllQuestion => 'حذف الكل؟';

  @override
  String get moveToRecycleBin => 'نقل جميع الملاحظات إلى سلة المحذوفات؟';

  @override
  String get moveToBinQuestion => 'نقل إلى السلة؟';

  @override
  String get restoreNoteLater => 'يمكنك استعادة هذه الملاحظة لاحقًا.';

  @override
  String get move => 'نقل';

  @override
  String get myThoughts => 'أفكاري';

  @override
  String get selected => 'محدد';

  @override
  String get noContent => 'لا يوجد محتوى';

  @override
  String get untitled => 'بدون عنوان';

  @override
  String get chooseWallpapers => 'اختر من بين أكثر من 10 خلفيات ديناميكية';

  @override
  String get backupData => 'نسخ احتياطي للبيانات';

  @override
  String get saveJsonFile => 'هل تريد حفظ ملف JSON يحتوي على جميع بياناتك؟';

  @override
  String get exportNow => 'تصدير الآن';

  @override
  String get importDataTitle => 'استيراد البيانات';

  @override
  String get mergeBackupFile =>
      'هل تريد دمج ملف النسخ الاحتياطي مع العناصر الحالية؟';

  @override
  String get selectFile => 'حدد ملفاً';

  @override
  String get backupSaved => 'تم حفظ النسخة الاحتياطية بنجاح!';

  @override
  String get exportFailed => 'فشل التصدير.';

  @override
  String importSuccess(Object count) {
    return 'تمت استعادة $count من العناصر بنجاح!';
  }

  @override
  String get importFailed => 'فشل الاستيراد.';

  @override
  String widgetAdded(String widget) {
    return 'تمت إضافة الأداة $widget إلى الشاشة الرئيسية!';
  }

  @override
  String get widgetRequestSent =>
      'تم إرسال طلب الأداة. يرجى التحقق من الشاشة الرئيسية.';

  @override
  String get widgetAddFailed => 'فشل إضافة الأداة';

  @override
  String get autoSaveEnabled => 'تم تفعيل الحفظ التلقائي.';

  @override
  String get autoSaveDisabled => 'تم تعطيل الحفظ التلقائي.';

  @override
  String get homeScreenWidgets => 'أدوات الشاشة الرئيسية';

  @override
  String get notificationsTitle => 'الإشعارات';

  @override
  String get dataBackup => 'البيانات والنسخ الاحتياطي';

  @override
  String get feedbackSupport => 'التعليقات والدعم';

  @override
  String get creditsTitle => 'الاعتمادات';

  @override
  String get privacyMaintenance => 'الخصوصية والصيانة';

  @override
  String get aboutTitle => 'حول';

  @override
  String get premium => 'بريميوم';

  @override
  String get appearanceTitle => 'المظهر';

  @override
  String get clipboardTitle => 'الحافظة';

  @override
  String get settingsSubtitle => 'تخصيص تجربتك';

  @override
  String get welcomeTitle => 'مرحبًا بك في CopyClip';

  @override
  String get welcomeDescription =>
      'رفيقك النهائي للإنتاجية. دعنا نجهزك بأدوات قوية لإدارة يومك.';

  @override
  String get onboardingNotesTitle => 'ملاحظات ذكية';

  @override
  String get onboardingNotesDesc =>
      'التقط الأفكار فورًا بتنسيق نص غني. نظم أفكارك ولا تفقد أي فكرة رائعة مرة أخرى.';

  @override
  String get onboardingTodosTitle => 'إدارة المهام';

  @override
  String get onboardingTodosDesc =>
      'ابق مطلعاً على أمورك. أنشئ قوائم مهام، وحدد الأولويات، وحقق أهدافك خطوة بخطوة.';

  @override
  String get onboardingExpensesTitle => 'تتبع النفقات';

  @override
  String get onboardingExpensesDesc =>
      'تحكم في أموالك. تتبع الدخل والنفقات بسهولة لفهم عادات الإنفاق الخاصة بك.';

  @override
  String get onboardingJournalTitle => 'يوميات شخصية';

  @override
  String get onboardingJournalDesc =>
      'تأمل في يومك. مساحة خاصة لتدوين ذكرياتك ومشاعرك وتجاربك اليومية.';

  @override
  String get onboardingCalendarTitle => 'التقويم والأحداث';

  @override
  String get onboardingCalendarDesc =>
      'لا تفوت أي لحظة. نظم جدولك وتابع الأحداث الهامة القادمة.';

  @override
  String get onboardingClipboardTitle => 'مدير الحافظة';

  @override
  String get onboardingClipboardDesc =>
      'انسخ مرة واحدة، والصق في أي مكان. الوصول إلى سجل الحافظة لاستعادة النصوص التي نسختها سابقاً.';

  @override
  String get onboardingCanvasTitle => 'لوحة إبداعية';

  @override
  String get onboardingCanvasDesc =>
      'أطلق العنان لإبداعك. ارسم وخطط وصور أفكارك على لوحة رقمية حرة.';

  @override
  String get featuresNotesDesc => 'إنشاء وإدارة الملاحظات الخاصة بك';

  @override
  String get featuresTodosDesc => 'تتبع المهام الخاصة بك';

  @override
  String get featuresExpensesDesc => 'مراقبة النفقات الخاصة بك';

  @override
  String get featuresJournalDesc => 'اكتتب أفكارك';

  @override
  String get featuresCalendarDesc => 'نظم جدولك الزمني';

  @override
  String get featuresClipboardDesc => 'الوصول إلى سجل الحافظة الخاص بك';

  @override
  String get featuresCanvasDesc => 'ارسم وخطط بحرية';

  @override
  String get featuresSocialPost => 'منشور اجتماعي';

  @override
  String get featuresSocialPostDesc =>
      'إنشاء محتوى جذاب لوسائل التواصل الاجتماعي';

  @override
  String get chooseYourAura => 'اختر هالتك';

  @override
  String get expressYourselfTheme => 'عبر عن نفسك بلون مظهر جديد!';

  @override
  String get level => 'المستوى';

  @override
  String get xpToNextLevel => 'XP للمستوى التالي';

  @override
  String get checkUpcomingEvents => 'تحقق من الأحداث القادمة';

  @override
  String get startNewSketch => 'بدأ رسمة جديدة';

  @override
  String get noTransactionsMonth => 'لا توجد معاملات هذا الشهر';

  @override
  String transactionsThisMonth(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count معاملات هذا الشهر',
      two: 'معاملتان هذا الشهر',
      one: 'معاملة واحدة هذا الشهر',
      zero: 'لا توجد معاملات هذا الشهر',
    );
    return '$_temp0';
  }

  @override
  String get autoSaveClipboard => 'حفظ تلقائي للحافظة';

  @override
  String get autoSaveClipboardDesc => 'حفظ العناصر المنسوخة تلقائياً';

  @override
  String get permissionDeniedSettings =>
      'تم رفض الإذن بشكل دائم. يرجى تفعيله من الإعدادات.';

  @override
  String get notificationsEnabled => 'تم تفعيل الإشعارات!';

  @override
  String get redirectingToSettings =>
      'جارٍ التوجيه إلى الإعدادات لتعطيل الإشعارات...';

  @override
  String get premiumAccess => 'وصول بريميوم';

  @override
  String get premiumActiveUntil => 'بريميوم نشط حتى';

  @override
  String get unlockAllFeatures => 'فتح جميع الميزات';

  @override
  String get buyPremium => 'شراء بريميوم (7 أيام)';

  @override
  String costCoins(Object cost) {
    return 'التكلفة: $cost عملات';
  }

  @override
  String get premiumActivated => 'تم تفعيل البريميوم لمدة 7 أيام!';

  @override
  String get premiumActive => 'البريميوم نشط';

  @override
  String get expires => 'تنتهي الصلاحية:';

  @override
  String get temporaryAccess => 'وصول مؤقت';

  @override
  String get journalExpression => 'يوميات وتعبير';

  @override
  String get artisticDesigns => 'تصاميم فنية';

  @override
  String get artisticDesignsDesc =>
      'فتح أكثر من 10 مظاهر فريدة لبطاقات اليوميات';

  @override
  String get premiumLayouts => 'تخطيطات بريميوم';

  @override
  String get premiumLayoutsDesc => 'طرق حصرية لعرض ذكرياتك';

  @override
  String get calendarTools => 'تقويم وأدوات';

  @override
  String get fullCalendar => 'تقويم كامل';

  @override
  String get fullCalendarDesc => 'نظام متكامل لإدارة الأحداث';

  @override
  String get clipboardAutoSaveDesc => 'التقاط سجل الحافظة في الخلفية';

  @override
  String get proWidgets => 'أدوات ذكية للمحترفين';

  @override
  String get proWidgetsDesc => 'جميع الميزات متوفرة على شاشتك الرئيسية';

  @override
  String get dataExport => 'البيانات والتصدير';

  @override
  String get advancedBackup => 'نسخ احتياطي متقدم';

  @override
  String get advancedBackupDesc => 'استيراد/تصدير آمن لجميع البيانات';

  @override
  String get pdfExport => 'تصدير إلى PDF';

  @override
  String get pdfExportDesc => 'تصدير الملاحظات واليوميات إلى PDF';

  @override
  String get printReady => 'جاهز للطباعة';

  @override
  String get printReadyDesc => 'دعم الطباعة المباشرة';

  @override
  String get richTextEditor => 'محرر نص غني';

  @override
  String get advancedSearch => 'بحث متقدم';

  @override
  String get advancedSearchDesc => 'البحث والاستبدال داخل النص';

  @override
  String get richMedia => 'وسائط غنية';

  @override
  String get richMediaDesc => 'إدراج صور وفيديوهات وروابط';

  @override
  String get editorStyling => 'تنسيق المحرر';

  @override
  String get editorStylingDesc => 'نص مخصص وخلفيات للمحرر';

  @override
  String get balance => 'الرصيد';

  @override
  String get loadingAd => 'جارٍ تحميل الإعلان...';

  @override
  String watchAd(Object amount) {
    return 'مشاهدة إعلان (+$amount)';
  }

  @override
  String get loadAd => 'تحميل إعلان';

  @override
  String get backupDataDesc => 'حفظ ملف JSON لبياناتك';

  @override
  String get importDataDesc => 'دمج ملف نسخة احتياطية في CopyClip';

  @override
  String get notificationPermissionDenied => 'تم رفض إذن الإشعارات.';

  @override
  String get typeNewTask => 'اكتب مهمة جديدة...';

  @override
  String get addTask => 'إضافة مهمة';

  @override
  String get completed => 'مكتمل';

  @override
  String get greatJob => 'عمل رائع!';

  @override
  String youEarnedXPNextTask(Object amount, Object date) {
    return 'لقد ربحت $amount XP! المهمة التالية: $date';
  }

  @override
  String taskCompletedXP(Object amount) {
    return 'تمت المهمة! +$amount XP';
  }

  @override
  String get moveTasksToRecycleBin =>
      'نقل جميع المهام النشطة إلى سلة المحذوفات؟';

  @override
  String get deleteAllPosts => 'حذف جميع المنشورات';

  @override
  String get deleteAllPostsConfirmation =>
      'هل أنت متأكد أنك تريد حذف جميع المنشورات الاجتماعية؟ لا يمكن التراجع عن هذا الإجراء.';

  @override
  String get allPosts => 'جميع المنشورات';

  @override
  String get favorites => 'المفضلة';

  @override
  String get drafts => 'المسودات';

  @override
  String get noFavoritesYet => 'لا توجد مفضلات بعد';

  @override
  String get noDraftsYet => 'لا توجد مسودات بعد';

  @override
  String get startSocialJourney => 'ابدأ رحلتك الاجتماعية!';

  @override
  String get draft => 'مسودة';

  @override
  String attachmentCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count مرفقات',
      two: 'مرفقان',
      one: 'مرفق واحد',
      zero: 'لا توجد مرفقات',
    );
    return '$_temp0';
  }

  @override
  String get pleaseAddContent => 'يرجى إضافة بعض المحتوى أو الوسائط للمشاركة';

  @override
  String fileNotFoundError(Object path) {
    return 'خطأ: لم يتم العثور على الملف في $path';
  }

  @override
  String get checkFacebookApp => 'تحقق من تطبيق فيسبوك';

  @override
  String get systemShare => 'مشاركة النظام';

  @override
  String get socialPost => 'منشور اجتماعي';

  @override
  String get favorite => 'مفضل';

  @override
  String get saveDraft => 'حفظ المسودة';

  @override
  String get entryCopied => 'تم نسخ المدخل';

  @override
  String get moveEntriesToRecycleBin =>
      'نقل جميع المدخلات النشطة إلى سلة المحذوفات؟';

  @override
  String get startWritingStory => 'ابدأ بكتابة قصتك';

  @override
  String get recordMemories => 'سجل ذكرياتك ومشاعرك اليومية.';

  @override
  String get writeJournal => 'اكتب يومياتك';

  @override
  String get myMemories => 'ذكرياتي';

  @override
  String get sortJournal => 'فرز اليوميات';

  @override
  String get byMood => 'حسب المزاج';

  @override
  String get searchMemories => 'بحث في الذكريات...';

  @override
  String get selectAll => 'تحديد الكل';

  @override
  String get deleteSelected => 'حذف المحدد';

  @override
  String get taskCompletedExclamation => 'تمت المهمة!';

  @override
  String get taskUncompletedExclamation => 'مهمة غير مكتملة';

  @override
  String get clipboardUpdatedExclamation => 'تم تحديث الحافظة!';

  @override
  String clipboardSavedContent(Object content) {
    return 'تم حفظ في الحافظة: $content';
  }

  @override
  String get overview => 'نظرة عامة';

  @override
  String get colorAurora => 'أورورا';

  @override
  String get colorCosmic => 'كوني';

  @override
  String get colorNebula => 'سديم';

  @override
  String get colorStarlight => 'ضوء النجوم';

  @override
  String get colorSolar => 'شمسي';

  @override
  String get colorNova => 'نوفا';

  @override
  String get loadingStepLoading => 'جارٍ التحميل...';

  @override
  String get loadingStepDatabase => 'إعداد قاعدة البيانات...';

  @override
  String get loadingStepSystem => 'تكوين النظام...';

  @override
  String get loadingStepReady => 'جاهز';

  @override
  String get productivityCompanion => 'رفيقك للإنتاجية';

  @override
  String get done => 'تم';

  @override
  String get newNote => 'ملاحظة جديدة';

  @override
  String get changeColor => 'تغيير اللون';

  @override
  String get copyContent => 'نسخ المحتوى';

  @override
  String get titleOptional => 'العنوان (اختياري)';

  @override
  String get exportAsPdf => 'تصدير كـ PDF';

  @override
  String get taskDueNow => 'موعد المهمة الآن';

  @override
  String get moveTaskToBinTitle => 'نقل المهمة إلى سلة المحذوفات؟';

  @override
  String get restoreTaskLater =>
      'يمكنك استعادة هذه المهمة لاحقًا من الإعدادات.';

  @override
  String get newTask => 'مهمة جديدة';

  @override
  String get editTask => 'تعديل المهمة';

  @override
  String get undo => 'تراجع';

  @override
  String get redo => 'إعادة';

  @override
  String get category => 'الفئة';

  @override
  String get categoryHint => 'مثال: العمل، النادي';

  @override
  String get whatNeedsToBeDone => 'ما الذي يجب القيام به؟';

  @override
  String get enterTaskDetails => 'أدخل تفاصيل المهمة...';

  @override
  String get setDueDate => 'تحديد موعد الاستحقاق';

  @override
  String get dueDate => 'موعد الاستحقاق';

  @override
  String get expenseTitle => 'النفقات';

  @override
  String searchInCurrency(String currency) {
    return 'بحث في $currency...';
  }

  @override
  String get sortAndFilter => 'فرز وتصفية';

  @override
  String get sortBy => 'فرز حسب';

  @override
  String get highestAmount => 'أعلى مبلغ';

  @override
  String get lowestAmount => 'أقل مبلغ';

  @override
  String get moreFilters => 'مزيد من الفلاتر...';

  @override
  String get filterExpenses => 'تصفية النفقات';

  @override
  String get transactionType => 'نوع المعاملة';

  @override
  String get categories => 'الفئات';

  @override
  String get all => 'الكل';

  @override
  String get income => 'الدخل';

  @override
  String get expense => 'المصروفات';

  @override
  String get reset => 'إعادة تعيين';

  @override
  String get apply => 'تطبيق';

  @override
  String newExpense(String currency) {
    return 'جديد $currency';
  }

  @override
  String errorLoadingData(String error) {
    return 'حدث خطأ أثناء تحميل البيانات.\n\n$error';
  }

  @override
  String get dailyQuote1 => 'أفضل طريقة للتنبؤ بالمستقبل هي أن تصنعه.';

  @override
  String get dailyQuote2 => 'الغنى ليس في كثرة العرض، ولكن الغنى غنى النفس.';

  @override
  String get dailyQuote3 => 'الوقت هو العملة الأغلى.';

  @override
  String get dailyQuote4 => 'النجاح ليس نهائياً، والفشل ليس قاتلاً.';

  @override
  String get dailyQuote5 => 'ركز على الحل، وليس المشكلة.';

  @override
  String get dailyQuote6 => 'شبكة علاقاتك هي ثروتك الحقيقية.';

  @override
  String get moodHappy => 'سعيد';

  @override
  String get moodExcited => 'متحمس';

  @override
  String get moodNeutral => 'محايد';

  @override
  String get moodSad => 'حزين';

  @override
  String get moodStressed => 'متوتر';

  @override
  String exportDate(String date) {
    return '📅 $date';
  }

  @override
  String exportMood(String emoji, String mood) {
    return 'المزاج: $emoji $mood';
  }

  @override
  String exportTitle(String title) {
    return 'العنوان: $title';
  }

  @override
  String exportTags(String tags) {
    return '\nالوسوم: $tags';
  }

  @override
  String get instagram => 'إنستغرام';

  @override
  String get facebook => 'فيسبوك';

  @override
  String get tiktok => 'تيك توك';

  @override
  String get newSketch => 'رسمة جديدة';

  @override
  String get searchSketches => 'البحث في الرسومات والمجلدات...';

  @override
  String get noResultsFound => 'لم يتم العثور على نتائج';

  @override
  String get noItems => 'لا توجد عناصر';

  @override
  String get noDrawingsYet => 'لا توجد رسومات بعد';

  @override
  String get canvasIntro => 'أطلق العنان لإبداعك على اللوحة!';

  @override
  String get newCanvas => 'لوحة جديدة';

  @override
  String get rename => 'إعادة تسمية';

  @override
  String get deleteFolder => 'حذف المجلد';

  @override
  String get deleteSketchesQuestion => 'حذف الرسومات؟';

  @override
  String get deleteFolderConfirmation =>
      'سيتم حذف جميع الرسومات في هذا المجلد نهائياً.';

  @override
  String get renameFolder => 'إعادة تسمية المجلد';

  @override
  String get chooseColor => 'اختر لوناً';

  @override
  String get deleteFolderQuestion => 'حذف المجلد؟';

  @override
  String get searchClips => 'البحث في القصاصات...';

  @override
  String get clipboardEmpty => 'الحافظة فارغة';

  @override
  String get addItem => 'إضافة عنصر';

  @override
  String get clipColor => 'لون القصاصة';

  @override
  String get newClip => 'قصاصة جديدة';

  @override
  String get editClip => 'تعديل القصاصة';

  @override
  String get restoreClipLater => 'يمكنك استعادة هذه القصاصة لاحقاً.';

  @override
  String get upcomingEvents => 'الأحداث القادمة';

  @override
  String get dataDistribution => 'توزيع البيانات';

  @override
  String get taskProgress => 'تقدم المهمة';

  @override
  String get quickStats => 'إحصائيات سريعة';

  @override
  String get taskCompletion => 'إكمال المهمة';

  @override
  String get noItemsForDate => 'لا توجد عناصر لهذا التاريخ';

  @override
  String get enjoyFreeTime => 'استمتع بوقت فراغك!';

  @override
  String get searchThisDay => 'البحث في هذا اليوم...';

  @override
  String get finance => 'المالية';

  @override
  String get permanentlyDelete => 'حذف نهائي؟';

  @override
  String deleteSelectionConfirmation(int foldersCount, int sketchesCount) {
    return 'سيؤدي هذا إلى حذف $foldersCount مجلدات (ورسماتها) و $sketchesCount رسومات أخرى نهائياً.\n\nلا يمكن التراجع عن هذا الإجراء.';
  }

  @override
  String get deleteForever => 'حذف للأبد';

  @override
  String selectedCount(int count) {
    return '$count محدد';
  }

  @override
  String canvasStats(int notes, int folders) {
    return '$notes رسومات • $folders مجلدات';
  }

  @override
  String get sortItems => 'فرز العناصر';

  @override
  String get sortNameAZ => 'الاسم (أ-ي)';

  @override
  String get sortNameZA => 'الاسم (ي-أ)';

  @override
  String get createFolder => 'إنشاء مجلد';

  @override
  String get folderNameHint => 'اسم المجلد...';

  @override
  String deleteSketchesConfirmation(int count) {
    return 'حذف $count رسومات؟ لا يمكن التراجع عن هذا الإجراء.';
  }

  @override
  String get noSketchesFound => 'لم يتم العثور على رسومات';

  @override
  String get noSketchesFoundSub => 'حاول تعديل بحثك أو إنشاء رسمة جديدة.';

  @override
  String searchInFolder(String folder) {
    return 'بحث في $folder...';
  }

  @override
  String sketchesCount(int count) {
    return '$count رسومات';
  }

  @override
  String get sortSketches => 'فرز الرسومات';

  @override
  String get calendarScreenTitle => 'التقويم';

  @override
  String get dailyActivity => 'النشاط اليومي';

  @override
  String get deleteItemQuestion => 'حذف العنصر؟';

  @override
  String get deleteItemConfirmation =>
      'سيؤدي هذا إلى نقل العنصر إلى سلة المحذوفات.';

  @override
  String get moveToBinItem => 'نقل إلى السلة؟';

  @override
  String get moveToBinConfirmation => 'يمكنك استعادته لاحقاً.';

  @override
  String selectedItems(int count) {
    return '$count محدد';
  }

  @override
  String get recentClips => 'القصاصات الأخيرة';

  @override
  String get copied => 'تم النسخ!';

  @override
  String get copiedPlainText => 'تم نسخ النص المجرد';

  @override
  String get clipTheme => 'مظهر القصاصة';

  @override
  String get justNow => 'الآن';

  @override
  String minutesAgo(Object count) {
    return 'منذ $count د';
  }

  @override
  String hoursAgo(Object count) {
    return 'منذ $count س';
  }

  @override
  String daysAgo(Object count) {
    return 'منذ $count ي';
  }

  @override
  String get noTasksFound => 'لم يتم العثور على مهام.';

  @override
  String get searchTasks => 'بحث في المهام...';

  @override
  String get taskReminder => 'تذكير بالمهمة';

  @override
  String get untitledNote => 'ملاحظة بدون عنوان';

  @override
  String get dailyEntry => 'مدخل يومي';

  @override
  String get clipboardHistory => 'سجل الحافظة';

  @override
  String get deletePermanentlyContent => 'هذا الإجراء لا يمكن التراجع عنه.';

  @override
  String get emptyRecycleBinTitle => 'إفراغ سلة المحذوفات؟';

  @override
  String emptyRecycleBinContent(Object count) {
    return 'سيتم حذف جميع العناصر الـ $count نهائياً.';
  }

  @override
  String get emptyBin => 'إفراغ السلة';

  @override
  String get recycleBinEmpty => 'سلة المحذوفات فارغة';

  @override
  String get deletedItemsAppearHere => 'العناصر المحذوفة ستظهر هنا.';

  @override
  String get empty => 'فارغ';

  @override
  String get recent => 'الأخيرة';

  @override
  String categoryLabel(Object category) {
    return 'الفئة: $category';
  }

  @override
  String get general => 'عام';

  @override
  String get saveTransactionQuestion => 'هل تريد حفظ هذه المعاملة؟';

  @override
  String get fillTitleAmount => 'يرجى ملء العنوان والمبلغ';

  @override
  String get invalidAmount => 'تنسيق المبلغ غير صالح';

  @override
  String get moveTransactionToBinTitle => 'نقل المعاملة إلى سلة المحذوفات؟';

  @override
  String get restoreTransactionLater =>
      'يمكنك استعادة هذه المعاملة لاحقاً من الإعدادات.';

  @override
  String get newTransaction => 'معاملة جديدة';

  @override
  String get whatIsThisFor => 'فيما هذا؟';

  @override
  String get description => 'الوصف';

  @override
  String get daily => 'يومياً';

  @override
  String get weekly => 'أسبوعياً';

  @override
  String get monthly => 'شهرياً';

  @override
  String get yearly => 'سنوياً';

  @override
  String get totalIncome => 'إجمالي الدخل';

  @override
  String get totalExpense => 'إجمالي النفقات';

  @override
  String get analysis => 'التحليل';

  @override
  String get transactions => 'المعاملات';

  @override
  String get noExpensesFound => 'لم يتم العثور على نفقات لهذه الفترة.';

  @override
  String get netBalance => 'صافي الرصيد';

  @override
  String get topCategories => 'أبرز الفئات';

  @override
  String get spendingTrend => 'اتجاه الإنفاق';

  @override
  String get insights => 'رؤى';

  @override
  String get noExpensesRecorded => 'لم يتم تسجيل أي نفقات';

  @override
  String get trackSpendingHabits => 'تتبع عادات الإنفاق الخاصة بك بسهولة.';

  @override
  String get addExpense => 'إضافة نفقة';

  @override
  String get noDataForPeriod => 'لا توجد بيانات لهذه الفترة';

  @override
  String get budget => 'الميزانية';

  @override
  String get spent => 'تم صرفه';

  @override
  String get limit => 'الحد';

  @override
  String get overBudget => 'تجاوز الميزانية!';

  @override
  String remainingBudget(Object percent) {
    return 'متبقي $percent%';
  }

  @override
  String get savingsRate => 'معدل الادخار';

  @override
  String get healthScore => 'درجة الصحة المالية';

  @override
  String get healthScoreExplanation =>
      'هذه الدرجة تعتمد على معدل ادخارك.\n\n• ادخار > 50% = ممتاز (100)\n• ادخار 0% = متوسط (50)\n• الإنفاق > الدخل = ضعيف (<50)';

  @override
  String get ok => 'موافق';

  @override
  String get bulkImport => 'استيراد بالجملة';
}

/// The translations for Arabic, as used in the United Arab Emirates (`ar_AE`).
class AppLocalizationsArAe extends AppLocalizationsAr {
  AppLocalizationsArAe() : super('ar_AE');

  @override
  String get settings => 'إعدادات';

  @override
  String get language => 'لغة';

  @override
  String get systemDefault => 'النظام الافتراضي';

  @override
  String get notes => 'ملحوظات';

  @override
  String get todos => 'المهام';

  @override
  String get expenses => 'نفقات';

  @override
  String get journal => 'مجلة';

  @override
  String get calendar => 'تقويم';

  @override
  String get clipboard => 'الحافظة';

  @override
  String get canvas => 'قماش';

  @override
  String get save => 'حفظ';

  @override
  String get create => 'إنشاء';

  @override
  String get cancel => 'إلغاء';

  @override
  String get delete => 'حذف';

  @override
  String get edit => 'تعديل';

  @override
  String get share => 'مشاركة';

  @override
  String get copy => 'نسخ';

  @override
  String get unsavedChanges => 'تغييرات غير محفوظة';

  @override
  String get confirmDelete => 'تأكيد الحذف';

  @override
  String get discard => 'تجاهل';

  @override
  String get createPost => 'إنشاء منشور';

  @override
  String get post => 'منشور';

  @override
  String get postingTo => 'النشر في';

  @override
  String get whatsOnYourMind => 'ماذا يدور في ذهنك؟';

  @override
  String get pickImages => 'اختر صورًا';

  @override
  String get pickVideo => 'اختر فيديو';

  @override
  String get camera => 'كاميرا';

  @override
  String get gallery => 'معرض الصور';

  @override
  String get search => 'بحث';

  @override
  String get pleaseEnterTask => 'يرجى إدخال مهمة';

  @override
  String get deleteTask => 'حذف المهمة';

  @override
  String get selectItems => 'حدد العناصر';

  @override
  String get deleteAll => 'حذف الكل';

  @override
  String error(Object error) {
    return 'خطأ: $error';
  }

  @override
  String get orderingOnlyAvailableInAllPosts =>
      'الترتيب متاح فقط في \"جميع المنشورات\"';

  @override
  String get deletePost => 'حذف المنشور';

  @override
  String get postDeleted => 'تم حذف المنشور';

  @override
  String get premiumFeatures => 'ميزات بريميوم';

  @override
  String get manageCoinsAdsPremium =>
      'إدارة العملات والإعلانات وحالة البريميوم';

  @override
  String get themeMode => 'وضع المظهر';

  @override
  String get accentColor => 'لون التمييز';

  @override
  String get backgroundDesign => 'تصميم الخلفية';

  @override
  String get pushNotifications => 'إشعارات الدفع';

  @override
  String get recycleBin => 'سلة المحذوفات';

  @override
  String get exportData => 'تصدير البيانات';

  @override
  String get importData => 'استيراد البيانات';

  @override
  String get rateApp => 'تقييم التطبيق';

  @override
  String get sendFeedback => 'إرسال تعليقات';

  @override
  String get privacyPolicy => 'سياسة الخصوصية';

  @override
  String get version => 'الإصدار';

  @override
  String get buildNumber => 'رقم البناء';

  @override
  String get system => 'النظام';

  @override
  String get light => 'فاتح';

  @override
  String get dark => 'داكن';

  @override
  String get itemRestored => 'تمت استعادة العنصر';

  @override
  String get recycleBinCleared => 'تم إفراغ سلة المحذوفات بنجاح';

  @override
  String get allPostsDeleted => 'تم حذف جميع المنشورات';

  @override
  String get newPost => 'منشور جديد';

  @override
  String get textCopiedToClipboardFacebook =>
      'تم نسخ النص إلى الحافظة (سياسة فيسبوك)';

  @override
  String get tiktokSharingRequiresVideoImage =>
      'تتطلب مشاركة TikTok فيديو/صورة';

  @override
  String errorSharing(Object error) {
    return 'خطأ في المشاركة: $error';
  }

  @override
  String shareToStory(Object platform) {
    return 'مشاركة في قصة $platform';
  }

  @override
  String shareToFeed(Object platform) {
    return 'مشاركة في موجز $platform';
  }

  @override
  String get unlockPermanently => 'فتح بشكل دائم';

  @override
  String get notEnoughCoins => 'لا توجد عملات كافية!';

  @override
  String youEarnedCoins(Object amount) {
    return 'لقد ربحت $amount من العملات!';
  }

  @override
  String get contentCopied => 'تم نسخ المحتوى';

  @override
  String get selectDateTime => 'حدد التاريخ والوقت';

  @override
  String get areYouSureYouWantToDeleteThisPost =>
      'هل أنت متأكد أنك تريد حذف هذا المنشور؟';

  @override
  String get socialPosts => 'منشورات اجتماعية';

  @override
  String get watchAdToEarnCoins => 'شاهد إعلانًا لربح العملات';

  @override
  String get premiumUnlocked => 'تم فتح البريميوم';

  @override
  String get removeAds => 'إزالة الإعلانات';

  @override
  String get unlimitedCloudStorage => 'تخزين سحابي غير محدود';

  @override
  String get deleteNote => 'حذف الملاحظة';

  @override
  String get shareNote => 'مشاركة الملاحظة';

  @override
  String get editNote => 'تعديل الملاحظة';

  @override
  String get searchNotes => 'البحث في الملاحظات...';

  @override
  String get noNotesFound => 'لم يتم العثور على ملاحظات';

  @override
  String get captureThoughts => 'سجل أفكارك فورا.';

  @override
  String get createNote => 'إنشاء ملاحظة';

  @override
  String get customOrder => 'ترتيب مخصص';

  @override
  String get newestFirst => 'الأحدث أولاً';

  @override
  String get oldestFirst => 'الأقدم أولاً';

  @override
  String get titleAZ => 'العنوان: أ-ي';

  @override
  String get titleZA => 'العنوان: ي-أ';

  @override
  String get deleteAllQuestion => 'حذف الكل؟';

  @override
  String get moveToRecycleBin => 'نقل جميع الملاحظات إلى سلة المحذوفات؟';

  @override
  String get moveToBinQuestion => 'نقل إلى السلة؟';

  @override
  String get restoreNoteLater => 'يمكنك استعادة هذه الملاحظة لاحقًا.';

  @override
  String get move => 'نقل';

  @override
  String get myThoughts => 'أفكاري';

  @override
  String get selected => 'محدد';

  @override
  String get noContent => 'لا يوجد محتوى';

  @override
  String get untitled => 'بدون عنوان';

  @override
  String get chooseWallpapers => 'اختر من بين أكثر من 10 خلفيات ديناميكية';

  @override
  String get backupData => 'نسخ احتياطي للبيانات';

  @override
  String get saveJsonFile => 'هل تريد حفظ ملف JSON يحتوي على جميع بياناتك؟';

  @override
  String get exportNow => 'تصدير الآن';

  @override
  String get importDataTitle => 'استيراد البيانات';

  @override
  String get mergeBackupFile =>
      'هل تريد دمج ملف النسخ الاحتياطي مع العناصر الحالية؟';

  @override
  String get selectFile => 'حدد ملفاً';

  @override
  String get backupSaved => 'تم حفظ النسخة الاحتياطية بنجاح!';

  @override
  String get exportFailed => 'فشل التصدير.';

  @override
  String importSuccess(Object count) {
    return 'تمت استعادة $count من العناصر بنجاح!';
  }

  @override
  String get importFailed => 'فشل الاستيراد.';

  @override
  String widgetAdded(String widget) {
    return 'تمت إضافة الأداة $widget إلى الشاشة الرئيسية!';
  }

  @override
  String get widgetRequestSent =>
      'تم إرسال طلب الأداة. يرجى التحقق من الشاشة الرئيسية.';

  @override
  String get widgetAddFailed => 'فشل إضافة الأداة';

  @override
  String get autoSaveEnabled => 'تم تفعيل الحفظ التلقائي.';

  @override
  String get autoSaveDisabled => 'تم تعطيل الحفظ التلقائي.';

  @override
  String get homeScreenWidgets => 'أدوات الشاشة الرئيسية';

  @override
  String get notificationsTitle => 'الإشعارات';

  @override
  String get dataBackup => 'البيانات والنسخ الاحتياطي';

  @override
  String get feedbackSupport => 'التعليقات والدعم';

  @override
  String get creditsTitle => 'الاعتمادات';

  @override
  String get privacyMaintenance => 'الخصوصية والصيانة';

  @override
  String get aboutTitle => 'حول';

  @override
  String get premium => 'بريميوم';

  @override
  String get appearanceTitle => 'المظهر';

  @override
  String get clipboardTitle => 'الحافظة';

  @override
  String get settingsSubtitle => 'تخصيص تجربتك';

  @override
  String get welcomeTitle => 'مرحبًا بك في CopyClip';

  @override
  String get welcomeDescription =>
      'رفيقك النهائي للإنتاجية. دعنا نجهزك بأدوات قوية لإدارة يومك.';

  @override
  String get onboardingNotesTitle => 'ملاحظات ذكية';

  @override
  String get onboardingNotesDesc =>
      'التقط الأفكار فورًا بتنسيق نص غني. نظم أفكارك ولا تفقد أي فكرة رائعة مرة أخرى.';

  @override
  String get onboardingTodosTitle => 'إدارة المهام';

  @override
  String get onboardingTodosDesc =>
      'ابق مطلعاً على أمورك. أنشئ قوائم مهام، وحدد الأولويات، وحقق أهدافك خطوة بخطوة.';

  @override
  String get onboardingExpensesTitle => 'تتبع النفقات';

  @override
  String get onboardingExpensesDesc =>
      'تحكم في أموالك. تتبع الدخل والنفقات بسهولة لفهم عادات الإنفاق الخاصة بك.';

  @override
  String get onboardingJournalTitle => 'يوميات شخصية';

  @override
  String get onboardingJournalDesc =>
      'تأمل في يومك. مساحة خاصة لتدوين ذكرياتك ومشاعرك وتجاربك اليومية.';

  @override
  String get onboardingCalendarTitle => 'التقويم والأحداث';

  @override
  String get onboardingCalendarDesc =>
      'لا تفوت أي لحظة. نظم جدولك وتابع الأحداث الهامة القادمة.';

  @override
  String get onboardingClipboardTitle => 'مدير الحافظة';

  @override
  String get onboardingClipboardDesc =>
      'انسخ مرة واحدة، والصق في أي مكان. الوصول إلى سجل الحافظة لاستعادة النصوص التي نسختها سابقاً.';

  @override
  String get onboardingCanvasTitle => 'لوحة إبداعية';

  @override
  String get onboardingCanvasDesc =>
      'أطلق العنان لإبداعك. ارسم وخطط وصور أفكارك على لوحة رقمية حرة.';

  @override
  String get featuresNotesDesc => 'إنشاء وإدارة الملاحظات الخاصة بك';

  @override
  String get featuresTodosDesc => 'تتبع المهام الخاصة بك';

  @override
  String get featuresExpensesDesc => 'مراقبة النفقات الخاصة بك';

  @override
  String get featuresJournalDesc => 'اكتتب أفكارك';

  @override
  String get featuresCalendarDesc => 'نظم جدولك الزمني';

  @override
  String get featuresClipboardDesc => 'الوصول إلى سجل الحافظة الخاص بك';

  @override
  String get featuresCanvasDesc => 'ارسم وخطط بحرية';

  @override
  String get featuresSocialPost => 'منشور اجتماعي';

  @override
  String get featuresSocialPostDesc =>
      'إنشاء محتوى جذاب لوسائل التواصل الاجتماعي';

  @override
  String get chooseYourAura => 'اختر هالتك';

  @override
  String get expressYourselfTheme => 'عبر عن نفسك بلون مظهر جديد!';

  @override
  String get level => 'المستوى';

  @override
  String get xpToNextLevel => 'XP للمستوى التالي';

  @override
  String get checkUpcomingEvents => 'تحقق من الأحداث القادمة';

  @override
  String get startNewSketch => 'بدأ رسمة جديدة';

  @override
  String get noTransactionsMonth => 'لا توجد معاملات هذا الشهر';

  @override
  String transactionsThisMonth(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count معاملات هذا الشهر',
      two: 'معاملتان هذا الشهر',
      one: 'معاملة واحدة هذا الشهر',
      zero: 'لا توجد معاملات هذا الشهر',
    );
    return '$_temp0';
  }

  @override
  String get autoSaveClipboard => 'حفظ تلقائي للحافظة';

  @override
  String get autoSaveClipboardDesc => 'حفظ العناصر المنسوخة تلقائياً';

  @override
  String get permissionDeniedSettings =>
      'تم رفض الإذن بشكل دائم. يرجى تفعيله من الإعدادات.';

  @override
  String get notificationsEnabled => 'تم تفعيل الإشعارات!';

  @override
  String get redirectingToSettings =>
      'جارٍ التوجيه إلى الإعدادات لتعطيل الإشعارات...';

  @override
  String get premiumAccess => 'وصول بريميوم';

  @override
  String get premiumActiveUntil => 'بريميوم نشط حتى';

  @override
  String get unlockAllFeatures => 'فتح جميع الميزات';

  @override
  String get buyPremium => 'شراء بريميوم (7 أيام)';

  @override
  String costCoins(Object cost) {
    return 'التكلفة: $cost عملات';
  }

  @override
  String get premiumActivated => 'تم تفعيل البريميوم لمدة 7 أيام!';

  @override
  String get premiumActive => 'البريميوم نشط';

  @override
  String get expires => 'تنتهي الصلاحية:';

  @override
  String get temporaryAccess => 'وصول مؤقت';

  @override
  String get journalExpression => 'يوميات وتعبير';

  @override
  String get artisticDesigns => 'تصاميم فنية';

  @override
  String get artisticDesignsDesc =>
      'فتح أكثر من 10 مظاهر فريدة لبطاقات اليوميات';

  @override
  String get premiumLayouts => 'تخطيطات بريميوم';

  @override
  String get premiumLayoutsDesc => 'طرق حصرية لعرض ذكرياتك';

  @override
  String get calendarTools => 'تقويم وأدوات';

  @override
  String get fullCalendar => 'تقويم كامل';

  @override
  String get fullCalendarDesc => 'نظام متكامل لإدارة الأحداث';

  @override
  String get clipboardAutoSaveDesc => 'التقاط سجل الحافظة في الخلفية';

  @override
  String get proWidgets => 'أدوات ذكية للمحترفين';

  @override
  String get proWidgetsDesc => 'جميع الميزات متوفرة على شاشتك الرئيسية';

  @override
  String get dataExport => 'البيانات والتصدير';

  @override
  String get advancedBackup => 'نسخ احتياطي متقدم';

  @override
  String get advancedBackupDesc => 'استيراد/تصدير آمن لجميع البيانات';

  @override
  String get pdfExport => 'تصدير إلى PDF';

  @override
  String get pdfExportDesc => 'تصدير الملاحظات واليوميات إلى PDF';

  @override
  String get printReady => 'جاهز للطباعة';

  @override
  String get printReadyDesc => 'دعم الطباعة المباشرة';

  @override
  String get richTextEditor => 'محرر نص غني';

  @override
  String get advancedSearch => 'بحث متقدم';

  @override
  String get advancedSearchDesc => 'البحث والاستبدال داخل النص';

  @override
  String get richMedia => 'وسائط غنية';

  @override
  String get richMediaDesc => 'إدراج صور وفيديوهات وروابط';

  @override
  String get editorStyling => 'تنسيق المحرر';

  @override
  String get editorStylingDesc => 'نص مخصص وخلفيات للمحرر';

  @override
  String get balance => 'الرصيد';

  @override
  String get loadingAd => 'جارٍ تحميل الإعلان...';

  @override
  String watchAd(Object amount) {
    return 'مشاهدة إعلان (+$amount)';
  }

  @override
  String get loadAd => 'تحميل إعلان';

  @override
  String get backupDataDesc => 'حفظ ملف JSON لبياناتك';

  @override
  String get importDataDesc => 'دمج ملف نسخة احتياطية في CopyClip';

  @override
  String get notificationPermissionDenied => 'تم رفض إذن الإشعارات.';

  @override
  String get typeNewTask => 'اكتب مهمة جديدة...';

  @override
  String get addTask => 'إضافة مهمة';

  @override
  String get completed => 'مكتمل';

  @override
  String get greatJob => 'عمل رائع!';

  @override
  String youEarnedXPNextTask(Object amount, Object date) {
    return 'لقد ربحت $amount XP! المهمة التالية: $date';
  }

  @override
  String taskCompletedXP(Object amount) {
    return 'تمت المهمة! +$amount XP';
  }

  @override
  String get moveTasksToRecycleBin =>
      'نقل جميع المهام النشطة إلى سلة المحذوفات؟';

  @override
  String get deleteAllPosts => 'حذف جميع المنشورات';

  @override
  String get deleteAllPostsConfirmation =>
      'هل أنت متأكد أنك تريد حذف جميع المنشورات الاجتماعية؟ لا يمكن التراجع عن هذا الإجراء.';

  @override
  String get allPosts => 'جميع المنشورات';

  @override
  String get favorites => 'المفضلة';

  @override
  String get drafts => 'المسودات';

  @override
  String get noFavoritesYet => 'لا توجد مفضلات بعد';

  @override
  String get noDraftsYet => 'لا توجد مسودات بعد';

  @override
  String get startSocialJourney => 'ابدأ رحلتك الاجتماعية!';

  @override
  String get draft => 'مسودة';

  @override
  String attachmentCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count مرفقات',
      two: 'مرفقان',
      one: 'مرفق واحد',
      zero: 'لا توجد مرفقات',
    );
    return '$_temp0';
  }

  @override
  String get pleaseAddContent => 'يرجى إضافة بعض المحتوى أو الوسائط للمشاركة';

  @override
  String fileNotFoundError(Object path) {
    return 'خطأ: لم يتم العثور على الملف في $path';
  }

  @override
  String get checkFacebookApp => 'تحقق من تطبيق فيسبوك';

  @override
  String get systemShare => 'مشاركة النظام';

  @override
  String get socialPost => 'منشور اجتماعي';

  @override
  String get favorite => 'مفضل';

  @override
  String get saveDraft => 'حفظ المسودة';

  @override
  String get entryCopied => 'تم نسخ المدخل';

  @override
  String get moveEntriesToRecycleBin =>
      'نقل جميع المدخلات النشطة إلى سلة المحذوفات؟';

  @override
  String get startWritingStory => 'ابدأ بكتابة قصتك';

  @override
  String get recordMemories => 'سجل ذكرياتك ومشاعرك اليومية.';

  @override
  String get writeJournal => 'اكتب يومياتك';

  @override
  String get myMemories => 'ذكرياتي';

  @override
  String get sortJournal => 'فرز اليوميات';

  @override
  String get byMood => 'حسب المزاج';

  @override
  String get searchMemories => 'بحث في الذكريات...';

  @override
  String get selectAll => 'تحديد الكل';

  @override
  String get deleteSelected => 'حذف المحدد';

  @override
  String get taskCompletedExclamation => 'تمت المهمة!';

  @override
  String get taskUncompletedExclamation => 'مهمة غير مكتملة';

  @override
  String get clipboardUpdatedExclamation => 'تم تحديث الحافظة!';

  @override
  String clipboardSavedContent(Object content) {
    return 'تم حفظ في الحافظة: $content';
  }

  @override
  String get overview => 'نظرة عامة';

  @override
  String get colorAurora => 'أورورا';

  @override
  String get colorCosmic => 'كوني';

  @override
  String get colorNebula => 'سديم';

  @override
  String get colorStarlight => 'ضوء النجوم';

  @override
  String get colorSolar => 'شمسي';

  @override
  String get colorNova => 'نوفا';

  @override
  String get loadingStepLoading => 'جارٍ التحميل...';

  @override
  String get loadingStepDatabase => 'إعداد قاعدة البيانات...';

  @override
  String get loadingStepSystem => 'تكوين النظام...';

  @override
  String get loadingStepReady => 'جاهز';

  @override
  String get productivityCompanion => 'رفيقك للإنتاجية';

  @override
  String get done => 'تم';

  @override
  String get newNote => 'ملاحظة جديدة';

  @override
  String get changeColor => 'تغيير اللون';

  @override
  String get copyContent => 'نسخ المحتوى';

  @override
  String get titleOptional => 'العنوان (اختياري)';

  @override
  String get exportAsPdf => 'تصدير كـ PDF';

  @override
  String get taskDueNow => 'موعد المهمة الآن';

  @override
  String get moveTaskToBinTitle => 'نقل المهمة إلى سلة المحذوفات؟';

  @override
  String get restoreTaskLater =>
      'يمكنك استعادة هذه المهمة لاحقًا من الإعدادات.';

  @override
  String get newTask => 'مهمة جديدة';

  @override
  String get editTask => 'تعديل المهمة';

  @override
  String get undo => 'تراجع';

  @override
  String get redo => 'إعادة';

  @override
  String get category => 'الفئة';

  @override
  String get categoryHint => 'مثال: العمل، النادي';

  @override
  String get whatNeedsToBeDone => 'ما الذي يجب القيام به؟';

  @override
  String get enterTaskDetails => 'أدخل تفاصيل المهمة...';

  @override
  String get setDueDate => 'تحديد موعد الاستحقاق';

  @override
  String get dueDate => 'موعد الاستحقاق';

  @override
  String get expenseTitle => 'النفقات';

  @override
  String searchInCurrency(String currency) {
    return 'بحث في $currency...';
  }

  @override
  String get sortAndFilter => 'فرز وتصفية';

  @override
  String get sortBy => 'فرز حسب';

  @override
  String get highestAmount => 'أعلى مبلغ';

  @override
  String get lowestAmount => 'أقل مبلغ';

  @override
  String get moreFilters => 'مزيد من الفلاتر...';

  @override
  String get filterExpenses => 'تصفية النفقات';

  @override
  String get transactionType => 'نوع المعاملة';

  @override
  String get categories => 'الفئات';

  @override
  String get all => 'الكل';

  @override
  String get income => 'الدخل';

  @override
  String get expense => 'المصروفات';

  @override
  String get reset => 'إعادة تعيين';

  @override
  String get apply => 'تطبيق';

  @override
  String newExpense(String currency) {
    return 'جديد $currency';
  }

  @override
  String errorLoadingData(String error) {
    return 'حدث خطأ أثناء تحميل البيانات.\n\n$error';
  }

  @override
  String get dailyQuote1 => 'أفضل طريقة للتنبؤ بالمستقبل هي أن تصنعه.';

  @override
  String get dailyQuote2 => 'الغنى ليس في كثرة العرض، ولكن الغنى غنى النفس.';

  @override
  String get dailyQuote3 => 'الوقت هو العملة الأغلى.';

  @override
  String get dailyQuote4 => 'النجاح ليس نهائياً، والفشل ليس قاتلاً.';

  @override
  String get dailyQuote5 => 'ركز على الحل، وليس المشكلة.';

  @override
  String get dailyQuote6 => 'شبكة علاقاتك هي ثروتك الحقيقية.';

  @override
  String get moodHappy => 'سعيد';

  @override
  String get moodExcited => 'متحمس';

  @override
  String get moodNeutral => 'محايد';

  @override
  String get moodSad => 'حزين';

  @override
  String get moodStressed => 'متوتر';

  @override
  String exportDate(String date) {
    return '📅 $date';
  }

  @override
  String exportMood(String emoji, String mood) {
    return 'المزاج: $emoji $mood';
  }

  @override
  String exportTitle(String title) {
    return 'العنوان: $title';
  }

  @override
  String exportTags(String tags) {
    return '\nالوسوم: $tags';
  }

  @override
  String get instagram => 'إنستغرام';

  @override
  String get facebook => 'فيسبوك';

  @override
  String get tiktok => 'تيك توك';

  @override
  String get newSketch => 'رسمة جديدة';

  @override
  String get searchSketches => 'البحث في الرسومات والمجلدات...';

  @override
  String get noResultsFound => 'لم يتم العثور على نتائج';

  @override
  String get noItems => 'لا توجد عناصر';

  @override
  String get noDrawingsYet => 'لا توجد رسومات بعد';

  @override
  String get canvasIntro => 'أطلق العنان لإبداعك على اللوحة!';

  @override
  String get newCanvas => 'لوحة جديدة';

  @override
  String get rename => 'إعادة تسمية';

  @override
  String get deleteFolder => 'حذف المجلد';

  @override
  String get deleteSketchesQuestion => 'حذف الرسومات؟';

  @override
  String get deleteFolderConfirmation =>
      'سيتم حذف جميع الرسومات في هذا المجلد نهائياً.';

  @override
  String get renameFolder => 'إعادة تسمية المجلد';

  @override
  String get chooseColor => 'اختر لوناً';

  @override
  String get deleteFolderQuestion => 'حذف المجلد؟';

  @override
  String get searchClips => 'البحث في القصاصات...';

  @override
  String get clipboardEmpty => 'الحافظة فارغة';

  @override
  String get addItem => 'إضافة عنصر';

  @override
  String get clipColor => 'لون القصاصة';

  @override
  String get newClip => 'قصاصة جديدة';

  @override
  String get editClip => 'تعديل القصاصة';

  @override
  String get restoreClipLater => 'يمكنك استعادة هذه القصاصة لاحقاً.';

  @override
  String get upcomingEvents => 'الأحداث القادمة';

  @override
  String get dataDistribution => 'توزيع البيانات';

  @override
  String get taskProgress => 'تقدم المهمة';

  @override
  String get quickStats => 'إحصائيات سريعة';

  @override
  String get taskCompletion => 'إكمال المهمة';

  @override
  String get noItemsForDate => 'لا توجد عناصر لهذا التاريخ';

  @override
  String get enjoyFreeTime => 'استمتع بوقت فراغك!';

  @override
  String get searchThisDay => 'البحث في هذا اليوم...';

  @override
  String get finance => 'المالية';

  @override
  String get permanentlyDelete => 'حذف نهائي؟';

  @override
  String deleteSelectionConfirmation(int foldersCount, int sketchesCount) {
    return 'سيؤدي هذا إلى حذف $foldersCount مجلدات (ورسماتها) و $sketchesCount رسومات أخرى نهائياً.\n\nلا يمكن التراجع عن هذا الإجراء.';
  }

  @override
  String get deleteForever => 'حذف للأبد';

  @override
  String selectedCount(int count) {
    return '$count محدد';
  }

  @override
  String canvasStats(int notes, int folders) {
    return '$notes رسومات • $folders مجلدات';
  }

  @override
  String get sortItems => 'فرز العناصر';

  @override
  String get sortNameAZ => 'الاسم (أ-ي)';

  @override
  String get sortNameZA => 'الاسم (ي-أ)';

  @override
  String get createFolder => 'إنشاء مجلد';

  @override
  String get folderNameHint => 'اسم المجلد...';

  @override
  String deleteSketchesConfirmation(int count) {
    return 'حذف $count رسومات؟ لا يمكن التراجع عن هذا الإجراء.';
  }

  @override
  String get noSketchesFound => 'لم يتم العثور على رسومات';

  @override
  String get noSketchesFoundSub => 'حاول تعديل بحثك أو إنشاء رسمة جديدة.';

  @override
  String searchInFolder(String folder) {
    return 'بحث في $folder...';
  }

  @override
  String sketchesCount(int count) {
    return '$count رسومات';
  }

  @override
  String get sortSketches => 'فرز الرسومات';

  @override
  String get calendarScreenTitle => 'التقويم';

  @override
  String get dailyActivity => 'النشاط اليومي';

  @override
  String get deleteItemQuestion => 'حذف العنصر؟';

  @override
  String get deleteItemConfirmation =>
      'سيؤدي هذا إلى نقل العنصر إلى سلة المحذوفات.';

  @override
  String get moveToBinItem => 'نقل إلى السلة؟';

  @override
  String get moveToBinConfirmation => 'يمكنك استعادته لاحقاً.';

  @override
  String selectedItems(int count) {
    return '$count محدد';
  }

  @override
  String get recentClips => 'القصاصات الأخيرة';

  @override
  String get copied => 'تم النسخ!';

  @override
  String get copiedPlainText => 'تم نسخ النص المجرد';

  @override
  String get clipTheme => 'مظهر القصاصة';

  @override
  String get justNow => 'الآن';

  @override
  String minutesAgo(Object count) {
    return 'منذ $count د';
  }

  @override
  String hoursAgo(Object count) {
    return 'منذ $count س';
  }

  @override
  String daysAgo(Object count) {
    return 'منذ $count ي';
  }

  @override
  String get noTasksFound => 'لم يتم العثور على مهام.';

  @override
  String get searchTasks => 'بحث في المهام...';

  @override
  String get taskReminder => 'تذكير بالمهمة';

  @override
  String get untitledNote => 'ملاحظة بدون عنوان';

  @override
  String get dailyEntry => 'مدخل يومي';

  @override
  String get clipboardHistory => 'سجل الحافظة';

  @override
  String get deletePermanentlyContent => 'هذا الإجراء لا يمكن التراجع عنه.';

  @override
  String get emptyRecycleBinTitle => 'إفراغ سلة المحذوفات؟';

  @override
  String emptyRecycleBinContent(Object count) {
    return 'سيتم حذف جميع العناصر الـ $count نهائياً.';
  }

  @override
  String get emptyBin => 'إفراغ السلة';

  @override
  String get recycleBinEmpty => 'سلة المحذوفات فارغة';

  @override
  String get deletedItemsAppearHere => 'العناصر المحذوفة ستظهر هنا.';

  @override
  String get empty => 'فارغ';

  @override
  String get recent => 'الأخيرة';

  @override
  String categoryLabel(Object category) {
    return 'الفئة: $category';
  }

  @override
  String get general => 'عام';

  @override
  String get saveTransactionQuestion => 'هل تريد حفظ هذه المعاملة؟';

  @override
  String get fillTitleAmount => 'يرجى ملء العنوان والمبلغ';

  @override
  String get invalidAmount => 'تنسيق المبلغ غير صالح';

  @override
  String get moveTransactionToBinTitle => 'نقل المعاملة إلى سلة المحذوفات؟';

  @override
  String get restoreTransactionLater =>
      'يمكنك استعادة هذه المعاملة لاحقاً من الإعدادات.';

  @override
  String get newTransaction => 'معاملة جديدة';

  @override
  String get whatIsThisFor => 'فيما هذا؟';

  @override
  String get description => 'الوصف';

  @override
  String get daily => 'يومياً';

  @override
  String get weekly => 'أسبوعياً';

  @override
  String get monthly => 'شهرياً';

  @override
  String get yearly => 'سنوياً';

  @override
  String get totalIncome => 'إجمالي الدخل';

  @override
  String get totalExpense => 'إجمالي النفقات';

  @override
  String get analysis => 'التحليل';

  @override
  String get transactions => 'المعاملات';

  @override
  String get noExpensesFound => 'لم يتم العثور على نفقات لهذه الفترة.';

  @override
  String get netBalance => 'صافي الرصيد';

  @override
  String get topCategories => 'أبرز الفئات';

  @override
  String get spendingTrend => 'اتجاه الإنفاق';

  @override
  String get insights => 'رؤى';

  @override
  String get noExpensesRecorded => 'لم يتم تسجيل أي نفقات';

  @override
  String get trackSpendingHabits => 'تتبع عادات الإنفاق الخاصة بك بسهولة.';

  @override
  String get addExpense => 'إضافة نفقة';

  @override
  String get noDataForPeriod => 'لا توجد بيانات لهذه الفترة';

  @override
  String get budget => 'الميزانية';

  @override
  String get spent => 'تم صرفه';

  @override
  String get limit => 'الحد';

  @override
  String get overBudget => 'تجاوز الميزانية!';

  @override
  String remainingBudget(Object percent) {
    return 'متبقي $percent%';
  }

  @override
  String get savingsRate => 'معدل الادخار';

  @override
  String get healthScore => 'درجة الصحة المالية';

  @override
  String get healthScoreExplanation =>
      'هذه الدرجة تعتمد على معدل ادخارك.\n\n• ادخار > 50% = ممتاز (100)\n• ادخار 0% = متوسط (50)\n• الإنفاق > الدخل = ضعيف (<50)';

  @override
  String get ok => 'موافق';

  @override
  String get bulkImport => 'استيراد بالجملة';
}

/// The translations for Arabic, as used in Bahrain (`ar_BH`).
class AppLocalizationsArBh extends AppLocalizationsAr {
  AppLocalizationsArBh() : super('ar_BH');

  @override
  String get settings => 'إعدادات';

  @override
  String get language => 'لغة';

  @override
  String get systemDefault => 'النظام الافتراضي';

  @override
  String get notes => 'ملحوظات';

  @override
  String get todos => 'المهام';

  @override
  String get expenses => 'نفقات';

  @override
  String get journal => 'مجلة';

  @override
  String get calendar => 'تقويم';

  @override
  String get clipboard => 'الحافظة';

  @override
  String get canvas => 'قماش';

  @override
  String get save => 'حفظ';

  @override
  String get create => 'إنشاء';

  @override
  String get cancel => 'إلغاء';

  @override
  String get delete => 'حذف';

  @override
  String get edit => 'تعديل';

  @override
  String get share => 'مشاركة';

  @override
  String get copy => 'نسخ';

  @override
  String get unsavedChanges => 'تغييرات غير محفوظة';

  @override
  String get confirmDelete => 'تأكيد الحذف';

  @override
  String get discard => 'تجاهل';

  @override
  String get createPost => 'إنشاء منشور';

  @override
  String get post => 'منشور';

  @override
  String get postingTo => 'النشر في';

  @override
  String get whatsOnYourMind => 'ماذا يدور في ذهنك؟';

  @override
  String get pickImages => 'اختر صورًا';

  @override
  String get pickVideo => 'اختر فيديو';

  @override
  String get camera => 'كاميرا';

  @override
  String get gallery => 'معرض الصور';

  @override
  String get search => 'بحث';

  @override
  String get pleaseEnterTask => 'يرجى إدخل مهمة';

  @override
  String get deleteTask => 'حذف المهمة';

  @override
  String get selectItems => 'حدد العناصر';

  @override
  String get deleteAll => 'حذف الكل';

  @override
  String error(Object error) {
    return 'خطأ: $error';
  }

  @override
  String get orderingOnlyAvailableInAllPosts =>
      'الترتيب متاح فقط في \"جميع المنشورات\"';

  @override
  String get deletePost => 'حذف المنشور';

  @override
  String get postDeleted => 'تم حذف المنشور';

  @override
  String get premiumFeatures => 'ميزات بريميوم';

  @override
  String get manageCoinsAdsPremium =>
      'إدارة العملات والإعلانات وحالة البريميوم';

  @override
  String get themeMode => 'وضع المظهر';

  @override
  String get accentColor => 'لون التمييز';

  @override
  String get backgroundDesign => 'تصميم الخلفية';

  @override
  String get pushNotifications => 'إشعارات الدفع';

  @override
  String get recycleBin => 'سلة المحذوفات';

  @override
  String get exportData => 'تصدير البيانات';

  @override
  String get importData => 'استيراد البيانات';

  @override
  String get rateApp => 'تقييم التطبيق';

  @override
  String get sendFeedback => 'إرسال تعليقات';

  @override
  String get privacyPolicy => 'سياسة الخصوصية';

  @override
  String get version => 'الإصدار';

  @override
  String get buildNumber => 'رقم البناء';

  @override
  String get system => 'النظام';

  @override
  String get light => 'فاتح';

  @override
  String get dark => 'داكن';

  @override
  String get itemRestored => 'تمت استعادة العنصر';

  @override
  String get recycleBinCleared => 'تم إفراغ سلة المحذوفات بنجاح';

  @override
  String get allPostsDeleted => 'تم حذف جميع المنشورات';

  @override
  String get newPost => 'منشور جديد';

  @override
  String get textCopiedToClipboardFacebook =>
      'تم نسخ النص إلى الحافظة (سياسة فيسبوك)';

  @override
  String get tiktokSharingRequiresVideoImage =>
      'تتطلب مشاركة TikTok فيديو/صورة';

  @override
  String errorSharing(Object error) {
    return 'خطأ في المشاركة: $error';
  }

  @override
  String shareToStory(Object platform) {
    return 'مشاركة في قصة $platform';
  }

  @override
  String shareToFeed(Object platform) {
    return 'مشاركة في موجز $platform';
  }

  @override
  String get unlockPermanently => 'فتح بشكل دائم';

  @override
  String get notEnoughCoins => 'لا توجد عملات كافية!';

  @override
  String youEarnedCoins(Object amount) {
    return 'لقد ربحت $amount من العملات!';
  }

  @override
  String get contentCopied => 'تم نسخ المحتوى';

  @override
  String get selectDateTime => 'حدد التاريخ والوقت';

  @override
  String get areYouSureYouWantToDeleteThisPost =>
      'هل أنت متأكد أنك تريد حذف هذا المنشور؟';

  @override
  String get socialPosts => 'منشورات اجتماعية';

  @override
  String get watchAdToEarnCoins => 'شاهد إعلانًا لربح العملات';

  @override
  String get premiumUnlocked => 'تم فتح البريميوم';

  @override
  String get removeAds => 'إزالة الإعلانات';

  @override
  String get unlimitedCloudStorage => 'تخزين سحابي غير محدود';

  @override
  String get deleteNote => 'حذف الملاحظة';

  @override
  String get shareNote => 'مشاركة الملاحظة';

  @override
  String get editNote => 'تعديل الملاحظة';

  @override
  String get searchNotes => 'البحث في الملاحظات...';

  @override
  String get noNotesFound => 'لم يتم العثور على ملاحظات';

  @override
  String get captureThoughts => 'سجل أفكارك فورا.';

  @override
  String get createNote => 'إنشاء ملاحظة';

  @override
  String get customOrder => 'ترتيب مخصص';

  @override
  String get newestFirst => 'الأحدث أولاً';

  @override
  String get oldestFirst => 'الأقدم أولاً';

  @override
  String get titleAZ => 'العنوان: أ-ي';

  @override
  String get titleZA => 'العنوان: ي-أ';

  @override
  String get deleteAllQuestion => 'حذف الكل؟';

  @override
  String get moveToRecycleBin => 'نقل جميع الملاحظات إلى سلة المحذوفات؟';

  @override
  String get moveToBinQuestion => 'نقل إلى السلة؟';

  @override
  String get restoreNoteLater => 'يمكنك استعادة هذه الملاحظة لاحقًا.';

  @override
  String get move => 'نقل';

  @override
  String get myThoughts => 'أفكاري';

  @override
  String get selected => 'محدد';

  @override
  String get noContent => 'لا يوجد محتوى';

  @override
  String get untitled => 'بدون عنوان';

  @override
  String get chooseWallpapers => 'اختر من بين أكثر من 10 خلفيات ديناميكية';

  @override
  String get backupData => 'نسخ احتياطي للبيانات';

  @override
  String get saveJsonFile => 'هل تريد حفظ ملف JSON يحتوي على جميع بياناتك؟';

  @override
  String get exportNow => 'تصدير الآن';

  @override
  String get importDataTitle => 'استيراد البيانات';

  @override
  String get mergeBackupFile =>
      'هل تريد دمج ملف النسخ الاحتياطي مع العناصر الحالية؟';

  @override
  String get selectFile => 'حدد ملفاً';

  @override
  String get backupSaved => 'تم حفظ النسخة الاحتياطية بنجاح!';

  @override
  String get exportFailed => 'فشل التصدير.';

  @override
  String importSuccess(Object count) {
    return 'تمت استعادة $count من العناصر بنجاح!';
  }

  @override
  String get importFailed => 'فشل الاستيراد.';

  @override
  String widgetAdded(String widget) {
    return 'تمت إضافة الأداة $widget إلى الشاشة الرئيسية!';
  }

  @override
  String get widgetRequestSent =>
      'تم إرسال طلب الأداة. يرجى التحقق من الشاشة الرئيسية.';

  @override
  String get widgetAddFailed => 'فشل إضافة الأداة';

  @override
  String get autoSaveEnabled => 'تم تفعيل الحفظ التلقائي.';

  @override
  String get autoSaveDisabled => 'تم تعطيل الحفظ التلقائي.';

  @override
  String get homeScreenWidgets => 'أدوات الشاشة الرئيسية';

  @override
  String get notificationsTitle => 'الإشعارات';

  @override
  String get dataBackup => 'البيانات والنسخ الاحتياطي';

  @override
  String get feedbackSupport => 'التعليقات والدعم';

  @override
  String get creditsTitle => 'الاعتمادات';

  @override
  String get privacyMaintenance => 'الخصوصية والصيانة';

  @override
  String get aboutTitle => 'حول';

  @override
  String get premium => 'بريميوم';

  @override
  String get appearanceTitle => 'المظهر';

  @override
  String get clipboardTitle => 'الحافظة';

  @override
  String get settingsSubtitle => 'تخصيص تجربتك';

  @override
  String get welcomeTitle => 'مرحبًا بك في CopyClip';

  @override
  String get welcomeDescription =>
      'رفيقك النهائي للإنتاجية. دعنا نجهزك بأدوات قوية لإدارة يومك.';

  @override
  String get onboardingNotesTitle => 'ملاحظات ذكية';

  @override
  String get onboardingNotesDesc =>
      'التقط الأفكار فورًا بتنسيق نص غني. نظم أفكارك ولا تفقد أي فكرة رائعة مرة أخرى.';

  @override
  String get onboardingTodosTitle => 'إدارة المهام';

  @override
  String get onboardingTodosDesc =>
      'ابق مطلعاً على أمورك. أنشئ قوائم مهام، وحدد الأولويات، وحقق أهدافك خطوة بخطوة.';

  @override
  String get onboardingExpensesTitle => 'تتبع النفقات';

  @override
  String get onboardingExpensesDesc =>
      'تحكم في أموالك. تتبع الدخل والنفقات بسهولة لفهم عادات الإنفاق الخاصة بك.';

  @override
  String get onboardingJournalTitle => 'يوميات شخصية';

  @override
  String get onboardingJournalDesc =>
      'تأمل في يومك. مساحة خاصة لتدوين ذكرياتك ومشاعرك وتجاربك اليومية.';

  @override
  String get onboardingCalendarTitle => 'التقويم والأحداث';

  @override
  String get onboardingCalendarDesc =>
      'لا تفوت أي لحظة. نظم جدولك وتابع الأحداث الهامة القادمة.';

  @override
  String get onboardingClipboardTitle => 'مدير الحافظة';

  @override
  String get onboardingClipboardDesc =>
      'انسخ مرة واحدة، والصق في أي مكان. الوصول إلى سجل الحافظة لاستعادة النصوص التي نسختها سابقاً.';

  @override
  String get onboardingCanvasTitle => 'لوحة إبداعية';

  @override
  String get onboardingCanvasDesc =>
      'أطلق العنان لإبداعك. ارسم وخطط وصور أفكارك على لوحة رقمية حرة.';

  @override
  String get featuresNotesDesc => 'إنشاء وإدارة الملاحظات الخاصة بك';

  @override
  String get featuresTodosDesc => 'تتبع المهام الخاصة بك';

  @override
  String get featuresExpensesDesc => 'مراقبة النفقات الخاصة بك';

  @override
  String get featuresJournalDesc => 'اكتتب أفكارك';

  @override
  String get featuresCalendarDesc => 'نظم جدولك الزمني';

  @override
  String get featuresClipboardDesc => 'الوصول إلى سجل الحافظة الخاص بك';

  @override
  String get featuresCanvasDesc => 'ارسم وخطط بحرية';

  @override
  String get featuresSocialPost => 'منشور اجتماعي';

  @override
  String get featuresSocialPostDesc =>
      'إنشاء محتوى جذاب لوسائل التواصل الاجتماعي';

  @override
  String get chooseYourAura => 'اختر هالتك';

  @override
  String get expressYourselfTheme => 'عبر عن نفسك بلون مظهر جديد!';

  @override
  String get level => 'المستوى';

  @override
  String get xpToNextLevel => 'XP للمستوى التالي';

  @override
  String get checkUpcomingEvents => 'تحقق من الأحداث القادمة';

  @override
  String get startNewSketch => 'بدأ رسمة جديدة';

  @override
  String get noTransactionsMonth => 'لا توجد معاملات هذا الشهر';

  @override
  String transactionsThisMonth(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count معاملات هذا الشهر',
      two: 'معاملتان هذا الشهر',
      one: 'معاملة واحدة هذا الشهر',
      zero: 'لا توجد معاملات هذا الشهر',
    );
    return '$_temp0';
  }

  @override
  String get autoSaveClipboard => 'حفظ تلقائي للحافظة';

  @override
  String get autoSaveClipboardDesc => 'حفظ العناصر المنسوخة تلقائياً';

  @override
  String get permissionDeniedSettings =>
      'تم رفض الإذن بشكل دائم. يرجى تفعيله من الإعدادات.';

  @override
  String get notificationsEnabled => 'تم تفعيل الإشعارات!';

  @override
  String get redirectingToSettings =>
      'جارٍ التوجيه إلى الإعدادات لتعطيل الإشعارات...';

  @override
  String get premiumAccess => 'وصول بريميوم';

  @override
  String get premiumActiveUntil => 'بريميوم نشط حتى';

  @override
  String get unlockAllFeatures => 'فتح جميع الميزات';

  @override
  String get buyPremium => 'شراء بريميوم (7 أيام)';

  @override
  String costCoins(Object cost) {
    return 'التكلفة: $cost عملات';
  }

  @override
  String get premiumActivated => 'تم تفعيل البريميوم لمدة 7 أيام!';

  @override
  String get premiumActive => 'البريميوم نشط';

  @override
  String get expires => 'تنتهي الصلاحية:';

  @override
  String get temporaryAccess => 'وصول مؤقت';

  @override
  String get journalExpression => 'يوميات وتعبير';

  @override
  String get artisticDesigns => 'تصاميم فنية';

  @override
  String get artisticDesignsDesc =>
      'فتح أكثر من 10 مظاهر فريدة لبطاقات اليوميات';

  @override
  String get premiumLayouts => 'تخطيطات بريميوم';

  @override
  String get premiumLayoutsDesc => 'طرق حصرية لعرض ذكرياتك';

  @override
  String get calendarTools => 'تقويم وأدوات';

  @override
  String get fullCalendar => 'تقويم كامل';

  @override
  String get fullCalendarDesc => 'نظام متكامل لإدارة الأحداث';

  @override
  String get clipboardAutoSaveDesc => 'التقاط سجل الحافظة في الخلفية';

  @override
  String get proWidgets => 'أدوات ذكية للمحترفين';

  @override
  String get proWidgetsDesc => 'جميع الميزات متوفرة على شاشتك الرئيسية';

  @override
  String get dataExport => 'البيانات والتصدير';

  @override
  String get advancedBackup => 'نسخ احتياطي متقدم';

  @override
  String get advancedBackupDesc => 'استيراد/تصدير آمن لجميع البيانات';

  @override
  String get pdfExport => 'تصدير إلى PDF';

  @override
  String get pdfExportDesc => 'تصدير الملاحظات واليوميات إلى PDF';

  @override
  String get printReady => 'جاهز للطباعة';

  @override
  String get printReadyDesc => 'دعم الطباعة المباشرة';

  @override
  String get richTextEditor => 'محرر نص غني';

  @override
  String get advancedSearch => 'بحث متقدم';

  @override
  String get advancedSearchDesc => 'البحث والاستبدال داخل النص';

  @override
  String get richMedia => 'وسائط غنية';

  @override
  String get richMediaDesc => 'إدراج صور وفيديوهات وروابط';

  @override
  String get editorStyling => 'تنسيق المحرر';

  @override
  String get editorStylingDesc => 'نص مخصص وخلفيات للمحرر';

  @override
  String get balance => 'الرصيد';

  @override
  String get loadingAd => 'جارٍ تحميل الإعلان...';

  @override
  String watchAd(Object amount) {
    return 'مشاهدة إعلان (+$amount)';
  }

  @override
  String get loadAd => 'تحميل إعلان';

  @override
  String get backupDataDesc => 'حفظ ملف JSON لبياناتك';

  @override
  String get importDataDesc => 'دمج ملف نسخة احتياطية في CopyClip';

  @override
  String get notificationPermissionDenied => 'تم رفض إذن الإشعارات.';

  @override
  String get typeNewTask => 'اكتب مهمة جديدة...';

  @override
  String get addTask => 'إضافة مهمة';

  @override
  String get completed => 'مكتمل';

  @override
  String get greatJob => 'عمل رائع!';

  @override
  String youEarnedXPNextTask(Object amount, Object date) {
    return 'لقد ربحت $amount XP! المهمة التالية: $date';
  }

  @override
  String taskCompletedXP(Object amount) {
    return 'تمت المهمة! +$amount XP';
  }

  @override
  String get moveTasksToRecycleBin =>
      'نقل جميع المهام النشطة إلى سلة المحذوفات؟';

  @override
  String get deleteAllPosts => 'حذف جميع المنشورات';

  @override
  String get deleteAllPostsConfirmation =>
      'هل أنت متأكد أنك تريد حذف جميع المنشورات الاجتماعية؟ لا يمكن التراجع عن هذا الإجراء.';

  @override
  String get allPosts => 'جميع المنشورات';

  @override
  String get favorites => 'المفضلة';

  @override
  String get drafts => 'المسودات';

  @override
  String get noFavoritesYet => 'لا توجد مفضلات بعد';

  @override
  String get noDraftsYet => 'لا توجد مسودات بعد';

  @override
  String get startSocialJourney => 'ابدأ رحلتك الاجتماعية!';

  @override
  String get draft => 'مسودة';

  @override
  String attachmentCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count مرفقات',
      two: 'مرفقان',
      one: 'مرفق واحد',
      zero: 'لا توجد مرفقات',
    );
    return '$_temp0';
  }

  @override
  String get pleaseAddContent => 'يرجى إضافة بعض المحتوى أو الوسائط للمشاركة';

  @override
  String fileNotFoundError(Object path) {
    return 'خطأ: لم يتم العثور على الملف في $path';
  }

  @override
  String get checkFacebookApp => 'تحقق من تطبيق فيسبوك';

  @override
  String get systemShare => 'مشاركة النظام';

  @override
  String get socialPost => 'منشور اجتماعي';

  @override
  String get favorite => 'مفضل';

  @override
  String get saveDraft => 'حفظ المسودة';

  @override
  String get entryCopied => 'تم نسخ المدخل';

  @override
  String get moveEntriesToRecycleBin =>
      'نقل جميع المدخلات النشطة إلى سلة المحذوفات؟';

  @override
  String get startWritingStory => 'ابدأ بكتابة قصتك';

  @override
  String get recordMemories => 'سجل ذكرياتك ومشاعرك اليومية.';

  @override
  String get writeJournal => 'اكتب يومياتك';

  @override
  String get myMemories => 'ذكرياتي';

  @override
  String get sortJournal => 'فرز اليوميات';

  @override
  String get byMood => 'حسب المزاج';

  @override
  String get searchMemories => 'بحث في الذكريات...';

  @override
  String get selectAll => 'تحديد الكل';

  @override
  String get deleteSelected => 'حذف المحدد';

  @override
  String get taskCompletedExclamation => 'تمت المهمة!';

  @override
  String get taskUncompletedExclamation => 'مهمة غير مكتملة';

  @override
  String get clipboardUpdatedExclamation => 'تم تحديث الحافظة!';

  @override
  String clipboardSavedContent(Object content) {
    return 'تم حفظ في الحافظة: $content';
  }

  @override
  String get overview => 'نظرة عامة';

  @override
  String get colorAurora => 'أورورا';

  @override
  String get colorCosmic => 'كوني';

  @override
  String get colorNebula => 'سديم';

  @override
  String get colorStarlight => 'ضوء النجوم';

  @override
  String get colorSolar => 'شمسي';

  @override
  String get colorNova => 'نوفا';

  @override
  String get loadingStepLoading => 'جارٍ التحميل...';

  @override
  String get loadingStepDatabase => 'إعداد قاعدة البيانات...';

  @override
  String get loadingStepSystem => 'تكوين النظام...';

  @override
  String get loadingStepReady => 'جاهز';

  @override
  String get productivityCompanion => 'رفيقك للإنتاجية';

  @override
  String get done => 'تم';

  @override
  String get newNote => 'ملاحظة جديدة';

  @override
  String get changeColor => 'تغيير اللون';

  @override
  String get copyContent => 'نسخ المحتوى';

  @override
  String get titleOptional => 'العنوان (اختياري)';

  @override
  String get exportAsPdf => 'تصدير كـ PDF';

  @override
  String get taskDueNow => 'موعد المهمة الآن';

  @override
  String get moveTaskToBinTitle => 'نقل المهمة إلى سلة المحذوفات؟';

  @override
  String get restoreTaskLater =>
      'يمكنك استعادة هذه المهمة لاحقاً من الإعدادات.';

  @override
  String get newTask => 'مهمة جديدة';

  @override
  String get editTask => 'تعديل المهمة';

  @override
  String get undo => 'تراجع';

  @override
  String get redo => 'إعادة';

  @override
  String get category => 'الفئة';

  @override
  String get categoryHint => 'مثال: العمل، النادي';

  @override
  String get whatNeedsToBeDone => 'ما الذي يجب القيام به؟';

  @override
  String get enterTaskDetails => 'أدخل تفاصيل المهمة...';

  @override
  String get setDueDate => 'تحديد موعد الاستحقاق';

  @override
  String get dueDate => 'موعد الاستحقاق';

  @override
  String get expenseTitle => 'النفقات';

  @override
  String searchInCurrency(String currency) {
    return 'بحث في $currency...';
  }

  @override
  String get sortAndFilter => 'فرز وتصفية';

  @override
  String get sortBy => 'فرز حسب';

  @override
  String get highestAmount => 'أعلى مبلغ';

  @override
  String get lowestAmount => 'أقل مبلغ';

  @override
  String get moreFilters => 'مزيد من الفلاتر...';

  @override
  String get filterExpenses => 'تصفية النفقات';

  @override
  String get transactionType => 'نوع المعاملة';

  @override
  String get categories => 'الفئات';

  @override
  String get all => 'الكل';

  @override
  String get income => 'الدخل';

  @override
  String get expense => 'المصروفات';

  @override
  String get reset => 'إعادة تعيين';

  @override
  String get apply => 'تطبيق';

  @override
  String newExpense(String currency) {
    return 'جديد $currency';
  }

  @override
  String errorLoadingData(String error) {
    return 'حدث خطأ أثناء تحميل البيانات.\n\n$error';
  }

  @override
  String get dailyQuote1 => 'أفضل طريقة للتنبؤ بالمستقبل هي أن تصنعه.';

  @override
  String get dailyQuote2 => 'الغنى ليس في كثرة العرض، ولكن الغنى غنى النفس.';

  @override
  String get dailyQuote3 => 'الوقت هو العملة الأغلى.';

  @override
  String get dailyQuote4 => 'النجاح ليس نهائياً، والفشل ليس قاتلاً.';

  @override
  String get dailyQuote5 => 'ركز على الحل، وليس المشكلة.';

  @override
  String get dailyQuote6 => 'شبكة علاقاتك هي ثروتك الحقيقية.';

  @override
  String get moodHappy => 'سعيد';

  @override
  String get moodExcited => 'متحمس';

  @override
  String get moodNeutral => 'محايد';

  @override
  String get moodSad => 'حزين';

  @override
  String get moodStressed => 'متوتر';

  @override
  String exportDate(String date) {
    return '📅 $date';
  }

  @override
  String exportMood(String emoji, String mood) {
    return 'المزاج: $emoji $mood';
  }

  @override
  String exportTitle(String title) {
    return 'العنوان: $title';
  }

  @override
  String exportTags(String tags) {
    return '\nالوسوم: $tags';
  }

  @override
  String get instagram => 'إنستغرام';

  @override
  String get facebook => 'فيسبوك';

  @override
  String get tiktok => 'تيك توك';

  @override
  String get newSketch => 'رسمة جديدة';

  @override
  String get searchSketches => 'البحث في الرسومات والمجلدات...';

  @override
  String get noResultsFound => 'لم يتم العثور على نتائج';

  @override
  String get noItems => 'لا توجد عناصر';

  @override
  String get noDrawingsYet => 'لا توجد رسومات بعد';

  @override
  String get canvasIntro => 'أطلق العنان لإبداعك على اللوحة!';

  @override
  String get newCanvas => 'لوحة جديدة';

  @override
  String get rename => 'إعادة تسمية';

  @override
  String get deleteFolder => 'حذف المجلد';

  @override
  String get deleteSketchesQuestion => 'حذف الرسومات؟';

  @override
  String get deleteFolderConfirmation =>
      'سيتم حذف جميع الرسومات في هذا المجلد نهائياً.';

  @override
  String get renameFolder => 'إعادة تسمية المجلد';

  @override
  String get chooseColor => 'اختر لوناً';

  @override
  String get deleteFolderQuestion => 'حذف المجلد؟';

  @override
  String get searchClips => 'البحث في القصاصات...';

  @override
  String get clipboardEmpty => 'الحافظة فارغة';

  @override
  String get addItem => 'إضافة عنصر';

  @override
  String get clipColor => 'لون القصاصة';

  @override
  String get newClip => 'قصاصة جديدة';

  @override
  String get editClip => 'تعديل القصاصة';

  @override
  String get restoreClipLater => 'يمكنك استعادة هذه القصاصة لاحقاً.';

  @override
  String get upcomingEvents => 'الأحداث القادمة';

  @override
  String get dataDistribution => 'توزيع البيانات';

  @override
  String get taskProgress => 'تقدم المهمة';

  @override
  String get quickStats => 'إحصائيات سريعة';

  @override
  String get taskCompletion => 'إكمال المهمة';

  @override
  String get noItemsForDate => 'لا توجد عناصر لهذا التاريخ';

  @override
  String get enjoyFreeTime => 'استمتع بوقت فراغك!';

  @override
  String get searchThisDay => 'البحث في هذا اليوم...';

  @override
  String get finance => 'المالية';

  @override
  String get permanentlyDelete => 'حذف نهائي؟';

  @override
  String deleteSelectionConfirmation(int foldersCount, int sketchesCount) {
    return 'سيؤدي هذا إلى حذف $foldersCount مجلدات (ورسماتها) و $sketchesCount رسومات أخرى نهائياً.\n\nلا يمكن التراجع عن هذا الإجراء.';
  }

  @override
  String get deleteForever => 'حذف للأبد';

  @override
  String selectedCount(int count) {
    return '$count محدد';
  }

  @override
  String canvasStats(int notes, int folders) {
    return '$notes رسومات • $folders مجلدات';
  }

  @override
  String get sortItems => 'فرز العناصر';

  @override
  String get sortNameAZ => 'الاسم (أ-ي)';

  @override
  String get sortNameZA => 'الاسم (ي-أ)';

  @override
  String get createFolder => 'إنشاء مجلد';

  @override
  String get folderNameHint => 'اسم المجلد...';

  @override
  String deleteSketchesConfirmation(int count) {
    return 'حذف $count رسومات؟ لا يمكن التراجع عن هذا الإجراء.';
  }

  @override
  String get noSketchesFound => 'لم يتم العثور على رسومات';

  @override
  String get noSketchesFoundSub => 'حاول تعديل بحثك أو إنشاء رسمة جديدة.';

  @override
  String searchInFolder(String folder) {
    return 'بحث في $folder...';
  }

  @override
  String sketchesCount(int count) {
    return '$count رسومات';
  }

  @override
  String get sortSketches => 'فرز الرسومات';

  @override
  String get calendarScreenTitle => 'التقويم';

  @override
  String get dailyActivity => 'النشاط اليومي';

  @override
  String get deleteItemQuestion => 'حذف العنصر؟';

  @override
  String get deleteItemConfirmation =>
      'سيؤدي هذا إلى نقل العنصر إلى سلة المحذوفات.';

  @override
  String get moveToBinItem => 'نقل إلى السلة؟';

  @override
  String get moveToBinConfirmation => 'يمكنك استعادته لاحقاً.';

  @override
  String selectedItems(int count) {
    return '$count محدد';
  }

  @override
  String get recentClips => 'القصاصات الأخيرة';

  @override
  String get copied => 'تم النسخ!';

  @override
  String get copiedPlainText => 'تم نسخ النص المجرد';

  @override
  String get clipTheme => 'مظهر القصاصة';

  @override
  String get justNow => 'الآن';

  @override
  String minutesAgo(Object count) {
    return 'منذ $count د';
  }

  @override
  String hoursAgo(Object count) {
    return 'منذ $count س';
  }

  @override
  String daysAgo(Object count) {
    return 'منذ $count ي';
  }

  @override
  String get noTasksFound => 'لم يتم العثور على مهام.';

  @override
  String get searchTasks => 'بحث في المهام...';

  @override
  String get taskReminder => 'تذكير بالمهمة';

  @override
  String get untitledNote => 'ملاحظة بدون عنوان';

  @override
  String get dailyEntry => 'مدخل يومي';

  @override
  String get clipboardHistory => 'سجل الحافظة';

  @override
  String get deletePermanentlyContent => 'هذا الإجراء لا يمكن التراجع عنه.';

  @override
  String get emptyRecycleBinTitle => 'إفراغ سلة المحذوفات؟';

  @override
  String emptyRecycleBinContent(Object count) {
    return 'سيتم حذف جميع العناصر الـ $count نهائياً.';
  }

  @override
  String get emptyBin => 'إفراغ السلة';

  @override
  String get recycleBinEmpty => 'سلة المحذوفات فارغة';

  @override
  String get deletedItemsAppearHere => 'العناصر المحذوفة ستظهر هنا.';

  @override
  String get empty => 'فارغ';

  @override
  String get recent => 'الأخيرة';

  @override
  String categoryLabel(Object category) {
    return 'الفئة: $category';
  }

  @override
  String get general => 'عام';

  @override
  String get saveTransactionQuestion => 'هل تريد حفظ هذه المعاملة؟';

  @override
  String get fillTitleAmount => 'يرجى ملء العنوان والمبلغ';

  @override
  String get invalidAmount => 'تنسيق المبلغ غير صالح';

  @override
  String get moveTransactionToBinTitle => 'نقل المعاملة إلى سلة المحذوفات؟';

  @override
  String get restoreTransactionLater =>
      'يمكنك استعادة هذه المعاملة لاحقاً من الإعدادات.';

  @override
  String get newTransaction => 'معاملة جديدة';

  @override
  String get whatIsThisFor => 'فيما هذا؟';

  @override
  String get description => 'الوصف';

  @override
  String get daily => 'يومياً';

  @override
  String get weekly => 'أسبوعياً';

  @override
  String get monthly => 'شهرياً';

  @override
  String get yearly => 'سنوياً';

  @override
  String get totalIncome => 'إجمالي الدخل';

  @override
  String get totalExpense => 'إجمالي النفقات';

  @override
  String get analysis => 'التحليل';

  @override
  String get transactions => 'المعاملات';

  @override
  String get noExpensesFound => 'لم يتم العثور على نفقات لهذه الفترة.';

  @override
  String get netBalance => 'صافي الرصيد';

  @override
  String get topCategories => 'أبرز الفئات';

  @override
  String get spendingTrend => 'اتجاه الإنفاق';

  @override
  String get insights => 'رؤى';

  @override
  String get noExpensesRecorded => 'لم يتم تسجيل أي نفقات';

  @override
  String get trackSpendingHabits => 'تتبع عادات الإنفاق الخاصة بك بسهولة.';

  @override
  String get addExpense => 'إضافة نفقة';

  @override
  String get noDataForPeriod => 'لا توجد بيانات لهذه الفترة';

  @override
  String get budget => 'الميزانية';

  @override
  String get spent => 'تم صرفه';

  @override
  String get limit => 'الحد';

  @override
  String get overBudget => 'تجاوز الميزانية!';

  @override
  String remainingBudget(Object percent) {
    return 'متبقي $percent%';
  }

  @override
  String get savingsRate => 'معدل الادخار';

  @override
  String get healthScore => 'درجة الصحة المالية';

  @override
  String get healthScoreExplanation =>
      'هذه الدرجة تعتمد على معدل ادخارك.\n\n• ادخار > 50% = ممتاز (100)\n• ادخار 0% = متوسط (50)\n• الإنفاق > الدخل = ضعيف (<50)';

  @override
  String get ok => 'موافق';

  @override
  String get bulkImport => 'استيراد بالجملة';
}

/// The translations for Arabic, as used in Algeria (`ar_DZ`).
class AppLocalizationsArDz extends AppLocalizationsAr {
  AppLocalizationsArDz() : super('ar_DZ');

  @override
  String get settings => 'إعدادات';

  @override
  String get language => 'لغة';

  @override
  String get systemDefault => 'النظام الافتراضي';

  @override
  String get notes => 'ملحوظات';

  @override
  String get todos => 'المهام';

  @override
  String get expenses => 'نفقات';

  @override
  String get journal => 'مجلة';

  @override
  String get calendar => 'تقويم';

  @override
  String get clipboard => 'الحافظة';

  @override
  String get canvas => 'قماش';

  @override
  String get save => 'حفظ';

  @override
  String get create => 'إنشاء';

  @override
  String get cancel => 'إلغاء';

  @override
  String get delete => 'حذف';

  @override
  String get edit => 'تعديل';

  @override
  String get share => 'مشاركة';

  @override
  String get copy => 'نسخ';

  @override
  String get unsavedChanges => 'تغييرات غير محفوظة';

  @override
  String get confirmDelete => 'تأكيد الحذف';

  @override
  String get discard => 'تجاهل';

  @override
  String get createPost => 'إنشاء منشور';

  @override
  String get post => 'منشور';

  @override
  String get postingTo => 'النشر في';

  @override
  String get whatsOnYourMind => 'ماذا يدور في ذهنك؟';

  @override
  String get pickImages => 'اختر صورًا';

  @override
  String get pickVideo => 'اختر فيديو';

  @override
  String get camera => 'كاميرا';

  @override
  String get gallery => 'معرض الصور';

  @override
  String get search => 'بحث';

  @override
  String get pleaseEnterTask => 'يرجى إدخال مهمة';

  @override
  String get deleteTask => 'حذف المهمة';

  @override
  String get selectItems => 'حدد العناصر';

  @override
  String get deleteAll => 'حذف الكل';

  @override
  String error(Object error) {
    return 'خطأ: $error';
  }

  @override
  String get orderingOnlyAvailableInAllPosts =>
      'الترتيب متاح فقط في \"جميع المنشورات\"';

  @override
  String get deletePost => 'حذف المنشور';

  @override
  String get postDeleted => 'تم حذف المنشور';

  @override
  String get premiumFeatures => 'ميزات بريميوم';

  @override
  String get manageCoinsAdsPremium =>
      'إدارة العملات والإعلانات وحالة البريميوم';

  @override
  String get themeMode => 'وضع المظهر';

  @override
  String get accentColor => 'لون التمييز';

  @override
  String get backgroundDesign => 'تصميم الخلفية';

  @override
  String get pushNotifications => 'إشعارات الدفع';

  @override
  String get recycleBin => 'سلة المحذوفات';

  @override
  String get exportData => 'تصدير البيانات';

  @override
  String get importData => 'استيراد البيانات';

  @override
  String get rateApp => 'تقييم التطبيق';

  @override
  String get sendFeedback => 'إرسال تعليقات';

  @override
  String get privacyPolicy => 'سياسة الخصوصية';

  @override
  String get version => 'الإصدار';

  @override
  String get buildNumber => 'رقم البناء';

  @override
  String get system => 'النظام';

  @override
  String get light => 'فاتح';

  @override
  String get dark => 'داكن';

  @override
  String get itemRestored => 'تمت استعادة العنصر';

  @override
  String get recycleBinCleared => 'تم إفراغ سلة المحذوفات بنجاح';

  @override
  String get allPostsDeleted => 'تم حذف جميع المنشورات';

  @override
  String get newPost => 'منشور جديد';

  @override
  String get textCopiedToClipboardFacebook =>
      'Text copied to clipboard (Facebook policy)';

  @override
  String get tiktokSharingRequiresVideoImage =>
      'تتطلب مشاركة TikTok فيديو/صورة';

  @override
  String errorSharing(Object error) {
    return 'خطأ في المشاركة: $error';
  }

  @override
  String shareToStory(Object platform) {
    return 'مشاركة في قصة $platform';
  }

  @override
  String shareToFeed(Object platform) {
    return 'مشاركة في موجز $platform';
  }

  @override
  String get unlockPermanently => 'فتح بشكل دائم';

  @override
  String get notEnoughCoins => 'لا توجد عملات كافية!';

  @override
  String youEarnedCoins(Object amount) {
    return 'لقد ربحت $amount من العملات!';
  }

  @override
  String get contentCopied => 'تم نسخ المحتوى';

  @override
  String get selectDateTime => 'حدد التاريخ والوقت';

  @override
  String get areYouSureYouWantToDeleteThisPost =>
      'هل أنت متأكد أنك تريد حذف هذا المنشور؟';

  @override
  String get socialPosts => 'منشورات اجتماعية';

  @override
  String get watchAdToEarnCoins => 'شاهد إعلانًا لربح العملات';

  @override
  String get premiumUnlocked => 'تم فتح البريميوم';

  @override
  String get removeAds => 'إزالة الإعلانات';

  @override
  String get unlimitedCloudStorage => 'تخزين سحابي غير محدود';

  @override
  String get deleteNote => 'حذف الملاحظة';

  @override
  String get shareNote => 'مشاركة الملاحظة';

  @override
  String get editNote => 'تعديل الملاحظة';

  @override
  String get searchNotes => 'البحث في الملاحظات...';

  @override
  String get noNotesFound => 'لم يتم العثور على ملاحظات';

  @override
  String get captureThoughts => 'سجل أفكارك فورا.';

  @override
  String get createNote => 'إنشاء ملاحظة';

  @override
  String get customOrder => 'ترتيب مخصص';

  @override
  String get newestFirst => 'الأحدث أولاً';

  @override
  String get oldestFirst => 'الأقدم أولاً';

  @override
  String get titleAZ => 'العنوان: أ-ي';

  @override
  String get titleZA => 'العنوان: ي-أ';

  @override
  String get deleteAllQuestion => 'حذف الكل؟';

  @override
  String get moveToRecycleBin => 'نقل جميع الملاحظات إلى سلة المحذوفات؟';

  @override
  String get moveToBinQuestion => 'نقل إلى السلة؟';

  @override
  String get restoreNoteLater => 'يمكنك استعادة هذه الملاحظة لاحقًا.';

  @override
  String get move => 'نقل';

  @override
  String get myThoughts => 'أفكاري';

  @override
  String get selected => 'محدد';

  @override
  String get noContent => 'لا يوجد محتوى';

  @override
  String get untitled => 'بدون عنوان';

  @override
  String get chooseWallpapers => 'اختر من بين أكثر من 10 خلفيات ديناميكية';

  @override
  String get backupData => 'نسخ احتياطي للبيانات';

  @override
  String get saveJsonFile => 'هل تريد حفظ ملف JSON يحتوي على جميع بياناتك؟';

  @override
  String get exportNow => 'تصدير الآن';

  @override
  String get importDataTitle => 'استيراد البيانات';

  @override
  String get mergeBackupFile =>
      'هل تريد دمج ملف النسخ الاحتياطي مع العناصر الحالية؟';

  @override
  String get selectFile => 'حدد ملفاً';

  @override
  String get backupSaved => 'تم حفظ النسخة الاحتياطية بنجاح!';

  @override
  String get exportFailed => 'فشل التصدير.';

  @override
  String importSuccess(Object count) {
    return 'تمت استعادة $count من العناصر بنجاح!';
  }

  @override
  String get importFailed => 'فشل الاستيراد.';

  @override
  String widgetAdded(String widget) {
    return 'تمت إضافة الأداة $widget إلى الشاشة الرئيسية!';
  }

  @override
  String get widgetRequestSent =>
      'تم إرسال طلب الأداة. يرجى التحقق من الشاشة الرئيسية.';

  @override
  String get widgetAddFailed => 'فشل إضافة الأداة';

  @override
  String get autoSaveEnabled => 'تم تفعيل الحفظ التلقائي.';

  @override
  String get autoSaveDisabled => 'تم تعطيل الحفظ التلقائي.';

  @override
  String get homeScreenWidgets => 'أدوات الشاشة الرئيسية';

  @override
  String get notificationsTitle => 'الإشعارات';

  @override
  String get dataBackup => 'البيانات والنسخ الاحتياطي';

  @override
  String get feedbackSupport => 'التعليقات والدعم';

  @override
  String get creditsTitle => 'الاعتمادات';

  @override
  String get privacyMaintenance => 'الخصوصية والصيانة';

  @override
  String get aboutTitle => 'حول';

  @override
  String get premium => 'بريميوم';

  @override
  String get appearanceTitle => 'المظهر';

  @override
  String get clipboardTitle => 'الحافظة';

  @override
  String get settingsSubtitle => 'تخصيص تجربتك';

  @override
  String get welcomeTitle => 'مرحبًا بك في CopyClip';

  @override
  String get welcomeDescription =>
      'رفيقك النهائي للإنتاجية. دعنا نجهزك بأدوات قوية لإدارة يومك.';

  @override
  String get onboardingNotesTitle => 'ملاحظات ذكية';

  @override
  String get onboardingNotesDesc =>
      'التقط الأفكار فورًا بتنسيق نص غني. نظم أفكارك ولا تفقد أي فكرة رائعة مرة أخرى.';

  @override
  String get onboardingTodosTitle => 'إدارة المهام';

  @override
  String get onboardingTodosDesc =>
      'ابق مطلعاً على أمورك. أنشئ قوائم مهام، وحدد الأولويات، وحقق أهدافك خطوة بخطوة.';

  @override
  String get onboardingExpensesTitle => 'تتبع النفقات';

  @override
  String get onboardingExpensesDesc =>
      'تحكم في أموالك. تتبع الدخل والنفقات بسهولة لفهم عادات الإنفاق الخاصة بك.';

  @override
  String get onboardingJournalTitle => 'يوميات شخصية';

  @override
  String get onboardingJournalDesc =>
      'تأمل في يومك. مساحة خاصة لتدوين ذكرياتك ومشاعرك وتجاربك اليومية.';

  @override
  String get onboardingCalendarTitle => 'التقويم والأحداث';

  @override
  String get onboardingCalendarDesc =>
      'لا تفوت أي لحظة. نظم جدولك وتابع الأحداث الهامة القادمة.';

  @override
  String get onboardingClipboardTitle => 'مدير الحافظة';

  @override
  String get onboardingClipboardDesc =>
      'انسخ مرة واحدة، والصق في أي مكان. الوصول إلى سجل الحافظة لاستعادة النصوص التي نسختها سابقاً.';

  @override
  String get onboardingCanvasTitle => 'لوحة إبداعية';

  @override
  String get onboardingCanvasDesc =>
      'أطلق العنان لإبداعك. ارسم وخطط وصور أفكارك على لوحة رقمية حرة.';

  @override
  String get featuresNotesDesc => 'إنشاء وإدارة الملاحظات الخاصة بك';

  @override
  String get featuresTodosDesc => 'تتبع المهام الخاصة بك';

  @override
  String get featuresExpensesDesc => 'مراقبة النفقات الخاصة بك';

  @override
  String get featuresJournalDesc => 'اكتتب أفكارك';

  @override
  String get featuresCalendarDesc => 'نظم جدولك الزمني';

  @override
  String get featuresClipboardDesc => 'الوصول إلى سجل الحافظة الخاص بك';

  @override
  String get featuresCanvasDesc => 'ارسم وخطط بحرية';

  @override
  String get featuresSocialPost => 'منشور اجتماعي';

  @override
  String get featuresSocialPostDesc =>
      'إنشاء محتوى جذاب لوسائل التواصل الاجتماعي';

  @override
  String get chooseYourAura => 'اختر هالتك';

  @override
  String get expressYourselfTheme => 'عبر عن نفسك بلون مظهر جديد!';

  @override
  String get level => 'المستوى';

  @override
  String get xpToNextLevel => 'XP للمستوى التالي';

  @override
  String get checkUpcomingEvents => 'تحقق من الأحداث القادمة';

  @override
  String get startNewSketch => 'بدأ رسمة جديدة';

  @override
  String get noTransactionsMonth => 'لا توجد معاملات هذا الشهر';

  @override
  String transactionsThisMonth(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count معاملات هذا الشهر',
      few: '$count معاملات هذا الشهر',
      two: 'معاملتان هذا الشهر',
      one: 'معاملة واحدة هذا الشهر',
      zero: 'لا توجد معاملات هذا الشهر',
    );
    return '$_temp0';
  }

  @override
  String get autoSaveClipboard => 'حفظ تلقائي للحافظة';

  @override
  String get autoSaveClipboardDesc => 'حفظ العناصر المنسوخة تلقائياً';

  @override
  String get permissionDeniedSettings =>
      'تم رفض الإذن بشكل دائم. يرجى تفعيله من الإعدادات.';

  @override
  String get notificationsEnabled => 'تم تفعيل الإشعارات!';

  @override
  String get redirectingToSettings =>
      'جارٍ التوجيه إلى الإعدادات لتعطيل الإشعارات...';

  @override
  String get premiumAccess => 'وصول بريميوم';

  @override
  String get premiumActiveUntil => 'بريميوم نشط حتى';

  @override
  String get unlockAllFeatures => 'فتح جميع الميزات';

  @override
  String get buyPremium => 'شراء بريميوم (7 أيام)';

  @override
  String costCoins(Object cost) {
    return 'التكلفة: $cost عملات';
  }

  @override
  String get premiumActivated => 'تم تفعيل البريميوم لمدة 7 أيام!';

  @override
  String get premiumActive => 'البريميوم نشط';

  @override
  String get expires => 'تنتهي الصلاحية:';

  @override
  String get temporaryAccess => 'وصول مؤقت';

  @override
  String get journalExpression => 'يوميات وتعبير';

  @override
  String get artisticDesigns => 'تصاميم فنية';

  @override
  String get artisticDesignsDesc =>
      'فتح أكثر من 10 مظاهر فريدة لبطاقات اليوميات';

  @override
  String get premiumLayouts => 'تخطيطات بريميوم';

  @override
  String get premiumLayoutsDesc => 'طرق حصرية لعرض ذكرياتك';

  @override
  String get calendarTools => 'تقويم وأدوات';

  @override
  String get fullCalendar => 'تقويم كامل';

  @override
  String get fullCalendarDesc => 'نظام متكامل لإدارة الأحداث';

  @override
  String get clipboardAutoSaveDesc => 'التقاط سجل الحافظة في الخلفية';

  @override
  String get proWidgets => 'أدوات ذكية للمحترفين';

  @override
  String get proWidgetsDesc => 'جميع الميزات متوفرة على شاشتك الرئيسية';

  @override
  String get dataExport => 'البيانات والتصدير';

  @override
  String get advancedBackup => 'نسخ احتياطي متقدم';

  @override
  String get advancedBackupDesc => 'استيراد/تصدير آمن لجميع البيانات';

  @override
  String get pdfExport => 'تصدير إلى PDF';

  @override
  String get pdfExportDesc => 'تصدير الملاحظات واليوميات إلى PDF';

  @override
  String get printReady => 'جاهز للطباعة';

  @override
  String get printReadyDesc => 'دعم الطباعة المباشرة';

  @override
  String get richTextEditor => 'محرر نص غني';

  @override
  String get advancedSearch => 'بحث متقدم';

  @override
  String get advancedSearchDesc => 'البحث والاستبدال داخل النص';

  @override
  String get richMedia => 'وسائط غنية';

  @override
  String get richMediaDesc => 'إدراج صور وفيديوهات وروابط';

  @override
  String get editorStyling => 'تنسيق المحرر';

  @override
  String get editorStylingDesc => 'نص مخصص وخلفيات للمحرر';

  @override
  String get balance => 'الرصيد';

  @override
  String get loadingAd => 'جارٍ تحميل الإعلان...';

  @override
  String watchAd(Object amount) {
    return 'مشاهدة إعلان (+$amount)';
  }

  @override
  String get loadAd => 'تحميل إعلان';

  @override
  String get backupDataDesc => 'حفظ ملف JSON لبياناتك';

  @override
  String get importDataDesc => 'دمج ملف نسخة احتياطية في CopyClip';

  @override
  String get notificationPermissionDenied => 'تم رفض إذن الإشعارات.';

  @override
  String get typeNewTask => 'اكتب مهمة جديدة...';

  @override
  String get addTask => 'إضافة مهمة';

  @override
  String get completed => 'مكتمل';

  @override
  String get greatJob => 'عمل رائع!';

  @override
  String youEarnedXPNextTask(Object amount, Object date) {
    return 'لقد ربحت $amount XP! المهمة التالية: $date';
  }

  @override
  String taskCompletedXP(Object amount) {
    return 'تمت المهمة! +$amount XP';
  }

  @override
  String get moveTasksToRecycleBin =>
      'نقل جميع المهام النشطة إلى سلة المحذوفات؟';

  @override
  String get deleteAllPosts => 'حذف جميع المنشورات';

  @override
  String get deleteAllPostsConfirmation =>
      'هل أنت متأكد أنك تريد حذف جميع المنشورات الاجتماعية؟ لا يمكن التراجع عن هذا الإجراء.';

  @override
  String get allPosts => 'جميع المنشورات';

  @override
  String get favorites => 'المفضلة';

  @override
  String get drafts => 'المسودات';

  @override
  String get noFavoritesYet => 'لا توجد مفضلات بعد';

  @override
  String get noDraftsYet => 'لا توجد مسودات بعد';

  @override
  String get startSocialJourney => 'ابدأ رحلتك الاجتماعية!';

  @override
  String get draft => 'مسودة';

  @override
  String attachmentCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count مرفقات',
      few: '$count مرفقات',
      two: 'مرفقان',
      one: 'مرفق واحد',
      zero: 'لا توجد مرفقات',
    );
    return '$_temp0';
  }

  @override
  String get pleaseAddContent => 'يرجى إضافة بعض المحتوى أو الوسائط للمشاركة';

  @override
  String fileNotFoundError(Object path) {
    return 'خطأ: لم يتم العثور على الملف في $path';
  }

  @override
  String get checkFacebookApp => 'تحقق من تطبيق فيسبوك';

  @override
  String get systemShare => 'مشاركة النظام';

  @override
  String get socialPost => 'منشور اجتماعي';

  @override
  String get favorite => 'مفضل';

  @override
  String get saveDraft => 'حفظ المسودة';

  @override
  String get entryCopied => 'تم نسخ المدخل';

  @override
  String get moveEntriesToRecycleBin =>
      'نقل جميع المدخلات النشطة إلى سلة المحذوفات؟';

  @override
  String get startWritingStory => 'ابدأ بكتابة قصتك';

  @override
  String get recordMemories => 'سجل ذكرياتك ومشاعرك اليومية.';

  @override
  String get writeJournal => 'اكتب يومياتك';

  @override
  String get myMemories => 'ذكرياتي';

  @override
  String get sortJournal => 'فرز اليوميات';

  @override
  String get byMood => 'حسب المزاج';

  @override
  String get searchMemories => 'بحث في الذكريات...';

  @override
  String get selectAll => 'تحديد الكل';

  @override
  String get deleteSelected => 'حذف المحدد';

  @override
  String get taskCompletedExclamation => 'تمت المهمة!';

  @override
  String get taskUncompletedExclamation => 'مهمة غير مكتملة';

  @override
  String get clipboardUpdatedExclamation => 'تم تحديث الحافظة!';

  @override
  String clipboardSavedContent(Object content) {
    return 'تم حفظ في الحافظة: $content';
  }

  @override
  String get overview => 'نظرة عامة';

  @override
  String get colorAurora => 'أورورا';

  @override
  String get colorCosmic => 'كوني';

  @override
  String get colorNebula => 'سديم';

  @override
  String get colorStarlight => 'ضوء النجوم';

  @override
  String get colorSolar => 'شمسي';

  @override
  String get colorNova => 'نوفا';

  @override
  String get loadingStepLoading => 'جارٍ التحميل...';

  @override
  String get loadingStepDatabase => 'إعداد قاعدة البيانات...';

  @override
  String get loadingStepSystem => 'تكوين النظام...';

  @override
  String get loadingStepReady => 'جاهز';

  @override
  String get productivityCompanion => 'رفيقك للإنتاجية';

  @override
  String get done => 'تم';

  @override
  String get newNote => 'ملاحظة جديدة';

  @override
  String get changeColor => 'تغيير اللون';

  @override
  String get copyContent => 'نسخ المحتوى';

  @override
  String get titleOptional => 'العنوان (اختياري)';

  @override
  String get exportAsPdf => 'تصدير كـ PDF';

  @override
  String get taskDueNow => 'موعد المهمة الآن';

  @override
  String get moveTaskToBinTitle => 'نقل المهمة إلى سلة المحذوفات؟';

  @override
  String get restoreTaskLater =>
      'يمكنك استعادة هذه المهمة لاحقًا من الإعدادات.';

  @override
  String get newTask => 'مهمة جديدة';

  @override
  String get editTask => 'تعديل المهمة';

  @override
  String get undo => 'تراجع';

  @override
  String get redo => 'إعادة';

  @override
  String get category => 'الفئة';

  @override
  String get categoryHint => 'مثال: العمل، النادي';

  @override
  String get whatNeedsToBeDone => 'ما الذي يجب القيام به؟';

  @override
  String get enterTaskDetails => 'أدخل تفاصيل المهمة...';

  @override
  String get setDueDate => 'تحديد موعد الاستحقاق';

  @override
  String get dueDate => 'موعد الاستحقاق';

  @override
  String get expenseTitle => 'النفقات';

  @override
  String searchInCurrency(String currency) {
    return 'بحث في $currency...';
  }

  @override
  String get sortAndFilter => 'فرز وتصفية';

  @override
  String get sortBy => 'فرز حسب';

  @override
  String get highestAmount => 'أعلى مبلغ';

  @override
  String get lowestAmount => 'أقل مبلغ';

  @override
  String get moreFilters => 'مزيد من الفلاتر...';

  @override
  String get filterExpenses => 'تصفية النفقات';

  @override
  String get transactionType => 'نوع المعاملة';

  @override
  String get categories => 'الفئات';

  @override
  String get all => 'الكل';

  @override
  String get income => 'الدخل';

  @override
  String get expense => 'المصروفات';

  @override
  String get reset => 'إعادة تعيين';

  @override
  String get apply => 'تطبيق';

  @override
  String newExpense(String currency) {
    return 'جديد $currency';
  }

  @override
  String errorLoadingData(String error) {
    return 'حدث خطأ أثناء تحميل البيانات.\n\n$error';
  }

  @override
  String get dailyQuote1 => 'أفضل طريقة للتنبؤ بالمستقبل هي أن تصنعه.';

  @override
  String get dailyQuote2 => 'الغنى ليس في كثرة العرض، ولكن الغنى غنى النفس.';

  @override
  String get dailyQuote3 => 'الوقت هو العملة الأغلى.';

  @override
  String get dailyQuote4 => 'النجاح ليس نهائياً، والفشل ليس قاتلاً.';

  @override
  String get dailyQuote5 => 'ركز على الحل، وليس المشكلة.';

  @override
  String get dailyQuote6 => 'شبكة علاقاتك هي ثروتك الحقيقية.';

  @override
  String get moodHappy => 'سعيد';

  @override
  String get moodExcited => 'متحمس';

  @override
  String get moodNeutral => 'محايد';

  @override
  String get moodSad => 'حزين';

  @override
  String get moodStressed => 'متوتر';

  @override
  String exportDate(String date) {
    return '📅 $date';
  }

  @override
  String exportMood(String emoji, String mood) {
    return 'المزاج: $emoji $mood';
  }

  @override
  String exportTitle(String title) {
    return 'العنوان: $title';
  }

  @override
  String exportTags(String tags) {
    return '\nالوسوم: $tags';
  }

  @override
  String get instagram => 'إنستغرام';

  @override
  String get facebook => 'فيسبوك';

  @override
  String get tiktok => 'تيك توك';

  @override
  String get newSketch => 'رسمة جديدة';

  @override
  String get searchSketches => 'البحث في الرسومات والمجلدات...';

  @override
  String get noResultsFound => 'لم يتم العثور على نتائج';

  @override
  String get noItems => 'لا توجد عناصر';

  @override
  String get noDrawingsYet => 'لا توجد رسومات بعد';

  @override
  String get canvasIntro => 'أطلق العنان لإبداعك على اللوحة!';

  @override
  String get newCanvas => 'لوحة جديدة';

  @override
  String get rename => 'إعادة تسمية';

  @override
  String get deleteFolder => 'حذف المجلد';

  @override
  String get deleteSketchesQuestion => 'حذف الرسومات؟';

  @override
  String get deleteFolderConfirmation =>
      'سيتم حذف جميع الرسومات في هذا المجلد نهائياً.';

  @override
  String get renameFolder => 'إعادة تسمية المجلد';

  @override
  String get chooseColor => 'اختر لوناً';

  @override
  String get deleteFolderQuestion => 'حذف المجلد؟';

  @override
  String get searchClips => 'البحث في القصاصات...';

  @override
  String get clipboardEmpty => 'الحافظة فارغة';

  @override
  String get addItem => 'إضافة عنصر';

  @override
  String get clipColor => 'لون القصاصة';

  @override
  String get newClip => 'قصاصة جديدة';

  @override
  String get editClip => 'تعديل القصاصة';

  @override
  String get restoreClipLater => 'يمكنك استعادة هذه القصاصة لاحقاً.';

  @override
  String get upcomingEvents => 'الأحداث القادمة';

  @override
  String get dataDistribution => 'توزيع البيانات';

  @override
  String get taskProgress => 'تقدم المهمة';

  @override
  String get quickStats => 'إحصيات سريعة';

  @override
  String get taskCompletion => 'إكمال المهمة';

  @override
  String get noItemsForDate => 'لا توجد عناصر لهذا التاريخ';

  @override
  String get enjoyFreeTime => 'استمتع بوقت فراغك!';

  @override
  String get searchThisDay => 'البحث في هذا اليوم...';

  @override
  String get finance => 'المالية';

  @override
  String get permanentlyDelete => 'حذف نهائي؟';

  @override
  String deleteSelectionConfirmation(int foldersCount, int sketchesCount) {
    return 'سيؤدي هذا إلى حذف $foldersCount مجلدات (ورسماتها) و $sketchesCount رسومات أخرى نهائياً.\n\nلا يمكن التراجع عن هذا الإجراء.';
  }

  @override
  String get deleteForever => 'حذف للأبد';

  @override
  String selectedCount(int count) {
    return '$count محدد';
  }

  @override
  String canvasStats(int notes, int folders) {
    return '$notes رسومات • $folders مجلدات';
  }

  @override
  String get sortItems => 'فرز العناصر';

  @override
  String get sortNameAZ => 'الاسم (أ-ي)';

  @override
  String get sortNameZA => 'الاسم (ي-أ)';

  @override
  String get createFolder => 'إنشاء مجلد';

  @override
  String get folderNameHint => 'اسم المجلد...';

  @override
  String deleteSketchesConfirmation(int count) {
    return 'حذف $count رسومات؟ لا يمكن التراجع عن هذا الإجراء.';
  }

  @override
  String get noSketchesFound => 'لم يتم العثور على رسومات';

  @override
  String get noSketchesFoundSub => 'حاول تعديل بحثك أو إنشاء رسمة جديدة.';

  @override
  String searchInFolder(String folder) {
    return 'بحث في $folder...';
  }

  @override
  String sketchesCount(int count) {
    return '$count رسومات';
  }

  @override
  String get sortSketches => 'فرز الرسومات';

  @override
  String get calendarScreenTitle => 'التقويم';

  @override
  String get dailyActivity => 'النشاط اليومي';

  @override
  String get deleteItemQuestion => 'حذف العنصر؟';

  @override
  String get deleteItemConfirmation =>
      'سيؤدي هذا إلى نقل العنصر إلى سلة المحذوفات.';

  @override
  String get moveToBinItem => 'نقل إلى السلة؟';

  @override
  String get moveToBinConfirmation => 'يمكنك استعادته لاحقاً.';

  @override
  String selectedItems(int count) {
    return '$count محدد';
  }

  @override
  String get recentClips => 'القصاصات الأخيرة';

  @override
  String get copied => 'تم النسخ!';

  @override
  String get copiedPlainText => 'تم نسخ النص المجرد';

  @override
  String get clipTheme => 'مظهر القصاصة';

  @override
  String get justNow => 'الآن';

  @override
  String minutesAgo(Object count) {
    return 'منذ $count د';
  }

  @override
  String hoursAgo(Object count) {
    return 'منذ $count س';
  }

  @override
  String daysAgo(Object count) {
    return 'منذ $count ي';
  }

  @override
  String get noTasksFound => 'لم يتم العثور على مهام.';

  @override
  String get searchTasks => 'بحث في المهام...';

  @override
  String get taskReminder => 'تذكير بالمهمة';

  @override
  String get untitledNote => 'ملاحظة بدون عنوان';

  @override
  String get dailyEntry => 'مدخل يومي';

  @override
  String get clipboardHistory => 'سجل الحافظة';

  @override
  String get deletePermanentlyContent => 'هذا الإجراء لا يمكن التراجع عنه.';

  @override
  String get emptyRecycleBinTitle => 'إفراغ سلة المحذوفات؟';

  @override
  String emptyRecycleBinContent(Object count) {
    return 'سيتم حذف جميع العناصر الـ $count نهائياً.';
  }

  @override
  String get emptyBin => 'إفراغ السلة';

  @override
  String get recycleBinEmpty => 'سلة المحذوفات فارغة';

  @override
  String get deletedItemsAppearHere => 'العناصر المحذوفة ستظهر هنا.';

  @override
  String get empty => 'فارغ';

  @override
  String get recent => 'الأخيرة';

  @override
  String categoryLabel(Object category) {
    return 'الفئة: $category';
  }

  @override
  String get general => 'عام';

  @override
  String get saveTransactionQuestion => 'هل تريد حفظ هذه المعاملة؟';

  @override
  String get fillTitleAmount => 'يرجى ملء العنوان والمبلغ';

  @override
  String get invalidAmount => 'تنسيق المبلغ غير صالح';

  @override
  String get moveTransactionToBinTitle => 'نقل المعاملة إلى سلة المحذوفات؟';

  @override
  String get restoreTransactionLater =>
      'يمكنك استعادة هذه المعاملة لاحقاً من الإعدادات.';

  @override
  String get newTransaction => 'معاملة جديدة';

  @override
  String get whatIsThisFor => 'فيما هذا؟';

  @override
  String get description => 'الوصف';

  @override
  String get daily => 'يومياً';

  @override
  String get weekly => 'أسبوعياً';

  @override
  String get monthly => 'شهرياً';

  @override
  String get yearly => 'سنوياً';

  @override
  String get totalIncome => 'إجمالي الدخل';

  @override
  String get totalExpense => 'إجمالي النفقات';

  @override
  String get analysis => 'التحليل';

  @override
  String get transactions => 'المعاملات';

  @override
  String get noExpensesFound => 'لم يتم العثور على نفقات لهذه الفترة.';

  @override
  String get netBalance => 'صافي الرصيد';

  @override
  String get topCategories => 'أبرز الفئات';

  @override
  String get spendingTrend => 'اتجاه الإنفاق';

  @override
  String get insights => 'رؤى';

  @override
  String get noExpensesRecorded => 'لم يتم تسجيل أي نفقات';

  @override
  String get trackSpendingHabits => 'تتبع عادات الإنفاق الخاصة بك بسهولة.';

  @override
  String get addExpense => 'إضافة نفقة';

  @override
  String get noDataForPeriod => 'لا توجد بيانات لهذه الفترة';

  @override
  String get budget => 'الميزانية';

  @override
  String get spent => 'تم صرفه';

  @override
  String get limit => 'الحد';

  @override
  String get overBudget => 'تجاوز الميزانية!';

  @override
  String remainingBudget(Object percent) {
    return 'متبقي $percent%';
  }

  @override
  String get savingsRate => 'معدل الادخار';

  @override
  String get healthScore => 'درجة الصحة المالية';

  @override
  String get healthScoreExplanation =>
      'هذه الدرجة تعتمد على معدل ادخارك.\n\n• ادخار > 50% = ممتاز (100)\n• ادخار 0% = متوسط (50)\n• الإنفاق > الدخل = ضعيف (<50)';

  @override
  String get ok => 'موافق';

  @override
  String get bulkImport => 'استيراد بالجملة';
}

/// The translations for Arabic, as used in Egypt (`ar_EG`).
class AppLocalizationsArEg extends AppLocalizationsAr {
  AppLocalizationsArEg() : super('ar_EG');

  @override
  String get settings => 'إعدادات';

  @override
  String get language => 'لغة';

  @override
  String get systemDefault => 'النظام الافتراضي';

  @override
  String get notes => 'ملحوظات';

  @override
  String get todos => 'المهام';

  @override
  String get expenses => 'نفقات';

  @override
  String get journal => 'مجلة';

  @override
  String get calendar => 'تقويم';

  @override
  String get clipboard => 'الحافظة';

  @override
  String get canvas => 'قماش';

  @override
  String get save => 'حفظ';

  @override
  String get create => 'إنشاء';

  @override
  String get cancel => 'إلغاء';

  @override
  String get delete => 'حذف';

  @override
  String get edit => 'تعديل';

  @override
  String get share => 'مشاركة';

  @override
  String get copy => 'نسخ';

  @override
  String get unsavedChanges => 'تغييرات غير محفوظة';

  @override
  String get confirmDelete => 'تأكيد الحذف';

  @override
  String get discard => 'تجاهل';

  @override
  String get createPost => 'إنشاء منشور';

  @override
  String get post => 'منشور';

  @override
  String get postingTo => 'النشر في';

  @override
  String get whatsOnYourMind => 'ماذا يدور في ذهنك؟';

  @override
  String get pickImages => 'اختر صورًا';

  @override
  String get pickVideo => 'اختر فيديو';

  @override
  String get camera => 'كاميرا';

  @override
  String get gallery => 'معرض الصور';

  @override
  String get search => 'بحث';

  @override
  String get pleaseEnterTask => 'يرجى إدخال مهمة';

  @override
  String get deleteTask => 'حذف المهمة';

  @override
  String get selectItems => 'حدد العناصر';

  @override
  String get deleteAll => 'حذف الكل';

  @override
  String error(Object error) {
    return 'خطأ: $error';
  }

  @override
  String get orderingOnlyAvailableInAllPosts =>
      'الترتيب متاح فقط في \"جميع المنشورات\"';

  @override
  String get deletePost => 'حذف المنشور';

  @override
  String get postDeleted => 'تم حذف المنشور';

  @override
  String get premiumFeatures => 'ميزات بريميوم';

  @override
  String get manageCoinsAdsPremium =>
      'إدارة العملات والإعلانات وحالة البريميوم';

  @override
  String get themeMode => 'وضع المظهر';

  @override
  String get accentColor => 'لون التمييز';

  @override
  String get backgroundDesign => 'تصميم الخلفية';

  @override
  String get pushNotifications => 'إشعارات الدفع';

  @override
  String get recycleBin => 'سلة المحذوفات';

  @override
  String get exportData => 'تصدير البيانات';

  @override
  String get importData => 'استيراد البيانات';

  @override
  String get rateApp => 'تقييم التطبيق';

  @override
  String get sendFeedback => 'إرسال تعليقات';

  @override
  String get privacyPolicy => 'سياسة الخصوصية';

  @override
  String get version => 'الإصدار';

  @override
  String get buildNumber => 'رقم البناء';

  @override
  String get system => 'النظام';

  @override
  String get light => 'فاتح';

  @override
  String get dark => 'داكن';

  @override
  String get itemRestored => 'تمت استعادة العنصر';

  @override
  String get recycleBinCleared => 'تم إفراغ سلة المحذوفات بنجاح';

  @override
  String get allPostsDeleted => 'تم حذف جميع المنشورات';

  @override
  String get newPost => 'منشور جديد';

  @override
  String get textCopiedToClipboardFacebook =>
      'تم نسخ النص إلى الحافظة (سياسة فيسبوك)';

  @override
  String get tiktokSharingRequiresVideoImage =>
      'تتطلب مشاركة TikTok فيديو/صورة';

  @override
  String errorSharing(Object error) {
    return 'خطأ في المشاركة: $error';
  }

  @override
  String shareToStory(Object platform) {
    return 'مشاركة في قصة $platform';
  }

  @override
  String shareToFeed(Object platform) {
    return 'مشاركة في موجز $platform';
  }

  @override
  String get unlockPermanently => 'فتح بشكل دائم';

  @override
  String get notEnoughCoins => 'لا توجد عملات كافية!';

  @override
  String youEarnedCoins(Object amount) {
    return 'لقد ربحت $amount من العملات!';
  }

  @override
  String get contentCopied => 'تم نسخ المحتوى';

  @override
  String get selectDateTime => 'حدد التاريخ والوقت';

  @override
  String get areYouSureYouWantToDeleteThisPost =>
      'هل أنت متأكد أنك تريد حذف هذا المنشور؟';

  @override
  String get socialPosts => 'منشورات اجتماعية';

  @override
  String get watchAdToEarnCoins => 'شاهد إعلانًا لربح العملات';

  @override
  String get premiumUnlocked => 'تم فتح البريميوم';

  @override
  String get removeAds => 'إزالة الإعلانات';

  @override
  String get unlimitedCloudStorage => 'تخزين سحابي غير محدود';

  @override
  String get deleteNote => 'حذف الملاحظة';

  @override
  String get shareNote => 'مشاركة الملاحظة';

  @override
  String get editNote => 'تعديل الملاحظة';

  @override
  String get searchNotes => 'البحث في الملاحظات...';

  @override
  String get noNotesFound => 'لم يتم العثور على ملاحظات';

  @override
  String get captureThoughts => 'سجل أفكارك فورا.';

  @override
  String get createNote => 'إنشاء ملاحظة';

  @override
  String get customOrder => 'ترتيب مخصص';

  @override
  String get newestFirst => 'الأحدث أولاً';

  @override
  String get oldestFirst => 'الأقدم أولاً';

  @override
  String get titleAZ => 'العنوان: أ-ي';

  @override
  String get titleZA => 'العنوان: ي-أ';

  @override
  String get deleteAllQuestion => 'حذف الكل؟';

  @override
  String get moveToRecycleBin => 'نقل جميع الملاحظات إلى سلة المحذوفات؟';

  @override
  String get moveToBinQuestion => 'نقل إلى السلة؟';

  @override
  String get restoreNoteLater => 'يمكنك استعادة هذه الملاحظة لاحقًا.';

  @override
  String get move => 'نقل';

  @override
  String get myThoughts => 'أفكاري';

  @override
  String get selected => 'محدد';

  @override
  String get noContent => 'لا يوجد محتوى';

  @override
  String get untitled => 'بدون عنوان';

  @override
  String get chooseWallpapers => 'اختر من بين أكثر من 10 خلفيات ديناميكية';

  @override
  String get backupData => 'نسخ احتياطي للبيانات';

  @override
  String get saveJsonFile => 'هل تريد حفظ ملف JSON يحتوي على جميع بياناتك؟';

  @override
  String get exportNow => 'تصدير الآن';

  @override
  String get importDataTitle => 'استيراد البيانات';

  @override
  String get mergeBackupFile =>
      'هل تريد دمج ملف النسخ الاحتياطي مع العناصر الحالية؟';

  @override
  String get selectFile => 'حدد ملفاً';

  @override
  String get backupSaved => 'تم حفظ النسخة الاحتياطية بنجاح!';

  @override
  String get exportFailed => 'فشل التصدير.';

  @override
  String importSuccess(Object count) {
    return 'تمت استعادة $count من العناصر بنجاح!';
  }

  @override
  String get importFailed => 'فشل الاستيراد.';

  @override
  String widgetAdded(String widget) {
    return 'تمت إضافة الأداة $widget إلى الشاشة الرئيسية!';
  }

  @override
  String get widgetRequestSent =>
      'تم إرسال طلب الأداة. يرجى التحقق من الشاشة الرئيسية.';

  @override
  String get widgetAddFailed => 'فشل إضافة الأداة';

  @override
  String get autoSaveEnabled => 'تم تفعيل الحفظ التلقائي.';

  @override
  String get autoSaveDisabled => 'تم تعطيل الحفظ التلقائي.';

  @override
  String get homeScreenWidgets => 'أدوات الشاشة الرئيسية';

  @override
  String get notificationsTitle => 'الإشعارات';

  @override
  String get dataBackup => 'البيانات والنسخ الاحتياطي';

  @override
  String get feedbackSupport => 'التعليقات والدعم';

  @override
  String get creditsTitle => 'الاعتمادات';

  @override
  String get privacyMaintenance => 'الخصوصية والصيانة';

  @override
  String get aboutTitle => 'حول';

  @override
  String get premium => 'بريميوم';

  @override
  String get appearanceTitle => 'المظهر';

  @override
  String get clipboardTitle => 'الحافظة';

  @override
  String get settingsSubtitle => 'تخصيص تجربتك';

  @override
  String get welcomeTitle => 'مرحبًا بك في CopyClip';

  @override
  String get welcomeDescription =>
      'رفيقك النهائي للإنتاجية. دعنا نجهزك بأدوات قوية لإدارة يومك.';

  @override
  String get onboardingNotesTitle => 'ملاحظات ذكية';

  @override
  String get onboardingNotesDesc =>
      'التقط الأفكار فورًا بتنسيق نص غني. نظم أفكارك ولا تفقد أي فكرة رائعة مرة أخرى.';

  @override
  String get onboardingTodosTitle => 'إدارة المهام';

  @override
  String get onboardingTodosDesc =>
      'ابق مطلعاً على أمورك. أنشئ قوائم مهام، وحدد الأولويات، وحقق أهدافك خطوة بخطوة.';

  @override
  String get onboardingExpensesTitle => 'تتبع النفقات';

  @override
  String get onboardingExpensesDesc =>
      'تحكم في أموالك. تتبع الدخل والنفقات بسهولة لفهم عادات الإنفاق الخاصة بك.';

  @override
  String get onboardingJournalTitle => 'يوميات شخصية';

  @override
  String get onboardingJournalDesc =>
      'تأمل في يومك. مساحة خاصة لتدوين ذكرياتك ومشاعرك وتجاربك اليومية.';

  @override
  String get onboardingCalendarTitle => 'التقويم والأحداث';

  @override
  String get onboardingCalendarDesc =>
      'لا تفوت أي لحظة. نظم جدولك وتابع الأحداث الهامة القادمة.';

  @override
  String get onboardingClipboardTitle => 'مدير الحافظة';

  @override
  String get onboardingClipboardDesc =>
      'انسخ مرة واحدة، والصق في أي مكان. الوصول إلى سجل الحافظة لاستعادة النصوص التي نسختها سابقاً.';

  @override
  String get onboardingCanvasTitle => 'لوحة إبداعية';

  @override
  String get onboardingCanvasDesc =>
      'أطلق العنان لإبداعك. ارسم وخطط وصور أفكارك على لوحة رقمية حرة.';

  @override
  String get featuresNotesDesc => 'إنشاء وإدارة الملاحظات الخاصة بك';

  @override
  String get featuresTodosDesc => 'تتبع المهام الخاصة بك';

  @override
  String get featuresExpensesDesc => 'مراقبة النفقات الخاصة بك';

  @override
  String get featuresJournalDesc => 'اكتتب أفكارك';

  @override
  String get featuresCalendarDesc => 'نظم جدولك الزمني';

  @override
  String get featuresClipboardDesc => 'الوصول إلى سجل الحافظة الخاص بك';

  @override
  String get featuresCanvasDesc => 'ارسم وخطط بحرية';

  @override
  String get featuresSocialPost => 'منشور اجتماعي';

  @override
  String get featuresSocialPostDesc =>
      'إنشاء محتوى جذاب لوسائل التواصل الاجتماعي';

  @override
  String get chooseYourAura => 'اختر هالتك';

  @override
  String get expressYourselfTheme => 'عبر عن نفسك بلون مظهر جديد!';

  @override
  String get level => 'المستوى';

  @override
  String get xpToNextLevel => 'XP للمستوى التالي';

  @override
  String get checkUpcomingEvents => 'تحقق من الأحداث القادمة';

  @override
  String get startNewSketch => 'بدأ رسمة جديدة';

  @override
  String get noTransactionsMonth => 'لا توجد معاملات هذا الشهر';

  @override
  String transactionsThisMonth(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count معاملات هذا الشهر',
      few: '$count معاملات هذا الشهر',
      two: 'معاملتان هذا الشهر',
      one: 'معاملة واحدة هذا الشهر',
      zero: 'لا توجد معاملات هذا الشهر',
    );
    return '$_temp0';
  }

  @override
  String get autoSaveClipboard => 'حفظ تلقائي للحافظة';

  @override
  String get autoSaveClipboardDesc => 'حفظ العناصر المنسوخة تلقائياً';

  @override
  String get permissionDeniedSettings =>
      'تم رفض الإذن بشكل دائم. يرجى تفعيله من الإعدادات.';

  @override
  String get notificationsEnabled => 'تم تفعيل الإشعارات!';

  @override
  String get redirectingToSettings =>
      'جارٍ التوجيه إلى الإعدادات لتعطيل الإشعارات...';

  @override
  String get premiumAccess => 'وصول بريميوم';

  @override
  String get premiumActiveUntil => 'بريميوم نشط حتى';

  @override
  String get unlockAllFeatures => 'فتح جميع الميزات';

  @override
  String get buyPremium => 'شراء بريميوم (7 أيام)';

  @override
  String costCoins(Object cost) {
    return 'التكلفة: $cost عملات';
  }

  @override
  String get premiumActivated => 'تم تفعيل البريميوم لمدة 7 أيام!';

  @override
  String get premiumActive => 'البريميوم نشط';

  @override
  String get expires => 'تنتهي الصلاحية:';

  @override
  String get temporaryAccess => 'وصول مؤقت';

  @override
  String get journalExpression => 'يوميات وتعبير';

  @override
  String get artisticDesigns => 'تصاميم فنية';

  @override
  String get artisticDesignsDesc =>
      'فتح أكثر من 10 مظاهر فريدة لبطاقات اليوميات';

  @override
  String get premiumLayouts => 'تخطيطات بريميوم';

  @override
  String get premiumLayoutsDesc => 'طرق حصرية لعرض ذكرياتك';

  @override
  String get calendarTools => 'تقويم وأدوات';

  @override
  String get fullCalendar => 'تقويم كامل';

  @override
  String get fullCalendarDesc => 'نظام متكامل لإدارة الأحداث';

  @override
  String get clipboardAutoSaveDesc => 'التقاط سجل الحافظة في الخلفية';

  @override
  String get proWidgets => 'أدوات ذكية للمحترفين';

  @override
  String get proWidgetsDesc => 'جميع الميزات متوفرة على شاشتك الرئيسية';

  @override
  String get dataExport => 'البيانات والتصدير';

  @override
  String get advancedBackup => 'نسخ احتياطي متقدم';

  @override
  String get advancedBackupDesc => 'استيراد/تصدير آمن لجميع البيانات';

  @override
  String get pdfExport => 'تصدير إلى PDF';

  @override
  String get pdfExportDesc => 'تصدير الملاحظات واليوميات إلى PDF';

  @override
  String get printReady => 'جاهز للطباعة';

  @override
  String get printReadyDesc => 'دعم الطباعة المباشرة';

  @override
  String get richTextEditor => 'محرر نص غني';

  @override
  String get advancedSearch => 'بحث متقدم';

  @override
  String get advancedSearchDesc => 'البحث والاستبدال داخل النص';

  @override
  String get richMedia => 'وسائط غنية';

  @override
  String get richMediaDesc => 'إدراج صور وفيديوهات وروابط';

  @override
  String get editorStyling => 'تنسيق المحرر';

  @override
  String get editorStylingDesc => 'نص مخصص وخلفيات للمحرر';

  @override
  String get balance => 'الرصيد';

  @override
  String get loadingAd => 'جارٍ تحميل الإعلان...';

  @override
  String watchAd(Object amount) {
    return 'مشاهدة إعلان (+$amount)';
  }

  @override
  String get loadAd => 'تحميل إعلان';

  @override
  String get backupDataDesc => 'حفظ ملف JSON لبياناتك';

  @override
  String get importDataDesc => 'دمج ملف نسخة احتياطية في CopyClip';

  @override
  String get notificationPermissionDenied => 'تم رفض إذن الإشعارات.';

  @override
  String get typeNewTask => 'اكتب مهمة جديدة...';

  @override
  String get addTask => 'إضافة مهمة';

  @override
  String get completed => 'مكتمل';

  @override
  String get greatJob => 'عمل رائع!';

  @override
  String youEarnedXPNextTask(Object amount, Object date) {
    return 'لقد ربحت $amount XP! المهمة التالية: $date';
  }

  @override
  String taskCompletedXP(Object amount) {
    return 'تمت المهمة! +$amount XP';
  }

  @override
  String get moveTasksToRecycleBin =>
      'نقل جميع المهام النشطة إلى سلة المحذوفات؟';

  @override
  String get deleteAllPosts => 'حذف جميع المنشورات';

  @override
  String get deleteAllPostsConfirmation =>
      'هل أنت متأكد أنك تريد حذف جميع المنشورات الاجتماعية؟ لا يمكن التراجع عن هذا الإجراء.';

  @override
  String get allPosts => 'جميع المنشورات';

  @override
  String get favorites => 'المفضلة';

  @override
  String get drafts => 'المسودات';

  @override
  String get noFavoritesYet => 'لا توجد مفضلات بعد';

  @override
  String get noDraftsYet => 'لا توجد مسودات بعد';

  @override
  String get startSocialJourney => 'ابدأ رحلتك الاجتماعية!';

  @override
  String get draft => 'مسودة';

  @override
  String attachmentCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count مرفقات',
      few: '$count مرفقات',
      two: 'مرفقان',
      one: 'مرفق واحد',
      zero: 'لا توجد مرفقات',
    );
    return '$_temp0';
  }

  @override
  String get pleaseAddContent => 'يرجى إضافة بعض المحتوى أو الوسائط للمشاركة';

  @override
  String fileNotFoundError(Object path) {
    return 'خطأ: لم يتم العثور على الملف في $path';
  }

  @override
  String get checkFacebookApp => 'تحقق من تطبيق فيسبوك';

  @override
  String get systemShare => 'مشاركة النظام';

  @override
  String get socialPost => 'منشور اجتماعي';

  @override
  String get favorite => 'مفضل';

  @override
  String get saveDraft => 'حفظ المسودة';

  @override
  String get entryCopied => 'تم نسخ المدخل';

  @override
  String get moveEntriesToRecycleBin =>
      'نقل جميع المدخلات النشطة إلى سلة المحذوفات؟';

  @override
  String get startWritingStory => 'ابدأ بكتابة قصتك';

  @override
  String get recordMemories => 'سجل ذكرياتك ومشاعرك اليومية.';

  @override
  String get writeJournal => 'اكتب يومياتك';

  @override
  String get myMemories => 'ذكرياتي';

  @override
  String get sortJournal => 'فرز اليوميات';

  @override
  String get byMood => 'حسب المزاج';

  @override
  String get searchMemories => 'بحث في الذكريات...';

  @override
  String get selectAll => 'تحديد الكل';

  @override
  String get deleteSelected => 'حذف المحدد';

  @override
  String get taskCompletedExclamation => 'تمت المهمة!';

  @override
  String get taskUncompletedExclamation => 'مهمة غير مكتملة';

  @override
  String get clipboardUpdatedExclamation => 'تم تحديث الحافظة!';

  @override
  String clipboardSavedContent(Object content) {
    return 'تم حفظ في الحافظة: $content';
  }

  @override
  String get overview => 'نظرة عامة';

  @override
  String get colorAurora => 'أورورا';

  @override
  String get colorCosmic => 'كوني';

  @override
  String get colorNebula => 'سديم';

  @override
  String get colorStarlight => 'ضوء النجوم';

  @override
  String get colorSolar => 'شمسي';

  @override
  String get colorNova => 'نوفا';

  @override
  String get loadingStepLoading => 'جارٍ التحميل...';

  @override
  String get loadingStepDatabase => 'إعداد قاعدة البيانات...';

  @override
  String get loadingStepSystem => 'تكوين النظام...';

  @override
  String get loadingStepReady => 'جاهز';

  @override
  String get productivityCompanion => 'رفيقك للإنتاجية';

  @override
  String get done => 'تم';

  @override
  String get newNote => 'ملاحظة جديدة';

  @override
  String get changeColor => 'تغيير اللون';

  @override
  String get copyContent => 'نسخ المحتوى';

  @override
  String get titleOptional => 'العنوان (اختياري)';

  @override
  String get exportAsPdf => 'تصدير كـ PDF';

  @override
  String get taskDueNow => 'موعد المهمة الآن';

  @override
  String get moveTaskToBinTitle => 'نقل المهمة إلى سلة المحذوفات؟';

  @override
  String get restoreTaskLater =>
      'يمكنك استعادة هذه المهمة لاحقًا من الإعدادات.';

  @override
  String get newTask => 'مهمة جديدة';

  @override
  String get editTask => 'تعديل المهمة';

  @override
  String get undo => 'تراجع';

  @override
  String get redo => 'إعادة';

  @override
  String get category => 'الفئة';

  @override
  String get categoryHint => 'مثال: العمل، النادي';

  @override
  String get whatNeedsToBeDone => 'ما الذي يجب القيام به؟';

  @override
  String get enterTaskDetails => 'أدخل تفاصيل المهمة...';

  @override
  String get setDueDate => 'تحديد موعد الاستحقاق';

  @override
  String get dueDate => 'موعد الاستحقاق';

  @override
  String get expenseTitle => 'النفقات';

  @override
  String searchInCurrency(String currency) {
    return 'بحث في $currency...';
  }

  @override
  String get sortAndFilter => 'فرز وتصفية';

  @override
  String get sortBy => 'فرز حسب';

  @override
  String get highestAmount => 'أعلى مبلغ';

  @override
  String get lowestAmount => 'أقل مبلغ';

  @override
  String get moreFilters => 'مزيد من الفلاتر...';

  @override
  String get filterExpenses => 'تصفية النفقات';

  @override
  String get transactionType => 'نوع المعاملة';

  @override
  String get categories => 'الفئات';

  @override
  String get all => 'الكل';

  @override
  String get income => 'الدخل';

  @override
  String get expense => 'المصروفات';

  @override
  String get reset => 'إعادة تعيين';

  @override
  String get apply => 'تطبيق';

  @override
  String newExpense(String currency) {
    return 'جديد $currency';
  }

  @override
  String errorLoadingData(String error) {
    return 'حدث خطأ أثناء تحميل البيانات.\n\n$error';
  }

  @override
  String get dailyQuote1 => 'أفضل طريقة للتنبؤ بالمستقبل هي أن تصنعه.';

  @override
  String get dailyQuote2 => 'الغنى ليس في كثرة العرض، ولكن الغنى غنى النفس.';

  @override
  String get dailyQuote3 => 'الوقت هو العملة الأغلى.';

  @override
  String get dailyQuote4 => 'النجاح ليس نهائياً، والفشل ليس قاتلاً.';

  @override
  String get dailyQuote5 => 'ركز على الحل، وليس المشكلة.';

  @override
  String get dailyQuote6 => 'شبكة علاقاتك هي ثروتك الحقيقية.';

  @override
  String get moodHappy => 'سعيد';

  @override
  String get moodExcited => 'متحمس';

  @override
  String get moodNeutral => 'محايد';

  @override
  String get moodSad => 'حزين';

  @override
  String get moodStressed => 'متوتر';

  @override
  String exportDate(String date) {
    return '📅 $date';
  }

  @override
  String exportMood(String emoji, String mood) {
    return 'المزاج: $emoji $mood';
  }

  @override
  String exportTitle(String title) {
    return 'العنوان: $title';
  }

  @override
  String exportTags(String tags) {
    return '\nالوسوم: $tags';
  }

  @override
  String get instagram => 'إنستغرام';

  @override
  String get facebook => 'فيسبوك';

  @override
  String get tiktok => 'تيك توك';

  @override
  String get newSketch => 'رسمة جديدة';

  @override
  String get searchSketches => 'البحث في الرسومات والمجلدات...';

  @override
  String get noResultsFound => 'لم يتم العثور على نتائج';

  @override
  String get noItems => 'لا توجد عناصر';

  @override
  String get noDrawingsYet => 'لا توجد رسومات بعد';

  @override
  String get canvasIntro => 'أطلق العنان لإبداعك على اللوحة!';

  @override
  String get newCanvas => 'لوحة جديدة';

  @override
  String get rename => 'إعادة تسمية';

  @override
  String get deleteFolder => 'حذف المجلد';

  @override
  String get deleteSketchesQuestion => 'حذف الرسومات؟';

  @override
  String get deleteFolderConfirmation =>
      'سيتم حذف جميع الرسومات في هذا المجلد نهائياً.';

  @override
  String get renameFolder => 'إعادة تسمية المجلد';

  @override
  String get chooseColor => 'اختر لوناً';

  @override
  String get deleteFolderQuestion => 'حذف المجلد؟';

  @override
  String get searchClips => 'البحث في القصاصات...';

  @override
  String get clipboardEmpty => 'الحافظة فارغة';

  @override
  String get addItem => 'إضافة عنصر';

  @override
  String get clipColor => 'لون القصاصة';

  @override
  String get newClip => 'قصاصة جديدة';

  @override
  String get editClip => 'تعديل القصاصة';

  @override
  String get restoreClipLater => 'يمكنك استعادة هذه القصاصة لاحقاً.';

  @override
  String get upcomingEvents => 'الأحداث القادمة';

  @override
  String get dataDistribution => 'توزيع البيانات';

  @override
  String get taskProgress => 'تقدم المهمة';

  @override
  String get quickStats => 'إحصائيات سريعة';

  @override
  String get taskCompletion => 'إكمال المهمة';

  @override
  String get noItemsForDate => 'لا توجد عناصر لهذا التاريخ';

  @override
  String get enjoyFreeTime => 'استمتع بوقت فراغك!';

  @override
  String get searchThisDay => 'البحث في هذا اليوم...';

  @override
  String get finance => 'المالية';

  @override
  String get permanentlyDelete => 'حذف نهائي؟';

  @override
  String deleteSelectionConfirmation(int foldersCount, int sketchesCount) {
    return 'سيؤدي هذا إلى حذف $foldersCount مجلدات (ورسماتها) و $sketchesCount رسومات أخرى نهائياً.\n\nلا يمكن التراجع عن هذا الإجراء.';
  }

  @override
  String get deleteForever => 'حذف للأبد';

  @override
  String selectedCount(int count) {
    return '$count محدد';
  }

  @override
  String canvasStats(int notes, int folders) {
    return '$notes رسومات • $folders مجلدات';
  }

  @override
  String get sortItems => 'فرز العناصر';

  @override
  String get sortNameAZ => 'الاسم (أ-ي)';

  @override
  String get sortNameZA => 'الاسم (ي-أ)';

  @override
  String get createFolder => 'إنشاء مجلد';

  @override
  String get folderNameHint => 'اسم المجلد...';

  @override
  String deleteSketchesConfirmation(int count) {
    return 'حذف $count رسومات؟ لا يمكن التراجع عن هذا الإجراء.';
  }

  @override
  String get noSketchesFound => 'لم يتم العثور على رسومات';

  @override
  String get noSketchesFoundSub => 'حاول تعديل بحثك أو إنشاء رسمة جديدة.';

  @override
  String searchInFolder(String folder) {
    return 'بحث في $folder...';
  }

  @override
  String sketchesCount(int count) {
    return '$count رسومات';
  }

  @override
  String get sortSketches => 'فرز الرسومات';

  @override
  String get calendarScreenTitle => 'التقويم';

  @override
  String get dailyActivity => 'النشاط اليومي';

  @override
  String get deleteItemQuestion => 'حذف العنصر؟';

  @override
  String get deleteItemConfirmation =>
      'سيؤدي هذا إلى نقل العنصر إلى سلة المحذوفات.';

  @override
  String get moveToBinItem => 'نقل إلى السلة؟';

  @override
  String get moveToBinConfirmation => 'يمكنك استعادته لاحقاً.';

  @override
  String selectedItems(int count) {
    return '$count محدد';
  }

  @override
  String get recentClips => 'القصاصات الأخيرة';

  @override
  String get copied => 'تم النسخ!';

  @override
  String get copiedPlainText => 'تم نسخ النص المجرد';

  @override
  String get clipTheme => 'مظهر القصاصة';

  @override
  String get justNow => 'الآن';

  @override
  String minutesAgo(Object count) {
    return 'منذ $count د';
  }

  @override
  String hoursAgo(Object count) {
    return 'منذ $count س';
  }

  @override
  String daysAgo(Object count) {
    return 'منذ $count ي';
  }

  @override
  String get noTasksFound => 'لم يتم العثور على مهام.';

  @override
  String get searchTasks => 'بحث في المهام...';

  @override
  String get taskReminder => 'تذكير بالمهمة';

  @override
  String get untitledNote => 'ملاحظة بدون عنوان';

  @override
  String get dailyEntry => 'مدخل يومي';

  @override
  String get clipboardHistory => 'سجل الحافظة';

  @override
  String get deletePermanentlyContent => 'هذا الإجراء لا يمكن التراجع عنه.';

  @override
  String get emptyRecycleBinTitle => 'إفراغ سلة المحذوفات؟';

  @override
  String emptyRecycleBinContent(Object count) {
    return 'سيتم حذف جميع العناصر الـ $count نهائياً.';
  }

  @override
  String get emptyBin => 'إفراغ السلة';

  @override
  String get recycleBinEmpty => 'سلة المحذوفات فارغة';

  @override
  String get deletedItemsAppearHere => 'العناصر المحذوفة ستظهر هنا.';

  @override
  String get empty => 'فارغ';

  @override
  String get recent => 'الأخيرة';

  @override
  String categoryLabel(Object category) {
    return 'الفئة: $category';
  }

  @override
  String get general => 'عام';

  @override
  String get saveTransactionQuestion => 'هل تريد حفظ هذه المعاملة؟';

  @override
  String get fillTitleAmount => 'يرجى ملء العنوان والمبلغ';

  @override
  String get invalidAmount => 'تنسيق المبلغ غير صالح';

  @override
  String get moveTransactionToBinTitle => 'نقل المعاملة إلى سلة المحذوفات؟';

  @override
  String get restoreTransactionLater =>
      'يمكنك استعادة هذه المعاملة لاحقاً من الإعدادات.';

  @override
  String get newTransaction => 'معاملة جديدة';

  @override
  String get whatIsThisFor => 'فيما هذا؟';

  @override
  String get description => 'الوصف';

  @override
  String get daily => 'يومياً';

  @override
  String get weekly => 'أسبوعياً';

  @override
  String get monthly => 'شهرياً';

  @override
  String get yearly => 'سنوياً';

  @override
  String get totalIncome => 'إجمالي الدخل';

  @override
  String get totalExpense => 'إجمالي النفقات';

  @override
  String get analysis => 'التحليل';

  @override
  String get transactions => 'المعاملات';

  @override
  String get noExpensesFound => 'لم يتم العثور على نفقات لهذه الفترة.';

  @override
  String get netBalance => 'صافي الرصيد';

  @override
  String get topCategories => 'أبرز الفئات';

  @override
  String get spendingTrend => 'اتجاه الإنفاق';

  @override
  String get insights => 'رؤى';

  @override
  String get noExpensesRecorded => 'لم يتم تسجيل أي نفقات';

  @override
  String get trackSpendingHabits => 'تتبع عادات الإنفاق الخاصة بك بسهولة.';

  @override
  String get addExpense => 'إضافة نفقة';

  @override
  String get noDataForPeriod => 'لا توجد بيانات لهذه الفترة';

  @override
  String get budget => 'الميزانية';

  @override
  String get spent => 'تم صرفه';

  @override
  String get limit => 'الحد';

  @override
  String get overBudget => 'تجاوز الميزانية!';

  @override
  String remainingBudget(Object percent) {
    return 'متبقي $percent%';
  }

  @override
  String get savingsRate => 'معدل الادخار';

  @override
  String get healthScore => 'درجة الصحة المالية';

  @override
  String get healthScoreExplanation =>
      'هذه الدرجة تعتمد على معدل ادخارك.\n\n• ادخار > 50% = ممتاز (100)\n• ادخار 0% = متوسط (50)\n• الإنفاق > الدخل = ضعيف (<50)';

  @override
  String get ok => 'موافق';

  @override
  String get bulkImport => 'استيراد بالجملة';
}

/// The translations for Arabic, as used in Iraq (`ar_IQ`).
class AppLocalizationsArIq extends AppLocalizationsAr {
  AppLocalizationsArIq() : super('ar_IQ');

  @override
  String get settings => 'إعدادات';

  @override
  String get language => 'لغة';

  @override
  String get systemDefault => 'النظام الافتراضي';

  @override
  String get notes => 'ملحوظات';

  @override
  String get todos => 'المهام';

  @override
  String get expenses => 'نفقات';

  @override
  String get journal => 'مجلة';

  @override
  String get calendar => 'تقويم';

  @override
  String get clipboard => 'الحافظة';

  @override
  String get canvas => 'قماش';

  @override
  String get save => 'حفظ';

  @override
  String get create => 'إنشاء';

  @override
  String get cancel => 'إلغاء';

  @override
  String get delete => 'حذف';

  @override
  String get edit => 'تعديل';

  @override
  String get share => 'مشاركة';

  @override
  String get copy => 'نسخ';

  @override
  String get unsavedChanges => 'تغييرات غير محفوظة';

  @override
  String get confirmDelete => 'تأكيد الحذف';

  @override
  String get discard => 'تجاهل';

  @override
  String get createPost => 'إنشاء منشور';

  @override
  String get post => 'منشور';

  @override
  String get postingTo => 'النشر في';

  @override
  String get whatsOnYourMind => 'ماذا يدور في ذهنك؟';

  @override
  String get pickImages => 'اختر صورًا';

  @override
  String get pickVideo => 'اختر فيديو';

  @override
  String get camera => 'كاميرا';

  @override
  String get gallery => 'معرض الصور';

  @override
  String get search => 'بحث';

  @override
  String get pleaseEnterTask => 'يرجى إدخال مهمة';

  @override
  String get deleteTask => 'حذف المهمة';

  @override
  String get selectItems => 'حدد العناصر';

  @override
  String get deleteAll => 'حذف الكل';

  @override
  String error(Object error) {
    return 'خطأ: $error';
  }

  @override
  String get orderingOnlyAvailableInAllPosts =>
      'الترتيب متاح فقط في \"جميع المنشورات\"';

  @override
  String get deletePost => 'حذف المنشور';

  @override
  String get postDeleted => 'تم حذف المنشور';

  @override
  String get premiumFeatures => 'ميزات بريميوم';

  @override
  String get manageCoinsAdsPremium =>
      'إدارة العملات والإعلانات وحالة البريميوم';

  @override
  String get themeMode => 'وضع المظهر';

  @override
  String get accentColor => 'لون التمييز';

  @override
  String get backgroundDesign => 'تصميم الخلفية';

  @override
  String get pushNotifications => 'إشعارات الدفع';

  @override
  String get recycleBin => 'سلة المحذوفات';

  @override
  String get exportData => 'تصدير البيانات';

  @override
  String get importData => 'استيراد البيانات';

  @override
  String get rateApp => 'تقييم التطبيق';

  @override
  String get sendFeedback => 'إرسال تعليقات';

  @override
  String get privacyPolicy => 'سياسة الخصوصية';

  @override
  String get version => 'الإصدار';

  @override
  String get buildNumber => 'رقم البناء';

  @override
  String get system => 'النظام';

  @override
  String get light => 'فاتح';

  @override
  String get dark => 'داكن';

  @override
  String get itemRestored => 'تمت استعادة العنصر';

  @override
  String get recycleBinCleared => 'تم إفراغ سلة المحذوفات بنجاح';

  @override
  String get allPostsDeleted => 'تم حذف جميع المنشورات';

  @override
  String get newPost => 'منشور جديد';

  @override
  String get textCopiedToClipboardFacebook =>
      'تم نسخ النص إلى الحافظة (سياسة فيسبوك)';

  @override
  String get tiktokSharingRequiresVideoImage =>
      'تتطلب مشاركة TikTok فيديو/صورة';

  @override
  String errorSharing(Object error) {
    return 'خطأ في المشاركة: $error';
  }

  @override
  String shareToStory(Object platform) {
    return 'مشاركة في قصة $platform';
  }

  @override
  String shareToFeed(Object platform) {
    return 'مشاركة في موجز $platform';
  }

  @override
  String get unlockPermanently => 'فتح بشكل دائم';

  @override
  String get notEnoughCoins => 'لا توجد عملات كافية!';

  @override
  String youEarnedCoins(Object amount) {
    return 'لقد ربحت $amount من العملات!';
  }

  @override
  String get contentCopied => 'تم نسخ المحتوى';

  @override
  String get selectDateTime => 'حدد التاريخ والوقت';

  @override
  String get areYouSureYouWantToDeleteThisPost =>
      'هل أنت متأكد أنك تريد حذف هذا المنشور؟';

  @override
  String get socialPosts => 'منشورات اجتماعية';

  @override
  String get watchAdToEarnCoins => 'شاهد إعلانًا لربح العملات';

  @override
  String get premiumUnlocked => 'تم فتح البريميوم';

  @override
  String get removeAds => 'إزالة الإعلانات';

  @override
  String get unlimitedCloudStorage => 'تخزين سحابي غير محدود';

  @override
  String get deleteNote => 'حذف الملاحظة';

  @override
  String get shareNote => 'مشاركة الملاحظة';

  @override
  String get editNote => 'تعديل الملاحظة';

  @override
  String get searchNotes => 'البحث في الملاحظات...';

  @override
  String get noNotesFound => 'لم يتم العثور على ملاحظات';

  @override
  String get captureThoughts => 'سجل أفكارك فورا.';

  @override
  String get createNote => 'إنشاء ملاحظة';

  @override
  String get customOrder => 'ترتيب مخصص';

  @override
  String get newestFirst => 'الأحدث أولاً';

  @override
  String get oldestFirst => 'الأقدم أولاً';

  @override
  String get titleAZ => 'العنوان: أ-ي';

  @override
  String get titleZA => 'العنوان: ي-أ';

  @override
  String get deleteAllQuestion => 'حذف الكل؟';

  @override
  String get moveToRecycleBin => 'نقل جميع الملاحظات إلى سلة المحذوفات؟';

  @override
  String get moveToBinQuestion => 'نقل إلى السلة؟';

  @override
  String get restoreNoteLater => 'يمكنك استعادة هذه الملاحظة لاحقًا.';

  @override
  String get move => 'نقل';

  @override
  String get myThoughts => 'أفكاري';

  @override
  String get selected => 'محدد';

  @override
  String get noContent => 'لا يوجد محتوى';

  @override
  String get untitled => 'بدون عنوان';

  @override
  String get chooseWallpapers => 'اختر من بين أكثر من 10 خلفيات ديناميكية';

  @override
  String get backupData => 'نسخ احتياطي للبيانات';

  @override
  String get saveJsonFile => 'هل تريد حفظ ملف JSON يحتوي على جميع بياناتك؟';

  @override
  String get exportNow => 'تصدير الآن';

  @override
  String get importDataTitle => 'استيراد البيانات';

  @override
  String get mergeBackupFile =>
      'هل تريد دمج ملف النسخ الاحتياطي مع العناصر الحالية؟';

  @override
  String get selectFile => 'حدد ملفاً';

  @override
  String get backupSaved => 'تم حفظ النسخة الاحتياطية بنجاح!';

  @override
  String get exportFailed => 'فشل التصدير.';

  @override
  String importSuccess(Object count) {
    return 'تمت استعادة $count من العناصر بنجاح!';
  }

  @override
  String get importFailed => 'فشل الاستيراد.';

  @override
  String widgetAdded(String widget) {
    return 'تمت إضافة الأداة $widget إلى الشاشة الرئيسية!';
  }

  @override
  String get widgetRequestSent =>
      'تم إرسال طلب الأداة. يرجى التحقق من الشاشة الرئيسية.';

  @override
  String get widgetAddFailed => 'فشل إضافة الأداة';

  @override
  String get autoSaveEnabled => 'تم تفعيل الحفظ التلقائي.';

  @override
  String get autoSaveDisabled => 'تم تعطيل الحفظ التلقائي.';

  @override
  String get homeScreenWidgets => 'أدوات الشاشة الرئيسية';

  @override
  String get notificationsTitle => 'الإشعارات';

  @override
  String get dataBackup => 'البيانات والنسخ الاحتياطي';

  @override
  String get feedbackSupport => 'التعليقات والدعم';

  @override
  String get creditsTitle => 'الاعتمادات';

  @override
  String get privacyMaintenance => 'الخصوصية والصيانة';

  @override
  String get aboutTitle => 'حول';

  @override
  String get premium => 'بريميوم';

  @override
  String get appearanceTitle => 'المظهر';

  @override
  String get clipboardTitle => 'الحافظة';

  @override
  String get settingsSubtitle => 'تخصيص تجربتك';

  @override
  String get welcomeTitle => 'مرحبًا بك في CopyClip';

  @override
  String get welcomeDescription =>
      'رفيقك النهائي للإنتاجية. دعنا نجهزك بأدوات قوية لإدارة يومك.';

  @override
  String get onboardingNotesTitle => 'ملاحظات ذكية';

  @override
  String get onboardingNotesDesc =>
      'التقط الأفكار فورًا بتنسيق نص غني. نظم أفكارك ولا تفقد أي فكرة رائعة مرة أخرى.';

  @override
  String get onboardingTodosTitle => 'إدارة المهام';

  @override
  String get onboardingTodosDesc =>
      'ابق مطلعاً على أمورك. أنشئ قوائم مهام، وحدد الأولويات، وحقق أهدافك خطوة بخطوة.';

  @override
  String get onboardingExpensesTitle => 'تتبع النفقات';

  @override
  String get onboardingExpensesDesc =>
      'تحكم في أموالك. تتبع الدخل والنفقات بسهولة لفهم عادات الإنفاق الخاصة بك.';

  @override
  String get onboardingJournalTitle => 'يوميات شخصية';

  @override
  String get onboardingJournalDesc =>
      'تأمل في يومك. مساحة خاصة لتدوين ذكرياتك ومشاعرك وتجاربك اليومية.';

  @override
  String get onboardingCalendarTitle => 'التقويم والأحداث';

  @override
  String get onboardingCalendarDesc =>
      'لا تفوت أي لحظة. نظم جدولك وتابع الأحداث الهامة القادمة.';

  @override
  String get onboardingClipboardTitle => 'مدير الحافظة';

  @override
  String get onboardingClipboardDesc =>
      'انسخ مرة واحدة، والصق في أي مكان. الوصول إلى سجل الحافظة لاستعادة النصوص التي نسختها سابقاً.';

  @override
  String get onboardingCanvasTitle => 'لوحة إبداعية';

  @override
  String get onboardingCanvasDesc =>
      'أطلق العنان لإبداعك. ارسم وخطط وصور أفكارك على لوحة رقمية حرة.';

  @override
  String get featuresNotesDesc => 'إنشاء وإدارة الملاحظات الخاصة بك';

  @override
  String get featuresTodosDesc => 'تتبع المهام الخاصة بك';

  @override
  String get featuresExpensesDesc => 'مراقبة النفقات الخاصة بك';

  @override
  String get featuresJournalDesc => 'اكتتب أفكارك';

  @override
  String get featuresCalendarDesc => 'نظم جدولك الزمني';

  @override
  String get featuresClipboardDesc => 'الوصول إلى سجل الحافظة الخاص بك';

  @override
  String get featuresCanvasDesc => 'ارسم وخطط بحرية';

  @override
  String get featuresSocialPost => 'منشور اجتماعي';

  @override
  String get featuresSocialPostDesc =>
      'إنشاء محتوى جذاب لوسائل التواصل الاجتماعي';

  @override
  String get chooseYourAura => 'اختر هالتك';

  @override
  String get expressYourselfTheme => 'عبر عن نفسك بلون مظهر جديد!';

  @override
  String get level => 'المستوى';

  @override
  String get xpToNextLevel => 'XP للمستوى التالي';

  @override
  String get checkUpcomingEvents => 'تحقق من الأحداث القادمة';

  @override
  String get startNewSketch => 'بدأ رسمة جديدة';

  @override
  String get noTransactionsMonth => 'لا توجد معاملات هذا الشهر';

  @override
  String transactionsThisMonth(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count معاملات هذا الشهر',
      two: 'معاملتان هذا الشهر',
      one: 'معاملة واحدة هذا الشهر',
      zero: 'لا توجد معاملات هذا الشهر',
    );
    return '$_temp0';
  }

  @override
  String get autoSaveClipboard => 'حفظ تلقائي للحافظة';

  @override
  String get autoSaveClipboardDesc => 'حفظ العناصر المنسوخة تلقائياً';

  @override
  String get permissionDeniedSettings =>
      'تم رفض الإذن بشكل دائم. يرجى تفعيله من الإعدادات.';

  @override
  String get notificationsEnabled => 'تم تفعيل الإشعارات!';

  @override
  String get redirectingToSettings =>
      'جارٍ التوجيه إلى الإعدادات لتعطيل الإشعارات...';

  @override
  String get premiumAccess => 'وصول بريميوم';

  @override
  String get premiumActiveUntil => 'بريميوم نشط حتى';

  @override
  String get unlockAllFeatures => 'فتح جميع الميزات';

  @override
  String get buyPremium => 'شراء بريميوم (7 أيام)';

  @override
  String costCoins(Object cost) {
    return 'التكلفة: $cost عملات';
  }

  @override
  String get premiumActivated => 'تم تفعيل البريميوم لمدة 7 أيام!';

  @override
  String get premiumActive => 'البريميوم نشط';

  @override
  String get expires => 'تنتهي الصلاحية:';

  @override
  String get temporaryAccess => 'وصول مؤقت';

  @override
  String get journalExpression => 'يوميات وتعبير';

  @override
  String get artisticDesigns => 'تصاميم فنية';

  @override
  String get artisticDesignsDesc =>
      'فتح أكثر من 10 مظاهر فريدة لبطاقات اليوميات';

  @override
  String get premiumLayouts => 'تخطيطات بريميوم';

  @override
  String get premiumLayoutsDesc => 'طرق حصرية لعرض ذكرياتك';

  @override
  String get calendarTools => 'تقويم وأدوات';

  @override
  String get fullCalendar => 'تقويم كامل';

  @override
  String get fullCalendarDesc => 'نظام متكامل لإدارة الأحداث';

  @override
  String get clipboardAutoSaveDesc => 'التقاط سجل الحافظة في الخلفية';

  @override
  String get proWidgets => 'أدوات ذكية للمحترفين';

  @override
  String get proWidgetsDesc => 'جميع الميزات متوفرة على شاشتك الرئيسية';

  @override
  String get dataExport => 'البيانات والتصدير';

  @override
  String get advancedBackup => 'نسخ احتياطي متقدم';

  @override
  String get advancedBackupDesc => 'استيراد/تصدير آمن لجميع البيانات';

  @override
  String get pdfExport => 'تصدير إلى PDF';

  @override
  String get pdfExportDesc => 'تصدير الملاحظات واليوميات إلى PDF';

  @override
  String get printReady => 'جاهز للطباعة';

  @override
  String get printReadyDesc => 'دعم الطباعة المباشرة';

  @override
  String get richTextEditor => 'محرر نص غني';

  @override
  String get advancedSearch => 'بحث متقدم';

  @override
  String get advancedSearchDesc => 'البحث والاستبدال داخل النص';

  @override
  String get richMedia => 'وسائط غنية';

  @override
  String get richMediaDesc => 'إدراج صور وفيديوهات وروابط';

  @override
  String get editorStyling => 'تنسيق المحرر';

  @override
  String get editorStylingDesc => 'نص مخصص وخلفيات للمحرر';

  @override
  String get balance => 'الرصيد';

  @override
  String get loadingAd => 'جارٍ تحميل الإعلان...';

  @override
  String watchAd(Object amount) {
    return 'مشاهدة إعلان (+$amount)';
  }

  @override
  String get loadAd => 'تحميل إعلان';

  @override
  String get backupDataDesc => 'حفظ ملف JSON لبياناتك';

  @override
  String get importDataDesc => 'دمج ملف نسخة احتياطية في CopyClip';

  @override
  String get notificationPermissionDenied => 'تم رفض إذن الإشعارات.';

  @override
  String get typeNewTask => 'اكتب مهمة جديدة...';

  @override
  String get addTask => 'إضافة مهمة';

  @override
  String get completed => 'مكتمل';

  @override
  String get greatJob => 'عمل رائع!';

  @override
  String youEarnedXPNextTask(Object amount, Object date) {
    return 'لقد ربحت $amount XP! المهمة التالية: $date';
  }

  @override
  String taskCompletedXP(Object amount) {
    return 'تمت المهمة! +$amount XP';
  }

  @override
  String get moveTasksToRecycleBin =>
      'نقل جميع المهام النشطة إلى سلة المحذوفات؟';

  @override
  String get deleteAllPosts => 'حذف جميع المنشورات';

  @override
  String get deleteAllPostsConfirmation =>
      'هل أنت متأكد أنك تريد حذف جميع المنشورات الاجتماعية؟ لا يمكن التراجع عن هذا الإجراء.';

  @override
  String get allPosts => 'جميع المنشورات';

  @override
  String get favorites => 'المفضلة';

  @override
  String get drafts => 'المسودات';

  @override
  String get noFavoritesYet => 'لا توجد مفضلات بعد';

  @override
  String get noDraftsYet => 'لا توجد مسودات بعد';

  @override
  String get startSocialJourney => 'ابدأ رحلتك الاجتماعية!';

  @override
  String get draft => 'مسودة';

  @override
  String attachmentCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count مرفقات',
      two: 'مرفقان',
      one: 'مرفق واحد',
      zero: 'لا توجد مرفقات',
    );
    return '$_temp0';
  }

  @override
  String get pleaseAddContent => 'يرجى إضافة بعض المحتوى أو الوسائط للمشاركة';

  @override
  String fileNotFoundError(Object path) {
    return 'خطأ: لم يتم العثور على الملف في $path';
  }

  @override
  String get checkFacebookApp => 'تحقق من تطبيق فيسبوك';

  @override
  String get systemShare => 'مشاركة النظام';

  @override
  String get socialPost => 'منشور اجتماعي';

  @override
  String get favorite => 'مفضل';

  @override
  String get saveDraft => 'حفظ المسودة';

  @override
  String get entryCopied => 'تم نسخ المدخل';

  @override
  String get moveEntriesToRecycleBin =>
      'نقل جميع المدخلات النشطة إلى سلة المحذوفات؟';

  @override
  String get startWritingStory => 'ابدأ بكتابة قصتك';

  @override
  String get recordMemories => 'سجل ذكرياتك ومشاعرك اليومية.';

  @override
  String get writeJournal => 'اكتب يومياتك';

  @override
  String get myMemories => 'ذكرياتي';

  @override
  String get sortJournal => 'فرز اليوميات';

  @override
  String get byMood => 'حسب المزاج';

  @override
  String get searchMemories => 'بحث في الذكريات...';

  @override
  String get selectAll => 'تحديد الكل';

  @override
  String get deleteSelected => 'حذف المحدد';

  @override
  String get taskCompletedExclamation => 'تمت المهمة!';

  @override
  String get taskUncompletedExclamation => 'مهمة غير مكتملة';

  @override
  String get clipboardUpdatedExclamation => 'تم تحديث الحافظة!';

  @override
  String clipboardSavedContent(Object content) {
    return 'تم حفظ في الحافظة: $content';
  }

  @override
  String get overview => 'نظرة عامة';

  @override
  String get colorAurora => 'أورورا';

  @override
  String get colorCosmic => 'كوني';

  @override
  String get colorNebula => 'سديم';

  @override
  String get colorStarlight => 'ضوء النجوم';

  @override
  String get colorSolar => 'شمسي';

  @override
  String get colorNova => 'نوفا';

  @override
  String get loadingStepLoading => 'جارٍ التحميل...';

  @override
  String get loadingStepDatabase => 'إعداد قاعدة البيانات...';

  @override
  String get loadingStepSystem => 'تكوين النظام...';

  @override
  String get loadingStepReady => 'جاهز';

  @override
  String get productivityCompanion => 'رفيقك للإنتاجية';

  @override
  String get done => 'تم';

  @override
  String get newNote => 'ملاحظة جديدة';

  @override
  String get changeColor => 'تغيير اللون';

  @override
  String get copyContent => 'نسخ المحتوى';

  @override
  String get titleOptional => 'العنوان (اختياري)';

  @override
  String get exportAsPdf => 'تصدير كـ PDF';

  @override
  String get taskDueNow => 'موعد المهمة الآن';

  @override
  String get moveTaskToBinTitle => 'نقل المهمة إلى سلة المحذوفات؟';

  @override
  String get restoreTaskLater =>
      'يمكنك استعادة هذه المهمة لاحقاً من الإعدادات.';

  @override
  String get newTask => 'مهمة جديدة';

  @override
  String get editTask => 'تعديل المهمة';

  @override
  String get undo => 'تراجع';

  @override
  String get redo => 'إعادة';

  @override
  String get category => 'الفئة';

  @override
  String get categoryHint => 'مثال: العمل، النادي';

  @override
  String get whatNeedsToBeDone => 'ما الذي يجب القيام به؟';

  @override
  String get enterTaskDetails => 'أدخل تفاصيل المهمة...';

  @override
  String get setDueDate => 'تحديد موعد الاستحقاق';

  @override
  String get dueDate => 'موعد الاستحقاق';

  @override
  String get expenseTitle => 'النفقات';

  @override
  String searchInCurrency(String currency) {
    return 'بحث في $currency...';
  }

  @override
  String get sortAndFilter => 'فرز وتصفية';

  @override
  String get sortBy => 'فرز حسب';

  @override
  String get highestAmount => 'أعلى مبلغ';

  @override
  String get lowestAmount => 'أقل مبلغ';

  @override
  String get moreFilters => 'مزيد من الفلاتر...';

  @override
  String get filterExpenses => 'تصفية النفقات';

  @override
  String get transactionType => 'نوع المعاملة';

  @override
  String get categories => 'الفئات';

  @override
  String get all => 'الكل';

  @override
  String get income => 'الدخل';

  @override
  String get expense => 'المصروفات';

  @override
  String get reset => 'إعادة تعيين';

  @override
  String get apply => 'تطبيق';

  @override
  String newExpense(String currency) {
    return 'جديد $currency';
  }

  @override
  String errorLoadingData(String error) {
    return 'حدث خطأ أثناء تحميل البيانات.\n\n$error';
  }

  @override
  String get dailyQuote1 => 'أفضل طريقة للتنبؤ بالمستقبل هي أن تصنعه.';

  @override
  String get dailyQuote2 => 'الغنى ليس في كثرة العرض، ولكن الغنى غنى النفس.';

  @override
  String get dailyQuote3 => 'الوقت هو العملة الأغلى.';

  @override
  String get dailyQuote4 => 'النجاح ليس نهائياً، والفشل ليس قاتلاً.';

  @override
  String get dailyQuote5 => 'ركز على الحل، وليس المشكلة.';

  @override
  String get dailyQuote6 => 'شبكة علاقاتك هي ثروتك الحقيقية.';

  @override
  String get moodHappy => 'سعيد';

  @override
  String get moodExcited => 'متحمس';

  @override
  String get moodNeutral => 'محايد';

  @override
  String get moodSad => 'حزين';

  @override
  String get moodStressed => 'متوتر';

  @override
  String exportDate(String date) {
    return '📅 $date';
  }

  @override
  String exportMood(String emoji, String mood) {
    return 'المزاج: $emoji $mood';
  }

  @override
  String exportTitle(String title) {
    return 'العنوان: $title';
  }

  @override
  String exportTags(String tags) {
    return '\nالوسوم: $tags';
  }

  @override
  String get instagram => 'إنستغرام';

  @override
  String get facebook => 'فيسبوك';

  @override
  String get tiktok => 'تيك توك';

  @override
  String get newSketch => 'رسمة جديدة';

  @override
  String get searchSketches => 'البحث في الرسومات والمجلدات...';

  @override
  String get noResultsFound => 'لم يتم العثور على نتائج';

  @override
  String get noItems => 'لا توجد عناصر';

  @override
  String get noDrawingsYet => 'لا توجد رسومات بعد';

  @override
  String get canvasIntro => 'أطلق العنان لإبداعك على اللوحة!';

  @override
  String get newCanvas => 'لوحة جديدة';

  @override
  String get rename => 'إعادة تسمية';

  @override
  String get deleteFolder => 'حذف المجلد';

  @override
  String get deleteSketchesQuestion => 'حذف الرسومات؟';

  @override
  String get deleteFolderConfirmation =>
      'سيتم حذف جميع الرسومات في هذا المجلد نهائياً.';

  @override
  String get renameFolder => 'إعادة تسمية المجلد';

  @override
  String get chooseColor => 'اختر لوناً';

  @override
  String get deleteFolderQuestion => 'حذف المجلد؟';

  @override
  String get searchClips => 'البحث في القصاصات...';

  @override
  String get clipboardEmpty => 'الحافظة فارغة';

  @override
  String get addItem => 'إضافة عنصر';

  @override
  String get clipColor => 'لون القصاصة';

  @override
  String get newClip => 'قصاصة جديدة';

  @override
  String get editClip => 'تعديل القصاصة';

  @override
  String get restoreClipLater => 'يمكنك استعادة هذه القصاصة لاحقاً.';

  @override
  String get upcomingEvents => 'الأحداث القادمة';

  @override
  String get dataDistribution => 'توزيع البيانات';

  @override
  String get taskProgress => 'تقدم المهمة';

  @override
  String get quickStats => 'إحصائيات سريعة';

  @override
  String get taskCompletion => 'إكمال المهمة';

  @override
  String get noItemsForDate => 'لا توجد عناصر لهذا التاريخ';

  @override
  String get enjoyFreeTime => 'استمتع بوقت فراغك!';

  @override
  String get searchThisDay => 'البحث في هذا اليوم...';

  @override
  String get finance => 'المالية';

  @override
  String get permanentlyDelete => 'حذف نهائي؟';

  @override
  String deleteSelectionConfirmation(int foldersCount, int sketchesCount) {
    return 'سيؤدي هذا إلى حذف $foldersCount مجلدات (ورسماتها) و $sketchesCount رسومات أخرى نهائياً.\n\nلا يمكن التراجع عن هذا الإجراء.';
  }

  @override
  String get deleteForever => 'حذف للأبد';

  @override
  String selectedCount(int count) {
    return '$count محدد';
  }

  @override
  String canvasStats(int notes, int folders) {
    return '$notes رسومات • $folders مجلدات';
  }

  @override
  String get sortItems => 'فرز العناصر';

  @override
  String get sortNameAZ => 'الاسم (أ-ي)';

  @override
  String get sortNameZA => 'الاسم (ي-أ)';

  @override
  String get createFolder => 'إنشاء مجلد';

  @override
  String get folderNameHint => 'اسم المجلد...';

  @override
  String deleteSketchesConfirmation(int count) {
    return 'حذف $count رسومات؟ لا يمكن التراجع عن هذا الإجراء.';
  }

  @override
  String get noSketchesFound => 'لم يتم العثور على رسومات';

  @override
  String get noSketchesFoundSub => 'حاول تعديل بحثك أو إنشاء رسمة جديدة.';

  @override
  String searchInFolder(String folder) {
    return 'بحث في $folder...';
  }

  @override
  String sketchesCount(int count) {
    return '$count رسومات';
  }

  @override
  String get sortSketches => 'فرز الرسومات';

  @override
  String get calendarScreenTitle => 'التقويم';

  @override
  String get dailyActivity => 'النشاط اليومي';

  @override
  String get deleteItemQuestion => 'حذف العنصر؟';

  @override
  String get deleteItemConfirmation =>
      'سيؤدي هذا إلى نقل العنصر إلى سلة المحذوفات.';

  @override
  String get moveToBinItem => 'نقل إلى السلة؟';

  @override
  String get moveToBinConfirmation => 'يمكنك استعادته لاحقاً.';

  @override
  String selectedItems(int count) {
    return '$count محدد';
  }

  @override
  String get recentClips => 'القصاصات الأخيرة';

  @override
  String get copied => 'تم النسخ!';

  @override
  String get copiedPlainText => 'تم نسخ النص المجرد';

  @override
  String get clipTheme => 'مظهر القصاصة';

  @override
  String get justNow => 'الآن';

  @override
  String minutesAgo(Object count) {
    return 'منذ $count د';
  }

  @override
  String hoursAgo(Object count) {
    return 'منذ $count س';
  }

  @override
  String daysAgo(Object count) {
    return 'منذ $count ي';
  }

  @override
  String get noTasksFound => 'لم يتم العثور على مهام.';

  @override
  String get searchTasks => 'بحث في المهام...';

  @override
  String get taskReminder => 'تذكير بالمهمة';

  @override
  String get untitledNote => 'ملاحظة بدون عنوان';

  @override
  String get dailyEntry => 'مدخل يومي';

  @override
  String get clipboardHistory => 'سجل الحافظة';

  @override
  String get deletePermanentlyContent => 'هذا الإجراء لا يمكن التراجع عنه.';

  @override
  String get emptyRecycleBinTitle => 'إفراغ سلة المحذوفات؟';

  @override
  String emptyRecycleBinContent(Object count) {
    return 'سيتم حذف جميع العناصر الـ $count نهائياً.';
  }

  @override
  String get emptyBin => 'إفراغ السلة';

  @override
  String get recycleBinEmpty => 'سلة المحذوفات فارغة';

  @override
  String get deletedItemsAppearHere => 'العناصر المحذوفة ستظهر هنا.';

  @override
  String get empty => 'فارغ';

  @override
  String get recent => 'الأخيرة';

  @override
  String categoryLabel(Object category) {
    return 'الفئة: $category';
  }

  @override
  String get general => 'عام';

  @override
  String get saveTransactionQuestion => 'هل تريد حفظ هذه المعاملة؟';

  @override
  String get fillTitleAmount => 'يرجى ملء العنوان والمبلغ';

  @override
  String get invalidAmount => 'تنسيق المبلغ غير صالح';

  @override
  String get moveTransactionToBinTitle => 'نقل المعاملة إلى سلة المحذوفات؟';

  @override
  String get restoreTransactionLater =>
      'يمكنك استعادة هذه المعاملة لاحقاً من الإعدادات.';

  @override
  String get newTransaction => 'معاملة جديدة';

  @override
  String get whatIsThisFor => 'فيما هذا؟';

  @override
  String get description => 'الوصف';

  @override
  String get daily => 'يومياً';

  @override
  String get weekly => 'أسبوعياً';

  @override
  String get monthly => 'شهرياً';

  @override
  String get yearly => 'سنوياً';

  @override
  String get totalIncome => 'إجمالي الدخل';

  @override
  String get totalExpense => 'إجمالي النفقات';

  @override
  String get analysis => 'التحليل';

  @override
  String get transactions => 'المعاملات';

  @override
  String get noExpensesFound => 'لم يتم العثور على نفقات لهذه الفترة.';

  @override
  String get netBalance => 'صافي الرصيد';

  @override
  String get topCategories => 'أبرز الفئات';

  @override
  String get spendingTrend => 'اتجاه الإنفاق';

  @override
  String get insights => 'رؤى';

  @override
  String get noExpensesRecorded => 'لم يتم تسجيل أي نفقات';

  @override
  String get trackSpendingHabits => 'تتبع عادات الإنفاق الخاصة بك بسهولة.';

  @override
  String get addExpense => 'إضافة نفقة';

  @override
  String get noDataForPeriod => 'لا توجد بيانات لهذه الفترة';

  @override
  String get budget => 'الميزانية';

  @override
  String get spent => 'تم صرفه';

  @override
  String get limit => 'الحد';

  @override
  String get overBudget => 'تجاوز الميزانية!';

  @override
  String remainingBudget(Object percent) {
    return 'متبقي $percent%';
  }

  @override
  String get savingsRate => 'معدل الادخار';

  @override
  String get healthScore => 'درجة الصحة المالية';

  @override
  String get healthScoreExplanation =>
      'هذه الدرجة تعتمد على معدل ادخارك.\n\n• ادخار > 50% = ممتاز (100)\n• ادخار 0% = متوسط (50)\n• الإنفاق > الدخل = ضعيف (<50)';

  @override
  String get ok => 'موافق';

  @override
  String get bulkImport => 'استيراد بالجملة';
}

/// The translations for Arabic, as used in Jordan (`ar_JO`).
class AppLocalizationsArJo extends AppLocalizationsAr {
  AppLocalizationsArJo() : super('ar_JO');

  @override
  String get settings => 'إعدادات';

  @override
  String get language => 'لغة';

  @override
  String get systemDefault => 'النظام الافتراضي';

  @override
  String get notes => 'ملحوظات';

  @override
  String get todos => 'المهام';

  @override
  String get expenses => 'نفقات';

  @override
  String get journal => 'مجلة';

  @override
  String get calendar => 'تقويم';

  @override
  String get clipboard => 'الحافظة';

  @override
  String get canvas => 'قماش';

  @override
  String get save => 'حفظ';

  @override
  String get create => 'إنشاء';

  @override
  String get cancel => 'إلغاء';

  @override
  String get delete => 'حذف';

  @override
  String get edit => 'تعديل';

  @override
  String get share => 'مشاركة';

  @override
  String get copy => 'نسخ';

  @override
  String get unsavedChanges => 'تغييرات غير محفوظة';

  @override
  String get confirmDelete => 'تأكيد الحذف';

  @override
  String get discard => 'تجاهل';

  @override
  String get createPost => 'إنشاء منشور';

  @override
  String get post => 'منشور';

  @override
  String get postingTo => 'النشر في';

  @override
  String get whatsOnYourMind => 'ماذا يدور في ذهنك؟';

  @override
  String get pickImages => 'اختر صورًا';

  @override
  String get pickVideo => 'اختر فيديو';

  @override
  String get camera => 'كاميرا';

  @override
  String get gallery => 'معرض الصور';

  @override
  String get search => 'بحث';

  @override
  String get pleaseEnterTask => 'يرجى إدخال مهمة';

  @override
  String get deleteTask => 'حذف المهمة';

  @override
  String get selectItems => 'حدد العناصر';

  @override
  String get deleteAll => 'حذف الكل';

  @override
  String error(Object error) {
    return 'خطأ: $error';
  }

  @override
  String get orderingOnlyAvailableInAllPosts =>
      'الترتيب متاح فقط في \"جميع المنشورات\"';

  @override
  String get deletePost => 'حذف المنشور';

  @override
  String get postDeleted => 'تم حذف المنشور';

  @override
  String get premiumFeatures => 'ميزات بريميوم';

  @override
  String get manageCoinsAdsPremium =>
      'إدارة العملات والإعلانات وحالة البريميوم';

  @override
  String get themeMode => 'وضع المظهر';

  @override
  String get accentColor => 'لون التمييز';

  @override
  String get backgroundDesign => 'تصميم الخلفية';

  @override
  String get pushNotifications => 'إشعارات الدفع';

  @override
  String get recycleBin => 'سلة المحذوفات';

  @override
  String get exportData => 'تصدير البيانات';

  @override
  String get importData => 'استيراد البيانات';

  @override
  String get rateApp => 'تقييم التطبيق';

  @override
  String get sendFeedback => 'إرسال تعليقات';

  @override
  String get privacyPolicy => 'سياسة الخصوصية';

  @override
  String get version => 'الإصدار';

  @override
  String get buildNumber => 'رقم البناء';

  @override
  String get system => 'النظام';

  @override
  String get light => 'فاتح';

  @override
  String get dark => 'داكن';

  @override
  String get itemRestored => 'تمت استعادة العنصر';

  @override
  String get recycleBinCleared => 'تم إفراغ سلة المحذوفات بنجاح';

  @override
  String get allPostsDeleted => 'تم حذف جميع المنشورات';

  @override
  String get newPost => 'منشور جديد';

  @override
  String get textCopiedToClipboardFacebook =>
      'تم نسخ النص إلى الحافظة (سياسة فيسبوك)';

  @override
  String get tiktokSharingRequiresVideoImage =>
      'تتطلب مشاركة TikTok فيديو/صورة';

  @override
  String errorSharing(Object error) {
    return 'خطأ في المشاركة: $error';
  }

  @override
  String shareToStory(Object platform) {
    return 'مشاركة في قصة $platform';
  }

  @override
  String shareToFeed(Object platform) {
    return 'مشاركة في موجز $platform';
  }

  @override
  String get unlockPermanently => 'فتح بشكل دائم';

  @override
  String get notEnoughCoins => 'لا توجد عملات كافية!';

  @override
  String youEarnedCoins(Object amount) {
    return 'لقد ربحت $amount من العملات!';
  }

  @override
  String get contentCopied => 'تم نسخ المحتوى';

  @override
  String get selectDateTime => 'حدد التاريخ والوقت';

  @override
  String get areYouSureYouWantToDeleteThisPost =>
      'هل أنت متأكد أنك تريد حذف هذا المنشور؟';

  @override
  String get socialPosts => 'منشورات اجتماعية';

  @override
  String get watchAdToEarnCoins => 'شاهد إعلانًا لربح العملات';

  @override
  String get premiumUnlocked => 'تم فتح البريميوم';

  @override
  String get removeAds => 'إزالة الإعلانات';

  @override
  String get unlimitedCloudStorage => 'تخزين سحابي غير محدود';

  @override
  String get deleteNote => 'حذف الملاحظة';

  @override
  String get shareNote => 'مشاركة الملاحظة';

  @override
  String get editNote => 'تعديل الملاحظة';

  @override
  String get searchNotes => 'البحث في الملاحظات...';

  @override
  String get noNotesFound => 'لم يتم العثور على ملاحظات';

  @override
  String get captureThoughts => 'سجل أفكارك فورا.';

  @override
  String get createNote => 'إنشاء ملاحظة';

  @override
  String get customOrder => 'ترتيب مخصص';

  @override
  String get newestFirst => 'الأحدث أولاً';

  @override
  String get oldestFirst => 'الأقدم أولاً';

  @override
  String get titleAZ => 'العنوان: أ-ي';

  @override
  String get titleZA => 'العنوان: ي-أ';

  @override
  String get deleteAllQuestion => 'حذف الكل؟';

  @override
  String get moveToRecycleBin => 'نقل جميع الملاحظات إلى سلة المحذوفات؟';

  @override
  String get moveToBinQuestion => 'نقل إلى السلة؟';

  @override
  String get restoreNoteLater => 'يمكنك استعادة هذه الملاحظة لاحقًا.';

  @override
  String get move => 'نقل';

  @override
  String get myThoughts => 'أفكاري';

  @override
  String get selected => 'محدد';

  @override
  String get noContent => 'لا يوجد محتوى';

  @override
  String get untitled => 'بدون عنوان';

  @override
  String get chooseWallpapers => 'اختر من بين أكثر من 10 خلفيات ديناميكية';

  @override
  String get backupData => 'نسخ احتياطي للبيانات';

  @override
  String get saveJsonFile => 'هل تريد حفظ ملف JSON يحتوي على جميع بياناتك؟';

  @override
  String get exportNow => 'تصدير الآن';

  @override
  String get importDataTitle => 'استيراد البيانات';

  @override
  String get mergeBackupFile =>
      'هل تريد دمج ملف النسخ الاحتياطي مع العناصر الحالية؟';

  @override
  String get selectFile => 'حدد ملفاً';

  @override
  String get backupSaved => 'تم حفظ النسخة الاحتياطية بنجاح!';

  @override
  String get exportFailed => 'فشل التصدير.';

  @override
  String importSuccess(Object count) {
    return 'تمت استعادة $count من العناصر بنجاح!';
  }

  @override
  String get importFailed => 'فشل الاستيراد.';

  @override
  String widgetAdded(String widget) {
    return 'تمت إضافة الأداة $widget إلى الشاشة الرئيسية!';
  }

  @override
  String get widgetRequestSent =>
      'تم إرسال طلب الأداة. يرجى التحقق من الشاشة الرئيسية.';

  @override
  String get widgetAddFailed => 'فشل إضافة الأداة';

  @override
  String get autoSaveEnabled => 'تم تفعيل الحفظ التلقائي.';

  @override
  String get autoSaveDisabled => 'تم تعطيل الحفظ التلقائي.';

  @override
  String get homeScreenWidgets => 'أدوات الشاشة الرئيسية';

  @override
  String get notificationsTitle => 'الإشعارات';

  @override
  String get dataBackup => 'البيانات والنسخ الاحتياطي';

  @override
  String get feedbackSupport => 'التعليقات والدعم';

  @override
  String get creditsTitle => 'الاعتمادات';

  @override
  String get privacyMaintenance => 'الخصوصية والصيانة';

  @override
  String get aboutTitle => 'حول';

  @override
  String get premium => 'بريميوم';

  @override
  String get appearanceTitle => 'المظهر';

  @override
  String get clipboardTitle => 'الحافظة';

  @override
  String get settingsSubtitle => 'تخصيص تجربتك';

  @override
  String get welcomeTitle => 'مرحبًا بك في CopyClip';

  @override
  String get welcomeDescription =>
      'رفيقك النهائي للإنتاجية. دعنا نجهزك بأدوات قوية لإدارة يومك.';

  @override
  String get onboardingNotesTitle => 'ملاحظات ذكية';

  @override
  String get onboardingNotesDesc =>
      'التقط الأفكار فورًا بتنسيق نص غني. نظم أفكارك ولا تفقد أي فكرة رائعة مرة أخرى.';

  @override
  String get onboardingTodosTitle => 'إدارة المهام';

  @override
  String get onboardingTodosDesc =>
      'ابق مطلعاً على أمورك. أنشئ قوائم مهام، وحدد الأولويات، وحقق أهدافك خطوة بخطوة.';

  @override
  String get onboardingExpensesTitle => 'تتبع النفقات';

  @override
  String get onboardingExpensesDesc =>
      'تحكم في أموالك. تتبع الدخل والنفقات بسهولة لفهم عادات الإنفاق الخاصة بك.';

  @override
  String get onboardingJournalTitle => 'يوميات شخصية';

  @override
  String get onboardingJournalDesc =>
      'تأمل في يومك. مساحة خاصة لتدوين ذكرياتك ومشاعرك وتجاربك اليومية.';

  @override
  String get onboardingCalendarTitle => 'التقويم والأحداث';

  @override
  String get onboardingCalendarDesc =>
      'لا تفوت أي لحظة. نظم جدولك وتابع الأحداث الهامة القادمة.';

  @override
  String get onboardingClipboardTitle => 'مدير الحافظة';

  @override
  String get onboardingClipboardDesc =>
      'انسخ مرة واحدة، والصق في أي مكان. الوصول إلى سجل الحافظة لاستعادة النصوص التي نسختها سابقاً.';

  @override
  String get onboardingCanvasTitle => 'لوحة إبداعية';

  @override
  String get onboardingCanvasDesc =>
      'أطلق العنان لإبداعك. ارسم وخطط وصور أفكارك على لوحة رقمية حرة.';

  @override
  String get featuresNotesDesc => 'إنشاء وإدارة الملاحظات الخاصة بك';

  @override
  String get featuresTodosDesc => 'تتبع المهام الخاصة بك';

  @override
  String get featuresExpensesDesc => 'مراقبة النفقات الخاصة بك';

  @override
  String get featuresJournalDesc => 'اكتتب أفكارك';

  @override
  String get featuresCalendarDesc => 'نظم جدولك الزمني';

  @override
  String get featuresClipboardDesc => 'الوصول إلى سجل الحافظة الخاص بك';

  @override
  String get featuresCanvasDesc => 'ارسم وخطط بحرية';

  @override
  String get featuresSocialPost => 'منشور اجتماعي';

  @override
  String get featuresSocialPostDesc =>
      'إنشاء محتوى جذاب لوسائل التواصل الاجتماعي';

  @override
  String get chooseYourAura => 'اختر هالتك';

  @override
  String get expressYourselfTheme => 'عبر عن نفسك بلون مظهر جديد!';

  @override
  String get level => 'المستوى';

  @override
  String get xpToNextLevel => 'XP للمستوى التالي';

  @override
  String get checkUpcomingEvents => 'تحقق من الأحداث القادمة';

  @override
  String get startNewSketch => 'بدأ رسمة جديدة';

  @override
  String get noTransactionsMonth => 'لا توجد معاملات هذا الشهر';

  @override
  String transactionsThisMonth(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count معاملات هذا الشهر',
      two: 'معاملتان هذا الشهر',
      one: 'معاملة واحدة هذا الشهر',
      zero: 'لا توجد معاملات هذا الشهر',
    );
    return '$_temp0';
  }

  @override
  String get autoSaveClipboard => 'حفظ تلقائي للحافظة';

  @override
  String get autoSaveClipboardDesc => 'حفظ العناصر المنسوخة تلقائياً';

  @override
  String get permissionDeniedSettings =>
      'تم رفض الإذن بشكل دائم. يرجى تفعيله من الإعدادات.';

  @override
  String get notificationsEnabled => 'تم تفعيل الإشعارات!';

  @override
  String get redirectingToSettings =>
      'جارٍ التوجيه إلى الإعدادات لتعطيل الإشعارات...';

  @override
  String get premiumAccess => 'وصول بريميوم';

  @override
  String get premiumActiveUntil => 'بريميوم نشط حتى';

  @override
  String get unlockAllFeatures => 'فتح جميع الميزات';

  @override
  String get buyPremium => 'شراء بريميوم (7 أيام)';

  @override
  String costCoins(Object cost) {
    return 'التكلفة: $cost عملات';
  }

  @override
  String get premiumActivated => 'تم تفعيل البريميوم لمدة 7 أيام!';

  @override
  String get premiumActive => 'البريميوم نشط';

  @override
  String get expires => 'تنتهي الصلاحية:';

  @override
  String get temporaryAccess => 'وصول مؤقت';

  @override
  String get journalExpression => 'يوميات وتعبير';

  @override
  String get artisticDesigns => 'تصاميم فنية';

  @override
  String get artisticDesignsDesc =>
      'فتح أكثر من 10 مظاهر فريدة لبطاقات اليوميات';

  @override
  String get premiumLayouts => 'تخطيطات بريميوم';

  @override
  String get premiumLayoutsDesc => 'طرق حصرية لعرض ذكرياتك';

  @override
  String get calendarTools => 'تقويم وأدوات';

  @override
  String get fullCalendar => 'تقويم كامل';

  @override
  String get fullCalendarDesc => 'نظام متكامل لإدارة الأحداث';

  @override
  String get clipboardAutoSaveDesc => 'التقاط سجل الحافظة في الخلفية';

  @override
  String get proWidgets => 'أدوات ذكية للمحترفين';

  @override
  String get proWidgetsDesc => 'جميع الميزات متوفرة على شاشتك الرئيسية';

  @override
  String get dataExport => 'البيانات والتصدير';

  @override
  String get advancedBackup => 'نسخ احتياطي متقدم';

  @override
  String get advancedBackupDesc => 'استيراد/تصدير آمن لجميع البيانات';

  @override
  String get pdfExport => 'تصدير إلى PDF';

  @override
  String get pdfExportDesc => 'تصدير الملاحظات واليوميات إلى PDF';

  @override
  String get printReady => 'جاهز للطباعة';

  @override
  String get printReadyDesc => 'دعم الطباعة المباشرة';

  @override
  String get richTextEditor => 'محرر نص غني';

  @override
  String get advancedSearch => 'بحث متقدم';

  @override
  String get advancedSearchDesc => 'البحث والاستبدال داخل النص';

  @override
  String get richMedia => 'وسائط غنية';

  @override
  String get richMediaDesc => 'إدراج صور وفيديوهات وروابط';

  @override
  String get editorStyling => 'تنسيق المحرر';

  @override
  String get editorStylingDesc => 'نص مخصص وخلفيات للمحرر';

  @override
  String get balance => 'الرصيد';

  @override
  String get loadingAd => 'جارٍ تحميل الإعلان...';

  @override
  String watchAd(Object amount) {
    return 'مشاهدة إعلان (+$amount)';
  }

  @override
  String get loadAd => 'تحميل إعلان';

  @override
  String get backupDataDesc => 'حفظ ملف JSON لبياناتك';

  @override
  String get importDataDesc => 'دمج ملف نسخة احتياطية في CopyClip';

  @override
  String get notificationPermissionDenied => 'تم رفض إذن الإشعارات.';

  @override
  String get typeNewTask => 'اكتب مهمة جديدة...';

  @override
  String get addTask => 'إضافة مهمة';

  @override
  String get completed => 'مكتمل';

  @override
  String get greatJob => 'عمل رائع!';

  @override
  String youEarnedXPNextTask(Object amount, Object date) {
    return 'لقد ربحت $amount XP! المهمة التالية: $date';
  }

  @override
  String taskCompletedXP(Object amount) {
    return 'تمت المهمة! +$amount XP';
  }

  @override
  String get moveTasksToRecycleBin =>
      'نقل جميع المهام النشطة إلى سلة المحذوفات؟';

  @override
  String get deleteAllPosts => 'حذف جميع المنشورات';

  @override
  String get deleteAllPostsConfirmation =>
      'هل أنت متأكد أنك تريد حذف جميع المنشورات الاجتماعية؟ لا يمكن التراجع عن هذا الإجراء.';

  @override
  String get allPosts => 'جميع المنشورات';

  @override
  String get favorites => 'المفضلة';

  @override
  String get drafts => 'المسودات';

  @override
  String get noFavoritesYet => 'لا توجد مفضلات بعد';

  @override
  String get noDraftsYet => 'لا توجد مسودات بعد';

  @override
  String get startSocialJourney => 'ابدأ رحلتك الاجتماعية!';

  @override
  String get draft => 'مسودة';

  @override
  String attachmentCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count مرفقات',
      two: 'مرفقان',
      one: 'مرفق واحد',
      zero: 'لا توجد مرفقات',
    );
    return '$_temp0';
  }

  @override
  String get pleaseAddContent => 'يرجى إضافة بعض المحتوى أو الوسائط للمشاركة';

  @override
  String fileNotFoundError(Object path) {
    return 'خطأ: لم يتم العثور على الملف في $path';
  }

  @override
  String get checkFacebookApp => 'تحقق من تطبيق فيسبوك';

  @override
  String get systemShare => 'مشاركة النظام';

  @override
  String get socialPost => 'منشور اجتماعي';

  @override
  String get favorite => 'مفضل';

  @override
  String get saveDraft => 'حفظ المسودة';

  @override
  String get entryCopied => 'تم نسخ المدخل';

  @override
  String get moveEntriesToRecycleBin =>
      'نقل جميع المدخلات النشطة إلى سلة المحذوفات؟';

  @override
  String get startWritingStory => 'ابدأ بكتابة قصتك';

  @override
  String get recordMemories => 'سجل ذكرياتك ومشاعرك اليومية.';

  @override
  String get writeJournal => 'اكتب يومياتك';

  @override
  String get myMemories => 'ذكرياتي';

  @override
  String get sortJournal => 'فرز اليوميات';

  @override
  String get byMood => 'حسب المزاج';

  @override
  String get searchMemories => 'بحث في الذكريات...';

  @override
  String get selectAll => 'تحديد الكل';

  @override
  String get deleteSelected => 'حذف المحدد';

  @override
  String get taskCompletedExclamation => 'تمت المهمة!';

  @override
  String get taskUncompletedExclamation => 'مهمة غير مكتملة';

  @override
  String get clipboardUpdatedExclamation => 'تم تحديث الحافظة!';

  @override
  String clipboardSavedContent(Object content) {
    return 'تم حفظ في الحافظة: $content';
  }

  @override
  String get overview => 'نظرة عامة';

  @override
  String get colorAurora => 'أورورا';

  @override
  String get colorCosmic => 'كوني';

  @override
  String get colorNebula => 'سديم';

  @override
  String get colorStarlight => 'ضوء النجوم';

  @override
  String get colorSolar => 'شمسي';

  @override
  String get colorNova => 'نوفا';

  @override
  String get loadingStepLoading => 'جارٍ التحميل...';

  @override
  String get loadingStepDatabase => 'إعداد قاعدة البيانات...';

  @override
  String get loadingStepSystem => 'تكوين النظام...';

  @override
  String get loadingStepReady => 'جاهز';

  @override
  String get productivityCompanion => 'رفيقك للإنتاجية';

  @override
  String get done => 'تم';

  @override
  String get newNote => 'ملاحظة جديدة';

  @override
  String get changeColor => 'تغيير اللون';

  @override
  String get copyContent => 'نسخ المحتوى';

  @override
  String get titleOptional => 'العنوان (اختياري)';

  @override
  String get exportAsPdf => 'تصدير كـ PDF';

  @override
  String get taskDueNow => 'موعد المهمة الآن';

  @override
  String get moveTaskToBinTitle => 'نقل المهمة إلى سلة المحذوفات؟';

  @override
  String get restoreTaskLater =>
      'يمكنك استعادة هذه المهمة لاحقاً من الإعدادات.';

  @override
  String get newTask => 'مهمة جديدة';

  @override
  String get editTask => 'تعديل المهمة';

  @override
  String get undo => 'تراجع';

  @override
  String get redo => 'إعادة';

  @override
  String get category => 'الفئة';

  @override
  String get categoryHint => 'مثال: العمل، النادي';

  @override
  String get whatNeedsToBeDone => 'ما الذي يجب القيام به؟';

  @override
  String get enterTaskDetails => 'أدخل تفاصيل المهمة...';

  @override
  String get setDueDate => 'تحديد موعد الاستحقاق';

  @override
  String get dueDate => 'موعد الاستحقاق';

  @override
  String get expenseTitle => 'النفقات';

  @override
  String searchInCurrency(String currency) {
    return 'بحث في $currency...';
  }

  @override
  String get sortAndFilter => 'فرز وتصفية';

  @override
  String get sortBy => 'فرز حسب';

  @override
  String get highestAmount => 'أعلى مبلغ';

  @override
  String get lowestAmount => 'أقل مبلغ';

  @override
  String get moreFilters => 'مزيد من الفلاتر...';

  @override
  String get filterExpenses => 'تصفية النفقات';

  @override
  String get transactionType => 'نوع المعاملة';

  @override
  String get categories => 'الفئات';

  @override
  String get all => 'الكل';

  @override
  String get income => 'الدخل';

  @override
  String get expense => 'المصروفات';

  @override
  String get reset => 'إعادة تعيين';

  @override
  String get apply => 'تطبيق';

  @override
  String newExpense(String currency) {
    return 'جديد $currency';
  }

  @override
  String errorLoadingData(String error) {
    return 'حدث خطأ أثناء تحميل البيانات.\n\n$error';
  }

  @override
  String get dailyQuote1 => 'أفضل طريقة للتنبؤ بالمستقبل هي أن تصنعه.';

  @override
  String get dailyQuote2 => 'الغنى ليس في كثرة العرض، ولكن الغنى غنى النفس.';

  @override
  String get dailyQuote3 => 'الوقت هو العملة الأغلى.';

  @override
  String get dailyQuote4 => 'النجاح ليس نهائياً، والفشل ليس قاتلاً.';

  @override
  String get dailyQuote5 => 'ركز على الحل، وليس المشكلة.';

  @override
  String get dailyQuote6 => 'شبكة علاقاتك هي ثروتك الحقيقية.';

  @override
  String get moodHappy => 'سعيد';

  @override
  String get moodExcited => 'متحمس';

  @override
  String get moodNeutral => 'محايد';

  @override
  String get moodSad => 'حزين';

  @override
  String get moodStressed => 'متوتر';

  @override
  String exportDate(String date) {
    return '📅 $date';
  }

  @override
  String exportMood(String emoji, String mood) {
    return 'المزاج: $emoji $mood';
  }

  @override
  String exportTitle(String title) {
    return 'العنوان: $title';
  }

  @override
  String exportTags(String tags) {
    return '\nالوسوم: $tags';
  }

  @override
  String get instagram => 'إنستغرام';

  @override
  String get facebook => 'فيسبوك';

  @override
  String get tiktok => 'تيك توك';

  @override
  String get newSketch => 'رسمة جديدة';

  @override
  String get searchSketches => 'البحث في الرسومات والمجلدات...';

  @override
  String get noResultsFound => 'لم يتم العثور على نتائج';

  @override
  String get noItems => 'لا توجد عناصر';

  @override
  String get noDrawingsYet => 'لا توجد رسومات بعد';

  @override
  String get canvasIntro => 'أطلق العنان لإبداعك على اللوحة!';

  @override
  String get newCanvas => 'لوحة جديدة';

  @override
  String get rename => 'إعادة تسمية';

  @override
  String get deleteFolder => 'حذف المجلد';

  @override
  String get deleteSketchesQuestion => 'حذف الرسومات؟';

  @override
  String get deleteFolderConfirmation =>
      'سيتم حذف جميع الرسومات في هذا المجلد نهائياً.';

  @override
  String get renameFolder => 'إعادة تسمية المجلد';

  @override
  String get chooseColor => 'اختر لوناً';

  @override
  String get deleteFolderQuestion => 'حذف المجلد؟';

  @override
  String get searchClips => 'البحث في القصاصات...';

  @override
  String get clipboardEmpty => 'الحافظة فارغة';

  @override
  String get addItem => 'إضافة عنصر';

  @override
  String get clipColor => 'لون القصاصة';

  @override
  String get newClip => 'قصاصة جديدة';

  @override
  String get editClip => 'تعديل القصاصة';

  @override
  String get restoreClipLater => 'يمكنك استعادة هذه القصاصة لاحقاً.';

  @override
  String get upcomingEvents => 'الأحداث القادمة';

  @override
  String get dataDistribution => 'توزيع البيانات';

  @override
  String get taskProgress => 'تقدم المهمة';

  @override
  String get quickStats => 'إحصيات سريعة';

  @override
  String get taskCompletion => 'إكمال المهمة';

  @override
  String get noItemsForDate => 'لا توجد عناصر لهذا التاريخ';

  @override
  String get enjoyFreeTime => 'استمتع بوقت فراغك!';

  @override
  String get searchThisDay => 'البحث في هذا اليوم...';

  @override
  String get finance => 'المالية';

  @override
  String get permanentlyDelete => 'حذف نهائي؟';

  @override
  String deleteSelectionConfirmation(int foldersCount, int sketchesCount) {
    return 'سيؤدي هذا إلى حذف $foldersCount مجلدات (ورسماتها) و $sketchesCount رسومات أخرى نهائياً.\n\nلا يمكن التراجع عن هذا الإجراء.';
  }

  @override
  String get deleteForever => 'حذف للأبد';

  @override
  String selectedCount(int count) {
    return '$count محدد';
  }

  @override
  String canvasStats(int notes, int folders) {
    return '$notes رسومات • $folders مجلدات';
  }

  @override
  String get sortItems => 'فرز العناصر';

  @override
  String get sortNameAZ => 'الاسم (أ-ي)';

  @override
  String get sortNameZA => 'الاسم (ي-أ)';

  @override
  String get createFolder => 'إنشاء مجلد';

  @override
  String get folderNameHint => 'اسم المجلد...';

  @override
  String deleteSketchesConfirmation(int count) {
    return 'حذف $count رسومات؟ لا يمكن التراجع عن هذا الإجراء.';
  }

  @override
  String get noSketchesFound => 'لم يتم العثور على رسومات';

  @override
  String get noSketchesFoundSub => 'حاول تعديل بحثك أو إنشاء رسمة جديدة.';

  @override
  String searchInFolder(String folder) {
    return 'بحث في $folder...';
  }

  @override
  String sketchesCount(int count) {
    return '$count رسومات';
  }

  @override
  String get sortSketches => 'فرز الرسومات';

  @override
  String get calendarScreenTitle => 'التقويم';

  @override
  String get dailyActivity => 'النشاط اليومي';

  @override
  String get deleteItemQuestion => 'حذف العنصر؟';

  @override
  String get deleteItemConfirmation =>
      'سيؤدي هذا إلى نقل العنصر إلى سلة المحذوفات.';

  @override
  String get moveToBinItem => 'نقل إلى السلة؟';

  @override
  String get moveToBinConfirmation => 'يمكنك استعادته لاحقاً.';

  @override
  String selectedItems(int count) {
    return '$count محدد';
  }

  @override
  String get recentClips => 'القصاصات الأخيرة';

  @override
  String get copied => 'تم النسخ!';

  @override
  String get copiedPlainText => 'تم نسخ النص المجرد';

  @override
  String get clipTheme => 'مظهر القصاصة';

  @override
  String get justNow => 'الآن';

  @override
  String minutesAgo(Object count) {
    return 'منذ $count د';
  }

  @override
  String hoursAgo(Object count) {
    return 'منذ $count س';
  }

  @override
  String daysAgo(Object count) {
    return 'منذ $count ي';
  }

  @override
  String get noTasksFound => 'لم يتم العثور على مهام.';

  @override
  String get searchTasks => 'بحث في المهام...';

  @override
  String get taskReminder => 'تذكير بالمهمة';

  @override
  String get untitledNote => 'ملاحظة بدون عنوان';

  @override
  String get dailyEntry => 'مدخل يومي';

  @override
  String get clipboardHistory => 'سجل الحافظة';

  @override
  String get deletePermanentlyContent => 'هذا الإجراء لا يمكن التراجع عنه.';

  @override
  String get emptyRecycleBinTitle => 'إفراغ سلة المحذوفات؟';

  @override
  String emptyRecycleBinContent(Object count) {
    return 'سيتم حذف جميع العناصر الـ $count نهائياً.';
  }

  @override
  String get emptyBin => 'إفراغ السلة';

  @override
  String get recycleBinEmpty => 'سلة المحذوفات فارغة';

  @override
  String get deletedItemsAppearHere => 'العناصر المحذوفة ستظهر هنا.';

  @override
  String get empty => 'فارغ';

  @override
  String get recent => 'الأخيرة';

  @override
  String categoryLabel(Object category) {
    return 'الفئة: $category';
  }

  @override
  String get general => 'عام';

  @override
  String get saveTransactionQuestion => 'هل تريد حفظ هذه المعاملة؟';

  @override
  String get fillTitleAmount => 'يرجى ملء العنوان والمبلغ';

  @override
  String get invalidAmount => 'تنسيق المبلغ غير صالح';

  @override
  String get moveTransactionToBinTitle => 'نقل المعاملة إلى سلة المحذوفات؟';

  @override
  String get restoreTransactionLater =>
      'يمكنك استعادة هذه المعاملة لاحقاً من الإعدادات.';

  @override
  String get newTransaction => 'معاملة جديدة';

  @override
  String get whatIsThisFor => 'فيما هذا؟';

  @override
  String get description => 'الوصف';

  @override
  String get daily => 'يومياً';

  @override
  String get weekly => 'أسبوعياً';

  @override
  String get monthly => 'شهرياً';

  @override
  String get yearly => 'سنوياً';

  @override
  String get totalIncome => 'إجمالي الدخل';

  @override
  String get totalExpense => 'إجمالي النفقات';

  @override
  String get analysis => 'التحليل';

  @override
  String get transactions => 'المعاملات';

  @override
  String get noExpensesFound => 'لم يتم العثور على نفقات لهذه الفترة.';

  @override
  String get netBalance => 'صافي الرصيد';

  @override
  String get topCategories => 'أبرز الفئات';

  @override
  String get spendingTrend => 'اتجاه الإنفاق';

  @override
  String get insights => 'رؤى';

  @override
  String get noExpensesRecorded => 'لم يتم تسجيل أي نفقات';

  @override
  String get trackSpendingHabits => 'تتبع عادات الإنفاق الخاصة بك بسهولة.';

  @override
  String get addExpense => 'إضافة نفقة';

  @override
  String get noDataForPeriod => 'لا توجد بيانات لهذه الفترة';

  @override
  String get budget => 'الميزانية';

  @override
  String get spent => 'تم صرفه';

  @override
  String get limit => 'الحد';

  @override
  String get overBudget => 'تجاوز الميزانية!';

  @override
  String remainingBudget(Object percent) {
    return 'متبقي $percent%';
  }

  @override
  String get savingsRate => 'معدل الادخار';

  @override
  String get healthScore => 'درجة الصحة المالية';

  @override
  String get healthScoreExplanation =>
      'هذه الدرجة تعتمد على معدل ادخارك.\n\n• ادخار > 50% = ممتاز (100)\n• ادخار 0% = متوسط (50)\n• الإنفاق > الدخل = ضعيف (<50)';

  @override
  String get ok => 'موافق';

  @override
  String get bulkImport => 'استيراد بالجملة';
}

/// The translations for Arabic, as used in Kuwait (`ar_KW`).
class AppLocalizationsArKw extends AppLocalizationsAr {
  AppLocalizationsArKw() : super('ar_KW');

  @override
  String get settings => 'إعدادات';

  @override
  String get language => 'لغة';

  @override
  String get systemDefault => 'النظام الافتراضي';

  @override
  String get notes => 'ملحوظات';

  @override
  String get todos => 'المهام';

  @override
  String get expenses => 'نفقات';

  @override
  String get journal => 'مجلة';

  @override
  String get calendar => 'تقويم';

  @override
  String get clipboard => 'الحافظة';

  @override
  String get canvas => 'قماش';

  @override
  String get save => 'حفظ';

  @override
  String get create => 'إنشاء';

  @override
  String get cancel => 'إلغاء';

  @override
  String get delete => 'حذف';

  @override
  String get edit => 'تعديل';

  @override
  String get share => 'مشاركة';

  @override
  String get copy => 'نسخ';

  @override
  String get unsavedChanges => 'تغييرات غير محفوظة';

  @override
  String get confirmDelete => 'تأكيد الحذف';

  @override
  String get discard => 'تجاهل';

  @override
  String get createPost => 'إنشاء منشور';

  @override
  String get post => 'منشور';

  @override
  String get postingTo => 'النشر في';

  @override
  String get whatsOnYourMind => 'ماذا يدور في ذهنك؟';

  @override
  String get pickImages => 'اختر صورًا';

  @override
  String get pickVideo => 'اختر فيديو';

  @override
  String get camera => 'كاميرا';

  @override
  String get gallery => 'معرض الصور';

  @override
  String get search => 'بحث';

  @override
  String get pleaseEnterTask => 'يرجى إدخال مهمة';

  @override
  String get deleteTask => 'حذف المهمة';

  @override
  String get selectItems => 'حدد العناصر';

  @override
  String get deleteAll => 'حذف الكل';

  @override
  String error(Object error) {
    return 'خطأ: $error';
  }

  @override
  String get orderingOnlyAvailableInAllPosts =>
      'الترتيب متاح فقط في \"جميع المنشورات\"';

  @override
  String get deletePost => 'حذف المنشور';

  @override
  String get postDeleted => 'تم حذف المنشور';

  @override
  String get premiumFeatures => 'ميزات بريميوم';

  @override
  String get manageCoinsAdsPremium =>
      'إدارة العملات والإعلانات وحالة البريميوم';

  @override
  String get themeMode => 'وضع المظهر';

  @override
  String get accentColor => 'لون التمييز';

  @override
  String get backgroundDesign => 'تصميم الخلفية';

  @override
  String get pushNotifications => 'إشعارات الدفع';

  @override
  String get recycleBin => 'سلة المحذوفات';

  @override
  String get exportData => 'تصدير البيانات';

  @override
  String get importData => 'استيراد البيانات';

  @override
  String get rateApp => 'تقييم التطبيق';

  @override
  String get sendFeedback => 'إرسال تعليقات';

  @override
  String get privacyPolicy => 'سياسة الخصوصية';

  @override
  String get version => 'الإصدار';

  @override
  String get buildNumber => 'رقم البناء';

  @override
  String get system => 'النظام';

  @override
  String get light => 'فاتح';

  @override
  String get dark => 'داكن';

  @override
  String get itemRestored => 'تمت استعادة العنصر';

  @override
  String get recycleBinCleared => 'تم إفراغ سلة المحذوفات بنجاح';

  @override
  String get allPostsDeleted => 'تم حذف جميع المنشورات';

  @override
  String get newPost => 'منشور جديد';

  @override
  String get textCopiedToClipboardFacebook =>
      'Text copied to clipboard (Facebook policy)';

  @override
  String get tiktokSharingRequiresVideoImage =>
      'تتطلب مشاركة TikTok فيديو/صورة';

  @override
  String errorSharing(Object error) {
    return 'خطأ في المشاركة: $error';
  }

  @override
  String shareToStory(Object platform) {
    return 'مشاركة في قصة $platform';
  }

  @override
  String shareToFeed(Object platform) {
    return 'مشاركة في موجز $platform';
  }

  @override
  String get unlockPermanently => 'فتح بشكل دائم';

  @override
  String get notEnoughCoins => 'لا توجد عملات كافية!';

  @override
  String youEarnedCoins(Object amount) {
    return 'لقد ربحت $amount من العملات!';
  }

  @override
  String get contentCopied => 'تم نسخ المحتوى';

  @override
  String get selectDateTime => 'حدد التاريخ والوقت';

  @override
  String get areYouSureYouWantToDeleteThisPost =>
      'هل أنت متأكد أنك تريد حذف هذا المنشور؟';

  @override
  String get socialPosts => 'منشورات اجتماعية';

  @override
  String get watchAdToEarnCoins => 'شاهد إعلانًا لربح العملات';

  @override
  String get premiumUnlocked => 'تم فتح البريميوم';

  @override
  String get removeAds => 'إزالة الإعلانات';

  @override
  String get unlimitedCloudStorage => 'تخزين سحابي غير محدود';

  @override
  String get deleteNote => 'حذف الملاحظة';

  @override
  String get shareNote => 'مشاركة الملاحظة';

  @override
  String get editNote => 'تعديل الملاحظة';

  @override
  String get searchNotes => 'البحث في الملاحظات...';

  @override
  String get noNotesFound => 'لم يتم العثور على ملاحظات';

  @override
  String get captureThoughts => 'سجل أفكارك فورا.';

  @override
  String get createNote => 'إنشاء ملاحظة';

  @override
  String get customOrder => 'ترتيب مخصص';

  @override
  String get newestFirst => 'الأحدث أولاً';

  @override
  String get oldestFirst => 'الأقدم أولاً';

  @override
  String get titleAZ => 'العنوان: أ-ي';

  @override
  String get titleZA => 'العنوان: ي-أ';

  @override
  String get deleteAllQuestion => 'حذف الكل؟';

  @override
  String get moveToRecycleBin => 'نقل جميع الملاحظات إلى سلة المحذوفات؟';

  @override
  String get moveToBinQuestion => 'نقل إلى السلة؟';

  @override
  String get restoreNoteLater => 'يمكنك استعادة هذه الملاحظة لاحقًا.';

  @override
  String get move => 'نقل';

  @override
  String get myThoughts => 'أفكاري';

  @override
  String get selected => 'محدد';

  @override
  String get noContent => 'لا يوجد محتوى';

  @override
  String get untitled => 'بدون عنوان';

  @override
  String get chooseWallpapers => 'اختر من بين أكثر من 10 خلفيات ديناميكية';

  @override
  String get backupData => 'نسخ احتياطي للبيانات';

  @override
  String get saveJsonFile => 'هل تريد حفظ ملف JSON يحتوي على جميع بياناتك؟';

  @override
  String get exportNow => 'تصدير الآن';

  @override
  String get importDataTitle => 'استيراد البيانات';

  @override
  String get mergeBackupFile =>
      'هل تريد دمج ملف النسخ الاحتياطي مع العناصر الحالية؟';

  @override
  String get selectFile => 'حدد ملفاً';

  @override
  String get backupSaved => 'تم حفظ النسخة الاحتياطية بنجاح!';

  @override
  String get exportFailed => 'فشل التصدير.';

  @override
  String importSuccess(Object count) {
    return 'تمت استعادة $count من العناصر بنجاح!';
  }

  @override
  String get importFailed => 'فشل الاستيراد.';

  @override
  String widgetAdded(String widget) {
    return 'تمت إضافة الأداة $widget إلى الشاشة الرئيسية!';
  }

  @override
  String get widgetRequestSent =>
      'تم إرسال طلب الأداة. يرجى التحقق من الشاشة الرئيسية.';

  @override
  String get widgetAddFailed => 'فشل إضافة الأداة';

  @override
  String get autoSaveEnabled => 'تم تفعيل الحفظ التلقائي.';

  @override
  String get autoSaveDisabled => 'تم تعطيل الحفظ التلقائي.';

  @override
  String get homeScreenWidgets => 'أدوات الشاشة الرئيسية';

  @override
  String get notificationsTitle => 'الإشعارات';

  @override
  String get dataBackup => 'البيانات والنسخ الاحتياطي';

  @override
  String get feedbackSupport => 'التعليقات والدعم';

  @override
  String get creditsTitle => 'الاعتمادات';

  @override
  String get privacyMaintenance => 'الخصوصية والصيانة';

  @override
  String get aboutTitle => 'حول';

  @override
  String get premium => 'بريميوم';

  @override
  String get appearanceTitle => 'المظهر';

  @override
  String get clipboardTitle => 'الحافظة';

  @override
  String get settingsSubtitle => 'تخصيص تجربتك';

  @override
  String get welcomeTitle => 'مرحبًا بك في CopyClip';

  @override
  String get welcomeDescription =>
      'رفيقك النهائي للإنتاجية. دعنا نجهزك بأدوات قوية لإدارة يومك.';

  @override
  String get onboardingNotesTitle => 'ملاحظات ذكية';

  @override
  String get onboardingNotesDesc =>
      'التقط الأفكار فورًا بتنسيق نص غني. نظم أفكارك ولا تفقد أي فكرة رائعة مرة أخرى.';

  @override
  String get onboardingTodosTitle => 'إدارة المهام';

  @override
  String get onboardingTodosDesc =>
      'ابق مطلعاً على أمورك. أنشئ قوائم مهام، وحدد الأولويات، وحقق أهدافك خطوة بخطوة.';

  @override
  String get onboardingExpensesTitle => 'تتبع النفقات';

  @override
  String get onboardingExpensesDesc =>
      'تحكم في أموالك. تتبع الدخل والنفقات بسهولة لفهم عادات الإنفاق الخاصة بك.';

  @override
  String get onboardingJournalTitle => 'يوميات شخصية';

  @override
  String get onboardingJournalDesc =>
      'تأمل في يومك. مساحة خاصة لتدوين ذكرياتك ومشاعرك وتجاربك اليومية.';

  @override
  String get onboardingCalendarTitle => 'التقويم والأحداث';

  @override
  String get onboardingCalendarDesc =>
      'لا تفوت أي لحظة. نظم جدولك وتابع الأحداث الهامة القادمة.';

  @override
  String get onboardingClipboardTitle => 'مدير الحافظة';

  @override
  String get onboardingClipboardDesc =>
      'انسخ مرة واحدة، والصق في أي مكان. الوصول إلى سجل الحافظة لاستعادة النصوص التي نسختها سابقاً.';

  @override
  String get onboardingCanvasTitle => 'لوحة إبداعية';

  @override
  String get onboardingCanvasDesc =>
      'أطلق العنان لإبداعك. ارسم وخطط وصور أفكارك على لوحة رقمية حرة.';

  @override
  String get featuresNotesDesc => 'إنشاء وإدارة الملاحظات الخاصة بك';

  @override
  String get featuresTodosDesc => 'تتبع المهام الخاصة بك';

  @override
  String get featuresExpensesDesc => 'مراقبة النفقات الخاصة بك';

  @override
  String get featuresJournalDesc => 'اكتتب أفكارك';

  @override
  String get featuresCalendarDesc => 'نظم جدولك الزمني';

  @override
  String get featuresClipboardDesc => 'الوصول إلى سجل الحافظة الخاص بك';

  @override
  String get featuresCanvasDesc => 'ارسم وخطط بحرية';

  @override
  String get featuresSocialPost => 'منشور اجتماعي';

  @override
  String get featuresSocialPostDesc =>
      'إنشاء محتوى جذاب لوسائل التواصل الاجتماعي';

  @override
  String get chooseYourAura => 'اختر هالتك';

  @override
  String get expressYourselfTheme => 'عبر عن نفسك بلون مظهر جديد!';

  @override
  String get level => 'المستوى';

  @override
  String get xpToNextLevel => 'XP للمستوى التالي';

  @override
  String get checkUpcomingEvents => 'تحقق من الأحداث القادمة';

  @override
  String get startNewSketch => 'بدأ رسمة جديدة';

  @override
  String get noTransactionsMonth => 'لا توجد معاملات هذا الشهر';

  @override
  String transactionsThisMonth(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count معاملات هذا الشهر',
      few: '$count معاملات هذا الشهر',
      two: 'معاملتان هذا الشهر',
      one: 'معاملة واحدة هذا الشهر',
      zero: 'لا توجد معاملات هذا الشهر',
    );
    return '$_temp0';
  }

  @override
  String get autoSaveClipboard => 'حفظ تلقائي للحافظة';

  @override
  String get autoSaveClipboardDesc => 'حفظ العناصر المنسوخة تلقائياً';

  @override
  String get permissionDeniedSettings =>
      'تم رفض الإذن بشكل دائم. يرجى تفعيله من الإعدادات.';

  @override
  String get notificationsEnabled => 'تم تفعيل الإشعارات!';

  @override
  String get redirectingToSettings =>
      'جارٍ التوجيه إلى الإعدادات لتعطيل الإشعارات...';

  @override
  String get premiumAccess => 'وصول بريميوم';

  @override
  String get premiumActiveUntil => 'بريميوم نشط حتى';

  @override
  String get unlockAllFeatures => 'فتح جميع الميزات';

  @override
  String get buyPremium => 'شراء بريميوم (7 أيام)';

  @override
  String costCoins(Object cost) {
    return 'التكلفة: $cost عملات';
  }

  @override
  String get premiumActivated => 'تم تفعيل البريميوم لمدة 7 أيام!';

  @override
  String get premiumActive => 'البريميوم نشط';

  @override
  String get expires => 'تنتهي الصلاحية:';

  @override
  String get temporaryAccess => 'وصول مؤقت';

  @override
  String get journalExpression => 'يوميات وتعبير';

  @override
  String get artisticDesigns => 'تصاميم فنية';

  @override
  String get artisticDesignsDesc =>
      'فتح أكثر من 10 مظاهر فريدة لبطاقات اليوميات';

  @override
  String get premiumLayouts => 'تخطيطات بريميوم';

  @override
  String get premiumLayoutsDesc => 'طرق حصرية لعرض ذكرياتك';

  @override
  String get calendarTools => 'تقويم وأدوات';

  @override
  String get fullCalendar => 'تقويم كامل';

  @override
  String get fullCalendarDesc => 'نظام متكامل لإدارة الأحداث';

  @override
  String get clipboardAutoSaveDesc => 'التقاط سجل الحافظة في الخلفية';

  @override
  String get proWidgets => 'أدوات ذكية للمحترفين';

  @override
  String get proWidgetsDesc => 'جميع الميزات متوفرة على شاشتك الرئيسية';

  @override
  String get dataExport => 'البيانات والتصدير';

  @override
  String get advancedBackup => 'نسخ احتياطي متقدم';

  @override
  String get advancedBackupDesc => 'استيراد/تصدير آمن لجميع البيانات';

  @override
  String get pdfExport => 'تصدير إلى PDF';

  @override
  String get pdfExportDesc => 'تصدير الملاحظات واليوميات إلى PDF';

  @override
  String get printReady => 'جاهز للطباعة';

  @override
  String get printReadyDesc => 'دعم الطباعة المباشرة';

  @override
  String get richTextEditor => 'محرر نص غني';

  @override
  String get advancedSearch => 'بحث متقدم';

  @override
  String get advancedSearchDesc => 'البحث والاستبدال داخل النص';

  @override
  String get richMedia => 'وسائط غنية';

  @override
  String get richMediaDesc => 'إدراج صور وفيديوهات وروابط';

  @override
  String get editorStyling => 'تنسيق المحرر';

  @override
  String get editorStylingDesc => 'نص مخصص وخلفيات للمحرر';

  @override
  String get balance => 'الرصيد';

  @override
  String get loadingAd => 'جارٍ تحميل الإعلان...';

  @override
  String watchAd(Object amount) {
    return 'مشاهدة إعلان (+$amount)';
  }

  @override
  String get loadAd => 'تحميل إعلان';

  @override
  String get backupDataDesc => 'حفظ ملف JSON لبياناتك';

  @override
  String get importDataDesc => 'دمج ملف نسخة احتياطية في CopyClip';

  @override
  String get notificationPermissionDenied => 'تم رفض إذن الإشعارات.';

  @override
  String get typeNewTask => 'اكتب مهمة جديدة...';

  @override
  String get addTask => 'إضافة مهمة';

  @override
  String get completed => 'مكتمل';

  @override
  String get greatJob => 'عمل رائع!';

  @override
  String youEarnedXPNextTask(Object amount, Object date) {
    return 'لقد ربحت $amount XP! المهمة التالية: $date';
  }

  @override
  String taskCompletedXP(Object amount) {
    return 'تمت المهمة! +$amount XP';
  }

  @override
  String get moveTasksToRecycleBin =>
      'نقل جميع المهام النشطة إلى سلة المحذوفات؟';

  @override
  String get deleteAllPosts => 'حذف جميع المنشورات';

  @override
  String get deleteAllPostsConfirmation =>
      'هل أنت متأكد أنك تريد حذف جميع المنشورات الاجتماعية؟ لا يمكن التراجع عن هذا الإجراء.';

  @override
  String get allPosts => 'جميع المنشورات';

  @override
  String get favorites => 'المفضلة';

  @override
  String get drafts => 'المسودات';

  @override
  String get noFavoritesYet => 'لا توجد مفضلات بعد';

  @override
  String get noDraftsYet => 'لا توجد مسودات بعد';

  @override
  String get startSocialJourney => 'ابدأ رحلتك الاجتماعية!';

  @override
  String get draft => 'مسودة';

  @override
  String attachmentCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count مرفقات',
      few: '$count مرفقات',
      two: 'مرفقان',
      one: 'مرفق واحد',
      zero: 'لا توجد مرفقات',
    );
    return '$_temp0';
  }

  @override
  String get pleaseAddContent => 'يرجى إضافة بعض المحتوى أو الوسائط للمشاركة';

  @override
  String fileNotFoundError(Object path) {
    return 'خطأ: لم يتم العثور على الملف في $path';
  }

  @override
  String get checkFacebookApp => 'تحقق من تطبيق فيسبوك';

  @override
  String get systemShare => 'مشاركة النظام';

  @override
  String get socialPost => 'منشور اجتماعي';

  @override
  String get favorite => 'مفضل';

  @override
  String get saveDraft => 'حفظ المسودة';

  @override
  String get entryCopied => 'تم نسخ المدخل';

  @override
  String get moveEntriesToRecycleBin =>
      'نقل جميع المدخلات النشطة إلى سلة المحذوفات؟';

  @override
  String get startWritingStory => 'ابدأ بكتابة قصتك';

  @override
  String get recordMemories => 'سجل ذكرياتك ومشاعرك اليومية.';

  @override
  String get writeJournal => 'اكتب يومياتك';

  @override
  String get myMemories => 'ذكرياتي';

  @override
  String get sortJournal => 'فرز اليوميات';

  @override
  String get byMood => 'حسب المزاج';

  @override
  String get searchMemories => 'بحث في الذكريات...';

  @override
  String get selectAll => 'تحديد الكل';

  @override
  String get deleteSelected => 'حذف المحدد';

  @override
  String get taskCompletedExclamation => 'تمت المهمة!';

  @override
  String get taskUncompletedExclamation => 'مهمة غير مكتملة';

  @override
  String get clipboardUpdatedExclamation => 'تم تحديث الحافظة!';

  @override
  String clipboardSavedContent(Object content) {
    return 'تم حفظ في الحافظة: $content';
  }

  @override
  String get overview => 'نظرة عامة';

  @override
  String get colorAurora => 'أورورا';

  @override
  String get colorCosmic => 'كوني';

  @override
  String get colorNebula => 'سديم';

  @override
  String get colorStarlight => 'ضوء النجوم';

  @override
  String get colorSolar => 'شمسي';

  @override
  String get colorNova => 'نوفا';

  @override
  String get loadingStepLoading => 'جارٍ التحميل...';

  @override
  String get loadingStepDatabase => 'إعداد قاعدة البيانات...';

  @override
  String get loadingStepSystem => 'تكوين النظام...';

  @override
  String get loadingStepReady => 'جاهز';

  @override
  String get productivityCompanion => 'رفيقك للإنتاجية';

  @override
  String get done => 'تم';

  @override
  String get newNote => 'ملاحظة جديدة';

  @override
  String get changeColor => 'تغيير اللون';

  @override
  String get copyContent => 'نسخ المحتوى';

  @override
  String get titleOptional => 'العنوان (اختياري)';

  @override
  String get exportAsPdf => 'تصدير كـ PDF';

  @override
  String get taskDueNow => 'موعد المهمة الآن';

  @override
  String get moveTaskToBinTitle => 'نقل المهمة إلى سلة المحذوفات؟';

  @override
  String get restoreTaskLater =>
      'يمكنك استعادة هذه المهمة لاحقًا من الإعدادات.';

  @override
  String get newTask => 'مهمة جديدة';

  @override
  String get editTask => 'تعديل المهمة';

  @override
  String get undo => 'تراجع';

  @override
  String get redo => 'إعادة';

  @override
  String get category => 'الفئة';

  @override
  String get categoryHint => 'مثال: العمل، النادي';

  @override
  String get whatNeedsToBeDone => 'ما الذي يجب القيام به؟';

  @override
  String get enterTaskDetails => 'أدخل تفاصيل المهمة...';

  @override
  String get setDueDate => 'تحديد موعد الاستحقاق';

  @override
  String get dueDate => 'موعد الاستحقاق';

  @override
  String get expenseTitle => 'النفقات';

  @override
  String searchInCurrency(String currency) {
    return 'بحث في $currency...';
  }

  @override
  String get sortAndFilter => 'فرز وتصفية';

  @override
  String get sortBy => 'فرز حسب';

  @override
  String get highestAmount => 'أعلى مبلغ';

  @override
  String get lowestAmount => 'أقل مبلغ';

  @override
  String get moreFilters => 'مزيد من الفلاتر...';

  @override
  String get filterExpenses => 'تصفية النفقات';

  @override
  String get transactionType => 'نوع المعاملة';

  @override
  String get categories => 'الفئات';

  @override
  String get all => 'الكل';

  @override
  String get income => 'الدخل';

  @override
  String get expense => 'المصروفات';

  @override
  String get reset => 'إعادة تعيين';

  @override
  String get apply => 'تطبيق';

  @override
  String newExpense(String currency) {
    return 'جديد $currency';
  }

  @override
  String errorLoadingData(String error) {
    return 'حدث خطأ أثناء تحميل البيانات.\n\n$error';
  }

  @override
  String get dailyQuote1 => 'أفضل طريقة للتنبؤ بالمستقبل هي أن تصنعه.';

  @override
  String get dailyQuote2 => 'الغنى ليس في كثرة العرض، ولكن الغنى غنى النفس.';

  @override
  String get dailyQuote3 => 'الوقت هو العملة الأغلى.';

  @override
  String get dailyQuote4 => 'النجاح ليس نهائياً، والفشل ليس قاتلاً.';

  @override
  String get dailyQuote5 => 'ركز على الحل، وليس المشكلة.';

  @override
  String get dailyQuote6 => 'شبكة علاقاتك هي ثروتك الحقيقية.';

  @override
  String get moodHappy => 'سعيد';

  @override
  String get moodExcited => 'متحمس';

  @override
  String get moodNeutral => 'محايد';

  @override
  String get moodSad => 'حزين';

  @override
  String get moodStressed => 'متوتر';

  @override
  String exportDate(String date) {
    return '📅 $date';
  }

  @override
  String exportMood(String emoji, String mood) {
    return 'المزاج: $emoji $mood';
  }

  @override
  String exportTitle(String title) {
    return 'العنوان: $title';
  }

  @override
  String exportTags(String tags) {
    return '\nالوسوم: $tags';
  }

  @override
  String get instagram => 'إنستغرام';

  @override
  String get facebook => 'فيسبوك';

  @override
  String get tiktok => 'تيك توك';

  @override
  String get newSketch => 'رسمة جديدة';

  @override
  String get searchSketches => 'البحث في الرسومات والمجلدات...';

  @override
  String get noResultsFound => 'لم يتم العثور على نتائج';

  @override
  String get noItems => 'لا توجد عناصر';

  @override
  String get noDrawingsYet => 'لا توجد رسومات بعد';

  @override
  String get canvasIntro => 'أطلق العنان لإبداعك على اللوحة!';

  @override
  String get newCanvas => 'لوحة جديدة';

  @override
  String get rename => 'إعادة تسمية';

  @override
  String get deleteFolder => 'حذف المجلد';

  @override
  String get deleteSketchesQuestion => 'حذف الرسومات؟';

  @override
  String get deleteFolderConfirmation =>
      'سيتم حذف جميع الرسومات في هذا المجلد نهائياً.';

  @override
  String get renameFolder => 'إعادة تسمية المجلد';

  @override
  String get chooseColor => 'اختر لوناً';

  @override
  String get deleteFolderQuestion => 'حذف المجلد؟';

  @override
  String get searchClips => 'البحث في القصاصات...';

  @override
  String get clipboardEmpty => 'الحافظة فارغة';

  @override
  String get addItem => 'إضافة عنصر';

  @override
  String get clipColor => 'لون القصاصة';

  @override
  String get newClip => 'قصاصة جديدة';

  @override
  String get editClip => 'تعديل القصاصة';

  @override
  String get restoreClipLater => 'يمكنك استعادة هذه القصاصة لاحقاً.';

  @override
  String get upcomingEvents => 'الأحداث القادمة';

  @override
  String get dataDistribution => 'توزيع البيانات';

  @override
  String get taskProgress => 'تقدم المهمة';

  @override
  String get quickStats => 'إحصائيات سريعة';

  @override
  String get taskCompletion => 'إكمال المهمة';

  @override
  String get noItemsForDate => 'لا توجد عناصر لهذا التاريخ';

  @override
  String get enjoyFreeTime => 'استمتع بوقت فراغك!';

  @override
  String get searchThisDay => 'البحث في هذا اليوم...';

  @override
  String get finance => 'المالية';

  @override
  String get permanentlyDelete => 'حذف نهائي؟';

  @override
  String deleteSelectionConfirmation(int foldersCount, int sketchesCount) {
    return 'سيؤدي هذا إلى حذف $foldersCount مجلدات (ورسماتها) و $sketchesCount رسومات أخرى نهائياً.\n\nلا يمكن التراجع عن هذا الإجراء.';
  }

  @override
  String get deleteForever => 'حذف للأبد';

  @override
  String selectedCount(int count) {
    return '$count محدد';
  }

  @override
  String canvasStats(int notes, int folders) {
    return '$notes رسومات • $folders مجلدات';
  }

  @override
  String get sortItems => 'فرز العناصر';

  @override
  String get sortNameAZ => 'الاسم (أ-ي)';

  @override
  String get sortNameZA => 'الاسم (ي-أ)';

  @override
  String get createFolder => 'إنشاء مجلد';

  @override
  String get folderNameHint => 'اسم المجلد...';

  @override
  String deleteSketchesConfirmation(int count) {
    return 'حذف $count رسومات؟ لا يمكن التراجع عن هذا الإجراء.';
  }

  @override
  String get noSketchesFound => 'لم يتم العثور على رسومات';

  @override
  String get noSketchesFoundSub => 'حاول تعديل بحثك أو إنشاء رسمة جديدة.';

  @override
  String searchInFolder(String folder) {
    return 'بحث في $folder...';
  }

  @override
  String sketchesCount(int count) {
    return '$count رسومات';
  }

  @override
  String get sortSketches => 'فرز الرسومات';

  @override
  String get calendarScreenTitle => 'التقويم';

  @override
  String get dailyActivity => 'النشاط اليومي';

  @override
  String get deleteItemQuestion => 'حذف العنصر؟';

  @override
  String get deleteItemConfirmation =>
      'سيؤدي هذا إلى نقل العنصر إلى سلة المحذوفات.';

  @override
  String get moveToBinItem => 'نقل إلى السلة؟';

  @override
  String get moveToBinConfirmation => 'يمكنك استعادته لاحقاً.';

  @override
  String selectedItems(int count) {
    return '$count محدد';
  }

  @override
  String get recentClips => 'القصاصات الأخيرة';

  @override
  String get copied => 'تم النسخ!';

  @override
  String get copiedPlainText => 'تم نسخ النص المجرد';

  @override
  String get clipTheme => 'مظهر القصاصة';

  @override
  String get justNow => 'الآن';

  @override
  String minutesAgo(Object count) {
    return 'منذ $count د';
  }

  @override
  String hoursAgo(Object count) {
    return 'منذ $count س';
  }

  @override
  String daysAgo(Object count) {
    return 'منذ $count ي';
  }

  @override
  String get noTasksFound => 'لم يتم العثور على مهام.';

  @override
  String get searchTasks => 'بحث في المهام...';

  @override
  String get taskReminder => 'تذكير بالمهمة';

  @override
  String get untitledNote => 'ملاحظة بدون عنوان';

  @override
  String get dailyEntry => 'مدخل يومي';

  @override
  String get clipboardHistory => 'سجل الحافظة';

  @override
  String get deletePermanentlyContent => 'هذا الإجراء لا يمكن التراجع عنه.';

  @override
  String get emptyRecycleBinTitle => 'إفراغ سلة المحذوفات؟';

  @override
  String emptyRecycleBinContent(Object count) {
    return 'سيتم حذف جميع العناصر الـ $count نهائياً.';
  }

  @override
  String get emptyBin => 'إفراغ السلة';

  @override
  String get recycleBinEmpty => 'سلة المحذوفات فارغة';

  @override
  String get deletedItemsAppearHere => 'العناصر المحذوفة ستظهر هنا.';

  @override
  String get empty => 'فارغ';

  @override
  String get recent => 'الأخيرة';

  @override
  String categoryLabel(Object category) {
    return 'الفئة: $category';
  }

  @override
  String get general => 'عام';

  @override
  String get saveTransactionQuestion => 'هل تريد حفظ هذه المعاملة؟';

  @override
  String get fillTitleAmount => 'يرجى ملء العنوان والمبلغ';

  @override
  String get invalidAmount => 'تنسيق المبلغ غير صالح';

  @override
  String get moveTransactionToBinTitle => 'نقل المعاملة إلى سلة المحذوفات؟';

  @override
  String get restoreTransactionLater =>
      'يمكنك استعادة هذه المعاملة لاحقاً من الإعدادات.';

  @override
  String get newTransaction => 'معاملة جديدة';

  @override
  String get whatIsThisFor => 'فيما هذا؟';

  @override
  String get description => 'الوصف';

  @override
  String get daily => 'يومياً';

  @override
  String get weekly => 'أسبوعياً';

  @override
  String get monthly => 'شهرياً';

  @override
  String get yearly => 'سنوفياً';

  @override
  String get totalIncome => 'إجمالي الدخل';

  @override
  String get totalExpense => 'إجمالي النفقات';

  @override
  String get analysis => 'التحليل';

  @override
  String get transactions => 'المعاملات';

  @override
  String get noExpensesFound => 'لم يتم العثور على نفقات لهذه الفترة.';

  @override
  String get netBalance => 'صافي الرصيد';

  @override
  String get topCategories => 'أبرز الفئات';

  @override
  String get spendingTrend => 'اتجاه الإنفاق';

  @override
  String get insights => 'رؤى';

  @override
  String get noExpensesRecorded => 'لم يتم تسجيل أي نفقات';

  @override
  String get trackSpendingHabits => 'تتبع عادات الإنفاق الخاصة بك بسهولة.';

  @override
  String get addExpense => 'إضافة نفقة';

  @override
  String get noDataForPeriod => 'لا توجد بيانات لهذه الفترة';

  @override
  String get budget => 'الميزانية';

  @override
  String get spent => 'تم صرفه';

  @override
  String get limit => 'الحد';

  @override
  String get overBudget => 'تجاوز الميزانية!';

  @override
  String remainingBudget(Object percent) {
    return 'متبقي $percent%';
  }

  @override
  String get savingsRate => 'معدل الادخار';

  @override
  String get healthScore => 'درجة الصحة المالية';

  @override
  String get healthScoreExplanation =>
      'هذه الدرجة تعتمد على معدل ادخارك.\n\n• ادخار > 50% = ممتاز (100)\n• ادخار 0% = متوسط (50)\n• الإنفاق > الدخل = ضعيف (<50)';

  @override
  String get ok => 'موافق';

  @override
  String get bulkImport => 'استيراد بالجملة';
}

/// The translations for Arabic, as used in Lebanon (`ar_LB`).
class AppLocalizationsArLb extends AppLocalizationsAr {
  AppLocalizationsArLb() : super('ar_LB');

  @override
  String get settings => 'إعدادات';

  @override
  String get language => 'لغة';

  @override
  String get systemDefault => 'النظام الافتراضي';

  @override
  String get notes => 'ملحوظات';

  @override
  String get todos => 'المهام';

  @override
  String get expenses => 'نفقات';

  @override
  String get journal => 'مجلة';

  @override
  String get calendar => 'تقويم';

  @override
  String get clipboard => 'الحافظة';

  @override
  String get canvas => 'قماش';

  @override
  String get save => 'حفظ';

  @override
  String get create => 'إنشاء';

  @override
  String get cancel => 'إلغاء';

  @override
  String get delete => 'حذف';

  @override
  String get edit => 'تعديل';

  @override
  String get share => 'مشاركة';

  @override
  String get copy => 'نسخ';

  @override
  String get unsavedChanges => 'تغييرات غير محفوظة';

  @override
  String get confirmDelete => 'تأكيد الحذف';

  @override
  String get discard => 'تجاهل';

  @override
  String get createPost => 'إنشاء منشور';

  @override
  String get post => 'منشور';

  @override
  String get postingTo => 'النشر في';

  @override
  String get whatsOnYourMind => 'ماذا يدور في ذهنك؟';

  @override
  String get pickImages => 'اختر صورًا';

  @override
  String get pickVideo => 'اختر فيديو';

  @override
  String get camera => 'كاميرا';

  @override
  String get gallery => 'معرض الصور';

  @override
  String get search => 'بحث';

  @override
  String get pleaseEnterTask => 'يرجى إدخال مهمة';

  @override
  String get deleteTask => 'حذف المهمة';

  @override
  String get selectItems => 'حدد العناصر';

  @override
  String get deleteAll => 'حذف الكل';

  @override
  String error(Object error) {
    return 'خطأ: $error';
  }

  @override
  String get orderingOnlyAvailableInAllPosts =>
      'الترتيب متاح فقط في \"جميع المنشورات\"';

  @override
  String get deletePost => 'حذف المنشور';

  @override
  String get postDeleted => 'تم حذف المنشور';

  @override
  String get premiumFeatures => 'ميزات بريميوم';

  @override
  String get manageCoinsAdsPremium =>
      'إدارة العملات والإعلانات وحالة البريميوم';

  @override
  String get themeMode => 'وضع المظهر';

  @override
  String get accentColor => 'لون التمييز';

  @override
  String get backgroundDesign => 'تصميم الخلفية';

  @override
  String get pushNotifications => 'إشعارات الدفع';

  @override
  String get recycleBin => 'سلة المحذوفات';

  @override
  String get exportData => 'تصدير البيانات';

  @override
  String get importData => 'استيراد البيانات';

  @override
  String get rateApp => 'تقييم التطبيق';

  @override
  String get sendFeedback => 'إرسال تعليقات';

  @override
  String get privacyPolicy => 'سياسة الخصوصية';

  @override
  String get version => 'الإصدار';

  @override
  String get buildNumber => 'رقم البناء';

  @override
  String get system => 'النظام';

  @override
  String get light => 'فاتح';

  @override
  String get dark => 'داكن';

  @override
  String get itemRestored => 'تمت استعادة العنصر';

  @override
  String get recycleBinCleared => 'تم إفراغ سلة المحذوفات بنجاح';

  @override
  String get allPostsDeleted => 'تم حذف جميع المنشورات';

  @override
  String get newPost => 'منشور جديد';

  @override
  String get textCopiedToClipboardFacebook =>
      'تم نسخ النص إلى الحافظة (سياسة فيسبوك)';

  @override
  String get tiktokSharingRequiresVideoImage =>
      'تتطلب مشاركة TikTok فيديو/صورة';

  @override
  String errorSharing(Object error) {
    return 'خطأ في المشاركة: $error';
  }

  @override
  String shareToStory(Object platform) {
    return 'مشاركة في قصة $platform';
  }

  @override
  String shareToFeed(Object platform) {
    return 'مشاركة في موجز $platform';
  }

  @override
  String get unlockPermanently => 'فتح بشكل دائم';

  @override
  String get notEnoughCoins => 'لا توجد عملات كافية!';

  @override
  String youEarnedCoins(Object amount) {
    return 'لقد ربحت $amount من العملات!';
  }

  @override
  String get contentCopied => 'تم نسخ المحتوى';

  @override
  String get selectDateTime => 'حدد التاريخ والوقت';

  @override
  String get areYouSureYouWantToDeleteThisPost =>
      'هل أنت متأكد أنك تريد حذف هذا المنشور؟';

  @override
  String get socialPosts => 'منشورات اجتماعية';

  @override
  String get watchAdToEarnCoins => 'شاهد إعلانًا لربح العملات';

  @override
  String get premiumUnlocked => 'تم فتح البريميوم';

  @override
  String get removeAds => 'إزالة الإعلانات';

  @override
  String get unlimitedCloudStorage => 'تخزين سحابي غير محدود';

  @override
  String get deleteNote => 'حذف الملاحظة';

  @override
  String get shareNote => 'مشاركة الملاحظة';

  @override
  String get editNote => 'تعديل الملاحظة';

  @override
  String get searchNotes => 'البحث في الملاحظات...';

  @override
  String get noNotesFound => 'لم يتم العثور على ملاحظات';

  @override
  String get captureThoughts => 'سجل أفكارك فورا.';

  @override
  String get createNote => 'إنشاء ملاحظة';

  @override
  String get customOrder => 'ترتيب مخصص';

  @override
  String get newestFirst => 'الأحدث أولاً';

  @override
  String get oldestFirst => 'الأقدم أولاً';

  @override
  String get titleAZ => 'العنوان: أ-ي';

  @override
  String get titleZA => 'العنوان: ي-أ';

  @override
  String get deleteAllQuestion => 'حذف الكل؟';

  @override
  String get moveToRecycleBin => 'نقل جميع الملاحظات إلى سلة المحذوفات؟';

  @override
  String get moveToBinQuestion => 'نقل إلى السلة؟';

  @override
  String get restoreNoteLater => 'يمكنك استعادة هذه الملاحظة لاحقًا.';

  @override
  String get move => 'نقل';

  @override
  String get myThoughts => 'أفكاري';

  @override
  String get selected => 'محدد';

  @override
  String get noContent => 'لا يوجد محتوى';

  @override
  String get untitled => 'بدون عنوان';

  @override
  String get chooseWallpapers => 'اختر من بين أكثر من 10 خلفيات ديناميكية';

  @override
  String get backupData => 'نسخ احتياطي للبيانات';

  @override
  String get saveJsonFile => 'هل تريد حفظ ملف JSON يحتوي على جميع بياناتك؟';

  @override
  String get exportNow => 'تصدير الآن';

  @override
  String get importDataTitle => 'استيراد البيانات';

  @override
  String get mergeBackupFile =>
      'هل تريد دمج ملف النسخ الاحتياطي مع العناصر الحالية؟';

  @override
  String get selectFile => 'حدد ملفاً';

  @override
  String get backupSaved => 'تم حفظ النسخة الاحتياطية بنجاح!';

  @override
  String get exportFailed => 'فشل التصدير.';

  @override
  String importSuccess(Object count) {
    return 'تمت استعادة $count من العناصر بنجاح!';
  }

  @override
  String get importFailed => 'فشل الاستيراد.';

  @override
  String widgetAdded(String widget) {
    return 'تمت إضافة الأداة $widget إلى الشاشة الرئيسية!';
  }

  @override
  String get widgetRequestSent =>
      'تم إرسال طلب الأداة. يرجى التحقق من الشاشة الرئيسية.';

  @override
  String get widgetAddFailed => 'فشل إضافة الأداة';

  @override
  String get autoSaveEnabled => 'تم تفعيل الحفظ التلقائي.';

  @override
  String get autoSaveDisabled => 'تم تعطيل الحفظ التلقائي.';

  @override
  String get homeScreenWidgets => 'أدوات الشاشة الرئيسية';

  @override
  String get notificationsTitle => 'الإشعارات';

  @override
  String get dataBackup => 'البيانات والنسخ الاحتياطي';

  @override
  String get feedbackSupport => 'التعليقات والدعم';

  @override
  String get creditsTitle => 'الاعتمادات';

  @override
  String get privacyMaintenance => 'الخصوصية والصيانة';

  @override
  String get aboutTitle => 'حول';

  @override
  String get premium => 'بريميوم';

  @override
  String get appearanceTitle => 'المظهر';

  @override
  String get clipboardTitle => 'الحافظة';

  @override
  String get settingsSubtitle => 'تخصيص تجربتك';

  @override
  String get welcomeTitle => 'مرحبًا بك في CopyClip';

  @override
  String get welcomeDescription =>
      'رفيقك النهائي للإنتاجية. دعنا نجهزك بأدوات قوية لإدارة يومك.';

  @override
  String get onboardingNotesTitle => 'ملاحظات ذكية';

  @override
  String get onboardingNotesDesc =>
      'التقط الأفكار فورًا بتنسيق نص غني. نظم أفكارك ولا تفقد أي فكرة رائعة مرة أخرى.';

  @override
  String get onboardingTodosTitle => 'إدارة المهام';

  @override
  String get onboardingTodosDesc =>
      'ابق مطلعاً على أمورك. أنشئ قوائم مهام، وحدد الأولويات، وحقق أهدافك خطوة بخطوة.';

  @override
  String get onboardingExpensesTitle => 'تتبع النفقات';

  @override
  String get onboardingExpensesDesc =>
      'تحكم في أموالك. تتبع الدخل والنفقات بسهولة لفهم عادات الإنفاق الخاصة بك.';

  @override
  String get onboardingJournalTitle => 'يوميات شخصية';

  @override
  String get onboardingJournalDesc =>
      'تأمل في يومك. مساحة خاصة لتدوين ذكرياتك ومشاعرك وتجاربك اليومية.';

  @override
  String get onboardingCalendarTitle => 'التقويم والأحداث';

  @override
  String get onboardingCalendarDesc =>
      'لا تفوت أي لحظة. نظم جدولك وتابع الأحداث الهامة القادمة.';

  @override
  String get onboardingClipboardTitle => 'مدير الحافظة';

  @override
  String get onboardingClipboardDesc =>
      'انسخ مرة واحدة، والصق في أي مكان. الوصول إلى سجل الحافظة لاستعادة النصوص التي نسختها سابقاً.';

  @override
  String get onboardingCanvasTitle => 'لوحة إبداعية';

  @override
  String get onboardingCanvasDesc =>
      'أطلق العنان لإبداعك. ارسم وخطط وصور أفكارك على لوحة رقمية حرة.';

  @override
  String get featuresNotesDesc => 'إنشاء وإدارة الملاحظات الخاصة بك';

  @override
  String get featuresTodosDesc => 'تتبع المهام الخاصة بك';

  @override
  String get featuresExpensesDesc => 'مراقبة النفقات الخاصة بك';

  @override
  String get featuresJournalDesc => 'اكتتب أفكارك';

  @override
  String get featuresCalendarDesc => 'نظم جدولك الزمني';

  @override
  String get featuresClipboardDesc => 'الوصول إلى سجل الحافظة الخاص بك';

  @override
  String get featuresCanvasDesc => 'ارسم وخطط بحرية';

  @override
  String get featuresSocialPost => 'منشور اجتماعي';

  @override
  String get featuresSocialPostDesc =>
      'إنشاء محتوى جذاب لوسائل التواصل الاجتماعي';

  @override
  String get chooseYourAura => 'اختر هالتك';

  @override
  String get expressYourselfTheme => 'عبر عن نفسك بلون مظهر جديد!';

  @override
  String get level => 'المستوى';

  @override
  String get xpToNextLevel => 'XP للمستوى التالي';

  @override
  String get checkUpcomingEvents => 'تحقق من الأحداث القادمة';

  @override
  String get startNewSketch => 'بدأ رسمة جديدة';

  @override
  String get noTransactionsMonth => 'لا توجد معاملات هذا الشهر';

  @override
  String transactionsThisMonth(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count معاملات هذا الشهر',
      few: '$count معاملات هذا الشهر',
      two: 'معاملتان هذا الشهر',
      one: 'معاملة واحدة هذا الشهر',
      zero: 'لا توجد معاملات هذا الشهر',
    );
    return '$_temp0';
  }

  @override
  String get autoSaveClipboard => 'حفظ تلقائي للحافظة';

  @override
  String get autoSaveClipboardDesc => 'حفظ العناصر المنسوخة تلقائياً';

  @override
  String get permissionDeniedSettings =>
      'تم رفض الإذن بشكل دائم. يرجى تفعيله من الإعدادات.';

  @override
  String get notificationsEnabled => 'تم تفعيل الإشعارات!';

  @override
  String get redirectingToSettings =>
      'جارٍ التوجيه إلى الإعدادات لتعطيل الإشعارات...';

  @override
  String get premiumAccess => 'وصول بريميوم';

  @override
  String get premiumActiveUntil => 'بريميوم نشط حتى';

  @override
  String get unlockAllFeatures => 'فتح جميع الميزات';

  @override
  String get buyPremium => 'شراء بريميوم (7 أيام)';

  @override
  String costCoins(Object cost) {
    return 'التكلفة: $cost عملات';
  }

  @override
  String get premiumActivated => 'تم تفعيل البريميوم لمدة 7 أيام!';

  @override
  String get premiumActive => 'البريميوم نشط';

  @override
  String get expires => 'تنتهي الصلاحية:';

  @override
  String get temporaryAccess => 'وصول مؤقت';

  @override
  String get journalExpression => 'يوميات وتعبير';

  @override
  String get artisticDesigns => 'تصاميم فنية';

  @override
  String get artisticDesignsDesc =>
      'فتح أكثر من 10 مظاهر فريدة لبطاقات اليوميات';

  @override
  String get premiumLayouts => 'تخطيطات بريميوم';

  @override
  String get premiumLayoutsDesc => 'طرق حصرية لعرض ذكرياتك';

  @override
  String get calendarTools => 'تقويم وأدوات';

  @override
  String get fullCalendar => 'تقويم كامل';

  @override
  String get fullCalendarDesc => 'نظام متكامل لإدارة الأحداث';

  @override
  String get clipboardAutoSaveDesc => 'التقاط سجل الحافظة في الخلفية';

  @override
  String get proWidgets => 'أدوات ذكية للمحترفين';

  @override
  String get proWidgetsDesc => 'جميع الميزات متوفرة على شاشتك الرئيسية';

  @override
  String get dataExport => 'البيانات والتصدير';

  @override
  String get advancedBackup => 'نسخ احتياطي متقدم';

  @override
  String get advancedBackupDesc => 'استيراد/تصدير آمن لجميع البيانات';

  @override
  String get pdfExport => 'تصدير إلى PDF';

  @override
  String get pdfExportDesc => 'تصدير الملاحظات واليوميات إلى PDF';

  @override
  String get printReady => 'جاهز للطباعة';

  @override
  String get printReadyDesc => 'دعم الطباعة المباشرة';

  @override
  String get richTextEditor => 'محرر نص غني';

  @override
  String get advancedSearch => 'بحث متقدم';

  @override
  String get advancedSearchDesc => 'البحث والاستبدال داخل النص';

  @override
  String get richMedia => 'وسائط غنية';

  @override
  String get richMediaDesc => 'إدراج صور وفيديوهات وروابط';

  @override
  String get editorStyling => 'تنسيق المحرر';

  @override
  String get editorStylingDesc => 'نص مخصص وخلفيات للمحرر';

  @override
  String get balance => 'الرصيد';

  @override
  String get loadingAd => 'جارٍ تحميل الإعلان...';

  @override
  String watchAd(Object amount) {
    return 'مشاهدة إعلان (+$amount)';
  }

  @override
  String get loadAd => 'تحميل إعلان';

  @override
  String get backupDataDesc => 'حفظ ملف JSON لبياناتك';

  @override
  String get importDataDesc => 'دمج ملف نسخة احتياطية في CopyClip';

  @override
  String get notificationPermissionDenied => 'تم رفض إذن الإشعارات.';

  @override
  String get typeNewTask => 'اكتب مهمة جديدة...';

  @override
  String get addTask => 'إضافة مهمة';

  @override
  String get completed => 'مكتمل';

  @override
  String get greatJob => 'عمل رائع!';

  @override
  String youEarnedXPNextTask(Object amount, Object date) {
    return 'لقد ربحت $amount XP! المهمة التالية: $date';
  }

  @override
  String taskCompletedXP(Object amount) {
    return 'تمت المهمة! +$amount XP';
  }

  @override
  String get moveTasksToRecycleBin =>
      'نقل جميع المهام النشطة إلى سلة المحذوفات؟';

  @override
  String get deleteAllPosts => 'حذف جميع المنشورات';

  @override
  String get deleteAllPostsConfirmation =>
      'هل أنت متأكد أنك تريد حذف جميع المنشورات الاجتماعية؟ لا يمكن التراجع عن هذا الإجراء.';

  @override
  String get allPosts => 'جميع المنشورات';

  @override
  String get favorites => 'المفضلة';

  @override
  String get drafts => 'المسودات';

  @override
  String get noFavoritesYet => 'لا توجد مفضلات بعد';

  @override
  String get noDraftsYet => 'لا توجد مسودات بعد';

  @override
  String get startSocialJourney => 'ابدأ رحلتك الاجتماعية!';

  @override
  String get draft => 'مسودة';

  @override
  String attachmentCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count مرفقات',
      few: '$count مرفقات',
      two: 'مرفقان',
      one: 'مرفق واحد',
      zero: 'لا توجد مرفقات',
    );
    return '$_temp0';
  }

  @override
  String get pleaseAddContent => 'يرجى إضافة بعض المحتوى أو الوسائط للمشاركة';

  @override
  String fileNotFoundError(Object path) {
    return 'خطأ: لم يتم العثور على الملف في $path';
  }

  @override
  String get checkFacebookApp => 'تحقق من تطبيق فيسبوك';

  @override
  String get systemShare => 'مشاركة النظام';

  @override
  String get socialPost => 'منشور اجتماعي';

  @override
  String get favorite => 'مفضل';

  @override
  String get saveDraft => 'حفظ المسودة';

  @override
  String get entryCopied => 'تم نسخ المدخل';

  @override
  String get moveEntriesToRecycleBin =>
      'نقل جميع المدخلات النشطة إلى سلة المحذوفات؟';

  @override
  String get startWritingStory => 'ابدأ بكتابة قصتك';

  @override
  String get recordMemories => 'سجل ذكرياتك ومشاعرك اليومية.';

  @override
  String get writeJournal => 'اكتب يومياتك';

  @override
  String get myMemories => 'ذكرياتي';

  @override
  String get sortJournal => 'فرز اليوميات';

  @override
  String get byMood => 'حسب المزاج';

  @override
  String get searchMemories => 'بحث في الذكريات...';

  @override
  String get selectAll => 'تحديد الكل';

  @override
  String get deleteSelected => 'حذف المحدد';

  @override
  String get taskCompletedExclamation => 'تمت المهمة!';

  @override
  String get taskUncompletedExclamation => 'مهمة غير مكتملة';

  @override
  String get clipboardUpdatedExclamation => 'تم تحديث الحافظة!';

  @override
  String clipboardSavedContent(Object content) {
    return 'تم حفظ في الحافظة: $content';
  }

  @override
  String get overview => 'نظرة عامة';

  @override
  String get colorAurora => 'أورورا';

  @override
  String get colorCosmic => 'كوني';

  @override
  String get colorNebula => 'سديم';

  @override
  String get colorStarlight => 'ضوء النجوم';

  @override
  String get colorSolar => 'شمسي';

  @override
  String get colorNova => 'نوفا';

  @override
  String get loadingStepLoading => 'جارٍ التحميل...';

  @override
  String get loadingStepDatabase => 'إعداد قاعدة البيانات...';

  @override
  String get loadingStepSystem => 'تكوين النظام...';

  @override
  String get loadingStepReady => 'جاهز';

  @override
  String get productivityCompanion => 'رفيقك للإنتاجية';

  @override
  String get done => 'تم';

  @override
  String get newNote => 'ملاحظة جديدة';

  @override
  String get changeColor => 'تغيير اللون';

  @override
  String get copyContent => 'نسخ المحتوى';

  @override
  String get titleOptional => 'العنوان (اختياري)';

  @override
  String get exportAsPdf => 'تصدير كـ PDF';

  @override
  String get taskDueNow => 'موعد المهمة الآن';

  @override
  String get moveTaskToBinTitle => 'نقل المهمة إلى سلة المحذوفات؟';

  @override
  String get restoreTaskLater =>
      'يمكنك استعادة هذه المهمة لاحقًا من الإعدادات.';

  @override
  String get newTask => 'مهمة جديدة';

  @override
  String get editTask => 'تعديل المهمة';

  @override
  String get undo => 'تراجع';

  @override
  String get redo => 'إعادة';

  @override
  String get category => 'الفئة';

  @override
  String get categoryHint => 'مثال: العمل، النادي';

  @override
  String get whatNeedsToBeDone => 'ما الذي يجب القيام به؟';

  @override
  String get enterTaskDetails => 'أدخل تفاصيل المهمة...';

  @override
  String get setDueDate => 'تحديد موعد الاستحقاق';

  @override
  String get dueDate => 'موعد الاستحقاق';

  @override
  String get expenseTitle => 'النفقات';

  @override
  String searchInCurrency(String currency) {
    return 'بحث في $currency...';
  }

  @override
  String get sortAndFilter => 'فرز وتصفية';

  @override
  String get sortBy => 'فرز حسب';

  @override
  String get highestAmount => 'أعلى مبلغ';

  @override
  String get lowestAmount => 'أقل مبلغ';

  @override
  String get moreFilters => 'مزيد من الفلاتر...';

  @override
  String get filterExpenses => 'تصفية النفقات';

  @override
  String get transactionType => 'نوع المعاملة';

  @override
  String get categories => 'الفئات';

  @override
  String get all => 'الكل';

  @override
  String get income => 'الدخل';

  @override
  String get expense => 'المصروفات';

  @override
  String get reset => 'إعادة تعيين';

  @override
  String get apply => 'تطبيق';

  @override
  String newExpense(String currency) {
    return 'جديد $currency';
  }

  @override
  String errorLoadingData(String error) {
    return 'حدث خطأ أثناء تحميل البيانات.\n\n$error';
  }

  @override
  String get dailyQuote1 => 'أفضل طريقة للتنبؤ بالمستقبل هي أن تصنعه.';

  @override
  String get dailyQuote2 => 'الغنى ليس في كثرة العرض، ولكن الغنى غنى النفس.';

  @override
  String get dailyQuote3 => 'الوقت هو العملة الأغلى.';

  @override
  String get dailyQuote4 => 'النجاح ليس نهائياً، والفشل ليس قاتلاً.';

  @override
  String get dailyQuote5 => 'ركز على الحل، وليس المشكلة.';

  @override
  String get dailyQuote6 => 'شبكة علاقاتك هي ثروتك الحقيقية.';

  @override
  String get moodHappy => 'سعيد';

  @override
  String get moodExcited => 'متحمس';

  @override
  String get moodNeutral => 'محايد';

  @override
  String get moodSad => 'حزين';

  @override
  String get moodStressed => 'متوتر';

  @override
  String exportDate(String date) {
    return '📅 $date';
  }

  @override
  String exportMood(String emoji, String mood) {
    return 'المزاج: $emoji $mood';
  }

  @override
  String exportTitle(String title) {
    return 'العنوان: $title';
  }

  @override
  String exportTags(String tags) {
    return '\nالوسوم: $tags';
  }

  @override
  String get instagram => 'إنستغرام';

  @override
  String get facebook => 'فيسبوك';

  @override
  String get tiktok => 'تيك توك';

  @override
  String get newSketch => 'رسمة جديدة';

  @override
  String get searchSketches => 'البحث في الرسومات والمجلدات...';

  @override
  String get noResultsFound => 'لم يتم العثور على نتائج';

  @override
  String get noItems => 'لا توجد عناصر';

  @override
  String get noDrawingsYet => 'لا توجد رسومات بعد';

  @override
  String get canvasIntro => 'أطلق العنان لإبداعك على اللوحة!';

  @override
  String get newCanvas => 'لوحة جديدة';

  @override
  String get rename => 'إعادة تسمية';

  @override
  String get deleteFolder => 'حذف المجلد';

  @override
  String get deleteSketchesQuestion => 'حذف الرسومات؟';

  @override
  String get deleteFolderConfirmation =>
      'سيتم حذف جميع الرسومات في هذا المجلد نهائياً.';

  @override
  String get renameFolder => 'إعادة تسمية المجلد';

  @override
  String get chooseColor => 'اختر لوناً';

  @override
  String get deleteFolderQuestion => 'حذف المجلد؟';

  @override
  String get searchClips => 'البحث في القصاصات...';

  @override
  String get clipboardEmpty => 'الحافظة فارغة';

  @override
  String get addItem => 'إضافة عنصر';

  @override
  String get clipColor => 'لون القصاصة';

  @override
  String get newClip => 'قصاصة جديدة';

  @override
  String get editClip => 'تعديل القصاصة';

  @override
  String get restoreClipLater => 'يمكنك استعادة هذه القصاصة لاحقاً.';

  @override
  String get upcomingEvents => 'الأحداث القادمة';

  @override
  String get dataDistribution => 'توزيع البيانات';

  @override
  String get taskProgress => 'تقدم المهمة';

  @override
  String get quickStats => 'إحصائيات سريعة';

  @override
  String get taskCompletion => 'إكمال المهمة';

  @override
  String get noItemsForDate => 'لا توجد عناصر لهذا التاريخ';

  @override
  String get enjoyFreeTime => 'استمتع بوقت فراغك!';

  @override
  String get searchThisDay => 'البحث في هذا اليوم...';

  @override
  String get finance => 'المالية';

  @override
  String get permanentlyDelete => 'حذف نهائي؟';

  @override
  String deleteSelectionConfirmation(int foldersCount, int sketchesCount) {
    return 'سيؤدي هذا إلى حذف $foldersCount مجلدات (ورسماتها) و $sketchesCount رسومات أخرى نهائياً.\n\nلا يمكن التراجع عن هذا الإجراء.';
  }

  @override
  String get deleteForever => 'حذف للأبد';

  @override
  String selectedCount(int count) {
    return '$count محدد';
  }

  @override
  String canvasStats(int notes, int folders) {
    return '$notes رسومات • $folders مجلدات';
  }

  @override
  String get sortItems => 'فرز العناصر';

  @override
  String get sortNameAZ => 'الاسم (أ-ي)';

  @override
  String get sortNameZA => 'الاسم (ي-أ)';

  @override
  String get createFolder => 'إنشاء مجلد';

  @override
  String get folderNameHint => 'اسم المجلد...';

  @override
  String deleteSketchesConfirmation(int count) {
    return 'حذف $count رسومات؟ لا يمكن التراجع عن هذا الإجراء.';
  }

  @override
  String get noSketchesFound => 'لم يتم العثور على رسومات';

  @override
  String get noSketchesFoundSub => 'حاول تعديل بحثك أو إنشاء رسمة جديدة.';

  @override
  String searchInFolder(String folder) {
    return 'بحث في $folder...';
  }

  @override
  String sketchesCount(int count) {
    return '$count رسومات';
  }

  @override
  String get sortSketches => 'فرز الرسومات';

  @override
  String get calendarScreenTitle => 'التقويم';

  @override
  String get dailyActivity => 'النشاط اليومي';

  @override
  String get deleteItemQuestion => 'حذف العنصر؟';

  @override
  String get deleteItemConfirmation =>
      'سيؤدي هذا إلى نقل العنصر إلى سلة المحذوفات.';

  @override
  String get moveToBinItem => 'نقل إلى السلة؟';

  @override
  String get moveToBinConfirmation => 'يمكنك استعادته لاحقاً.';

  @override
  String selectedItems(int count) {
    return '$count محدد';
  }

  @override
  String get recentClips => 'القصاصات الأخيرة';

  @override
  String get copied => 'تم النسخ!';

  @override
  String get copiedPlainText => 'تم نسخ النص المجرد';

  @override
  String get clipTheme => 'مظهر القصاصة';

  @override
  String get justNow => 'الآن';

  @override
  String minutesAgo(Object count) {
    return 'منذ $count د';
  }

  @override
  String hoursAgo(Object count) {
    return 'منذ $count س';
  }

  @override
  String daysAgo(Object count) {
    return 'منذ $count ي';
  }

  @override
  String get noTasksFound => 'لم يتم العثور على مهام.';

  @override
  String get searchTasks => 'بحث في المهام...';

  @override
  String get taskReminder => 'تذكير بالمهمة';

  @override
  String get untitledNote => 'ملاحظة بدون عنوان';

  @override
  String get dailyEntry => 'مدخل يومي';

  @override
  String get clipboardHistory => 'سجل الحافظة';

  @override
  String get deletePermanentlyContent => 'هذا الإجراء لا يمكن التراجع عنه.';

  @override
  String get emptyRecycleBinTitle => 'إفراغ سلة المحذوفات؟';

  @override
  String emptyRecycleBinContent(Object count) {
    return 'سيتم حذف جميع العناصر الـ $count نهائياً.';
  }

  @override
  String get emptyBin => 'إفراغ السلة';

  @override
  String get recycleBinEmpty => 'سلة المحذوفات فارغة';

  @override
  String get deletedItemsAppearHere => 'العناصر المحذوفة ستظهر هنا.';

  @override
  String get empty => 'فارغ';

  @override
  String get recent => 'الأخيرة';

  @override
  String categoryLabel(Object category) {
    return 'الفئة: $category';
  }

  @override
  String get general => 'عام';

  @override
  String get saveTransactionQuestion => 'هل تريد حفظ هذه المعاملة؟';

  @override
  String get fillTitleAmount => 'يرجى ملء العنوان والمبلغ';

  @override
  String get invalidAmount => 'تنسيق المبلغ غير صالح';

  @override
  String get moveTransactionToBinTitle => 'نقل المعاملة إلى سلة المحذوفات؟';

  @override
  String get restoreTransactionLater =>
      'يمكنك استعادة هذه المعاملة لاحقاً من الإعدادات.';

  @override
  String get newTransaction => 'معاملة جديدة';

  @override
  String get whatIsThisFor => 'فيما هذا؟';

  @override
  String get description => 'الوصف';

  @override
  String get daily => 'يومياً';

  @override
  String get weekly => 'أسبوعياً';

  @override
  String get monthly => 'شهرياً';

  @override
  String get yearly => 'سنوياً';

  @override
  String get totalIncome => 'إجمالي الدخل';

  @override
  String get totalExpense => 'إجمالي النفقات';

  @override
  String get analysis => 'التحليل';

  @override
  String get transactions => 'المعاملات';

  @override
  String get noExpensesFound => 'لم يتم العثور على نفقات لهذه الفترة.';

  @override
  String get netBalance => 'صافي الرصيد';

  @override
  String get topCategories => 'أبرز الفئات';

  @override
  String get spendingTrend => 'اتجاه الإنفاق';

  @override
  String get insights => 'رؤى';

  @override
  String get noExpensesRecorded => 'لم يتم تسجيل أي نفقات';

  @override
  String get trackSpendingHabits => 'تتبع عادات الإنفاق الخاصة بك بسهولة.';

  @override
  String get addExpense => 'إضافة نفقة';

  @override
  String get noDataForPeriod => 'لا توجد بيانات لهذه الفترة';

  @override
  String get budget => 'الميزانية';

  @override
  String get spent => 'تم صرفه';

  @override
  String get limit => 'الحد';

  @override
  String get overBudget => 'تجاوز الميزانية!';

  @override
  String remainingBudget(Object percent) {
    return 'متبقي $percent%';
  }

  @override
  String get savingsRate => 'معدل الادخار';

  @override
  String get healthScore => 'درجة الصحة المالية';

  @override
  String get healthScoreExplanation =>
      'هذه الدرجة تعتمد على معدل ادخارك.\n\n• ادخار > 50% = ممتاز (100)\n• ادخار 0% = متوسط (50)\n• الإنفاق > الدخل = ضعيف (<50)';

  @override
  String get ok => 'موافق';

  @override
  String get bulkImport => 'استيراد بالجملة';
}

/// The translations for Arabic, as used in Libya (`ar_LY`).
class AppLocalizationsArLy extends AppLocalizationsAr {
  AppLocalizationsArLy() : super('ar_LY');

  @override
  String get settings => 'إعدادات';

  @override
  String get language => 'لغة';

  @override
  String get systemDefault => 'النظام الافتراضي';

  @override
  String get notes => 'ملحوظات';

  @override
  String get todos => 'المهام';

  @override
  String get expenses => 'نفقات';

  @override
  String get journal => 'مجلة';

  @override
  String get calendar => 'تقويم';

  @override
  String get clipboard => 'الحافظة';

  @override
  String get canvas => 'قماش';

  @override
  String get save => 'حفظ';

  @override
  String get create => 'إنشاء';

  @override
  String get cancel => 'إلغاء';

  @override
  String get delete => 'حذف';

  @override
  String get edit => 'تعديل';

  @override
  String get share => 'مشاركة';

  @override
  String get copy => 'نسخ';

  @override
  String get unsavedChanges => 'تغييرات غير محفوظة';

  @override
  String get confirmDelete => 'تأكيد الحذف';

  @override
  String get discard => 'تجاهل';

  @override
  String get createPost => 'إنشاء منشور';

  @override
  String get post => 'منشور';

  @override
  String get postingTo => 'النشر في';

  @override
  String get whatsOnYourMind => 'ماذا يدور في ذهنك؟';

  @override
  String get pickImages => 'اختر صورًا';

  @override
  String get pickVideo => 'اختر فيديو';

  @override
  String get camera => 'كاميرا';

  @override
  String get gallery => 'معرض الصور';

  @override
  String get search => 'بحث';

  @override
  String get pleaseEnterTask => 'يرجى إدخال مهمة';

  @override
  String get deleteTask => 'حذف المهمة';

  @override
  String get selectItems => 'حدد العناصر';

  @override
  String get deleteAll => 'حذف الكل';

  @override
  String error(Object error) {
    return 'خطأ: $error';
  }

  @override
  String get orderingOnlyAvailableInAllPosts =>
      'الترتيب متاح فقط في \"جميع المنشورات\"';

  @override
  String get deletePost => 'حذف المنشور';

  @override
  String get postDeleted => 'تم حذف المنشور';

  @override
  String get premiumFeatures => 'ميزات بريميوم';

  @override
  String get manageCoinsAdsPremium =>
      'إدارة العملات والإعلانات وحالة البريميوم';

  @override
  String get themeMode => 'وضع المظهر';

  @override
  String get accentColor => 'لون التمييز';

  @override
  String get backgroundDesign => 'تصميم الخلفية';

  @override
  String get pushNotifications => 'إشعارات الدفع';

  @override
  String get recycleBin => 'سلة المحذوفات';

  @override
  String get exportData => 'تصدير البيانات';

  @override
  String get importData => 'استيراد البيانات';

  @override
  String get rateApp => 'تقييم التطبيق';

  @override
  String get sendFeedback => 'إرسال تعليقات';

  @override
  String get privacyPolicy => 'سياسة الخصوصية';

  @override
  String get version => 'الإصدار';

  @override
  String get buildNumber => 'رقم البناء';

  @override
  String get system => 'النظام';

  @override
  String get light => 'فاتح';

  @override
  String get dark => 'داكن';

  @override
  String get itemRestored => 'تمت استعادة العنصر';

  @override
  String get recycleBinCleared => 'تم إفراغ سلة المحذوفات بنجاح';

  @override
  String get allPostsDeleted => 'تم حذف جميع المنشورات';

  @override
  String get newPost => 'منشور جديد';

  @override
  String get textCopiedToClipboardFacebook =>
      'Text copied to clipboard (Facebook policy)';

  @override
  String get tiktokSharingRequiresVideoImage =>
      'تتطلب مشاركة TikTok فيديو/صورة';

  @override
  String errorSharing(Object error) {
    return 'خطأ في المشاركة: $error';
  }

  @override
  String shareToStory(Object platform) {
    return 'مشاركة في قصة $platform';
  }

  @override
  String shareToFeed(Object platform) {
    return 'مشاركة في موجز $platform';
  }

  @override
  String get unlockPermanently => 'فتح بشكل دائم';

  @override
  String get notEnoughCoins => 'لا توجد عملات كافية!';

  @override
  String youEarnedCoins(Object amount) {
    return 'لقد ربحت $amount من العملات!';
  }

  @override
  String get contentCopied => 'تم نسخ المحتوى';

  @override
  String get selectDateTime => 'حدد التاريخ والوقت';

  @override
  String get areYouSureYouWantToDeleteThisPost =>
      'هل أنت متأكد أنك تريد حذف هذا المنشور؟';

  @override
  String get socialPosts => 'منشورات اجتماعية';

  @override
  String get watchAdToEarnCoins => 'شاهد إعلانًا لربح العملات';

  @override
  String get premiumUnlocked => 'تم فتح البريميوم';

  @override
  String get removeAds => 'إزالة الإعلانات';

  @override
  String get unlimitedCloudStorage => 'تخزين سحابي غير محدود';

  @override
  String get deleteNote => 'حذف الملاحظة';

  @override
  String get shareNote => 'مشاركة الملاحظة';

  @override
  String get editNote => 'تعديل الملاحظة';

  @override
  String get searchNotes => 'البحث في الملاحظات...';

  @override
  String get noNotesFound => 'لم يتم العثور على ملاحظات';

  @override
  String get captureThoughts => 'سجل أفكارك فورا.';

  @override
  String get createNote => 'إنشاء ملاحظة';

  @override
  String get customOrder => 'ترتيب مخصص';

  @override
  String get newestFirst => 'الأحدث أولاً';

  @override
  String get oldestFirst => 'الأقدم أولاً';

  @override
  String get titleAZ => 'العنوان: أ-ي';

  @override
  String get titleZA => 'العنوان: ي-أ';

  @override
  String get deleteAllQuestion => 'حذف الكل؟';

  @override
  String get moveToRecycleBin => 'نقل جميع الملاحظات إلى سلة المحذوفات؟';

  @override
  String get moveToBinQuestion => 'نقل إلى السلة؟';

  @override
  String get restoreNoteLater => 'يمكنك استعادة هذه الملاحظة لاحقًا.';

  @override
  String get move => 'نقل';

  @override
  String get myThoughts => 'أفكاري';

  @override
  String get selected => 'محدد';

  @override
  String get noContent => 'لا يوجد محتوى';

  @override
  String get untitled => 'بدون عنوان';

  @override
  String get chooseWallpapers => 'اختر من بين أكثر من 10 خلفيات ديناميكية';

  @override
  String get backupData => 'نسخ احتياطي للبيانات';

  @override
  String get saveJsonFile => 'هل تريد حفظ ملف JSON يحتوي على جميع بياناتك؟';

  @override
  String get exportNow => 'تصدير الآن';

  @override
  String get importDataTitle => 'استيراد البيانات';

  @override
  String get mergeBackupFile =>
      'هل تريد دمج ملف النسخ الاحتياطي مع العناصر الحالية؟';

  @override
  String get selectFile => 'حدد ملفاً';

  @override
  String get backupSaved => 'تم حفظ النسخة الاحتياطية بنجاح!';

  @override
  String get exportFailed => 'فشل التصدير.';

  @override
  String importSuccess(Object count) {
    return 'تمت استعادة $count من العناصر بنجاح!';
  }

  @override
  String get importFailed => 'فشل الاستيراد.';

  @override
  String widgetAdded(String widget) {
    return 'تمت إضافة الأداة $widget إلى الشاشة الرئيسية!';
  }

  @override
  String get widgetRequestSent =>
      'تم إرسال طلب الأداة. يرجى التحقق من الشاشة الرئيسية.';

  @override
  String get widgetAddFailed => 'فشل إضافة الأداة';

  @override
  String get autoSaveEnabled => 'تم تفعيل الحفظ التلقائي.';

  @override
  String get autoSaveDisabled => 'تم تعطيل الحفظ التلقائي.';

  @override
  String get homeScreenWidgets => 'أدوات الشاشة الرئيسية';

  @override
  String get notificationsTitle => 'الإشعارات';

  @override
  String get dataBackup => 'البيانات والنسخ الاحتياطي';

  @override
  String get feedbackSupport => 'التعليقات والدعم';

  @override
  String get creditsTitle => 'الاعتمادات';

  @override
  String get privacyMaintenance => 'الخصوصية والصيانة';

  @override
  String get aboutTitle => 'حول';

  @override
  String get premium => 'بريميوم';

  @override
  String get appearanceTitle => 'المظهر';

  @override
  String get clipboardTitle => 'الحافظة';

  @override
  String get settingsSubtitle => 'تخصيص تجربتك';

  @override
  String get welcomeTitle => 'مرحبًا بك في CopyClip';

  @override
  String get welcomeDescription =>
      'رفيقك النهائي للإنتاجية. دعنا نجهزك بأدوات قوية لإدارة يومك.';

  @override
  String get onboardingNotesTitle => 'ملاحظات ذكية';

  @override
  String get onboardingNotesDesc =>
      'التقط الأفكار فورًا بتنسيق نص غني. نظم أفكارك ولا تفقد أي فكرة رائعة مرة أخرى.';

  @override
  String get onboardingTodosTitle => 'إدارة المهام';

  @override
  String get onboardingTodosDesc =>
      'ابق مطلعاً على أمورك. أنشئ قوائم مهام، وحدد الأولويات، وحقق أهدافك خطوة بخطوة.';

  @override
  String get onboardingExpensesTitle => 'تتبع النفقات';

  @override
  String get onboardingExpensesDesc =>
      'تحكم في أموالك. تتبع الدخل والنفقات بسهولة لفهم عادات الإنفاق الخاصة بك.';

  @override
  String get onboardingJournalTitle => 'يوميات شخصية';

  @override
  String get onboardingJournalDesc =>
      'تأمل في يومك. مساحة خاصة لتدوين ذكرياتك ومشاعرك وتجاربك اليومية.';

  @override
  String get onboardingCalendarTitle => 'التقويم والأحداث';

  @override
  String get onboardingCalendarDesc =>
      'لا تفوت أي لحظة. نظم جدولك وتابع الأحداث الهامة القادمة.';

  @override
  String get onboardingClipboardTitle => 'مدير الحافظة';

  @override
  String get onboardingClipboardDesc =>
      'انسخ مرة واحدة، والصق في أي مكان. الوصول إلى سجل الحافظة لاستعادة النصوص التي نسختها سابقاً.';

  @override
  String get onboardingCanvasTitle => 'لوحة إبداعية';

  @override
  String get onboardingCanvasDesc =>
      'أطلق العنان لإبداعك. ارسم وخطط وصور أفكارك على لوحة رقمية حرة.';

  @override
  String get featuresNotesDesc => 'إنشاء وإدارة الملاحظات الخاصة بك';

  @override
  String get featuresTodosDesc => 'تتبع المهام الخاصة بك';

  @override
  String get featuresExpensesDesc => 'مراقبة النفقات الخاصة بك';

  @override
  String get featuresJournalDesc => 'اكتتب أفكارك';

  @override
  String get featuresCalendarDesc => 'نظم جدولك الزمني';

  @override
  String get featuresClipboardDesc => 'الوصول إلى سجل الحافظة الخاص بك';

  @override
  String get featuresCanvasDesc => 'ارسم وخطط بحرية';

  @override
  String get featuresSocialPost => 'منشور اجتماعي';

  @override
  String get featuresSocialPostDesc =>
      'إنشاء محتوى جذاب لوسائل التواصل الاجتماعي';

  @override
  String get chooseYourAura => 'اختر هالتك';

  @override
  String get expressYourselfTheme => 'عبر عن نفسك بلون مظهر جديد!';

  @override
  String get level => 'المستوى';

  @override
  String get xpToNextLevel => 'XP للمستوى التالي';

  @override
  String get checkUpcomingEvents => 'تحقق من الأحداث القادمة';

  @override
  String get startNewSketch => 'بدأ رسمة جديدة';

  @override
  String get noTransactionsMonth => 'لا توجد معاملات هذا الشهر';

  @override
  String transactionsThisMonth(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count معاملات هذا الشهر',
      few: '$count معاملات هذا الشهر',
      two: 'معاملتان هذا الشهر',
      one: 'معاملة واحدة هذا الشهر',
      zero: 'لا توجد معاملات هذا الشهر',
    );
    return '$_temp0';
  }

  @override
  String get autoSaveClipboard => 'حفظ تلقائي للحافظة';

  @override
  String get autoSaveClipboardDesc => 'حفظ العناصر المنسوخة تلقائياً';

  @override
  String get permissionDeniedSettings =>
      'تم رفض الإذن بشكل دائم. يرجى تفعيله من الإعدادات.';

  @override
  String get notificationsEnabled => 'تم تفعيل الإشعارات!';

  @override
  String get redirectingToSettings =>
      'جارٍ التوجيه إلى الإعدادات لتعطيل الإشعارات...';

  @override
  String get premiumAccess => 'وصول بريميوم';

  @override
  String get premiumActiveUntil => 'بريميوم نشط حتى';

  @override
  String get unlockAllFeatures => 'فتح جميع الميزات';

  @override
  String get buyPremium => 'شراء بريميوم (7 أيام)';

  @override
  String costCoins(Object cost) {
    return 'التكلفة: $cost عملات';
  }

  @override
  String get premiumActivated => 'تم تفعيل البريميوم لمدة 7 أيام!';

  @override
  String get premiumActive => 'البريميوم نشط';

  @override
  String get expires => 'تنتهي الصلاحية:';

  @override
  String get temporaryAccess => 'وصول مؤقت';

  @override
  String get journalExpression => 'يوميات وتعبير';

  @override
  String get artisticDesigns => 'تصاميم فنية';

  @override
  String get artisticDesignsDesc =>
      'فتح أكثر من 10 مظاهر فريدة لبطاقات اليوميات';

  @override
  String get premiumLayouts => 'تخطيطات بريميوم';

  @override
  String get premiumLayoutsDesc => 'طرق حصرية لعرض ذكرياتك';

  @override
  String get calendarTools => 'تقويم وأدوات';

  @override
  String get fullCalendar => 'تقويم كامل';

  @override
  String get fullCalendarDesc => 'نظام متكامل لإدارة الأحداث';

  @override
  String get clipboardAutoSaveDesc => 'التقاط سجل الحافظة في الخلفية';

  @override
  String get proWidgets => 'أدوات ذكية للمحترفين';

  @override
  String get proWidgetsDesc => 'جميع الميزات متوفرة على شاشتك الرئيسية';

  @override
  String get dataExport => 'البيانات والتصدير';

  @override
  String get advancedBackup => 'نسخ احتياطي متقدم';

  @override
  String get advancedBackupDesc => 'استيراد/تصدير آمن لجميع البيانات';

  @override
  String get pdfExport => 'تصدير إلى PDF';

  @override
  String get pdfExportDesc => 'تصدير الملاحظات واليوميات إلى PDF';

  @override
  String get printReady => 'جاهز للطباعة';

  @override
  String get printReadyDesc => 'دعم الطباعة المباشرة';

  @override
  String get richTextEditor => 'محرر نص غني';

  @override
  String get advancedSearch => 'بحث متقدم';

  @override
  String get advancedSearchDesc => 'البحث والاستبدال داخل النص';

  @override
  String get richMedia => 'وسائط غنية';

  @override
  String get richMediaDesc => 'إدراج صور وفيديوهات وروابط';

  @override
  String get editorStyling => 'تنسيق المحرر';

  @override
  String get editorStylingDesc => 'نص مخصص وخلفيات للمحرر';

  @override
  String get balance => 'الرصيد';

  @override
  String get loadingAd => 'جارٍ تحميل الإعلان...';

  @override
  String watchAd(Object amount) {
    return 'مشاهدة إعلان (+$amount)';
  }

  @override
  String get loadAd => 'تحميل إعلان';

  @override
  String get backupDataDesc => 'حفظ ملف JSON لبياناتك';

  @override
  String get importDataDesc => 'دمج ملف نسخة احتياطية في CopyClip';

  @override
  String get notificationPermissionDenied => 'تم رفض إذن الإشعارات.';

  @override
  String get typeNewTask => 'اكتب مهمة جديدة...';

  @override
  String get addTask => 'إضافة مهمة';

  @override
  String get completed => 'مكتمل';

  @override
  String get greatJob => 'عمل رائع!';

  @override
  String youEarnedXPNextTask(Object amount, Object date) {
    return 'لقد ربحت $amount XP! المهمة التالية: $date';
  }

  @override
  String taskCompletedXP(Object amount) {
    return 'تمت المهمة! +$amount XP';
  }

  @override
  String get moveTasksToRecycleBin =>
      'نقل جميع المهام النشطة إلى سلة المحذوفات؟';

  @override
  String get deleteAllPosts => 'حذف جميع المنشورات';

  @override
  String get deleteAllPostsConfirmation =>
      'هل أنت متأكد أنك تريد حذف جميع المنشورات الاجتماعية؟ لا يمكن التراجع عن هذا الإجراء.';

  @override
  String get allPosts => 'جميع المنشورات';

  @override
  String get favorites => 'المفضلة';

  @override
  String get drafts => 'المسودات';

  @override
  String get noFavoritesYet => 'لا توجد مفضلات بعد';

  @override
  String get noDraftsYet => 'لا توجد مسودات بعد';

  @override
  String get startSocialJourney => 'ابدأ رحلتك الاجتماعية!';

  @override
  String get draft => 'مسودة';

  @override
  String attachmentCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count مرفقات',
      few: '$count مرفقات',
      two: 'مرفقان',
      one: 'مرفق واحد',
      zero: 'لا توجد مرفقات',
    );
    return '$_temp0';
  }

  @override
  String get pleaseAddContent => 'يرجى إضافة بعض المحتوى أو الوسائط للمشاركة';

  @override
  String fileNotFoundError(Object path) {
    return 'خطأ: لم يتم العثور على الملف في $path';
  }

  @override
  String get checkFacebookApp => 'تحقق من تطبيق فيسبوك';

  @override
  String get systemShare => 'مشاركة النظام';

  @override
  String get socialPost => 'منشور اجتماعي';

  @override
  String get favorite => 'مفضل';

  @override
  String get saveDraft => 'حفظ المسودة';

  @override
  String get entryCopied => 'تم نسخ المدخل';

  @override
  String get moveEntriesToRecycleBin =>
      'نقل جميع المدخلات النشطة إلى سلة المحذوفات؟';

  @override
  String get startWritingStory => 'ابدأ بكتابة قصتك';

  @override
  String get recordMemories => 'سجل ذكرياتك ومشاعرك اليومية.';

  @override
  String get writeJournal => 'اكتب يومياتك';

  @override
  String get myMemories => 'ذكرياتي';

  @override
  String get sortJournal => 'فرز اليوميات';

  @override
  String get byMood => 'حسب المزاج';

  @override
  String get searchMemories => 'بحث في الذكريات...';

  @override
  String get selectAll => 'تحديد الكل';

  @override
  String get deleteSelected => 'حذف المحدد';

  @override
  String get taskCompletedExclamation => 'تمت المهمة!';

  @override
  String get taskUncompletedExclamation => 'مهمة غير مكتملة';

  @override
  String get clipboardUpdatedExclamation => 'تم تحديث الحافظة!';

  @override
  String clipboardSavedContent(Object content) {
    return 'تم حفظ في الحافظة: $content';
  }

  @override
  String get overview => 'نظرة عامة';

  @override
  String get colorAurora => 'أورورا';

  @override
  String get colorCosmic => 'كوني';

  @override
  String get colorNebula => 'سديم';

  @override
  String get colorStarlight => 'ضوء النجوم';

  @override
  String get colorSolar => 'شمسي';

  @override
  String get colorNova => 'نوفا';

  @override
  String get loadingStepLoading => 'جارٍ التحميل...';

  @override
  String get loadingStepDatabase => 'إعداد قاعدة البيانات...';

  @override
  String get loadingStepSystem => 'تكوين النظام...';

  @override
  String get loadingStepReady => 'جاهز';

  @override
  String get productivityCompanion => 'رفيقك للإنتاجية';

  @override
  String get done => 'تم';

  @override
  String get newNote => 'ملاحظة جديدة';

  @override
  String get changeColor => 'تغيير اللون';

  @override
  String get copyContent => 'نسخ المحتوى';

  @override
  String get titleOptional => 'العنوان (اختياري)';

  @override
  String get exportAsPdf => 'تصدير كـ PDF';

  @override
  String get taskDueNow => 'موعد المهمة الآن';

  @override
  String get moveTaskToBinTitle => 'نقل المهمة إلى سلة المحذوفات؟';

  @override
  String get restoreTaskLater =>
      'يمكنك استعادة هذه المهمة لاحقًا من الإعدادات.';

  @override
  String get newTask => 'مهمة جديدة';

  @override
  String get editTask => 'تعديل المهمة';

  @override
  String get undo => 'تراجع';

  @override
  String get redo => 'إعادة';

  @override
  String get category => 'الفئة';

  @override
  String get categoryHint => 'مثال: العمل، النادي';

  @override
  String get whatNeedsToBeDone => 'ما الذي يجب القيام به؟';

  @override
  String get enterTaskDetails => 'أدخل تفاصيل المهمة...';

  @override
  String get setDueDate => 'تحديد موعد الاستحقاق';

  @override
  String get dueDate => 'موعد الاستحقاق';

  @override
  String get expenseTitle => 'النفقات';

  @override
  String searchInCurrency(String currency) {
    return 'بحث في $currency...';
  }

  @override
  String get sortAndFilter => 'فرز وتصفية';

  @override
  String get sortBy => 'فرز حسب';

  @override
  String get highestAmount => 'أعلى مبلغ';

  @override
  String get lowestAmount => 'أقل مبلغ';

  @override
  String get moreFilters => 'مزيد من الفلاتر...';

  @override
  String get filterExpenses => 'تصفية النفقات';

  @override
  String get transactionType => 'نوع المعاملة';

  @override
  String get categories => 'الفئات';

  @override
  String get all => 'الكل';

  @override
  String get income => 'الدخل';

  @override
  String get expense => 'المصروفات';

  @override
  String get reset => 'إعادة تعيين';

  @override
  String get apply => 'تطبيق';

  @override
  String newExpense(String currency) {
    return 'جديد $currency';
  }

  @override
  String errorLoadingData(String error) {
    return 'حدث خطأ أثناء تحميل البيانات.\n\n$error';
  }

  @override
  String get dailyQuote1 => 'أفضل طريقة للتنبؤ بالمستقبل هي أن تصنعه.';

  @override
  String get dailyQuote2 => 'الغنى ليس في كثرة العرض، ولكن الغنى غنى النفس.';

  @override
  String get dailyQuote3 => 'الوقت هو العملة الأغلى.';

  @override
  String get dailyQuote4 => 'النجاح ليس نهائياً، والفشل ليس قاتلاً.';

  @override
  String get dailyQuote5 => 'ركز على الحل، وليس المشكلة.';

  @override
  String get dailyQuote6 => 'شبكة علاقاتك هي ثروتك الحقيقية.';

  @override
  String get moodHappy => 'سعيد';

  @override
  String get moodExcited => 'متحمس';

  @override
  String get moodNeutral => 'محايد';

  @override
  String get moodSad => 'حزين';

  @override
  String get moodStressed => 'متوتر';

  @override
  String exportDate(String date) {
    return '📅 $date';
  }

  @override
  String exportMood(String emoji, String mood) {
    return 'المزاج: $emoji $mood';
  }

  @override
  String exportTitle(String title) {
    return 'العنوان: $title';
  }

  @override
  String exportTags(String tags) {
    return '\nالوسوم: $tags';
  }

  @override
  String get instagram => 'إنستغرام';

  @override
  String get facebook => 'فيسبوك';

  @override
  String get tiktok => 'تيك توك';

  @override
  String get newSketch => 'رسمة جديدة';

  @override
  String get searchSketches => 'البحث في الرسومات والمجلدات...';

  @override
  String get noResultsFound => 'لم يتم العثور على نتائج';

  @override
  String get noItems => 'لا توجد عناصر';

  @override
  String get noDrawingsYet => 'لا توجد رسومات بعد';

  @override
  String get canvasIntro => 'أطلق العنان لإبداعك على اللوحة!';

  @override
  String get newCanvas => 'لوحة جديدة';

  @override
  String get rename => 'إعادة تسمية';

  @override
  String get deleteFolder => 'حذف المجلد';

  @override
  String get deleteSketchesQuestion => 'حذف الرسومات؟';

  @override
  String get deleteFolderConfirmation =>
      'سيتم حذف جميع الرسومات في هذا المجلد نهائياً.';

  @override
  String get renameFolder => 'إعادة تسمية المجلد';

  @override
  String get chooseColor => 'اختر لوناً';

  @override
  String get deleteFolderQuestion => 'حذف المجلد؟';

  @override
  String get searchClips => 'البحث في القصاصات...';

  @override
  String get clipboardEmpty => 'الحافظة فارغة';

  @override
  String get addItem => 'إضافة عنصر';

  @override
  String get clipColor => 'لون القصاصة';

  @override
  String get newClip => 'قصاصة جديدة';

  @override
  String get editClip => 'تعديل القصاصة';

  @override
  String get restoreClipLater => 'يمكنك استعادة هذه القصاصة لاحقاً.';

  @override
  String get upcomingEvents => 'الأحداث القادمة';

  @override
  String get dataDistribution => 'توزيع البيانات';

  @override
  String get taskProgress => 'تقدم المهمة';

  @override
  String get quickStats => 'إحصائيات سريعة';

  @override
  String get taskCompletion => 'إكمال المهمة';

  @override
  String get noItemsForDate => 'لا توجد عناصر لهذا التاريخ';

  @override
  String get enjoyFreeTime => 'استمتع بوقت فراغك!';

  @override
  String get searchThisDay => 'البحث في هذا اليوم...';

  @override
  String get finance => 'المالية';

  @override
  String get permanentlyDelete => 'حذف نهائي؟';

  @override
  String deleteSelectionConfirmation(int foldersCount, int sketchesCount) {
    return 'سيؤدي هذا إلى حذف $foldersCount مجلدات (ورسماتها) و $sketchesCount رسومات أخرى نهائياً.\n\nلا يمكن التراجع عن هذا الإجراء.';
  }

  @override
  String get deleteForever => 'حذف للأبد';

  @override
  String selectedCount(int count) {
    return '$count محدد';
  }

  @override
  String canvasStats(int notes, int folders) {
    return '$notes رسومات • $folders مجلدات';
  }

  @override
  String get sortItems => 'فرز العناصر';

  @override
  String get sortNameAZ => 'الاسم (أ-ي)';

  @override
  String get sortNameZA => 'الاسم (ي-أ)';

  @override
  String get createFolder => 'إنشاء مجلد';

  @override
  String get folderNameHint => 'اسم المجلد...';

  @override
  String deleteSketchesConfirmation(int count) {
    return 'حذف $count رسومات؟ لا يمكن التراجع عن هذا الإجراء.';
  }

  @override
  String get noSketchesFound => 'لم يتم العثور على رسومات';

  @override
  String get noSketchesFoundSub => 'حاول تعديل بحثك أو إنشاء رسمة جديدة.';

  @override
  String searchInFolder(String folder) {
    return 'بحث في $folder...';
  }

  @override
  String sketchesCount(int count) {
    return '$count رسومات';
  }

  @override
  String get sortSketches => 'فرز الرسومات';

  @override
  String get calendarScreenTitle => 'التقويم';

  @override
  String get dailyActivity => 'النشاط اليومي';

  @override
  String get deleteItemQuestion => 'حذف العنصر؟';

  @override
  String get deleteItemConfirmation =>
      'سيؤدي هذا إلى نقل العنصر إلى سلة المحذوفات.';

  @override
  String get moveToBinItem => 'نقل إلى السلة؟';

  @override
  String get moveToBinConfirmation => 'يمكنك استعادته لاحقاً.';

  @override
  String selectedItems(int count) {
    return '$count محدد';
  }

  @override
  String get recentClips => 'القصاصات الأخيرة';

  @override
  String get copied => 'تم النسخ!';

  @override
  String get copiedPlainText => 'تم نسخ النص المجرد';

  @override
  String get clipTheme => 'مظهر القصاصة';

  @override
  String get justNow => 'الآن';

  @override
  String minutesAgo(Object count) {
    return 'منذ $count د';
  }

  @override
  String hoursAgo(Object count) {
    return 'منذ $count س';
  }

  @override
  String daysAgo(Object count) {
    return 'منذ $count ي';
  }

  @override
  String get noTasksFound => 'لم يتم العثور على مهام.';

  @override
  String get searchTasks => 'بحث في المهام...';

  @override
  String get taskReminder => 'تذكير بالمهمة';

  @override
  String get untitledNote => 'ملاحظة بدون عنوان';

  @override
  String get dailyEntry => 'مدخل يومي';

  @override
  String get clipboardHistory => 'سجل الحافظة';

  @override
  String get deletePermanentlyContent => 'هذا الإجراء لا يمكن التراجع عنه.';

  @override
  String get emptyRecycleBinTitle => 'إفراغ سلة المحذوفات؟';

  @override
  String emptyRecycleBinContent(Object count) {
    return 'سيتم حذف جميع العناصر الـ $count نهائياً.';
  }

  @override
  String get emptyBin => 'إفراغ السلة';

  @override
  String get recycleBinEmpty => 'سلة المحذوفات فارغة';

  @override
  String get deletedItemsAppearHere => 'العناصر المحذوفة ستظهر هنا.';

  @override
  String get empty => 'فارغ';

  @override
  String get recent => 'الأخيرة';

  @override
  String categoryLabel(Object category) {
    return 'الفئة: $category';
  }

  @override
  String get general => 'عام';

  @override
  String get saveTransactionQuestion => 'هل تريد حفظ هذه المعاملة؟';

  @override
  String get fillTitleAmount => 'يرجى ملء العنوان والمبلغ';

  @override
  String get invalidAmount => 'تنسيق المبلغ غير صالح';

  @override
  String get moveTransactionToBinTitle => 'نقل المعاملة إلى سلة المحذوفات؟';

  @override
  String get restoreTransactionLater =>
      'يمكنك استعادة هذه المعاملة لاحقاً من الإعدادات.';

  @override
  String get newTransaction => 'معاملة جديدة';

  @override
  String get whatIsThisFor => 'فيما هذا؟';

  @override
  String get description => 'الوصف';

  @override
  String get daily => 'يومياً';

  @override
  String get weekly => 'أسبوعياً';

  @override
  String get monthly => 'شهرياً';

  @override
  String get yearly => 'سنوياً';

  @override
  String get totalIncome => 'إجمالي الدخل';

  @override
  String get totalExpense => 'إجمالي النفقات';

  @override
  String get analysis => 'التحليل';

  @override
  String get transactions => 'المعاملات';

  @override
  String get noExpensesFound => 'لم يتم العثور على نفقات لهذه الفترة.';

  @override
  String get netBalance => 'صافي الرصيد';

  @override
  String get topCategories => 'أبرز الفئات';

  @override
  String get spendingTrend => 'اتجاه الإنفاق';

  @override
  String get insights => 'رؤى';

  @override
  String get noExpensesRecorded => 'لم يتم تسجيل أي نفقات';

  @override
  String get trackSpendingHabits => 'تتبع عادات الإنفاق الخاصة بك بسهولة.';

  @override
  String get addExpense => 'إضافة نفقة';

  @override
  String get noDataForPeriod => 'لا توجد بيانات لهذه الفترة';

  @override
  String get budget => 'الميزانية';

  @override
  String get spent => 'تم صرفه';

  @override
  String get limit => 'الحد';

  @override
  String get overBudget => 'تجاوز الميزانية!';

  @override
  String remainingBudget(Object percent) {
    return 'متبقي $percent%';
  }

  @override
  String get savingsRate => 'معدل الادخار';

  @override
  String get healthScore => 'درجة الصحة المالية';

  @override
  String get healthScoreExplanation =>
      'هذه الدرجة تعتمد على معدل ادخارك.\n\n• ادخار > 50% = ممتاز (100)\n• ادخار 0% = متوسط (50)\n• الإنفاق > الدخل = ضعيف (<50)';

  @override
  String get ok => 'موافق';

  @override
  String get bulkImport => 'استيراد بالجملة';
}

/// The translations for Arabic, as used in Morocco (`ar_MA`).
class AppLocalizationsArMa extends AppLocalizationsAr {
  AppLocalizationsArMa() : super('ar_MA');

  @override
  String get settings => 'إعدادات';

  @override
  String get language => 'لغة';

  @override
  String get systemDefault => 'النظام الافتراضي';

  @override
  String get notes => 'ملحوظات';

  @override
  String get todos => 'المهام';

  @override
  String get expenses => 'نفقات';

  @override
  String get journal => 'مجلة';

  @override
  String get calendar => 'تقويم';

  @override
  String get clipboard => 'الحافظة';

  @override
  String get canvas => 'قماش';

  @override
  String get save => 'حفظ';

  @override
  String get create => 'إنشاء';

  @override
  String get cancel => 'إلغاء';

  @override
  String get delete => 'حذف';

  @override
  String get edit => 'تعديل';

  @override
  String get share => 'مشاركة';

  @override
  String get copy => 'نسخ';

  @override
  String get unsavedChanges => 'تغييرات غير محفوظة';

  @override
  String get confirmDelete => 'تأكيد الحذف';

  @override
  String get discard => 'تجاهل';

  @override
  String get createPost => 'إنشاء منشور';

  @override
  String get post => 'منشور';

  @override
  String get postingTo => 'النشر في';

  @override
  String get whatsOnYourMind => 'ماذا يدور في ذهنك؟';

  @override
  String get pickImages => 'اختر صورًا';

  @override
  String get pickVideo => 'اختر فيديو';

  @override
  String get camera => 'كاميرا';

  @override
  String get gallery => 'معرض الصور';

  @override
  String get search => 'بحث';

  @override
  String get pleaseEnterTask => 'يرجى إدخال مهمة';

  @override
  String get deleteTask => 'حذف المهمة';

  @override
  String get selectItems => 'حدد العناصر';

  @override
  String get deleteAll => 'حذف الكل';

  @override
  String error(Object error) {
    return 'خطأ: $error';
  }

  @override
  String get orderingOnlyAvailableInAllPosts =>
      'الترتيب متاح فقط في \"جميع المنشورات\"';

  @override
  String get deletePost => 'حذف المنشور';

  @override
  String get postDeleted => 'تم حذف المنشور';

  @override
  String get premiumFeatures => 'ميزات بريميوم';

  @override
  String get manageCoinsAdsPremium =>
      'إدارة العملات والإعلانات وحالة البريميوم';

  @override
  String get themeMode => 'وضع المظهر';

  @override
  String get accentColor => 'لون التمييز';

  @override
  String get backgroundDesign => 'تصميم الخلفية';

  @override
  String get pushNotifications => 'إشعارات الدفع';

  @override
  String get recycleBin => 'سلة المحذوفات';

  @override
  String get exportData => 'تصدير البيانات';

  @override
  String get importData => 'استيراد البيانات';

  @override
  String get rateApp => 'تقييم التطبيق';

  @override
  String get sendFeedback => 'إرسال تعليقات';

  @override
  String get privacyPolicy => 'سياسة الخصوصية';

  @override
  String get version => 'الإصدار';

  @override
  String get buildNumber => 'رقم البناء';

  @override
  String get system => 'النظام';

  @override
  String get light => 'فاتح';

  @override
  String get dark => 'داكن';

  @override
  String get itemRestored => 'تمت استعادة العنصر';

  @override
  String get recycleBinCleared => 'تم إفراغ سلة المحذوفات بنجاح';

  @override
  String get allPostsDeleted => 'تم حذف جميع المنشورات';

  @override
  String get newPost => 'منشور جديد';

  @override
  String get textCopiedToClipboardFacebook =>
      'Text copied to clipboard (Facebook policy)';

  @override
  String get tiktokSharingRequiresVideoImage =>
      'تتطلب مشاركة TikTok فيديو/صورة';

  @override
  String errorSharing(Object error) {
    return 'خطأ في المشاركة: $error';
  }

  @override
  String shareToStory(Object platform) {
    return 'مشاركة في قصة $platform';
  }

  @override
  String shareToFeed(Object platform) {
    return 'مشاركة في موجز $platform';
  }

  @override
  String get unlockPermanently => 'فتح بشكل دائم';

  @override
  String get notEnoughCoins => 'لا توجد عملات كافية!';

  @override
  String youEarnedCoins(Object amount) {
    return 'لقد ربحت $amount من العملات!';
  }

  @override
  String get contentCopied => 'تم نسخ المحتوى';

  @override
  String get selectDateTime => 'حدد التاريخ والوقت';

  @override
  String get areYouSureYouWantToDeleteThisPost =>
      'هل أنت متأكد أنك تريد حذف هذا المنشور؟';

  @override
  String get socialPosts => 'منشورات اجتماعية';

  @override
  String get watchAdToEarnCoins => 'شاهد إعلانًا لربح العملات';

  @override
  String get premiumUnlocked => 'تم فتح البريميوم';

  @override
  String get removeAds => 'إزالة الإعلانات';

  @override
  String get unlimitedCloudStorage => 'تخزين سحابي غير محدود';

  @override
  String get deleteNote => 'حذف الملاحظة';

  @override
  String get shareNote => 'مشاركة الملاحظة';

  @override
  String get editNote => 'تعديل الملاحظة';

  @override
  String get searchNotes => 'البحث في الملاحظات...';

  @override
  String get noNotesFound => 'لم يتم العثور على ملاحظات';

  @override
  String get captureThoughts => 'سجل أفكارك فورا.';

  @override
  String get createNote => 'إنشاء ملاحظة';

  @override
  String get customOrder => 'ترتيب مخصص';

  @override
  String get newestFirst => 'الأحدث أولاً';

  @override
  String get oldestFirst => 'الأقدم أولاً';

  @override
  String get titleAZ => 'العنوان: أ-ي';

  @override
  String get titleZA => 'العنوان: ي-أ';

  @override
  String get deleteAllQuestion => 'حذف الكل؟';

  @override
  String get moveToRecycleBin => 'نقل جميع الملاحظات إلى سلة المحذوفات؟';

  @override
  String get moveToBinQuestion => 'نقل إلى السلة؟';

  @override
  String get restoreNoteLater => 'يمكنك استعادة هذه الملاحظة لاحقًا.';

  @override
  String get move => 'نقل';

  @override
  String get myThoughts => 'أفكاري';

  @override
  String get selected => 'محدد';

  @override
  String get noContent => 'لا يوجد محتوى';

  @override
  String get untitled => 'بدون عنوان';

  @override
  String get chooseWallpapers => 'اختر من بين أكثر من 10 خلفيات ديناميكية';

  @override
  String get backupData => 'نسخ احتياطي للبيانات';

  @override
  String get saveJsonFile => 'هل تريد حفظ ملف JSON يحتوي على جميع بياناتك؟';

  @override
  String get exportNow => 'تصدير الآن';

  @override
  String get importDataTitle => 'استيراد البيانات';

  @override
  String get mergeBackupFile =>
      'هل تريد دمج ملف النسخ الاحتياطي مع العناصر الحالية؟';

  @override
  String get selectFile => 'حدد ملفاً';

  @override
  String get backupSaved => 'تم حفظ النسخة الاحتياطية بنجاح!';

  @override
  String get exportFailed => 'فشل التصدير.';

  @override
  String importSuccess(Object count) {
    return 'تمت استعادة $count من العناصر بنجاح!';
  }

  @override
  String get importFailed => 'فشل الاستيراد.';

  @override
  String widgetAdded(String widget) {
    return 'تمت إضافة الأداة $widget إلى الشاشة الرئيسية!';
  }

  @override
  String get widgetRequestSent =>
      'تم إرسال طلب الأداة. يرجى التحقق من الشاشة الرئيسية.';

  @override
  String get widgetAddFailed => 'فشل إضافة الأداة';

  @override
  String get autoSaveEnabled => 'تم تفعيل الحفظ التلقائي.';

  @override
  String get autoSaveDisabled => 'تم تعطيل الحفظ التلقائي.';

  @override
  String get homeScreenWidgets => 'أدوات الشاشة الرئيسية';

  @override
  String get notificationsTitle => 'الإشعارات';

  @override
  String get dataBackup => 'البيانات والنسخ الاحتياطي';

  @override
  String get feedbackSupport => 'التعليقات والدعم';

  @override
  String get creditsTitle => 'الاعتمادات';

  @override
  String get privacyMaintenance => 'الخصوصية والصيانة';

  @override
  String get aboutTitle => 'حول';

  @override
  String get premium => 'بريميوم';

  @override
  String get appearanceTitle => 'المظهر';

  @override
  String get clipboardTitle => 'الحافظة';

  @override
  String get settingsSubtitle => 'تخصيص تجربتك';

  @override
  String get welcomeTitle => 'مرحبًا بك في CopyClip';

  @override
  String get welcomeDescription =>
      'رفيقك النهائي للإنتاجية. دعنا نجهزك بأدوات قوية لإدارة يومك.';

  @override
  String get onboardingNotesTitle => 'ملاحظات ذكية';

  @override
  String get onboardingNotesDesc =>
      'التقط الأفكار فورًا بتنسيق نص غني. نظم أفكارك ولا تفقد أي فكرة رائعة مرة أخرى.';

  @override
  String get onboardingTodosTitle => 'إدارة المهام';

  @override
  String get onboardingTodosDesc =>
      'ابق مطلعاً على أمورك. أنشئ قوائم مهام، وحدد الأولويات، وحقق أهدافك خطوة بخطوة.';

  @override
  String get onboardingExpensesTitle => 'تتبع النفقات';

  @override
  String get onboardingExpensesDesc =>
      'تحكم في أموالك. تتبع الدخل والنفقات بسهولة لفهم عادات الإنفاق الخاصة بك.';

  @override
  String get onboardingJournalTitle => 'يوميات شخصية';

  @override
  String get onboardingJournalDesc =>
      'تأمل في يومك. مساحة خاصة لتدوين ذكرياتك ومشاعرك وتجاربك اليومية.';

  @override
  String get onboardingCalendarTitle => 'التقويم والأحداث';

  @override
  String get onboardingCalendarDesc =>
      'لا تفوت أي لحظة. نظم جدولك وتابع الأحداث الهامة القادمة.';

  @override
  String get onboardingClipboardTitle => 'مدير الحافظة';

  @override
  String get onboardingClipboardDesc =>
      'انسخ مرة واحدة، والصق في أي مكان. الوصول إلى سجل الحافظة لاستعادة النصوص التي نسختها سابقاً.';

  @override
  String get onboardingCanvasTitle => 'لوحة إبداعية';

  @override
  String get onboardingCanvasDesc =>
      'أطلق العنان لإبداعك. ارسم وخطط وصور أفكارك على لوحة رقمية حرة.';

  @override
  String get featuresNotesDesc => 'إنشاء وإدارة الملاحظات الخاصة بك';

  @override
  String get featuresTodosDesc => 'تتبع المهام الخاصة بك';

  @override
  String get featuresExpensesDesc => 'مراقبة النفقات الخاصة بك';

  @override
  String get featuresJournalDesc => 'اكتتب أفكارك';

  @override
  String get featuresCalendarDesc => 'نظم جدولك الزمني';

  @override
  String get featuresClipboardDesc => 'الوصول إلى سجل الحافظة الخاص بك';

  @override
  String get featuresCanvasDesc => 'ارسم وخطط بحرية';

  @override
  String get featuresSocialPost => 'منشور اجتماعي';

  @override
  String get featuresSocialPostDesc =>
      'إنشاء محتوى جذاب لوسائل التواصل الاجتماعي';

  @override
  String get chooseYourAura => 'اختر هالتك';

  @override
  String get expressYourselfTheme => 'عبر عن نفسك بلون مظهر جديد!';

  @override
  String get level => 'المستوى';

  @override
  String get xpToNextLevel => 'XP للمستوى التالي';

  @override
  String get checkUpcomingEvents => 'تحقق من الأحداث القادمة';

  @override
  String get startNewSketch => 'بدأ رسمة جديدة';

  @override
  String get noTransactionsMonth => 'لا توجد معاملات هذا الشهر';

  @override
  String transactionsThisMonth(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count معاملات هذا الشهر',
      few: '$count معاملات هذا الشهر',
      two: 'معاملتان هذا الشهر',
      one: 'معاملة واحدة هذا الشهر',
      zero: 'لا توجد معاملات هذا الشهر',
    );
    return '$_temp0';
  }

  @override
  String get autoSaveClipboard => 'حفظ تلقائي للحافظة';

  @override
  String get autoSaveClipboardDesc => 'حفظ العناصر المنسوخة تلقائياً';

  @override
  String get permissionDeniedSettings =>
      'تم رفض الإذن بشكل دائم. يرجى تفعيله من الإعدادات.';

  @override
  String get notificationsEnabled => 'تم تفعيل الإشعارات!';

  @override
  String get redirectingToSettings =>
      'جارٍ التوجيه إلى الإعدادات لتعطيل الإشعارات...';

  @override
  String get premiumAccess => 'وصول بريميوم';

  @override
  String get premiumActiveUntil => 'بريميوم نشط حتى';

  @override
  String get unlockAllFeatures => 'فتح جميع الميزات';

  @override
  String get buyPremium => 'شراء بريميوم (7 أيام)';

  @override
  String costCoins(Object cost) {
    return 'التكلفة: $cost عملات';
  }

  @override
  String get premiumActivated => 'تم تفعيل البريميوم لمدة 7 أيام!';

  @override
  String get premiumActive => 'البريميوم نشط';

  @override
  String get expires => 'تنتهي الصلاحية:';

  @override
  String get temporaryAccess => 'وصول مؤقت';

  @override
  String get journalExpression => 'يوميات وتعبير';

  @override
  String get artisticDesigns => 'تصاميم فنية';

  @override
  String get artisticDesignsDesc =>
      'فتح أكثر من 10 مظاهر فريدة لبطاقات اليوميات';

  @override
  String get premiumLayouts => 'تخطيطات بريميوم';

  @override
  String get premiumLayoutsDesc => 'طرق حصرية لعرض ذكرياتك';

  @override
  String get calendarTools => 'تقويم وأدوات';

  @override
  String get fullCalendar => 'تقويم كامل';

  @override
  String get fullCalendarDesc => 'نظام متكامل لإدارة الأحداث';

  @override
  String get clipboardAutoSaveDesc => 'التقاط سجل الحافظة في الخلفية';

  @override
  String get proWidgets => 'أدوات ذكية للمحترفين';

  @override
  String get proWidgetsDesc => 'جميع الميزات متوفرة على شاشتك الرئيسية';

  @override
  String get dataExport => 'البيانات والتصدير';

  @override
  String get advancedBackup => 'نسخ احتياطي متقدم';

  @override
  String get advancedBackupDesc => 'استيراد/تصدير آمن لجميع البيانات';

  @override
  String get pdfExport => 'تصدير إلى PDF';

  @override
  String get pdfExportDesc => 'تصدير الملاحظات واليوميات إلى PDF';

  @override
  String get printReady => 'جاهز للطباعة';

  @override
  String get printReadyDesc => 'دعم الطباعة المباشرة';

  @override
  String get richTextEditor => 'محرر نص غني';

  @override
  String get advancedSearch => 'بحث متقدم';

  @override
  String get advancedSearchDesc => 'البحث والاستبدال داخل النص';

  @override
  String get richMedia => 'وسائط غنية';

  @override
  String get richMediaDesc => 'إدراج صور وفيديوهات وروابط';

  @override
  String get editorStyling => 'تنسيق المحرر';

  @override
  String get editorStylingDesc => 'نص مخصص وخلفيات للمحرر';

  @override
  String get balance => 'الرصيد';

  @override
  String get loadingAd => 'جارٍ تحميل الإعلان...';

  @override
  String watchAd(Object amount) {
    return 'مشاهدة إعلان (+$amount)';
  }

  @override
  String get loadAd => 'تحميل إعلان';

  @override
  String get backupDataDesc => 'حفظ ملف JSON لبياناتك';

  @override
  String get importDataDesc => 'دمج ملف نسخة احتياطية في CopyClip';

  @override
  String get notificationPermissionDenied => 'تم رفض إذن الإشعارات.';

  @override
  String get typeNewTask => 'اكتب مهمة جديدة...';

  @override
  String get addTask => 'إضافة مهمة';

  @override
  String get completed => 'مكتمل';

  @override
  String get greatJob => 'عمل رائع!';

  @override
  String youEarnedXPNextTask(Object amount, Object date) {
    return 'لقد ربحت $amount XP! المهمة التالية: $date';
  }

  @override
  String taskCompletedXP(Object amount) {
    return 'تمت المهمة! +$amount XP';
  }

  @override
  String get moveTasksToRecycleBin =>
      'نقل جميع المهام النشطة إلى سلة المحذوفات؟';

  @override
  String get deleteAllPosts => 'حذف جميع المنشورات';

  @override
  String get deleteAllPostsConfirmation =>
      'هل أنت متأكد أنك تريد حذف جميع المنشورات الاجتماعية؟ لا يمكن التراجع عن هذا الإجراء.';

  @override
  String get allPosts => 'جميع المنشورات';

  @override
  String get favorites => 'المفضلة';

  @override
  String get drafts => 'المسودات';

  @override
  String get noFavoritesYet => 'لا توجد مفضلات بعد';

  @override
  String get noDraftsYet => 'لا توجد مسودات بعد';

  @override
  String get startSocialJourney => 'ابدأ رحلتك الاجتماعية!';

  @override
  String get draft => 'مسودة';

  @override
  String attachmentCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count مرفقات',
      few: '$count مرفقات',
      two: 'مرفقان',
      one: 'مرفق واحد',
      zero: 'لا توجد مرفقات',
    );
    return '$_temp0';
  }

  @override
  String get pleaseAddContent => 'يرجى إضافة بعض المحتوى أو الوسائط للمشاركة';

  @override
  String fileNotFoundError(Object path) {
    return 'خطأ: لم يتم العثور على الملف في $path';
  }

  @override
  String get checkFacebookApp => 'تحقق من تطبيق فيسبوك';

  @override
  String get systemShare => 'مشاركة النظام';

  @override
  String get socialPost => 'منشور اجتماعي';

  @override
  String get favorite => 'مفضل';

  @override
  String get saveDraft => 'حفظ المسودة';

  @override
  String get entryCopied => 'تم نسخ المدخل';

  @override
  String get moveEntriesToRecycleBin =>
      'نقل جميع المدخلات النشطة إلى سلة المحذوفات؟';

  @override
  String get startWritingStory => 'ابدأ بكتابة قصتك';

  @override
  String get recordMemories => 'سجل ذكرياتك ومشاعرك اليومية.';

  @override
  String get writeJournal => 'اكتب يومياتك';

  @override
  String get myMemories => 'ذكرياتي';

  @override
  String get sortJournal => 'فرز اليوميات';

  @override
  String get byMood => 'حسب المزاج';

  @override
  String get searchMemories => 'بحث في الذكريات...';

  @override
  String get selectAll => 'تحديد الكل';

  @override
  String get deleteSelected => 'حذف المحدد';

  @override
  String get taskCompletedExclamation => 'تمت المهمة!';

  @override
  String get taskUncompletedExclamation => 'مهمة غير مكتملة';

  @override
  String get clipboardUpdatedExclamation => 'تم تحديث الحافظة!';

  @override
  String clipboardSavedContent(Object content) {
    return 'تم حفظ في الحافظة: $content';
  }

  @override
  String get overview => 'نظرة عامة';

  @override
  String get colorAurora => 'أورورا';

  @override
  String get colorCosmic => 'كوني';

  @override
  String get colorNebula => 'سديم';

  @override
  String get colorStarlight => 'ضوء النجوم';

  @override
  String get colorSolar => 'شمسي';

  @override
  String get colorNova => 'نوفا';

  @override
  String get loadingStepLoading => 'جارٍ التحميل...';

  @override
  String get loadingStepDatabase => 'إعداد قاعدة البيانات...';

  @override
  String get loadingStepSystem => 'تكوين النظام...';

  @override
  String get loadingStepReady => 'جاهز';

  @override
  String get productivityCompanion => 'رفيقك للإنتاجية';

  @override
  String get done => 'تم';

  @override
  String get newNote => 'ملاحظة جديدة';

  @override
  String get changeColor => 'تغيير اللون';

  @override
  String get copyContent => 'نسخ المحتوى';

  @override
  String get titleOptional => 'العنوان (اختياري)';

  @override
  String get exportAsPdf => 'تصدير كـ PDF';

  @override
  String get taskDueNow => 'موعد المهمة الآن';

  @override
  String get moveTaskToBinTitle => 'نقل المهمة إلى سلة المحذوفات؟';

  @override
  String get restoreTaskLater =>
      'يمكنك استعادة هذه المهمة لاحقًا من الإعدادات.';

  @override
  String get newTask => 'مهمة جديدة';

  @override
  String get editTask => 'تعديل المهمة';

  @override
  String get undo => 'تراجع';

  @override
  String get redo => 'إعادة';

  @override
  String get category => 'الفئة';

  @override
  String get categoryHint => 'مثال: العمل، النادي';

  @override
  String get whatNeedsToBeDone => 'ما الذي يجب القيام به؟';

  @override
  String get enterTaskDetails => 'أدخل تفاصيل المهمة...';

  @override
  String get setDueDate => 'تحديد موعد الاستحقاق';

  @override
  String get dueDate => 'موعد الاستحقاق';

  @override
  String get expenseTitle => 'النفقات';

  @override
  String searchInCurrency(String currency) {
    return 'بحث في $currency...';
  }

  @override
  String get sortAndFilter => 'فرز وتصفية';

  @override
  String get sortBy => 'فرز حسب';

  @override
  String get highestAmount => 'أعلى مبلغ';

  @override
  String get lowestAmount => 'أقل مبلغ';

  @override
  String get moreFilters => 'مزيد من الفلاتر...';

  @override
  String get filterExpenses => 'تصفية النفقات';

  @override
  String get transactionType => 'نوع المعاملة';

  @override
  String get categories => 'الفئات';

  @override
  String get all => 'الكل';

  @override
  String get income => 'الدخل';

  @override
  String get expense => 'المصروفات';

  @override
  String get reset => 'إعادة تعيين';

  @override
  String get apply => 'تطبيق';

  @override
  String newExpense(String currency) {
    return 'جديد $currency';
  }

  @override
  String errorLoadingData(String error) {
    return 'حدث خطأ أثناء تحميل البيانات.\n\n$error';
  }

  @override
  String get dailyQuote1 => 'أفضل طريقة للتنبؤ بالمستقبل هي أن تصنعه.';

  @override
  String get dailyQuote2 => 'الغنى ليس في كثرة العرض، ولكن الغنى غنى النفس.';

  @override
  String get dailyQuote3 => 'الوقت هو العملة الأغلى.';

  @override
  String get dailyQuote4 => 'النجاح ليس نهائياً، والفشل ليس قاتلاً.';

  @override
  String get dailyQuote5 => 'ركز على الحل، وليس المشكلة.';

  @override
  String get dailyQuote6 => 'شبكة علاقاتك هي ثروتك الحقيقية.';

  @override
  String get moodHappy => 'سعيد';

  @override
  String get moodExcited => 'متحمس';

  @override
  String get moodNeutral => 'محايد';

  @override
  String get moodSad => 'حزين';

  @override
  String get moodStressed => 'متوتر';

  @override
  String exportDate(String date) {
    return '📅 $date';
  }

  @override
  String exportMood(String emoji, String mood) {
    return 'المزاج: $emoji $mood';
  }

  @override
  String exportTitle(String title) {
    return 'العنوان: $title';
  }

  @override
  String exportTags(String tags) {
    return '\nالوسوم: $tags';
  }

  @override
  String get instagram => 'إنستغرام';

  @override
  String get facebook => 'فيسبوك';

  @override
  String get tiktok => 'تيك توك';

  @override
  String get newSketch => 'رسمة جديدة';

  @override
  String get searchSketches => 'البحث في الرسومات والمجلدات...';

  @override
  String get noResultsFound => 'لم يتم العثور على نتائج';

  @override
  String get noItems => 'لا توجد عناصر';

  @override
  String get noDrawingsYet => 'لا توجد رسومات بعد';

  @override
  String get canvasIntro => 'أطلق العنان لإبداعك على اللوحة!';

  @override
  String get newCanvas => 'لوحة جديدة';

  @override
  String get rename => 'إعادة تسمية';

  @override
  String get deleteFolder => 'حذف المجلد';

  @override
  String get deleteSketchesQuestion => 'حذف الرسومات؟';

  @override
  String get deleteFolderConfirmation =>
      'سيتم حذف جميع الرسومات في هذا المجلد نهائياً.';

  @override
  String get renameFolder => 'إعادة تسمية المجلد';

  @override
  String get chooseColor => 'اختر لوناً';

  @override
  String get deleteFolderQuestion => 'حذف المجلد؟';

  @override
  String get searchClips => 'البحث في القصاصات...';

  @override
  String get clipboardEmpty => 'الحافظة فارغة';

  @override
  String get addItem => 'إضافة عنصر';

  @override
  String get clipColor => 'لون القصاصة';

  @override
  String get newClip => 'قصاصة جديدة';

  @override
  String get editClip => 'تعديل القصاصة';

  @override
  String get restoreClipLater => 'يمكنك استعادة هذه القصاصة لاحقاً.';

  @override
  String get upcomingEvents => 'الأحداث القادمة';

  @override
  String get dataDistribution => 'توزيع البيانات';

  @override
  String get taskProgress => 'تقدم المهمة';

  @override
  String get quickStats => 'إحصائيات سريعة';

  @override
  String get taskCompletion => 'إكمال المهمة';

  @override
  String get noItemsForDate => 'لا توجد عناصر لهذا التاريخ';

  @override
  String get enjoyFreeTime => 'استمتع بوقت فراغك!';

  @override
  String get searchThisDay => 'البحث في هذا اليوم...';

  @override
  String get finance => 'المالية';

  @override
  String get permanentlyDelete => 'حذف نهائي؟';

  @override
  String deleteSelectionConfirmation(int foldersCount, int sketchesCount) {
    return 'سيؤدي هذا إلى حذف $foldersCount مجلدات (ورسماتها) و $sketchesCount رسومات أخرى نهائياً.\n\nلا يمكن التراجع عن هذا الإجراء.';
  }

  @override
  String get deleteForever => 'حذف للأبد';

  @override
  String selectedCount(int count) {
    return '$count محدد';
  }

  @override
  String canvasStats(int notes, int folders) {
    return '$notes رسومات • $folders مجلدات';
  }

  @override
  String get sortItems => 'فرز العناصر';

  @override
  String get sortNameAZ => 'الاسم (أ-ي)';

  @override
  String get sortNameZA => 'الاسم (ي-أ)';

  @override
  String get createFolder => 'إنشاء مجلد';

  @override
  String get folderNameHint => 'اسم المجلد...';

  @override
  String deleteSketchesConfirmation(int count) {
    return 'حذف $count رسومات؟ لا يمكن التراجع عن هذا الإجراء.';
  }

  @override
  String get noSketchesFound => 'لم يتم العثور على رسومات';

  @override
  String get noSketchesFoundSub => 'حاول تعديل بحثك أو إنشاء رسمة جديدة.';

  @override
  String searchInFolder(String folder) {
    return 'بحث في $folder...';
  }

  @override
  String sketchesCount(int count) {
    return '$count رسومات';
  }

  @override
  String get sortSketches => 'فرز الرسومات';

  @override
  String get calendarScreenTitle => 'التقويم';

  @override
  String get dailyActivity => 'النشاط اليومي';

  @override
  String get deleteItemQuestion => 'حذف العنصر؟';

  @override
  String get deleteItemConfirmation =>
      'سيؤدي هذا إلى نقل العنصر إلى سلة المحذوفات.';

  @override
  String get moveToBinItem => 'نقل إلى السلة؟';

  @override
  String get moveToBinConfirmation => 'يمكنك استعادته لاحقاً.';

  @override
  String selectedItems(int count) {
    return '$count محدد';
  }

  @override
  String get recentClips => 'القصاصات الأخيرة';

  @override
  String get copied => 'تم النسخ!';

  @override
  String get copiedPlainText => 'تم نسخ النص المجرد';

  @override
  String get clipTheme => 'مظهر القصاصة';

  @override
  String get justNow => 'الآن';

  @override
  String minutesAgo(Object count) {
    return 'منذ $count د';
  }

  @override
  String hoursAgo(Object count) {
    return 'منذ $count س';
  }

  @override
  String daysAgo(Object count) {
    return 'منذ $count ي';
  }

  @override
  String get noTasksFound => 'لم يتم العثور على مهام.';

  @override
  String get searchTasks => 'بحث في المهام...';

  @override
  String get taskReminder => 'تذكير بالمهمة';

  @override
  String get untitledNote => 'ملاحظة بدون عنوان';

  @override
  String get dailyEntry => 'مدخل يومي';

  @override
  String get clipboardHistory => 'سجل الحافظة';

  @override
  String get deletePermanentlyContent => 'هذا الإجراء لا يمكن التراجع عنه.';

  @override
  String get emptyRecycleBinTitle => 'إفراغ سلة المحذوفات؟';

  @override
  String emptyRecycleBinContent(Object count) {
    return 'سيتم حذف جميع العناصر الـ $count نهائياً.';
  }

  @override
  String get emptyBin => 'إفراغ السلة';

  @override
  String get recycleBinEmpty => 'سلة المحذوفات فارغة';

  @override
  String get deletedItemsAppearHere => 'العناصر المحذوفة ستظهر هنا.';

  @override
  String get empty => 'فارغ';

  @override
  String get recent => 'الأخيرة';

  @override
  String categoryLabel(Object category) {
    return 'الفئة: $category';
  }

  @override
  String get general => 'عام';

  @override
  String get saveTransactionQuestion => 'هل تريد حفظ هذه المعاملة؟';

  @override
  String get fillTitleAmount => 'يرجى ملء العنوان والمبلغ';

  @override
  String get invalidAmount => 'تنسيق المبلغ غير صالح';

  @override
  String get moveTransactionToBinTitle => 'نقل المعاملة إلى سلة المحذوفات؟';

  @override
  String get restoreTransactionLater =>
      'يمكنك استعادة هذه المعاملة لاحقاً من الإعدادات.';

  @override
  String get newTransaction => 'معاملة جديدة';

  @override
  String get whatIsThisFor => 'فيما هذا؟';

  @override
  String get description => 'الوصف';

  @override
  String get daily => 'يومياً';

  @override
  String get weekly => 'أسبوعياً';

  @override
  String get monthly => 'شهرياً';

  @override
  String get yearly => 'سنوياً';

  @override
  String get totalIncome => 'إجمالي الدخل';

  @override
  String get totalExpense => 'إجمالي النفقات';

  @override
  String get analysis => 'التحليل';

  @override
  String get transactions => 'المعاملات';

  @override
  String get noExpensesFound => 'لم يتم العثور على نفقات لهذه الفترة.';

  @override
  String get netBalance => 'صافي الرصيد';

  @override
  String get topCategories => 'أبرز الفئات';

  @override
  String get spendingTrend => 'اتجاه الإنفاق';

  @override
  String get insights => 'رؤى';

  @override
  String get noExpensesRecorded => 'لم يتم تسجيل أي نفقات';

  @override
  String get trackSpendingHabits => 'تتبع عادات الإنفاق الخاصة بك بسهولة.';

  @override
  String get addExpense => 'إضافة نفقة';

  @override
  String get noDataForPeriod => 'لا توجد بيانات لهذه الفترة';

  @override
  String get budget => 'الميزانية';

  @override
  String get spent => 'تم صرفه';

  @override
  String get limit => 'الحد';

  @override
  String get overBudget => 'تجاوز الميزانية!';

  @override
  String remainingBudget(Object percent) {
    return 'متبقي $percent%';
  }

  @override
  String get savingsRate => 'معدل الادخار';

  @override
  String get healthScore => 'درجة الصحة المالية';

  @override
  String get healthScoreExplanation =>
      'هذه الدرجة تعتمد على معدل ادخارك.\n\n• ادخار > 50% = ممتاز (100)\n• ادخار 0% = متوسط (50)\n• الإنفاق > الدخل = ضعيف (<50)';

  @override
  String get ok => 'موافق';

  @override
  String get bulkImport => 'استيراد بالجملة';
}

/// The translations for Arabic, as used in Oman (`ar_OM`).
class AppLocalizationsArOm extends AppLocalizationsAr {
  AppLocalizationsArOm() : super('ar_OM');

  @override
  String get settings => 'إعدادات';

  @override
  String get language => 'لغة';

  @override
  String get systemDefault => 'النظام الافتراضي';

  @override
  String get notes => 'ملحوظات';

  @override
  String get todos => 'المهام';

  @override
  String get expenses => 'نفقات';

  @override
  String get journal => 'مجلة';

  @override
  String get calendar => 'تقويم';

  @override
  String get clipboard => 'الحافظة';

  @override
  String get canvas => 'قماش';

  @override
  String get save => 'حفظ';

  @override
  String get create => 'إنشاء';

  @override
  String get cancel => 'إلغاء';

  @override
  String get delete => 'حذف';

  @override
  String get edit => 'تعديل';

  @override
  String get share => 'مشاركة';

  @override
  String get copy => 'نسخ';

  @override
  String get unsavedChanges => 'تغييرات غير محفوظة';

  @override
  String get confirmDelete => 'تأكيد الحذف';

  @override
  String get discard => 'تجاهل';

  @override
  String get createPost => 'إنشاء منشور';

  @override
  String get post => 'منشور';

  @override
  String get postingTo => 'النشر في';

  @override
  String get whatsOnYourMind => 'ماذا يدور في ذهنك؟';

  @override
  String get pickImages => 'اختر صورًا';

  @override
  String get pickVideo => 'اختر فيديو';

  @override
  String get camera => 'كاميرا';

  @override
  String get gallery => 'معرض الصور';

  @override
  String get search => 'بحث';

  @override
  String get pleaseEnterTask => 'يرجى إدخال مهمة';

  @override
  String get deleteTask => 'حذف المهمة';

  @override
  String get selectItems => 'حدد العناصر';

  @override
  String get deleteAll => 'حذف الكل';

  @override
  String error(Object error) {
    return 'خطأ: $error';
  }

  @override
  String get orderingOnlyAvailableInAllPosts =>
      'الترتيب متاح فقط في \"جميع المنشورات\"';

  @override
  String get deletePost => 'حذف المنشور';

  @override
  String get postDeleted => 'تم حذف المنشور';

  @override
  String get premiumFeatures => 'ميزات بريميوم';

  @override
  String get manageCoinsAdsPremium =>
      'إدارة العملات والإعلانات وحالة البريميوم';

  @override
  String get themeMode => 'وضع المظهر';

  @override
  String get accentColor => 'لون التمييز';

  @override
  String get backgroundDesign => 'تصميم الخلفية';

  @override
  String get pushNotifications => 'إشعارات الدفع';

  @override
  String get recycleBin => 'سلة المحذوفات';

  @override
  String get exportData => 'تصدير البيانات';

  @override
  String get importData => 'استيراد البيانات';

  @override
  String get rateApp => 'تقييم التطبيق';

  @override
  String get sendFeedback => 'إرسال تعليقات';

  @override
  String get privacyPolicy => 'سياسة الخصوصية';

  @override
  String get version => 'الإصدار';

  @override
  String get buildNumber => 'رقم البناء';

  @override
  String get system => 'النظام';

  @override
  String get light => 'فاتح';

  @override
  String get dark => 'داكن';

  @override
  String get itemRestored => 'تمت استعادة العنصر';

  @override
  String get recycleBinCleared => 'تم إفراغ سلة المحذوفات بنجاح';

  @override
  String get allPostsDeleted => 'تم حذف جميع المنشورات';

  @override
  String get newPost => 'منشور جديد';

  @override
  String get textCopiedToClipboardFacebook =>
      'Text copied to clipboard (Facebook policy)';

  @override
  String get tiktokSharingRequiresVideoImage =>
      'تتطلب مشاركة TikTok فيديو/صورة';

  @override
  String errorSharing(Object error) {
    return 'خطأ في المشاركة: $error';
  }

  @override
  String shareToStory(Object platform) {
    return 'مشاركة في قصة $platform';
  }

  @override
  String shareToFeed(Object platform) {
    return 'مشاركة في موجز $platform';
  }

  @override
  String get unlockPermanently => 'فتح بشكل دائم';

  @override
  String get notEnoughCoins => 'لا توجد عملات كافية!';

  @override
  String youEarnedCoins(Object amount) {
    return 'لقد ربحت $amount من العملات!';
  }

  @override
  String get contentCopied => 'تم نسخ المحتوى';

  @override
  String get selectDateTime => 'حدد التاريخ والوقت';

  @override
  String get areYouSureYouWantToDeleteThisPost =>
      'هل أنت متأكد أنك تريد حذف هذا المنشور؟';

  @override
  String get socialPosts => 'منشورات اجتماعية';

  @override
  String get watchAdToEarnCoins => 'شاهد إعلانًا لربح العملات';

  @override
  String get premiumUnlocked => 'تم فتح البريميوم';

  @override
  String get removeAds => 'إزالة الإعلانات';

  @override
  String get unlimitedCloudStorage => 'تخزين سحابي غير محدود';

  @override
  String get deleteNote => 'حذف الملاحظة';

  @override
  String get shareNote => 'مشاركة الملاحظة';

  @override
  String get editNote => 'تعديل الملاحظة';

  @override
  String get searchNotes => 'البحث في الملاحظات...';

  @override
  String get noNotesFound => 'لم يتم العثور على ملاحظات';

  @override
  String get captureThoughts => 'سجل أفكارك فورا.';

  @override
  String get createNote => 'إنشاء ملاحظة';

  @override
  String get customOrder => 'ترتيب مخصص';

  @override
  String get newestFirst => 'الأحدث أولاً';

  @override
  String get oldestFirst => 'الأقدم أولاً';

  @override
  String get titleAZ => 'العنوان: أ-ي';

  @override
  String get titleZA => 'العنوان: ي-أ';

  @override
  String get deleteAllQuestion => 'حذف الكل؟';

  @override
  String get moveToRecycleBin => 'نقل جميع الملاحظات إلى سلة المحذوفات؟';

  @override
  String get moveToBinQuestion => 'نقل إلى السلة؟';

  @override
  String get restoreNoteLater => 'يمكنك استعادة هذه الملاحظة لاحقًا.';

  @override
  String get move => 'نقل';

  @override
  String get myThoughts => 'أفكاري';

  @override
  String get selected => 'محدد';

  @override
  String get noContent => 'لا يوجد محتوى';

  @override
  String get untitled => 'بدون عنوان';

  @override
  String get chooseWallpapers => 'اختر من بين أكثر من 10 خلفيات ديناميكية';

  @override
  String get backupData => 'نسخ احتياطي للبيانات';

  @override
  String get saveJsonFile => 'هل تريد حفظ ملف JSON يحتوي على جميع بياناتك؟';

  @override
  String get exportNow => 'تصدير الآن';

  @override
  String get importDataTitle => 'استيراد البيانات';

  @override
  String get mergeBackupFile =>
      'هل تريد دمج ملف النسخ الاحتياطي مع العناصر الحالية؟';

  @override
  String get selectFile => 'حدد ملفاً';

  @override
  String get backupSaved => 'تم حفظ النسخة الاحتياطية بنجاح!';

  @override
  String get exportFailed => 'فشل التصدير.';

  @override
  String importSuccess(Object count) {
    return 'تمت استعادة $count من العناصر بنجاح!';
  }

  @override
  String get importFailed => 'فشل الاستيراد.';

  @override
  String widgetAdded(String widget) {
    return 'تمت إضافة الأداة $widget إلى الشاشة الرئيسية!';
  }

  @override
  String get widgetRequestSent =>
      'تم إرسال طلب الأداة. يرجى التحقق من الشاشة الرئيسية.';

  @override
  String get widgetAddFailed => 'فشل إضافة الأداة';

  @override
  String get autoSaveEnabled => 'تم تفعيل الحفظ التلقائي.';

  @override
  String get autoSaveDisabled => 'تم تعطيل الحفظ التلقائي.';

  @override
  String get homeScreenWidgets => 'أدوات الشاشة الرئيسية';

  @override
  String get notificationsTitle => 'الإشعارات';

  @override
  String get dataBackup => 'البيانات والنسخ الاحتياطي';

  @override
  String get feedbackSupport => 'التعليقات والدعم';

  @override
  String get creditsTitle => 'الاعتمادات';

  @override
  String get privacyMaintenance => 'الخصوصية والصيانة';

  @override
  String get aboutTitle => 'حول';

  @override
  String get premium => 'بريميوم';

  @override
  String get appearanceTitle => 'المظهر';

  @override
  String get clipboardTitle => 'الحافظة';

  @override
  String get settingsSubtitle => 'تخصيص تجربتك';

  @override
  String get welcomeTitle => 'مرحبًا بك في CopyClip';

  @override
  String get welcomeDescription =>
      'رفيقك النهائي للإنتاجية. دعنا نجهزك بأدوات قوية لإدارة يومك.';

  @override
  String get onboardingNotesTitle => 'ملاحظات ذكية';

  @override
  String get onboardingNotesDesc =>
      'التقط الأفكار فورًا بتنسيق نص غني. نظم أفكارك ولا تفقد أي فكرة رائعة مرة أخرى.';

  @override
  String get onboardingTodosTitle => 'إدارة المهام';

  @override
  String get onboardingTodosDesc =>
      'ابق مطلعاً على أمورك. أنشئ قوائم مهام، وحدد الأولويات، وحقق أهدافك خطوة بخطوة.';

  @override
  String get onboardingExpensesTitle => 'تتبع النفقات';

  @override
  String get onboardingExpensesDesc =>
      'تحكم في أموالك. تتبع الدخل والنفقات بسهولة لفهم عادات الإنفاق الخاصة بك.';

  @override
  String get onboardingJournalTitle => 'يوميات شخصية';

  @override
  String get onboardingJournalDesc =>
      'تأمل في يومك. مساحة خاصة لتدوين ذكرياتك ومشاعرك وتجاربك اليومية.';

  @override
  String get onboardingCalendarTitle => 'التقويم والأحداث';

  @override
  String get onboardingCalendarDesc =>
      'لا تفوت أي لحظة. نظم جدولك وتابع الأحداث الهامة القادمة.';

  @override
  String get onboardingClipboardTitle => 'مدير الحافظة';

  @override
  String get onboardingClipboardDesc =>
      'انسخ مرة واحدة، والصق في أي مكان. الوصول إلى سجل الحافظة لاستعادة النصوص التي نسختها سابقاً.';

  @override
  String get onboardingCanvasTitle => 'لوحة إبداعية';

  @override
  String get onboardingCanvasDesc =>
      'أطلق العنان لإبداعك. ارسم وخطط وصور أفكارك على لوحة رقمية حرة.';

  @override
  String get featuresNotesDesc => 'إنشاء وإدارة الملاحظات الخاصة بك';

  @override
  String get featuresTodosDesc => 'تتبع المهام الخاصة بك';

  @override
  String get featuresExpensesDesc => 'مراقبة النفقات الخاصة بك';

  @override
  String get featuresJournalDesc => 'اكتتب أفكارك';

  @override
  String get featuresCalendarDesc => 'نظم جدولك الزمني';

  @override
  String get featuresClipboardDesc => 'الوصول إلى سجل الحافظة الخاص بك';

  @override
  String get featuresCanvasDesc => 'ارسم وخطط بحرية';

  @override
  String get featuresSocialPost => 'منشور اجتماعي';

  @override
  String get featuresSocialPostDesc =>
      'إنشاء محتوى جذاب لوسائل التواصل الاجتماعي';

  @override
  String get chooseYourAura => 'اختر هالتك';

  @override
  String get expressYourselfTheme => 'عبر عن نفسك بلون مظهر جديد!';

  @override
  String get level => 'المستوى';

  @override
  String get xpToNextLevel => 'XP للمستوى التالي';

  @override
  String get checkUpcomingEvents => 'تحقق من الأحداث القادمة';

  @override
  String get startNewSketch => 'بدأ رسمة جديدة';

  @override
  String get noTransactionsMonth => 'لا توجد معاملات هذا الشهر';

  @override
  String transactionsThisMonth(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count معاملات هذا الشهر',
      few: '$count معاملات هذا الشهر',
      two: 'معاملتان هذا الشهر',
      one: 'معاملة واحدة هذا الشهر',
      zero: 'لا توجد معاملات هذا الشهر',
    );
    return '$_temp0';
  }

  @override
  String get autoSaveClipboard => 'حفظ تلقائي للحافظة';

  @override
  String get autoSaveClipboardDesc => 'حفظ العناصر المنسوخة تلقائياً';

  @override
  String get permissionDeniedSettings =>
      'تم رفض الإذن بشكل دائم. يرجى تفعيله من الإعدادات.';

  @override
  String get notificationsEnabled => 'تم تفعيل الإشعارات!';

  @override
  String get redirectingToSettings =>
      'جارٍ التوجيه إلى الإعدادات لتعطيل الإشعارات...';

  @override
  String get premiumAccess => 'وصول بريميوم';

  @override
  String get premiumActiveUntil => 'بريميوم نشط حتى';

  @override
  String get unlockAllFeatures => 'فتح جميع الميزات';

  @override
  String get buyPremium => 'شراء بريميوم (7 أيام)';

  @override
  String costCoins(Object cost) {
    return 'التكلفة: $cost عملات';
  }

  @override
  String get premiumActivated => 'تم تفعيل البريميوم لمدة 7 أيام!';

  @override
  String get premiumActive => 'البريميوم نشط';

  @override
  String get expires => 'تنتهي الصلاحية:';

  @override
  String get temporaryAccess => 'وصول مؤقت';

  @override
  String get journalExpression => 'يوميات وتعبير';

  @override
  String get artisticDesigns => 'تصاميم فنية';

  @override
  String get artisticDesignsDesc =>
      'فتح أكثر من 10 مظاهر فريدة لبطاقات اليوميات';

  @override
  String get premiumLayouts => 'تخطيطات بريميوم';

  @override
  String get premiumLayoutsDesc => 'طرق حصرية لعرض ذكرياتك';

  @override
  String get calendarTools => 'تقويم وأدوات';

  @override
  String get fullCalendar => 'تقويم كامل';

  @override
  String get fullCalendarDesc => 'نظام متكامل لإدارة الأحداث';

  @override
  String get clipboardAutoSaveDesc => 'التقاط سجل الحافظة في الخلفية';

  @override
  String get proWidgets => 'أدوات ذكية للمحترفين';

  @override
  String get proWidgetsDesc => 'جميع الميزات متوفرة على شاشتك الرئيسية';

  @override
  String get dataExport => 'البيانات والتصدير';

  @override
  String get advancedBackup => 'نسخ احتياطي متقدم';

  @override
  String get advancedBackupDesc => 'استيراد/تصدير آمن لجميع البيانات';

  @override
  String get pdfExport => 'تصدير إلى PDF';

  @override
  String get pdfExportDesc => 'تصدير الملاحظات واليوميات إلى PDF';

  @override
  String get printReady => 'جاهز للطباعة';

  @override
  String get printReadyDesc => 'دعم الطباعة المباشرة';

  @override
  String get richTextEditor => 'محرر نص غني';

  @override
  String get advancedSearch => 'بحث متقدم';

  @override
  String get advancedSearchDesc => 'البحث والاستبدال داخل النص';

  @override
  String get richMedia => 'وسائط غنية';

  @override
  String get richMediaDesc => 'إدراج صور وفيديوهات وروابط';

  @override
  String get editorStyling => 'تنسيق المحرر';

  @override
  String get editorStylingDesc => 'نص مخصص وخلفيات للمحرر';

  @override
  String get balance => 'الرصيد';

  @override
  String get loadingAd => 'جارٍ تحميل الإعلان...';

  @override
  String watchAd(Object amount) {
    return 'مشاهدة إعلان (+$amount)';
  }

  @override
  String get loadAd => 'تحميل إعلان';

  @override
  String get backupDataDesc => 'حفظ ملف JSON لبياناتك';

  @override
  String get importDataDesc => 'دمج ملف نسخة احتياطية في CopyClip';

  @override
  String get notificationPermissionDenied => 'تم رفض إذن الإشعارات.';

  @override
  String get typeNewTask => 'اكتب مهمة جديدة...';

  @override
  String get addTask => 'إضافة مهمة';

  @override
  String get completed => 'مكتمل';

  @override
  String get greatJob => 'عمل رائع!';

  @override
  String youEarnedXPNextTask(Object amount, Object date) {
    return 'لقد ربحت $amount XP! المهمة التالية: $date';
  }

  @override
  String taskCompletedXP(Object amount) {
    return 'تمت المهمة! +$amount XP';
  }

  @override
  String get moveTasksToRecycleBin =>
      'نقل جميع المهام النشطة إلى سلة المحذوفات؟';

  @override
  String get deleteAllPosts => 'حذف جميع المنشورات';

  @override
  String get deleteAllPostsConfirmation =>
      'هل أنت متأكد أنك تريد حذف جميع المنشورات الاجتماعية؟ لا يمكن التراجع عن هذا الإجراء.';

  @override
  String get allPosts => 'جميع المنشورات';

  @override
  String get favorites => 'المفضلة';

  @override
  String get drafts => 'المسودات';

  @override
  String get noFavoritesYet => 'لا توجد مفضلات بعد';

  @override
  String get noDraftsYet => 'لا توجد مسودات بعد';

  @override
  String get startSocialJourney => 'ابدأ رحلتك الاجتماعية!';

  @override
  String get draft => 'مسودة';

  @override
  String attachmentCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count مرفقات',
      few: '$count مرفقات',
      two: 'مرفقان',
      one: 'مرفق واحد',
      zero: 'لا توجد مرفقات',
    );
    return '$_temp0';
  }

  @override
  String get pleaseAddContent => 'يرجى إضافة بعض المحتوى أو الوسائط للمشاركة';

  @override
  String fileNotFoundError(Object path) {
    return 'خطأ: لم يتم العثور على الملف في $path';
  }

  @override
  String get checkFacebookApp => 'تحقق من تطبيق فيسبوك';

  @override
  String get systemShare => 'مشاركة النظام';

  @override
  String get socialPost => 'منشور اجتماعي';

  @override
  String get favorite => 'مفضل';

  @override
  String get saveDraft => 'حفظ المسودة';

  @override
  String get entryCopied => 'تم نسخ المدخل';

  @override
  String get moveEntriesToRecycleBin =>
      'نقل جميع المدخلات النشطة إلى سلة المحذوفات؟';

  @override
  String get startWritingStory => 'ابدأ بكتابة قصتك';

  @override
  String get recordMemories => 'سجل ذكرياتك ومشاعرك اليومية.';

  @override
  String get writeJournal => 'اكتب يومياتك';

  @override
  String get myMemories => 'ذكرياتي';

  @override
  String get sortJournal => 'فرز اليوميات';

  @override
  String get byMood => 'حسب المزاج';

  @override
  String get searchMemories => 'بحث في الذكريات...';

  @override
  String get selectAll => 'تحديد الكل';

  @override
  String get deleteSelected => 'حذف المحدد';

  @override
  String get taskCompletedExclamation => 'تمت المهمة!';

  @override
  String get taskUncompletedExclamation => 'مهمة غير مكتملة';

  @override
  String get clipboardUpdatedExclamation => 'تم تحديث الحافظة!';

  @override
  String clipboardSavedContent(Object content) {
    return 'تم حفظ في الحافظة: $content';
  }

  @override
  String get overview => 'نظرة عامة';

  @override
  String get colorAurora => 'أورورا';

  @override
  String get colorCosmic => 'كوني';

  @override
  String get colorNebula => 'سديم';

  @override
  String get colorStarlight => 'ضوء النجوم';

  @override
  String get colorSolar => 'شمسي';

  @override
  String get colorNova => 'نوفا';

  @override
  String get loadingStepLoading => 'جارٍ التحميل...';

  @override
  String get loadingStepDatabase => 'إعداد قاعدة البيانات...';

  @override
  String get loadingStepSystem => 'تكوين النظام...';

  @override
  String get loadingStepReady => 'جاهز';

  @override
  String get productivityCompanion => 'رفيقك للإنتاجية';

  @override
  String get done => 'تم';

  @override
  String get newNote => 'ملاحظة جديدة';

  @override
  String get changeColor => 'تغيير اللون';

  @override
  String get copyContent => 'نسخ المحتوى';

  @override
  String get titleOptional => 'العنوان (اختياري)';

  @override
  String get exportAsPdf => 'تصدير كـ PDF';

  @override
  String get taskDueNow => 'موعد المهمة الآن';

  @override
  String get moveTaskToBinTitle => 'نقل المهمة إلى سلة المحذوفات؟';

  @override
  String get restoreTaskLater =>
      'يمكنك استعادة هذه المهمة لاحقًا من الإعدادات.';

  @override
  String get newTask => 'مهمة جديدة';

  @override
  String get editTask => 'تعديل المهمة';

  @override
  String get undo => 'تراجع';

  @override
  String get redo => 'إعادة';

  @override
  String get category => 'الفئة';

  @override
  String get categoryHint => 'مثال: العمل، النادي';

  @override
  String get whatNeedsToBeDone => 'ما الذي يجب القيام به؟';

  @override
  String get enterTaskDetails => 'أدخل تفاصيل المهمة...';

  @override
  String get setDueDate => 'تحديد موعد الاستحقاق';

  @override
  String get dueDate => 'موعد الاستحقاق';

  @override
  String get expenseTitle => 'النفقات';

  @override
  String searchInCurrency(String currency) {
    return 'بحث في $currency...';
  }

  @override
  String get sortAndFilter => 'فرز وتصفية';

  @override
  String get sortBy => 'فرز حسب';

  @override
  String get highestAmount => 'أعلى مبلغ';

  @override
  String get lowestAmount => 'أقل مبلغ';

  @override
  String get moreFilters => 'مزيد من الفلاتر...';

  @override
  String get filterExpenses => 'تصفية النفقات';

  @override
  String get transactionType => 'نوع المعاملة';

  @override
  String get categories => 'الفئات';

  @override
  String get all => 'الكل';

  @override
  String get income => 'الدخل';

  @override
  String get expense => 'المصروفات';

  @override
  String get reset => 'إعادة تعيين';

  @override
  String get apply => 'تطبيق';

  @override
  String newExpense(String currency) {
    return 'جديد $currency';
  }

  @override
  String errorLoadingData(String error) {
    return 'حدث خطأ أثناء تحميل البيانات.\n\n$error';
  }

  @override
  String get dailyQuote1 => 'أفضل طريقة للتنبؤ بالمستقبل هي أن تصنعه.';

  @override
  String get dailyQuote2 => 'الغنى ليس في كثرة العرض، ولكن الغنى غنى النفس.';

  @override
  String get dailyQuote3 => 'الوقت هو العملة الأغلى.';

  @override
  String get dailyQuote4 => 'النجاح ليس نهائياً، والفشل ليس قاتلاً.';

  @override
  String get dailyQuote5 => 'ركز على الحل، وليس المشكلة.';

  @override
  String get dailyQuote6 => 'شبكة علاقاتك هي ثروتك الحقيقية.';

  @override
  String get moodHappy => 'سعيد';

  @override
  String get moodExcited => 'متحمس';

  @override
  String get moodNeutral => 'محايد';

  @override
  String get moodSad => 'حزين';

  @override
  String get moodStressed => 'متوتر';

  @override
  String exportDate(String date) {
    return '📅 $date';
  }

  @override
  String exportMood(String emoji, String mood) {
    return 'المزاج: $emoji $mood';
  }

  @override
  String exportTitle(String title) {
    return 'العنوان: $title';
  }

  @override
  String exportTags(String tags) {
    return '\nالوسوم: $tags';
  }

  @override
  String get instagram => 'إنستغرام';

  @override
  String get facebook => 'فيسبوك';

  @override
  String get tiktok => 'تيك توك';

  @override
  String get newSketch => 'رسمة جديدة';

  @override
  String get searchSketches => 'البحث في الرسومات والمجلدات...';

  @override
  String get noResultsFound => 'لم يتم العثور على نتائج';

  @override
  String get noItems => 'لا توجد عناصر';

  @override
  String get noDrawingsYet => 'لا توجد رسومات بعد';

  @override
  String get canvasIntro => 'أطلق العنان لإبداعك على اللوحة!';

  @override
  String get newCanvas => 'لوحة جديدة';

  @override
  String get rename => 'إعادة تسمية';

  @override
  String get deleteFolder => 'حذف المجلد';

  @override
  String get deleteSketchesQuestion => 'حذف الرسومات؟';

  @override
  String get deleteFolderConfirmation =>
      'سيتم حذف جميع الرسومات في هذا المجلد نهائياً.';

  @override
  String get renameFolder => 'إعادة تسمية المجلد';

  @override
  String get chooseColor => 'اختر لوناً';

  @override
  String get deleteFolderQuestion => 'حذف المجلد؟';

  @override
  String get searchClips => 'البحث في القصاصات...';

  @override
  String get clipboardEmpty => 'الحافظة فارغة';

  @override
  String get addItem => 'إضافة عنصر';

  @override
  String get clipColor => 'لون القصاصة';

  @override
  String get newClip => 'قصاصة جديدة';

  @override
  String get editClip => 'تعديل القصاصة';

  @override
  String get restoreClipLater => 'يمكنك استعادة هذه القصاصة لاحقاً.';

  @override
  String get upcomingEvents => 'الأحداث القادمة';

  @override
  String get dataDistribution => 'توزيع البيانات';

  @override
  String get taskProgress => 'تقدم المهمة';

  @override
  String get quickStats => 'إحصائيات سريعة';

  @override
  String get taskCompletion => 'إكمال المهمة';

  @override
  String get noItemsForDate => 'لا توجد عناصر لهذا التاريخ';

  @override
  String get enjoyFreeTime => 'استمتع بوقت فراغك!';

  @override
  String get searchThisDay => 'البحث في هذا اليوم...';

  @override
  String get finance => 'المالية';

  @override
  String get permanentlyDelete => 'حذف نهائي؟';

  @override
  String deleteSelectionConfirmation(int foldersCount, int sketchesCount) {
    return 'سيؤدي هذا إلى حذف $foldersCount مجلدات (ورسماتها) و $sketchesCount رسومات أخرى نهائياً.\n\nلا يمكن التراجع عن هذا الإجراء.';
  }

  @override
  String get deleteForever => 'حذف للأبد';

  @override
  String selectedCount(int count) {
    return '$count محدد';
  }

  @override
  String canvasStats(int notes, int folders) {
    return '$notes رسومات • $folders مجلدات';
  }

  @override
  String get sortItems => 'فرز العناصر';

  @override
  String get sortNameAZ => 'الاسم (أ-ي)';

  @override
  String get sortNameZA => 'الاسم (ي-أ)';

  @override
  String get createFolder => 'إنشاء مجلد';

  @override
  String get folderNameHint => 'اسم المجلد...';

  @override
  String deleteSketchesConfirmation(int count) {
    return 'حذف $count رسومات؟ لا يمكن التراجع عن هذا الإجراء.';
  }

  @override
  String get noSketchesFound => 'لم يتم العثور على رسومات';

  @override
  String get noSketchesFoundSub => 'حاول تعديل بحثك أو إنشاء رسمة جديدة.';

  @override
  String searchInFolder(String folder) {
    return 'بحث في $folder...';
  }

  @override
  String sketchesCount(int count) {
    return '$count رسومات';
  }

  @override
  String get sortSketches => 'فرز الرسومات';

  @override
  String get calendarScreenTitle => 'التقويم';

  @override
  String get dailyActivity => 'النشاط اليومي';

  @override
  String get deleteItemQuestion => 'حذف العنصر؟';

  @override
  String get deleteItemConfirmation =>
      'سيؤدي هذا إلى نقل العنصر إلى سلة المحذوفات.';

  @override
  String get moveToBinItem => 'نقل إلى السلة؟';

  @override
  String get moveToBinConfirmation => 'يمكنك استعادته لاحقاً.';

  @override
  String selectedItems(int count) {
    return '$count محدد';
  }

  @override
  String get recentClips => 'القصاصات الأخيرة';

  @override
  String get copied => 'تم النسخ!';

  @override
  String get copiedPlainText => 'تم نسخ النص المجرد';

  @override
  String get clipTheme => 'مظهر القصاصة';

  @override
  String get justNow => 'الآن';

  @override
  String minutesAgo(Object count) {
    return 'منذ $count د';
  }

  @override
  String hoursAgo(Object count) {
    return 'منذ $count س';
  }

  @override
  String daysAgo(Object count) {
    return 'منذ $count ي';
  }

  @override
  String get noTasksFound => 'لم يتم العثور على مهام.';

  @override
  String get searchTasks => 'بحث في المهام...';

  @override
  String get taskReminder => 'تذكير بالمهمة';

  @override
  String get untitledNote => 'ملاحظة بدون عنوان';

  @override
  String get dailyEntry => 'مدخل يومي';

  @override
  String get clipboardHistory => 'سجل الحافظة';

  @override
  String get deletePermanentlyContent => 'هذا الإجراء لا يمكن التراجع عنه.';

  @override
  String get emptyRecycleBinTitle => 'إفراغ سلة المحذوفات؟';

  @override
  String emptyRecycleBinContent(Object count) {
    return 'سيتم حذف جميع العناصر الـ $count نهائياً.';
  }

  @override
  String get emptyBin => 'إفراغ السلة';

  @override
  String get recycleBinEmpty => 'سلة المحذوفات فارغة';

  @override
  String get deletedItemsAppearHere => 'العناصر المحذوفة ستظهر هنا.';

  @override
  String get empty => 'فارغ';

  @override
  String get recent => 'الأخيرة';

  @override
  String categoryLabel(Object category) {
    return 'الفئة: $category';
  }

  @override
  String get general => 'عام';

  @override
  String get saveTransactionQuestion => 'هل تريد حفظ هذه المعاملة؟';

  @override
  String get fillTitleAmount => 'يرجى ملء العنوان والمبلغ';

  @override
  String get invalidAmount => 'تنسيق المبلغ غير صالح';

  @override
  String get moveTransactionToBinTitle => 'نقل المعاملة إلى سلة المحذوفات؟';

  @override
  String get restoreTransactionLater =>
      'يمكنك استعادة هذه المعاملة لاحقاً من الإعدادات.';

  @override
  String get newTransaction => 'معاملة جديدة';

  @override
  String get whatIsThisFor => 'فيما هذا؟';

  @override
  String get description => 'الوصف';

  @override
  String get daily => 'يومياً';

  @override
  String get weekly => 'أسبوعياً';

  @override
  String get monthly => 'شهرياً';

  @override
  String get yearly => 'سنوياً';

  @override
  String get totalIncome => 'إجمالي الدخل';

  @override
  String get totalExpense => 'إجمالي النفقات';

  @override
  String get analysis => 'التحليل';

  @override
  String get transactions => 'المعاملات';

  @override
  String get noExpensesFound => 'لم يتم العثور على نفقات لهذه الفترة.';

  @override
  String get netBalance => 'صافي الرصيد';

  @override
  String get topCategories => 'أبرز الفئات';

  @override
  String get spendingTrend => 'اتجاه الإنفاق';

  @override
  String get insights => 'رؤى';

  @override
  String get noExpensesRecorded => 'لم يتم تسجيل أي نفقات';

  @override
  String get trackSpendingHabits => 'تتبع عادات الإنفاق الخاصة بك بسهولة.';

  @override
  String get addExpense => 'إضافة نفقة';

  @override
  String get noDataForPeriod => 'لا توجد بيانات لهذه الفترة';

  @override
  String get budget => 'الميزانية';

  @override
  String get spent => 'تم صرفه';

  @override
  String get limit => 'الحد';

  @override
  String get overBudget => 'تجاوز الميزانية!';

  @override
  String remainingBudget(Object percent) {
    return 'متبقي $percent%';
  }

  @override
  String get savingsRate => 'معدل الادخار';

  @override
  String get healthScore => 'درجة الصحة المالية';

  @override
  String get healthScoreExplanation =>
      'هذه الدرجة تعتمد على معدل ادخارك.\n\n• ادخار > 50% = ممتاز (100)\n• ادخار 0% = متوسط (50)\n• الإنفاق > الدخل = ضعيف (<50)';

  @override
  String get ok => 'موافق';

  @override
  String get bulkImport => 'استيراد بالجملة';
}

/// The translations for Arabic, as used in Qatar (`ar_QA`).
class AppLocalizationsArQa extends AppLocalizationsAr {
  AppLocalizationsArQa() : super('ar_QA');

  @override
  String get settings => 'إعدادات';

  @override
  String get language => 'لغة';

  @override
  String get systemDefault => 'النظام الافتراضي';

  @override
  String get notes => 'ملحوظات';

  @override
  String get todos => 'المهام';

  @override
  String get expenses => 'نفقات';

  @override
  String get journal => 'مجلة';

  @override
  String get calendar => 'تقويم';

  @override
  String get clipboard => 'الحافظة';

  @override
  String get canvas => 'قماش';

  @override
  String get save => 'حفظ';

  @override
  String get create => 'إنشاء';

  @override
  String get cancel => 'إلغاء';

  @override
  String get delete => 'حذف';

  @override
  String get edit => 'تعديل';

  @override
  String get share => 'مشاركة';

  @override
  String get copy => 'نسخ';

  @override
  String get unsavedChanges => 'تغييرات غير محفوظة';

  @override
  String get confirmDelete => 'تأكيد الحذف';

  @override
  String get discard => 'تجاهل';

  @override
  String get createPost => 'إنشاء منشور';

  @override
  String get post => 'منشور';

  @override
  String get postingTo => 'النشر في';

  @override
  String get whatsOnYourMind => 'ماذا يدور في ذهنك؟';

  @override
  String get pickImages => 'اختر صورًا';

  @override
  String get pickVideo => 'اختر فيديو';

  @override
  String get camera => 'كاميرا';

  @override
  String get gallery => 'معرض الصور';

  @override
  String get search => 'بحث';

  @override
  String get pleaseEnterTask => 'يرجى إدخال مهمة';

  @override
  String get deleteTask => 'حذف المهمة';

  @override
  String get selectItems => 'حدد العناصر';

  @override
  String get deleteAll => 'حذف الكل';

  @override
  String error(Object error) {
    return 'خطأ: $error';
  }

  @override
  String get orderingOnlyAvailableInAllPosts =>
      'الترتيب متاح فقط في \"جميع المنشورات\"';

  @override
  String get deletePost => 'حذف المنشور';

  @override
  String get postDeleted => 'تم حذف المنشور';

  @override
  String get premiumFeatures => 'ميزات بريميوم';

  @override
  String get manageCoinsAdsPremium =>
      'إدارة العملات والإعلانات وحالة البريميوم';

  @override
  String get themeMode => 'وضع المظهر';

  @override
  String get accentColor => 'لون التمييز';

  @override
  String get backgroundDesign => 'تصميم الخلفية';

  @override
  String get pushNotifications => 'إشعارات الدفع';

  @override
  String get recycleBin => 'سلة المحذوفات';

  @override
  String get exportData => 'تصدير البيانات';

  @override
  String get importData => 'استيراد البيانات';

  @override
  String get rateApp => 'تقييم التطبيق';

  @override
  String get sendFeedback => 'إرسال تعليقات';

  @override
  String get privacyPolicy => 'سياسة الخصوصية';

  @override
  String get version => 'الإصدار';

  @override
  String get buildNumber => 'رقم البناء';

  @override
  String get system => 'النظام';

  @override
  String get light => 'فاتح';

  @override
  String get dark => 'داكن';

  @override
  String get itemRestored => 'تمت استعادة العنصر';

  @override
  String get recycleBinCleared => 'تم إفراغ سلة المحذوفات بنجاح';

  @override
  String get allPostsDeleted => 'تم حذف جميع المنشورات';

  @override
  String get newPost => 'منشور جديد';

  @override
  String get textCopiedToClipboardFacebook =>
      'Text copied to clipboard (Facebook policy)';

  @override
  String get tiktokSharingRequiresVideoImage =>
      'تتطلب مشاركة TikTok فيديو/صورة';

  @override
  String errorSharing(Object error) {
    return 'خطأ في المشاركة: $error';
  }

  @override
  String shareToStory(Object platform) {
    return 'مشاركة في قصة $platform';
  }

  @override
  String shareToFeed(Object platform) {
    return 'مشاركة في موجز $platform';
  }

  @override
  String get unlockPermanently => 'فتح بشكل دائم';

  @override
  String get notEnoughCoins => 'لا توجد عملات كافية!';

  @override
  String youEarnedCoins(Object amount) {
    return 'لقد ربحت $amount من العملات!';
  }

  @override
  String get contentCopied => 'تم نسخ المحتوى';

  @override
  String get selectDateTime => 'حدد التاريخ والوقت';

  @override
  String get areYouSureYouWantToDeleteThisPost =>
      'هل أنت متأكد أنك تريد حذف هذا المنشور؟';

  @override
  String get socialPosts => 'منشورات اجتماعية';

  @override
  String get watchAdToEarnCoins => 'شاهد إعلانًا لربح العملات';

  @override
  String get premiumUnlocked => 'تم فتح البريميوم';

  @override
  String get removeAds => 'إزالة الإعلانات';

  @override
  String get unlimitedCloudStorage => 'تخزين سحابي غير محدود';

  @override
  String get deleteNote => 'حذف الملاحظة';

  @override
  String get shareNote => 'مشاركة الملاحظة';

  @override
  String get editNote => 'تعديل الملاحظة';

  @override
  String get searchNotes => 'البحث في الملاحظات...';

  @override
  String get noNotesFound => 'لم يتم العثور على ملاحظات';

  @override
  String get captureThoughts => 'سجل أفكارك فورا.';

  @override
  String get createNote => 'إنشاء ملاحظة';

  @override
  String get customOrder => 'ترتيب مخصص';

  @override
  String get newestFirst => 'الأحدث أولاً';

  @override
  String get oldestFirst => 'الأقدم أولاً';

  @override
  String get titleAZ => 'العنوان: أ-ي';

  @override
  String get titleZA => 'العنوان: ي-أ';

  @override
  String get deleteAllQuestion => 'حذف الكل؟';

  @override
  String get moveToRecycleBin => 'نقل جميع الملاحظات إلى سلة المحذوفات؟';

  @override
  String get moveToBinQuestion => 'نقل إلى السلة؟';

  @override
  String get restoreNoteLater => 'يمكنك استعادة هذه الملاحظة لاحقًا.';

  @override
  String get move => 'نقل';

  @override
  String get myThoughts => 'أفكاري';

  @override
  String get selected => 'محدد';

  @override
  String get noContent => 'لا يوجد محتوى';

  @override
  String get untitled => 'بدون عنوان';

  @override
  String get chooseWallpapers => 'اختر من بين أكثر من 10 خلفيات ديناميكية';

  @override
  String get backupData => 'نسخ احتياطي للبيانات';

  @override
  String get saveJsonFile => 'هل تريد حفظ ملف JSON يحتوي على جميع بياناتك؟';

  @override
  String get exportNow => 'تصدير الآن';

  @override
  String get importDataTitle => 'استيراد البيانات';

  @override
  String get mergeBackupFile =>
      'هل تريد دمج ملف النسخ الاحتياطي مع العناصر الحالية؟';

  @override
  String get selectFile => 'حدد ملفاً';

  @override
  String get backupSaved => 'تم حفظ النسخة الاحتياطية بنجاح!';

  @override
  String get exportFailed => 'فشل التصدير.';

  @override
  String importSuccess(Object count) {
    return 'تمت استعادة $count من العناصر بنجاح!';
  }

  @override
  String get importFailed => 'فشل الاستيراد.';

  @override
  String widgetAdded(String widget) {
    return 'تمت إضافة الأداة $widget إلى الشاشة الرئيسية!';
  }

  @override
  String get widgetRequestSent =>
      'تم إرسال طلب الأداة. يرجى التحقق من الشاشة الرئيسية.';

  @override
  String get widgetAddFailed => 'فشل إضافة الأداة';

  @override
  String get autoSaveEnabled => 'تم تفعيل الحفظ التلقائي.';

  @override
  String get autoSaveDisabled => 'تم تعطيل الحفظ التلقائي.';

  @override
  String get homeScreenWidgets => 'أدوات الشاشة الرئيسية';

  @override
  String get notificationsTitle => 'الإشعارات';

  @override
  String get dataBackup => 'البيانات والنسخ الاحتياطي';

  @override
  String get feedbackSupport => 'التعليقات والدعم';

  @override
  String get creditsTitle => 'الاعتمادات';

  @override
  String get privacyMaintenance => 'الخصوصية والصيانة';

  @override
  String get aboutTitle => 'حول';

  @override
  String get premium => 'بريميوم';

  @override
  String get appearanceTitle => 'المظهر';

  @override
  String get clipboardTitle => 'الحافظة';

  @override
  String get settingsSubtitle => 'تخصيص تجربتك';

  @override
  String get welcomeTitle => 'مرحبًا بك في CopyClip';

  @override
  String get welcomeDescription =>
      'رفيقك النهائي للإنتاجية. دعنا نجهزك بأدوات قوية لإدارة يومك.';

  @override
  String get onboardingNotesTitle => 'ملاحظات ذكية';

  @override
  String get onboardingNotesDesc =>
      'التقط الأفكار فورًا بتنسيق نص غني. نظم أفكارك ولا تفقد أي فكرة رائعة مرة أخرى.';

  @override
  String get onboardingTodosTitle => 'إدارة المهام';

  @override
  String get onboardingTodosDesc =>
      'ابق مطلعاً على أمورك. أنشئ قوائم مهام، وحدد الأولويات، وحقق أهدافك خطوة بخطوة.';

  @override
  String get onboardingExpensesTitle => 'تتبع النفقات';

  @override
  String get onboardingExpensesDesc =>
      'تحكم في أموالك. تتبع الدخل والنفقات بسهولة لفهم عادات الإنفاق الخاصة بك.';

  @override
  String get onboardingJournalTitle => 'يوميات شخصية';

  @override
  String get onboardingJournalDesc =>
      'تأمل في يومك. مساحة خاصة لتدوين ذكرياتك ومشاعرك وتجاربك اليومية.';

  @override
  String get onboardingCalendarTitle => 'التقويم والأحداث';

  @override
  String get onboardingCalendarDesc =>
      'لا تفوت أي لحظة. نظم جدولك وتابع الأحداث الهامة القادمة.';

  @override
  String get onboardingClipboardTitle => 'مدير الحافظة';

  @override
  String get onboardingClipboardDesc =>
      'انسخ مرة واحدة، والصق في أي مكان. الوصول إلى سجل الحافظة لاستعادة النصوص التي نسختها سابقاً.';

  @override
  String get onboardingCanvasTitle => 'لوحة إبداعية';

  @override
  String get onboardingCanvasDesc =>
      'أطلق العنان لإبداعك. ارسم وخطط وصور أفكارك على لوحة رقمية حرة.';

  @override
  String get featuresNotesDesc => 'إنشاء وإدارة الملاحظات الخاصة بك';

  @override
  String get featuresTodosDesc => 'تتبع المهام الخاصة بك';

  @override
  String get featuresExpensesDesc => 'مراقبة النفقات الخاصة بك';

  @override
  String get featuresJournalDesc => 'اكتتب أفكارك';

  @override
  String get featuresCalendarDesc => 'نظم جدولك الزمني';

  @override
  String get featuresClipboardDesc => 'الوصول إلى سجل الحافظة الخاص بك';

  @override
  String get featuresCanvasDesc => 'ارسم وخطط بحرية';

  @override
  String get featuresSocialPost => 'منشور اجتماعي';

  @override
  String get featuresSocialPostDesc =>
      'إنشاء محتوى جذاب لوسائل التواصل الاجتماعي';

  @override
  String get chooseYourAura => 'اختر هالتك';

  @override
  String get expressYourselfTheme => 'عبر عن نفسك بلون مظهر جديد!';

  @override
  String get level => 'المستوى';

  @override
  String get xpToNextLevel => 'XP للمستوى التالي';

  @override
  String get checkUpcomingEvents => 'تحقق من الأحداث القادمة';

  @override
  String get startNewSketch => 'بدأ رسمة جديدة';

  @override
  String get noTransactionsMonth => 'لا توجد معاملات هذا الشهر';

  @override
  String transactionsThisMonth(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count معاملات هذا الشهر',
      few: '$count معاملات هذا الشهر',
      two: 'معاملتان هذا الشهر',
      one: 'معاملة واحدة هذا الشهر',
      zero: 'لا توجد معاملات هذا الشهر',
    );
    return '$_temp0';
  }

  @override
  String get autoSaveClipboard => 'حفظ تلقائي للحافظة';

  @override
  String get autoSaveClipboardDesc => 'حفظ العناصر المنسوخة تلقائياً';

  @override
  String get permissionDeniedSettings =>
      'تم رفض الإذن بشكل دائم. يرجى تفعيله من الإعدادات.';

  @override
  String get notificationsEnabled => 'تم تفعيل الإشعارات!';

  @override
  String get redirectingToSettings =>
      'جارٍ التوجيه إلى الإعدادات لتعطيل الإشعارات...';

  @override
  String get premiumAccess => 'وصول بريميوم';

  @override
  String get premiumActiveUntil => 'بريميوم نشط حتى';

  @override
  String get unlockAllFeatures => 'فتح جميع الميزات';

  @override
  String get buyPremium => 'شراء بريميوم (7 أيام)';

  @override
  String costCoins(Object cost) {
    return 'التكلفة: $cost عملات';
  }

  @override
  String get premiumActivated => 'تم تفعيل البريميوم لمدة 7 أيام!';

  @override
  String get premiumActive => 'البريميوم نشط';

  @override
  String get expires => 'تنتهي الصلاحية:';

  @override
  String get temporaryAccess => 'وصول مؤقت';

  @override
  String get journalExpression => 'يوميات وتعبير';

  @override
  String get artisticDesigns => 'تصاميم فنية';

  @override
  String get artisticDesignsDesc =>
      'فتح أكثر من 10 مظاهر فريدة لبطاقات اليوميات';

  @override
  String get premiumLayouts => 'تخطيطات بريميوم';

  @override
  String get premiumLayoutsDesc => 'طرق حصرية لعرض ذكرياتك';

  @override
  String get calendarTools => 'تقويم وأدوات';

  @override
  String get fullCalendar => 'تقويم كامل';

  @override
  String get fullCalendarDesc => 'نظام متكامل لإدارة الأحداث';

  @override
  String get clipboardAutoSaveDesc => 'التقاط سجل الحافظة في الخلفية';

  @override
  String get proWidgets => 'أدوات ذكية للمحترفين';

  @override
  String get proWidgetsDesc => 'جميع الميزات متوفرة على شاشتك الرئيسية';

  @override
  String get dataExport => 'البيانات والتصدير';

  @override
  String get advancedBackup => 'نسخ احتياطي متقدم';

  @override
  String get advancedBackupDesc => 'استيراد/تصدير آمن لجميع البيانات';

  @override
  String get pdfExport => 'تصدير إلى PDF';

  @override
  String get pdfExportDesc => 'تصدير الملاحظات واليوميات إلى PDF';

  @override
  String get printReady => 'جاهز للطباعة';

  @override
  String get printReadyDesc => 'دعم الطباعة المباشرة';

  @override
  String get richTextEditor => 'محرر نص غني';

  @override
  String get advancedSearch => 'بحث متقدم';

  @override
  String get advancedSearchDesc => 'البحث والاستبدال داخل النص';

  @override
  String get richMedia => 'وسائط غنية';

  @override
  String get richMediaDesc => 'إدراج صور وفيديوهات وروابط';

  @override
  String get editorStyling => 'تنسيق المحرر';

  @override
  String get editorStylingDesc => 'نص مخصص وخلفيات للمحرر';

  @override
  String get balance => 'الرصيد';

  @override
  String get loadingAd => 'جارٍ تحميل الإعلان...';

  @override
  String watchAd(Object amount) {
    return 'مشاهدة إعلان (+$amount)';
  }

  @override
  String get loadAd => 'تحميل إعلان';

  @override
  String get backupDataDesc => 'حفظ ملف JSON لبياناتك';

  @override
  String get importDataDesc => 'دمج ملف نسخة احتياطية في CopyClip';

  @override
  String get notificationPermissionDenied => 'تم رفض إذن الإشعارات.';

  @override
  String get typeNewTask => 'اكتب مهمة جديدة...';

  @override
  String get addTask => 'إضافة مهمة';

  @override
  String get completed => 'مكتمل';

  @override
  String get greatJob => 'عمل رائع!';

  @override
  String youEarnedXPNextTask(Object amount, Object date) {
    return 'لقد ربحت $amount XP! المهمة التالية: $date';
  }

  @override
  String taskCompletedXP(Object amount) {
    return 'تمت المهمة! +$amount XP';
  }

  @override
  String get moveTasksToRecycleBin =>
      'نقل جميع المهام النشطة إلى سلة المحذوفات؟';

  @override
  String get deleteAllPosts => 'حذف جميع المنشورات';

  @override
  String get deleteAllPostsConfirmation =>
      'هل أنت متأكد أنك تريد حذف جميع المنشورات الاجتماعية؟ لا يمكن التراجع عن هذا الإجراء.';

  @override
  String get allPosts => 'جميع المنشورات';

  @override
  String get favorites => 'المفضلة';

  @override
  String get drafts => 'المسودات';

  @override
  String get noFavoritesYet => 'لا توجد مفضلات بعد';

  @override
  String get noDraftsYet => 'لا توجد مسودات بعد';

  @override
  String get startSocialJourney => 'ابدأ رحلتك الاجتماعية!';

  @override
  String get draft => 'مسودة';

  @override
  String attachmentCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count مرفقات',
      few: '$count مرفقات',
      two: 'مرفقان',
      one: 'مرفق واحد',
      zero: 'لا توجد مرفقات',
    );
    return '$_temp0';
  }

  @override
  String get pleaseAddContent => 'يرجى إضافة بعض المحتوى أو الوسائط للمشاركة';

  @override
  String fileNotFoundError(Object path) {
    return 'خطأ: لم يتم العثور على الملف في $path';
  }

  @override
  String get checkFacebookApp => 'تحقق من تطبيق فيسبوك';

  @override
  String get systemShare => 'مشاركة النظام';

  @override
  String get socialPost => 'منشور اجتماعي';

  @override
  String get favorite => 'مفضل';

  @override
  String get saveDraft => 'حفظ المسودة';

  @override
  String get entryCopied => 'تم نسخ المدخل';

  @override
  String get moveEntriesToRecycleBin =>
      'نقل جميع المدخلات النشطة إلى سلة المحذوفات؟';

  @override
  String get startWritingStory => 'ابدأ بكتابة قصتك';

  @override
  String get recordMemories => 'سجل ذكرياتك ومشاعرك اليومية.';

  @override
  String get writeJournal => 'اكتب يومياتك';

  @override
  String get myMemories => 'ذكرياتي';

  @override
  String get sortJournal => 'فرز اليوميات';

  @override
  String get byMood => 'حسب المزاج';

  @override
  String get searchMemories => 'بحث في الذكريات...';

  @override
  String get selectAll => 'تحديد الكل';

  @override
  String get deleteSelected => 'حذف المحدد';

  @override
  String get taskCompletedExclamation => 'تمت المهمة!';

  @override
  String get taskUncompletedExclamation => 'مهمة غير مكتملة';

  @override
  String get clipboardUpdatedExclamation => 'تم تحديث الحافظة!';

  @override
  String clipboardSavedContent(Object content) {
    return 'تم حفظ في الحافظة: $content';
  }

  @override
  String get overview => 'نظرة عامة';

  @override
  String get colorAurora => 'أورورا';

  @override
  String get colorCosmic => 'كوني';

  @override
  String get colorNebula => 'سديم';

  @override
  String get colorStarlight => 'ضوء النجوم';

  @override
  String get colorSolar => 'شمسي';

  @override
  String get colorNova => 'نوفا';

  @override
  String get loadingStepLoading => 'جارٍ التحميل...';

  @override
  String get loadingStepDatabase => 'إعداد قاعدة البيانات...';

  @override
  String get loadingStepSystem => 'تكوين النظام...';

  @override
  String get loadingStepReady => 'جاهز';

  @override
  String get productivityCompanion => 'رفيقك للإنتاجية';

  @override
  String get done => 'تم';

  @override
  String get newNote => 'ملاحظة جديدة';

  @override
  String get changeColor => 'تغيير اللون';

  @override
  String get copyContent => 'نسخ المحتوى';

  @override
  String get titleOptional => 'العنوان (اختياري)';

  @override
  String get exportAsPdf => 'تصدير كـ PDF';

  @override
  String get taskDueNow => 'موعد المهمة الآن';

  @override
  String get moveTaskToBinTitle => 'نقل المهمة إلى سلة المحذوفات؟';

  @override
  String get restoreTaskLater =>
      'يمكنك استعادة هذه المهمة لاحقًا من الإعدادات.';

  @override
  String get newTask => 'مهمة جديدة';

  @override
  String get editTask => 'تعديل المهمة';

  @override
  String get undo => 'تراجع';

  @override
  String get redo => 'إعادة';

  @override
  String get category => 'الفئة';

  @override
  String get categoryHint => 'مثال: العمل، النادي';

  @override
  String get whatNeedsToBeDone => 'ما الذي يجب القيام به؟';

  @override
  String get enterTaskDetails => 'أدخل تفاصيل المهمة...';

  @override
  String get setDueDate => 'تحديد موعد الاستحقاق';

  @override
  String get dueDate => 'موعد الاستحقاق';

  @override
  String get expenseTitle => 'النفقات';

  @override
  String searchInCurrency(String currency) {
    return 'بحث في $currency...';
  }

  @override
  String get sortAndFilter => 'فرز وتصفية';

  @override
  String get sortBy => 'فرز حسب';

  @override
  String get highestAmount => 'أعلى مبلغ';

  @override
  String get lowestAmount => 'أقل مبلغ';

  @override
  String get moreFilters => 'مزيد من الفلاتر...';

  @override
  String get filterExpenses => 'تصفية النفقات';

  @override
  String get transactionType => 'نوع المعاملة';

  @override
  String get categories => 'الفئات';

  @override
  String get all => 'الكل';

  @override
  String get income => 'الدخل';

  @override
  String get expense => 'المصروفات';

  @override
  String get reset => 'إعادة تعيين';

  @override
  String get apply => 'تطبيق';

  @override
  String newExpense(String currency) {
    return 'جديد $currency';
  }

  @override
  String errorLoadingData(String error) {
    return 'حدث خطأ أثناء تحميل البيانات.\n\n$error';
  }

  @override
  String get dailyQuote1 => 'أفضل طريقة للتنبؤ بالمستقبل هي أن تصنعه.';

  @override
  String get dailyQuote2 => 'الغنى ليس في كثرة العرض، ولكن الغنى غنى النفس.';

  @override
  String get dailyQuote3 => 'الوقت هو العملة الأغلى.';

  @override
  String get dailyQuote4 => 'النجاح ليس نهائياً، والفشل ليس قاتلاً.';

  @override
  String get dailyQuote5 => 'ركز على الحل، وليس المشكلة.';

  @override
  String get dailyQuote6 => 'شبكة علاقاتك هي ثروتك الحقيقية.';

  @override
  String get moodHappy => 'سعيد';

  @override
  String get moodExcited => 'متحمس';

  @override
  String get moodNeutral => 'محايد';

  @override
  String get moodSad => 'حزين';

  @override
  String get moodStressed => 'متوتر';

  @override
  String exportDate(String date) {
    return '📅 $date';
  }

  @override
  String exportMood(String emoji, String mood) {
    return 'المزاج: $emoji $mood';
  }

  @override
  String exportTitle(String title) {
    return 'العنوان: $title';
  }

  @override
  String exportTags(String tags) {
    return '\nالوسوم: $tags';
  }

  @override
  String get instagram => 'إنستغرام';

  @override
  String get facebook => 'فيسبوك';

  @override
  String get tiktok => 'تيك توك';

  @override
  String get newSketch => 'رسمة جديدة';

  @override
  String get searchSketches => 'البحث في الرسومات والمجلدات...';

  @override
  String get noResultsFound => 'لم يتم العثور على نتائج';

  @override
  String get noItems => 'لا توجد عناصر';

  @override
  String get noDrawingsYet => 'لا توجد رسومات بعد';

  @override
  String get canvasIntro => 'أطلق العنان لإبداعك على اللوحة!';

  @override
  String get newCanvas => 'لوحة جديدة';

  @override
  String get rename => 'إعادة تسمية';

  @override
  String get deleteFolder => 'حذف المجلد';

  @override
  String get deleteSketchesQuestion => 'حذف الرسومات؟';

  @override
  String get deleteFolderConfirmation =>
      'سيتم حذف جميع الرسومات في هذا المجلد نهائياً.';

  @override
  String get renameFolder => 'إعادة تسمية المجلد';

  @override
  String get chooseColor => 'اختر لوناً';

  @override
  String get deleteFolderQuestion => 'حذف المجلد؟';

  @override
  String get searchClips => 'البحث في القصاصات...';

  @override
  String get clipboardEmpty => 'الحافظة فارغة';

  @override
  String get addItem => 'إضافة عنصر';

  @override
  String get clipColor => 'لون القصاصة';

  @override
  String get newClip => 'قصاصة جديدة';

  @override
  String get editClip => 'تعديل القصاصة';

  @override
  String get restoreClipLater => 'يمكنك استعادة هذه القصاصة لاحقاً.';

  @override
  String get upcomingEvents => 'الأحداث القادمة';

  @override
  String get dataDistribution => 'توزيع البيانات';

  @override
  String get taskProgress => 'تقدم المهمة';

  @override
  String get quickStats => 'إحصيات سريعة';

  @override
  String get taskCompletion => 'إكمال المهمة';

  @override
  String get noItemsForDate => 'لا توجد عناصر لهذا التاريخ';

  @override
  String get enjoyFreeTime => 'استمتع بوقت فراغك!';

  @override
  String get searchThisDay => 'البحث في هذا اليوم...';

  @override
  String get finance => 'المالية';

  @override
  String get permanentlyDelete => 'حذف نهائي؟';

  @override
  String deleteSelectionConfirmation(int foldersCount, int sketchesCount) {
    return 'سيؤدي هذا إلى حذف $foldersCount مجلدات (ورسماتها) و $sketchesCount رسومات أخرى نهائياً.\n\nلا يمكن التراجع عن هذا الإجراء.';
  }

  @override
  String get deleteForever => 'حذف للأبد';

  @override
  String selectedCount(int count) {
    return '$count محدد';
  }

  @override
  String canvasStats(int notes, int folders) {
    return '$notes رسومات • $folders مجلدات';
  }

  @override
  String get sortItems => 'فرز العناصر';

  @override
  String get sortNameAZ => 'الاسم (أ-ي)';

  @override
  String get sortNameZA => 'الاسم (ي-أ)';

  @override
  String get createFolder => 'إنشاء مجلد';

  @override
  String get folderNameHint => 'اسم المجلد...';

  @override
  String deleteSketchesConfirmation(int count) {
    return 'حذف $count رسومات؟ لا يمكن التراجع عن هذا الإجراء.';
  }

  @override
  String get noSketchesFound => 'لم يتم العثور على رسومات';

  @override
  String get noSketchesFoundSub => 'حاول تعديل بحثك أو إنشاء رسمة جديدة.';

  @override
  String searchInFolder(String folder) {
    return 'بحث في $folder...';
  }

  @override
  String sketchesCount(int count) {
    return '$count رسومات';
  }

  @override
  String get sortSketches => 'فرز الرسومات';

  @override
  String get calendarScreenTitle => 'التقويم';

  @override
  String get dailyActivity => 'النشاط اليومي';

  @override
  String get deleteItemQuestion => 'حذف العنصر؟';

  @override
  String get deleteItemConfirmation =>
      'سيؤدي هذا إلى نقل العنصر إلى سلة المحذوفات.';

  @override
  String get moveToBinItem => 'نقل إلى السلة؟';

  @override
  String get moveToBinConfirmation => 'يمكنك استعادته لاحقاً.';

  @override
  String selectedItems(int count) {
    return '$count محدد';
  }

  @override
  String get recentClips => 'القصاصات الأخيرة';

  @override
  String get copied => 'تم النسخ!';

  @override
  String get copiedPlainText => 'تم نسخ النص المجرد';

  @override
  String get clipTheme => 'مظهر القصاصة';

  @override
  String get justNow => 'الآن';

  @override
  String minutesAgo(Object count) {
    return 'منذ $count د';
  }

  @override
  String hoursAgo(Object count) {
    return 'منذ $count س';
  }

  @override
  String daysAgo(Object count) {
    return 'منذ $count ي';
  }

  @override
  String get noTasksFound => 'لم يتم العثور على مهام.';

  @override
  String get searchTasks => 'بحث في المهام...';

  @override
  String get taskReminder => 'تذكير بالمهمة';

  @override
  String get untitledNote => 'ملاحظة بدون عنوان';

  @override
  String get dailyEntry => 'مدخل يومي';

  @override
  String get clipboardHistory => 'سجل الحافظة';

  @override
  String get deletePermanentlyContent => 'هذا الإجراء لا يمكن التراجع عنه.';

  @override
  String get emptyRecycleBinTitle => 'إفراغ سلة المحذوفات؟';

  @override
  String emptyRecycleBinContent(Object count) {
    return 'سيتم حذف جميع العناصر الـ $count نهائياً.';
  }

  @override
  String get emptyBin => 'إفراغ السلة';

  @override
  String get recycleBinEmpty => 'سلة المحذوفات فارغة';

  @override
  String get deletedItemsAppearHere => 'العناصر المحذوفة ستظهر هنا.';

  @override
  String get empty => 'فارغ';

  @override
  String get recent => 'الأخيرة';

  @override
  String categoryLabel(Object category) {
    return 'الفئة: $category';
  }

  @override
  String get general => 'عام';

  @override
  String get saveTransactionQuestion => 'هل تريد حفظ هذه المعاملة؟';

  @override
  String get fillTitleAmount => 'يرجى ملء العنوان والمبلغ';

  @override
  String get invalidAmount => 'تنسيق المبلغ غير صالح';

  @override
  String get moveTransactionToBinTitle => 'نقل المعاملة إلى سلة المحذوفات؟';

  @override
  String get restoreTransactionLater =>
      'يمكنك استعادة هذه المعاملة لاحقاً من الإعدادات.';

  @override
  String get newTransaction => 'معاملة جديدة';

  @override
  String get whatIsThisFor => 'فيما هذا؟';

  @override
  String get description => 'الوصف';

  @override
  String get daily => 'يومياً';

  @override
  String get weekly => 'أسبوعياً';

  @override
  String get monthly => 'شهرياً';

  @override
  String get yearly => 'سنوياً';

  @override
  String get totalIncome => 'إجمالي الدخل';

  @override
  String get totalExpense => 'إجمالي النفقات';

  @override
  String get analysis => 'التحليل';

  @override
  String get transactions => 'المعاملات';

  @override
  String get noExpensesFound => 'لم يتم العثور على نفقات لهذه الفترة.';

  @override
  String get netBalance => 'صافي الرصيد';

  @override
  String get topCategories => 'أبرز الفئات';

  @override
  String get spendingTrend => 'اتجاه الإنفاق';

  @override
  String get insights => 'رؤى';

  @override
  String get noExpensesRecorded => 'لم يتم تسجيل أي نفقات';

  @override
  String get trackSpendingHabits => 'تتبع عادات الإنفاق الخاصة بك بسهولة.';

  @override
  String get addExpense => 'إضافة نفقة';

  @override
  String get noDataForPeriod => 'لا توجد بيانات لهذه الفترة';

  @override
  String get budget => 'الميزانية';

  @override
  String get spent => 'تم صرفه';

  @override
  String get limit => 'الحد';

  @override
  String get overBudget => 'تجاوز الميزانية!';

  @override
  String remainingBudget(Object percent) {
    return 'متبقي $percent%';
  }

  @override
  String get savingsRate => 'معدل الادخار';

  @override
  String get healthScore => 'درجة الصحة المالية';

  @override
  String get healthScoreExplanation =>
      'هذه الدرجة تعتمد على معدل ادخارك.\n\n• ادخار > 50% = ممتاز (100)\n• ادخار 0% = متوسط (50)\n• الإنفاق > الدخل = ضعيف (<50)';

  @override
  String get ok => 'موافق';

  @override
  String get bulkImport => 'استيراد بالجملة';
}

/// The translations for Arabic, as used in Saudi Arabia (`ar_SA`).
class AppLocalizationsArSa extends AppLocalizationsAr {
  AppLocalizationsArSa() : super('ar_SA');

  @override
  String get settings => 'إعدادات';

  @override
  String get language => 'لغة';

  @override
  String get systemDefault => 'النظام الافتراضي';

  @override
  String get notes => 'ملحوظات';

  @override
  String get todos => 'المهام';

  @override
  String get expenses => 'نفقات';

  @override
  String get journal => 'مجلة';

  @override
  String get calendar => 'تقويم';

  @override
  String get clipboard => 'الحافظة';

  @override
  String get canvas => 'قماش';

  @override
  String get save => 'حفظ';

  @override
  String get create => 'إنشاء';

  @override
  String get cancel => 'إلغاء';

  @override
  String get delete => 'حذف';

  @override
  String get edit => 'تعديل';

  @override
  String get share => 'مشاركة';

  @override
  String get copy => 'نسخ';

  @override
  String get unsavedChanges => 'تغييرات غير محفوظة';

  @override
  String get confirmDelete => 'تأكيد الحذف';

  @override
  String get discard => 'تجاهل';

  @override
  String get createPost => 'إنشاء منشور';

  @override
  String get post => 'منشور';

  @override
  String get postingTo => 'النشر في';

  @override
  String get whatsOnYourMind => 'ماذا يدور في ذهنك؟';

  @override
  String get pickImages => 'اختر صورًا';

  @override
  String get pickVideo => 'اختر فيديو';

  @override
  String get camera => 'كاميرا';

  @override
  String get gallery => 'معرض الصور';

  @override
  String get search => 'بحث';

  @override
  String get pleaseEnterTask => 'يرجى إدخال مهمة';

  @override
  String get deleteTask => 'حذف المهمة';

  @override
  String get selectItems => 'حدد العناصر';

  @override
  String get deleteAll => 'حذف الكل';

  @override
  String error(Object error) {
    return 'خطأ: $error';
  }

  @override
  String get orderingOnlyAvailableInAllPosts =>
      'الترتيب متاح فقط في \"جميع المنشورات\"';

  @override
  String get deletePost => 'حذف المنشور';

  @override
  String get postDeleted => 'تم حذف المنشور';

  @override
  String get premiumFeatures => 'ميزات بريميوم';

  @override
  String get manageCoinsAdsPremium =>
      'إدارة العملات والإعلانات وحالة البريميوم';

  @override
  String get themeMode => 'وضع المظهر';

  @override
  String get accentColor => 'لون التمييز';

  @override
  String get backgroundDesign => 'تصميم الخلفية';

  @override
  String get pushNotifications => 'إشعارات الدفع';

  @override
  String get recycleBin => 'سلة المحذوفات';

  @override
  String get exportData => 'تصدير البيانات';

  @override
  String get importData => 'استيراد البيانات';

  @override
  String get rateApp => 'تقييم التطبيق';

  @override
  String get sendFeedback => 'إرسال تعليقات';

  @override
  String get privacyPolicy => 'سياسة الخصوصية';

  @override
  String get version => 'الإصدار';

  @override
  String get buildNumber => 'رقم البناء';

  @override
  String get system => 'النظام';

  @override
  String get light => 'فاتح';

  @override
  String get dark => 'داكن';

  @override
  String get itemRestored => 'تمت استعادة العنصر';

  @override
  String get recycleBinCleared => 'تم إفراغ سلة المحذوفات بنجاح';

  @override
  String get allPostsDeleted => 'تم حذف جميع المنشورات';

  @override
  String get newPost => 'منشور جديد';

  @override
  String get textCopiedToClipboardFacebook =>
      'Text copied to clipboard (Facebook policy)';

  @override
  String get tiktokSharingRequiresVideoImage =>
      'تتطلب مشاركة TikTok فيديو/صورة';

  @override
  String errorSharing(Object error) {
    return 'خطأ في المشاركة: $error';
  }

  @override
  String shareToStory(Object platform) {
    return 'مشاركة في قصة $platform';
  }

  @override
  String shareToFeed(Object platform) {
    return 'مشاركة في موجز $platform';
  }

  @override
  String get unlockPermanently => 'فتح بشكل دائم';

  @override
  String get notEnoughCoins => 'لا توجد عملات كافية!';

  @override
  String youEarnedCoins(Object amount) {
    return 'لقد ربحت $amount من العملات!';
  }

  @override
  String get contentCopied => 'تم نسخ المحتوى';

  @override
  String get selectDateTime => 'حدد التاريخ والوقت';

  @override
  String get areYouSureYouWantToDeleteThisPost =>
      'هل أنت متأكد أنك تريد حذف هذا المنشور؟';

  @override
  String get socialPosts => 'منشورات اجتماعية';

  @override
  String get watchAdToEarnCoins => 'شاهد إعلانًا لربح العملات';

  @override
  String get premiumUnlocked => 'تم فتح البريميوم';

  @override
  String get removeAds => 'إزالة الإعلانات';

  @override
  String get unlimitedCloudStorage => 'تخزين سحابي غير محدود';

  @override
  String get deleteNote => 'حذف الملاحظة';

  @override
  String get shareNote => 'مشاركة الملاحظة';

  @override
  String get editNote => 'تعديل الملاحظة';

  @override
  String get searchNotes => 'البحث في الملاحظات...';

  @override
  String get noNotesFound => 'لم يتم العثور على ملاحظات';

  @override
  String get captureThoughts => 'سجل أفكارك فورا.';

  @override
  String get createNote => 'إنشاء ملاحظة';

  @override
  String get customOrder => 'ترتيب مخصص';

  @override
  String get newestFirst => 'الأحدث أولاً';

  @override
  String get oldestFirst => 'الأقدم أولاً';

  @override
  String get titleAZ => 'العنوان: أ-ي';

  @override
  String get titleZA => 'العنوان: ي-أ';

  @override
  String get deleteAllQuestion => 'حذف الكل؟';

  @override
  String get moveToRecycleBin => 'نقل جميع الملاحظات إلى سلة المحذوفات؟';

  @override
  String get moveToBinQuestion => 'نقل إلى السلة؟';

  @override
  String get restoreNoteLater => 'يمكنك استعادة هذه الملاحظة لاحقًا.';

  @override
  String get move => 'نقل';

  @override
  String get myThoughts => 'أفكاري';

  @override
  String get selected => 'محدد';

  @override
  String get noContent => 'لا يوجد محتوى';

  @override
  String get untitled => 'بدون عنوان';

  @override
  String get chooseWallpapers => 'اختر من بين أكثر من 10 خلفيات ديناميكية';

  @override
  String get backupData => 'نسخ احتياطي للبيانات';

  @override
  String get saveJsonFile => 'هل تريد حفظ ملف JSON يحتوي على جميع بياناتك؟';

  @override
  String get exportNow => 'تصدير الآن';

  @override
  String get importDataTitle => 'استيراد البيانات';

  @override
  String get mergeBackupFile =>
      'هل تريد دمج ملف النسخ الاحتياطي مع العناصر الحالية؟';

  @override
  String get selectFile => 'حدد ملفاً';

  @override
  String get backupSaved => 'تم حفظ النسخة الاحتياطية بنجاح!';

  @override
  String get exportFailed => 'فشل التصدير.';

  @override
  String importSuccess(Object count) {
    return 'تمت استعادة $count من العناصر بنجاح!';
  }

  @override
  String get importFailed => 'فشل الاستيراد.';

  @override
  String widgetAdded(String widget) {
    return 'تمت إضافة الأداة $widget إلى الشاشة الرئيسية!';
  }

  @override
  String get widgetRequestSent =>
      'تم إرسال طلب الأداة. يرجى التحقق من الشاشة الرئيسية.';

  @override
  String get widgetAddFailed => 'فشل إضافة الأداة';

  @override
  String get autoSaveEnabled => 'تم تفعيل الحفظ التلقائي.';

  @override
  String get autoSaveDisabled => 'تم تعطيل الحفظ التلقائي.';

  @override
  String get homeScreenWidgets => 'أدوات الشاشة الرئيسية';

  @override
  String get notificationsTitle => 'الإشعارات';

  @override
  String get dataBackup => 'البيانات والنسخ الاحتياطي';

  @override
  String get feedbackSupport => 'التعليقات والدعم';

  @override
  String get creditsTitle => 'الاعتمادات';

  @override
  String get privacyMaintenance => 'الخصوصية والصيانة';

  @override
  String get aboutTitle => 'حول';

  @override
  String get premium => 'بريميوم';

  @override
  String get appearanceTitle => 'المظهر';

  @override
  String get clipboardTitle => 'الحافظة';

  @override
  String get settingsSubtitle => 'تخصيص تجربتك';

  @override
  String get welcomeTitle => 'مرحبًا بك في CopyClip';

  @override
  String get welcomeDescription =>
      'رفيقك النهائي للإنتاجية. دعنا نجهزك بأدوات قوية لإدارة يومك.';

  @override
  String get onboardingNotesTitle => 'ملاحظات ذكية';

  @override
  String get onboardingNotesDesc =>
      'التقط الأفكار فورًا بتنسيق نص غني. نظم أفكارك ولا تفقد أي فكرة رائعة مرة أخرى.';

  @override
  String get onboardingTodosTitle => 'إدارة المهام';

  @override
  String get onboardingTodosDesc =>
      'ابق مطلعاً على أمورك. أنشئ قوائم مهام، وحدد الأولويات، وحقق أهدافك خطوة بخطوة.';

  @override
  String get onboardingExpensesTitle => 'تتبع النفقات';

  @override
  String get onboardingExpensesDesc =>
      'تحكم في أموالك. تتبع الدخل والنفقات بسهولة لفهم عادات الإنفاق الخاصة بك.';

  @override
  String get onboardingJournalTitle => 'يوميات شخصية';

  @override
  String get onboardingJournalDesc =>
      'تأمل في يومك. مساحة خاصة لتدوين ذكرياتك ومشاعرك وتجاربك اليومية.';

  @override
  String get onboardingCalendarTitle => 'التقويم والأحداث';

  @override
  String get onboardingCalendarDesc =>
      'لا تفوت أي لحظة. نظم جدولك وتابع الأحداث الهامة القادمة.';

  @override
  String get onboardingClipboardTitle => 'مدير الحافظة';

  @override
  String get onboardingClipboardDesc =>
      'انسخ مرة واحدة، والصق في أي مكان. الوصول إلى سجل الحافظة لاستعادة النصوص التي نسختها سابقاً.';

  @override
  String get onboardingCanvasTitle => 'لوحة إبداعية';

  @override
  String get onboardingCanvasDesc =>
      'أطلق العنان لإبداعك. ارسم وخطط وصور أفكارك على لوحة رقمية حرة.';

  @override
  String get featuresNotesDesc => 'إنشاء وإدارة الملاحظات الخاصة بك';

  @override
  String get featuresTodosDesc => 'تتبع المهام الخاصة بك';

  @override
  String get featuresExpensesDesc => 'مراقبة النفقات الخاصة بك';

  @override
  String get featuresJournalDesc => 'اكتتب أفكارك';

  @override
  String get featuresCalendarDesc => 'نظم جدولك الزمني';

  @override
  String get featuresClipboardDesc => 'الوصول إلى سجل الحافظة الخاص بك';

  @override
  String get featuresCanvasDesc => 'ارسم وخطط بحرية';

  @override
  String get featuresSocialPost => 'منشور اجتماعي';

  @override
  String get featuresSocialPostDesc =>
      'إنشاء محتوى جذاب لوسائل التواصل الاجتماعي';

  @override
  String get chooseYourAura => 'اختر هالتك';

  @override
  String get expressYourselfTheme => 'عبر عن نفسك بلون مظهر جديد!';

  @override
  String get level => 'المستوى';

  @override
  String get xpToNextLevel => 'XP للمستوى التالي';

  @override
  String get checkUpcomingEvents => 'تحقق من الأحداث القادمة';

  @override
  String get startNewSketch => 'بدأ رسمة جديدة';

  @override
  String get noTransactionsMonth => 'لا توجد معاملات هذا الشهر';

  @override
  String transactionsThisMonth(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count معاملات هذا الشهر',
      few: '$count معاملات هذا الشهر',
      two: 'معاملتان هذا الشهر',
      one: 'معاملة واحدة هذا الشهر',
      zero: 'لا توجد معاملات هذا الشهر',
    );
    return '$_temp0';
  }

  @override
  String get autoSaveClipboard => 'حفظ تلقائي للحافظة';

  @override
  String get autoSaveClipboardDesc => 'حفظ العناصر المنسوخة تلقائياً';

  @override
  String get permissionDeniedSettings =>
      'تم رفض الإذن بشكل دائم. يرجى تفعيله من الإعدادات.';

  @override
  String get notificationsEnabled => 'تم تفعيل الإشعارات!';

  @override
  String get redirectingToSettings =>
      'جارٍ التوجيه إلى الإعدادات لتعطيل الإشعارات...';

  @override
  String get premiumAccess => 'وصول بريميوم';

  @override
  String get premiumActiveUntil => 'بريميوم نشط حتى';

  @override
  String get unlockAllFeatures => 'فتح جميع الميزات';

  @override
  String get buyPremium => 'شراء بريميوم (7 أيام)';

  @override
  String costCoins(Object cost) {
    return 'التكلفة: $cost عملات';
  }

  @override
  String get premiumActivated => 'تم تفعيل البريميوم لمدة 7 أيام!';

  @override
  String get premiumActive => 'البريميوم نشط';

  @override
  String get expires => 'تنتهي الصلاحية:';

  @override
  String get temporaryAccess => 'وصول مؤقت';

  @override
  String get journalExpression => 'يوميات وتعبير';

  @override
  String get artisticDesigns => 'تصاميم فنية';

  @override
  String get artisticDesignsDesc =>
      'فتح أكثر من 10 مظاهر فريدة لبطاقات اليوميات';

  @override
  String get premiumLayouts => 'تخطيطات بريميوم';

  @override
  String get premiumLayoutsDesc => 'طرق حصرية لعرض ذكرياتك';

  @override
  String get calendarTools => 'تقويم وأدوات';

  @override
  String get fullCalendar => 'تقويم كامل';

  @override
  String get fullCalendarDesc => 'نظام متكامل لإدارة الأحداث';

  @override
  String get clipboardAutoSaveDesc => 'التقاط سجل الحافظة في الخلفية';

  @override
  String get proWidgets => 'أدوات ذكية للمحترفين';

  @override
  String get proWidgetsDesc => 'جميع الميزات متوفرة على شاشتك الرئيسية';

  @override
  String get dataExport => 'البيانات والتصدير';

  @override
  String get advancedBackup => 'نسخ احتياطي متقدم';

  @override
  String get advancedBackupDesc => 'استيراد/تصدير آمن لجميع البيانات';

  @override
  String get pdfExport => 'تصدير إلى PDF';

  @override
  String get pdfExportDesc => 'تصدير الملاحظات واليوميات إلى PDF';

  @override
  String get printReady => 'جاهز للطباعة';

  @override
  String get printReadyDesc => 'دعم الطباعة المباشرة';

  @override
  String get richTextEditor => 'محرر نص غني';

  @override
  String get advancedSearch => 'بحث متقدم';

  @override
  String get advancedSearchDesc => 'البحث والاستبدال داخل النص';

  @override
  String get richMedia => 'وسائط غنية';

  @override
  String get richMediaDesc => 'إدراج صور وفيديوهات وروابط';

  @override
  String get editorStyling => 'تنسيق المحرر';

  @override
  String get editorStylingDesc => 'نص مخصص وخلفيات للمحرر';

  @override
  String get balance => 'الرصيد';

  @override
  String get loadingAd => 'جارٍ تحميل الإعلان...';

  @override
  String watchAd(Object amount) {
    return 'مشاهدة إعلان (+$amount)';
  }

  @override
  String get loadAd => 'تحميل إعلان';

  @override
  String get backupDataDesc => 'حفظ ملف JSON لبياناتك';

  @override
  String get importDataDesc => 'دمج ملف نسخة احتياطية في CopyClip';

  @override
  String get notificationPermissionDenied => 'تم رفض إذن الإشعارات.';

  @override
  String get typeNewTask => 'اكتب مهمة جديدة...';

  @override
  String get addTask => 'إضافة مهمة';

  @override
  String get completed => 'مكتمل';

  @override
  String get greatJob => 'عمل رائع!';

  @override
  String youEarnedXPNextTask(Object amount, Object date) {
    return 'لقد ربحت $amount XP! المهمة التالية: $date';
  }

  @override
  String taskCompletedXP(Object amount) {
    return 'تمت المهمة! +$amount XP';
  }

  @override
  String get moveTasksToRecycleBin =>
      'نقل جميع المهام النشطة إلى سلة المحذوفات؟';

  @override
  String get deleteAllPosts => 'حذف جميع المنشورات';

  @override
  String get deleteAllPostsConfirmation =>
      'هل أنت متأكد أنك تريد حذف جميع المنشورات الاجتماعية؟ لا يمكن التراجع عن هذا الإجراء.';

  @override
  String get allPosts => 'جميع المنشورات';

  @override
  String get favorites => 'المفضلة';

  @override
  String get drafts => 'المسودات';

  @override
  String get noFavoritesYet => 'لا توجد مفضلات بعد';

  @override
  String get noDraftsYet => 'لا توجد مسودات بعد';

  @override
  String get startSocialJourney => 'ابدأ رحلتك الاجتماعية!';

  @override
  String get draft => 'مسودة';

  @override
  String attachmentCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count مرفقات',
      few: '$count مرفقات',
      two: 'مرفقان',
      one: 'مرفق واحد',
      zero: 'لا توجد مرفقات',
    );
    return '$_temp0';
  }

  @override
  String get pleaseAddContent => 'يرجى إضافة بعض المحتوى أو الوسائط للمشاركة';

  @override
  String fileNotFoundError(Object path) {
    return 'خطأ: لم يتم العثور على الملف في $path';
  }

  @override
  String get checkFacebookApp => 'تحقق من تطبيق فيسبوك';

  @override
  String get systemShare => 'مشاركة النظام';

  @override
  String get socialPost => 'منشور اجتماعي';

  @override
  String get favorite => 'مفضل';

  @override
  String get saveDraft => 'حفظ المسودة';

  @override
  String get entryCopied => 'تم نسخ المدخل';

  @override
  String get moveEntriesToRecycleBin =>
      'نقل جميع المدخلات النشطة إلى سلة المحذوفات؟';

  @override
  String get startWritingStory => 'ابدأ بكتابة قصتك';

  @override
  String get recordMemories => 'سجل ذكرياتك ومشاعرك اليومية.';

  @override
  String get writeJournal => 'اكتب يومياتك';

  @override
  String get myMemories => 'ذكرياتي';

  @override
  String get sortJournal => 'فرز اليوميات';

  @override
  String get byMood => 'حسب المزاج';

  @override
  String get searchMemories => 'بحث في الذكريات...';

  @override
  String get selectAll => 'تحديد الكل';

  @override
  String get deleteSelected => 'حذف المحدد';

  @override
  String get taskCompletedExclamation => 'تمت المهمة!';

  @override
  String get taskUncompletedExclamation => 'مهمة غير مكتملة';

  @override
  String get clipboardUpdatedExclamation => 'تم تحديث الحافظة!';

  @override
  String clipboardSavedContent(Object content) {
    return 'تم حفظ في الحافظة: $content';
  }

  @override
  String get overview => 'نظرة عامة';

  @override
  String get colorAurora => 'أورورا';

  @override
  String get colorCosmic => 'كوني';

  @override
  String get colorNebula => 'سديم';

  @override
  String get colorStarlight => 'ضوء النجوم';

  @override
  String get colorSolar => 'شمسي';

  @override
  String get colorNova => 'نوفا';

  @override
  String get loadingStepLoading => 'جارٍ التحميل...';

  @override
  String get loadingStepDatabase => 'إعداد قاعدة البيانات...';

  @override
  String get loadingStepSystem => 'تكوين النظام...';

  @override
  String get loadingStepReady => 'جاهز';

  @override
  String get productivityCompanion => 'رفيقك للإنتاجية';

  @override
  String get done => 'تم';

  @override
  String get newNote => 'ملاحظة جديدة';

  @override
  String get changeColor => 'تغيير اللون';

  @override
  String get copyContent => 'نسخ المحتوى';

  @override
  String get titleOptional => 'العنوان (اختياري)';

  @override
  String get exportAsPdf => 'تصدير كـ PDF';

  @override
  String get taskDueNow => 'موعد المهمة الآن';

  @override
  String get moveTaskToBinTitle => 'نقل المهمة إلى سلة المحذوفات؟';

  @override
  String get restoreTaskLater =>
      'يمكنك استعادة هذه المهمة لاحقًا من الإعدادات.';

  @override
  String get newTask => 'مهمة جديدة';

  @override
  String get editTask => 'تعديل المهمة';

  @override
  String get undo => 'تراجع';

  @override
  String get redo => 'إعادة';

  @override
  String get category => 'الفئة';

  @override
  String get categoryHint => 'مثال: العمل، النادي';

  @override
  String get whatNeedsToBeDone => 'ما الذي يجب القيام به؟';

  @override
  String get enterTaskDetails => 'أدخل تفاصيل المهمة...';

  @override
  String get setDueDate => 'تحديد موعد الاستحقاق';

  @override
  String get dueDate => 'موعد الاستحقاق';

  @override
  String get expenseTitle => 'النفقات';

  @override
  String searchInCurrency(String currency) {
    return 'بحث في $currency...';
  }

  @override
  String get sortAndFilter => 'فرز وتصفية';

  @override
  String get sortBy => 'فرز حسب';

  @override
  String get highestAmount => 'أعلى مبلغ';

  @override
  String get lowestAmount => 'أقل مبلغ';

  @override
  String get moreFilters => 'مزيد من الفلاتر...';

  @override
  String get filterExpenses => 'تصفية النفقات';

  @override
  String get transactionType => 'نوع المعاملة';

  @override
  String get categories => 'الفئات';

  @override
  String get all => 'الكل';

  @override
  String get income => 'الدخل';

  @override
  String get expense => 'المصروفات';

  @override
  String get reset => 'إعادة تعيين';

  @override
  String get apply => 'تطبيق';

  @override
  String newExpense(String currency) {
    return 'جديد $currency';
  }

  @override
  String errorLoadingData(String error) {
    return 'حدث خطأ أثناء تحميل البيانات.\n\n$error';
  }

  @override
  String get dailyQuote1 => 'أفضل طريقة للتنبؤ بالمستقبل هي أن تصنعه.';

  @override
  String get dailyQuote2 => 'الغنى ليس في كثرة العرض، ولكن الغنى غنى النفس.';

  @override
  String get dailyQuote3 => 'الوقت هو العملة الأغلى.';

  @override
  String get dailyQuote4 => 'النجاح ليس نهائياً، والفشل ليس قاتلاً.';

  @override
  String get dailyQuote5 => 'ركز على الحل، وليس المشكلة.';

  @override
  String get dailyQuote6 => 'شبكة علاقاتك هي ثروتك الحقيقية.';

  @override
  String get moodHappy => 'سعيد';

  @override
  String get moodExcited => 'متحمس';

  @override
  String get moodNeutral => 'محايد';

  @override
  String get moodSad => 'حزين';

  @override
  String get moodStressed => 'متوتر';

  @override
  String exportDate(String date) {
    return '📅 $date';
  }

  @override
  String exportMood(String emoji, String mood) {
    return 'المزاج: $emoji $mood';
  }

  @override
  String exportTitle(String title) {
    return 'العنوان: $title';
  }

  @override
  String exportTags(String tags) {
    return '\nالوسوم: $tags';
  }

  @override
  String get instagram => 'إنستغرام';

  @override
  String get facebook => 'فيسبوك';

  @override
  String get tiktok => 'تيك توك';

  @override
  String get newSketch => 'رسمة جديدة';

  @override
  String get searchSketches => 'البحث في الرسومات والمجلدات...';

  @override
  String get noResultsFound => 'لم يتم العثور على نتائج';

  @override
  String get noItems => 'لا توجد عناصر';

  @override
  String get noDrawingsYet => 'لا توجد رسومات بعد';

  @override
  String get canvasIntro => 'أطلق العنان لإبداعك على اللوحة!';

  @override
  String get newCanvas => 'لوحة جديدة';

  @override
  String get rename => 'إعادة تسمية';

  @override
  String get deleteFolder => 'حذف المجلد';

  @override
  String get deleteSketchesQuestion => 'حذف الرسومات؟';

  @override
  String get deleteFolderConfirmation =>
      'سيتم حذف جميع الرسومات في هذا المجلد نهائياً.';

  @override
  String get renameFolder => 'إعادة تسمية المجلد';

  @override
  String get chooseColor => 'اختر لوناً';

  @override
  String get deleteFolderQuestion => 'حذف المجلد؟';

  @override
  String get searchClips => 'البحث في القصاصات...';

  @override
  String get clipboardEmpty => 'الحافظة فارغة';

  @override
  String get addItem => 'إضافة عنصر';

  @override
  String get clipColor => 'لون القصاصة';

  @override
  String get newClip => 'قصاصة جديدة';

  @override
  String get editClip => 'تعديل القصاصة';

  @override
  String get restoreClipLater => 'يمكنك استعادة هذه القصاصة لاحقاً.';

  @override
  String get upcomingEvents => 'الأحداث القادمة';

  @override
  String get dataDistribution => 'توزيع البيانات';

  @override
  String get taskProgress => 'تقدم المهمة';

  @override
  String get quickStats => 'إحصائيات سريعة';

  @override
  String get taskCompletion => 'إكمال المهمة';

  @override
  String get noItemsForDate => 'لا توجد عناصر لهذا التاريخ';

  @override
  String get enjoyFreeTime => 'استمتع بوقت فراغك!';

  @override
  String get searchThisDay => 'البحث في هذا اليوم...';

  @override
  String get finance => 'المالية';

  @override
  String get permanentlyDelete => 'حذف نهائي؟';

  @override
  String deleteSelectionConfirmation(int foldersCount, int sketchesCount) {
    return 'سيؤدي هذا إلى حذف $foldersCount مجلدات (ورسماتها) و $sketchesCount رسومات أخرى نهائياً.\n\nلا يمكن التراجع عن هذا الإجراء.';
  }

  @override
  String get deleteForever => 'حذف للأبد';

  @override
  String selectedCount(int count) {
    return '$count محدد';
  }

  @override
  String canvasStats(int notes, int folders) {
    return '$notes رسومات • $folders مجلدات';
  }

  @override
  String get sortItems => 'فرز العناصر';

  @override
  String get sortNameAZ => 'الاسم (أ-ي)';

  @override
  String get sortNameZA => 'الاسم (ي-أ)';

  @override
  String get createFolder => 'إنشاء مجلد';

  @override
  String get folderNameHint => 'اسم المجلد...';

  @override
  String deleteSketchesConfirmation(int count) {
    return 'حذف $count رسومات؟ لا يمكن التراجع عن هذا الإجراء.';
  }

  @override
  String get noSketchesFound => 'لم يتم العثور على رسومات';

  @override
  String get noSketchesFoundSub => 'حاول تعديل بحثك أو إنشاء رسمة جديدة.';

  @override
  String searchInFolder(String folder) {
    return 'بحث في $folder...';
  }

  @override
  String sketchesCount(int count) {
    return '$count رسومات';
  }

  @override
  String get sortSketches => 'فرز الرسومات';

  @override
  String get calendarScreenTitle => 'التقويم';

  @override
  String get dailyActivity => 'النشاط اليومي';

  @override
  String get deleteItemQuestion => 'حذف العنصر؟';

  @override
  String get deleteItemConfirmation =>
      'سيؤدي هذا إلى نقل العنصر إلى سلة المحذوفات.';

  @override
  String get moveToBinItem => 'نقل إلى السلة؟';

  @override
  String get moveToBinConfirmation => 'يمكنك استعادته لاحقاً.';

  @override
  String selectedItems(int count) {
    return '$count محدد';
  }

  @override
  String get recentClips => 'القصاصات الأخيرة';

  @override
  String get copied => 'تم النسخ!';

  @override
  String get copiedPlainText => 'تم نسخ النص المجرد';

  @override
  String get clipTheme => 'مظهر القصاصة';

  @override
  String get justNow => 'الآن';

  @override
  String minutesAgo(Object count) {
    return 'منذ $count د';
  }

  @override
  String hoursAgo(Object count) {
    return 'منذ $count س';
  }

  @override
  String daysAgo(Object count) {
    return 'منذ $count ي';
  }

  @override
  String get noTasksFound => 'لم يتم العثور على مهام.';

  @override
  String get searchTasks => 'بحث في المهام...';

  @override
  String get taskReminder => 'تذكير بالمهمة';

  @override
  String get untitledNote => 'ملاحظة بدون عنوان';

  @override
  String get dailyEntry => 'مدخل يومي';

  @override
  String get clipboardHistory => 'سجل الحافظة';

  @override
  String get deletePermanentlyContent => 'هذا الإجراء لا يمكن التراجع عنه.';

  @override
  String get emptyRecycleBinTitle => 'إفراغ سلة المحذوفات؟';

  @override
  String emptyRecycleBinContent(Object count) {
    return 'سيتم حذف جميع العناصر الـ $count نهائياً.';
  }

  @override
  String get emptyBin => 'إفراغ السلة';

  @override
  String get recycleBinEmpty => 'سلة المحذوفات فارغة';

  @override
  String get deletedItemsAppearHere => 'العناصر المحذوفة ستظهر هنا.';

  @override
  String get empty => 'فارغ';

  @override
  String get recent => 'الأخيرة';

  @override
  String categoryLabel(Object category) {
    return 'الفئة: $category';
  }

  @override
  String get general => 'عام';

  @override
  String get saveTransactionQuestion => 'هل تريد حفظ هذه المعاملة؟';

  @override
  String get fillTitleAmount => 'يرجى ملء العنوان والمبلغ';

  @override
  String get invalidAmount => 'تنسيق المبلغ غير صالح';

  @override
  String get moveTransactionToBinTitle => 'نقل المعاملة إلى سلة المحذوفات؟';

  @override
  String get restoreTransactionLater =>
      'يمكنك استعادة هذه المعاملة لاحقاً من الإعدادات.';

  @override
  String get newTransaction => 'معاملة جديدة';

  @override
  String get whatIsThisFor => 'فيما هذا؟';

  @override
  String get description => 'الوصف';

  @override
  String get daily => 'يومياً';

  @override
  String get weekly => 'أسبوعياً';

  @override
  String get monthly => 'شهرياً';

  @override
  String get yearly => 'سنوياً';

  @override
  String get totalIncome => 'إجمالي الدخل';

  @override
  String get totalExpense => 'إجمالي النفقات';

  @override
  String get analysis => 'التحليل';

  @override
  String get transactions => 'المعاملات';

  @override
  String get noExpensesFound => 'لم يتم العثور على نفقات لهذه الفترة.';

  @override
  String get netBalance => 'صافي الرصيد';

  @override
  String get topCategories => 'أبرز الفئات';

  @override
  String get spendingTrend => 'اتجاه الإنفاق';

  @override
  String get insights => 'رؤى';

  @override
  String get noExpensesRecorded => 'لم يتم تسجيل أي نفقات';

  @override
  String get trackSpendingHabits => 'تتبع عادات الإنفاق الخاصة بك بسهولة.';

  @override
  String get addExpense => 'إضافة نفقة';

  @override
  String get noDataForPeriod => 'لا توجد بيانات لهذه الفترة';

  @override
  String get budget => 'الميزانية';

  @override
  String get spent => 'تم صرفه';

  @override
  String get limit => 'الحد';

  @override
  String get overBudget => 'تجاوز الميزانية!';

  @override
  String remainingBudget(Object percent) {
    return 'متبقي $percent%';
  }

  @override
  String get savingsRate => 'معدل الادخار';

  @override
  String get healthScore => 'درجة الصحة المالية';

  @override
  String get healthScoreExplanation =>
      'هذه الدرجة تعتمد على معدل ادخارك.\n\n• ادخار > 50% = ممتاز (100)\n• ادخار 0% = متوسط (50)\n• الإنفاق > الدخل = ضعيف (<50)';

  @override
  String get ok => 'موافق';

  @override
  String get bulkImport => 'استيراد بالجملة';
}

/// The translations for Arabic, as used in Sudan (`ar_SD`).
class AppLocalizationsArSd extends AppLocalizationsAr {
  AppLocalizationsArSd() : super('ar_SD');

  @override
  String get settings => 'إعدادات';

  @override
  String get language => 'لغة';

  @override
  String get systemDefault => 'النظام الافتراضي';

  @override
  String get notes => 'ملحوظات';

  @override
  String get todos => 'المهام';

  @override
  String get expenses => 'نفقات';

  @override
  String get journal => 'مجلة';

  @override
  String get calendar => 'تقويم';

  @override
  String get clipboard => 'الحافظة';

  @override
  String get canvas => 'قماش';

  @override
  String get save => 'حفظ';

  @override
  String get create => 'إنشاء';

  @override
  String get cancel => 'إلغاء';

  @override
  String get delete => 'حذف';

  @override
  String get edit => 'تعديل';

  @override
  String get share => 'مشاركة';

  @override
  String get copy => 'نسخ';

  @override
  String get unsavedChanges => 'تغييرات غير محفوظة';

  @override
  String get confirmDelete => 'تأكيد الحذف';

  @override
  String get discard => 'تجاهل';

  @override
  String get createPost => 'إنشاء منشور';

  @override
  String get post => 'منشور';

  @override
  String get postingTo => 'النشر في';

  @override
  String get whatsOnYourMind => 'ماذا يدور في ذهنك؟';

  @override
  String get pickImages => 'اختر صورًا';

  @override
  String get pickVideo => 'اختر فيديو';

  @override
  String get camera => 'كاميرا';

  @override
  String get gallery => 'معرض الصور';

  @override
  String get search => 'بحث';

  @override
  String get pleaseEnterTask => 'يرجى إدخال مهمة';

  @override
  String get deleteTask => 'حذف المهمة';

  @override
  String get selectItems => 'حدد العناصر';

  @override
  String get deleteAll => 'حذف الكل';

  @override
  String error(Object error) {
    return 'خطأ: $error';
  }

  @override
  String get orderingOnlyAvailableInAllPosts =>
      'الترتيب متاح فقط في \"جميع المنشورات\"';

  @override
  String get deletePost => 'حذف المنشور';

  @override
  String get postDeleted => 'تم حذف المنشور';

  @override
  String get premiumFeatures => 'ميزات بريميوم';

  @override
  String get manageCoinsAdsPremium =>
      'إدارة العملات والإعلانات وحالة البريميوم';

  @override
  String get themeMode => 'وضع المظهر';

  @override
  String get accentColor => 'لون التمييز';

  @override
  String get backgroundDesign => 'تصميم الخلفية';

  @override
  String get pushNotifications => 'إشعارات الدفع';

  @override
  String get recycleBin => 'سلة المحذوفات';

  @override
  String get exportData => 'تصدير البيانات';

  @override
  String get importData => 'استيراد البيانات';

  @override
  String get rateApp => 'تقييم التطبيق';

  @override
  String get sendFeedback => 'إرسال تعليقات';

  @override
  String get privacyPolicy => 'سياسة الخصوصية';

  @override
  String get version => 'الإصدار';

  @override
  String get buildNumber => 'رقم البناء';

  @override
  String get system => 'النظام';

  @override
  String get light => 'فاتح';

  @override
  String get dark => 'داكن';

  @override
  String get itemRestored => 'تمت استعادة العنصر';

  @override
  String get recycleBinCleared => 'تم إفراغ سلة المحذوفات بنجاح';

  @override
  String get allPostsDeleted => 'تم حذف جميع المنشورات';

  @override
  String get newPost => 'منشور جديد';

  @override
  String get textCopiedToClipboardFacebook =>
      'Text copied to clipboard (Facebook policy)';

  @override
  String get tiktokSharingRequiresVideoImage =>
      'تتطلب مشاركة TikTok فيديو/صورة';

  @override
  String errorSharing(Object error) {
    return 'خطأ في المشاركة: $error';
  }

  @override
  String shareToStory(Object platform) {
    return 'مشاركة في قصة $platform';
  }

  @override
  String shareToFeed(Object platform) {
    return 'مشاركة في موجز $platform';
  }

  @override
  String get unlockPermanently => 'فتح بشكل دائم';

  @override
  String get notEnoughCoins => 'لا توجد عملات كافية!';

  @override
  String youEarnedCoins(Object amount) {
    return 'لقد ربحت $amount من العملات!';
  }

  @override
  String get contentCopied => 'تم نسخ المحتوى';

  @override
  String get selectDateTime => 'حدد التاريخ والوقت';

  @override
  String get areYouSureYouWantToDeleteThisPost =>
      'هل أنت متأكد أنك تريد حذف هذا المنشور؟';

  @override
  String get socialPosts => 'منشورات اجتماعية';

  @override
  String get watchAdToEarnCoins => 'شاهد إعلانًا لربح العملات';

  @override
  String get premiumUnlocked => 'تم فتح البريميوم';

  @override
  String get removeAds => 'إزالة الإعلانات';

  @override
  String get unlimitedCloudStorage => 'تخزين سحابي غير محدود';

  @override
  String get deleteNote => 'حذف الملاحظة';

  @override
  String get shareNote => 'مشاركة الملاحظة';

  @override
  String get editNote => 'تعديل الملاحظة';

  @override
  String get searchNotes => 'البحث في الملاحظات...';

  @override
  String get noNotesFound => 'لم يتم العثور على ملاحظات';

  @override
  String get captureThoughts => 'سجل أفكارك فورا.';

  @override
  String get createNote => 'إنشاء ملاحظة';

  @override
  String get customOrder => 'ترتيب مخصص';

  @override
  String get newestFirst => 'الأحدث أولاً';

  @override
  String get oldestFirst => 'الأقدم أولاً';

  @override
  String get titleAZ => 'العنوان: أ-ي';

  @override
  String get titleZA => 'العنوان: ي-أ';

  @override
  String get deleteAllQuestion => 'حذف الكل؟';

  @override
  String get moveToRecycleBin => 'نقل جميع الملاحظات إلى سلة المحذوفات؟';

  @override
  String get moveToBinQuestion => 'نقل إلى السلة؟';

  @override
  String get restoreNoteLater => 'يمكنك استعادة هذه الملاحظة لاحقًا.';

  @override
  String get move => 'نقل';

  @override
  String get myThoughts => 'أفكاري';

  @override
  String get selected => 'محدد';

  @override
  String get noContent => 'لا يوجد محتوى';

  @override
  String get untitled => 'بدون عنوان';

  @override
  String get chooseWallpapers => 'اختر من بين أكثر من 10 خلفيات ديناميكية';

  @override
  String get backupData => 'نسخ احتياطي للبيانات';

  @override
  String get saveJsonFile => 'هل تريد حفظ ملف JSON يحتوي على جميع بياناتك؟';

  @override
  String get exportNow => 'تصدير الآن';

  @override
  String get importDataTitle => 'استيراد البيانات';

  @override
  String get mergeBackupFile =>
      'هل تريد دمج ملف النسخ الاحتياطي مع العناصر الحالية؟';

  @override
  String get selectFile => 'حدد ملفاً';

  @override
  String get backupSaved => 'تم حفظ النسخة الاحتياطية بنجاح!';

  @override
  String get exportFailed => 'فشل التصدير.';

  @override
  String importSuccess(Object count) {
    return 'تمت استعادة $count من العناصر بنجاح!';
  }

  @override
  String get importFailed => 'فشل الاستيراد.';

  @override
  String widgetAdded(String widget) {
    return 'تمت إضافة الأداة $widget إلى الشاشة الرئيسية!';
  }

  @override
  String get widgetRequestSent =>
      'تم إرسال طلب الأداة. يرجى التحقق من الشاشة الرئيسية.';

  @override
  String get widgetAddFailed => 'فشل إضافة الأداة';

  @override
  String get autoSaveEnabled => 'تم تفعيل الحفظ التلقائي.';

  @override
  String get autoSaveDisabled => 'تم تعطيل الحفظ التلقائي.';

  @override
  String get homeScreenWidgets => 'أدوات الشاشة الرئيسية';

  @override
  String get notificationsTitle => 'الإشعارات';

  @override
  String get dataBackup => 'البيانات والنسخ الاحتياطي';

  @override
  String get feedbackSupport => 'التعليقات والدعم';

  @override
  String get creditsTitle => 'الاعتمادات';

  @override
  String get privacyMaintenance => 'الخصوصية والصيانة';

  @override
  String get aboutTitle => 'حول';

  @override
  String get premium => 'بريميوم';

  @override
  String get appearanceTitle => 'المظهر';

  @override
  String get clipboardTitle => 'الحافظة';

  @override
  String get settingsSubtitle => 'تخصيص تجربتك';

  @override
  String get welcomeTitle => 'مرحبًا بك في CopyClip';

  @override
  String get welcomeDescription =>
      'رفيقك النهائي للإنتاجية. دعنا نجهزك بأدوات قوية لإدارة يومك.';

  @override
  String get onboardingNotesTitle => 'ملاحظات ذكية';

  @override
  String get onboardingNotesDesc =>
      'التقط الأفكار فورًا بتنسيق نص غني. نظم أفكارك ولا تفقد أي فكرة رائعة مرة أخرى.';

  @override
  String get onboardingTodosTitle => 'إدارة المهام';

  @override
  String get onboardingTodosDesc =>
      'ابق مطلعاً على أمورك. أنشئ قوائم مهام، وحدد الأولويات، وحقق أهدافك خطوة بخطوة.';

  @override
  String get onboardingExpensesTitle => 'تتبع النفقات';

  @override
  String get onboardingExpensesDesc =>
      'تحكم في أموالك. تتبع الدخل والنفقات بسهولة لفهم عادات الإنفاق الخاصة بك.';

  @override
  String get onboardingJournalTitle => 'يوميات شخصية';

  @override
  String get onboardingJournalDesc =>
      'تأمل في يومك. مساحة خاصة لتدوين ذكرياتك ومشاعرك وتجاربك اليومية.';

  @override
  String get onboardingCalendarTitle => 'التقويم والأحداث';

  @override
  String get onboardingCalendarDesc =>
      'لا تفوت أي لحظة. نظم جدولك وتابع الأحداث الهامة القادمة.';

  @override
  String get onboardingClipboardTitle => 'مدير الحافظة';

  @override
  String get onboardingClipboardDesc =>
      'انسخ مرة واحدة، والصق في أي مكان. الوصول إلى سجل الحافظة لاستعادة النصوص التي نسختها سابقاً.';

  @override
  String get onboardingCanvasTitle => 'لوحة إبداعية';

  @override
  String get onboardingCanvasDesc =>
      'أطلق العنان لإبداعك. ارسم وخطط وصور أفكارك على لوحة رقمية حرة.';

  @override
  String get featuresNotesDesc => 'إنشاء وإدارة الملاحظات الخاصة بك';

  @override
  String get featuresTodosDesc => 'تتبع المهام الخاصة بك';

  @override
  String get featuresExpensesDesc => 'مراقبة النفقات الخاصة بك';

  @override
  String get featuresJournalDesc => 'اكتتب أفكارك';

  @override
  String get featuresCalendarDesc => 'نظم جدولك الزمني';

  @override
  String get featuresClipboardDesc => 'الوصول إلى سجل الحافظة الخاص بك';

  @override
  String get featuresCanvasDesc => 'ارسم وخطط بحرية';

  @override
  String get featuresSocialPost => 'منشور اجتماعي';

  @override
  String get featuresSocialPostDesc =>
      'إنشاء محتوى جذاب لوسائل التواصل الاجتماعي';

  @override
  String get chooseYourAura => 'اختر هالتك';

  @override
  String get expressYourselfTheme => 'عبر عن نفسك بلون مظهر جديد!';

  @override
  String get level => 'المستوى';

  @override
  String get xpToNextLevel => 'XP للمستوى التالي';

  @override
  String get checkUpcomingEvents => 'تحقق من الأحداث القادمة';

  @override
  String get startNewSketch => 'بدأ رسمة جديدة';

  @override
  String get noTransactionsMonth => 'لا توجد معاملات هذا الشهر';

  @override
  String transactionsThisMonth(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count معاملات هذا الشهر',
      few: '$count معاملات هذا الشهر',
      two: 'معاملتان هذا الشهر',
      one: 'معاملة واحدة هذا الشهر',
      zero: 'لا توجد معاملات هذا الشهر',
    );
    return '$_temp0';
  }

  @override
  String get autoSaveClipboard => 'حفظ تلقائي للحافظة';

  @override
  String get autoSaveClipboardDesc => 'حفظ العناصر المنسوخة تلقائياً';

  @override
  String get permissionDeniedSettings =>
      'تم رفض الإذن بشكل دائم. يرجى تفعيله من الإعدادات.';

  @override
  String get notificationsEnabled => 'تم تفعيل الإشعارات!';

  @override
  String get redirectingToSettings =>
      'جارٍ التوجيه إلى الإعدادات لتعطيل الإشعارات...';

  @override
  String get premiumAccess => 'وصول بريميوم';

  @override
  String get premiumActiveUntil => 'بريميوم نشط حتى';

  @override
  String get unlockAllFeatures => 'فتح جميع الميزات';

  @override
  String get buyPremium => 'شراء بريميوم (7 أيام)';

  @override
  String costCoins(Object cost) {
    return 'التكلفة: $cost عملات';
  }

  @override
  String get premiumActivated => 'تم تفعيل البريميوم لمدة 7 أيام!';

  @override
  String get premiumActive => 'البريميوم نشط';

  @override
  String get expires => 'تنتهي الصلاحية:';

  @override
  String get temporaryAccess => 'وصول مؤقت';

  @override
  String get journalExpression => 'يوميات وتعبير';

  @override
  String get artisticDesigns => 'تصاميم فنية';

  @override
  String get artisticDesignsDesc =>
      'فتح أكثر من 10 مظاهر فريدة لبطاقات اليوميات';

  @override
  String get premiumLayouts => 'تخطيطات بريميوم';

  @override
  String get premiumLayoutsDesc => 'طرق حصرية لعرض ذكرياتك';

  @override
  String get calendarTools => 'تقويم وأدوات';

  @override
  String get fullCalendar => 'تقويم كامل';

  @override
  String get fullCalendarDesc => 'نظام متكامل لإدارة الأحداث';

  @override
  String get clipboardAutoSaveDesc => 'التقاط سجل الحافظة في الخلفية';

  @override
  String get proWidgets => 'أدوات ذكية للمحترفين';

  @override
  String get proWidgetsDesc => 'جميع الميزات متوفرة على شاشتك الرئيسية';

  @override
  String get dataExport => 'البيانات والتصدير';

  @override
  String get advancedBackup => 'نسخ احتياطي متقدم';

  @override
  String get advancedBackupDesc => 'استيراد/تصدير آمن لجميع البيانات';

  @override
  String get pdfExport => 'تصدير إلى PDF';

  @override
  String get pdfExportDesc => 'تصدير الملاحظات واليوميات إلى PDF';

  @override
  String get printReady => 'جاهز للطباعة';

  @override
  String get printReadyDesc => 'دعم الطباعة المباشرة';

  @override
  String get richTextEditor => 'محرر نص غني';

  @override
  String get advancedSearch => 'بحث متقدم';

  @override
  String get advancedSearchDesc => 'البحث والاستبدال داخل النص';

  @override
  String get richMedia => 'وسائط غنية';

  @override
  String get richMediaDesc => 'إدراج صور وفيديوهات وروابط';

  @override
  String get editorStyling => 'تنسيق المحرر';

  @override
  String get editorStylingDesc => 'نص مخصص وخلفيات للمحرر';

  @override
  String get balance => 'الرصيد';

  @override
  String get loadingAd => 'جارٍ تحميل الإعلان...';

  @override
  String watchAd(Object amount) {
    return 'مشاهدة إعلان (+$amount)';
  }

  @override
  String get loadAd => 'تحميل إعلان';

  @override
  String get backupDataDesc => 'حفظ ملف JSON لبياناتك';

  @override
  String get importDataDesc => 'دمج ملف نسخة احتياطية في CopyClip';

  @override
  String get notificationPermissionDenied => 'تم رفض إذن الإشعارات.';

  @override
  String get typeNewTask => 'اكتب مهمة جديدة...';

  @override
  String get addTask => 'إضافة مهمة';

  @override
  String get completed => 'مكتمل';

  @override
  String get greatJob => 'عمل رائع!';

  @override
  String youEarnedXPNextTask(Object amount, Object date) {
    return 'لقد ربحت $amount XP! المهمة التالية: $date';
  }

  @override
  String taskCompletedXP(Object amount) {
    return 'تمت المهمة! +$amount XP';
  }

  @override
  String get moveTasksToRecycleBin =>
      'نقل جميع المهام النشطة إلى سلة المحذوفات؟';

  @override
  String get deleteAllPosts => 'حذف جميع المنشورات';

  @override
  String get deleteAllPostsConfirmation =>
      'هل أنت متأكد أنك تريد حذف جميع المنشورات الاجتماعية؟ لا يمكن التراجع عن هذا الإجراء.';

  @override
  String get allPosts => 'جميع المنشورات';

  @override
  String get favorites => 'المفضلة';

  @override
  String get drafts => 'المسودات';

  @override
  String get noFavoritesYet => 'لا توجد مفضلات بعد';

  @override
  String get noDraftsYet => 'لا توجد مسودات بعد';

  @override
  String get startSocialJourney => 'ابدأ رحلتك الاجتماعية!';

  @override
  String get draft => 'مسودة';

  @override
  String attachmentCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count مرفقات',
      few: '$count مرفقات',
      two: 'مرفقان',
      one: 'مرفق واحد',
      zero: 'لا توجد مرفقات',
    );
    return '$_temp0';
  }

  @override
  String get pleaseAddContent => 'يرجى إضافة بعض المحتوى أو الوسائط للمشاركة';

  @override
  String fileNotFoundError(Object path) {
    return 'خطأ: لم يتم العثور على الملف في $path';
  }

  @override
  String get checkFacebookApp => 'تحقق من تطبيق فيسبوك';

  @override
  String get systemShare => 'مشاركة النظام';

  @override
  String get socialPost => 'منشور اجتماعي';

  @override
  String get favorite => 'مفضل';

  @override
  String get saveDraft => 'حفظ المسودة';

  @override
  String get entryCopied => 'تم نسخ المدخل';

  @override
  String get moveEntriesToRecycleBin =>
      'نقل جميع المدخلات النشطة إلى سلة المحذوفات؟';

  @override
  String get startWritingStory => 'ابدأ بكتابة قصتك';

  @override
  String get recordMemories => 'سجل ذكرياتك ومشاعرك اليومية.';

  @override
  String get writeJournal => 'اكتب يومياتك';

  @override
  String get myMemories => 'ذكرياتي';

  @override
  String get sortJournal => 'فرز اليوميات';

  @override
  String get byMood => 'حسب المزاج';

  @override
  String get searchMemories => 'بحث في الذكريات...';

  @override
  String get selectAll => 'تحديد الكل';

  @override
  String get deleteSelected => 'حذف المحدد';

  @override
  String get taskCompletedExclamation => 'تمت المهمة!';

  @override
  String get taskUncompletedExclamation => 'مهمة غير مكتملة';

  @override
  String get clipboardUpdatedExclamation => 'تم تحديث الحافظة!';

  @override
  String clipboardSavedContent(Object content) {
    return 'تم حفظ في الحافظة: $content';
  }

  @override
  String get overview => 'نظرة عامة';

  @override
  String get colorAurora => 'أورورا';

  @override
  String get colorCosmic => 'كوني';

  @override
  String get colorNebula => 'سديم';

  @override
  String get colorStarlight => 'ضوء النجوم';

  @override
  String get colorSolar => 'شمسي';

  @override
  String get colorNova => 'نوفا';

  @override
  String get loadingStepLoading => 'جارٍ التحميل...';

  @override
  String get loadingStepDatabase => 'إعداد قاعدة البيانات...';

  @override
  String get loadingStepSystem => 'تكوين النظام...';

  @override
  String get loadingStepReady => 'جاهز';

  @override
  String get productivityCompanion => 'رفيقك للإنتاجية';

  @override
  String get done => 'تم';

  @override
  String get newNote => 'ملاحظة جديدة';

  @override
  String get changeColor => 'تغيير اللون';

  @override
  String get copyContent => 'نسخ المحتوى';

  @override
  String get titleOptional => 'العنوان (اختياري)';

  @override
  String get exportAsPdf => 'تصدير كـ PDF';

  @override
  String get taskDueNow => 'موعد المهمة الآن';

  @override
  String get moveTaskToBinTitle => 'نقل المهمة إلى سلة المحذوفات؟';

  @override
  String get restoreTaskLater =>
      'يمكنك استعادة هذه المهمة لاحقًا من الإعدادات.';

  @override
  String get newTask => 'مهمة جديدة';

  @override
  String get editTask => 'تعديل المهمة';

  @override
  String get undo => 'تراجع';

  @override
  String get redo => 'إعادة';

  @override
  String get category => 'الفئة';

  @override
  String get categoryHint => 'مثال: العمل، النادي';

  @override
  String get whatNeedsToBeDone => 'ما الذي يجب القيام به؟';

  @override
  String get enterTaskDetails => 'أدخل تفاصيل المهمة...';

  @override
  String get setDueDate => 'تحديد موعد الاستحقاق';

  @override
  String get dueDate => 'موعد الاستحقاق';

  @override
  String get expenseTitle => 'النفقات';

  @override
  String searchInCurrency(String currency) {
    return 'بحث في $currency...';
  }

  @override
  String get sortAndFilter => 'فرز وتصفية';

  @override
  String get sortBy => 'فرز حسب';

  @override
  String get highestAmount => 'أعلى مبلغ';

  @override
  String get lowestAmount => 'أقل مبلغ';

  @override
  String get moreFilters => 'مزيد من الفلاتر...';

  @override
  String get filterExpenses => 'تصفية النفقات';

  @override
  String get transactionType => 'نوع المعاملة';

  @override
  String get categories => 'الفئات';

  @override
  String get all => 'الكل';

  @override
  String get income => 'الدخل';

  @override
  String get expense => 'المصروفات';

  @override
  String get reset => 'إعادة تعيين';

  @override
  String get apply => 'تطبيق';

  @override
  String newExpense(String currency) {
    return 'جديد $currency';
  }

  @override
  String errorLoadingData(String error) {
    return 'حدث خطأ أثناء تحميل البيانات.\n\n$error';
  }

  @override
  String get dailyQuote1 => 'أفضل طريقة للتنبؤ بالمستقبل هي أن تصنعه.';

  @override
  String get dailyQuote2 => 'الغنى ليس في كثرة العرض، ولكن الغنى غنى النفس.';

  @override
  String get dailyQuote3 => 'الوقت هو العملة الأغلى.';

  @override
  String get dailyQuote4 => 'النجاح ليس نهائياً، والفشل ليس قاتلاً.';

  @override
  String get dailyQuote5 => 'ركز على الحل، وليس المشكلة.';

  @override
  String get dailyQuote6 => 'شبكة علاقاتك هي ثروتك الحقيقية.';

  @override
  String get moodHappy => 'سعيد';

  @override
  String get moodExcited => 'متحمس';

  @override
  String get moodNeutral => 'محايد';

  @override
  String get moodSad => 'حزين';

  @override
  String get moodStressed => 'متوتر';

  @override
  String exportDate(String date) {
    return '📅 $date';
  }

  @override
  String exportMood(String emoji, String mood) {
    return 'المزاج: $emoji $mood';
  }

  @override
  String exportTitle(String title) {
    return 'العنوان: $title';
  }

  @override
  String exportTags(String tags) {
    return '\nالوسوم: $tags';
  }

  @override
  String get instagram => 'إنستغرام';

  @override
  String get facebook => 'فيسبوك';

  @override
  String get tiktok => 'تيك توك';

  @override
  String get newSketch => 'رسمة جديدة';

  @override
  String get searchSketches => 'البحث في الرسومات والمجلدات...';

  @override
  String get noResultsFound => 'لم يتم العثور على نتائج';

  @override
  String get noItems => 'لا توجد عناصر';

  @override
  String get noDrawingsYet => 'لا توجد رسومات بعد';

  @override
  String get canvasIntro => 'أطلق العنان لإبداعك على اللوحة!';

  @override
  String get newCanvas => 'لوحة جديدة';

  @override
  String get rename => 'إعادة تسمية';

  @override
  String get deleteFolder => 'حذف المجلد';

  @override
  String get deleteSketchesQuestion => 'حذف الرسومات؟';

  @override
  String get deleteFolderConfirmation =>
      'سيتم حذف جميع الرسومات في هذا المجلد نهائياً.';

  @override
  String get renameFolder => 'إعادة تسمية المجلد';

  @override
  String get chooseColor => 'اختر لوناً';

  @override
  String get deleteFolderQuestion => 'حذف المجلد؟';

  @override
  String get searchClips => 'البحث في القصاصات...';

  @override
  String get clipboardEmpty => 'الحافظة فارغة';

  @override
  String get addItem => 'إضافة عنصر';

  @override
  String get clipColor => 'لون القصاصة';

  @override
  String get newClip => 'قصاصة جديدة';

  @override
  String get editClip => 'تعديل القصاصة';

  @override
  String get restoreClipLater => 'يمكنك استعادة هذه القصاصة لاحقاً.';

  @override
  String get upcomingEvents => 'الأحداث القادمة';

  @override
  String get dataDistribution => 'توزيع البيانات';

  @override
  String get taskProgress => 'تقدم المهمة';

  @override
  String get quickStats => 'إحصائيات سريعة';

  @override
  String get taskCompletion => 'إكمال المهمة';

  @override
  String get noItemsForDate => 'لا توجد عناصر لهذا التاريخ';

  @override
  String get enjoyFreeTime => 'استمتع بوقت فراغك!';

  @override
  String get searchThisDay => 'البحث في هذا اليوم...';

  @override
  String get finance => 'المالية';

  @override
  String get permanentlyDelete => 'حذف نهائي؟';

  @override
  String deleteSelectionConfirmation(int foldersCount, int sketchesCount) {
    return 'سيؤدي هذا إلى حذف $foldersCount مجلدات (ورسماتها) و $sketchesCount رسومات أخرى نهائياً.\n\nلا يمكن التراجع عن هذا الإجراء.';
  }

  @override
  String get deleteForever => 'حذف للأبد';

  @override
  String selectedCount(int count) {
    return '$count محدد';
  }

  @override
  String canvasStats(int notes, int folders) {
    return '$notes رسومات • $folders مجلدات';
  }

  @override
  String get sortItems => 'فرز العناصر';

  @override
  String get sortNameAZ => 'الاسم (أ-ي)';

  @override
  String get sortNameZA => 'الاسم (ي-أ)';

  @override
  String get createFolder => 'إنشاء مجلد';

  @override
  String get folderNameHint => 'اسم المجلد...';

  @override
  String deleteSketchesConfirmation(int count) {
    return 'حذف $count رسومات؟ لا يمكن التراجع عن هذا الإجراء.';
  }

  @override
  String get noSketchesFound => 'لم يتم العثور على رسومات';

  @override
  String get noSketchesFoundSub => 'حاول تعديل بحثك أو إنشاء رسمة جديدة.';

  @override
  String searchInFolder(String folder) {
    return 'بحث في $folder...';
  }

  @override
  String sketchesCount(int count) {
    return '$count رسومات';
  }

  @override
  String get sortSketches => 'فرز الرسومات';

  @override
  String get calendarScreenTitle => 'التقويم';

  @override
  String get dailyActivity => 'النشاط اليومي';

  @override
  String get deleteItemQuestion => 'حذف العنصر؟';

  @override
  String get deleteItemConfirmation =>
      'سيؤدي هذا إلى نقل العنصر إلى سلة المحذوفات.';

  @override
  String get moveToBinItem => 'نقل إلى السلة؟';

  @override
  String get moveToBinConfirmation => 'يمكنك استعادته لاحقاً.';

  @override
  String selectedItems(int count) {
    return '$count محدد';
  }

  @override
  String get recentClips => 'القصاصات الأخيرة';

  @override
  String get copied => 'تم النسخ!';

  @override
  String get copiedPlainText => 'تم نسخ النص المجرد';

  @override
  String get clipTheme => 'مظهر القصاصة';

  @override
  String get justNow => 'الآن';

  @override
  String minutesAgo(Object count) {
    return 'منذ $count د';
  }

  @override
  String hoursAgo(Object count) {
    return 'منذ $count س';
  }

  @override
  String daysAgo(Object count) {
    return 'منذ $count ي';
  }

  @override
  String get noTasksFound => 'لم يتم العثور على مهام.';

  @override
  String get searchTasks => 'بحث في المهام...';

  @override
  String get taskReminder => 'تذكير بالمهمة';

  @override
  String get untitledNote => 'ملاحظة بدون عنوان';

  @override
  String get dailyEntry => 'مدخل يومي';

  @override
  String get clipboardHistory => 'سجل الحافظة';

  @override
  String get deletePermanentlyContent => 'هذا الإجراء لا يمكن التراجع عنه.';

  @override
  String get emptyRecycleBinTitle => 'إفراغ سلة المحذوفات؟';

  @override
  String emptyRecycleBinContent(Object count) {
    return 'سيتم حذف جميع العناصر الـ $count نهائياً.';
  }

  @override
  String get emptyBin => 'إفراغ السلة';

  @override
  String get recycleBinEmpty => 'سلة المحذوفات فارغة';

  @override
  String get deletedItemsAppearHere => 'العناصر المحذوفة ستظهر هنا.';

  @override
  String get empty => 'فارغ';

  @override
  String get recent => 'الأخيرة';

  @override
  String categoryLabel(Object category) {
    return 'الفئة: $category';
  }

  @override
  String get general => 'عام';

  @override
  String get saveTransactionQuestion => 'هل تريد حفظ هذه المعاملة؟';

  @override
  String get fillTitleAmount => 'يرجى ملء العنوان والمبلغ';

  @override
  String get invalidAmount => 'تنسيق المبلغ غير صالح';

  @override
  String get moveTransactionToBinTitle => 'نقل المعاملة إلى سلة المحذوفات؟';

  @override
  String get restoreTransactionLater =>
      'يمكنك استعادة هذه المعاملة لاحقاً من الإعدادات.';

  @override
  String get newTransaction => 'معاملة جديدة';

  @override
  String get whatIsThisFor => 'فيما هذا؟';

  @override
  String get description => 'الوصف';

  @override
  String get daily => 'يومياً';

  @override
  String get weekly => 'أسبوعياً';

  @override
  String get monthly => 'شهرياً';

  @override
  String get yearly => 'سنوياً';

  @override
  String get totalIncome => 'إجمالي الدخل';

  @override
  String get totalExpense => 'إجمالي النفقات';

  @override
  String get analysis => 'التحليل';

  @override
  String get transactions => 'المعاملات';

  @override
  String get noExpensesFound => 'لم يتم العثور على نفقات لهذه الفترة.';

  @override
  String get netBalance => 'صافي الرصيد';

  @override
  String get topCategories => 'أبرز الفئات';

  @override
  String get spendingTrend => 'اتجاه الإنفاق';

  @override
  String get insights => 'رؤى';

  @override
  String get noExpensesRecorded => 'لم يتم تسجيل أي نفقات';

  @override
  String get trackSpendingHabits => 'تتبع عادات الإنفاق الخاصة بك بسهولة.';

  @override
  String get addExpense => 'إضافة نفقة';

  @override
  String get noDataForPeriod => 'لا توجد بيانات لهذه الفترة';

  @override
  String get budget => 'الميزانية';

  @override
  String get spent => 'تم صرفه';

  @override
  String get limit => 'الحد';

  @override
  String get overBudget => 'تجاوز الميزانية!';

  @override
  String remainingBudget(Object percent) {
    return 'متبقي $percent%';
  }

  @override
  String get savingsRate => 'معدل الادخار';

  @override
  String get healthScore => 'درجة الصحة المالية';

  @override
  String get healthScoreExplanation =>
      'هذه الدرجة تعتمد على معدل ادخارك.\n\n• ادخار > 50% = ممتاز (100)\n• ادخار 0% = متوسط (50)\n• الإنفاق > الدخل = ضعيف (<50)';

  @override
  String get ok => 'موافق';

  @override
  String get bulkImport => 'استيراد بالجملة';
}

/// The translations for Arabic, as used in the Syrian Arab Republic (`ar_SY`).
class AppLocalizationsArSy extends AppLocalizationsAr {
  AppLocalizationsArSy() : super('ar_SY');

  @override
  String get settings => 'إعدادات';

  @override
  String get language => 'لغة';

  @override
  String get systemDefault => 'النظام الافتراضي';

  @override
  String get notes => 'ملحوظات';

  @override
  String get todos => 'المهام';

  @override
  String get expenses => 'نفقات';

  @override
  String get journal => 'مجلة';

  @override
  String get calendar => 'تقويم';

  @override
  String get clipboard => 'الحافظة';

  @override
  String get canvas => 'قماش';

  @override
  String get save => 'حفظ';

  @override
  String get create => 'إنشاء';

  @override
  String get cancel => 'إلغاء';

  @override
  String get delete => 'حذف';

  @override
  String get edit => 'تعديل';

  @override
  String get share => 'مشاركة';

  @override
  String get copy => 'نسخ';

  @override
  String get unsavedChanges => 'تغييرات غير محفوظة';

  @override
  String get confirmDelete => 'تأكيد الحذف';

  @override
  String get discard => 'تجاهل';

  @override
  String get createPost => 'إنشاء منشور';

  @override
  String get post => 'منشور';

  @override
  String get postingTo => 'النشر في';

  @override
  String get whatsOnYourMind => 'ماذا يدور في ذهنك؟';

  @override
  String get pickImages => 'اختر صورًا';

  @override
  String get pickVideo => 'اختر فيديو';

  @override
  String get camera => 'كاميرا';

  @override
  String get gallery => 'معرض الصور';

  @override
  String get search => 'بحث';

  @override
  String get pleaseEnterTask => 'يرجى إدخال مهمة';

  @override
  String get deleteTask => 'حذف المهمة';

  @override
  String get selectItems => 'حدد العناصر';

  @override
  String get deleteAll => 'حذف الكل';

  @override
  String error(Object error) {
    return 'خطأ: $error';
  }

  @override
  String get orderingOnlyAvailableInAllPosts =>
      'الترتيب متاح فقط في \"جميع المنشورات\"';

  @override
  String get deletePost => 'حذف المنشور';

  @override
  String get postDeleted => 'تم حذف المنشور';

  @override
  String get premiumFeatures => 'ميزات بريميوم';

  @override
  String get manageCoinsAdsPremium =>
      'إدارة العملات والإعلانات وحالة البريميوم';

  @override
  String get themeMode => 'وضع المظهر';

  @override
  String get accentColor => 'لون التمييز';

  @override
  String get backgroundDesign => 'تصميم الخلفية';

  @override
  String get pushNotifications => 'إشعارات الدفع';

  @override
  String get recycleBin => 'سلة المحذوفات';

  @override
  String get exportData => 'تصدير البيانات';

  @override
  String get importData => 'استيراد البيانات';

  @override
  String get rateApp => 'تقييم التطبيق';

  @override
  String get sendFeedback => 'إرسال تعليقات';

  @override
  String get privacyPolicy => 'سياسة الخصوصية';

  @override
  String get version => 'الإصدار';

  @override
  String get buildNumber => 'رقم البناء';

  @override
  String get system => 'النظام';

  @override
  String get light => 'فاتح';

  @override
  String get dark => 'داكن';

  @override
  String get itemRestored => 'تمت استعادة العنصر';

  @override
  String get recycleBinCleared => 'تم إفراغ سلة المحذوفات بنجاح';

  @override
  String get allPostsDeleted => 'تم حذف جميع المنشورات';

  @override
  String get newPost => 'منشور جديد';

  @override
  String get textCopiedToClipboardFacebook =>
      'Text copied to clipboard (Facebook policy)';

  @override
  String get tiktokSharingRequiresVideoImage =>
      'تتطلب مشاركة TikTok فيديو/صورة';

  @override
  String errorSharing(Object error) {
    return 'خطأ في المشاركة: $error';
  }

  @override
  String shareToStory(Object platform) {
    return 'مشاركة في قصة $platform';
  }

  @override
  String shareToFeed(Object platform) {
    return 'مشاركة في موجز $platform';
  }

  @override
  String get unlockPermanently => 'فتح بشكل دائم';

  @override
  String get notEnoughCoins => 'لا توجد عملات كافية!';

  @override
  String youEarnedCoins(Object amount) {
    return 'لقد ربحت $amount من العملات!';
  }

  @override
  String get contentCopied => 'تم نسخ المحتوى';

  @override
  String get selectDateTime => 'حدد التاريخ والوقت';

  @override
  String get areYouSureYouWantToDeleteThisPost =>
      'هل أنت متأكد أنك تريد حذف هذا المنشور؟';

  @override
  String get socialPosts => 'منشورات اجتماعية';

  @override
  String get watchAdToEarnCoins => 'شاهد إعلانًا لربح العملات';

  @override
  String get premiumUnlocked => 'تم فتح البريميوم';

  @override
  String get removeAds => 'إزالة الإعلانات';

  @override
  String get unlimitedCloudStorage => 'تخزين سحابي غير محدود';

  @override
  String get deleteNote => 'حذف الملاحظة';

  @override
  String get shareNote => 'مشاركة الملاحظة';

  @override
  String get editNote => 'تعديل الملاحظة';

  @override
  String get searchNotes => 'البحث في الملاحظات...';

  @override
  String get noNotesFound => 'لم يتم العثور على ملاحظات';

  @override
  String get captureThoughts => 'سجل أفكارك فورا.';

  @override
  String get createNote => 'إنشاء ملاحظة';

  @override
  String get customOrder => 'ترتيب مخصص';

  @override
  String get newestFirst => 'الأحدث أولاً';

  @override
  String get oldestFirst => 'الأقدم أولاً';

  @override
  String get titleAZ => 'العنوان: أ-ي';

  @override
  String get titleZA => 'العنوان: ي-أ';

  @override
  String get deleteAllQuestion => 'حذف الكل؟';

  @override
  String get moveToRecycleBin => 'نقل جميع الملاحظات إلى سلة المحذوفات؟';

  @override
  String get moveToBinQuestion => 'نقل إلى السلة؟';

  @override
  String get restoreNoteLater => 'يمكنك استعادة هذه الملاحظة لاحقًا.';

  @override
  String get move => 'نقل';

  @override
  String get myThoughts => 'أفكاري';

  @override
  String get selected => 'محدد';

  @override
  String get noContent => 'لا يوجد محتوى';

  @override
  String get untitled => 'بدون عنوان';

  @override
  String get chooseWallpapers => 'اختر من بين أكثر من 10 خلفيات ديناميكية';

  @override
  String get backupData => 'نسخ احتياطي للبيانات';

  @override
  String get saveJsonFile => 'هل تريد حفظ ملف JSON يحتوي على جميع بياناتك؟';

  @override
  String get exportNow => 'تصدير الآن';

  @override
  String get importDataTitle => 'استيراد البيانات';

  @override
  String get mergeBackupFile =>
      'هل تريد دمج ملف النسخ الاحتياطي مع العناصر الحالية؟';

  @override
  String get selectFile => 'حدد ملفاً';

  @override
  String get backupSaved => 'تم حفظ النسخة الاحتياطية بنجاح!';

  @override
  String get exportFailed => 'فشل التصدير.';

  @override
  String importSuccess(Object count) {
    return 'تمت استعادة $count من العناصر بنجاح!';
  }

  @override
  String get importFailed => 'فشل الاستيراد.';

  @override
  String widgetAdded(String widget) {
    return 'تمت إضافة الأداة $widget إلى الشاشة الرئيسية!';
  }

  @override
  String get widgetRequestSent =>
      'تم إرسال طلب الأداة. يرجى التحقق من الشاشة الرئيسية.';

  @override
  String get widgetAddFailed => 'فشل إضافة الأداة';

  @override
  String get autoSaveEnabled => 'تم تفعيل الحفظ التلقائي.';

  @override
  String get autoSaveDisabled => 'تم تعطيل الحفظ التلقائي.';

  @override
  String get homeScreenWidgets => 'أدوات الشاشة الرئيسية';

  @override
  String get notificationsTitle => 'الإشعارات';

  @override
  String get dataBackup => 'البيانات والنسخ الاحتياطي';

  @override
  String get feedbackSupport => 'التعليقات والدعم';

  @override
  String get creditsTitle => 'الاعتمادات';

  @override
  String get privacyMaintenance => 'الخصوصية والصيانة';

  @override
  String get aboutTitle => 'حول';

  @override
  String get premium => 'بريميوم';

  @override
  String get appearanceTitle => 'المظهر';

  @override
  String get clipboardTitle => 'الحافظة';

  @override
  String get settingsSubtitle => 'تخصيص تجربتك';

  @override
  String get welcomeTitle => 'مرحبًا بك في CopyClip';

  @override
  String get welcomeDescription =>
      'رفيقك النهائي للإنتاجية. دعنا نجهزك بأدوات قوية لإدارة يومك.';

  @override
  String get onboardingNotesTitle => 'ملاحظات ذكية';

  @override
  String get onboardingNotesDesc =>
      'التقط الأفكار فورًا بتنسيق نص غني. نظم أفكارك ولا تفقد أي فكرة رائعة مرة أخرى.';

  @override
  String get onboardingTodosTitle => 'إدارة المهام';

  @override
  String get onboardingTodosDesc =>
      'ابق مطلعاً على أمورك. أنشئ قوائم مهام، وحدد الأولويات، وحقق أهدافك خطوة بخطوة.';

  @override
  String get onboardingExpensesTitle => 'تتبع النفقات';

  @override
  String get onboardingExpensesDesc =>
      'تحكم في أموالك. تتبع الدخل والنفقات بسهولة لفهم عادات الإنفاق الخاصة بك.';

  @override
  String get onboardingJournalTitle => 'يوميات شخصية';

  @override
  String get onboardingJournalDesc =>
      'تأمل في يومك. مساحة خاصة لتدوين ذكرياتك ومشاعرك وتجاربك اليومية.';

  @override
  String get onboardingCalendarTitle => 'التقويم والأحداث';

  @override
  String get onboardingCalendarDesc =>
      'لا تفوت أي لحظة. نظم جدولك وتابع الأحداث الهامة القادمة.';

  @override
  String get onboardingClipboardTitle => 'مدير الحافظة';

  @override
  String get onboardingClipboardDesc =>
      'انسخ مرة واحدة، والصق في أي مكان. الوصول إلى سجل الحافظة لاستعادة النصوص التي نسختها سابقاً.';

  @override
  String get onboardingCanvasTitle => 'لوحة إبداعية';

  @override
  String get onboardingCanvasDesc =>
      'أطلق العنان لإبداعك. ارسم وخطط وصور أفكارك على لوحة رقمية حرة.';

  @override
  String get featuresNotesDesc => 'إنشاء وإدارة الملاحظات الخاصة بك';

  @override
  String get featuresTodosDesc => 'تتبع المهام الخاصة بك';

  @override
  String get featuresExpensesDesc => 'مراقبة النفقات الخاصة بك';

  @override
  String get featuresJournalDesc => 'اكتتب أفكارك';

  @override
  String get featuresCalendarDesc => 'نظم جدولك الزمني';

  @override
  String get featuresClipboardDesc => 'الوصول إلى سجل الحافظة الخاص بك';

  @override
  String get featuresCanvasDesc => 'ارسم وخطط بحرية';

  @override
  String get featuresSocialPost => 'منشور اجتماعي';

  @override
  String get featuresSocialPostDesc =>
      'إنشاء محتوى جذاب لوسائل التواصل الاجتماعي';

  @override
  String get chooseYourAura => 'اختر هالتك';

  @override
  String get expressYourselfTheme => 'عبر عن نفسك بلون مظهر جديد!';

  @override
  String get level => 'المستوى';

  @override
  String get xpToNextLevel => 'XP للمستوى التالي';

  @override
  String get checkUpcomingEvents => 'تحقق من الأحداث القادمة';

  @override
  String get startNewSketch => 'بدأ رسمة جديدة';

  @override
  String get noTransactionsMonth => 'لا توجد معاملات هذا الشهر';

  @override
  String transactionsThisMonth(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count معاملات هذا الشهر',
      few: '$count معاملات هذا الشهر',
      two: 'معاملتان هذا الشهر',
      one: 'معاملة واحدة هذا الشهر',
      zero: 'لا توجد معاملات هذا الشهر',
    );
    return '$_temp0';
  }

  @override
  String get autoSaveClipboard => 'حفظ تلقائي للحافظة';

  @override
  String get autoSaveClipboardDesc => 'حفظ العناصر المنسوخة تلقائياً';

  @override
  String get permissionDeniedSettings =>
      'تم رفض الإذن بشكل دائم. يرجى تفعيله من الإعدادات.';

  @override
  String get notificationsEnabled => 'تم تفعيل الإشعارات!';

  @override
  String get redirectingToSettings =>
      'جارٍ التوجيه إلى الإعدادات لتعطيل الإشعارات...';

  @override
  String get premiumAccess => 'وصول بريميوم';

  @override
  String get premiumActiveUntil => 'بريميوم نشط حتى';

  @override
  String get unlockAllFeatures => 'فتح جميع الميزات';

  @override
  String get buyPremium => 'شراء بريميوم (7 أيام)';

  @override
  String costCoins(Object cost) {
    return 'التكلفة: $cost عملات';
  }

  @override
  String get premiumActivated => 'تم تفعيل البريميوم لمدة 7 أيام!';

  @override
  String get premiumActive => 'البريميوم نشط';

  @override
  String get expires => 'تنتهي الصلاحية:';

  @override
  String get temporaryAccess => 'وصول مؤقت';

  @override
  String get journalExpression => 'يوميات وتعبير';

  @override
  String get artisticDesigns => 'تصاميم فنية';

  @override
  String get artisticDesignsDesc =>
      'فتح أكثر من 10 مظاهر فريدة لبطاقات اليوميات';

  @override
  String get premiumLayouts => 'تخطيطات بريميوم';

  @override
  String get premiumLayoutsDesc => 'طرق حصرية لعرض ذكرياتك';

  @override
  String get calendarTools => 'تقويم وأدوات';

  @override
  String get fullCalendar => 'تقويم كامل';

  @override
  String get fullCalendarDesc => 'نظام متكامل لإدارة الأحداث';

  @override
  String get clipboardAutoSaveDesc => 'التقاط سجل الحافظة في الخلفية';

  @override
  String get proWidgets => 'أدوات ذكية للمحترفين';

  @override
  String get proWidgetsDesc => 'جميع الميزات متوفرة على شاشتك الرئيسية';

  @override
  String get dataExport => 'البيانات والتصدير';

  @override
  String get advancedBackup => 'نسخ احتياطي متقدم';

  @override
  String get advancedBackupDesc => 'استيراد/تصدير آمن لجميع البيانات';

  @override
  String get pdfExport => 'تصدير إلى PDF';

  @override
  String get pdfExportDesc => 'تصدير الملاحظات واليوميات إلى PDF';

  @override
  String get printReady => 'جاهز للطباعة';

  @override
  String get printReadyDesc => 'دعم الطباعة المباشرة';

  @override
  String get richTextEditor => 'محرر نص غني';

  @override
  String get advancedSearch => 'بحث متقدم';

  @override
  String get advancedSearchDesc => 'البحث والاستبدال داخل النص';

  @override
  String get richMedia => 'وسائط غنية';

  @override
  String get richMediaDesc => 'إدراج صور وفيديوهات وروابط';

  @override
  String get editorStyling => 'تنسيق المحرر';

  @override
  String get editorStylingDesc => 'نص مخصص وخلفيات للمحرر';

  @override
  String get balance => 'الرصيد';

  @override
  String get loadingAd => 'جارٍ تحميل الإعلان...';

  @override
  String watchAd(Object amount) {
    return 'مشاهدة إعلان (+$amount)';
  }

  @override
  String get loadAd => 'تحميل إعلان';

  @override
  String get backupDataDesc => 'حفظ ملف JSON لبياناتك';

  @override
  String get importDataDesc => 'دمج ملف نسخة احتياطية في CopyClip';

  @override
  String get notificationPermissionDenied => 'تم رفض إذن الإشعارات.';

  @override
  String get typeNewTask => 'اكتب مهمة جديدة...';

  @override
  String get addTask => 'إضافة مهمة';

  @override
  String get completed => 'مكتمل';

  @override
  String get greatJob => 'عمل رائع!';

  @override
  String youEarnedXPNextTask(Object amount, Object date) {
    return 'لقد ربحت $amount XP! المهمة التالية: $date';
  }

  @override
  String taskCompletedXP(Object amount) {
    return 'تمت المهمة! +$amount XP';
  }

  @override
  String get moveTasksToRecycleBin =>
      'نقل جميع المهام النشطة إلى سلة المحذوفات؟';

  @override
  String get deleteAllPosts => 'حذف جميع المنشورات';

  @override
  String get deleteAllPostsConfirmation =>
      'هل أنت متأكد أنك تريد حذف جميع المنشورات الاجتماعية؟ لا يمكن التراجع عن هذا الإجراء.';

  @override
  String get allPosts => 'جميع المنشورات';

  @override
  String get favorites => 'المفضلة';

  @override
  String get drafts => 'المسودات';

  @override
  String get noFavoritesYet => 'لا توجد مفضلات بعد';

  @override
  String get noDraftsYet => 'لا توجد مسودات بعد';

  @override
  String get startSocialJourney => 'ابدأ رحلتك الاجتماعية!';

  @override
  String get draft => 'مسودة';

  @override
  String attachmentCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count مرفقات',
      few: '$count مرفقات',
      two: 'مرفقان',
      one: 'مرفق واحد',
      zero: 'لا توجد مرفقات',
    );
    return '$_temp0';
  }

  @override
  String get pleaseAddContent => 'يرجى إضافة بعض المحتوى أو الوسائط للمشاركة';

  @override
  String fileNotFoundError(Object path) {
    return 'خطأ: لم يتم العثور على الملف في $path';
  }

  @override
  String get checkFacebookApp => 'تحقق من تطبيق فيسبوك';

  @override
  String get systemShare => 'مشاركة النظام';

  @override
  String get socialPost => 'منشور اجتماعي';

  @override
  String get favorite => 'مفضل';

  @override
  String get saveDraft => 'حفظ المسودة';

  @override
  String get entryCopied => 'تم نسخ المدخل';

  @override
  String get moveEntriesToRecycleBin =>
      'نقل جميع المدخلات النشطة إلى سلة المحذوفات؟';

  @override
  String get startWritingStory => 'ابدأ بكتابة قصتك';

  @override
  String get recordMemories => 'سجل ذكرياتك ومشاعرك اليومية.';

  @override
  String get writeJournal => 'اكتب يومياتك';

  @override
  String get myMemories => 'ذكرياتي';

  @override
  String get sortJournal => 'فرز اليوميات';

  @override
  String get byMood => 'حسب المزاج';

  @override
  String get searchMemories => 'بحث في الذكريات...';

  @override
  String get selectAll => 'تحديد الكل';

  @override
  String get deleteSelected => 'حذف المحدد';

  @override
  String get taskCompletedExclamation => 'تمت المهمة!';

  @override
  String get taskUncompletedExclamation => 'مهمة غير مكتملة';

  @override
  String get clipboardUpdatedExclamation => 'تم تحديث الحافظة!';

  @override
  String clipboardSavedContent(Object content) {
    return 'تم حفظ في الحافظة: $content';
  }

  @override
  String get overview => 'نظرة عامة';

  @override
  String get colorAurora => 'أورورا';

  @override
  String get colorCosmic => 'كوني';

  @override
  String get colorNebula => 'سديم';

  @override
  String get colorStarlight => 'ضوء النجوم';

  @override
  String get colorSolar => 'شمسي';

  @override
  String get colorNova => 'نوفا';

  @override
  String get loadingStepLoading => 'جارٍ التحميل...';

  @override
  String get loadingStepDatabase => 'إعداد قاعدة البيانات...';

  @override
  String get loadingStepSystem => 'تكوين النظام...';

  @override
  String get loadingStepReady => 'جاهز';

  @override
  String get productivityCompanion => 'رفيقك للإنتاجية';

  @override
  String get done => 'تم';

  @override
  String get newNote => 'ملاحظة جديدة';

  @override
  String get changeColor => 'تغيير اللون';

  @override
  String get copyContent => 'نسخ المحتوى';

  @override
  String get titleOptional => 'العنوان (اختياري)';

  @override
  String get exportAsPdf => 'تصدير كـ PDF';

  @override
  String get taskDueNow => 'موعد المهمة الآن';

  @override
  String get moveTaskToBinTitle => 'نقل المهمة إلى سلة المحذوفات؟';

  @override
  String get restoreTaskLater =>
      'يمكنك استعادة هذه المهمة لاحقًا من الإعدادات.';

  @override
  String get newTask => 'مهمة جديدة';

  @override
  String get editTask => 'تعديل المهمة';

  @override
  String get undo => 'تراجع';

  @override
  String get redo => 'إعادة';

  @override
  String get category => 'الفئة';

  @override
  String get categoryHint => 'مثال: العمل، النادي';

  @override
  String get whatNeedsToBeDone => 'ما الذي يجب القيام به؟';

  @override
  String get enterTaskDetails => 'أدخل تفاصيل المهمة...';

  @override
  String get setDueDate => 'تحديد موعد الاستحقاق';

  @override
  String get dueDate => 'موعد الاستحقاق';

  @override
  String get expenseTitle => 'النفقات';

  @override
  String searchInCurrency(String currency) {
    return 'بحث في $currency...';
  }

  @override
  String get sortAndFilter => 'فرز وتصفية';

  @override
  String get sortBy => 'فرز حسب';

  @override
  String get highestAmount => 'أعلى مبلغ';

  @override
  String get lowestAmount => 'أقل مبلغ';

  @override
  String get moreFilters => 'مزيد من الفلاتر...';

  @override
  String get filterExpenses => 'تصفية النفقات';

  @override
  String get transactionType => 'نوع المعاملة';

  @override
  String get categories => 'الفئات';

  @override
  String get all => 'الكل';

  @override
  String get income => 'الدخل';

  @override
  String get expense => 'المصروفات';

  @override
  String get reset => 'إعادة تعيين';

  @override
  String get apply => 'تطبيق';

  @override
  String newExpense(String currency) {
    return 'جديد $currency';
  }

  @override
  String errorLoadingData(String error) {
    return 'حدث خطأ أثناء تحميل البيانات.\n\n$error';
  }

  @override
  String get dailyQuote1 => 'أفضل طريقة للتنبؤ بالمستقبل هي أن تصنعه.';

  @override
  String get dailyQuote2 => 'الغنى ليس في كثرة العرض، ولكن الغنى غنى النفس.';

  @override
  String get dailyQuote3 => 'الوقت هو العملة الأغلى.';

  @override
  String get dailyQuote4 => 'النجاح ليس نهائياً، والفشل ليس قاتلاً.';

  @override
  String get dailyQuote5 => 'ركز على الحل، وليس المشكلة.';

  @override
  String get dailyQuote6 => 'شبكة علاقاتك هي ثروتك الحقيقية.';

  @override
  String get moodHappy => 'سعيد';

  @override
  String get moodExcited => 'متحمس';

  @override
  String get moodNeutral => 'محايد';

  @override
  String get moodSad => 'حزين';

  @override
  String get moodStressed => 'متوتر';

  @override
  String exportDate(String date) {
    return '📅 $date';
  }

  @override
  String exportMood(String emoji, String mood) {
    return 'المزاج: $emoji $mood';
  }

  @override
  String exportTitle(String title) {
    return 'العنوان: $title';
  }

  @override
  String exportTags(String tags) {
    return '\nالوسوم: $tags';
  }

  @override
  String get instagram => 'إنستغرام';

  @override
  String get facebook => 'فيسبوك';

  @override
  String get tiktok => 'تيك توك';

  @override
  String get newSketch => 'رسمة جديدة';

  @override
  String get searchSketches => 'البحث في الرسومات والمجلدات...';

  @override
  String get noResultsFound => 'لم يتم العثور على نتائج';

  @override
  String get noItems => 'لا توجد عناصر';

  @override
  String get noDrawingsYet => 'لا توجد رسومات بعد';

  @override
  String get canvasIntro => 'أطلق العنان لإبداعك على اللوحة!';

  @override
  String get newCanvas => 'لوحة جديدة';

  @override
  String get rename => 'إعادة تسمية';

  @override
  String get deleteFolder => 'حذف المجلد';

  @override
  String get deleteSketchesQuestion => 'حذف الرسومات؟';

  @override
  String get deleteFolderConfirmation =>
      'سيتم حذف جميع الرسومات في هذا المجلد نهائياً.';

  @override
  String get renameFolder => 'إعادة تسمية المجلد';

  @override
  String get chooseColor => 'اختر لوناً';

  @override
  String get deleteFolderQuestion => 'حذف المجلد؟';

  @override
  String get searchClips => 'البحث في القصاصات...';

  @override
  String get clipboardEmpty => 'الحافظة فارغة';

  @override
  String get addItem => 'إضافة عنصر';

  @override
  String get clipColor => 'لون القصاصة';

  @override
  String get newClip => 'قصاصة جديدة';

  @override
  String get editClip => 'تعديل القصاصة';

  @override
  String get restoreClipLater => 'يمكنك استعادة هذه القصاصة لاحقاً.';

  @override
  String get upcomingEvents => 'الأحداث القادمة';

  @override
  String get dataDistribution => 'توزيع البيانات';

  @override
  String get taskProgress => 'تقدم المهمة';

  @override
  String get quickStats => 'إحصائيات سريعة';

  @override
  String get taskCompletion => 'إكمال المهمة';

  @override
  String get noItemsForDate => 'لا توجد عناصر لهذا التاريخ';

  @override
  String get enjoyFreeTime => 'استمتع بوقت فراغك!';

  @override
  String get searchThisDay => 'البحث في هذا اليوم...';

  @override
  String get finance => 'المالية';

  @override
  String get permanentlyDelete => 'حذف نهائي؟';

  @override
  String deleteSelectionConfirmation(int foldersCount, int sketchesCount) {
    return 'سيؤدي هذا إلى حذف $foldersCount مجلدات (ورسماتها) و $sketchesCount رسومات أخرى نهائياً.\n\nلا يمكن التراجع عن هذا الإجراء.';
  }

  @override
  String get deleteForever => 'حذف للأبد';

  @override
  String selectedCount(int count) {
    return '$count محدد';
  }

  @override
  String canvasStats(int notes, int folders) {
    return '$notes رسومات • $folders مجلدات';
  }

  @override
  String get sortItems => 'فرز العناصر';

  @override
  String get sortNameAZ => 'الاسم (أ-ي)';

  @override
  String get sortNameZA => 'الاسم (ي-أ)';

  @override
  String get createFolder => 'إنشاء مجلد';

  @override
  String get folderNameHint => 'اسم المجلد...';

  @override
  String deleteSketchesConfirmation(int count) {
    return 'حذف $count رسومات؟ لا يمكن التراجع عن هذا الإجراء.';
  }

  @override
  String get noSketchesFound => 'لم يتم العثور على رسومات';

  @override
  String get noSketchesFoundSub => 'حاول تعديل بحثك أو إنشاء رسمة جديدة.';

  @override
  String searchInFolder(String folder) {
    return 'بحث في $folder...';
  }

  @override
  String sketchesCount(int count) {
    return '$count رسومات';
  }

  @override
  String get sortSketches => 'فرز الرسومات';

  @override
  String get calendarScreenTitle => 'التقويم';

  @override
  String get dailyActivity => 'النشاط اليومي';

  @override
  String get deleteItemQuestion => 'حذف العنصر؟';

  @override
  String get deleteItemConfirmation =>
      'سيؤدي هذا إلى نقل العنصر إلى سلة المحذوفات.';

  @override
  String get moveToBinItem => 'نقل إلى السلة؟';

  @override
  String get moveToBinConfirmation => 'يمكنك استعادته لاحقاً.';

  @override
  String selectedItems(int count) {
    return '$count محدد';
  }

  @override
  String get recentClips => 'القصاصات الأخيرة';

  @override
  String get copied => 'تم النسخ!';

  @override
  String get copiedPlainText => 'تم نسخ النص المجرد';

  @override
  String get clipTheme => 'مظهر القصاصة';

  @override
  String get justNow => 'الآن';

  @override
  String minutesAgo(Object count) {
    return 'منذ $count د';
  }

  @override
  String hoursAgo(Object count) {
    return 'منذ $count س';
  }

  @override
  String daysAgo(Object count) {
    return 'منذ $count ي';
  }

  @override
  String get noTasksFound => 'لم يتم العثور على مهام.';

  @override
  String get searchTasks => 'بحث في المهام...';

  @override
  String get taskReminder => 'تذكير بالمهمة';

  @override
  String get untitledNote => 'ملاحظة بدون عنوان';

  @override
  String get dailyEntry => 'مدخل يومي';

  @override
  String get clipboardHistory => 'سجل الحافظة';

  @override
  String get deletePermanentlyContent => 'هذا الإجراء لا يمكن التراجع عنه.';

  @override
  String get emptyRecycleBinTitle => 'إفراغ سلة المحذوفات؟';

  @override
  String emptyRecycleBinContent(Object count) {
    return 'سيتم حذف جميع العناصر الـ $count نهائياً.';
  }

  @override
  String get emptyBin => 'إفراغ السلة';

  @override
  String get recycleBinEmpty => 'سلة المحذوفات فارغة';

  @override
  String get deletedItemsAppearHere => 'العناصر المحذوفة ستظهر هنا.';

  @override
  String get empty => 'فارغ';

  @override
  String get recent => 'الأخيرة';

  @override
  String categoryLabel(Object category) {
    return 'الفئة: $category';
  }

  @override
  String get general => 'عام';

  @override
  String get saveTransactionQuestion => 'هل تريد حفظ هذه المعاملة؟';

  @override
  String get fillTitleAmount => 'يرجى ملء العنوان والمبلغ';

  @override
  String get invalidAmount => 'تنسيق المبلغ غير صالح';

  @override
  String get moveTransactionToBinTitle => 'نقل المعاملة إلى سلة المحذوفات؟';

  @override
  String get restoreTransactionLater =>
      'يمكنك استعادة هذه المعاملة لاحقاً من الإعدادات.';

  @override
  String get newTransaction => 'معاملة جديدة';

  @override
  String get whatIsThisFor => 'فيما هذا؟';

  @override
  String get description => 'الوصف';

  @override
  String get daily => 'يومياً';

  @override
  String get weekly => 'أسبوعياً';

  @override
  String get monthly => 'شهرياً';

  @override
  String get yearly => 'سنوياً';

  @override
  String get totalIncome => 'إجمالي الدخل';

  @override
  String get totalExpense => 'إجمالي النفقات';

  @override
  String get analysis => 'التحليل';

  @override
  String get transactions => 'المعاملات';

  @override
  String get noExpensesFound => 'لم يتم العثور على نفقات لهذه الفترة.';

  @override
  String get netBalance => 'صافي الرصيد';

  @override
  String get topCategories => 'أبرز الفئات';

  @override
  String get spendingTrend => 'اتجاه الإنفاق';

  @override
  String get insights => 'رؤى';

  @override
  String get noExpensesRecorded => 'لم يتم تسجيل أي نفقات';

  @override
  String get trackSpendingHabits => 'تتبع عادات الإنفاق الخاصة بك بسهولة.';

  @override
  String get addExpense => 'إضافة نفقة';

  @override
  String get noDataForPeriod => 'لا توجد بيانات لهذه الفترة';

  @override
  String get budget => 'الميزانية';

  @override
  String get spent => 'تم صرفه';

  @override
  String get limit => 'الحد';

  @override
  String get overBudget => 'تجاوز الميزانية!';

  @override
  String remainingBudget(Object percent) {
    return 'متبقي $percent%';
  }

  @override
  String get savingsRate => 'معدل الادخار';

  @override
  String get healthScore => 'درجة الصحة المالية';

  @override
  String get healthScoreExplanation =>
      'هذه الدرجة تعتمد على معدل ادخارك.\n\n• ادخار > 50% = ممتاز (100)\n• ادخار 0% = متوسط (50)\n• الإنفاق > الدخل = ضعيف (<50)';

  @override
  String get ok => 'موافق';

  @override
  String get bulkImport => 'استيراد بالجملة';
}

/// The translations for Arabic, as used in Tunisia (`ar_TN`).
class AppLocalizationsArTn extends AppLocalizationsAr {
  AppLocalizationsArTn() : super('ar_TN');

  @override
  String get settings => 'إعدادات';

  @override
  String get language => 'لغة';

  @override
  String get systemDefault => 'النظام الافتراضي';

  @override
  String get notes => 'ملحوظات';

  @override
  String get todos => 'المهام';

  @override
  String get expenses => 'نفقات';

  @override
  String get journal => 'مجلة';

  @override
  String get calendar => 'تقويم';

  @override
  String get clipboard => 'الحافظة';

  @override
  String get canvas => 'قماش';

  @override
  String get save => 'حفظ';

  @override
  String get create => 'إنشاء';

  @override
  String get cancel => 'إلغاء';

  @override
  String get delete => 'حذف';

  @override
  String get edit => 'تعديل';

  @override
  String get share => 'مشاركة';

  @override
  String get copy => 'نسخ';

  @override
  String get unsavedChanges => 'تغييرات غير محفوظة';

  @override
  String get confirmDelete => 'تأكيد الحذف';

  @override
  String get discard => 'تجاهل';

  @override
  String get createPost => 'إنشاء منشور';

  @override
  String get post => 'منشور';

  @override
  String get postingTo => 'النشر في';

  @override
  String get whatsOnYourMind => 'ماذا يدور في ذهنك؟';

  @override
  String get pickImages => 'اختر صورًا';

  @override
  String get pickVideo => 'اختر فيديو';

  @override
  String get camera => 'كاميرا';

  @override
  String get gallery => 'معرض الصور';

  @override
  String get search => 'بحث';

  @override
  String get pleaseEnterTask => 'يرجى إدخال مهمة';

  @override
  String get deleteTask => 'حذف المهمة';

  @override
  String get selectItems => 'حدد العناصر';

  @override
  String get deleteAll => 'حذف الكل';

  @override
  String error(Object error) {
    return 'خطأ: $error';
  }

  @override
  String get orderingOnlyAvailableInAllPosts =>
      'Ordering only available in \'\'All Posts\'\'';

  @override
  String get deletePost => 'حذف المنشور';

  @override
  String get postDeleted => 'تم حذف المنشور';

  @override
  String get premiumFeatures => 'ميزات بريميوم';

  @override
  String get manageCoinsAdsPremium =>
      'إدارة العملات والإعلانات وحالة البريميوم';

  @override
  String get themeMode => 'وضع المظهر';

  @override
  String get accentColor => 'لون التمييز';

  @override
  String get backgroundDesign => 'تصميم الخلفية';

  @override
  String get pushNotifications => 'إشعارات الدفع';

  @override
  String get recycleBin => 'سلة المحذوفات';

  @override
  String get exportData => 'تصدير البيانات';

  @override
  String get importData => 'استيراد البيانات';

  @override
  String get rateApp => 'تقييم التطبيق';

  @override
  String get sendFeedback => 'إرسال تعليقات';

  @override
  String get privacyPolicy => 'سياسة الخصوصية';

  @override
  String get version => 'الإصدار';

  @override
  String get buildNumber => 'رقم البناء';

  @override
  String get system => 'النظام';

  @override
  String get light => 'فاتح';

  @override
  String get dark => 'داكن';

  @override
  String get itemRestored => 'تمت استعادة العنصر';

  @override
  String get recycleBinCleared => 'تم إفراغ سلة المحذوفات بنجاح';

  @override
  String get allPostsDeleted => 'تم حذف جميع المنشورات';

  @override
  String get newPost => 'منشور جديد';

  @override
  String get textCopiedToClipboardFacebook =>
      'Text copied to clipboard (Facebook policy)';

  @override
  String get tiktokSharingRequiresVideoImage =>
      'تتطلب مشاركة TikTok فيديو/صورة';

  @override
  String errorSharing(Object error) {
    return 'خطأ في المشاركة: $error';
  }

  @override
  String shareToStory(Object platform) {
    return 'مشاركة في قصة $platform';
  }

  @override
  String shareToFeed(Object platform) {
    return 'مشاركة في موجز $platform';
  }

  @override
  String get unlockPermanently => 'فتح بشكل دائم';

  @override
  String get notEnoughCoins => 'لا توجد عملات كافية!';

  @override
  String youEarnedCoins(Object amount) {
    return 'لقد ربحت $amount من العملات!';
  }

  @override
  String get contentCopied => 'تم نسخ المحتوى';

  @override
  String get selectDateTime => 'حدد التاريخ والوقت';

  @override
  String get areYouSureYouWantToDeleteThisPost =>
      'هل أنت متأكد أنك تريد حذف هذا المنشور؟';

  @override
  String get socialPosts => 'منشورات اجتماعية';

  @override
  String get watchAdToEarnCoins => 'شاهد إعلانًا لربح العملات';

  @override
  String get premiumUnlocked => 'تم فتح البريميوم';

  @override
  String get removeAds => 'إزالة الإعلانات';

  @override
  String get unlimitedCloudStorage => 'تخزين سحابي غير محدود';

  @override
  String get deleteNote => 'حذف الملاحظة';

  @override
  String get shareNote => 'مشاركة الملاحظة';

  @override
  String get editNote => 'تعديل الملاحظة';

  @override
  String get searchNotes => 'البحث في الملاحظات...';

  @override
  String get noNotesFound => 'لم يتم العثور على ملاحظات';

  @override
  String get captureThoughts => 'سجل أفكارك فورا.';

  @override
  String get createNote => 'إنشاء ملاحظة';

  @override
  String get customOrder => 'ترتيب مخصص';

  @override
  String get newestFirst => 'الأحدث أولاً';

  @override
  String get oldestFirst => 'الأقدم أولاً';

  @override
  String get titleAZ => 'العنوان: أ-ي';

  @override
  String get titleZA => 'العنوان: ي-أ';

  @override
  String get deleteAllQuestion => 'حذف الكل؟';

  @override
  String get moveToRecycleBin => 'نقل جميع الملاحظات إلى سلة المحذوفات؟';

  @override
  String get moveToBinQuestion => 'نقل إلى السلة؟';

  @override
  String get restoreNoteLater => 'يمكنك استعادة هذه الملاحظة لاحقًا.';

  @override
  String get move => 'نقل';

  @override
  String get myThoughts => 'أفكاري';

  @override
  String get selected => 'محدد';

  @override
  String get noContent => 'لا يوجد محتوى';

  @override
  String get untitled => 'بدون عنوان';

  @override
  String get chooseWallpapers => 'اختر من بين أكثر من 10 خلفيات ديناميكية';

  @override
  String get backupData => 'نسخ احتياطي للبيانات';

  @override
  String get saveJsonFile => 'هل تريد حفظ ملف JSON يحتوي على جميع بياناتك؟';

  @override
  String get exportNow => 'تصدير الآن';

  @override
  String get importDataTitle => 'استيراد البيانات';

  @override
  String get mergeBackupFile =>
      'هل تريد دمج ملف النسخ الاحتياطي مع العناصر الحالية؟';

  @override
  String get selectFile => 'حدد ملفاً';

  @override
  String get backupSaved => 'تم حفظ النسخة الاحتياطية بنجاح!';

  @override
  String get exportFailed => 'فشل التصدير.';

  @override
  String importSuccess(Object count) {
    return 'تمت استعادة $count من العناصر بنجاح!';
  }

  @override
  String get importFailed => 'فشل الاستيراد.';

  @override
  String widgetAdded(String widget) {
    return 'تمت إضافة الأداة $widget إلى الشاشة الرئيسية!';
  }

  @override
  String get widgetRequestSent =>
      'تم إرسال طلب الأداة. يرجى التحقق من الشاشة الرئيسية.';

  @override
  String get widgetAddFailed => 'فشل إضافة الأداة';

  @override
  String get autoSaveEnabled => 'تم تفعيل الحفظ التلقائي.';

  @override
  String get autoSaveDisabled => 'تم تعطيل الحفظ التلقائي.';

  @override
  String get homeScreenWidgets => 'أدوات الشاشة الرئيسية';

  @override
  String get notificationsTitle => 'الإشعارات';

  @override
  String get dataBackup => 'البيانات والنسخ الاحتياطي';

  @override
  String get feedbackSupport => 'التعليقات والدعم';

  @override
  String get creditsTitle => 'الاعتمادات';

  @override
  String get privacyMaintenance => 'الخصوصية والصيانة';

  @override
  String get aboutTitle => 'حول';

  @override
  String get premium => 'بريميوم';

  @override
  String get appearanceTitle => 'المظهر';

  @override
  String get clipboardTitle => 'الحافظة';

  @override
  String get settingsSubtitle => 'تخصيص تجربتك';

  @override
  String get welcomeTitle => 'مرحبًا بك في CopyClip';

  @override
  String get welcomeDescription =>
      'رفيقك النهائي للإنتاجية. دعنا نجهزك بأدوات قوية لإدارة يومك.';

  @override
  String get onboardingNotesTitle => 'ملاحظات ذكية';

  @override
  String get onboardingNotesDesc =>
      'التقط الأفكار فورًا بتنسيق نص غني. نظم أفكارك ولا تفقد أي فكرة رائعة مرة أخرى.';

  @override
  String get onboardingTodosTitle => 'إدارة المهام';

  @override
  String get onboardingTodosDesc =>
      'ابق مطلعاً على أمورك. أنشئ قوائم مهام، وحدد الأولويات، وحقق أهدافك خطوة بخطوة.';

  @override
  String get onboardingExpensesTitle => 'تتبع النفقات';

  @override
  String get onboardingExpensesDesc =>
      'تحكم في أموالك. تتبع الدخل والنفقات بسهولة لفهم عادات الإنفاق الخاصة بك.';

  @override
  String get onboardingJournalTitle => 'يوميات شخصية';

  @override
  String get onboardingJournalDesc =>
      'تأمل في يومك. مساحة خاصة لتدوين ذكرياتك ومشاعرك وتجاربك اليومية.';

  @override
  String get onboardingCalendarTitle => 'التقويم والأحداث';

  @override
  String get onboardingCalendarDesc =>
      'لا تفوت أي لحظة. نظم جدولك وتابع الأحداث الهامة القادمة.';

  @override
  String get onboardingClipboardTitle => 'مدير الحافظة';

  @override
  String get onboardingClipboardDesc =>
      'انسخ مرة واحدة، والصق في أي مكان. الوصول إلى سجل الحافظة لاستعادة النصوص التي نسختها سابقاً.';

  @override
  String get onboardingCanvasTitle => 'لوحة إبداعية';

  @override
  String get onboardingCanvasDesc =>
      'أطلق العنان لإبداعك. ارسم وخطط وصور أفكارك على لوحة رقمية حرة.';

  @override
  String get featuresNotesDesc => 'إنشاء وإدارة الملاحظات الخاصة بك';

  @override
  String get featuresTodosDesc => 'تتبع المهام الخاصة بك';

  @override
  String get featuresExpensesDesc => 'مراقبة النفقات الخاصة بك';

  @override
  String get featuresJournalDesc => 'اكتتب أفكارك';

  @override
  String get featuresCalendarDesc => 'نظم جدولك الزمني';

  @override
  String get featuresClipboardDesc => 'الوصول إلى سجل الحافظة الخاص بك';

  @override
  String get featuresCanvasDesc => 'ارسم وخطط بحرية';

  @override
  String get featuresSocialPost => 'منشور اجتماعي';

  @override
  String get featuresSocialPostDesc =>
      'إنشاء محتوى جذاب لوسائل التواصل الاجتماعي';

  @override
  String get chooseYourAura => 'اختر هالتك';

  @override
  String get expressYourselfTheme => 'عبر عن نفسك بلون مظهر جديد!';

  @override
  String get level => 'المستوى';

  @override
  String get xpToNextLevel => 'XP للمستوى التالي';

  @override
  String get checkUpcomingEvents => 'تحقق من الأحداث القادمة';

  @override
  String get startNewSketch => 'بدأ رسمة جديدة';

  @override
  String get noTransactionsMonth => 'لا توجد معاملات هذا الشهر';

  @override
  String transactionsThisMonth(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count معاملات هذا الشهر',
      few: '$count معاملات هذا الشهر',
      two: 'معاملتان هذا الشهر',
      one: 'معاملة واحدة هذا الشهر',
      zero: 'لا توجد معاملات هذا الشهر',
    );
    return '$_temp0';
  }

  @override
  String get autoSaveClipboard => 'حفظ تلقائي للحافظة';

  @override
  String get autoSaveClipboardDesc => 'حفظ العناصر المنسوخة تلقائياً';

  @override
  String get permissionDeniedSettings =>
      'تم رفض الإذن بشكل دائم. يرجى تفعيله من الإعدادات.';

  @override
  String get notificationsEnabled => 'تم تفعيل الإشعارات!';

  @override
  String get redirectingToSettings =>
      'جارٍ التوجيه إلى الإعدادات لتعطيل الإشعارات...';

  @override
  String get premiumAccess => 'وصول بريميوم';

  @override
  String get premiumActiveUntil => 'بريميوم نشط حتى';

  @override
  String get unlockAllFeatures => 'فتح جميع الميزات';

  @override
  String get buyPremium => 'شراء بريميوم (7 أيام)';

  @override
  String costCoins(Object cost) {
    return 'التكلفة: $cost عملات';
  }

  @override
  String get premiumActivated => 'تم تفعيل البريميوم لمدة 7 أيام!';

  @override
  String get premiumActive => 'البريميوم نشط';

  @override
  String get expires => 'تنتهي الصلاحية:';

  @override
  String get temporaryAccess => 'وصول مؤقت';

  @override
  String get journalExpression => 'يوميات وتعبير';

  @override
  String get artisticDesigns => 'تصاميم فنية';

  @override
  String get artisticDesignsDesc =>
      'فتح أكثر من 10 مظاهر فريدة لبطاقات اليوميات';

  @override
  String get premiumLayouts => 'تخطيطات بريميوم';

  @override
  String get premiumLayoutsDesc => 'طرق حصرية لعرض ذكرياتك';

  @override
  String get calendarTools => 'تقويم وأدوات';

  @override
  String get fullCalendar => 'تقويم كامل';

  @override
  String get fullCalendarDesc => 'نظام متكامل لإدارة الأحداث';

  @override
  String get clipboardAutoSaveDesc => 'التقاط سجل الحافظة في الخلفية';

  @override
  String get proWidgets => 'أدوات ذكية للمحترفين';

  @override
  String get proWidgetsDesc => 'جميع الميزات متوفرة على شاشتك الرئيسية';

  @override
  String get dataExport => 'البيانات والتصدير';

  @override
  String get advancedBackup => 'نسخ احتياطي متقدم';

  @override
  String get advancedBackupDesc => 'استيراد/تصدير آمن لجميع البيانات';

  @override
  String get pdfExport => 'تصدير إلى PDF';

  @override
  String get pdfExportDesc => 'تصدير الملاحظات واليوميات إلى PDF';

  @override
  String get printReady => 'جاهز للطباعة';

  @override
  String get printReadyDesc => 'دعم الطباعة المباشرة';

  @override
  String get richTextEditor => 'محرر نص غني';

  @override
  String get advancedSearch => 'بحث متقدم';

  @override
  String get advancedSearchDesc => 'البحث والاستبدال داخل النص';

  @override
  String get richMedia => 'وسائط غنية';

  @override
  String get richMediaDesc => 'إدراج صور وفيديوهات وروابط';

  @override
  String get editorStyling => 'تنسيق المحرر';

  @override
  String get editorStylingDesc => 'نص مخصص وخلفيات للمحرر';

  @override
  String get balance => 'الرصيد';

  @override
  String get loadingAd => 'جارٍ تحميل الإعلان...';

  @override
  String watchAd(Object amount) {
    return 'مشاهدة إعلان (+$amount)';
  }

  @override
  String get loadAd => 'تحميل إعلان';

  @override
  String get backupDataDesc => 'حفظ ملف JSON لبياناتك';

  @override
  String get importDataDesc => 'دمج ملف نسخة احتياطية في CopyClip';

  @override
  String get notificationPermissionDenied => 'تم رفض إذن الإشعارات.';

  @override
  String get typeNewTask => 'اكتب مهمة جديدة...';

  @override
  String get addTask => 'إضافة مهمة';

  @override
  String get completed => 'مكتمل';

  @override
  String get greatJob => 'عمل رائع!';

  @override
  String youEarnedXPNextTask(Object amount, Object date) {
    return 'لقد ربحت $amount XP! المهمة التالية: $date';
  }

  @override
  String taskCompletedXP(Object amount) {
    return 'تمت المهمة! +$amount XP';
  }

  @override
  String get moveTasksToRecycleBin =>
      'نقل جميع المهام النشطة إلى سلة المحذوفات؟';

  @override
  String get deleteAllPosts => 'حذف جميع المنشورات';

  @override
  String get deleteAllPostsConfirmation =>
      'هل أنت متأكد أنك تريد حذف جميع المنشورات الاجتماعية؟ لا يمكن التراجع عن هذا الإجراء.';

  @override
  String get allPosts => 'جميع المنشورات';

  @override
  String get favorites => 'المفضلة';

  @override
  String get drafts => 'المسودات';

  @override
  String get noFavoritesYet => 'لا توجد مفضلات بعد';

  @override
  String get noDraftsYet => 'لا توجد مسودات بعد';

  @override
  String get startSocialJourney => 'Start your social journey!';

  @override
  String get draft => 'مسودة';

  @override
  String attachmentCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count مرفقات',
      few: '$count مرفقات',
      two: 'مرفقان',
      one: 'مرفق واحد',
      zero: 'لا توجد مرفقات',
    );
    return '$_temp0';
  }

  @override
  String get pleaseAddContent => 'يرجى إضافة بعض المحتوى أو الوسائط للمشاركة';

  @override
  String fileNotFoundError(Object path) {
    return 'خطأ: لم يتم العثور على الملف في $path';
  }

  @override
  String get checkFacebookApp => 'تحقق من تطبيق فيسبوك';

  @override
  String get systemShare => 'مشاركة النظام';

  @override
  String get socialPost => 'منشور اجتماعي';

  @override
  String get favorite => 'مفضل';

  @override
  String get saveDraft => 'حفظ المسودة';

  @override
  String get entryCopied => 'تم نسخ المدخل';

  @override
  String get moveEntriesToRecycleBin =>
      'نقل جميع المدخلات النشطة إلى سلة المحذوفات؟';

  @override
  String get startWritingStory => 'ابدأ بكتابة قصتك';

  @override
  String get recordMemories => 'سجل ذكرياتك ومشاعرك اليومية.';

  @override
  String get writeJournal => 'اكتب يومياتك';

  @override
  String get myMemories => 'ذكرياتي';

  @override
  String get sortJournal => 'فرز اليوميات';

  @override
  String get byMood => 'حسب المزاج';

  @override
  String get searchMemories => 'بحث في الذكريات...';

  @override
  String get selectAll => 'تحديد الكل';

  @override
  String get deleteSelected => 'حذف المحدد';

  @override
  String get taskCompletedExclamation => 'تمت المهمة!';

  @override
  String get taskUncompletedExclamation => 'مهمة غير مكتملة';

  @override
  String get clipboardUpdatedExclamation => 'تم تحديث الحافظة!';

  @override
  String clipboardSavedContent(Object content) {
    return 'تم حفظ في الحافظة: $content';
  }

  @override
  String get overview => 'نظرة عامة';

  @override
  String get colorAurora => 'أورورا';

  @override
  String get colorCosmic => 'كوني';

  @override
  String get colorNebula => 'سديم';

  @override
  String get colorStarlight => 'ضوء النجوم';

  @override
  String get colorSolar => 'شمسي';

  @override
  String get colorNova => 'نوفا';

  @override
  String get loadingStepLoading => 'جارٍ التحميل...';

  @override
  String get loadingStepDatabase => 'إعداد قاعدة البيانات...';

  @override
  String get loadingStepSystem => 'تكوين النظام...';

  @override
  String get loadingStepReady => 'جاهز';

  @override
  String get productivityCompanion => 'رفيقك للإنتاجية';

  @override
  String get done => 'تم';

  @override
  String get newNote => 'ملاحظة جديدة';

  @override
  String get changeColor => 'تغيير اللون';

  @override
  String get copyContent => 'نسخ المحتوى';

  @override
  String get titleOptional => 'العنوان (اختياري)';

  @override
  String get exportAsPdf => 'تصدير كـ PDF';

  @override
  String get taskDueNow => 'موعد المهمة الآن';

  @override
  String get moveTaskToBinTitle => 'نقل المهمة إلى سلة المحذوفات؟';

  @override
  String get restoreTaskLater =>
      'يمكنك استعادة هذه المهمة لاحقًا من الإعدادات.';

  @override
  String get newTask => 'مهمة جديدة';

  @override
  String get editTask => 'تعديل المهمة';

  @override
  String get undo => 'تراجع';

  @override
  String get redo => 'إعادة';

  @override
  String get category => 'الفئة';

  @override
  String get categoryHint => 'مثال: العمل، النادي';

  @override
  String get whatNeedsToBeDone => 'ما الذي يجب القيام به؟';

  @override
  String get enterTaskDetails => 'أدخل تفاصيل المهمة...';

  @override
  String get setDueDate => 'تحديد موعد الاستحقاق';

  @override
  String get dueDate => 'موعد الاستحقاق';

  @override
  String get expenseTitle => 'النفقات';

  @override
  String searchInCurrency(String currency) {
    return 'بحث في $currency...';
  }

  @override
  String get sortAndFilter => 'فرز وتصفية';

  @override
  String get sortBy => 'فرز حسب';

  @override
  String get highestAmount => 'أعلى مبلغ';

  @override
  String get lowestAmount => 'أقل مبلغ';

  @override
  String get moreFilters => 'مزيد من الفلاتر...';

  @override
  String get filterExpenses => 'تصفية النفقات';

  @override
  String get transactionType => 'نوع المعاملة';

  @override
  String get categories => 'الفئات';

  @override
  String get all => 'الكل';

  @override
  String get income => 'الدخل';

  @override
  String get expense => 'المصروفات';

  @override
  String get reset => 'إعادة تعيين';

  @override
  String get apply => 'تطبيق';

  @override
  String newExpense(String currency) {
    return 'جديد $currency';
  }

  @override
  String errorLoadingData(String error) {
    return 'حدث خطأ أثناء تحميل البيانات.\n\n$error';
  }

  @override
  String get dailyQuote1 => 'أفضل طريقة للتنبؤ بالمستقبل هي أن تصنعه.';

  @override
  String get dailyQuote2 => 'الغنى ليس في كثرة العرض، ولكن الغنى غنى النفس.';

  @override
  String get dailyQuote3 => 'الوقت هو العملة الأغلى.';

  @override
  String get dailyQuote4 => 'النجاح ليس نهائياً، والفشل ليس قاتلاً.';

  @override
  String get dailyQuote5 => 'ركز على الحل، وليس المشكلة.';

  @override
  String get dailyQuote6 => 'شبكة علاقاتك هي ثروتك الحقيقية.';

  @override
  String get moodHappy => 'Happy';

  @override
  String get moodExcited => 'متحمس';

  @override
  String get moodNeutral => 'محايد';

  @override
  String get moodSad => 'حزين';

  @override
  String get moodStressed => 'متوتر';

  @override
  String exportDate(String date) {
    return '📅 $date';
  }

  @override
  String exportMood(String emoji, String mood) {
    return 'المزاج: $emoji $mood';
  }

  @override
  String exportTitle(String title) {
    return 'العنوان: $title';
  }

  @override
  String exportTags(String tags) {
    return '\nالوسوم: $tags';
  }

  @override
  String get instagram => 'إنستغرام';

  @override
  String get facebook => 'فيسبوك';

  @override
  String get tiktok => 'تيك توك';

  @override
  String get newSketch => 'رسمة جديدة';

  @override
  String get searchSketches => 'البحث في الرسومات والمجلدات...';

  @override
  String get noResultsFound => 'لم يتم العثور على نتائج';

  @override
  String get noItems => 'لا توجد عناصر';

  @override
  String get noDrawingsYet => 'لا توجد رسومات بعد';

  @override
  String get canvasIntro => 'أطلق العنان لإبداعك على اللوحة!';

  @override
  String get newCanvas => 'لوحة جديدة';

  @override
  String get rename => 'إعادة تسمية';

  @override
  String get deleteFolder => 'حذف المجلد';

  @override
  String get deleteSketchesQuestion => 'حذف الرسومات؟';

  @override
  String get deleteFolderConfirmation =>
      'سيتم حذف جميع الرسومات في هذا المجلد نهائياً.';

  @override
  String get renameFolder => 'إعادة تسمية المجلد';

  @override
  String get chooseColor => 'اختر لوناً';

  @override
  String get deleteFolderQuestion => 'حذف المجلد؟';

  @override
  String get searchClips => 'البحث في القصاصات...';

  @override
  String get clipboardEmpty => 'الحافظة فارغة';

  @override
  String get addItem => 'إضافة عنصر';

  @override
  String get clipColor => 'لون القصاصة';

  @override
  String get newClip => 'قصاصة جديدة';

  @override
  String get editClip => 'تعديل القصاصة';

  @override
  String get restoreClipLater => 'يمكنك استعادة هذه القصاصة لاحقاً.';

  @override
  String get upcomingEvents => 'الأحداث القادمة';

  @override
  String get dataDistribution => 'توزيع البيانات';

  @override
  String get taskProgress => 'تقدم المهمة';

  @override
  String get quickStats => 'إحصائيات سريعة';

  @override
  String get taskCompletion => 'إكمال المهمة';

  @override
  String get noItemsForDate => 'لا توجد عناصر لهذا التاريخ';

  @override
  String get enjoyFreeTime => 'استمتع بوقت فراغك!';

  @override
  String get searchThisDay => 'البحث في هذا اليوم...';

  @override
  String get finance => 'المالية';

  @override
  String get permanentlyDelete => 'حذف نهائي؟';

  @override
  String deleteSelectionConfirmation(int foldersCount, int sketchesCount) {
    return 'سيؤدي هذا إلى حذف $foldersCount مجلدات (ورسماتها) و $sketchesCount رسومات أخرى نهائياً.\n\nلا يمكن التراجع عن هذا الإجراء.';
  }

  @override
  String get deleteForever => 'حذف للأبد';

  @override
  String selectedCount(int count) {
    return '$count محدد';
  }

  @override
  String canvasStats(int notes, int folders) {
    return '$notes رسومات • $folders مجلدات';
  }

  @override
  String get sortItems => 'فرز العناصر';

  @override
  String get sortNameAZ => 'الاسم (أ-ي)';

  @override
  String get sortNameZA => 'الاسم (ي-أ)';

  @override
  String get createFolder => 'إنشاء مجلد';

  @override
  String get folderNameHint => 'اسم المجلد...';

  @override
  String deleteSketchesConfirmation(int count) {
    return 'حذف $count رسومات؟ لا يمكن التراجع عن هذا الإجراء.';
  }

  @override
  String get noSketchesFound => 'لم يتم العثور على رسومات';

  @override
  String get noSketchesFoundSub => 'حاول تعديل بحثك أو إنشاء رسمة جديدة.';

  @override
  String searchInFolder(String folder) {
    return 'بحث في $folder...';
  }

  @override
  String sketchesCount(int count) {
    return '$count رسومات';
  }

  @override
  String get sortSketches => 'فرز الرسومات';

  @override
  String get calendarScreenTitle => 'التقويم';

  @override
  String get dailyActivity => 'النشاط اليومي';

  @override
  String get deleteItemQuestion => 'حذف العنصر؟';

  @override
  String get deleteItemConfirmation =>
      'سيؤدي هذا إلى نقل العنصر إلى سلة المحذوفات.';

  @override
  String get moveToBinItem => 'نقل إلى السلة؟';

  @override
  String get moveToBinConfirmation => 'يمكنك استعادته لاحقاً.';

  @override
  String selectedItems(int count) {
    return '$count محدد';
  }

  @override
  String get recentClips => 'القصاصات الأخيرة';

  @override
  String get copied => 'تم النسخ!';

  @override
  String get copiedPlainText => 'تم نسخ النص المجرد';

  @override
  String get clipTheme => 'مظهر القصاصة';

  @override
  String get justNow => 'الآن';

  @override
  String minutesAgo(Object count) {
    return 'منذ $count د';
  }

  @override
  String hoursAgo(Object count) {
    return 'منذ $count س';
  }

  @override
  String daysAgo(Object count) {
    return 'منذ $count ي';
  }

  @override
  String get noTasksFound => 'لم يتم العثور على مهام.';

  @override
  String get searchTasks => 'بحث في المهام...';

  @override
  String get taskReminder => 'تذكير بالمهمة';

  @override
  String get untitledNote => 'ملاحظة بدون عنوان';

  @override
  String get dailyEntry => 'مدخل يومي';

  @override
  String get clipboardHistory => 'سجل الحافظة';

  @override
  String get deletePermanentlyContent => 'هذا الإجراء لا يمكن التراجع عنه.';

  @override
  String get emptyRecycleBinTitle => 'إفراغ سلة المحذوفات؟';

  @override
  String emptyRecycleBinContent(Object count) {
    return 'سيتم حذف جميع العناصر الـ $count نهائياً.';
  }

  @override
  String get emptyBin => 'إفراغ السلة';

  @override
  String get recycleBinEmpty => 'سلة المحذوفات فارغة';

  @override
  String get deletedItemsAppearHere => 'Deleted items will appear here.';

  @override
  String get empty => 'فارغ';

  @override
  String get recent => 'الأخيرة';

  @override
  String categoryLabel(Object category) {
    return 'الفئة: $category';
  }

  @override
  String get general => 'عام';

  @override
  String get saveTransactionQuestion => 'هل تريد حفظ هذه المعاملة؟';

  @override
  String get fillTitleAmount => 'يرجى ملء العنوان والمبلغ';

  @override
  String get invalidAmount => 'تنسيق المبلغ غير صالح';

  @override
  String get moveTransactionToBinTitle => 'نقل المعاملة إلى سلة المحذوفات؟';

  @override
  String get restoreTransactionLater =>
      'يمكنك استعادة هذه المعاملة لاحقاً من الإعدادات.';

  @override
  String get newTransaction => 'معاملة جديدة';

  @override
  String get whatIsThisFor => 'فيما هذا؟';

  @override
  String get description => 'الوصف';

  @override
  String get daily => 'يومياً';

  @override
  String get weekly => 'أسبوعياً';

  @override
  String get monthly => 'شهرياً';

  @override
  String get yearly => 'سنوياً';

  @override
  String get totalIncome => 'إجمالي الدخل';

  @override
  String get totalExpense => 'إجمالي النفقات';

  @override
  String get analysis => 'التحليل';

  @override
  String get transactions => 'المعاملات';

  @override
  String get noExpensesFound => 'لم يتم العثور على نفقات لهذه الفترة.';

  @override
  String get netBalance => 'صافي الرصيد';

  @override
  String get topCategories => 'أبرز الفئات';

  @override
  String get spendingTrend => 'اتجاه الإنفاق';

  @override
  String get insights => 'رؤى';

  @override
  String get noExpensesRecorded => 'لم يتم تسجيل أي نفقات';

  @override
  String get trackSpendingHabits => 'تتبع عادات الإنفاق الخاصة بك بسهولة.';

  @override
  String get addExpense => 'إضافة نفقة';

  @override
  String get noDataForPeriod => 'لا توجد بيانات لهذه الفترة';

  @override
  String get budget => 'الميزانية';

  @override
  String get spent => 'تم صرفه';

  @override
  String get limit => 'الحد';

  @override
  String get overBudget => 'تجاوز الميزانية!';

  @override
  String remainingBudget(Object percent) {
    return 'متبقي $percent%';
  }

  @override
  String get savingsRate => 'معدل الادخار';

  @override
  String get healthScore => 'درجة الصحة المالية';

  @override
  String get healthScoreExplanation =>
      'هذه الدرجة تعتمد على معدل ادخارك.\n\n• ادخار > 50% = ممتاز (100)\n• ادخار 0% = متوسط (50)\n• الإنفاق > الدخل = ضعيف (<50)';

  @override
  String get ok => 'موافق';

  @override
  String get bulkImport => 'استيراد بالجملة';
}

/// The translations for Arabic, as used in Yemen (`ar_YE`).
class AppLocalizationsArYe extends AppLocalizationsAr {
  AppLocalizationsArYe() : super('ar_YE');

  @override
  String get settings => 'إعدادات';

  @override
  String get language => 'لغة';

  @override
  String get systemDefault => 'النظام الافتراضي';

  @override
  String get notes => 'ملحوظات';

  @override
  String get todos => 'المهام';

  @override
  String get expenses => 'نفقات';

  @override
  String get journal => 'مجلة';

  @override
  String get calendar => 'تقويم';

  @override
  String get clipboard => 'الحافظة';

  @override
  String get canvas => 'قماش';

  @override
  String get save => 'حفظ';

  @override
  String get create => 'إنشاء';

  @override
  String get cancel => 'إلغاء';

  @override
  String get delete => 'حذف';

  @override
  String get edit => 'تعديل';

  @override
  String get share => 'مشاركة';

  @override
  String get copy => 'نسخ';

  @override
  String get unsavedChanges => 'تغييرات غير محفوظة';

  @override
  String get confirmDelete => 'تأكيد الحذف';

  @override
  String get discard => 'تجاهل';

  @override
  String get createPost => 'إنشاء منشور';

  @override
  String get post => 'منشور';

  @override
  String get postingTo => 'النشر في';

  @override
  String get whatsOnYourMind => 'ماذا يدور في ذهنك؟';

  @override
  String get pickImages => 'اختر صورًا';

  @override
  String get pickVideo => 'اختر فيديو';

  @override
  String get camera => 'كاميرا';

  @override
  String get gallery => 'معرض الصور';

  @override
  String get search => 'بحث';

  @override
  String get pleaseEnterTask => 'يرجى إدخال مهمة';

  @override
  String get deleteTask => 'حذف المهمة';

  @override
  String get selectItems => 'حدد العناصر';

  @override
  String get deleteAll => 'حذف الكل';

  @override
  String error(Object error) {
    return 'خطأ: $error';
  }

  @override
  String get orderingOnlyAvailableInAllPosts =>
      'الترتيب متاح فقط في \"جميع المنشورات\"';

  @override
  String get deletePost => 'حذف المنشور';

  @override
  String get postDeleted => 'تم حذف المنشور';

  @override
  String get premiumFeatures => 'ميزات بريميوم';

  @override
  String get manageCoinsAdsPremium =>
      'إدارة العملات والإعلانات وحالة البريميوم';

  @override
  String get themeMode => 'وضع المظهر';

  @override
  String get accentColor => 'لون التمييز';

  @override
  String get backgroundDesign => 'تصميم الخلفية';

  @override
  String get pushNotifications => 'إشعارات الدفع';

  @override
  String get recycleBin => 'سلة المحذوفات';

  @override
  String get exportData => 'تصدير البيانات';

  @override
  String get importData => 'استيراد البيانات';

  @override
  String get rateApp => 'تقييم التطبيق';

  @override
  String get sendFeedback => 'إرسال تعليقات';

  @override
  String get privacyPolicy => 'سياسة الخصوصية';

  @override
  String get version => 'الإصدار';

  @override
  String get buildNumber => 'رقم البناء';

  @override
  String get system => 'النظام';

  @override
  String get light => 'فاتح';

  @override
  String get dark => 'داكن';

  @override
  String get itemRestored => 'تمت استعادة العنصر';

  @override
  String get recycleBinCleared => 'تم إفراغ سلة المحذوفات بنجاح';

  @override
  String get allPostsDeleted => 'تم حذف جميع المنشورات';

  @override
  String get newPost => 'منشور جديد';

  @override
  String get textCopiedToClipboardFacebook =>
      'Text copied to clipboard (Facebook policy)';

  @override
  String get tiktokSharingRequiresVideoImage =>
      'تتطلب مشاركة TikTok فيديو/صورة';

  @override
  String errorSharing(Object error) {
    return 'خطأ في المشاركة: $error';
  }

  @override
  String shareToStory(Object platform) {
    return 'مشاركة في قصة $platform';
  }

  @override
  String shareToFeed(Object platform) {
    return 'مشاركة في موجز $platform';
  }

  @override
  String get unlockPermanently => 'فتح بشكل دائم';

  @override
  String get notEnoughCoins => 'لا توجد عملات كافية!';

  @override
  String youEarnedCoins(Object amount) {
    return 'لقد ربحت $amount من العملات!';
  }

  @override
  String get contentCopied => 'تم نسخ المحتوى';

  @override
  String get selectDateTime => 'حدد التاريخ والوقت';

  @override
  String get areYouSureYouWantToDeleteThisPost =>
      'هل أنت متأكد أنك تريد حذف هذا المنشور؟';

  @override
  String get socialPosts => 'منشورات اجتماعية';

  @override
  String get watchAdToEarnCoins => 'شاهد إعلانًا لربح العملات';

  @override
  String get premiumUnlocked => 'تم فتح البريميوم';

  @override
  String get removeAds => 'إزالة الإعلانات';

  @override
  String get unlimitedCloudStorage => 'تخزين سحابي غير محدود';

  @override
  String get deleteNote => 'حذف الملاحظة';

  @override
  String get shareNote => 'مشاركة الملاحظة';

  @override
  String get editNote => 'تعديل الملاحظة';

  @override
  String get searchNotes => 'البحث في الملاحظات...';

  @override
  String get noNotesFound => 'لم يتم العثور على ملاحظات';

  @override
  String get captureThoughts => 'سجل أفكارك فورا.';

  @override
  String get createNote => 'إنشاء ملاحظة';

  @override
  String get customOrder => 'ترتيب مخصص';

  @override
  String get newestFirst => 'الأحدث أولاً';

  @override
  String get oldestFirst => 'الأقدم أولاً';

  @override
  String get titleAZ => 'العنوان: أ-ي';

  @override
  String get titleZA => 'العنوان: ي-أ';

  @override
  String get deleteAllQuestion => 'حذف الكل؟';

  @override
  String get moveToRecycleBin => 'نقل جميع الملاحظات إلى سلة المحذوفات؟';

  @override
  String get moveToBinQuestion => 'نقل إلى السلة؟';

  @override
  String get restoreNoteLater => 'يمكنك استعادة هذه الملاحظة لاحقًا.';

  @override
  String get move => 'نقل';

  @override
  String get myThoughts => 'أفكاري';

  @override
  String get selected => 'محدد';

  @override
  String get noContent => 'لا يوجد محتوى';

  @override
  String get untitled => 'بدون عنوان';

  @override
  String get chooseWallpapers => 'اختر من بين أكثر من 10 خلفيات ديناميكية';

  @override
  String get backupData => 'نسخ احتياطي للبيانات';

  @override
  String get saveJsonFile => 'هل تريد حفظ ملف JSON يحتوي على جميع بياناتك؟';

  @override
  String get exportNow => 'تصدير الآن';

  @override
  String get importDataTitle => 'استيراد البيانات';

  @override
  String get mergeBackupFile =>
      'هل تريد دمج ملف النسخ الاحتياطي مع العناصر الحالية؟';

  @override
  String get selectFile => 'حدد ملفاً';

  @override
  String get backupSaved => 'تم حفظ النسخة الاحتياطية بنجاح!';

  @override
  String get exportFailed => 'فشل التصدير.';

  @override
  String importSuccess(Object count) {
    return 'تمت استعادة $count من العناصر بنجاح!';
  }

  @override
  String get importFailed => 'فشل الاستيراد.';

  @override
  String widgetAdded(String widget) {
    return 'تمت إضافة الأداة $widget إلى الشاشة الرئيسية!';
  }

  @override
  String get widgetRequestSent =>
      'تم إرسال طلب الأداة. يرجى التحقق من الشاشة الرئيسية.';

  @override
  String get widgetAddFailed => 'فشل إضافة الأداة';

  @override
  String get autoSaveEnabled => 'تم تفعيل الحفظ التلقائي.';

  @override
  String get autoSaveDisabled => 'تم تعطيل الحفظ التلقائي.';

  @override
  String get homeScreenWidgets => 'أدوات الشاشة الرئيسية';

  @override
  String get notificationsTitle => 'الإشعارات';

  @override
  String get dataBackup => 'البيانات والنسخ الاحتياطي';

  @override
  String get feedbackSupport => 'التعليقات والدعم';

  @override
  String get creditsTitle => 'الاعتمادات';

  @override
  String get privacyMaintenance => 'الخصوصية والصيانة';

  @override
  String get aboutTitle => 'حول';

  @override
  String get premium => 'بريميوم';

  @override
  String get appearanceTitle => 'المظهر';

  @override
  String get clipboardTitle => 'الحافظة';

  @override
  String get settingsSubtitle => 'تخصيص تجربتك';

  @override
  String get welcomeTitle => 'مرحبًا بك في CopyClip';

  @override
  String get welcomeDescription =>
      'رفيقك النهائي للإنتاجية. دعنا نجهزك بأدوات قوية لإدارة يومك.';

  @override
  String get onboardingNotesTitle => 'ملاحظات ذكية';

  @override
  String get onboardingNotesDesc =>
      'التقط الأفكار فورًا بتنسيق نص غني. نظم أفكارك ولا تفقد أي فكرة رائعة مرة أخرى.';

  @override
  String get onboardingTodosTitle => 'إدارة المهام';

  @override
  String get onboardingTodosDesc =>
      'ابق مطلعاً على أمورك. أنشئ قوائم مهام، وحدد الأولويات، وحقق أهدافك خطوة بخطوة.';

  @override
  String get onboardingExpensesTitle => 'تتبع النفقات';

  @override
  String get onboardingExpensesDesc =>
      'تحكم في أموالك. تتبع الدخل والنفقات بسهولة لفهم عادات الإنفاق الخاصة بك.';

  @override
  String get onboardingJournalTitle => 'يوميات شخصية';

  @override
  String get onboardingJournalDesc =>
      'تأمل في يومك. مساحة خاصة لتدوين ذكرياتك ومشاعرك وتجاربك اليومية.';

  @override
  String get onboardingCalendarTitle => 'التقويم والأحداث';

  @override
  String get onboardingCalendarDesc =>
      'لا تفوت أي لحظة. نظم جدولك وتابع الأحداث الهامة القادمة.';

  @override
  String get onboardingClipboardTitle => 'مدير الحافظة';

  @override
  String get onboardingClipboardDesc =>
      'انسخ مرة واحدة، والصق في أي مكان. الوصول إلى سجل الحافظة لاستعادة النصوص التي نسختها سابقاً.';

  @override
  String get onboardingCanvasTitle => 'لوحة إبداعية';

  @override
  String get onboardingCanvasDesc =>
      'أطلق العنان لإبداعك. ارسم وخطط وصور أفكارك على لوحة رقمية حرة.';

  @override
  String get featuresNotesDesc => 'إنشاء وإدارة الملاحظات الخاصة بك';

  @override
  String get featuresTodosDesc => 'تتبع المهام الخاصة بك';

  @override
  String get featuresExpensesDesc => 'مراقبة النفقات الخاصة بك';

  @override
  String get featuresJournalDesc => 'اكتتب أفكارك';

  @override
  String get featuresCalendarDesc => 'نظم جدولك الزمني';

  @override
  String get featuresClipboardDesc => 'الوصول إلى سجل الحافظة الخاص بك';

  @override
  String get featuresCanvasDesc => 'ارسم وخطط بحرية';

  @override
  String get featuresSocialPost => 'منشور اجتماعي';

  @override
  String get featuresSocialPostDesc =>
      'إنشاء محتوى جذاب لوسائل التواصل الاجتماعي';

  @override
  String get chooseYourAura => 'اختر هالتك';

  @override
  String get expressYourselfTheme => 'عبر عن نفسك بلون مظهر جديد!';

  @override
  String get level => 'المستوى';

  @override
  String get xpToNextLevel => 'XP للمستوى التالي';

  @override
  String get checkUpcomingEvents => 'تحقق من الأحداث القادمة';

  @override
  String get startNewSketch => 'بدأ رسمة جديدة';

  @override
  String get noTransactionsMonth => 'لا توجد معاملات هذا الشهر';

  @override
  String transactionsThisMonth(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count معاملات هذا الشهر',
      few: '$count معاملات هذا الشهر',
      two: 'معاملتان هذا الشهر',
      one: 'معاملة واحدة هذا الشهر',
      zero: 'لا توجد معاملات هذا الشهر',
    );
    return '$_temp0';
  }

  @override
  String get autoSaveClipboard => 'حفظ تلقائي للحافظة';

  @override
  String get autoSaveClipboardDesc => 'حفظ العناصر المنسوخة تلقائياً';

  @override
  String get permissionDeniedSettings =>
      'تم رفض الإذن بشكل دائم. يرجى تفعيله من الإعدادات.';

  @override
  String get notificationsEnabled => 'تم تفعيل الإشعارات!';

  @override
  String get redirectingToSettings =>
      'جارٍ التوجيه إلى الإعدادات لتعطيل الإشعارات...';

  @override
  String get premiumAccess => 'وصول بريميوم';

  @override
  String get premiumActiveUntil => 'بريميوم نشط حتى';

  @override
  String get unlockAllFeatures => 'فتح جميع الميزات';

  @override
  String get buyPremium => 'شراء بريميوم (7 أيام)';

  @override
  String costCoins(Object cost) {
    return 'التكلفة: $cost عملات';
  }

  @override
  String get premiumActivated => 'تم تفعيل البريميوم لمدة 7 أيام!';

  @override
  String get premiumActive => 'البريميوم نشط';

  @override
  String get expires => 'تنتهي الصلاحية:';

  @override
  String get temporaryAccess => 'وصول مؤقت';

  @override
  String get journalExpression => 'يوميات وتعبير';

  @override
  String get artisticDesigns => 'تصاميم فنية';

  @override
  String get artisticDesignsDesc =>
      'فتح أكثر من 10 مظاهر فريدة لبطاقات اليوميات';

  @override
  String get premiumLayouts => 'تخطيطات بريميوم';

  @override
  String get premiumLayoutsDesc => 'طرق حصرية لعرض ذكرياتك';

  @override
  String get calendarTools => 'تقويم وأدوات';

  @override
  String get fullCalendar => 'تقويم كامل';

  @override
  String get fullCalendarDesc => 'نظام متكامل لإدارة الأحداث';

  @override
  String get clipboardAutoSaveDesc => 'التقاط سجل الحافظة في الخلفية';

  @override
  String get proWidgets => 'أدوات ذكية للمحترفين';

  @override
  String get proWidgetsDesc => 'جميع الميزات متوفرة على شاشتك الرئيسية';

  @override
  String get dataExport => 'البيانات والتصدير';

  @override
  String get advancedBackup => 'نسخ احتياطي متقدم';

  @override
  String get advancedBackupDesc => 'استيراد/تصدير آمن لجميع البيانات';

  @override
  String get pdfExport => 'تصدير إلى PDF';

  @override
  String get pdfExportDesc => 'تصدير الملاحظات واليوميات إلى PDF';

  @override
  String get printReady => 'جاهز للطباعة';

  @override
  String get printReadyDesc => 'دعم الطباعة المباشرة';

  @override
  String get richTextEditor => 'محرر نص غني';

  @override
  String get advancedSearch => 'بحث متقدم';

  @override
  String get advancedSearchDesc => 'البحث والاستبدال داخل النص';

  @override
  String get richMedia => 'وسائط غنية';

  @override
  String get richMediaDesc => 'إدراج صور وفيديوهات وروابط';

  @override
  String get editorStyling => 'تنسيق المحرر';

  @override
  String get editorStylingDesc => 'نص مخصص وخلفيات للمحرر';

  @override
  String get balance => 'الرصيد';

  @override
  String get loadingAd => 'جارٍ تحميل الإعلان...';

  @override
  String watchAd(Object amount) {
    return 'مشاهدة إعلان (+$amount)';
  }

  @override
  String get loadAd => 'تحميل إعلان';

  @override
  String get backupDataDesc => 'حفظ ملف JSON لبياناتك';

  @override
  String get importDataDesc => 'دمج ملف نسخة احتياطية في CopyClip';

  @override
  String get notificationPermissionDenied => 'تم رفض إذن الإشعارات.';

  @override
  String get typeNewTask => 'اكتب مهمة جديدة...';

  @override
  String get addTask => 'إضافة مهمة';

  @override
  String get completed => 'مكتمل';

  @override
  String get greatJob => 'عمل رائع!';

  @override
  String youEarnedXPNextTask(Object amount, Object date) {
    return 'لقد ربحت $amount XP! المهمة التالية: $date';
  }

  @override
  String taskCompletedXP(Object amount) {
    return 'تمت المهمة! +$amount XP';
  }

  @override
  String get moveTasksToRecycleBin =>
      'نقل جميع المهام النشطة إلى سلة المحذوفات؟';

  @override
  String get deleteAllPosts => 'حذف جميع المنشورات';

  @override
  String get deleteAllPostsConfirmation =>
      'هل أنت متأكد أنك تريد حذف جميع المنشورات الاجتماعية؟ لا يمكن التراجع عن هذا الإجراء.';

  @override
  String get allPosts => 'جميع المنشورات';

  @override
  String get favorites => 'المفضلة';

  @override
  String get drafts => 'المسودات';

  @override
  String get noFavoritesYet => 'لا توجد مفضلات بعد';

  @override
  String get noDraftsYet => 'لا توجد مسودات بعد';

  @override
  String get startSocialJourney => 'ابدأ رحلتك الاجتماعية!';

  @override
  String get draft => 'مسودة';

  @override
  String attachmentCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count مرفقات',
      few: '$count مرفقات',
      two: 'مرفقان',
      one: 'مرفق واحد',
      zero: 'لا توجد مرفقات',
    );
    return '$_temp0';
  }

  @override
  String get pleaseAddContent => 'يرجى إضافة بعض المحتوى أو الوسائط للمشاركة';

  @override
  String fileNotFoundError(Object path) {
    return 'خطأ: لم يتم العخثور على الملف في $path';
  }

  @override
  String get checkFacebookApp => 'تحقق من تطبيق فيسبوك';

  @override
  String get systemShare => 'مشاركة النظام';

  @override
  String get socialPost => 'منشور اجتماعي';

  @override
  String get favorite => 'مفضل';

  @override
  String get saveDraft => 'حفظ المسودة';

  @override
  String get entryCopied => 'تم نسخ المدخل';

  @override
  String get moveEntriesToRecycleBin =>
      'نقل جميع المدخلات النشطة إلى سلة المحذوفات؟';

  @override
  String get startWritingStory => 'ابدأ بكتابة قصتك';

  @override
  String get recordMemories => 'سجل ذكرياتك ومشاعرك اليومية.';

  @override
  String get writeJournal => 'اكتب يومياتك';

  @override
  String get myMemories => 'ذكرياتي';

  @override
  String get sortJournal => 'فرز اليوميات';

  @override
  String get byMood => 'حسب المزاج';

  @override
  String get searchMemories => 'بحث في الذكريات...';

  @override
  String get selectAll => 'تحديد الكل';

  @override
  String get deleteSelected => 'حذف المحدد';

  @override
  String get taskCompletedExclamation => 'تمت المهمة!';

  @override
  String get taskUncompletedExclamation => 'مهمة غير مكتملة';

  @override
  String get clipboardUpdatedExclamation => 'تم تحديث الحافظة!';

  @override
  String clipboardSavedContent(Object content) {
    return 'تم حفظ في الحافظة: $content';
  }

  @override
  String get overview => 'نظرة عامة';

  @override
  String get colorAurora => 'أورورا';

  @override
  String get colorCosmic => 'كوني';

  @override
  String get colorNebula => 'سديم';

  @override
  String get colorStarlight => 'ضوء النجوم';

  @override
  String get colorSolar => 'شمسي';

  @override
  String get colorNova => 'نوفا';

  @override
  String get loadingStepLoading => 'جارٍ التحميل...';

  @override
  String get loadingStepDatabase => 'إعداد قاعدة البيانات...';

  @override
  String get loadingStepSystem => 'تكوين النظام...';

  @override
  String get loadingStepReady => 'جاهز';

  @override
  String get productivityCompanion => 'رفيقك للإنتاجية';

  @override
  String get done => 'تم';

  @override
  String get newNote => 'ملاحظة جديدة';

  @override
  String get changeColor => 'تغيير اللون';

  @override
  String get copyContent => 'نسخ المحتوى';

  @override
  String get titleOptional => 'العنوان (اختياري)';

  @override
  String get exportAsPdf => 'تصدير كـ PDF';

  @override
  String get taskDueNow => 'موعد المهمة الآن';

  @override
  String get moveTaskToBinTitle => 'نقل المهمة إلى سلة المحذوفات؟';

  @override
  String get restoreTaskLater =>
      'يمكنك استعادة هذه المهمة لاحقًا من الإعدادات.';

  @override
  String get newTask => 'مهمة جديدة';

  @override
  String get editTask => 'تعديل المهمة';

  @override
  String get undo => 'تراجع';

  @override
  String get redo => 'إعادة';

  @override
  String get category => 'الفئة';

  @override
  String get categoryHint => 'مثال: العمل، النادي';

  @override
  String get whatNeedsToBeDone => 'ما الذي يجب القيام به؟';

  @override
  String get enterTaskDetails => 'أدخل تفاصيل المهمة...';

  @override
  String get setDueDate => 'تحديد موعد الاستحقاق';

  @override
  String get dueDate => 'موعد الاستحقاق';

  @override
  String get expenseTitle => 'النفقات';

  @override
  String searchInCurrency(String currency) {
    return 'بحث في $currency...';
  }

  @override
  String get sortAndFilter => 'فرز وتصفية';

  @override
  String get sortBy => 'فرز حسب';

  @override
  String get highestAmount => 'أعلى مبلغ';

  @override
  String get lowestAmount => 'أقل مبلغ';

  @override
  String get moreFilters => 'مزيد من الفلاتر...';

  @override
  String get filterExpenses => 'تصفية النفقات';

  @override
  String get transactionType => 'نوع المعاملة';

  @override
  String get categories => 'الفئات';

  @override
  String get all => 'الكل';

  @override
  String get income => 'الدخل';

  @override
  String get expense => 'المصروفات';

  @override
  String get reset => 'إعادة تعيين';

  @override
  String get apply => 'تطبيق';

  @override
  String newExpense(String currency) {
    return 'جديد $currency';
  }

  @override
  String errorLoadingData(String error) {
    return 'حدث خطأ أثناء تحميل البيانات.\n\n$error';
  }

  @override
  String get dailyQuote1 => 'أفضل طريقة للتنبؤ بالمستقبل هي أن تصنعه.';

  @override
  String get dailyQuote2 => 'الغنى ليس في كثرة العرض، ولكن الغنى غنى النفس.';

  @override
  String get dailyQuote3 => 'الوقت هو العملة الأغلى.';

  @override
  String get dailyQuote4 => 'النجاح ليس نهائياً، والفشل ليس قاتلاً.';

  @override
  String get dailyQuote5 => 'ركز على الحل، وليس المشكلة.';

  @override
  String get dailyQuote6 => 'شبكة علاقاتك هي ثروتك الحقيقية.';

  @override
  String get moodHappy => 'سعيد';

  @override
  String get moodExcited => 'متحمس';

  @override
  String get moodNeutral => 'محايد';

  @override
  String get moodSad => 'حزين';

  @override
  String get moodStressed => 'متوتر';

  @override
  String exportDate(String date) {
    return '📅 $date';
  }

  @override
  String exportMood(String emoji, String mood) {
    return 'المزاج: $emoji $mood';
  }

  @override
  String exportTitle(String title) {
    return 'العنوان: $title';
  }

  @override
  String exportTags(String tags) {
    return '\nالوسوم: $tags';
  }

  @override
  String get instagram => 'إنستغرام';

  @override
  String get facebook => 'فيسبوك';

  @override
  String get tiktok => 'تيك توك';

  @override
  String get newSketch => 'رسمة جديدة';

  @override
  String get searchSketches => 'البحث في الرسومات والمجلدات...';

  @override
  String get noResultsFound => 'لم يتم العثور على نتائج';

  @override
  String get noItems => 'لا توجد عناصر';

  @override
  String get noDrawingsYet => 'لا توجد رسومات بعد';

  @override
  String get canvasIntro => 'أطلق العنان لإبداعك على اللوحة!';

  @override
  String get newCanvas => 'لوحة جديدة';

  @override
  String get rename => 'إعادة تسمية';

  @override
  String get deleteFolder => 'حذف المجلد';

  @override
  String get deleteSketchesQuestion => 'حذف الرسومات؟';

  @override
  String get deleteFolderConfirmation =>
      'سيتم حذف جميع الرسومات في هذا المجلد نهائياً.';

  @override
  String get renameFolder => 'إعادة تسمية المجلد';

  @override
  String get chooseColor => 'اختر لوناً';

  @override
  String get deleteFolderQuestion => 'حذف المجلد؟';

  @override
  String get searchClips => 'البحث في القصاصات...';

  @override
  String get clipboardEmpty => 'الحافظة فارغة';

  @override
  String get addItem => 'إضافة عنصر';

  @override
  String get clipColor => 'لون القصاصة';

  @override
  String get newClip => 'قصاصة جديدة';

  @override
  String get editClip => 'تعديل القصاصة';

  @override
  String get restoreClipLater => 'يمكنك استعادة هذه القصاصة لاحقاً.';

  @override
  String get upcomingEvents => 'الأحداث القادمة';

  @override
  String get dataDistribution => 'توزيع البيانات';

  @override
  String get taskProgress => 'تقدم المهمة';

  @override
  String get quickStats => 'إحصائيات سريعة';

  @override
  String get taskCompletion => 'إكمال المهمة';

  @override
  String get noItemsForDate => 'لا توجد عناصر لهذا التاريخ';

  @override
  String get enjoyFreeTime => 'استمتع بوقت فراغك!';

  @override
  String get searchThisDay => 'البحث في هذا اليوم...';

  @override
  String get finance => 'المالية';

  @override
  String get permanentlyDelete => 'حذف نهائي؟';

  @override
  String deleteSelectionConfirmation(int foldersCount, int sketchesCount) {
    return 'سيؤدي هذا إلى حذف $foldersCount مجلدات (ورسماتها) و $sketchesCount رسومات أخرى نهائياً.\n\nلا يمكن التراجع عن هذا الإجراء.';
  }

  @override
  String get deleteForever => 'حذف للأبد';

  @override
  String selectedCount(int count) {
    return '$count محدد';
  }

  @override
  String canvasStats(int notes, int folders) {
    return '$notes رسومات • $folders مجلدات';
  }

  @override
  String get sortItems => 'فرز العناصر';

  @override
  String get sortNameAZ => 'الاسم (أ-ي)';

  @override
  String get sortNameZA => 'الاسم (ي-أ)';

  @override
  String get createFolder => 'إنشاء مجلد';

  @override
  String get folderNameHint => 'اسم المجلد...';

  @override
  String deleteSketchesConfirmation(int count) {
    return 'حذف $count رسومات؟ لا يمكن التراجع عن هذا الإجراء.';
  }

  @override
  String get noSketchesFound => 'لم يتم العثور على رسومات';

  @override
  String get noSketchesFoundSub => 'حاول تعديل بحثك أو إنشاء رسمة جديدة.';

  @override
  String searchInFolder(String folder) {
    return 'بحث في $folder...';
  }

  @override
  String sketchesCount(int count) {
    return '$count رسومات';
  }

  @override
  String get sortSketches => 'فرز الرسومات';

  @override
  String get calendarScreenTitle => 'التقويم';

  @override
  String get dailyActivity => 'النشاط اليومي';

  @override
  String get deleteItemQuestion => 'حذف العنصر؟';

  @override
  String get deleteItemConfirmation =>
      'سيؤدي هذا إلى نقل العنصر إلى سلة المحذوفات.';

  @override
  String get moveToBinItem => 'نقل إلى السلة؟';

  @override
  String get moveToBinConfirmation => 'يمكنك استعادته لاحقاً.';

  @override
  String selectedItems(int count) {
    return '$count محدد';
  }

  @override
  String get recentClips => 'القصاصات الأخيرة';

  @override
  String get copied => 'تم النسخ!';

  @override
  String get copiedPlainText => 'تم نسخ النص المجرد';

  @override
  String get clipTheme => 'مظهر القصاصة';

  @override
  String get justNow => 'الآن';

  @override
  String minutesAgo(Object count) {
    return 'منذ $count د';
  }

  @override
  String hoursAgo(Object count) {
    return 'منذ $count س';
  }

  @override
  String daysAgo(Object count) {
    return 'منذ $count ي';
  }

  @override
  String get noTasksFound => 'لم يتم العثور على مهام.';

  @override
  String get searchTasks => 'بحث في المهام...';

  @override
  String get taskReminder => 'تذكير بالمهمة';

  @override
  String get untitledNote => 'ملاحظة بدون عنوان';

  @override
  String get dailyEntry => 'مدخل يومي';

  @override
  String get clipboardHistory => 'سجل الحافظة';

  @override
  String get deletePermanentlyContent => 'هذا الإجراء لا يمكن التراجع عنه.';

  @override
  String get emptyRecycleBinTitle => 'إفراغ سلة المحذوفات؟';

  @override
  String emptyRecycleBinContent(Object count) {
    return 'سيتم حذف جميع العناصر الـ $count نهائياً.';
  }

  @override
  String get emptyBin => 'إفراغ السلة';

  @override
  String get recycleBinEmpty => 'سلة المحذوفات فارغة';

  @override
  String get deletedItemsAppearHere => 'العناصر المحذوفة ستظهر هنا.';

  @override
  String get empty => 'فارغ';

  @override
  String get recent => 'الأخيرة';

  @override
  String categoryLabel(Object category) {
    return 'الفئة: $category';
  }

  @override
  String get general => 'عام';

  @override
  String get saveTransactionQuestion => 'هل تريد حفظ هذه المعاملة؟';

  @override
  String get fillTitleAmount => 'يرجى ملء العنوان والمبلغ';

  @override
  String get invalidAmount => 'تنسيق المبلغ غير صالح';

  @override
  String get moveTransactionToBinTitle => 'نقل المعاملة إلى سلة المحذوفات؟';

  @override
  String get restoreTransactionLater =>
      'يمكنك استعادة هذه المعاملة لاحقاً من الإعدادات.';

  @override
  String get newTransaction => 'معاملة جديدة';

  @override
  String get whatIsThisFor => 'فيما هذا؟';

  @override
  String get description => 'الوصف';

  @override
  String get daily => 'يومياً';

  @override
  String get weekly => 'أسبوعياً';

  @override
  String get monthly => 'شهرياً';

  @override
  String get yearly => 'سنوياً';

  @override
  String get totalIncome => 'إجمالي الدخل';

  @override
  String get totalExpense => 'إجمالي النفقات';

  @override
  String get analysis => 'التحليل';

  @override
  String get transactions => 'المعاملات';

  @override
  String get noExpensesFound => 'لم يتم العثور على نفقات لهذه الفترة.';

  @override
  String get netBalance => 'صافي الرصيد';

  @override
  String get topCategories => 'أبرز الفئات';

  @override
  String get spendingTrend => 'اتجاه الإنفاق';

  @override
  String get insights => 'رؤى';

  @override
  String get noExpensesRecorded => 'لم يتم تسجيل أي نفقات';

  @override
  String get trackSpendingHabits => 'تتبع عادات الإنفاق الخاصة بك بسهولة.';

  @override
  String get addExpense => 'إضافة نفقة';

  @override
  String get noDataForPeriod => 'لا توجد بيانات لهذه الفترة';

  @override
  String get budget => 'الميزانية';

  @override
  String get spent => 'تم صرفه';

  @override
  String get limit => 'الحد';

  @override
  String get overBudget => 'تجاوز الميزانية!';

  @override
  String remainingBudget(Object percent) {
    return 'متبقي $percent%';
  }

  @override
  String get savingsRate => 'معدل الادخار';

  @override
  String get healthScore => 'درجة الصحة المالية';

  @override
  String get healthScoreExplanation =>
      'هذه الدرجة تعتمد على معدل ادخارك.\n\n• ادخار > 50% = ممتاز (100)\n• ادخار 0% = متوسط (50)\n• الإنفاق > الدخل = ضعيف (<50)';

  @override
  String get ok => 'موافق';

  @override
  String get bulkImport => 'استيراد بالجملة';
}
