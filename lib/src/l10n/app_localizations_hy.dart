// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Armenian (`hy`).
class AppLocalizationsHy extends AppLocalizations {
  AppLocalizationsHy([String locale = 'hy']) : super(locale);

  @override
  String get settings => 'Կարգավորումներ';

  @override
  String get language => 'Լեզու';

  @override
  String get systemDefault => 'Համակարգային լռելյայն';

  @override
  String get notes => 'Նշումներ';

  @override
  String get todos => 'Անելիքներ';

  @override
  String get expenses => 'Ծախսեր';

  @override
  String get journal => 'Օրագիր';

  @override
  String get calendar => 'Օրացույց';

  @override
  String get clipboard => 'Բուֆեր';

  @override
  String get canvas => 'Կտավ';

  @override
  String get save => 'Պահպանել';

  @override
  String get create => 'Ստեղծել';

  @override
  String get cancel => 'Չեղարկել';

  @override
  String get delete => 'Ջնջել';

  @override
  String get edit => 'Խմբագրել';

  @override
  String get share => 'Կիսվել';

  @override
  String get copy => 'Պատճենել';

  @override
  String get unsavedChanges => 'Չպահպանված փոփոխություններ';

  @override
  String get confirmDelete => 'Հաստատել ջնջումը';

  @override
  String get discard => 'Չեղարկել';

  @override
  String get createPost => 'Ստեղծել հրապարակում';

  @override
  String get post => 'Հրապարակել';

  @override
  String get postingTo => 'Հրապարակումը՝';

  @override
  String get whatsOnYourMind => 'Ի՞նչ կա ձեր մտքում:';

  @override
  String get pickImages => 'Ընտրել նկարներ';

  @override
  String get pickVideo => 'Ընտրել տեսանյութ';

  @override
  String get camera => 'Տեսախցիկ';

  @override
  String get gallery => 'Պատկերասրահ';

  @override
  String get search => 'Որոնել';

  @override
  String get pleaseEnterTask => 'Մուտքագրեք առաջադրանքը';

  @override
  String get deleteTask => 'Ջնջել առաջադրանքը';

  @override
  String get selectItems => 'Ընտրել տարրեր';

  @override
  String get deleteAll => 'Ջնջել բոլորը';

  @override
  String error(Object error) {
    return 'Սխալ՝ $error';
  }

  @override
  String get orderingOnlyAvailableInAllPosts =>
      'Դասավորումը հասանելի է միայն «Բոլոր հրապարակումներում»';

  @override
  String get deletePost => 'Ջնջել հրապարակումը';

  @override
  String get postDeleted => 'Հրապարակումը ջնջված է';

  @override
  String get premiumFeatures => 'Պրեմիում հնարավորություններ';

  @override
  String get manageCoinsAdsPremium =>
      'Կառավարել մետաղադրամները, գովազդը և պրեմիում կարգավիճակը';

  @override
  String get themeMode => 'Թեմայի ռեժիմ';

  @override
  String get accentColor => 'Շեշտադրման գույն';

  @override
  String get backgroundDesign => 'Ֆոնի դիզայն';

  @override
  String get pushNotifications => 'Push ծանուցումներ';

  @override
  String get recycleBin => 'Աղբաման';

  @override
  String get exportData => 'Արտահանել տվյալները';

  @override
  String get importData => 'Ներմուծել տվյալները';

  @override
  String get rateApp => 'Գնահատել հավելվածը';

  @override
  String get sendFeedback => 'Ուղարկել հետադարձ կապ';

  @override
  String get privacyPolicy => 'Գաղտնիության քաղաքականություն';

  @override
  String get version => 'Տարբերակ';

  @override
  String get buildNumber => 'Build համարը';

  @override
  String get system => 'Համակարգային';

  @override
  String get light => 'Լուսավոր';

  @override
  String get dark => 'Մուգ';

  @override
  String get itemRestored => 'Տարրը վերականգնված է';

  @override
  String get recycleBinCleared => 'Աղբամանը հաջողությամբ դատարկվեց';

  @override
  String get allPostsDeleted => 'Բոլոր հրապարակումները ջնջված են';

  @override
  String get newPost => 'Նոր հրապարակում';

  @override
  String get textCopiedToClipboardFacebook =>
      'Տեքստը պատճենված է բուֆերում (Facebook-ի քաղաքականություն)';

  @override
  String get tiktokSharingRequiresVideoImage =>
      'TikTok-ով կիսվելու համար անհրաժեշտ է տեսանյութ/նկար';

  @override
  String errorSharing(Object error) {
    return 'Կիսվելու սխալ՝ $error';
  }

  @override
  String shareToStory(Object platform) {
    return 'Կիսվել $platform Story-ում';
  }

  @override
  String shareToFeed(Object platform) {
    return 'Կիսվել $platform Feed-ում';
  }

  @override
  String get unlockPermanently => 'Ապակողպել ընդմիշտ';

  @override
  String get notEnoughCoins => 'Բավարար մետաղադրամներ չկան:';

  @override
  String youEarnedCoins(Object amount) {
    return 'Դուք վաստակեցիք $amount մետաղադրամ:';
  }

  @override
  String get contentCopied => 'Բովանդակությունը պատճենված է';

  @override
  String get selectDateTime => 'Ընտրել ամսաթիվը և ժամը';

  @override
  String get areYouSureYouWantToDeleteThisPost =>
      'Վստա՞հ եք, որ ցանկանում եք ջնջել այս հրապարակումը:';

  @override
  String get socialPosts => 'Սոցիալական հրապարակումներ';

  @override
  String get watchAdToEarnCoins =>
      'Դիտեք գովազդ մետաղադրամներ վաստակելու համար';

  @override
  String get premiumUnlocked => 'Պրեմիումն ապակողպված է';

  @override
  String get removeAds => 'Հեռացնել գովազդը';

  @override
  String get unlimitedCloudStorage => 'Անսահմանափակ ամպային պահեստ';

  @override
  String get deleteNote => 'Ջնջել նշումը';

  @override
  String get shareNote => 'Կիսվել նշումով';

  @override
  String get editNote => 'Խմբագրել նշումը';

  @override
  String get searchNotes => 'Որոնել նշումներ...';

  @override
  String get noNotesFound => 'Նշումներ չեն գտնվել';

  @override
  String get captureThoughts => 'Ակնթարթորեն գրանցեք ձեր մտքերը:';

  @override
  String get createNote => 'Ստեղծել նշում';

  @override
  String get customOrder => 'Անհատական կարգ';

  @override
  String get newestFirst => 'Նորերը սկզբում';

  @override
  String get oldestFirst => 'Հիները սկզբում';

  @override
  String get titleAZ => 'Վերնագիր՝ Ա-Ֆ';

  @override
  String get titleZA => 'Վերնագիր՝ Ֆ-Ա';

  @override
  String get deleteAllQuestion => 'Ջնջե՞լ բոլորը';

  @override
  String get moveToRecycleBin => 'Տեղափոխե՞լ բոլոր նշումները աղբաման:';

  @override
  String get moveToBinQuestion => 'Տեղափոխե՞լ աղբաման:';

  @override
  String get restoreNoteLater =>
      'Դուք կարող եք վերականգնել այս նշումը ավելի ուշ:';

  @override
  String get move => 'Տեղափոխել';

  @override
  String get myThoughts => 'Իմ մտքերը';

  @override
  String get selected => 'Ընտրված է';

  @override
  String get noContent => 'Բովանդակություն չկա';

  @override
  String get untitled => 'Անվերնագիր';

  @override
  String get chooseWallpapers => 'Ընտրեք 10+ դինամիկ պաստառներից';

  @override
  String get backupData => 'Տվյալների պահպանում';

  @override
  String get saveJsonFile =>
      'Պահպանե՞լ JSON ֆայլը, որը պարունակում է ձեր բոլոր տվյալները:';

  @override
  String get exportNow => 'Արտահանել հիմա';

  @override
  String get importDataTitle => 'Ներմուծել տվյալները';

  @override
  String get mergeBackupFile =>
      'Միավորե՞լ պահուստային ֆայլը ձեր ընթացիկ տարրերի հետ:';

  @override
  String get selectFile => 'Ընտրել ֆայլ';

  @override
  String get backupSaved => 'Պահուստային պատճենը հաջողությամբ պահպանվեց:';

  @override
  String get exportFailed => 'Արտահանումը ձախողվեց:';

  @override
  String importSuccess(Object count) {
    return '$count տարր հաջողությամբ վերականգնվեց:';
  }

  @override
  String get importFailed => 'Ներմուծումը ձախողվեց:';

  @override
  String widgetAdded(String widget) {
    return 'Վիդջեթը ավելացված է հիմնական էկրանին:';
  }

  @override
  String get widgetRequestSent =>
      'Վիդջեթի հարցումն ուղարկված է: Խնդրում ենք ստուգել ձեր հիմնական էկրանը:';

  @override
  String get widgetAddFailed => 'Չհաջողվեց ավելացնել վիդջեթը';

  @override
  String get autoSaveEnabled => 'Ավտոմատ պահպանումը միացված է:';

  @override
  String get autoSaveDisabled => 'Ավտոմատ պահպանումը անջատված է:';

  @override
  String get homeScreenWidgets => 'Հիմնական էկրանի վիդջեթներ';

