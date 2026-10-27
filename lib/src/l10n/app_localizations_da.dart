// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Danish (`da`).
class AppLocalizationsDa extends AppLocalizations {
  AppLocalizationsDa([String locale = 'da']) : super(locale);

  @override
  String get settings => 'Indstillinger';

  @override
  String get language => 'Sprog';

  @override
  String get systemDefault => 'Systemstandard';

  @override
  String get notes => 'Noter';

  @override
  String get todos => 'To-Dos';

  @override
  String get journal => 'Tidsskrift';

  @override
  String get clipboard => 'Udklipsholder';

  @override
  String get save => 'Spare';

  @override
  String get create => 'Skabe';

  @override
  String get cancel => 'Ophæve';

  @override
  String get delete => 'Slet';

  @override
  String get edit => 'Redigere';

  @override
  String get share => 'Dele';

  @override
  String get copy => 'Kopi';

  @override
  String get unsavedChanges => 'Ikke-gemte ændringer';

  @override
  String get confirmDelete => 'Bekræft sletning';

  @override
  String get discard => 'Kassér';

  @override
  String get camera => 'Kamera';

  @override
  String get gallery => 'Galleri';

  @override
  String get search => 'Søge';

  @override
  String get pleaseEnterTask => 'Indtast venligst en opgave';

  @override
  String get deleteTask => 'Slet opgave';

  @override
  String get selectItems => 'Vælg elementer';

  @override
  String get deleteAll => 'Slet alle';

  @override
  String error(Object error) {
    return 'Fejl: $error';
  }

  @override
  String get premiumFeatures => 'Premium funktioner';

  @override
  String get manageCoinsAdsPremium =>
      'Administrer mønter, annoncer og premium-status';

  @override
  String get themeMode => 'Tematilstand';

  @override
  String get accentColor => 'Accent farve';

  @override
  String get backgroundDesign => 'Baggrundsdesign';

  @override
  String get pushNotifications => 'Push-meddelelser';

  @override
  String get recycleBin => 'Papirkurv';

  @override
  String get exportData => 'Eksporter data';

  @override
  String get importData => 'Importer data';

  @override
  String get rateApp => 'Bedøm app';

  @override
  String get sendFeedback => 'Send feedback';

  @override
  String get privacyPolicy => 'Privatlivspolitik';

  @override
  String get version => 'Version';

  @override
  String get buildNumber => 'Byg nummer';

  @override
  String get system => 'System';

  @override
  String get light => 'Lys';

  @override
  String get dark => 'Mørk';

  @override
  String get itemRestored => 'Varen er gendannet';

  @override
  String get recycleBinCleared => 'Papirkurven blev ryddet';

  @override
  String get unlockPermanently => 'Lås op permanent';

  @override
  String get notEnoughCoins => 'Ikke nok mønter!';

  @override
  String youEarnedCoins(Object amount) {
    return 'Du har tjent $amount mønter!';
  }

  @override
  String get contentCopied => 'Indhold kopieret';

  @override
  String get selectDateTime => 'Vælg dato og tid';

  @override
  String get watchAdToEarnCoins => 'Se annonce for at tjene mønter';

  @override
  String get premiumUnlocked => 'Premium ulåst';

  @override
  String get removeAds => 'Fjern annoncer';

  @override
  String get unlimitedCloudStorage => 'Ubegrænset Cloud Storage';

  @override
  String get deleteNote => 'Slet note';

  @override
  String get shareNote => 'Del note';

  @override
  String get editNote => 'Rediger note';

  @override
  String get searchNotes => 'Søg i noter...';

  @override
  String get noNotesFound => 'Ingen noter fundet';

  @override
  String get captureThoughts => 'Fang dine tanker med det samme.';

  @override
  String get createNote => 'Opret note';

  @override
  String get customOrder => 'Brugerdefineret rækkefølge';

  @override
  String get newestFirst => 'Nyeste først';

  @override
  String get oldestFirst => 'Ældste først';

  @override
  String get titleAZ => 'Titel: A-Z';

  @override
  String get titleZA => 'Titel: Z-A';

  @override
  String get deleteAllQuestion => 'Vil du slette alle?';

  @override
  String get moveToRecycleBin => 'Flytte alle sedler til papirkurven?';

  @override
  String get moveToBinQuestion => 'Flytte til bin?';

  @override
  String get restoreNoteLater => 'Du kan gendanne denne note senere.';

  @override
  String get move => 'Flytte';

  @override
  String get myThoughts => 'Mine tanker';

  @override
  String get selected => 'Valgt';

  @override
  String get noContent => 'Intet indhold';

  @override
  String get untitled => 'Uden titel';

  @override
  String get chooseWallpapers => 'Vælg mellem 10+ dynamiske tapeter';

  @override
  String get backupData => 'Sikkerhedskopier data';

  @override
  String get saveJsonFile =>
      'Vil du gemme en JSON-fil, der indeholder alle dine data?';

  @override
  String get exportNow => 'Eksporter nu';

  @override
  String get importDataTitle => 'Importer data';

  @override
  String get mergeBackupFile =>
      'Vil du flette en sikkerhedskopifil med dine nuværende elementer?';

  @override
  String get selectFile => 'Vælg Fil';

  @override
  String get backupSaved => 'Sikkerhedskopien blev gemt!';

  @override
  String get exportFailed => 'Eksport mislykkedes.';

