// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Japanese (`ja`).
class AppLocalizationsJa extends AppLocalizations {
  AppLocalizationsJa([String locale = 'ja']) : super(locale);

  @override
  String get settings => '設定';

  @override
  String get language => '言語';

  @override
  String get systemDefault => 'システムデフォルト';

  @override
  String get notes => 'ノート';

  @override
  String get todos => 'ToDo';

  @override
  String get expenses => '支出';

  @override
  String get journal => 'ジャーナル';

  @override
  String get calendar => 'カレンダー';

  @override
  String get clipboard => 'クリップボード';

  @override
  String get canvas => 'キャンバス';

  @override
  String get save => '保存';

  @override
  String get create => '作成';

  @override
  String get cancel => 'キャンセル';

  @override
  String get delete => '削除';

  @override
  String get edit => '編集';

  @override
  String get share => '共有';

  @override
  String get copy => 'コピー';

  @override
  String get unsavedChanges => '未保存の変更';

  @override
  String get confirmDelete => '削除の確認';

  @override
  String get discard => '破棄';

  @override
  String get createPost => '投稿を作成';

  @override
  String get post => '投稿';

  @override
  String get postingTo => '投稿先';

  @override
  String get whatsOnYourMind => 'いまどうしてる？';

  @override
  String get pickImages => '画像を選択';

  @override
  String get pickVideo => '動画を選択';

  @override
  String get camera => 'カメラ';

  @override
  String get gallery => 'ギャラリー';

  @override
  String get search => '検索';

  @override
  String get pleaseEnterTask => 'タスクを入力してください';

  @override
  String get deleteTask => 'タスクを削除';

  @override
  String get selectItems => '項目を選択';

  @override
  String get deleteAll => 'すべて削除';

  @override
  String error(Object error) {
    return 'エラー: $error';
  }

  @override
  String get orderingOnlyAvailableInAllPosts => '並べ替えは「すべての投稿」でのみ利用可能です';

  @override
  String get deletePost => '投稿を削除';

  @override
  String get postDeleted => '投稿が削除されました';

  @override
  String get premiumFeatures => 'プレミアム機能';

  @override
  String get manageCoinsAdsPremium => 'コイン、広告、プレミアムステータスの管理';

  @override
  String get themeMode => 'テーマモード';

  @override
  String get accentColor => 'アクセントカラー';

  @override
  String get backgroundDesign => '背景デザイン';

  @override
  String get pushNotifications => 'プッシュ通知';

  @override
  String get recycleBin => 'ゴミ箱';

  @override
  String get exportData => 'データをエクスポート';

  @override
  String get importData => 'データをインポート';

  @override
  String get rateApp => 'アプリを評価';

  @override
  String get sendFeedback => 'フィードバックを送信';

  @override
  String get privacyPolicy => 'プライバシーポリシー';

  @override
  String get version => 'バージョン';

  @override
  String get buildNumber => 'ビルド番号';

  @override
  String get system => 'システム';

  @override
  String get light => 'ライト';

  @override
  String get dark => 'ダーク';

  @override
  String get itemRestored => '項目が復元されました';

  @override
  String get recycleBinCleared => 'ゴミ箱が空になりました';

  @override
  String get allPostsDeleted => 'すべての投稿が削除されました';

  @override
  String get newPost => '新しい投稿';

  @override
  String get textCopiedToClipboardFacebook =>
      'テキストがクリップボードにコピーされました（Facebookポリシー）';

  @override
  String get tiktokSharingRequiresVideoImage => 'TikTok共有には動画または画像が必要です';

  @override
  String errorSharing(Object error) {
    return '共有エラー: $error';
  }

  @override
  String shareToStory(Object platform) {
    return '$platformストーリーで共有';
  }

  @override
  String shareToFeed(Object platform) {
    return '$platformフィードで共有';
  }

  @override
  String get unlockPermanently => '永久にアンロック';

  @override
  String get notEnoughCoins => 'コインが足りません！';

  @override
  String youEarnedCoins(Object amount) {
    return '$amountコインを獲得しました！';
  }

  @override
  String get contentCopied => 'コンテンツをコピーしました';

  @override
  String get selectDateTime => '日時を選択';

  @override
  String get areYouSureYouWantToDeleteThisPost => 'この投稿を削除してもよろしいですか？';

  @override
  String get socialPosts => 'ソーシャル投稿';

  @override
  String get watchAdToEarnCoins => '広告を見てコインを獲得';

  @override
  String get premiumUnlocked => 'プレミアムをアンロックしました';

  @override
  String get removeAds => '広告を削除';

  @override
  String get unlimitedCloudStorage => '無制限のクラウドストレージ';

  @override
  String get deleteNote => 'ノートを削除';

  @override
  String get shareNote => 'ノートを共有';

  @override
  String get editNote => 'ノートを編集';

  @override
  String get searchNotes => 'ノートを検索...';

  @override
  String get noNotesFound => 'ノートが見つかりません';

  @override
  String get captureThoughts => '考えをすぐに記録しましょう。';

  @override
  String get createNote => 'ノートを作成';

  @override
  String get customOrder => 'カスタム順';

  @override
  String get newestFirst => '新しい順';

  @override
  String get oldestFirst => '古い順';

  @override
  String get titleAZ => 'タイトル: A-Z';

  @override
  String get titleZA => 'タイトル: Z-A';

  @override
  String get deleteAllQuestion => 'すべて削除しますか？';

  @override
  String get moveToRecycleBin => 'すべてのノートをゴミ箱に移動しますか？';

  @override
  String get moveToBinQuestion => 'ゴミ箱に移動しますか？';

  @override
  String get restoreNoteLater => 'このノートは後で復元できます。';

  @override
  String get move => '移動';

  @override
  String get myThoughts => 'マイ・ソート';

  @override
  String get selected => '選択済み';

  @override
  String get noContent => 'コンテンツなし';

  @override
  String get untitled => '無題';

  @override
  String get chooseWallpapers => '10種類以上のダイナミックな壁紙から選択';

  @override
  String get backupData => 'データのバックアップ';

  @override
  String get saveJsonFile => 'すべてのデータを含むJSONファイルを保存しますか？';

  @override
  String get exportNow => '今すぐエクスポート';

  @override
  String get importDataTitle => 'データのインポート';

  @override
  String get mergeBackupFile => 'バックアップファイルを現在の項目に統合しますか？';

  @override
  String get selectFile => 'ファイルを選択';

  @override
  String get backupSaved => 'バックアップが正常に保存されました！';

  @override
  String get exportFailed => 'エクスポートに失敗しました。';

  @override
  String importSuccess(Object count) {
    return '$count個の項目が正常に復元されました！';
  }

  @override
  String get importFailed => 'インポートに失敗しました。';

  @override
  String widgetAdded(String widget) {
    return 'ウィジェットがホーム画面に追加されました！';
  }

  @override
  String get widgetRequestSent => 'ウィジェットのリクエストを送信しました。ホーム画面を確認してください。';

  @override
  String get widgetAddFailed => 'ウィジェットの追加に失敗しました';

  @override
  String get autoSaveEnabled => '自動保存が有効になりました。';

  @override
  String get autoSaveDisabled => '自動保存が無効になりました。';

  @override
  String get homeScreenWidgets => 'ホーム画面ウィジェット';

  @override
  String get notificationsTitle => '通知';

