import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../app_state.dart';

class ProgressBreakdownScreen extends ConsumerWidget {
  const ProgressBreakdownScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final trainee = ref.watch(appStateProvider).currentTrainee;
    final mp = trainee.muscleProgress;

    return Scaffold(
      appBar: AppBar(title: const Text('Muscle Breakdown')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
        children: [
          // ── Trainee context ──
          Row(
            children: [
              CircleAvatar(
                radius: 16,
                backgroundColor: trainee.avatarColor,
                child: Text(trainee.initials,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.w700)),
              ),
              const SizedBox(width: 10),
              Text("${trainee.name}'s Breakdown",
                  style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF1A1A2E))),
            ],
          ),
          const SizedBox(height: 20),

          // ── Large muscle groups ──
          Text('Large Muscle Groups',
              style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[600])),
          const SizedBox(height: 12),
          _ProgressBar(label: 'Chest', value: mp['Chest'] ?? 0, color: Colors.redAccent),
          _ProgressBar(label: 'Back', value: mp['Back'] ?? 0, color: const Color(0xFF3F51B5)),
          _ProgressBar(label: 'Legs', value: mp['Legs'] ?? 0, color: const Color(0xFF4CAF50)),
          _ProgressBar(label: 'Shoulders', value: mp['Shoulders'] ?? 0, color: const Color(0xFF7E57C2)),
          const SizedBox(height: 20),

          // ── Small muscle groups ──
          Text('Small Muscle Groups',
              style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[600])),
          const SizedBox(height: 12),
          _ProgressBar(label: 'Arms', value: mp['Arms'] ?? 0, color: const Color(0xFFFF7043)),
          _ProgressBar(label: 'Core', value: mp['Core'] ?? 0, color: const Color(0xFF00897B)),
          _ProgressBar(label: 'Forearms', value: mp['Forearms'] ?? 0, color: const Color(0xFF5C6BC0)),
          _ProgressBar(label: 'Calves', value: mp['Calves'] ?? 0, color: const Color(0xFFAB47BC)),
        ],
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
