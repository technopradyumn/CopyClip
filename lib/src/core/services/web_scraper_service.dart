import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:html/parser.dart' as parser;
import 'package:html/dom.dart' as dom;

class WebScraperService {
  final Dio _dio = Dio();
  final CookieJar _cookieJar = CookieJar();

  // Data attributes that commonly hold the full-size image URL
  static const List<String> _highResAttrs = [
    'data-original',
    'data-highres',
    'data-full-url',
    'data-zoom-image',
    'data-hi-res',
    'data-full-src',
    'data-large-file',
    'data-src-large',
    'data-big',
    'data-image',
    'data-zoom',
    'data-original-src',
    'data-src',
    'data-lazy-src',
    'data-full',
    'data-actual-src',
  ];

  // Extensions that indicate a direct image file link
  static final RegExp _imageExtRe = RegExp(
    r'\.(jpe?g|png|webp|gif|bmp|tiff)(\?.*)?$',
    caseSensitive: false,
  );

  // Patterns that indicate junk (icons, spacers, etc.)
  static final RegExp _junkRe = RegExp(
    r'(icon|placeholder|avatar|pixel|1x1|blank|spacer|logo|sprite)',
    caseSensitive: false,
  );

  WebScraperService() {
    _dio.interceptors.add(CookieManager(_cookieJar));
    _dio.options.headers = {
      'User-Agent':
          'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 '
          '(KHTML, like Gecko) Chrome/122.0.0.0 Safari/537.36',
      'Accept':
          'text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8',
      'Accept-Language': 'en-US,en;q=0.9',
    };
    _dio.options.connectTimeout = const Duration(seconds: 15);
    _dio.options.receiveTimeout = const Duration(seconds: 20);
  }

  // ── Core public method ────────────────────────────────────────────────────

  /// Fetches a page and returns a deduplicated list of full-size image URLs.
  ///
  /// Priority for each <img> element:
  ///   1. Parent <a href> — if it ends with an image extension (the original!)
  ///   2. data-* high-resolution attributes
  ///   3. Highest-resolution URL from srcset
  ///   4. CDN-stripped version of src (removes -150x150, _small, etc.)
  ///   5. src as-is (last resort)
  Future<List<String>> fetchImageUrls(String url) async {
    try {
      final response = await _dio.get<String>(url);
      if (response.statusCode != 200 || response.data == null) {
        throw Exception('Failed to load page: ${response.statusCode}');
      }

      final document = parser.parse(response.data!);
      final baseUri = Uri.parse(url);

      final seen = <String>{};
      final results = <String>[];

      void add(String? raw) {
        if (raw == null || raw.isEmpty || raw.startsWith('data:')) return;
        try {
          final abs = _resolveUrl(raw, baseUri);
          if (abs == null) return;
          final cleaned = _stripResize(abs);
          if (!seen.contains(cleaned) && !_junkRe.hasMatch(cleaned)) {
            seen.add(cleaned);
            results.add(cleaned);
          }
        } catch (_) {}
      }

      // ── <picture> elements ───────────────────────────────────────────────
      for (final pic in document.getElementsByTagName('picture')) {
        for (final source in pic.getElementsByTagName('source')) {
          final ss =
              source.attributes['srcset'] ??
              source.attributes['data-srcset'] ??
              '';
          if (ss.isNotEmpty) add(_bestFromSrcset(ss));
        }
        final img = pic.getElementsByTagName('img').firstOrNull;
        if (img != null) _addFromImgTag(img, baseUri, add);
      }

      // ── Standalone <img> elements ────────────────────────────────────────
      for (final img in document.getElementsByTagName('img')) {
        if (img.parent?.localName == 'picture') continue;
        _addFromImgTag(img, baseUri, add);
      }

      // ── Standalone <a href="...image..."> links ──────────────────────────
      for (final a in document.getElementsByTagName('a')) {
        if (a.getElementsByTagName('img').isNotEmpty) continue;
        final href = a.attributes['href'] ?? '';
        if (href.isNotEmpty && _imageExtRe.hasMatch(href)) {
          add(href);
        }
      }

      return results;
    } catch (e) {
      throw Exception('Error fetching images: $e');
    }
  }

  // ── Private helpers ───────────────────────────────────────────────────────

  void _addFromImgTag(
    dom.Element img,
    Uri baseUri,
    void Function(String?) add,
  ) {
    // 1. Parent <a href> — HIGHEST PRIORITY (already the original filename)
    dom.Element? current = img.parent;
    while (current != null) {
      if (current.localName == 'a') {
        final href = current.attributes['href'] ?? '';
        if (href.isNotEmpty && _imageExtRe.hasMatch(href)) {
          // This is already the full-size original — add without stripping
          try {
            final abs = _resolveUrl(href, baseUri);
            if (abs != null && !_junkRe.hasMatch(abs)) {
              add(abs); // Note: added first, before the others
            }
          } catch (_) {}
        }
        break;
      }
      current = current.parent;
    }

    // 2. data-* high-res attributes
    for (final attr in _highResAttrs) {
      final val = img.attributes[attr] ?? '';
      if (val.isNotEmpty && !val.startsWith('data:')) {
        add(val);
      }
    }

    // 3. Best from srcset
    final srcset =
        img.attributes['srcset'] ?? img.attributes['data-srcset'] ?? '';
    if (srcset.isNotEmpty) {
      add(_bestFromSrcset(srcset));
    }

    // 4 & 5. src (stripped, then as-is)
    final src = img.attributes['src'] ?? '';
    if (src.isNotEmpty && !src.startsWith('data:')) {
      add(src); // _stripResize is called inside add()
    }
  }

