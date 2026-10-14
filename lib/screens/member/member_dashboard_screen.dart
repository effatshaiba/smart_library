import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/library_data_provider.dart';
import '../../widgets/accessibility_toolbar.dart';
import '../../widgets/stat_card.dart';
import '../shared/notifications_screen.dart';
import 'book_catalog_screen.dart';
import 'my_borrows_screen.dart';

class MemberDashboardScreen extends StatelessWidget {
  const MemberDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    final data = Provider.of<LibraryDataProvider>(context);
    final memberId = auth.currentUser?.id ?? '';

    final myBorrows = data.getMemberBorrows(memberId);
    final activeBorrows = myBorrows.where((b) => b.returnDate == null).toList();
    final myReservations = data.getMemberReservations(memberId);
    final myFines = data.getMemberFines(memberId);
    final pendingFines = myFines.where((f) => f.status == f.status).fold(0.0, (s, f) => s + f.amount);

    return Scaffold(
      appBar: AccessibilityToolbar(
        title: 'Member Home',
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
            // Student Banner
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.teal,
                    Colors.teal.shade700,
                  ],
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  const CircleAvatar(
                    radius: 28,
                    backgroundColor: Colors.white24,
                    child: Icon(Icons.person, size: 32, color: Colors.white),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Welcome, ${auth.currentUser?.name ?? "Student"}',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'ID: ${auth.currentUser?.studentId} | Dept: ${auth.currentUser?.department}',
                          style: const TextStyle(color: Colors.white70, fontSize: 13),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            const Text(
              'My Library Summary',
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),

            // Stat Cards Grid
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.3,
              children: [
                StatCard(
                  title: 'Currently Borrowed',
                  value: '${activeBorrows.length}',
                  icon: Icons.book,
                  color: Colors.teal,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const MyBorrowsScreen()),
                    );
                  },
                ),
                StatCard(
                  title: 'Active Holds',
                  value: '${myReservations.where((r) => r.status == r.status).length}',
                  icon: Icons.bookmark_border,
                  color: Colors.purple,
                ),
                StatCard(
                  title: 'My Pending Fines',
                  value: '৳${pendingFines.toInt()}',
                  icon: Icons.monetization_on,
                  color: Colors.deepOrange,
                ),
                StatCard(
                  title: 'Total Borrow History',
                  value: '${myBorrows.length}',
                  icon: Icons.history,
                  color: Colors.blue,
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Search Books Banner
            InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const BookCatalogScreen()),
                );
              },
              child: Card(
                color: Theme.of(context).colorScheme.primaryContainer,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      Icon(
                        Icons.search,
                        size: 36,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Search Library Catalog',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.onPrimaryContainer,
                              ),
                            ),
                            const SizedBox(height: 2),
                            const Text(
                              'Browse books, view availability, request or reserve books.',
                              style: TextStyle(fontSize: 12, color: Colors.black54),
                            ),
                          ],
                        ),
                      ),
                      const Icon(Icons.arrow_forward_ios, size: 16),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
