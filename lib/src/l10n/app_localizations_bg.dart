// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Bulgarian (`bg`).
class AppLocalizationsBg extends AppLocalizations {
  AppLocalizationsBg([String locale = 'bg']) : super(locale);

  @override
  String get settings => 'Настройки';

  @override
  String get language => 'език';

  @override
  String get systemDefault => 'Системни настройки по подразбиране';

  @override
  String get notes => 'Бележки';

  @override
  String get todos => 'Задачи';

  @override
  String get journal => 'Журнал';

  @override
  String get clipboard => 'Клипборд';

  @override
  String get save => 'Запазване';

  @override
  String get create => 'Създавайте';

  @override
  String get cancel => 'Отказ';

  @override
  String get delete => 'Изтриване';

  @override
  String get edit => 'Редактиране';

  @override
  String get share => 'Споделете';

  @override
  String get copy => 'копие';

  @override
  String get unsavedChanges => 'Незапазени промени';

  @override
  String get confirmDelete => 'Потвърдете Изтриване';

  @override
  String get discard => 'Изхвърлете';

  @override
  String get camera => 'Камера';

  @override
  String get gallery => 'Галерия';

  @override
  String get search => 'Търсене';

  @override
  String get pleaseEnterTask => 'Моля, въведете задача';

  @override
  String get deleteTask => 'Изтриване на задача';

  @override
  String get selectItems => 'Изберете елементи';

  @override
  String get deleteAll => 'Изтриване на всички';

  @override
  String error(Object error) {
    return 'Грешка: $error';
  }

  @override
  String get premiumFeatures => 'Премиум функции';

  @override
  String get manageCoinsAdsPremium =>
      'Управлявайте монети, реклами и премиум статус';

  @override
  String get themeMode => 'Тематичен режим';

  @override
  String get accentColor => 'Цвят на акцента';

  @override
  String get backgroundDesign => 'Дизайн на фона';

  @override
  String get pushNotifications => 'Насочени известия';

  @override
  String get recycleBin => 'Кошче';

  @override
  String get exportData => 'Експортиране на данни';

  @override
  String get importData => 'Импортиране на данни';

  @override
  String get rateApp => 'Оценете приложението';

  @override
  String get sendFeedback => 'Изпратете обратна връзка';

  @override
  String get privacyPolicy => 'Политика за поверителност';

  @override
  String get version => 'Версия';

  @override
  String get buildNumber => 'Номер на компилация';

  @override
  String get system => 'система';

  @override
  String get light => 'светлина';

  @override
  String get dark => 'Тъмно';

  @override
  String get itemRestored => 'Елементът е възстановен';

  @override
  String get recycleBinCleared => 'Кошчето е изчистено успешно';

  @override
  String get unlockPermanently => 'Отключи за постоянно';

  @override
  String get notEnoughCoins => 'Няма достатъчно монети!';

  @override
  String youEarnedCoins(Object amount) {
    return 'Спечелихте $amount монети!';
  }

  @override
  String get contentCopied => 'Съдържанието е копирано';

  @override
  String get selectDateTime => 'Изберете Дата и час';

  @override
  String get watchAdToEarnCoins => 'Гледайте реклама, за да печелите монети';

  @override
  String get premiumUnlocked => 'Премиум отключен';

  @override
  String get removeAds => 'Премахване на реклами';

  @override
  String get unlimitedCloudStorage => 'Неограничено съхранение в облак';

  @override
  String get deleteNote => 'Изтриване на бележка';

  @override
  String get shareNote => 'Споделяне на бележка';

  @override
  String get editNote => 'Редактиране на бележка';

  @override
  String get searchNotes => 'Търсене в бележки...';

  @override
  String get noNotesFound => 'Няма намерени бележки';

  @override
  String get captureThoughts => 'Уловете мислите си незабавно.';

  @override
  String get createNote => 'Създаване на бележка';

  @override
  String get customOrder => 'Персонализирана поръчка';

  @override
  String get newestFirst => 'Първо най-новите';

  @override
  String get oldestFirst => 'Първо най-старите';

  @override
  String get titleAZ => 'Заглавие: A-Z';

  @override
  String get titleZA => 'Заглавие: Z-A';

  @override
  String get deleteAllQuestion => 'Изтриване на всички?';

  @override
  String get moveToRecycleBin => 'Преместване на всички бележки в кошчето?';

  @override
  String get moveToBinQuestion => 'Преместване в кошчето?';

  @override
  String get restoreNoteLater =>
      'Можете да възстановите тази бележка по-късно.';

  @override
  String get move => 'Движи се';

  @override
  String get myThoughts => 'Моите мисли';

  @override
  String get selected => 'Избрано';

  @override
  String get noContent => 'Без съдържание';

  @override
  String get untitled => 'Без заглавие';

  @override
  String get chooseWallpapers => 'Изберете от 10+ динамични тапети';

  @override
  String get backupData => 'Архивиране на данни';

  @override
  String get saveJsonFile =>
      'Запазване на JSON файл, съдържащ всички ваши данни?';

  @override
  String get exportNow => 'Експортирайте сега';

  @override
  String get importDataTitle => 'Импортиране на данни';

  @override
  String get mergeBackupFile =>
      'Обединяване на архивен файл с текущите ви елементи?';

  @override
  String get selectFile => 'Изберете Файл';

  @override
  String get backupSaved => 'Резервното копие е запазено успешно!';

  @override
  String get exportFailed => 'Неуспешно експортиране.';

