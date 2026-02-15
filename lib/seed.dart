import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

// ── Seed Runner ─────────────────────────────────────────
// เรียก seedAll() ครั้งเดียวเพื่อ seed ข้อมูลทั้งหมดเข้า Firestore
//
// วิธีใช้: ใน main.dart หลัง Firebase.initializeApp()
//   await seedAll();   // ลบออกหลัง seed เสร็จ

Future<void> seedAll() async {
  final db = FirebaseFirestore.instance;

  await seedMuscles(db);
  await seedMuscleGroups(db);
  await seedMachines(db);
  await seedExercises(db);
  await seedPrograms(db);

  debugPrint('--- All seeding completed ---');
}

// ═══════════════════════════════════════════════════════════
// 1. MUSCLES (22 muscles from seed.go)
// ═══════════════════════════════════════════════════════════

Future<void> seedMuscles(FirebaseFirestore db) async {
  final batch = db.batch();
  for (final m in _muscles) {
    batch.set(db.collection('muscles').doc(m['id'] as String), {
      'muscle_name': m['muscle_name'],
      'scientific_name': m['scientific_name'],
      'body_region': m['body_region'],
      'function': m['function'],
      'created_at': FieldValue.serverTimestamp(),
    });
  }
  await batch.commit();
  debugPrint('Seeded muscles (${_muscles.length})');
}

const _muscles = <Map<String, dynamic>>[
  // Chest
  {
    'id': 'pectoralis_major',
    'muscle_name': 'Pectoralis Major',
    'scientific_name': 'Pectoralis major',
    'body_region': 'chest',
    'function': 'Flexion, adduction, and medial rotation of the humerus',
  },
  {
    'id': 'pectoralis_minor',
    'muscle_name': 'Pectoralis Minor',
    'scientific_name': 'Pectoralis minor',
    'body_region': 'chest',
    'function': 'Stabilizes the scapula',
  },
  // Back
  {
    'id': 'latissimus_dorsi',
    'muscle_name': 'Latissimus Dorsi',
    'scientific_name': 'Latissimus dorsi',
    'body_region': 'back',
    'function': 'Extension, adduction, and medial rotation of the shoulder',
  },
  {
    'id': 'trapezius',
    'muscle_name': 'Trapezius',
    'scientific_name': 'Trapezius',
    'body_region': 'back',
    'function': 'Elevates, retracts, and rotates the scapula',
  },
  {
    'id': 'rhomboids',
    'muscle_name': 'Rhomboids',
    'scientific_name': 'Rhomboideus',
    'body_region': 'back',
    'function': 'Retracts and elevates the scapula',
  },
  {
    'id': 'erector_spinae',
    'muscle_name': 'Erector Spinae',
    'scientific_name': 'Erector spinae',
    'body_region': 'back',
    'function': 'Extends and laterally flexes the vertebral column',
  },
  // Shoulders
  {
    'id': 'anterior_deltoid',
    'muscle_name': 'Anterior Deltoid',
    'scientific_name': 'Deltoideus anterior',
    'body_region': 'shoulders',
    'function': 'Flexion and medial rotation of the arm',
  },
  {
    'id': 'lateral_deltoid',
    'muscle_name': 'Lateral Deltoid',
    'scientific_name': 'Deltoideus lateralis',
    'body_region': 'shoulders',
    'function': 'Abduction of the arm',
  },
  {
    'id': 'posterior_deltoid',
    'muscle_name': 'Posterior Deltoid',
    'scientific_name': 'Deltoideus posterior',
    'body_region': 'shoulders',
    'function': 'Extension and lateral rotation of the arm',
  },
  // Arms
  {
    'id': 'biceps_brachii',
    'muscle_name': 'Biceps Brachii',
    'scientific_name': 'Biceps brachii',
    'body_region': 'arms',
    'function': 'Flexion of the elbow and supination of the forearm',
  },
  {
    'id': 'triceps_brachii',
    'muscle_name': 'Triceps Brachii',
    'scientific_name': 'Triceps brachii',
    'body_region': 'arms',
    'function': 'Extension of the elbow',
  },
  {
    'id': 'brachialis',
    'muscle_name': 'Brachialis',
    'scientific_name': 'Brachialis',
    'body_region': 'arms',
    'function': 'Flexion of the elbow',
  },
  {
    'id': 'forearm_flexors',
    'muscle_name': 'Forearm Flexors',
    'scientific_name': 'Flexor group',
    'body_region': 'arms',
    'function': 'Flexion of the wrist and fingers',
  },
  {
    'id': 'forearm_extensors',
    'muscle_name': 'Forearm Extensors',
    'scientific_name': 'Extensor group',
    'body_region': 'arms',
    'function': 'Extension of the wrist and fingers',
  },
  // Legs
  {
    'id': 'quadriceps',
    'muscle_name': 'Quadriceps',
    'scientific_name': 'Quadriceps femoris',
    'body_region': 'legs',
    'function': 'Extension of the knee',
  },
  {
    'id': 'hamstrings',
    'muscle_name': 'Hamstrings',
    'scientific_name': 'Hamstring group',
    'body_region': 'legs',
    'function': 'Flexion of the knee and extension of the hip',
  },
  {
    'id': 'glutes',
    'muscle_name': 'Glutes',
    'scientific_name': 'Gluteus maximus',
    'body_region': 'legs',
    'function': 'Extension and lateral rotation of the hip',
  },
  {
    'id': 'calves',
    'muscle_name': 'Calves',
    'scientific_name': 'Gastrocnemius and Soleus',
    'body_region': 'legs',
    'function': 'Plantarflexion of the ankle',
  },
  {
    'id': 'adductors',
    'muscle_name': 'Adductors',
    'scientific_name': 'Adductor group',
    'body_region': 'legs',
    'function': 'Adduction of the hip',
  },
  // Core
  {
    'id': 'rectus_abdominis',
    'muscle_name': 'Rectus Abdominis',
    'scientific_name': 'Rectus abdominis',
    'body_region': 'core',
    'function': 'Flexion of the lumbar spine',
  },
  {
    'id': 'obliques',
    'muscle_name': 'Obliques',
    'scientific_name': 'Obliquus externus and internus',
    'body_region': 'core',
    'function': 'Rotation and lateral flexion of the trunk',
  },
  {
    'id': 'transverse_abdominis',
    'muscle_name': 'Transverse Abdominis',
    'scientific_name': 'Transversus abdominis',
    'body_region': 'core',
    'function': 'Compression of the abdominal contents',
  },
];

