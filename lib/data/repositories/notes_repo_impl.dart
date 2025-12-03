import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_application_1/data/models/notes_model.dart';
import 'package:flutter_application_1/data/models/task_model.dart';
import 'package:flutter_application_1/data/services/note_service.dart';
import 'package:flutter_application_1/domain/entities/notes.dart';
import 'package:flutter_application_1/domain/entities/task.dart';
import 'package:flutter_application_1/domain/repositories/note_repository.dart';

class NotesRepoImpl implements NoteRepository {
  final NoteService noteService;  

  NotesRepoImpl({required this.noteService });

  @override
  Stream<List<Note>> getNotes(String uid) {
    return noteService.getNotes(uid).map((models) => models.map((m) => m.toEntity()).toList());
  }

  @override
  Future<Note> addNote(String uid, Note note) async {
    final model = NoteModel(
      id: '',
      title: note.title,
      content: note.content,
      tags: note.tags,
      tasks: note.tasks.map((t) => TaskModel(
        id: t.id,
        text: t.text,
        done: t.done,
        description: t.description,
        dueDate: t.dueDate,
        priority: t.priority,
        reminderTime: t.reminderTime,
        recurringWeekly: t.recurringWeekly,
        recurringDaily: t.recurringDaily,
      )).toList(),
      createdAt: note.createdAt,
      updatedAt: note.updatedAt,
      pinned: note.pinned,
      color: note.color,
    );

    final docRef = await noteService.addNote(uid, model);
    final createdDoc = await docRef.get();
    final addedModel = NoteModel.fromDoc(createdDoc);
    return addedModel.toEntity();
  }

  @override
  Future<void> updateNote(String uid, Note note) async {
    // convert Note entity to NoteModel
    final model = NoteModel(
      id: note.id,
      title: note.title,
      content: note.content,
      tags: note.tags,
      tasks: note.tasks.map((t) => TaskModel(
        id: t.id,
        text: t.text,
        done: t.done,
        description: t.description,
        dueDate: t.dueDate,
        priority: t.priority,
        reminderTime: t.reminderTime,
        recurringWeekly: t.recurringWeekly,
        recurringDaily: t.recurringDaily,
      )).toList(),
      createdAt: note.createdAt,
      updatedAt: note.updatedAt,
      pinned: note.pinned,
      color: note.color,
    );
    await noteService.updateNote(uid, model);
  }

  @override
  Future<void> deleteNote(String uid, String noteId) {
    return noteService.deleteNote(uid, noteId);
  }


  @override
  Future<void> toggleTask(String uid, Note note, int taskIndex) async {
    final model = NoteModel.fromEntity(note);
    await noteService.toggleTask(uid, model, taskIndex);
  }

  @override
  Future<List<Note>> searchNotes(String uid, String query) async {
    final result = await noteService.searchNotes(uid, query);
   
    return result;
}

  @override
  Future<List<Note>> filterNotesByTag(String uid, String tag) async {
    final result = await noteService.filterNotesByTag(uid, tag);
    return result.map((m) => m.toEntity()).toList();
  }

}