  @override
  String importSuccess(Object count) {
    return '$count елемента възстановени успешно!';
  }

  @override
  String get importFailed => 'Импортирането не бе успешно.';

  @override
  String widgetAdded(String widget) {
    return 'Приспособлението е добавено към началния екран!';
  }

  @override
  String get widgetRequestSent =>
      'Заявката за приспособление е изпратена. Моля, проверете началния екран.';

  @override
  String get widgetAddFailed => 'Неуспешно добавяне на приспособление';

  @override
  String get autoSaveEnabled => 'Автоматичното запазване е активирано.';

  @override
  String get autoSaveDisabled => 'Автоматичното запазване е деактивирано.';

  @override
  String get homeScreenWidgets => 'Уиджети на началния екран';

  @override
  String get notificationsTitle => 'Известия';

  @override
  String get dataBackup => 'Данни и архивиране';

  @override
  String get feedbackSupport => 'Обратна връзка и поддръжка';

  @override
  String get creditsTitle => 'Кредити';

  @override
  String get privacyMaintenance => 'Поверителност и поддръжка';

  @override
  String get aboutTitle => 'За';

  @override
  String get premium => 'Премиум';

  @override
  String get appearanceTitle => 'Външен вид';

  @override
  String get clipboardTitle => 'Клипборд';

  @override
  String get settingsSubtitle => 'Персонализирайте вашето изживяване';

  @override
  String get welcomeTitle => 'Добре дошли в CopyClip';

  @override
  String get welcomeDescription =>
      'Вашият най-добър спътник в продуктивността. Нека ви настроим с мощни инструменти за управление на деня ви.';

  @override
  String get onboardingNotesTitle => 'Интелигентни бележки';

  @override
  String get onboardingNotesDesc =>
      'Улавяйте незабавно идеи с обогатен текстов формат. Организирайте мислите си и никога повече не губете страхотна идея.';

  @override
  String get onboardingTodosTitle => 'Управление на задачите';

  @override
  String get onboardingTodosDesc =>
      'Останете на върха на играта си. Създавайте списъци със задачи, задавайте приоритети и смазвайте целите си една отметка наведнъж.';

  @override
  String get onboardingJournalTitle => 'Личен дневник';

  @override
  String get onboardingJournalDesc =>
      'Отразете деня си. Лично пространство, където да запишете своите спомени, чувства и ежедневни преживявания.';

  @override
  String get onboardingClipboardTitle => 'Мениджър на клипборда';

  @override
  String get onboardingClipboardDesc =>
      'Копирайте веднъж, поставете навсякъде. Достъп до хронологията на клипборда, за да извлечете фрагменти, които сте копирали по-рано.';

  @override
  String get featuresNotesDesc => 'Създавайте и управлявайте своите бележки';

  @override
  String get featuresTodosDesc => 'Следете задачите си';

  @override
  String get featuresJournalDesc => 'Запишете вашите мисли';

  @override
  String get featuresClipboardDesc => 'Достъп до хронологията на клипборда';

  @override
  String get chooseYourAura => 'Изберете своята аура';

  @override
  String get expressYourselfTheme => 'Изразете себе си с нов цвят на темата!';

  @override
  String get autoSaveClipboard => 'Автоматично запазване на клипборда';

  @override
  String get autoSaveClipboardDesc =>
      'Автоматично запазване на копирани елементи';

  @override
  String get permissionDeniedSettings =>
      'Разрешението е отказано завинаги. Моля, активирайте в Настройки.';

  @override
  String get notificationsEnabled => 'Известията са активирани!';

  @override
  String get redirectingToSettings =>
      'Пренасочване към настройки за деактивиране на известията...';

  @override
  String get premiumAccess => 'Премиум достъп';

  @override
  String get premiumActiveUntil => 'Premium Активен до';

  @override
  String get unlockAllFeatures => 'Отключете всички функции';

  @override
  String get buyPremium => 'Купете Premium (7 дни)';

  @override
  String costCoins(Object cost) {
    return 'Цена: $cost монети';
  }

  @override
  String get premiumActivated => 'Premium активиран за 7 дни!';

  @override
  String get premiumActive => 'Premium Active';

  @override
  String get expires => 'Изтича:';

  @override
  String get temporaryAccess => 'Временен достъп';

  @override
  String get journalExpression => 'Дневник и изразяване';

  @override
  String get artisticDesigns => 'Художествен дизайн';

  @override
  String get artisticDesignsDesc =>
      'Отключете 10+ уникални теми за карти за дневници';

  @override
  String get premiumLayouts => 'Първокласни оформления';

  @override
  String get premiumLayoutsDesc =>
      'Ексклузивни начини за преглед на вашите спомени';

  @override
  String get clipboardAutoSaveDesc =>
      'Заснемане на историята на клипборда във фонов режим';

  @override
  String get proWidgets => 'Професионални джаджи';

  @override
  String get proWidgetsDesc => 'Всички функции, налични на началния екран';

  @override
  String get dataExport => 'Данни и експорт';

  @override
  String get advancedBackup => 'Разширено архивиране';

  @override
  String get advancedBackupDesc => 'Сигурен импорт/експорт на всички данни';

  @override
  String get pdfExport => 'PDF експортиране';

  @override
  String get pdfExportDesc => 'Експортирайте бележки и дневници в PDF';

  @override
  String get printReady => 'Готов за печат';

  @override
  String get printReadyDesc => 'Поддръжка на директен печат';