// ═══════════════════════════════════════════════════════════
// 2. MUSCLE GROUPS (with member muscle IDs embedded)
// ═══════════════════════════════════════════════════════════

Future<void> seedMuscleGroups(FirebaseFirestore db) async {
  final batch = db.batch();
  for (final g in _muscleGroups) {
    batch.set(db.collection('muscle_groups').doc(g['id'] as String), {
      'group_name': g['group_name'],
      'split_category': g['split_category'],
      'muscle_ids': g['muscle_ids'],
      'created_at': FieldValue.serverTimestamp(),
    });
  }
  await batch.commit();
  debugPrint('Seeded muscle_groups (${_muscleGroups.length})');
}

const _muscleGroups = <Map<String, dynamic>>[
  {
    'id': 'chest',
    'group_name': 'Chest',
    'split_category': 'Push',
    'muscle_ids': ['pectoralis_major', 'pectoralis_minor'],
  },
  {
    'id': 'back',
    'group_name': 'Back',
    'split_category': 'Pull',
    'muscle_ids': [
      'latissimus_dorsi',
      'trapezius',
      'rhomboids',
      'erector_spinae',
    ],
  },
  {
    'id': 'shoulders',
    'group_name': 'Shoulders',
    'split_category': 'Push',
    'muscle_ids': ['anterior_deltoid', 'lateral_deltoid', 'posterior_deltoid'],
  },
  {
    'id': 'arms',
    'group_name': 'Arms',
    'split_category': 'Push',
    'muscle_ids': [
      'biceps_brachii',
      'triceps_brachii',
      'brachialis',
      'forearm_flexors',
      'forearm_extensors',
    ],
  },
  {
    'id': 'legs',
    'group_name': 'Legs',
    'split_category': 'Legs',
    'muscle_ids': ['quadriceps', 'hamstrings', 'glutes', 'calves', 'adductors'],
  },
  {
    'id': 'core',
    'group_name': 'Core',
    'split_category': 'Upper',
    'muscle_ids': ['rectus_abdominis', 'obliques', 'transverse_abdominis'],
  },
];

// ═══════════════════════════════════════════════════════════
// 3. MACHINES (17 items from seed.go)
// ═══════════════════════════════════════════════════════════

Future<void> seedMachines(FirebaseFirestore db) async {
  final batch = db.batch();
  for (final m in _machines) {
    batch.set(db.collection('machines').doc(m['id'] as String), {
      'machine_name': m['machine_name'],
      'machine_type': m['machine_type'],
      'description': m['description'],
      'created_at': FieldValue.serverTimestamp(),
    });
  }
  await batch.commit();
  debugPrint('Seeded machines (${_machines.length})');
}

