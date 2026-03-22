// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Gujarati (`gu`).
class AppLocalizationsGu extends AppLocalizations {
  AppLocalizationsGu([String locale = 'gu']) : super(locale);

  @override
  String get settings => 'સેટિંગ્સ';

  @override
  String get language => 'ભાષા';

  @override
  String get systemDefault => 'સિસ્ટમ ડિફોલ્ટ';

  @override
  String get notes => 'નોંધો';

  @override
  String get todos => 'કાર્યો';

  @override
  String get expenses => 'ખર્ચ';

  @override
  String get journal => 'જર્નલ';

  @override
  String get calendar => 'કેલેન્ડર';

  @override
  String get clipboard => 'ક્લિપબોર્ડ';

  @override
  String get canvas => 'કેનવાસ';

  @override
  String get save => 'સાચવો';

  @override
  String get create => 'બનાવો';

  @override
  String get cancel => 'રદ કરો';

  @override
  String get delete => 'કાઢી નાખો';

  @override
  String get edit => 'સંપાદિત કરો';

  @override
  String get share => 'શેર કરો';

  @override
  String get copy => 'કોપી કરો';

  @override
  String get unsavedChanges => 'વણસાચવેલા ફેરફારો';

  @override
  String get confirmDelete => 'કાઢી નાખવાની પુષ્ટિ કરો';

  @override
  String get discard => 'રદ કરો';

  @override
  String get createPost => 'પોસ્ટ બનાવો';

  @override
  String get post => 'પોસ્ટ';

  @override
  String get postingTo => 'પોસ્ટ થઈ રહ્યું છે';

  @override
  String get whatsOnYourMind => 'તમારા મનમાં શું છે?';

  @override
  String get pickImages => 'છબીઓ પસંદ કરો';

  @override
  String get pickVideo => 'વિડિયો પસંદ કરો';

  @override
  String get camera => 'કેમેરા';

  @override
  String get gallery => 'ગેલેરી';

  @override
  String get search => 'શોધો';

  @override
  String get pleaseEnterTask => 'કૃપા કરીને કાર્ય દાખલ કરો';

  @override
  String get deleteTask => 'કાર્ય કાઢી નાખો';

  @override
  String get selectItems => 'વસ્તુઓ પસંદ કરો';

  @override
  String get deleteAll => 'બધું કાઢી નાખો';

  @override
  String error(Object error) {
    return 'ભૂલ: $error';
  }

  @override
  String get orderingOnlyAvailableInAllPosts =>
      'ક્રમ માત્ર \'બધી પોસ્ટ\' માં ઉપલબ્ધ છે';

  @override
  String get deletePost => 'પોસ્ટ કાઢી નાખો';

  @override
  String get postDeleted => 'પોસ્ટ કાઢી નાખવામાં આવી';

  @override
  String get premiumFeatures => 'પ્રીમિયમ સુવિધાઓ';

  @override
  String get manageCoinsAdsPremium =>
      'સિક્કા, જાહેરાતો અને પ્રીમિયમ સ્ટેટસ મેનેજ કરો';

  @override
  String get themeMode => 'થીમ મોડ';

  @override
  String get accentColor => 'રંગ';

  @override
  String get backgroundDesign => 'બેકગ્રાઉન્ડ ડિઝાઇન';

  @override
  String get pushNotifications => 'પુશ નોટિફિકેશન';

  @override
  String get recycleBin => 'રિસાયકલ બિન';

  @override
  String get exportData => 'ડેટા નિકાસ કરો';

  @override
  String get importData => 'ડેટા આયાત કરો';

  @override
  String get rateApp => 'એપ્લિકેશન રેટ કરો';

  @override
  String get sendFeedback => 'ફીડબેક મોકલો';

  @override
  String get privacyPolicy => 'ગોપનીયતા નીતિ';

  @override
  String get version => 'વર્ઝન';

  @override
  String get buildNumber => 'બિલ્ડ નંબર';

  @override
  String get system => 'સિસ્ટમ';

  @override
  String get light => 'લાઇટ';

  @override
  String get dark => 'ડાર્ક';

  @override
  String get itemRestored => 'વસ્તુ પુનઃસ્થાપિત કરવામાં આવી';

  @override
  String get recycleBinCleared => 'રિસાયકલ બિન સફળતાપૂર્વક ખાલી કરવામાં આવ્યું';

  @override
  String get allPostsDeleted => 'બધી પોસ્ટ કાઢી નાખવામાં આવી';

  @override
  String get newPost => 'નવી પોસ્ટ';

  @override
  String get textCopiedToClipboardFacebook =>
      'ટેક્સ્ટ ક્લિપબોર્ડ પર કોપી કરવામાં આવ્યો (Facebook નીતિ)';

  @override
  String get tiktokSharingRequiresVideoImage =>
      'TikTok શેરિંગ માટે વિડિયો/છબીની જરૂર છે';

  @override
  String errorSharing(Object error) {
    return 'શેર કરવામાં ભૂલ: $error';
  }

  @override
  String shareToStory(Object platform) {
    return '$platform સ્ટોરી પર શેર કરો';
  }

  @override
  String shareToFeed(Object platform) {
    return '$platform ફીડ પર શેર કરો';
  }

  @override
  String get unlockPermanently => 'કાયમી માટે અનલોક કરો';

  @override
  String get notEnoughCoins => 'પૂરતા સિક્કા નથી!';

  @override
  String youEarnedCoins(Object amount) {
    return 'તમે $amount સિક્કા કમાયા!';
  }

  @override
  String get contentCopied => 'સામગ્રી કોપી કરવામાં આવી';

  @override
  String get selectDateTime => 'તારીખ અને સમય પસંદ કરો';

  @override
  String get areYouSureYouWantToDeleteThisPost =>
      'શું તમે ખરેખર આ પોસ્ટ કાઢી નાખવા માંગો છો?';

  @override
  String get socialPosts => 'સોશિયલ પોસ્ટ';

  @override
  String get watchAdToEarnCoins => 'સિક્કા કમાવવા માટે જાહેરાત જુઓ';

  @override
  String get premiumUnlocked => 'પ્રીમિયમ અનલોક થયું';

  @override
  String get removeAds => 'જાહેરાતો દૂર કરો';

  @override
  String get unlimitedCloudStorage => 'અમર્યાદિત ક્લાઉડ સ્ટોરેજ';

  @override
  String get deleteNote => 'નોંધ કાઢી નાખો';

  @override
  String get shareNote => 'નોંધ શેર કરો';

  @override
  String get editNote => 'નોંધ સંપાદિત કરો';

  @override
  String get searchNotes => 'નોંધો શોધો...';

  @override
  String get noNotesFound => 'કોઈ નોંધ મળી નથી';

  @override
  String get captureThoughts => 'તમારા વિચારો તરત જ રેકોર્ડ કરો.';

  @override
  String get createNote => 'નોંધ બનાવો';

  @override
  String get customOrder => 'કસ્ટમ ઓર્ડર';

  @override
  String get newestFirst => 'નવું સૌથી પહેલા';

  @override
  String get oldestFirst => 'જૂનું સૌથી પહેલા';

  @override
  String get titleAZ => 'શીર્ષક: A-Z';

  @override
  String get titleZA => 'શીર્ષક: Z-A';

  @override
  String get deleteAllQuestion => 'બધું કાઢી નાખવું?';

  @override
  String get moveToRecycleBin => 'બધી નોંધો રિસાયકલ બિનમાં ખસેડવી?';

  @override
  String get moveToBinQuestion => 'બિનમાં ખસેડવું?';

  @override
  String get restoreNoteLater => 'તમે આ નોંધને પછીથી પુનઃસ્થાપિત કરી શકો છો.';

  @override
  String get move => 'ખસેડો';

  @override
  String get myThoughts => 'મારા વિચારો';

  @override
  String get selected => 'પસંદ કરેલ';

  @override
  String get noContent => 'કોઈ સામગ્રી નથી';

  @override
  String get untitled => 'શીર્ષક વગરનું';

  @override
  String get chooseWallpapers => '10+ ડાયનેમિક વોલપેપર્સમાંથી પસંદ કરો';

  @override
  String get backupData => 'ડેટા બેકઅપ';

  @override
  String get saveJsonFile => 'તમારા તમામ ડેટાવાળી JSON ફાઇલ સાચવવી?';

  @override
  String get exportNow => 'અત્યારે નિકાસ કરો';

  @override
  String get importDataTitle => 'ડેટા આયાત કરો';

  @override
  String get mergeBackupFile =>
      'બેકઅપ ફાઇલને તમારી વર્તમાન વસ્તુઓ સાથે મર્જ કરવી?';

  @override
  String get selectFile => 'ફાઇલ પસંદ કરો';

  @override
  String get backupSaved => 'બેકઅપ સફળતાપૂર્વક સાચવવામાં આવ્યો!';

  @override
  String get exportFailed => 'નિકાસ નિષ્ફળ ગઈ.';

  @override
  String importSuccess(Object count) {
    return '$count વસ્તુઓ સફળતાપૂર્વક પુનઃસ્થાપિત થઈ!';
  }

  @override
  String get importFailed => 'આયાત નિષ્ફળ ગઈ.';

  @override
  String widgetAdded(String widget) {
    return 'વિજેટ $widget હોમ સ્ક્રીન પર ઉમેરવામાં આવ્યું!';
  }

  @override
  String get widgetRequestSent =>
      'વિજેટ વિનંતી મોકલવામાં આવી. કૃપા કરીને તમારી હોમ સ્ક્રીન તપાસો.';

  @override
  String get widgetAddFailed => 'વિજેટ ઉમેરવામાં નિષ્ફળતા';

  @override
  String get autoSaveEnabled => 'ઓટો-સેવ સક્ષમ.';

  @override
  String get autoSaveDisabled => 'ઓટો-સેવ અક્ષમ.';

  @override
  String get homeScreenWidgets => 'હોમ સ્ક્રીન વિજેટ્સ';

  @override
  String get notificationsTitle => 'નોટિફિકેશન';

