import 'package:copyclip/src/core/router/app_router.dart';
import 'package:copyclip/src/features/social_post/presentation/widgets/social_post_list_widget.dart';
import '../../../../l10n/app_localizations.dart';
import 'package:copyclip/src/core/widgets/glass_scaffold.dart';
import 'package:copyclip/src/core/widgets/dynamic_background.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:copyclip/src/core/services/lazy_box_loader.dart';
import 'package:copyclip/src/features/social_post/data/social_post_model.dart';

class SocialPostTabsScreen extends StatelessWidget {
  const SocialPostTabsScreen({super.key});

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
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context)!.allPostsDeleted),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: GlassScaffold(
        title: AppLocalizations.of(context)!.socialPosts,
        showBackArrow: true,
        actions: [
          PopupMenuButton<String>(
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
        body: DynamicBackground(
          child: Column(
            children: [
              const TabBar(
                tabs: [
                  Tab(text: 'All Posts'),
                  Tab(text: 'Favorites'),
                  Tab(text: 'Drafts'),
                ],
              ),
              Expanded(
                child: const TabBarView(
                  children: [
                    SocialPostListWidget(filter: 'all'),
                    SocialPostListWidget(filter: 'favorites'),
                    SocialPostListWidget(filter: 'drafts'),
                  ],
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            context.push(AppRouter.socialPostEdit);
          },
          label: const Text('New Post'),
          icon: const Icon(Icons.edit),
        ),
      ),
    );
  }
}
