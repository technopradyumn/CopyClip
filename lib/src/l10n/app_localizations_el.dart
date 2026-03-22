// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Modern Greek (`el`).
class AppLocalizationsEl extends AppLocalizations {
  AppLocalizationsEl([String locale = 'el']) : super(locale);

  @override
  String get settings => 'Ρυθμίσεις';

  @override
  String get language => 'Γλώσσα';

  @override
  String get systemDefault => 'Προεπιλογή συστήματος';

  @override
  String get notes => 'Σημειώσεις';

  @override
  String get todos => 'To-Dos';

  @override
  String get expenses => 'Εξοδα';

  @override
  String get journal => 'Εφημερίδα';

  @override
  String get calendar => 'Ημερολόγιο';

  @override
  String get clipboard => 'Πρόχειρο';

  @override
  String get canvas => 'Καμβάς';

  @override
  String get save => 'Εκτός';

  @override
  String get create => 'Δημιουργώ';

  @override
  String get cancel => 'Ματαίωση';

  @override
  String get delete => 'Διαγράφω';

  @override
  String get edit => 'Εκδίδω';

  @override
  String get share => 'Μερίδιο';

  @override
  String get copy => 'Αντίγραφο';

  @override
  String get unsavedChanges => 'Μη αποθηκευμένες αλλαγές';

  @override
  String get confirmDelete => 'Επιβεβαίωση Διαγραφής';

  @override
  String get discard => 'Απορρίπτω';

  @override
  String get createPost => 'Δημιουργία ανάρτησης';

  @override
  String get post => 'Θέση';

  @override
  String get postingTo => 'Δημοσίευση σε';

  @override
  String get whatsOnYourMind => 'Τι έχεις στο μυαλό σου;';

  @override
  String get pickImages => 'Επιλέξτε Εικόνες';

  @override
  String get pickVideo => 'Επιλέξτε βίντεο';

  @override
  String get camera => 'Κάμερα';

  @override
  String get gallery => 'Στοά';

  @override
  String get search => 'Ερευνα';

  @override
  String get pleaseEnterTask => 'Εισαγάγετε μια εργασία';

  @override
  String get deleteTask => 'Διαγραφή Εργασίας';

  @override
  String get selectItems => 'Επιλέξτε Στοιχεία';

  @override
  String get deleteAll => 'Διαγραφή όλων';

  @override
  String error(Object error) {
    return 'Σφάλμα: $error';
  }

  @override
  String get orderingOnlyAvailableInAllPosts =>
      'Η παραγγελία είναι διαθέσιμη μόνο σε \"Όλες οι αναρτήσεις\"';

  @override
  String get deletePost => 'Διαγραφή ανάρτησης';

  @override
  String get postDeleted => 'Η ανάρτηση διαγράφηκε';

  @override
  String get premiumFeatures => 'Premium Χαρακτηριστικά';

  @override
  String get manageCoinsAdsPremium =>
      'Διαχειριστείτε νομίσματα, διαφημίσεις και κατάσταση premium';

  @override
  String get themeMode => 'Λειτουργία θέματος';

  @override
  String get accentColor => 'Χρώμα έμφασης';

  @override
  String get backgroundDesign => 'Σχεδιασμός φόντου';

  @override
  String get pushNotifications => 'Push Notifications';

  @override
  String get recycleBin => 'Κάδος Ανακύκλωσης';

  @override
  String get exportData => 'Εξαγωγή δεδομένων';

  @override
  String get importData => 'Εισαγωγή δεδομένων';

  @override
  String get rateApp => 'Βαθμολογήστε την εφαρμογή';

  @override
  String get sendFeedback => 'Αποστολή σχολίων';

  @override
  String get privacyPolicy => 'Πολιτική Απορρήτου';

  @override
  String get version => 'Εκδοχή';

  @override
  String get buildNumber => 'Αριθμός κατασκευής';

  @override
  String get system => 'Σύστημα';

  @override
  String get light => 'Φως';

  @override
  String get dark => 'Σκοτάδι';

  @override
  String get itemRestored => 'Το στοιχείο αποκαταστάθηκε';

  @override
  String get recycleBinCleared =>
      'Ο Κάδος Ανακύκλωσης εκκαθαρίστηκε με επιτυχία';

  @override
  String get allPostsDeleted => 'Όλες οι αναρτήσεις διαγράφηκαν';

  @override
  String get newPost => 'Νέα ανάρτηση';

  @override
  String get textCopiedToClipboardFacebook =>
      'Το κείμενο αντιγράφηκε στο πρόχειρο (πολιτική Facebook)';

  @override
  String get tiktokSharingRequiresVideoImage =>
      'Η κοινή χρήση TikTok απαιτεί βίντεο/εικόνα';

  @override
  String errorSharing(Object error) {
    return 'Κοινοποίηση σφάλματος: $error';
  }

  @override
  String shareToStory(Object platform) {
    return 'Κοινοποίηση στο $platform Story';
  }

  @override
  String shareToFeed(Object platform) {
    return 'Κοινή χρήση στη ροή $platform';
  }

  @override
  String get unlockPermanently => 'Ξεκλείδωμα μόνιμα';

  @override
  String get notEnoughCoins => 'Δεν υπάρχουν αρκετά νομίσματα!';

  @override
  String youEarnedCoins(Object amount) {
    return 'Κερδίσατε $amount νομίσματα!';
  }

  @override
  String get contentCopied => 'Το περιεχόμενο αντιγράφηκε';

  @override
  String get selectDateTime => 'Επιλέξτε Ημερομηνία & Ώρα';

  @override
  String get areYouSureYouWantToDeleteThisPost =>
      'Είστε βέβαιοι ότι θέλετε να διαγράψετε αυτήν την ανάρτηση;';

  @override
  String get socialPosts => 'Κοινωνικές αναρτήσεις';

  @override
  String get watchAdToEarnCoins =>
      'Παρακολουθήστε τη διαφήμιση για να κερδίσετε νομίσματα';

  @override
  String get premiumUnlocked => 'Premium Ξεκλείδωτο';

  @override
  String get removeAds => 'Κατάργηση διαφημίσεων';

  @override
  String get unlimitedCloudStorage => 'Απεριόριστος χώρος αποθήκευσης Cloud';

  @override
  String get deleteNote => 'Διαγραφή Σημείωσης';

  @override
  String get shareNote => 'Κοινή χρήση Σημείωση';

  @override
  String get editNote => 'Επεξεργασία Σημείωσης';

  @override
  String get searchNotes => 'Αναζήτηση σημειώσεων...';

  @override
  String get noNotesFound => 'Δεν βρέθηκαν σημειώσεις';

  @override
  String get captureThoughts => 'Καταγράψτε τις σκέψεις σας αμέσως.';

  @override
  String get createNote => 'Δημιουργία Σημείωσης';

  @override
  String get customOrder => 'Προσαρμοσμένη παραγγελία';

  @override
  String get newestFirst => 'Πρώτα τα νεότερα';

  @override
  String get oldestFirst => 'Πρώτος παλαιότερος';

  @override
  String get titleAZ => 'Τίτλος: Α-Ζ';

  @override
  String get titleZA => 'Τίτλος: Ζ-Α';

  @override
  String get deleteAllQuestion => 'Διαγραφή όλων;';

  @override
  String get moveToRecycleBin =>
      'Μετακίνηση όλων των σημειώσεων στον Κάδο Ανακύκλωσης;';

  @override
  String get moveToBinQuestion => 'Μετακίνηση στον κάδο;';

  @override
  String get restoreNoteLater =>
      'Μπορείτε να επαναφέρετε αυτήν τη σημείωση αργότερα.';

  @override
  String get move => 'Κίνηση';

  @override
  String get myThoughts => 'Οι Σκέψεις μου';

  @override
  String get selected => 'Επιλεγμένο';

  @override
  String get noContent => 'Χωρίς περιεχόμενο';

  @override
  String get untitled => 'Χωρίς τίτλο';

  @override
  String get chooseWallpapers => 'Επιλέξτε από 10+ δυναμικές ταπετσαρίες';

  @override
  String get backupData => 'Δημιουργία αντιγράφων ασφαλείας δεδομένων';

  @override
  String get saveJsonFile =>
      'Αποθήκευση αρχείου JSON που περιέχει όλα τα δεδομένα σας;';

  @override
  String get exportNow => 'Εξαγωγή τώρα';

  @override
  String get importDataTitle => 'Εισαγωγή δεδομένων';

  @override
  String get mergeBackupFile =>
      'Συγχώνευση αρχείου αντιγράφου ασφαλείας με τα τρέχοντα στοιχεία σας;';

  @override
  String get selectFile => 'Επιλέξτε Αρχείο';

  @override
  String get backupSaved => 'Το αντίγραφο ασφαλείας αποθηκεύτηκε με επιτυχία!';

  @override
  String get exportFailed => 'Η εξαγωγή απέτυχε.';

  @override
  String importSuccess(Object count) {
    return 'Έγινε επιτυχής επαναφορά $count στοιχείων!';
  }

  @override
  String get importFailed => 'Η εισαγωγή απέτυχε.';

  @override
  String widgetAdded(String widget) {
    return 'Το γραφικό στοιχείο προστέθηκε στην αρχική οθόνη!';
  }

  @override
  String get widgetRequestSent =>
      'Στάλθηκε το αίτημα για widget. Ελέγξτε την αρχική οθόνη σας.';

  @override
  String get widgetAddFailed => 'Αποτυχία προσθήκης γραφικού στοιχείου';

  @override
  String get autoSaveEnabled => 'Ενεργοποιήθηκε η αυτόματη αποθήκευση.';

  @override
  String get autoSaveDisabled =>
      'Η αυτόματη αποθήκευση είναι απενεργοποιημένη.';

  @override
  String get homeScreenWidgets => 'Γραφικά στοιχεία αρχικής οθόνης';

  @override
  String get notificationsTitle => 'Ειδοποιήσεις';

