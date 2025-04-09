import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:path_provider/path_provider.dart';

class FileViewerScreen extends StatefulWidget {
  final String fileType;
  final String fileUrl;

  const FileViewerScreen({
    super.key,
    required this.fileType,
    required this.fileUrl,
  });

  @override
  State<FileViewerScreen> createState() => _FileViewerScreenState();
}

class _FileViewerScreenState extends State<FileViewerScreen> {
  String? localPath;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    if (widget.fileType == 'pdf') {
      _downloadPdf();
    } else {
      loading = false;
    }
  }

  Future<void> _downloadPdf() async {
    try {
      final response = await http.get(Uri.parse(widget.fileUrl));
      final dir = await getTemporaryDirectory();
      final file = File('${dir.path}/temp.pdf');
      await file.writeAsBytes(response.bodyBytes);
      setState(() {
        localPath = file.path;
        loading = false;
      });
    } catch (e) {
      print("Error downloading PDF: $e");
      setState(() {
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text(widget.fileType.toUpperCase())),
      body: widget.fileType == 'pdf'
          ? (localPath != null
          ? PDFView(filePath: localPath!)
          : const Center(child: Text("Failed to load PDF.")))
          : Center(child: Image.network(widget.fileUrl, fit: BoxFit.contain)),
    );
  }
}
