// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Welsh (`cy`).
class AppLocalizationsCy extends AppLocalizations {
  AppLocalizationsCy([String locale = 'cy']) : super(locale);

  @override
  String get settings => 'Gosodiadau';

  @override
  String get language => 'Iaith';

  @override
  String get systemDefault => 'System ddiofyn';

  @override
  String get notes => 'Nodiadau';

  @override
  String get todos => 'I-Dos';

  @override
  String get journal => 'Dyddlyfr';

  @override
  String get clipboard => 'Clipfwrdd';

  @override
  String get save => 'Arbed';

  @override
  String get create => 'Creu';

  @override
  String get cancel => 'Canslo';

  @override
  String get delete => 'Dileu';

  @override
  String get edit => 'Golygu';

  @override
  String get share => 'Rhannu';

  @override
  String get copy => 'Copi';

  @override
  String get unsavedChanges => 'Newidiadau Heb eu Cadw';

  @override
  String get confirmDelete => 'Cadarnhau Dileu';

  @override
  String get discard => 'Taflwch';

  @override
  String get camera => 'Camera';

  @override
  String get gallery => 'Oriel';

  @override
  String get search => 'Chwiliwch';

  @override
  String get pleaseEnterTask => 'Rhowch dasg';

  @override
  String get deleteTask => 'Dileu Tasg';

  @override
  String get selectItems => 'Dewiswch Eitemau';

  @override
  String get deleteAll => 'Dileu Pawb';

  @override
  String error(Object error) {
    return 'Gwall: $error';
  }

  @override
  String get premiumFeatures => 'Nodweddion Premiwm';

  @override
  String get manageCoinsAdsPremium =>
      'Rheoli darnau arian, hysbysebion, a statws premiwm';

  @override
  String get themeMode => 'Modd Thema';

  @override
  String get accentColor => 'Lliw Acen';

  @override
  String get backgroundDesign => 'Dyluniad Cefndir';

  @override
  String get pushNotifications => 'Hysbysiadau Gwthio';

  @override
  String get recycleBin => 'Bin Ailgylchu';

  @override
  String get exportData => 'Data Allforio';

  @override
  String get importData => 'Mewnforio Data';

  @override
  String get rateApp => 'App Cyfradd';

  @override
  String get sendFeedback => 'Anfon Adborth';

  @override
  String get privacyPolicy => 'Polisi Preifatrwydd';

  @override
  String get version => 'Fersiwn';

  @override
  String get buildNumber => 'Adeiladu Rhif';

  @override
  String get system => 'System';

  @override
  String get light => 'Ysgafn';

  @override
  String get dark => 'Tywyll';

  @override
  String get itemRestored => 'Eitem wedi\'\'i hadfer';

  @override
  String get recycleBinCleared => 'Clirio\'\'r Bin Ailgylchu yn llwyddiannus';

  @override
  String get unlockPermanently => 'Datgloi\'\'n Barhaol';

  @override
  String get notEnoughCoins => 'Dim digon o ddarnau arian!';

  @override
  String youEarnedCoins(Object amount) {
    return 'Fe wnaethoch chi ennill $amount darnau arian!';
  }

  @override
  String get contentCopied => 'Cynnwys wedi\'\'i gopïo';

  @override
  String get selectDateTime => 'Dewiswch Dyddiad ac Amser';

  @override
  String get watchAdToEarnCoins => 'Gwylio Hysbyseb i Ennill Darnau Arian';

  @override
  String get premiumUnlocked => 'Premiwm heb ei gloi';

  @override
  String get removeAds => 'Dileu Hysbysebion';

  @override
  String get unlimitedCloudStorage => 'Storio Cwmwl Diderfyn';

  @override
  String get deleteNote => 'Dileu Nodyn';

  @override
  String get shareNote => 'Rhannu Nodyn';

  @override
  String get editNote => 'Golygu Nodyn';

  @override
  String get searchNotes => 'Chwilio nodiadau...';

  @override
  String get noNotesFound => 'Heb ganfod nodiadau';

  @override
  String get captureThoughts => 'Daliwch eich meddyliau ar unwaith.';