const _machines = <Map<String, dynamic>>[
  // Free weights
  {
    'id': 'barbell',
    'machine_name': 'Barbell',
    'machine_type': 'free_weight',
    'description': 'Standard Olympic barbell for compound lifts',
  },
  {
    'id': 'dumbbells',
    'machine_name': 'Dumbbells',
    'machine_type': 'free_weight',
    'description': 'Pair of dumbbells for unilateral and isolation work',
  },
  {
    'id': 'kettlebell',
    'machine_name': 'Kettlebell',
    'machine_type': 'free_weight',
    'description': 'Cast iron weight for dynamic movements',
  },
  {
    'id': 'ez_curl_bar',
    'machine_name': 'EZ Curl Bar',
    'machine_type': 'free_weight',
    'description': 'Curved bar for bicep and tricep exercises',
  },
  {
    'id': 'bench',
    'machine_name': 'Bench',
    'machine_type': 'free_weight',
    'description': 'Flat/incline/decline bench',
  },
  // Machines
  {
    'id': 'chest_press_machine',
    'machine_name': 'Chest Press Machine',
    'machine_type': 'machine',
    'description': 'Guided chest press movement',
  },
  {
    'id': 'leg_press_machine',
    'machine_name': 'Leg Press Machine',
    'machine_type': 'machine',
    'description': 'Seated leg press with weight stack',
  },
  {
    'id': 'lat_pulldown_machine',
    'machine_name': 'Lat Pulldown Machine',
    'machine_type': 'machine',
    'description': 'Vertical pulling machine for back',
  },
  {
    'id': 'leg_extension_machine',
    'machine_name': 'Leg Extension Machine',
    'machine_type': 'machine',
    'description': 'Isolated quadriceps extension',
  },
  {
    'id': 'leg_curl_machine',
    'machine_name': 'Leg Curl Machine',
    'machine_type': 'machine',
    'description': 'Isolated hamstring curl',
  },
  {
    'id': 'shoulder_press_machine',
    'machine_name': 'Shoulder Press Machine',
    'machine_type': 'machine',
    'description': 'Guided overhead press movement',
  },
  {
    'id': 'pec_fly_machine',
    'machine_name': 'Pec Fly Machine',
    'machine_type': 'machine',
    'description': 'Chest isolation machine',
  },
  {
    'id': 'smith_machine',
    'machine_name': 'Smith Machine',
    'machine_type': 'machine',
    'description': 'Fixed barbell path machine',
  },
  // Cable
  {
    'id': 'cable_machine',
    'machine_name': 'Cable Machine',
    'machine_type': 'cable',
    'description': 'Adjustable cable pulley system',
  },
  // Bodyweight
  {
    'id': 'pullup_bar',
    'machine_name': 'Pull-up Bar',
    'machine_type': 'bodyweight',
    'description': 'Bar for pull-ups and chin-ups',
  },
  {
    'id': 'dip_station',
    'machine_name': 'Dip Station',
    'machine_type': 'bodyweight',
    'description': 'Parallel bars for dips',
  },
  {
    'id': 'none',
    'machine_name': 'None',
    'machine_type': 'bodyweight',
    'description': 'No machine needed',
  },
];

// ═══════════════════════════════════════════════════════════
// 4. EXERCISES (28 exercises, with muscle & machine embedded)
// ═══════════════════════════════════════════════════════════

Future<void> seedExercises(FirebaseFirestore db) async {
  final batch = db.batch();
  for (final e in _exercises) {
    batch.set(db.collection('exercises').doc(e['id'] as String), {
      'exercise_name': e['exercise_name'],
      'movement_type': e['movement_type'],
      'movement_pattern': e['movement_pattern'],
      'description': e['description'],
      'difficulty_level': e['difficulty_level'],
      'is_compound': e['is_compound'],
      'muscle_involvements': e['muscle_involvements'],
      'machines': e['machines'],
      'created_at': FieldValue.serverTimestamp(),
    });
  }
  await batch.commit();
  debugPrint('Seeded exercises (${_exercises.length})');
}