  @override
  String get dataBackup => 'データとバックアップ';

  @override
  String get feedbackSupport => 'フィードバックとサポート';

  @override
  String get creditsTitle => 'クレジット';

  @override
  String get privacyMaintenance => 'プライバシーとメンテナンス';

  @override
  String get aboutTitle => 'このアプリについて';

  @override
  String get premium => 'プレミアム';

  @override
  String get appearanceTitle => '外観';

  @override
  String get clipboardTitle => 'クリップボード';

  @override
  String get settingsSubtitle => '体験をカスタマイズ';

  @override
  String get welcomeTitle => 'CopyClipへようこそ';

  @override
  String get welcomeDescription =>
      'あなたの究極の生産性パートナーです。一日を管理するための強力なツールをセットアップしましょう。';

  @override
  String get onboardingNotesTitle => 'スマートノート';

  @override
  String get onboardingNotesDesc =>
      'リッチテキスト形式でアイデアを瞬時にキャプチャ。考えを整理し、素晴らしいアイデアを二度と逃しません。';

  @override
  String get onboardingTodosTitle => 'タスク管理';

  @override
  String get onboardingTodosDesc =>
      '常に一歩先へ。ToDoリストを作成し、優先順位を設定し、目標を一つずつ達成しましょう。';

  @override
  String get onboardingExpensesTitle => '支出の追跡';

  @override
  String get onboardingExpensesDesc => '家計をコントロール。収入と支出を簡単に追跡して、支出の習慣を理解しましょう。';

  @override
  String get onboardingJournalTitle => 'パーソナルジャーナル';

  @override
  String get onboardingJournalDesc =>
      '一日を振り返る。思い出、感情、日々の体験を書き留めるためのプライベートな空間です。';

  @override
  String get onboardingCalendarTitle => 'カレンダーとイベント';

  @override
  String get onboardingCalendarDesc => '一瞬を逃さない。スケジュールを整理し、今後の重要なイベントを追跡しましょう。';

  @override
  String get onboardingClipboardTitle => 'クリップボード管理';

  @override
  String get onboardingClipboardDesc =>
      '一度コピーすればどこでもペースト。クリップボードの履歴にアクセスして、前にコピーしたスニペットを取り出せます。';

  @override
  String get onboardingCanvasTitle => 'クリエイティブキャンパス';

  @override
  String get onboardingCanvasDesc =>
      '創造性を解き放つ。自由形式のデジタルキャンバスでアイデアを描き、スケッチし、視覚化しましょう。';

  @override
  String get featuresNotesDesc => 'ノートの作成と管理';

  @override
  String get featuresTodosDesc => 'タスクの追跡';

  @override
  String get featuresExpensesDesc => '支出の監視';

  @override
  String get featuresJournalDesc => '考えを書き留める';

  @override
  String get featuresCalendarDesc => 'スケジュールの整理';

  @override
  String get featuresClipboardDesc => 'クリップボード履歴へのアクセス';

  @override
  String get featuresCanvasDesc => '自由に描画とスケッチ';

  @override
  String get featuresSocialPost => 'ソーシャル投稿';

  @override
  String get featuresSocialPostDesc => '魅力的なソーシャルメディアコンテンツを作成';

  @override
  String get chooseYourAura => 'あなたのオーラを選択';

  @override
  String get expressYourselfTheme => '新しいテーマカラーで自分を表現しましょう！';

  @override
  String get level => 'レベル';

  @override
  String get xpToNextLevel => '次のレベルまでのXP';

  @override
  String get checkUpcomingEvents => '今後のイベントを確認';

  @override
  String get startNewSketch => '新しいスケッチを開始';

  @override
  String get noTransactionsMonth => '今月の取引はありません';

  @override
  String transactionsThisMonth(num count) {
    return '今月は$count件の取引があります';
  }

  @override
  String get autoSaveClipboard => 'クリップボードの自動保存';

  @override
  String get autoSaveClipboardDesc => 'コピーした項目を自動的に保存する';

  @override
  String get permissionDeniedSettings => '権限が永久に拒否されました。設定で有効にしてください。';

  @override
  String get notificationsEnabled => '通知が有効になりました！';

  @override
  String get redirectingToSettings => '通知を無効にするために設定にリダイレクトしています...';

  @override
  String get premiumAccess => 'プレミアムアクセス';

  @override
  String get premiumActiveUntil => 'プレミアム有効期限';

  @override
  String get unlockAllFeatures => 'すべての機能をアンロック';

  @override
  String get buyPremium => 'プレミアムを購入（7日間）';

  @override
  String costCoins(Object cost) {
    return 'コスト: $costコイン';
  }

  @override
  String get premiumActivated => 'プレミアムが7日間有効になりました！';

  @override
  String get premiumActive => 'プレミアム有効';

  @override
  String get expires => '有効期限:';

  @override
  String get temporaryAccess => '一時的なアクセス';

  @override
  String get journalExpression => 'ジャーナルと表現';

  @override
  String get artisticDesigns => '芸術的なデザイン';

  @override
  String get artisticDesignsDesc => '10種類以上のユニークなジャーナルカードテーマをアンロック';

  @override
  String get premiumLayouts => 'プレミアムレイアウト';

  @override
  String get premiumLayoutsDesc => '思い出を表示する特別な方法';

  @override
  String get calendarTools => 'カレンダーとツール';

  @override
  String get fullCalendar => 'フルカレンダー';

  @override
  String get fullCalendarDesc => '完全なイベント管理システム';

  @override
  String get clipboardAutoSaveDesc => 'バックグラウンドでのクリップボード履歴取得';

  @override
  String get proWidgets => 'プロ・ウィジェット';

  @override
  String get proWidgetsDesc => 'すべての機能がホーム画面で利用可能';

  @override
  String get dataExport => 'データとエクスポート';

  @override
  String get advancedBackup => '高度なバックアップ';

  @override
  String get advancedBackupDesc => 'すべてのデータの安全なインポート/エクスポート';

  @override
  String get pdfExport => 'PDFエクスポート';

  @override
  String get pdfExportDesc => 'ノートやジャーナルをPDFで書き出し';

  @override
  String get printReady => '印刷対応';

  @override
  String get printReadyDesc => 'ダイレクト印刷をサポート';

  @override
  String get richTextEditor => 'リッチテキストエディタ';

  @override
  String get advancedSearch => '高度な検索';

  @override
  String get advancedSearchDesc => 'テキスト内の検索と置換';

  @override
  String get richMedia => 'リッチメディア';

  @override
  String get richMediaDesc => '画像、動画、リンクの挿入';

  @override
  String get editorStyling => 'エディタのスタイリング';

  @override
  String get editorStylingDesc => 'カスタムテキストとエディタの背景';

  @override
  String get balance => '残高';

  @override
  String get loadingAd => '広告を読み込み中...';

  @override
  String watchAd(Object amount) {
    return '広告を見る (+$amount)';
  }

  @override
  String get loadAd => '広告を読み込む';

  @override
  String get backupDataDesc => 'データのJSONファイルを保存';

  @override
  String get importDataDesc => 'バックアップファイルをCopyClipに統合';

  @override
  String get notificationPermissionDenied => '通知権限が拒否されました。';

  @override
  String get typeNewTask => '新しいタスクを入力...';

  @override
  String get addTask => 'タスクを追加';

