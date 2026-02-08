import 'package:flutter/material.dart';

void main() {
  runApp(const GymBroApp());
}

class GymBroApp extends StatelessWidget {
  const GymBroApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GymBro',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFFF6B35),
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFF1A1A2E),
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  final List<Widget> _pages = const [
    DashboardPage(),
    WorkoutPage(),
    HistoryPage(),
    ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) {
          setState(() => _currentIndex = index);
        },
        backgroundColor: const Color(0xFF16213E),
        indicatorColor: const Color(0xFFFF6B35).withAlpha(50),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.dashboard_outlined),
            selectedIcon: Icon(Icons.dashboard, color: Color(0xFFFF6B35)),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.fitness_center_outlined),
            selectedIcon: Icon(Icons.fitness_center, color: Color(0xFFFF6B35)),
            label: 'Workout',
          ),
          NavigationDestination(
            icon: Icon(Icons.history_outlined),
            selectedIcon: Icon(Icons.history, color: Color(0xFFFF6B35)),
            label: 'History',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outlined),
            selectedIcon: Icon(Icons.person, color: Color(0xFFFF6B35)),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

// ==================== DASHBOARD PAGE ====================
class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Welcome Back!',
                      style: TextStyle(color: Colors.grey[400], fontSize: 14),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'GymBro',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const CircleAvatar(
                  radius: 24,
                  backgroundColor: Color(0xFFFF6B35),
                  child: Icon(Icons.person, color: Colors.white),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Today's Stats
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFFF6B35), Color(0xFFFF8E53)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Today's Progress",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildStatItem('Calories', '420', 'kcal'),
                      _buildStatItem('Duration', '45', 'min'),
                      _buildStatItem('Exercises', '8', 'sets'),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Quick Actions
            const Text(
              'Quick Start',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildQuickAction(
                    context,
                    Icons.directions_run,
                    'Cardio',
                    const Color(0xFF00C9FF),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildQuickAction(
                    context,
                    Icons.fitness_center,
                    'Strength',
                    const Color(0xFFFF6B35),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildQuickAction(
                    context,
                    Icons.self_improvement,
                    'Yoga',
                    const Color(0xFF92FE9D),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Recent Workouts
            const Text(
              'Recent Workouts',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            _buildWorkoutCard('Chest & Triceps', '45 min', '320 kcal', Icons.fitness_center),
            const SizedBox(height: 10),
            _buildWorkoutCard('Leg Day', '60 min', '450 kcal', Icons.directions_run),
            const SizedBox(height: 10),
            _buildWorkoutCard('Back & Biceps', '50 min', '380 kcal', Icons.fitness_center),
          ],
        ),
      ),
    );
  }

  static Widget _buildStatItem(String label, String value, String unit) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          unit,
          style: TextStyle(color: Colors.white.withAlpha(180), fontSize: 12),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(color: Colors.white.withAlpha(200), fontSize: 14),
        ),
      ],
    );
  }

  Widget _buildQuickAction(
    BuildContext context,
    IconData icon,
    String label,
    Color color,
  ) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20),
        decoration: BoxDecoration(
          color: const Color(0xFF16213E),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withAlpha(80)),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(height: 8),
            Text(
              label,
              style: const TextStyle(color: Colors.white, fontSize: 13),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWorkoutCard(
    String title,
    String duration,
    String calories,
    IconData icon,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF16213E),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFFFF6B35).withAlpha(30),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: const Color(0xFFFF6B35)),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '$duration  |  $calories',
                  style: TextStyle(color: Colors.grey[500], fontSize: 13),
                ),
              ],
            ),
          ),
          Icon(Icons.chevron_right, color: Colors.grey[600]),
        ],
      ),
    );
  }
}

// ==================== WORKOUT PAGE ====================
class WorkoutPage extends StatelessWidget {
  const WorkoutPage({super.key});