  @override
  String get dataBackup => 'Δεδομένα & Backup';

  @override
  String get feedbackSupport => 'Σχόλια & Υποστήριξη';

  @override
  String get creditsTitle => 'Πιστώσεις';

  @override
  String get privacyMaintenance => 'Απόρρητο & Συντήρηση';

  @override
  String get aboutTitle => 'Για';

  @override
  String get premium => 'Ασφάλιστρο';

  @override
  String get appearanceTitle => 'Εμφάνιση';

  @override
  String get clipboardTitle => 'Πρόχειρο';

  @override
  String get settingsSubtitle => 'Προσαρμόστε την εμπειρία σας';

  @override
  String get welcomeTitle => 'Καλώς ορίσατε στο CopyClip';

  @override
  String get welcomeDescription =>
      'Ο απόλυτος σύντροφός σας στην παραγωγικότητα. Ας σας κάνουμε να ρυθμίσετε με ισχυρά εργαλεία για να διαχειριστείτε την ημέρα σας.';

  @override
  String get onboardingNotesTitle => 'Έξυπνες σημειώσεις';

  @override
  String get onboardingNotesDesc =>
      'Καταγράψτε ιδέες άμεσα με μορφοποίηση εμπλουτισμένου κειμένου. Οργανώστε τις σκέψεις σας και μην χάσετε ποτέ ξανά μια υπέροχη ιδέα.';

  @override
  String get onboardingTodosTitle => 'Διαχείριση εργασιών';

  @override
  String get onboardingTodosDesc =>
      'Μείνετε στην κορυφή του παιχνιδιού σας. Δημιουργήστε λίστες υποχρεώσεων, ορίστε προτεραιότητες και συντρίψτε τους στόχους σας ένα σημάδι επιλογής κάθε φορά.';

  @override
  String get onboardingExpensesTitle => 'Παρακολούθηση Εξόδων';

  @override
  String get onboardingExpensesDesc =>
      'Πάρτε τον έλεγχο των οικονομικών σας. Παρακολουθήστε εύκολα τα έσοδα και τα έξοδα για να κατανοήσετε τις συνήθειες δαπανών σας.';

  @override
  String get onboardingJournalTitle => 'Προσωπική Εφημερίδα';

  @override
  String get onboardingJournalDesc =>
      'Σκεφτείτε τη μέρα σας. Ένας ιδιωτικός χώρος για να καταγράψετε τις αναμνήσεις, τα συναισθήματα και τις καθημερινές σας εμπειρίες.';

  @override
  String get onboardingCalendarTitle => 'Ημερολόγιο & Εκδηλώσεις';

  @override
  String get onboardingCalendarDesc =>
      'Μην χάσετε ποτέ μια στιγμή. Οργανώστε το πρόγραμμά σας και παρακολουθήστε σημαντικά επερχόμενα γεγονότα.';

  @override
  String get onboardingClipboardTitle => 'Διαχείριση προχείρου';

  @override
  String get onboardingClipboardDesc =>
      'Αντιγράψτε μία φορά, επικολλήστε οπουδήποτε. Αποκτήστε πρόσβαση στο ιστορικό του προχείρου σας για να ανακτήσετε αποσπάσματα που αντιγράψατε νωρίτερα.';

  @override
  String get onboardingCanvasTitle => 'Δημιουργικός καμβάς';

  @override
  String get onboardingCanvasDesc =>
      'Απελευθερώστε τη δημιουργικότητά σας. Σχεδιάστε, σκιαγραφήστε και οπτικοποιήστε τις ιδέες σας σε έναν ψηφιακό καμβά ελεύθερης μορφής.';

  @override
  String get featuresNotesDesc =>
      'Δημιουργήστε και διαχειριστείτε τις σημειώσεις σας';

  @override
  String get featuresTodosDesc => 'Παρακολουθήστε τις εργασίες σας';

  @override
  String get featuresExpensesDesc => 'Παρακολουθήστε τα έξοδά σας';

  @override
  String get featuresJournalDesc => 'Γράψτε τις σκέψεις σας';

  @override
  String get featuresCalendarDesc => 'Οργανώστε το πρόγραμμά σας';

  @override
  String get featuresClipboardDesc => 'Πρόσβαση στο ιστορικό του προχείρου σας';

  @override
  String get featuresCanvasDesc => 'Ζωγράφισε και σκιαγράφησε ελεύθερα';

  @override
  String get featuresSocialPost => 'Κοινωνική ανάρτηση';

  @override
  String get featuresSocialPostDesc =>
      'Δημιουργήστε ελκυστικό περιεχόμενο κοινωνικής δικτύωσης';

  @override
  String get chooseYourAura => 'Επιλέξτε την Αύρα σας';

  @override
  String get expressYourselfTheme => 'Εκφραστείτε με ένα νέο χρώμα θέματος!';

  @override
  String get level => 'Επίπεδο';

  @override
  String get xpToNextLevel => 'XP σε επίπεδο';

  @override
  String get checkUpcomingEvents => 'Ελέγξτε τις επερχόμενες εκδηλώσεις';

  @override
  String get startNewSketch => 'Ξεκινήστε ένα νέο σκίτσο';

  @override
  String get noTransactionsMonth => 'Δεν υπάρχουν συναλλαγές αυτόν τον μήνα';