  @override
  String get completed => '完了';

  @override
  String get greatJob => '素晴らしい！';

  @override
  String youEarnedXPNextTask(Object amount, Object date) {
    return '$amount XPを獲得しました！次のタスク: $date';
  }

  @override
  String taskCompletedXP(Object amount) {
    return 'タスク完了！ +$amount XP';
  }

  @override
  String get moveTasksToRecycleBin => 'すべてのアクティブなタスクをゴミ箱に移動しますか？';

  @override
  String get deleteAllPosts => 'すべての投稿を削除';

  @override
  String get deleteAllPostsConfirmation =>
      '本当にすべてのソーシャル投稿を削除しますか？この操作は取り消せません。';

  @override
  String get allPosts => 'すべての投稿';

  @override
  String get favorites => 'お気に入り';

  @override
  String get drafts => '下書き';

  @override
  String get noFavoritesYet => 'お気に入りはまだありません';

  @override
  String get noDraftsYet => '下書きはまだありません';

  @override
  String get startSocialJourney => 'ソーシャルジャーニーを始めましょう！';

  @override
  String get draft => '下書き';

  @override
  String attachmentCount(num count) {
    return '添付ファイル $count件';
  }

  @override
  String get pleaseAddContent => '共有するコンテンツまたはメディアを追加してください';

  @override
  String fileNotFoundError(Object path) {
    return 'エラー: $path にファイルが見つかりません';
  }

  @override
  String get checkFacebookApp => 'Facebookアプリを確認してください';

  @override
  String get systemShare => 'システム共有';

  @override
  String get socialPost => 'ソーシャル投稿';

  @override
  String get favorite => 'お気に入り';

  @override
  String get saveDraft => '下書きを保存';

  @override
  String get entryCopied => 'エントリをコピーしました';

  @override
  String get moveEntriesToRecycleBin => 'すべてのアクティブなエントリをゴミ箱に移動しますか？';

  @override
  String get startWritingStory => 'ストーリーを書き始めましょう';

  @override
  String get recordMemories => '日々の思い出や感情を記録しましょう。';

  @override
  String get writeJournal => 'ジャーナルを書く';

  @override
  String get myMemories => '私の思い出';

  @override
  String get sortJournal => 'ジャーナルを並べ替え';

  @override
  String get byMood => '気分で絞り込む';

  @override
  String get searchMemories => '思い出を検索...';

  @override
  String get selectAll => 'すべて選択';

  @override
  String get deleteSelected => '選択項目を削除';

  @override
  String get taskCompletedExclamation => 'タスク完了！';

  @override
  String get taskUncompletedExclamation => 'タスク未完了';

  @override
  String get clipboardUpdatedExclamation => 'クリップボードが更新されました！';

  @override
  String clipboardSavedContent(Object content) {
    return '保存されたクリップボード: $content';
  }

  @override
  String get overview => '概要';

  @override
  String get colorAurora => 'オーロラ';

  @override
  String get colorCosmic => 'コズミック';

  @override
  String get colorNebula => '星雲';

  @override
  String get colorStarlight => 'スターライト';

  @override
  String get colorSolar => 'ソーラー';

  @override
  String get colorNova => 'ノバ';

  @override
  String get loadingStepLoading => '読み込み中...';

  @override
  String get loadingStepDatabase => 'データベースをセットアップ中...';

  @override
  String get loadingStepSystem => 'システムを構成中...';

  @override
  String get loadingStepReady => '準備完了';

  @override
  String get productivityCompanion => 'あなたの生産性パートナー';

  @override
  String get done => '完了';

  @override
  String get newNote => '新しいノート';

  @override
  String get changeColor => '色を変更';

  @override
  String get copyContent => '内容をコピー';

  @override
  String get titleOptional => 'タイトル（任意）';

  @override
  String get exportAsPdf => 'PDFとしてエクスポート';

  @override
  String get taskDueNow => '期限が来たタスク';

  @override
  String get moveTaskToBinTitle => 'タスクをゴミ箱に移動しますか？';

  @override
  String get restoreTaskLater => 'このタスクは後で設定から復元できます。';

  @override
  String get newTask => '新しいタスク';

  @override
  String get editTask => 'タスクを編集';

  @override
  String get undo => '元に戻す';

  @override
  String get redo => 'やり直し';

  @override
  String get category => 'カテゴリー';

  @override
  String get categoryHint => '例：仕事、ジム';

  @override
  String get whatNeedsToBeDone => '何をすべきですか？';

  @override
  String get enterTaskDetails => 'タスクの詳細を入力...';

  @override
  String get setDueDate => '期限を設定';

  @override
  String get dueDate => '期限';

  @override
  String get expenseTitle => '支出';

  @override
  String searchInCurrency(String currency) {
    return '$currency で検索...';
  }

  @override
  String get sortAndFilter => '並べ替えとフィルター';

  @override
  String get sortBy => '並べ替え:';

  @override
  String get highestAmount => '金額が高い順';

  @override
  String get lowestAmount => '金額が低い順';

  @override
  String get moreFilters => '詳細フィルター...';

  @override
  String get filterExpenses => '支出をフィルター';

  @override
  String get transactionType => '取引タイプ';

  @override
  String get categories => 'カテゴリー';

  @override
  String get all => 'すべて';

  @override
  String get income => '収入';

  @override
  String get expense => '支出';

  @override
  String get reset => 'リセット';

  @override
  String get apply => '適用';

  @override
  String newExpense(String currency) {
    return '新しい $currency';
  }

  @override
  String errorLoadingData(String error) {
    return 'データの読み込み中にエラーが発生しました。\n\n$error';
  }

  @override
  String get dailyQuote1 => '未来を予測する最良の方法は、それを創ることだ。';

  @override
  String get dailyQuote2 => '富とは、多くの財産を持つことではなく、欲を少なくすることにある。';

  @override
  String get dailyQuote3 => '時間は究極の通貨である。';

  @override
  String get dailyQuote4 => '成功は最終的なものではなく、失敗は致命的なものではない。';

  @override
  String get dailyQuote5 => '問題ではなく、解決策に集中せよ。';

  @override
  String get dailyQuote6 => 'あなたのネットワークが、あなたの純資産である。';

  @override
  String get moodHappy => '嬉しい';

  @override
  String get moodExcited => 'ワクワク';

  @override
  String get moodNeutral => '普通';

  @override
  String get moodSad => '悲しい';

  @override
  String get moodStressed => 'ストレス';

  @override
  String exportDate(String date) {
    return '📅 $date';
  }

  @override
  String exportMood(String emoji, String mood) {
    return '気分: $emoji $mood';
  }

  @override
  String exportTitle(String title) {
    return 'タイトル: $title';
  }

  @override
  String exportTags(String tags) {
    return '\nタグ: $tags';
  }

  @override
  String get instagram => 'Instagram';

  @override
  String get facebook => 'Facebook';

  @override
  String get tiktok => 'TikTok';

  @override
  String get newSketch => '新しいスケッチ';

  @override
  String get searchSketches => 'スケッチやフォルダを検索...';

  @override
  String get noResultsFound => '結果が見つかりません';

  @override
  String get noItems => '項目なし';

  @override
  String get noDrawingsYet => '描画はまだありません';

  @override
  String get canvasIntro => 'キャンバスで創造性を解き放ちましょう！';

  @override
  String get newCanvas => '新しいキャンバス';

