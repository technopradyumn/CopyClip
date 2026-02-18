import 'dart:io';
import 'dart:convert';

import 'package:copyclip/src/core/widgets/glass_scaffold.dart';
import 'package:copyclip/src/core/widgets/dynamic_background.dart';
import 'package:copyclip/src/features/social_post/presentation/widgets/social_platform_selector.dart';
import 'package:copyclip/src/features/social_post/data/social_post_model.dart';
import 'package:copyclip/src/core/services/lazy_box_loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_quill/flutter_quill.dart'; // For legacy post migration
import 'package:appinio_social_share_plus/appinio_social_share_plus.dart';

import 'package:image_picker/image_picker.dart';
import 'package:share_plus/share_plus.dart';
import 'package:uuid/uuid.dart';
import 'package:go_router/go_router.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../../l10n/app_localizations.dart';

class SocialPostScreen extends StatefulWidget {
  final SocialPost? postToEdit;

  const SocialPostScreen({super.key, this.postToEdit});

  @override
  State<SocialPostScreen> createState() => _SocialPostScreenState();
}

class _SocialPostScreenState extends State<SocialPostScreen> {
  late TextEditingController _controller;
  final FocusNode _focusNode = FocusNode();
  final ScrollController _scrollController = ScrollController();
  final AppinioSocialSharePlus _appinioSocialShare = AppinioSocialSharePlus();

  SocialPlatformType _selectedPlatform = SocialPlatformType.generic;
  final List<String> _mediaPaths = [];
  bool _isSharing = false;
  bool _isFavorite = false;

  @override
  void initState() {
    super.initState();
    _initializeEditor();
  }

  void _initializeEditor() {
    if (widget.postToEdit != null) {
      final post = widget.postToEdit!;
      _selectedPlatform = post.platform;
      _mediaPaths.addAll(post.mediaPaths);
      _isFavorite = post.isFavorite;

      // Extract plain text from content (handle legacy JSON format)
      String plainText = post.content;
      if (post.content.startsWith('[')) {
        try {
          // Legacy: Extract text from Quill JSON
          final doc = Document.fromJson(jsonDecode(post.content));
          plainText = doc.toPlainText();
        } catch (e) {
          plainText = post.content;
        }
      }
      _controller = TextEditingController(text: plainText);
    } else {
      _controller = TextEditingController();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _pickMedia(ImageSource source) async {
    final ImagePicker picker = ImagePicker();
    if (source == ImageSource.gallery) {
      // Show dialog to choose image or video for gallery
      final type = await showModalBottomSheet<String>(
        context: context,
        builder: (ctx) => Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.image),
              title: Text(AppLocalizations.of(context)!.pickImages),
              onTap: () => Navigator.pop(ctx, 'image'),
            ),
            ListTile(
              leading: const Icon(Icons.video_library),
              title: Text(AppLocalizations.of(context)!.pickVideo),
              onTap: () => Navigator.pop(ctx, 'video'),
            ),
          ],
        ),
      );