  @override
  String get dataBackup => 'ડેટા અને બેકઅપ';

  @override
  String get feedbackSupport => 'ફીડબેક અને સપોર્ટ';

  @override
  String get creditsTitle => 'ક્રેડિટ્સ';

  @override
  String get privacyMaintenance => 'ગોપનીયતા અને જાળવણી';

  @override
  String get aboutTitle => 'વિશે';

  @override
  String get premium => 'પ્રીમિયમ';

  @override
  String get appearanceTitle => 'દેખાવ';

  @override
  String get clipboardTitle => 'ક્લિપબોર્ડ';

  @override
  String get settingsSubtitle => 'તમારા અનુભવને કસ્ટમાઇઝ કરો';

  @override
  String get welcomeTitle => 'CopyClip માં આપનું સ્વાગત છે';

  @override
  String get welcomeDescription =>
      'તમારો પરમ ઉત્પાદકતા સાથી. ચાલો તમારા દિવસને મેનેજ કરવા માટે શક્તિશાળી સાધનો સાથે તમને સેટ કરીએ.';

  @override
  String get onboardingNotesTitle => 'સ્માર્ટ નોંધો';

  @override
  String get onboardingNotesDesc =>
      'રિચ ટેક્સ્ટ ફોર્મેટિંગ સાથે વિચારો તરત જ રેકોર્ડ કરો. તમારા વિચારો વ્યવસ્થિત કરો અને ક્યારેય પણ એક મહાન વિચાર ગુમાવશો નહીં.';

  @override
  String get onboardingTodosTitle => 'કાર્ય વ્યવસ્થાપન';

  @override
  String get onboardingTodosDesc =>
      'તમારા કામમાં આગળ રહો. ટુ-ડુ લિસ્ટ બનાવો, પ્રાથમિકતાઓ સેટ કરો અને તમારા લક્ષ્યો પૂરા કરો.';

  @override
  String get onboardingExpensesTitle => 'ખર્ચ ટ્રેકિંગ';

  @override
  String get onboardingExpensesDesc =>
      'તમારા નાણાં પર નિયંત્રણ મેળવો. તમારી ખર્ચ કરવાની આદતોને સમજવા માટે આવક અને ખર્ચને સરળતાથી ટ્રેક કરો.';

  @override
  String get onboardingJournalTitle => 'વ્યક્તિગત જર્નલ';

  @override
  String get onboardingJournalDesc =>
      'તમારા દિવસ પર વિચાર કરો. તમારી યાદો, લાગણીઓ અને દૈનિક અનુભવો લખવા માટે એક ખાનગી જગ્યા.';

  @override
  String get onboardingCalendarTitle => 'કેલેન્ડર અને ઇવેન્ટ્સ';

  @override
  String get onboardingCalendarDesc =>
      'ક્યારેય પણ એક પળ ચૂકશો નહીં. તમારા શેડ્યૂલને વ્યવસ્થિત કરો અને મહત્વપૂર્ણ આગામી ઇવેન્ટ્સ પર નજર રાખો.';

  @override
  String get onboardingClipboardTitle => 'ક્લિપબોર્ડ મેનેજર';

  @override
  String get onboardingClipboardDesc =>
      'એકવાર કોપી કરો, ગમે ત્યાં પેસ્ટ કરો. અગાઉ કોપી કરેલા સ્નિપેટ્સ પરત મેળવવા માટે તમારા ક્લિપબોર્ડ ઇતિહાસને એક્સેસ કરો.';

  @override
  String get onboardingCanvasTitle => 'ક્રિએટિવ કેનવાસ';

  @override
  String get onboardingCanvasDesc =>
      'તમારી સર્જનાત્મકતાને મુક્ત કરો. ડિજિટલ કેનવાસ પર તમારા વિચારોને ચિત્રિત અને સ્કેચ કરો.';

  @override
  String get featuresNotesDesc => 'તમારી નોંધો બનાવો અને મેનેજ કરો';

  @override
  String get featuresTodosDesc => 'તમારા કાર્યો પર નજર રાખો';

  @override
  String get featuresExpensesDesc => 'તમારા ખર્ચનું નિરીક્ષણ કરો';

  @override
  String get featuresJournalDesc => 'તમારા વિચારો લખો';

  @override
  String get featuresCalendarDesc => 'તમારા શેડ્યૂલને વ્યવસ્થિત કરો';

  @override
  String get featuresClipboardDesc => 'તમારા ક્લિપબોર્ડ ઇતિહાસને એક્સેસ કરો';

  @override
  String get featuresCanvasDesc => 'મુક્તપણે ચિત્ર દોરો અને સ્કેચ કરો';

  @override
  String get featuresSocialPost => 'સોશિયલ પોસ્ટ';

  @override
  String get featuresSocialPostDesc => 'આકર્ષક સોશિયલ મીડિયા સામગ્રી બનાવો';

  @override
  String get chooseYourAura => 'તમારી આભા પસંદ કરો';

  @override
  String get expressYourselfTheme => 'નવા થીમ કલર સાથે તમારી જાતને વ્યક્ત કરો!';

  @override
  String get level => 'લેવલ';

  @override
  String get xpToNextLevel => 'આગલા લેવલ માટે XP';

  @override
  String get checkUpcomingEvents => 'આગામી ઇવેન્ટ્સ તપાસો';

  @override
  String get startNewSketch => 'નવો સ્કેચ શરૂ કરો';

  @override
  String get noTransactionsMonth => 'આ મહિને કોઈ વ્યવહાર નથી';

  @override
  String transactionsThisMonth(num count) {
    return 'આ મહિને $count વ્યવહાર';
  }

  @override
  String get autoSaveClipboard => 'ક્લિપબોર્ડ ઓટો-સેવ';

  @override
  String get autoSaveClipboardDesc => 'કોપી કરેલી વસ્તુઓ આપમેળે સાચવો';

  @override
  String get permissionDeniedSettings =>
      'પરવાનગી કાયમી માટે નકારવામાં આવી. કૃપા કરીને સેટિંગ્સમાં સક્ષમ કરો.';

  @override
  String get notificationsEnabled => 'નોટિફિકેશન સક્ષમ!';

  @override
  String get redirectingToSettings =>
      'નોટિફિકેશન અક્ષમ કરવા માટે સેટિંગ્સ પર મોકલી રહ્યા છીએ...';

  @override
  String get premiumAccess => 'પ્રીમિયમ એક્સેસ';

  @override
  String get premiumActiveUntil => 'પ્રીમિયમ સક્રિય છે ત્યાં સુધી';

  @override
  String get unlockAllFeatures => 'તમામ સુવિધાઓ અનલોક કરો';

  @override
  String get buyPremium => 'પ્રીમિયમ ખરીદો (7 દિવસ)';

  @override
  String costCoins(Object cost) {
    return 'કિંમત: $cost સિક્કા';
  }

  @override
  String get premiumActivated => '7 દિવસ માટે પ્રીમિયમ સક્રિય થયું!';

  @override
  String get premiumActive => 'પ્રીમિયમ સક્રિય';

  @override
  String get expires => 'સમાપ્તિ તારીખ:';

  @override
  String get temporaryAccess => 'કામચલાઉ એક્સેસ';

  @override
  String get journalExpression => 'જર્નલ અને અભિવ્યક્તિ';

  @override
  String get artisticDesigns => 'કલાત્મક ડિઝાઇન';

  @override
  String get artisticDesignsDesc => '10+ અનન્ય જર્નલ કાર્ડ થીમ્સ અનલોક કરો';

  @override
  String get premiumLayouts => 'પ્રીમિયમ લેઆઉટ';

  @override
  String get premiumLayoutsDesc => 'તમારી યાદો જોવાની વિશિષ્ટ રીતો';

  @override
  String get calendarTools => 'કેલેન્ડર અને ટૂલ્સ';

  @override
  String get fullCalendar => 'પૂર્ણ કેલેન્ડર';

  @override
  String get fullCalendarDesc => 'સંપૂર્ણ ઇવેન્ટ મેનેજમેન્ટ સિસ્ટમ';

  @override
  String get clipboardAutoSaveDesc => 'બેકગ્રાઉન્ડ ક્લિપબોર્ડ ઇતિહાસ કેપ્ચર';

  @override
  String get proWidgets => 'પ્રો વિજેટ્સ';

  @override
  String get proWidgetsDesc => 'તમારી હોમ સ્ક્રીન પર તમામ સુવિધાઓ ઉપલબ્ધ';

  @override
  String get dataExport => 'ડેટા અને નિકાસ';

  @override
  String get advancedBackup => 'અદ્યતન બેકઅપ';

  @override
  String get advancedBackupDesc => 'તમામ ડેટાની સુરક્ષિત આયાત/નિકાસ';

  @override
  String get pdfExport => 'PDF નિકાસ';

  @override
  String get pdfExportDesc => 'નોંધો અને જર્નલને PDF માં નિકાસ કરો';

  @override
  String get printReady => 'પ્રિન્ટ માટે તૈયાર';

  @override
  String get printReadyDesc => 'ડાયરેક્ટ પ્રિન્ટિંગ સપોર્ટ';

  @override
  String get richTextEditor => 'રિચ ટેક્સ્ટ એડિટર';

  @override
  String get advancedSearch => 'અદ્યતન શોધ';

  @override
  String get advancedSearchDesc => 'તમારા ટેક્સ્ટમાં શોધો અને બદલો';

  @override
  String get richMedia => 'રિચ મીડિયા';

  @override
  String get richMediaDesc => 'છબીઓ, વિડિયો અને લિંક્સ દાખલ કરો';

  @override
  String get editorStyling => 'એડિટર સ્ટાઇલિંગ';

  @override
  String get editorStylingDesc => 'કસ્ટમ ટેક્સ્ટ અને એડિટર બેકગ્રાઉન્ડ';

  @override
  String get balance => 'બેલેન્સ';

  @override
  String get loadingAd => 'જાહેરાત લોડ થઈ રહી છે...';

