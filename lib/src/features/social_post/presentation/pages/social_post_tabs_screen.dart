import 'package:copyclip/src/core/router/app_router.dart';
import 'package:copyclip/src/features/social_post/presentation/widgets/social_post_list_widget.dart';
import '../../../../l10n/app_localizations.dart';
import 'package:copyclip/src/core/widgets/glass_scaffold.dart';
import 'package:copyclip/src/core/widgets/dynamic_background.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:copyclip/src/core/services/lazy_box_loader.dart';
import 'package:copyclip/src/features/social_post/data/social_post_model.dart';
import 'package:copyclip/src/core/widgets/seamless_header.dart';
import 'package:copyclip/src/core/const/constant.dart';

class SocialPostTabsScreen extends StatefulWidget {
  const SocialPostTabsScreen({super.key});

  @override
  State<SocialPostTabsScreen> createState() => _SocialPostTabsScreenState();
}

class _SocialPostTabsScreenState extends State<SocialPostTabsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // Keys to access list state
  final GlobalKey<SocialPostListWidgetState> _allPostsKey = GlobalKey();
  final GlobalKey<SocialPostListWidgetState> _favoritesKey = GlobalKey();
  final GlobalKey<SocialPostListWidgetState> _draftsKey = GlobalKey();

  // Selection State
  bool _isSelectionMode = false;
  int _selectedCount = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(_handleTabSelection);
  }

  @override
  void dispose() {
    _tabController.removeListener(_handleTabSelection);
    _tabController.dispose();
    super.dispose();
  }

  void _handleTabSelection() {
    if (_tabController.indexIsChanging) {
      // Exit selection mode when switching tabs
      _exitSelectionMode();
    }
    setState(() {}); // Rebuild to update keys/actions if needed
  }

  GlobalKey<SocialPostListWidgetState> _getCurrentKey() {
    switch (_tabController.index) {
      case 0:
        return _allPostsKey;
      case 1:
        return _favoritesKey;
      case 2:
        return _draftsKey;
      default:
        return _allPostsKey;
    }
  }

  void _exitSelectionMode() {
    if (!_isSelectionMode) return;
    _getCurrentKey().currentState?.deselectAll();
    setState(() {
      _isSelectionMode = false;
      _selectedCount = 0;
    });
  }

  void _onSelectionChanged(bool isSelectionMode, int count) {
    // Only update if it matches current tab's state
    // (though logically only current tab should trigger this)
    if (_isSelectionMode != isSelectionMode || _selectedCount != count) {
      setState(() {
        _isSelectionMode = isSelectionMode;
        _selectedCount = count;
      });
    }
  }

  void _deleteSelected() {
    _getCurrentKey().currentState?.deleteSelected();
    // State update handled by callback from child
  }

  void _selectAll() {
    _getCurrentKey().currentState?.selectAll();
  }

  Future<void> _deleteAllPosts(BuildContext context) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Delete All Posts"),
        content: const Text(
          "Are you sure you want to delete ALL social posts? This cannot be undone.",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text(
              "Delete All",
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );

    if (confirm == true) {
      final box = await LazyBoxLoader.getBox<SocialPost>('social_posts_box');
      await box.clear();
      // Optionally clear order too
      final settingsBox = await LazyBoxLoader.getBox('settings');
      settingsBox.delete('social_posts_order');

      if (context.mounted) {
        // ScaffoldMessenger.of(context).showSnackBar(
        //   SnackBar(
        //     content: Text(AppLocalizations.of(context)!.allPostsDeleted),
        //   ),
        // );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Intercept Back Button
    return PopScope(
      canPop: !_isSelectionMode,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        _exitSelectionMode();
      },
      child: GlassScaffold(
        // Use custom header logic
        showBackArrow: false, // We handle it in SeamlessHeader
        title: null, // We provide custom header body
        // Floating Action Button
        floatingActionButton: _isSelectionMode
            ? null
            : FloatingActionButton.extended(
                onPressed: () {
                  context.push(AppRouter.socialPostEdit);
                },
                backgroundColor: FeatureColors.socialPost,
                label: const Text('New Post'),
                icon: const Icon(Icons.edit),
              ),

        body: DynamicBackground(
          child: Column(
            children: [
              // Header
              _buildHeader(context),

              // Tabs (only show if NOT in selection mode? Or keep them disabled?)
              // UX: Usually tabs hide or disable during selection. Let's hide them or keep them but disabled.
              // Hiding them gives more space.
              if (!_isSelectionMode)
                TabBar(
                  controller: _tabController,
                  indicatorColor: FeatureColors.socialPost,
                  labelColor: FeatureColors.socialPost,
                  unselectedLabelColor: theme.colorScheme.onSurface.withValues(
                    alpha: 0.6,
                  ),
                  tabs: const [
                    Tab(text: 'All Posts'),
                    Tab(text: 'Favorites'),
                    Tab(text: 'Drafts'),
                  ],
                ),

              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  physics: _isSelectionMode
                      ? const NeverScrollableScrollPhysics()
                      : null,
                  children: [
                    SocialPostListWidget(
                      key: _allPostsKey,
                      filter: 'all',
                      onSelectionChanged: _onSelectionChanged,
                    ),
                    SocialPostListWidget(
                      key: _favoritesKey,
                      filter: 'favorites',
                      onSelectionChanged: _onSelectionChanged,
                    ),
                    SocialPostListWidget(
                      key: _draftsKey,
                      filter: 'drafts',
                      onSelectionChanged: _onSelectionChanged,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final theme = Theme.of(context);
    final onSurfaceColor = theme.colorScheme.onSurface;

    if (_isSelectionMode) {
      return SeamlessHeader(
        title: '$_selectedCount Selected',
        heroTagPrefix: 'social_selection', // Different tag
        showBackButton: true,
        onBackTap: _exitSelectionMode,
        actions: [
          IconButton(
            icon: Icon(CupertinoIcons.checkmark_square, color: onSurfaceColor),
            onPressed: _selectAll,
            tooltip: 'Select All',
          ),
          IconButton(
            icon: const Icon(CupertinoIcons.delete, color: Colors.redAccent),
            onPressed:
                _deleteSelected, // Logic handles local deletion (no dialog)
            tooltip: 'Delete Selected',
          ),
        ],
      );
    }

    return SeamlessHeader(
      title: AppLocalizations.of(context)!.socialPosts,
      heroTagPrefix: 'social_post', // Match Dashboard tile
      showBackButton: true,
      onBackTap: () => context.pop(),
      actions: [
        PopupMenuButton<String>(
          icon: Icon(Icons.more_vert, color: onSurfaceColor),
          onSelected: (value) {
            if (value == 'delete_all') {
              _deleteAllPosts(context);
            }
          },
          itemBuilder: (context) => [
            const PopupMenuItem(
              value: 'delete_all',
              child: Row(
                children: [
                  Icon(Icons.delete_forever, color: Colors.red),
                  SizedBox(width: 8),
                  Text('Delete All', style: TextStyle(color: Colors.red)),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
