import 'dart:convert';
import 'dart:ui' as ui;

import 'package:timeago/timeago.dart' as timeago;
import 'package:go_router/go_router.dart';
import 'package:copyclip/src/core/router/app_router.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:copyclip/src/core/services/lazy_box_loader.dart';
import 'package:copyclip/src/features/social_post/data/social_post_model.dart';
import '../../../../l10n/app_localizations.dart';
import 'package:copyclip/src/features/social_post/presentation/widgets/social_platform_selector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:share_plus/share_plus.dart';
import 'dart:io';

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

class SocialPostListWidgetState extends State<SocialPostListWidget>
    with AutomaticKeepAliveClientMixin {
  Box<SocialPost>? _postsBox;
  Box? _settingsBox;
  bool _isLoading = true;

  // Selection State
  bool _isSelectionMode = false;
  final Set<String> _selectedIds = {};

  // Cached posts — only recomputed when the Hive box changes
  List<SocialPost> _currentPosts = [];

  @override
  void initState() {
    super.initState();
    _initBoxes();
    debugPrint("SocialPostListWidget init: ${widget.filter}");
  }

  Future<void> _initBoxes() async {
    _postsBox = await LazyBoxLoader.getBox<SocialPost>('social_posts_box');
    _settingsBox = await LazyBoxLoader.getBox('settings');
    _postsBox!.listenable().addListener(_onBoxChanged);
    _recomputePosts();
    if (mounted) setState(() => _isLoading = false);
  }

  @override
  void dispose() {
    _postsBox?.listenable().removeListener(_onBoxChanged);
    super.dispose();
  }

  void _onBoxChanged() {
    _recomputePosts();
    if (mounted) setState(() {});
  }

  void _recomputePosts() {
    if (_postsBox == null || _settingsBox == null) return;

    List<SocialPost> posts = _postsBox!.values.toList();

    // 1. FILTERING
    if (widget.filter == 'favorites') {
      posts = posts.where((p) => p.isFavorite).toList();
    } else if (widget.filter == 'drafts') {
      posts = posts.where((p) => p.isDraft).toList();
    }

    // 2. SORTING (Custom Order for 'all', UpdatedAt for others)
    if (widget.filter == 'all') {
      final List<String>? savedOrder = _settingsBox!
          .get('social_posts_order', defaultValue: <String>[])
          ?.cast<String>();

      if (savedOrder != null && savedOrder.isNotEmpty) {
        final orderMap = {
          for (var i = 0; i < savedOrder.length; i++) savedOrder[i]: i,
        };

        posts.sort((a, b) {
          final indexA = orderMap[a.id];
          final indexB = orderMap[b.id];

          if (indexA != null && indexB != null) {
            return indexA.compareTo(indexB);
          } else if (indexA != null) {
            return -1;
          } else if (indexB != null) {
            return 1;
          } else {
            return b.updatedAt.compareTo(a.updatedAt);
          }
        });
      } else {
        posts.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
      }
    } else {
      posts.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
    }

    _currentPosts = posts;
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
    if (_postsBox == null) return;
    final idsToDelete = _selectedIds.toList();

    // Delete from Hive
    await _postsBox!.deleteAll(idsToDelete);

    // Also remove from order list if applicable
    if (widget.filter == 'all' && _settingsBox != null) {
      final List<String>? savedOrder = _settingsBox!
          .get('social_posts_order', defaultValue: <String>[])
          ?.cast<String>();

      if (savedOrder != null) {
        final newOrder = savedOrder
            .where((id) => !idsToDelete.contains(id))
            .toList();
        await _settingsBox!.put('social_posts_order', newOrder);
      }
    }

    deselectAll();
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
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_currentPosts.isEmpty) {
      return _buildEmptyState();
    }

    // Only allow reordering if NOT in selection mode and filter is 'all'
    final canReorder = widget.filter == 'all' && !_isSelectionMode;

    if (canReorder) {
      return ReorderableListView.builder(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        itemCount: _currentPosts.length,
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
          setState(() {
            final item = _currentPosts.removeAt(oldIndex);
            _currentPosts.insert(newIndex, item);
          });

          // Save new order
          final newOrderIds = _currentPosts.map((p) => p.id).toList();
          _settingsBox?.put('social_posts_order', newOrderIds);
        },
        itemBuilder: (context, index) {
          final post = _currentPosts[index];
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
        itemCount: _currentPosts.length,
        itemBuilder: (context, index) {
          final post = _currentPosts[index];
          return _buildPostCard(context, post);
        },
      );
    }
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
                ? AppLocalizations.of(context)!.noFavoritesYet
                : widget.filter == 'drafts'
                ? AppLocalizations.of(context)!.noDraftsYet
                : AppLocalizations.of(context)!.startSocialJourney,
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
                      if (_isSelectionMode) {
                        _toggleSelection(post.id);
                        return;
                      }
                      post.isFavorite = !post.isFavorite;
                      post.save();
                    },
                  ),
                  // Share Button
                  IconButton(
                    icon: Icon(
                      Icons.share_outlined,
                      color: Colors.grey,
                      size: 20.sp,
                    ),
                    onPressed: () => _sharePost(context, post),
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
                        AppLocalizations.of(context)!.draft,
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
                        AppLocalizations.of(
                          context,
                        )!.attachmentCount(post.mediaPaths.length),
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

  /// Share post text + images via system share sheet
  Future<void> _sharePost(BuildContext context, SocialPost post) async {
    try {
      final plainText = _getPreviewText(post.content);

      // Collect valid media files
      final validFiles = post.mediaPaths
          .where((p) => File(p).existsSync())
          .map((p) => XFile(p))
          .toList();

      if (validFiles.isNotEmpty) {
        await Share.shareXFiles(
          validFiles,
          text: plainText.isNotEmpty ? plainText : null,
          subject: 'Shared from CopyClip',
        );
      } else if (plainText.isNotEmpty) {
        await Share.share(plainText, subject: 'Shared from CopyClip');
      } else {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Nothing to share')),
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error sharing: $e')),
        );
      }
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