  @override
  String watchAd(Object amount) {
    return 'જાહેરાત જુઓ (+$amount)';
  }

  @override
  String get loadAd => 'જાહેરાત લોડ કરો';

  @override
  String get backupDataDesc => 'તમારા ડેટાની JSON ફાઇલ સાચવો';

  @override
  String get importDataDesc => 'બેકઅપ ફાઇલને CopyClip માં મર્જ કરો';

  @override
  String get notificationPermissionDenied =>
      'નોટિફિકેશન પરવાનગી નકારવામાં આવી.';

  @override
  String get typeNewTask => 'નવું કાર્ય ટાઇપ કરો...';

  @override
  String get addTask => 'કાર્ય ઉમેરો';

  @override
  String get completed => 'પૂર્ણ થયું';

  @override
  String get greatJob => 'ખૂબ સરસ!';

  @override
  String youEarnedXPNextTask(Object amount, Object date) {
    return 'તમે $amount XP કમાયા! આગલું કાર્ય: $date';
  }

  @override
  String taskCompletedXP(Object amount) {
    return 'કાર્ય પૂર્ણ થયું! +$amount XP';
  }

  @override
  String get moveTasksToRecycleBin =>
      'તમામ સક્રિય કાર્યોને રિસાયકલ બિનમાં ખસેડવા?';

  @override
  String get deleteAllPosts => 'બધી પોસ્ટ કાઢી નાખો';

  @override
  String get deleteAllPostsConfirmation =>
      'શું તમે ખરેખર બધી સોશિયલ પોસ્ટ કાઢી નાખવા માંગો છો? આ પાછું કરી શકાશે નહીં.';

  @override
  String get allPosts => 'બધી પોસ્ટ';

  @override
  String get favorites => 'મનપસંદ';

  @override
  String get drafts => 'ડ્રાફ્ટ્સ';

  @override
  String get noFavoritesYet => 'હજી સુધી કોઈ મનપસંદ નથી';

  @override
  String get noDraftsYet => 'હજી સુધી કોઈ ડ્રાફ્ટ્સ નથી';

  @override
  String get startSocialJourney => 'તમારી સોશિયલ મુસાફરી શરૂ કરો!';

  @override
  String get draft => 'ડ્રાફ્ટ';

  @override
  String attachmentCount(num count) {
    return '$count જોડાણ';
  }

  @override
  String get pleaseAddContent =>
      'શેર કરવા માટે કૃપા કરીને સામગ્રી અથવા મીડિયા ઉમેરો';

  @override
  String fileNotFoundError(Object path) {
    return 'ભૂલ: $path પર ફાઇલ મળી નથી';
  }

  @override
  String get checkFacebookApp => 'Facebook એપ્લિકેશન તપાસો';

  @override
  String get systemShare => 'સિસ્ટમ શેર';

  @override
  String get socialPost => 'સોશિયલ પોસ્ટ';

  @override
  String get favorite => 'મનપસંદ';

  @override
  String get saveDraft => 'ડ્રાફ્ટ સાચવો';

  @override
  String get entryCopied => 'નોંધ નકલ કરવામાં આવી';

  @override
  String get moveEntriesToRecycleBin =>
      'તમામ સક્રિય પ્રવેશોને રિસાયકલ બિનમાં ખસેડવા?';

  @override
  String get startWritingStory => 'તમારી વાર્તા લખવાનું શરૂ કરો';

  @override
  String get recordMemories => 'તમારી દૈનિક યાદો અને લાગણીઓ રેકોર્ડ કરો.';

  @override
  String get writeJournal => 'જર્નલ લખો';

  @override
  String get myMemories => 'મારી યાદો';

  @override
  String get sortJournal => 'જર્નલ સાર્ટ કરો';

  @override
  String get byMood => 'મૂડ દ્વારા';

  @override
  String get searchMemories => 'યાદો શોધો...';

  @override
  String get selectAll => 'બધું પસંદ કરો';

  @override
  String get deleteSelected => 'પસંદ કરેલ કાઢી નાખો';

  @override
  String get taskCompletedExclamation => 'કાર્ય પૂર્ણ થયું!';

  @override
  String get taskUncompletedExclamation => 'કાર્ય અધૂરું';

  @override
  String get clipboardUpdatedExclamation => 'ક્લિપબોર્ડ અપડેટ થયું!';

  @override
  String clipboardSavedContent(Object content) {
    return 'ક્લિપબોર્ડ સાચવવામાં આવ્યું: $content';
  }

  @override
  String get overview => 'ઝાંખી';

  @override
  String get colorAurora => 'અરોરા';

  @override
  String get colorCosmic => 'કોસ્મિક';

  @override
  String get colorNebula => 'નેબ્યુલા';

  @override
  String get colorStarlight => 'સ્ટારલાઇટ';

  @override
  String get colorSolar => 'સોલર';

  @override
  String get colorNova => 'નોવા';

  @override
  String get loadingStepLoading => 'લોડ થઈ રહ્યું છે...';

  @override
  String get loadingStepDatabase => 'ડેટાબેઝ સેટ કરી રહ્યાં છીએ...';

  @override
  String get loadingStepSystem => 'સિસ્ટમ કન્ફિગર કરી રહ્યાં છીએ...';

  @override
  String get loadingStepReady => 'તૈયાર';

  @override
  String get productivityCompanion => 'તમારો ઉત્પાદકતા સાથી';

  @override
  String get done => 'થઈ ગયું';

  @override
  String get newNote => 'નવી નોંધ';

  @override
  String get changeColor => 'રંગ બદલો';

  @override
  String get copyContent => 'સામગ્રી કોપી કરો';

  @override
  String get titleOptional => 'શીર્ષક (વૈકલ્પિક)';

  @override
  String get exportAsPdf => 'PDF તરીકે નિકાસ કરો';

  @override
  String get taskDueNow => 'કાર્ય પૂર્ણ કરવાનો સમય થયો છે';

  @override
  String get moveTaskToBinTitle => 'કાર્યને રિસાયકલ બિનમાં ખસેડવું?';

  @override
  String get restoreTaskLater =>
      'તમે તેને પછીથી સેટિંગ્સમાંથી પુનઃસ્થાપિત કરી શકો છો.';

  @override
  String get newTask => 'નવું કાર્ય';

  @override
  String get editTask => 'કાર્ય સંપાદિત કરો';

  @override
  String get undo => 'પહેલા જેવું કરો';

  @override
  String get redo => 'ફરીથી કરો';

  @override
  String get category => 'શ્રેણી';

  @override
  String get categoryHint => 'દા.ત. ઓફિસ, જીમ';

  @override
  String get whatNeedsToBeDone => 'શું કરવાની જરૂર છે?';

  @override
  String get enterTaskDetails => 'કાર્યની વિગતો દાખલ કરો...';

  @override
  String get setDueDate => 'નિયત તારીખ સેટ કરો';

  @override
  String get dueDate => 'નિયત તારીખ';

  @override
  String get expenseTitle => 'ખર્ચ';

  @override
  String searchInCurrency(String currency) {
    return '$currency માં શોધો...';
  }

  @override
  String get sortAndFilter => 'સાર્ટ અને ફિલ્ટર';

  @override
  String get sortBy => 'આના દ્વારા સાર્ટ કરો';

  @override
  String get highestAmount => 'સૌથી વધુ રકમ';

  @override
  String get lowestAmount => 'સૌથી ઓછી રકમ';

  @override
  String get moreFilters => 'વધુ ફિલ્ટર્સ...';

  @override
  String get filterExpenses => 'ખર્ચ ફિલ્ટર કરો';

  @override
  String get transactionType => 'વ્યવહાર પ્રકાર';

  @override
  String get categories => 'શ્રેણીઓ';

  @override
  String get all => 'બધા';

  @override
  String get income => 'આવક';

  @override
  String get expense => 'ખર્ચ';

  @override
  String get reset => 'રીસેટ';

  @override
  String get apply => 'લાગુ કરો';

  @override
  String newExpense(String currency) {
    return 'નવું $currency';
  }

  @override
  String errorLoadingData(String error) {
    return 'ડેટા લોડ કરવામાં ભૂલ.\n\n$error';
  }

  @override
  String get dailyQuote1 => 'ભવિષ્યની આગાહી કરવાની શ્રેષ્ઠ રીત તેને બનાવવી છે.';

  @override
  String get dailyQuote2 =>
      'સંપત્તિ મોટી મિલકતો હોવામાં નથી, પરંતુ ઓછી ઈચ્છાઓ હોવામાં છે.';

  @override
  String get dailyQuote3 => 'સમય એ પરમ ચલણ છે.';

  @override
  String get dailyQuote4 => 'સફળતા અંતિમ નથી, નિષ્ફળતા જીવલેણ નથી.';

  @override
  String get dailyQuote5 => 'ઉકેલ પર ધ્યાન આપો, સમસ્યા પર નહીં.';

  @override
  String get dailyQuote6 => 'તમારું નેટવર્ક એ તમારી નેટવર્થ છે.';

  @override
  String get moodHappy => 'ખુશ';

  @override
  String get moodExcited => 'ઉત્સાહિત';

  @override
  String get moodNeutral => 'તટસ્થ';

  @override
  String get moodSad => 'ઉદાસ';

  @override
  String get moodStressed => 'તણાવમાં';

  @override
  String exportDate(String date) {
    return '📅 $date';
  }

  @override
  String exportMood(String emoji, String mood) {
    return 'મૂડ: $emoji $mood';
  }

  @override
  String exportTitle(String title) {
    return 'શીર્ષક: $title';
  }

  @override
  String exportTags(String tags) {
    return '\nટૅગ્સ: $tags';
  }

  @override
  String get instagram => 'ઈન્સ્ટાગ્રામ';

  @override
  String get facebook => 'ફેસબુક';

  @override
  String get tiktok => 'TikTok';

  @override
  String get newSketch => 'નવો સ્કેચ';

  @override
  String get searchSketches => 'સ્કેચ અને ફોલ્ડર્સ શોધો...';

