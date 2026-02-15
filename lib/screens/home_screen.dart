import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../app_state.dart';
import '../mock_data.dart';
import '../widgets/app_drawer.dart';

String _formatNum(int n) =>
    n.toString().replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+$)'), (m) => '${m[1]},');

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(appStateProvider);
    final trainee = state.currentTrainee;

    return Scaffold(
      key: _scaffoldKey,
      drawer: const AppDrawer(),
      drawerEnableOpenDragGesture: true,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top bar: menu + notification
              _TopBar(scaffoldKey: _scaffoldKey),
              const SizedBox(height: 24),
              // Mode-dependent content
              if (state.isOwnerMode)
                _OwnerHome(trainee: trainee)
              else
                _TraineeDashboard(trainee: trainee),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Top bar (shared) ────────────────────────────────────

class _TopBar extends StatelessWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;
  const _TopBar({required this.scaffoldKey});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: IconButton(
            icon: const Icon(Icons.menu_rounded),
            onPressed: () => scaffoldKey.currentState?.openDrawer(),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {},
          ),
        ),
      ],
    );
  }
}

// ── Owner mode: Full home with CTAs ─────────────────────

class _OwnerHome extends StatelessWidget {
  final Trainee trainee;
  const _OwnerHome({required this.trainee});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Hi ${trainee.name}',
          style: const TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w800,
            color: Color(0xFF1A1A2E),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Ready to workout today?',
          style: TextStyle(fontSize: 15, color: Colors.grey[500]),
        ),
        const SizedBox(height: 24),

        // Hero workout card
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            gradient: const LinearGradient(
              colors: [Color(0xFF283593), Color(0xFF5C6BC0)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Full Body\nWorkout',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        height: 1.3,
                      ),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () =>
                          Navigator.pushNamed(context, '/plans'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: const Color(0xFF283593),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 28, vertical: 12),
                      ),
                      child: const Text('Start',
                          style: TextStyle(fontWeight: FontWeight.w700)),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: Colors.white.withAlpha(40),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.fitness_center,
                    color: Colors.white, size: 36),
              ),
            ],
          ),
        ),
        const SizedBox(height: 28),

        // Today's Activity
        const Text(
          "Today's Activity",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: Color(0xFF1A1A2E),
          ),
        ),
        const SizedBox(height: 14),
        Row(
          children: [
            Expanded(
              child: _ActivityCard(
                icon: Icons.fitness_center,
                iconColor: const Color(0xFF3F51B5),
                value: '${trainee.totalSets}',
                unit: '',
                label: 'Total Sets',
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _ActivityCard(
                icon: Icons.repeat,
                iconColor: const Color(0xFF00897B),
                value: '${trainee.totalReps}',
                unit: '',
                label: 'Total Reps',
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _ActivityCard(
                icon: Icons.event_available,
                iconColor: const Color(0xFFFF7043),
                value: '${trainee.workoutsCompleted}',
                unit: '',
                label: 'Workouts',
              ),
            ),
          ],
        ),
      ],
    );
  }
}

// ── Trainee mode: Read-only dashboard ───────────────────

class _TraineeDashboard extends StatelessWidget {
  final Trainee trainee;
  const _TraineeDashboard({required this.trainee});

  @override
  Widget build(BuildContext context) {
    final mp = trainee.muscleProgress;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Trainee identity banner
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: trainee.avatarColor.withAlpha(18),
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
                            fontSize: 13, color: Colors.grey[500])),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),

        // Summary stats (2x2 grid)
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

        // Large muscle groups
        const Text('Large Muscle Groups',
            style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: Color(0xFF1A1A2E))),
        const SizedBox(height: 12),
        _ProgressBar(label: 'Chest', value: mp['Chest'] ?? 0, color: Colors.redAccent),
        _ProgressBar(label: 'Back', value: mp['Back'] ?? 0, color: const Color(0xFF3F51B5)),
        _ProgressBar(label: 'Legs', value: mp['Legs'] ?? 0, color: const Color(0xFF4CAF50)),
        const SizedBox(height: 20),

        // Small muscle groups
        Row(
          children: [
            const Expanded(
              child: Text('Small Muscle Groups',
                  style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF1A1A2E))),
            ),
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
        const SizedBox(height: 28),

        // Quick links (Notes & Workout Plan only — Progress is already inline)
        Text('Quick Access',
            style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Colors.grey[600])),
        const SizedBox(height: 12),
        _QuickLink(
          icon: Icons.calendar_month_rounded,
          title: 'Workout Plan',
          subtitle: 'View assigned plans',
          color: const Color(0xFF00897B),
          onTap: () => Navigator.pushNamed(context, '/plans'),
        ),
        const SizedBox(height: 10),
        _QuickLink(
          icon: Icons.sticky_note_2_rounded,
          title: 'Notes',
          subtitle: 'View & manage notes',
          color: const Color(0xFFFF7043),
          onTap: () => Navigator.pushNamed(context, '/notes'),
        ),
      ],
    );
  }
}

// ── Stat tile (for trainee dashboard) ───────────────────

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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: iconColor.withAlpha(20),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: iconColor, size: 20),
          ),
          const SizedBox(height: 12),
          Text(value,
              style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF1A1A2E))),
          Text(label,
              style: TextStyle(color: Colors.grey[500], fontSize: 12)),
        ],
      ),
    );
  }
}

// ── Quick link tile (navigation only) ───────────────────

class _QuickLink extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;

  const _QuickLink({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color.withAlpha(20),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 22),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF1A1A2E))),
                  Text(subtitle,
                      style: TextStyle(
                          fontSize: 12, color: Colors.grey[500])),
                ],
              ),
            ),
            Icon(Icons.chevron_right, color: Colors.grey[400], size: 22),
          ],
        ),
      ),
    );
  }
}

// ── Progress bar (trainee dashboard) ─────────────────────

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

// ── Activity card (owner mode only) ─────────────────────

class _ActivityCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String value;
  final String unit;
  final String label;

  const _ActivityCard({
    required this.icon,
    required this.iconColor,
    required this.value,
    required this.unit,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(8),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: iconColor.withAlpha(25),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: iconColor, size: 22),
          ),
          const SizedBox(height: 10),
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: value,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF1A1A2E),
                  ),
                ),
                if (unit.isNotEmpty)
                  TextSpan(
                    text: ' $unit',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey[500],
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(fontSize: 12, color: Colors.grey[500]),
          ),
        ],
      ),
    );
  }
}
