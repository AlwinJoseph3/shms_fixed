import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import '../../services/api_service.dart';


class FileUploadBox extends StatefulWidget {
  final Function(List<String>) onFilesSelected;
  const FileUploadBox({super.key, required this.onFilesSelected});

  @override
  State<FileUploadBox> createState() => _FileUploadBoxState();
}

class _FileUploadBoxState extends State<FileUploadBox> {
  bool isLoading = false;

  void _handleFileUpload() async {
    final result = await FilePicker.platform.pickFiles(
      allowMultiple: false,
      type: FileType.custom,
      allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png'],
    );

    if (result != null && result.files.isNotEmpty) {
      setState(() => isLoading = true);

      final file = File(result.files.first.path!);
      final success = await ApiService.uploadFile(file);

      setState(() => isLoading = false);

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("File Processed. Tap on Refresh.")),
        );
        widget.onFilesSelected([file.path]);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Processing failed")));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        GestureDetector(
          onTap: _handleFileUpload,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 30),
            margin: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey[300]!),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.cloud_upload, size: 40, color: Colors.grey),
                  SizedBox(height: 10),
                  Text(
                    'Tap to select and upload a file',
                    style: TextStyle(fontSize: 16, color: Colors.black54),
                  ),
                ],
              ),
            ),
          ),
        ),
        if (isLoading)
          const Positioned.fill(
            child: ColoredBox(
              color: Colors.black26,
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ),
          ),
      ],
    );
  }
}