  @override
  String get notificationsTitle => 'Ծանուցումներ';

  @override
  String get dataBackup => 'Տվյալներ և Պահուստավորում';

  @override
  String get feedbackSupport => 'Հետադարձ կապ և Աջակցություն';

  @override
  String get creditsTitle => 'Հեղինակներ';

  @override
  String get privacyMaintenance => 'Գաղտնիություն և Սպասարկում';

  @override
  String get aboutTitle => 'Մասին';

  @override
  String get premium => 'Պրեմիում';

  @override
  String get appearanceTitle => 'Արտաքին տեսք';

  @override
  String get clipboardTitle => 'Բուֆեր';

  @override
  String get settingsSubtitle => 'Անհատականացրեք ձեր փորձը';

  @override
  String get welcomeTitle => 'Բարի գալուստ CopyClip';

  @override
  String get welcomeDescription =>
      'Ձեր լավագույն արտադրողականության ուղեկիցը: Եկեք կարգավորենք հզոր գործիքներ՝ ձեր օրը կառավարելու համար:';

  @override
  String get onboardingNotesTitle => 'Խելացի նշումներ';

  @override
  String get onboardingNotesDesc =>
      'Ակնթարթորեն գրանցեք գաղափարները տեքստի հարուստ ձևաչափմամբ: Կազմակերպեք ձեր մտքերը և երբեք բաց մի թողեք հիանալի գաղափար:';

  @override
  String get onboardingTodosTitle => 'Առաջադրանքների կառավարում';

  @override
  String get onboardingTodosDesc =>
      'Մնացեք խաղի մեջ: Ստեղծեք անելիքների ցուցակներ, սահմանեք առաջնահերթություններ և հասեք ձեր նպատակներին քայլ առ քայլ:';

  @override
  String get onboardingExpensesTitle => 'Ծախսերի հետևում';

  @override
  String get onboardingExpensesDesc =>
      'Վերահսկեք ձեր ֆինանսները: Հեշտությամբ հետևեք եկամուտներին և ծախսերին՝ ձեր ծախսային սովորությունները հասկանալու համար:';

  @override
  String get onboardingJournalTitle => 'Անձնական օրագիր';

  @override
  String get onboardingJournalDesc =>
      'Մտորեք ձեր օրվա մասին: Մասնավոր տարածք ձեր հիշողությունները, զգացմունքները և ամենօրյա փորձառությունները գրի առնելու համար:';

  @override
  String get onboardingCalendarTitle => 'Օրացույց և Իրադարձություններ';

  @override
  String get onboardingCalendarDesc =>
      'Երբեք բաց մի թողեք ոչ մի պահ: Կազմակերպեք ձեր ժամանակացույցը և հետևեք կարևոր գալիք իրադարձություններին:';

  @override
  String get onboardingClipboardTitle => 'Բուֆերի կառավարիչ';

  @override
  String get onboardingClipboardDesc =>
      'Պատճենեք մեկ անգամ, տեղադրեք ցանկացած տեղ: Մուտք գործեք ձեր բուֆերի պատմություն՝ նախկինում պատճենված հատվածները վերականգնելու համար:';

  @override
  String get onboardingCanvasTitle => 'Ստեղծագործական կտավ';

  @override
  String get onboardingCanvasDesc =>
      'Սանձազերծեք ձեր ստեղծագործական ունակությունները: Նկարեք, էսքիզներ արեք և վիզուալացրեք ձեր գաղափարները թվային կտավի վրա:';

  @override
  String get featuresNotesDesc => 'Ստեղծեք և կառավարեք ձեր նշումները';

  @override
  String get featuresTodosDesc => 'Հետևեք ձեր առաջադրանքներին';

  @override
  String get featuresExpensesDesc => 'Վերահսկեք ձեր ծախսերը';

  @override
  String get featuresJournalDesc => 'Գրի առեք ձեր մտքերը';

  @override
  String get featuresCalendarDesc => 'Կազմակերպեք ձեր ժամանակացույցը';

  @override
  String get featuresClipboardDesc => 'Մուտք գործեք բուֆերի պատմություն';

  @override
  String get featuresCanvasDesc => 'Նկարեք և էսքիզներ արեք ազատորեն';

  @override
  String get featuresSocialPost => 'Սոցիալական հրապարակում';

  @override
  String get featuresSocialPostDesc =>
      'Ստեղծեք գրավիչ սոցիալական մեդիա բովանդակություն';

  @override
  String get chooseYourAura => 'Ընտրեք ձեր աուրան';

  @override
  String get expressYourselfTheme => 'Արտահայտվեք թեմայի նոր գույնով:';

  @override
  String get level => 'Մակարդակ';

  @override
  String get xpToNextLevel => 'XP մինչև հաջորդ մակարդակ';

  @override
  String get checkUpcomingEvents => 'Ստուգել գալիք իրադարձությունները';

  @override
  String get startNewSketch => 'Սկսել նոր էսքիզ';

  @override
  String get noTransactionsMonth => 'Այս ամիս գործարքներ չկան';

  @override
  String transactionsThisMonth(num count) {
    return '$count գործարք այս ամիս';
  }

  @override
  String get autoSaveClipboard => 'Բուֆերի ավտոմատ պահպանում';

  @override
  String get autoSaveClipboardDesc =>
      'Ավտոմատ կերպով պահպանել պատճենված տարրերը';

  @override
  String get permissionDeniedSettings =>
      'Թույլտվությունը վերջնականապես մերժված է: Խնդրում ենք միացնել Կարգավորումներում:';

  @override
  String get notificationsEnabled => 'Ծանուցումները միացված են:';

  @override
  String get redirectingToSettings =>
      'Վերահասցեավորում դեպի կարգավորումներ՝ ծանուցումներն անջատելու համար...';

  @override
  String get premiumAccess => 'Պրեմիում մուցք';

  @override
  String get premiumActiveUntil => 'Պրեմիումը ակտիվ է մինչև';

  @override
  String get unlockAllFeatures => 'Ապակողպել բոլոր հնարավորությունները';

  @override
  String get buyPremium => 'Գնել Պրեմիում (7 օր)';

  @override
  String costCoins(Object cost) {
    return 'Արժեքը՝ $cost մետաղադրամ';
  }

  @override
  String get premiumActivated => 'Պրեմիումը ակտիվացված է 7 օրով:';

  @override
  String get premiumActive => 'Պրեմիումը ակտիվ է';

  @override
  String get expires => 'Լրանում է՝';

  @override
  String get temporaryAccess => 'Ժամանակավոր մուտք';

  @override
  String get journalExpression => 'Օրագիր և արտահայտում';

  @override
  String get artisticDesigns => 'Գեղարվեստական դիզայն';

  @override
  String get artisticDesignsDesc =>
      'Ապակողպեք 10+ եզակի օրագրի քարտերի թեմաներ';

  @override
  String get premiumLayouts => 'Պրեմիում դասավորություններ';

  @override
  String get premiumLayoutsDesc =>
      'Ձեր հիշողությունները դիտելու բացառիկ եղանակներ';

  @override
  String get calendarTools => 'Օրացույց և Գործիքներ';

  @override
  String get fullCalendar => 'Լրիվ օրացույց';

  @override
  String get fullCalendarDesc =>
      'Իրադարձությունների կառավարման ամբողջական համակարգ';

  @override
  String get clipboardAutoSaveDesc => 'Բուֆերի պատմության ֆոնային ձայնագրում';

  @override
  String get proWidgets => 'Pro վիդջեթներ';

  @override
  String get proWidgetsDesc =>
      'Բոլոր հնարավորությունները հասանելի են ձեր հիմնական էկրանին';

  @override
  String get dataExport => 'Տվյալներ և Արտահանում';

  @override
  String get advancedBackup => 'Ընդլայնված պահուստավորում';

  @override
  String get advancedBackupDesc =>
      'Բոլոր տվյալների անվտանգ ներմուծում/արտահանում';

  @override
  String get pdfExport => 'PDF արտահանում';

  @override
  String get pdfExportDesc => 'Արտահանել նշումներն ու օրագրերը PDF ձևաչափով';

  @override
  String get printReady => 'Պատրաստ է տպագրության';

  @override
  String get printReadyDesc => 'Ուղղակի տպագրության աջակցություն';

  @override
  String get richTextEditor => 'Հարուստ տեքստային խմբագիր';

  @override
  String get advancedSearch => 'Ընդլայնված որոնում';

  @override
  String get advancedSearchDesc => 'Որոնել և փոխարինել ձեր տեքստում';

  @override
  String get richMedia => 'Հարուստ մեդիա';

  @override
  String get richMediaDesc => 'Տեղադրել նկարներ, տեսանյութեր և հղումներ';

  @override
  String get editorStyling => 'Խմբագրի ոճավորում';

  @override
  String get editorStylingDesc => 'Անհատական տեքստի և խմբագրի ֆոն';

  @override
  String get balance => 'Հաշվեկշիռ';

  @override
  String get loadingAd => 'Գովազդը բեռնվում է...';

  @override
  String watchAd(Object amount) {
    return 'Դիտել գովազդ (+$amount)';
  }

  @override
  String get loadAd => 'Բեռնել գովազդը';

  @override
  String get backupDataDesc => 'Պահպանել ձեր տվյալների JSON ֆայլը';

  @override
  String get importDataDesc => 'Միավորել պահուստային ֆայլը CopyClip-ի հետ';

