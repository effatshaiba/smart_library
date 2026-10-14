import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../models/reservation.dart';
import '../../providers/auth_provider.dart';
import '../../providers/library_data_provider.dart';
import '../../widgets/accessibility_toolbar.dart';
import '../../widgets/status_chip.dart';

class MyReservationsScreen extends StatelessWidget {
  const MyReservationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    final data = Provider.of<LibraryDataProvider>(context);
    final myRes = data.getMemberReservations(auth.currentUser?.id ?? '');

    return Scaffold(
      appBar: const AccessibilityToolbar(title: 'My Book Holds'),
      body: myRes.isEmpty
          ? const Center(
              child: Text('You have no active book reservations.', style: TextStyle(color: Colors.grey, fontSize: 16)),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: myRes.length,
              itemBuilder: (context, index) {
                final res = myRes[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 10),
                  child: ListTile(
                    leading: const CircleAvatar(child: Icon(Icons.bookmark_border)),
                    title: Text(res.bookTitle, style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text('Reserved on: ${DateFormat('dd MMM yyyy').format(res.reservationDate)}'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (res.status == ReservationStatus.pending) StatusChip.pending(),
                        if (res.status == ReservationStatus.fulfilled) StatusChip.active(),
                        if (res.status == ReservationStatus.cancelled) StatusChip.inactive(),
                        if (res.status == ReservationStatus.pending)
                          IconButton(
                            icon: const Icon(Icons.cancel_outlined, color: Colors.red),
                            onPressed: () {
                              data.cancelReservation(res.id);
                            },
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