  @override
  String transactionsThisMonth(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 's',
      one: '',
    );
    return '$count συναλλαγή$_temp0 αυτόν τον μήνα';
  }

  @override
  String get autoSaveClipboard => 'Αυτόματη αποθήκευση του Πρόχειρου';

  @override
  String get autoSaveClipboardDesc =>
      'Αυτόματη αποθήκευση αντιγραμμένων στοιχείων';

  @override
  String get permissionDeniedSettings =>
      'Η άδεια απορρίφθηκε οριστικά. Ενεργοποιήστε το στις Ρυθμίσεις.';

  @override
  String get notificationsEnabled => 'Οι ειδοποιήσεις ενεργοποιήθηκαν!';

  @override
  String get redirectingToSettings =>
      'Ανακατεύθυνση στις ρυθμίσεις για απενεργοποίηση ειδοποιήσεων...';

  @override
  String get premiumAccess => 'Premium Access';

  @override
  String get premiumActiveUntil => 'Premium Ενεργό μέχρι';

  @override
  String get unlockAllFeatures => 'Ξεκλειδώστε όλες τις δυνατότητες';

  @override
  String get buyPremium => 'Αγορά Premium (7 ημέρες)';

  @override
  String costCoins(Object cost) {
    return 'Κόστος: $cost Κέρματα';
  }

  @override
  String get premiumActivated => 'Premium Ενεργοποιήθηκε για 7 ημέρες!';

  @override
  String get premiumActive => 'Premium Active';

  @override
  String get expires => 'Λήγει:';

  @override
  String get temporaryAccess => 'Προσωρινή Πρόσβαση';

  @override
  String get journalExpression => 'Περιοδικό & Έκφραση';

  @override
  String get artisticDesigns => 'Καλλιτεχνικά Σχέδια';

  @override
  String get artisticDesignsDesc =>
      'Ξεκλειδώστε 10+ μοναδικά θέματα καρτών ημερολογίου';

  @override
  String get premiumLayouts => 'Premium Layouts';

  @override
  String get premiumLayoutsDesc =>
      'Αποκλειστικοί τρόποι για να δείτε τις αναμνήσεις σας';

  @override
  String get calendarTools => 'Ημερολόγιο & Εργαλεία';

  @override
  String get fullCalendar => 'Πλήρες Ημερολόγιο';

  @override
  String get fullCalendarDesc => 'Ολοκληρωμένο σύστημα διαχείρισης εκδηλώσεων';

  @override
  String get clipboardAutoSaveDesc => 'Λήψη ιστορικού προχείρου φόντου';

  @override
  String get proWidgets => 'Επαγγελματικά Widgets';

  @override
  String get proWidgetsDesc =>
      'Όλες οι λειτουργίες είναι διαθέσιμες στην αρχική οθόνη σας';

  @override
  String get dataExport => 'Δεδομένα & Εξαγωγή';

  @override
  String get advancedBackup => 'Σύνθετη δημιουργία αντιγράφων ασφαλείας';

  @override
  String get advancedBackupDesc =>
      'Ασφαλής εισαγωγή/εξαγωγή όλων των δεδομένων';

  @override
  String get pdfExport => 'Εξαγωγή PDF';

  @override
  String get pdfExportDesc => 'Εξαγωγή σημειώσεων και περιοδικών σε PDF';

  @override
  String get printReady => 'Έτοιμο για εκτύπωση';

  @override
  String get printReadyDesc => 'Άμεση υποστήριξη εκτύπωσης';

  @override
  String get richTextEditor => 'Επεξεργαστής εμπλουτισμένου κειμένου';

  @override
  String get advancedSearch => 'Σύνθετη αναζήτηση';

  @override
  String get advancedSearchDesc => 'Αναζήτηση & Αντικατάσταση στο κείμενό σας';

  @override
  String get richMedia => 'Rich Media';

  @override
  String get richMediaDesc => 'Εισαγάγετε εικόνες, βίντεο και συνδέσμους';

  @override
  String get editorStyling => 'Editor Styling';

  @override
  String get editorStylingDesc =>
      'Προσαρμοσμένο υπόβαθρο κειμένου και επεξεργαστή';

  @override
  String get balance => 'Ισορροπία';

  @override
  String get loadingAd => 'Φόρτωση διαφήμισης...';

  @override
  String watchAd(Object amount) {
    return 'Παρακολούθηση διαφήμισης (+$amount)';
  }

  @override
  String get loadAd => 'Φόρτωση διαφήμισης';

  @override
  String get backupDataDesc => 'Αποθηκεύστε ένα αρχείο JSON των δεδομένων σας';

  @override
  String get importDataDesc =>
      'Συγχωνεύστε ένα αρχείο αντιγράφου ασφαλείας στο CopyClip';

  @override
  String get notificationPermissionDenied => 'Η άδεια ειδοποίησης απορρίφθηκε.';

  @override
  String get typeNewTask => 'Πληκτρολογήστε μια νέα εργασία...';

  @override
  String get addTask => 'Προσθέστε μια εργασία';

  @override
  String get completed => 'Ολοκληρώθηκε το';

  @override
  String get greatJob => 'Μεγάλη δουλειά!';

  @override
  String youEarnedXPNextTask(Object amount, Object date) {
    return 'Κερδίσατε $amount XP! Επόμενη εργασία: $date';
  }

  @override
  String taskCompletedXP(Object amount) {
    return 'Η εργασία ολοκληρώθηκε! +$amount XP';
  }

  @override
  String get moveTasksToRecycleBin =>
      'Μετακίνηση όλων των ενεργών εργασιών στον Κάδο Ανακύκλωσης;';

  @override
  String get deleteAllPosts => 'Διαγραφή όλων των αναρτήσεων';

  @override
  String get deleteAllPostsConfirmation =>
      'Είστε βέβαιοι ότι θέλετε να διαγράψετε ΟΛΕΣ τις αναρτήσεις στα κοινωνικά δίκτυα; Αυτό δεν μπορεί να αναιρεθεί.';

  @override
  String get allPosts => 'Όλες οι αναρτήσεις';

  @override
  String get favorites => 'Αγαπημένα';

  @override
  String get drafts => 'Προσχέδια';

  @override
  String get noFavoritesYet => 'Δεν υπάρχουν ακόμα αγαπημένα';

  @override
  String get noDraftsYet => 'Δεν υπάρχουν ακόμη προσχέδια';

  @override
  String get startSocialJourney => 'Ξεκινήστε το κοινωνικό σας ταξίδι!';

  @override
  String get draft => 'ΠΡΟΣΧΕΔΙΟ';

  @override
  String attachmentCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 's',
      one: '',
    );
    return '$count συνημμένο$_temp0';
  }

  @override
  String get pleaseAddContent =>
      'Προσθέστε κάποιο περιεχόμενο ή πολυμέσα για κοινή χρήση';

  @override
  String fileNotFoundError(Object path) {
    return 'Σφάλμα: Το αρχείο δεν βρέθηκε στο $path';
  }

  @override
  String get checkFacebookApp => 'Ελέγξτε την εφαρμογή Facebook';

  @override
  String get systemShare => 'Κοινή χρήση συστήματος';

  @override
  String get socialPost => 'Κοινωνική ανάρτηση';

  @override
  String get favorite => 'Ευνοούμενος';

  @override
  String get saveDraft => 'Αποθήκευση σχεδίου';

  @override
  String get entryCopied => 'Η καταχώρηση αντιγράφηκε';

  @override
  String get moveEntriesToRecycleBin =>
      'Μετακίνηση όλων των ενεργών καταχωρήσεων στον Κάδο Ανακύκλωσης;';

  @override
  String get startWritingStory => 'Ξεκινήστε να γράφετε την ιστορία σας';

  @override
  String get recordMemories =>
      'Καταγράψτε τις καθημερινές σας αναμνήσεις και συναισθήματα.';

  @override
  String get writeJournal => 'Γράψτε περιοδικό';

  @override
  String get myMemories => 'Οι αναμνήσεις μου';

  @override
  String get sortJournal => 'Ταξινόμηση περιοδικών';

  @override
  String get byMood => 'Με διάθεση';

  @override
  String get searchMemories => 'Αναζήτηση αναμνήσεων...';

  @override
  String get selectAll => 'Επιλέξτε Όλα';

  @override
  String get deleteSelected => 'Διαγραφή επιλεγμένων';

  @override
  String get taskCompletedExclamation => 'Η εργασία ολοκληρώθηκε!';

  @override
  String get taskUncompletedExclamation => 'Η εργασία δεν ολοκληρώθηκε';

  @override
  String get clipboardUpdatedExclamation => 'Το πρόχειρο ενημερώθηκε!';

  @override
  String clipboardSavedContent(Object content) {
    return 'Το πρόχειρο αποθηκεύτηκε: $content';
  }

  @override
  String get overview => 'Επισκόπηση';

  @override
  String get colorAurora => 'Αυγή';

  @override
  String get colorCosmic => 'Κοσμικός';

  @override
  String get colorNebula => 'Νεφέλωμα';

  @override
  String get colorStarlight => 'Αστροφεγγιά';

  @override
  String get colorSolar => 'Ηλιακός';

  @override
  String get colorNova => 'Νέος';

  @override
  String get loadingStepLoading => 'Φόρτωση...';

  @override
  String get loadingStepDatabase => 'Ρύθμιση βάσης δεδομένων...';

  @override
  String get loadingStepSystem => 'Διαμόρφωση συστήματος...';

  @override
  String get loadingStepReady => 'Ετοιμος';

  @override
  String get productivityCompanion => 'Ο σύντροφός σας στην παραγωγικότητα';

  @override
  String get done => 'Γινώμενος';

  @override
  String get newNote => 'Νέα Σημείωση';

  @override
  String get changeColor => 'Αλλαγή χρώματος';

  @override
  String get copyContent => 'Αντιγραφή περιεχομένου';

  @override
  String get titleOptional => 'Τίτλος (Προαιρετικό)';

  @override
  String get exportAsPdf => 'Εξαγωγή ως PDF';

  @override
  String get taskDueNow => 'Οφειλόμενη εργασία τώρα';

  @override
  String get moveTaskToBinTitle => 'Μετακίνηση Εργασίας στον Κάδο Ανακύκλωσης;';

  @override
  String get restoreTaskLater =>
      'Μπορείτε να επαναφέρετε αυτήν την εργασία αργότερα από τις ρυθμίσεις.';

  @override
  String get newTask => 'Νέα εργασία';

  @override
  String get editTask => 'Επεξεργασία εργασίας';

  @override
  String get undo => 'Ξεκάνω';

  @override
  String get redo => 'Ξανακάνω';

  @override
  String get category => 'Κατηγορία';

  @override
  String get categoryHint => 'π.χ. Εργασία, γυμναστήριο';

  @override
  String get whatNeedsToBeDone => 'Τι πρέπει να γίνει;';

  @override
  String get enterTaskDetails => 'Εισαγάγετε τα στοιχεία της εργασίας...';

  @override
  String get setDueDate => 'Ορισμός ημερομηνίας λήξης';

  @override
  String get dueDate => 'Δύο ραντεβού';

  @override
  String get expenseTitle => 'Εξοδα';

  @override
  String searchInCurrency(String currency) {
    return 'Αναζήτηση σε $currency...';
  }

  @override
  String get sortAndFilter => 'Ταξινόμηση & Φιλτράρισμα';

  @override
  String get sortBy => 'ΤΑΞΙΝΟΜΗΣΗ ΚΑΤΑ';

  @override
  String get highestAmount => 'Υψηλότερο Ποσό';

  @override
  String get lowestAmount => 'Χαμηλότερο ποσό';

  @override
  String get moreFilters => 'Περισσότερα φίλτρα...';

  @override
  String get filterExpenses => 'Φιλτράρισμα εξόδων';

  @override
  String get transactionType => 'Τύπος συναλλαγής';

  @override
  String get categories => 'Κατηγορίες';

  @override
  String get all => 'Ολοι';

  @override
  String get income => 'Εισόδημα';

  @override
  String get expense => 'Δαπάνη';

  @override
  String get reset => 'Επαναφορά';

  @override
  String get apply => 'Εφαρμόζω';

  @override
  String newExpense(String currency) {
    return 'Νέο $currency';
  }

  @override
  String errorLoadingData(String error) {
    return 'Σφάλμα κατά τη φόρτωση δεδομένων.\n\n$error';
  }

  @override
  String get dailyQuote1 =>
      'Ο καλύτερος τρόπος να προβλέψεις το μέλλον είναι να το δημιουργήσεις.';

  @override
  String get dailyQuote2 =>
      'Ο πλούτος δεν συνίσταται στο να έχεις μεγάλα υπάρχοντα, αλλά στο να έχεις λίγα θέλω.';

  @override
  String get dailyQuote3 => 'Ο χρόνος είναι το απόλυτο νόμισμα.';

  @override
  String get dailyQuote4 =>
      'Η επιτυχία δεν είναι οριστική, η αποτυχία δεν είναι μοιραία.';

  @override
  String get dailyQuote5 => 'Εστιάστε στη λύση, όχι στο πρόβλημα.';

  @override
  String get dailyQuote6 => 'Το δίκτυό σας είναι η καθαρή σας αξία.';

  @override
  String get moodHappy => 'Ευτυχισμένος';

  @override
  String get moodExcited => 'Ερεθισμένος';

  @override
  String get moodNeutral => 'Ουδέτερος';

  @override
  String get moodSad => 'Λυπημένος';

  @override
  String get moodStressed => 'Τονισμένα';

  @override
  String exportDate(String date) {
    return '📅 $date';
  }

  @override
  String exportMood(String emoji, String mood) {
    return 'Διάθεση: $emoji $mood';
  }

  @override
  String exportTitle(String title) {
    return 'ΤΙΤΛΟΣ: $title';
  }

  @override
  String exportTags(String tags) {
    return 'Ετικέτες: $tags';
  }

  @override
  String get instagram => 'Instagram';

  @override
  String get facebook => 'Facebook';

  @override
  String get tiktok => 'TikTok';

  @override
  String get newSketch => 'Νέο Σκίτσο';

  @override
  String get searchSketches => 'Αναζήτηση σκίτσων και φακέλων...';

  @override
  String get noResultsFound => 'Δεν βρέθηκαν αποτελέσματα';

  @override
  String get noItems => 'Δεν υπάρχουν στοιχεία';

  @override
  String get noDrawingsYet => 'Δεν υπάρχουν σχέδια ακόμα';

  @override
  String get canvasIntro => 'Απελευθερώστε τη δημιουργικότητά σας στον καμβά!';

  @override
  String get newCanvas => 'Νέος καμβάς';

  @override
  String get rename => 'Μετονομάζω';

  @override
  String get deleteFolder => 'Διαγραφή φακέλου';

  @override
  String get deleteSketchesQuestion => 'Διαγραφή σκίτσων;';

  @override
  String get deleteFolderConfirmation =>
      'Όλα τα σκίτσα σε αυτόν τον φάκελο θα διαγραφούν οριστικά.';

  @override
  String get renameFolder => 'Μετονομασία φακέλου';

  @override
  String get chooseColor => 'Επιλέξτε Χρώμα';

  @override
  String get deleteFolderQuestion => 'Διαγραφή φακέλου;';

  @override
  String get searchClips => 'Αναζήτηση κλιπ...';

  @override
  String get clipboardEmpty => 'Το πρόχειρο είναι κενό';

  @override
  String get addItem => 'Προσθήκη αντικειμένου';

  @override
  String get clipColor => 'Χρώμα κλιπ';

  @override
  String get newClip => 'Νέο Κλιπ';

  @override
  String get editClip => 'Επεξεργασία κλιπ';

  @override
  String get restoreClipLater =>
      'Μπορείτε να επαναφέρετε αυτό το κλιπ αργότερα.';

  @override
  String get upcomingEvents => 'Προσεχείς Εκδηλώσεις';

  @override
  String get dataDistribution => 'ΔΙΑΝΟΜΗ ΔΕΔΟΜΕΝΩΝ';

  @override
  String get taskProgress => 'ΠΡΟΟΔΟΣ ΕΡΓΟΥ';

  @override
  String get quickStats => 'ΓΡΗΓΟΡΑ ΣΤΑΤΙΣΤΙΚΑ';

  @override
  String get taskCompletion => 'Ολοκλήρωση Εργασίας';

  @override
  String get noItemsForDate => 'Δεν υπάρχουν στοιχεία για αυτήν την ημερομηνία';

  @override
  String get enjoyFreeTime => 'Απολαύστε τον ελεύθερο χρόνο σας!';

  @override
  String get searchThisDay => 'Ψάξτε σήμερα...';

  @override
  String get finance => 'Οικονομικά';

  @override
  String get permanentlyDelete => 'Οριστική διαγραφή;';

  @override
  String deleteSelectionConfirmation(int foldersCount, int sketchesCount) {
    return 'Αυτό θα διαγράψει οριστικά τους φακέλους $foldersCount (και τα σκίτσα τους) και τα άλλα σκίτσα $sketchesCount.\n\nΑυτό δεν μπορεί να αναιρεθεί.';
  }

  @override
  String get deleteForever => 'Διαγραφή για πάντα';

  @override
  String selectedCount(int count) {
    return '$count Επιλέχτηκε';
  }

  @override
  String canvasStats(int notes, int folders) {
    return '$notes σκίτσα • $folders φάκελοι';
  }

  @override
  String get sortItems => 'Ταξινόμηση αντικειμένων';

  @override
  String get sortNameAZ => 'Όνομα (A-Z)';

  @override
  String get sortNameZA => 'Όνομα (Z-A)';

  @override
  String get createFolder => 'Δημιουργία φακέλου';

  @override
  String get folderNameHint => 'Όνομα φακέλου...';

  @override
  String deleteSketchesConfirmation(int count) {
    return 'Διαγραφή $count σκίτσων; Αυτό δεν μπορεί να αναιρεθεί.';
  }

  @override
  String get noSketchesFound => 'Δεν βρέθηκαν σκίτσα';

  @override
  String get noSketchesFoundSub =>
      'Δοκιμάστε να προσαρμόσετε την αναζήτησή σας ή να δημιουργήσετε ένα νέο σκίτσο.';

  @override
  String searchInFolder(String folder) {
    return 'Αναζήτηση στο $folder...';
  }

  @override
  String sketchesCount(int count) {
    return '$count σκίτσα';
  }

  @override
  String get sortSketches => 'Ταξινόμηση σκίτσων';

  @override
  String get calendarScreenTitle => 'Ημερολόγιο';

  @override
  String get dailyActivity => 'Καθημερινή Δραστηριότητα';

  @override
  String get deleteItemQuestion => 'Διαγραφή στοιχείου;';

  @override
  String get deleteItemConfirmation =>
      'Αυτό θα μετακινήσει το αντικείμενο στον κάδο ανακύκλωσης.';

  @override
  String get moveToBinItem => 'Μετακίνηση στον κάδο;';

  @override
  String get moveToBinConfirmation => 'Μπορείτε να το επαναφέρετε αργότερα.';

  @override
  String selectedItems(int count) {
    return '$count Επιλέχτηκε';
  }

  @override
  String get recentClips => 'Πρόσφατα κλιπ';

  @override
  String get copied => 'Αντιγράφηκε!';

  @override
  String get copiedPlainText => 'Αντιγράφηκε απλό κείμενο';

  @override
  String get clipTheme => 'Θέμα κλιπ';

  @override
  String get justNow => 'Μόλις τώρα';

  @override
  String minutesAgo(Object count) {
    return 'πριν από $countλ';
  }

  @override
  String hoursAgo(Object count) {
    return '${count}h πριν';
  }

  @override
  String daysAgo(Object count) {
    return 'πριν από ${count}d';
  }

  @override
  String get noTasksFound => 'Δεν βρέθηκαν εργασίες.';

  @override
  String get searchTasks => 'Εργασίες αναζήτησης...';

  @override
  String get taskReminder => 'Υπενθύμιση εργασιών';

  @override
  String get untitledNote => 'Σημείωση χωρίς τίτλο';

  @override
  String get dailyEntry => 'Καθημερινή Είσοδος';

  @override
  String get clipboardHistory => 'Ιστορικό πρόχειρου';

  @override
  String get deletePermanentlyContent =>
      'Αυτή η ενέργεια δεν μπορεί να αναιρεθεί.';

  @override
  String get emptyRecycleBinTitle => 'Άδειος Κάδος Ανακύκλωσης;';

  @override
  String emptyRecycleBinContent(Object count) {
    return 'Όλα τα $count στοιχεία θα διαγραφούν οριστικά.';
  }

  @override
  String get emptyBin => 'Άδειος Κάδος';

  @override
  String get recycleBinEmpty => 'Ο Κάδος Ανακύκλωσης είναι άδειος';

  @override
  String get deletedItemsAppearHere =>
      'Τα διαγραμμένα στοιχεία θα εμφανιστούν εδώ.';

  @override
  String get empty => 'Αδειάζω';

  @override
  String get recent => 'Πρόσφατος';

  @override
  String categoryLabel(Object category) {
    return 'Κατηγορία: $category';
  }

  @override
  String get general => 'Γενικός';

  @override
  String get saveTransactionQuestion =>
      'Θέλετε να αποθηκεύσετε αυτήν τη συναλλαγή;';

  @override
  String get fillTitleAmount => 'Συμπληρώστε τον τίτλο και το ποσό';

  @override
  String get invalidAmount => 'Μη έγκυρη μορφή ποσού';

  @override
  String get moveTransactionToBinTitle =>
      'Μετακίνηση συναλλαγής στον Κάδο Ανακύκλωσης;';

  @override
  String get restoreTransactionLater =>
      'Μπορείτε να επαναφέρετε αυτήν τη συναλλαγή αργότερα από τις ρυθμίσεις.';

  @override
  String get newTransaction => 'Νέα συναλλαγή';

  @override
  String get whatIsThisFor => 'Σε τι χρησιμεύει αυτό;';

  @override
  String get description => 'Περιγραφή';

  @override
  String get daily => 'Καθημερινά';

  @override
  String get weekly => 'Εβδομαδιαίος';

  @override
  String get monthly => 'Μηνιαίος';

  @override
  String get yearly => 'Ετήσια';

  @override
  String get totalIncome => 'Συνολικό εισόδημα';

  @override
  String get totalExpense => 'Συνολικές δαπάνες';

  @override
  String get analysis => 'Ανάλυση';

  @override
  String get transactions => 'Συναλλαγές';

  @override
  String get noExpensesFound => 'Δεν βρέθηκαν έξοδα για αυτήν την περίοδο.';

  @override
  String get netBalance => 'Καθαρό Υπόλοιπο';

  @override
  String get topCategories => 'Κορυφαίες Κατηγορίες';

  @override
  String get spendingTrend => 'Τάση δαπανών';

  @override
  String get insights => 'Insights';

  @override
  String get noExpensesRecorded => 'Δεν καταγράφηκαν έξοδα';

  @override
  String get trackSpendingHabits =>
      'Παρακολουθήστε εύκολα τις συνήθειες δαπανών σας.';

  @override
  String get addExpense => 'Προσθήκη εξόδων';

  @override
  String get noDataForPeriod => 'Δεν υπάρχουν δεδομένα για αυτήν την περίοδο';

  @override
  String get budget => 'Προϋπολογισμός';

  @override
  String get spent => 'Ξοδεύτηκε';

  @override
  String get limit => 'Οριο';

  @override
  String get overBudget => 'Πάνω από τον προϋπολογισμό!';

  @override
  String remainingBudget(Object percent) {
    return 'Απομένει $percent%.';
  }

  @override
  String get savingsRate => 'Ποσοστό Αποταμίευσης';

  @override
  String get healthScore => 'Βαθμολογία υγείας';

  @override
  String get healthScoreExplanation =>
      'Αυτή η βαθμολογία βασίζεται στο ποσοστό αποταμίευσης.\n\n• > 50% αποθηκευμένο = Εξαιρετικό (100)\n• 0% αποθηκευμένο = Μέσος όρος (50)\n• Δαπάνες > Εισόδημα = Κακή (<50)';

  @override
  String get ok => 'ΕΝΤΑΞΕΙ';

  @override
  String get bulkImport => 'Bulk Import';
}