  @override
  String get richTextEditor => 'Обогатен текстов редактор';

  @override
  String get advancedSearch => 'Разширено търсене';

  @override
  String get advancedSearchDesc => 'Търсене и замяна във вашия текст';

  @override
  String get richMedia => 'Мултимедия';

  @override
  String get richMediaDesc => 'Вмъкнете изображения, видеоклипове и връзки';

  @override
  String get editorStyling => 'Стил на редактора';

  @override
  String get editorStylingDesc => 'Персонализиран фон на текст и редактор';

  @override
  String get balance => 'Баланс';

  @override
  String get loadingAd => 'Рекламата се зарежда...';

  @override
  String watchAd(Object amount) {
    return 'Гледайте реклама (+$amount)';
  }

  @override
  String get loadAd => 'Зареди реклама';

  @override
  String get backupDataDesc => 'Запазете JSON файл с вашите данни';

  @override
  String get importDataDesc => 'Обединете архивен файл в CopyClip';

  @override
  String get notificationPermissionDenied =>
      'Разрешението за известяване е отказано.';

  @override
  String get typeNewTask => 'Въведете нова задача...';

  @override
  String get addTask => 'Добавяне на задача';

  @override
  String get completed => 'Завършено';

  @override
  String get moveTasksToRecycleBin =>
      'Преместване на всички активни задачи в кошчето?';

  @override
  String fileNotFoundError(Object path) {
    return 'Грешка: Файлът не е намерен на $path';
  }

  @override
  String get entryCopied => 'Записът е копиран';

  @override
  String get moveEntriesToRecycleBin =>
      'Преместване на всички активни записи в кошчето?';

  @override
  String get startWritingStory => 'Започнете да пишете своята история';

  @override
  String get recordMemories => 'Запишете ежедневните си спомени и чувства.';

  @override
  String get writeJournal => 'Напиши дневник';

  @override
  String get myMemories => 'Моите спомени';

  @override
  String get sortJournal => 'Сортиране на дневник';

  @override
  String get byMood => 'По настроение';

  @override
  String get searchMemories => 'Търсене в спомени...';

  @override
  String get selectAll => 'Изберете Всички';

  @override
  String get deleteSelected => 'Изтриване на избраното';

  @override
  String get taskCompletedExclamation => 'Задачата е изпълнена!';

  @override
  String get taskUncompletedExclamation => 'Задачата не е изпълнена';

  @override
  String get clipboardUpdatedExclamation => 'Клипбордът е актуализиран!';

  @override
  String clipboardSavedContent(Object content) {
    return 'Клипбордът е запазен: $content';
  }

  @override
  String get overview => 'Преглед';

  @override
  String get colorAurora => 'Аврора';

  @override
  String get colorCosmic => 'Космически';

  @override
  String get colorNebula => 'Мъглявина';

  @override
  String get colorStarlight => 'Звездна светлина';

  @override
  String get colorSolar => 'Слънчева';

  @override
  String get colorNova => 'Нов';

  @override
  String get loadingStepLoading => 'Зареждане...';

  @override
  String get loadingStepDatabase => 'Базата данни се настройва...';

  @override
  String get loadingStepSystem => 'Конфигуриране на системата...';

  @override
  String get loadingStepReady => 'Готови';

  @override
  String get productivityCompanion => 'Вашият спътник в продуктивността';

  @override
  String get done => 'Готово';

  @override
  String get newNote => 'Нова бележка';

  @override
  String get changeColor => 'Промяна на цвета';

  @override
  String get copyContent => 'Копиране на съдържание';

  @override
  String get titleOptional => 'Заглавие (по избор)';

  @override
  String get exportAsPdf => 'Експортиране като PDF';

  @override
  String get taskDueNow => 'Задачата трябва да бъде изпълнена сега';

  @override
  String get moveTaskToBinTitle => 'Преместване на задача в кошчето?';

  @override
  String get restoreTaskLater =>
      'Можете да възстановите тази задача по-късно от настройките.';

  @override
  String get newTask => 'Нова задача';

  @override
  String get editTask => 'Редактиране на задача';

  @override
  String get undo => 'Отмяна';

  @override
  String get redo => 'Повторете';

  @override
  String get category => 'Категория';

  @override
  String get categoryHint => 'напр. Работа, Фитнес зала';

  @override
  String get whatNeedsToBeDone => 'Какво трябва да се направи?';

  @override
  String get enterTaskDetails => 'Въведете подробности за задачата...';

  @override
  String get setDueDate => 'Задаване на краен срок';

  @override
  String get dueDate => 'Две дати';

  @override
  String get sortAndFilter => 'Сортиране и филтриране';

  @override
  String get sortBy => 'СОРТИРАНЕ ПО';

  @override
  String get categories => 'Категории';

  @override
  String get all => 'Всички';

  @override
  String get reset => 'Нулиране';

  @override
  String get apply => 'Кандидатствайте';

  @override
  String errorLoadingData(String error) {
    return 'Грешка при зареждане на данни.\n\n$error';
  }

  @override
  String get dailyQuote1 =>
      'Най-добрият начин да предвидите бъдещето е да го създадете.';

  @override
  String get dailyQuote2 =>
      'Богатството не се състои в притежаването на големи притежания, а в това да имаш малко желания.';

  @override
  String get dailyQuote3 => 'Времето е основната валута.';

  @override
  String get dailyQuote4 => 'Успехът не е окончателен, провалът не е фатален.';

