// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Filipino Pilipino (`fil`).
class AppLocalizationsFil extends AppLocalizations {
  AppLocalizationsFil([String locale = 'fil']) : super(locale);

  @override
  String get settings => 'Mga setting';

  @override
  String get language => 'Wika';

  @override
  String get systemDefault => 'System Default';

  @override
  String get notes => 'Mga Tala';

  @override
  String get todos => 'Mga dapat gawin';

  @override
  String get journal => 'Journal';

  @override
  String get clipboard => 'Clipboard';

  @override
  String get save => 'I-save';

  @override
  String get create => 'Lumikha';

  @override
  String get cancel => 'Kanselahin';

  @override
  String get delete => 'Tanggalin';

  @override
  String get edit => 'I-edit';

  @override
  String get share => 'Ibahagi';

  @override
  String get copy => 'Kopyahin';

  @override
  String get unsavedChanges => 'Mga Hindi Na-save na Pagbabago';

  @override
  String get confirmDelete => 'Kumpirmahin ang Tanggalin';

  @override
  String get discard => 'Itapon';

  @override
  String get camera => 'Camera';

  @override
  String get gallery => 'Gallery';

  @override
  String get search => 'Maghanap';

  @override
  String get pleaseEnterTask => 'Mangyaring magpasok ng isang gawain';

  @override
  String get deleteTask => 'Tanggalin ang Gawain';

  @override
  String get selectItems => 'Pumili ng Mga Item';

  @override
  String get deleteAll => 'Tanggalin Lahat';

  @override
  String error(Object error) {
    return 'Error: $error';
  }

  @override
  String get premiumFeatures => 'Mga Premium na Tampok';

  @override
  String get manageCoinsAdsPremium =>
      'Pamahalaan ang mga barya, ad, at premium na katayuan';

  @override
  String get themeMode => 'Mode ng Tema';

  @override
  String get accentColor => 'Kulay ng Accent';

  @override
  String get backgroundDesign => 'Disenyo ng Background';

  @override
  String get pushNotifications => 'Mga Push Notification';

  @override
  String get recycleBin => 'Recycle Bin';

  @override
  String get exportData => 'I-export ang Data';

  @override
  String get importData => 'Mag-import ng Data';

  @override
  String get rateApp => 'I-rate ang App';

  @override
  String get sendFeedback => 'Magpadala ng Feedback';

  @override
  String get privacyPolicy => 'Patakaran sa Privacy';

  @override
  String get version => 'Bersyon';

  @override
  String get buildNumber => 'Build Number';

  @override
  String get system => 'Sistema';

  @override
  String get light => 'Liwanag';

  @override
  String get dark => 'Madilim';

  @override
  String get itemRestored => 'Na-restore ang item';

  @override
  String get recycleBinCleared => 'Matagumpay na na-clear ang Recycle Bin';

  @override
  String get unlockPermanently => 'I-unlock nang Permanenteng';

  @override
  String get notEnoughCoins => 'Hindi sapat ang mga barya!';

  @override
  String youEarnedCoins(Object amount) {
    return 'Nakakuha ka ng $amount coins!';
  }

  @override
  String get contentCopied => 'Nakopya ang nilalaman';

  @override
  String get selectDateTime => 'Piliin ang Petsa at Oras';

  @override
  String get watchAdToEarnCoins => 'Manood ng Ad para Kumita ng Barya';

  @override
  String get premiumUnlocked => 'Naka-unlock ang Premium';

  @override
  String get removeAds => 'Alisin ang Mga Ad';

  @override
  String get unlimitedCloudStorage => 'Walang limitasyong Cloud Storage';

  @override
  String get deleteNote => 'Tanggalin ang Tala';

  @override
  String get shareNote => 'Ibahagi ang Tala';

  @override
  String get editNote => 'I-edit ang Tala';

  @override
  String get searchNotes => 'Maghanap ng mga tala...';

  @override
  String get noNotesFound => 'Walang nakitang tala';

  @override
  String get captureThoughts => 'Kunin agad ang iyong mga iniisip.';

  @override
  String get createNote => 'Lumikha ng Tala';

  @override
  String get customOrder => 'Pasadyang Order';

  @override
  String get newestFirst => 'Pinakabago Una';

  @override
  String get oldestFirst => 'Pinakamatanda Una';

  @override
  String get titleAZ => 'Pamagat: A-Z';

  @override
  String get titleZA => 'Pamagat: Z-A';

  @override
  String get deleteAllQuestion => 'Tanggalin Lahat?';

  @override
  String get moveToRecycleBin => 'Ilipat ang lahat ng tala sa Recycle Bin?';

  @override
  String get moveToBinQuestion => 'Lumipat sa Bin?';

  @override
  String get restoreNoteLater =>
      'Maaari mong ibalik ang talang ito sa ibang pagkakataon.';

  @override
  String get move => 'Ilipat';

  @override
  String get myThoughts => 'Aking mga Inisip';

  @override
  String get selected => 'Napili';

  @override
  String get noContent => 'Walang nilalaman';

  @override
  String get untitled => 'Walang pamagat';

  @override
  String get chooseWallpapers => 'Pumili mula sa 10+ dynamic na wallpaper';

  @override
  String get backupData => 'Backup na Data';

  @override
  String get saveJsonFile =>
      'Mag-save ng JSON file na naglalaman ng lahat ng iyong data?';

  @override
  String get exportNow => 'I-export Ngayon';

  @override
  String get importDataTitle => 'Mag-import ng Data';

  @override
  String get mergeBackupFile =>
      'Pagsamahin ang isang backup na file sa iyong kasalukuyang mga item?';

  @override
  String get selectFile => 'Piliin ang File';

  @override
  String get backupSaved => 'Matagumpay na na-save ang backup!';

  @override
  String get exportFailed => 'Nabigo ang pag-export.';

  @override
  String importSuccess(Object count) {
    return 'Matagumpay na naibalik ang $count item!';
  }