  @override
  String get noResultsFound => 'કોઈ પરિણામ મળ્યા નથી';

  @override
  String get noItems => 'કોઈ વસ્તુ નથી';

  @override
  String get noDrawingsYet => 'હજી સુધી કોઈ ચિત્ર નથી';

  @override
  String get canvasIntro => 'કેનવાસ પર તમારી સર્જનાત્મકતા મુક્ત કરો!';

  @override
  String get newCanvas => 'નવો કેનવાસ';

  @override
  String get rename => 'ફરીથી નામ આપો';

  @override
  String get deleteFolder => 'ફોલ્ડર કાઢી નાખો';

  @override
  String get deleteSketchesQuestion => 'સ્કેચ કાઢી નાખવા?';

  @override
  String get deleteFolderConfirmation =>
      'આ ફોલ્ડરના તમામ સ્કેચ કાયમી માટે કાઢી નાખવામાં આવશે.';

  @override
  String get renameFolder => 'ફોલ્ડરનું નામ બદલો';

  @override
  String get chooseColor => 'રંગ પસંદ કરો';

  @override
  String get deleteFolderQuestion => 'ફોલ્ડર કાઢી નાખવું?';

  @override
  String get searchClips => 'ક્લિપ્સ શોધો...';

  @override
  String get clipboardEmpty => 'ક્લિપબોર્ડ ખાલી છે';

  @override
  String get addItem => 'વસ્તુ ઉમેરો';

  @override
  String get clipColor => 'ક્લિપ રંગ';

  @override
  String get newClip => 'નવી ક્લિપ';

  @override
  String get editClip => 'ક્લિપ સંપાદિત કરો';

  @override
  String get restoreClipLater => 'તમે આ ક્લિપને પછીથી પુનઃસ્થાપિત કરી શકો છો.';

  @override
  String get upcomingEvents => 'આગામી ઇવેન્ટ્સ';

  @override
  String get dataDistribution => 'ડેટા વિતરણ';

  @override
  String get taskProgress => 'કાર્ય પ્રગતિ';

  @override
  String get quickStats => 'ઝડપી આંકડા';

  @override
  String get taskCompletion => 'કાર્ય પૂર્ણતા';

  @override
  String get noItemsForDate => 'આ તારીખ માટે કોઈ વસ્તુ નથી';

  @override
  String get enjoyFreeTime => 'તમારા ખાલી સમયનો આનંદ માણો!';

  @override
  String get searchThisDay => 'આ દિવસમાં શોધો...';

  @override
  String get finance => 'ફાઇનાન્સ';

  @override
  String get permanentlyDelete => 'કાયમી માટે કાઢી નાખવું?';

  @override
  String deleteSelectionConfirmation(int foldersCount, int sketchesCount) {
    return 'આનાથી $foldersCount ફોલ્ડર્સ અને $sketchesCount સ્કેચ કાયમી માટે કાઢી નાખવામાં આવશે. આ પાછું કરી શકાશે નહીં.';
  }

  @override
  String get deleteForever => 'કાયમી માટે કાઢી નાખો';

  @override
  String selectedCount(int count) {
    return '$count પસંદ કરેલ';
  }

  @override
  String canvasStats(int notes, int folders) {
    return '$notes સ્કેચ • $folders ફોલ્ડર્સ';
  }

  @override
  String get sortItems => 'વસ્તુઓ સાર્ટ કરો';

  @override
  String get sortNameAZ => 'નામ (A-Z)';

  @override
  String get sortNameZA => 'નામ (Z-A)';

  @override
  String get createFolder => 'ફોલ્ડર બનાવો';

  @override
  String get folderNameHint => 'ફોલ્ડરનું નામ...';

  @override
  String deleteSketchesConfirmation(int count) {
    return '$count સ્કેચ કાઢી નાખવા? આ પાછું કરી શકાશે નહીં.';
  }

  @override
  String get noSketchesFound => 'કોઈ સ્કેચ મળ્યા નથી';

  @override
  String get noSketchesFoundSub =>
      'તમારી શોધને સમાયોજિત કરવાનો અથવા નવો સ્કેચ બનાવવાનો પ્રયાસ કરો.';

  @override
  String searchInFolder(String folder) {
    return '$folder માં શોધો...';
  }

  @override
  String sketchesCount(int count) {
    return '$count સ્કેચ';
  }

  @override
  String get sortSketches => 'સ્કેચ સાર્ટ કરો';

  @override
  String get calendarScreenTitle => 'કેલેન્ડર';

  @override
  String get dailyActivity => 'દૈનિક પ્રવૃત્તિ';

  @override
  String get deleteItemQuestion => 'વસ્તુ કાઢી નાખવી?';

  @override
  String get deleteItemConfirmation => 'આનાથી વસ્તુ રિસાયકલ બિનમાં જશે.';

  @override
  String get moveToBinItem => 'બિનમાં ખસેડવું?';

  @override
  String get moveToBinConfirmation => 'તમે તેને પછીથી પુનઃસ્થાપિત કરી શકો છો.';

  @override
  String selectedItems(int count) {
    return '$count પસંદ કરેલ';
  }

  @override
  String get recentClips => 'તાજેતરની ક્લિપ્સ';

  @override
  String get copied => 'કોપી કર્યું!';

  @override
  String get copiedPlainText => 'પ્લેન ટેક્સ્ટ કોપી કર્યો';

  @override
  String get clipTheme => 'ક્લિપ થીમ';

  @override
  String get justNow => 'હમણાં જ';

  @override
  String minutesAgo(Object count) {
    return '$count મિનિટ પહેલા';
  }

  @override
  String hoursAgo(Object count) {
    return '$count કલાક પહેલા';
  }

  @override
  String daysAgo(Object count) {
    return '$count દિવસ પહેલા';
  }

  @override
  String get noTasksFound => 'કોઈ કાર્ય મળ્યા નથી.';

  @override
  String get searchTasks => 'કાર્યો શોધો...';

  @override
  String get taskReminder => 'કાર્ય રીમાઇન્ડર';

  @override
  String get untitledNote => 'શીર્ષક વગરની નોંધ';

  @override
  String get dailyEntry => 'દૈનિક એન્ટ્રી';

  @override
  String get clipboardHistory => 'ક્લિપબોર્ડ ઇતિહાસ';

  @override
  String get deletePermanentlyContent => 'આ ક્રિયા પાછી કરી શકાશે નહીં.';

  @override
  String get emptyRecycleBinTitle => 'રિસાયકલ બિન ખાલી કરવું?';

  @override
  String emptyRecycleBinContent(Object count) {
    return 'તમામ $count વસ્તુઓ કાયમી માટે કાઢી નાખવામાં આવશે.';
  }

  @override
  String get emptyBin => 'બિન ખાલી કરો';

  @override
  String get recycleBinEmpty => 'રિસાયકલ બિન ખાલી છે';

  @override
  String get deletedItemsAppearHere => 'કાઢી નાખેલી વસ્તુઓ અહીં દેખાશે.';

  @override
  String get empty => 'ખાલી';

  @override
  String get recent => 'તાજેતરની';

  @override
  String categoryLabel(Object category) {
    return 'શ્રેણી: $category';
  }

  @override
  String get general => 'સામાન્ય';

  @override
  String get saveTransactionQuestion => 'શું તમે આ વ્યવહાર સાચવવા માંગો છો?';

  @override
  String get fillTitleAmount => 'કૃપા કરીને શીર્ષક અને રકમ ભરો';

  @override
  String get invalidAmount => 'અમાન્ય રકમ ફોર્મેટ';

  @override
  String get moveTransactionToBinTitle => 'વ્યવહારને રિસાયકલ બિનમાં ખસેડવો?';

  @override
  String get restoreTransactionLater =>
      'તમે આ વ્યવહારને પછીથી સેટિંગ્સમાંથી પુનઃસ્થાપિત કરી શકો છો.';

  @override
  String get newTransaction => 'નવો વ્યવહાર';

  @override
  String get whatIsThisFor => 'આ શાના માટે છે?';

  @override
  String get description => 'વર્ણન';

  @override
  String get daily => 'દૈનિક';

  @override
  String get weekly => 'સાપ્તાહિક';

  @override
  String get monthly => 'માસિક';

  @override
  String get yearly => 'વાર્ષિક';

  @override
  String get totalIncome => 'કુલ આવક';

  @override
  String get totalExpense => 'કુલ ખર્ચ';

  @override
  String get analysis => 'વિશ્લેષણ';

  @override
  String get transactions => 'વ્યવહાર';

  @override
  String get noExpensesFound => 'આ સમયગાળા માટે કોઈ ખર્ચ મળ્યો નથી.';

  @override
  String get netBalance => 'ચોખ્ખું બેલેન્સ';

  @override
  String get topCategories => 'ટોચની શ્રેણીઓ';

  @override
  String get spendingTrend => 'ખર્ચનું વલણ';

  @override
  String get insights => 'ઇનસાઇટ્સ';

  @override
  String get noExpensesRecorded => 'કોઈ ખર્ચ રેકોર્ડ થયો નથી';

  @override
  String get trackSpendingHabits =>
      'તમારી ખર્ચ કરવાની આદતોને સરળતાથી ટ્રેક કરો.';

  @override
  String get addExpense => 'ખર્ચ ઉમેરો';

  @override
  String get noDataForPeriod => 'આ સમયગાળા માટે કોઈ ડેટા નથી';

  @override
  String get budget => 'બજેટ';

  @override
  String get spent => 'ખર્ચાયેલ';

  @override
  String get limit => 'મર્યાદા';

  @override
  String get overBudget => 'બજેટથી વધારે!';

  @override
  String remainingBudget(Object percent) {
    return '$percent% બાકી';
  }

  @override
  String get savingsRate => 'બચત દર';

  @override
  String get healthScore => 'હેલ્થ સ્કોર';

  @override
  String get healthScoreExplanation =>
      'આ સ્કોર તમારા બચત દર પર આધારિત છે.\n\n• > 50% બચત = ઉત્તમ (100)\n• 0% બચત = સરેરાસ (50)\n• ખર્ચ > આવક = નબળો (<50)';

