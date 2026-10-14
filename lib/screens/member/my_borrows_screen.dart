import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../models/borrow_record.dart';
import '../../providers/auth_provider.dart';
import '../../providers/library_data_provider.dart';
import '../../widgets/accessibility_toolbar.dart';
import '../../widgets/status_chip.dart';

class MyBorrowsScreen extends StatelessWidget {
  const MyBorrowsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    final data = Provider.of<LibraryDataProvider>(context);
    final myBorrows = data.getMemberBorrows(auth.currentUser?.id ?? '');

    return Scaffold(
      appBar: const AccessibilityToolbar(title: 'My Borrowed Books'),
      body: myBorrows.isEmpty
          ? const Center(
              child: Text('You have not borrowed any books yet.', style: TextStyle(color: Colors.grey, fontSize: 16)),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: myBorrows.length,
              itemBuilder: (context, index) {
                final record = myBorrows[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 10),
                  child: Padding(
                    padding: const EdgeInsets.all(14.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                record.bookTitle,
                                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                            ),
                            if (record.status == BorrowStatus.requested) StatusChip.requested(),
                            if (record.status == BorrowStatus.issued) StatusChip.issued(),
                            if (record.status == BorrowStatus.returned) StatusChip.returned(),
                            if (record.isOverdue) StatusChip.overdue(),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Icon(Icons.calendar_today, size: 14, color: Colors.grey),
                            const SizedBox(width: 6),
                            Text(
                              'Issued: ${DateFormat('dd MMM yyyy').format(record.issueDate)}',
                              style: const TextStyle(fontSize: 12, color: Colors.grey),
                            ),
                            const Spacer(),
                            Text(
                              'Due: ${DateFormat('dd MMM yyyy').format(record.dueDate)}',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: record.isOverdue ? Colors.red : Colors.green,
                              ),
                            ),
                          ],
                        ),
                        if (record.isOverdue) ...[
                          const SizedBox(height: 8),
                          Text(
                            'Notice: Book is ${record.overdueDays} days overdue! Pending Fine: ৳${(record.overdueDays * data.fineRatePerDay).toInt()}',
                            style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 12),
                          ),
                        ],
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
