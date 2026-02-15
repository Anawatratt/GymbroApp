import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../app_state.dart';

String _formatNum(int n) =>
    n.toString().replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+$)'), (m) => '${m[1]},');

class ProgressAnalyticsScreen extends ConsumerWidget {
  const ProgressAnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final trainee = ref.watch(appStateProvider).currentTrainee;
    final mp = trainee.muscleProgress;

    return Scaffold(
      appBar: AppBar(title: const Text('Progress')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
        children: [
          // ── Trainee identity banner ──
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: trainee.avatarColor.withAlpha(18),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: trainee.avatarColor.withAlpha(40)),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 22,
                  backgroundColor: trainee.avatarColor,
                  child: Text(trainee.initials,
                      style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 14)),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("${trainee.name}'s Progress",
                          style: const TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF1A1A2E))),
                      const SizedBox(height: 2),
                      Text('Training analytics overview',
                          style: TextStyle(
                              color: Colors.grey[500], fontSize: 13)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // ── Summary stats grid (2x2) ──
          Row(
            children: [
              Expanded(
                  child: _StatTile(
                      icon: Icons.fitness_center,
                      iconColor: const Color(0xFF3F51B5),
                      value: _formatNum(trainee.totalSets),
                      label: 'Total Sets')),
              const SizedBox(width: 12),
              Expanded(
                  child: _StatTile(
                      icon: Icons.repeat,
                      iconColor: const Color(0xFF00897B),
                      value: _formatNum(trainee.totalReps),
                      label: 'Total Reps')),
            ],
          ),
          const SizedBox(height: 28),

          // ── Large muscle groups ──
          _SectionHeader(title: 'Large Muscle Groups'),
          const SizedBox(height: 12),
          _ProgressBar(label: 'Chest', value: mp['Chest'] ?? 0, color: Colors.redAccent),
          _ProgressBar(label: 'Back', value: mp['Back'] ?? 0, color: const Color(0xFF3F51B5)),
          _ProgressBar(label: 'Legs', value: mp['Legs'] ?? 0, color: const Color(0xFF4CAF50)),
          const SizedBox(height: 20),

          // ── Small muscle groups ──
          Row(
            children: [
              const Expanded(child: _SectionHeader(title: 'Small Muscle Groups')),
              GestureDetector(
                onTap: () => Navigator.pushNamed(context, '/progressBreakdown'),
                child: Text('See all',
                    style: TextStyle(
                        color: Colors.grey[500],
                        fontSize: 13,
                        fontWeight: FontWeight.w500)),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _ProgressBar(label: 'Arms', value: mp['Arms'] ?? 0, color: const Color(0xFFFF7043)),
          _ProgressBar(label: 'Core', value: mp['Core'] ?? 0, color: const Color(0xFF00897B)),
          _ProgressBar(label: 'Shoulders', value: mp['Shoulders'] ?? 0, color: const Color(0xFF7E57C2)),
        ],
      ),
    );
  }
}

// ── Section header (read-only label) ────────────────────

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(title,
        style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            color: Color(0xFF1A1A2E)));
  }
}

// ── Stat tile (icon + value + label) ────────────────────

class _StatTile extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String value;
  final String label;

  const _StatTile({
    required this.icon,
    required this.iconColor,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: iconColor.withAlpha(20),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: iconColor, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(value,
                    style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF1A1A2E))),
                Text(label,
                    style: TextStyle(
                        color: Colors.grey[500], fontSize: 11)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Progress bar (read-only) ────────────────────────────

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
