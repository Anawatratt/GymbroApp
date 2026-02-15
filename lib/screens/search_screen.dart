import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: const Color(0xFFF5F5F5),
        appBar: AppBar(
          title: const Text('Search'),
          bottom: const TabBar(
            labelColor: Color(0xFF3F51B5),
            unselectedLabelColor: Colors.grey,
            indicatorColor: Color(0xFF3F51B5),
            labelStyle: TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
            tabs: [
              Tab(icon: Icon(Icons.fitness_center, size: 20), text: 'Exercises'),
              Tab(icon: Icon(Icons.precision_manufacturing, size: 20), text: 'Machines'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            _ExercisesTab(),
            _MachinesTab(),
          ],
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════
// Exercises Tab
// ═══════════════════════════════════════════════════════════

class _ExercisesTab extends StatefulWidget {
  const _ExercisesTab();

  @override
  State<_ExercisesTab> createState() => _ExercisesTabState();
}

class _ExercisesTabState extends State<_ExercisesTab> {
  String _query = '';
  String? _selectedMuscleGroup;
  String? _selectedDifficulty;
  String? _selectedMovement;

  final _muscleGroups = ['All', 'Chest', 'Back', 'Shoulders', 'Arms', 'Legs', 'Core'];
  final _difficulties = ['All', 'beginner', 'intermediate', 'advanced'];
  final _movements = ['All', 'compound', 'isolated'];

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Column(
      children: [
        // Search bar
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 14, 20, 0),
          child: _SearchBar(
            hint: 'Search exercises...',
            onChanged: (v) => setState(() => _query = v),
          ),
        ),
        const SizedBox(height: 10),

        // Filters
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: SizedBox(
            height: 40,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                _FilterChip(
                  label: 'Muscle',
                  icon: Icons.sports_gymnastics,
                  items: _muscleGroups,
                  selected: _selectedMuscleGroup,
                  onChanged: (v) => setState(() => _selectedMuscleGroup = v),
                ),
                const SizedBox(width: 8),
                _FilterChip(
                  label: 'Difficulty',
                  icon: Icons.speed,
                  items: _difficulties,
                  selected: _selectedDifficulty,
                  onChanged: (v) => setState(() => _selectedDifficulty = v),
                  displayTransform: _capitalize,
                ),
                const SizedBox(width: 8),
                _FilterChip(
                  label: 'Movement',
                  icon: Icons.swap_horiz,
                  items: _movements,
                  selected: _selectedMovement,
                  onChanged: (v) => setState(() => _selectedMovement = v),
                  displayTransform: _capitalize,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 10),

        // Results
        Expanded(
          child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance.collection('exercises').snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return const Center(child: Text('No exercises found'));
              }

              final docs = snapshot.data!.docs.where((doc) {
                final data = doc.data() as Map<String, dynamic>;
                final name = (data['exercise_name'] ?? '') as String;
                final matchQuery = _query.isEmpty ||
                    name.toLowerCase().contains(_query.toLowerCase());

                final muscles = data['muscle_involvements'] as List<dynamic>? ?? [];
                final primaryMuscleIds = muscles
                    .where((m) => m['involvement'] == 'primary')
                    .map((m) => m['muscle_id'] as String)
                    .toList();
                final matchMuscle = _selectedMuscleGroup == null ||
                    _selectedMuscleGroup == 'All' ||
                    _muscleInGroup(primaryMuscleIds, _selectedMuscleGroup!);

                final matchDiff = _selectedDifficulty == null ||
                    _selectedDifficulty == 'All' ||
                    data['difficulty_level'] == _selectedDifficulty;

                final matchMove = _selectedMovement == null ||
                    _selectedMovement == 'All' ||
                    data['movement_type'] == _selectedMovement;

                return matchQuery && matchMuscle && matchDiff && matchMove;
              }).toList();

              if (docs.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.search_off, size: 48, color: Colors.grey[300]),
                      const SizedBox(height: 8),
                      Text('No matching exercises',
                          style: TextStyle(color: Colors.grey[400], fontSize: 15)),
                    ],
                  ),
                );
              }

              return ListView.separated(
                padding: const EdgeInsets.fromLTRB(20, 4, 20, 20),
                itemCount: docs.length,
                separatorBuilder: (_, __) => const SizedBox(height: 8),
                itemBuilder: (context, index) {
                  final data = docs[index].data() as Map<String, dynamic>;
                  return _ExerciseCard(data: data);
                },
              );
            },
          ),
        ),
      ],
    ),
    );
  }

  bool _muscleInGroup(List<String> muscleIds, String group) {
    const groupMap = {
      'Chest': ['pectoralis_major', 'pectoralis_minor'],
      'Back': ['latissimus_dorsi', 'trapezius', 'rhomboids', 'erector_spinae'],
      'Shoulders': ['anterior_deltoid', 'lateral_deltoid', 'posterior_deltoid'],
      'Arms': ['biceps_brachii', 'triceps_brachii', 'brachialis', 'forearm_flexors', 'forearm_extensors'],
      'Legs': ['quadriceps', 'hamstrings', 'glutes', 'calves', 'adductors'],
      'Core': ['rectus_abdominis', 'obliques', 'transverse_abdominis'],
    };
    final ids = groupMap[group] ?? [];
    return muscleIds.any((id) => ids.contains(id));
  }
}

