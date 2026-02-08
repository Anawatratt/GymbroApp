import 'package:flutter/material.dart';

/// ProgressBarItem: shows a label, numeric value and a horizontal progress bar.
class ProgressBarItem extends StatelessWidget {
  final String label;
  final double value; // 0..1
  final String valueLabel;
  final Color color;

  const ProgressBarItem({
    super.key,
    required this.label,
    required this.value,
    required this.valueLabel,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
              Text(valueLabel, style: const TextStyle(color: Colors.black54)),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: value,
              minHeight: 10,
              color: color,
              backgroundColor: color.withOpacity(0.16),
            ),
          ),
        ],
      ),
    );
  }
}