  @override
  String get notificationPermissionDenied =>
      'Ծանուցումների թույլտվությունը մերժված է:';

  @override
  String get typeNewTask => 'Գրեք նոր առաջադրանք...';

  @override
  String get addTask => 'Ավելացնել առաջադրանք';

  @override
  String get completed => 'Ավարտված է';

  @override
  String get greatJob => 'Հիանալի աշխատանք:';

  @override
  String youEarnedXPNextTask(Object amount, Object date) {
    return 'Դուք վաստակեցիք $amount XP: Հաջորդ առաջադրանքը՝ $date';
  }

  @override
  String taskCompletedXP(Object amount) {
    return 'Առաջադրանքն ավարտված է: +$amount XP';
  }

  @override
  String get moveTasksToRecycleBin =>
      'Տեղափոխե՞լ բոլոր ակտիվ առաջադրանքները աղբաման:';

  @override
  String get deleteAllPosts => 'Ջնջել բոլոր հրապարակումները';

  @override
  String get deleteAllPostsConfirmation =>
      'Վստա՞հ եք, որ ցանկանում եք ջնջել ԲՈԼՈՐ սոցիալական հրապարակումները: Սա հնարավոր չէ չեղարկել:';

  @override
  String get allPosts => 'Բոլոր հրապարակումները';

  @override
  String get favorites => 'Ֆավորիտներ';

  @override
  String get drafts => 'Սևագրեր';

  @override
  String get noFavoritesYet => 'Դեռ ֆավորիտներ չկան';

  @override
  String get noDraftsYet => 'Դեռ սևագրեր չկան';

  @override
  String get startSocialJourney => 'Սկսեք ձեր սոցիալական ճանապարհորդությունը:';

  @override
  String get draft => 'Սևագիր';

  @override
  String attachmentCount(num count) {
    return '$count կցորդ';
  }

  @override
  String get pleaseAddContent =>
      'Խնդրում ենք ավելացնել որոշակի բովանդակություն կամ մեդիա կիսվելու համար';

  @override
  String fileNotFoundError(Object path) {
    return 'Սխալ՝ ֆայլը չի գտնվել $path հասցեում';
  }

  @override
  String get checkFacebookApp => 'Ստուգեք Facebook հավելվածը';

  @override
  String get systemShare => 'Համակարգային կիսվել';

  @override
  String get socialPost => 'Սոցիալական հրապարակում';

  @override
  String get favorite => 'Ֆավորիտ';

  @override
  String get saveDraft => 'Պահպանել սևագիրը';

  @override
  String get entryCopied => 'Գրառումը պատճենված է';

  @override
  String get moveEntriesToRecycleBin =>
      'Տեղափոխե՞լ բոլոր ակտիվ գրառումները աղբաման:';

  @override
  String get startWritingStory => 'Սկսեք գրել ձեր պատմությունը';

  @override
  String get recordMemories =>
      'Գրանցեք ձեր ամենօրյա հիշողություններն ու զգացմունքները:';

  @override
  String get writeJournal => 'Գրել օրագիր';

  @override
  String get myMemories => 'Իմ հիշողությունները';

  @override
  String get sortJournal => 'Տեսակավորել օրագիրը';

  @override
  String get byMood => 'Ըստ տրամադրության';

  @override
  String get searchMemories => 'Որոնել հիշողություններ...';

  @override
  String get selectAll => 'Ընտրել բոլորը';

  @override
  String get deleteSelected => 'Ջնջել ընտրվածները';

  @override
  String get taskCompletedExclamation => 'Առաջադրանքն ավարտված է:';

  @override
  String get taskUncompletedExclamation => 'Առաջադրանքը թերի է';

  @override
  String get clipboardUpdatedExclamation => 'Բուֆերը թարմացված է:';

  @override
  String clipboardSavedContent(Object content) {
    return 'Բուֆերը պահպանված է՝ $content';
  }

  @override
  String get overview => 'Ակնարկ';

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
  String get loadingStepLoading => 'Բեռնում...';

  @override
  String get loadingStepDatabase => 'Տվյալների բազայի կարգավորում...';

  @override
  String get loadingStepSystem => 'Համակարգի կոնֆիգուրացում...';

  @override
  String get loadingStepReady => 'Պատրաստ է';

  @override
  String get productivityCompanion => 'Ձեր արտադրողականության ուղեկիցը';

  @override
  String get done => 'Պատրաստ է';

  @override
  String get newNote => 'Նոր նշում';

  @override
  String get changeColor => 'Փոխել գույնը';

  @override
  String get copyContent => 'Պատճենել բովանդակությունը';

  @override
  String get titleOptional => 'Վերնագիր (ըստ ցանկության)';

  @override
  String get exportAsPdf => 'Արտահանել որպես PDF';

  @override
  String get taskDueNow => 'Առաջադրանքն այս պահին է';

  @override
  String get moveTaskToBinTitle => 'Տեղափոխե՞լ առաջադրանքը աղբաման:';

  @override
  String get restoreTaskLater =>
      'Դուք կարող եք վերականգնել այս առաջադրանքը ավելի ուշ կարգավորումներից:';

  @override
  String get newTask => 'Նոր առաջադրանք';

  @override
  String get editTask => 'Խմբագրել առաջադրանքը';

  @override
  String get undo => 'Հետադարձել';

  @override
  String get redo => 'Կրկնել';

  @override
  String get category => 'Կատեգորիա';

  @override
  String get categoryHint => 'օրինակ՝ Աշխատանք, Մարզասրահ';

  @override
  String get whatNeedsToBeDone => 'Ի՞նչ է պետք անել:';

  @override
  String get enterTaskDetails => 'Մուտքագրեք առաջադրանքի մանրամասները...';

  @override
  String get setDueDate => 'Սահմանել վերջնաժամկետ';

  @override
  String get dueDate => 'Վերջնաժամկետ';

  @override
  String get expenseTitle => 'Ծախսեր';

  @override
  String searchInCurrency(String currency) {
    return 'Որոնել $currency-ով...';
  }

  @override
  String get sortAndFilter => 'Տեսակավորել և Ֆիլտրել';

  @override
  String get sortBy => 'ՏԵՍԱԿԱՎՈՐԵԼ ԸՍՏ';

  @override
  String get highestAmount => 'Ամենաբարձր գումարը';

  @override
  String get lowestAmount => 'Ամենացածր գումարը';

  @override
  String get moreFilters => 'Այլ ֆիլտրեր...';

  @override
  String get filterExpenses => 'Ֆիլտրել ծախսերը';

  @override
  String get transactionType => 'Գործարքի տեսակ';

  @override
  String get categories => 'Կատեգորիաներ';

  @override
  String get all => 'Բոլորը';

  @override
  String get income => 'Եկամուտ';

  @override
  String get expense => 'Ծախս';

  @override
  String get reset => 'Վերակայել';

  @override
  String get apply => 'Կիրառել';

  @override
  String newExpense(String currency) {
    return 'Նոր $currency';
  }

  @override
  String errorLoadingData(String error) {
    return 'Տվյալների բեռնման սխալ:\n\n$error';
  }

  @override
  String get dailyQuote1 =>
      'Ապագան կանխատեսելու լավագույն միջոցը այն ստեղծելն է:';

  @override
  String get dailyQuote2 =>
      'Հարստությունը մեծ ունեցվածք ունենալու մեջ չէ, այլ քիչ կարիքներ ունենալու:';

  @override
  String get dailyQuote3 => 'Ժամանակը գերագույն արժույթն է:';

  @override
  String get dailyQuote4 => 'Հաջողությունը վերջնական չէ, ձախողումը մահացու չէ:';

  @override
  String get dailyQuote5 => 'Կենտրոնացեք լուծման վրա, այլ ոչ թե խնդրի:';

  @override
  String get dailyQuote6 => 'Ձեր կապերը ձեր զուտ արժեքն են:';

  @override
  String get moodHappy => 'Ուրախ';

  @override
  String get moodExcited => 'Ոգևորված';

  @override
  String get moodNeutral => 'Չեզոք';

  @override
  String get moodSad => 'Տխուր';

  @override
  String get moodStressed => 'Սթրեսային';

  @override
  String exportDate(String date) {
    return '📅 $date';
  }

  @override
  String exportMood(String emoji, String mood) {
    return 'Տրամադրություն՝ $emoji $mood';
  }

  @override
  String exportTitle(String title) {
    return 'ՎԵՐՆԱԳԻՐ՝ $title';
  }

  @override
  String exportTags(String tags) {
    return '\nՊիտակներ՝ $tags';
  }

  @override
  String get instagram => 'Instagram';

  @override
  String get facebook => 'Facebook';

  @override
  String get tiktok => 'TikTok';

  @override
  String get newSketch => 'Նոր էսքիզ';

  @override
  String get searchSketches => 'Որոնել էսքիզներ և թղթապանակներ...';

  @override
  String get noResultsFound => 'Արդյունքներ չեն գտնվել';

  @override
  String get noItems => 'Տարրեր չկան';

  @override
  String get noDrawingsYet => 'Դեռ նկարներ չկան';

  @override
  String get canvasIntro =>
      'Սանձազերծեք ձեր ստեղծագործական ունակությունները կտավի վրա:';

  @override
  String get newCanvas => 'Նոր կտավ';

