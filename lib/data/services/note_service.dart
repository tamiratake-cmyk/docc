import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_application_1/data/models/notes_model.dart';
import 'package:flutter_application_1/domain/entities/notes.dart';

class NoteService {
   final FirebaseFirestore _db;

  NoteService({FirebaseFirestore? fireStore})
      : _db = fireStore ?? FirebaseFirestore.instance;


  Stream<List<NoteModel>> getNotes(String uid){
    
    return _db
    .collection('users/$uid/notes')
    .orderBy('timestamp', descending: true)
    .snapshots()
    .map((snapshot){
      return snapshot.docs.map((doc){
        return NoteModel.fromDoc(doc);
      }).toList();
    });

  }



  Future<DocumentReference> addNote(String uid, NoteModel note) async {
   return  await _db.collection('users/$uid/notes').add(note.toMap());
  }

  Future<void> updateNote(String uid, NoteModel note) async {
    await _db.collection('users/$uid/notes').doc(note.id).update(note.toMap());
  }

  Future<void> deleteNote(String uid, String noteId) async {
    await _db.collection('users/$uid/notes').doc(noteId).delete();
  }

}