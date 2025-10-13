import 'dart:convert';
import 'package:http/http.dart' as http;

enum HttpMethod { GET, POST, PUT, DELETE }

class ApiService {
  static const String baseUrl = "https://68e4b51f8e116898997c83bf.mockapi.io/";

  /// Common request handler
  static Future<dynamic> request({
    required String endpoint,
    HttpMethod method = HttpMethod.GET,
    Map<String, String>? headers,
    Map<String, dynamic>? body,
    Map<String, dynamic>? queryParams,
  }) async {
    try {
      // Build URL with query parameters if any
      Uri url = Uri.parse(
        '$baseUrl$endpoint',
      ).replace(queryParameters: queryParams);

      // Default headers
      headers ??= {'Content-Type': 'application/json'};

      // Choose method dynamically
      late http.Response response;
      switch (method) {
        case HttpMethod.POST:
          response = await http.post(
            url,
            headers: headers,
            body: jsonEncode(body),
          );
          break;
        case HttpMethod.PUT:
          response = await http.put(
            url,
            headers: headers,
            body: jsonEncode(body),
          );
          break;
        case HttpMethod.DELETE:
          response = await http.delete(url, headers: headers);
          break;
        case HttpMethod.GET:
          response = await http.get(url, headers: headers);
          break;
      }

      // Check for success
      if (response.statusCode >= 200 && response.statusCode < 300) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Error ${response.statusCode}: ${response.body}');
      }
    } catch (e) {
      print('HTTP Error: $e');
      rethrow;
    }
  }
}
