import 'dart:convert';
import 'package:axscend_tech_test/config/constants.dart';
import 'package:http/http.dart' as http;

class ApiClient {
  ApiClient({http.Client? httpClient}) : _client = httpClient ?? http.Client();

  final http.Client _client;

  Future<dynamic> get(String path, {Map<String, String>? query}) async {
    final uri = Uri.parse('$baseUrl$path').replace(queryParameters: query);
    final response = await _client
        .get(uri)
        .timeout(const Duration(seconds: 15));

    if (response.statusCode != 200) {
      throw Exception('Request failed: ${response.statusCode}');
    }
    return jsonDecode(utf8.decode(response.bodyBytes));
  }

  void close() => _client.close();
}
