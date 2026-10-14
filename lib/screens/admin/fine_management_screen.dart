import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/fine_record.dart';
import '../../providers/library_data_provider.dart';
import '../../widgets/accessibility_toolbar.dart';
import '../../widgets/status_chip.dart';

class FineManagementScreen extends StatelessWidget {
  const FineManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final data = Provider.of<LibraryDataProvider>(context);

    return Scaffold(
      appBar: const AccessibilityToolbar(title: 'Fine Management'),
      body: Column(
        children: [
          // Total Summary Header
          Container(
            padding: const EdgeInsets.all(16),
            margin: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Total Outstanding Fines', style: TextStyle(fontSize: 13, color: Colors.grey)),
                    Text(
                      '৳${data.totalPendingFines.toStringAsFixed(2)}',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.onPrimaryContainer,
                      ),
                    ),
                  ],
                ),
                Icon(
                  Icons.monetization_on,
                  size: 40,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ],
            ),
          ),

          // Fines List
          Expanded(
            child: data.fineRecords.isEmpty
                ? const Center(
                    child: Text('No fine records found.', style: TextStyle(color: Colors.grey, fontSize: 16)),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    itemCount: data.fineRecords.length,
                    itemBuilder: (context, index) {
                      final fine = data.fineRecords[index];
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
                                  Text(
                                    '৳${fine.amount.toStringAsFixed(0)}',
                                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.deepOrange),
                                  ),
                                  if (fine.status == FineStatus.pending) StatusChip.pending(),
                                  if (fine.status == FineStatus.collected) StatusChip.collected(),
                                  if (fine.status == FineStatus.waived) StatusChip.waived(),
                                ],
                              ),
                              const SizedBox(height: 6),
                              Text('Member: ${fine.memberName}', style: const TextStyle(fontWeight: FontWeight.bold)),
                              Text('Book: ${fine.bookTitle}', style: TextStyle(color: Colors.grey.shade700)),
                              Text('Overdue by ${fine.overdueDays} days', style: const TextStyle(fontSize: 12, color: Colors.grey)),

                              if (fine.status == FineStatus.pending) ...[
                                const SizedBox(height: 12),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    OutlinedButton.icon(
                                      icon: const Icon(Icons.check, size: 16, color: Colors.green),
                                      label: const Text('Waive Fine', style: TextStyle(color: Colors.green)),
                                      onPressed: () {
                                        data.waiveFine(fine.id);
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          const SnackBar(content: Text('Fine waived successfully.')),
                                        );
                                      },
                                    ),
                                    const SizedBox(width: 8),
                                    ElevatedButton.icon(
                                      icon: const Icon(Icons.payments, size: 16),
                                      label: const Text('Collect Cash'),
                                      style: ElevatedButton.styleFrom(backgroundColor: Colors.teal, foregroundColor: Colors.white),
                                      onPressed: () {
                                        data.collectFine(fine.id);
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          const SnackBar(content: Text('Fine collected successfully!'), backgroundColor: Colors.green),
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ],
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