  @override
  String get rename => 'Վերանվանել';

  @override
  String get deleteFolder => 'Ջնջել թղթապանակը';

  @override
  String get deleteSketchesQuestion => 'Ջնջե՞լ էսքիզները';

  @override
  String get deleteFolderConfirmation =>
      'Այս թղթապանակի բոլոր էսքիզները վերջնականապես կջնջվեն:';

  @override
  String get renameFolder => 'Վերանվանել թղթապանակը';

  @override
  String get chooseColor => 'Ընտրել գույնը';

  @override
  String get deleteFolderQuestion => 'Ջնջե՞լ թղթապանակը';

  @override
  String get searchClips => 'Որոնել հատվածներ...';

  @override
  String get clipboardEmpty => 'Բուֆերը դատարկ է';

  @override
  String get addItem => 'Ավելացնել տարր';

  @override
  String get clipColor => 'Հատվածի գույնը';

  @override
  String get newClip => 'Նոր հատված';

  @override
  String get editClip => 'Խմբագրել հատվածը';

  @override
  String get restoreClipLater =>
      'Դուք կարող եք վերականգնել այս հատվածը ավելի ուշ:';

  @override
  String get upcomingEvents => 'Գալիք իրադարձություններ';

  @override
  String get dataDistribution => 'ՏՎՅԱԼՆԵՐԻ ԲԱՇԽՈՒՄ';

  @override
  String get taskProgress => 'ԱՌԱՋԱԴՐԱՆՔՆԵՐԻ ԸՆԹԱՑՔԸ';

  @override
  String get quickStats => 'ԱՐԱԳ ՎԻՃԱԿԱԳՐՈՒԹՅՈՒՆ';

  @override
  String get taskCompletion => 'Առաջադրանքների կատարում';

  @override
  String get noItemsForDate => 'Այս ամսաթվի համար տարրեր չկան';

  @override
  String get enjoyFreeTime => 'Վայելեք ձեր ազատ ժամանակը:';

  @override
  String get searchThisDay => 'Որոնել այս օրվա մեջ...';

  @override
  String get finance => 'Ֆինանսներ';

  @override
  String get permanentlyDelete => 'Ջնջե՞լ վերջնականապես';

  @override
  String deleteSelectionConfirmation(int foldersCount, int sketchesCount) {
    return 'Սա վերջնականապես կջնջի $foldersCount թղթապանակ (և դրանց էսքիզները) և $sketchesCount այլ էսքիզներ:\n\nՍա հնարավոր չէ չեղարկել:';
  }

  @override
  String get deleteForever => 'Ջնջել ընդմիշտ';

  @override
  String selectedCount(int count) {
    return '$count ընտրված է';
  }

  @override
  String canvasStats(int notes, int folders) {
    return '$notes էսքիզ • $folders թղթապանակ';
  }

  @override
  String get sortItems => 'Տեսակավորել տարրերը';

  @override
  String get sortNameAZ => 'Անուն (Ա-Ֆ)';

  @override
  String get sortNameZA => 'Անուն (Ֆ-Ա)';

  @override
  String get createFolder => 'Ստեղծել թղթապանակ';

  @override
  String get folderNameHint => 'Թղթապանակի անունը...';

  @override
  String deleteSketchesConfirmation(int count) {
    return 'Ջնջե՞լ $count էսքիզ: Սա հնարավոր չէ չեղարկել:';
  }

  @override
  String get noSketchesFound => 'Էսքիզներ չեն գտնվել';

  @override
  String get noSketchesFoundSub =>
      'Փորձեք կարգավորել որոնումը կամ ստեղծել նոր էսքիզ:';

  @override
  String searchInFolder(String folder) {
    return 'Որոնել $folder-ում...';
  }

  @override
  String sketchesCount(int count) {
    return '$count էսքիզ';
  }

  @override
  String get sortSketches => 'Տեսակավորել էսքիզները';

  @override
  String get calendarScreenTitle => 'Օրացույց';

  @override
  String get dailyActivity => 'Ամենօրյա գործունեություն';

  @override
  String get deleteItemQuestion => 'Ջնջե՞լ տարրը';

  @override
  String get deleteItemConfirmation => 'Սա կտեղափոխի տարրը աղբաման:';

  @override
  String get moveToBinItem => 'Տեղափոխե՞լ աղբաման:';

  @override
  String get moveToBinConfirmation =>
      'Դուք կարող եք վերականգնել այն ավելի ուշ:';

  @override
  String selectedItems(int count) {
    return '$count ընտրված է';
  }

  @override
  String get recentClips => 'Վերջին հատվածները';

  @override
  String get copied => 'Պատճենված է:';

  @override
  String get copiedPlainText => 'Պատճենված է սովորական տեքստը';

  @override
  String get clipTheme => 'Հատվածի թեման';

  @override
  String get justNow => 'Հենց նոր';

  @override
  String minutesAgo(Object count) {
    return '$countր առաջ';
  }

  @override
  String hoursAgo(Object count) {
    return '$countժ առաջ';
  }

  @override
  String daysAgo(Object count) {
    return '$countօր առաջ';
  }

  @override
  String get noTasksFound => 'Առաջադրանքներ չեն գտնվել:';

  @override
  String get searchTasks => 'Որոնել առաջադրանքներ...';

  @override
  String get taskReminder => 'Հիշեցում առաջադրանքի մասին';

  @override
  String get untitledNote => 'Անվերնագիր նշում';

  @override
  String get dailyEntry => 'Ամենօրյա գրառում';

  @override
  String get clipboardHistory => 'Բուֆերի պատմություն';

  @override
  String get deletePermanentlyContent =>
      'Այս գործողությունը հնարավոր չէ չեղարկել:';

  @override
  String get emptyRecycleBinTitle => 'Դատարկե՞լ աղբամանը';

  @override
  String emptyRecycleBinContent(Object count) {
    return 'Բոլոր $count տարրերը վերջնականապես կջնջվեն:';
  }

  @override
  String get emptyBin => 'Դատարկել աղբամանը';

  @override
  String get recycleBinEmpty => 'Աղբամանը դատարկ է';

  @override
  String get deletedItemsAppearHere => 'Ջնջված տարրերը կհայտնվեն այստեղ:';

  @override
  String get empty => 'Դատարկ';

  @override
  String get recent => 'Վերջին';

  @override
  String categoryLabel(Object category) {
    return 'Կատեգորիա՝ $category';
  }

  @override
  String get general => 'Ընդհանուր';

  @override
  String get saveTransactionQuestion => 'Ցանկանու՞մ եք պահպանել այս գործարքը:';

  @override
  String get fillTitleAmount => 'Խնդրում ենք լրացնել վերնագիրը և գումարը';

  @override
  String get invalidAmount => 'Գումարի անվավեր ձևաչափ';

  @override
  String get moveTransactionToBinTitle => 'Տեղափոխե՞լ գործարքը աղբաման:';

  @override
  String get restoreTransactionLater =>
      'Դուք կարող եք վերականգնել այս գործարքը ավելի ուշ կարգավորումներից:';

  @override
  String get newTransaction => 'Նոր գործարք';

  @override
  String get whatIsThisFor => 'What is this for?';

  @override
  String get description => 'Նկարագրություն';

  @override
  String get daily => 'Օրական';

  @override
  String get weekly => 'Շաբաթական';

  @override
  String get monthly => 'Ամսական';

  @override
  String get yearly => 'Տարեկան';

  @override
  String get totalIncome => 'Ընդհանուր եկամուտ';

  @override
  String get totalExpense => 'Ընդհանուր ծախս';

  @override
  String get analysis => 'Վերլուծություն';

  @override
  String get transactions => 'Գործարքներ';

  @override
  String get noExpensesFound => 'Այս ժամանակահատվածի համար ծախսեր չեն գտնվել:';

  @override
  String get netBalance => 'Զուտ հաշվեկշիռ';

  @override
  String get topCategories => 'Հիմնական կատեգորիաներ';

  @override
  String get spendingTrend => 'Ծախսերի միտումը';

  @override
  String get insights => 'Խորհուրդներ';

  @override
  String get noExpensesRecorded => 'Ծախսեր չեն գրանցվել';

  @override
  String get trackSpendingHabits =>
      'Հեշտությամբ հետևեք ձեր ծախսային սովորություններին:';

  @override
  String get addExpense => 'Ավելացնել ծախս';

  @override
  String get noDataForPeriod => 'Այս ժամանակահատվածի համար տվյալներ չկան';

  @override
  String get budget => 'Բյուջե';

  @override
  String get spent => 'Ծախսված է';

  @override
  String get limit => 'Սահմանաչափ';

  @override
  String get overBudget => 'Բյուջեն գերազանցված է:';

  @override
  String remainingBudget(Object percent) {
    return 'մնացել է $percent%';
  }

  @override
  String get savingsRate => 'Խնայողության չափը';

  @override
  String get healthScore => 'Առողջության միավոր';

  @override
  String get healthScoreExplanation =>
      'Այս միավորը հիմնված է ձեր խնայողության չափի վրա:\n\n• > 50% խնայված = Գերազանց (100)\n• 0% խնայված = Միջին (50)\n• Ծախսերը > Եկամուտները = Վատ (<50)';

  @override
  String get ok => 'Լավ';

  @override
  String get bulkImport => 'Bulk Import';
}