  @override
  String get dailyQuote5 =>
      'Фокусирайте се върху решението, а не върху проблема.';

  @override
  String get dailyQuote6 => 'Вашата мрежа е вашата нетна стойност.';

  @override
  String get moodHappy => 'Щастлив';

  @override
  String get moodExcited => 'развълнуван';

  @override
  String get moodNeutral => 'Неутрален';

  @override
  String get moodSad => 'тъжно';

  @override
  String get moodStressed => 'стресиран';

  @override
  String exportDate(String date) {
    return '📅 $date';
  }

  @override
  String exportMood(String emoji, String mood) {
    return 'Настроение: $emoji $mood';
  }

  @override
  String exportTitle(String title) {
    return 'ЗАГЛАВИЕ: $title';
  }

  @override
  String exportTags(String tags) {
    return 'Етикети: $tags';
  }

  @override
  String get noResultsFound => 'Няма намерени резултати';

  @override
  String get noItems => 'Няма елементи';

  @override
  String get rename => 'Преименуване';

  @override
  String get deleteFolder => 'Изтриване на папка';

  @override
  String get deleteSketchesQuestion => 'Изтриване на скици?';

  @override
  String get deleteFolderConfirmation =>
      'Всички скици в тази папка ще бъдат изтрити за постоянно.';

  @override
  String get chooseColor => 'Изберете цвят';

  @override
  String get searchClips => 'Търсене на клипове...';

  @override
  String get clipboardEmpty => 'Клипбордът е празен';

  @override
  String get addItem => 'Добавяне на артикул';

  @override
  String get clipColor => 'Цвят на клипа';

  @override
  String get newClip => 'Нов клип';

  @override
  String get editClip => 'Редактиране на клип';

  @override
  String get restoreClipLater => 'Можете да възстановите този клип по-късно.';

  @override
  String get dataDistribution => 'РАЗПРОСТРАНЕНИЕ НА ДАННИ';

  @override
  String get taskProgress => 'ПРОГРЕС НА ЗАДАЧАТА';

  @override
  String get quickStats => 'БЪРЗА СТАТИСТИКА';

  @override
  String get taskCompletion => 'Изпълнение на задачата';

  @override
  String get noItemsForDate => 'Няма артикули за тази дата';

  @override
  String get enjoyFreeTime => 'Насладете се на свободното си време!';

  @override
  String get searchThisDay => 'Търсете в този ден...';

  @override
  String get finance => 'Финанси';

  @override
  String get permanentlyDelete => 'Изтриване за постоянно?';

  @override
  String deleteSelectionConfirmation(int foldersCount, int sketchesCount) {
    return 'Това ще изтрие за постоянно $foldersCount папки (и техните скици) и $sketchesCount други скици.\n\nТова не може да бъде отменено.';
  }

  @override
  String get deleteForever => 'Изтрий завинаги';

  @override
  String selectedCount(int count) {
    return '$count избрани';
  }

  @override
  String get deleteItemQuestion => 'Изтриване на елемент?';

  @override
  String get deleteItemConfirmation => 'Това ще премести елемента в кошчето.';

  @override
  String get moveToBinItem => 'Преместване в кошчето?';

  @override
  String get moveToBinConfirmation => 'Можете да го възстановите по-късно.';

  @override
  String selectedItems(int count) {
    return '$count избрани';
  }

  @override
  String get recentClips => 'Скорошни клипове';

  @override
  String get copied => 'Копирано!';

  @override
  String get copiedPlainText => 'Копиран обикновен текст';

  @override
  String get clipTheme => 'Тема за клип';

  @override
  String get justNow => 'Току-що';

  @override
  String minutesAgo(Object count) {
    return 'преди $count мин';
  }

  @override
  String hoursAgo(Object count) {
    return 'преди $count ч';
  }

  @override
  String daysAgo(Object count) {
    return 'преди $count дни';
  }

  @override
  String get noTasksFound => 'Няма намерени задачи.';

  @override
  String get searchTasks => 'Задачи за търсене...';

  @override
  String get taskReminder => 'Напомняне за задача';

  @override
  String get untitledNote => 'Бележка без заглавие';

  @override
  String get dailyEntry => 'Ежедневен вход';

  @override
  String get clipboardHistory => 'История на клипборда';

  @override
  String get deletePermanentlyContent =>
      'Това действие не може да бъде отменено.';

  @override
  String get emptyRecycleBinTitle => 'Изпразване на кошчето?';

  @override
  String emptyRecycleBinContent(Object count) {
    return 'Всички $count елемента ще бъдат изтрити за постоянно.';
  }

  @override
  String get emptyBin => 'Изпразване на кошчето';

  @override
  String get recycleBinEmpty => 'Кошчето е празно';

  @override
  String get deletedItemsAppearHere => 'Изтритите елементи ще се появят тук.';

  @override
  String get empty => 'празна';

  @override
  String get recent => 'Скорошни';

  @override
  String categoryLabel(Object category) {
    return 'Категория: $category';
  }

  @override
  String get general => 'генерал';

  @override
  String get description => 'Описание';

  @override
  String get daily => 'Ежедневно';

  @override
  String get weekly => 'Ежеседмично';

  @override
  String get monthly => 'Месечно';

  @override
  String get yearly => 'Годишно';

  @override
  String get analysis => 'Анализ';

  @override
  String get transactions => 'Транзакции';

  @override
  String get ok => 'добре';

  @override
  String get bulkImport => 'Bulk Import';
}

