import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_application_1/data/models/notes_model.dart';
import 'package:flutter_application_1/domain/entities/notes.dart';

abstract class NoteRepository {
  
  
  Stream<List<Note>> getNotes(String uid);
  Future<Note> addNote(String uid, NoteModel note);
  Future<void> updateNote(String uid, NoteModel note);
  Future<void> deleteNote(String uid, String noteId);


  Future<void> toggleTask(
    String uid,
    NoteModel note,
    int taskIndex,
  );


  Future<List<Note>> searchNotes(String uid, String query);
  Future<List<Note>> filterNotesByTag(String uid, String tag);
  Future<List<String>> uploadNoteImages(String uid, List<String> filePaths);

}


