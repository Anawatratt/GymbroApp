import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../app_state.dart';
import '../mock_data.dart';

class AppDrawer extends ConsumerWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final width = MediaQuery.of(context).size.width * 0.78;

    return Drawer(
      width: width,
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          topRight: Radius.circular(18),
          bottomRight: Radius.circular(18),
        ),
        child: Material(
          color: Colors.white,
          child: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _DrawerHeader(),
                const Divider(height: 1),
                // Main menu (adapts to mode)
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    children: [
                      _MenuItemTile(
                        icon: Icons.calendar_month_rounded,
                        title: 'Workout Plan',
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.pushNamed(context, '/plans');
                        },
                      ),
                      _MenuItemTile(
                        icon: Icons.search_rounded,
                        title: 'Search',
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.pushNamed(context, '/search');
                        },
                      ),
                      _MenuItemTile(
                        icon: Icons.bar_chart_rounded,
                        title: 'Progress',
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.pushNamed(context, '/progressAnalytics');
                        },
                      ),
                      _MenuItemTile(
                        icon: Icons.sticky_note_2_rounded,
                        title: 'Notes',
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.pushNamed(context, '/notes');
                        },
                      ),
                      _MenuItemTile(
                        icon: Icons.history_rounded,
                        title: 'Workout History',
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.pushNamed(context, '/workoutHistory');
                        },
                      ),
                    ],
                  ),
                ),
                // Trainee section — fixed at bottom
                const Divider(height: 1),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
                  child: Text('Trainee',
                      style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: Colors.grey[600])),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: _ProfileMiniCard(),
                ),
                const SizedBox(height: 8),
                const Divider(height: 1),
                // Footer
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextButton.icon(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon:
                              const Icon(Icons.logout, color: Colors.black54),
                          label: const Text('Logout',
                              style: TextStyle(color: Colors.black87)),
                          style: TextButton.styleFrom(
                            alignment: Alignment.centerLeft,
                          ),
                        ),
                      ),
                      Text('v1.0.0',
                          style: TextStyle(
                              color: Colors.grey[500], fontSize: 12)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _DrawerHeader extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(appStateProvider);
    final trainee = state.currentTrainee;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          CircleAvatar(
            radius: 28,
            backgroundColor: trainee.avatarColor,
            child: Text(trainee.initials,
                style: const TextStyle(
                    color: Colors.white, fontWeight: FontWeight.w600)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(trainee.name,
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.w800)),
                const SizedBox(height: 4),
                Text(state.isOwnerMode ? 'My Profile' : 'Viewing Trainee',
                    style: const TextStyle(color: Colors.grey)),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.edit_outlined),
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/switchProfile');
            },
          ),
        ],
      ),
    );
  }
}

class _MenuItemTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback? onTap;

  const _MenuItemTile(
      {required this.icon, required this.title, this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: Colors.black87),
      title: Text(title,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
      horizontalTitleGap: 4,
      onTap: onTap,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
      dense: true,
      visualDensity: VisualDensity.compact,
      tileColor: Colors.transparent,
      hoverColor: Colors.grey[100],
      splashColor: Colors.grey.withAlpha(40),
    );
  }
}

class _ProfileMiniCard extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(appStateProvider);
    final trainees = mockTrainees;

    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.withAlpha(40)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(trainees.length, (i) {
          final t = trainees[i];
          final selected = t.id == state.currentProfileId;
          return InkWell(
            borderRadius: BorderRadius.circular(8),
            onTap: () =>
                ref.read(appStateProvider.notifier).switchProfile(t.id),
            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 16,
                    backgroundColor: selected
                        ? t.avatarColor
                        : Colors.grey.shade300,
                    child: Text(
                      t.initials,
                      style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color:
                              selected ? Colors.white : Colors.black87),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                      child: Text(t.name,
                          style: const TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w600))),
                  if (selected)
                    const Icon(Icons.check_circle,
                        size: 20, color: Color(0xFF3F51B5)),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}