  @override
  String get createNote => 'Creu Nodyn';

  @override
  String get customOrder => 'Gorchymyn Custom';

  @override
  String get newestFirst => 'Diweddaraf yn Gyntaf';

  @override
  String get oldestFirst => 'Hynaf yn Gyntaf';

  @override
  String get titleAZ => 'Teitl: A-Z';

  @override
  String get titleZA => 'Teitl: Z-A';

  @override
  String get deleteAllQuestion => 'Dileu Pawb?';

  @override
  String get moveToRecycleBin => 'Symud pob nodyn i Recycle Bin?';

  @override
  String get moveToBinQuestion => 'Symud i Bin?';

  @override
  String get restoreNoteLater => 'Gallwch adfer y nodyn hwn yn ddiweddarach.';

  @override
  String get move => 'Symud';

  @override
  String get myThoughts => 'Fy Meddyliau';

  @override
  String get selected => 'Wedi\'\'i ddewis';

  @override
  String get noContent => 'Dim cynnwys';

  @override
  String get untitled => 'Di-deitl';

  @override
  String get chooseWallpapers => 'Dewiswch o blith 10+ o bapurau wal deinamig';

  @override
  String get backupData => 'Data Wrth Gefn';

  @override
  String get saveJsonFile => 'Cadw ffeil JSON sy\'\'n cynnwys eich holl ddata?';

  @override
  String get exportNow => 'Allforio Nawr';

  @override
  String get importDataTitle => 'Mewnforio Data';

  @override
  String get mergeBackupFile =>
      'Cyfuno ffeil wrth gefn gyda\'\'ch eitemau cyfredol?';

  @override
  String get selectFile => 'Dewiswch Ffeil';

  @override
  String get backupSaved => 'Copi wrth gefn wedi\'\'i arbed yn llwyddiannus!';

  @override
  String get exportFailed => 'Methodd yr allforio.';

  @override
  String importSuccess(Object count) {
    return '$count o eitemau wedi\'\'u hadfer yn llwyddiannus!';
  }

  @override
  String get importFailed => 'Methodd y mewnforio.';

  @override
  String widgetAdded(String widget) {
    return 'Teclyn wedi\'\'i ychwanegu at Home Screen!';
  }

  @override
  String get widgetRequestSent =>
      'Cais teclyn wedi\'\'i anfon. Gwiriwch eich sgrin gartref.';

  @override
  String get widgetAddFailed => 'Wedi methu ag ychwanegu teclyn';

  @override
  String get autoSaveEnabled => 'Wedi\'\'i alluogi i gadw\'\'n awtomatig.';

  @override
  String get autoSaveDisabled => 'Analluogwyd cadw\'\'n awtomatig.';

  @override
  String get homeScreenWidgets => 'Widgets Sgrin Cartref';

  @override
  String get notificationsTitle => 'Hysbysiadau';

  @override
  String get dataBackup => 'Data a Gwneud copi wrth gefn';

  @override
  String get feedbackSupport => 'Adborth a Chefnogaeth';

  @override
  String get creditsTitle => 'Credydau';

  @override
  String get privacyMaintenance => 'Preifatrwydd a Chynnal a Chadw';

  @override
  String get aboutTitle => 'Ynghylch';

  @override
  String get premium => 'Premiwm';

  @override
  String get appearanceTitle => 'Ymddangosiad';

  @override
  String get clipboardTitle => 'Clipfwrdd';

  @override
  String get settingsSubtitle => 'Addasu Eich Profiad';

  @override
  String get welcomeTitle => 'Croeso i CopyClip';

  @override
  String get welcomeDescription =>
      'Eich cydymaith cynhyrchiant yn y pen draw. Gadewch i ni eich sefydlu gydag offer pwerus i reoli\'\'ch diwrnod.';

  @override
  String get onboardingNotesTitle => 'Nodiadau Clyfar';

  @override
  String get onboardingNotesDesc =>
      'Dal syniadau ar unwaith gyda fformatio testun cyfoethog. Trefnwch eich meddyliau a pheidiwch byth â cholli syniad gwych eto.';

  @override
  String get onboardingTodosTitle => 'Rheoli Tasgau';