  @override
  String get rename => '名前を変更';

  @override
  String get deleteFolder => 'フォルダを削除';

  @override
  String get deleteSketchesQuestion => 'スケッチを削除しますか？';

  @override
  String get deleteFolderConfirmation => 'このフォルダ内のすべてのスケッチは永久に削除されます。';

  @override
  String get renameFolder => 'フォルダ名を変更';

  @override
  String get chooseColor => '色を選択';

  @override
  String get deleteFolderQuestion => 'フォルダを削除しますか？';

  @override
  String get searchClips => 'クリップを検索...';

  @override
  String get clipboardEmpty => 'クリップボードが空です';

  @override
  String get addItem => '項目を追加';

  @override
  String get clipColor => 'クリップの色';

  @override
  String get newClip => '新しいクリップ';

  @override
  String get editClip => 'クリップを編集';

  @override
  String get restoreClipLater => 'このクリップは後で復元できます。';

  @override
  String get upcomingEvents => '今後のイベント';

  @override
  String get dataDistribution => 'データ分布';

  @override
  String get taskProgress => 'タスクの進行状況';

  @override
  String get quickStats => 'クイック統計';

  @override
  String get taskCompletion => 'タスク完了率';

  @override
  String get noItemsForDate => 'この日の項目はありません';

  @override
  String get enjoyFreeTime => '自由な時間を楽しみましょう！';

  @override
  String get searchThisDay => 'この日を検索...';

  @override
  String get finance => 'ファイナンス';

  @override
  String get permanentlyDelete => '永久に削除しますか？';

  @override
  String deleteSelectionConfirmation(int foldersCount, int sketchesCount) {
    return '$foldersCount個のフォルダ（とその中のスケッチ）および$sketchesCount個の他のスケッチを永久に削除します。\n\nこの操作は取り消せません。';
  }

  @override
  String get deleteForever => '永久に削除';

  @override
  String selectedCount(int count) {
    return '$count個選択済み';
  }

  @override
  String canvasStats(int notes, int folders) {
    return 'スケッチ $notes個 ・ フォルダ $folders個';
  }

  @override
  String get sortItems => '項目を並べ替え';

  @override
  String get sortNameAZ => '名前 (A-Z)';

  @override
  String get sortNameZA => '名前 (Z-A)';

  @override
  String get createFolder => 'フォルダを作成';

  @override
  String get folderNameHint => 'フォルダ名...';

  @override
  String deleteSketchesConfirmation(int count) {
    return '$count個のスケッチを削除しますか？この操作は取り消せません。';
  }

  @override
  String get noSketchesFound => 'スケッチが見つかりません';

  @override
  String get noSketchesFoundSub => '検索条件を調整するか、新しいスケッチを作成してください。';

  @override
  String searchInFolder(String folder) {
    return '$folder 内を検索...';
  }

  @override
  String sketchesCount(int count) {
    return 'スケッチ $count個';
  }

  @override
  String get sortSketches => 'スケッチを並べ替え';

  @override
  String get calendarScreenTitle => 'カレンダー';

  @override
  String get dailyActivity => '今日のアクティビティ';

  @override
  String get deleteItemQuestion => '項目を削除しますか？';

  @override
  String get deleteItemConfirmation => '項目をゴミ箱に移動します。';

  @override
  String get moveToBinItem => 'ゴミ箱に移動しますか？';

  @override
  String get moveToBinConfirmation => '後で復元できます。';

  @override
  String selectedItems(int count) {
    return '$count個選択済み';
  }

  @override
  String get recentClips => '最近のクリップ';

  @override
  String get copied => 'コピーしました！';

  @override
  String get copiedPlainText => 'プレーンテキストをコピーしました';

  @override
  String get clipTheme => 'クリップのテーマ';

  @override
  String get justNow => 'たった今';

  @override
  String minutesAgo(Object count) {
    return '$count分前';
  }

  @override
  String hoursAgo(Object count) {
    return '$count時間前';
  }

  @override
  String daysAgo(Object count) {
    return '$count日前';
  }

  @override
  String get noTasksFound => 'タスクは見つかりません。';

  @override
  String get searchTasks => 'タスクを検索...';

  @override
  String get taskReminder => 'タスクのリマインダー';

  @override
  String get untitledNote => '無題のノート';

  @override
  String get dailyEntry => '今日のエントリ';

  @override
  String get clipboardHistory => 'クリップボードの履歴';

  @override
  String get deletePermanentlyContent => 'この操作は取り消せません。';

  @override
  String get emptyRecycleBinTitle => 'ゴミ箱を空にしますか？';

  @override
  String emptyRecycleBinContent(Object count) {
    return '$count個のすべての項目が永久に削除されます。';
  }

  @override
  String get emptyBin => 'ゴミ箱を空にする';

  @override
  String get recycleBinEmpty => 'ゴミ箱は空です';

  @override
  String get deletedItemsAppearHere => '削除された項目がここに表示されます。';

  @override
  String get empty => '空';

  @override
  String get recent => '最近';

  @override
  String categoryLabel(Object category) {
    return 'カテゴリー: $category';
  }

  @override
  String get general => '全般';

  @override
  String get saveTransactionQuestion => 'この取引を保存しますか？';

  @override
  String get fillTitleAmount => 'タイトルと金額を入力してください';

  @override
  String get invalidAmount => '金額の形式が無効です';

  @override
  String get moveTransactionToBinTitle => '取引をゴミ箱に移動しますか？';

  @override
  String get restoreTransactionLater => 'この取引は後で設定から復元できます。';

  @override
  String get newTransaction => '新しい取引';

  @override
  String get whatIsThisFor => '何のための取引ですか？';

  @override
  String get description => '説明';

  @override
  String get daily => '毎日';

  @override
  String get weekly => '毎週';

  @override
  String get monthly => '毎月';

  @override
  String get yearly => '毎年';

  @override
  String get totalIncome => '総収入';

  @override
  String get totalExpense => '総支出';

  @override
  String get analysis => '分析';

  @override
  String get transactions => '取引';

  @override
  String get noExpensesFound => 'この期間の支出は見つかりません。';

  @override
  String get netBalance => '純残高';

  @override
  String get topCategories => '主なカテゴリー';

  @override
  String get spendingTrend => '支出トレンド';

  @override
  String get insights => 'インサイト';

  @override
  String get noExpensesRecorded => '支出は記録されていません';

  @override
  String get trackSpendingHabits => '支出の習慣を簡単に追跡しましょう。';

  @override
  String get addExpense => '支出を追加';

  @override
  String get noDataForPeriod => 'この期間のデータはありません';

  @override
  String get budget => '予算';

  @override
  String get spent => '使用済み';

  @override
  String get limit => '制限';

  @override
  String get overBudget => '予算超過！';

  @override
  String remainingBudget(Object percent) {
    return '残り $percent%';
  }

  @override
  String get savingsRate => '貯蓄率';

  @override
  String get healthScore => '健康スコア';

  @override
  String get healthScoreExplanation =>
      'このスコアは貯蓄率に基づいています。\n\n・50%以上の貯蓄 = 優秀 (100)\n・0%の貯蓄 = 平均 (50)\n・支出 > 収入 = 不足 (<50)';

  @override
  String get ok => 'OK';

  @override
  String get bulkImport => 'Bulk Import';
}