  @override
  String get ok => 'બરાબર';

  @override
  String get bulkImport => 'બલ્ક ઇમ્પોર્ટ';
}

/// The translations for Gujarati, as used in India (`gu_IN`).
class AppLocalizationsGuIn extends AppLocalizationsGu {
  AppLocalizationsGuIn() : super('gu_IN');

  @override
  String get settings => 'સેટિંગ્સ';

  @override
  String get language => 'ભાષા';

  @override
  String get systemDefault => 'સિસ્ટમ ડિફોલ્ટ';

  @override
  String get notes => 'નોંધો';

  @override
  String get todos => 'કાર્યો';

  @override
  String get expenses => 'ખર્ચ';

  @override
  String get journal => 'જર્નલ';

  @override
  String get calendar => 'કેલેન્ડર';

  @override
  String get clipboard => 'ક્લિપબોર્ડ';

  @override
  String get canvas => 'કેનવાસ';

  @override
  String get save => 'સાચવો';

  @override
  String get create => 'બનાવો';

  @override
  String get cancel => 'રદ કરો';

  @override
  String get delete => 'કાઢી નાખો';

  @override
  String get edit => 'સંપાદિત કરો';

  @override
  String get share => 'શેર કરો';

  @override
  String get copy => 'કોપી કરો';

  @override
  String get unsavedChanges => 'વણસાચવેલા ફેરફારો';

  @override
  String get confirmDelete => 'કાઢી નાખવાની પુષ્ટિ કરો';

  @override
  String get discard => 'રદ કરો';

  @override
  String get createPost => 'પોસ્ટ બનાવો';

  @override
  String get post => 'પોસ્ટ';

  @override
  String get postingTo => 'પોસ્ટ થઈ રહ્યું છે';

  @override
  String get whatsOnYourMind => 'તમારા મનમાં શું છે?';

  @override
  String get pickImages => 'છબીઓ પસંદ કરો';

  @override
  String get pickVideo => 'વિડિયો પસંદ કરો';

  @override
  String get camera => 'કેમેરા';

  @override
  String get gallery => 'ગેલેરી';

  @override
  String get search => 'શોધો';

  @override
  String get pleaseEnterTask => 'કૃપા કરીને કાર્ય દાખલ કરો';

  @override
  String get deleteTask => 'કાર્ય કાઢી નાખો';

  @override
  String get selectItems => 'વસ્તુઓ પસંદ કરો';

  @override
  String get deleteAll => 'બધું કાઢી નાખો';

  @override
  String error(Object error) {
    return 'ભૂલ: $error';
  }

  @override
  String get orderingOnlyAvailableInAllPosts =>
      'ક્રમ માત્ર \'બધી પોસ્ટ\' માં ઉપલબ્ધ છે';

  @override
  String get deletePost => 'પોસ્ટ કાઢી નાખો';

  @override
  String get postDeleted => 'પોસ્ટ કાઢી નાખવામાં આવી';

  @override
  String get premiumFeatures => 'પ્રીમિયમ સુવિધાઓ';

  @override
  String get manageCoinsAdsPremium =>
      'સિક્કા, જાહેરાતો અને પ્રીમિયમ સ્ટેટસ મેનેજ કરો';

  @override
  String get themeMode => 'થીમ મોડ';

  @override
  String get accentColor => 'રંગ';

  @override
  String get backgroundDesign => 'બેકગ્રાઉન્ડ ડિઝાઇન';

  @override
  String get pushNotifications => 'પુશ નોટિફિકેશન';

  @override
  String get recycleBin => 'રિસાયકલ બિન';

  @override
  String get exportData => 'ડેટા નિકાસ કરો';

  @override
  String get importData => 'ડેટા આયાત કરો';

  @override
  String get rateApp => 'એપ્લિકેશન રેટ કરો';

  @override
  String get sendFeedback => 'ફીડબેક મોકલો';

  @override
  String get privacyPolicy => 'ગોપનીયતા નીતિ';

  @override
  String get version => 'વર્ઝન';

  @override
  String get buildNumber => 'બિલ્ડ નંબર';

  @override
  String get system => 'સિસ્ટમ';

  @override
  String get light => 'લાઇટ';

  @override
  String get dark => 'ડાર્ક';

  @override
  String get itemRestored => 'વસ્તુ પુનઃસ્થાપિત કરવામાં આવી';

  @override
  String get recycleBinCleared => 'રિસાયકલ બિન સફળતાપૂર્વક ખાલી કરવામાં આવ્યું';

  @override
  String get allPostsDeleted => 'બધી પોસ્ટ કાઢી નાખવામાં આવી';

  @override
  String get newPost => 'નવી પોસ્ટ';

  @override
  String get textCopiedToClipboardFacebook =>
      'ટેક્સ્ટ ક્લિપબોર્ડ પર કોપી કરવામાં આવ્યો (Facebook નીતિ)';

  @override
  String get tiktokSharingRequiresVideoImage =>
      'TikTok શેરિંગ માટે વિડિયો/છબીની જરૂર છે';

  @override
  String errorSharing(Object error) {
    return 'શેર કરવામાં ભૂલ: $error';
  }

  @override
  String shareToStory(Object platform) {
    return '$platform સ્ટોરી પર શેર કરો';
  }

  @override
  String shareToFeed(Object platform) {
    return '$platform ફીડ પર શેર કરો';
  }

  @override
  String get unlockPermanently => 'કાયમી માટે અનલોક કરો';

  @override
  String get notEnoughCoins => 'પૂરતા સિક્કા નથી!';

  @override
  String youEarnedCoins(Object amount) {
    return 'તમે $amount સિક્કા કમાયા!';
  }

  @override
  String get contentCopied => 'સામગ્રી કોપી કરવામાં આવી';

  @override
  String get selectDateTime => 'તારીખ અને સમય પસંદ કરો';

  @override
  String get areYouSureYouWantToDeleteThisPost =>
      'શું તમે ખરેખર આ પોસ્ટ કાઢી નાખવા માંગો છો?';

  @override
  String get socialPosts => 'સોશિયલ પોસ્ટ';

  @override
  String get watchAdToEarnCoins => 'સિક્કા કમાવવા માટે જાહેરાત જુઓ';

  @override
  String get premiumUnlocked => 'પ્રીમિયમ અનલોક થયું';

  @override
  String get removeAds => 'જાહેરાતો દૂર કરો';

  @override
  String get unlimitedCloudStorage => 'અમર્યાદિત ક્લાઉડ સ્ટોરેજ';

  @override
  String get deleteNote => 'નોંધ કાઢી નાખો';

  @override
  String get shareNote => 'નોંધ શેર કરો';

  @override
  String get editNote => 'નોંધ સંપાદિત કરો';

  @override
  String get searchNotes => 'નોંધો શોધો...';

  @override
  String get noNotesFound => 'કોઈ નોંધ મળી નથી';

  @override
  String get captureThoughts => 'તમારા વિચારો તરત જ રેકોર્ડ કરો.';

  @override
  String get createNote => 'નોંધ બનાવો';

  @override
  String get customOrder => 'કસ્ટમ ઓર્ડર';

  @override
  String get newestFirst => 'નવું સૌથી પહેલા';

  @override
  String get oldestFirst => 'જૂનું સૌથી પહેલા';

  @override
  String get titleAZ => 'શીર્ષક: A-Z';

  @override
  String get titleZA => 'શીર્ષક: Z-A';

  @override
  String get deleteAllQuestion => 'બધું કાઢી નાખવું?';

  @override
  String get moveToRecycleBin => 'બધી નોંધો રિસાયકલ બિનમાં ખસેડવી?';

  @override
  String get moveToBinQuestion => 'બિનમાં ખસેડવું?';

  @override
  String get restoreNoteLater => 'તમે આ નોંધને પછીથી પુનઃસ્થાપિત કરી શકો છો.';

  @override
  String get move => 'ખસેડો';

  @override
  String get myThoughts => 'મારા વિચારો';

  @override
  String get selected => 'પસંદ કરેલ';

  @override
  String get noContent => 'કોઈ સામગ્રી નથી';

  @override
  String get untitled => 'શીર્ષક વગરનું';

  @override
  String get chooseWallpapers => '10+ ડાયનેમિક વોલપેપર્સમાંથી પસંદ કરો';

  @override
  String get backupData => 'ડેટા બેકઅપ';

  @override
  String get saveJsonFile => 'તમારા તમામ ડેટાવાળી JSON ફાઇલ સાચવવી?';

  @override
  String get exportNow => 'અત્યારે નિકાસ કરો';

  @override
  String get importDataTitle => 'ડેટા આયાત કરો';

  @override
  String get mergeBackupFile =>
      'બેકઅપ ફાઇલને તમારી વર્તમાન વસ્તુઓ સાથે મર્જ કરવી?';

  @override
  String get selectFile => 'ફાઇલ પસંદ કરો';

  @override
  String get backupSaved => 'બેકઅપ સફળતાપૂર્વક સાચવવામાં આવ્યો!';

  @override
  String get exportFailed => 'નિકાસ નિષ્ફળ ગઈ.';

  @override
  String importSuccess(Object count) {
    return '$count વસ્તુઓ સફળતાપૂર્વક પુનઃસ્થાપિત થઈ!';
  }

  @override
  String get importFailed => 'આયાત નિષ્ફળ ગઈ.';

  @override
  String widgetAdded(String widget) {
    return 'વિજેટ $widget હોમ સ્ક્રીન પર ઉમેરવામાં આવ્યું!';
  }

  @override
  String get widgetRequestSent =>
      'વિજેટ વિનંતી મોકલવામાં આવી. કૃપા કરીને તમારી હોમ સ્ક્રીન તપાસો.';

  @override
  String get widgetAddFailed => 'વિજેટ ઉમેરવામાં નિષ્ફળતા';

  @override
  String get autoSaveEnabled => 'ઓટો-સેવ સક્ષમ.';

  @override
  String get autoSaveDisabled => 'ઓટો-સેવ અક્ષમ.';