  @override
  String get onboardingTodosDesc =>
      'Arhoswch ar ben eich gêm. Creu rhestrau o bethau i\'\'w gwneud, gosod blaenoriaethau, a mathru\'\'ch nodau un marc gwirio ar y tro.';

  @override
  String get onboardingJournalTitle => 'Cylchgrawn Personol';

  @override
  String get onboardingJournalDesc =>
      'Myfyriwch ar eich diwrnod. Gofod preifat i ysgrifennu eich atgofion, eich teimladau a\'\'ch profiadau dyddiol.';

  @override
  String get onboardingClipboardTitle => 'Rheolwr Clipfwrdd';

  @override
  String get onboardingClipboardDesc =>
      'Copïwch unwaith, pastiwch unrhyw le. Cyrchwch hanes eich clipfwrdd i adalw pytiau y gwnaethoch eu copïo\'\'n gynharach.';

  @override
  String get featuresNotesDesc => 'Creu a rheoli eich nodiadau';

  @override
  String get featuresTodosDesc => 'Cadwch olwg ar eich tasgau';

  @override
  String get featuresJournalDesc => 'Ysgrifennwch eich meddyliau';

  @override
  String get featuresClipboardDesc => 'Mynediad i\'\'ch hanes clipfwrdd';

  @override
  String get chooseYourAura => 'Dewiswch Eich Aura';

  @override
  String get expressYourselfTheme =>
      'Mynegwch eich hun gyda lliw thema newydd!';

  @override
  String get autoSaveClipboard => 'Auto-arbed Clipfwrdd';

  @override
  String get autoSaveClipboardDesc =>
      'Cadw eitemau sydd wedi\'\'u copïo\'\'n awtomatig';

  @override
  String get permissionDeniedSettings =>
      'Caniatâd wedi ei wrthod yn barhaol. Galluogwch yn y Gosodiadau.';

  @override
  String get notificationsEnabled => 'Hysbysiadau wedi\'\'u galluogi!';

  @override
  String get redirectingToSettings =>
      'Ailgyfeirio i osodiadau i analluogi hysbysiadau...';

  @override
  String get premiumAccess => 'Mynediad Premiwm';

  @override
  String get premiumActiveUntil => 'Premiwm Actif tan';

  @override
  String get unlockAllFeatures => 'Datgloi Pob Nodwedd';

  @override
  String get buyPremium => 'Prynu Premiwm (7 Diwrnod)';

  @override
  String costCoins(Object cost) {
    return 'Cost: $cost Darnau arian';
  }

  @override
  String get premiumActivated => 'Premiwm Wedi\'\'i actifadu am 7 diwrnod!';

  @override
  String get premiumActive => 'Premiwm Actif';

  @override
  String get expires => 'Yn dod i ben:';

  @override
  String get temporaryAccess => 'Mynediad Dros Dro';

  @override
  String get journalExpression => 'Cyfnodolyn a Mynegiant';

  @override
  String get artisticDesigns => 'Dyluniadau Artistig';

  @override
  String get artisticDesignsDesc =>
      'Datgloi 10+ o themâu cardiau cyfnodolyn unigryw';

  @override
  String get premiumLayouts => 'Cynlluniau Premiwm';

  @override
  String get premiumLayoutsDesc => 'Ffyrdd unigryw o weld eich atgofion';

  @override
  String get clipboardAutoSaveDesc => 'Cipio hanes clipfwrdd cefndir';

  @override
  String get proWidgets => 'Widgets Pro';

  @override
  String get proWidgetsDesc =>
      'Mae\'\'r holl nodweddion ar gael ar eich sgrin gartref';

  @override
  String get dataExport => 'Data ac Allforio';

  @override
  String get advancedBackup => 'Copi Wrth Gefn Uwch';

  @override
  String get advancedBackupDesc =>
      'Mewnforio / allforio\'\'r holl ddata yn ddiogel';

  @override
  String get pdfExport => 'Allforio PDF';

  @override
  String get pdfExportDesc => 'Allforio nodiadau a chyfnodolion i PDF';

  @override
  String get printReady => 'Argraffu\'\'n Barod';