  @override
  String get importFailed => 'Nabigo ang pag-import.';

  @override
  String widgetAdded(String widget) {
    return 'Idinagdag ang widget sa Home Screen!';
  }

  @override
  String get widgetRequestSent =>
      'Ipinadala ang kahilingan sa widget. Mangyaring suriin ang iyong home screen.';

  @override
  String get widgetAddFailed => 'Nabigong magdagdag ng widget';

  @override
  String get autoSaveEnabled => 'Pinagana ang auto-save.';

  @override
  String get autoSaveDisabled => 'Na-disable ang auto-save.';

  @override
  String get homeScreenWidgets => 'Mga Widget ng Home Screen';

  @override
  String get notificationsTitle => 'Mga abiso';

  @override
  String get dataBackup => 'Data at Backup';

  @override
  String get feedbackSupport => 'Feedback at Suporta';

  @override
  String get creditsTitle => 'Mga kredito';

  @override
  String get privacyMaintenance => 'Privacy at Pagpapanatili';

  @override
  String get aboutTitle => 'Tungkol sa';

  @override
  String get premium => 'Premium';

  @override
  String get appearanceTitle => 'Hitsura';

  @override
  String get clipboardTitle => 'Clipboard';

  @override
  String get settingsSubtitle => 'I-customize ang Iyong Karanasan';

  @override
  String get welcomeTitle => 'Maligayang pagdating sa CopyClip';

  @override
  String get welcomeDescription =>
      'Ang iyong kasama sa pagiging produktibo. Hayaan kang i-set up gamit ang makapangyarihang mga tool upang pamahalaan ang iyong araw.';

  @override
  String get onboardingNotesTitle => 'Mga Matalinong Tala';

  @override
  String get onboardingNotesDesc =>
      'Kumuha agad ng mga ideya gamit ang rich text formatting. Ayusin ang iyong mga iniisip at hindi na muling mawawalan ng magandang ideya.';

  @override
  String get onboardingTodosTitle => 'Pamamahala ng Gawain';

  @override
  String get onboardingTodosDesc =>
      'Manatili sa tuktok ng iyong laro. Gumawa ng mga listahan ng gagawin, magtakda ng mga priyoridad, at durugin ang iyong mga layunin nang paisa-isa.';

  @override
  String get onboardingJournalTitle => 'Personal na Journal';

  @override
  String get onboardingJournalDesc =>
      'Pagnilayan ang iyong araw. Isang pribadong espasyo para isulat ang iyong mga alaala, damdamin, at pang-araw-araw na karanasan.';

  @override
  String get onboardingClipboardTitle => 'Tagapamahala ng Clipboard';

  @override
  String get onboardingClipboardDesc =>
      'Isang beses kopyahin, i-paste kahit saan. I-access ang history ng iyong clipboard para makuha ang mga snippet na kinopya mo kanina.';

  @override
  String get featuresNotesDesc => 'Lumikha at pamahalaan ang iyong mga tala';

  @override
  String get featuresTodosDesc => 'Subaybayan ang iyong mga gawain';

  @override
  String get featuresJournalDesc => 'Isulat ang iyong mga iniisip';

  @override
  String get featuresClipboardDesc =>
      'I-access ang iyong kasaysayan ng clipboard';

  @override
  String get chooseYourAura => 'Piliin ang Iyong Aura';

  @override
  String get expressYourselfTheme =>
      'Ipahayag ang iyong sarili gamit ang isang bagong kulay ng tema!';

  @override
  String get autoSaveClipboard => 'Awtomatikong i-save ang Clipboard';

  @override
  String get autoSaveClipboardDesc =>
      'Awtomatikong i-save ang mga nakopyang item';

  @override
  String get permissionDeniedSettings =>
      'Permanenteng tinanggihan ang pahintulot. Mangyaring paganahin sa Mga Setting.';

  @override
  String get notificationsEnabled => 'Pinagana ang mga notification!';

  @override
  String get redirectingToSettings =>
      'Nagre-redirect sa mga setting upang huwag paganahin ang mga notification...';

  @override
  String get premiumAccess => 'Premium Access';

  @override
  String get premiumActiveUntil => 'Premium Active hanggang';

  @override
  String get unlockAllFeatures => 'I-unlock ang Lahat ng Mga Tampok';

  @override
  String get buyPremium => 'Bumili ng Premium (7 Araw)';

  @override
  String costCoins(Object cost) {
    return 'Gastos: $cost Mga barya';
  }

  @override
  String get premiumActivated => 'Premium Activated para sa 7 araw!';

  @override
  String get premiumActive => 'Premium Active';

  @override
  String get expires => 'Mag-e-expire:';

  @override
  String get temporaryAccess => 'Pansamantalang Access';

  @override
  String get journalExpression => 'Journal at Expression';

  @override
  String get artisticDesigns => 'Mga Masining na Disenyo';

  @override
  String get artisticDesignsDesc =>
      'I-unlock ang 10+ natatanging tema ng journal card';

  @override
  String get premiumLayouts => 'Mga Premium na Layout';

  @override
  String get premiumLayoutsDesc =>
      'Mga eksklusibong paraan upang tingnan ang iyong mga alaala';

  @override
  String get clipboardAutoSaveDesc =>
      'Pagkuha ng history ng background clipboard';

  @override
  String get proWidgets => 'Mga Pro Widget';

  @override
  String get proWidgetsDesc =>
      'Lahat ng feature na available sa iyong home screen';

  @override
  String get dataExport => 'Data at I-export';

  @override
  String get advancedBackup => 'Advanced na Backup';

  @override
  String get advancedBackupDesc =>
      'Secure na pag-import/pag-export ng lahat ng data';

  @override
  String get pdfExport => 'PDF Export';

  @override
  String get pdfExportDesc => 'I-export ang mga tala at journal sa PDF';

  @override
  String get printReady => 'Print Ready';

