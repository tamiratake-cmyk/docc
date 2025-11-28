import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_application_1/data/models/notes_model.dart';
import 'package:flutter_application_1/domain/entities/notes.dart';

abstract class NoteRepository {
  Stream<List<Note>> getNotes(String uid);
  Future<Note> addNote(String uid, NoteModel note);
  Future<void> updateNote(String uid, NoteModel note);
  Future<void> deleteNote(String uid, String noteId);
}


