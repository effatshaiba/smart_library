import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/library_data_provider.dart';
import '../../widgets/accessibility_toolbar.dart';
import '../../widgets/stat_card.dart';
import '../shared/notifications_screen.dart';

class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final data = Provider.of<LibraryDataProvider>(context);

    return Scaffold(
      appBar: AccessibilityToolbar(
        title: 'Admin Dashboard',
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const NotificationsScreen()),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Welcome Header
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Theme.of(context).colorScheme.primary,
                    Theme.of(context).colorScheme.primary.withAlpha(200),
                  ],
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  const CircleAvatar(
                    radius: 28,
                    backgroundColor: Colors.white24,
                    child: Icon(Icons.admin_panel_settings, size: 32, color: Colors.white),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          'Library Admin Control',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Shanto-Mariam University LMS',
                          style: TextStyle(color: Colors.white70, fontSize: 13),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            const Text(
              'System Overview Statistics',
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),

            // Statistics Grid (FR2)
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.3,
              children: [
                StatCard(
                  title: 'Total Books Inventory',
                  value: '${data.totalBooks}',
                  icon: Icons.menu_book,
                  color: Colors.deepPurple,
                ),
                StatCard(
                  title: 'Active Borrowings',
                  value: '${data.activeBorrowings}',
                  icon: Icons.auto_stories,
                  color: Colors.blue,
                ),
                StatCard(
                  title: 'Overdue Borrowings',
                  value: '${data.overdueBooks}',
                  icon: Icons.warning_amber_rounded,
                  color: Colors.red,
                ),
                StatCard(
                  title: 'Registered Members',
                  value: '${data.totalMembers}',
                  icon: Icons.people,
                  color: Colors.teal,
                ),
                StatCard(
                  title: 'Pending Holds',
                  value: '${data.pendingReservations}',
                  icon: Icons.bookmark_border,
                  color: Colors.orange,
                ),
                StatCard(
                  title: 'Pending Fines',
                  value: '৳${data.totalPendingFines.toInt()}',
                  icon: Icons.monetization_on,
                  color: Colors.amber.shade800,
                ),
              ],
            ),
            const SizedBox(height: 24),

            const Text(
              'Quick System Actions',
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),

            // Quick Actions List
            Card(
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.add_a_photo, color: Colors.deepPurple),
                    title: const Text('Add New Book to Inventory'),
                    subtitle: const Text('Manage books with cover image support'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {},
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.person_add, color: Colors.teal),
                    title: const Text('Register New Member'),
                    subtitle: const Text('Add student or staff library account'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {},
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.sync_alt, color: Colors.blue),
                    title: const Text('Process Book Issue / Return'),
                    subtitle: const Text('Perform circulation transactions'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {},
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
