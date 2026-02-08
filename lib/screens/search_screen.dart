import 'package:flutter/material.dart';
import '../mock_data.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  String _query = '';
  String? _selectedMuscle;
  String? _selectedDifficulty;

  final List<String> _muscles = ['All', 'Chest', 'Back', 'Legs', 'Core', 'Shoulders', 'Arms'];
  final List<String> _difficulties = ['All', 'Beginner', 'Intermediate', 'Advanced'];

  List<Exercise> get _filtered {
    return mockExercises.where((e) {
      final matchQuery = _query.isEmpty ||
          e.name.toLowerCase().contains(_query.toLowerCase());
      final matchMuscle = _selectedMuscle == null ||
          _selectedMuscle == 'All' ||
          e.muscle == _selectedMuscle;
      final matchDiff = _selectedDifficulty == null ||
          _selectedDifficulty == 'All' ||
          e.difficulty == _selectedDifficulty;
      return matchQuery && matchMuscle && matchDiff;
    }).toList();
  }

  Color _badgeColor(String difficulty) {
    switch (difficulty.toLowerCase()) {
      case 'beginner':
        return const Color(0xFF4CAF50);
      case 'intermediate':
        return const Color(0xFFFF9800);
      case 'advanced':
        return const Color(0xFFF44336);
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final results = _filtered;

    return Scaffold(
      appBar: AppBar(title: const Text('Search')),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
        child: Column(
          children: [
            // Search bar
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlpha(8),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: TextField(
                onChanged: (v) => setState(() => _query = v),
                decoration: InputDecoration(
                  hintText: 'Search exercises...',
                  hintStyle: TextStyle(color: Colors.grey[400]),
                  prefixIcon: Icon(Icons.search, color: Colors.grey[400]),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(vertical: 14),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 14),

            // Filter chips
            SizedBox(
              height: 40,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  _buildFilterDropdown(
                    label: 'Muscle',
                    icon: Icons.sports_gymnastics,
                    items: _muscles,
                    selected: _selectedMuscle,
                    onChanged: (v) => setState(() => _selectedMuscle = v),
                  ),
                  const SizedBox(width: 8),
                  _buildFilterDropdown(
                    label: 'Difficulty',
                    icon: Icons.speed,
                    items: _difficulties,
                    selected: _selectedDifficulty,
                    onChanged: (v) => setState(() => _selectedDifficulty = v),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),

            // Results
            Expanded(
              child: ListView.separated(
                itemCount: results.length,
                separatorBuilder: (_, __) => const SizedBox(height: 8),
                itemBuilder: (context, index) {
                  final e = results[index];
                  return Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      leading: Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: _badgeColor(e.difficulty).withAlpha(25),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Icon(
                          Icons.fitness_center,
                          color: _badgeColor(e.difficulty),
                        ),
                      ),
                      title: Text(
                        e.name,
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                      subtitle: Text(
                        e.muscle,
                        style: TextStyle(
                            color: Colors.grey[500], fontSize: 13),
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            decoration: BoxDecoration(
                              color: _badgeColor(e.difficulty),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              e.difficulty,
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 11,
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Icon(Icons.chevron_right, color: Colors.grey[400]),
                        ],
                      ),
                      onTap: () {},
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

  Widget _buildFilterDropdown({
    required String label,
    required IconData icon,
    required List<String> items,
    required String? selected,
    required ValueChanged<String?> onChanged,
  }) {
    final isActive = selected != null && selected != 'All';
    return PopupMenuButton<String>(
      onSelected: onChanged,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      itemBuilder: (context) => items
          .map((item) => PopupMenuItem(value: item, child: Text(item)))
          .toList(),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? const Color(0xFF3F51B5) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isActive ? const Color(0xFF3F51B5) : Colors.grey.shade300,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16,
                color: isActive ? Colors.white : Colors.grey[600]),
            const SizedBox(width: 6),
            Text(
              isActive ? selected! : label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: isActive ? Colors.white : Colors.grey[700],
              ),
            ),
            const SizedBox(width: 4),
            Icon(Icons.keyboard_arrow_down, size: 18,
                color: isActive ? Colors.white : Colors.grey[600]),
          ],
        ),
      ),
    );
  }
}
