import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../models/borrow_record.dart';
import '../../providers/library_data_provider.dart';
import '../../widgets/accessibility_toolbar.dart';
import '../../widgets/status_chip.dart';

class CirculationScreen extends StatelessWidget {
  const CirculationScreen({super.key});

  void _showIssueBookDialog(BuildContext context) {
    final data = Provider.of<LibraryDataProvider>(context, listen: false);

    if (data.activeMembers == 0 || data.availableBooks == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Need active members and available books to issue.')),
      );
      return;
    }

    String selectedMemberId = data.members.firstWhere((m) => m.isActive).id;
    String selectedBookId = data.books.firstWhere((b) => b.isAvailable).id;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('Issue Book to Member'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Member Selector
              DropdownButtonFormField<String>(
                initialValue: selectedMemberId,
                decoration: const InputDecoration(labelText: 'Select Member', prefixIcon: Icon(Icons.person)),
                items: data.members.where((m) => m.isActive).map((m) {
                  return DropdownMenuItem(
                    value: m.id,
                    child: Text('${m.name} (${m.studentId})'),
                  );
                }).toList(),
                onChanged: (val) => setDialogState(() => selectedMemberId = val!),
              ),
              const SizedBox(height: 14),

              // Book Selector
              DropdownButtonFormField<String>(
                initialValue: selectedBookId,
                decoration: const InputDecoration(labelText: 'Select Available Book', prefixIcon: Icon(Icons.book)),
                items: data.books.where((b) => b.isAvailable).map((b) {
                  return DropdownMenuItem(
                    value: b.id,
                    child: Text('${b.title} (${b.availableCopies} available)'),
                  );
                }).toList(),
                onChanged: (val) => setDialogState(() => selectedBookId = val!),
              ),
              const SizedBox(height: 14),

              const Text(
                'Default Borrow Duration: 14 Days',
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
            ElevatedButton(
              onPressed: () {
                final member = data.members.firstWhere((m) => m.id == selectedMemberId);
                final success = data.requestBorrow(selectedBookId, member);

                if (success) {
                  // Find created record and issue
                  final created = data.borrowRecords.last;
                  data.issueBook(created.id);

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Book issued successfully!'), backgroundColor: Colors.green),
                  );
                  Navigator.pop(ctx);
                }
              },
              child: const Text('Issue Book'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final data = Provider.of<LibraryDataProvider>(context);
    final activeBorrows = data.borrowRecords
        .where((b) => b.status == BorrowStatus.issued || b.status == BorrowStatus.overdue || b.status == BorrowStatus.requested)
        .toList();

    return Scaffold(
      appBar: const AccessibilityToolbar(title: 'Circulation (Issue & Return)'),
      floatingActionButton: FloatingActionButton.extended(
        icon: const Icon(Icons.outbox),
        label: const Text('Issue Book'),
        onPressed: () => _showIssueBookDialog(context),
      ),
      body: activeBorrows.isEmpty
          ? const Center(
              child: Text('No active book borrows currently.', style: TextStyle(color: Colors.grey, fontSize: 16)),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: activeBorrows.length,
              itemBuilder: (context, index) {
                final record = activeBorrows[index];
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
                            if (record.isOverdue) StatusChip.overdue(),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text('Member: ${record.memberName}', style: const TextStyle(fontWeight: FontWeight.w500)),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(Icons.calendar_today, size: 14, color: Colors.grey.shade600),
                            const SizedBox(width: 4),
                            Text(
                              'Issued: ${DateFormat('dd MMM yyyy').format(record.issueDate)}  |  Due: ${DateFormat('dd MMM yyyy').format(record.dueDate)}',
                              style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                            ),
                          ],
                        ),
                        if (record.isOverdue) ...[
                          const SizedBox(height: 6),
                          Text(
                            'OVERDUE by ${record.overdueDays} days (Pending Fine: ৳${(record.overdueDays * data.fineRatePerDay).toInt()})',
                            style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 13),
                          ),
                        ],
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            if (record.status == BorrowStatus.requested)
                              ElevatedButton.icon(
                                icon: const Icon(Icons.check, size: 16),
                                label: const Text('Approve & Issue'),
                                style: ElevatedButton.styleFrom(backgroundColor: Colors.purple, foregroundColor: Colors.white),
                                onPressed: () {
                                  data.issueBook(record.id);
                                },
                              ),
                            if (record.status == BorrowStatus.issued || record.status == BorrowStatus.overdue)
                              ElevatedButton.icon(
                                icon: const Icon(Icons.assignment_turned_in, size: 16),
                                label: const Text('Process Return'),
                                style: ElevatedButton.styleFrom(backgroundColor: Colors.teal, foregroundColor: Colors.white),
                                onPressed: () {
                                  final success = data.processReturn(record.id);
                                  if (success) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text('Book return processed!'), backgroundColor: Colors.green),
                                    );
                                  }
                                },
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