  @override
  String importSuccess(Object count) {
    return '$count elementer blev gendannet!';
  }

  @override
  String get importFailed => 'Import mislykkedes.';

  @override
  String widgetAdded(String widget) {
    return 'Widget tilføjet til startskærmen!';
  }

  @override
  String get widgetRequestSent =>
      'Widgetanmodning sendt. Tjek venligst din startskærm.';

  @override
  String get widgetAddFailed => 'Kunne ikke tilføje widget';

  @override
  String get autoSaveEnabled => 'Automatisk lagring aktiveret.';

  @override
  String get autoSaveDisabled => 'Automatisk lagring er deaktiveret.';

  @override
  String get homeScreenWidgets => 'Home Screen Widgets';

  @override
  String get notificationsTitle => 'Meddelelser';

  @override
  String get dataBackup => 'Data & Backup';

  @override
  String get feedbackSupport => 'Feedback og support';

  @override
  String get creditsTitle => 'Kreditter';

  @override
  String get privacyMaintenance => 'Privatliv og vedligeholdelse';

  @override
  String get aboutTitle => 'Om';

  @override
  String get premium => 'Præmie';

  @override
  String get appearanceTitle => 'Udseende';

  @override
  String get clipboardTitle => 'Udklipsholder';

  @override
  String get settingsSubtitle => 'Tilpas din oplevelse';

  @override
  String get welcomeTitle => 'Velkommen til CopyClip';

  @override
  String get welcomeDescription =>
      'Din ultimative produktivitetsledsager. Lad os sætte dig op med kraftfulde værktøjer til at styre din dag.';

  @override
  String get onboardingNotesTitle => 'Smarte noter';

  @override
  String get onboardingNotesDesc =>
      'Fang ideer med det samme med RTF-formatering. Organiser dine tanker og mist aldrig en god idé igen.';

  @override
  String get onboardingTodosTitle => 'Opgavestyring';

  @override
  String get onboardingTodosDesc =>
      'Hold dig på toppen af ​​dit spil. Opret to-do-lister, sæt prioriteter og knus dine mål et flueben ad gangen.';

  @override
  String get onboardingJournalTitle => 'Personlig Journal';

  @override
  String get onboardingJournalDesc =>
      'Reflekter over din dag. Et privat rum til at skrive dine minder, følelser og daglige oplevelser ned.';

  @override
  String get onboardingClipboardTitle => 'Udklipsholder';

  @override
  String get onboardingClipboardDesc =>
      'Kopiér én gang, indsæt hvor som helst. Få adgang til din udklipsholderhistorik for at hente uddrag, du har kopieret tidligere.';

  @override
  String get featuresNotesDesc => 'Opret og administrer dine noter';

  @override
  String get featuresTodosDesc => 'Hold styr på dine opgaver';

  @override
  String get featuresJournalDesc => 'Skriv dine tanker ned';

  @override
  String get featuresClipboardDesc => 'Få adgang til din udklipsholderhistorik';

  @override
  String get chooseYourAura => 'Vælg din aura';

  @override
  String get expressYourselfTheme => 'Udtryk dig selv med en ny temafarve!';

  @override
  String get autoSaveClipboard => 'Gem automatisk udklipsholder';

  @override
  String get autoSaveClipboardDesc => 'Gem automatisk kopierede elementer';

  @override
  String get permissionDeniedSettings =>
      'Tilladelse nægtet permanent. Aktiver venligst i Indstillinger.';

  @override
  String get notificationsEnabled => 'Notifikationer aktiveret!';

  @override
  String get redirectingToSettings =>
      'Omdirigerer til indstillinger for at deaktivere meddelelser...';

  @override
  String get premiumAccess => 'Premium adgang';

  @override
  String get premiumActiveUntil => 'Premium Aktiv indtil';

  @override
  String get unlockAllFeatures => 'Lås op for alle funktioner';

  @override
  String get buyPremium => 'Køb Premium (7 dage)';

  @override
  String costCoins(Object cost) {
    return 'Pris: $cost mønter';
  }

  @override
  String get premiumActivated => 'Premium aktiveret i 7 dage!';

  @override
  String get premiumActive => 'Premium Active';

  @override
  String get expires => 'Udløber:';

  @override
  String get temporaryAccess => 'Midlertidig adgang';

  @override
  String get journalExpression => 'Journal & Udtryk';

  @override
  String get artisticDesigns => 'Kunstneriske Designs';

  @override
  String get artisticDesignsDesc => 'Lås op for 10+ unikke journalkorttemaer';

  @override
  String get premiumLayouts => 'Premium layouts';

  @override
  String get premiumLayoutsDesc => 'Eksklusive måder at se dine minder på';

  @override
  String get clipboardAutoSaveDesc =>
      'Optagelse af historik i baggrunden udklipsholder';

  @override
  String get proWidgets => 'Pro widgets';

  @override
  String get proWidgetsDesc => 'Alle funktioner tilgængelige på din startskærm';

  @override
  String get dataExport => 'Data og eksport';

  @override
  String get advancedBackup => 'Avanceret sikkerhedskopiering';

  @override
  String get advancedBackupDesc => 'Sikker import/eksport af alle data';

  @override
  String get pdfExport => 'PDF eksport';

  @override
  String get pdfExportDesc => 'Eksporter noter og journaler til PDF';

  @override
  String get printReady => 'Print klar';

