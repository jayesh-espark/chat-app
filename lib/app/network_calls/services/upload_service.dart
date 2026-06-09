import 'dart:convert';
import 'dart:io';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import '../../core/config/app_config.dart';
import '../../core/storage/local_storage.dart';

class UploadService {
  UploadService._();
  static final UploadService _instance = UploadService._();
  factory UploadService() => _instance;

  /// Uploads the given image file as multipart/form-data to POST /api/v1/upload.
  /// Expects authorization Bearer token and returns the Cloudinary secure_url on success.
  Future<String?> uploadImage(File imageFile) async {
    try {
      final token = await LocalStorageApp().getAuthToken();
      if (token.isEmpty) {
        log("Upload error: Auth token is empty");
        return null;
      }

      final url = Uri.parse('${AppConfig.apiBaseUrl}/upload');
      log("Uploading image to: $url");

      final request = http.MultipartRequest('POST', url);
      request.headers['Authorization'] = 'Bearer $token';

      // Parse the extension to supply the correct MIME contentType to Multer
      final fileExtension = imageFile.path.split('.').last.toLowerCase();
      String mimeType = 'image/jpeg'; // Default fallback
      if (fileExtension == 'png') {
        mimeType = 'image/png';
      } else if (fileExtension == 'gif') {
        mimeType = 'image/gif';
      } else if (fileExtension == 'webp') {
        mimeType = 'image/webp';
      }

      final multipartFile = await http.MultipartFile.fromPath(
        'image',
        imageFile.path,
        contentType: MediaType.parse(mimeType),
      );

      request.files.add(multipartFile);

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      log("Upload response status: ${response.statusCode}");
      log("Upload response body: ${response.body}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        final body = jsonDecode(response.body) as Map<String, dynamic>;
        if (body['status'] == 'success') {
          return body['data']['secure_url'] as String?;
        }
      }
      return null;
    } catch (e) {
      log("Upload image exception: $e");
      return null;
    }
  }
}