  @override
  String get printReadyDesc => 'Direktang suporta sa pag-print';

  @override
  String get richTextEditor => 'Rich Text Editor';

  @override
  String get advancedSearch => 'Masusing Paghahanap';

  @override
  String get advancedSearchDesc =>
      'Maghanap at Palitan sa loob ng iyong teksto';

  @override
  String get richMedia => 'Rich Media';

  @override
  String get richMediaDesc => 'Maglagay ng Mga Larawan, Video, at Link';

  @override
  String get editorStyling => 'Pag-istilo ng Editor';

  @override
  String get editorStylingDesc =>
      'Pasadyang teksto at mga background ng editor';

  @override
  String get balance => 'Balanse';

  @override
  String get loadingAd => 'Nilo-load ang Ad...';

  @override
  String watchAd(Object amount) {
    return 'Manood ng Ad (+$amount)';
  }

  @override
  String get loadAd => 'Mag-load ng Ad';

  @override
  String get backupDataDesc => 'Mag-save ng JSON file ng iyong data';

  @override
  String get importDataDesc =>
      'Pagsamahin ang isang backup na file sa CopyClip';

  @override
  String get notificationPermissionDenied =>
      'Tinanggihan ang pahintulot sa pag-abiso.';

  @override
  String get typeNewTask => 'Mag-type ng bagong gawain...';

  @override
  String get addTask => 'Magdagdag ng gawain';

  @override
  String get completed => 'Nakumpleto';

  @override
  String get moveTasksToRecycleBin =>
      'Ilipat ang lahat ng aktibong gawain sa Recycle Bin?';

  @override
  String fileNotFoundError(Object path) {
    return 'Error: Hindi nakita ang file sa $path';
  }

  @override
  String get entryCopied => 'Kinopya ang entry';

  @override
  String get moveEntriesToRecycleBin =>
      'Ilipat ang lahat ng aktibong entry sa Recycle Bin?';

  @override
  String get startWritingStory => 'Simulan ang pagsulat ng iyong kwento';

  @override
  String get recordMemories =>
      'Itala ang iyong pang-araw-araw na alaala at damdamin.';

  @override
  String get writeJournal => 'Sumulat ng Journal';

  @override
  String get myMemories => 'Aking Mga Alaala';

  @override
  String get sortJournal => 'Pagbukud-bukurin Journal';

  @override
  String get byMood => 'Sa pamamagitan ng Mood';

  @override
  String get searchMemories => 'Maghanap ng mga alaala...';

  @override
  String get selectAll => 'Piliin ang Lahat';

  @override
  String get deleteSelected => 'Tanggalin ang Napili';

  @override
  String get taskCompletedExclamation => 'Nakumpleto ang gawain!';

  @override
  String get taskUncompletedExclamation => 'Hindi natapos ang gawain';

  @override
  String get clipboardUpdatedExclamation => 'Na-update ang clipboard!';

  @override
  String clipboardSavedContent(Object content) {
    return 'Na-save ang clipboard: $content';
  }

  @override
  String get overview => 'Pangkalahatang-ideya';

  @override
  String get colorAurora => 'Aurora';

  @override
  String get colorCosmic => 'Cosmic';

  @override
  String get colorNebula => 'Nebula';

  @override
  String get colorStarlight => 'Liwanag ng bituin';

  @override
  String get colorSolar => 'Solar';

  @override
  String get colorNova => 'Bago';

  @override
  String get loadingStepLoading => 'Naglo-load...';

  @override
  String get loadingStepDatabase => 'Pagse-set up ng database...';

  @override
  String get loadingStepSystem => 'Kino-configure ang system...';

  @override
  String get loadingStepReady => 'handa na';

  @override
  String get productivityCompanion => 'Ang iyong kasama sa pagiging produktibo';

  @override
  String get done => 'Tapos na';

  @override
  String get newNote => 'Bagong Tala';

  @override
  String get changeColor => 'Baguhin ang Kulay';

  @override
  String get copyContent => 'Kopyahin ang Nilalaman';

  @override
  String get titleOptional => 'Pamagat (Opsyonal)';

  @override
  String get exportAsPdf => 'I-export bilang PDF';

  @override
  String get taskDueNow => 'Nakatakdang Gawain Ngayon';

  @override
  String get moveTaskToBinTitle => 'Ilipat ang Gawain sa Recycle Bin?';

  @override
  String get restoreTaskLater =>
      'Maaari mong ibalik ang gawaing ito sa ibang pagkakataon mula sa mga setting.';

  @override
  String get newTask => 'Bagong Gawain';

  @override
  String get editTask => 'I-edit ang Gawain';

  @override
  String get undo => 'I-undo';

  @override
  String get redo => 'Gawin muli';

  @override
  String get category => 'Kategorya';

  @override
  String get categoryHint => 'hal. Trabaho, Gym';

  @override
  String get whatNeedsToBeDone => 'Ano ang kailangang gawin?';

  @override
  String get enterTaskDetails => 'Ilagay ang mga detalye ng gawain...';

  @override
  String get setDueDate => 'Itakda ang Takdang Petsa';

  @override
  String get dueDate => 'Dalawang Petsa';

  @override
  String get sortAndFilter => 'Pagbukud-bukurin at Salain';

  @override
  String get sortBy => 'PAGSAY-BAYIN NG';

  @override
  String get categories => 'Mga kategorya';

  @override
  String get all => 'Lahat';

  @override
  String get reset => 'I-reset';

  @override
  String get apply => 'Mag-apply';

  @override
  String errorLoadingData(String error) {
    return 'Error sa paglo-load ng data.\n\n$error';
  }

  @override
  String get dailyQuote1 =>
      'Ang pinakamahusay na paraan upang mahulaan ang hinaharap ay ang paglikha nito.';

  @override
  String get dailyQuote2 =>
      'Ang kayamanan ay hindi binubuo sa pagkakaroon ng malalaking ari-arian, ngunit sa pagkakaroon ng kaunting mga pangangailangan.';

