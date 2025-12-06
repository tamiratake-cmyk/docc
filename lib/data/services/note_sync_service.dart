import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_application_1/data/models/note_hive_model.dart' hide TaskPriority;
import 'package:flutter_application_1/data/models/notes_model.dart';
import 'package:flutter_application_1/data/models/task_model.dart';
import 'package:flutter_application_1/data/services/note_local_storage.dart';
import 'package:flutter_application_1/data/services/note_service.dart';
import 'package:flutter_application_1/domain/entities/task.dart';

class NoteSyncService {
  final NoteLocalStorage localStorage;
  final NoteService? remoteService;
  final String? userId;
  
  StreamSubscription? _connectivitySubscription;
  bool _isSyncing = false;

  NoteSyncService({
    required this.localStorage,
    this.remoteService,
    this.userId,
  });

  /// Start listening to connectivity changes and sync when online
  void startAutoSync() {
    _connectivitySubscription = Connectivity().onConnectivityChanged.listen((result) {
      if (result != ConnectivityResult.none && userId != null && remoteService != null) {
        syncToFirestore();
      }
    });
  }

  /// Stop auto-sync
  void stopAutoSync() {
    _connectivitySubscription?.cancel();
  }

  /// Sync local changes to Firestore
  Future<void> syncToFirestore() async {
    if (_isSyncing || userId == null || remoteService == null) return;
    
    _isSyncing = true;
    try {
      final unsyncedNotes = await localStorage.getUnsyncedNotes();
      
      for (final hiveNote in unsyncedNotes) {
        try {
          if (hiveNote.isDeleted) {
            // Delete from Firestore
            await remoteService!.deleteNote(userId!, hiveNote.id);
          } else {
            // Convert to NoteModel
            final noteModel = NoteModel(
              id: hiveNote.id,
              title: hiveNote.title,
              content: hiveNote.content,
              tags: hiveNote.tags,
              tasks: hiveNote.tasks.map((t) => TaskModelAdapter.fromHive(t)).toList(),
              createdAt: hiveNote.createdAt,
              updatedAt: hiveNote.updatedAt,
              pinned: hiveNote.pinned,
              color: hiveNote.color,
              imageUrls: hiveNote.imageUrls,
            );

            // Check if note exists in Firestore
            final docSnapshot = await FirebaseFirestore.instance
                .collection('users/$userId/notes')
                .doc(hiveNote.id)
                .get();

            if (docSnapshot.exists) {
              // Update existing note
              await remoteService!.updateNote(userId!, noteModel);
            } else {
              // Create new note with the local ID
              await FirebaseFirestore.instance
                  .collection('users/$userId/notes')
                  .doc(hiveNote.id)
                  .set(noteModel.toMap());
            }
          }

          // Mark as synced
          await localStorage.markAsSynced(hiveNote.id, DateTime.now());
        } catch (e) {
          print('Error syncing note ${hiveNote.id}: $e');
          // Continue with other notes
        }
      }
    } finally {
      _isSyncing = false;
    }
  }

  /// Sync from Firestore to local storage
  Future<void> syncFromFirestore() async {
    if (userId == null || remoteService == null) return;

    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('users/$userId/notes')
          .get();

      for (final doc in snapshot.docs) {
        final firestoreNote = NoteModel.fromDoc(doc);
        await localStorage.updateFromFirestore(firestoreNote);
      }
    } catch (e) {
      print('Error syncing from Firestore: $e');
    }
  }

  /// Full bi-directional sync
  Future<void> fullSync() async {
    if (userId == null || remoteService == null) return;

    await syncToFirestore();
    await syncFromFirestore();
  }

  /// Check if device is online
  Future<bool> isOnline() async {
    final result = await Connectivity().checkConnectivity();
    return result != ConnectivityResult.none;
  }
}

// Helper to convert TaskHiveModel to TaskModel
extension TaskModelAdapter on TaskModel {
  static TaskModel fromHive(TaskHiveModel hive) {
    // Parse priority from string or default to normal
    TaskPriority priority = TaskPriority.normal;
    if (hive.priority != null) {
      try {
        final priorityIndex = int.tryParse((hive.priority).toString()) ?? 1;
        if (priorityIndex >= 0 && priorityIndex < TaskPriority.values.length) {
          priority = TaskPriority.values[priorityIndex];
        }
      } catch (e) {
        // Use default priority if parsing fails
      }
    }

    return TaskModel(
      id: hive.id,
      text: hive.text,
      done: hive.done,
      description: hive.description,
      dueDate: hive.dueDate,
      priority: priority,
      reminderTime: hive.reminderTime,
      recurringWeekly: hive.recurringWeekly,
      recurringDaily: hive.recurringDaily,
    );
  }
}
