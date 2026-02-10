import 'package:flutter/material.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width * 0.78; // ~78%

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
                // Main menu
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    children: [
                      MenuItemTile(
                        icon: Icons.calendar_month_rounded,
                        title: 'Workout Plan',
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.pushNamed(context, '/plans');
                        },
                      ),
                      MenuItemTile(
                        icon: Icons.search_rounded,
                        title: 'Exercises',
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.pushNamed(context, '/search');
                        },
                      ),
                      MenuItemTile(
                        icon: Icons.bar_chart_rounded,
                        title: 'Progress',
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.pushNamed(context, '/progressAnalytics');
                        },
                      ),
                      MenuItemTile(
                        icon: Icons.note_alt_outlined,
                        title: 'Notes',
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.pushNamed(context, '/notes');
                        },
                      ),
                      const SizedBox(height: 12),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Text('Trainee', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Colors.grey[800])),
                      ),
                      const SizedBox(height: 8),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12.0),
                        child: ProfileMiniCard(),
                      ),
                    ],
                  ),
                ),
                const Divider(height: 1),
                // Footer
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextButton.icon(
                          onPressed: () {
                            // placeholder logout
                            Navigator.pop(context);
                          },
                          icon: const Icon(Icons.logout, color: Colors.black54),
                          label: const Text('Logout', style: TextStyle(color: Colors.black87)),
                          style: TextButton.styleFrom(
                            alignment: Alignment.centerLeft,
                          ),
                        ),
                      ),
                      Text('v1.0.0', style: TextStyle(color: Colors.grey[500], fontSize: 12)),
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

class _DrawerHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          const CircleAvatar(radius: 28, backgroundColor: Color(0xFF3F51B5), child: Text('JJ', style: TextStyle(color: Colors.white))),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text('JJ', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
                SizedBox(height: 4),
                Text('My Profile', style: TextStyle(color: Colors.grey)),
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

class MenuItemTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback? onTap;

  const MenuItemTile({Key? key, required this.icon, required this.title, this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: Colors.black87),
      title: Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
      horizontalTitleGap: 4,
      onTap: onTap,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
      dense: true,
      visualDensity: VisualDensity.compact,
      tileColor: Colors.transparent,
      hoverColor: Colors.grey[100],
      splashColor: Colors.grey.withAlpha(40),
    );
  }
}

class ProfileMiniCard extends StatefulWidget {
  @override
  State<ProfileMiniCard> createState() => _ProfileMiniCardState();
}

class _ProfileMiniCardState extends State<ProfileMiniCard> {
  int _selected = 0;

  @override
  Widget build(BuildContext context) {
    final profiles = List.generate(3, (i) => 'User ${i + 1}');

    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black.withAlpha(6), blurRadius: 8, offset: const Offset(0,2))],
        border: Border.all(color: Colors.grey.withAlpha(40)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(profiles.length, (i) {
          final selected = i == _selected;
          return InkWell(
            onTap: () => setState(() => _selected = i),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
              child: Row(
                children: [
                  CircleAvatar(radius: 18, backgroundColor: selected ? const Color(0xFF3F51B5) : Colors.grey.shade300, child: Text(profiles[i].split(' ')[1], style: TextStyle(color: selected ? Colors.white : Colors.black87))),
                  const SizedBox(width: 12),
                  Expanded(child: Text(profiles[i], style: const TextStyle(fontWeight: FontWeight.w600))),
                  if (selected) const Icon(Icons.check_circle, color: Color(0xFF3F51B5)),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}