  @override
  String get dailyQuote3 => 'Ang oras ay ang tunay na pera.';

  @override
  String get dailyQuote4 =>
      'Ang tagumpay ay hindi pangwakas, ang kabiguan ay hindi nakamamatay.';

  @override
  String get dailyQuote5 => 'Tumutok sa solusyon, hindi sa problema.';

  @override
  String get dailyQuote6 => 'Ang iyong network ay ang iyong net worth.';

  @override
  String get moodHappy => 'Masaya';

  @override
  String get moodExcited => 'Excited';

  @override
  String get moodNeutral => 'Neutral';

  @override
  String get moodSad => 'Malungkot';

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
    return 'PAMAGAT: $title';
  }

  @override
  String exportTags(String tags) {
    return 'Mga Tag: $tags';
  }

  @override
  String get noResultsFound => 'Walang nakitang resulta';

  @override
  String get noItems => 'Walang item';

  @override
  String get rename => 'Palitan ang pangalan';

  @override
  String get deleteFolder => 'Tanggalin ang Folder';

  @override
  String get deleteSketchesQuestion => 'Tanggalin ang mga Sketch?';

  @override
  String get deleteFolderConfirmation =>
      'Ang lahat ng sketch sa folder na ito ay permanenteng tatanggalin.';

  @override
  String get chooseColor => 'Pumili ng Kulay';

  @override
  String get searchClips => 'Maghanap ng mga clip...';

  @override
  String get clipboardEmpty => 'Walang laman ang clipboard';

  @override
  String get addItem => 'Magdagdag ng Item';

  @override
  String get clipColor => 'Kulay ng Clip';

  @override
  String get newClip => 'Bagong Clip';

  @override
  String get editClip => 'I-edit ang Clip';

  @override
  String get restoreClipLater =>
      'Maaari mong ibalik ang clip na ito sa ibang pagkakataon.';

  @override
  String get dataDistribution => 'PAGBABIGAY NG DATOS';

  @override
  String get taskProgress => 'PAG-UNLAD NG GAWAIN';

  @override
  String get quickStats => 'MABILIS NA STATS';

  @override
  String get taskCompletion => 'Pagkumpleto ng Gawain';

  @override
  String get noItemsForDate => 'Walang mga item para sa petsang ito';

  @override
  String get enjoyFreeTime => 'Masiyahan sa iyong libreng oras!';

  @override
  String get searchThisDay => 'Maghanap sa araw na ito...';

  @override
  String get finance => 'Pananalapi';

  @override
  String get permanentlyDelete => 'Permanenteng Tanggalin?';

  @override
  String deleteSelectionConfirmation(int foldersCount, int sketchesCount) {
    return 'Permanente nitong tatanggalin ang $foldersCount na mga folder (at ang kanilang mga sketch) at $sketchesCount iba pang mga sketch.\n\nHindi na ito maaaring bawiin.';
  }

  @override
  String get deleteForever => 'Tanggalin ang Magpakailanman';

  @override
  String selectedCount(int count) {
    return '$count Napili';
  }

  @override
  String get deleteItemQuestion => 'Tanggalin ang Item?';

  @override
  String get deleteItemConfirmation => 'Ililipat nito ang item sa recycle bin.';

  @override
  String get moveToBinItem => 'Lumipat sa Bin?';

  @override
  String get moveToBinConfirmation =>
      'Maaari mo itong ibalik sa ibang pagkakataon.';

  @override
  String selectedItems(int count) {
    return '$count Napili';
  }

  @override
  String get recentClips => 'Mga Kamakailang Clip';

  @override
  String get copied => 'Kinopya!';

  @override
  String get copiedPlainText => 'Kinopya ang plain text';

  @override
  String get clipTheme => 'Tema ng Clip';

  @override
  String get justNow => 'Ngayon lang';

  @override
  String minutesAgo(Object count) {
    return '${count}m ang nakalipas';
  }

  @override
  String hoursAgo(Object count) {
    return '${count}h ang nakalipas';
  }

  @override
  String daysAgo(Object count) {
    return '${count}d ang nakalipas';
  }

  @override
  String get noTasksFound => 'Walang nakitang gawain.';

  @override
  String get searchTasks => 'Maghanap ng mga gawain...';

  @override
  String get taskReminder => 'Paalala sa Gawain';

  @override
  String get untitledNote => 'Walang Pamagat na Tala';

  @override
  String get dailyEntry => 'Araw-araw na Pagpasok';

  @override
  String get clipboardHistory => 'Kasaysayan ng Clipboard';

  @override
  String get deletePermanentlyContent =>
      'Ang pagkilos na ito ay hindi maaaring i-undo.';

  @override
  String get emptyRecycleBinTitle => 'Walang laman ang Recycle Bin?';

  @override
  String emptyRecycleBinContent(Object count) {
    return 'Lahat ng $count item ay permanenteng tatanggalin.';
  }

  @override
  String get emptyBin => 'Walang laman na Bin';

  @override
  String get recycleBinEmpty => 'Walang laman ang Recycle Bin';

  @override
  String get deletedItemsAppearHere =>
      'Lalabas dito ang mga tinanggal na item.';

  @override
  String get empty => 'Walang laman';

  @override
  String get recent => 'Kamakailan';

  @override
  String categoryLabel(Object category) {
    return 'Kategorya: $category';
  }

  @override
  String get general => 'Heneral';

  @override
  String get description => 'Paglalarawan';

  @override
  String get daily => 'Araw-araw';

  @override
  String get weekly => 'Linggu-linggo';

  @override
  String get monthly => 'Buwan-buwan';

  @override
  String get yearly => 'Taon-taon';

  @override
  String get analysis => 'Pagsusuri';

  @override
  String get transactions => 'Mga transaksyon';

  @override
  String get ok => 'OK';

  @override
  String get bulkImport => 'Bulk Import';
}

