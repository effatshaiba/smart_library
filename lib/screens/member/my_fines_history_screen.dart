import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../models/fine_record.dart';
import '../../providers/auth_provider.dart';
import '../../providers/library_data_provider.dart';
import '../../widgets/accessibility_toolbar.dart';
import '../../widgets/status_chip.dart';

class MyFinesHistoryScreen extends StatelessWidget {
  const MyFinesHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    final data = Provider.of<LibraryDataProvider>(context);
    final myFines = data.getMemberFines(auth.currentUser?.id ?? '');
    final myHistory = data.getMemberBorrows(auth.currentUser?.id ?? '');

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: const AccessibilityToolbar(title: 'Fines & Borrow History'),
        body: Column(
          children: [
            Container(
              color: Theme.of(context).cardColor,
              child: const TabBar(
                tabs: [
                  Tab(icon: Icon(Icons.monetization_on), text: 'My Fines'),
                  Tab(icon: Icon(Icons.history), text: 'Borrow History'),
                ],
              ),
            ),
            Expanded(
              child: TabBarView(
                children: [
                  // Tab 1: My Fines
                  myFines.isEmpty
                      ? const Center(child: Text('No pending or historical fines!', style: TextStyle(color: Colors.green, fontSize: 16)))
                      : ListView.builder(
                          padding: const EdgeInsets.all(12),
                          itemCount: myFines.length,
                          itemBuilder: (context, index) {
                            final fine = myFines[index];
                            return Card(
                              margin: const EdgeInsets.only(bottom: 10),
                              child: ListTile(
                                title: Text(fine.bookTitle, style: const TextStyle(fontWeight: FontWeight.bold)),
                                subtitle: Text('Overdue: ${fine.overdueDays} days'),
                                trailing: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text('৳${fine.amount.toStringAsFixed(0)}', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.deepOrange)),
                                    const SizedBox(height: 4),
                                    if (fine.status == FineStatus.pending) StatusChip.pending(),
                                    if (fine.status == FineStatus.collected) StatusChip.collected(),
                                    if (fine.status == FineStatus.waived) StatusChip.waived(),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),

                  // Tab 2: Borrow History
                  myHistory.isEmpty
                      ? const Center(child: Text('No borrow history recorded yet.', style: TextStyle(color: Colors.grey, fontSize: 16)))
                      : ListView.builder(
                          padding: const EdgeInsets.all(12),
                          itemCount: myHistory.length,
                          itemBuilder: (context, index) {
                            final record = myHistory[index];
                            return Card(
                              margin: const EdgeInsets.only(bottom: 10),
                              child: ListTile(
                                leading: const Icon(Icons.book, color: Colors.teal),
                                title: Text(record.bookTitle, style: const TextStyle(fontWeight: FontWeight.bold)),
                                subtitle: Text('Issued: ${DateFormat('dd MMM yyyy').format(record.issueDate)}'),
                                trailing: record.returnDate != null ? StatusChip.returned() : StatusChip.issued(),
                              ),
                            );
                          },
                        ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