  @override
  String get printReadyDesc => 'Cefnogaeth argraffu uniongyrchol';

  @override
  String get richTextEditor => 'Golygydd Testun Cyfoethog';

  @override
  String get advancedSearch => 'Chwiliad Manwl';

  @override
  String get advancedSearchDesc => 'Chwilio ac Amnewid o fewn eich testun';

  @override
  String get richMedia => 'Cyfryngau Cyfoethog';

  @override
  String get richMediaDesc => 'Mewnosod Delweddau, Fideos, a Dolenni';

  @override
  String get editorStyling => 'Golygydd Styling';

  @override
  String get editorStylingDesc => 'Testun personol a chefndiroedd golygydd';

  @override
  String get balance => 'Cydbwysedd';

  @override
  String get loadingAd => 'Wrthi\'\'n llwytho hysbyseb...';

  @override
  String watchAd(Object amount) {
    return 'Gwylio Hysbyseb (+$amount)';
  }

  @override
  String get loadAd => 'Llwytho Hysbyseb';

  @override
  String get backupDataDesc => 'Cadw ffeil JSON o\'\'ch data';

  @override
  String get importDataDesc => 'Cyfuno ffeil wrth gefn i mewn i CopyClip';

  @override
  String get notificationPermissionDenied =>
      'Caniatâd hysbysu wedi\'\'i wrthod.';

  @override
  String get typeNewTask => 'Teipiwch dasg newydd...';

  @override
  String get addTask => 'Ychwanegu tasg';

  @override
  String get completed => 'Cwblhawyd';

  @override
  String get moveTasksToRecycleBin =>
      'Symud pob tasg weithredol i Recycle Bin?';

  @override
  String fileNotFoundError(Object path) {
    return 'Gwall: Ni chanfuwyd y ffeil yn $path';
  }

  @override
  String get entryCopied => 'Cafodd y cofnod ei gopïo';

  @override
  String get moveEntriesToRecycleBin =>
      'Symud pob cofnod gweithredol i Recycle Bin?';

  @override
  String get startWritingStory => 'Dechreuwch ysgrifennu eich stori';

  @override
  String get recordMemories =>
      'Cofnodwch eich atgofion a\'\'ch teimladau dyddiol.';

  @override
  String get writeJournal => 'Ysgrifennu Cylchgrawn';

  @override
  String get myMemories => 'Fy Atgofion';

  @override
  String get sortJournal => 'Trefnu Cylchgrawn';

  @override
  String get byMood => 'Gan Hwyliau';

  @override
  String get searchMemories => 'Chwilio atgofion...';

  @override
  String get selectAll => 'Dewiswch Pawb';

  @override
  String get deleteSelected => 'Dileu Wedi\'\'i Ddewis';

  @override
  String get taskCompletedExclamation => 'Tasg wedi\'\'i chwblhau!';

  @override
  String get taskUncompletedExclamation => 'Tasg heb ei chwblhau';

  @override
  String get clipboardUpdatedExclamation => 'Clipfwrdd wedi\'\'i ddiweddaru!';

  @override
  String clipboardSavedContent(Object content) {
    return 'Cadwyd y clipfwrdd: $content';
  }

  @override
  String get overview => 'Trosolwg';

  @override
  String get colorAurora => 'Aurora';

  @override
  String get colorCosmic => 'Cosmig';

  @override
  String get colorNebula => 'Nebula';

  @override
  String get colorStarlight => 'Golau seren';

  @override
  String get colorSolar => 'Solar';

  @override
  String get colorNova => 'Newydd';

  @override
  String get loadingStepLoading => 'Wrthi\'\'n llwytho...';

  @override
  String get loadingStepDatabase => 'Wrthi\'\'n sefydlu cronfa ddata...';

  @override
  String get loadingStepSystem => 'Wrthi\'\'n ffurfweddu system...';

  @override
  String get loadingStepReady => 'Yn barod';

  @override
  String get productivityCompanion => 'Eich cydymaith cynhyrchiant';

  @override
  String get done => 'Wedi\'\'i wneud';

  @override
  String get newNote => 'Nodyn Newydd';

