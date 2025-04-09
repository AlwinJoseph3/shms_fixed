import 'package:flutter/material.dart';

class ReportCard extends StatelessWidget {
  final String reportName;
  final String reportDate;

  const ReportCard(
      {super.key, required this.reportName, required this.reportDate});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 180,
      margin: const EdgeInsets.only(left: 20),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.blue.shade600,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.insert_drive_file, size: 30, color: Colors.white),
          const SizedBox(height: 10),
          Text(
            reportName,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            reportDate,
            style: const TextStyle(color: Colors.white70, fontSize: 14),
          ),
          const SizedBox(height: 10),
          const Text(
            "View Summary ➜",
            style: TextStyle(color: Colors.redAccent, fontSize: 14),
          ),
        ],
      ),
    );
  }
}
