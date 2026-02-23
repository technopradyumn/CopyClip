import 'dart:io';
import 'package:path/path.dart' as path;
import 'package:copyclip/src/core/services/file_download_service.dart';
import 'package:copyclip/src/core/services/ocr_service.dart';
import 'package:copyclip/src/core/services/web_scraper_service.dart';
import 'package:copyclip/src/core/widgets/glass_scaffold.dart';
import 'package:copyclip/src/core/widgets/dynamic_background.dart';
import 'package:copyclip/src/features/social_post/data/social_post_model.dart';
import 'package:copyclip/src/features/social_post/presentation/widgets/social_platform_selector.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:uuid/uuid.dart';
import 'package:copyclip/src/core/services/lazy_box_loader.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BulkImportScreen extends StatefulWidget {
  const BulkImportScreen({super.key});

  @override
  State<BulkImportScreen> createState() => _BulkImportScreenState();
}

class _BulkImportScreenState extends State<BulkImportScreen> {
  final TextEditingController _urlController = TextEditingController();
  final WebScraperService _webScraperService = WebScraperService();
  final FileDownloadService _fileDownloadService = FileDownloadService();
  final OcrService _ocrService = OcrService(); // Make sure to dispose if needed

  List<String> _imageUrls = [];
  final Set<String> _selectedImageUrls = {};
  int _displayCount = 5;
  bool _isLoading = false;
  String? _statusMessage;
  double _progress = 0.0;

  // Seva Special Mode State
  bool _isSevaMode = false;
  final TextEditingController _sevaTextController = TextEditingController();
  List<String> _sevaPoints = [];
  String _sevaHashtags = "";
  bool _saveToDevice = false;