  @override
  String get changeColor => 'Newid Lliw';

  @override
  String get copyContent => 'Copïo Cynnwys';

  @override
  String get titleOptional => 'Teitl (Dewisol)';

  @override
  String get exportAsPdf => 'Allforio fel PDF';

  @override
  String get taskDueNow => 'Tasg i\'\'w Cyflawni Nawr';

  @override
  String get moveTaskToBinTitle => 'Symud Tasg i Recycle Bin?';

  @override
  String get restoreTaskLater =>
      'Gallwch chi adfer y dasg hon yn ddiweddarach o\'\'r gosodiadau.';

  @override
  String get newTask => 'Tasg Newydd';

  @override
  String get editTask => 'Golygu Tasg';

  @override
  String get undo => 'Dadwneud';

  @override
  String get redo => 'Ail-wneud';

  @override
  String get category => 'Categori';

  @override
  String get categoryHint => 'e.e. Gwaith, Gym';

  @override
  String get whatNeedsToBeDone => 'Beth sydd angen ei wneud?';

  @override
  String get enterTaskDetails => 'Rhowch fanylion y dasg...';

  @override
  String get setDueDate => 'Gosod Dyddiad Cwblhau';

  @override
  String get dueDate => 'Dau Ddyddiad';

  @override
  String get sortAndFilter => 'Trefnu a Hidlo';

  @override
  String get sortBy => 'SORT GAN';

  @override
  String get categories => 'Categorïau';

  @override
  String get all => 'Pawb';

  @override
  String get reset => 'Ailosod';

  @override
  String get apply => 'Ymgeisiwch';

  @override
  String errorLoadingData(String error) {
    return 'Gwall wrth lwytho data.\n\n$error';
  }

  @override
  String get dailyQuote1 => 'Y ffordd orau o ragweld y dyfodol yw ei greu.';

  @override
  String get dailyQuote2 =>
      'Mae cyfoeth yn cynnwys nid meddu ar feddiannau mawr, ond ychydig o eisiau.';

  @override
  String get dailyQuote3 => 'Amser yw\'\'r arian cyfred eithaf.';

  @override
  String get dailyQuote4 =>
      'Nid yw llwyddiant yn derfynol, nid yw methiant yn angheuol.';

  @override
  String get dailyQuote5 => 'Canolbwyntiwch ar yr ateb, nid y broblem.';

  @override
  String get dailyQuote6 => 'Eich rhwydwaith yw eich gwerth net.';

  @override
  String get moodHappy => 'Hapus';

  @override
  String get moodExcited => 'Wedi cyffroi';

  @override
  String get moodNeutral => 'Niwtral';

  @override
  String get moodSad => 'Trist';

  @override
  String get moodStressed => 'Dan straen';

  @override
  String exportDate(String date) {
    return '📅 $date';
  }

  @override
  String exportMood(String emoji, String mood) {
    return 'Hwyliau: $emoji $mood';
  }

  @override
  String exportTitle(String title) {
    return 'TEITL: $title';
  }

  @override
  String exportTags(String tags) {
    return 'Tagiau: $tags';
  }

  @override
  String get noResultsFound => 'Heb ganfod canlyniadau';

  @override
  String get noItems => 'Dim eitemau';

  @override
  String get rename => 'Ailenwi';

  @override
  String get deleteFolder => 'Dileu Ffolder';

  @override
  String get deleteSketchesQuestion => 'Dileu Brasluniau?';

  @override
  String get deleteFolderConfirmation =>
      'Bydd pob braslun yn y ffolder hwn yn cael ei ddileu yn barhaol.';

  @override
  String get chooseColor => 'Dewiswch Lliw';

  @override
  String get searchClips => 'Chwilio clipiau...';

  @override
  String get clipboardEmpty => 'Mae\'\'r clipfwrdd yn wag';

  @override
  String get addItem => 'Ychwanegu Eitem';

  @override
  String get clipColor => 'Lliw Clip';

  @override
  String get newClip => 'Clip Newydd';

  @override
  String get editClip => 'Golygu Clip';

  @override
  String get restoreClipLater => 'Gallwch adfer y clip hwn yn ddiweddarach.';

