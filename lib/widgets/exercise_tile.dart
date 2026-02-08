import 'package:flutter/material.dart';

/// Exercise list tile used in Search and Plan Detail lists.
class ExerciseTile extends StatelessWidget {
  final String name;
  final String muscle;
  final String difficulty;
  final VoidCallback? onTap;

  const ExerciseTile({
    super.key,
    required this.name,
    required this.muscle,
    required this.difficulty,
    this.onTap,
  });

  Color _badgeColor(String difficulty) {
    switch (difficulty.toLowerCase()) {
      case 'beginner':
        return Colors.green.shade600;
      case 'intermediate':
        return Colors.orange.shade600;
      case 'advanced':
        return Colors.red.shade600;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      elevation: 0,
      child: ListTile(
        onTap: onTap,
        title: Text(name, style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text(muscle),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: _badgeColor(difficulty),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                difficulty,
                style: const TextStyle(color: Colors.white, fontSize: 12),
              ),
            ),
            const SizedBox(width: 8),
            const Icon(Icons.chevron_right),
          ],
        ),
      ),
    );
  }
}