  @override
  String get printReadyDesc => 'Direkte udskrivningsstøtte';

  @override
  String get richTextEditor => 'Rich Text Editor';

  @override
  String get advancedSearch => 'Avanceret søgning';

  @override
  String get advancedSearchDesc => 'Søg og erstat i din tekst';

  @override
  String get richMedia => 'Rich Media';

  @override
  String get richMediaDesc => 'Indsæt billeder, videoer og links';

  @override
  String get editorStyling => 'Editor Styling';

  @override
  String get editorStylingDesc => 'Brugerdefineret tekst og editor baggrunde';

  @override
  String get balance => 'Balance';

  @override
  String get loadingAd => 'Indlæser annonce...';

  @override
  String watchAd(Object amount) {
    return 'Se annonce (+$amount)';
  }

  @override
  String get loadAd => 'Indlæs annonce';

  @override
  String get backupDataDesc => 'Gem en JSON-fil med dine data';

  @override
  String get importDataDesc => 'Flet en sikkerhedskopifil ind i CopyClip';

  @override
  String get notificationPermissionDenied => 'Notifikationstilladelse nægtet.';

  @override
  String get typeNewTask => 'Indtast en ny opgave...';

  @override
  String get addTask => 'Tilføj en opgave';

  @override
  String get completed => 'Afsluttet';

  @override
  String get moveTasksToRecycleBin =>
      'Flytte alle aktive opgaver til papirkurven?';

  @override
  String fileNotFoundError(Object path) {
    return 'Fejl: Filen blev ikke fundet på $path';
  }

  @override
  String get entryCopied => 'Indlæg kopieret';

  @override
  String get moveEntriesToRecycleBin =>
      'Flytte alle aktive poster til papirkurven?';

  @override
  String get startWritingStory => 'Begynd at skrive din historie';

  @override
  String get recordMemories => 'Optag dine daglige minder og følelser.';

  @override
  String get writeJournal => 'Skriv Journal';

  @override
  String get myMemories => 'Mine minder';

  @override
  String get sortJournal => 'Sorter Journal';

  @override
  String get byMood => 'Efter humør';

  @override
  String get searchMemories => 'Søg efter minder...';

  @override
  String get selectAll => 'Vælg alle';

  @override
  String get deleteSelected => 'Slet valgte';

  @override
  String get taskCompletedExclamation => 'Opgave afsluttet!';

  @override
  String get taskUncompletedExclamation => 'Opgaven er ikke fuldført';

  @override
  String get clipboardUpdatedExclamation => 'Udklipsholder opdateret!';

  @override
  String clipboardSavedContent(Object content) {
    return 'Udklipsholder gemt: $content';
  }

  @override
  String get overview => 'Oversigt';

  @override
  String get colorAurora => 'Aurora';

  @override
  String get colorCosmic => 'Kosmisk';

  @override
  String get colorNebula => 'Tåge';

  @override
  String get colorStarlight => 'Stjernelys';

  @override
  String get colorSolar => 'Solar';

  @override
  String get colorNova => 'Ny';

  @override
  String get loadingStepLoading => 'Indlæser...';

  @override
  String get loadingStepDatabase => 'Opsætter database...';

  @override
  String get loadingStepSystem => 'Konfigurerer system...';

  @override
  String get loadingStepReady => 'Parat';

  @override
  String get productivityCompanion => 'Din produktivitetsledsager';

  @override
  String get done => 'Færdig';

  @override
  String get newNote => 'Ny note';

  @override
  String get changeColor => 'Skift farve';

  @override
  String get copyContent => 'Kopier indhold';

  @override
  String get titleOptional => 'Titel (valgfrit)';

  @override
  String get exportAsPdf => 'Eksporter som PDF';

  @override
  String get taskDueNow => 'Opgave klar nu';

  @override
  String get moveTaskToBinTitle => 'Flytte opgave til papirkurven?';

  @override
  String get restoreTaskLater =>
      'Du kan gendanne denne opgave senere fra indstillingerne.';

  @override
  String get newTask => 'Ny opgave';

  @override
  String get editTask => 'Rediger opgave';

  @override
  String get undo => 'Fortryd';

  @override
  String get redo => 'Gentag';

  @override
  String get category => 'Kategori';

  @override
  String get categoryHint => 'f.eks. Arbejde, Gym';

  @override
  String get whatNeedsToBeDone => 'Hvad skal der gøres?';

  @override
  String get enterTaskDetails => 'Indtast opgavedetaljer...';

  @override
  String get setDueDate => 'Indstil forfaldsdato';

  @override
  String get dueDate => 'To datoer';

  @override
  String get sortAndFilter => 'Sorter og filtrer';

  @override
  String get sortBy => 'SORTERT EFTER';

  @override
  String get categories => 'Kategorier';

  @override
  String get all => 'Alle';

  @override
  String get reset => 'Nulstil';

  @override
  String get apply => 'Anvende';

  @override
  String errorLoadingData(String error) {
    return 'Fejl ved indlæsning af data.\n\n$error';
  }

  @override
  String get dailyQuote1 =>
      'Den bedste måde at forudsige fremtiden er at skabe den.';

  @override
  String get dailyQuote2 =>
      'Rigdom består ikke i at have store ejendele, men i at have få ønsker.';

  @override
  String get dailyQuote3 => 'Tid er den ultimative valuta.';

