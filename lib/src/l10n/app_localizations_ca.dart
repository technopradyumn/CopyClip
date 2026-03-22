// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Catalan Valencian (`ca`).
class AppLocalizationsCa extends AppLocalizations {
  AppLocalizationsCa([String locale = 'ca']) : super(locale);

  @override
  String get settings => 'Configuració';

  @override
  String get language => 'Llengua';

  @override
  String get systemDefault => 'Sistema per defecte';

  @override
  String get notes => 'Notes';

  @override
  String get todos => 'Coses pendents';

  @override
  String get expenses => 'Despeses';

  @override
  String get journal => 'Diari';

  @override
  String get calendar => 'Calendari';

  @override
  String get clipboard => 'Porta-retalls';

  @override
  String get canvas => 'Tela';

  @override
  String get save => 'Desa';

  @override
  String get create => 'Crear';

  @override
  String get cancel => 'Cancel·la';

  @override
  String get delete => 'Suprimeix';

  @override
  String get edit => 'Edita';

  @override
  String get share => 'Comparteix';

  @override
  String get copy => 'Còpia';

  @override
  String get unsavedChanges => 'Canvis no desats';

  @override
  String get confirmDelete => 'Confirmeu l\'\'eliminació';

  @override
  String get discard => 'Descartar';

  @override
  String get createPost => 'Crea una publicació';

  @override
  String get post => 'Publicació';

  @override
  String get postingTo => 'Publicació a';

  @override
  String get whatsOnYourMind => 'Què et passa pel cap?';

  @override
  String get pickImages => 'Trieu Imatges';

  @override
  String get pickVideo => 'Trieu el vídeo';

  @override
  String get camera => 'Càmera';

  @override
  String get gallery => 'Galeria';

  @override
  String get search => 'Cerca';

  @override
  String get pleaseEnterTask => 'Introduïu una tasca';

  @override
  String get deleteTask => 'Suprimeix la tasca';

  @override
  String get selectItems => 'Seleccioneu Elements';

  @override
  String get deleteAll => 'Suprimeix-ho tot';

  @override
  String error(Object error) {
    return 'Error: $error';
  }

  @override
  String get orderingOnlyAvailableInAllPosts =>
      'Comandes només disponibles a \"Totes les publicacions\"';

  @override
  String get deletePost => 'Suprimeix la publicació';

  @override
  String get postDeleted => 'Publicació suprimida';

  @override
  String get premiumFeatures => 'Funcions Premium';

  @override
  String get manageCoinsAdsPremium =>
      'Gestioneu les monedes, els anuncis i l\'\'estat premium';

  @override
  String get themeMode => 'Mode de tema';

  @override
  String get accentColor => 'Color d\'\'accent';

  @override
  String get backgroundDesign => 'Disseny de fons';

  @override
  String get pushNotifications => 'Notificacions push';

  @override
  String get recycleBin => 'Paperera de reciclatge';

  @override
  String get exportData => 'Exporta dades';

  @override
  String get importData => 'Importa dades';

  @override
  String get rateApp => 'Valora l\'\'aplicació';

  @override
  String get sendFeedback => 'Enviar comentaris';

  @override
  String get privacyPolicy => 'Política de privadesa';

  @override
  String get version => 'Versió';

  @override
  String get buildNumber => 'Número de compilació';

  @override
  String get system => 'Sistema';

  @override
  String get light => 'Llum';

  @override
  String get dark => 'Fosc';

  @override
  String get itemRestored => 'Element restaurat';

  @override
  String get recycleBinCleared =>
      'La paperera de reciclatge s\'\'ha esborrat correctament';

  @override
  String get allPostsDeleted => 'S\'\'han suprimit totes les publicacions';

  @override
  String get newPost => 'Publicació nova';

  @override
  String get textCopiedToClipboardFacebook =>
      'Text copiat al porta-retalls (política de Facebook)';

  @override
  String get tiktokSharingRequiresVideoImage =>
      'Per compartir TikTok cal un vídeo/imatge';

  @override
  String errorSharing(Object error) {
    return 'Error en compartir: $error';
  }

  @override
  String shareToStory(Object platform) {
    return 'Comparteix a $platform Story';
  }

  @override
  String shareToFeed(Object platform) {
    return 'Comparteix al feed $platform';
  }

  @override
  String get unlockPermanently => 'Desbloqueja permanentment';

  @override
  String get notEnoughCoins => 'No hi ha prou monedes!';

  @override
  String youEarnedCoins(Object amount) {
    return 'Has guanyat $amount monedes!';
  }

  @override
  String get contentCopied => 'Contingut copiat';

  @override
  String get selectDateTime => 'Seleccioneu Data i hora';

  @override
  String get areYouSureYouWantToDeleteThisPost =>
      'Esteu segur que voleu suprimir aquesta publicació?';

  @override
  String get socialPosts => 'Publicacions socials';

  @override
  String get watchAdToEarnCoins => 'Mira l\'\'anunci per guanyar monedes';

  @override
  String get premiumUnlocked => 'Premium desbloquejat';

  @override
  String get removeAds => 'Elimina els anuncis';

  @override
  String get unlimitedCloudStorage => 'Emmagatzematge al núvol il·limitat';

  @override
  String get deleteNote => 'Suprimeix la nota';

  @override
  String get shareNote => 'Comparteix la nota';

  @override
  String get editNote => 'Edita la nota';

  @override
  String get searchNotes => 'Cerca notes...';

  @override
  String get noNotesFound => 'No s\'\'han trobat notes';

  @override
  String get captureThoughts => 'Captura els teus pensaments a l\'\'instant.';

  @override
  String get createNote => 'Crea una nota';

  @override
  String get customOrder => 'Comanda personalitzada';

  @override
  String get newestFirst => 'El més nou primer';

  @override
  String get oldestFirst => 'El més vell primer';

  @override
  String get titleAZ => 'Títol: A-Z';

  @override
  String get titleZA => 'Títol: Z-A';

  @override
  String get deleteAllQuestion => 'Vols suprimir-ho tot?';

  @override
  String get moveToRecycleBin =>
      'Voleu moure totes les notes a la paperera de reciclatge?';

  @override
  String get moveToBinQuestion => 'Vols moure\'\'t a la safata?';

  @override
  String get restoreNoteLater => 'Podeu restaurar aquesta nota més tard.';

  @override
  String get move => 'Mou-te';

  @override
  String get myThoughts => 'Els meus pensaments';

  @override
  String get selected => 'Seleccionat';

  @override
  String get noContent => 'Sense contingut';

  @override
  String get untitled => 'Sense títol';

  @override
  String get chooseWallpapers =>
      'Trieu entre més de 10 fons de pantalla dinàmics';

  @override
  String get backupData => 'Còpia de seguretat de dades';

  @override
  String get saveJsonFile =>
      'Vols desar un fitxer JSON que conté totes les teves dades?';

  @override
  String get exportNow => 'Exporta ara';

  @override
  String get importDataTitle => 'Importa dades';

  @override
  String get mergeBackupFile =>
      'Voleu combinar un fitxer de còpia de seguretat amb els vostres elements actuals?';

  @override
  String get selectFile => 'Seleccioneu Fitxer';

  @override
  String get backupSaved => 'Còpia de seguretat desada correctament!';

  @override
  String get exportFailed => 'Ha fallat l\'\'exportació.';

  @override
  String importSuccess(Object count) {
    return 'S\'\'han restaurat $count elements correctament!';
  }

  @override
  String get importFailed => 'La importació ha fallat.';

  @override
  String widgetAdded(String widget) {
    return 'S\'\'ha afegit un widget a la pantalla d\'\'inici!';
  }

  @override
  String get widgetRequestSent =>
      'S\'\'ha enviat una sol·licitud de widget. Si us plau, comproveu la vostra pantalla d\'\'inici.';

  @override
  String get widgetAddFailed => 'No s\'\'ha pogut afegir el widget';

  @override
  String get autoSaveEnabled => 'Desat automàtic activat.';

