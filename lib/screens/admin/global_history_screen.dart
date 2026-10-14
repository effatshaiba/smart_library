import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../providers/library_data_provider.dart';
import '../../widgets/accessibility_toolbar.dart';
import '../../widgets/status_chip.dart';

class GlobalHistoryScreen extends StatelessWidget {
  const GlobalHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final data = Provider.of<LibraryDataProvider>(context);

    return Scaffold(
      appBar: const AccessibilityToolbar(title: 'Global Borrow History'),
      body: data.borrowRecords.isEmpty
          ? const Center(
              child: Text('No borrowing history records found.', style: TextStyle(color: Colors.grey, fontSize: 16)),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: data.borrowRecords.length,
              itemBuilder: (context, index) {
                final record = data.borrowRecords[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 10),
                  child: ListTile(
                    leading: const CircleAvatar(child: Icon(Icons.history)),
                    title: Text(record.bookTitle, style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Member: ${record.memberName}'),
                        Text(
                          'Issued: ${DateFormat('dd MMM yyyy').format(record.issueDate)}  |  Returned: ${record.returnDate != null ? DateFormat('dd MMM yyyy').format(record.returnDate!) : "Active"}',
                          style: const TextStyle(fontSize: 11),
                        ),
                      ],
                    ),
                    trailing: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (record.returnDate != null) StatusChip.returned(),
                        if (record.returnDate == null && record.isOverdue) StatusChip.overdue(),
                        if (record.returnDate == null && !record.isOverdue) StatusChip.issued(),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
