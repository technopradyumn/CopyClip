import 'dart:convert';

import 'package:copyclip/src/features/social_post/data/social_post_model.dart';
import '../../../../l10n/app_localizations.dart';
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

  const SocialPostListWidget({super.key, required this.filter});

  @override
  State<SocialPostListWidget> createState() => _SocialPostListWidgetState();
}

class _SocialPostListWidgetState extends State<SocialPostListWidget> {
  late Future<Box<SocialPost>> _boxFuture;
  late Future<Box> _settingsBoxFuture;

  @override
  void initState() {
    super.initState();
    _boxFuture = LazyBoxLoader.getBox<SocialPost>('social_posts_box');
    _settingsBoxFuture = LazyBoxLoader.getBox('settings');
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

            if (posts.isEmpty) {
              return _buildEmptyState();
            }

            // 3. REORDERABLE LIST
            return ReorderableListView.builder(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
              itemCount: posts.length,
              proxyDecorator: (child, index, animation) => Material(
                elevation: 4,
                color: Colors.transparent,
                child: child,
              ),
              onReorder: (oldIndex, newIndex) {
                if (widget.filter != 'all') {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Ordering only available in 'All Posts'"),
                    ),
                  );
                  return;
                }

                if (newIndex > oldIndex) newIndex -= 1;
                final item = posts.removeAt(oldIndex);
                posts.insert(newIndex, item);

                // Save new order
                final newOrderIds = posts.map((p) => p.id).toList();

                // We must also include IDs that might be hidden by filters if we supported complex filtering,
                // but here 'all' includes everything except maybe strictly deleted ones.
                // However, to be safe, we should merge with existing IDs not in this view?
                // For simplicity, assuming 'all' shows all items.
                // Wait! 'all' shows everything.

                // BUT, what if there are items NOT loaded? Hive loads all.
                // What if we just filtered out drafts? 'all' usually implies everything.
                // The prompt implies 'all' tab.

                settingsBox.put('social_posts_order', newOrderIds);
              },
              itemBuilder: (context, index) {
                final post = posts[index];
                return Dismissible(
                  key: ValueKey(post.id),
                  background: Container(
                    margin: EdgeInsets.symmetric(vertical: 8.h),
                    decoration: BoxDecoration(
                      color: Colors.red.withValues(alpha: 0.8),
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    alignment: Alignment.centerRight,
                    padding: EdgeInsets.only(right: 20.w),
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),
                  direction: DismissDirection.endToStart,
                  confirmDismiss: (direction) async {
                    return await showDialog(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        title: Text(AppLocalizations.of(context)!.deletePost),
                        content: Text(
                          AppLocalizations.of(
                            context,
                          )!.areYouSureYouWantToDeleteThisPost,
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(ctx).pop(false),
                            child: Text(AppLocalizations.of(context)!.cancel),
                          ),
                          TextButton(
                            onPressed: () => Navigator.of(ctx).pop(true),
                            child: const Text(
                              "Delete",
                              style: TextStyle(color: Colors.red),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                  onDismissed: (direction) {
                    post.delete();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Post deleted")),
                    );
                  },
                  child: _buildPostCard(context, post),
                );
              },
            );
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
            'assets/images/social_empty.svg', // Uses the newly created SVG
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
    return Card(
      key: ValueKey(post.id), // Important for ReorderableListView
      margin: EdgeInsets.only(bottom: 12.h),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
      child: InkWell(
        borderRadius: BorderRadius.circular(12.r),
        onTap: () {
          context.push(AppRouter.socialPostEdit, extra: post);
        },
        child: Padding(
          padding: EdgeInsets.all(12.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
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
                  if (widget.filter == 'all')
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
