import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_application_1/data/models/notes_model.dart';

class NoteService {
  // Don't access `FirebaseFirestore.instance` at construction time — access
  // it lazily so the service can be created on platforms where Firebase
  // isn't initialized (e.g., Linux during development).
  FirebaseFirestore get _db => FirebaseFirestore.instance;


  Stream<List<NotesModel>> getNotes(String uid){
    return _db
    .collection('users/$uid/notes')
    .orderBy('timestamp', descending: true)
    .snapshots()
    .map((snapshot){
      return snapshot.docs.map((doc){
        return NotesModel.fromMap(doc.id, doc.data());
      }).toList();
    });

  }

Future<void> toggleTask(
  String uid,
  NotesModel note,
  int taskIndex,
) async {
    final newTask = [...note.tasks];
    final task = newTask[taskIndex];

    newTask[taskIndex] = TaskItem(
      text: task.text,
      done: !task.done,
    );
    await _db
    .collection('users/$uid/notes')
      .doc(note.id)
      .update({
        'tasks': newTask.map((task) => task.toMap()).toList(),
      });
  }


  Future<void> addNote(String uid, NotesModel note) async {
    await _db.collection('users/$uid/notes').add(note.toMap());
  }

  Future<void> updateNote(String uid, NotesModel note) async {
    await _db.collection('users/$uid/notes').doc(note.id).update(note.toMap());
  }

  Future<void> deleteNote(String uid, String noteId) async {
    await _db.collection('users/$uid/notes').doc(noteId).delete();
  }

}