/// The translations for Armenian, as used in Armenia (`hy_AM`).
class AppLocalizationsHyAm extends AppLocalizationsHy {
  AppLocalizationsHyAm() : super('hy_AM');

  @override
  String get settings => 'Կարգավորումներ';

  @override
  String get language => 'Լեզու';

  @override
  String get systemDefault => 'Համակարգային լռելյայն';

  @override
  String get notes => 'Նշումներ';

  @override
  String get todos => 'Անելիքներ';

  @override
  String get expenses => 'Ծախսեր';

  @override
  String get journal => 'Օրագիր';

  @override
  String get calendar => 'Օրացույց';

  @override
  String get clipboard => 'Բուֆեր';

  @override
  String get canvas => 'Կտավ';

  @override
  String get save => 'Պահպանել';

  @override
  String get create => 'Ստեղծել';

  @override
  String get cancel => 'Չեղարկել';

  @override
  String get delete => 'Ջնջել';

  @override
  String get edit => 'Խմբագրել';

  @override
  String get share => 'Կիսվել';

  @override
  String get copy => 'Պատճենել';

  @override
  String get unsavedChanges => 'Չպահպանված փոփոխություններ';

  @override
  String get confirmDelete => 'Հաստատել ջնջումը';

  @override
  String get discard => 'Չեղարկել';

  @override
  String get createPost => 'Ստեղծել հրապարակում';

  @override
  String get post => 'Հրապարակել';

  @override
  String get postingTo => 'Հրապարակումը՝';

  @override
  String get whatsOnYourMind => 'Ի՞նչ կա ձեր մտքում:';

  @override
  String get pickImages => 'Ընտրել նկարներ';

  @override
  String get pickVideo => 'Ընտրել տեսանյութ';

  @override
  String get camera => 'Տեսախցիկ';

  @override
  String get gallery => 'Պատկերասրահ';

  @override
  String get search => 'Որոնել';

  @override
  String get pleaseEnterTask => 'Մուտքագրեք առաջադրանքը';

  @override
  String get deleteTask => 'Ջնջել առաջադրանքը';

  @override
  String get selectItems => 'Ընտրել տարրեր';

  @override
  String get deleteAll => 'Ջնջել բոլորը';

  @override
  String error(Object error) {
    return 'Սխալ՝ $error';
  }

  @override
  String get orderingOnlyAvailableInAllPosts =>
      'Դասավորումը հասանելի է միայն «Բոլոր հրապարակումներում»';

  @override
  String get deletePost => 'Ջնջել հրապարակումը';

  @override
  String get postDeleted => 'Հրապարակումը ջնջված է';

  @override
  String get premiumFeatures => 'Պրեմիում հնարավորություններ';

  @override
  String get manageCoinsAdsPremium =>
      'Կառավարել մետաղադրամները, գովազդը և պրեմիում կարգավիճակը';

  @override
  String get themeMode => 'Թեմայի ռեժիմ';

  @override
  String get accentColor => 'Շեշտադրման գույն';

  @override
  String get backgroundDesign => 'Ֆոնի դիզայն';

  @override
  String get pushNotifications => 'Push ծանուցումներ';

  @override
  String get recycleBin => 'Աղբաման';

  @override
  String get exportData => 'Արտահանել տվյալները';

  @override
  String get importData => 'Ներմուծել տվյալները';

  @override
  String get rateApp => 'Գնահատել հավելվածը';

  @override
  String get sendFeedback => 'Ուղարկել հետադարձ կապ';

  @override
  String get privacyPolicy => 'Գաղտնիության քաղաքականություն';

  @override
  String get version => 'Տարբերակ';

  @override
  String get buildNumber => 'Build համարը';

  @override
  String get system => 'Համակարգային';

  @override
  String get light => 'Լուսավոր';

  @override
  String get dark => 'Մուգ';

  @override
  String get itemRestored => 'Տարրը վերականգնված է';

  @override
  String get recycleBinCleared => 'Աղբամանը հաջողությամբ դատարկվեց';

  @override
  String get allPostsDeleted => 'Բոլոր հրապարակումները ջնջված են';

  @override
  String get newPost => 'Նոր հրապարակում';

  @override
  String get textCopiedToClipboardFacebook =>
      'Տեքստը պատճենված է բուֆերում (Facebook-ի քաղաքականություն)';

  @override
  String get tiktokSharingRequiresVideoImage =>
      'TikTok-ով կիսվելու համար անհրաժեշտ է տեսանյութ/նկար';

  @override
  String errorSharing(Object error) {
    return 'Կիսվելու սխալ՝ $error';
  }

  @override
  String shareToStory(Object platform) {
    return 'Կիսվել $platform Story-ում';
  }

  @override
  String shareToFeed(Object platform) {
    return 'Կիսվել $platform Feed-ում';
  }

  @override
  String get unlockPermanently => 'Ապակողպել ընդմիշտ';

  @override
  String get notEnoughCoins => 'Բավարար մետաղադրամներ չկան:';

  @override
  String youEarnedCoins(Object amount) {
    return 'Դուք վաստակեցիք $amount մետաղադրամ:';
  }

  @override
  String get contentCopied => 'Բովանդակությունը պատճենված է';

  @override
  String get selectDateTime => 'Ընտրել ամսաթիվը և ժամը';

  @override
  String get areYouSureYouWantToDeleteThisPost =>
      'Վստա՞հ եք, որ ցանկանում եք ջնջել այս հրապարակումը:';

  @override
  String get socialPosts => 'Սոցիալական հրապարակումներ';

  @override
  String get watchAdToEarnCoins =>
      'Դիտեք գովազդ մետաղադրամներ վաստակելու համար';

  @override
  String get premiumUnlocked => 'Պրեմիումն ապակողպված է';

  @override
  String get removeAds => 'Հեռացնել գովազդը';

  @override
  String get unlimitedCloudStorage => 'Անսահմանափակ ամպային պահեստ';

  @override
  String get deleteNote => 'Ջնջել նշումը';

  @override
  String get shareNote => 'Կիսվել նշումով';

  @override
  String get editNote => 'Խմբագրել նշումը';

  @override
  String get searchNotes => 'Որոնել նշումներ...';

  @override
  String get noNotesFound => 'Նշումներ չեն գտնվել';

  @override
  String get captureThoughts => 'Ակնթարթորեն գրանցեք ձեր մտքերը:';

  @override
  String get createNote => 'Ստեղծել նշում';

  @override
  String get customOrder => 'Անհատական կարգ';

  @override
  String get newestFirst => 'Նորերը սկզբում';

  @override
  String get oldestFirst => 'Հիները սկզբում';

  @override
  String get titleAZ => 'Վերնագիր՝ Ա-Ֆ';

  @override
  String get titleZA => 'Վերնագիր՝ Ֆ-Ա';

  @override
  String get deleteAllQuestion => 'Ջնջե՞լ բոլորը';

  @override
  String get moveToRecycleBin => 'Տեղափոխե՞լ բոլոր նշումները աղբաման:';

  @override
  String get moveToBinQuestion => 'Տեղափոխե՞լ աղբաման:';

  @override
  String get restoreNoteLater =>
      'Դուք կարող եք վերականգնել այս նշումը ավելի ուշ:';

  @override
  String get move => 'Տեղափոխել';

  @override
  String get myThoughts => 'Իմ մտքերը';

  @override
  String get selected => 'Ընտրված է';

  @override
  String get noContent => 'Բովանդակություն չկա';

  @override
  String get untitled => 'Անվերնագիր';

  @override
  String get chooseWallpapers => 'Ընտրեք 10+ դինամիկ պաստառներից';

  @override
  String get backupData => 'Տվյալների պահպանում';

  @override
  String get saveJsonFile =>
      'Պահպանե՞լ JSON ֆայլը, որը պարունակում է ձեր բոլոր տվյալները:';

  @override
  String get exportNow => 'Արտահանել հիմա';

  @override
  String get importDataTitle => 'Ներմուծել տվյալները';

  @override
  String get mergeBackupFile =>
      'Միավորե՞լ պահուստային ֆայլը ձեր ընթացիկ տարրերի հետ:';

  @override
  String get selectFile => 'Ընտրել ֆայլ';

  @override
  String get backupSaved => 'Պահուստային պատճենը հաջողությամբ պահպանվեց:';

  @override
  String get exportFailed => 'Արտահանումը ձախողվեց:';

  @override
  String importSuccess(Object count) {
    return '$count տարր հաջողությամբ վերականգնվեց:';
  }

  @override
  String get importFailed => 'Ներմուծումը ձախողվեց:';

  @override
  String widgetAdded(String widget) {
    return 'Վիդջեթը ավելացված է հիմնական էկրանին:';
  }

  @override
  String get widgetRequestSent =>
      'Վիդջեթի հարցումն ուղարկված է: Խնդրում ենք ստուգել ձեր հիմնական էկրանը:';

  @override
  String get widgetAddFailed => 'Չհաջողվեց ավելացնել վիդջեթը';

  @override
  String get autoSaveEnabled => 'Ավտոմատ պահպանումը միացված է:';

  @override
  String get autoSaveDisabled => 'Ավտոմատ պահպանումը անջատված է:';

  @override
  String get homeScreenWidgets => 'Հիմնական էկրանի վիդջեթներ';

  @override
  String get notificationsTitle => 'Ծանուցումներ';

