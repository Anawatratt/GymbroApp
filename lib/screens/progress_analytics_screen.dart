import 'package:flutter/material.dart';

class ProgressAnalyticsScreen extends StatelessWidget {
  const ProgressAnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Progress')),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
        child: ListView(
          children: [
            const Text(
              'Training Analytics',
              style: TextStyle(
                  fontSize: 20, fontWeight: FontWeight.w800, color: Color(0xFF1A1A2E)),
            ),
            const SizedBox(height: 4),
            Text(
              'Your muscle group workload overview',
              style: TextStyle(color: Colors.grey[500], fontSize: 14),
            ),
            const SizedBox(height: 18),

            // Summary card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _SummaryItem(label: 'Total Sets', value: '1,240'),
                  Container(width: 1, height: 40, color: Colors.grey[200]),
                  _SummaryItem(label: 'Total Reps', value: '9,510'),
                  Container(width: 1, height: 40, color: Colors.grey[200]),
                  _SummaryItem(label: 'Calories', value: '14,200'),
                ],
              ),
            ),
            const SizedBox(height: 24),

            const Text(
              'Large Muscle Groups',
              style: TextStyle(
                  fontSize: 16, fontWeight: FontWeight.w700, color: Color(0xFF1A1A2E)),
            ),
            const SizedBox(height: 12),
            _ProgressBar(label: 'Chest', value: 0.75, color: Colors.redAccent),
            _ProgressBar(label: 'Back', value: 0.60, color: const Color(0xFF3F51B5)),
            _ProgressBar(label: 'Legs', value: 0.85, color: const Color(0xFF4CAF50)),
            const SizedBox(height: 20),

            Row(
              children: [
                const Text(
                  'Small Muscle Groups',
                  style: TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w700, color: Color(0xFF1A1A2E)),
                ),
                const Spacer(),
                TextButton(
                  onPressed: () =>
                      Navigator.pushNamed(context, '/progressBreakdown'),
                  child: const Text('See all'),
                ),
              ],
            ),
            const SizedBox(height: 8),
            _ProgressBar(label: 'Arms', value: 0.48, color: const Color(0xFFFF7043)),
            _ProgressBar(label: 'Core', value: 0.72, color: const Color(0xFF00897B)),
            _ProgressBar(label: 'Shoulders', value: 0.55, color: const Color(0xFF7E57C2)),
          ],
        ),
      ),
    );
  }
}

class _SummaryItem extends StatelessWidget {
  final String label;
  final String value;

  const _SummaryItem({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
              fontWeight: FontWeight.w800, fontSize: 18, color: Color(0xFF1A1A2E)),
        ),
        const SizedBox(height: 4),
        Text(label, style: TextStyle(color: Colors.grey[500], fontSize: 12)),
      ],
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
