import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'screens/search_screen.dart';
import 'screens/plan_list_screen.dart';
import 'screens/plan_detail_screen.dart';
import 'screens/custom_plan_screen.dart';
import 'screens/switch_profile_screen.dart';
import 'screens/progress_analytics_screen.dart';
import 'screens/progress_breakdown_screen.dart';

import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const GymbroApp());
}

class GymbroApp extends StatelessWidget {
  const GymbroApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Gymbro',
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: const Color(0xFF3F51B5),
        brightness: Brightness.light,
        scaffoldBackgroundColor: const Color(0xFFF5F6FA),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          foregroundColor: Color(0xFF1A1A2E),
          elevation: 0,
          centerTitle: false,
          titleTextStyle: TextStyle(
            color: Color(0xFF1A1A2E),
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
        cardTheme: CardThemeData(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          color: Colors.white,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF3F51B5),
            foregroundColor: Colors.white,
            elevation: 0,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          ),
        ),
      ),
      home: const HomeScreen(),
      routes: {
        '/search': (context) => const SearchScreen(),
        '/plans': (context) => const PlanListScreen(),
        '/planDetail': (context) => const PlanDetailScreen(),
        '/customPlan': (context) => const CustomPlanScreen(),
        '/switchProfile': (context) => const SwitchProfileScreen(),
        '/progressAnalytics': (context) => const ProgressAnalyticsScreen(),
        '/progressBreakdown': (context) => const ProgressBreakdownScreen(),
      },
    );
  }
}