/// The translations for Bulgarian, as used in Bulgaria (`bg_BG`).
class AppLocalizationsBgBg extends AppLocalizationsBg {
  AppLocalizationsBgBg() : super('bg_BG');

  @override
  String get settings => 'Настройки';

  @override
  String get language => 'език';

  @override
  String get systemDefault => 'Системни настройки по подразбиране';

  @override
  String get notes => 'Бележки';

  @override
  String get todos => 'Задачи';

  @override
  String get journal => 'Журнал';

  @override
  String get clipboard => 'Клипборд';

  @override
  String get save => 'Запазване';

  @override
  String get create => 'Създавайте';

  @override
  String get cancel => 'Отказ';

  @override
  String get delete => 'Изтриване';

  @override
  String get edit => 'Редактиране';

  @override
  String get share => 'Споделете';

  @override
  String get copy => 'копие';

  @override
  String get unsavedChanges => 'Незапазени промени';

  @override
  String get confirmDelete => 'Потвърдете Изтриване';

  @override
  String get discard => 'Изхвърлете';

  @override
  String get camera => 'Камера';

  @override
  String get gallery => 'Галерия';

  @override
  String get search => 'Търсене';

  @override
  String get pleaseEnterTask => 'Моля, въведете задача';

  @override
  String get deleteTask => 'Изтриване на задача';

  @override
  String get selectItems => 'Изберете елементи';

  @override
  String get deleteAll => 'Изтриване на всички';

  @override
  String error(Object error) {
    return 'Грешка: $error';
  }

  @override
  String get premiumFeatures => 'Премиум функции';

  @override
  String get manageCoinsAdsPremium =>
      'Управлявайте монети, реклами и премиум статус';

  @override
  String get themeMode => 'Тематичен режим';

  @override
  String get accentColor => 'Цвят на акцента';

  @override
  String get backgroundDesign => 'Дизайн на фона';

  @override
  String get pushNotifications => 'Насочени известия';

  @override
  String get recycleBin => 'Кошче';

  @override
  String get exportData => 'Експортиране на данни';

  @override
  String get importData => 'Импортиране на данни';

  @override
  String get rateApp => 'Оценете приложението';

  @override
  String get sendFeedback => 'Изпратете обратна връзка';

  @override
  String get privacyPolicy => 'Политика за поверителност';

  @override
  String get version => 'Версия';

  @override
  String get buildNumber => 'Номер на компилация';

  @override
  String get system => 'система';

  @override
  String get light => 'светлина';

  @override
  String get dark => 'Тъмно';

  @override
  String get itemRestored => 'Елементът е възстановен';

  @override
  String get recycleBinCleared => 'Кошчето е изчистено успешно';

  @override
  String get unlockPermanently => 'Отключи за постоянно';

  @override
  String get notEnoughCoins => 'Няма достатъчно монети!';

  @override
  String youEarnedCoins(Object amount) {
    return 'Спечелихте $amount монети!';
  }

  @override
  String get contentCopied => 'Съдържанието е копирано';

  @override
  String get selectDateTime => 'Изберете Дата и час';

  @override
  String get watchAdToEarnCoins => 'Гледайте реклама, за да печелите монети';

  @override
  String get premiumUnlocked => 'Премиум отключен';

  @override
  String get removeAds => 'Премахване на реклами';

  @override
  String get unlimitedCloudStorage => 'Неограничено съхранение в облак';

  @override
  String get deleteNote => 'Изтриване на бележка';

  @override
  String get shareNote => 'Споделяне на бележка';

  @override
  String get editNote => 'Редактиране на бележка';

  @override
  String get searchNotes => 'Търсене в бележки...';

  @override
  String get noNotesFound => 'Няма намерени бележки';

  @override
  String get captureThoughts => 'Уловете мислите си незабавно.';

  @override
  String get createNote => 'Създаване на бележка';

  @override
  String get customOrder => 'Персонализирана поръчка';

  @override
  String get newestFirst => 'Първо най-новите';

  @override
  String get oldestFirst => 'Първо най-старите';

  @override
  String get titleAZ => 'Заглавие: A-Z';

  @override
  String get titleZA => 'Заглавие: Z-A';

  @override
  String get deleteAllQuestion => 'Изтриване на всички?';

  @override
  String get moveToRecycleBin => 'Преместване на всички бележки в кошчето?';

  @override
  String get moveToBinQuestion => 'Преместване в кошчето?';

  @override
  String get restoreNoteLater =>
      'Можете да възстановите тази бележка по-късно.';

  @override
  String get move => 'Движи се';

  @override
  String get myThoughts => 'Моите мисли';

  @override
  String get selected => 'Избрано';

  @override
  String get noContent => 'Без съдържание';

  @override
  String get untitled => 'Без заглавие';

  @override
  String get chooseWallpapers => 'Изберете от 10+ динамични тапети';

  @override
  String get backupData => 'Архивиране на данни';

  @override
  String get saveJsonFile =>
      'Запазване на JSON файл, съдържащ всички ваши данни?';

  @override
  String get exportNow => 'Експортирайте сега';

  @override
  String get importDataTitle => 'Импортиране на данни';

  @override
  String get mergeBackupFile =>
      'Обединяване на архивен файл с текущите ви елементи?';

  @override
  String get selectFile => 'Изберете Файл';

  @override
  String get backupSaved => 'Резервното копие е запазено успешно!';

  @override
  String get exportFailed => 'Неуспешно експортиране.';