  @override
  String get dailyQuote4 => 'Succes er ikke endelig, fiasko er ikke fatal.';

  @override
  String get dailyQuote5 => 'Fokuser på løsningen, ikke problemet.';

  @override
  String get dailyQuote6 => 'Dit netværk er din nettoværdi.';

  @override
  String get moodHappy => 'Lykkelig';

  @override
  String get moodExcited => 'Ophidset';

  @override
  String get moodNeutral => 'Neutral';

  @override
  String get moodSad => 'Sørgelig';

  @override
  String get moodStressed => 'Stresset';

  @override
  String exportDate(String date) {
    return '📅 $date';
  }

  @override
  String exportMood(String emoji, String mood) {
    return 'Stemning: $emoji $mood';
  }

  @override
  String exportTitle(String title) {
    return 'TITEL: $title';
  }

  @override
  String exportTags(String tags) {
    return 'Tags: $tags';
  }

  @override
  String get noResultsFound => 'Ingen resultater fundet';

  @override
  String get noItems => 'Ingen varer';

  @override
  String get rename => 'Omdøb';

  @override
  String get deleteFolder => 'Slet mappe';

  @override
  String get deleteSketchesQuestion => 'Vil du slette skitser?';

  @override
  String get deleteFolderConfirmation =>
      'Alle skitser i denne mappe vil blive slettet permanent.';

  @override
  String get chooseColor => 'Vælg Farve';

  @override
  String get searchClips => 'Søg efter klip...';

  @override
  String get clipboardEmpty => 'Udklipsholderen er tom';

  @override
  String get addItem => 'Tilføj vare';

  @override
  String get clipColor => 'Klip farve';

  @override
  String get newClip => 'Nyt klip';

  @override
  String get editClip => 'Rediger klip';

  @override
  String get restoreClipLater => 'Du kan gendanne dette klip senere.';

  @override
  String get dataDistribution => 'DATADISTRIBUTION';

  @override
  String get taskProgress => 'OPGAVEFREMSKRIDT';

  @override
  String get quickStats => 'HURTIG STATISTIK';

  @override
  String get taskCompletion => 'Opgaveafslutning';

  @override
  String get noItemsForDate => 'Ingen varer for denne dato';

  @override
  String get enjoyFreeTime => 'Nyd din fritid!';

  @override
  String get searchThisDay => 'Søg i denne dag...';

  @override
  String get finance => 'Finansiere';

  @override
  String get permanentlyDelete => 'Slet permanent?';

  @override
  String deleteSelectionConfirmation(int foldersCount, int sketchesCount) {
    return 'Dette vil permanent slette $foldersCount mapper (og deres skitser) og $sketchesCount andre skitser.\n\nDette kan ikke fortrydes.';
  }

  @override
  String get deleteForever => 'Slet for evigt';

  @override
  String selectedCount(int count) {
    return '$count valgt';
  }

  @override
  String get deleteItemQuestion => 'Slet element?';

  @override
  String get deleteItemConfirmation =>
      'Dette vil flytte varen til papirkurven.';

  @override
  String get moveToBinItem => 'Flytte til bin?';

  @override
  String get moveToBinConfirmation => 'Du kan gendanne den senere.';

  @override
  String selectedItems(int count) {
    return '$count valgt';
  }

  @override
  String get recentClips => 'Seneste klip';

  @override
  String get copied => 'Kopieret!';

  @override
  String get copiedPlainText => 'Kopieret almindelig tekst';

  @override
  String get clipTheme => 'Klip tema';

  @override
  String get justNow => 'Lige nu';

  @override
  String minutesAgo(Object count) {
    return 'for $count m siden';
  }

  @override
  String hoursAgo(Object count) {
    return 'for $count t siden';
  }

  @override
  String daysAgo(Object count) {
    return 'for ${count}d siden';
  }

  @override
  String get noTasksFound => 'Ingen opgaver fundet.';

  @override
  String get searchTasks => 'Søg opgaver...';

  @override
  String get taskReminder => 'Opgavepåmindelse';

  @override
  String get untitledNote => 'Unavngivet note';

  @override
  String get dailyEntry => 'Daglig indgang';

  @override
  String get clipboardHistory => 'Udklipsholder historie';

  @override
  String get deletePermanentlyContent => 'Denne handling kan ikke fortrydes.';

  @override
  String get emptyRecycleBinTitle => 'Tøm papirkurven?';

  @override
  String emptyRecycleBinContent(Object count) {
    return 'Alle $count elementer vil blive slettet permanent.';
  }

  @override
  String get emptyBin => 'Tøm beholder';

  @override
  String get recycleBinEmpty => 'Papirkurven er tom';

  @override
  String get deletedItemsAppearHere => 'Slettede elementer vises her.';

  @override
  String get empty => 'Tom';

  @override
  String get recent => 'Nylig';

  @override
  String categoryLabel(Object category) {
    return 'Kategori: $category';
  }

  @override
  String get general => 'Generel';

  @override
  String get description => 'Beskrivelse';

  @override
  String get daily => 'Daglig';

  @override
  String get weekly => 'Ugentlig';

  @override
  String get monthly => 'Månedlig';

  @override
  String get yearly => 'Årligt';

  @override
  String get analysis => 'Analyse';

  @override
  String get transactions => 'Transaktioner';

  @override
  String get ok => 'OK';

  @override
  String get bulkImport => 'Bulk Import';
}

