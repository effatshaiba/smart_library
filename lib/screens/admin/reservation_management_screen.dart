import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../models/reservation.dart';
import '../../providers/library_data_provider.dart';
import '../../widgets/accessibility_toolbar.dart';
import '../../widgets/status_chip.dart';

class ReservationManagementScreen extends StatelessWidget {
  const ReservationManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final data = Provider.of<LibraryDataProvider>(context);

    return Scaffold(
      appBar: const AccessibilityToolbar(title: 'Reservation Holds'),
      body: data.reservations.isEmpty
          ? const Center(
              child: Text('No book reservations placed yet.', style: TextStyle(color: Colors.grey, fontSize: 16)),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: data.reservations.length,
              itemBuilder: (context, index) {
                final res = data.reservations[index];
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
                                res.bookTitle,
                                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                            ),
                            if (res.status == ReservationStatus.pending) StatusChip.pending(),
                            if (res.status == ReservationStatus.fulfilled) StatusChip.active(),
                            if (res.status == ReservationStatus.cancelled) StatusChip.inactive(),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Text('Reserved by: ${res.memberName}', style: const TextStyle(fontWeight: FontWeight.w500)),
                        const SizedBox(height: 4),
                        Text(
                          'Reserved on: ${DateFormat('dd MMM yyyy, hh:mm a').format(res.reservationDate)}',
                          style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                        ),
                        if (res.status == ReservationStatus.pending) ...[
                          const SizedBox(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              OutlinedButton.icon(
                                icon: const Icon(Icons.close, size: 16, color: Colors.red),
                                label: const Text('Reject/Cancel', style: TextStyle(color: Colors.red)),
                                onPressed: () {
                                  data.cancelReservation(res.id);
                                },
                              ),
                              const SizedBox(width: 8),
                              ElevatedButton.icon(
                                icon: const Icon(Icons.check, size: 16),
                                label: const Text('Fulfill & Notify'),
                                style: ElevatedButton.styleFrom(backgroundColor: Colors.green, foregroundColor: Colors.white),
                                onPressed: () {
                                  data.fulfillReservation(res.id);
                                  data.sendNotification(
                                    'Reserved Book Available',
                                    'Your reserved book "${res.bookTitle}" is now available for checkout at the library counter.',
                                    recipientMemberId: res.memberId,
                                  );
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Reservation fulfilled and member notified!'), backgroundColor: Colors.green),
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
    );
  }
}