/// The translations for Filipino Pilipino, as used in Philippines (`fil_PH`).
class AppLocalizationsFilPh extends AppLocalizationsFil {
  AppLocalizationsFilPh() : super('fil_PH');

  @override
  String get settings => 'Mga setting';

  @override
  String get language => 'Wika';

  @override
  String get systemDefault => 'System Default';

  @override
  String get notes => 'Mga Tala';

  @override
  String get todos => 'Mga dapat gawin';

  @override
  String get journal => 'Journal';

  @override
  String get clipboard => 'Clipboard';

  @override
  String get save => 'I-save';

  @override
  String get create => 'Lumikha';

  @override
  String get cancel => 'Kanselahin';

  @override
  String get delete => 'Tanggalin';

  @override
  String get edit => 'I-edit';

  @override
  String get share => 'Ibahagi';

  @override
  String get copy => 'Kopyahin';

  @override
  String get unsavedChanges => 'Mga Hindi Na-save na Pagbabago';

  @override
  String get confirmDelete => 'Kumpirmahin ang Tanggalin';

  @override
  String get discard => 'Itapon';

  @override
  String get camera => 'Camera';

  @override
  String get gallery => 'Gallery';

  @override
  String get search => 'Maghanap';

  @override
  String get pleaseEnterTask => 'Mangyaring magpasok ng isang gawain';

  @override
  String get deleteTask => 'Tanggalin ang Gawain';

  @override
  String get selectItems => 'Pumili ng Mga Item';

  @override
  String get deleteAll => 'Tanggalin Lahat';

  @override
  String error(Object error) {
    return 'Error: $error';
  }

  @override
  String get premiumFeatures => 'Mga Premium na Tampok';

  @override
  String get manageCoinsAdsPremium =>
      'Pamahalaan ang mga barya, ad, at premium na katayuan';

  @override
  String get themeMode => 'Mode ng Tema';

  @override
  String get accentColor => 'Accent Color';

  @override
  String get backgroundDesign => 'Disenyo ng Background';

  @override
  String get pushNotifications => 'Mga Push Notification';

  @override
  String get recycleBin => 'Recycle Bin';

  @override
  String get exportData => 'I-export ang Data';

  @override
  String get importData => 'Mag-import ng Data';

  @override
  String get rateApp => 'I-rate ang App';

  @override
  String get sendFeedback => 'Magpadala ng Feedback';

  @override
  String get privacyPolicy => 'Patakaran sa Privacy';

  @override
  String get version => 'Bersyon';

  @override
  String get buildNumber => 'Build Number';

  @override
  String get system => 'Sistema';

  @override
  String get light => 'Liwanag';

  @override
  String get dark => 'Madilim';

  @override
  String get itemRestored => 'Na-restore ang item';

  @override
  String get recycleBinCleared => 'Matagumpay na na-clear ang Recycle Bin';

  @override
  String get unlockPermanently => 'I-unlock nang Permanenteng';

  @override
  String get notEnoughCoins => 'Hindi sapat ang mga barya!';

  @override
  String youEarnedCoins(Object amount) {
    return 'Nakakuha ka ng $amount coins!';
  }

  @override
  String get contentCopied => 'Nakopya ang nilalaman';

  @override
  String get selectDateTime => 'Piliin ang Petsa at Oras';

  @override
  String get watchAdToEarnCoins => 'Manood ng Ad para Kumita ng Barya';

  @override
  String get premiumUnlocked => 'Naka-unlock ang Premium';

  @override
  String get removeAds => 'Alisin ang Mga Ad';

  @override
  String get unlimitedCloudStorage => 'Walang limitasyong Cloud Storage';

  @override
  String get deleteNote => 'Tanggalin ang Tala';

  @override
  String get shareNote => 'Ibahagi ang Tala';

  @override
  String get editNote => 'I-edit ang Tala';

  @override
  String get searchNotes => 'Maghanap ng mga tala...';

  @override
  String get noNotesFound => 'Walang nakitang tala';

  @override
  String get captureThoughts => 'Kunin agad ang iyong mga iniisip.';

  @override
  String get createNote => 'Lumikha ng Tala';

  @override
  String get customOrder => 'Pasadyang Order';

  @override
  String get newestFirst => 'Pinakabago Una';

  @override
  String get oldestFirst => 'Pinakamatanda Una';

  @override
  String get titleAZ => 'Pamagat: A-Z';

  @override
  String get titleZA => 'Pamagat: Z-A';

  @override
  String get deleteAllQuestion => 'Tanggalin Lahat?';

  @override
  String get moveToRecycleBin => 'Ilipat ang lahat ng tala sa Recycle Bin?';

  @override
  String get moveToBinQuestion => 'Lumipat sa Bin?';

  @override
  String get restoreNoteLater =>
      'Maaari mong ibalik ang talang ito sa ibang pagkakataon.';

  @override
  String get move => 'Ilipat';

  @override
  String get myThoughts => 'Aking mga Inisip';

  @override
  String get selected => 'Napili';

  @override
  String get noContent => 'Walang nilalaman';

  @override
  String get untitled => 'Walang pamagat';

  @override
  String get chooseWallpapers => 'Pumili mula sa 10+ dynamic na wallpaper';

  @override
  String get backupData => 'Backup na Data';

  @override
  String get saveJsonFile =>
      'Mag-save ng JSON file na naglalaman ng lahat ng iyong data?';

  @override
  String get exportNow => 'I-export Ngayon';

  @override
  String get importDataTitle => 'Mag-import ng Data';

  @override
  String get mergeBackupFile =>
      'Pagsamahin ang isang backup na file sa iyong kasalukuyang mga item?';

  @override
  String get selectFile => 'Piliin ang File';

  @override
  String get backupSaved => 'Matagumpay na na-save ang backup!';

  @override
  String get exportFailed => 'Nabigo ang pag-export.';

  @override
  String importSuccess(Object count) {
    return 'Matagumpay na naibalik ang $count item!';
  }