  @override
  String get autoSaveDisabled => 'Desa automàticament desactivat.';

  @override
  String get homeScreenWidgets => 'Ginys de la pantalla d\'\'inici';

  @override
  String get notificationsTitle => 'Notificacions';

  @override
  String get dataBackup => 'Dades i còpia de seguretat';

  @override
  String get feedbackSupport => 'Suport i comentaris';

  @override
  String get creditsTitle => 'Crèdits';

  @override
  String get privacyMaintenance => 'Privacitat i manteniment';

  @override
  String get aboutTitle => 'Sobre';

  @override
  String get premium => 'Premium';

  @override
  String get appearanceTitle => 'Aparença';

  @override
  String get clipboardTitle => 'Porta-retalls';

  @override
  String get settingsSubtitle => 'Personalitza la teva experiència';

  @override
  String get welcomeTitle => 'Benvingut a CopyClip';

  @override
  String get welcomeDescription =>
      'El vostre millor company de productivitat. Us oferim eines potents per gestionar el vostre dia.';

  @override
  String get onboardingNotesTitle => 'Notes intel·ligents';

  @override
  String get onboardingNotesDesc =>
      'Captura idees a l\'\'instant amb el format de text enriquit. Organitza els teus pensaments i no perdis mai més una gran idea.';

  @override
  String get onboardingTodosTitle => 'Gestió de tasques';

  @override
  String get onboardingTodosDesc =>
      'Manteniu-vos al capdavant del vostre joc. Creeu llistes de tasques pendents, establiu prioritats i aixafeu els vostres objectius marca per marca.';

  @override
  String get onboardingExpensesTitle => 'Seguiment de despeses';

  @override
  String get onboardingExpensesDesc =>
      'Preneu el control de les vostres finances. Feu un seguiment dels ingressos i les despeses fàcilment per entendre els vostres hàbits de despesa.';

  @override
  String get onboardingJournalTitle => 'Diari personal';

  @override
  String get onboardingJournalDesc =>
      'Reflexiona sobre el teu dia. Un espai privat per escriure els teus records, sentiments i experiències diàries.';

  @override
  String get onboardingCalendarTitle => 'Calendari i esdeveniments';

  @override
  String get onboardingCalendarDesc =>
      'No et perdis ni un moment. Organitzeu la vostra agenda i feu un seguiment dels propers esdeveniments importants.';

  @override
  String get onboardingClipboardTitle => 'Gestor de porta-retalls';

  @override
  String get onboardingClipboardDesc =>
      'Copia una vegada, enganxa a qualsevol lloc. Accediu al vostre historial del porta-retalls per recuperar fragments que heu copiat anteriorment.';

  @override
  String get onboardingCanvasTitle => 'Tela Creativa';

  @override
  String get onboardingCanvasDesc =>
      'Deixa anar la teva creativitat. Dibuixa, dibuixa i visualitza les teves idees en un llenç digital de forma lliure.';

  @override
  String get featuresNotesDesc => 'Crea i gestiona les teves notes';

  @override
  String get featuresTodosDesc => 'Feu un seguiment de les vostres tasques';

  @override
  String get featuresExpensesDesc => 'Superviseu les vostres despeses';

  @override
  String get featuresJournalDesc => 'Escriu els teus pensaments';

  @override
  String get featuresCalendarDesc => 'Organitza el teu horari';

  @override
  String get featuresClipboardDesc =>
      'Accediu al vostre historial del porta-retalls';

  @override
  String get featuresCanvasDesc => 'Dibuixa i dibuixa lliurement';

  @override
  String get featuresSocialPost => 'Post social';

  @override
  String get featuresSocialPostDesc =>
      'Crea contingut atractiu a les xarxes socials';

  @override
  String get chooseYourAura => 'Tria la teva aura';

  @override
  String get expressYourselfTheme => 'Expressa\'\'t amb un nou color temàtic!';

  @override
  String get level => 'Nivell';

  @override
  String get xpToNextLevel => 'XP a nivell';

  @override
  String get checkUpcomingEvents => 'Consulta els propers esdeveniments';

  @override
  String get startNewSketch => 'Comença un nou esbós';

  @override
  String get noTransactionsMonth => 'No hi ha transaccions aquest mes';