/// The translations for Danish, as used in Denmark (`da_DK`).
class AppLocalizationsDaDk extends AppLocalizationsDa {
  AppLocalizationsDaDk() : super('da_DK');

  @override
  String get settings => 'Indstillinger';

  @override
  String get language => 'Sprog';

  @override
  String get systemDefault => 'Systemstandard';

  @override
  String get notes => 'Noter';

  @override
  String get todos => 'To-Dos';

  @override
  String get journal => 'Tidsskrift';

  @override
  String get clipboard => 'Udklipsholder';

  @override
  String get save => 'Spare';

  @override
  String get create => 'Skabe';

  @override
  String get cancel => 'Ophæve';

  @override
  String get delete => 'Slet';

  @override
  String get edit => 'Redigere';

  @override
  String get share => 'Dele';

  @override
  String get copy => 'Kopi';

  @override
  String get unsavedChanges => 'Ikke-gemte ændringer';

  @override
  String get confirmDelete => 'Bekræft sletning';

  @override
  String get discard => 'Kassér';

  @override
  String get camera => 'Kamera';

  @override
  String get gallery => 'Galleri';

  @override
  String get search => 'Søge';

  @override
  String get pleaseEnterTask => 'Indtast venligst en opgave';

  @override
  String get deleteTask => 'Slet opgave';

  @override
  String get selectItems => 'Vælg elementer';

  @override
  String get deleteAll => 'Slet alle';

  @override
  String error(Object error) {
    return 'Fejl: $error';
  }

  @override
  String get premiumFeatures => 'Premium funktioner';

  @override
  String get manageCoinsAdsPremium =>
      'Administrer mønter, annoncer og premium-status';

  @override
  String get themeMode => 'Tematilstand';

  @override
  String get accentColor => 'Accent farve';

  @override
  String get backgroundDesign => 'Baggrundsdesign';

  @override
  String get pushNotifications => 'Push-meddelelser';

  @override
  String get recycleBin => 'Papirkurv';

  @override
  String get exportData => 'Eksporter data';

  @override
  String get importData => 'Importer data';

  @override
  String get rateApp => 'Bedøm app';

  @override
  String get sendFeedback => 'Send feedback';

  @override
  String get privacyPolicy => 'Privatlivspolitik';

  @override
  String get version => 'Version';

  @override
  String get buildNumber => 'Byg nummer';

  @override
  String get system => 'System';

  @override
  String get light => 'Lys';

  @override
  String get dark => 'Mørk';

  @override
  String get itemRestored => 'Varen er gendannet';

  @override
  String get recycleBinCleared => 'Papirkurven blev ryddet';

  @override
  String get unlockPermanently => 'Lås op permanent';

  @override
  String get notEnoughCoins => 'Ikke nok mønter!';

  @override
  String youEarnedCoins(Object amount) {
    return 'Du har tjent $amount mønter!';
  }

  @override
  String get contentCopied => 'Indhold kopieret';

  @override
  String get selectDateTime => 'Vælg dato og tid';

  @override
  String get watchAdToEarnCoins => 'Se annonce for at tjene mønter';

  @override
  String get premiumUnlocked => 'Premium ulåst';

  @override
  String get removeAds => 'Fjern annoncer';

  @override
  String get unlimitedCloudStorage => 'Ubegrænset Cloud Storage';

  @override
  String get deleteNote => 'Slet note';

  @override
  String get shareNote => 'Del note';

  @override
  String get editNote => 'Rediger note';

  @override
  String get searchNotes => 'Søg i noter...';

  @override
  String get noNotesFound => 'Ingen noter fundet';

  @override
  String get captureThoughts => 'Fang dine tanker med det samme.';

  @override
  String get createNote => 'Opret note';

  @override
  String get customOrder => 'Brugerdefineret rækkefølge';

  @override
  String get newestFirst => 'Nyeste først';

  @override
  String get oldestFirst => 'Ældste først';

  @override
  String get titleAZ => 'Titel: A-Z';

  @override
  String get titleZA => 'Titel: Z-A';

  @override
  String get deleteAllQuestion => 'Vil du slette alle?';

  @override
  String get moveToRecycleBin => 'Flytte alle sedler til papirkurven?';

  @override
  String get moveToBinQuestion => 'Flytte til bin?';

  @override
  String get restoreNoteLater => 'Du kan gendanne denne note senere.';

  @override
  String get move => 'Flytte';

  @override
  String get myThoughts => 'Mine tanker';

  @override
  String get selected => 'Valgt';

  @override
  String get noContent => 'Intet indhold';

  @override
  String get untitled => 'Uden titel';

  @override
  String get chooseWallpapers => 'Vælg mellem 10+ dynamiske tapeter';

  @override
  String get backupData => 'Sikkerhedskopier data';

  @override
  String get saveJsonFile =>
      'Vil du gemme en JSON-fil, der indeholder alle dine data?';

  @override
  String get exportNow => 'Eksporter nu';

  @override
  String get importDataTitle => 'Importer data';

  @override
  String get mergeBackupFile =>
      'Vil du flette en sikkerhedskopifil med dine nuværende elementer?';

  @override
  String get selectFile => 'Vælg Fil';

  @override
  String get backupSaved => 'Sikkerhedskopien blev gemt!';

  @override
  String get exportFailed => 'Eksport mislykkedes.';