  @override
  String get importFailed => 'Nabigo ang pag-import.';

  @override
  String widgetAdded(String widget) {
    return 'Idinagdag ang widget sa Home Screen!';
  }

  @override
  String get widgetRequestSent =>
      'Ipinadala ang kahilingan sa widget. Mangyaring suriin ang iyong home screen.';

  @override
  String get widgetAddFailed => 'Nabigong magdagdag ng widget';

  @override
  String get autoSaveEnabled => 'Pinagana ang auto-save.';

  @override
  String get autoSaveDisabled => 'Na-disable ang auto-save.';

  @override
  String get homeScreenWidgets => 'Mga Widget ng Home Screen';

  @override
  String get notificationsTitle => 'Mga abiso';

  @override
  String get dataBackup => 'Data at Backup';

  @override
  String get feedbackSupport => 'Feedback at Suporta';

  @override
  String get creditsTitle => 'Mga kredito';

  @override
  String get privacyMaintenance => 'Privacy at Pagpapanatili';

  @override
  String get aboutTitle => 'Tungkol sa';

  @override
  String get premium => 'Premium';

  @override
  String get appearanceTitle => 'Hitsura';

  @override
  String get clipboardTitle => 'Clipboard';

  @override
  String get settingsSubtitle => 'I-customize ang Iyong Karanasan';

  @override
  String get welcomeTitle => 'Maligayang pagdating sa CopyClip';

  @override
  String get welcomeDescription =>
      'Ang iyong kasama sa pagiging produktibo. Hayaan kang i-set up gamit ang makapangyarihang mga tool upang pamahalaan ang iyong araw.';

  @override
  String get onboardingNotesTitle => 'Mga Matalinong Tala';

  @override
  String get onboardingNotesDesc =>
      'Kumuha agad ng mga ideya gamit ang rich text formatting. Ayusin ang iyong mga iniisip at hindi na muling mawawalan ng magandang ideya.';

  @override
  String get onboardingTodosTitle => 'Pamamahala ng Gawain';

  @override
  String get onboardingTodosDesc =>
      'Manatili sa tuktok ng iyong laro. Gumawa ng mga listahan ng gagawin, magtakda ng mga priyoridad, at durugin ang iyong mga layunin nang paisa-isa.';

  @override
  String get onboardingJournalTitle => 'Personal na Journal';

  @override
  String get onboardingJournalDesc =>
      'Pagnilayan ang iyong araw. Isang pribadong espasyo para isulat ang iyong mga alaala, damdamin, at pang-araw-araw na karanasan.';

  @override
  String get onboardingClipboardTitle => 'Tagapamahala ng Clipboard';

  @override
  String get onboardingClipboardDesc =>
      'Isang beses kopyahin, i-paste kahit saan. I-access ang history ng iyong clipboard para makuha ang mga snippet na kinopya mo kanina.';

  @override
  String get featuresNotesDesc => 'Lumikha at pamahalaan ang iyong mga tala';

  @override
  String get featuresTodosDesc => 'Subaybayan ang iyong mga gawain';

  @override
  String get featuresJournalDesc => 'Isulat ang iyong mga iniisip';

  @override
  String get featuresClipboardDesc =>
      'I-access ang iyong kasaysayan ng clipboard';

  @override
  String get chooseYourAura => 'Piliin ang Iyong Aura';

  @override
  String get expressYourselfTheme =>
      'Ipahayag ang iyong sarili gamit ang isang bagong kulay ng tema!';

  @override
  String get autoSaveClipboard => 'Awtomatikong i-save ang Clipboard';

  @override
  String get autoSaveClipboardDesc =>
      'Awtomatikong i-save ang mga nakopyang item';

  @override
  String get permissionDeniedSettings =>
      'Permanenteng tinanggihan ang pahintulot. Mangyaring paganahin sa Mga Setting.';

  @override
  String get notificationsEnabled => 'Pinagana ang mga notification!';

  @override
  String get redirectingToSettings =>
      'Nagre-redirect sa mga setting upang huwag paganahin ang mga notification...';

  @override
  String get premiumAccess => 'Premium Access';

  @override
  String get premiumActiveUntil => 'Premium Active hanggang';

  @override
  String get unlockAllFeatures => 'I-unlock ang Lahat ng Mga Tampok';

  @override
  String get buyPremium => 'Bumili ng Premium (7 Araw)';

  @override
  String costCoins(Object cost) {
    return 'Gastos: $cost Mga barya';
  }

  @override
  String get premiumActivated => 'Premium Activated para sa 7 araw!';

  @override
  String get premiumActive => 'Premium Active';

  @override
  String get expires => 'Mag-e-expire:';

  @override
  String get temporaryAccess => 'Pansamantalang Access';

  @override
  String get journalExpression => 'Journal at Expression';

  @override
  String get artisticDesigns => 'Mga Masining na Disenyo';

  @override
  String get artisticDesignsDesc =>
      'I-unlock ang 10+ natatanging tema ng journal card';

  @override
  String get premiumLayouts => 'Mga Premium na Layout';

  @override
  String get premiumLayoutsDesc =>
      'Mga eksklusibong paraan upang tingnan ang iyong mga alaala';

  @override
  String get clipboardAutoSaveDesc =>
      'Pagkuha ng history ng background clipboard';

  @override
  String get proWidgets => 'Mga Pro Widget';

  @override
  String get proWidgetsDesc =>
      'Lahat ng feature na available sa iyong home screen';

  @override
  String get dataExport => 'Data at I-export';

  @override
  String get advancedBackup => 'Advanced na Backup';

  @override
  String get advancedBackupDesc =>
      'Secure na pag-import/pag-export ng lahat ng data';

  @override
  String get pdfExport => 'PDF Export';

  @override
  String get pdfExportDesc => 'I-export ang mga tala at journal sa PDF';

  @override
  String get printReady => 'Print Ready';