const _exercises = <Map<String, dynamic>>[
  // ── Chest ──
  {
    'id': 'barbell_bench_press',
    'exercise_name': 'Barbell Bench Press',
    'movement_type': 'compound',
    'movement_pattern': 'horizontal_push',
    'description': 'Classic compound chest exercise',
    'difficulty_level': 'intermediate',
    'is_compound': true,
    'muscle_involvements': [
      {
        'muscle_id': 'pectoralis_major',
        'involvement': 'primary',
        'activation_pct': 70,
      },
      {
        'muscle_id': 'anterior_deltoid',
        'involvement': 'secondary',
        'activation_pct': 20,
      },
      {
        'muscle_id': 'triceps_brachii',
        'involvement': 'secondary',
        'activation_pct': 10,
      },
    ],
    'machines': [
      {'machine_id': 'barbell', 'is_required': true},
      {'machine_id': 'bench', 'is_required': true},
    ],
  },
  {
    'id': 'dumbbell_bench_press',
    'exercise_name': 'Dumbbell Bench Press',
    'movement_type': 'compound',
    'movement_pattern': 'horizontal_push',
    'description': 'Dumbbell variation of bench press',
    'difficulty_level': 'intermediate',
    'is_compound': true,
    'muscle_involvements': [
      {
        'muscle_id': 'pectoralis_major',
        'involvement': 'primary',
        'activation_pct': 70,
      },
      {
        'muscle_id': 'anterior_deltoid',
        'involvement': 'secondary',
        'activation_pct': 20,
      },
      {
        'muscle_id': 'triceps_brachii',
        'involvement': 'secondary',
        'activation_pct': 10,
      },
    ],
    'machines': [
      {'machine_id': 'dumbbells', 'is_required': true},
      {'machine_id': 'bench', 'is_required': true},
    ],
  },
  {
    'id': 'incline_barbell_bench_press',
    'exercise_name': 'Incline Barbell Bench Press',
    'movement_type': 'compound',
    'movement_pattern': 'incline_push',
    'description': 'Targets upper chest',
    'difficulty_level': 'intermediate',
    'is_compound': true,
    'muscle_involvements': [
      {
        'muscle_id': 'pectoralis_major',
        'involvement': 'primary',
        'activation_pct': 60,
      },
      {
        'muscle_id': 'anterior_deltoid',
        'involvement': 'primary',
        'activation_pct': 30,
      },
      {
        'muscle_id': 'triceps_brachii',
        'involvement': 'secondary',
        'activation_pct': 10,
      },
    ],
    'machines': [
      {'machine_id': 'barbell', 'is_required': true},
      {'machine_id': 'bench', 'is_required': true},
    ],
  },
  {
    'id': 'chest_fly',
    'exercise_name': 'Chest Fly',
    'movement_type': 'isolated',
    'movement_pattern': 'horizontal_adduction',
    'description': 'Isolation exercise for chest',
    'difficulty_level': 'beginner',
    'is_compound': false,
    'muscle_involvements': [
      {
        'muscle_id': 'pectoralis_major',
        'involvement': 'primary',
        'activation_pct': 90,
      },
      {
        'muscle_id': 'anterior_deltoid',
        'involvement': 'stabilizer',
        'activation_pct': 10,
      },
    ],
    'machines': [
      {'machine_id': 'dumbbells', 'is_required': false},
      {'machine_id': 'cable_machine', 'is_required': false},
      {'machine_id': 'pec_fly_machine', 'is_required': false},
    ],
  },
  {
    'id': 'push_ups',
    'exercise_name': 'Push-ups',
    'movement_type': 'compound',
    'movement_pattern': 'horizontal_push',
    'description': 'Bodyweight chest exercise',
    'difficulty_level': 'beginner',
    'is_compound': true,
    'muscle_involvements': [
      {
        'muscle_id': 'pectoralis_major',
        'involvement': 'primary',
        'activation_pct': 60,
      },
      {
        'muscle_id': 'anterior_deltoid',
        'involvement': 'secondary',
        'activation_pct': 20,
      },
      {
        'muscle_id': 'triceps_brachii',
        'involvement': 'secondary',
        'activation_pct': 20,
      },
    ],
    'machines': [
      {'machine_id': 'none', 'is_required': true},
    ],
  },

  // ── Back ──
  {
    'id': 'deadlift',
    'exercise_name': 'Deadlift',
    'movement_type': 'compound',
    'movement_pattern': 'hip_hinge',
    'description': 'King of compound exercises',
    'difficulty_level': 'advanced',
    'is_compound': true,
    'muscle_involvements': [
      {
        'muscle_id': 'erector_spinae',
        'involvement': 'primary',
        'activation_pct': 40,
      },
      {'muscle_id': 'glutes', 'involvement': 'primary', 'activation_pct': 30},
      {
        'muscle_id': 'hamstrings',
        'involvement': 'primary',
        'activation_pct': 20,
      },
      {
        'muscle_id': 'trapezius',
        'involvement': 'secondary',
        'activation_pct': 10,
      },
    ],
    'machines': [
      {'machine_id': 'barbell', 'is_required': true},
    ],
  },
  {
    'id': 'barbell_row',
    'exercise_name': 'Barbell Row',
    'movement_type': 'compound',
    'movement_pattern': 'horizontal_pull',
    'description': 'Compound back thickness builder',
    'difficulty_level': 'intermediate',
    'is_compound': true,
    'muscle_involvements': [
      {
        'muscle_id': 'latissimus_dorsi',
        'involvement': 'primary',
        'activation_pct': 50,
      },
      {
        'muscle_id': 'rhomboids',
        'involvement': 'primary',
        'activation_pct': 25,
      },
      {
        'muscle_id': 'trapezius',
        'involvement': 'secondary',
        'activation_pct': 15,
      },
      {
        'muscle_id': 'biceps_brachii',
        'involvement': 'secondary',
        'activation_pct': 10,
      },
    ],
    'machines': [
      {'machine_id': 'barbell', 'is_required': true},
    ],
  },
  {
    'id': 'pull_ups',
    'exercise_name': 'Pull-ups',
    'movement_type': 'compound',
    'movement_pattern': 'vertical_pull',
    'description': 'Bodyweight back exercise',
    'difficulty_level': 'intermediate',
    'is_compound': true,
    'muscle_involvements': [
      {
        'muscle_id': 'latissimus_dorsi',
        'involvement': 'primary',
        'activation_pct': 60,
      },
      {
        'muscle_id': 'biceps_brachii',
        'involvement': 'secondary',
        'activation_pct': 25,
      },
      {
        'muscle_id': 'rhomboids',
        'involvement': 'secondary',
        'activation_pct': 15,
      },
    ],
    'machines': [
      {'machine_id': 'pullup_bar', 'is_required': true},
    ],
  },
  {
    'id': 'lat_pulldown',
    'exercise_name': 'Lat Pulldown',
    'movement_type': 'compound',
    'movement_pattern': 'vertical_pull',
    'description': 'Machine-based vertical pull',
    'difficulty_level': 'beginner',
    'is_compound': true,
    'muscle_involvements': [
      {
        'muscle_id': 'latissimus_dorsi',
        'involvement': 'primary',
        'activation_pct': 60,
      },
      {
        'muscle_id': 'biceps_brachii',
        'involvement': 'secondary',
        'activation_pct': 25,
      },
      {
        'muscle_id': 'rhomboids',
        'involvement': 'secondary',
        'activation_pct': 15,
      },
    ],
    'machines': [
      {'machine_id': 'lat_pulldown_machine', 'is_required': true},
    ],
  },
  {
    'id': 'dumbbell_row',
    'exercise_name': 'Dumbbell Row',
    'movement_type': 'compound',
    'movement_pattern': 'horizontal_pull',
    'description': 'Unilateral back exercise',
    'difficulty_level': 'intermediate',
    'is_compound': true,
    'muscle_involvements': [
      {
        'muscle_id': 'latissimus_dorsi',
        'involvement': 'primary',
        'activation_pct': 55,
      },
      {
        'muscle_id': 'rhomboids',
        'involvement': 'primary',
        'activation_pct': 25,
      },
      {
        'muscle_id': 'biceps_brachii',
        'involvement': 'secondary',
        'activation_pct': 20,
      },
    ],
    'machines': [
      {'machine_id': 'dumbbells', 'is_required': true},
    ],
  },

  // ── Shoulders ──
  {
    'id': 'overhead_press',
    'exercise_name': 'Overhead Press',
    'movement_type': 'compound',
    'movement_pattern': 'vertical_push',
    'description': 'Compound shoulder press',
    'difficulty_level': 'intermediate',
    'is_compound': true,
    'muscle_involvements': [
      {
        'muscle_id': 'anterior_deltoid',
        'involvement': 'primary',
        'activation_pct': 50,
      },
      {
        'muscle_id': 'lateral_deltoid',
        'involvement': 'primary',
        'activation_pct': 30,
      },
      {
        'muscle_id': 'triceps_brachii',
        'involvement': 'secondary',
        'activation_pct': 20,
      },
    ],
    'machines': [
      {'machine_id': 'barbell', 'is_required': true},
    ],
  },
  {
    'id': 'dumbbell_shoulder_press',
    'exercise_name': 'Dumbbell Shoulder Press',
    'movement_type': 'compound',
    'movement_pattern': 'vertical_push',
    'description': 'Dumbbell overhead press',
    'difficulty_level': 'intermediate',
    'is_compound': true,
    'muscle_involvements': [
      {
        'muscle_id': 'anterior_deltoid',
        'involvement': 'primary',
        'activation_pct': 50,
      },
      {
        'muscle_id': 'lateral_deltoid',
        'involvement': 'primary',
        'activation_pct': 30,
      },
      {
        'muscle_id': 'triceps_brachii',
        'involvement': 'secondary',
        'activation_pct': 20,
      },
    ],
    'machines': [
      {'machine_id': 'dumbbells', 'is_required': true},
    ],
  },
  {
    'id': 'lateral_raise',
    'exercise_name': 'Lateral Raise',
    'movement_type': 'isolated',
    'movement_pattern': 'abduction',
    'description': 'Isolation for lateral delts',
    'difficulty_level': 'beginner',
    'is_compound': false,
    'muscle_involvements': [
      {
        'muscle_id': 'lateral_deltoid',
        'involvement': 'primary',
        'activation_pct': 90,
      },
      {
        'muscle_id': 'anterior_deltoid',
        'involvement': 'stabilizer',
        'activation_pct': 10,
      },
    ],
    'machines': [
      {'machine_id': 'dumbbells', 'is_required': true},
    ],
  },
  {
    'id': 'front_raise',
    'exercise_name': 'Front Raise',
    'movement_type': 'isolated',
    'movement_pattern': 'flexion',
    'description': 'Isolation for anterior delts',
    'difficulty_level': 'beginner',
    'is_compound': false,
    'muscle_involvements': [
      {
        'muscle_id': 'anterior_deltoid',
        'involvement': 'primary',
        'activation_pct': 90,
      },
      {
        'muscle_id': 'lateral_deltoid',
        'involvement': 'stabilizer',
        'activation_pct': 10,
      },
    ],
    'machines': [
      {'machine_id': 'dumbbells', 'is_required': true},
    ],
  },

  // ── Arms ──
  {
    'id': 'barbell_curl',
    'exercise_name': 'Barbell Curl',
    'movement_type': 'isolated',
    'movement_pattern': 'elbow_flexion',
    'description': 'Classic bicep exercise',
    'difficulty_level': 'beginner',
    'is_compound': false,
    'muscle_involvements': [
      {
        'muscle_id': 'biceps_brachii',
        'involvement': 'primary',
        'activation_pct': 80,
      },
      {
        'muscle_id': 'brachialis',
        'involvement': 'secondary',
        'activation_pct': 20,
      },
    ],
    'machines': [
      {'machine_id': 'barbell', 'is_required': false},
      {'machine_id': 'ez_curl_bar', 'is_required': false},
    ],
  },
  {
    'id': 'dumbbell_curl',
    'exercise_name': 'Dumbbell Curl',
    'movement_type': 'isolated',
    'movement_pattern': 'elbow_flexion',
    'description': 'Unilateral bicep curl',
    'difficulty_level': 'beginner',
    'is_compound': false,
    'muscle_involvements': [
      {
        'muscle_id': 'biceps_brachii',
        'involvement': 'primary',
        'activation_pct': 80,
      },
      {
        'muscle_id': 'brachialis',
        'involvement': 'secondary',
        'activation_pct': 20,
      },
    ],
    'machines': [
      {'machine_id': 'dumbbells', 'is_required': true},
    ],
  },
  {
    'id': 'tricep_pushdown',
    'exercise_name': 'Tricep Pushdown',
    'movement_type': 'isolated',
    'movement_pattern': 'elbow_extension',
    'description': 'Cable tricep isolation',
    'difficulty_level': 'beginner',
    'is_compound': false,
    'muscle_involvements': [
      {
        'muscle_id': 'triceps_brachii',
        'involvement': 'primary',
        'activation_pct': 100,
      },
    ],
    'machines': [
      {'machine_id': 'cable_machine', 'is_required': true},
    ],
  },
  {
    'id': 'skull_crushers',
    'exercise_name': 'Skull Crushers',
    'movement_type': 'isolated',
    'movement_pattern': 'elbow_extension',
    'description': 'Lying tricep extension',
    'difficulty_level': 'intermediate',
    'is_compound': false,
    'muscle_involvements': [
      {
        'muscle_id': 'triceps_brachii',
        'involvement': 'primary',
        'activation_pct': 100,
      },
    ],
    'machines': [
      {'machine_id': 'barbell', 'is_required': false},
      {'machine_id': 'ez_curl_bar', 'is_required': false},
    ],
  },
  {
    'id': 'dips',
    'exercise_name': 'Dips',
    'movement_type': 'compound',
    'movement_pattern': 'vertical_push',
    'description': 'Compound tricep and chest exercise',
    'difficulty_level': 'intermediate',
    'is_compound': true,
    'muscle_involvements': [
      {
        'muscle_id': 'triceps_brachii',
        'involvement': 'primary',
        'activation_pct': 50,
      },
      {
        'muscle_id': 'pectoralis_major',
        'involvement': 'primary',
        'activation_pct': 30,
      },
      {
        'muscle_id': 'anterior_deltoid',
        'involvement': 'secondary',
        'activation_pct': 20,
      },
    ],
    'machines': [
      {'machine_id': 'dip_station', 'is_required': true},
    ],
  },

  // ── Legs ──
  {
    'id': 'barbell_squat',
    'exercise_name': 'Barbell Squat',
    'movement_type': 'compound',
    'movement_pattern': 'squat',
    'description': 'King of leg exercises',
    'difficulty_level': 'intermediate',
    'is_compound': true,
    'muscle_involvements': [
      {
        'muscle_id': 'quadriceps',
        'involvement': 'primary',
        'activation_pct': 50,
      },
      {'muscle_id': 'glutes', 'involvement': 'primary', 'activation_pct': 30},
      {
        'muscle_id': 'hamstrings',
        'involvement': 'secondary',
        'activation_pct': 20,
      },
    ],
    'machines': [
      {'machine_id': 'barbell', 'is_required': true},
    ],
  },
  {
    'id': 'leg_press',
    'exercise_name': 'Leg Press',
    'movement_type': 'compound',
    'movement_pattern': 'leg_press',
    'description': 'Machine-based leg compound',
    'difficulty_level': 'beginner',
    'is_compound': true,
    'muscle_involvements': [
      {
        'muscle_id': 'quadriceps',
        'involvement': 'primary',
        'activation_pct': 55,
      },
      {'muscle_id': 'glutes', 'involvement': 'primary', 'activation_pct': 30},
      {
        'muscle_id': 'hamstrings',
        'involvement': 'secondary',
        'activation_pct': 15,
      },
    ],
    'machines': [
      {'machine_id': 'leg_press_machine', 'is_required': true},
    ],
  },
  {
    'id': 'romanian_deadlift',
    'exercise_name': 'Romanian Deadlift',
    'movement_type': 'compound',
    'movement_pattern': 'hip_hinge',
    'description': 'Hamstring-focused deadlift variation',
    'difficulty_level': 'intermediate',
    'is_compound': true,
    'muscle_involvements': [
      {
        'muscle_id': 'hamstrings',
        'involvement': 'primary',
        'activation_pct': 60,
      },
      {'muscle_id': 'glutes', 'involvement': 'primary', 'activation_pct': 30},
      {
        'muscle_id': 'erector_spinae',
        'involvement': 'secondary',
        'activation_pct': 10,
      },
    ],
    'machines': [
      {'machine_id': 'barbell', 'is_required': true},
    ],
  },
  {
    'id': 'leg_extension',
    'exercise_name': 'Leg Extension',
    'movement_type': 'isolated',
    'movement_pattern': 'knee_extension',
    'description': 'Quadriceps isolation',
    'difficulty_level': 'beginner',
    'is_compound': false,
    'muscle_involvements': [
      {
        'muscle_id': 'quadriceps',
        'involvement': 'primary',
        'activation_pct': 100,
      },
    ],
    'machines': [
      {'machine_id': 'leg_extension_machine', 'is_required': true},
    ],
  },
  {
    'id': 'leg_curl',
    'exercise_name': 'Leg Curl',
    'movement_type': 'isolated',
    'movement_pattern': 'knee_flexion',
    'description': 'Hamstring isolation',
    'difficulty_level': 'beginner',
    'is_compound': false,
    'muscle_involvements': [
      {
        'muscle_id': 'hamstrings',
        'involvement': 'primary',
        'activation_pct': 100,
      },
    ],
    'machines': [
      {'machine_id': 'leg_curl_machine', 'is_required': true},
    ],
  },
  {
    'id': 'calf_raise',
    'exercise_name': 'Calf Raise',
    'movement_type': 'isolated',
    'movement_pattern': 'plantarflexion',
    'description': 'Calf isolation exercise',
    'difficulty_level': 'beginner',
    'is_compound': false,
    'muscle_involvements': [
      {'muscle_id': 'calves', 'involvement': 'primary', 'activation_pct': 100},
    ],
    'machines': [
      {'machine_id': 'none', 'is_required': true},
    ],
  },

  // ── Core ──
  {
    'id': 'plank',
    'exercise_name': 'Plank',
    'movement_type': 'isolated',
    'movement_pattern': 'isometric',
    'description': 'Core stability exercise',
    'difficulty_level': 'beginner',
    'is_compound': false,
    'muscle_involvements': [
      {
        'muscle_id': 'rectus_abdominis',
        'involvement': 'primary',
        'activation_pct': 50,
      },
      {
        'muscle_id': 'transverse_abdominis',
        'involvement': 'primary',
        'activation_pct': 30,
      },
      {
        'muscle_id': 'obliques',
        'involvement': 'stabilizer',
        'activation_pct': 20,
      },
    ],
    'machines': [
      {'machine_id': 'none', 'is_required': true},
    ],
  },
  {
    'id': 'crunches',
    'exercise_name': 'Crunches',
    'movement_type': 'isolated',
    'movement_pattern': 'spinal_flexion',
    'description': 'Basic abdominal exercise',
    'difficulty_level': 'beginner',
    'is_compound': false,
    'muscle_involvements': [
      {
        'muscle_id': 'rectus_abdominis',
        'involvement': 'primary',
        'activation_pct': 90,
      },
      {
        'muscle_id': 'obliques',
        'involvement': 'secondary',
        'activation_pct': 10,
      },
    ],
    'machines': [
      {'machine_id': 'none', 'is_required': true},
    ],
  },
  {
    'id': 'russian_twists',
    'exercise_name': 'Russian Twists',
    'movement_type': 'isolated',
    'movement_pattern': 'rotation',
    'description': 'Oblique targeting exercise',
    'difficulty_level': 'beginner',
    'is_compound': false,
    'muscle_involvements': [
      {'muscle_id': 'obliques', 'involvement': 'primary', 'activation_pct': 70},
      {
        'muscle_id': 'rectus_abdominis',
        'involvement': 'secondary',
        'activation_pct': 30,
      },
    ],
    'machines': [
      {'machine_id': 'none', 'is_required': true},
    ],
  },
];