  @override
  String transactionsThisMonth(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 's',
      one: '',
    );
    return '$count transacció$_temp0 aquest mes';
  }

  @override
  String get autoSaveClipboard => 'Desa automàticament el porta-retalls';

  @override
  String get autoSaveClipboardDesc =>
      'Desa automàticament els elements copiats';

  @override
  String get permissionDeniedSettings =>
      'Permís denegat permanentment. Si us plau, activeu-lo a Configuració.';

  @override
  String get notificationsEnabled => 'Notificacions activades!';

  @override
  String get redirectingToSettings =>
      'S\'\'està redirigint a la configuració per desactivar les notificacions...';

  @override
  String get premiumAccess => 'Accés Premium';

  @override
  String get premiumActiveUntil => 'Premium actiu fins a';

  @override
  String get unlockAllFeatures => 'Desbloqueja totes les funcions';

  @override
  String get buyPremium => 'Compra Premium (7 dies)';

  @override
  String costCoins(Object cost) {
    return 'Cost: $cost monedes';
  }

  @override
  String get premiumActivated => 'Premium activat durant 7 dies!';

  @override
  String get premiumActive => 'Premium Active';

  @override
  String get expires => 'Caduca:';

  @override
  String get temporaryAccess => 'Accés temporal';

  @override
  String get journalExpression => 'Diari i expressió';

  @override
  String get artisticDesigns => 'Dissenys Artístics';

  @override
  String get artisticDesignsDesc =>
      'Desbloqueja més de 10 temes de targetes de diari únics';

  @override
  String get premiumLayouts => 'Dissenys Premium';

  @override
  String get premiumLayoutsDesc =>
      'Maneres exclusives de veure els teus records';

  @override
  String get calendarTools => 'Calendari i eines';

  @override
  String get fullCalendar => 'Calendari complet';

  @override
  String get fullCalendarDesc => 'Sistema complet de gestió d\'\'esdeveniments';

  @override
  String get clipboardAutoSaveDesc =>
      'Captura de fons de l\'\'historial del porta-retalls';

  @override
  String get proWidgets => 'Ginys professionals';

  @override
  String get proWidgetsDesc =>
      'Totes les funcions disponibles a la pantalla d\'\'inici';

  @override
  String get dataExport => 'Dades i exportació';

  @override
  String get advancedBackup => 'Còpia de seguretat avançada';

  @override
  String get advancedBackupDesc =>
      'Importació/exportació segura de totes les dades';

  @override
  String get pdfExport => 'Exportació PDF';

  @override
  String get pdfExportDesc => 'Exporta notes i revistes a PDF';

  @override
  String get printReady => 'A punt per imprimir';

  @override
  String get printReadyDesc => 'Suport d\'\'impressió directa';

  @override
  String get richTextEditor => 'Editor de text enriquit';

  @override
  String get advancedSearch => 'Cerca avançada';

  @override
  String get advancedSearchDesc => 'Cerca i substitueix dins del teu text';

  @override
  String get richMedia => 'Rich Media';

  @override
  String get richMediaDesc => 'Insereix imatges, vídeos i enllaços';

  @override
  String get editorStyling => 'Editor d\'\'estil';

  @override
  String get editorStylingDesc => 'Text personalitzat i fons de l\'\'editor';

  @override
  String get balance => 'Balanç';

  @override
  String get loadingAd => 'S\'\'està carregant l\'\'anunci...';

  @override
  String watchAd(Object amount) {
    return 'Mira l\'\'anunci (+$amount)';
  }

  @override
  String get loadAd => 'Carrega l\'\'anunci';

  @override
  String get backupDataDesc => 'Deseu un fitxer JSON de les vostres dades';

  @override
  String get importDataDesc =>
      'Combina un fitxer de còpia de seguretat a CopyClip';

  @override
  String get notificationPermissionDenied =>
      'S\'\'ha denegat el permís de notificació.';

  @override
  String get typeNewTask => 'Escriu una tasca nova...';

  @override
  String get addTask => 'Afegeix una tasca';

  @override
  String get completed => 'Completat';

  @override
  String get greatJob => 'Gran feina!';

  @override
  String youEarnedXPNextTask(Object amount, Object date) {
    return 'Has guanyat $amount XP! Següent tasca: $date';
  }

  @override
  String taskCompletedXP(Object amount) {
    return 'Tasca completada! +$amount XP';
  }

  @override
  String get moveTasksToRecycleBin =>
      'Voleu moure totes les tasques actives a la Paperera de reciclatge?';

  @override
  String get deleteAllPosts => 'Suprimeix totes les publicacions';

  @override
  String get deleteAllPostsConfirmation =>
      'Confirmes que vols suprimir TOTES les publicacions socials? Això no es pot desfer.';

  @override
  String get allPosts => 'Totes les publicacions';

  @override
  String get favorites => 'Preferits';

  @override
  String get drafts => 'Esborranys';

  @override
  String get noFavoritesYet => 'Encara no hi ha cap favorit';

  @override
  String get noDraftsYet => 'Encara no hi ha esborranys';

  @override
  String get startSocialJourney => 'Comença el teu viatge social!';

  @override
  String get draft => 'PROJECTE';

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
      'Si us plau, afegiu contingut o contingut multimèdia per compartir';

  @override
  String fileNotFoundError(Object path) {
    return 'Error: no s\'\'ha trobat el fitxer a $path';
  }

  @override
  String get checkFacebookApp => 'Comproveu l\'\'aplicació de Facebook';

  @override
  String get systemShare => 'Compartició del sistema';

  @override
  String get socialPost => 'Post social';

  @override
  String get favorite => 'Favorit';

  @override
  String get saveDraft => 'Desa l\'\'esborrany';

  @override
  String get entryCopied => 'S\'\'ha copiat l\'\'entrada';

  @override
  String get moveEntriesToRecycleBin =>
      'Voleu moure totes les entrades actives a la paperera de reciclatge?';

  @override
  String get startWritingStory => 'Comença a escriure la teva història';

  @override
  String get recordMemories =>
      'Enregistreu els vostres records i sentiments diaris.';

  @override
  String get writeJournal => 'Escriu un diari';

  @override
  String get myMemories => 'Els meus records';

  @override
  String get sortJournal => 'Ordena el diari';

  @override
  String get byMood => 'Per estat d\'\'ànim';

  @override
  String get searchMemories => 'Cerca records...';

  @override
  String get selectAll => 'Seleccioneu Tot';

  @override
  String get deleteSelected => 'Suprimeix el seleccionat';

  @override
  String get taskCompletedExclamation => 'Tasca completada!';

  @override
  String get taskUncompletedExclamation => 'Tasca no completada';

  @override
  String get clipboardUpdatedExclamation => 'Porta-retalls actualitzat!';

  @override
  String clipboardSavedContent(Object content) {
    return 'Porta-retalls desat: $content';
  }

  @override
  String get overview => 'Visió general';

  @override
  String get colorAurora => 'Aurora';

  @override
  String get colorCosmic => 'Còsmic';

  @override
  String get colorNebula => 'Nebulosa';

  @override
  String get colorStarlight => 'Llum de les estrelles';

  @override
  String get colorSolar => 'Solar';

  @override
  String get colorNova => 'Nova';

  @override
  String get loadingStepLoading => 'Carregant...';

  @override
  String get loadingStepDatabase => 'S\'\'està configurant la base de dades...';

  @override
  String get loadingStepSystem => 'S\'\'està configurant el sistema...';

  @override
  String get loadingStepReady => 'A punt';

  @override
  String get productivityCompanion => 'El teu company de productivitat';

  @override
  String get done => 'Fet';

  @override
  String get newNote => 'Nova nota';

  @override
  String get changeColor => 'Canvia el color';

  @override
  String get copyContent => 'Copia contingut';

  @override
  String get titleOptional => 'Títol (opcional)';

  @override
  String get exportAsPdf => 'Exporta com a PDF';

  @override
  String get taskDueNow => 'Tasca pendent ara';

  @override
  String get moveTaskToBinTitle =>
      'Voleu moure la tasca a la paperera de reciclatge?';

  @override
  String get restoreTaskLater =>
      'Podeu restaurar aquesta tasca més tard des de la configuració.';

  @override
  String get newTask => 'Nova tasca';

  @override
  String get editTask => 'Edita la tasca';

  @override
  String get undo => 'Desfer';

  @override
  String get redo => 'Refer';

  @override
  String get category => 'Categoria';

  @override
  String get categoryHint => 'p. ex. Treball, Gimnàs';

  @override
  String get whatNeedsToBeDone => 'Què cal fer?';

  @override
  String get enterTaskDetails => 'Introduïu els detalls de la tasca...';

  @override
  String get setDueDate => 'Estableix la data de venciment';

  @override
  String get dueDate => 'Dues Cites';

  @override
  String get expenseTitle => 'Despeses';

  @override
  String searchInCurrency(String currency) {
    return 'Cerca en $currency...';
  }

  @override
  String get sortAndFilter => 'Ordena i filtra';

  @override
  String get sortBy => 'CLASIFICAR PER';

  @override
  String get highestAmount => 'Quantitat més alta';

  @override
  String get lowestAmount => 'Quantitat més baixa';

  @override
  String get moreFilters => 'Més filtres...';

  @override
  String get filterExpenses => 'Filtre les despeses';

  @override
  String get transactionType => 'Tipus de transacció';

  @override
  String get categories => 'Categories';

  @override
  String get all => 'Tots';

  @override
  String get income => 'Ingressos';

  @override
  String get expense => 'Despesa';

  @override
  String get reset => 'Restableix';

  @override
  String get apply => 'Aplicar';

  @override
  String newExpense(String currency) {
    return 'Nova $currency';
  }

  @override
  String errorLoadingData(String error) {
    return 'S\'\'ha produït un error en carregar les dades.\n\n$error';
  }

  @override
  String get dailyQuote1 => 'La millor manera de predir el futur és crear-lo.';

  @override
  String get dailyQuote2 =>
      'La riquesa no consisteix en tenir grans possessions, sinó en tenir poques necessitats.';

  @override
  String get dailyQuote3 => 'El temps és la moneda definitiva.';

  @override
  String get dailyQuote4 => 'L\'\'èxit no és definitiu, el fracàs no és fatal.';

  @override
  String get dailyQuote5 => 'Centra\'\'t en la solució, no en el problema.';

  @override
  String get dailyQuote6 => 'La vostra xarxa és el vostre valor net.';

  @override
  String get moodHappy => 'Feliç';

  @override
  String get moodExcited => 'Emocionat';

  @override
  String get moodNeutral => 'Neutre';

  @override
  String get moodSad => 'Trist';

  @override
  String get moodStressed => 'Estrès';

  @override
  String exportDate(String date) {
    return '📅 $date';
  }

  @override
  String exportMood(String emoji, String mood) {
    return 'Estat d\'\'ànim: $emoji $mood';
  }

  @override
  String exportTitle(String title) {
    return 'TÍTOL: $title';
  }

  @override
  String exportTags(String tags) {
    return 'Etiquetes: $tags';
  }

  @override
  String get instagram => 'Instagram';

  @override
  String get facebook => 'Facebook';

  @override
  String get tiktok => 'TikTok';

  @override
  String get newSketch => 'Esbós nou';

  @override
  String get searchSketches => 'Cerca esbossos i carpetes...';

  @override
  String get noResultsFound => 'No s\'\'han trobat resultats';

  @override
  String get noItems => 'No hi ha articles';

  @override
  String get noDrawingsYet => 'Encara no hi ha dibuixos';

  @override
  String get canvasIntro => 'Deixa anar la teva creativitat al llenç!';

  @override
  String get newCanvas => 'Nou Canvas';

  @override
  String get rename => 'Canvia el nom';

  @override
  String get deleteFolder => 'Suprimeix la carpeta';

  @override
  String get deleteSketchesQuestion => 'Vols suprimir esbossos?';

  @override
  String get deleteFolderConfirmation =>
      'Tots els esbossos d\'\'aquesta carpeta se suprimiran permanentment.';

  @override
  String get renameFolder => 'Canvia el nom de la carpeta';

  @override
  String get chooseColor => 'Trieu Color';

  @override
  String get deleteFolderQuestion => 'Vols suprimir la carpeta?';

  @override
  String get searchClips => 'Cerca clips...';

  @override
  String get clipboardEmpty => 'El porta-retalls està buit';

  @override
  String get addItem => 'Afegeix un element';

  @override
  String get clipColor => 'Color del clip';

  @override
  String get newClip => 'Clip nou';

  @override
  String get editClip => 'Edita el clip';

  @override
  String get restoreClipLater => 'Pots restaurar aquest clip més tard.';

  @override
  String get upcomingEvents => 'Pròxims Esdeveniments';

  @override
  String get dataDistribution => 'DISTRIBUCIÓ DE DADES';

  @override
  String get taskProgress => 'PROGRÉS DE LA TASCA';

  @override
  String get quickStats => 'ESTADÍSTIQUES RÀPIDES';

  @override
  String get taskCompletion => 'Finalització de la tasca';

  @override
  String get noItemsForDate => 'No hi ha articles per a aquesta data';

  @override
  String get enjoyFreeTime => 'Gaudeix del teu temps lliure!';

  @override
  String get searchThisDay => 'Busca en aquest dia...';

  @override
  String get finance => 'Finances';

  @override
  String get permanentlyDelete => 'Vols suprimir definitivament?';

  @override
  String deleteSelectionConfirmation(int foldersCount, int sketchesCount) {
    return 'Això suprimirà permanentment $foldersCount carpetes (i els seus esbossos) i $sketchesCount altres esbossos.\n\nAixò no es pot desfer.';
  }

  @override
  String get deleteForever => 'Suprimeix per sempre';

  @override
  String selectedCount(int count) {
    return '$count seleccionat';
  }

  @override
  String canvasStats(int notes, int folders) {
    return '$notes esbossos • $folders carpetes';
  }

  @override
  String get sortItems => 'Ordena els elements';

  @override
  String get sortNameAZ => 'Nom (A-Z)';

  @override
  String get sortNameZA => 'Nom (Z-A)';

  @override
  String get createFolder => 'Crea una carpeta';

  @override
  String get folderNameHint => 'Nom de la carpeta...';

  @override
  String deleteSketchesConfirmation(int count) {
    return 'Vols suprimir $count esbossos? Això no es pot desfer.';
  }

  @override
  String get noSketchesFound => 'No s\'\'han trobat esbossos';

  @override
  String get noSketchesFoundSub =>
      'Proveu d\'\'ajustar la cerca o de crear un esbós nou.';

  @override
  String searchInFolder(String folder) {
    return 'Cerca a $folder...';
  }

  @override
  String sketchesCount(int count) {
    return '$count esbossos';
  }

  @override
  String get sortSketches => 'Ordenar esbossos';

  @override
  String get calendarScreenTitle => 'Calendari';

  @override
  String get dailyActivity => 'Activitat diària';

  @override
  String get deleteItemQuestion => 'Vols suprimir l\'\'element?';

  @override
  String get deleteItemConfirmation =>
      'Això traslladarà l\'\'element a la paperera de reciclatge.';

  @override
  String get moveToBinItem => 'Vols moure\'\'t a la safata?';

  @override
  String get moveToBinConfirmation => 'Podeu restaurar-lo més tard.';

  @override
  String selectedItems(int count) {
    return '$count seleccionat';
  }

  @override
  String get recentClips => 'Clips recents';

  @override
  String get copied => 'Copiat!';

  @override
  String get copiedPlainText => 'Text sense format copiat';

  @override
  String get clipTheme => 'Tema del clip';

  @override
  String get justNow => 'Just ara';

  @override
  String minutesAgo(Object count) {
    return 'fa $count m';
  }

  @override
  String hoursAgo(Object count) {
    return 'fa $count h';
  }

  @override
  String daysAgo(Object count) {
    return 'fa $count dies';
  }

  @override
  String get noTasksFound => 'No s\'\'han trobat tasques.';

  @override
  String get searchTasks => 'Cerca tasques...';

  @override
  String get taskReminder => 'Recordatori de tasques';

  @override
  String get untitledNote => 'Nota sense títol';

  @override
  String get dailyEntry => 'Entrada diària';

  @override
  String get clipboardHistory => 'Historial del porta-retalls';

  @override
  String get deletePermanentlyContent => 'Aquesta acció no es pot desfer.';

  @override
  String get emptyRecycleBinTitle => 'Voleu la paperera de reciclatge?';

  @override
  String emptyRecycleBinContent(Object count) {
    return 'Tots els $count elements se suprimiran permanentment.';
  }

  @override
  String get emptyBin => 'Paperera buida';

  @override
  String get recycleBinEmpty => 'La paperera de reciclatge està buida';

  @override
  String get deletedItemsAppearHere =>
      'Els elements suprimits apareixeran aquí.';

  @override
  String get empty => 'Buit';

  @override
  String get recent => 'Recent';

  @override
  String categoryLabel(Object category) {
    return 'Categoria: $category';
  }

  @override
  String get general => 'General';

  @override
  String get saveTransactionQuestion => 'Vols desar aquesta transacció?';

  @override
  String get fillTitleAmount => 'Si us plau, empleneu el títol i l\'\'import';

  @override
  String get invalidAmount => 'Format d\'\'import no vàlid';

  @override
  String get moveTransactionToBinTitle =>
      'Voleu moure la transacció a la paperera de reciclatge?';

  @override
  String get restoreTransactionLater =>
      'Pots restaurar aquesta transacció més tard des de la configuració.';

  @override
  String get newTransaction => 'Nova transacció';

  @override
  String get whatIsThisFor => 'Per a què serveix això?';

  @override
  String get description => 'Descripció';

  @override
  String get daily => 'Diàriament';

  @override
  String get weekly => 'Setmanalment';

  @override
  String get monthly => 'Mensualment';

  @override
  String get yearly => 'Anualment';

  @override
  String get totalIncome => 'Ingressos totals';

  @override
  String get totalExpense => 'Despesa total';

  @override
  String get analysis => 'Anàlisi';

  @override
  String get transactions => 'Transaccions';

  @override
  String get noExpensesFound =>
      'No s\'\'han trobat despeses per a aquest període.';

  @override
  String get netBalance => 'Saldo Net';

  @override
  String get topCategories => 'Categories principals';

  @override
  String get spendingTrend => 'Tendència de despesa';

  @override
  String get insights => 'Insights';

  @override
  String get noExpensesRecorded => 'No s\'\'han registrat despeses';

  @override
  String get trackSpendingHabits =>
      'Feu un seguiment dels vostres hàbits de despesa fàcilment.';

  @override
  String get addExpense => 'Afegeix despesa';

  @override
  String get noDataForPeriod => 'No hi ha dades per a aquest període';

  @override
  String get budget => 'Pressupost';

  @override
  String get spent => 'Esgotat';

  @override
  String get limit => 'Límit';

  @override
  String get overBudget => 'Per sobre del pressupost!';

  @override
  String remainingBudget(Object percent) {
    return '$percent% restant';
  }

  @override
  String get savingsRate => 'Taxa d\'\'estalvi';

  @override
  String get healthScore => 'Puntuació de salut';

  @override
  String get healthScoreExplanation =>
      'Aquesta puntuació es basa en la teva taxa d\'\'estalvi.\n\n• > 50% estalviat = Excel·lent (100)\n• 0% d\'\'estalvi = Mitjana (50)\n• Despesa > Ingressos = Pobre (<50)';

  @override
  String get ok => 'D\'\'acord';

  @override
  String get bulkImport => 'Bulk Import';
}

