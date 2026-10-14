import 'package:flutter/material.dart';

class StatusChip extends StatelessWidget {
  final String label;
  final Color color;
  final IconData? icon;

  const StatusChip({
    super.key,
    required this.label,
    required this.color,
    this.icon,
  });

  factory StatusChip.available() => const StatusChip(label: 'Available', color: Colors.green, icon: Icons.check_circle_outline);
  factory StatusChip.outOfStock() => const StatusChip(label: 'Out of Stock', color: Colors.orange, icon: Icons.hourglass_empty);
  factory StatusChip.issued() => const StatusChip(label: 'Issued', color: Colors.blue, icon: Icons.menu_book);
  factory StatusChip.requested() => const StatusChip(label: 'Requested', color: Colors.purple, icon: Icons.pending_actions);
  factory StatusChip.returned() => const StatusChip(label: 'Returned', color: Colors.teal, icon: Icons.assignment_turned_in);
  factory StatusChip.overdue() => const StatusChip(label: 'Overdue', color: Colors.red, icon: Icons.warning_amber_rounded);
  factory StatusChip.active() => const StatusChip(label: 'Active', color: Colors.green, icon: Icons.verified_user);
  factory StatusChip.inactive() => const StatusChip(label: 'Inactive', color: Colors.grey, icon: Icons.block);
  factory StatusChip.pending() => const StatusChip(label: 'Pending', color: Colors.amber, icon: Icons.access_time);
  factory StatusChip.collected() => const StatusChip(label: 'Collected', color: Colors.blue, icon: Icons.payments);
  factory StatusChip.waived() => const StatusChip(label: 'Waived', color: Colors.green, icon: Icons.check);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withAlpha(30),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withAlpha(100)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 14, color: color),
            const SizedBox(width: 4),
          ],
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
