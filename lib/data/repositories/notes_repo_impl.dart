import 'dart:io';
import 'dart:async';

import 'package:flutter_application_1/data/services/note_service.dart';
import 'package:flutter_application_1/data/services/note_local_storage.dart';
import 'package:flutter_application_1/data/services/note_sync_service.dart';
import 'package:flutter_application_1/domain/entities/notes.dart';
import 'package:flutter_application_1/domain/repositories/note_repository.dart';


class NotesRepoImpl implements NoteRepository {
  final NoteService? noteService;
  final NoteLocalStorage localStorage;
  final String? userId;
  late final NoteSyncService _syncService;

  NotesRepoImpl({
    required this.localStorage,
    this.noteService,
    this.userId,
  }) {
    _syncService = NoteSyncService(
      localStorage: localStorage,
      remoteService: noteService,
      userId: userId,
    );

    // Start auto-sync if user is logged in
    if (userId != null && noteService != null) {
      _syncService.startAutoSync();
    }
  }

  @override
  Stream<List<Note>> getNotes([String? uid]) {
    // If logged in, sync from Firestore then return local stream
    if ((uid ?? userId) != null && noteService != null) {
      // Trigger sync in background
      _syncService.syncFromFirestore();
      // Return stream that updates from local storage
      return Stream.periodic(const Duration(seconds: 1))
          .asyncMap((_) => localStorage.getAllNotes())
          .distinct();
    }
    // Guest mode: return local notes only
    return Stream.periodic(const Duration(seconds: 1))
        .asyncMap((_) => localStorage.getAllNotes())
        .distinct();
  }

  @override
  Future<Note> addNote([String? uid, Note? note]) async {
    if (note == null) throw ArgumentError('Note must not be null');
    // Always save to local storage first
    final savedNote = await localStorage.addNote(note);
    // If logged in, sync to Firestore in background
    if ((uid ?? userId) != null && noteService != null) {
      _syncService.syncToFirestore();
    }
    return savedNote;
  }

  @override
  Future<void> updateNote([String? uid, Note? note]) async {
    if (note == null) throw ArgumentError('Note must not be null');
    // Always update local storage first
    await localStorage.updateNote(note);
    // If logged in, sync to Firestore in background
    if ((uid ?? userId) != null && noteService != null) {
      _syncService.syncToFirestore();
    }
  }

  @override
  Future<void> deleteNote([String? uid, String? noteId]) async {
    if (noteId == null) throw ArgumentError('noteId must not be null');
    // Always delete from local storage first
    await localStorage.deleteNote(noteId);
    // If logged in, sync to Firestore in background
    if ((uid ?? userId) != null && noteService != null) {
      _syncService.syncToFirestore();
    }
  }


  @override
  Future<void> toggleTask([String? uid, Note? note, int? taskIndex]) async {
    if (note == null || taskIndex == null) throw ArgumentError('note and taskIndex must not be null');
    // Update task in local storage
    final updatedNote = note.copyWith(
      tasks: List.from(note.tasks)..[taskIndex] = note.tasks[taskIndex].copyWith(
        done: !note.tasks[taskIndex].done,
      ),
      updatedAt: DateTime.now(),
    );
    await localStorage.updateNote(updatedNote);
    // If logged in, sync to Firestore in background
    if ((uid ?? userId) != null && noteService != null) {
      _syncService.syncToFirestore();
    }
  }

  @override
  Future<List<Note>> searchNotes([String? uid, String? query]) async {
    if (query == null) return await localStorage.getAllNotes();
    // Search in local storage
    return await localStorage.searchNotes(query);
  }

  @override
  Future<List<Note>> filterNotesByTag([String? uid, String? tag]) async {
    if (tag == null) return await localStorage.getAllNotes();
    // Filter from local storage
    return await localStorage.filterNotesByTag(tag);
  }

  @override
  Future<List<String>> uploadNoteImages([String? uid, List<String>? filePaths]) async {
    final files = (filePaths ?? []).map((p) => File(p)).where((file) => file.existsSync()).toList();
    if (files.isEmpty) return const [];
    // If logged in, upload to Firebase Storage
    if ((uid ?? userId) != null && noteService != null) {
      return await noteService!.uploadNoteImages(uid ?? userId!, files);
    }
    // Guest mode: store local file paths
    return filePaths ?? [];
  }

}