  @override
  String get printReadyDesc => 'Direktang suporta sa pag-print';

  @override
  String get richTextEditor => 'Rich Text Editor';

  @override
  String get advancedSearch => 'Masusing Paghahanap';

  @override
  String get advancedSearchDesc =>
      'Maghanap at Palitan sa loob ng iyong teksto';

  @override
  String get richMedia => 'Rich Media';

  @override
  String get richMediaDesc => 'Maglagay ng Mga Larawan, Video, at Link';

  @override
  String get editorStyling => 'Pag-istilo ng Editor';

  @override
  String get editorStylingDesc =>
      'Pasadyang teksto at mga background ng editor';

  @override
  String get balance => 'Balanse';

  @override
  String get loadingAd => 'Nilo-load ang Ad...';

  @override
  String watchAd(Object amount) {
    return 'Manood ng Ad (+$amount)';
  }

  @override
  String get loadAd => 'Mag-load ng Ad';

  @override
  String get backupDataDesc => 'Mag-save ng JSON file ng iyong data';

  @override
  String get importDataDesc =>
      'Pagsamahin ang isang backup na file sa CopyClip';

  @override
  String get notificationPermissionDenied =>
      'Tinanggihan ang pahintulot sa pag-abiso.';

  @override
  String get typeNewTask => 'Mag-type ng bagong gawain...';

  @override
  String get addTask => 'Magdagdag ng gawain';

  @override
  String get completed => 'Nakumpleto';

  @override
  String get moveTasksToRecycleBin =>
      'Ilipat ang lahat ng aktibong gawain sa Recycle Bin?';

  @override
  String fileNotFoundError(Object path) {
    return 'Error: Hindi nakita ang file sa $path';
  }

  @override
  String get entryCopied => 'Kinopya ang entry';

  @override
  String get moveEntriesToRecycleBin =>
      'Ilipat ang lahat ng aktibong entry sa Recycle Bin?';

  @override
  String get startWritingStory => 'Simulan ang pagsulat ng iyong kwento';

  @override
  String get recordMemories =>
      'Itala ang iyong pang-araw-araw na alaala at damdamin.';

  @override
  String get writeJournal => 'Sumulat ng Journal';

  @override
  String get myMemories => 'Aking Mga Alaala';

  @override
  String get sortJournal => 'Pagbukud-bukurin Journal';

  @override
  String get byMood => 'Sa pamamagitan ng Mood';

  @override
  String get searchMemories => 'Maghanap ng mga alaala...';

  @override
  String get selectAll => 'Piliin ang Lahat';

  @override
  String get deleteSelected => 'Tanggalin ang Napili';

  @override
  String get taskCompletedExclamation => 'Nakumpleto ang gawain!';

  @override
  String get taskUncompletedExclamation => 'Hindi natapos ang gawain';

  @override
  String get clipboardUpdatedExclamation => 'Na-update ang clipboard!';

  @override
  String clipboardSavedContent(Object content) {
    return 'Na-save ang clipboard: $content';
  }

  @override
  String get overview => 'Pangkalahatang-ideya';

  @override
  String get colorAurora => 'Aurora';

  @override
  String get colorCosmic => 'Cosmic';

  @override
  String get colorNebula => 'Nebula';

  @override
  String get colorStarlight => 'Liwanag ng bituin';

  @override
  String get colorSolar => 'Solar';

  @override
  String get colorNova => 'Bago';

  @override
  String get loadingStepLoading => 'Naglo-load...';

  @override
  String get loadingStepDatabase => 'Pagse-set up ng database...';

  @override
  String get loadingStepSystem => 'Kino-configure ang system...';

  @override
  String get loadingStepReady => 'handa na';

  @override
  String get productivityCompanion => 'Ang iyong kasama sa pagiging produktibo';

  @override
  String get done => 'Tapos na';

  @override
  String get newNote => 'Bagong Tala';

  @override
  String get changeColor => 'Baguhin ang Kulay';

  @override
  String get copyContent => 'Kopyahin ang Nilalaman';

  @override
  String get titleOptional => 'Pamagat (Opsyonal)';

  @override
  String get exportAsPdf => 'I-export bilang PDF';

  @override
  String get taskDueNow => 'Nakatakdang Gawain Ngayon';

  @override
  String get moveTaskToBinTitle => 'Ilipat ang Gawain sa Recycle Bin?';

  @override
  String get restoreTaskLater =>
      'Maaari mong ibalik ang gawaing ito sa ibang pagkakataon mula sa mga setting.';

  @override
  String get newTask => 'Bagong Gawain';

  @override
  String get editTask => 'I-edit ang Gawain';

  @override
  String get undo => 'I-undo';

  @override
  String get redo => 'Gawin muli';

  @override
  String get category => 'Kategorya';

  @override
  String get categoryHint => 'hal. Trabaho, Gym';

  @override
  String get whatNeedsToBeDone => 'Ano ang kailangang gawin?';

  @override
  String get enterTaskDetails => 'Ilagay ang mga detalye ng gawain...';

  @override
  String get setDueDate => 'Itakda ang Takdang Petsa';

  @override
  String get dueDate => 'Dalawang Petsa';

  @override
  String get sortAndFilter => 'Pagbukud-bukurin at Salain';

  @override
  String get sortBy => 'PAGSAY-BAYIN NG';

  @override
  String get categories => 'Mga kategorya';

  @override
  String get all => 'Lahat';

  @override
  String get reset => 'I-reset';

  @override
  String get apply => 'Mag-apply';

  @override
  String errorLoadingData(String error) {
    return 'Error sa paglo-load ng data.\n\n$error';
  }

  @override
  String get dailyQuote1 =>
      'Ang pinakamahusay na paraan upang mahulaan ang hinaharap ay ang paglikha nito.';

  @override
  String get dailyQuote2 =>
      'Ang kayamanan ay hindi binubuo sa pagkakaroon ng malalaking ari-arian, ngunit sa pagkakaroon ng kaunting mga pangangailangan.';

