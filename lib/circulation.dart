import 'package:flutter/material.dart';
import 'admin_dashboard.dart';
import 'book_catalog_admin.dart';
import 'admin_profile.dart';
import 'placeholder_screen.dart';
import 'screens/shared/notifications_screen.dart';

class CirculationScreen extends StatelessWidget {
  const CirculationScreen({super.key});

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
            icon: const Icon(Icons.text_fields, color: Colors.grey),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const PlaceholderScreen(title: 'Font Scale Settings')));
            },
          ),
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
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Text('Circulation Board', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blue.shade900)),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(color: Colors.blue.shade100, borderRadius: BorderRadius.circular(12)),
                      child: Text('Desk #04', style: TextStyle(color: Colors.blue.shade700, fontSize: 10, fontWeight: FontWeight.bold)),
                    )
                  ],
                ),
                Row(
                  children: [
                    const Icon(Icons.check_circle, color: Colors.green, size: 16),
                    const SizedBox(width: 4),
                    Text('RFID Synced', style: TextStyle(color: Colors.grey.shade700, fontSize: 12)),
                  ],
                )
              ],
            ),
            const SizedBox(height: 16),

            // Tabs
            Container(
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24)),
              padding: const EdgeInsets.all(4),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(color: Colors.blue.shade700, borderRadius: BorderRadius.circular(20)),
                      child: const Center(child: Text('Issue Book', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
                    ),
                  ),
                  Expanded(
                    child: Center(child: Text('Return Book', style: TextStyle(color: Colors.grey.shade600, fontWeight: FontWeight.bold))),
                  ),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Requests ', style: TextStyle(color: Colors.grey.shade600, fontWeight: FontWeight.bold)),
                        Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(color: Colors.red.shade100, shape: BoxShape.circle),
                          child: const Text('3', style: TextStyle(color: Colors.red, fontSize: 10, fontWeight: FontWeight.bold)),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // New Circulation Entry Form
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.swap_horiz, color: Colors.blue.shade700),
                          const SizedBox(width: 8),
                          Text('NEW CIRCULATION ENTRY', style: TextStyle(color: Colors.blue.shade700, fontWeight: FontWeight.bold)),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(12)),
                        child: Text('Quota: 3/5 books', style: TextStyle(color: Colors.grey.shade600, fontSize: 10)),
                      )
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Member ID Section (Sadia Afrin)
                  Text('Member ID', style: TextStyle(color: Colors.grey.shade700)),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(color: Colors.grey.shade50, borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.grey.shade200)),
                    child: Row(
                      children: [
                        CircleAvatar(backgroundColor: Colors.blue.shade700, child: const Text('S', style: TextStyle(color: Colors.white))),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Sadia Afrin', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                              Text('Faculty • Dept. of CS', style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
                            ],
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.qr_code_scanner, size: 16, color: Colors.blue.shade700),
                                const SizedBox(width: 4),
                                Text('Scan', style: TextStyle(color: Colors.blue.shade700, fontWeight: FontWeight.bold))
                              ],
                            ),
                            const SizedBox(height: 4),
                            const Text('Active', style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 12))
                          ],
                        )
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Book Title or ISBN Section
                  Text('Book Title or ISBN', style: TextStyle(color: Colors.grey.shade700)),
                  const SizedBox(height: 8),
                  TextField(
                    decoration: InputDecoration(
                      hintText: '978-0262033848',
                      hintStyle: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black87),
                      prefixIcon: const Icon(Icons.menu_book),
                      suffixIcon: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ElevatedButton.icon(
                          onPressed: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => const PlaceholderScreen(title: 'Barcode Scanner')));
                          },
                          icon: const Icon(Icons.camera_alt, size: 16, color: Colors.white),
                          label: const Text('Scan', style: TextStyle(color: Colors.white)),
                          style: ElevatedButton.styleFrom(backgroundColor: Colors.teal.shade600),
                        ),
                      ),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.shade300)),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Book Info Card
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(color: Colors.indigo.shade50, borderRadius: BorderRadius.circular(12)),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(color: Colors.blue.shade100, borderRadius: BorderRadius.circular(8)),
                          child: Icon(Icons.book, color: Colors.blue.shade700),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Expanded(child: Text('Introduction to Algorithms', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue.shade900))),
                                  const Text('In Stock (4)', style: TextStyle(color: Colors.green, fontSize: 12, fontWeight: FontWeight.bold)),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Text('4th Edition • Cormen, Leiserson, Rivest', style: TextStyle(color: Colors.grey.shade700, fontSize: 12)),
                              Text('Shelf: CS-B2-04 • Copy #CP-0891', style: TextStyle(color: Colors.grey.shade700, fontSize: 12)),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Dates
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Issue Date', style: TextStyle(color: Colors.grey.shade700)),
                            const SizedBox(height: 8),
                            TextField(
                              decoration: InputDecoration(
                                hintText: 'Oct 24, 2024',
                                suffixIcon: Icon(Icons.calendar_today, color: Colors.blue.shade700),
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                                contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text('Today (Auto-stamped)', style: TextStyle(color: Colors.grey.shade500, fontSize: 10)),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Due Date', style: TextStyle(color: Colors.grey.shade700)),
                            const SizedBox(height: 8),
                            TextField(
                              decoration: InputDecoration(
                                hintText: 'Nov 07, 2024',
                                suffixIcon: Icon(Icons.calendar_today, color: Colors.blue.shade700),
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                                contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text('14 Days Standard', style: TextStyle(color: Colors.blue.shade700, fontSize: 10, fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Confirm Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.blue.shade700, padding: const EdgeInsets.symmetric(vertical: 16), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Circulation entry confirmed!'), backgroundColor: Colors.green),
                        );
                      },
                      icon: const Icon(Icons.check_box_outlined, color: Colors.white),
                      label: const Text('Confirm Issue', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Recent Issues Section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Text('Recent Issues', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blue.shade900)),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(color: Colors.grey.shade200, shape: BoxShape.circle),
                      child: Text('18', style: TextStyle(color: Colors.grey.shade700, fontSize: 12, fontWeight: FontWeight.bold)),
                    )
                  ],
                ),
                Text('View All >', style: TextStyle(color: Colors.blue.shade700, fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 16),
            _buildRecentIssueCard('Clean Architecture', 'Marcus Chen (#8821)', 'Today, 09:40 AM', 'Nov 07'),
            const SizedBox(height: 12),
            _buildRecentIssueCard('Principles of Neural Science', 'Elena Rostova (#4092)', 'Today, 08:15 AM', 'Nov 07'),
            const SizedBox(height: 24),
          ],
        ),
      ),

      // Bottom Navigation Bar
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: 2, // Circulation selected
        selectedItemColor: Colors.blue.shade700,
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          if (index == 0) { // Home / Dashboard
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const AdminDashboard()),
            );
          } else if (index == 1) { // Catalog / Books
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const BookCatalogScreen()),
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

  Widget _buildRecentIssueCard(String title, String user, String time, String dueDate) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.grey.shade200)),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: Colors.indigo.shade50, borderRadius: BorderRadius.circular(8)),
            child: Icon(Icons.book, color: Colors.blue.shade700),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(child: Text(title, style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue.shade900))),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(color: Colors.green.shade50, borderRadius: BorderRadius.circular(12)),
                      child: const Text('Issued', style: TextStyle(color: Colors.green, fontSize: 10, fontWeight: FontWeight.bold)),
                    )
                  ],
                ),
                const SizedBox(height: 4),
                Text('To $user', style: TextStyle(color: Colors.grey.shade700, fontSize: 12)),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.access_time, size: 12, color: Colors.grey),
                    const SizedBox(width: 4),
                    Text(time, style: const TextStyle(color: Colors.grey, fontSize: 12)),
                    const Text('  •  ', style: TextStyle(color: Colors.grey)),
                    Text('Due $dueDate', style: TextStyle(color: Colors.blue.shade700, fontSize: 12, fontWeight: FontWeight.bold)),
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