/// The translations for Modern Greek, as used in Greece (`el_GR`).
class AppLocalizationsElGr extends AppLocalizationsEl {
  AppLocalizationsElGr() : super('el_GR');

  @override
  String get settings => 'Ρυθμίσεις';

  @override
  String get language => 'Γλώσσα';

  @override
  String get systemDefault => 'Προεπιλογή συστήματος';

  @override
  String get notes => 'Σημειώσεις';

  @override
  String get todos => 'To-Dos';

  @override
  String get expenses => 'Εξοδα';

  @override
  String get journal => 'Εφημερίδα';

  @override
  String get calendar => 'Ημερολόγιο';

  @override
  String get clipboard => 'Πρόχειρο';

  @override
  String get canvas => 'Καμβάς';

  @override
  String get save => 'Εκτός';

  @override
  String get create => 'Δημιουργώ';

  @override
  String get cancel => 'Ματαίωση';

  @override
  String get delete => 'Διαγράφω';

  @override
  String get edit => 'Εκδίδω';

  @override
  String get share => 'Μερίδιο';

  @override
  String get copy => 'Αντίγραφο';

  @override
  String get unsavedChanges => 'Μη αποθηκευμένες αλλαγές';

  @override
  String get confirmDelete => 'Επιβεβαίωση Διαγραφής';