  @override
  String importSuccess(Object count) {
    return '$count elementer blev gendannet!';
  }

  @override
  String get importFailed => 'Import mislykkedes.';

  @override
  String widgetAdded(String widget) {
    return 'Widget tilføjet til startskærmen!';
  }

  @override
  String get widgetRequestSent =>
      'Widgetanmodning sendt. Tjek venligst din startskærm.';

  @override
  String get widgetAddFailed => 'Kunne ikke tilføje widget';

  @override
  String get autoSaveEnabled => 'Automatisk lagring aktiveret.';

  @override
  String get autoSaveDisabled => 'Automatisk lagring er deaktiveret.';

  @override
  String get homeScreenWidgets => 'Home Screen Widgets';

  @override
  String get notificationsTitle => 'Meddelelser';

  @override
  String get dataBackup => 'Data & Backup';

  @override
  String get feedbackSupport => 'Feedback og support';

  @override
  String get creditsTitle => 'Kreditter';

  @override
  String get privacyMaintenance => 'Privatliv og vedligeholdelse';

  @override
  String get aboutTitle => 'Om';

  @override
  String get premium => 'Præmie';

  @override
  String get appearanceTitle => 'Udseende';

  @override
  String get clipboardTitle => 'Udklipsholder';

  @override
  String get settingsSubtitle => 'Tilpas din oplevelse';

  @override
  String get welcomeTitle => 'Velkommen til CopyClip';

  @override
  String get welcomeDescription =>
      'Din ultimative produktivitetsledsager. Lad os sætte dig op med kraftfulde værktøjer til at styre din dag.';

  @override
  String get onboardingNotesTitle => 'Smarte noter';

  @override
  String get onboardingNotesDesc =>
      'Fang ideer med det samme med RTF-formatering. Organiser dine tanker og mist aldrig en god idé igen.';

  @override
  String get onboardingTodosTitle => 'Opgavestyring';

  @override
  String get onboardingTodosDesc =>
      'Hold dig på toppen af ​​dit spil. Opret to-do-lister, sæt prioriteter og knus dine mål et flueben ad gangen.';

  @override
  String get onboardingJournalTitle => 'Personlig Journal';

  @override
  String get onboardingJournalDesc =>
      'Reflekter over din dag. Et privat rum til at skrive dine minder, følelser og daglige oplevelser ned.';

  @override
  String get onboardingClipboardTitle => 'Udklipsholder';

  @override
  String get onboardingClipboardDesc =>
      'Kopiér én gang, indsæt hvor som helst. Få adgang til din udklipsholderhistorik for at hente uddrag, du har kopieret tidligere.';

  @override
  String get featuresNotesDesc => 'Opret og administrer dine noter';

  @override
  String get featuresTodosDesc => 'Hold styr på dine opgaver';

  @override
  String get featuresJournalDesc => 'Skriv dine tanker ned';

  @override
  String get featuresClipboardDesc => 'Få adgang til din udklipsholderhistorik';

  @override
  String get chooseYourAura => 'Vælg din aura';

  @override
  String get expressYourselfTheme => 'Udtryk dig selv med en ny temafarve!';

  @override
  String get autoSaveClipboard => 'Gem automatisk udklipsholder';

  @override
  String get autoSaveClipboardDesc => 'Gem automatisk kopierede elementer';

  @override
  String get permissionDeniedSettings =>
      'Tilladelse nægtet permanent. Aktiver venligst i Indstillinger.';

  @override
  String get notificationsEnabled => 'Notifikationer aktiveret!';

  @override
  String get redirectingToSettings =>
      'Omdirigerer til indstillinger for at deaktivere meddelelser...';

  @override
  String get premiumAccess => 'Premium adgang';

  @override
  String get premiumActiveUntil => 'Premium Aktiv indtil';

  @override
  String get unlockAllFeatures => 'Lås op for alle funktioner';

  @override
  String get buyPremium => 'Køb Premium (7 dage)';

  @override
  String costCoins(Object cost) {
    return 'Pris: $cost mønter';
  }

  @override
  String get premiumActivated => 'Premium aktiveret i 7 dage!';

  @override
  String get premiumActive => 'Premium Active';

  @override
  String get expires => 'Udløber:';

  @override
  String get temporaryAccess => 'Midlertidig adgang';

  @override
  String get journalExpression => 'Journal & Udtryk';

  @override
  String get artisticDesigns => 'Kunstneriske Designs';

  @override
  String get artisticDesignsDesc => 'Lås op for 10+ unikke journalkorttemaer';

  @override
  String get premiumLayouts => 'Premium layouts';

  @override
  String get premiumLayoutsDesc => 'Eksklusive måder at se dine minder på';

  @override
  String get clipboardAutoSaveDesc =>
      'Optagelse af historik i baggrunden udklipsholder';

  @override
  String get proWidgets => 'Pro widgets';

  @override
  String get proWidgetsDesc => 'Alle funktioner tilgængelige på din startskærm';

  @override
  String get dataExport => 'Data og eksport';

  @override
  String get advancedBackup => 'Avanceret sikkerhedskopiering';

  @override
  String get advancedBackupDesc => 'Sikker import/eksport af alle data';

  @override
  String get pdfExport => 'PDF eksport';

  @override
  String get pdfExportDesc => 'Eksporter noter og journaler til PDF';

  @override
  String get printReady => 'Print klar';