  @override
  String importSuccess(Object count) {
    return '$count елемента възстановени успешно!';
  }

  @override
  String get importFailed => 'Импортирането не бе успешно.';

  @override
  String widgetAdded(String widget) {
    return 'Приспособлението е добавено към началния екран!';
  }

  @override
  String get widgetRequestSent =>
      'Заявката за приспособление е изпратена. Моля, проверете началния екран.';

  @override
  String get widgetAddFailed => 'Неуспешно добавяне на приспособление';

  @override
  String get autoSaveEnabled => 'Автоматичното запазване е активирано.';

  @override
  String get autoSaveDisabled => 'Автоматичното запазване е деактивирано.';

  @override
  String get homeScreenWidgets => 'Уиджети на началния екран';

  @override
  String get notificationsTitle => 'Известия';

  @override
  String get dataBackup => 'Данни и архивиране';

  @override
  String get feedbackSupport => 'Обратна връзка и поддръжка';

  @override
  String get creditsTitle => 'Кредити';

  @override
  String get privacyMaintenance => 'Поверителност и поддръжка';

  @override
  String get aboutTitle => 'За';

  @override
  String get premium => 'Премиум';

  @override
  String get appearanceTitle => 'Външен вид';

  @override
  String get clipboardTitle => 'Клипборд';

  @override
  String get settingsSubtitle => 'Персонализирайте вашето изживяване';

  @override
  String get welcomeTitle => 'Добре дошли в CopyClip';

  @override
  String get welcomeDescription =>
      'Вашият най-добър спътник в продуктивността. Нека ви настроим с мощни инструменти за управление на деня ви.';

  @override
  String get onboardingNotesTitle => 'Интелигентни бележки';

  @override
  String get onboardingNotesDesc =>
      'Улавяйте незабавно идеи с обогатен текстов формат. Организирайте мислите си и никога повече не губете страхотна идея.';

  @override
  String get onboardingTodosTitle => 'Управление на задачите';

  @override
  String get onboardingTodosDesc =>
      'Останете на върха на играта си. Създавайте списъци със задачи, задавайте приоритети и смазвайте целите си една отметка наведнъж.';

  @override
  String get onboardingJournalTitle => 'Личен дневник';

  @override
  String get onboardingJournalDesc =>
      'Отразете деня си. Лично пространство, където да запишете своите спомени, чувства и ежедневни преживявания.';

  @override
  String get onboardingClipboardTitle => 'Мениджър на клипборда';

  @override
  String get onboardingClipboardDesc =>
      'Копирайте веднъж, поставете навсякъде. Достъп до хронологията на клипборда, за да извлечете фрагменти, които сте копирали по-рано.';

  @override
  String get featuresNotesDesc => 'Създавайте и управлявайте своите бележки';

  @override
  String get featuresTodosDesc => 'Следете задачите си';

  @override
  String get featuresJournalDesc => 'Запишете вашите мисли';

  @override
  String get featuresClipboardDesc => 'Достъп до хронологията на клипборда';

  @override
  String get chooseYourAura => 'Изберете своята аура';

  @override
  String get expressYourselfTheme => 'Изразете себе си с нов цвят на темата!';

  @override
  String get autoSaveClipboard => 'Автоматично запазване на клипборда';

  @override
  String get autoSaveClipboardDesc =>
      'Автоматично запазване на копирани елементи';

  @override
  String get permissionDeniedSettings =>
      'Разрешението е отказано завинаги. Моля, активирайте в Настройки.';

  @override
  String get notificationsEnabled => 'Известията са активирани!';

  @override
  String get redirectingToSettings =>
      'Пренасочване към настройки за деактивиране на известията...';

  @override
  String get premiumAccess => 'Премиум достъп';

  @override
  String get premiumActiveUntil => 'Premium Активен до';

  @override
  String get unlockAllFeatures => 'Отключете всички функции';

  @override
  String get buyPremium => 'Купете Premium (7 дни)';

  @override
  String costCoins(Object cost) {
    return 'Цена: $cost монети';
  }

  @override
  String get premiumActivated => 'Premium активиран за 7 дни!';

  @override
  String get premiumActive => 'Premium Active';

  @override
  String get expires => 'Изтича:';

  @override
  String get temporaryAccess => 'Временен достъп';

  @override
  String get journalExpression => 'Дневник и изразяване';

  @override
  String get artisticDesigns => 'Художествен дизайн';

  @override
  String get artisticDesignsDesc =>
      'Отключете 10+ уникални теми за карти за дневници';

  @override
  String get premiumLayouts => 'Първокласни оформления';

  @override
  String get premiumLayoutsDesc =>
      'Ексклузивни начини за преглед на вашите спомени';

  @override
  String get clipboardAutoSaveDesc =>
      'Заснемане на историята на клипборда във фонов режим';

  @override
  String get proWidgets => 'Професионални джаджи';

  @override
  String get proWidgetsDesc => 'Всички функции, налични на началния екран';

  @override
  String get dataExport => 'Данни и експорт';

  @override
  String get advancedBackup => 'Разширено архивиране';

  @override
  String get advancedBackupDesc => 'Сигурен импорт/експорт на всички данни';

  @override
  String get pdfExport => 'PDF експортиране';

  @override
  String get pdfExportDesc => 'Експортирайте бележки и дневници в PDF';

  @override
  String get printReady => 'Готов за печат';

  @override
  String get printReadyDesc => 'Поддръжка на директен печат';

