import 'package:flutter/material.dart';

class AnalysisCard extends StatelessWidget {
  final String reportName;
  final String analysisDate;

  const AnalysisCard(
      {super.key, required this.reportName, required this.analysisDate});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 180,
      margin: const EdgeInsets.only(left: 20),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.grey.shade300,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.analytics, size: 30, color: Colors.black54),
          const SizedBox(height: 10),
          Text(
            reportName,
            style: const TextStyle(
              color: Colors.black87,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            analysisDate,
            style: const TextStyle(color: Colors.black54, fontSize: 14),
          ),
        ],
      ),
    );
  }
}
