import 'package:flutter/material.dart';

class ProgressBreakdownScreen extends StatelessWidget {
  const ProgressBreakdownScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Muscle Breakdown')),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
        child: ListView(
          children: [
            const Text(
              'Large Muscle Groups',
              style: TextStyle(
                  fontSize: 16, fontWeight: FontWeight.w700, color: Color(0xFF1A1A2E)),
            ),
            const SizedBox(height: 12),
            _ProgressBar(label: 'Chest', value: 0.75, color: Colors.redAccent),
            _ProgressBar(label: 'Back', value: 0.62, color: const Color(0xFF3F51B5)),
            _ProgressBar(label: 'Legs', value: 0.80, color: const Color(0xFF4CAF50)),
            _ProgressBar(label: 'Shoulders', value: 0.55, color: const Color(0xFF7E57C2)),
            const SizedBox(height: 20),

            const Text(
              'Small Muscle Groups',
              style: TextStyle(
                  fontSize: 16, fontWeight: FontWeight.w700, color: Color(0xFF1A1A2E)),
            ),
            const SizedBox(height: 12),
            _ProgressBar(label: 'Arms', value: 0.48, color: const Color(0xFFFF7043)),
            _ProgressBar(label: 'Core', value: 0.72, color: const Color(0xFF00897B)),
            _ProgressBar(label: 'Forearms', value: 0.35, color: const Color(0xFF5C6BC0)),
            _ProgressBar(label: 'Calves', value: 0.40, color: const Color(0xFFAB47BC)),
          ],
        ),
      ),
    );
  }
}

class _ProgressBar extends StatelessWidget {
  final String label;
  final double value;
  final Color color;

  const _ProgressBar({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label,
                  style: const TextStyle(
                      fontWeight: FontWeight.w600, fontSize: 14)),
              Text('${(value * 100).toInt()}%',
                  style: TextStyle(color: Colors.grey[500], fontSize: 13)),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: value,
              minHeight: 10,
              color: color,
              backgroundColor: color.withAlpha(30),
            ),
          ),
        ],
      ),
    );
  }
}