// ═══════════════════════════════════════════════════════════
// Machines Tab
// ═══════════════════════════════════════════════════════════

class _MachinesTab extends StatefulWidget {
  const _MachinesTab();

  @override
  State<_MachinesTab> createState() => _MachinesTabState();
}

class _MachinesTabState extends State<_MachinesTab> {
  String _query = '';
  String? _selectedMachineType;

  final _machineTypes = ['All', 'free_weight', 'machine', 'cable', 'bodyweight'];

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Column(
      children: [
        // Search bar
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 14, 20, 0),
          child: _SearchBar(
            hint: 'Search machines...',
            onChanged: (v) => setState(() => _query = v),
          ),
        ),
        const SizedBox(height: 10),

        // Filters
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: SizedBox(
            height: 40,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                _FilterChip(
                  label: 'Type',
                  icon: Icons.category,
                  items: _machineTypes,
                  selected: _selectedMachineType,
                  onChanged: (v) => setState(() => _selectedMachineType = v),
                  displayTransform: _formatSnakeCase,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 10),

        // Results
        Expanded(
          child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance.collection('machines').snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return const Center(child: Text('No machines found'));
              }

              final docs = snapshot.data!.docs.where((doc) {
                final data = doc.data() as Map<String, dynamic>;
                final name = (data['machine_name'] ?? '') as String;
                final matchQuery = _query.isEmpty ||
                    name.toLowerCase().contains(_query.toLowerCase());

                final matchType = _selectedMachineType == null ||
                    _selectedMachineType == 'All' ||
                    data['machine_type'] == _selectedMachineType;

                return matchQuery && matchType;
              }).toList();

              if (docs.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.search_off, size: 48, color: Colors.grey[300]),
                      const SizedBox(height: 8),
                      Text('No matching machines',
                          style: TextStyle(color: Colors.grey[400], fontSize: 15)),
                    ],
                  ),
                );
              }

              return ListView.separated(
                padding: const EdgeInsets.fromLTRB(20, 4, 20, 20),
                itemCount: docs.length,
                separatorBuilder: (_, __) => const SizedBox(height: 8),
                itemBuilder: (context, index) {
                  final data = docs[index].data() as Map<String, dynamic>;
                  return _MachineCard(data: data);
                },
              );
            },
          ),
        ),
      ],
    ),
    );
  }
}

// ═══════════════════════════════════════════════════════════
// Shared Widgets
// ═══════════════════════════════════════════════════════════

class _SearchBar extends StatelessWidget {
  final String hint;
  final ValueChanged<String> onChanged;