  @override
  String get dataBackup => 'Տվյալներ և Պահուստավորում';

  @override
  String get feedbackSupport => 'Հետադարձ կապ և Աջակցություն';

  @override
  String get creditsTitle => 'Հեղինակներ';

  @override
  String get privacyMaintenance => 'Գաղտնիություն և Սպասարկում';

  @override
  String get aboutTitle => 'Մասին';

  @override
  String get premium => 'Պրեմիում';

  @override
  String get appearanceTitle => 'Արտաքին տեսք';

  @override
  String get clipboardTitle => 'Բուֆեր';

  @override
  String get settingsSubtitle => 'Անհատականացրեք ձեր փորձը';

  @override
  String get welcomeTitle => 'Բարի գալուստ CopyClip';

  @override
  String get welcomeDescription =>
      'Ձեր լավագույն արտադրողականության ուղեկիցը: Եկեք կարգավորենք հզոր գործիքներ՝ ձեր օրը կառավարելու համար:';

  @override
  String get onboardingNotesTitle => 'Խելացի նշումներ';

  @override
  String get onboardingNotesDesc =>
      'Ակնթարթորեն գրանցեք գաղափարները տեքստի հարուստ ձևաչափմամբ: Կազմակերպեք ձեր մտքերը և երբեք բաց մի թողեք հիանալի գաղափար:';

  @override
  String get onboardingTodosTitle => 'Առաջադրանքների կառավարում';

  @override
  String get onboardingTodosDesc =>
      'Մնացեք խաղի մեջ: Ստեղծեք անելիքների ցուցակներ, սահմանեք առաջնահերթություններ և հասեք ձեր նպատակներին քայլ առ քայլ:';

  @override
  String get onboardingExpensesTitle => 'Ծախսերի հետևում';

  @override
  String get onboardingExpensesDesc =>
      'Վերահսկեք ձեր ֆինանսները: Հեշտությամբ հետևեք եկամուտներին և ծախսերին՝ ձեր ծախսային սովորությունները հասկանալու համար:';

  @override
  String get onboardingJournalTitle => 'Անձնական օրագիր';

  @override
  String get onboardingJournalDesc =>
      'Մտորեք ձեր օրվա մասին: Մասնավոր տարածք ձեր հիշողությունները, զգացմունքները և ամենօրյա փորձառությունները գրի առնելու համար:';

  @override
  String get onboardingCalendarTitle => 'Օրացույց և Իրադարձություններ';

  @override
  String get onboardingCalendarDesc =>
      'Երբեք բաց մի թողեք ոչ մի պահ: Կազմակերպեք ձեր ժամանակացույցը և հետևեք կարևոր գալիք իրադարձություններին:';

  @override
  String get onboardingClipboardTitle => 'Բուֆերի կառավարիչ';

  @override
  String get onboardingClipboardDesc =>
      'Պատճենեք մեկ անգամ, տեղադրեք ցանկացած տեղ: Մուտք գործեք ձեր բուֆերի պատմություն՝ նախկինում պատճենված հատվածները վերականգնելու համար:';

  @override
  String get onboardingCanvasTitle => 'Ստեղծագործական կտավ';

  @override
  String get onboardingCanvasDesc =>
      'Սանձազերծեք ձեր ստեղծագործական ունակությունները: Նկարեք, էսքիզներ արեք և վիզուալացրեք ձեր գաղափարները թվային կտավի վրա:';

  @override
  String get featuresNotesDesc => 'Ստեղծեք և կառավարեք ձեր նշումները';

  @override
  String get featuresTodosDesc => 'Հետևեք ձեր առաջադրանքներին';

  @override
  String get featuresExpensesDesc => 'Վերահսկեք ձեր ծախսերը';

  @override
  String get featuresJournalDesc => 'Գրի առեք ձեր մտքերը';

  @override
  String get featuresCalendarDesc => 'Կազմակերպեք ձեր ժամանակացույցը';

  @override
  String get featuresClipboardDesc => 'Մուտք գործեք բուֆերի պատմություն';

  @override
  String get featuresCanvasDesc => 'Նկարեք և էսքիզներ արեք ազատորեն';

  @override
  String get featuresSocialPost => 'Սոցիալական հրապարակում';

  @override
  String get featuresSocialPostDesc =>
      'Ստեղծեք գրավիչ սոցիալական մեդիա բովանդակություն';

  @override
  String get chooseYourAura => 'Ընտրեք ձեր աուրան';

  @override
  String get expressYourselfTheme => 'Արտահայտվեք թեմայի նոր գույնով:';

  @override
  String get level => 'Մակարդակ';

  @override
  String get xpToNextLevel => 'XP մինչև հաջորդ մակարդակ';

  @override
  String get checkUpcomingEvents => 'Ստուգել գալիք իրադարձությունները';

  @override
  String get startNewSketch => 'Սկսել նոր էսքիզ';

  @override
  String get noTransactionsMonth => 'Այս ամիս գործարքներ չկան';

  @override
  String transactionsThisMonth(num count) {
    return '$count գործարք այս ամիս';
  }

  @override
  String get autoSaveClipboard => 'Բուֆերի ավտոմատ պահպանում';

  @override
  String get autoSaveClipboardDesc =>
      'Ավտոմատ կերպով պահպանել պատճենված տարրերը';

  @override
  String get permissionDeniedSettings =>
      'Թույլտվությունը վերջնականապես մերժված է: Խնդրում ենք միացնել Կարգավորումներում:';

  @override
  String get notificationsEnabled => 'Ծանուցումները միացված են:';

  @override
  String get redirectingToSettings =>
      'Վերահասցեավորում դեպի կարգավորումներ՝ ծանուցումներն անջատելու համար...';

  @override
  String get premiumAccess => 'Պրեմիում մուտք';

  @override
  String get premiumActiveUntil => 'Պրեմիումը ակտիվ է մինչև';

  @override
  String get unlockAllFeatures => 'Ապակողպել բոլոր հնարավորությունները';

  @override
  String get buyPremium => 'Գնել Պրեմիում (7 օր)';

  @override
  String costCoins(Object cost) {
    return 'Արժեքը՝ $cost մետաղադրամ';
  }

  @override
  String get premiumActivated => 'Պրեմիումը ակտիվացված է 7 օրով:';

  @override
  String get premiumActive => 'Պրեմիումը ակտիվ է';

  @override
  String get expires => 'Լրանում է՝';

  @override
  String get temporaryAccess => 'Ժամանակավոր մուտք';

  @override
  String get journalExpression => 'Օրագիր և արտահայտում';

  @override
  String get artisticDesigns => 'Գեղարվեստական դիզայն';

  @override
  String get artisticDesignsDesc =>
      'Ապակողպեք 10+ եզակի օրագրի քարտերի թեմաներ';

  @override
  String get premiumLayouts => 'Պրեմիում դասավորություններ';

  @override
  String get premiumLayoutsDesc =>
      'Ձեր հիշողությունները դիտելու բացառիկ եղանակներ';

  @override
  String get calendarTools => 'Օրացույց և Գործիքներ';

  @override
  String get fullCalendar => 'Լրիվ օրացույց';

  @override
  String get fullCalendarDesc =>
      'Իրադարձությունների կառավարման ամբողջական համակարգ';

  @override
  String get clipboardAutoSaveDesc => 'Բուֆերի պատմության ֆոնային ձայնագրում';

  @override
  String get proWidgets => 'Pro վիդջեթներ';

  @override
  String get proWidgetsDesc =>
      'Բոլոր հնարավորությունները հասանելի են ձեր հիմնական էկրանին';

  @override
  String get dataExport => 'Տվյալներ և Արտահանում';

  @override
  String get advancedBackup => 'Ընդլայնված պահուստավորում';

  @override
  String get advancedBackupDesc =>
      'Բոլոր տվյալների անվտանգ ներմուծում/արտահանում';

  @override
  String get pdfExport => 'PDF արտահանում';

  @override
  String get pdfExportDesc => 'Արտահանել նշումներն ու օրագրերը PDF ձևաչափով';

  @override
  String get printReady => 'Պատրաստ է տպագրության';

  @override
  String get printReadyDesc => 'Ուղղակի տպագրության աջակցություն';

  @override
  String get richTextEditor => 'Հարուստ տեքստային խմբագիր';

  @override
  String get advancedSearch => 'Ընդլայնված որոնում';

  @override
  String get advancedSearchDesc => 'Որոնել և փոխարինել ձեր տեքստում';

  @override
  String get richMedia => 'Հարուստ մեդիա';

  @override
  String get richMediaDesc => 'Տեղադրել նկարներ, տեսանյութեր և հղումներ';

  @override
  String get editorStyling => 'Խմբագրի ոճավորում';

  @override
  String get editorStylingDesc => 'Անհատական տեքստի և խմբագրի ֆոն';

  @override
  String get balance => 'Հաշվեկշիռ';

  @override
  String get loadingAd => 'Գովազդը բեռնվում է...';

  @override
  String watchAd(Object amount) {
    return 'Դիտել գովազդ (+$amount)';
  }

  @override
  String get loadAd => 'Բեռնել գովազդը';

  @override
  String get backupDataDesc => 'Պահպանել ձեր տվյալների JSON ֆայլը';

  @override
  String get importDataDesc => 'Միավորել պահուստային ֆայլը CopyClip-ի հետ';

