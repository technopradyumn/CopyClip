import 'package:flutter/material.dart';
import 'package:copyclip/src/core/widgets/glass_scaffold.dart';
import 'package:copyclip/src/core/widgets/glass_container.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;
    final onSurfaceColor = theme.colorScheme.onSurface;

    return GlassScaffold(
      title: "Privacy Policy",
      body: ListView(
        padding: const EdgeInsets.only(left: 20, right: 20,bottom: 20),
        physics: const BouncingScrollPhysics(),
        children: [
          _buildSection(
            context,
            title: "Introduction",
            content:
            "At CopyClip, we take your privacy seriously. This Privacy Policy explains how we collect, use, and protect your information when you use our application.",
            icon: Icons.info_outline,
            color: primaryColor,
          ),
          const SizedBox(height: 16),
          _buildSection(
            context,
            title: "Data Collection",
            content:
            "CopyClip stores all your data locally on your device. We do not collect, transmit, or store any of your personal information on external servers. The data you create (notes, todos, expenses, journal entries, and clipboard items) remains entirely on your device.",
            icon: Icons.storage_outlined,
            color: primaryColor,
          ),
          const SizedBox(height: 16),
          _buildSection(
            context,
            title: "Clipboard Access",
            content:
            "CopyClip requires accessibility permission to automatically capture clipboard content. This permission is used solely to provide the clipboard management feature. We do not share or transmit your clipboard data outside the app.",
            icon: Icons.content_paste_outlined,
            color: primaryColor,
          ),
          const SizedBox(height: 16),
          _buildSection(
            context,
            title: "Data Storage",
            content:
            "All data is stored locally using Hive database on your device. You have full control over your data and can export, import, or delete it at any time through the app settings.",
            icon: Icons.folder_outlined,
            color: primaryColor,
          ),
          const SizedBox(height: 16),
          _buildSection(
            context,
            title: "Third-Party Services",
            content:
            "CopyClip does not use any third-party analytics, advertising, or tracking services. Your data never leaves your device unless you explicitly choose to export it.",
            icon: Icons.block_outlined,
            color: primaryColor,
          ),
          const SizedBox(height: 16),
          _buildSection(
            context,
            title: "Data Security",
            content:
            "We implement industry-standard security measures to protect your data. Since all data is stored locally, the security of your information depends on your device's security settings.",
            icon: Icons.security_outlined,
            color: primaryColor,
          ),
          const SizedBox(height: 16),
          _buildSection(
            context,
            title: "Your Rights",
            content:
            "You have the right to access, modify, export, and delete your data at any time. You can do this through the app's settings or by uninstalling the application.",
            icon: Icons.verified_user_outlined,
            color: primaryColor,
          ),
          const SizedBox(height: 16),
          _buildSection(
            context,
            title: "Updates to Privacy Policy",
            content:
            "We may update this Privacy Policy from time to time. We will notify you of any changes by posting the new Privacy Policy on this page and updating the 'Last Updated' date.",
            icon: Icons.update_outlined,
            color: primaryColor,
          ),
          const SizedBox(height: 16),
          _buildSection(
            context,
            title: "Contact Us",
            content:
            "If you have any questions about this Privacy Policy, please contact us through the feedback option in the app settings or reach out via our social media channels.",
            icon: Icons.contact_support_outlined,
            color: primaryColor,
          ),
          const SizedBox(height: 24),
          Center(
            child: Text(
              "Last Updated: December 22, 2025",
              style: theme.textTheme.bodySmall?.copyWith(
                color: onSurfaceColor.withOpacity(0.5),
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildSection(
      BuildContext context, {
        required String title,
        required String content,
        required IconData icon,
        required Color color,
      }) {
    final theme = Theme.of(context);
    return GlassContainer(
      color: color.withOpacity(0.08),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 24),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            content,
            style: theme.textTheme.bodyMedium?.copyWith(
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}