import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_settings_provider.dart';
import '../providers/auth_provider.dart';

class AccessibilityToolbar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;

  const AccessibilityToolbar({
    super.key,
    required this.title,
    this.actions,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final settings = Provider.of<AppSettingsProvider>(context);
    final auth = Provider.of<AuthProvider>(context);

    return AppBar(
      title: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      actions: [
        if (actions != null) ...?actions,

        // Dark Mode "Moon" Toggle (FR14)
        IconButton(
          tooltip: settings.isDarkMode ? 'Switch to Light Mode' : 'Switch to Dark Mode (Moon)',
          icon: Icon(
            settings.isDarkMode ? Icons.wb_sunny : Icons.nightlight_round,
            color: settings.isDarkMode ? Colors.amber : Colors.indigo,
          ),
          onPressed: () => settings.toggleDarkMode(),
        ),

        // +10% Font Size Toggle Button (FR15)
        InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () => settings.toggleLargeFont(),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            margin: const EdgeInsets.symmetric(horizontal: 4),
            decoration: BoxDecoration(
              color: settings.isLargeFontEnabled
                  ? Theme.of(context).colorScheme.primaryContainer
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: settings.isLargeFontEnabled
                    ? Theme.of(context).colorScheme.primary
                    : Colors.grey.shade400,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.format_size, size: 18),
                const SizedBox(width: 2),
                Text(
                  '+10%',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: settings.isLargeFontEnabled ? FontWeight.bold : FontWeight.normal,
                    color: settings.isLargeFontEnabled
                        ? Theme.of(context).colorScheme.onPrimaryContainer
                        : null,
                  ),
                ),
              ],
            ),
          ),
        ),

        // Quick Role Switcher Popup
        PopupMenuButton<String>(
          tooltip: 'Switch User Role (Current: ${auth.isAdmin ? "Admin" : "Member"})',
          icon: CircleAvatar(
            radius: 14,
            backgroundColor: auth.isAdmin ? Colors.deepPurple : Colors.teal,
            child: Text(
              auth.isAdmin ? 'A' : 'M',
              style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
            ),
          ),
          onSelected: (role) {
            if (role == 'admin') {
              auth.switchToAdmin();
            } else if (role == 'member') {
              auth.switchToMember();
            } else if (role == 'logout') {
              auth.logout();
            }
          },
          itemBuilder: (context) => [
            PopupMenuItem(
              value: 'admin',
              child: Row(
                children: [
                  Icon(Icons.admin_panel_settings, color: auth.isAdmin ? Colors.deepPurple : Colors.grey),
                  const SizedBox(width: 8),
                  Text('Admin View ${auth.isAdmin ? "(Active)" : ""}'),
                ],
              ),
            ),
            PopupMenuItem(
              value: 'member',
              child: Row(
                children: [
                  Icon(Icons.person, color: auth.isMember ? Colors.teal : Colors.grey),
                  const SizedBox(width: 8),
                  Text('Member View ${auth.isMember ? "(Active)" : ""}'),
                ],
              ),
            ),
            const PopupMenuDivider(),
            const PopupMenuItem(
              value: 'logout',
              child: Row(
                children: [
                  Icon(Icons.logout, color: Colors.red),
                  SizedBox(width: 8),
                  Text('Log Out', style: TextStyle(color: Colors.red)),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(width: 8),
      ],
    );
  }
}
