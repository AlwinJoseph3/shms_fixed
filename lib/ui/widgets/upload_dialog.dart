import 'package:flutter/material.dart';
import '../../core/theme.dart';
import 'file_upload_box.dart';

class UploadDialog extends StatelessWidget {
  final Function(List<String>) onFilesSelected;
  final bool showBackButton;

  const UploadDialog({
    Key? key,
    required this.onFilesSelected,
    this.showBackButton = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.85,
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.8,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (showBackButton)
              Align(
                alignment: Alignment.topLeft,
                child: IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            FileUploadBox(
              onFilesSelected: onFilesSelected,
            ),
          ],
        ),
      ),
    );
  }
}