/// The translations for Catalan Valencian, as used in Spain (`ca_ES`).
class AppLocalizationsCaEs extends AppLocalizationsCa {
  AppLocalizationsCaEs() : super('ca_ES');

  @override
  String get settings => 'Configuració';

  @override
  String get language => 'Llengua';

  @override
  String get systemDefault => 'Sistema per defecte';

  @override
  String get notes => 'Notes';

  @override
  String get todos => 'Coses pendents';

  @override
  String get expenses => 'Despeses';

  @override
  String get journal => 'Diari';

  @override
  String get calendar => 'Calendari';

  @override
  String get clipboard => 'Porta-retalls';

  @override
  String get canvas => 'Tela';

  @override
  String get save => 'Desa';

  @override
  String get create => 'Crear';

  @override
  String get cancel => 'Cancel·la';

  @override
  String get delete => 'Suprimeix';

  @override
  String get edit => 'Edita';

  @override
  String get share => 'Comparteix';

  @override
  String get copy => 'Còpia';

  @override
  String get unsavedChanges => 'Canvis no desats';

  @override
  String get confirmDelete => 'Confirmeu l\'\'eliminació';

  @override
  String get discard => 'Descartar';

  @override
  String get createPost => 'Crea una publicació';

  @override
  String get post => 'Publicació';