  @override
  String get printReadyDesc => 'Direkte udskrivningsstøtte';

  @override
  String get richTextEditor => 'Rich Text Editor';

  @override
  String get advancedSearch => 'Avanceret søgning';

  @override
  String get advancedSearchDesc => 'Søg og erstat i din tekst';

  @override
  String get richMedia => 'Rich Media';

  @override
  String get richMediaDesc => 'Indsæt billeder, videoer og links';

  @override
  String get editorStyling => 'Editor Styling';

  @override
  String get editorStylingDesc => 'Brugerdefineret tekst og editor baggrunde';

  @override
  String get balance => 'Balance';

  @override
  String get loadingAd => 'Indlæser annonce...';

  @override
  String watchAd(Object amount) {
    return 'Se annonce (+$amount)';
  }

  @override
  String get loadAd => 'Indlæs annonce';

  @override
  String get backupDataDesc => 'Gem en JSON-fil med dine data';

  @override
  String get importDataDesc => 'Flet en sikkerhedskopifil ind i CopyClip';

  @override
  String get notificationPermissionDenied => 'Notifikationstilladelse nægtet.';

  @override
  String get typeNewTask => 'Indtast en ny opgave...';

  @override
  String get addTask => 'Tilføj en opgave';

  @override
  String get completed => 'Afsluttet';

  @override
  String get moveTasksToRecycleBin =>
      'Flytte alle aktive opgaver til papirkurven?';

  @override
  String fileNotFoundError(Object path) {
    return 'Fejl: Filen blev ikke fundet på $path';
  }

  @override
  String get entryCopied => 'Indlæg kopieret';

  @override
  String get moveEntriesToRecycleBin =>
      'Flytte alle aktive poster til papirkurven?';

  @override
  String get startWritingStory => 'Begynd at skrive din historie';

  @override
  String get recordMemories => 'Optag dine daglige minder og følelser.';

  @override
  String get writeJournal => 'Skriv Journal';

  @override
  String get myMemories => 'Mine minder';

  @override
  String get sortJournal => 'Sorter Journal';

  @override
  String get byMood => 'Efter humør';

  @override
  String get searchMemories => 'Søg efter minder...';

  @override
  String get selectAll => 'Vælg alle';

  @override
  String get deleteSelected => 'Slet valgte';

  @override
  String get taskCompletedExclamation => 'Opgave afsluttet!';

  @override
  String get taskUncompletedExclamation => 'Opgaven er ikke fuldført';

  @override
  String get clipboardUpdatedExclamation => 'Udklipsholder opdateret!';

  @override
  String clipboardSavedContent(Object content) {
    return 'Udklipsholder gemt: $content';
  }

  @override
  String get overview => 'Oversigt';

  @override
  String get colorAurora => 'Aurora';

  @override
  String get colorCosmic => 'Kosmisk';

  @override
  String get colorNebula => 'Tåge';

  @override
  String get colorStarlight => 'Stjernelys';

  @override
  String get colorSolar => 'Solar';

  @override
  String get colorNova => 'Ny';

  @override
  String get loadingStepLoading => 'Indlæser...';

  @override
  String get loadingStepDatabase => 'Opsætter database...';

  @override
  String get loadingStepSystem => 'Konfigurerer system...';

  @override
  String get loadingStepReady => 'Parat';

  @override
  String get productivityCompanion => 'Din produktivitetsledsager';

  @override
  String get done => 'Færdig';

  @override
  String get newNote => 'Ny note';

  @override
  String get changeColor => 'Skift farve';

  @override
  String get copyContent => 'Kopier indhold';

  @override
  String get titleOptional => 'Titel (valgfrit)';

  @override
  String get exportAsPdf => 'Eksporter som PDF';

  @override
  String get taskDueNow => 'Opgave klar nu';

  @override
  String get moveTaskToBinTitle => 'Flytte opgave til papirkurven?';

  @override
  String get restoreTaskLater =>
      'Du kan gendanne denne opgave senere fra indstillingerne.';

  @override
  String get newTask => 'Ny opgave';

  @override
  String get editTask => 'Rediger opgave';

  @override
  String get undo => 'Fortryd';

  @override
  String get redo => 'Gentag';

  @override
  String get category => 'Kategori';

  @override
  String get categoryHint => 'f.eks. Arbejde, Gym';

  @override
  String get whatNeedsToBeDone => 'Hvad skal der gøres?';

  @override
  String get enterTaskDetails => 'Indtast opgavedetaljer...';

  @override
  String get setDueDate => 'Indstil forfaldsdato';

  @override
  String get dueDate => 'To datoer';

  @override
  String get sortAndFilter => 'Sorter og filtrer';

  @override
  String get sortBy => 'SORTERT EFTER';

  @override
  String get categories => 'Kategorier';

  @override
  String get all => 'Alle';

  @override
  String get reset => 'Nulstil';

  @override
  String get apply => 'Anvende';

  @override
  String errorLoadingData(String error) {
    return 'Fejl ved indlæsning af data.\n\n$error';
  }

  @override
  String get dailyQuote1 =>
      'Den bedste måde at forudsige fremtiden er at skabe den.';

  @override
  String get dailyQuote2 =>
      'Rigdom består ikke i at have store ejendele, men i at have få ønsker.';

  @override
  String get dailyQuote3 => 'Tid er den ultimative valuta.';