  @override
  String get discard => 'Απορρίπτω';

  @override
  String get createPost => 'Δημιουργία ανάρτησης';

  @override
  String get post => 'Θέση';

  @override
  String get postingTo => 'Δημοσίευση σε';

  @override
  String get whatsOnYourMind => 'Τι έχεις στο μυαλό σου;';

  @override
  String get pickImages => 'Επιλέξτε Εικόνες';

  @override
  String get pickVideo => 'Επιλέξτε βίντεο';

  @override
  String get camera => 'Κάμερα';

  @override
  String get gallery => 'Στοά';

  @override
  String get search => 'Ερευνα';

  @override
  String get pleaseEnterTask => 'Εισαγάγετε μια εργασία';

  @override
  String get deleteTask => 'Διαγραφή Εργασίας';

  @override
  String get selectItems => 'Επιλέξτε Στοιχεία';

  @override
  String get deleteAll => 'Διαγραφή όλων';

  @override
  String error(Object error) {
    return 'Σφάλμα: $error';
  }

  @override
  String get orderingOnlyAvailableInAllPosts =>
      'Η παραγγελία είναι διαθέσιμη μόνο σε \"Όλες οι αναρτήσεις\"';

  @override
  String get deletePost => 'Διαγραφή ανάρτησης';

  @override
  String get postDeleted => 'Η ανάρτηση διαγράφηκε';

  @override
  String get premiumFeatures => 'Premium Χαρακτηριστικά';

  @override
  String get manageCoinsAdsPremium =>
      'Διαχειριστείτε νομίσματα, διαφημίσεις και κατάσταση premium';

  @override
  String get themeMode => 'Λειτουργία θέματος';

  @override
  String get accentColor => 'Χρώμα έμφασης';

  @override
  String get backgroundDesign => 'Σχεδιασμός φόντου';

  @override
  String get pushNotifications => 'Push Notifications';

  @override
  String get recycleBin => 'Κάδος Ανακύκλωσης';

  @override
  String get exportData => 'Εξαγωγή δεδομένων';

  @override
  String get importData => 'Εισαγωγή δεδομένων';

  @override
  String get rateApp => 'Βαθμολογήστε την εφαρμογή';

  @override
  String get sendFeedback => 'Αποστολή σχολίων';

  @override
  String get privacyPolicy => 'Πολιτική Απορρήτου';

  @override
  String get version => 'Εκδοχή';

  @override
  String get buildNumber => 'Αριθμός κατασκευής';

  @override
  String get system => 'Σύστημα';

  @override
  String get light => 'Φως';

  @override
  String get dark => 'Σκοτάδι';

  @override
  String get itemRestored => 'Το στοιχείο αποκαταστάθηκε';

  @override
  String get recycleBinCleared =>
      'Ο Κάδος Ανακύκλωσης εκκαθαρίστηκε με επιτυχία';

  @override
  String get allPostsDeleted => 'Όλες οι αναρτήσεις διαγράφηκαν';

  @override
  String get newPost => 'Νέα ανάρτηση';

  @override
  String get textCopiedToClipboardFacebook =>
      'Το κείμενο αντιγράφηκε στο πρόχειρο (πολιτική Facebook)';

  @override
  String get tiktokSharingRequiresVideoImage =>
      'Η κοινή χρήση TikTok απαιτεί βίντεο/εικόνα';

  @override
  String errorSharing(Object error) {
    return 'Κοινοποίηση σφάλματος: $error';
  }

  @override
  String shareToStory(Object platform) {
    return 'Κοινοποίηση στο $platform Story';
  }

  @override
  String shareToFeed(Object platform) {
    return 'Κοινή χρήση στη ροή $platform';
  }

  @override
  String get unlockPermanently => 'Ξεκλείδωμα μόνιμα';

  @override
  String get notEnoughCoins => 'Δεν υπάρχουν αρκετά νομίσματα!';

  @override
  String youEarnedCoins(Object amount) {
    return 'Κερδίσατε $amount νομίσματα!';
  }

  @override
  String get contentCopied => 'Το περιεχόμενο αντιγράφηκε';

  @override
  String get selectDateTime => 'Επιλέξτε Ημερομηνία & Ώρα';

  @override
  String get areYouSureYouWantToDeleteThisPost =>
      'Είστε βέβαιοι ότι θέλετε να διαγράψετε αυτήν την ανάρτηση;';

  @override
  String get socialPosts => 'Κοινωνικές αναρτήσεις';

  @override
  String get watchAdToEarnCoins =>
      'Παρακολουθήστε τη διαφήμιση για να κερδίσετε νομίσματα';

  @override
  String get premiumUnlocked => 'Premium Ξεκλείδωτο';

  @override
  String get removeAds => 'Κατάργηση διαφημίσεων';

  @override
  String get unlimitedCloudStorage => 'Απεριόριστος χώρος αποθήκευσης Cloud';

  @override
  String get deleteNote => 'Διαγραφή Σημείωσης';

  @override
  String get shareNote => 'Κοινή χρήση Σημείωση';

  @override
  String get editNote => 'Επεξεργασία Σημείωσης';

  @override
  String get searchNotes => 'Αναζήτηση σημειώσεων...';

  @override
  String get noNotesFound => 'Δεν βρέθηκαν σημειώσεις';

  @override
  String get captureThoughts => 'Καταγράψτε τις σκέψεις σας αμέσως.';

  @override
  String get createNote => 'Δημιουργία Σημείωσης';

  @override
  String get customOrder => 'Προσαρμοσμένη παραγγελία';

  @override
  String get newestFirst => 'Πρώτα τα νεότερα';

  @override
  String get oldestFirst => 'Πρώτος παλαιότερος';

  @override
  String get titleAZ => 'Τίτλος: Α-Ζ';

  @override
  String get titleZA => 'Τίτλος: Ζ-Α';

  @override
  String get deleteAllQuestion => 'Διαγραφή όλων;';

  @override
  String get moveToRecycleBin =>
      'Μετακίνηση όλων των σημειώσεων στον Κάδο Ανακύκλωσης;';

  @override
  String get moveToBinQuestion => 'Μετακίνηση στον κάδο;';

  @override
  String get restoreNoteLater =>
      'Μπορείτε να επαναφέρετε αυτήν τη σημείωση αργότερα.';

  @override
  String get move => 'Κίνηση';

  @override
  String get myThoughts => 'Οι Σκέψεις μου';

  @override
  String get selected => 'Επιλεγμένο';

  @override
  String get noContent => 'Χωρίς περιεχόμενο';

  @override
  String get untitled => 'Χωρίς τίτλο';

  @override
  String get chooseWallpapers => 'Επιλέξτε από 10+ δυναμικές ταπετσαρίες';

  @override
  String get backupData => 'Δημιουργία αντιγράφων ασφαλείας δεδομένων';

  @override
  String get saveJsonFile =>
      'Αποθήκευση αρχείου JSON που περιέχει όλα τα δεδομένα σας;';

  @override
  String get exportNow => 'Εξαγωγή τώρα';

  @override
  String get importDataTitle => 'Εισαγωγή δεδομένων';

  @override
  String get mergeBackupFile =>
      'Συγχώνευση αρχείου αντιγράφου ασφαλείας με τα τρέχοντα στοιχεία σας;';

  @override
  String get selectFile => 'Επιλέξτε Αρχείο';

  @override
  String get backupSaved => 'Το αντίγραφο ασφαλείας αποθηκεύτηκε με επιτυχία!';

  @override
  String get exportFailed => 'Η εξαγωγή απέτυχε.';

  @override
  String importSuccess(Object count) {
    return 'Έγινε επιτυχής επαναφορά $count στοιχείων!';
  }

  @override
  String get importFailed => 'Η εισαγωγή απέτυχε.';

  @override
  String widgetAdded(String widget) {
    return 'Το γραφικό στοιχείο προστέθηκε στην αρχική οθόνη!';
  }

  @override
  String get widgetRequestSent =>
      'Στάλθηκε το αίτημα για widget. Ελέγξτε την αρχική οθόνη σας.';

  @override
  String get widgetAddFailed => 'Αποτυχία προσθήκης γραφικού στοιχείου';

  @override
  String get autoSaveEnabled => 'Ενεργοποιήθηκε η αυτόματη αποθήκευση.';

  @override
  String get autoSaveDisabled =>
      'Η αυτόματη αποθήκευση είναι απενεργοποιημένη.';

  @override
  String get homeScreenWidgets => 'Γραφικά στοιχεία αρχικής οθόνης';

  @override
  String get notificationsTitle => 'Ειδοποιήσεις';

