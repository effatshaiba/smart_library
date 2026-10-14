import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../providers/auth_provider.dart';
import '../../providers/library_data_provider.dart';
import '../../widgets/accessibility_toolbar.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    final data = Provider.of<LibraryDataProvider>(context);

    final notifs = auth.isAdmin
        ? data.notifications
        : data.getMemberNotifications(auth.currentUser?.id ?? '');

    return Scaffold(
      appBar: const AccessibilityToolbar(title: 'Notifications'),
      body: notifs.isEmpty
          ? const Center(
              child: Text(
                'No notifications available',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: notifs.length,
              itemBuilder: (context, index) {
                final notif = notifs[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 10),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: notif.isRead ? Colors.grey.shade300 : Theme.of(context).colorScheme.primaryContainer,
                      child: Icon(
                        Icons.notifications_active,
                        color: notif.isRead ? Colors.grey : Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    title: Text(
                      notif.title,
                      style: TextStyle(
                        fontWeight: notif.isRead ? FontWeight.normal : FontWeight.bold,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 4),
                        Text(notif.message),
                        const SizedBox(height: 6),
                        Text(
                          DateFormat('dd MMM yyyy, hh:mm a').format(notif.timestamp),
                          style: const TextStyle(fontSize: 11, color: Colors.grey),
                        ),
                      ],
                    ),
                    onTap: () {
                      data.markNotificationRead(notif.id);
                    },
                  ),
                );
              },
            ),
    );
  }
}
