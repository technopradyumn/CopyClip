import 'package:copyclip/src/core/router/app_router.dart';
import 'package:copyclip/src/features/social_post/presentation/widgets/social_post_list_widget.dart';
import '../../../../l10n/app_localizations.dart';
import 'package:copyclip/src/core/widgets/glass_scaffold.dart';
import 'package:copyclip/src/core/widgets/dynamic_background.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
        title: Text(AppLocalizations.of(context)!.deleteAllPosts),
        content: Text(AppLocalizations.of(context)!.deleteAllPostsConfirmation),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(AppLocalizations.of(context)!.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(
              AppLocalizations.of(context)!.deleteAll,
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
                label: Text(AppLocalizations.of(context)!.newPost),
                icon: const Icon(Icons.edit),
              ),

        body: DynamicBackground(
          child: Column(
            children: [
              // Header
              _buildHeader(context),

              // Bulk Import Tile
              if (!_isSelectionMode)
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 8.h,
                  ),
                  child: Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: ListTile(
                      leading: Icon(
                        Icons.add_photo_alternate_outlined,
                        color: FeatureColors.socialPost,
                        size: 28.sp,
                      ),
                      title: Text(
                        AppLocalizations.of(context)!.bulkImport,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16.sp,
                        ),
                      ),
                      subtitle: Text(
                        "Import multiple posts from URL",
                        style: TextStyle(fontSize: 12.sp),
                      ),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () {
                        context.push(AppRouter.socialPostBulkImport);
                      },
                    ),
                  ),
                ),

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
                  tabs: [
                    Tab(text: AppLocalizations.of(context)!.allPosts),
                    Tab(text: AppLocalizations.of(context)!.favorites),
                    Tab(text: AppLocalizations.of(context)!.drafts),
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
        title: '$_selectedCount ${AppLocalizations.of(context)!.selected}',
        heroTagPrefix: 'social_selection', // Different tag
        showBackButton: true,
        onBackTap: _exitSelectionMode,
        actions: [
          IconButton(
            icon: Icon(CupertinoIcons.checkmark_square, color: onSurfaceColor),
            onPressed: _selectAll,
            tooltip: AppLocalizations.of(context)!.selectAll,
          ),
          IconButton(
            icon: const Icon(CupertinoIcons.delete, color: Colors.redAccent),
            onPressed:
                _deleteSelected, // Logic handles local deletion (no dialog)
            tooltip: AppLocalizations.of(context)!.deleteSelected,
          ),
        ],
      );
    }

    return SeamlessHeader(
      title: AppLocalizations.of(context)!.socialPosts,
      icon: CupertinoIcons.share_up,
      iconColor: FeatureColors.socialPost,
      heroTagPrefix: 'social_post', // Match Dashboard tile
      showBackButton: true,
      onBackTap: () => context.pop(),
      actions: [
        PopupMenuButton<String>(
          icon: Icon(Icons.more_vert, color: onSurfaceColor),
          onSelected: (value) {
            if (value == 'delete_all') {
              _deleteAllPosts(context);
            } else if (value == 'bulk_import') {
              context.push(AppRouter.socialPostBulkImport);
            }
          },
          itemBuilder: (context) => [
            PopupMenuItem(
              value: 'bulk_import',
              child: Row(
                children: [
                  Icon(
                    Icons.add_photo_alternate_outlined,
                    color: theme.colorScheme.primary,
                  ),
                  SizedBox(width: 8),
                  Text(AppLocalizations.of(context)!.bulkImport),
                ],
              ),
            ),
            PopupMenuItem(
              value: 'delete_all',
              child: Row(
                children: [
                  Icon(Icons.delete_forever, color: Colors.red),
                  SizedBox(width: 8),
                  Text(
                    AppLocalizations.of(context)!.deleteAll,
                    style: TextStyle(color: Colors.red),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
