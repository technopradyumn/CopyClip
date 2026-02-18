import 'dart:convert';
import 'dart:ui' as ui;

import 'package:copyclip/src/features/social_post/data/social_post_model.dart';
// import '../../../../l10n/app_localizations.dart'; // Unused
import 'package:copyclip/src/features/social_post/presentation/widgets/social_platform_selector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:go_router/go_router.dart';
import 'package:copyclip/src/core/router/app_router.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:copyclip/src/core/services/lazy_box_loader.dart';

class SocialPostListWidget extends StatefulWidget {
  final String filter; // 'all', 'favorites', 'drafts'
  final Function(bool isSelectionMode, int selectedCount)? onSelectionChanged;

  const SocialPostListWidget({
    super.key,
    required this.filter,
    this.onSelectionChanged,
  });

  @override
  State<SocialPostListWidget> createState() => SocialPostListWidgetState();
}

class SocialPostListWidgetState extends State<SocialPostListWidget> {
  late Future<Box<SocialPost>> _boxFuture;
  late Future<Box> _settingsBoxFuture;

  // Selection State
  bool _isSelectionMode = false;
  final Set<String> _selectedIds = {};
  List<SocialPost> _currentPosts = []; // Keep track for selectAll

  @override
  void initState() {
    super.initState();
    _boxFuture = LazyBoxLoader.getBox<SocialPost>('social_posts_box');
    _settingsBoxFuture = LazyBoxLoader.getBox('settings');
  }

  // --- Public Methods for Parent ---

  void selectAll() {
    if (_currentPosts.isEmpty) return;
    setState(() {
      _isSelectionMode = true;
      _selectedIds.clear();
      _selectedIds.addAll(_currentPosts.map((p) => p.id));
    });
    _notifySelectionChanged();
  }

  void deselectAll() {
    setState(() {
      _isSelectionMode = false;
      _selectedIds.clear();
    });
    _notifySelectionChanged();
  }

  Future<void> deleteSelected() async {
    final box = await _boxFuture;
    final idsToDelete = _selectedIds.toList();

    // Delete from Hive
    await box.deleteAll(idsToDelete);

    // Also remove from order list if applicable
    if (widget.filter == 'all') {
      final settingsBox = await _settingsBoxFuture;
      final List<String>? savedOrder = settingsBox
          .get('social_posts_order', defaultValue: <String>[])
          ?.cast<String>();

      if (savedOrder != null) {
        final newOrder = savedOrder
            .where((id) => !idsToDelete.contains(id))
            .toList();
        await settingsBox.put('social_posts_order', newOrder);
      }
    }

    deselectAll();

    if (mounted) {
      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(content: Text('${idsToDelete.length} posts deleted')),
      // );
    }
  }

  void _notifySelectionChanged() {
    widget.onSelectionChanged?.call(_isSelectionMode, _selectedIds.length);
  }

