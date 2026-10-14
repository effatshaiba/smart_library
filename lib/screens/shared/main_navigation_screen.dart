import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/library_data_provider.dart';

// Admin Screens
import '../admin/admin_dashboard_screen.dart';
import '../admin/catalog_management_screen.dart';
import '../admin/member_management_screen.dart';
import '../admin/circulation_screen.dart';
import '../admin/reservation_management_screen.dart';
import '../admin/fine_management_screen.dart';
import '../admin/global_history_screen.dart';
import '../admin/admin_reports_screen.dart';

// Member Screens
import '../member/member_dashboard_screen.dart';
import '../member/book_catalog_screen.dart';
import '../member/my_borrows_screen.dart';
import '../member/my_reservations_screen.dart';
import '../member/my_fines_history_screen.dart';
import '../member/member_profile_screen.dart';

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    final data = Provider.of<LibraryDataProvider>(context);

    if (auth.isAdmin) {
      // Admin Bottom Navigation Items
      final List<Widget> adminScreens = [
        const AdminDashboardScreen(),
        const CatalogManagementScreen(),
        const CirculationScreen(),
        const MemberManagementScreen(),
      ];

      return Scaffold(
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              UserAccountsDrawerHeader(
                accountName: Text(auth.currentUser?.name ?? 'Admin'),
                accountEmail: Text(auth.currentUser?.email ?? 'admin@library.edu'),
                currentAccountPicture: const CircleAvatar(
                  backgroundColor: Colors.white,
                  child: Icon(Icons.admin_panel_settings, size: 36, color: Colors.deepPurple),
                ),
                decoration: const BoxDecoration(color: Colors.deepPurple),
              ),
              ListTile(
                leading: const Icon(Icons.dashboard),
                title: const Text('Admin Dashboard'),
                onTap: () {
                  Navigator.pop(context);
                  setState(() => _selectedIndex = 0);
                },
              ),
              ListTile(
                leading: const Icon(Icons.library_books),
                title: const Text('Catalog & Inventory'),
                onTap: () {
                  Navigator.pop(context);
                  setState(() => _selectedIndex = 1);
                },
              ),
              ListTile(
                leading: const Icon(Icons.sync_alt),
                title: const Text('Circulation (Issue/Return)'),
                onTap: () {
                  Navigator.pop(context);
                  setState(() => _selectedIndex = 2);
                },
              ),
              ListTile(
                leading: const Icon(Icons.people),
                title: const Text('Member Management'),
                onTap: () {
                  Navigator.pop(context);
                  setState(() => _selectedIndex = 3);
                },
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.bookmark),
                title: const Text('Reservation Holds'),
                trailing: Chip(label: Text('${data.pendingReservations}')),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const ReservationManagementScreen()),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.monetization_on),
                title: const Text('Fine Management'),
                trailing: Chip(label: Text('৳${data.totalPendingFines.toInt()}')),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const FineManagementScreen()),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.history),
                title: const Text('Global Borrow History'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const GlobalHistoryScreen()),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.picture_as_pdf),
                title: const Text('Reports Generation'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const AdminReportsScreen()),
                  );
                },
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.swap_horiz, color: Colors.teal),
                title: const Text('Switch to Member View'),
                onTap: () {
                  Navigator.pop(context);
                  auth.switchToMember();
                },
              ),
            ],
          ),
        ),
        body: IndexedStack(
          index: _selectedIndex,
          children: adminScreens,
        ),
        bottomNavigationBar: NavigationBar(
          selectedIndex: _selectedIndex,
          onDestinationSelected: (idx) => setState(() => _selectedIndex = idx),
          destinations: const [
            NavigationDestination(icon: Icon(Icons.dashboard_outlined), selectedIcon: Icon(Icons.dashboard), label: 'Dashboard'),
            NavigationDestination(icon: Icon(Icons.menu_book_outlined), selectedIcon: Icon(Icons.menu_book), label: 'Catalog'),
            NavigationDestination(icon: Icon(Icons.sync_alt), selectedIcon: Icon(Icons.sync), label: 'Circulation'),
            NavigationDestination(icon: Icon(Icons.people_outline), selectedIcon: Icon(Icons.people), label: 'Members'),
          ],
        ),
      );
    } else {
      // Member Bottom Navigation Items
      final List<Widget> memberScreens = [
        const MemberDashboardScreen(),
        const BookCatalogScreen(),
        const MyBorrowsScreen(),
        const MemberProfileScreen(),
      ];

      return Scaffold(
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              UserAccountsDrawerHeader(
                accountName: Text(auth.currentUser?.name ?? 'Member'),
                accountEmail: Text(auth.currentUser?.email ?? 'member@smuct.edu.bd'),
                currentAccountPicture: const CircleAvatar(
                  backgroundColor: Colors.white,
                  child: Icon(Icons.person, size: 36, color: Colors.teal),
                ),
                decoration: const BoxDecoration(color: Colors.teal),
              ),
              ListTile(
                leading: const Icon(Icons.dashboard),
                title: const Text('Member Dashboard'),
                onTap: () {
                  Navigator.pop(context);
                  setState(() => _selectedIndex = 0);
                },
              ),
              ListTile(
                leading: const Icon(Icons.search),
                title: const Text('Search Catalog'),
                onTap: () {
                  Navigator.pop(context);
                  setState(() => _selectedIndex = 1);
                },
              ),
              ListTile(
                leading: const Icon(Icons.book),
                title: const Text('My Borrowed Books'),
                onTap: () {
                  Navigator.pop(context);
                  setState(() => _selectedIndex = 2);
                },
              ),
              ListTile(
                leading: const Icon(Icons.bookmark_border),
                title: const Text('My Reservations'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const MyReservationsScreen()),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.history),
                title: const Text('My Fines & History'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const MyFinesHistoryScreen()),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.account_circle),
                title: const Text('Profile Settings'),
                onTap: () {
                  Navigator.pop(context);
                  setState(() => _selectedIndex = 3);
                },
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.swap_horiz, color: Colors.deepPurple),
                title: const Text('Switch to Admin View'),
                onTap: () {
                  Navigator.pop(context);
                  auth.switchToAdmin();
                },
              ),
            ],
          ),
        ),
        body: IndexedStack(
          index: _selectedIndex,
          children: memberScreens,
        ),
        bottomNavigationBar: NavigationBar(
          selectedIndex: _selectedIndex,
          onDestinationSelected: (idx) => setState(() => _selectedIndex = idx),
          destinations: const [
            NavigationDestination(icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home), label: 'Home'),
            NavigationDestination(icon: Icon(Icons.search_outlined), selectedIcon: Icon(Icons.search), label: 'Catalog'),
            NavigationDestination(icon: Icon(Icons.auto_stories_outlined), selectedIcon: Icon(Icons.auto_stories), label: 'Borrows'),
            NavigationDestination(icon: Icon(Icons.person_outline), selectedIcon: Icon(Icons.person), label: 'Profile'),
          ],
        ),
      );
    }
  }
}
