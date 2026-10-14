import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/member.dart';
import '../../providers/library_data_provider.dart';
import '../../widgets/accessibility_toolbar.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/status_chip.dart';

class MemberManagementScreen extends StatefulWidget {
  const MemberManagementScreen({super.key});

  @override
  State<MemberManagementScreen> createState() => _MemberManagementScreenState();
}

class _MemberManagementScreenState extends State<MemberManagementScreen> {
  String _searchQuery = '';

  void _showAddMemberDialog(BuildContext context) {
    final data = Provider.of<LibraryDataProvider>(context, listen: false);
    final nameCtrl = TextEditingController();
    final emailCtrl = TextEditingController();
    final idCtrl = TextEditingController();
    final deptCtrl = TextEditingController();
    final phoneCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Register New Member'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomTextField(controller: nameCtrl, label: 'Full Name', prefixIcon: Icons.person),
              const SizedBox(height: 10),
              CustomTextField(controller: emailCtrl, label: 'Email Address', prefixIcon: Icons.email, keyboardType: TextInputType.emailAddress),
              const SizedBox(height: 10),
              CustomTextField(controller: idCtrl, label: 'Student / Employee ID', prefixIcon: Icons.badge),
              const SizedBox(height: 10),
              CustomTextField(controller: deptCtrl, label: 'Department', prefixIcon: Icons.school),
              const SizedBox(height: 10),
              CustomTextField(controller: phoneCtrl, label: 'Phone Number', prefixIcon: Icons.phone, keyboardType: TextInputType.phone),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              if (nameCtrl.text.isNotEmpty && idCtrl.text.isNotEmpty) {
                data.addMember(Member(
                  id: 'mem_${DateTime.now().millisecondsSinceEpoch}',
                  name: nameCtrl.text,
                  email: emailCtrl.text,
                  studentId: idCtrl.text,
                  department: deptCtrl.text,
                  phone: phoneCtrl.text,
                  isActive: true,
                ));
                Navigator.pop(ctx);
              }
            },
            child: const Text('Register'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final data = Provider.of<LibraryDataProvider>(context);
    final filteredMembers = data.members.where((m) {
      final query = _searchQuery.toLowerCase();
      return m.name.toLowerCase().contains(query) ||
          m.studentId.toLowerCase().contains(query) ||
          m.department.toLowerCase().contains(query);
    }).toList();

    return Scaffold(
      appBar: const AccessibilityToolbar(title: 'Member Management'),
      floatingActionButton: FloatingActionButton.extended(
        icon: const Icon(Icons.person_add),
        label: const Text('Add Member'),
        onPressed: () => _showAddMemberDialog(context),
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search by name, ID, or department...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(icon: const Icon(Icons.clear), onPressed: () => setState(() => _searchQuery = ''))
                    : null,
              ),
              onChanged: (val) => setState(() => _searchQuery = val),
            ),
          ),

          // Member List
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.only(left: 12, right: 12, bottom: 80),
              itemCount: filteredMembers.length,
              itemBuilder: (context, index) {
                final member = filteredMembers[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 10),
                  child: ExpansionTile(
                    leading: CircleAvatar(
                      backgroundColor: member.isActive ? Colors.teal : Colors.grey,
                      child: Text(
                        member.name.isNotEmpty ? member.name[0] : 'U',
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                    title: Row(
                      children: [
                        Expanded(
                          child: Text(
                            member.name,
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                        ),
                        member.isActive ? StatusChip.active() : StatusChip.inactive(),
                      ],
                    ),
                    subtitle: Text('ID: ${member.studentId} | Dept: ${member.department}'),
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(children: [const Icon(Icons.email, size: 16), const SizedBox(width: 8), Text(member.email)]),
                            const SizedBox(height: 6),
                            Row(children: [const Icon(Icons.phone, size: 16), const SizedBox(width: 8), Text(member.phone)]),
                            const SizedBox(height: 12),

                            // Active / Inactive Status Toggle (FR3)
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Account Status: ${member.isActive ? "Active" : "Disabled/Inactive"}',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: member.isActive ? Colors.green : Colors.red,
                                  ),
                                ),
                                Switch(
                                  value: member.isActive,
                                  activeTrackColor: Colors.teal,
                                  onChanged: (val) {
                                    data.toggleMemberStatus(member.id);
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