  @override
  String get notificationPermissionDenied =>
      'Ծանուցումների թույլտվությունը մերժված է:';

  @override
  String get typeNewTask => 'Գրեք նոր առաջադրանք...';

  @override
  String get addTask => 'Ավելացնել առաջադրանք';

  @override
  String get completed => 'Ավարտված է';

  @override
  String get greatJob => 'Հիանալի աշխատանք:';

  @override
  String youEarnedXPNextTask(Object amount, Object date) {
    return 'Դուք վաստակեցիք $amount XP: Հաջորդ առաջադրանքը՝ $date';
  }

  @override
  String taskCompletedXP(Object amount) {
    return 'Առաջադրանքն ավարտված է: +$amount XP';
  }

  @override
  String get moveTasksToRecycleBin =>
      'Տեղափոխե՞լ բոլոր ակտիվ առաջադրանքները աղբաման:';

  @override
  String get deleteAllPosts => 'Ջնջել բոլոր հրապարակումները';

  @override
  String get deleteAllPostsConfirmation =>
      'Վստա՞հ եք, որ ցանկանում եք ջնջել ԲՈԼՈՐ սոցիալական հրապարակումները: Սա հնարավոր չէ չեղարկել:';

  @override
  String get allPosts => 'Բոլոր հրապարակումները';

  @override
  String get favorites => 'Ֆավորիտներ';

  @override
  String get drafts => 'Սևագրեր';

  @override
  String get noFavoritesYet => 'Դեռ ֆավորիտներ չկան';

  @override
  String get noDraftsYet => 'Դեռ սևագրեր չկան';

  @override
  String get startSocialJourney => 'Սկսեք ձեր սոցիալական ճանապարհորդությունը:';

  @override
  String get draft => 'Սևագիր';

  @override
  String attachmentCount(num count) {
    return '$count կցորդ';
  }

  @override
  String get pleaseAddContent =>
      'Խնդրում ենք ավելացնել որոշակի բովանդակություն կամ մեդիա կիսվելու համար';

  @override
  String fileNotFoundError(Object path) {
    return 'Սխալ՝ ֆայլը չի գտնվել $path հասցեում';
  }

  @override
  String get checkFacebookApp => 'Ստուգեք Facebook հավելվածը';

  @override
  String get systemShare => 'Համակարգային կիսվել';

  @override
  String get socialPost => 'Սոցիալական հրապարակում';

  @override
  String get favorite => 'Ֆավորիտ';

  @override
  String get saveDraft => 'Պահպանել սևագիրը';

  @override
  String get entryCopied => 'Գրառումը պատճենված է';

  @override
  String get moveEntriesToRecycleBin =>
      'Տեղափոխե՞լ բոլոր ակտիվ գրառումները աղբաման:';

  @override
  String get startWritingStory => 'Սկսեք գրել ձեր պատմությունը';

  @override
  String get recordMemories =>
      'Գրանցեք ձեր ամենօրյա հիշողություններն ու զգացմունքները:';

  @override
  String get writeJournal => 'Գրել օրագիր';

  @override
  String get myMemories => 'Իմ հիշողությունները';

  @override
  String get sortJournal => 'Տեսակավորել օրագիրը';

  @override
  String get byMood => 'Ըստ տրամադրության';

  @override
  String get searchMemories => 'Որոնել հիշողություններ...';

  @override
  String get selectAll => 'Ընտրել բոլորը';

  @override
  String get deleteSelected => 'Ջնջել ընտրվածները';

  @override
  String get taskCompletedExclamation => 'Առաջադրանքն ավարտված է:';

  @override
  String get taskUncompletedExclamation => 'Առաջադրանքը թերի է';

  @override
  String get clipboardUpdatedExclamation => 'Բուֆերը թարմացված է:';

  @override
  String clipboardSavedContent(Object content) {
    return 'Բուֆերը պահպանված է՝ $content';
  }

  @override
  String get overview => 'Ակնարկ';

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
  String get loadingStepLoading => 'Բեռնում...';

  @override
  String get loadingStepDatabase => 'Տվյալների բազայի կարգավորում...';

  @override
  String get loadingStepSystem => 'Համակարգի կոնֆիգուրացում...';

  @override
  String get loadingStepReady => 'Պատրաստ է';

  @override
  String get productivityCompanion => 'Ձեր արտադրողականության ուղեկիցը';

  @override
  String get done => 'Պատրաստ է';

  @override
  String get newNote => 'Նոր նշում';

  @override
  String get changeColor => 'Փոխել գույնը';

  @override
  String get copyContent => 'Պատճենել բովանդակությունը';

  @override
  String get titleOptional => 'Վերնագիր (ըստ ցանկության)';

  @override
  String get exportAsPdf => 'Արտահանել որպես PDF';

  @override
  String get taskDueNow => 'Առաջադրանքն այս պահին է';

  @override
  String get moveTaskToBinTitle => 'Տեղափոխե՞լ առաջադրանքը աղբաման:';

  @override
  String get restoreTaskLater =>
      'Դուք կարող եք վերականգնել այս առաջադրանքը ավելի ուշ կարգավորումներից:';

  @override
  String get newTask => 'Նոր առաջադրանք';

  @override
  String get editTask => 'Խմբագրել առաջադրանքը';

  @override
  String get undo => 'Հետադարձել';

  @override
  String get redo => 'Կրկնել';

  @override
  String get category => 'Կատեգորիա';

  @override
  String get categoryHint => 'օրինակ՝ Աշխատանք, Մարզասրահ';

  @override
  String get whatNeedsToBeDone => 'Ի՞նչ է պետք անել:';

  @override
  String get enterTaskDetails => 'Մուտքագրեք առաջադրանքի մանրամասները...';

  @override
  String get setDueDate => 'Սահմանել վերջնաժամկետ';

  @override
  String get dueDate => 'Վերջնաժամկետ';

  @override
  String get expenseTitle => 'Ծախսեր';

  @override
  String searchInCurrency(String currency) {
    return 'Որոնել $currency-ով...';
  }

  @override
  String get sortAndFilter => 'Տեսակավորել և Ֆիլտրել';

  @override
  String get sortBy => 'ՏԵՍԱԿԱՎՈՐԵԼ ԸՍՏ';

  @override
  String get highestAmount => 'Ամենաբարձր գումարը';

  @override
  String get lowestAmount => 'Ամենացածր գումարը';

  @override
  String get moreFilters => 'Այլ ֆիլտրեր...';

  @override
  String get filterExpenses => 'Ֆիլտրել ծախսերը';

  @override
  String get transactionType => 'Գործարքի տեսակ';

  @override
  String get categories => 'Կատեգորիաներ';

  @override
  String get all => 'Բոլորը';

  @override
  String get income => 'Եկամուտ';

  @override
  String get expense => 'Ծախս';

  @override
  String get reset => 'Վերակայել';

  @override
  String get apply => 'Կիրառել';

  @override
  String newExpense(String currency) {
    return 'Նոր $currency';
  }

  @override
  String errorLoadingData(String error) {
    return 'Տվյալների բեռնման սխալ:\n\n$error';
  }

  @override
  String get dailyQuote1 =>
      'Ապագան կանխատեսելու լավագույն միջոցը այն ստեղծելն է:';

  @override
  String get dailyQuote2 =>
      'Հարստությունը մեծ ունեցվածք ունենալու մեջ չէ, այլ քիչ կարիքներ ունենալու:';

  @override
  String get dailyQuote3 => 'Ժամանակը գերագույն արժույթն է:';

  @override
  String get dailyQuote4 => 'Հաջողությունը վերջնական չէ, ձախողումը մահացու չէ:';

  @override
  String get dailyQuote5 => 'Կենտրոնացեք լուծման վրա, այլ ոչ թե խնդրի:';

  @override
  String get dailyQuote6 => 'Ձեր կապերը ձեր զուտ արժեքն են:';

  @override
  String get moodHappy => 'Ուրախ';

  @override
  String get moodExcited => 'Ոգևորված';

  @override
  String get moodNeutral => 'Չեզոք';

  @override
  String get moodSad => 'Տխուր';

  @override
  String get moodStressed => 'Սթրեսային';

  @override
  String exportDate(String date) {
    return '📅 $date';
  }

  @override
  String exportMood(String emoji, String mood) {
    return 'Տրամադրություն՝ $emoji $mood';
  }

  @override
  String exportTitle(String title) {
    return 'ՎԵՐՆԱԳԻՐ՝ $title';
  }

  @override
  String exportTags(String tags) {
    return '\nՊիտակներ՝ $tags';
  }

  @override
  String get instagram => 'Instagram';

  @override
  String get facebook => 'Facebook';

  @override
  String get tiktok => 'TikTok';

  @override
  String get newSketch => 'Նոր էսքիզ';

  @override
  String get searchSketches => 'Որոնել էսքիզներ և թղթապանակներ...';

  @override
  String get noResultsFound => 'Արդյունքներ չեն գտնվել';

  @override
  String get noItems => 'Տարրեր չկան';

  @override
  String get noDrawingsYet => 'Դեռ նկարներ չկան';

  @override
  String get canvasIntro =>
      'Սանձազերծեք ձեր ստեղծագործական ունակությունները կտավի վրա:';

  @override
  String get newCanvas => 'Նոր կտավ';

