import 'package:flutter/material.dart';

class Exercise {
  final String name;
  final String muscle;
  final String difficulty;
  final String sets;

  Exercise({
    required this.name,
    required this.muscle,
    required this.difficulty,
    this.sets = '3 x 10',
  });
}

class Plan {
  final String title;
  final IconData icon;
  final Color color;
  final int calories;
  final int durationMin;
  final int exercisesCount;

  Plan({
    required this.title,
    required this.icon,
    required this.color,
    required this.calories,
    required this.durationMin,
    required this.exercisesCount,
  });
}

final List<Exercise> mockExercises = [
  Exercise(name: 'Bench Press', muscle: 'Chest', difficulty: 'Intermediate', sets: '4 x 8'),
  Exercise(name: 'Push Ups', muscle: 'Chest', difficulty: 'Beginner', sets: '3 x 15'),
  Exercise(name: 'Dumbbell Rows', muscle: 'Back', difficulty: 'Intermediate', sets: '3 x 12'),
  Exercise(name: 'Squats', muscle: 'Legs', difficulty: 'Beginner', sets: '4 x 10'),
  Exercise(name: 'Lunges', muscle: 'Legs', difficulty: 'Intermediate', sets: '3 x 12'),
  Exercise(name: 'Plank', muscle: 'Core', difficulty: 'Beginner', sets: '3 x 60s'),
  Exercise(name: 'Pull Ups', muscle: 'Back', difficulty: 'Advanced', sets: '4 x 8'),
  Exercise(name: 'Deadlift', muscle: 'Back', difficulty: 'Advanced', sets: '4 x 6'),
  Exercise(name: 'Shoulder Press', muscle: 'Shoulders', difficulty: 'Intermediate', sets: '3 x 10'),
  Exercise(name: 'Bicep Curls', muscle: 'Arms', difficulty: 'Beginner', sets: '3 x 12'),
];

final List<Plan> mockPlans = [
  Plan(
    title: 'Full Body',
    icon: Icons.fitness_center,
    color: const Color(0xFF3F51B5),
    calories: 450,
    durationMin: 45,
    exercisesCount: 8,
  ),
  Plan(
    title: 'Upper Body',
    icon: Icons.accessibility_new,
    color: const Color(0xFF00897B),
    calories: 350,
    durationMin: 40,
    exercisesCount: 7,
  ),
  Plan(
    title: 'Lower Body',
    icon: Icons.directions_run,
    color: const Color(0xFFFF7043),
    calories: 400,
    durationMin: 40,
    exercisesCount: 7,
  ),
];