  @override
  String get postingTo => 'Publicació a';

  @override
  String get whatsOnYourMind => 'Què et passa pel cap?';

  @override
  String get pickImages => 'Trieu Imatges';

  @override
  String get pickVideo => 'Trieu el vídeo';

  @override
  String get camera => 'Càmera';

  @override
  String get gallery => 'Galeria';

  @override
  String get search => 'Cerca';

  @override
  String get pleaseEnterTask => 'Introduïu una tasca';

  @override
  String get deleteTask => 'Suprimeix la tasca';

  @override
  String get selectItems => 'Seleccioneu Elements';

  @override
  String get deleteAll => 'Suprimeix-ho tot';

  @override
  String error(Object error) {
    return 'Error: $error';
  }

  @override
  String get orderingOnlyAvailableInAllPosts =>
      'Comandes només disponibles a \"Totes les publicacions\"';

  @override
  String get deletePost => 'Suprimeix la publicació';

  @override
  String get postDeleted => 'Publicació suprimida';

  @override
  String get premiumFeatures => 'Funcions Premium';

  @override
  String get manageCoinsAdsPremium =>
      'Gestioneu les monedes, els anuncis i l\'\'estat premium';

  @override
  String get themeMode => 'Mode de tema';

  @override
  String get accentColor => 'Color d\'\'accent';

  @override
  String get backgroundDesign => 'Disseny de fons';

  @override
  String get pushNotifications => 'Notificacions push';

  @override
  String get recycleBin => 'Paperera de reciclatge';

  @override
  String get exportData => 'Exporta dades';

  @override
  String get importData => 'Importa dades';

  @override
  String get rateApp => 'Valora l\'\'aplicació';

  @override
  String get sendFeedback => 'Enviar comentaris';

  @override
  String get privacyPolicy => 'Política de privadesa';

  @override
  String get version => 'Versió';

  @override
  String get buildNumber => 'Número de compilació';

  @override
  String get system => 'Sistema';

  @override
  String get light => 'Llum';

  @override
  String get dark => 'Fosc';

  @override
  String get itemRestored => 'Element restaurat';

  @override
  String get recycleBinCleared =>
      'La paperera de reciclatge s\'\'ha esborrat correctament';

  @override
  String get allPostsDeleted => 'S\'\'han suprimit totes les publicacions';

  @override
  String get newPost => 'Publicació nova';

  @override
  String get textCopiedToClipboardFacebook =>
      'Text copiat al porta-retalls (política de Facebook)';

  @override
  String get tiktokSharingRequiresVideoImage =>
      'Per compartir TikTok cal un vídeo/imatge';

  @override
  String errorSharing(Object error) {
    return 'Error en compartir: $error';
  }

  @override
  String shareToStory(Object platform) {
    return 'Comparteix a $platform Story';
  }

  @override
  String shareToFeed(Object platform) {
    return 'Comparteix al feed $platform';
  }

  @override
  String get unlockPermanently => 'Desbloqueja permanentment';

  @override
  String get notEnoughCoins => 'No hi ha prou monedes!';

  @override
  String youEarnedCoins(Object amount) {
    return 'Has guanyat $amount monedes!';
  }

  @override
  String get contentCopied => 'Contingut copiat';

  @override
  String get selectDateTime => 'Seleccioneu Data i hora';

  @override
  String get areYouSureYouWantToDeleteThisPost =>
      'Esteu segur que voleu suprimir aquesta publicació?';

  @override
  String get socialPosts => 'Publicacions socials';

  @override
  String get watchAdToEarnCoins => 'Mira l\'\'anunci per guanyar monedes';

  @override
  String get premiumUnlocked => 'Premium desbloquejat';

  @override
  String get removeAds => 'Elimina els anuncis';

  @override
  String get unlimitedCloudStorage => 'Emmagatzematge al núvol il·limitat';

  @override
  String get deleteNote => 'Suprimeix la nota';

  @override
  String get shareNote => 'Comparteix la nota';

  @override
  String get editNote => 'Edita la nota';

  @override
  String get searchNotes => 'Cerca notes...';

  @override
  String get noNotesFound => 'No s\'\'han trobat notes';

  @override
  String get captureThoughts => 'Captura els teus pensaments a l\'\'instant.';

  @override
  String get createNote => 'Crea una nota';

  @override
  String get customOrder => 'Comanda personalitzada';

  @override
  String get newestFirst => 'El més nou primer';

  @override
  String get oldestFirst => 'El més vell primer';

  @override
  String get titleAZ => 'Títol: A-Z';

  @override
  String get titleZA => 'Títol: Z-A';

  @override
  String get deleteAllQuestion => 'Vols suprimir-ho tot?';

  @override
  String get moveToRecycleBin =>
      'Voleu moure totes les notes a la paperera de reciclatge?';

  @override
  String get moveToBinQuestion => 'Vols moure\'\'t a la safata?';

  @override
  String get restoreNoteLater => 'Podeu restaurar aquesta nota més tard.';

  @override
  String get move => 'Mou-te';

  @override
  String get myThoughts => 'Els meus pensaments';

  @override
  String get selected => 'Seleccionat';

  @override
  String get noContent => 'Sense contingut';

  @override
  String get untitled => 'Sense títol';

  @override
  String get chooseWallpapers =>
      'Trieu entre més de 10 fons de pantalla dinàmics';

  @override
  String get backupData => 'Còpia de seguretat de dades';

  @override
  String get saveJsonFile =>
      'Vols desar un fitxer JSON que conté totes les teves dades?';

  @override
  String get exportNow => 'Exporta ara';

  @override
  String get importDataTitle => 'Importa dades';

  @override
  String get mergeBackupFile =>
      'Voleu combinar un fitxer de còpia de seguretat amb els vostres elements actuals?';

  @override
  String get selectFile => 'Seleccioneu Fitxer';

  @override
  String get backupSaved => 'Còpia de seguretat desada correctament!';

  @override
  String get exportFailed => 'Ha fallat l\'\'exportació.';

  @override
  String importSuccess(Object count) {
    return 'S\'\'han restaurat $count elements correctament!';
  }

  @override
  String get importFailed => 'La importació ha fallat.';

  @override
  String widgetAdded(String widget) {
    return 'S\'\'ha afegit un widget a la pantalla d\'\'inici!';
  }

  @override
  String get widgetRequestSent =>
      'S\'\'ha enviat una sol·licitud de widget. Si us plau, comproveu la vostra pantalla d\'\'inici.';

  @override
  String get widgetAddFailed => 'No s\'\'ha pogut afegir el widget';

  @override
  String get autoSaveEnabled => 'Desat automàtic activat.';

  @override
  String get autoSaveDisabled => 'Desa automàticament desactivat.';

