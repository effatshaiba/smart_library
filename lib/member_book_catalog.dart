import 'package:flutter/material.dart';
import 'member_dashboard.dart';
import 'member_borrowing_history.dart';
import 'member_profile.dart';
import 'book_reservation_member.dart';
import 'placeholder_screen.dart';
import 'screens/shared/notifications_screen.dart';

class MemberCatalogScreen extends StatelessWidget {
  const MemberCatalogScreen({super.key});

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
          children: [
            Icon(Icons.local_library, color: Colors.blue.shade700, size: 24),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'SMART LIBRARY',
                  style: TextStyle(
                    color: Colors.blue.shade900,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'ENDLESS READING',
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 9,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ],
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.nightlight_round, color: Colors.grey.shade700, size: 20),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const PlaceholderScreen(title: 'Dark Mode Settings')));
            },
          ),
          IconButton(
            icon: Icon(Icons.notifications_none, color: Colors.red.shade400, size: 22),
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
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Library Catalog',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue.shade900,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Explore, borrow, and reserve books',
                      style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade100,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.bookmark_border, size: 14, color: Colors.blue.shade800),
                      const SizedBox(width: 4),
                      Text(
                        'Quota: 2/5',
                        style: TextStyle(
                          color: Colors.blue.shade800,
                          fontWeight: FontWeight.bold,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Search Bar
            Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Search by Title, Author, or ISBN...',
                      hintStyle: TextStyle(color: Colors.grey.shade500, fontSize: 13),
                      prefixIcon: Icon(Icons.search, color: Colors.grey.shade500),
                      suffixIcon: IconButton(
                        icon: Icon(Icons.qr_code_scanner, color: Colors.blue.shade700),
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => const PlaceholderScreen(title: 'QR / Barcode Scanner')));
                        },
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(vertical: 0),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Category Chips (Horizontal Scrollable)
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildChip('All •', true),
                  _buildChip('Categories', false, icon: Icons.category_outlined),
                  _buildChip('Popular', false, icon: Icons.trending_up),
                  _buildChip('New', false, icon: Icons.fiber_new),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Stock Count & Sort Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(color: Colors.blue.shade700, shape: BoxShape.circle),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      '850+ Titles in Stock',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.blue.shade900),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade200),
                  ),
                  child: Row(
                    children: [
                      Text(
                        'Sort: Most Relevant',
                        style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.blue.shade700),
                      ),
                      const SizedBox(width: 4),
                      Icon(Icons.keyboard_arrow_down, size: 16, color: Colors.blue.shade700),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Book Cards List
            _buildBookCard(
              context: context,
              title: 'Introduction to Algorithms (4th...',
              author: 'Thomas H. Cormen, Charles E. Leiserson',
              category: 'Computer Science',
              shelf: 'CS-B2-04',
              statusText: 'Available (4 Copies)',
              statusColor: Colors.green,
              actionButtonText: 'Request',
              isAvailable: true,
            ),
            const SizedBox(height: 16),
            _buildBookCard(
              context: context,
              title: 'Clean Architecture',
              author: 'Robert C. Martin',
              category: 'Software Engineering',
              shelf: 'SE-A1-12',
              statusText: 'Reserved (In Circulation)',
              statusColor: Colors.orange.shade800,
              actionButtonText: 'Place in Queue\n#2',
              isAvailable: false,
              estReturn: 'Est. Return: 3 Days',
            ),
            const SizedBox(height: 16),
            _buildBookCard(
              context: context,
              title: 'Designing Data-Intensive...',
              author: 'Martin Kleppmann',
              category: 'Data Systems',
              shelf: 'CS-D3-19',
              statusText: 'Available (1 Copy)',
              statusColor: Colors.green,
              actionButtonText: 'Request',
              isAvailable: true,
            ),
            const SizedBox(height: 16),
            _buildBookCard(
              context: context,
              title: 'Principles of Neural Science',
              author: 'Eric R. Kandel',
              category: 'Neuroscience / Medicine',
              shelf: 'MED-N1-08',
              statusText: 'Reserved (Expected Nov 02)',
              statusColor: Colors.orange.shade800,
              actionButtonText: 'Reserve',
              isAvailable: false,
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

  Widget _buildChip(String label, bool isSelected, {IconData? icon}) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: isSelected ? Colors.blue.shade700 : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: isSelected ? null : Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        children: [
          if (icon != null) ...[
            Icon(icon, size: 14, color: isSelected ? Colors.white : Colors.grey.shade700),
            const SizedBox(width: 4),
          ],
          Text(
            label,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.grey.shade700,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBookCard({
    required BuildContext context,
    required String title,
    required String author,
    required String category,
    required String shelf,
    required String statusText,
    required Color statusColor,
    required String actionButtonText,
    required bool isAvailable,
    String? estReturn,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Book Cover Placeholder
              Container(
                width: 60,
                height: 80,
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(Icons.menu_book, color: Colors.grey.shade400),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: statusColor.withAlpha(25),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              statusText,
                              style: TextStyle(color: statusColor, fontSize: 10, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        IconButton(
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                          icon: Icon(Icons.bookmark_border, size: 18, color: Colors.grey.shade600),
                          onPressed: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => const PlaceholderScreen(title: 'Book Bookmark')));
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      title,
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.blue.shade900),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      author,
                      style: TextStyle(color: Colors.grey.shade600, fontSize: 11),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  category,
                  style: TextStyle(color: Colors.blue.shade800, fontSize: 10, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                'Shelf: $shelf',
                style: TextStyle(color: Colors.grey.shade600, fontSize: 11),
              ),
            ],
          ),
          if (estReturn != null) ...[
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.access_time, size: 12, color: Colors.orange.shade800),
                const SizedBox(width: 4),
                Text(
                  estReturn,
                  style: TextStyle(color: Colors.orange.shade800, fontSize: 11, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ],
          const Divider(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const MemberReservationScreen()),
                  );
                },
                icon: Text('Details & Citations', style: TextStyle(color: Colors.blue.shade700, fontSize: 12, fontWeight: FontWeight.bold)),
                label: Icon(Icons.arrow_forward, size: 14, color: Colors.blue.shade700),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const MemberReservationScreen()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: isAvailable ? Colors.blue.shade700 : Colors.white,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                    side: isAvailable ? BorderSide.none : BorderSide(color: Colors.blue.shade700),
                  ),
                ),
                child: Text(
                  actionButtonText,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: isAvailable ? Colors.white : Colors.blue.shade700,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
