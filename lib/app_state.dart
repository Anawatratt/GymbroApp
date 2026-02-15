import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'mock_data.dart';

// ── State model ─────────────────────────────────────────

class AppState {
  final String currentProfileId;
  final Map<String, List<Note>> notesByProfile;

  const AppState({
    this.currentProfileId = 'jj',
    this.notesByProfile = const {},
  });

  static const ownerProfileId = 'jj';

  bool get isOwnerMode => currentProfileId == ownerProfileId;

  Trainee get currentTrainee =>
      mockTrainees.firstWhere((t) => t.id == currentProfileId);

  List<Note> get currentNotes =>
      notesByProfile[currentProfileId] ?? [];

  AppState copyWith({
    String? currentProfileId,
    Map<String, List<Note>>? notesByProfile,
  }) {
    return AppState(
      currentProfileId: currentProfileId ?? this.currentProfileId,
      notesByProfile: notesByProfile ?? this.notesByProfile,
    );
  }
}

// ── StateNotifier ───────────────────────────────────────

class AppStateNotifier extends StateNotifier<AppState> {
  AppStateNotifier()
      : super(AppState(
          notesByProfile: Map.from(
            mockNotesByProfile.map((k, v) => MapEntry(k, List<Note>.from(v))),
          ),
        ));

  void switchProfile(String profileId) {
    if (state.currentProfileId != profileId) {
      state = state.copyWith(currentProfileId: profileId);
    }
  }

  void addNote(Note note) {
    final map = Map<String, List<Note>>.from(state.notesByProfile);
    final pid = state.currentProfileId;
    map[pid] = [note, ...map[pid] ?? []];
    state = state.copyWith(notesByProfile: map);
  }

  void updateNote(String noteId, {String? title, String? body, Color? color}) {
    final pid = state.currentProfileId;
    final list = state.notesByProfile[pid];
    if (list == null) return;
    final i = list.indexWhere((n) => n.id == noteId);
    if (i == -1) return;

    final map = Map<String, List<Note>>.from(state.notesByProfile);
    map[pid] = List<Note>.from(list);
    map[pid]![i] = list[i].copyWith(title: title, body: body, color: color);
    state = state.copyWith(notesByProfile: map);
  }

  void deleteNote(String noteId) {
    final pid = state.currentProfileId;
    final list = state.notesByProfile[pid];
    if (list == null) return;

    final map = Map<String, List<Note>>.from(state.notesByProfile);
    map[pid] = list.where((n) => n.id != noteId).toList();
    state = state.copyWith(notesByProfile: map);
  }
}

// ── Provider ────────────────────────────────────────────

final appStateProvider =
    StateNotifierProvider<AppStateNotifier, AppState>((ref) {
  return AppStateNotifier();
});
