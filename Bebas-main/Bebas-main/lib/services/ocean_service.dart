
import 'dart:convert';
import 'package:http/http.dart' as http;

class OceanArticle {
  final String title;
  final String body;
  OceanArticle({required this.title, required this.body});

  factory OceanArticle.fromJson(Map<String, dynamic> j) =>
      OceanArticle(title: j['title'] ?? 'Untitled', body: j['body'] ?? '');
}

class OceanService {
  static Future<List<OceanArticle>> fetchArticles() async {
    final url = Uri.parse('https://jsonplaceholder.typicode.com/posts?_limit=8');
    final resp = await http.get(url);
    if (resp.statusCode != 200) throw Exception('Failed to fetch articles');
    final data = jsonDecode(resp.body) as List;
    return data.map((e) => OceanArticle.fromJson(e)).toList();
  }
}