  @override
  String get homeScreenWidgets => 'હોમ સ્ક્રીન વિજેટ્સ';

  @override
  String get notificationsTitle => 'નોટિફિકેશન';

  @override
  String get dataBackup => 'ડેટા અને બેકઅપ';

  @override
  String get feedbackSupport => 'ફીડબેક અને સપોર્ટ';

  @override
  String get creditsTitle => 'ક્રેડિટ્સ';

  @override
  String get privacyMaintenance => 'ગોપનીયતા અને જાળવણી';

  @override
  String get aboutTitle => 'વિશે';

  @override
  String get premium => 'પ્રીમિયમ';

  @override
  String get appearanceTitle => 'દેખાવ';

  @override
  String get clipboardTitle => 'ક્લિપબોર્ડ';

  @override
  String get settingsSubtitle => 'તમારા અનુભવને કસ્ટમાઇઝ કરો';

  @override
  String get welcomeTitle => 'CopyClip માં આપનું સ્વાગત છે';

  @override
  String get welcomeDescription =>
      'તમારો પરમ ઉત્પાદકતા સાથી. ચાલો તમારા દિવસને મેનેજ કરવા માટે શક્તિશાળી સાધનો સાથે તમને સેટ કરીએ.';

  @override
  String get onboardingNotesTitle => 'સ્માર્ટ નોંધો';

  @override
  String get onboardingNotesDesc =>
      'રિચ ટેક્સ્ટ ફોર્મેટિંગ સાથે વિચારો તરત જ રેકોર્ડ કરો. તમારા વિચારો વ્યવસ્થિત કરો અને ક્યારેય પણ એક મહાન વિચાર ગુમાવશો નહીં.';

  @override
  String get onboardingTodosTitle => 'કાર્ય વ્યવસ્થાપન';

  @override
  String get onboardingTodosDesc =>
      'તમારા કામમાં આગળ રહો. ટુ-ડુ લિસ્ટ બનાવો, પ્રાથમિકતાઓ સેટ કરો અને તમારા લક્ષ્યો પૂરા કરો.';

  @override
  String get onboardingExpensesTitle => 'ખર્ચ ટ્રેકિંગ';

  @override
  String get onboardingExpensesDesc =>
      'તમારા નાણાં પર નિયંત્રણ મેળવો. તમારી ખર્ચ કરવાની આદતોને સમજવા માટે આવક અને ખર્ચને સરળતાથી ટ્રેક કરો.';

  @override
  String get onboardingJournalTitle => 'વ્યક્તિગત જર્નલ';

  @override
  String get onboardingJournalDesc =>
      'તમારા દિવસ પર વિચાર કરો. તમારી યાદો, લાગણીઓ અને દૈનિક અનુભવો લખવા માટે એક ખાનગી જગ્યા.';

  @override
  String get onboardingCalendarTitle => 'કેલેન્ડર અને ઇવેન્ટ્સ';

  @override
  String get onboardingCalendarDesc =>
      'ક્યારેય પણ એક પળ ચૂકશો નહીં. તમારા શેડ્યૂલને વ્યવસ્થિત કરો અને મહત્વપૂર્ણ આગામી ઇવેન્ટ્સ પર નજર રાખો.';

  @override
  String get onboardingClipboardTitle => 'ક્લિપબોર્ડ મેનેજર';

  @override
  String get onboardingClipboardDesc =>
      'એકવાર કોપી કરો, ગમે ત્યાં પેસ્ટ કરો. અગાઉ કોપી કરેલા સ્નિપેટ્સ પરત મેળવવા માટે તમારા ક્લિપબોર્ડ ઇતિહાસને એક્સેસ કરો.';

  @override
  String get onboardingCanvasTitle => 'ક્રિએટિવ કેનવાસ';

  @override
  String get onboardingCanvasDesc =>
      'તમારી સર્જનાત્મકતાને મુક્ત કરો. ડિજિટલ કેનવાસ પર તમારા વિચારોને ચિત્રિત અને સ્કેચ કરો.';

  @override
  String get featuresNotesDesc => 'તમારી નોંધો બનાવો અને મેનેજ કરો';

  @override
  String get featuresTodosDesc => 'તમારા કાર્યો પર નજર રાખો';

  @override
  String get featuresExpensesDesc => 'તમારા ખર્ચનું નિરીક્ષણ કરો';

  @override
  String get featuresJournalDesc => 'તમારા વિચારો લખો';

  @override
  String get featuresCalendarDesc => 'તમારા શેડ્યૂલને વ્યવસ્થિત કરો';

  @override
  String get featuresClipboardDesc => 'તમારા ક્લિપબોર્ડ ઇતિહાસને એક્સેસ કરો';

  @override
  String get featuresCanvasDesc => 'મુક્તપણે ચિત્ર દોરો અને સ્કેચ કરો';

  @override
  String get featuresSocialPost => 'સોશિયલ પોસ્ટ';

  @override
  String get featuresSocialPostDesc => 'આકર્ષક સોશિયલ મીડિયા સામગ્રી બનાવો';

  @override
  String get chooseYourAura => 'તમારી આભા પસંદ કરો';

  @override
  String get expressYourselfTheme => 'નવા થીમ કલર સાથે તમારી જાતને વ્યક્ત કરો!';

  @override
  String get level => 'લેવલ';

  @override
  String get xpToNextLevel => 'આગલા લેવલ માટે XP';

  @override
  String get checkUpcomingEvents => 'આગામી ઇવેન્ટ્સ તપાસો';

  @override
  String get startNewSketch => 'નવો સ્કેચ શરૂ કરો';

  @override
  String get noTransactionsMonth => 'આ મહિને કોઈ વ્યવહાર નથી';