  const _SearchBar({required this.hint, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
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
        onChanged: onChanged,
        decoration: InputDecoration(
          hintText: hint,
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
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final IconData icon;
  final List<String> items;
  final String? selected;
  final ValueChanged<String?> onChanged;
  final String Function(String)? displayTransform;

  const _FilterChip({
    required this.label,
    required this.icon,
    required this.items,
    required this.selected,
    required this.onChanged,
    this.displayTransform,
  });

  @override
  Widget build(BuildContext context) {
    final isActive = selected != null && selected != 'All';
    return PopupMenuButton<String>(
      onSelected: onChanged,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      itemBuilder: (context) => items
          .map((item) => PopupMenuItem(
                value: item,
                child: Text(displayTransform != null ? displayTransform!(item) : item),
              ))
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
              isActive
                  ? (displayTransform != null ? displayTransform!(selected!) : selected!)
                  : label,
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

// ═══════════════════════════════════════════════════════════
// Exercise Card
// ═══════════════════════════════════════════════════════════

class _ExerciseCard extends StatelessWidget {
  final Map<String, dynamic> data;

  const _ExerciseCard({required this.data});

  @override
  Widget build(BuildContext context) {
    final name = data['exercise_name'] ?? '';
    final diff = data['difficulty_level'] ?? '';
    final moveType = data['movement_type'] ?? '';
    final isCompound = data['is_compound'] == true;
    final muscles = data['muscle_involvements'] as List<dynamic>? ?? [];
    final primaryMuscles = muscles
        .where((m) => m['involvement'] == 'primary')
        .map((m) => _formatSnakeCase(m['muscle_id'] as String))
        .toList();

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        _showExerciseDetail(context);
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(12),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            // Icon — monochrome, no background box
            Icon(
              isCompound ? Icons.fitness_center : Icons.track_changes,
              size: 28,
              color: Colors.grey[700],
            ),
            const SizedBox(width: 14),
            // Text area
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name,
                      style: const TextStyle(
                          fontSize: 15, fontWeight: FontWeight.w700)),
                  const SizedBox(height: 4),
                  Text(
                    primaryMuscles.join(', '),
                    style: TextStyle(color: Colors.grey[500], fontSize: 13),
                  ),
                  const SizedBox(height: 8),
                  // Metadata chips — muted, pill-style
                  Row(
                    children: [
                      _mutedPill(_capitalize(diff)),
                      const SizedBox(width: 6),
                      _mutedPill(_capitalize(moveType)),
                    ],
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right, color: Colors.grey[350], size: 22),
          ],
        ),
      ),
    );
  }

  Widget _mutedPill(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: Colors.grey[600],
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  void _showExerciseDetail(BuildContext context) {
    final name = data['exercise_name'] ?? '';
    final desc = data['description'] ?? '';
    final diff = data['difficulty_level'] ?? '';
    final pattern = data['movement_pattern'] ?? '';
    final muscles = data['muscle_involvements'] as List<dynamic>? ?? [];
    final machines = data['machines'] as List<dynamic>? ?? [];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.55,
        minChildSize: 0.3,
        maxChildSize: 0.85,
        expand: false,
        builder: (context, scrollController) => ListView(
          controller: scrollController,
          padding: const EdgeInsets.all(24),
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(name,
                style: const TextStyle(
                    fontSize: 22, fontWeight: FontWeight.w800)),
            const SizedBox(height: 6),
            Text(desc,
                style: TextStyle(color: Colors.grey[600], fontSize: 14)),
            const SizedBox(height: 12),
            Row(
              children: [
                _mutedPill(_capitalize(diff)),
                const SizedBox(width: 8),
                _mutedPill(_formatSnakeCase(pattern)),
              ],
            ),
            const SizedBox(height: 20),
            const Text('Muscles',
                style: TextStyle(
                    fontSize: 16, fontWeight: FontWeight.w700)),
            const SizedBox(height: 8),
            ...muscles.map((m) {
              final pct = m['activation_pct'] ?? 0;
              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  children: [
                    SizedBox(
                      width: 120,
                      child: Text(
                        _formatSnakeCase(m['muscle_id']),
                        style: const TextStyle(fontSize: 13),
                      ),
                    ),
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: LinearProgressIndicator(
                          value: pct / 100,
                          minHeight: 8,
                          backgroundColor: Colors.grey[200],
                          valueColor: AlwaysStoppedAnimation(
                            _involvementColor(m['involvement']),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text('$pct%',
                        style: TextStyle(
                            fontSize: 12, color: Colors.grey[600])),
                  ],
                ),
              );
            }),
            if (machines.isNotEmpty) ...[
              const SizedBox(height: 16),
              const Text('Machines',
                  style: TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w700)),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: machines.map<Widget>((m) {
                  final id = m['machine_id'] as String;
                  return Chip(
                    label: Text(_formatSnakeCase(id),
                        style: const TextStyle(fontSize: 13)),
                    backgroundColor: Colors.grey[100],
                  );
                }).toList(),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Color _involvementColor(String involvement) {
    switch (involvement) {
      case 'primary':
        return const Color(0xFF3F51B5);
      case 'secondary':
        return const Color(0xFF00897B);
      case 'stabilizer':
        return const Color(0xFFFF9800);
      default:
        return Colors.grey;
    }
  }
}

// ═══════════════════════════════════════════════════════════
// Machine Card
// ═══════════════════════════════════════════════════════════

class _MachineCard extends StatelessWidget {
  final Map<String, dynamic> data;

  const _MachineCard({required this.data});

  IconData _typeIcon(String type) {
    switch (type) {
      case 'free_weight':
        return Icons.fitness_center;
      case 'machine':
        return Icons.precision_manufacturing;
      case 'cable':
        return Icons.cable;
      case 'bodyweight':
        return Icons.self_improvement;
      default:
        return Icons.devices_other;
    }
  }

  @override
  Widget build(BuildContext context) {
    final name = data['machine_name'] ?? '';
    final type = data['machine_type'] ?? '';
    final desc = data['description'] ?? '';

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(12),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          // Icon — monochrome, no background box
          Icon(_typeIcon(type), size: 28, color: Colors.grey[700]),
          const SizedBox(width: 14),
          // Text area
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name,
                    style: const TextStyle(
                        fontSize: 15, fontWeight: FontWeight.w700)),
                const SizedBox(height: 4),
                Text(desc,
                    style: TextStyle(color: Colors.grey[500], fontSize: 13),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis),
                const SizedBox(height: 8),
                // Metadata chip — muted, pill-style
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    _formatSnakeCase(type),
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════
// Helpers
// ═══════════════════════════════════════════════════════════

String _capitalize(String s) =>
    s.isEmpty ? s : s[0].toUpperCase() + s.substring(1);

String _formatSnakeCase(String s) {
  if (s == 'All') return s;
  return s.split('_').map((w) => w.isEmpty ? w : w[0].toUpperCase() + w.substring(1)).join(' ');
}