  @override
  String get dailyQuote3 => 'Ang oras ay ang tunay na pera.';

  @override
  String get dailyQuote4 =>
      'Ang tagumpay ay hindi pangwakas, ang kabiguan ay hindi nakamamatay.';

  @override
  String get dailyQuote5 => 'Tumutok sa solusyon, hindi sa problema.';

  @override
  String get dailyQuote6 => 'Ang iyong network ay ang iyong net worth.';

  @override
  String get moodHappy => 'Masaya';

  @override
  String get moodExcited => 'Excited';

  @override
  String get moodNeutral => 'Neutral';

  @override
  String get moodSad => 'Malungkot';

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
    return 'PAMAGAT: $title';
  }

  @override
  String exportTags(String tags) {
    return 'Mga Tag: $tags';
  }

  @override
  String get noResultsFound => 'Walang nakitang resulta';

  @override
  String get noItems => 'Walang item';

  @override
  String get rename => 'Palitan ang pangalan';

  @override
  String get deleteFolder => 'Tanggalin ang Folder';

  @override
  String get deleteSketchesQuestion => 'Tanggalin ang mga Sketch?';

  @override
  String get deleteFolderConfirmation =>
      'Ang lahat ng sketch sa folder na ito ay permanenteng tatanggalin.';

  @override
  String get chooseColor => 'Pumili ng Kulay';

  @override
  String get searchClips => 'Maghanap ng mga clip...';

  @override
  String get clipboardEmpty => 'Walang laman ang clipboard';

  @override
  String get addItem => 'Magdagdag ng Item';

  @override
  String get clipColor => 'Kulay ng Clip';

  @override
  String get newClip => 'Bagong Clip';

  @override
  String get editClip => 'I-edit ang Clip';

  @override
  String get restoreClipLater =>
      'Maaari mong ibalik ang clip na ito sa ibang pagkakataon.';

  @override
  String get dataDistribution => 'PAGBABIGAY NG DATOS';

  @override
  String get taskProgress => 'PAG-UNLAD NG GAWAIN';

  @override
  String get quickStats => 'MABILIS NA STATS';

  @override
  String get taskCompletion => 'Pagkumpleto ng Gawain';

  @override
  String get noItemsForDate => 'Walang mga item para sa petsang ito';

  @override
  String get enjoyFreeTime => 'Masiyahan sa iyong libreng oras!';

  @override
  String get searchThisDay => 'Maghanap sa araw na ito...';

  @override
  String get finance => 'Pananalapi';

  @override
  String get permanentlyDelete => 'Permanenteng Tanggalin?';

  @override
  String deleteSelectionConfirmation(int foldersCount, int sketchesCount) {
    return 'Permanente nitong tatanggalin ang $foldersCount na mga folder (at ang kanilang mga sketch) at $sketchesCount iba pang mga sketch.\n\nHindi na ito maaaring bawiin.';
  }

  @override
  String get deleteForever => 'Tanggalin ang Magpakailanman';

  @override
  String selectedCount(int count) {
    return '$count Napili';
  }

  @override
  String get deleteItemQuestion => 'Tanggalin ang Item?';

  @override
  String get deleteItemConfirmation => 'Ililipat nito ang item sa recycle bin.';

  @override
  String get moveToBinItem => 'Lumipat sa Bin?';

  @override
  String get moveToBinConfirmation =>
      'Maaari mo itong ibalik sa ibang pagkakataon.';

  @override
  String selectedItems(int count) {
    return '$count Napili';
  }

  @override
  String get recentClips => 'Mga Kamakailang Clip';

  @override
  String get copied => 'Kinopya!';

  @override
  String get copiedPlainText => 'Kinopya ang plain text';

  @override
  String get clipTheme => 'Tema ng Clip';

  @override
  String get justNow => 'Ngayon lang';

  @override
  String minutesAgo(Object count) {
    return '${count}m ang nakalipas';
  }

  @override
  String hoursAgo(Object count) {
    return '${count}h ang nakalipas';
  }

  @override
  String daysAgo(Object count) {
    return '${count}d ang nakalipas';
  }

  @override
  String get noTasksFound => 'Walang nakitang gawain.';

  @override
  String get searchTasks => 'Maghanap ng mga gawain...';

  @override
  String get taskReminder => 'Paalala sa Gawain';

  @override
  String get untitledNote => 'Walang Pamagat na Tala';

  @override
  String get dailyEntry => 'Araw-araw na Pagpasok';

  @override
  String get clipboardHistory => 'Kasaysayan ng Clipboard';

  @override
  String get deletePermanentlyContent =>
      'Ang pagkilos na ito ay hindi maaaring i-undo.';

  @override
  String get emptyRecycleBinTitle => 'Walang laman ang Recycle Bin?';

  @override
  String emptyRecycleBinContent(Object count) {
    return 'Lahat ng $count item ay permanenteng tatanggalin.';
  }

  @override
  String get emptyBin => 'Walang laman na Bin';

  @override
  String get recycleBinEmpty => 'Walang laman ang Recycle Bin';

  @override
  String get deletedItemsAppearHere =>
      'Lalabas dito ang mga tinanggal na item.';

  @override
  String get empty => 'Walang laman';

  @override
  String get recent => 'Kamakailan';

  @override
  String categoryLabel(Object category) {
    return 'Kategorya: $category';
  }

  @override
  String get general => 'Heneral';

  @override
  String get description => 'Paglalarawan';

  @override
  String get daily => 'Araw-araw';

  @override
  String get weekly => 'Linggu-linggo';

  @override
  String get monthly => 'Buwan-buwan';

  @override
  String get yearly => 'Taon-taon';

  @override
  String get analysis => 'Pagsusuri';

  @override
  String get transactions => 'Mga transaksyon';

  @override
  String get ok => 'OK';

  @override
  String get bulkImport => 'Bulk Import';
}
