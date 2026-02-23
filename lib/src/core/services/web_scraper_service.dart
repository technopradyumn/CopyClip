import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:html/parser.dart' as parser;

class WebScraperService {
  final Dio _dio = Dio();
  final CookieJar _cookieJar = CookieJar();

  WebScraperService() {
    _dio.interceptors.add(CookieManager(_cookieJar));
    _dio.options.headers = {
      'User-Agent':
          'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36',
    };
  }

  Future<List<String>> fetchImageUrls(String url) async {
    try {
      final response = await _dio.get(url);

      if (response.statusCode == 200) {
        final document = parser.parse(response.data);
        final List<String> imageUrls = [];

        var elements = document.getElementsByTagName('img');

        for (var element in elements) {
          String? src = element.attributes['src'];
          if (src != null && src.isNotEmpty) {
            // Handle relative URLs
            final uri = Uri.parse(url);
            String resolvedSrc = uri.resolve(src).toString();

            if (!imageUrls.contains(resolvedSrc)) {
              imageUrls.add(resolvedSrc);
            }
          }
        }
        return imageUrls;
      } else {
        throw Exception('Failed to load page: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching images: $e');
    }
  }
}
