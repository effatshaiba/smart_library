import 'package:flutter/material.dart';
import 'member_dashboard.dart';
import 'member_book_catalog.dart';
import 'member_borrowing_history.dart';
import 'member_profile.dart';
import 'placeholder_screen.dart';
import 'screens/shared/notifications_screen.dart';

class MemberReservationScreen extends StatelessWidget {
  const MemberReservationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade50,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.blue.shade900),
          onPressed: () {
            if (Navigator.canPop(context)) {
              Navigator.pop(context);
            }
          },
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.local_library, color: Colors.blue.shade700, size: 20),
            const SizedBox(width: 6),
            Text(
              'SMART LIBRARY',
              style: TextStyle(
                color: Colors.blue.shade900,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4.0),
              child: Text(
                'TT',
                style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey.shade700, fontSize: 13),
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.nightlight_round, color: Colors.grey.shade700, size: 20),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const PlaceholderScreen(title: 'Dark Mode Settings')));
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 10),
            // Book Card Container
            Container(
              width: 260,
              height: 340,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF102A43), // Dark navy book cover background
                borderRadius: BorderRadius.circular(16),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 10,
                    offset: Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'SERIES IN\nARCHITECTURE',
                        style: TextStyle(color: Colors.grey.shade300, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 0.5),
                      ),
                      IconButton(
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        icon: Icon(Icons.share, color: Colors.grey.shade300, size: 16),
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => const PlaceholderScreen(title: 'Share Book Details')));
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Clean\nArchitecture',
                    style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold, height: 1.1),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    "A Craftsman's Guide",
                    style: TextStyle(color: Colors.grey.shade300, fontSize: 11),
                  ),
                  const Spacer(),
                  // Mock UI blocks on book cover
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white.withAlpha(20),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Container(width: 30, height: 16, decoration: BoxDecoration(color: Colors.blue.shade300, borderRadius: BorderRadius.circular(4))),
                        const SizedBox(width: 8),
                        Expanded(child: Container(height: 16, decoration: BoxDecoration(color: Colors.blue.shade200.withAlpha(128), borderRadius: BorderRadius.circular(4)))),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(child: Container(height: 24, decoration: BoxDecoration(color: Colors.indigo.shade300.withAlpha(128), borderRadius: BorderRadius.circular(4)))),
                      const SizedBox(width: 8),
                      Container(width: 40, height: 24, decoration: BoxDecoration(color: Colors.blue.shade900, borderRadius: BorderRadius.circular(4))),
                    ],
                  ),
                  const Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('AUTHOR', style: TextStyle(color: Colors.grey.shade400, fontSize: 8, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 2),
                          const Text('Sarah Jenkins', style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold)),
                        ],
                      ),
                      CircleAvatar(
                        radius: 14,
                        backgroundColor: Colors.white.withAlpha(38),
                        child: const Icon(Icons.school, color: Colors.white, size: 14),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Book Details Text Section
            Text(
              'Clean Architecture',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.blue.shade900),
            ),
            const SizedBox(height: 4),
            Text(
              'Sarah Jenkins',
              style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
            ),
            const SizedBox(height: 12),

            // Out of Stock Badge
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.orange.shade50,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.orange.shade200),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.circle, size: 8, color: Colors.orange.shade800),
                  const SizedBox(width: 6),
                  Text(
                    'Out of Stock',
                    style: TextStyle(color: Colors.orange.shade800, fontWeight: FontWeight.bold, fontSize: 12),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),

            // Est Availability Row
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.calendar_today, size: 14, color: Colors.blue.shade700),
                const SizedBox(width: 6),
                Text(
                  'Est. Availability: ',
                  style: TextStyle(color: Colors.grey.shade700, fontSize: 12),
                ),
                Text(
                  'Oct 20',
                  style: TextStyle(color: Colors.blue.shade900, fontWeight: FontWeight.bold, fontSize: 12),
                ),
              ],
            ),
            const SizedBox(height: 30),

            // Reserve Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Book reserved successfully!'), backgroundColor: Colors.green),
                  );
                  if (Navigator.canPop(context)) {
                    Navigator.pop(context);
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue.shade800,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 0,
                ),
                icon: const Icon(Icons.bookmark_border, color: Colors.white, size: 20),
                label: const Text(
                  'Reserve This Book',
                  style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '14-day borrowing rules apply upon pickup',
              style: TextStyle(color: Colors.grey.shade600, fontSize: 11),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: 1, // Catalog selected
        selectedItemColor: Colors.blue.shade700,
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          if (index == 0) { // Home
            Navigator.push(context, MaterialPageRoute(builder: (_) => const MemberDashboardScreen()));
          } else if (index == 1) { // Catalog
            Navigator.push(context, MaterialPageRoute(builder: (_) => const MemberCatalogScreen()));
          } else if (index == 2) { // My Books / History
            Navigator.push(context, MaterialPageRoute(builder: (_) => const MemberHistoryScreen()));
          } else if (index == 3) { // Alerts
            Navigator.push(context, MaterialPageRoute(builder: (_) => const NotificationsScreen()));
          } else if (index == 4) { // Profile
            Navigator.push(context, MaterialPageRoute(builder: (_) => const MemberProfileScreen()));
          }
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.menu_book), label: 'Catalog'),
          BottomNavigationBarItem(icon: Icon(Icons.book_outlined), label: 'My Books'),
          BottomNavigationBarItem(icon: Icon(Icons.notifications_none), label: 'Alerts'),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'Profile'),
        ],
      ),
    );
  }
}