/// The translations for Japanese, as used in Japan (`ja_JP`).
class AppLocalizationsJaJp extends AppLocalizationsJa {
  AppLocalizationsJaJp() : super('ja_JP');

  @override
  String get settings => '設定';

  @override
  String get language => '言語';

  @override
  String get systemDefault => 'システムデフォルト';

  @override
  String get notes => 'ノート';

  @override
  String get todos => 'ToDo';

  @override
  String get expenses => '支出';

  @override
  String get journal => 'ジャーナル';

  @override
  String get calendar => 'カレンダー';

  @override
  String get clipboard => 'クリップボード';

  @override
  String get canvas => 'キャンバス';

  @override
  String get save => '保存';

  @override
  String get create => '作成';

  @override
  String get cancel => 'キャンセル';

  @override
  String get delete => '削除';

  @override
  String get edit => '編集';

  @override
  String get share => '共有';

  @override
  String get copy => 'コピー';

  @override
  String get unsavedChanges => '未保存の変更';

  @override
  String get confirmDelete => '削除の確認';

  @override
  String get discard => '破棄';

  @override
  String get createPost => '投稿を作成';

  @override
  String get post => '投稿';

  @override
  String get postingTo => '投稿先';

  @override
  String get whatsOnYourMind => 'いまどうしてる？';

  @override
  String get pickImages => '画像を選択';

  @override
  String get pickVideo => '動画を選択';

  @override
  String get camera => 'カメラ';

  @override
  String get gallery => 'ギャラリー';

  @override
  String get search => '検索';

  @override
  String get pleaseEnterTask => 'タスクを入力してください';

  @override
  String get deleteTask => 'タスクを削除';

  @override
  String get selectItems => '項目を選択';

  @override
  String get deleteAll => 'すべて削除';

  @override
  String error(Object error) {
    return 'エラー: $error';
  }

  @override
  String get orderingOnlyAvailableInAllPosts => '並べ替えは「すべての投稿」でのみ利用可能です';

  @override
  String get deletePost => '投稿を削除';

  @override
  String get postDeleted => '投稿が削除されました';

  @override
  String get premiumFeatures => 'プレミアム機能';

  @override
  String get manageCoinsAdsPremium => 'コイン、広告、プレミアムステータスの管理';

  @override
  String get themeMode => 'テーマモード';

  @override
  String get accentColor => 'アクセントカラー';

  @override
  String get backgroundDesign => '背景デザイン';

  @override
  String get pushNotifications => 'プッシュ通知';

  @override
  String get recycleBin => 'ゴミ箱';

  @override
  String get exportData => 'データをエクスポート';

  @override
  String get importData => 'データをインポート';

  @override
  String get rateApp => 'アプリを評価';

  @override
  String get sendFeedback => 'フィードバックを送信';

  @override
  String get privacyPolicy => 'プライバシーポリシー';

  @override
  String get version => 'バージョン';

  @override
  String get buildNumber => 'ビルド番号';

  @override
  String get system => 'システム';

  @override
  String get light => 'ライト';

  @override
  String get dark => 'ダーク';

  @override
  String get itemRestored => '項目が復元されました';

  @override
  String get recycleBinCleared => 'ゴミ箱が空になりました';

  @override
  String get allPostsDeleted => 'すべての投稿が削除されました';

  @override
  String get newPost => '新しい投稿';

  @override
  String get textCopiedToClipboardFacebook =>
      'テキストがクリップボードにコピーされました（Facebookポリシー）';

  @override
  String get tiktokSharingRequiresVideoImage => 'TikTok共有には動画または画像が必要です';

  @override
  String errorSharing(Object error) {
    return '共有エラー: $error';
  }

  @override
  String shareToStory(Object platform) {
    return '$platformストーリーで共有';
  }

  @override
  String shareToFeed(Object platform) {
    return '$platformフィードで共有';
  }

  @override
  String get unlockPermanently => '永久にアンロック';

  @override
  String get notEnoughCoins => 'コインが足りません！';

  @override
  String youEarnedCoins(Object amount) {
    return '$amountコインを獲得しました！';
  }

  @override
  String get contentCopied => 'コンテンツをコピーしました';

  @override
  String get selectDateTime => '日時を選択';

  @override
  String get areYouSureYouWantToDeleteThisPost => 'この投稿を削除してもよろしいですか？';

  @override
  String get socialPosts => 'ソーシャル投稿';

  @override
  String get watchAdToEarnCoins => '広告を見てコインを獲得';

  @override
  String get premiumUnlocked => 'プレミアムをアンロックしました';

  @override
  String get removeAds => '広告を削除';

  @override
  String get unlimitedCloudStorage => '無制限のクラウドストレージ';

  @override
  String get deleteNote => 'ノートを削除';

  @override
  String get shareNote => 'ノートを共有';

  @override
  String get editNote => 'ノートを編集';

  @override
  String get searchNotes => 'ノートを検索...';

  @override
  String get noNotesFound => 'ノートが見つかりません';

  @override
  String get captureThoughts => '考えをすぐに記録しましょう。';

  @override
  String get createNote => 'ノートを作成';

  @override
  String get customOrder => 'カスタム順';

  @override
  String get newestFirst => '新しい順';

  @override
  String get oldestFirst => '古い順';

  @override
  String get titleAZ => 'タイトル: A-Z';

  @override
  String get titleZA => 'タイトル: Z-A';

  @override
  String get deleteAllQuestion => 'すべて削除しますか？';

  @override
  String get moveToRecycleBin => 'すべてのノートをゴミ箱に移動しますか？';

  @override
  String get moveToBinQuestion => 'ゴミ箱に移動しますか？';

  @override
  String get restoreNoteLater => 'このノートは後で復元できます。';

  @override
  String get move => '移動';

  @override
  String get myThoughts => 'マイ・ソート';

  @override
  String get selected => '選択済み';

  @override
  String get noContent => 'コンテンツなし';

  @override
  String get untitled => '無題';

  @override
  String get chooseWallpapers => '10種類以上のダイナミックな壁紙から選択';

  @override
  String get backupData => 'データのバックアップ';

  @override
  String get saveJsonFile => 'すべてのデータを含むJSONファイルを保存しますか？';

  @override
  String get exportNow => '今すぐエクスポート';

  @override
  String get importDataTitle => 'データのインポート';

  @override
  String get mergeBackupFile => 'バックアップファイルを現在の項目に統合しますか？';

  @override
  String get selectFile => 'ファイルを選択';

  @override
  String get backupSaved => 'バックアップが正常に保存されました！';

  @override
  String get exportFailed => 'エクスポートに失敗しました。';

  @override
  String importSuccess(Object count) {
    return '$count個の項目が正常に復元されました！';
  }

  @override
  String get importFailed => 'インポートに失敗しました。';

  @override
  String widgetAdded(String widget) {
    return 'ウィジェットがホーム画面に追加されました！';
  }

  @override
  String get widgetRequestSent => 'ウィジェットのリクエストを送信しました。ホーム画面を確認してください。';

  @override
  String get widgetAddFailed => 'ウィジェットの追加に失敗しました';

  @override
  String get autoSaveEnabled => '自動保存が有効になりました。';

  @override
  String get autoSaveDisabled => '自動保存が無効になりました。';

  @override
  String get homeScreenWidgets => 'ホーム画面ウィジェット';

  @override
  String get notificationsTitle => '通知';