      if (type == 'image') {
        final List<XFile> images = await picker.pickMultiImage();
        if (images.isNotEmpty) {
          setState(() {
            _mediaPaths.addAll(images.map((e) => e.path));
          });
        }
      } else if (type == 'video') {
        final XFile? video = await picker.pickVideo(
          source: ImageSource.gallery,
        );
        if (video != null) {
          setState(() {
            _mediaPaths.add(video.path);
          });
        }
      }
    } else {
      // Camera - default to image for now, or ask
      final XFile? image = await picker.pickImage(source: ImageSource.camera);
      if (image != null) {
        setState(() {
          _mediaPaths.add(image.path);
        });
      }
    }
  }

  void _removeMedia(int index) {
    setState(() {
      _mediaPaths.removeAt(index);
    });
  }

  Future<void> _savePost({bool isDraft = false}) async {
    final box = await LazyBoxLoader.getBox<SocialPost>('social_posts_box');

    final content = _controller.text;
    final now = DateTime.now();

    if (widget.postToEdit != null) {
      final post = widget.postToEdit!;
      post.content = content;
      post.mediaPaths = List.from(_mediaPaths);
      post.platformIndex = _selectedPlatform.index;
      post.isFavorite = _isFavorite;
      post.isDraft = isDraft;
      post.updatedAt = now;
      await post.save();
    } else {
      final newPost = SocialPost(
        id: const Uuid().v4(),
        content: content,
        mediaPaths: List.from(_mediaPaths),
        platformIndex: _selectedPlatform.index,
        isFavorite: _isFavorite,
        isDraft: isDraft,
        createdAt: now,
        updatedAt: now,
      );
      await box.put(newPost.id, newPost);
    }

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(isDraft ? 'Draft saved' : 'Post saved to history'),
        ),
      );
      if (isDraft) context.pop();
    }
  }

  void _toggleFavorite() {
    setState(() => _isFavorite = !_isFavorite);
  }

  Future<void> _shareContent() async {
    final String plainText = _controller.text.trim();
    if (plainText.isEmpty && _mediaPaths.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please add some content or media to share'),
        ),
      );
      return;
    }

    setState(() => _isSharing = true);
    debugPrint(
      "Attempting to share. Platform: $_selectedPlatform, Text length: ${plainText.length}, Media count: ${_mediaPaths.length}",
    );

    // Debug: Check files
    for (var path in _mediaPaths) {
      final file = File(path);
      if (!file.existsSync()) {
        debugPrint("ERROR: File does not exist: $path");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error: File not found at $path")),
        );
        setState(() => _isSharing = false);
        return;
      }
    }

    try {
      String response = "Shared";

      switch (_selectedPlatform) {
        case SocialPlatformType.instagram:
          if (_mediaPaths.isNotEmpty) {
            final mode = await _showShareModeDialog("Instagram");
            if (mode == 'story') {
              response = await _appinioSocialShare.android
                  .shareToInstagramStory(
                    "instagram_app_id", // Replace with actual ID
                    stickerImage: _mediaPaths.first,
                  );
            } else if (mode == 'feed') {
              if (_mediaPaths.length > 1) {
                // shareFilesToInstagramFeed(List<String> imagePaths)
                response = await _appinioSocialShare.android
                    .shareFilesToInstagramFeed(_mediaPaths);
              } else {
                // shareToInstagramFeed(String message, String? filePath)
                response = await _appinioSocialShare.android
                    .shareToInstagramFeed(plainText, _mediaPaths.first);
              }
            } else {
              // shareToInstagramDirect(String appId, String message)
              response = await _appinioSocialShare.android
                  .shareToInstagramDirect("instagram_app_id", plainText);
            }
          } else {
            response = await _appinioSocialShare.android.shareToInstagramDirect(
              "instagram_app_id",
              plainText,
            );
          }
          break;

        case SocialPlatformType.facebook:
          // Facebook Policy: Cannot pre-fill text. Copy to clipboard for user to paste.
          if (plainText.isNotEmpty) {
            await Clipboard.setData(ClipboardData(text: plainText));
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Text copied to clipboard (Facebook policy)'),
                  duration: Duration(seconds: 2),
                ),
              );
            }
          }

          if (_mediaPaths.isNotEmpty) {
            final mode = await _showShareModeDialog("Facebook");
            if (mode == 'story') {
              response = await _appinioSocialShare.android.shareToFacebookStory(
                "facebook_app_id",
                stickerImage: _mediaPaths.first,
              );
            } else {
              // Use share_plus for Facebook Feed as it's more reliable for media
              // Appinio's shareToFacebook often fails with media if App ID isn't perfect
              final files = _mediaPaths.map((path) => XFile(path)).toList();
              // Facebook Feed doesn't support pre-filled text in the intent usually,
              // but we already copied it to clipboard above.
              // ignore: deprecated_member_use
              await Share.shareXFiles(files, text: plainText);
              response = "Check Facebook app";
            }
          } else {
            // Text only -> Use System Share
            // Fallback to system share for text-only facebook attempts
            // ignore: deprecated_member_use
            await Share.share(plainText);
            response = "System Share";
          }
          break;

        case SocialPlatformType.whatsapp:
          if (_mediaPaths.length > 1) {
            // shareFilesToWhatsapp(List<String> filePaths)
            response = await _appinioSocialShare.android.shareFilesToWhatsapp(
              _mediaPaths,
            );
          } else if (_mediaPaths.isNotEmpty) {
            // shareToWhatsapp(String message, String? filePath)
            response = await _appinioSocialShare.android.shareToWhatsapp(
              plainText,
              _mediaPaths.first,
            );
          } else {
            response = await _appinioSocialShare.android.shareToWhatsapp(
              plainText,
              null,
            );
          }
          break;

        case SocialPlatformType.telegram:
          if (_mediaPaths.length > 1) {
            // shareFilesToTelegram(List<String> filePaths)
            response = await _appinioSocialShare.android.shareFilesToTelegram(
              _mediaPaths,
            );
          } else if (_mediaPaths.isNotEmpty) {
            // shareToTelegram(String message, String? filePath)
            response = await _appinioSocialShare.android.shareToTelegram(
              plainText,
              _mediaPaths.first,
            );
          } else {
            response = await _appinioSocialShare.android.shareToTelegram(
              plainText,
              null,
            );
          }
          break;

        case SocialPlatformType.twitter:
          // shareToTwitter(String message, {String? filePath})
          response = await _appinioSocialShare.android.shareToTwitter(
            plainText,
            filePath: _mediaPaths.isNotEmpty ? _mediaPaths.first : null,
          );
          break;

        case SocialPlatformType.linkedin:
          // shareToLinkedinFeed(String message, String? imagePath)
          response = await _appinioSocialShare.android.shareToLinkedinFeed(
            plainText,
            _mediaPaths.isNotEmpty ? _mediaPaths.first : null,
          );
          break;

        case SocialPlatformType.tiktok:
          // shareToTiktokStatus(List<String> filePaths)
          if (_mediaPaths.isNotEmpty) {
            response = await _appinioSocialShare.android.shareToTiktokStatus(
              _mediaPaths,
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('TikTok sharing requires a video/image'),
              ),
            );
          }
          break;

        case SocialPlatformType.pinterest:
        default:
          // shareToSystem(String title, String message, String? filePath)
          // shareFilesToSystem(String title, List<String> filePaths)
          if (_mediaPaths.length > 1) {
            response = await _appinioSocialShare.android.shareFilesToSystem(
              "Share",
              _mediaPaths,
            );
          } else {
            response = await _appinioSocialShare.android.shareToSystem(
              "Share",
              plainText,
              _mediaPaths.isNotEmpty ? _mediaPaths.first : null,
            );
          }
          break;
      }

      debugPrint("Share response: $response");
      await _savePost(isDraft: false);
    } catch (e) {
      debugPrint("Error sharing: $e");
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error sharing: $e')));
      }
    } finally {
      if (mounted) setState(() => _isSharing = false);
    }
  }

  Future<String?> _showShareModeDialog(String platform) {
    return showModalBottomSheet<String>(
      context: context,
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            title: Text("Share to $platform Story"),
            leading: const Icon(Icons.history_edu),
            onTap: () => Navigator.pop(context, 'story'),
          ),
          ListTile(
            title: Text("Share to $platform Feed"),
            leading: const Icon(Icons.feed),
            onTap: () => Navigator.pop(context, 'feed'),
          ),
        ],
      ),
    );
  }

  void _showPlatformSelector() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => SocialPlatformGridSelector(
        selectedPlatform: _selectedPlatform,
        onPlatformChanged: (platform) {
          setState(() => _selectedPlatform = platform);
          Navigator.pop(context);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final platformData = SocialPlatformSelector.getPlatformData(
      _selectedPlatform,
      theme,
    );

    // ✅ FIX: Detect keyboard visibility
    final keyboardVisible = MediaQuery.of(context).viewInsets.bottom > 0;

    return GlassScaffold(
      title: AppLocalizations.of(context)!.createPost,
      showBackArrow: true,
      actions: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
          child: FilledButton(
            onPressed: _isSharing ? null : _shareContent,
            style: FilledButton.styleFrom(
              shape: const StadiumBorder(),
              visualDensity: VisualDensity.compact,
            ),
            child: _isSharing
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : Text(AppLocalizations.of(context)!.post),
          ),
        ),
      ],
      body: DynamicBackground(
        child: Column(
          children: [
            // 1. User/Platform Context
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  // Avatar (Placeholder)  - Hero for icon
                  Hero(
                    tag: 'social_post_icon',
                    child: Container(
                      width: 52,
                      height: 52,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            const Color(0xFF1DA1F2).withValues(alpha: 0.8),
                            const Color(0xFF1DA1F2),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF1DA1F2).withValues(alpha: 0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: const Icon(
                        CupertinoIcons.share,
                        color: Colors.white,
                        size: 26,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Posting to Chip with Hero for title
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Hero(
                          tag: 'social_post_title',
                          child: Material(
                            type: MaterialType.transparency,
                            child: Text(
                              'Social Post',
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: _showPlatformSelector,
                            borderRadius: BorderRadius.circular(20),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: theme.colorScheme.outline.withValues(
                                    alpha: 0.5,
                                  ),
                                ),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    AppLocalizations.of(context)!.postingTo,
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      color: theme.colorScheme.onSurfaceVariant,
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                  FaIcon(
                                    platformData.icon,
                                    size: 14,
                                    color: platformData.color,
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    platformData.name,
                                    style: theme.textTheme.labelLarge?.copyWith(
                                      color: platformData.color,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  Icon(
                                    Icons.keyboard_arrow_down,
                                    size: 16,
                                    color: theme.colorScheme.onSurfaceVariant,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // 2. Editor
            Expanded(
              child: Material(
                color: Colors.transparent,
                child: Container(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Theme.of(
                      context,
                    ).colorScheme.surface.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: Theme.of(
                        context,
                      ).colorScheme.outline.withValues(alpha: 0.2),
                    ),
                  ),
                  child: TextField(
                    controller: _controller,
                    focusNode: _focusNode,
                    scrollController: _scrollController,
                    maxLines: null,
                    expands: true,
                    textAlignVertical: TextAlignVertical.top,
                    style: Theme.of(context).textTheme.bodyLarge,
                    decoration: InputDecoration(
                      hintText: AppLocalizations.of(context)!.whatsOnYourMind,
                      border: InputBorder.none,
                      hintStyle: Theme.of(context).textTheme.bodyLarge
                          ?.copyWith(
                            color: Theme.of(
                              context,
                            ).colorScheme.onSurface.withValues(alpha: 0.5),
                          ),
                    ),
                  ),
                ),
              ),
            ),

            // 3. Media Grid - ✅ FIX: Hide when keyboard is visible
            if (_mediaPaths.isNotEmpty && !keyboardVisible)
              ConstrainedBox(
                constraints: const BoxConstraints(maxHeight: 250),
                child: GridView.builder(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  shrinkWrap: true,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                  ),
                  itemCount: _mediaPaths.length,
                  itemBuilder: (context, index) {
                    return Stack(
                      fit: StackFit.expand,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child:
                              _mediaPaths[index].endsWith('.mp4') ||
                                  _mediaPaths[index].endsWith('.mov')
                              ? Container(
                                  color: Colors.black12,
                                  child: const Icon(
                                    Icons.play_circle_fill,
                                    color: Colors.white,
                                    size: 30,
                                  ),
                                )
                              : Image.file(
                                  File(_mediaPaths[index]),
                                  fit: BoxFit.cover,
                                ),
                        ),
                        Positioned(
                          top: 4,
                          right: 4,
                          child: GestureDetector(
                            onTap: () => _removeMedia(index),
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: const BoxDecoration(
                                color: Colors.black54,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.close,
                                size: 14,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),

            // 4. Bottom Toolbar - ✅ FIX: Hide when keyboard is visible
            if (!keyboardVisible)
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface.withValues(alpha: 0.8),
                  border: Border(
                    top: BorderSide(color: theme.colorScheme.outlineVariant),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    IconButton(
                      onPressed: () => _pickMedia(ImageSource.gallery),
                      icon: const Icon(Icons.photo_library_outlined),
                      tooltip: AppLocalizations.of(context)!.gallery,
                      color: theme.colorScheme.primary,
                    ),
                    IconButton(
                      onPressed: () => _pickMedia(ImageSource.camera),
                      icon: const Icon(Icons.camera_alt_outlined),
                      tooltip: AppLocalizations.of(context)!.camera,
                      color: theme.colorScheme.primary,
                    ),
                    IconButton(
                      onPressed: _toggleFavorite,
                      icon: Icon(
                        _isFavorite ? Icons.favorite : Icons.favorite_border,
                        color: _isFavorite
                            ? Colors.red
                            : theme.colorScheme.onSurfaceVariant,
                      ),
                      tooltip: "Favorite",
                    ),
                    IconButton(
                      onPressed: () => _savePost(isDraft: true),
                      icon: const Icon(Icons.save_as_outlined),
                      tooltip: "Save Draft",
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
