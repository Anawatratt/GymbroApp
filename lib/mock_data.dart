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

// Plan class and mockPlans removed as we now use Firestore data.

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
