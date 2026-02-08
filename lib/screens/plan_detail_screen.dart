import 'package:flutter/material.dart';
import '../mock_data.dart';

class PlanDetailScreen extends StatefulWidget {
  const PlanDetailScreen({super.key});

  @override
  State<PlanDetailScreen> createState() => _PlanDetailScreenState();
}

class _PlanDetailScreenState extends State<PlanDetailScreen> {
  final List<Map<String, dynamic>> _days = [
    {'day': 'Mon', 'date': 17},
    {'day': 'Tue', 'date': 18},
    {'day': 'Wed', 'date': 19},
    {'day': 'Thu', 'date': 20},
    {'day': 'Fri', 'date': 21},
    {'day': 'Sat', 'date': 22},
    {'day': 'Sun', 'date': 23},
  ];

  int _selectedDay = 2; // Wed
  final Map<int, bool> _completed = {};

  bool get _allDone =>
      mockExercises.isNotEmpty &&
      mockExercises.asMap().keys.every((i) => _completed[i] == true);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Workout Plan')),
      body: Column(
        children: [
          // Day selector
          Container(
            height: 88,
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _days.length,
              itemBuilder: (context, index) {
                final isSelected = index == _selectedDay;
                final d = _days[index];
                return GestureDetector(
                  onTap: () => setState(() => _selectedDay = index),
                  child: Container(
                    width: 56,
                    margin: const EdgeInsets.symmetric(horizontal: 6),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? const Color(0xFF3F51B5)
                          : Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: isSelected
                          ? [
                              BoxShadow(
                                color: const Color(0xFF3F51B5).withAlpha(40),
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              ),
                            ]
                          : null,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          d['day'] as String,
                          style: TextStyle(
                            color: isSelected ? Colors.white70 : Colors.grey[500],
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${d['date']}',
                          style: TextStyle(
                            color: isSelected ? Colors.white : const Color(0xFF1A1A2E),
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          // Exercise checklist
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
              itemCount: mockExercises.length,
              separatorBuilder: (_, __) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                final e = mockExercises[index];
                final isDone = _completed[index] ?? false;
                return Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: isDone
                        ? Border.all(
                            color: const Color(0xFF4CAF50).withAlpha(60))
                        : null,
                  ),
                  child: ListTile(
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    leading: Checkbox(
                      value: isDone,
                      activeColor: const Color(0xFF4CAF50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                      onChanged: (v) =>
                          setState(() => _completed[index] = v ?? false),
                    ),
                    title: Text(
                      e.name,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        decoration: isDone ? TextDecoration.lineThrough : null,
                        color: isDone ? Colors.grey[400] : const Color(0xFF1A1A2E),
                      ),
                    ),
                    subtitle: Text(
                      '${e.muscle}  ·  ${e.sets}',
                      style: TextStyle(color: Colors.grey[500], fontSize: 13),
                    ),
                    trailing: PopupMenuButton(
                      icon: Icon(Icons.more_vert, color: Colors.grey[400]),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      itemBuilder: (context) => [
                        const PopupMenuItem(value: 'edit', child: Text('Edit')),
                        const PopupMenuItem(
                            value: 'remove', child: Text('Remove')),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          // Bottom CTA
          Container(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha(8),
                  blurRadius: 8,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        for (var i = 0; i < mockExercises.length; i++) {
                          _completed[i] = true;
                        }
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _allDone
                          ? const Color(0xFF4CAF50)
                          : const Color(0xFF3F51B5),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: Text(
                      _allDone ? 'All Completed!' : 'Mark All Complete',
                      style: const TextStyle(fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                OutlinedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    side: BorderSide(color: Colors.grey.shade300),
                  ),
                  child: const Text(
                    '+ Edit',
                    style: TextStyle(fontWeight: FontWeight.w600),
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