  @override
  String get dataBackup => 'Δεδομένα & Backup';

  @override
  String get feedbackSupport => 'Σχόλια & Υποστήριξη';

  @override
  String get creditsTitle => 'Πιστώσεις';

  @override
  String get privacyMaintenance => 'Απόρρητο & Συντήρηση';

  @override
  String get aboutTitle => 'Για';

  @override
  String get premium => 'Ασφάλιστρο';

  @override
  String get appearanceTitle => 'Εμφάνιση';

  @override
  String get clipboardTitle => 'Πρόχειρο';

  @override
  String get settingsSubtitle => 'Προσαρμόστε την εμπειρία σας';

  @override
  String get welcomeTitle => 'Καλώς ορίσατε στο CopyClip';

  @override
  String get welcomeDescription =>
      'Ο απόλυτος σύντροφός σας στην παραγωγικότητα. Ας σας κάνουμε να ρυθμίσετε με ισχυρά εργαλεία για να διαχειριστείτε την ημέρα σας.';

  @override
  String get onboardingNotesTitle => 'Έξυπνες σημειώσεις';

  @override
  String get onboardingNotesDesc =>
      'Καταγράψτε ιδέες άμεσα με μορφοποίηση εμπλουτισμένου κειμένου. Οργανώστε τις σκέψεις σας και μην χάσετε ποτέ ξανά μια υπέροχη ιδέα.';

  @override
  String get onboardingTodosTitle => 'Διαχείριση εργασιών';

  @override
  String get onboardingTodosDesc =>
      'Μείνετε στην κορυφή του παιχνιδιού σας. Δημιουργήστε λίστες υποχρεώσεων, ορίστε προτεραιότητες και συντρίψτε τους στόχους σας ένα σημάδι επιλογής κάθε φορά.';

  @override
  String get onboardingExpensesTitle => 'Παρακολούθηση Εξόδων';

  @override
  String get onboardingExpensesDesc =>
      'Πάρτε τον έλεγχο των οικονομικών σας. Παρακολουθήστε εύκολα τα έσοδα και τα έξοδα για να κατανοήσετε τις συνήθειες δαπανών σας.';

  @override
  String get onboardingJournalTitle => 'Προσωπική Εφημερίδα';

  @override
  String get onboardingJournalDesc =>
      'Σκεφτείτε τη μέρα σας. Ένας ιδιωτικός χώρος για να καταγράψετε τις αναμνήσεις, τα συναισθήματα και τις καθημερινές σας εμπειρίες.';

  @override
  String get onboardingCalendarTitle => 'Ημερολόγιο & Εκδηλώσεις';

  @override
  String get onboardingCalendarDesc =>
      'Μην χάσετε ποτέ μια στιγμή. Οργανώστε το πρόγραμμά σας και παρακολουθήστε σημαντικά επερχόμενα γεγονότα.';

  @override
  String get onboardingClipboardTitle => 'Διαχείριση προχείρου';

  @override
  String get onboardingClipboardDesc =>
      'Αντιγράψτε μία φορά, επικολλήστε οπουδήποτε. Αποκτήστε πρόσβαση στο ιστορικό του προχείρου σας για να ανακτήσετε αποσπάσματα που αντιγράψατε νωρίτερα.';

  @override
  String get onboardingCanvasTitle => 'Δημιουργικός καμβάς';

  @override
  String get onboardingCanvasDesc =>
      'Απελευθερώστε τη δημιουργικότητά σας. Σχεδιάστε, σκιαγραφήστε και οπτικοποιήστε τις ιδέες σας σε έναν ψηφιακό καμβά ελεύθερης μορφής.';

  @override
  String get featuresNotesDesc =>
      'Δημιουργήστε και διαχειριστείτε τις σημειώσεις σας';

  @override
  String get featuresTodosDesc => 'Παρακολουθήστε τις εργασίες σας';

  @override
  String get featuresExpensesDesc => 'Παρακολουθήστε τα έξοδά σας';

  @override
  String get featuresJournalDesc => 'Γράψτε τις σκέψεις σας';

  @override
  String get featuresCalendarDesc => 'Οργανώστε το πρόγραμμά σας';

  @override
  String get featuresClipboardDesc => 'Πρόσβαση στο ιστορικό του προχείρου σας';

  @override
  String get featuresCanvasDesc => 'Ζωγράφισε και σκιαγράφησε ελεύθερα';

  @override
  String get featuresSocialPost => 'Κοινωνική ανάρτηση';

  @override
  String get featuresSocialPostDesc =>
      'Δημιουργήστε ελκυστικό περιεχόμενο κοινωνικής δικτύωσης';

  @override
  String get chooseYourAura => 'Επιλέξτε την Αύρα σας';

  @override
  String get expressYourselfTheme => 'Εκφραστείτε με ένα νέο χρώμα θέματος!';

  @override
  String get level => 'Επίπεδο';

  @override
  String get xpToNextLevel => 'XP σε επίπεδο';

  @override
  String get checkUpcomingEvents => 'Ελέγξτε τις επερχόμενες εκδηλώσεις';

  @override
  String get startNewSketch => 'Ξεκινήστε ένα νέο σκίτσο';

  @override
  String get noTransactionsMonth => 'Δεν υπάρχουν συναλλαγές αυτόν τον μήνα';