  @override
  String transactionsThisMonth(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 's',
      one: '',
    );
    return '$count transaction$_temp0 આ મહિને';
  }

  @override
  String get autoSaveClipboard => 'ક્લિપબોર્ડ ઓટો-સેવ';

  @override
  String get autoSaveClipboardDesc => 'કોપી કરેલી વસ્તુઓ આપમેળે સાચવો';

  @override
  String get permissionDeniedSettings =>
      'પરવાનગી કાયમી માટે નકારવામાં આવી. કૃપા કરીને સેટિંગ્સમાં સક્ષમ કરો.';

  @override
  String get notificationsEnabled => 'નોટિફિકેશન સક્ષમ!';

  @override
  String get redirectingToSettings =>
      'નોટિફિકેશન અક્ષમ કરવા માટે સેટિંગ્સ પર મોકલી રહ્યા છીએ...';

  @override
  String get premiumAccess => 'પ્રીમિયમ એક્સેસ';

  @override
  String get premiumActiveUntil => 'પ્રીમિયમ સક્રિય છે ત્યાં સુધી';

  @override
  String get unlockAllFeatures => 'તમામ સુવિધાઓ અનલોક કરો';

  @override
  String get buyPremium => 'પ્રીમિયમ ખરીદો (7 દિવસ)';

  @override
  String costCoins(Object cost) {
    return 'કિંમત: $cost સિક્કા';
  }

  @override
  String get premiumActivated => '7 દિવસ માટે પ્રીમિયમ સક્રિય થયું!';

  @override
  String get premiumActive => 'પ્રીમિયમ સક્રિય';

  @override
  String get expires => 'સમાપ્તિ તારીખ:';

  @override
  String get temporaryAccess => 'કામચલાઉ એક્સેસ';

  @override
  String get journalExpression => 'જર્નલ અને અભિવ્યક્તિ';

  @override
  String get artisticDesigns => 'કલાત્મક ડિઝાઇન';

  @override
  String get artisticDesignsDesc => '10+ અનન્ય જર્નલ કાર્ડ થીમ્સ અનલોક કરો';

  @override
  String get premiumLayouts => 'પ્રીમિયમ લેઆઉટ';

  @override
  String get premiumLayoutsDesc => 'તમારી યાદો જોવાની વિશિષ્ટ રીતો';

  @override
  String get calendarTools => 'કેલેન્ડર અને ટૂલ્સ';

  @override
  String get fullCalendar => 'પૂર્ણ કેલેન્ડર';

  @override
  String get fullCalendarDesc => 'સંપૂર્ણ ઇવેન્ટ મેનેજમેન્ટ સિસ્ટમ';

  @override
  String get clipboardAutoSaveDesc => 'બેકગ્રાઉન્ડ ક્લિપબોર્ડ ઇતિહાસ કેપ્ચર';

  @override
  String get proWidgets => 'પ્રો વિજેટ્સ';

  @override
  String get proWidgetsDesc => 'તમારી હોમ સ્ક્રીન પર તમામ સુવિધાઓ ઉપલબ્ધ';

  @override
  String get dataExport => 'ડેટા અને નિકાસ';

  @override
  String get advancedBackup => 'અદ્યતન બેકઅપ';

  @override
  String get advancedBackupDesc => 'તમામ ડેટાની સુરક્ષિત આયાત/નિકાસ';

  @override
  String get pdfExport => 'PDF નિકાસ';

  @override
  String get pdfExportDesc => 'નોંધો અને જર્નલને PDF માં નિકાસ કરો';

  @override
  String get printReady => 'પ્રિન્ટ માટે તૈયાર';

  @override
  String get printReadyDesc => 'ડાયરેક્ટ પ્રિન્ટિંગ સપોર્ટ';

  @override
  String get richTextEditor => 'રિચ ટેક્સ્ટ એડિટર';

  @override
  String get advancedSearch => 'અદ્યતન શોધ';

  @override
  String get advancedSearchDesc => 'તમારા ટેક્સ્ટમાં શોધો અને બદલો';

  @override
  String get richMedia => 'રિચ મીડિયા';

  @override
  String get richMediaDesc => 'છબીઓ, વિડિયો અને લિંક્સ દાખલ કરો';

  @override
  String get editorStyling => 'એડિટર સ્ટાઇલિંગ';

  @override
  String get editorStylingDesc => 'કસ્ટમ ટેક્સ્ટ અને એડિટર બેકગ્રાઉન્ડ';

  @override
  String get balance => 'બેલેન્સ';

  @override
  String get loadingAd => 'જાહેરાત લોડ થઈ રહી છે...';

  @override
  String watchAd(Object amount) {
    return 'જાહેરાત જુઓ (+$amount)';
  }

  @override
  String get loadAd => 'જાહેરાત લોડ કરો';

  @override
  String get backupDataDesc => 'તમારા ડેટાની JSON ફાઇલ સાચવો';

  @override
  String get importDataDesc => 'બેકઅપ ફાઇલને CopyClip માં મર્જ કરો';

  @override
  String get notificationPermissionDenied =>
      'નોટિફિકેશન પરવાનગી નકારવામાં આવી.';

  @override
  String get typeNewTask => 'નવું કાર્ય ટાઇપ કરો...';

  @override
  String get addTask => 'કાર્ય ઉમેરો';

  @override
  String get completed => 'પૂર્ણ થયું';

  @override
  String get greatJob => 'ખૂબ સરસ!';

  @override
  String youEarnedXPNextTask(Object amount, Object date) {
    return 'તમે $amount XP કમાયા! આગલું કાર્ય: $date';
  }

  @override
  String taskCompletedXP(Object amount) {
    return 'કાર્ય પૂર્ણ થયું! +$amount XP';
  }

  @override
  String get moveTasksToRecycleBin =>
      'તમામ સક્રિય કાર્યોને રિસાયકલ બિનમાં ખસેડવા?';

  @override
  String get deleteAllPosts => 'બધી પોસ્ટ કાઢી નાખો';

  @override
  String get deleteAllPostsConfirmation =>
      'શું તમે ખરેખર બધી સોશિયલ પોસ્ટ કાઢી નાખવા માંગો છો? આ પાછું કરી શકાશે નહીં.';

  @override
  String get allPosts => 'બધી પોસ્ટ';

  @override
  String get favorites => 'મનપસંદ';

  @override
  String get drafts => 'ડ્રાફ્ટ્સ';

  @override
  String get noFavoritesYet => 'હજી સુધી કોઈ મનપસંદ નથી';

  @override
  String get noDraftsYet => 'હજી સુધી કોઈ ડ્રાફ્ટ્સ નથી';

  @override
  String get startSocialJourney => 'તમારી સોશિયલ મુસાફરી શરૂ કરો!';

  @override
  String get draft => 'ડ્રાફ્ટ';

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
      'શેર કરવા માટે કૃપા કરીને સામગ્રી અથવા મીડિયા ઉમેરો';

  @override
  String fileNotFoundError(Object path) {
    return 'ભૂલ: $path પર ફાઇલ મળી નથી';
  }

  @override
  String get checkFacebookApp => 'Facebook એપ્લિકેશન તપાસો';

  @override
  String get systemShare => 'સિસ્ટમ શેર';

  @override
  String get socialPost => 'સોશિયલ પોસ્ટ';

  @override
  String get favorite => 'મનપસંદ';

  @override
  String get saveDraft => 'ડ્રાફ્ટ સાચવો';

  @override
  String get entryCopied => 'નોંધ નકલ કરવામાં આવી';

  @override
  String get moveEntriesToRecycleBin =>
      'તમામ સક્રિય પ્રવેશોને રિસાયકલ બિનમાં ખસેડવા?';

  @override
  String get startWritingStory => 'તમારી વાર્તા લખવાનું શરૂ કરો';

  @override
  String get recordMemories => 'તમારી દૈનિક યાદો અને લાગણીઓ રેકોર્ડ કરો.';

  @override
  String get writeJournal => 'જર્નલ લખો';

  @override
  String get myMemories => 'મારી યાદો';

  @override
  String get sortJournal => 'જર્નલ સાર્ટ કરો';

  @override
  String get byMood => 'મૂડ દ્વારા';

  @override
  String get searchMemories => 'યાદો શોધો...';

  @override
  String get selectAll => 'બધું પસંદ કરો';

  @override
  String get deleteSelected => 'પસંદ કરેલ કાઢી નાખો';

  @override
  String get taskCompletedExclamation => 'કાર્ય પૂર્ણ થયું!';

  @override
  String get taskUncompletedExclamation => 'કાર્ય અધૂરું';

  @override
  String get clipboardUpdatedExclamation => 'ક્લિપબોર્ડ અપડેટ થયું!';

  @override
  String clipboardSavedContent(Object content) {
    return 'ક્લિપબોર્ડ સાચવવામાં આવ્યું: $content';
  }

  @override
  String get overview => 'ઝાંખી';

  @override
  String get colorAurora => 'અરોરા';

  @override
  String get colorCosmic => 'કોસ્મિક';

  @override
  String get colorNebula => 'નેબ્યુલા';

  @override
  String get colorStarlight => 'સ્ટારલાઇટ';

  @override
  String get colorSolar => 'સોલર';

  @override
  String get colorNova => 'નોવા';

  @override
  String get loadingStepLoading => 'લોડ થઈ રહ્યું છે...';

  @override
  String get loadingStepDatabase => 'ડેટાબેઝ સેટ કરી રહ્યાં છીએ...';

  @override
  String get loadingStepSystem => 'સિસ્ટમ કન્ફિગર કરી રહ્યાં છીએ...';

  @override
  String get loadingStepReady => 'તૈયાર';

  @override
  String get productivityCompanion => 'તમારો ઉત્પાદકતા સાથી';

  @override
  String get done => 'થઈ ગયું';

  @override
  String get newNote => 'નવી નોંધ';

  @override
  String get changeColor => 'રંગ બદલો';

  @override
  String get copyContent => 'સામગ્રી કોપી કરો';

  @override
  String get titleOptional => 'શીર્ષક (વૈકલ્પિક)';

  @override
  String get exportAsPdf => 'PDF તરીકે નિકાસ કરો';

  @override
  String get taskDueNow => 'કાર્ય પૂર્ણ કરવાનો સમય થયો છે';

  @override
  String get moveTaskToBinTitle => 'કાર્યને રિસાયકલ બિનમાં ખસેડવું?';

  @override
  String get restoreTaskLater =>
      'તમે તેને પછીથી સેટિંગ્સમાંથી પુનઃસ્થાપિત કરી શકો છો.';

  @override
  String get newTask => 'નવું કાર્ય';

  @override
  String get editTask => 'કાર્ય સંપાદિત કરો';

  @override
  String get undo => 'પહેલા જેવું કરો';

  @override
  String get redo => 'ફરીથી કરો';

  @override
  String get category => 'શ્રેણી';

  @override
  String get categoryHint => 'દા.ત. ઓફિસ, જીમ';

  @override
  String get whatNeedsToBeDone => 'શું કરવાની જરૂર છે?';

  @override
  String get enterTaskDetails => 'કાર્યની વિગતો દાખલ કરો...';

  @override
  String get setDueDate => 'નિયત તારીખ સેટ કરો';

  @override
  String get dueDate => 'નિયત તારીખ';

  @override
  String get expenseTitle => 'ખર્ચ';

  @override
  String searchInCurrency(String currency) {
    return '$currency માં શોધો...';
  }

  @override
  String get sortAndFilter => 'સાર્ટ અને ફિલ્ટર';

  @override
  String get sortBy => 'TRIER PAR';

  @override
  String get highestAmount => 'સૌથી વધુ રકમ';

  @override
  String get lowestAmount => 'સૌથી ઓછી રકમ';

  @override
  String get moreFilters => 'વધુ ફિલ્ટર્સ...';

  @override
  String get filterExpenses => 'ખર્ચ ફિલ્ટર કરો';

  @override
  String get transactionType => 'વ્યવહાર પ્રકાર';

  @override
  String get categories => 'શ્રેણીઓ';

  @override
  String get all => 'બધા';

  @override
  String get income => 'આવક';

  @override
  String get expense => 'ખર્ચ';

  @override
  String get reset => 'રીસેટ';

  @override
  String get apply => 'લાગુ કરો';

  @override
  String newExpense(String currency) {
    return 'નવું $currency';
  }

  @override
  String errorLoadingData(String error) {
    return 'ડેટા લોડ કરવામાં ભૂલ.\n\n$error';
  }

  @override
  String get dailyQuote1 => 'ભવિષ્યની આગાહી કરવાની શ્રેષ્ઠ રીત તેને બનાવવી છે.';

  @override
  String get dailyQuote2 =>
      'સંપત્તિ મોટી મિલકતો હોવામાં નથી, પરંતુ ઓછી ઈચ્છાઓ હોવામાં છે.';

  @override
  String get dailyQuote3 => 'સમય એ પરમ ચલણ છે.';

  @override
  String get dailyQuote4 => 'સફળતા અંતિમ નથી, નિષ્ફળતા જીવલેણ નથી.';

  @override
  String get dailyQuote5 => 'ઉકેલ પર ધ્યાન આપો, સમસ્યા પર નહીં.';

  @override
  String get dailyQuote6 => 'તમારું નેટવર્ક એ તમારી નેટવર્થ છે.';

  @override
  String get moodHappy => 'ખુશ';

  @override
  String get moodExcited => 'ઉત્સાહિત';

  @override
  String get moodNeutral => 'તટસ્થ';

  @override
  String get moodSad => 'ઉદાસ';

  @override
  String get moodStressed => 'તણાવમાં';

  @override
  String exportDate(String date) {
    return '📅 $date';
  }

  @override
  String exportMood(String emoji, String mood) {
    return 'મૂડ: $emoji $mood';
  }

  @override
  String exportTitle(String title) {
    return 'TITRE : $title';
  }

  @override
  String exportTags(String tags) {
    return 'Tags : $tags';
  }

  @override
  String get instagram => 'ઈન્સ્ટાગ્રામ';

  @override
  String get facebook => 'ફેસબુક';

  @override
  String get tiktok => 'TikTok';

  @override
  String get newSketch => 'નવો સ્કેચ';

  @override
  String get searchSketches => 'સ્કેચ અને ફોલ્ડર્સ શોધો...';

  @override
  String get noResultsFound => 'કોઈ પરિણામ મળ્યા નથી';

  @override
  String get noItems => 'કોઈ વસ્તુ નથી';

  @override
  String get noDrawingsYet => 'હજી સુધી કોઈ ચિત્ર નથી';

  @override
  String get canvasIntro => 'કેનવાસ પર તમારી સર્જનાત્મકતા મુક્ત કરો!';

  @override
  String get newCanvas => 'નવો કેનવાસ';

  @override
  String get rename => 'ફરીથી નામ આપો';

  @override
  String get deleteFolder => 'ફોલ્ડર કાઢી નાખો';

  @override
  String get deleteSketchesQuestion => 'સ્કેચ કાઢી નાખવા?';

  @override
  String get deleteFolderConfirmation =>
      'આ ફોલ્ડરના તમામ સ્કેચ કાયમી માટે કાઢી નાખવામાં આવશે.';

  @override
  String get renameFolder => 'ફોલ્ડરનું નામ બદલો';

  @override
  String get chooseColor => 'રંગ પસંદ કરો';

  @override
  String get deleteFolderQuestion => 'ફોલ્ડર કાઢી નાખવું?';

  @override
  String get searchClips => 'ક્લિપ્સ શોધો...';

  @override
  String get clipboardEmpty => 'ક્લિપબોર્ડ ખાલી છે';

  @override
  String get addItem => 'વસ્તુ ઉમેરો';

  @override
  String get clipColor => 'ક્લિપ રંગ';

  @override
  String get newClip => 'નવી ક્લિપ';

  @override
  String get editClip => 'ક્લિપ સંપાદિત કરો';

  @override
  String get restoreClipLater => 'તમે આ ક્લિપને પછીથી પુનઃસ્થાપિત કરી શકો છો.';

  @override
  String get upcomingEvents => 'આગામી ઇવેન્ટ્સ';

  @override
  String get dataDistribution => 'ડેટા વિતરણ';

  @override
  String get taskProgress => 'કાર્ય પ્રગતિ';

  @override
  String get quickStats => 'ઝડપી આંકડા';

  @override
  String get taskCompletion => 'કાર્ય પૂર્ણતા';

  @override
  String get noItemsForDate => 'આ તારીખ માટે કોઈ વસ્તુ નથી';

  @override
  String get enjoyFreeTime => 'તમારા ખાલી સમયનો આનંદ માણો!';

  @override
  String get searchThisDay => 'આ દિવસમાં શોધો...';

  @override
  String get finance => 'ફાઇનાન્સ';

  @override
  String get permanentlyDelete => 'કાયમી માટે કાઢી નાખવું?';

  @override
  String deleteSelectionConfirmation(int foldersCount, int sketchesCount) {
    return 'Cela supprimera définitivement $foldersCount dossiers (et leurs croquis) et $sketchesCount autres croquis.\n\nCela ne peut pas être annulé.';
  }

  @override
  String get deleteForever => 'કાયમી માટે કાઢી નાખો';

  @override
  String selectedCount(int count) {
    return '$count પસંદ કરેલ';
  }

  @override
  String canvasStats(int notes, int folders) {
    return '$notes સ્કેચ • $folders ફોલ્ડર્સ';
  }

  @override
  String get sortItems => 'વસ્તુઓ સાર્ટ કરો';

  @override
  String get sortNameAZ => 'નામ (A-Z)';

  @override
  String get sortNameZA => 'નામ (Z-A)';

  @override
  String get createFolder => 'ફોલ્ડર બનાવો';

  @override
  String get folderNameHint => 'ફોલ્ડરનું નામ...';

  @override
  String deleteSketchesConfirmation(int count) {
    return 'Supprimer $count croquis ? Cela ne peut pas être annulé.';
  }

  @override
  String get noSketchesFound => 'કોઈ સ્કેચ મળ્યા નથી';

  @override
  String get noSketchesFoundSub =>
      'Essayez d\'\'ajuster votre recherche ou de créer un nouveau croquis.';

  @override
  String searchInFolder(String folder) {
    return '$folder માં શોધો...';
  }

  @override
  String sketchesCount(int count) {
    return '$count સ્કેચ';
  }

  @override
  String get sortSketches => 'સ્કેચ સાર્ટ કરો';

  @override
  String get calendarScreenTitle => 'કેલેન્ડર';

  @override
  String get dailyActivity => 'દૈનિક પ્રવૃત્તિ';

  @override
  String get deleteItemQuestion => 'વસ્તુ કાઢી નાખવી?';

  @override
  String get deleteItemConfirmation =>
      'Cela déplacera l\'\'élément vers la corbeille.';

  @override
  String get moveToBinItem => 'બિનમાં ખસેડવું?';

  @override
  String get moveToBinConfirmation => 'તમે તેને પછીથી પુનઃસ્થાપિત કરી શકો છો.';

  @override
  String selectedItems(int count) {
    return '$count પસંદ કરેલ';
  }

  @override
  String get recentClips => 'તાજેતરની ક્લિપ્સ';

  @override
  String get copied => 'કોપી કર્યું!';

  @override
  String get copiedPlainText => 'પ્લેન ટેક્સ્ટ કોપી કર્યો';

  @override
  String get clipTheme => 'ક્લિપ થીમ';

  @override
  String get justNow => 'હમણાં જ';

  @override
  String minutesAgo(Object count) {
    return '$count મિનિટ પહેલા';
  }

  @override
  String hoursAgo(Object count) {
    return '$count કલાક પહેલા';
  }

  @override
  String daysAgo(Object count) {
    return '$count દિવસ પહેલા';
  }

  @override
  String get noTasksFound => 'કોઈ કાર્ય મળ્યા નથી.';

  @override
  String get searchTasks => 'કાર્યો શોધો...';

  @override
  String get taskReminder => 'કાર્ય રીમાઇન્ડર';

  @override
  String get untitledNote => 'શીર્ષક વગરની નોંધ';

  @override
  String get dailyEntry => 'દૈનિક એન્ટ્રી';

  @override
  String get clipboardHistory => 'ક્લિપબોર્ડ ઇતિહાસ';

  @override
  String get deletePermanentlyContent =>
      'Cette action ne peut pas être annulée.';

  @override
  String get emptyRecycleBinTitle => 'Vider la corbeille ?';

  @override
  String emptyRecycleBinContent(Object count) {
    return 'Tous les $count éléments seront supprimés définitivement.';
  }

  @override
  String get emptyBin => 'બિન ખાલી કરો';

  @override
  String get recycleBinEmpty => 'રિસાયકલ બિન ખાલી છે';

  @override
  String get deletedItemsAppearHere => 'કાઢી નાખેલી વસ્તુઓ અહીં દેખાશે.';

  @override
  String get empty => 'ખાલી';

  @override
  String get recent => 'તાજેતરની';

  @override
  String categoryLabel(Object category) {
    return 'શ્રેણી: $category';
  }

  @override
  String get general => 'સામાન્ય';

  @override
  String get saveTransactionQuestion => 'શું તમે આ વ્યવહાર સાચવવા માંગો છો?';

  @override
  String get fillTitleAmount => 'કૃપા કરીને શીર્ષક અને રકમ ભરો';

  @override
  String get invalidAmount => 'અમાન્ય રકમ ફોર્મેટ';

  @override
  String get moveTransactionToBinTitle => 'વ્યવહારને રિસાયકલ બિનમાં ખસેડવો?';

  @override
  String get restoreTransactionLater =>
      'તમે આ વ્યવહારને પછીથી સેટિંગ્સમાંથી પુનઃસ્થાપિત કરી શકો છો.';

  @override
  String get newTransaction => 'નવો વ્યવહાર';

  @override
  String get whatIsThisFor => 'આ શાના માટે છે?';

  @override
  String get description => 'વર્ણન';

  @override
  String get daily => 'દૈનિક';

  @override
  String get weekly => 'સાપ્તાહિક';

  @override
  String get monthly => 'માસિક';

  @override
  String get yearly => 'વાર્ષિક';

  @override
  String get totalIncome => 'કુલ આવક';

  @override
  String get totalExpense => 'કુલ ખર્ચ';

  @override
  String get analysis => 'વિશ્લેષણ';

  @override
  String get transactions => 'વ્યવહાર';

  @override
  String get noExpensesFound => 'આ સમયગાળા માટે કોઈ ખર્ચ મળ્યો નથી.';

  @override
  String get netBalance => 'ચોખ્ખું બેલેન્સ';

  @override
  String get topCategories => 'ટોચની શ્રેણીઓ';

  @override
  String get spendingTrend => 'ખર્ચનું વલણ';

  @override
  String get insights => 'ઇનસાઇટ્સ';

  @override
  String get noExpensesRecorded => 'કોઈ ખર્ચ રેકોર્ડ થયો નથી';

  @override
  String get trackSpendingHabits =>
      'તમારી ખર્ચ કરવાની આદતોને સરળતાથી ટ્રેક કરો.';

  @override
  String get addExpense => 'ખર્ચ ઉમેરો';

  @override
  String get noDataForPeriod => 'આ સમયગાળા માટે કોઈ ડેટા નથી';

  @override
  String get budget => 'બજેટ';

  @override
  String get spent => 'ખર્ચાયેલ';

  @override
  String get limit => 'મર્યાદા';

  @override
  String get overBudget => 'બજેટથી વધારે!';

  @override
  String remainingBudget(Object percent) {
    return '$percent% બાકી';
  }

  @override
  String get savingsRate => 'બચત દર';

  @override
  String get healthScore => 'હેલ્થ સ્કોર';

  @override
  String get healthScoreExplanation =>
      'આ સ્કોર તમારા બચત દર પર આધારિત છે.\n\n• > 50% બચત = ઉત્તમ (100)\n• 0% બચત = સરેરાસ (50)\n• ખર્ચ > આવક = નબળો (<50)';

  @override
  String get ok => 'બરાબર';

  @override
  String get bulkImport => 'બલ્ક ઇમ્પોર્ટ';
}
