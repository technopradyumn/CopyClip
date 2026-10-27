import 'package:copyclip/src/core/router/app_router.dart';
import 'package:copyclip/src/l10n/app_localizations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Navigation drawer shown from the hamburger menu on feature screens.
class CopyClipDrawer extends StatelessWidget {
  const CopyClipDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    final theme = Theme.of(context);

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: theme.colorScheme.primaryContainer,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.copy,
                  size: 40,
                  color: CupertinoColors.activeBlue,
                ),
                const SizedBox(height: 8),
                Text(
                  'CopyClip',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  localizations?.productivityCompanion ?? 'Your productivity companion',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                  ),
                ),
              ],
            ),
          ),
          _DrawerItem(
            icon: CupertinoIcons.doc_text,
            title: localizations?.notes ?? 'Notes',
            onTap: () {
              context.pop();
              context.go(AppRouter.notes);
            },
          ),
          _DrawerItem(
            icon: CupertinoIcons.checkmark_circle,
            title: localizations?.todos ?? 'To-Dos',
            onTap: () {
              context.pop();
              context.go(AppRouter.todos);
            },
          ),
          _DrawerItem(
            icon: CupertinoIcons.book,
            title: localizations?.journal ?? 'Journal',
            onTap: () {
              context.pop();
              context.go(AppRouter.journal);
            },
          ),
          _DrawerItem(
            icon: CupertinoIcons.doc_on_clipboard,
            title: localizations?.clipboard ?? 'Clipboard',
            onTap: () {
              context.pop();
              context.go(AppRouter.clipboard);
            },
          ),
          const Divider(height: 1),
          _DrawerItem(
            icon: CupertinoIcons.settings,
            title: localizations?.settings ?? 'Settings',
            onTap: () {
              context.pop();
              context.go(AppRouter.settings);
            },
          ),
          _DrawerItem(
            icon: CupertinoIcons.delete,
            title: localizations?.recycleBin ?? 'Recycle Bin',
            onTap: () {
              context.pop();
              context.go(AppRouter.recycleBin);
            },
          ),
          _DrawerItem(
            icon: CupertinoIcons.doc_text,
            title: localizations?.privacyPolicy ?? 'Privacy Policy',
            onTap: () {
              context.pop();
              context.go(AppRouter.privacyPolicy);
            },
          ),
          _DrawerItem(
            icon: CupertinoIcons.chat_bubble,
            title: localizations?.sendFeedback ?? 'Feedback',
            onTap: () {
              context.pop();
              context.go(AppRouter.feedback);
            },
          ),
          const Divider(height: 1),
          _DrawerItem(
            icon: CupertinoIcons.star,
            title: localizations?.premium ?? 'Premium',
            onTap: () {
              context.pop();
              context.go(AppRouter.premium);
            },
          ),
        ],
      ),
    );
  }
}

class _DrawerItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const _DrawerItem({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ListTile(
      leading: Icon(icon, color: theme.colorScheme.onSurface),
      title: Text(
        title,
        style: theme.textTheme.bodyMedium?.copyWith(
          color: theme.colorScheme.onSurface,
          fontWeight: FontWeight.w500,
        ),
      ),
      onTap: onTap,
    );
  }
}