  @override
  String get dataBackup => 'データとバックアップ';

  @override
  String get feedbackSupport => 'フィードバックとサポート';

  @override
  String get creditsTitle => 'クレジット';

  @override
  String get privacyMaintenance => 'プライバシーとメンテナンス';

  @override
  String get aboutTitle => 'このアプリについて';

  @override
  String get premium => 'プレミアム';

  @override
  String get appearanceTitle => '外観';

  @override
  String get clipboardTitle => 'クリップボード';

  @override
  String get settingsSubtitle => '体験をカスタマイズ';

  @override
  String get welcomeTitle => 'CopyClipへようこそ';

  @override
  String get welcomeDescription =>
      'あなたの究極の生産性パートナーです。一日を管理するための強力なツールをセットアップしましょう。';

  @override
  String get onboardingNotesTitle => 'スマートノート';

  @override
  String get onboardingNotesDesc =>
      'リッチテキスト形式でアイデアを瞬時にキャプチャ。考えを整理し、素晴らしいアイデアを二度と逃しません。';

  @override
  String get onboardingTodosTitle => 'タスク管理';

  @override
  String get onboardingTodosDesc =>
      '常に一歩先へ。ToDoリストを作成し、優先順位を設定し、目標を一つずつ達成しましょう。';

  @override
  String get onboardingExpensesTitle => '支出の追跡';

  @override
  String get onboardingExpensesDesc => '家計をコントロール。収入と支出を簡単に追跡して、支出の習慣を理解しましょう。';

  @override
  String get onboardingJournalTitle => 'パーソナルジャーナル';

  @override
  String get onboardingJournalDesc =>
      '一日を振り返る。思い出、感情、日々の体験を書き留めるためのプライベートな空間です。';

  @override
  String get onboardingCalendarTitle => 'カレンダーとイベント';

  @override
  String get onboardingCalendarDesc => '一瞬を逃さない。スケジュールを整理し、今後の重要なイベントを追跡しましょう。';

  @override
  String get onboardingClipboardTitle => 'クリップボード管理';

  @override
  String get onboardingClipboardDesc =>
      '一度コピーすればどこでもペースト。クリップボードの履歴にアクセスして、前にコピーしたスニペットを取り出せます。';

  @override
  String get onboardingCanvasTitle => 'クリエイティブキャンパス';

  @override
  String get onboardingCanvasDesc =>
      '創造性を解き放つ。自由形式のデジタルキャンバスでアイデアを描き、スケッチし、視覚化しましょう。';

  @override
  String get featuresNotesDesc => 'ノートの作成と管理';

  @override
  String get featuresTodosDesc => 'タスクの追跡';

  @override
  String get featuresExpensesDesc => '支出の監視';

  @override
  String get featuresJournalDesc => '考えを書き留める';

  @override
  String get featuresCalendarDesc => 'スケジュールの整理';

  @override
  String get featuresClipboardDesc => 'クリップボード履歴へのアクセス';

  @override
  String get featuresCanvasDesc => '自由に描画とスケッチ';

  @override
  String get featuresSocialPost => 'ソーシャル投稿';

  @override
  String get featuresSocialPostDesc => '魅力的なソーシャルメディアコンテンツを作成';

  @override
  String get chooseYourAura => 'あなたのオーラを選択';

  @override
  String get expressYourselfTheme => '新しいテーマカラーで自分を表現しましょう！';

  @override
  String get level => 'レベル';

  @override
  String get xpToNextLevel => '次のレベルまでのXP';

  @override
  String get checkUpcomingEvents => '今後のイベントを確認';

  @override
  String get startNewSketch => '新しいスケッチを開始';

  @override
  String get noTransactionsMonth => '今月の取引はありません';

  @override
  String transactionsThisMonth(num count) {
    return '今月は$count件の取引があります';
  }

  @override
  String get autoSaveClipboard => 'クリップボードの自動保存';

  @override
  String get autoSaveClipboardDesc => 'コピーした項目を自動的に保存する';

  @override
  String get permissionDeniedSettings => '権限が永久に拒否されました。設定で有効にしてください。';

  @override
  String get notificationsEnabled => '通知が有効になりました！';

  @override
  String get redirectingToSettings => '通知を無効にするために設定にリダイレクトしています...';

  @override
  String get premiumAccess => 'プレミアムアクセス';

  @override
  String get premiumActiveUntil => 'プレミアム有効期限';

  @override
  String get unlockAllFeatures => 'すべての機能をアンロック';

  @override
  String get buyPremium => 'プレミアムを購入（7日間）';

  @override
  String costCoins(Object cost) {
    return 'コスト: $costコイン';
  }

  @override
  String get premiumActivated => 'プレミアムが7日間有効になりました！';

  @override
  String get premiumActive => 'プレミアム有効';

  @override
  String get expires => '有効期限:';

  @override
  String get temporaryAccess => '一時的なアクセス';

  @override
  String get journalExpression => 'ジャーナルと表現';

  @override
  String get artisticDesigns => '芸術的なデザイン';

  @override
  String get artisticDesignsDesc => '10種類以上のユニークなジャーナルカードテーマをアンロック';

  @override
  String get premiumLayouts => 'プレミアムレイアウト';

  @override
  String get premiumLayoutsDesc => '思い出を表示する特別な方法';

  @override
  String get calendarTools => 'カレンダーとツール';

  @override
  String get fullCalendar => 'フルカレンダー';

  @override
  String get fullCalendarDesc => '完全なイベント管理システム';

  @override
  String get clipboardAutoSaveDesc => 'バックグラウンドでのクリップボード履歴取得';

  @override
  String get proWidgets => 'プロ・ウィジェット';

  @override
  String get proWidgetsDesc => 'すべての機能がホーム画面で利用可能';

  @override
  String get dataExport => 'データとエクスポート';

  @override
  String get advancedBackup => '高度なバックアップ';

  @override
  String get advancedBackupDesc => 'すべてのデータの安全なインポート/エクスポート';

  @override
  String get pdfExport => 'PDFエクスポート';

  @override
  String get pdfExportDesc => 'ノートやジャーナルをPDFで書き出し';

  @override
  String get printReady => '印刷対応';

  @override
  String get printReadyDesc => 'ダイレクト印刷をサポート';

  @override
  String get richTextEditor => 'リッチテキストエディタ';

  @override
  String get advancedSearch => '高度な検索';

  @override
  String get advancedSearchDesc => 'テキスト内の検索と置換';

  @override
  String get richMedia => 'リッチメディア';

  @override
  String get richMediaDesc => '画像、動画、リンクの挿入';

  @override
  String get editorStyling => 'エディタのスタイリング';

  @override
  String get editorStylingDesc => 'カスタムテキストとエディタの背景';

  @override
  String get balance => '残高';

  @override
  String get loadingAd => '広告を読み込み中...';

  @override
  String watchAd(Object amount) {
    return '広告を見る (+$amount)';
  }

  @override
  String get loadAd => '広告を読み込む';

  @override
  String get backupDataDesc => 'データのJSONファイルを保存';

  @override
  String get importDataDesc => 'バックアップファイルをCopyClipに統合';

  @override
  String get notificationPermissionDenied => '通知権限が拒否されました。';

  @override
  String get typeNewTask => '新しいタスクを入力...';

  @override
  String get addTask => 'タスクを追加';