  @override
  String get homeScreenWidgets => 'Ginys de la pantalla d\'\'inici';

  @override
  String get notificationsTitle => 'Notificacions';

  @override
  String get dataBackup => 'Dades i còpia de seguretat';

  @override
  String get feedbackSupport => 'Suport i comentaris';

  @override
  String get creditsTitle => 'Crèdits';

  @override
  String get privacyMaintenance => 'Privacitat i manteniment';

  @override
  String get aboutTitle => 'Sobre';

  @override
  String get premium => 'Premium';

  @override
  String get appearanceTitle => 'Aparença';

  @override
  String get clipboardTitle => 'Porta-retalls';

  @override
  String get settingsSubtitle => 'Personalitza la teva experiència';

  @override
  String get welcomeTitle => 'Benvingut a CopyClip';

  @override
  String get welcomeDescription =>
      'El vostre millor company de productivitat. Us oferim eines potents per gestionar el vostre dia.';

  @override
  String get onboardingNotesTitle => 'Notes intel·ligents';

  @override
  String get onboardingNotesDesc =>
      'Captura idees a l\'\'instant amb el format de text enriquit. Organitza els teus pensaments i no perdis mai més una gran idea.';

  @override
  String get onboardingTodosTitle => 'Gestió de tasques';

  @override
  String get onboardingTodosDesc =>
      'Manteniu-vos al capdavant del vostre joc. Creeu llistes de tasques pendents, establiu prioritats i aixafeu els vostres objectius marca per marca.';

  @override
  String get onboardingExpensesTitle => 'Seguiment de despeses';

  @override
  String get onboardingExpensesDesc =>
      'Preneu el control de les vostres finances. Feu un seguiment dels ingressos i les despeses fàcilment per entendre els vostres hàbits de despesa.';

  @override
  String get onboardingJournalTitle => 'Diari personal';

  @override
  String get onboardingJournalDesc =>
      'Reflexiona sobre el teu dia. Un espai privat per escriure els teus records, sentiments i experiències diàries.';

  @override
  String get onboardingCalendarTitle => 'Calendari i esdeveniments';

  @override
  String get onboardingCalendarDesc =>
      'No et perdis ni un moment. Organitzeu la vostra agenda i feu un seguiment dels propers esdeveniments importants.';

  @override
  String get onboardingClipboardTitle => 'Gestor de porta-retalls';

  @override
  String get onboardingClipboardDesc =>
      'Copia una vegada, enganxa a qualsevol lloc. Accediu al vostre historial del porta-retalls per recuperar fragments que heu copiat anteriorment.';

  @override
  String get onboardingCanvasTitle => 'Tela Creativa';

  @override
  String get onboardingCanvasDesc =>
      'Deixa anar la teva creativitat. Dibuixa, dibuixa i visualitza les teves idees en un llenç digital de forma lliure.';

  @override
  String get featuresNotesDesc => 'Crea i gestiona les teves notes';

  @override
  String get featuresTodosDesc => 'Feu un seguiment de les vostres tasques';

  @override
  String get featuresExpensesDesc => 'Superviseu les vostres despeses';

  @override
  String get featuresJournalDesc => 'Escriu els teus pensaments';

  @override
  String get featuresCalendarDesc => 'Organitza el teu horari';

  @override
  String get featuresClipboardDesc =>
      'Accediu al vostre historial del porta-retalls';

  @override
  String get featuresCanvasDesc => 'Dibuixa i dibuixa lliurement';

  @override
  String get featuresSocialPost => 'Post social';

  @override
  String get featuresSocialPostDesc =>
      'Crea contingut atractiu a les xarxes socials';

  @override
  String get chooseYourAura => 'Tria la teva aura';

  @override
  String get expressYourselfTheme => 'Expressa\'\'t amb un nou color temàtic!';

  @override
  String get level => 'Nivell';

  @override
  String get xpToNextLevel => 'XP a nivell';

  @override
  String get checkUpcomingEvents => 'Consulta els propers esdeveniments';

  @override
  String get startNewSketch => 'Comença un nou esbós';

  @override
  String get noTransactionsMonth => 'No hi ha transaccions aquest mes';

