import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ApiService {
  static const String baseUrl = 'http://192.168.0.124:5000'; // your Flask server IP

  static String? get _userId => Supabase.instance.client.auth.currentUser?.id;

  /// Uploads image (X-ray or MRI) and returns result path or null
  static Future<Map<String, dynamic>?> uploadImage(File file) async {
    final uri = Uri.parse('$baseUrl/upload');
    final request = http.MultipartRequest('POST', uri);

    request.headers['X-User-ID'] = _userId ?? '';

    final filename = basename(file.path);
    request.files.add(await http.MultipartFile.fromPath('file', file.path, filename: filename));

    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode == 200) {
      return jsonDecode(response.body)['result'];
    } else {
      print('Error uploading image: ${response.statusCode}');
      return null;
    }
  }

  /// Uploads a general file (PDF/image), returns true on success
  static Future<bool> uploadFile(File file) async {
    final uri = Uri.parse('$baseUrl/upload');
    final request = http.MultipartRequest('POST', uri);

    request.headers['X-User-ID'] = _userId ?? '';

    request.files.add(await http.MultipartFile.fromPath('file', file.path));

    final response = await request.send();
    return response.statusCode == 200;
  }

  /// Fetches output files that belong to the logged-in user
  static Future<List<Map<String, dynamic>>> fetchAnalyzedOutputs() async {
    final userId = Supabase.instance.client.auth.currentUser?.id;

    final response = await http.get(
      Uri.parse('$baseUrl/outputs'),
      headers: {
        'X-User-ID': userId ?? '',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> files = json.decode(response.body);
      return files.map((f) => f as Map<String, dynamic>).toList();
    } else {
      print('Error fetching outputs: ${response.body}');
      throw Exception('Failed to fetch output files');
    }
  }

}
