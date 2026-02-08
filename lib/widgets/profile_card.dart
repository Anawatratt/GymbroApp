import 'package:flutter/material.dart';

/// ProfileCard: shows avatar initials, name, and selection state.
class ProfileCard extends StatelessWidget {
  final String name;
  final String initials;
  final bool selected;
  final VoidCallback? onTap;

  const ProfileCard({
    super.key,
    required this.name,
    required this.initials,
    this.selected = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: selected ? Colors.indigo[50] : Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 6,
              offset: const Offset(0, 4),
            ),
          ],
          border: selected
              ? Border.all(color: Colors.indigo, width: 1.2)
              : null,
        ),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: Colors.indigo,
              child: Text(
                initials,
                style: const TextStyle(color: Colors.white),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                name,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
            if (selected) const Icon(Icons.check_circle, color: Colors.indigo),
          ],
        ),
      ),
    );
  }
}