  @override
  String transactionsThisMonth(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 's',
      one: '',
    );
    return '$count transacció$_temp0 aquest mes';
  }

  @override
  String get autoSaveClipboard => 'Desa automàticament el porta-retalls';

  @override
  String get autoSaveClipboardDesc =>
      'Desa automàticament els elements copiats';

  @override
  String get permissionDeniedSettings =>
      'Permís denegat permanentment. Si us plau, activeu-lo a Configuració.';

  @override
  String get notificationsEnabled => 'Notificacions activades!';

  @override
  String get redirectingToSettings =>
      'S\'\'està redirigint a la configuració per desactivar les notificacions...';

  @override
  String get premiumAccess => 'Accés Premium';

  @override
  String get premiumActiveUntil => 'Premium actiu fins a';

  @override
  String get unlockAllFeatures => 'Desbloqueja totes les funcions';

  @override
  String get buyPremium => 'Compra Premium (7 dies)';

  @override
  String costCoins(Object cost) {
    return 'Cost: $cost monedes';
  }

  @override
  String get premiumActivated => 'Premium activat durant 7 dies!';

  @override
  String get premiumActive => 'Premium Active';

  @override
  String get expires => 'Caduca:';

  @override
  String get temporaryAccess => 'Accés temporal';

  @override
  String get journalExpression => 'Diari i expressió';

  @override
  String get artisticDesigns => 'Dissenys Artístics';

  @override
  String get artisticDesignsDesc =>
      'Desbloqueja més de 10 temes de targetes de diari únics';

  @override
  String get premiumLayouts => 'Dissenys Premium';

  @override
  String get premiumLayoutsDesc =>
      'Maneres exclusives de veure els teus records';

  @override
  String get calendarTools => 'Calendari i eines';

  @override
  String get fullCalendar => 'Calendari complet';

  @override
  String get fullCalendarDesc => 'Sistema complet de gestió d\'\'esdeveniments';

  @override
  String get clipboardAutoSaveDesc =>
      'Captura de fons de l\'\'historial del porta-retalls';

  @override
  String get proWidgets => 'Ginys professionals';

  @override
  String get proWidgetsDesc =>
      'Totes les funcions disponibles a la pantalla d\'\'inici';

  @override
  String get dataExport => 'Dades i exportació';

  @override
  String get advancedBackup => 'Còpia de seguretat avançada';

  @override
  String get advancedBackupDesc =>
      'Importació/exportació segura de totes les dades';

  @override
  String get pdfExport => 'Exportació PDF';

  @override
  String get pdfExportDesc => 'Exporta notes i revistes a PDF';

  @override
  String get printReady => 'A punt per imprimir';

  @override
  String get printReadyDesc => 'Suport d\'\'impressió directa';

  @override
  String get richTextEditor => 'Editor de text enriquit';

  @override
  String get advancedSearch => 'Cerca avançada';

  @override
  String get advancedSearchDesc => 'Cerca i substitueix dins del teu text';

  @override
  String get richMedia => 'Rich Media';

  @override
  String get richMediaDesc => 'Insereix imatges, vídeos i enllaços';

  @override
  String get editorStyling => 'Editor d\'\'estil';

  @override
  String get editorStylingDesc => 'Text personalitzat i fons de l\'\'editor';

  @override
  String get balance => 'Balanç';

  @override
  String get loadingAd => 'S\'\'està carregant l\'\'anunci...';

  @override
  String watchAd(Object amount) {
    return 'Mira l\'\'anunci (+$amount)';
  }

  @override
  String get loadAd => 'Carrega l\'\'anunci';

  @override
  String get backupDataDesc => 'Deseu un fitxer JSON de les vostres dades';

  @override
  String get importDataDesc =>
      'Combina un fitxer de còpia de seguretat a CopyClip';

  @override
  String get notificationPermissionDenied =>
      'S\'\'ha denegat el permís de notificació.';

  @override
  String get typeNewTask => 'Escriu una tasca nova...';

  @override
  String get addTask => 'Afegeix una tasca';

  @override
  String get completed => 'Completat';

  @override
  String get greatJob => 'Gran feina!';

  @override
  String youEarnedXPNextTask(Object amount, Object date) {
    return 'Has guanyat $amount XP! Següent tasca: $date';
  }

  @override
  String taskCompletedXP(Object amount) {
    return 'Tasca completada! +$amount XP';
  }

  @override
  String get moveTasksToRecycleBin =>
      'Voleu moure totes les tasques actives a la Paperera de reciclatge?';

  @override
  String get deleteAllPosts => 'Suprimeix totes les publicacions';

  @override
  String get deleteAllPostsConfirmation =>
      'Confirmes que vols suprimir TOTES les publicacions socials? Això no es pot desfer.';

  @override
  String get allPosts => 'Totes les publicacions';

  @override
  String get favorites => 'Preferits';

  @override
  String get drafts => 'Esborranys';

  @override
  String get noFavoritesYet => 'Encara no hi ha cap favorit';

  @override
  String get noDraftsYet => 'Encara no hi ha esborranys';

  @override
  String get startSocialJourney => 'Comença el teu viatge social!';

  @override
  String get draft => 'PROJECTE';

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
      'Si us plau, afegiu contingut o contingut multimèdia per compartir';

  @override
  String fileNotFoundError(Object path) {
    return 'Error: no s\'\'ha trobat el fitxer a $path';
  }

  @override
  String get checkFacebookApp => 'Comproveu l\'\'aplicació de Facebook';

  @override
  String get systemShare => 'Compartició del sistema';

  @override
  String get socialPost => 'Post social';

  @override
  String get favorite => 'Favorit';

  @override
  String get saveDraft => 'Desa l\'\'esborrany';

  @override
  String get entryCopied => 'S\'\'ha copiat l\'\'entrada';

  @override
  String get moveEntriesToRecycleBin =>
      'Voleu moure totes les entrades actives a la paperera de reciclatge?';

  @override
  String get startWritingStory => 'Comença a escriure la teva història';

  @override
  String get recordMemories =>
      'Enregistreu els vostres records i sentiments diaris.';

  @override
  String get writeJournal => 'Escriu un diari';

  @override
  String get myMemories => 'Els meus records';

  @override
  String get sortJournal => 'Ordena el diari';

  @override
  String get byMood => 'Per estat d\'\'ànim';

  @override
  String get searchMemories => 'Cerca records...';

  @override
  String get selectAll => 'Seleccioneu Tot';

  @override
  String get deleteSelected => 'Suprimeix el seleccionat';

  @override
  String get taskCompletedExclamation => 'Tasca completada!';

  @override
  String get taskUncompletedExclamation => 'Tasca no completada';

  @override
  String get clipboardUpdatedExclamation => 'Porta-retalls actualitzat!';

  @override
  String clipboardSavedContent(Object content) {
    return 'Porta-retalls desat: $content';
  }

  @override
  String get overview => 'Visió general';

  @override
  String get colorAurora => 'Aurora';

  @override
  String get colorCosmic => 'Còsmic';

  @override
  String get colorNebula => 'Nebulosa';

  @override
  String get colorStarlight => 'Llum de les estrelles';

  @override
  String get colorSolar => 'Solar';

  @override
  String get colorNova => 'Nova';

  @override
  String get loadingStepLoading => 'Carregant...';

  @override
  String get loadingStepDatabase => 'S\'\'està configurant la base de dades...';

  @override
  String get loadingStepSystem => 'S\'\'està configurant el sistema...';

  @override
  String get loadingStepReady => 'A punt';

  @override
  String get productivityCompanion => 'El teu company de productivitat';

  @override
  String get done => 'Fet';

  @override
  String get newNote => 'Nova nota';

  @override
  String get changeColor => 'Canvia el color';

  @override
  String get copyContent => 'Copia contingut';

  @override
  String get titleOptional => 'Títol (opcional)';

  @override
  String get exportAsPdf => 'Exporta com a PDF';

  @override
  String get taskDueNow => 'Tasca pendent ara';

  @override
  String get moveTaskToBinTitle =>
      'Voleu moure la tasca a la paperera de reciclatge?';

  @override
  String get restoreTaskLater =>
      'Podeu restaurar aquesta tasca més tard des de la configuració.';

  @override
  String get newTask => 'Nova tasca';

  @override
  String get editTask => 'Edita la tasca';

  @override
  String get undo => 'Desfer';

  @override
  String get redo => 'Refer';

  @override
  String get category => 'Categoria';

  @override
  String get categoryHint => 'p. ex. Treball, Gimnàs';

  @override
  String get whatNeedsToBeDone => 'Què cal fer?';

  @override
  String get enterTaskDetails => 'Introduïu els detalls de la tasca...';

  @override
  String get setDueDate => 'Estableix la data de venciment';

  @override
  String get dueDate => 'Dues Cites';

  @override
  String get expenseTitle => 'Despeses';

  @override
  String searchInCurrency(String currency) {
    return 'Cerca en $currency...';
  }

  @override
  String get sortAndFilter => 'Ordena i filtra';

  @override
  String get sortBy => 'CLASIFICAR PER';

  @override
  String get highestAmount => 'Quantitat més alta';

  @override
  String get lowestAmount => 'Quantitat més baixa';

  @override
  String get moreFilters => 'Més filtres...';

  @override
  String get filterExpenses => 'Filtre les despeses';

  @override
  String get transactionType => 'Tipus de transacció';

  @override
  String get categories => 'Categories';

  @override
  String get all => 'Tots';

  @override
  String get income => 'Ingressos';

  @override
  String get expense => 'Despesa';

  @override
  String get reset => 'Restableix';

  @override
  String get apply => 'Aplicar';

  @override
  String newExpense(String currency) {
    return 'Nova $currency';
  }

  @override
  String errorLoadingData(String error) {
    return 'S\'\'ha produït un error en carregar les dades.\n\n$error';
  }

  @override
  String get dailyQuote1 => 'La millor manera de predir el futur és crear-lo.';

  @override
  String get dailyQuote2 =>
      'La riquesa no consisteix en tenir grans possessions, sinó en tenir poques necessitats.';

  @override
  String get dailyQuote3 => 'El temps és la moneda definitiva.';

  @override
  String get dailyQuote4 => 'L\'\'èxit no és definitiu, el fracàs no és fatal.';

  @override
  String get dailyQuote5 => 'Centra\'\'t en la solució, no en el problema.';

  @override
  String get dailyQuote6 => 'La vostra xarxa és el vostre valor net.';

  @override
  String get moodHappy => 'Feliç';

  @override
  String get moodExcited => 'Emocionat';

  @override
  String get moodNeutral => 'Neutre';

  @override
  String get moodSad => 'Trist';

  @override
  String get moodStressed => 'Estrès';

  @override
  String exportDate(String date) {
    return '📅 $date';
  }

  @override
  String exportMood(String emoji, String mood) {
    return 'Estat d\'\'ànim: $emoji $mood';
  }

  @override
  String exportTitle(String title) {
    return 'TÍTOL: $title';
  }

  @override
  String exportTags(String tags) {
    return 'Etiquetes: $tags';
  }

  @override
  String get instagram => 'Instagram';

  @override
  String get facebook => 'Facebook';

  @override
  String get tiktok => 'TikTok';

  @override
  String get newSketch => 'Esbós nou';

  @override
  String get searchSketches => 'Cerca esbossos i carpetes...';

  @override
  String get noResultsFound => 'No s\'\'han trobat resultats';

  @override
  String get noItems => 'No hi ha articles';

  @override
  String get noDrawingsYet => 'Encara no hi ha dibuixos';

  @override
  String get canvasIntro => 'Deixa anar la teva creativitat al llenç!';

  @override
  String get newCanvas => 'Nou Canvas';

  @override
  String get rename => 'Canvia el nom';

  @override
  String get deleteFolder => 'Suprimeix la carpeta';

  @override
  String get deleteSketchesQuestion => 'Vols suprimir esbossos?';

  @override
  String get deleteFolderConfirmation =>
      'Tots els esbossos d\'\'aquesta carpeta se suprimiran permanentment.';

  @override
  String get renameFolder => 'Canvia el nom de la carpeta';

  @override
  String get chooseColor => 'Trieu Color';

  @override
  String get deleteFolderQuestion => 'Vols suprimir la carpeta?';

  @override
  String get searchClips => 'Cerca clips...';

  @override
  String get clipboardEmpty => 'El porta-retalls està buit';

  @override
  String get addItem => 'Afegeix un element';

  @override
  String get clipColor => 'Color del clip';

  @override
  String get newClip => 'Clip nou';

  @override
  String get editClip => 'Edita el clip';

  @override
  String get restoreClipLater => 'Pots restaurar aquest clip més tard.';

  @override
  String get upcomingEvents => 'Pròxims Esdeveniments';

  @override
  String get dataDistribution => 'DISTRIBUCIÓ DE DADES';

  @override
  String get taskProgress => 'PROGRÉS DE LA TASCA';

  @override
  String get quickStats => 'ESTADÍSTIQUES RÀPIDES';

  @override
  String get taskCompletion => 'Finalització de la tasca';

  @override
  String get noItemsForDate => 'No hi ha articles per a aquesta data';

  @override
  String get enjoyFreeTime => 'Gaudeix del teu temps lliure!';

  @override
  String get searchThisDay => 'Busca en aquest dia...';

  @override
  String get finance => 'Finances';

  @override
  String get permanentlyDelete => 'Vols suprimir definitivament?';

  @override
  String deleteSelectionConfirmation(int foldersCount, int sketchesCount) {
    return 'Això suprimirà permanentment $foldersCount carpetes (i els seus esbossos) i $sketchesCount altres esbossos.\n\nAixò no es pot desfer.';
  }

  @override
  String get deleteForever => 'Suprimeix per sempre';

  @override
  String selectedCount(int count) {
    return '$count seleccionat';
  }

  @override
  String canvasStats(int notes, int folders) {
    return '$notes esbossos • $folders carpetes';
  }

  @override
  String get sortItems => 'Ordena els elements';

  @override
  String get sortNameAZ => 'Nom (A-Z)';

  @override
  String get sortNameZA => 'Nom (Z-A)';

  @override
  String get createFolder => 'Crea una carpeta';

  @override
  String get folderNameHint => 'Nom de la carpeta...';

  @override
  String deleteSketchesConfirmation(int count) {
    return 'Vols suprimir $count esbossos? Això no es pot desfer.';
  }

  @override
  String get noSketchesFound => 'No s\'\'han trobat esbossos';

  @override
  String get noSketchesFoundSub =>
      'Proveu d\'\'ajustar la cerca o de crear un esbós nou.';

  @override
  String searchInFolder(String folder) {
    return 'Cerca a $folder...';
  }

  @override
  String sketchesCount(int count) {
    return '$count esbossos';
  }

  @override
  String get sortSketches => 'Ordenar esbossos';

  @override
  String get calendarScreenTitle => 'Calendari';

  @override
  String get dailyActivity => 'Activitat diària';

  @override
  String get deleteItemQuestion => 'Vols suprimir l\'\'element?';

  @override
  String get deleteItemConfirmation =>
      'Això traslladarà l\'\'element a la paperera de reciclatge.';

  @override
  String get moveToBinItem => 'Vols moure\'\'t a la safata?';

  @override
  String get moveToBinConfirmation => 'Podeu restaurar-lo més tard.';

  @override
  String selectedItems(int count) {
    return '$count seleccionat';
  }

  @override
  String get recentClips => 'Clips recents';

  @override
  String get copied => 'Copiat!';

  @override
  String get copiedPlainText => 'Text sense format copiat';

  @override
  String get clipTheme => 'Tema del clip';

  @override
  String get justNow => 'Just ara';

  @override
  String minutesAgo(Object count) {
    return 'fa $count m';
  }

  @override
  String hoursAgo(Object count) {
    return 'fa $count h';
  }

  @override
  String daysAgo(Object count) {
    return 'fa $count dies';
  }

  @override
  String get noTasksFound => 'No s\'\'han trobat tasques.';

  @override
  String get searchTasks => 'Cerca tasques...';

  @override
  String get taskReminder => 'Recordatori de tasques';

  @override
  String get untitledNote => 'Nota sense títol';

  @override
  String get dailyEntry => 'Entrada diària';

  @override
  String get clipboardHistory => 'Historial del porta-retalls';

  @override
  String get deletePermanentlyContent => 'Aquesta acció no es pot desfer.';

  @override
  String get emptyRecycleBinTitle => 'Voleu la paperera de reciclatge?';

  @override
  String emptyRecycleBinContent(Object count) {
    return 'Tots els $count elements se suprimiran permanentment.';
  }

  @override
  String get emptyBin => 'Paperera buida';

  @override
  String get recycleBinEmpty => 'La paperera de reciclatge està buida';

  @override
  String get deletedItemsAppearHere =>
      'Els elements suprimits apareixeran aquí.';

  @override
  String get empty => 'Buit';

  @override
  String get recent => 'Recent';

  @override
  String categoryLabel(Object category) {
    return 'Categoria: $category';
  }

  @override
  String get general => 'General';

  @override
  String get saveTransactionQuestion => 'Vols desar aquesta transacció?';

  @override
  String get fillTitleAmount => 'Si us plau, empleneu el títol i l\'\'import';

  @override
  String get invalidAmount => 'Format d\'\'import no vàlid';

  @override
  String get moveTransactionToBinTitle =>
      'Voleu moure la transacció a la paperera de reciclatge?';

  @override
  String get restoreTransactionLater =>
      'Pots restaurar aquesta transacció més tard des de la configuració.';

  @override
  String get newTransaction => 'Nova transacció';

  @override
  String get whatIsThisFor => 'Per a què serveix això?';

  @override
  String get description => 'Descripció';

  @override
  String get daily => 'Diàriament';

  @override
  String get weekly => 'Setmanalment';

  @override
  String get monthly => 'Mensualment';

  @override
  String get yearly => 'Anualment';

  @override
  String get totalIncome => 'Ingressos totals';

  @override
  String get totalExpense => 'Despesa total';

  @override
  String get analysis => 'Anàlisi';

  @override
  String get transactions => 'Transaccions';

  @override
  String get noExpensesFound =>
      'No s\'\'han trobat despeses per a aquest període.';

  @override
  String get netBalance => 'Saldo Net';

  @override
  String get topCategories => 'Categories principals';

  @override
  String get spendingTrend => 'Tendència de despesa';

  @override
  String get insights => 'Insights';

  @override
  String get noExpensesRecorded => 'No s\'\'han registrat despeses';

  @override
  String get trackSpendingHabits =>
      'Feu un seguiment dels vostres hàbits de despesa fàcilment.';

  @override
  String get addExpense => 'Afegeix despesa';

  @override
  String get noDataForPeriod => 'No hi ha dades per a aquest període';

  @override
  String get budget => 'Pressupost';

  @override
  String get spent => 'Esgotat';

  @override
  String get limit => 'Límit';

  @override
  String get overBudget => 'Per sobre del pressupost!';

  @override
  String remainingBudget(Object percent) {
    return '$percent% restant';
  }

  @override
  String get savingsRate => 'Taxa d\'\'estalvi';

  @override
  String get healthScore => 'Puntuació de salut';

  @override
  String get healthScoreExplanation =>
      'Aquesta puntuació es basa en la teva taxa d\'\'estalvi.\n\n• > 50% estalviat = Excel·lent (100)\n• 0% d\'\'estalvi = Mitjana (50)\n• Despesa > Ingressos = Pobre (<50)';

  @override
  String get ok => 'D\'\'acord';

  @override
  String get bulkImport => 'Bulk Import';
}
