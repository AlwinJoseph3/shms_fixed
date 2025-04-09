import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:io';

class FileUploadService {
  static const String _baseUrl =
      'http://10.0.2.2:3000/api'; // Android emulator localhost

  static Future<List<String>?> pickFiles(BuildContext context) async {
    try {
      final ImagePicker picker = ImagePicker();
      final List<XFile> result = await picker.pickMultiImage();

      if (result.isNotEmpty) {
        return result.map((file) => file.path).toList();
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error picking files: ${e.toString()}')),
        );
      }
    }
    return null;
  }

  static Future<bool> uploadFiles(List<String> filePaths) async {
    try {
      // Create multipart request
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('$_baseUrl/upload'),
      );

      // Add all files
      for (var filePath in filePaths) {
        var file = await http.MultipartFile.fromPath(
          'files',
          filePath,
        );
        request.files.add(file);
      }

      // Add any additional headers or fields if needed
      request.headers['Content-Type'] = 'multipart/form-data';

      // Send the request
      var response = await request.send();
      var responseData = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        print('Upload successful: $responseData');
        return true;
      } else {
        print('Upload failed with status code: ${response.statusCode}');
        print('Response data: $responseData');
        return false;
      }
    } catch (e) {
      print('Error uploading files: $e');
      return false;
    }
  }
}
