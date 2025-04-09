import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  static const String baseUrl =
      "https://13.201.77.65"; // Replace with your EC2 IP

  /// Registers a new user
  static Future<bool> registerUser(
    String name,
    String email,
    String password,
    String dob,
    String address,
  ) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/auth/register"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "name": name,
          "email": email,
          "password": password,
          "dob": dob,
          "address": address,
        }),
      );

      return response.statusCode == 201;
    } catch (e) {
      print("Registration error: $e");
      return false;
    }
  }

  /// Logs in a user and saves JWT token
  static Future<bool> loginUser(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/auth/login"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"email": email, "password": password}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        String token = data["access_token"];

        // Store JWT token for future requests
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString("jwt_token", token);

        return true;
      } else {
        return false;
      }
    } catch (e) {
      print("Login error: $e");
      return false;
    }
  }

  /// Fetches stored JWT token for API requests
  static Future<String?> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString("jwt_token");
  }

  /// Uploads a file with authentication
  static Future<bool> uploadFile(File file) async {
    try {
      String? token = await getToken();
      if (token == null) return false;

      var request = http.MultipartRequest('POST', Uri.parse("$baseUrl/upload"));
      request.headers['Authorization'] = 'Bearer $token';
      request.files.add(await http.MultipartFile.fromPath('file', file.path));

      var response = await request.send();
      return response.statusCode == 200;
    } catch (e) {
      print("File upload error: $e");
      return false;
    }
  }

  /// Downloads a file from EC2 (AWS S3 pre-signed link)
  static Future<bool> downloadFile(String fileUrl) async {
    try {
      final response = await http.get(Uri.parse(fileUrl));

      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print("Error downloading file: $e");
      return false;
    }
  }

  /// Fetches user files with authentication
  static Future<List<String>> fetchFiles() async {
    try {
      String? token = await getToken();
      if (token == null) return [];

      final response = await http.get(
        Uri.parse("$baseUrl/files"),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        List<dynamic> files = jsonDecode(response.body);
        return files.map((file) => file.toString()).toList();
      } else {
        throw Exception("Failed to load files");
      }
    } catch (e) {
      print("Error fetching files: $e");
      return [];
    }
  }
}
