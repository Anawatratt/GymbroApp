import 'package:flutter/material.dart';

/// Plan card showing summary info and START button.
class PlanCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final int calories;
  final int duration;
  final int exercises;
  final VoidCallback? onStart;

  const PlanCard({
    super.key,
    required this.title,
    required this.icon,
    required this.calories,
    required this.duration,
    required this.exercises,
    this.onStart,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            CircleAvatar(
              radius: 28,
              backgroundColor: Colors.indigo[50],
              child: Icon(icon, color: Colors.indigo),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '$calories kcal • $duration min • $exercises ex',
                    style: const TextStyle(color: Colors.black54, fontSize: 13),
                  ),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: onStart,
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: const Text('START'),
            ),
          ],
        ),
      ),
    );
  }
}
