import 'package:flutter/material.dart';
import '../../widgets/accessibility_toolbar.dart';

class AdminReportsScreen extends StatelessWidget {
  const AdminReportsScreen({super.key});

  void _simulateDownload(BuildContext context, String format) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Exporting system report as $format file...'),
        backgroundColor: Colors.teal,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AccessibilityToolbar(title: 'System Reports Generation'),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'Export Library Data (FR12)',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 6),
          const Text(
            'Generate downloadable reports in PDF or Excel formats for administrative auditing.',
            style: TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 20),

          _ReportTypeCard(
            title: 'Book Inventory & Catalog Report',
            description: 'Comprehensive list of all registered books, categories, authors, and available copy counts.',
            icon: Icons.menu_book,
            color: Colors.deepPurple,
            onPdf: () => _simulateDownload(context, 'PDF'),
            onExcel: () => _simulateDownload(context, 'Excel'),
          ),
          const SizedBox(height: 12),

          _ReportTypeCard(
            title: 'Active & Historical Borrowing Audit',
            description: 'Log of issued books, due dates, return dates, and member transaction history.',
            icon: Icons.history,
            color: Colors.blue,
            onPdf: () => _simulateDownload(context, 'PDF'),
            onExcel: () => _simulateDownload(context, 'Excel'),
          ),
          const SizedBox(height: 12),

          _ReportTypeCard(
            title: 'Overdue Fines & Payments Log',
            description: 'Summary of outstanding fines, collected payments, and waived dues.',
            icon: Icons.monetization_on,
            color: Colors.amber.shade800,
            onPdf: () => _simulateDownload(context, 'PDF'),
            onExcel: () => _simulateDownload(context, 'Excel'),
          ),
        ],
      ),
    );
  }
}

class _ReportTypeCard extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  final Color color;
  final VoidCallback onPdf;
  final VoidCallback onExcel;

  const _ReportTypeCard({
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
    required this.onPdf,
    required this.onExcel,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: color, size: 28),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(description, style: const TextStyle(fontSize: 13, color: Colors.grey)),
            const SizedBox(height: 14),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                OutlinedButton.icon(
                  icon: const Icon(Icons.picture_as_pdf, color: Colors.red, size: 18),
                  label: const Text('PDF', style: TextStyle(color: Colors.red)),
                  onPressed: onPdf,
                ),
                const SizedBox(width: 10),
                ElevatedButton.icon(
                  icon: const Icon(Icons.table_chart, size: 18),
                  label: const Text('Excel'),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.green, foregroundColor: Colors.white),
                  onPressed: onExcel,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