  void _toggleSelection(String id) {
    setState(() {
      if (_selectedIds.contains(id)) {
        _selectedIds.remove(id);
        if (_selectedIds.isEmpty) {
          _isSelectionMode = false;
        }
      } else {
        _selectedIds.add(id);
        _isSelectionMode = true;
      }
    });
    _notifySelectionChanged();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Future.wait([_boxFuture, _settingsBoxFuture]),
      builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text("Error: ${snapshot.error}"));
        }

        final postsBox = snapshot.data![0] as Box<SocialPost>;
        final settingsBox = snapshot.data![1] as Box;

        return ValueListenableBuilder(
          valueListenable: postsBox.listenable(),
          builder: (context, Box<SocialPost> box, _) {
            // Get all posts first
            List<SocialPost> posts = box.values.toList();

            // 1. FILTERING
            if (widget.filter == 'favorites') {
              posts = posts.where((p) => p.isFavorite).toList();
            } else if (widget.filter == 'drafts') {
              posts = posts.where((p) => p.isDraft).toList();
            }

            // 2. SORTING (Custom Order for 'all', UpdatedAt for others)
            if (widget.filter == 'all') {
              final List<String>? savedOrder = settingsBox
                  .get('social_posts_order', defaultValue: <String>[])
                  ?.cast<String>();

              if (savedOrder != null && savedOrder.isNotEmpty) {
                // Create a map for O(1) lookups of index
                final orderMap = {
                  for (var i = 0; i < savedOrder.length; i++) savedOrder[i]: i,
                };

                posts.sort((a, b) {
                  final indexA = orderMap[a.id];
                  final indexB = orderMap[b.id];

                  if (indexA != null && indexB != null) {
                    return indexA.compareTo(indexB);
                  } else if (indexA != null) {
                    return -1; // A exists in order, so it comes first
                  } else if (indexB != null) {
                    return 1; // B exists in order
                  } else {
                    // Both new? Sort by date descending
                    return b.updatedAt.compareTo(a.updatedAt);
                  }
                });
              } else {
                // Default: Newest first
                posts.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
              }
            } else {
              // Favorites/Drafts always sorted by update time
              posts.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
            }

            _currentPosts = posts; // Update local ref

            if (posts.isEmpty) {
              return _buildEmptyState();
            }

            // 3. REORDERABLE LIST
            // Only allow reordering if NOT in selection mode and filter is 'all'
            final canReorder = widget.filter == 'all' && !_isSelectionMode;

            if (canReorder) {
              return ReorderableListView.builder(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                itemCount: posts.length,
                proxyDecorator: (child, index, animation) {
                  return AnimatedBuilder(
                    animation: animation,
                    builder: (BuildContext context, Widget? child) {
                      final double animValue = Curves.easeInOut.transform(
                        animation.value,
                      );
                      final double scale = ui.lerpDouble(1, 1.1, animValue)!;
                      return Transform.scale(
                        scale: scale,
                        child: Material(
                          color: Colors.transparent,
                          elevation: 10,
                          shadowColor: Colors.black45,
                          child: child,
                        ),
                      );
                    },
                    child: child,
                  );
                },
                onReorder: (oldIndex, newIndex) {
                  if (newIndex > oldIndex) newIndex -= 1;
                  final item = posts.removeAt(oldIndex);
                  posts.insert(newIndex, item);

                  // Save new order
                  final newOrderIds = posts.map((p) => p.id).toList();
                  settingsBox.put('social_posts_order', newOrderIds);
                },
                itemBuilder: (context, index) {
                  final post = posts[index];
                  return ReorderableDelayedDragStartListener(
                    key: ValueKey(post.id),
                    index: index,
                    child: _buildPostCard(context, post),
                  );
                },
              );
            } else {
              // Standard List when reordering disabled (e.g. selection mode or other tabs)
              return ListView.builder(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                itemCount: posts.length,
                itemBuilder: (context, index) {
                  final post = posts[index];
                  return _buildPostCard(context, post);
                },
              );
            }
          },
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            'assets/images/social_empty.svg',
            width: 150.w,
            height: 150.w,
          ),
          SizedBox(height: 16.h),
          Text(
            widget.filter == 'favorites'
                ? 'No favorites yet'
                : widget.filter == 'drafts'
                ? 'No drafts yet'
                : 'Start your social journey!',
            style: TextStyle(
              fontSize: 18.sp,
              color: Colors.grey[600],
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPostCard(BuildContext context, SocialPost post) {
    final isSelected = _selectedIds.contains(post.id);
    final theme = Theme.of(context);

    // Dynamic background color based on selection
    final backgroundColor = isSelected
        ? theme.colorScheme.primaryContainer.withValues(alpha: 0.3)
        : theme.cardColor;

    return Card(
      margin: EdgeInsets.only(bottom: 12.h),
      elevation: isSelected ? 4 : 2,
      color: backgroundColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.r),
        side: isSelected
            ? BorderSide(color: theme.colorScheme.primary, width: 2)
            : BorderSide.none,
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12.r),
        onTap: () {
          if (_isSelectionMode) {
            _toggleSelection(post.id);
          } else {
            context.push(AppRouter.socialPostEdit, extra: post);
          }
        },
        onLongPress: () {
          _toggleSelection(post.id);
        },
        child: Padding(
          padding: EdgeInsets.all(12.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  // Selection Checkbox
                  if (_isSelectionMode) ...[
                    Icon(
                      isSelected ? Icons.check_circle : Icons.circle_outlined,
                      color: isSelected
                          ? theme.colorScheme.primary
                          : Colors.grey,
                      size: 20.sp,
                    ),
                    SizedBox(width: 8.w),
                  ],
                  _PlatformIcon(platform: post.platform),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: Text(
                      timeago.format(post.updatedAt),
                      style: TextStyle(fontSize: 12.sp, color: Colors.grey),
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      post.isFavorite ? Icons.favorite : Icons.favorite_border,
                      color: post.isFavorite ? Colors.red : Colors.grey,
                      size: 20.sp,
                    ),
                    onPressed: () {
                      // Dont allow favorite toggle in selection mode to avoid confusion?
                      // Or just let it happen. Let's block it in selection mode for cleaner UX.
                      if (_isSelectionMode) {
                        _toggleSelection(post.id);
                        return;
                      }
                      post.isFavorite = !post.isFavorite;
                      post.save();
                    },
                  ),
                  if (post.isDraft)
                    Container(
                      margin: EdgeInsets.only(left: 8.w),
                      padding: EdgeInsets.symmetric(
                        horizontal: 6.w,
                        vertical: 2.h,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.orange.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(
                          color: Colors.orange.withValues(alpha: 0.5),
                        ),
                      ),
                      child: Text(
                        'DRAFT',
                        style: TextStyle(
                          fontSize: 10.sp,
                          color: Colors.orange[800],
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  // Drag Handle
                  if (widget.filter == 'all' && !_isSelectionMode)
                    const Padding(
                      padding: EdgeInsets.only(left: 8),
                      child: Icon(Icons.drag_handle, color: Colors.grey),
                    ),
                ],
              ),
              SizedBox(height: 8.h),
              // Hero Animation on content preview
              // Matches the tag in SocialPostScreen (which we will add next)
              Hero(
                tag: 'post_content_${post.id}',
                child: Material(
                  color: Colors.transparent,
                  child: Text(
                    _getPreviewText(post.content),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 14.sp),
                  ),
                ),
              ),
              if (post.mediaPaths.isNotEmpty)
                Padding(
                  padding: EdgeInsets.only(top: 8.h),
                  child: Row(
                    children: [
                      Icon(Icons.attachment, size: 16.sp, color: Colors.grey),
                      SizedBox(width: 4.w),
                      Text(
                        '${post.mediaPaths.length} attachment${post.mediaPaths.length > 1 ? 's' : ''}',
                        style: TextStyle(fontSize: 12.sp, color: Colors.grey),
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

  String _getPreviewText(String content) {
    if (!content.startsWith('[')) return content;
    try {
      final List<dynamic> delta = jsonDecode(content);
      final buffer = StringBuffer();
      for (var op in delta) {
        if (op is Map<String, dynamic> && op['insert'] is String) {
          buffer.write(op['insert']);
        }
      }
      return buffer.toString().trim().replaceAll('\n', ' ');
    } catch (_) {
      return content;
    }
  }
}

class _PlatformIcon extends StatelessWidget {
  final SocialPlatformType platform;

  const _PlatformIcon({required this.platform});

  @override
  Widget build(BuildContext context) {
    IconData icon;
    Color color;

    switch (platform) {
      case SocialPlatformType.facebook:
        icon = FontAwesomeIcons.facebookF;
        color = const Color(0xFF1877F2);
        break;
      case SocialPlatformType.twitter:
        icon = FontAwesomeIcons.twitter;
        color = Colors.black;
        break;
      case SocialPlatformType.instagram:
        icon = FontAwesomeIcons.instagram;
        color = const Color(0xFFE4405F);
        break;
      case SocialPlatformType.linkedin:
        icon = FontAwesomeIcons.linkedinIn;
        color = const Color(0xFF0077B5);
        break;
      case SocialPlatformType.whatsapp:
        icon = FontAwesomeIcons.whatsapp;
        color = const Color(0xFF25D366);
        break;
      case SocialPlatformType.telegram:
        icon = FontAwesomeIcons.telegram;
        color = const Color(0xFF0088CC);
        break;
      case SocialPlatformType.tiktok:
        icon = FontAwesomeIcons.tiktok;
        color = Colors.black;
        break;
      case SocialPlatformType.pinterest:
        icon = FontAwesomeIcons.pinterest;
        color = const Color(0xFFE60023);
        break;
      default:
        icon = Icons.share;
        color = Colors.grey;
    }

    return CircleAvatar(
      backgroundColor: color.withValues(alpha: 0.1),
      radius: 12.r,
      child: FaIcon(icon, color: color, size: 14.sp),
    );
  }
}