  @override
  String transactionsThisMonth(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 's',
      one: '',
    );
    return '$count συναλλαγή$_temp0 αυτόν τον μήνα';
  }

  @override
  String get autoSaveClipboard => 'Αυτόματη αποθήκευση του Πρόχειρου';

  @override
  String get autoSaveClipboardDesc =>
      'Αυτόματη αποθήκευση αντιγραμμένων στοιχείων';

  @override
  String get permissionDeniedSettings =>
      'Η άδεια απορρίφθηκε οριστικά. Ενεργοποιήστε το στις Ρυθμίσεις.';

  @override
  String get notificationsEnabled => 'Οι ειδοποιήσεις ενεργοποιήθηκαν!';

  @override
  String get redirectingToSettings =>
      'Ανακατεύθυνση στις ρυθμίσεις για απενεργοποίηση ειδοποιήσεων...';

  @override
  String get premiumAccess => 'Premium Access';

  @override
  String get premiumActiveUntil => 'Premium Ενεργό μέχρι';

  @override
  String get unlockAllFeatures => 'Ξεκλειδώστε όλες τις δυνατότητες';

  @override
  String get buyPremium => 'Αγορά Premium (7 ημέρες)';

  @override
  String costCoins(Object cost) {
    return 'Κόστος: $cost Κέρματα';
  }

  @override
  String get premiumActivated => 'Premium Ενεργοποιήθηκε για 7 ημέρες!';

  @override
  String get premiumActive => 'Premium Active';

  @override
  String get expires => 'Λήγει:';

  @override
  String get temporaryAccess => 'Προσωρινή Πρόσβαση';

  @override
  String get journalExpression => 'Περιοδικό & Έκφραση';

  @override
  String get artisticDesigns => 'Καλλιτεχνικά Σχέδια';

  @override
  String get artisticDesignsDesc =>
      'Ξεκλειδώστε 10+ μοναδικά θέματα καρτών ημερολογίου';

  @override
  String get premiumLayouts => 'Premium Layouts';

  @override
  String get premiumLayoutsDesc =>
      'Αποκλειστικοί τρόποι για να δείτε τις αναμνήσεις σας';

  @override
  String get calendarTools => 'Ημερολόγιο & Εργαλεία';

  @override
  String get fullCalendar => 'Πλήρες Ημερολόγιο';

  @override
  String get fullCalendarDesc => 'Ολοκληρωμένο σύστημα διαχείρισης εκδηλώσεων';

  @override
  String get clipboardAutoSaveDesc => 'Λήψη ιστορικού προχείρου φόντου';

  @override
  String get proWidgets => 'Επαγγελματικά Widgets';

  @override
  String get proWidgetsDesc =>
      'Όλες οι λειτουργίες είναι διαθέσιμες στην αρχική οθόνη σας';

  @override
  String get dataExport => 'Δεδομένα & Εξαγωγή';

  @override
  String get advancedBackup => 'Σύνθετη δημιουργία αντιγράφων ασφαλείας';

  @override
  String get advancedBackupDesc =>
      'Ασφαλής εισαγωγή/εξαγωγή όλων των δεδομένων';

  @override
  String get pdfExport => 'Εξαγωγή PDF';

  @override
  String get pdfExportDesc => 'Εξαγωγή σημειώσεων και περιοδικών σε PDF';

  @override
  String get printReady => 'Έτοιμο για εκτύπωση';

  @override
  String get printReadyDesc => 'Άμεση υποστήριξη εκτύπωσης';

  @override
  String get richTextEditor => 'Επεξεργαστής εμπλουτισμένου κειμένου';

  @override
  String get advancedSearch => 'Σύνθετη αναζήτηση';

  @override
  String get advancedSearchDesc => 'Αναζήτηση & Αντικατάσταση στο κείμενό σας';

  @override
  String get richMedia => 'Rich Media';

  @override
  String get richMediaDesc => 'Εισαγάγετε εικόνες, βίντεο και συνδέσμους';

  @override
  String get editorStyling => 'Editor Styling';

  @override
  String get editorStylingDesc =>
      'Προσαρμοσμένο υπόβαθρο κειμένου και επεξεργαστή';

  @override
  String get balance => 'Ισορροπία';

  @override
  String get loadingAd => 'Φόρτωση διαφήμισης...';

  @override
  String watchAd(Object amount) {
    return 'Παρακολούθηση διαφήμισης (+$amount)';
  }

  @override
  String get loadAd => 'Φόρτωση διαφήμισης';

  @override
  String get backupDataDesc => 'Αποθηκεύστε ένα αρχείο JSON των δεδομένων σας';

  @override
  String get importDataDesc =>
      'Συγχωνεύστε ένα αρχείο αντιγράφου ασφαλείας στο CopyClip';

  @override
  String get notificationPermissionDenied => 'Η άδεια ειδοποίησης απορρίφθηκε.';

  @override
  String get typeNewTask => 'Πληκτρολογήστε μια νέα εργασία...';

  @override
  String get addTask => 'Προσθέστε μια εργασία';

  @override
  String get completed => 'Ολοκληρώθηκε το';

  @override
  String get greatJob => 'Μεγάλη δουλειά!';

  @override
  String youEarnedXPNextTask(Object amount, Object date) {
    return 'Κερδίσατε $amount XP! Επόμενη εργασία: $date';
  }

  @override
  String taskCompletedXP(Object amount) {
    return 'Η εργασία ολοκληρώθηκε! +$amount XP';
  }

  @override
  String get moveTasksToRecycleBin =>
      'Μετακίνηση όλων των ενεργών εργασιών στον Κάδο Ανακύκλωσης;';

  @override
  String get deleteAllPosts => 'Διαγραφή όλων των αναρτήσεων';

  @override
  String get deleteAllPostsConfirmation =>
      'Είστε βέβαιοι ότι θέλετε να διαγράψετε ΟΛΕΣ τις αναρτήσεις στα κοινωνικά δίκτυα; Αυτό δεν μπορεί να αναιρεθεί.';

  @override
  String get allPosts => 'Όλες οι αναρτήσεις';

  @override
  String get favorites => 'Αγαπημένα';

  @override
  String get drafts => 'Προσχέδια';

  @override
  String get noFavoritesYet => 'Δεν υπάρχουν ακόμα αγαπημένα';

  @override
  String get noDraftsYet => 'Δεν υπάρχουν ακόμη προσχέδια';

  @override
  String get startSocialJourney => 'Ξεκινήστε το κοινωνικό σας ταξίδι!';

  @override
  String get draft => 'ΠΡΟΣΧΕΔΙΟ';

  @override
  String attachmentCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 's',
      one: '',
    );
    return '$count συνημμένο$_temp0';
  }

  @override
  String get pleaseAddContent =>
      'Προσθέστε κάποιο περιεχόμενο ή πολυμέσα για κοινή χρήση';

  @override
  String fileNotFoundError(Object path) {
    return 'Σφάλμα: Το αρχείο δεν βρέθηκε στο $path';
  }

  @override
  String get checkFacebookApp => 'Ελέγξτε την εφαρμογή Facebook';

  @override
  String get systemShare => 'Κοινή χρήση συστήματος';

  @override
  String get socialPost => 'Κοινωνική ανάρτηση';

  @override
  String get favorite => 'Ευνοούμενος';

  @override
  String get saveDraft => 'Αποθήκευση σχεδίου';

  @override
  String get entryCopied => 'Η καταχώρηση αντιγράφηκε';

  @override
  String get moveEntriesToRecycleBin =>
      'Μετακίνηση όλων των ενεργών καταχωρήσεων στον Κάδο Ανακύκλωσης;';

  @override
  String get startWritingStory => 'Ξεκινήστε να γράφετε την ιστορία σας';

  @override
  String get recordMemories =>
      'Καταγράψτε τις καθημερινές σας αναμνήσεις και συναισθήματα.';

  @override
  String get writeJournal => 'Γράψτε περιοδικό';

  @override
  String get myMemories => 'Οι αναμνήσεις μου';

  @override
  String get sortJournal => 'Ταξινόμηση περιοδικών';

  @override
  String get byMood => 'Με διάθεση';

  @override
  String get searchMemories => 'Αναζήτηση αναμνήσεων...';

  @override
  String get selectAll => 'Επιλέξτε Όλα';

  @override
  String get deleteSelected => 'Διαγραφή επιλεγμένων';

  @override
  String get taskCompletedExclamation => 'Η εργασία ολοκληρώθηκε!';

  @override
  String get taskUncompletedExclamation => 'Η εργασία δεν ολοκληρώθηκε';

  @override
  String get clipboardUpdatedExclamation => 'Το πρόχειρο ενημερώθηκε!';

  @override
  String clipboardSavedContent(Object content) {
    return 'Το πρόχειρο αποθηκεύτηκε: $content';
  }

  @override
  String get overview => 'Επισκόπηση';

  @override
  String get colorAurora => 'Αυγή';

  @override
  String get colorCosmic => 'Κοσμικός';

  @override
  String get colorNebula => 'Νεφέλωμα';

  @override
  String get colorStarlight => 'Αστροφεγγιά';

  @override
  String get colorSolar => 'Ηλιακός';

  @override
  String get colorNova => 'Νέος';

  @override
  String get loadingStepLoading => 'Φόρτωση...';

  @override
  String get loadingStepDatabase => 'Ρύθμιση βάσης δεδομένων...';

  @override
  String get loadingStepSystem => 'Διαμόρφωση συστήματος...';

  @override
  String get loadingStepReady => 'Ετοιμος';

  @override
  String get productivityCompanion => 'Ο σύντροφός σας στην παραγωγικότητα';

  @override
  String get done => 'Γινώμενος';

  @override
  String get newNote => 'Νέα Σημείωση';

  @override
  String get changeColor => 'Αλλαγή χρώματος';

  @override
  String get copyContent => 'Αντιγραφή περιεχομένου';

  @override
  String get titleOptional => 'Τίτλος (Προαιρετικό)';

  @override
  String get exportAsPdf => 'Εξαγωγή ως PDF';

  @override
  String get taskDueNow => 'Οφειλόμενη εργασία τώρα';

  @override
  String get moveTaskToBinTitle => 'Μετακίνηση Εργασίας στον Κάδο Ανακύκλωσης;';

  @override
  String get restoreTaskLater =>
      'Μπορείτε να επαναφέρετε αυτήν την εργασία αργότερα από τις ρυθμίσεις.';

  @override
  String get newTask => 'Νέα εργασία';

  @override
  String get editTask => 'Επεξεργασία εργασίας';

  @override
  String get undo => 'Ξεκάνω';

  @override
  String get redo => 'Ξανακάνω';

  @override
  String get category => 'Κατηγορία';

  @override
  String get categoryHint => 'π.χ. Εργασία, γυμναστήριο';

  @override
  String get whatNeedsToBeDone => 'Τι πρέπει να γίνει;';

  @override
  String get enterTaskDetails => 'Εισαγάγετε τα στοιχεία της εργασίας...';

  @override
  String get setDueDate => 'Ορισμός ημερομηνίας λήξης';

  @override
  String get dueDate => 'Δύο ραντεβού';

  @override
  String get expenseTitle => 'Εξοδα';

  @override
  String searchInCurrency(String currency) {
    return 'Αναζήτηση σε $currency...';
  }

  @override
  String get sortAndFilter => 'Ταξινόμηση & Φιλτράρισμα';

  @override
  String get sortBy => 'ΤΑΞΙΝΟΜΗΣΗ ΚΑΤΑ';

  @override
  String get highestAmount => 'Υψηλότερο Ποσό';

  @override
  String get lowestAmount => 'Χαμηλότερο ποσό';

  @override
  String get moreFilters => 'Περισσότερα φίλτρα...';

  @override
  String get filterExpenses => 'Φιλτράρισμα εξόδων';

  @override
  String get transactionType => 'Τύπος συναλλαγής';

  @override
  String get categories => 'Κατηγορίες';

  @override
  String get all => 'Ολοι';

  @override
  String get income => 'Εισόδημα';

  @override
  String get expense => 'Δαπάνη';

  @override
  String get reset => 'Επαναφορά';

  @override
  String get apply => 'Εφαρμόζω';

  @override
  String newExpense(String currency) {
    return 'Νέο $currency';
  }

  @override
  String errorLoadingData(String error) {
    return 'Σφάλμα κατά τη φόρτωση δεδομένων.\n\n$error';
  }

  @override
  String get dailyQuote1 =>
      'Ο καλύτερος τρόπος να προβλέψεις το μέλλον είναι να το δημιουργήσεις.';

  @override
  String get dailyQuote2 =>
      'Ο πλούτος δεν συνίσταται στο να έχεις μεγάλα υπάρχοντα, αλλά στο να έχεις λίγα θέλω.';

  @override
  String get dailyQuote3 => 'Ο χρόνος είναι το απόλυτο νόμισμα.';

  @override
  String get dailyQuote4 =>
      'Η επιτυχία δεν είναι οριστική, η αποτυχία δεν είναι μοιραία.';

  @override
  String get dailyQuote5 => 'Εστιάστε στη λύση, όχι στο πρόβλημα.';

  @override
  String get dailyQuote6 => 'Το δίκτυό σας είναι η καθαρή σας αξία.';

  @override
  String get moodHappy => 'Ευτυχισμένος';

  @override
  String get moodExcited => 'Ερεθισμένος';

  @override
  String get moodNeutral => 'Ουδέτερος';

  @override
  String get moodSad => 'Λυπημένος';

  @override
  String get moodStressed => 'Τονισμένα';

  @override
  String exportDate(String date) {
    return '📅 $date';
  }

  @override
  String exportMood(String emoji, String mood) {
    return 'Διάθεση: $emoji $mood';
  }

  @override
  String exportTitle(String title) {
    return 'ΤΙΤΛΟΣ: $title';
  }

  @override
  String exportTags(String tags) {
    return 'Ετικέτες: $tags';
  }

  @override
  String get instagram => 'Instagram';

  @override
  String get facebook => 'Facebook';

  @override
  String get tiktok => 'TikTok';

  @override
  String get newSketch => 'Νέο Σκίτσο';

  @override
  String get searchSketches => 'Αναζήτηση σκίτσων και φακέλων...';

  @override
  String get noResultsFound => 'Δεν βρέθηκαν αποτελέσματα';

  @override
  String get noItems => 'Δεν υπάρχουν στοιχεία';

  @override
  String get noDrawingsYet => 'Δεν υπάρχουν σχέδια ακόμα';

  @override
  String get canvasIntro => 'Απελευθερώστε τη δημιουργικότητά σας στον καμβά!';

  @override
  String get newCanvas => 'Νέος καμβάς';

  @override
  String get rename => 'Μετονομάζω';

  @override
  String get deleteFolder => 'Διαγραφή φακέλου';

  @override
  String get deleteSketchesQuestion => 'Διαγραφή σκίτσων;';

  @override
  String get deleteFolderConfirmation =>
      'Όλα τα σκίτσα σε αυτόν τον φάκελο θα διαγραφούν οριστικά.';

  @override
  String get renameFolder => 'Μετονομασία φακέλου';

  @override
  String get chooseColor => 'Επιλέξτε Χρώμα';

  @override
  String get deleteFolderQuestion => 'Διαγραφή φακέλου;';

  @override
  String get searchClips => 'Αναζήτηση κλιπ...';

  @override
  String get clipboardEmpty => 'Το πρόχειρο είναι κενό';

  @override
  String get addItem => 'Προσθήκη αντικειμένου';

  @override
  String get clipColor => 'Χρώμα κλιπ';

  @override
  String get newClip => 'Νέο Κλιπ';

  @override
  String get editClip => 'Επεξεργασία κλιπ';

  @override
  String get restoreClipLater =>
      'Μπορείτε να επαναφέρετε αυτό το κλιπ αργότερα.';

  @override
  String get upcomingEvents => 'Προσεχείς Εκδηλώσεις';

  @override
  String get dataDistribution => 'ΔΙΑΝΟΜΗ ΔΕΔΟΜΕΝΩΝ';

  @override
  String get taskProgress => 'ΠΡΟΟΔΟΣ ΕΡΓΟΥ';

  @override
  String get quickStats => 'ΓΡΗΓΟΡΑ ΣΤΑΤΙΣΤΙΚΑ';

  @override
  String get taskCompletion => 'Ολοκλήρωση Εργασίας';

  @override
  String get noItemsForDate => 'Δεν υπάρχουν στοιχεία για αυτήν την ημερομηνία';

  @override
  String get enjoyFreeTime => 'Απολαύστε τον ελεύθερο χρόνο σας!';

  @override
  String get searchThisDay => 'Ψάξτε σήμερα...';

  @override
  String get finance => 'Οικονομικά';

  @override
  String get permanentlyDelete => 'Οριστική διαγραφή;';

  @override
  String deleteSelectionConfirmation(int foldersCount, int sketchesCount) {
    return 'Αυτό θα διαγράψει οριστικά τους φακέλους $foldersCount (και τα σκίτσα τους) και τα άλλα σκίτσα $sketchesCount.\n\nΑυτό δεν μπορεί να αναιρεθεί.';
  }

  @override
  String get deleteForever => 'Διαγραφή για πάντα';

  @override
  String selectedCount(int count) {
    return '$count Επιλέχτηκε';
  }

  @override
  String canvasStats(int notes, int folders) {
    return '$notes σκίτσα • $folders φάκελοι';
  }

  @override
  String get sortItems => 'Ταξινόμηση αντικειμένων';

  @override
  String get sortNameAZ => 'Όνομα (A-Z)';

  @override
  String get sortNameZA => 'Όνομα (Z-A)';

  @override
  String get createFolder => 'Δημιουργία φακέλου';

  @override
  String get folderNameHint => 'Όνομα φακέλου...';

  @override
  String deleteSketchesConfirmation(int count) {
    return 'Διαγραφή $count σκίτσων; Αυτό δεν μπορεί να αναιρεθεί.';
  }

  @override
  String get noSketchesFound => 'Δεν βρέθηκαν σκίτσα';

  @override
  String get noSketchesFoundSub =>
      'Δοκιμάστε να προσαρμόσετε την αναζήτησή σας ή να δημιουργήσετε ένα νέο σκίτσο.';

  @override
  String searchInFolder(String folder) {
    return 'Αναζήτηση στο $folder...';
  }

  @override
  String sketchesCount(int count) {
    return '$count σκίτσα';
  }

  @override
  String get sortSketches => 'Ταξινόμηση σκίτσων';

  @override
  String get calendarScreenTitle => 'Ημερολόγιο';

  @override
  String get dailyActivity => 'Καθημερινή Δραστηριότητα';

  @override
  String get deleteItemQuestion => 'Διαγραφή στοιχείου;';

  @override
  String get deleteItemConfirmation =>
      'Αυτό θα μετακινήσει το αντικείμενο στον κάδο ανακύκλουσης.';

  @override
  String get moveToBinItem => 'Μετακίνηση στον κάδο;';

  @override
  String get moveToBinConfirmation => 'Μπορείτε να το επαναφέρετε αργότερα.';

  @override
  String selectedItems(int count) {
    return '$count Επιλέχτηκε';
  }

  @override
  String get recentClips => 'Πρόσφατα κλιπ';

  @override
  String get copied => 'Αντιγράφηκε!';

  @override
  String get copiedPlainText => 'Αντιγράφηκε απλό κείμενο';

  @override
  String get clipTheme => 'Θέμα κλιπ';

  @override
  String get justNow => 'Μόλις τώρα';

  @override
  String minutesAgo(Object count) {
    return 'πριν από $countλ';
  }

  @override
  String hoursAgo(Object count) {
    return '${count}h πριν';
  }

  @override
  String daysAgo(Object count) {
    return 'πριν από ${count}d';
  }

  @override
  String get noTasksFound => 'Δεν βρέθηκαν εργασίες.';

  @override
  String get searchTasks => 'Εργασίες αναζήτησης...';

  @override
  String get taskReminder => 'Υπενθύμιση εργασιών';

  @override
  String get untitledNote => 'Σημείωση χωρίς τίτλο';

  @override
  String get dailyEntry => 'Καθημερινή Είσοδος';

  @override
  String get clipboardHistory => 'Ιστορικό πρόχειρου';

  @override
  String get deletePermanentlyContent =>
      'Αυτή η ενέργεια δεν μπορεί να αναιρεθεί.';

  @override
  String get emptyRecycleBinTitle => 'Άδειος Κάδος Ανακύκλωσης;';

  @override
  String emptyRecycleBinContent(Object count) {
    return 'Όλα τα $count στοιχεία θα διαγραφούν οριστικά.';
  }

  @override
  String get emptyBin => 'Άδειος Κάδος';

  @override
  String get recycleBinEmpty => 'Ο Κάδος Ανακύκλωσης είναι άδειος';

  @override
  String get deletedItemsAppearHere =>
      'Τα διαγραμμένα στοιχεία θα εμφανιστούν εδώ.';

  @override
  String get empty => 'Αδειάζω';

  @override
  String get recent => 'Πρόσφατος';

  @override
  String categoryLabel(Object category) {
    return 'Κατηγορία: $category';
  }

  @override
  String get general => 'Γενικός';

  @override
  String get saveTransactionQuestion =>
      'Θέλετε να αποθηκεύσετε αυτήν τη συναλλαγή;';

  @override
  String get fillTitleAmount => 'Συμπληρώστε τον τίτλο και το ποσό';

  @override
  String get invalidAmount => 'Μη έγκυρη μορφή ποσού';

  @override
  String get moveTransactionToBinTitle =>
      'Μετακίνηση συναλλαγής στον Κάδο Ανακύκλωσης;';

  @override
  String get restoreTransactionLater =>
      'Μπορείτε να επαναφέρετε αυτήν τη συναλλαγή αργότερα από τις ρυθμίσεις.';

  @override
  String get newTransaction => 'Νέα συναλλαγή';

  @override
  String get whatIsThisFor => 'Σε τι χρησιμεύει αυτό;';

  @override
  String get description => 'Περιγραφή';

  @override
  String get daily => 'Καθημερινά';

  @override
  String get weekly => 'Εβδομαδιαίος';

  @override
  String get monthly => 'Μηνιαίος';

  @override
  String get yearly => 'Ετήσια';

  @override
  String get totalIncome => 'Συνολικό εισόδημα';

  @override
  String get totalExpense => 'Συνολικές δαπάνες';

  @override
  String get analysis => 'Ανάλυση';

  @override
  String get transactions => 'Συναλλαγές';

  @override
  String get noExpensesFound => 'Δεν βρέθηκαν έξοδα για αυτήν την περίοδο.';

  @override
  String get netBalance => 'Καθαρό Υπόλοιπο';

  @override
  String get topCategories => 'Κορυφαίες Κατηγορίες';

  @override
  String get spendingTrend => 'Τάση δαπανών';

  @override
  String get insights => 'Insights';

  @override
  String get noExpensesRecorded => 'Δεν καταγράφηκαν έξοδα';

  @override
  String get trackSpendingHabits =>
      'Παρακολουθήστε εύκολα τις συνήθειες δαπανών σας.';

  @override
  String get addExpense => 'Προσθήκη εξόδων';

  @override
  String get noDataForPeriod => 'Δεν υπάρχουν δεδομένα για αυτήν την περίοδο';

  @override
  String get budget => 'Προϋπολογισμός';

  @override
  String get spent => 'Ξοδεύτηκε';

  @override
  String get limit => 'Οριο';

  @override
  String get overBudget => 'Πάνω από τον προϋπολογισμό!';

  @override
  String remainingBudget(Object percent) {
    return 'Απομένει $percent%.';
  }

  @override
  String get savingsRate => 'Ποσοστό Αποταμίευσης';

  @override
  String get healthScore => 'Βαθμολογία υγείας';

  @override
  String get healthScoreExplanation =>
      'Αυτή η βαθμολογία βασίζεται στο ποσοστό αποταμίευσης.\n\n• > 50% αποθηκευμένο = Εξαιρετικό (100)\n• 0% αποθηκευμένο = Μέσος όρος (50)\n• Δαπάνες > Εισόδημα = Κακή (<50)';

  @override
  String get ok => 'ΕΝΤΑΞΕΙ';

  @override
  String get bulkImport => 'Bulk Import';
}