  String? _resolveUrl(String raw, Uri base) {
    raw = raw.trim();
    if (raw.isEmpty) return null;
    if (raw.startsWith('//')) raw = 'https:$raw';
    try {
      final resolved = base.resolve(raw).toString();
      if (!resolved.startsWith('http')) return null;
      return resolved;
    } catch (_) {
      return null;
    }
  }

  /// Pick the URL with the highest pixel width/density from a srcset string.
  String? _bestFromSrcset(String srcset) {
    if (srcset.isEmpty) return null;
    String bestUrl = '';
    int bestScore = -1;
    for (final part in srcset.split(',')) {
      final tokens = part.trim().split(RegExp(r'\s+'));
      if (tokens.isEmpty) continue;
      final url = tokens[0];
      int score = 0;
      if (tokens.length > 1) {
        final m = RegExp(r'^(\d+)([wx])$').firstMatch(tokens[1]);
        if (m != null) {
          score = int.parse(m.group(1)!) * (m.group(2) == 'x' ? 1000 : 1);
        }
      }
      if (score > bestScore) {
        bestScore = score;
        bestUrl = url;
      }
    }
    return bestUrl.isNotEmpty ? bestUrl : null;
  }

  /// Remove CDN/CMS resize parameters to get the closest-to-original URL.
  /// Handles WordPress, Shopify, DigitalOcean Spaces, Cloudinary, imgix,
  /// Wix, Squarespace, Pinterest, Twitter/X, Reddit, and more.
  String _stripResize(String url) {
    var u = url;

    // Twitter/X → :orig
    if (u.contains('twimg.com')) {
      return u.contains('?')
          ? u.replaceAll(RegExp(r'name=[^&]+'), 'name=orig')
          : u.replaceAll(RegExp(r':\w+$'), ':orig');
    }

    // Pinterest → /originals/
    if (u.contains('pinimg.com')) {
      return u.replaceAll(RegExp(r'/\d+x/'), '/originals/');
    }

    // Reddit preview → actual image host
    if (u.contains('preview.redd.it')) {
      return u.replaceAll('preview.redd.it', 'i.redd.it').split('?').first;
    }

    // Wikipedia thumb
    if (u.contains('upload.wikimedia.org') && u.contains('/thumb/')) {
      final parts = u.split('/');
      if (RegExp(r'^\d+px-').hasMatch(parts.last)) {
        u = u.replaceAll('/thumb/', '/');
        final idx = u.lastIndexOf('/');
        if (idx != -1) u = u.substring(0, idx);
      }
      return u;
    }

    // Shopify
    if (u.contains('cdn.shopify.com')) {
      u = u.replaceAll(
        RegExp(
          r'_(small|medium|large|grande|master|compact|pico|icon|thumb|\d+x\d+)'
          r'(?=\.(jpe?g|png|webp|gif))',
          caseSensitive: false,
        ),
        '',
      );
      return u.split('?v=').first;
    }

    // Wix
    if (u.contains('static.wixstatic.com')) {
      return u.replaceAll(RegExp(r'/v1/fill/[^/]+/'), '/');
    }

    // Squarespace / imgix / Fastly — strip query
    if (u.contains('squarespace.com') ||
        u.contains('imgix.net') ||
        u.contains('.fastly.')) {
      return u.split('?').first;
    }

    // Unsplash
    if (u.contains('images.unsplash.com')) {
      return u.split('?').first;
    }

    // Google user content
    if (u.contains('googleusercontent.com')) {
      return u.replaceAll(RegExp(r'=[swh]\d+(-[swh]\d+)*$'), '=s0');
    }

    // Cloudinary — strip transform segment before the filename
    if (u.contains('cloudinary.com')) {
      return u.replaceAll(RegExp(r'(/upload/)(?:[^/]+/)+'), r'$1');
    }

    // DigitalOcean Spaces / WordPress:
    //   Remove  -WIDTHxHEIGHT  before the extension
    //   e.g. image-12-150x150.jpeg  →  image-12.jpeg
    u = u.replaceAll(
      RegExp(r'-\d+x\d+(?=\.(jpe?g|png|webp|gif|bmp))', caseSensitive: false),
      '',
    );

    // Generic thumbnail name suffixes before extension
    u = u.replaceAll(
      RegExp(
        r'[-_](thumb|thumbnail|small|medium|large|sm|md|lg|xs|'
        r'preview|square|tile|crop|resized|scaled|compact|mini|tiny)'
        r'(?=\.(jpe?g|png|webp|gif|bmp))',
        caseSensitive: false,
      ),
      '',
    );

    // Generic resize query params → strip entire query string
    final lower = u.toLowerCase();
    const resizeParams = [
      'w=',
      'width=',
      'h=',
      'height=',
      'fit=',
      'crop=',
      'size=',
      'resize=',
      'maxwidth=',
      'maxheight=',
    ];
    if (resizeParams.any(lower.contains)) {
      u = u.split('?').first;
    }

    return u;
  }
}