  @override
  String get dailyQuote4 => 'Succes er ikke endelig, fiasko er ikke fatal.';

  @override
  String get dailyQuote5 => 'Fokuser på løsningen, ikke problemet.';

  @override
  String get dailyQuote6 => 'Dit netværk er din nettoværdi.';

  @override
  String get moodHappy => 'Lykkelig';

  @override
  String get moodExcited => 'Ophidset';

  @override
  String get moodNeutral => 'Neutral';

  @override
  String get moodSad => 'Sørgelig';

  @override
  String get moodStressed => 'Stresset';

  @override
  String exportDate(String date) {
    return '📅 $date';
  }

  @override
  String exportMood(String emoji, String mood) {
    return 'Stemning: $emoji $mood';
  }

  @override
  String exportTitle(String title) {
    return 'TITEL: $title';
  }

  @override
  String exportTags(String tags) {
    return 'Tags: $tags';
  }

  @override
  String get noResultsFound => 'Ingen resultater fundet';

  @override
  String get noItems => 'Ingen varer';

  @override
  String get rename => 'Omdøb';

  @override
  String get deleteFolder => 'Slet mappe';

  @override
  String get deleteSketchesQuestion => 'Vil du slette skitser?';

  @override
  String get deleteFolderConfirmation =>
      'Alle skitser i denne mappe vil blive slettet permanent.';

  @override
  String get chooseColor => 'Vælg Farve';

  @override
  String get searchClips => 'Søg efter klip...';

  @override
  String get clipboardEmpty => 'Udklipsholderen er tom';

  @override
  String get addItem => 'Tilføj vare';

  @override
  String get clipColor => 'Klip farve';

  @override
  String get newClip => 'Nyt klip';

  @override
  String get editClip => 'Rediger klip';

  @override
  String get restoreClipLater => 'Du kan gendanne dette klip senere.';

  @override
  String get dataDistribution => 'DATADISTRIBUTION';

  @override
  String get taskProgress => 'OPGAVEFREMSKRIDT';

  @override
  String get quickStats => 'HURTIG STATISTIK';

  @override
  String get taskCompletion => 'Opgaveafslutning';

  @override
  String get noItemsForDate => 'Ingen varer for denne dato';

  @override
  String get enjoyFreeTime => 'Nyd din fritid!';

  @override
  String get searchThisDay => 'Søg i denne dag...';

  @override
  String get finance => 'Finansiere';

  @override
  String get permanentlyDelete => 'Slet permanent?';

  @override
  String deleteSelectionConfirmation(int foldersCount, int sketchesCount) {
    return 'Dette vil permanent slette $foldersCount mapper (og deres skitser) og $sketchesCount andre skitser.\n\nDette kan ikke fortrydes.';
  }

  @override
  String get deleteForever => 'Slet for evigt';

  @override
  String selectedCount(int count) {
    return '$count valgt';
  }

  @override
  String get deleteItemQuestion => 'Slet element?';

  @override
  String get deleteItemConfirmation =>
      'Dette vil flytte varen til papirkurven.';

  @override
  String get moveToBinItem => 'Flytte til bin?';

  @override
  String get moveToBinConfirmation => 'Du kan gendanne den senere.';

  @override
  String selectedItems(int count) {
    return '$count valgt';
  }

  @override
  String get recentClips => 'Seneste klip';

  @override
  String get copied => 'Kopieret!';

  @override
  String get copiedPlainText => 'Kopieret almindelig tekst';

  @override
  String get clipTheme => 'Klip tema';

  @override
  String get justNow => 'Lige nu';

  @override
  String minutesAgo(Object count) {
    return 'for $count m siden';
  }

  @override
  String hoursAgo(Object count) {
    return 'for $count t siden';
  }

  @override
  String daysAgo(Object count) {
    return 'for ${count}d siden';
  }

  @override
  String get noTasksFound => 'Ingen opgaver fundet.';

  @override
  String get searchTasks => 'Søg opgaver...';

  @override
  String get taskReminder => 'Opgavepåmindelse';

  @override
  String get untitledNote => 'Unavngivet note';

  @override
  String get dailyEntry => 'Daglig indgang';

  @override
  String get clipboardHistory => 'Udklipsholder historie';

  @override
  String get deletePermanentlyContent => 'Denne handling kan ikke fortrydes.';

  @override
  String get emptyRecycleBinTitle => 'Tøm papirkurven?';

  @override
  String emptyRecycleBinContent(Object count) {
    return 'Alle $count elementer vil blive slettet permanent.';
  }

  @override
  String get emptyBin => 'Tøm beholder';

  @override
  String get recycleBinEmpty => 'Papirkurven er tom';

  @override
  String get deletedItemsAppearHere => 'Slettede elementer vises her.';

  @override
  String get empty => 'Tom';

  @override
  String get recent => 'Nylig';

  @override
  String categoryLabel(Object category) {
    return 'Kategori: $category';
  }

  @override
  String get general => 'Generel';

  @override
  String get description => 'Beskrivelse';

  @override
  String get daily => 'Daglig';

  @override
  String get weekly => 'Ugentlig';

  @override
  String get monthly => 'Månedlig';

  @override
  String get yearly => 'Årligt';

  @override
  String get analysis => 'Analyse';

  @override
  String get transactions => 'Transaktioner';

  @override
  String get ok => 'OK';

  @override
  String get bulkImport => 'Bulk Import';
}