  Future<void> _parseSevaText() async {
    final text = _sevaTextController.text;
    if (text.isEmpty) return;

    setState(() {
      _isLoading = true;
      _statusMessage = "Extracting links and fetching images...";
      _imageUrls = [];
      _selectedImageUrls.clear();
    });

    try {
      // 1. Extract URLs
      final urlRegex = RegExp(r'https?://[^\s]+');
      final urls = urlRegex
          .allMatches(text)
          .map((m) => m.group(0)!)
          .toSet()
          .toList();

      // 2. Extract Seva Points (everything starting with 🍀)
      // We split by 🍀 and skip the first part (before first 🍀)
      final rawPoints = text.split('🍀').skip(1).toList();

      // 3. Extract Hashtags (we need these to strip from points later)
      final hashtagRegex = RegExp(r'#[^\s#]+');
      final hashtagsList = hashtagRegex
          .allMatches(text)
          .map((m) => m.group(0)!)
          .toList();
      final hashtags = hashtagsList.join(' ');

      final points = rawPoints.map((p) {
        String cleaned = p.trim();
        // Remove hashtags from the point text to avoid duplication
        for (final tag in hashtagsList) {
          cleaned = cleaned.replaceAll(tag, "").trim();
        }
        // Remove any double newlines left after stripping tags
        cleaned = cleaned.replaceAll(RegExp(r'\n{3,}'), '\n\n');
        return "🍀 $cleaned".trim();
      }).toList();

      // 4. Fetch images from each URL found
      List<String> allImages = [];
      for (final url in urls) {
        try {
          final images = await _webScraperService.fetchImageUrls(url);
          allImages.addAll(images);
        } catch (e) {
          debugPrint("Error scraping $url: $e");
        }
      }

      setState(() {
        _imageUrls = allImages;
        _sevaPoints = points;
        _sevaHashtags = hashtags;
        _selectedImageUrls.addAll(allImages); // Auto-select all found images
        _displayCount = allImages.length > 5 ? allImages.length : 5;
        _isLoading = false;
        _statusMessage = null;
      });

      if (allImages.isEmpty) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("No images found in the Seva links.")),
          );
        }
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        _statusMessage = "Error: $e";
      });
    }
  }

  Future<void> _saveImageToGallery(String sourcePath) async {
    try {
      if (!Platform.isAndroid && !Platform.isIOS) return;

      // 1. Check/Request Permissions
      if (Platform.isAndroid) {
        // For Android 13+ (API 33), we need manageExternalStorage or specific media permissions
        // But for common "Pictures" folder, sometimes standard storage permission is enough or even scoped storage.
        if (await Permission.photos.request().isGranted ||
            await Permission.storage.request().isGranted) {
          // Proceed
        } else {
          debugPrint("Storage permission denied");
          return;
        }
      }

      // 2. Resolve Path
      final fileName = path.basename(sourcePath);
      Directory? galleryDir;

      if (Platform.isAndroid) {
        // Use 'Pictures' folder which is standard for gallery indexing
        galleryDir = Directory('/storage/emulated/0/Pictures/CopyClip');
      } else {
        galleryDir =
            await getApplicationDocumentsDirectory(); // iOS is stricter
      }

      if (true) {
        // galleryDir is never null
        if (!await galleryDir.exists()) {
          await galleryDir.create(recursive: true);
        }
        final newPath = "${galleryDir.path}/$fileName";
        await File(sourcePath).copy(newPath);

        // On Android, we should ideally trigger media scanner.
        // Without MethodChannel, we hope the OS picks it up in 'Pictures' relatively quickly.
        debugPrint("Saved to gallery folder: $newPath");
      }
    } catch (e) {
      debugPrint("Error saving to gallery: $e");
    }
  }

  Future<void> _fetchImages() async {
    final url = _urlController.text.trim();
    if (url.isEmpty) return;

    setState(() {
      _isLoading = true;
      _statusMessage = "Fetching images...";
      _imageUrls = [];
      _selectedImageUrls.clear();
      _displayCount = 5;
    });

    try {
      final images = await _webScraperService.fetchImageUrls(url);
      setState(() {
        _imageUrls = images;
        _isLoading = false;
        _statusMessage = null;
      });
      if (images.isEmpty) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("No images found on this page.")),
          );
        }
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        _statusMessage = "Error: $e";
      });
    }
  }

  void _loadMore() {
    setState(() {
      _displayCount += 10;
    });
  }

  void _toggleSelection(String url) {
    setState(() {
      if (_selectedImageUrls.contains(url)) {
        _selectedImageUrls.remove(url);
      } else {
        _selectedImageUrls.add(url);
      }
    });
  }

  Future<void> _importSelected() async {
    if (_selectedImageUrls.isEmpty) return;

    setState(() {
      _isLoading = true;
      _progress = 0.0;
      _statusMessage = "Starting import...";
    });

    int total = _selectedImageUrls.length;
    int current = 0;
    int successCount = 0;

    final appDir = await getApplicationDocumentsDirectory();
    final socialPostBox = await LazyBoxLoader.getBox<SocialPost>(
      'social_posts_box',
    );
    final settingsBox = await LazyBoxLoader.getBox('settings');
    final List<String> newPostIds = [];

    // Platform detection for Seva mode
    SocialPlatformType platform = SocialPlatformType.generic;
    if (_isSevaMode) {
      final text = _sevaTextController.text;
      if (text.contains('फेसबुक') || text.contains('Facebook')) {
        platform = SocialPlatformType.facebook;
      } else if (text.contains('इंस्टाग्राम') || text.contains('Instagram')) {
        platform = SocialPlatformType.instagram;
      }
    }

    final selectedList = _selectedImageUrls.toList();
    for (int i = 0; i < selectedList.length; i++) {
      final imageUrl = selectedList[i];
      try {
        current++;
        setState(() {
          _statusMessage = "Processing $current / $total...";
          _progress = current / total;
        });

        // 1. Download
        final fileName = "${const Uuid().v4()}.jpg";
        final savePath = "${appDir.path}/$fileName";
        await _fileDownloadService.downloadFile(imageUrl, savePath);

        // Save to device if enabled
        if (_saveToDevice) {
          await _saveImageToGallery(savePath);
        }

        // 2. Content logic
        String finalContent = "Image only";
        if (_isSevaMode) {
          // Map Seva Point to Image
          String point = "";
          if (_sevaPoints.isNotEmpty) {
            point = _sevaPoints[i % _sevaPoints.length];
          }
          finalContent = "$_sevaHashtags\n\n$point".trim();
        } else {
          finalContent = await _ocrService.extractText(savePath);
        }

        // 3. Create SocialPost
        final now = DateTime.now().add(Duration(milliseconds: i));
        final newPost = SocialPost(
          id: const Uuid().v4(),
          content: finalContent.isNotEmpty ? finalContent : "Image only",
          mediaPaths: [savePath],
          platformIndex: platform.index,
          isDraft: true,
          createdAt: now,
          updatedAt: now,
        );

        await socialPostBox.put(newPost.id, newPost);
        newPostIds.add(newPost.id);
        successCount++;
      } catch (e) {
        debugPrint("Error processing $imageUrl: $e");
      }
    }

    // Update global order to show new posts at the top
    if (newPostIds.isNotEmpty) {
      final List<String> currentOrder =
          settingsBox
              .get('social_posts_order', defaultValue: <String>[])
              ?.cast<String>() ??
          [];
      // Prepend new IDs to the order
      final updatedOrder = [...newPostIds.reversed, ...currentOrder];
      await settingsBox.put('social_posts_order', updatedOrder);
    }

    setState(() {
      _isLoading = false;
      _statusMessage = null;
    });

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Imported $successCount / $total posts")),
      );
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GlassScaffold(
      title: "Bulk Import",
      showBackArrow: true,
      body: DynamicBackground(
        child: Column(
          children: [
            // 1. Default URL Input (Always Visible)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _urlController,
                      decoration: InputDecoration(
                        hintText: "Enter Website URL",
                        filled: true,
                        fillColor: theme.colorScheme.surface.withValues(
                          alpha: 0.5,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  FilledButton(
                    onPressed: _isLoading ? null : _fetchImages,
                    child: _isLoading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text("Fetch"),
                  ),
                ],
              ),
            ),

            // 2. Mode Toggle
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      "Seva Special Import Mode",
                      style: theme.textTheme.titleSmall?.copyWith(
                        color: _isSevaMode ? theme.colorScheme.primary : null,
                        fontWeight: _isSevaMode ? FontWeight.bold : null,
                      ),
                    ),
                  ),
                  Switch(
                    value: _isSevaMode,
                    onChanged: (val) => setState(() => _isSevaMode = val),
                  ),
                ],
              ),
            ),

            if (_isSevaMode) ...[
              // Seva Text Input
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextField(
                  controller: _sevaTextController,
                  maxLines: 5,
                  decoration: InputDecoration(
                    hintText: "Paste Seva message here...",
                    filled: true,
                    fillColor: theme.colorScheme.surface.withValues(alpha: 0.5),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    onPressed: _isLoading ? null : _parseSevaText,
                    icon: const Icon(Icons.auto_fix_high),
                    label: const Text("Parse & Sync URLs"),
                  ),
                ),
              ),
            ],

            // Save to Device Toggle
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: CheckboxListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text("Save images to device downloads"),
                value: _saveToDevice,
                onChanged: (val) =>
                    setState(() => _saveToDevice = val ?? false),
                controlAffinity: ListTileControlAffinity.leading,
              ),
            ),

            if (_statusMessage != null)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  children: [
                    Text(_statusMessage!),
                    if (_isLoading && _selectedImageUrls.isNotEmpty)
                      LinearProgressIndicator(value: _progress),
                  ],
                ),
              ),

            // Image Grid
            Expanded(
              child: _imageUrls.isEmpty
                  ? const Center(child: Text("Enter a URL to fetch images"))
                  : GridView.builder(
                      padding: const EdgeInsets.all(8),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            crossAxisSpacing: 8,
                            mainAxisSpacing: 8,
                          ),
                      itemCount: (_imageUrls.length > _displayCount)
                          ? _displayCount + 1
                          : _imageUrls.length,
                      itemBuilder: (context, index) {
                        if (index == _displayCount &&
                            _imageUrls.length > _displayCount) {
                          return _buildLoadMoreButton();
                        }

                        final url = _imageUrls[index];
                        final isSelected = _selectedImageUrls.contains(url);
                        return GestureDetector(
                          onTap: () => _toggleSelection(url),
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                              CachedNetworkImage(
                                imageUrl: url,
                                fit: BoxFit.cover,
                                placeholder: (context, url) => const Center(
                                  child: CircularProgressIndicator(),
                                ),
                                errorWidget: (context, url, error) =>
                                    const Center(child: Icon(Icons.error)),
                              ),
                              if (isSelected)
                                Container(
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.primary.withValues(alpha: 0.4),
                                  child: const Center(
                                    child: Icon(
                                      Icons.check_circle,
                                      color: Colors.white,
                                      size: 32,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        );
                      },
                    ),
            ),

            // Bottom Bar
            if (_imageUrls.isNotEmpty)
              Container(
                padding: const EdgeInsets.all(16),
                color: theme.colorScheme.surface.withValues(alpha: 0.9),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("${_selectedImageUrls.length} selected"),
                    FilledButton.icon(
                      onPressed: _isLoading || _selectedImageUrls.isEmpty
                          ? null
                          : _importSelected,
                      icon: const Icon(Icons.download),
                      label: const Text("Import Selected"),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadMoreButton() {
    return GestureDetector(
      onTap: _loadMore,
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceVariant,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.add_circle_outline),
            SizedBox(height: 4.h),
            Text(
              "Load More",
              style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.bold),
            ),
            Text(
              "(${_imageUrls.length - _displayCount} left)",
              style: TextStyle(fontSize: 10.sp),
            ),
          ],
        ),
      ),
    );
  }
}
