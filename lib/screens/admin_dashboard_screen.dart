import 'package:flutter/material.dart';
import '../book_catalog_admin.dart';
import '../circulation.dart';
import '../admin_profile.dart';
import '../placeholder_screen.dart';
import 'shared/notifications_screen.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F5F9),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        automaticallyImplyLeading: false, // Root screen - no back button
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: const Color(0xFF0284C7),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.local_library_rounded, color: Colors.white, size: 20),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'SMART LIBRARY',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0284C7),
                    letterSpacing: 0.5,
                  ),
                ),
                Text(
                  'ADMIN DASHBOARD',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF64748B),
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.nightlight_round, color: Color(0xFF475569)),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const PlaceholderScreen(title: 'Dark Mode Settings')));
            },
          ),
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.notifications_outlined, color: Color(0xFF475569)),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const NotificationsScreen()),
                  );
                },
              ),
              Positioned(
                right: 8,
                top: 8,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                  child: const Text(
                    '4',
                    style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile Header Card
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: Row(
                children: [
                  Stack(
                    children: [
                      const CircleAvatar(
                        radius: 22,
                        backgroundColor: Color(0xFFE0F2FE),
                        child: Text(
                          'DV',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF0284C7),
                          ),
                        ),
                      ),
                      Positioned(
                        right: 0,
                        bottom: 0,
                        child: Container(
                          padding: const EdgeInsets.all(2),
                          decoration: const BoxDecoration(
                            color: Color(0xFF0284C7),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.check, size: 10, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Welcome back, Dr. Vance',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF0F172A),
                          ),
                        ),
                        const SizedBox(height: 2),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: const Color(0xFFE0F2FE),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: const Text(
                                'Librarian Admin',
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF0284C7),
                                ),
                              ),
                            ),
                            const SizedBox(width: 6),
                            const Text(
                              '• Central Campus',
                              style: TextStyle(fontSize: 11, color: Colors.grey),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const PlaceholderScreen(title: 'QR Code Scanner')));
                    },
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF1F5F9),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(Icons.qr_code_scanner, color: Color(0xFF0284C7), size: 20),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Section Header: Library Statistics
            Row(
              children: const [
                Icon(Icons.bar_chart_rounded, size: 18, color: Color(0xFF0284C7)),
                SizedBox(width: 6),
                Text(
                  'LIBRARY STATISTICS',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1E293B),
                    letterSpacing: 0.5,
                  ),
                ),
                Spacer(),
                Text(
                  'Auto-synced',
                  style: TextStyle(fontSize: 11, color: Colors.grey),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // 6 Metric Cards Grid
            GridView.count(
              crossAxisCount: 3,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              childAspectRatio: 0.95,
              children: [
                _buildMetricCard(context, 'Total Books', '14.8k', '+42 this mo', Icons.menu_book_outlined, Colors.green),
                _buildMetricCard(context, 'Members', '3,412', 'Active: 3.2k', Icons.people_outline, Colors.grey),
                _buildMetricCard(context, 'Borrowed', '846', '58 Overdue', Icons.swap_horiz_rounded, Colors.red),
                _buildMetricCard(context, 'Requests', '19', 'Needs Review', Icons.assignment_outlined, Colors.orange),
                _buildMetricCard(context, 'Fines', '\$428.50', '24 unpaid', Icons.account_balance_wallet_outlined, Colors.red),
                _buildMetricCard(context, 'Reserved', '34', '8 ready', Icons.bookmark_border_rounded, Colors.green),
              ],
            ),
            const SizedBox(height: 16),

            // Daily Circulation Progress Card
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: Column(
                children: [
                  Row(
                    children: const [
                      Icon(Icons.swap_horiz, size: 18, color: Color(0xFF0284C7)),
                      SizedBox(width: 6),
                      Text(
                        'Daily Circulation',
                        style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF1E293B)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: const [
                      Text('64 ', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF0F172A))),
                      Text('Issued', style: TextStyle(color: Colors.grey, fontSize: 12)),
                      Text('  •  ', style: TextStyle(color: Colors.grey)),
                      Text('51 ', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF0F172A))),
                      Text('Returned', style: TextStyle(color: Colors.grey, fontSize: 12)),
                      Text('  •  ', style: TextStyle(color: Colors.grey)),
                      Spacer(),
                      Text('13 ', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.orange)),
                      Text('Active Flow', style: TextStyle(color: Colors.grey, fontSize: 12)),
                    ],
                  ),
                  const SizedBox(height: 10),
                  // Multi-color Bar
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: SizedBox(
                      height: 8,
                      child: Row(
                        children: [
                          Expanded(flex: 64, child: Container(color: const Color(0xFF0284C7))),
                          Expanded(flex: 51, child: Container(color: const Color(0xFF10B981))),
                          Expanded(flex: 13, child: Container(color: const Color(0xFFE2E8F0))),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Pending Borrow Requests Section
            Row(
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(color: Colors.orange, shape: BoxShape.circle),
                ),
                const SizedBox(width: 6),
                const Text(
                  'PENDING BORROW REQUESTS',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1E293B),
                    letterSpacing: 0.5,
                  ),
                ),
                const Spacer(),
                GestureDetector(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const PlaceholderScreen(title: 'All Borrow Requests')));
                  },
                  child: const Text(
                    'View All (19)',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0284C7),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),

            // Request Item 1
            _buildRequestCard(
              context: context,
              title: 'Introduction to Algorithms',
              badgeLabel: 'NEEDS REVIEW',
              badgeBg: const Color(0xFFFEF3C7),
              badgeFg: const Color(0xFFD97706),
              subtitle: 'Marcus Chen (#8821) • Today, 10:15 AM',
            ),
            const SizedBox(height: 10),

            // Request Item 2
            _buildRequestCard(
              context: context,
              title: 'Organic Chemistry: Structure & I',
              badgeLabel: 'PENDING',
              badgeBg: const Color(0xFFE0F2FE),
              badgeFg: const Color(0xFF0284C7),
              subtitle: 'Elena Rostova (#4092) • Today, 09:30 AM',
            ),
            const SizedBox(height: 10),

            // Request Item 3
            _buildRequestCard(
              context: context,
              title: 'Clean Architecture',
              badgeLabel: 'IN QUEUE',
              badgeBg: const Color(0xFFF1F5F9),
              badgeFg: const Color(0xFF64748B),
              subtitle: 'Sarah Jenkins (#1042) • Yesterday',
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),

      // Bottom Navigation Bar
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() => _currentIndex = index);
          if (index == 1) { // Books
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const BookCatalogScreen()),
            );
          } else if (index == 2) { // Circulation
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const CirculationScreen()),
            );
          } else if (index == 3) { // Alerts
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const NotificationsScreen()),
            );
          } else if (index == 4) { // Profile
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const AdminProfileScreen()),
            );
          }
        },
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: const Color(0xFF0284C7),
        unselectedItemColor: const Color(0xFF64748B),
        selectedFontSize: 11,
        unselectedFontSize: 11,
        items: [
          const BottomNavigationBarItem(
            icon: Icon(Icons.grid_view_rounded),
            label: 'Home',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.menu_book_outlined),
            label: 'Books',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.people_outline),
            label: 'Members',
          ),
          BottomNavigationBarItem(
            icon: Stack(
              children: [
                const Icon(Icons.assignment_outlined),
                Positioned(
                  right: 0,
                  top: 0,
                  child: Container(
                    width: 7,
                    height: 7,
                    decoration: const BoxDecoration(
                      color: Colors.orange,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ],
            ),
            label: 'Requests',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.more_horiz),
            label: 'More',
          ),
        ],
      ),
    );
  }

  Widget _buildMetricCard(BuildContext context, String title, String value, String subtext, IconData icon, Color subColor) {
    return InkWell(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => PlaceholderScreen(title: title)));
      },
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFFE2E8F0)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontSize: 11, color: Colors.grey, fontWeight: FontWeight.w500),
                ),
                Icon(icon, size: 16, color: const Color(0xFF0284C7)),
              ],
            ),
            Text(
              value,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
            ),
            Text(
              subtext,
              style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: subColor),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRequestCard({
    required BuildContext context,
    required String title,
    required String badgeLabel,
    required Color badgeBg,
    required Color badgeFg,
    required String subtitle,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0F172A),
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: badgeBg,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  badgeLabel,
                  style: TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.bold,
                    color: badgeFg,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: const TextStyle(fontSize: 11, color: Colors.grey),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              InkWell(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const PlaceholderScreen(title: 'Reject Request')));
                },
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF1F5F9),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.close, size: 16, color: Colors.grey),
                ),
              ),
              const SizedBox(width: 8),
              SizedBox(
                height: 32,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0284C7),
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    elevation: 0,
                  ),
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const PlaceholderScreen(title: 'Approve Request')));
                  },
                  icon: const Icon(Icons.check, size: 14, color: Colors.white),
                  label: const Text('Approve', style: TextStyle(fontSize: 12, color: Colors.white, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
