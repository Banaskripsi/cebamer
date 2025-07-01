import 'dart:convert';
import 'package:http/http.dart' as http;

class YoutubeHelper {
  static Future<Map<String, String>> fetchVideoInfo(String youtubeUrl) async {
    final uri = Uri.parse('https://www.youtube.com/oembed?url=$youtubeUrl&format=json');
    try {
      final response = await http.get(uri);
      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        return {
          'title': json['title'] ?? 'Tanpa Judul',
          'author': json['author_name'] ?? 'Tidak diketahui',
        };
      } else {
        return {'title': 'Tidak bisa memuat judul', 'author': ''};
      }
    } catch (e) {
      return {'title': 'Error', 'author': ''};
    }
  }
}