  @override
  String get richTextEditor => 'Обогатен текстов редактор';

  @override
  String get advancedSearch => 'Разширено търсене';

  @override
  String get advancedSearchDesc => 'Търсене и замяна във вашия текст';

  @override
  String get richMedia => 'Мултимедия';

  @override
  String get richMediaDesc => 'Вмъкнете изображения, видеоклипове и връзки';

  @override
  String get editorStyling => 'Стил на редактора';

  @override
  String get editorStylingDesc => 'Персонализиран фон на текст и редактор';

  @override
  String get balance => 'Баланс';

  @override
  String get loadingAd => 'Рекламата се зарежда...';

  @override
  String watchAd(Object amount) {
    return 'Гледайте реклама (+$amount)';
  }

  @override
  String get loadAd => 'Зареди реклама';

  @override
  String get backupDataDesc => 'Запазете JSON файл с вашите данни';

  @override
  String get importDataDesc => 'Обединете архивен файл в CopyClip';

  @override
  String get notificationPermissionDenied =>
      'Разрешението за известяване е отказано.';

  @override
  String get typeNewTask => 'Въведете нова задача...';

  @override
  String get addTask => 'Добавяне на задача';

  @override
  String get completed => 'Завършено';

  @override
  String get moveTasksToRecycleBin =>
      'Преместване на всички активни задачи в кошчето?';

  @override
  String fileNotFoundError(Object path) {
    return 'Грешка: Файлът не е намерен на $path';
  }

  @override
  String get entryCopied => 'Записът е копиран';

  @override
  String get moveEntriesToRecycleBin =>
      'Преместване на всички активни записи в кошчето?';

  @override
  String get startWritingStory => 'Започнете да пишете своята история';

  @override
  String get recordMemories => 'Запишете ежедневните си спомени и чувства.';

  @override
  String get writeJournal => 'Напиши дневник';

  @override
  String get myMemories => 'Моите спомени';

  @override
  String get sortJournal => 'Сортиране на дневник';

  @override
  String get byMood => 'По настроение';

  @override
  String get searchMemories => 'Търсене в спомени...';

  @override
  String get selectAll => 'Изберете Всички';

  @override
  String get deleteSelected => 'Изтриване на избраното';

  @override
  String get taskCompletedExclamation => 'Задачата е изпълнена!';

  @override
  String get taskUncompletedExclamation => 'Задачата не е изпълнена';

  @override
  String get clipboardUpdatedExclamation => 'Клипбордът е актуализиран!';

  @override
  String clipboardSavedContent(Object content) {
    return 'Клипбордът е запазен: $content';
  }

  @override
  String get overview => 'Преглед';

  @override
  String get colorAurora => 'Аврора';

  @override
  String get colorCosmic => 'Космически';

  @override
  String get colorNebula => 'Мъглявина';

  @override
  String get colorStarlight => 'Звездна светлина';

  @override
  String get colorSolar => 'Слънчева';

  @override
  String get colorNova => 'Нов';

  @override
  String get loadingStepLoading => 'Зареждане...';

  @override
  String get loadingStepDatabase => 'Базата данни се настройва...';

  @override
  String get loadingStepSystem => 'Конфигуриране на системата...';

  @override
  String get loadingStepReady => 'Готови';

  @override
  String get productivityCompanion => 'Вашият спътник в продуктивността';

  @override
  String get done => 'Готово';

  @override
  String get newNote => 'Нова бележка';

  @override
  String get changeColor => 'Промяна на цвета';

  @override
  String get copyContent => 'Копиране на съдържание';

  @override
  String get titleOptional => 'Заглавие (по избор)';

  @override
  String get exportAsPdf => 'Експортиране като PDF';

  @override
  String get taskDueNow => 'Задачата трябва да бъде изпълнена сега';

  @override
  String get moveTaskToBinTitle => 'Преместване на задача в кошчето?';

  @override
  String get restoreTaskLater =>
      'Можете да възстановите тази задача по-късно от настройките.';

  @override
  String get newTask => 'Нова задача';

  @override
  String get editTask => 'Редактиране на задача';

  @override
  String get undo => 'Отмяна';

  @override
  String get redo => 'Повторете';

  @override
  String get category => 'Категория';

  @override
  String get categoryHint => 'напр. Работа, Фитнес зала';

  @override
  String get whatNeedsToBeDone => 'Какво трябва да се направи?';

  @override
  String get enterTaskDetails => 'Въведете подробности за задачата...';

  @override
  String get setDueDate => 'Задаване на краен срок';

  @override
  String get dueDate => 'Две дати';

  @override
  String get sortAndFilter => 'Сортиране и филтриране';

  @override
  String get sortBy => 'СОРТИРАНЕ ПО';

  @override
  String get categories => 'Категории';

  @override
  String get all => 'Всички';

  @override
  String get reset => 'Нулиране';

  @override
  String get apply => 'Кандидатствайте';

  @override
  String errorLoadingData(String error) {
    return 'Грешка при зареждане на данни.\n\n$error';
  }

  @override
  String get dailyQuote1 =>
      'Най-добрият начин да предвидите бъдещето е да го създадете.';

  @override
  String get dailyQuote2 =>
      'Богатството не се състои в притежаването на големи притежания, а в това да имаш малко желания.';

  @override
  String get dailyQuote3 => 'Времето е основната валута.';

  @override
  String get dailyQuote4 => 'Успехът не е окончателен, провалът не е фатален.';

