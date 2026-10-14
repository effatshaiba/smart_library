import 'package:flutter/material.dart';
import 'admin_dashboard.dart';
import 'circulation.dart';
import 'admin_profile.dart';
import 'placeholder_screen.dart';
import 'screens/shared/notifications_screen.dart';

class BookCatalogScreen extends StatelessWidget {
  const BookCatalogScreen({super.key});

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
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('SMART LIBRARY', style: TextStyle(color: Colors.blue.shade900, fontSize: 16, fontWeight: FontWeight.bold)),
            const Text('ENDLESS READING', style: TextStyle(color: Colors.grey, fontSize: 10)),
          ],
        ),
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.blue.shade900),
        actions: [
          IconButton(
            icon: const Icon(Icons.dark_mode_outlined, color: Colors.grey),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const PlaceholderScreen(title: 'Dark Mode Settings')));
            },
          ),
          IconButton(
            icon: const Icon(Icons.notifications_outlined, color: Colors.red),
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
                    Text('Book Catalog', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.blue.shade900)),
                    Text('Inventory & Circulation Management', style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(color: Colors.cyan.shade100, borderRadius: BorderRadius.circular(20)),
                  child: Row(
                    children: [
                      Icon(Icons.admin_panel_settings, size: 16, color: Colors.cyan.shade800),
                      const SizedBox(width: 4),
                      Text('Admin View', style: TextStyle(color: Colors.cyan.shade800, fontWeight: FontWeight.bold, fontSize: 12)),
                    ],
                  ),
                )
              ],
            ),
            const SizedBox(height: 16),

            // Search Bar
            Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Search books by title, ISBN, author...',
                      prefixIcon: const Icon(Icons.search),
                      suffixIcon: const Icon(Icons.qr_code_scanner),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
                  child: Icon(Icons.tune, color: Colors.blue.shade700),
                )
              ],
            ),
            const SizedBox(height: 16),

            // Category Chips
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildChip('All Books', true),
                  _buildChip('Categories', false),
                  _buildChip('Authors', false),
                  _buildChip('Publishers', false),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Summary Row
            Row(
              children: [
                Icon(Icons.circle, size: 10, color: Colors.blue.shade700),
                const SizedBox(width: 4),
                const Text('1,248', style: TextStyle(fontWeight: FontWeight.bold)),
                const Text(' Titles  •  '),
                const Text('4,820', style: TextStyle(fontWeight: FontWeight.bold)),
                const Text(' Copies'),
                const Spacer(),
                Text('Sort: Recently Added', style: TextStyle(color: Colors.blue.shade700, fontWeight: FontWeight.bold)),
                Icon(Icons.keyboard_arrow_down, color: Colors.blue.shade700),
              ],
            ),
            const SizedBox(height: 16),

            // Books List (Scrollable)
            _buildBookCard(context, 'Introduction to Algorithms (4th Ed.)', 'Thomas H. Cormen, Charles E. Leiserson', 'Computer Science', 'Available • 4 Copies', Colors.green, 'CS-B2-04', '5', '1', '4'),
            const SizedBox(height: 16),
            _buildBookCard(context, 'Clean Architecture', 'Robert C. Martin', 'Software Engineering', 'Out of Stock • 0 Available', Colors.orange, 'SE-A1-12', '3', '3', '0'),
            const SizedBox(height: 16),
            _buildBookCard(context, 'Principles of Neural Science (5th Ed.)', 'Eric R. Kandel, James H. Schwartz', 'Neuroscience & Med', 'Available • 2 Copies', Colors.green, 'MED-C3-08', '4', '2', '2'),
            const SizedBox(height: 80),
          ],
        ),
      ),

      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => const PlaceholderScreen(title: 'Add New Book')));
        },
        backgroundColor: Colors.blue.shade700,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text('Add Book', style: TextStyle(color: Colors.white)),
      ),

      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: 1, // Catalog selected
        selectedItemColor: Colors.blue.shade700,
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          if (index == 0) { // Home / Dashboard
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const AdminDashboard()),
            );
          } else if (index == 2) { // Circulation
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const CirculationScreen()),
            );
          } else if (index == 3) { // Alerts
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const NotificationsScreen()),
            );
          } else if (index == 4) { // Profile
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const AdminProfileScreen()),
            );
          }
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: 'Dashboard'),
          BottomNavigationBarItem(icon: Icon(Icons.menu_book), label: 'Catalog'),
          BottomNavigationBarItem(icon: Icon(Icons.swap_horiz), label: 'Circulation'),
          BottomNavigationBarItem(icon: Icon(Icons.notifications_none), label: 'Alerts'),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'Profile'),
        ],
      ),
    );
  }

  Widget _buildChip(String label, bool isSelected) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isSelected ? Colors.blue.shade700 : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: isSelected ? null : Border.all(color: Colors.grey.shade300),
      ),
      child: Text(label, style: TextStyle(color: isSelected ? Colors.white : Colors.grey.shade700, fontWeight: FontWeight.bold)),
    );
  }

  Widget _buildBookCard(BuildContext context, String title, String author, String category, String status, Color statusColor, String shelf, String total, String circ, String inLib) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(width: 60, height: 80, color: Colors.grey.shade200, child: const Icon(Icons.image, color: Colors.grey)),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.blue.shade900)),
                    Text(author, style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(color: statusColor.withAlpha(25), borderRadius: BorderRadius.circular(12)),
                      child: Text(status, style: TextStyle(color: statusColor, fontSize: 10, fontWeight: FontWeight.bold)),
                    ),
                    const SizedBox(height: 4),
                    Text('Category: $category', style: TextStyle(color: Colors.blue.shade900, fontSize: 12)),
                  ],
                ),
              )
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: Colors.grey.shade50, borderRadius: BorderRadius.circular(8)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildStatColumn('SHELF', shelf, Colors.blue.shade900),
                _buildStatColumn('TOTAL', total, Colors.blue.shade900),
                _buildStatColumn('CIRCULATION', circ, Colors.cyan),
                _buildStatColumn('IN LIBRARY', inLib, Colors.green),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Added: Oct 14, 2024', style: TextStyle(color: Colors.grey, fontSize: 12)),
              Row(
                children: [
                  OutlinedButton.icon(
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const PlaceholderScreen(title: 'Edit Book')));
                    },
                    icon: const Icon(Icons.edit, size: 14),
                    label: const Text('Edit', style: TextStyle(fontSize: 12)),
                    style: OutlinedButton.styleFrom(foregroundColor: Colors.blue.shade700, padding: const EdgeInsets.symmetric(horizontal: 12)),
                  ),
                  const SizedBox(width: 8),
                  OutlinedButton.icon(
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const PlaceholderScreen(title: 'Delete Book')));
                    },
                    icon: const Icon(Icons.delete, size: 14),
                    label: const Text('Delete', style: TextStyle(fontSize: 12)),
                    style: OutlinedButton.styleFrom(foregroundColor: Colors.red, padding: const EdgeInsets.symmetric(horizontal: 12), side: BorderSide(color: Colors.red.shade100)),
                  ),
                ],
              )
            ],
          )
        ],
      ),
    );
  }

  Widget _buildStatColumn(String label, String value, Color valueColor) {
    return Column(
      children: [
        Text(label, style: const TextStyle(color: Colors.grey, fontSize: 10, fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        Text(value, style: TextStyle(color: valueColor, fontSize: 14, fontWeight: FontWeight.bold)),
      ],
    );
  }
}