  @override
  Widget build(BuildContext context) {
    final workouts = [
      {'name': 'Push Day', 'exercises': 'Bench Press, Shoulder Press, Tricep Dips', 'icon': Icons.fitness_center},
      {'name': 'Pull Day', 'exercises': 'Deadlift, Barbell Row, Bicep Curl', 'icon': Icons.fitness_center},
      {'name': 'Leg Day', 'exercises': 'Squat, Leg Press, Lunges', 'icon': Icons.directions_run},
      {'name': 'Cardio', 'exercises': 'Running, Jump Rope, Cycling', 'icon': Icons.directions_run},
      {'name': 'Core', 'exercises': 'Plank, Crunches, Leg Raises', 'icon': Icons.self_improvement},
    ];

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            const Text(
              'Workouts',
              style: TextStyle(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Choose your workout for today',
              style: TextStyle(color: Colors.grey[400], fontSize: 14),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.separated(
                itemCount: workouts.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final workout = workouts[index];
                  return GestureDetector(
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Starting ${workout['name']}...'),
                          backgroundColor: const Color(0xFFFF6B35),
                        ),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: const Color(0xFF16213E),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFF6B35).withAlpha(30),
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: Icon(
                              workout['icon'] as IconData,
                              color: const Color(0xFFFF6B35),
                              size: 28,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  workout['name'] as String,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  workout['exercises'] as String,
                                  style: TextStyle(color: Colors.grey[500], fontSize: 13),
                                ),
                              ],
                            ),
                          ),
                          const Icon(
                            Icons.play_circle_fill,
                            color: Color(0xFFFF6B35),
                            size: 36,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ==================== HISTORY PAGE ====================
class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final history = [
      {'day': 'Today', 'workout': 'Chest & Triceps', 'duration': '45 min', 'cal': '320'},
      {'day': 'Yesterday', 'workout': 'Leg Day', 'duration': '60 min', 'cal': '450'},
      {'day': 'Feb 4', 'workout': 'Back & Biceps', 'duration': '50 min', 'cal': '380'},
      {'day': 'Feb 3', 'workout': 'Cardio', 'duration': '30 min', 'cal': '280'},
      {'day': 'Feb 2', 'workout': 'Push Day', 'duration': '55 min', 'cal': '400'},
      {'day': 'Feb 1', 'workout': 'Core', 'duration': '25 min', 'cal': '150'},
    ];

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            const Text(
              'History',
              style: TextStyle(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Your workout history',
              style: TextStyle(color: Colors.grey[400], fontSize: 14),
            ),
            const SizedBox(height: 8),

            // Weekly summary
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF16213E),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildWeekStat('This Week', '5', 'workouts'),
                  Container(width: 1, height: 40, color: Colors.grey[700]),
                  _buildWeekStat('Total Time', '4.2', 'hours'),
                  Container(width: 1, height: 40, color: Colors.grey[700]),
                  _buildWeekStat('Burned', '1,980', 'kcal'),
                ],
              ),
            ),
            const SizedBox(height: 20),

            Expanded(
              child: ListView.separated(
                itemCount: history.length,
                separatorBuilder: (_, __) => const SizedBox(height: 10),
                itemBuilder: (context, index) {
                  final item = history[index];
                  return Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: const Color(0xFF16213E),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 50,
                          alignment: Alignment.center,
                          child: Text(
                            item['day']!,
                            style: const TextStyle(
                              color: Color(0xFFFF6B35),
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            item['workout']!,
                            style: const TextStyle(color: Colors.white, fontSize: 15),
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(item['duration']!, style: TextStyle(color: Colors.grey[400], fontSize: 12)),
                            Text('${item['cal']} kcal', style: TextStyle(color: Colors.grey[500], fontSize: 11)),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Widget _buildWeekStat(String label, String value, String unit) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
        ),
        Text(unit, style: TextStyle(color: Colors.grey[500], fontSize: 11)),
        const SizedBox(height: 2),
        Text(label, style: TextStyle(color: Colors.grey[400], fontSize: 11)),
      ],
    );
  }
}

// ==================== PROFILE PAGE ====================
class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 20),
            const CircleAvatar(
              radius: 50,
              backgroundColor: Color(0xFFFF6B35),
              child: Icon(Icons.person, size: 50, color: Colors.white),
            ),
            const SizedBox(height: 14),
            const Text(
              'GymBro User',
              style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text('Member since Feb 2026', style: TextStyle(color: Colors.grey[500], fontSize: 13)),
            const SizedBox(height: 24),

            // Stats Grid
            Row(
              children: [
                Expanded(child: _buildProfileStat('Workouts', '128')),
                const SizedBox(width: 12),
                Expanded(child: _buildProfileStat('Hours', '96')),
                const SizedBox(width: 12),
                Expanded(child: _buildProfileStat('Streak', '7 days')),
              ],
            ),
            const SizedBox(height: 24),

            _buildMenuItem(Icons.settings_outlined, 'Settings'),
            _buildMenuItem(Icons.bar_chart_outlined, 'Statistics'),
            _buildMenuItem(Icons.notifications_outlined, 'Notifications'),
            _buildMenuItem(Icons.help_outline, 'Help & Support'),
            _buildMenuItem(Icons.info_outline, 'About'),
          ],
        ),
      ),
    );
  }

  static Widget _buildProfileStat(String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 18),
      decoration: BoxDecoration(
        color: const Color(0xFF16213E),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: const TextStyle(color: Color(0xFFFF6B35), fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(label, style: TextStyle(color: Colors.grey[400], fontSize: 12)),
        ],
      ),
    );
  }

  static Widget _buildMenuItem(IconData icon, String label) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF16213E),
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: Icon(icon, color: Colors.grey[400]),
        title: Text(label, style: const TextStyle(color: Colors.white, fontSize: 15)),
        trailing: Icon(Icons.chevron_right, color: Colors.grey[600]),
      ),
    );
  }
}