  @override
  String get completed => '完了';

  @override
  String get greatJob => '素晴らしい！';

  @override
  String youEarnedXPNextTask(Object amount, Object date) {
    return '$amount XPを獲得しました！次のタスク: $date';
  }

  @override
  String taskCompletedXP(Object amount) {
    return 'タスク完了！ +$amount XP';
  }

  @override
  String get moveTasksToRecycleBin => 'すべてのアクティブなタスクをゴミ箱に移動しますか？';

  @override
  String get deleteAllPosts => 'すべての投稿を削除';

  @override
  String get deleteAllPostsConfirmation =>
      '本当にすべてのソーシャル投稿を削除しますか？この操作は取り消せません。';

  @override
  String get allPosts => 'すべての投稿';

  @override
  String get favorites => 'お気に入り';

  @override
  String get drafts => '下書き';

  @override
  String get noFavoritesYet => 'お気に入りはまだありません';

  @override
  String get noDraftsYet => '下書きはまだありません';

  @override
  String get startSocialJourney => 'ソーシャルジャーニーを始めましょう！';

  @override
  String get draft => '下書き';

  @override
  String attachmentCount(num count) {
    return '添付ファイル $count件';
  }

  @override
  String get pleaseAddContent => '共有するコンテンツまたはメディアを追加してください';

  @override
  String fileNotFoundError(Object path) {
    return 'エラー: $path にファイルが見つかりません';
  }

  @override
  String get checkFacebookApp => 'Facebookアプリを確認してください';

  @override
  String get systemShare => 'システム共有';

  @override
  String get socialPost => 'ソーシャル投稿';

  @override
  String get favorite => 'お気に入り';

  @override
  String get saveDraft => '下書きを保存';

  @override
  String get entryCopied => 'エントリをコピーしました';

  @override
  String get moveEntriesToRecycleBin => 'すべてのアクティブなエントリをゴミ箱に移動しますか？';

  @override
  String get startWritingStory => 'ストーリーを書き始めましょう';

  @override
  String get recordMemories => '日々の思い出や感情を記録しましょう。';

  @override
  String get writeJournal => 'ジャーナルを書く';

  @override
  String get myMemories => '私の思い出';

  @override
  String get sortJournal => 'ジャーナルを並べ替え';

  @override
  String get byMood => '気分で絞り込む';

  @override
  String get searchMemories => '思い出を検索...';

  @override
  String get selectAll => 'すべて選択';

  @override
  String get deleteSelected => '選択項目を削除';

  @override
  String get taskCompletedExclamation => 'タスク完了！';

  @override
  String get taskUncompletedExclamation => 'タスク未完了';

  @override
  String get clipboardUpdatedExclamation => 'クリップボードが更新されました！';

  @override
  String clipboardSavedContent(Object content) {
    return '保存されたクリップボード: $content';
  }

  @override
  String get overview => '概要';

  @override
  String get colorAurora => 'オーロラ';

  @override
  String get colorCosmic => 'コズミック';

  @override
  String get colorNebula => '星雲';

  @override
  String get colorStarlight => 'スターライト';

  @override
  String get colorSolar => 'ソーラー';

  @override
  String get colorNova => 'ノバ';

  @override
  String get loadingStepLoading => '読み込み中...';

  @override
  String get loadingStepDatabase => 'データベースをセットアップ中...';

  @override
  String get loadingStepSystem => 'システムを構成中...';

  @override
  String get loadingStepReady => '準備完了';

  @override
  String get productivityCompanion => 'あなたの生産性パートナー';

  @override
  String get done => '完了';

  @override
  String get newNote => '新しいノート';

  @override
  String get changeColor => '色を変更';

  @override
  String get copyContent => '内容をコピー';

  @override
  String get titleOptional => 'タイトル（任意）';

  @override
  String get exportAsPdf => 'PDFとしてエクスポート';

  @override
  String get taskDueNow => '期限が来たタスク';

  @override
  String get moveTaskToBinTitle => 'タスクをゴミ箱に移動しますか？';

  @override
  String get restoreTaskLater => 'このタスクは後で設定から復元できます。';

  @override
  String get newTask => '新しいタスク';

  @override
  String get editTask => 'タスクを編集';

  @override
  String get undo => '元に戻す';

  @override
  String get redo => 'やり直し';

  @override
  String get category => 'カテゴリー';

  @override
  String get categoryHint => '例：仕事、ジム';

  @override
  String get whatNeedsToBeDone => '何をすべきですか？';

  @override
  String get enterTaskDetails => 'タスクの詳細を入力...';

  @override
  String get setDueDate => '期限を設定';

  @override
  String get dueDate => '期限';

  @override
  String get expenseTitle => '支出';

  @override
  String searchInCurrency(String currency) {
    return '$currency で検索...';
  }

  @override
  String get sortAndFilter => '並べ替えとフィルター';

  @override
  String get sortBy => '並べ替え:';

  @override
  String get highestAmount => '金額が高い順';

  @override
  String get lowestAmount => '金額が低い順';

  @override
  String get moreFilters => '詳細フィルター...';

  @override
  String get filterExpenses => '支出をフィルター';

  @override
  String get transactionType => '取引タイプ';

  @override
  String get categories => 'カテゴリー';

  @override
  String get all => 'すべて';

  @override
  String get income => '収入';

  @override
  String get expense => '支出';

  @override
  String get reset => 'リセット';

  @override
  String get apply => '適用';

  @override
  String newExpense(String currency) {
    return '新しい $currency';
  }

  @override
  String errorLoadingData(String error) {
    return 'データの読み込み中にエラーが発生しました。\n\n$error';
  }

  @override
  String get dailyQuote1 => '未来を予測する最良の方法は、それを創ることだ。';

  @override
  String get dailyQuote2 => '富とは、多くの財産を持つことではなく、欲を少なくすることにある。';

  @override
  String get dailyQuote3 => '時間は究極の通貨である。';

  @override
  String get dailyQuote4 => '成功は最終的なものではなく、失敗は致命的なものではない。';

  @override
  String get dailyQuote5 => '問題ではなく、解決策に集中せよ。';

  @override
  String get dailyQuote6 => 'あなたのネットワークが、あなたの純資産である。';

  @override
  String get moodHappy => '嬉しい';

  @override
  String get moodExcited => 'ワクワク';

  @override
  String get moodNeutral => '普通';

  @override
  String get moodSad => '悲しい';

  @override
  String get moodStressed => 'ストレス';

  @override
  String exportDate(String date) {
    return '📅 $date';
  }

  @override
  String exportMood(String emoji, String mood) {
    return '気分: $emoji $mood';
  }

  @override
  String exportTitle(String title) {
    return 'タイトル: $title';
  }

  @override
  String exportTags(String tags) {
    return '\nタグ: $tags';
  }

  @override
  String get instagram => 'Instagram';

  @override
  String get facebook => 'Facebook';

  @override
  String get tiktok => 'TikTok';

  @override
  String get newSketch => '新しいスケッチ';

  @override
  String get searchSketches => 'スケッチやフォルダを検索...';

  @override
  String get noResultsFound => '結果が見つかりません';

  @override
  String get noItems => '項目なし';

  @override
  String get noDrawingsYet => '描画はまだありません';

  @override
  String get canvasIntro => 'キャンバスで創造性を解き放ちましょう！';