  @override
  String get dailyQuote5 =>
      'Фокусирайте се върху решението, а не върху проблема.';

  @override
  String get dailyQuote6 => 'Вашата мрежа е вашата нетна стойност.';

  @override
  String get moodHappy => 'Щастлив';

  @override
  String get moodExcited => 'развълнуван';

  @override
  String get moodNeutral => 'Неутрален';

  @override
  String get moodSad => 'тъжно';

  @override
  String get moodStressed => 'стресиран';

  @override
  String exportDate(String date) {
    return '📅 $date';
  }

  @override
  String exportMood(String emoji, String mood) {
    return 'Настроение: $emoji $mood';
  }

  @override
  String exportTitle(String title) {
    return 'ЗАГЛАВИЕ: $title';
  }

  @override
  String exportTags(String tags) {
    return 'Етикети: $tags';
  }

  @override
  String get noResultsFound => 'Няма намерени резултати';

  @override
  String get noItems => 'Няма елементи';

  @override
  String get rename => 'Преименуване';

  @override
  String get deleteFolder => 'Изтриване на папка';

  @override
  String get deleteSketchesQuestion => 'Изтриване на скици?';

  @override
  String get deleteFolderConfirmation =>
      'Всички скици в тази папка ще бъдат изтрити за постоянно.';

  @override
  String get chooseColor => 'Изберете цвят';

  @override
  String get searchClips => 'Търсене на клипове...';

  @override
  String get clipboardEmpty => 'Клипбордът е празен';

  @override
  String get addItem => 'Добавяне на артикул';

  @override
  String get clipColor => 'Цвят на клипа';

  @override
  String get newClip => 'Нов клип';

  @override
  String get editClip => 'Редактиране на клип';

  @override
  String get restoreClipLater => 'Можете да възстановите този клип по-късно.';

  @override
  String get dataDistribution => 'РАЗПРОСТРАНЕНИЕ НА ДАННИ';

  @override
  String get taskProgress => 'ПРОГРЕС НА ЗАДАЧАТА';

  @override
  String get quickStats => 'БЪРЗА СТАТИСТИКА';

  @override
  String get taskCompletion => 'Изпълнение на задачата';

  @override
  String get noItemsForDate => 'Няма артикули за тази дата';

  @override
  String get enjoyFreeTime => 'Насладете се на свободното си време!';

  @override
  String get searchThisDay => 'Търсете в този ден...';

  @override
  String get finance => 'Финанси';

  @override
  String get permanentlyDelete => 'Изтриване за постоянно?';

  @override
  String deleteSelectionConfirmation(int foldersCount, int sketchesCount) {
    return 'Това ще изтрие за постоянно $foldersCount папки (и техните скици) и $sketchesCount други скици.\n\nТова не може да бъде отменено.';
  }

  @override
  String get deleteForever => 'Изтрий завинаги';

  @override
  String selectedCount(int count) {
    return '$count избрани';
  }

  @override
  String get deleteItemQuestion => 'Изтриване на елемент?';

  @override
  String get deleteItemConfirmation => 'Това ще премести елемента в кошчето.';

  @override
  String get moveToBinItem => 'Преместване в кошчето?';

  @override
  String get moveToBinConfirmation => 'Можете да го възстановите по-късно.';

  @override
  String selectedItems(int count) {
    return '$count избрани';
  }

  @override
  String get recentClips => 'Скорошни клипове';

  @override
  String get copied => 'Копирано!';

  @override
  String get copiedPlainText => 'Копиран обикновен текст';

  @override
  String get clipTheme => 'Тема за клип';

  @override
  String get justNow => 'Току-що';

  @override
  String minutesAgo(Object count) {
    return 'преди $count мин';
  }

  @override
  String hoursAgo(Object count) {
    return 'преди $count ч';
  }

  @override
  String daysAgo(Object count) {
    return 'преди $count дни';
  }

  @override
  String get noTasksFound => 'Няма намерени задачи.';

  @override
  String get searchTasks => 'Задачи за търсене...';

  @override
  String get taskReminder => 'Напомняне за задача';

  @override
  String get untitledNote => 'Бележка без заглавие';

  @override
  String get dailyEntry => 'Ежедневен вход';

  @override
  String get clipboardHistory => 'История на клипборда';

  @override
  String get deletePermanentlyContent =>
      'Това действие не може да бъде отменено.';

  @override
  String get emptyRecycleBinTitle => 'Изпразване на кошчето?';

  @override
  String emptyRecycleBinContent(Object count) {
    return 'Всички $count елемента ще бъдат изтрити за постоянно.';
  }

  @override
  String get emptyBin => 'Изпразване на кошчето';

  @override
  String get recycleBinEmpty => 'Кошчето е празно';

  @override
  String get deletedItemsAppearHere => 'Изтритите елементи ще се появят тук.';

  @override
  String get empty => 'празна';

  @override
  String get recent => 'Скорошни';

  @override
  String categoryLabel(Object category) {
    return 'Категория: $category';
  }

  @override
  String get general => 'генерал';

  @override
  String get description => 'Описание';

  @override
  String get daily => 'Ежедневно';

  @override
  String get weekly => 'Ежеседмично';

  @override
  String get monthly => 'Месечно';

  @override
  String get yearly => 'Годишно';

  @override
  String get analysis => 'Анализ';

  @override
  String get transactions => 'Транзакции';

  @override
  String get ok => 'добре';

  @override
  String get bulkImport => 'Bulk Import';
}
