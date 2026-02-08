import 'package:flutter/material.dart';

class SwitchProfileScreen extends StatefulWidget {
  const SwitchProfileScreen({super.key});

  @override
  State<SwitchProfileScreen> createState() => _SwitchProfileScreenState();
}

class _SwitchProfileScreenState extends State<SwitchProfileScreen> {
  final List<Map<String, String>> _profiles = [
    {'name': 'JJ', 'initials': 'JJ'},
    {'name': 'Sarah Johnson', 'initials': 'SJ'},
    {'name': 'Mike Chen', 'initials': 'MC'},
    {'name': 'Emily Davis', 'initials': 'ED'},
    {'name': 'David Kim', 'initials': 'DK'},
  ];

  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Switch Profile')),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Select a profile',
              style: TextStyle(color: Colors.grey[500], fontSize: 14),
            ),
            const SizedBox(height: 14),
            Expanded(
              child: ListView.separated(
                itemCount: _profiles.length,
                separatorBuilder: (_, __) => const SizedBox(height: 10),
                itemBuilder: (context, index) {
                  final p = _profiles[index];
                  final selected = index == _selectedIndex;
                  return GestureDetector(
                    onTap: () => setState(() => _selectedIndex = index),
                    child: Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: selected
                            ? const Color(0xFF3F51B5).withAlpha(15)
                            : Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: selected
                            ? Border.all(color: const Color(0xFF3F51B5))
                            : null,
                      ),
                      child: Row(
                        children: [
                          CircleAvatar(
                            backgroundColor: const Color(0xFF3F51B5),
                            child: Text(
                              p['initials']!,
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Text(
                              p['name']!,
                              style: const TextStyle(
                                  fontWeight: FontWeight.w600, fontSize: 15),
                            ),
                          ),
                          if (selected)
                            const Icon(Icons.check_circle,
                                color: Color(0xFF3F51B5)),
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