  @override
  String get newCanvas => '新しいキャンバス';

  @override
  String get rename => '名前を変更';

  @override
  String get deleteFolder => 'フォルダを削除';

  @override
  String get deleteSketchesQuestion => 'スケッチを削除しますか？';

  @override
  String get deleteFolderConfirmation => 'このフォルダ内のすべてのスケッチは永久に削除されます。';

  @override
  String get renameFolder => 'フォルダ名を変更';

  @override
  String get chooseColor => '色を選択';

  @override
  String get deleteFolderQuestion => 'フォルダを削除しますか？';

  @override
  String get searchClips => 'クリップを検索...';

  @override
  String get clipboardEmpty => 'クリップボードが空です';

  @override
  String get addItem => '項目を追加';

  @override
  String get clipColor => 'クリップの色';

  @override
  String get newClip => '新しいクリップ';

  @override
  String get editClip => 'クリップを編集';

  @override
  String get restoreClipLater => 'このクリップは後で復元できます。';

  @override
  String get upcomingEvents => '今後のイベント';

  @override
  String get dataDistribution => 'データ分布';

  @override
  String get taskProgress => 'タスクの進行状況';

  @override
  String get quickStats => 'クイック統計';

  @override
  String get taskCompletion => 'タスク完了率';

  @override
  String get noItemsForDate => 'この日の項目はありません';

  @override
  String get enjoyFreeTime => '自由な時間を楽しみましょう！';

  @override
  String get searchThisDay => 'この日を検索...';

  @override
  String get finance => 'ファイナンス';

  @override
  String get permanentlyDelete => '永久に削除しますか？';

  @override
  String deleteSelectionConfirmation(int foldersCount, int sketchesCount) {
    return '$foldersCount個のフォルダ（とその中のスケッチ）および$sketchesCount個の他のスケッチを永久に削除します。\n\nこの操作は取り消せません。';
  }

  @override
  String get deleteForever => '永久に削除';

  @override
  String selectedCount(int count) {
    return '$count個選択済み';
  }

  @override
  String canvasStats(int notes, int folders) {
    return 'スケッチ $notes個 ・ フォルダ $folders個';
  }

  @override
  String get sortItems => '項目を並べ替え';

  @override
  String get sortNameAZ => '名前 (A-Z)';

  @override
  String get sortNameZA => '名前 (Z-A)';

  @override
  String get createFolder => 'フォルダを作成';

  @override
  String get folderNameHint => 'フォルダ名...';

  @override
  String deleteSketchesConfirmation(int count) {
    return '$count個のスケッチを削除しますか？この操作は取り消せません。';
  }

  @override
  String get noSketchesFound => 'スケッチが見つかりません';

  @override
  String get noSketchesFoundSub => '検索条件を調整するか、新しいスケッチを作成してください。';

  @override
  String searchInFolder(String folder) {
    return '$folder 内を検索...';
  }

  @override
  String sketchesCount(int count) {
    return 'スケッチ $count個';
  }

  @override
  String get sortSketches => 'スケッチを並べ替え';

  @override
  String get calendarScreenTitle => 'カレンダー';

  @override
  String get dailyActivity => '今日のアクティビティ';

  @override
  String get deleteItemQuestion => '項目を削除しますか？';

  @override
  String get deleteItemConfirmation => '項目をゴミ箱に移動します。';

  @override
  String get moveToBinItem => 'ゴミ箱に移動しますか？';

  @override
  String get moveToBinConfirmation => '後で復元できます。';

  @override
  String selectedItems(int count) {
    return '$count個選択済み';
  }

  @override
  String get recentClips => '最近のクリップ';

  @override
  String get copied => 'コピーしました！';

  @override
  String get copiedPlainText => 'プレーンテキストをコピーしました';

  @override
  String get clipTheme => 'クリップのテーマ';

  @override
  String get justNow => 'たった今';

  @override
  String minutesAgo(Object count) {
    return '$count分前';
  }

  @override
  String hoursAgo(Object count) {
    return '$count時間前';
  }

  @override
  String daysAgo(Object count) {
    return '$count日前';
  }

  @override
  String get noTasksFound => 'タスクは見つかりません。';

  @override
  String get searchTasks => 'タスクを検索...';

  @override
  String get taskReminder => 'タスクのリマインダー';

  @override
  String get untitledNote => '無題のノート';

  @override
  String get dailyEntry => '今日のエントリ';

  @override
  String get clipboardHistory => 'クリップボードの履歴';

  @override
  String get deletePermanentlyContent => 'この操作は取り消せません。';

  @override
  String get emptyRecycleBinTitle => 'ゴミ箱を空にしますか？';

  @override
  String emptyRecycleBinContent(Object count) {
    return '$count個のすべての項目が永久に削除されます。';
  }

  @override
  String get emptyBin => 'ゴミ箱を空にする';

  @override
  String get recycleBinEmpty => 'ゴミ箱は空です';

  @override
  String get deletedItemsAppearHere => '削除された項目がここに表示されます。';

  @override
  String get empty => '空';

  @override
  String get recent => '最近';

  @override
  String categoryLabel(Object category) {
    return 'カテゴリー: $category';
  }

  @override
  String get general => '全般';

  @override
  String get saveTransactionQuestion => 'この取引を保存しますか？';

  @override
  String get fillTitleAmount => 'タイトルと金額を入力してください';

  @override
  String get invalidAmount => '金額の形式が無効です';

  @override
  String get moveTransactionToBinTitle => '取引をゴミ箱に移動しますか？';

  @override
  String get restoreTransactionLater => 'この取引は後で設定から復元できます。';

  @override
  String get newTransaction => '新しい取引';

  @override
  String get whatIsThisFor => '何のための取引ですか？';

  @override
  String get description => '説明';

  @override
  String get daily => '毎日';

  @override
  String get weekly => '毎週';

  @override
  String get monthly => '毎月';

  @override
  String get yearly => '毎年';

  @override
  String get totalIncome => '総収入';

  @override
  String get totalExpense => '総支出';

  @override
  String get analysis => '分析';

  @override
  String get transactions => '取引';

  @override
  String get noExpensesFound => 'この期間の支出は見つかりません。';

  @override
  String get netBalance => '純残高';

  @override
  String get topCategories => '主なカテゴリー';

  @override
  String get spendingTrend => '支出トレンド';

  @override
  String get insights => 'インサイト';

  @override
  String get noExpensesRecorded => '支出は記録されていません';

  @override
  String get trackSpendingHabits => '支出の習慣を簡単に追跡しましょう。';

  @override
  String get addExpense => '支出を追加';

  @override
  String get noDataForPeriod => 'この期間のデータはありません';

  @override
  String get budget => '予算';

  @override
  String get spent => '使用済み';

  @override
  String get limit => '制限';

  @override
  String get overBudget => '予算超過！';

  @override
  String remainingBudget(Object percent) {
    return '残り $percent%';
  }

  @override
  String get savingsRate => '貯蓄率';

  @override
  String get healthScore => '健康スコア';

  @override
  String get healthScoreExplanation =>
      'このスコアは貯蓄率に基づいています。\n\n・50%以上の貯蓄 = 優秀 (100)\n・0%の貯蓄 = 平均 (50)\n・支出 > 収入 = 不足 (<50)';

  @override
  String get ok => 'OK';

  @override
  String get bulkImport => 'Bulk Import';
}
