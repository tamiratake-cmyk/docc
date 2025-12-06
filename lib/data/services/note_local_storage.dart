import 'package:flutter_application_1/domain/entities/task.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_application_1/data/models/note_hive_model.dart' as hive_models;
import 'package:flutter_application_1/data/models/notes_model.dart';
import 'package:flutter_application_1/data/models/task_model.dart' as task_models;
import 'package:flutter_application_1/domain/entities/notes.dart';
import 'package:uuid/uuid.dart';



class NoteLocalStorage {
  static const String _notesBox = 'notes';
  late Box<hive_models.NoteHiveModel> _box;



  Future<void> init() async {
    await Hive.initFlutter();
    
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(hive_models.NoteHiveModelAdapter());
    }
    if (!Hive.isAdapterRegistered(1)) {
      Hive.registerAdapter(hive_models.TaskHiveModelAdapter());
    }
    if (!Hive.isAdapterRegistered(2)) {
      Hive.registerAdapter(hive_models.TaskPriorityAdapter());
    }
    
    _box = await Hive.openBox<hive_models.NoteHiveModel>(_notesBox);

  }

  // Convert from domain entity to Hive model
  hive_models.NoteHiveModel _toHiveModel(Note note, {bool isSynced = false}) {
    return hive_models.NoteHiveModel(
      id: note.id.isEmpty ? const Uuid().v4() : note.id,
      title: note.title,
      content: note.content,
      tags: note.tags,
      tasks: note.tasks.map((t) => hive_models.TaskHiveModel(
        id: t.id,
        text: t.text,
        done: t.done,
        description: t.description,
        dueDate: t.dueDate,
        priority: hive_models.TaskPriority.values[t.priority.index],
        reminderTime: t.reminderTime,
        recurringWeekly: t.recurringWeekly,
        recurringDaily: t.recurringDaily,
      )).toList(),
      createdAt: note.createdAt,
      updatedAt: note.updatedAt,
      pinned: note.pinned,
      color: note.color,
      imageUrls: note.imageUrls,
      isSynced: isSynced,
      isDeleted: false,
    );
  }

  // Convert from Hive model to domain entity
  Note _toEntity(hive_models.NoteHiveModel hiveNote) {
    return Note(
      id: hiveNote.id,
      title: hiveNote.title,
      content: hiveNote.content,
      tags: hiveNote.tags,
      tasks: hiveNote.tasks.map((t) => task_models.TaskModel(
        id: t.id,
        text: t.text,
        done: t.done,
        description: t.description,
        dueDate: t.dueDate,
        priority: TaskPriority.values[t.priority.index],
        reminderTime: t.reminderTime,
        recurringWeekly: t.recurringWeekly,
        recurringDaily: t.recurringDaily,
      )).toList(),
      createdAt: hiveNote.createdAt,
      updatedAt: hiveNote.updatedAt,
      pinned: hiveNote.pinned,
      color: hiveNote.color,
      imageUrls: hiveNote.imageUrls,
    );
  }

  // Get all notes (excluding deleted)
  Future<List<Note>> getAllNotes() async {
    final notes = _box.values
        .where((note) => !note.isDeleted)
        .map((note) => _toEntity(note))
        .toList();
    
    // Sort by creation date (newest first)
    notes.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return notes;
  }

  // Add a new note
  Future<Note> addNote(Note note) async {
    final hiveNote = _toHiveModel(note);
    await _box.put(hiveNote.id, hiveNote);
    return _toEntity(hiveNote);
  }

  // Update an existing note
  Future<void> updateNote(Note note) async {
    final existing = _box.get(note.id);
    if (existing != null) {
      final updated = _toHiveModel(
        note.copyWith(updatedAt: DateTime.now()),
        isSynced: false, // Mark as not synced after local update
      );
      await _box.put(note.id, updated);
    }
  }

  // Delete a note (soft delete)
  Future<void> deleteNote(String noteId) async {
    final note = _box.get(noteId);
    if (note != null) {
      note.isDeleted = true;
      note.isSynced = false;
      await note.save();
    }
  }

  // Search notes by query
  Future<List<Note>> searchNotes(String query) async {
    final lowerQuery = query.toLowerCase();
    final notes = _box.values
        .where((note) => 
            !note.isDeleted &&
            (note.title.toLowerCase().contains(lowerQuery) ||
             note.content.toLowerCase().contains(lowerQuery)))
        .map((note) => _toEntity(note))
        .toList();
    
    notes.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return notes;
  }

  // Filter notes by tag
  Future<List<Note>> filterNotesByTag(String tag) async {
    final notes = _box.values
        .where((note) => 
            !note.isDeleted &&
            note.tags != null &&
            note.tags!.contains(tag))
        .map((note) => _toEntity(note))
        .toList();
    
    notes.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return notes;
  }

  // Get unsynced notes (for sync to Firestore)
  Future<List<hive_models.NoteHiveModel>> getUnsyncedNotes() async {
    return _box.values.where((note) => !note.isSynced).toList();
  }

  // Mark note as synced
  Future<void> markAsSynced(String noteId, DateTime syncTime) async {
    final note = _box.get(noteId);
    if (note != null) {
      note.isSynced = true;
      note.lastSyncedAt = syncTime;
      await note.save();
    }
  }

  // Update note from Firestore (for sync from cloud)
  Future<void> updateFromFirestore(NoteModel firestoreNote) async {
    final existing = _box.get(firestoreNote.id);
    
    if (existing == null || existing.updatedAt.isBefore(firestoreNote.updatedAt)) {
      // Firestore version is newer or doesn't exist locally
      final hiveNote = hive_models.NoteHiveModel(
        id: firestoreNote.id,
        title: firestoreNote.title,
        content: firestoreNote.content,
        tags: firestoreNote.tags,
        tasks: firestoreNote.tasks.map((t) => hive_models.TaskHiveModel(
          id: t.id,
          text: t.text,
          done: t.done,
          description: t.description,
          dueDate: t.dueDate,
          priority: hive_models.TaskPriority.values[t.priority.index],
          reminderTime: t.reminderTime,
          recurringWeekly: t.recurringWeekly,
          recurringDaily: t.recurringDaily,
        )).toList(),
        createdAt: firestoreNote.createdAt,
        updatedAt: firestoreNote.updatedAt,
        pinned: firestoreNote.pinned,
        color: firestoreNote.color,
        imageUrls: firestoreNote.imageUrls,
        isSynced: true,
        isDeleted: false,
        lastSyncedAt: DateTime.now(),
      );
      await _box.put(firestoreNote.id, hiveNote);
    }
  }

  // Clear all notes (for logout or testing)
  Future<void> clearAll() async {
    await _box.clear();
  }

  // Get note by ID
  Note? getNote(String id) {
    final hiveNote = _box.get(id);
    if (hiveNote != null && !hiveNote.isDeleted) {
      return _toEntity(hiveNote);
    }
    return null;
  }
}