  @override
  String get dataDistribution => 'DOSBARTHU DATA';

  @override
  String get taskProgress => 'CYNNYDD Y DASG';

  @override
  String get quickStats => 'STATSAU CYFLYM';

  @override
  String get taskCompletion => 'Cwblhau Tasg';

  @override
  String get noItemsForDate => 'Dim eitemau ar gyfer y dyddiad hwn';

  @override
  String get enjoyFreeTime => 'Mwynhewch eich amser rhydd!';

  @override
  String get searchThisDay => 'Chwiliwch yn y dydd hwn...';

  @override
  String get finance => 'Cyllid';

  @override
  String get permanentlyDelete => 'Dileu\'\'n Barhaol?';

  @override
  String deleteSelectionConfirmation(int foldersCount, int sketchesCount) {
    return 'Bydd hyn yn dileu ffolderi $foldersCount (a\'\'u brasluniau) a $sketchesCount brasluniau eraill yn barhaol.\n\nNi ellir dadwneud hyn.';
  }

  @override
  String get deleteForever => 'Dileu Am Byth';

  @override
  String selectedCount(int count) {
    return '$count Wedi\'\'i ddewis';
  }

  @override
  String get deleteItemQuestion => 'Dileu Eitem?';

  @override
  String get deleteItemConfirmation =>
      'Bydd hyn yn symud yr eitem i\'\'r bin ailgylchu.';

  @override
  String get moveToBinItem => 'Symud i Bin?';

  @override
  String get moveToBinConfirmation => 'Gallwch ei adfer yn ddiweddarach.';

  @override
  String selectedItems(int count) {
    return '$count Wedi\'\'i ddewis';
  }

  @override
  String get recentClips => 'Clipiau Diweddar';

  @override
  String get copied => 'Wedi\'\'i gopïo!';

  @override
  String get copiedPlainText => 'Testun plaen wedi\'\'i gopïo';

  @override
  String get clipTheme => 'Thema Clip';

  @override
  String get justNow => 'Dim ond nawr';

  @override
  String minutesAgo(Object count) {
    return '${count}m yn ôl';
  }

  @override
  String hoursAgo(Object count) {
    return '${count}a yn ôl';
  }

  @override
  String daysAgo(Object count) {
    return '${count}d yn ôl';
  }

  @override
  String get noTasksFound => 'Heb ganfod tasgau.';

  @override
  String get searchTasks => 'Tasgau chwilio...';

  @override
  String get taskReminder => 'Nodyn Atgoffa Tasg';

  @override
  String get untitledNote => 'Nodyn Di-deitl';

  @override
  String get dailyEntry => 'Mynediad Dyddiol';

  @override
  String get clipboardHistory => 'Hanes Clipfwrdd';

  @override
  String get deletePermanentlyContent => 'Ni ellir dadwneud y weithred hon.';

  @override
  String get emptyRecycleBinTitle => 'Bin Ailgylchu Gwag?';

  @override
  String emptyRecycleBinContent(Object count) {
    return 'Bydd pob eitem $count yn cael ei dileu yn barhaol.';
  }

  @override
  String get emptyBin => 'Bin Gwag';

  @override
  String get recycleBinEmpty => 'Bin Ailgylchu yn wag';

  @override
  String get deletedItemsAppearHere =>
      'Bydd eitemau sydd wedi\'\'u dileu yn ymddangos yma.';

  @override
  String get empty => 'Gwag';

  @override
  String get recent => 'diweddar';

  @override
  String categoryLabel(Object category) {
    return 'Categori: $category';
  }

  @override
  String get general => 'Cyffredinol';

  @override
  String get description => 'Disgrifiad';

  @override
  String get daily => 'Dyddiol';

  @override
  String get weekly => 'Wythnosol';

  @override
  String get monthly => 'Yn fisol';

  @override
  String get yearly => 'Yn flynyddol';

  @override
  String get analysis => 'Dadansoddi';

  @override
  String get transactions => 'Trafodion';

  @override
  String get ok => 'iawn';

  @override
  String get bulkImport => 'Bulk Import';
}
