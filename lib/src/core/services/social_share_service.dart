import 'dart:io';
import 'package:appinio_social_share_plus/appinio_social_share_plus.dart';
import 'package:copyclip/src/features/social_post/presentation/widgets/social_platform_selector.dart';
import '../../features/social_post/data/social_post_model.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import '../../l10n/app_localizations.dart';

class SocialShareService {
  final AppinioSocialSharePlus _appinioSocialShare = AppinioSocialSharePlus();

  Future<void> sharePost({
    required BuildContext context,
    required SocialPost post,
  }) async {
    final String plainText = post.content;
    final List<String> mediaPaths = post.mediaPaths;
    final platform = post.platform;

    if (plainText.isEmpty && mediaPaths.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context)!.pleaseAddContent)),
      );
      return;
    }

    // Check files
    for (var path in mediaPaths) {
      if (!File(path).existsSync()) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              AppLocalizations.of(context)!.fileNotFoundError(path),
            ),
          ),
        );
        return;
      }
    }

    try {
      String response = "Shared";

      switch (platform) {
        case SocialPlatformType.instagram:
          if (mediaPaths.isNotEmpty) {
            final mode = await _showShareModeDialog(context, 'Instagram');
            if (mode == 'story') {
              response = await _appinioSocialShare.android
                  .shareToInstagramStory(
                    "instagram_app_id",
                    stickerImage: mediaPaths.first,
                  );
            } else if (mode == 'feed') {
              if (mediaPaths.length > 1) {
                response = await _appinioSocialShare.android
                    .shareFilesToInstagramFeed(mediaPaths);
              } else {
                response = await _appinioSocialShare.android
                    .shareToInstagramFeed(plainText, mediaPaths.first);
              }
            } else if (mode != null) {
              response = await _appinioSocialShare.android
                  .shareToInstagramDirect("instagram_app_id", plainText);
            } else {
              return; // User cancelled
            }
          } else {
            response = await _appinioSocialShare.android.shareToInstagramDirect(
              "instagram_app_id",
              plainText,
            );
          }
          break;

        case SocialPlatformType.facebook:
          if (mediaPaths.isNotEmpty) {
            final mode = await _showShareModeDialog(context, 'Facebook');
            if (mode == 'story') {
              response = await _appinioSocialShare.android.shareToFacebookStory(
                "facebook_app_id",
                stickerImage: mediaPaths.first,
              );
            } else if (mode != null) {
              final files = mediaPaths.map((path) => XFile(path)).toList();
              await Share.shareXFiles(files, text: plainText);
              response = AppLocalizations.of(context)!.checkFacebookApp;
            } else {
              return; // User cancelled
            }
          } else {
            await Share.share(plainText);
            response = AppLocalizations.of(context)!.systemShare;
          }
          break;

        case SocialPlatformType.whatsapp:
          if (mediaPaths.length > 1) {
            response = await _appinioSocialShare.android.shareFilesToWhatsapp(
              mediaPaths,
            );
          } else if (mediaPaths.isNotEmpty) {
            response = await _appinioSocialShare.android.shareToWhatsapp(
              plainText,
              mediaPaths.first,
            );
          } else {
            response = await _appinioSocialShare.android.shareToWhatsapp(
              plainText,
              null,
            );
          }
          break;

        case SocialPlatformType.telegram:
          if (mediaPaths.length > 1) {
            response = await _appinioSocialShare.android.shareFilesToTelegram(
              mediaPaths,
            );
          } else if (mediaPaths.isNotEmpty) {
            response = await _appinioSocialShare.android.shareToTelegram(
              plainText,
              mediaPaths.first,
            );
          } else {
            response = await _appinioSocialShare.android.shareToTelegram(
              plainText,
              null,
            );
          }
          break;

        case SocialPlatformType.twitter:
          response = await _appinioSocialShare.android.shareToTwitter(
            plainText,
            filePath: mediaPaths.isNotEmpty ? mediaPaths.first : null,
          );
          break;

        case SocialPlatformType.linkedin:
          response = await _appinioSocialShare.android.shareToLinkedinFeed(
            plainText,
            mediaPaths.isNotEmpty ? mediaPaths.first : null,
          );
          break;

        case SocialPlatformType.tiktok:
          if (mediaPaths.isNotEmpty) {
            response = await _appinioSocialShare.android.shareToTiktokStatus(
              mediaPaths,
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  AppLocalizations.of(context)!.tiktokSharingRequiresVideoImage,
                ),
              ),
            );
          }
          break;

        case SocialPlatformType.pinterest:
        default:
          if (mediaPaths.isNotEmpty) {
            final files = mediaPaths.map((path) => XFile(path)).toList();
            await Share.shareXFiles(
              files,
              text: plainText,
              subject: AppLocalizations.of(context)!.share,
            );
            response = AppLocalizations.of(context)!.systemShare;
          } else {
            await Share.share(plainText);
            response = AppLocalizations.of(context)!.systemShare;
          }
          break;
      }
      debugPrint("Share success: $response");
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              AppLocalizations.of(context)!.errorSharing(e.toString()),
            ),
          ),
        );
      }
    }
  }

  Future<String?> _showShareModeDialog(BuildContext context, String platform) {
    return showModalBottomSheet<String>(
      context: context,
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            title: Text(AppLocalizations.of(context)!.shareToStory(platform)),
            leading: const Icon(Icons.history_edu),
            onTap: () => Navigator.pop(context, 'story'),
          ),
          ListTile(
            title: Text(AppLocalizations.of(context)!.shareToFeed(platform)),
            leading: const Icon(Icons.feed),
            onTap: () => Navigator.pop(context, 'feed'),
          ),
        ],
      ),
    );
  }
}