  @override
  String get rename => 'Վերանվանել';

  @override
  String get deleteFolder => 'Ջնջել թղթապանակը';

  @override
  String get deleteSketchesQuestion => 'Ջնջե՞լ էսքիզները';

  @override
  String get deleteFolderConfirmation =>
      'Այս թղթապանակի բոլոր էսքիզները վերջնականապես կջնջվեն:';

  @override
  String get renameFolder => 'Վերանվանել թղթապանակը';

  @override
  String get chooseColor => 'Ընտրել գույնը';

  @override
  String get deleteFolderQuestion => 'Ջնջե՞լ թղթապանակը';

  @override
  String get searchClips => 'Որոնել հատվածներ...';

  @override
  String get clipboardEmpty => 'Բուֆերը դատարկ է';

  @override
  String get addItem => 'Ավելացնել տարր';

  @override
  String get clipColor => 'Հատվածի գույնը';

  @override
  String get newClip => 'Նոր հատված';

  @override
  String get editClip => 'Խմբագրել հատվածը';

  @override
  String get restoreClipLater =>
      'Դուք կարող եք վերականգնել այս հատվածը ավելի ուշ:';

  @override
  String get upcomingEvents => 'Գալիք իրադարձություններ';

  @override
  String get dataDistribution => 'ՏՎՅԱԼՆԵՐԻ ԲԱՇԽՈՒՄ';

  @override
  String get taskProgress => 'ԱՌԱՋԱԴՐԱՆՔՆԵՐԻ ԸՆԹԱՑՔԸ';

  @override
  String get quickStats => 'ԱՐԱԳ ՎԻՃԱԿԱԳՐՈՒԹՅՈՒՆ';

  @override
  String get taskCompletion => 'Առաջադրանքների կատարում';

  @override
  String get noItemsForDate => 'Այս ամսաթվի համար տարրեր չկան';

  @override
  String get enjoyFreeTime => 'Վայելեք ձեր ազատ ժամանակը:';

  @override
  String get searchThisDay => 'Որոնել այս օրվա մեջ...';

  @override
  String get finance => 'Ֆինանսներ';

  @override
  String get permanentlyDelete => 'Ջնջե՞լ վերջնականապես';

  @override
  String deleteSelectionConfirmation(int foldersCount, int sketchesCount) {
    return 'Սա վերջնականապես կջնջի $foldersCount թղթապանակ (և դրանց էսքիզները) և $sketchesCount այլ էսքիզներ:\n\nՍա հնարավոր չէ չեղարկել:';
  }

  @override
  String get deleteForever => 'Ջնջել ընդմիշտ';

  @override
  String selectedCount(int count) {
    return '$count ընտրված է';
  }

  @override
  String canvasStats(int notes, int folders) {
    return '$notes էսքիզ • $folders թղթապանակ';
  }

  @override
  String get sortItems => 'Տեսակավորել տարրերը';

  @override
  String get sortNameAZ => 'Անուն (Ա-Ֆ)';

  @override
  String get sortNameZA => 'Անուն (Ֆ-Ա)';

  @override
  String get createFolder => 'Ստեղծել թղթապանակ';

  @override
  String get folderNameHint => 'Թղթապանակի անունը...';

  @override
  String deleteSketchesConfirmation(int count) {
    return 'Ջնջե՞լ $count էսքիզ: Սա հնարավոր չէ չեղարկել:';
  }

  @override
  String get noSketchesFound => 'Էսքիզներ չեն գտնվել';

  @override
  String get noSketchesFoundSub =>
      'Փորձեք կարգավորել որոնումը կամ ստեղծել նոր էսքիզ:';

  @override
  String searchInFolder(String folder) {
    return 'Որոնել $folder-ում...';
  }

  @override
  String sketchesCount(int count) {
    return '$count էսքիզ';
  }

  @override
  String get sortSketches => 'Տեսակավորել էսքիզները';

  @override
  String get calendarScreenTitle => 'Օրացույց';

  @override
  String get dailyActivity => 'Ամենօրյա գործունեություն';

  @override
  String get deleteItemQuestion => 'Ջնջե՞լ տարրը';

  @override
  String get deleteItemConfirmation => 'Սա կտեղափոխի տարրը աղբաման:';

  @override
  String get moveToBinItem => 'Տեղափոխե՞լ աղբաման:';

  @override
  String get moveToBinConfirmation =>
      'Դուք կարող եք վերականգնել այն ավելի ուշ:';

  @override
  String selectedItems(int count) {
    return '$count ընտրված է';
  }

  @override
  String get recentClips => 'Վերջին հատվածները';

  @override
  String get copied => 'Պատճենված է:';

  @override
  String get copiedPlainText => 'Պատճենված է սովորական տեքստը';

  @override
  String get clipTheme => 'Հատվածի թեման';

  @override
  String get justNow => 'Հենց նոր';

  @override
  String minutesAgo(Object count) {
    return '$countր առաջ';
  }

  @override
  String hoursAgo(Object count) {
    return '$countժ առաջ';
  }

  @override
  String daysAgo(Object count) {
    return '$countօր առաջ';
  }

  @override
  String get noTasksFound => 'Առաջադրանքներ չեն գտնվել:';

  @override
  String get searchTasks => 'Որոնել առաջադրանքներ...';

  @override
  String get taskReminder => 'Հիշեցում առաջադրանքի մասին';

  @override
  String get untitledNote => 'Անվերնագիր նշում';

  @override
  String get dailyEntry => 'Ամենօրյա գրառում';

  @override
  String get clipboardHistory => 'Բուֆերի պատմություն';

  @override
  String get deletePermanentlyContent =>
      'Այս գործողությունը հնարավոր չէ չեղարկել:';

  @override
  String get emptyRecycleBinTitle => 'Դատարկե՞լ աղբամանը';

  @override
  String emptyRecycleBinContent(Object count) {
    return 'Բոլոր $count տարրերը վերջնականապես կջնջվեն:';
  }

  @override
  String get emptyBin => 'Դատարկել աղբամանը';

  @override
  String get recycleBinEmpty => 'Աղբամանը դատարկ է';

  @override
  String get deletedItemsAppearHere => 'Ջնջված տարրերը կհայտնվեն այստեղ:';

  @override
  String get empty => 'Դատարկ';

  @override
  String get recent => 'Վերջին';

  @override
  String categoryLabel(Object category) {
    return 'Կատեգորիա՝ $category';
  }

  @override
  String get general => 'Ընդհուր';

  @override
  String get saveTransactionQuestion => 'Ցանկանու՞մ եք պահպանել այս գործարքը:';

  @override
  String get fillTitleAmount => 'Խնդրում ենք լրացնել վերնագիրը և գումարը';

  @override
  String get invalidAmount => 'Գումարի անվավեր ձևաչափ';

  @override
  String get moveTransactionToBinTitle => 'Տեղափոխե՞լ գործարքը աղբաման:';

  @override
  String get restoreTransactionLater =>
      'Դուք կարող եք վերականգնել այս գործարքը ավելի ուշ կարգավորումներից:';

  @override
  String get newTransaction => 'Նոր գործարք';

  @override
  String get whatIsThisFor => 'Ինչի՞ համար է սա:';

  @override
  String get description => 'Նկարագրություն';

  @override
  String get daily => 'Օրական';

  @override
  String get weekly => 'Շաբաթական';

  @override
  String get monthly => 'Ամսական';

  @override
  String get yearly => 'Տարեկան';

  @override
  String get totalIncome => 'Ընդհանուր եկամուտ';

  @override
  String get totalExpense => 'Ընդհանուր ծախս';

  @override
  String get analysis => 'Վերլուծություն';

  @override
  String get transactions => 'Գործարքներ';

  @override
  String get noExpensesFound => 'Այս ժամանակահատվածի համար ծախսեր չեն գտնվել:';

  @override
  String get netBalance => 'Զուտ հաշվեկշիռ';

  @override
  String get topCategories => 'Հիմնական կատեգորիաներ';

  @override
  String get spendingTrend => 'Ծախսերի միտումը';

  @override
  String get insights => 'Խորհուրդներ';

  @override
  String get noExpensesRecorded => 'Ծախսեր չեն գրանցվել';

  @override
  String get trackSpendingHabits =>
      'Հեշտությամբ հետևեք ձեր ծախսային սովորություններին:';

  @override
  String get addExpense => 'Ավելացնել ծախս';

  @override
  String get noDataForPeriod => 'Այս ժամանակահատվածի համար տվյալներ չկան';

  @override
  String get budget => 'Բյուջե';

  @override
  String get spent => 'Ծախսված է';

  @override
  String get limit => 'Սահմանաչափ';

  @override
  String get overBudget => 'Բյուջեն գերազանցված է:';

  @override
  String remainingBudget(Object percent) {
    return 'մնացել է $percent%';
  }

  @override
  String get savingsRate => 'Խնայողության չափը';

  @override
  String get healthScore => 'Առողջության միավոր';

  @override
  String get healthScoreExplanation =>
      'Այս միավորը հիմնված է ձեր խնայողության չափի վրա:\n\n• > 50% խնայված = Գերազանց (100)\n• 0% խնայված = Միջին (50)\n• Ծախսերը > Եկամուտները = Վատ (<50)';

  @override
  String get ok => 'Լավ';

  @override
  String get bulkImport => 'Bulk Import';
}
