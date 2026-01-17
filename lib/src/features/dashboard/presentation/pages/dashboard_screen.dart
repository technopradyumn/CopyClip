import 'dart:async';
import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:go_router/go_router.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:home_widget/home_widget.dart';

import 'package:copyclip/src/core/router/app_router.dart';
import 'package:copyclip/src/core/widgets/glass_scaffold.dart';
import 'package:copyclip/src/core/widgets/glass_container.dart';
import '../../../clipboard/data/clipboard_model.dart';
import '../../../expenses/data/expense_model.dart';
import '../../../journal/data/journal_model.dart';
import '../../../notes/data/note_model.dart';
import '../../../todos/data/todo_model.dart';

class FeatureItem {
  final String id;
  final String title;
  final IconData icon;
  final Color color;
  final String route;
  final String description;

  FeatureItem(this.id, this.title, this.icon, this.color, this.route, this.description);
}

class GlobalSearchResult {
  final String id;
  final String title;
  final String subtitle;
  final String type;
  final String route;
  final dynamic argument;
  final bool? isCompleted;

  GlobalSearchResult({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.type,
    required this.route,
    this.argument,
    this.isCompleted,
  });
}

class OnboardingContent {
  final String title;
  final String description;
  final IconData icon;
  final Color color;

  OnboardingContent({
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
  });
}

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> with TickerProviderStateMixin, WidgetsBindingObserver {
  // State
  bool _boxesOpened = false;
  List<String> _order = [];
  String? _draggedId;
  int? _draggedIndex;
  final ValueNotifier<Offset?> _dragPositionNotifier = ValueNotifier(null);

  // Controllers
  late ScrollController _scrollController;
  Timer? _autoScrollTimer;
  late AnimationController _settingsAnimationController;
  late AnimationController _entryAnimationController;

  // Ads
  BannerAd? _bannerAd;

  // ⚠️ CHANGED: Switched from RewardedAd to RewardedInterstitialAd
  RewardedInterstitialAd? _rewardedInterstitialAd;

  bool _isBannerAdLoaded = false;
  bool _isRewardedAdLoading = false;
  DateTime? _lastRewardedAdTime;

  // ============ AD UNIT IDS ============

  String get _bannerAdUnitId {
    if (Platform.isAndroid) {
      return dotenv.env['ANDROID_BANNER_AD_UNIT_ID'] ?? '';
    }
    return dotenv.env['ANDROID_BANNER_AD_UNIT_ID'] ?? '';
  }

  String get _rewardedAdUnitId {
    if (Platform.isAndroid) {
      return dotenv.env['ANDROID_REWARDED_AD_UNIT_ID'] ?? '';
    }
    return dotenv.env['ANDROID_REWARDED_AD_UNIT_ID'] ?? '' ;
  }

  // Onboarding
  bool _showOnboarding = false;
  int _onboardingStep = 0;
  final PageController _onboardingController = PageController();

  // Features Data
  final Map<String, FeatureItem> _features = {
    'notes': FeatureItem('notes', 'Notes', Icons.note_alt_outlined, Colors.amberAccent, AppRouter.notes, 'Create and manage your notes'),
    'todos': FeatureItem('todos', 'To-Dos', Icons.check_circle_outline, Colors.greenAccent, AppRouter.todos, 'Keep track of your tasks'),
    'expenses': FeatureItem('expenses', 'Finance', Icons.attach_money, Colors.redAccent, AppRouter.expenses, 'Monitor your expenses'),
    'journal': FeatureItem('journal', 'Journal', Icons.book_outlined, Colors.blueAccent, AppRouter.journal, 'Write down your thoughts'),
    'calendar': FeatureItem('calendar', 'Calendar', Icons.calendar_today_outlined, Colors.orangeAccent, AppRouter.calendar, 'Organize your schedule'),
    'clipboard': FeatureItem('clipboard', 'Clipboard', Icons.paste, Colors.purpleAccent, AppRouter.clipboard, 'Access your clipboard history'),
    'canvas': FeatureItem('canvas', 'Canvas', Icons.gesture, Colors.tealAccent, AppRouter.canvas, 'Draw and sketch freely'),
  };

  final Map<String, Color> featureColors = {
    'notes': const Color(0xFFFF9A85),
    'todos': const Color(0xFF82CFFD),
    'expenses': const Color(0xFFFFB77B),
    'journal': const Color(0xFF9B7DFF),
    'calendar': const Color(0xFF7DE3A0),
    'clipboard': const Color(0xFFFF92D0),
    'canvas': const Color(0xFF4DB6AC),
  };

  late final List<OnboardingContent> _onboardingData;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    _scrollController = ScrollController();

    _settingsAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _entryAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _entryAnimationController.forward();

    _onboardingData = [
      OnboardingContent(
        title: 'Welcome to CopyClip',
        description: 'Your ultimate productivity companion. Let\'s get you set up with powerful tools to manage your day.',
        icon: Icons.dashboard_rounded,
        color: const Color(0xFF6C63FF),
      ),
      OnboardingContent(
        title: 'Smart Notes',
        description: 'Capture ideas instantly with rich text formatting. Organize your thoughts and never lose a great idea again.',
        icon: Icons.note_alt_outlined,
        color: featureColors['notes']!,
      ),
      OnboardingContent(
        title: 'Task Management',
        description: 'Stay on top of your game. Create to-do lists, set priorities, and crush your goals one checkmark at a time.',
        icon: Icons.check_circle_outline,
        color: featureColors['todos']!,
      ),
      OnboardingContent(
        title: 'Expense Tracking',
        description: 'Take control of your finances. Track income and expenses easily to understand your spending habits.',
        icon: Icons.attach_money,
        color: featureColors['expenses']!,
      ),
      OnboardingContent(
        title: 'Personal Journal',
        description: 'Reflect on your day. A private space to write down your memories, feelings, and daily experiences.',
        icon: Icons.book_outlined,
        color: featureColors['journal']!,
      ),
      OnboardingContent(
        title: 'Calendar & Events',
        description: 'Never miss a moment. Organize your schedule and keep track of important upcoming events.',
        icon: Icons.calendar_today_outlined,
        color: featureColors['calendar']!,
      ),
      OnboardingContent(
        title: 'Clipboard Manager',
        description: 'Copy once, paste anywhere. Access your clipboard history to retrieve snippets you copied earlier.',
        icon: Icons.paste,
        color: featureColors['clipboard']!,
      ),
      OnboardingContent(
        title: 'Creative Canvas',
        description: 'Unleash your creativity. Draw, sketch, and visualize your ideas on a free-form digital canvas.',
        icon: Icons.gesture,
        color: featureColors['canvas']!,
      ),
    ];

    _initHive();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _scrollController.dispose();
    _autoScrollTimer?.cancel();
    _settingsAnimationController.dispose();
    _entryAnimationController.dispose();
    _dragPositionNotifier.dispose();
    _onboardingController.dispose();
    _bannerAd?.dispose();
    _rewardedInterstitialAd?.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      debugPrint("📱 App Resumed: Checking for Rewarded Interstitial Ad trigger...");
      _checkAndShowRewardedAd();
    }
  }

  // ============ HIVE ============
  Future<void> _initHive() async {
    if (!Hive.isBoxOpen('settings')) await Hive.openBox('settings');

    final settingsBox = Hive.box('settings');
    final savedOrder = settingsBox.get('dashboard_order', defaultValue: null);
    final hasSeenOnboarding = settingsBox.get('has_seen_onboarding', defaultValue: false);
    final lastAdTimeStr = settingsBox.get('last_rewarded_ad_time', defaultValue: null);

    if (lastAdTimeStr != null) {
      try {
        _lastRewardedAdTime = DateTime.parse(lastAdTimeStr);
      } catch (e) {
        debugPrint('Error parsing last ad time: $e');
      }
    }

    if (mounted) {
      setState(() {
        if (savedOrder != null) {
          _order = List<String>.from(savedOrder);
          for (var key in _features.keys) {
            if (!_order.contains(key)) _order.add(key);
          }
        } else {
          _order = _features.keys.toList();
        }
        _boxesOpened = true;
        _showOnboarding = !hasSeenOnboarding;
      });

      _initializeAds();
    }
  }

  void _saveOrder() {
    Hive.box('settings').put('dashboard_order', _order);
  }

  void _saveLastRewardedAdTime(DateTime time) {
    Hive.box('settings').put('last_rewarded_ad_time', time.toIso8601String());
  }

  // ============ ADS IMPLEMENTATION ============

  void _initializeAds() {
    debugPrint('🎯 Initializing ads...');
    _loadBannerAd();
    _checkAndShowRewardedAd();
  }

  void _loadBannerAd() {
    _bannerAd = BannerAd(
      adUnitId: _bannerAdUnitId,
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          if (mounted) setState(() => _isBannerAdLoaded = true);
        },
        onAdFailedToLoad: (ad, error) {
          debugPrint('❌ Banner Ad Failed: $error');
          ad.dispose();
        },
      ),
    )..load();
  }

  void _checkAndShowRewardedAd() {
    if (_isRewardedAdLoading || _showOnboarding) return;

    final now = DateTime.now();
    bool shouldShow = false;

    if (_lastRewardedAdTime == null) {
      debugPrint('⏰ First time opening app: Preparing to show Ad.');
      shouldShow = true;
    } else {
      final difference = now.difference(_lastRewardedAdTime!);
      if (difference.inHours >= 2) {
        debugPrint('⏰ > 2 Hours passed (${difference.inHours} hrs). Showing Ad.');
        shouldShow = true;
      } else {
        debugPrint('⏳ Ad cooldown active. Next ad in ${120 - difference.inMinutes} minutes.');
        shouldShow = false;
      }
    }

    if (shouldShow) {
      _loadAndShowRewardedInterstitialAd();
    }
  }

  // ⚠️ CHANGED: Loading Logic for Rewarded Interstitial
  void _loadAndShowRewardedInterstitialAd() {
    if (_isRewardedAdLoading) return;
    setState(() => _isRewardedAdLoading = true);

    debugPrint('🎁 Loading Rewarded Interstitial Ad from ENV ID');

    // Uses RewardedInterstitialAd.load instead of RewardedAd.load
    RewardedInterstitialAd.load(
      adUnitId: _rewardedAdUnitId,
      request: const AdRequest(),
      rewardedInterstitialAdLoadCallback: RewardedInterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          debugPrint('✅ Rewarded Interstitial ad loaded.');
          _rewardedInterstitialAd = ad;

          _rewardedInterstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
            onAdShowedFullScreenContent: (ad) {
              debugPrint('🎬 Ad showing fullscreen');
            },
            onAdDismissedFullScreenContent: (ad) {
              debugPrint('👋 Ad dismissed');
              ad.dispose();
              _rewardedInterstitialAd = null;
            },
            onAdFailedToShowFullScreenContent: (ad, error) {
              debugPrint('❌ Ad failed to show: $error');
              ad.dispose();
              _rewardedInterstitialAd = null;
            },
          );

          if (mounted) {
            _showRewardedAd();
            setState(() => _isRewardedAdLoading = false);
          }
        },
        onAdFailedToLoad: (error) {
          debugPrint('❌ Failed to load Rewarded Interstitial ad: ${error.message} (Code: ${error.code})');
          setState(() => _isRewardedAdLoading = false);
          _rewardedInterstitialAd = null;
        },
      ),
    );
  }

  void _showRewardedAd() {
    if (_rewardedInterstitialAd == null) return;

    // ⚠️ CHANGED: Show logic is slightly different for RewardedInterstitial
    _rewardedInterstitialAd!.show(
      onUserEarnedReward: (ad, reward) {
        debugPrint('🎉 User Earned Reward');
        final now = DateTime.now();
        setState(() => _lastRewardedAdTime = now);
        _saveLastRewardedAdTime(now);
      },
    );
  }


  // ============ ONBOARDING UI ============
  void _completeOnboarding() {
    Hive.box('settings').put('has_seen_onboarding', true);
    setState(() => _showOnboarding = false);
    _checkAndShowRewardedAd();
  }

  Widget _buildOnboardingScreen() {
    final theme = Theme.of(context);
    final currentData = _onboardingData[_onboardingStep];

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Stack(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 500),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  currentData.color.withOpacity(0.15),
                  theme.scaffoldBackgroundColor,
                ],
              ),
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                Align(
                  alignment: Alignment.topRight,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: TextButton(
                      onPressed: _completeOnboarding,
                      style: TextButton.styleFrom(
                        foregroundColor: theme.colorScheme.onSurface.withOpacity(0.6),
                      ),
                      child: const Text('Skip'),
                    ),
                  ),
                ),
                Expanded(
                  child: PageView.builder(
                    controller: _onboardingController,
                    onPageChanged: (index) => setState(() => _onboardingStep = index),
                    itemCount: _onboardingData.length,
                    itemBuilder: (context, index) {
                      return _buildOnboardingPageItem(theme, _onboardingData[index], index == _onboardingStep);
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          _onboardingData.length,
                              (index) => AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            width: _onboardingStep == index ? 24 : 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: _onboardingStep == index
                                  ? currentData.color
                                  : theme.colorScheme.onSurface.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 32),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          if (_onboardingStep > 0)
                            TextButton(
                              onPressed: () {
                                _onboardingController.previousPage(
                                  duration: const Duration(milliseconds: 300),
                                  curve: Curves.easeInOut,
                                );
                              },
                              style: TextButton.styleFrom(
                                foregroundColor: theme.colorScheme.onSurface,
                                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                              ),
                              child: const Text('Back', style: TextStyle(fontWeight: FontWeight.w600)),
                            )
                          else
                            const SizedBox(width: 80),
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            child: ElevatedButton(
                              onPressed: () {
                                if (_onboardingStep < _onboardingData.length - 1) {
                                  _onboardingController.nextPage(
                                    duration: const Duration(milliseconds: 300),
                                    curve: Curves.easeInOut,
                                  );
                                } else {
                                  _completeOnboarding();
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: currentData.color,
                                foregroundColor: Colors.white,
                                elevation: 8,
                                shadowColor: currentData.color.withOpacity(0.4),
                                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    _onboardingStep == _onboardingData.length - 1
                                        ? 'Get Started'
                                        : 'Next',
                                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                  ),
                                  if (_onboardingStep != _onboardingData.length - 1) ...[
                                    const SizedBox(width: 8),
                                    const Icon(Icons.arrow_forward_rounded, size: 20),
                                  ],
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOnboardingPageItem(ThemeData theme, OnboardingContent content, bool isActive) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0.0, end: isActive ? 1.0 : 0.0),
            duration: const Duration(milliseconds: 600),
            curve: Curves.elasticOut,
            builder: (context, value, child) {
              return Transform.scale(
                scale: value,
                child: Container(
                  padding: const EdgeInsets.all(40),
                  decoration: BoxDecoration(
                    color: content.color.withOpacity(0.1),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: content.color.withOpacity(0.2),
                      width: 2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: content.color.withOpacity(0.2),
                        blurRadius: 30,
                        spreadRadius: 5,
                      ),
                    ],
                  ),
                  child: Icon(content.icon, size: 80, color: content.color),
                ),
              );
            },
          ),
          const SizedBox(height: 50),
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 20.0, end: isActive ? 0.0 : 20.0),
            duration: const Duration(milliseconds: 400),
            curve: Curves.easeOut,
            builder: (context, value, child) {
              return Transform.translate(
                offset: Offset(0, value),
                child: Opacity(
                  opacity: (1 - (value / 20)).clamp(0.0, 1.0),
                  child: child,
                ),
              );
            },
            child: Text(
              content.title,
              style: theme.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.onSurface,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 16),
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 20.0, end: isActive ? 0.0 : 20.0),
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeOut,
            builder: (context, value, child) {
              return Transform.translate(
                offset: Offset(0, value),
                child: Opacity(
                  opacity: (1 - (value / 20)).clamp(0.0, 1.0),
                  child: child,
                ),
              );
            },
            child: Text(
              content.description,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: theme.colorScheme.onSurface.withOpacity(0.7),
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  // ============ DRAG & DROP LOGIC ============
  void _onDragStart(String id, int index, LongPressStartDetails details) {
    setState(() {
      _draggedId = id;
      _draggedIndex = index;
    });
    _dragPositionNotifier.value = details.globalPosition;
    HapticFeedback.mediumImpact();
    _autoScrollTimer = Timer.periodic(const Duration(milliseconds: 50), _checkForAutoScroll);
  }

  void _onDragUpdate(LongPressMoveUpdateDetails details) {
    if (_draggedId == null) return;
    _dragPositionNotifier.value = details.globalPosition;
    _handleReorder(details.globalPosition);
  }

  void _onDragEnd() {
    _autoScrollTimer?.cancel();
    _autoScrollTimer = null;
    setState(() {
      _draggedId = null;
      _draggedIndex = null;
    });
    _dragPositionNotifier.value = null;
    _saveOrder();
  }

  void _checkForAutoScroll(Timer timer) {
    final currentOffset = _dragPositionNotifier.value;
    if (currentOffset == null || _draggedId == null) return;
    final double screenHeight = MediaQuery.of(context).size.height;
    final double topThreshold = 150.0;
    final double bottomThreshold = screenHeight - 150.0;
    final double scrollSpeed = 8.0;

    double scrollDelta = 0;
    if (currentOffset.dy < topThreshold) {
      scrollDelta = -scrollSpeed;
    } else if (currentOffset.dy > bottomThreshold) {
      scrollDelta = scrollSpeed;
    }

    if (scrollDelta != 0) {
      final double newOffset = (_scrollController.offset + scrollDelta).clamp(0.0, _scrollController.position.maxScrollExtent);
      if (newOffset != _scrollController.offset) {
        _scrollController.jumpTo(newOffset);
        _handleReorder(currentOffset);
      }
    }
  }

  void _handleReorder(Offset globalPosition) {
    if (_draggedIndex == null) return;
    final double itemHeight = (MediaQuery.of(context).size.width - 64) / 2 * 1.1 + 16;
    final double scrollOffset = _scrollController.offset;
    final double relativeY = globalPosition.dy + scrollOffset - 120;
    final int newRow = (relativeY / itemHeight).floor().clamp(0, (_order.length / 2).ceil() - 1);
    final double relativeX = globalPosition.dx - 24;
    final double itemWidth = (MediaQuery.of(context).size.width - 64) / 2 + 16;
    final int newCol = (relativeX / itemWidth).floor().clamp(0, 1);
    int newIndex = (newRow * 2 + newCol).clamp(0, _order.length - 1);

    if (newIndex != _draggedIndex) {
      setState(() {
        final item = _order.removeAt(_draggedIndex!);
        _order.insert(newIndex, item);
        _draggedIndex = newIndex;
      });
      HapticFeedback.lightImpact();
    }
  }

  // ============ UI COMPONENTS ============

  Widget _buildFeatureCard(ThemeData theme, FeatureItem item, {bool isDragging = false}) {
    final Color baseColor = featureColors[item.id] ?? item.color;
    Widget content = Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Hero(
          tag: '${item.id}_icon',
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [baseColor.withOpacity(0.6), baseColor.withOpacity(0.9)], begin: Alignment.topLeft, end: Alignment.bottomRight),
              shape: BoxShape.circle,
              boxShadow: [BoxShadow(color: baseColor.withOpacity(0.3), blurRadius: 12, offset: const Offset(0, 6))],
            ),
            child: Icon(item.icon, size: 32, color: Colors.white),
          ),
        ),
        const SizedBox(height: 14),
        Hero(
          tag: '${item.id}_title',
          child: Material(
            type: MaterialType.transparency,
            child: Text(item.title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: theme.colorScheme.onSurface)),
          ),
        ),
      ],
    );

    if (isDragging) {
      return Container(decoration: BoxDecoration(color: baseColor.withOpacity(0.5), borderRadius: BorderRadius.circular(32), border: Border.all(color: baseColor, width: 1.5)), child: content);
    }

    return Container(decoration: BoxDecoration(color: baseColor.withOpacity(0.15), borderRadius: BorderRadius.circular(32), border: Border.all(color: baseColor, width: 1)), child: content);
  }

  Widget _buildTopHeader(ThemeData theme) {
    final primaryColor = theme.colorScheme.primary;
    return Container(
      padding: const EdgeInsets.only(left: 24, right: 24, bottom: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Dashboard", style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
              Text("Manage your day", style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurface.withOpacity(0.5))),
            ],
          ),
          Row(
            children: [
              IconButton(
                icon: Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: primaryColor.withOpacity(0.1), shape: BoxShape.circle), child: Icon(Icons.search_rounded, color: primaryColor)),
                onPressed: () => context.push(AppRouter.globalSearch),
              ),
              IconButton(
                icon: Hero(tag: 'settings_icon', child: RotationTransition(turns: _settingsAnimationController, child: Icon(Icons.settings_outlined, color: theme.colorScheme.onSurface.withOpacity(0.7)))),
                onPressed: () {
                  _settingsAnimationController.forward(from: 0.0);
                  context.push(AppRouter.settings);
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildGridItem(int index, ThemeData theme) {
    if (index >= _order.length) return const SizedBox.shrink();
    final String id = _order[index];
    final FeatureItem? item = _features[id];
    if (item == null) return const SizedBox.shrink();
    final bool isDragging = id == _draggedId;

    return RepaintBoundary(
      child: GestureDetector(
        onLongPressStart: (d) => _onDragStart(id, index, d),
        onLongPressMoveUpdate: (d) => _onDragUpdate(d),
        onLongPressEnd: (_) => _onDragEnd(),
        onTap: () => context.push(item.route),
        child: AnimatedOpacity(
          duration: const Duration(milliseconds: 200),
          opacity: isDragging ? 0.0 : 1.0,
          child: _buildBouncingItemWrapper(index, _buildFeatureCard(theme, item)),
        ),
      ),
    );
  }

  Widget _buildBouncingItemWrapper(int index, Widget child) {
    return AnimatedBuilder(
      animation: _entryAnimationController,
      builder: (context, child) {
        final double start = (index * 0.1).clamp(0.0, 0.8);
        final double end = (start + 0.5).clamp(0.0, 1.0);
        final animation = CurvedAnimation(parent: _entryAnimationController, curve: Interval(start, end, curve: Curves.elasticOut));
        return Transform.scale(scale: animation.value, child: Opacity(opacity: animation.value.clamp(0.0, 1.0), child: child));
      },
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (_showOnboarding) {
      return _buildOnboardingScreen();
    }

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: !_boxesOpened
          ? const Center(child: CircularProgressIndicator())
          : Stack(
        children: [
          Column(
            children: [
              const SizedBox(height: 50),
              _buildTopHeader(theme),
              Expanded(
                child: GridView.builder(
                  controller: _scrollController,
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 1 / 1.1,
                  ),
                  itemCount: _order.length,
                  itemBuilder: (context, index) => _buildGridItem(index, theme),
                ),
              ),
              // Banner Ad at bottom
              if (_isBannerAdLoaded && _bannerAd != null)
                Container(
                  alignment: Alignment.center,
                  width: _bannerAd!.size.width.toDouble(),
                  height: _bannerAd!.size.height.toDouble(),
                  decoration: BoxDecoration(
                    color: theme.scaffoldBackgroundColor,
                    boxShadow: [
                      BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 8, offset: const Offset(0, -2)),
                    ],
                  ),
                  child: AdWidget(ad: _bannerAd!),
                ),
            ],
          ),
          // Dragging overlay
          ValueListenableBuilder<Offset?>(
            valueListenable: _dragPositionNotifier,
            builder: (context, offset, child) {
              if (offset == null || _draggedId == null) return const SizedBox.shrink();
              final FeatureItem? item = _features[_draggedId];
              if (item == null) return const SizedBox.shrink();

              final double itemWidth = (MediaQuery.of(context).size.width - 64) / 2;
              return Positioned(
                left: offset.dx - (itemWidth / 2),
                top: offset.dy - (itemWidth * 1.1 / 2),
                child: IgnorePointer(
                  child: Transform.scale(scale: 1.1, child: SizedBox(width: itemWidth, height: itemWidth * 1.1, child: _buildFeatureCard(theme, item, isDragging: true))),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}