// ═══════════════════════════════════════════════════════════
// 5. PROGRAMS (with sessions & session exercises embedded)
// ═══════════════════════════════════════════════════════════

Future<void> seedPrograms(FirebaseFirestore db) async {
  // Program 1: Push Pull Legs Split
  final pplRef = db.collection('programs').doc('push_pull_legs');
  await pplRef.set({
    'program_name': 'Push Pull Legs Split',
    'goal': 'muscle_gain',
    'duration_weeks': 12,
    'days_per_week': 6,
    'difficulty_level': 'intermediate',
    'description': '6-day split focusing on muscle hypertrophy',
    'is_template': false,
    'is_active': true,
    'created_at': FieldValue.serverTimestamp(),
  });

  // PPL Sessions (as subcollection)
  final pplSessions = pplRef.collection('sessions');

  await pplSessions.doc('push_day_a').set({
    'session_name': 'Push Day A',
    'workout_split': 'Push',
    'day_number': 1,
    'notes': 'Focus on chest and shoulders',
    'exercises': [
      {
        'exercise_id': 'barbell_bench_press',
        'sets': 4,
        'reps': 8,
        'weight': 185.0,
        'rest_seconds': 180,
        'order': 1,
      },
      {
        'exercise_id': 'incline_barbell_bench_press',
        'sets': 3,
        'reps': 10,
        'weight': 135.0,
        'rest_seconds': 120,
        'order': 2,
      },
      {
        'exercise_id': 'overhead_press',
        'sets': 4,
        'reps': 8,
        'weight': 95.0,
        'rest_seconds': 150,
        'order': 3,
      },
      {
        'exercise_id': 'lateral_raise',
        'sets': 3,
        'reps': 12,
        'weight': 30.0,
        'rest_seconds': 60,
        'order': 4,
      },
      {
        'exercise_id': 'tricep_pushdown',
        'sets': 3,
        'reps': 12,
        'weight': 50.0,
        'rest_seconds': 60,
        'order': 5,
      },
    ],
  });

  await pplSessions.doc('pull_day_a').set({
    'session_name': 'Pull Day A',
    'workout_split': 'Pull',
    'day_number': 2,
    'notes': 'Focus on back and biceps',
    'exercises': [
      {
        'exercise_id': 'deadlift',
        'sets': 3,
        'reps': 5,
        'weight': 185.0,
        'rest_seconds': 240,
        'order': 1,
      },
      {
        'exercise_id': 'pull_ups',
        'sets': 4,
        'reps': 8,
        'weight': null,
        'rest_seconds': 120,
        'order': 2,
      },
      {
        'exercise_id': 'barbell_row',
        'sets': 4,
        'reps': 10,
        'weight': 135.0,
        'rest_seconds': 120,
        'order': 3,
      },
      {
        'exercise_id': 'dumbbell_row',
        'sets': 3,
        'reps': 12,
        'weight': 50.0,
        'rest_seconds': 90,
        'order': 4,
      },
      {
        'exercise_id': 'barbell_curl',
        'sets': 3,
        'reps': 12,
        'weight': 50.0,
        'rest_seconds': 60,
        'order': 5,
      },
    ],
  });

  await pplSessions.doc('leg_day_a').set({
    'session_name': 'Leg Day A',
    'workout_split': 'Legs',
    'day_number': 3,
    'notes': 'Focus on quads and glutes',
    'exercises': [
      {
        'exercise_id': 'barbell_squat',
        'sets': 4,
        'reps': 8,
        'weight': 185.0,
        'rest_seconds': 180,
        'order': 1,
      },
      {
        'exercise_id': 'romanian_deadlift',
        'sets': 3,
        'reps': 10,
        'weight': 135.0,
        'rest_seconds': 120,
        'order': 2,
      },
      {
        'exercise_id': 'leg_press',
        'sets': 3,
        'reps': 12,
        'weight': 185.0,
        'rest_seconds': 90,
        'order': 3,
      },
      {
        'exercise_id': 'leg_extension',
        'sets': 3,
        'reps': 15,
        'weight': 95.0,
        'rest_seconds': 60,
        'order': 4,
      },
      {
        'exercise_id': 'calf_raise',
        'sets': 4,
        'reps': 20,
        'weight': null,
        'rest_seconds': 45,
        'order': 5,
      },
    ],
  });

  // Program 2: Strength Building
  await db.collection('programs').doc('strength_building').set({
    'program_name': 'Strength Building Program',
    'goal': 'strength',
    'duration_weeks': 8,
    'days_per_week': 4,
    'difficulty_level': 'advanced',
    'description': 'Low-rep compound-focused strength program',
    'is_template': false,
    'is_active': false,
    'created_at': FieldValue.serverTimestamp(),
  });

  // Program 3: Beginner Template
  await db.collection('programs').doc('beginner_full_body').set({
    'program_name': 'Beginner Full Body Template',
    'goal': 'general_fitness',
    'duration_weeks': 4,
    'days_per_week': 3,
    'difficulty_level': 'beginner',
    'description': '3-day full body workout for beginners',
    'is_template': true,
    'is_active': false,
    'created_at': FieldValue.serverTimestamp(),
  });

  debugPrint('Seeded programs (3) with sessions');
}
