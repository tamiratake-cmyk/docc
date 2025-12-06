import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_application_1/data/models/notes_model.dart';
import 'package:flutter_application_1/data/models/task_model.dart';

class NoteService {
   final FirebaseFirestore _db;
   final FirebaseStorage _storage;

  NoteService({FirebaseFirestore? fireStore, FirebaseStorage? storage})
      : _db = fireStore ?? FirebaseFirestore.instance,
        _storage = storage ?? FirebaseStorage.instance;


  Stream<List<NoteModel>> getNotes(String uid){
    
    return _db
    .collection('users/$uid/notes')
    .orderBy('createdAt', descending: true)
    .snapshots()
    .map((snapshot){
      return snapshot.docs.map((doc){
        return NoteModel.fromDoc(doc);
      }).toList();
    });

  }

Future<void> toggleTask(
  String uid,
  NoteModel note,
  int taskIndex,
) async {
    final newTask = List<TaskModel>.from(note.tasks);
    final task = newTask[taskIndex];

    newTask[taskIndex] = TaskModel(
      id: task.id,
      text: task.text,
      done: !task.done,
      description: task.description,
      dueDate: task.dueDate,
      priority: task.priority,
      reminderTime: task.reminderTime,
      recurringWeekly: task.recurringWeekly,
      recurringDaily: task.recurringDaily,
    );
    
    await _db
    .collection('users/$uid/notes')
      .doc(note.id)
      .update({
        'tasks': newTask.map((t) => t.toMap()).toList(),
      });
  }


  Future<DocumentReference> addNote(String uid, NoteModel note) async {
   final data = note.toMap();
   data['keywords'] = _makeKeywords(note);
   return await _db.collection('users/$uid/notes').add(data);
  }

  List<String> _makeKeywords(NoteModel note) {
    final keywords = <String>{};
    final titleWords = note.title.toLowerCase().split(' ');
    final contentWords = note.content.toLowerCase().split(' ');

    for (var word in [...titleWords, ...contentWords]) {
      for (var i = 1; i <= word.length; i++) {
        keywords.add(word.substring(0, i));
      }
    }
    return keywords.toList();
  }

  Future<void> updateNote(String uid, NoteModel note) async {
    await _db.collection('users/$uid/notes').doc(note.id).update(note.toMap());
  }

  Future<void> deleteNote(String uid, String noteId) async {
    await _db.collection('users/$uid/notes').doc(noteId).delete();
  }

  Future<List<String>> uploadNoteImages(String uid, List<File> files) async {
    final urls = <String>[];
    for (final file in files) {
      final fileName = Uri.file(file.path).pathSegments.isNotEmpty
          ? Uri.file(file.path).pathSegments.last
          : 'note_image';
      final uniqueName =
          '${DateTime.now().millisecondsSinceEpoch}_${fileName.replaceAll(' ', '_')}';
      final ref = _storage
          .ref()
          .child('users/$uid/note_images/$uniqueName');
      final uploadTask = await ref.putFile(file);
      final url = await uploadTask.ref.getDownloadURL();
      urls.add(url);
    }
    return urls;
  }

  Future<List<NoteModel>> searchNotes(String uid, String query) async {
    final snapshot = await _db
    .collection('users/$uid/notes')
    .where('keywords', arrayContains: query.toLowerCase())
    .get();

    return snapshot.docs.map((doc) => NoteModel.fromDoc(doc)).toList();
  }

  Future<List<NoteModel>> filterNotesByTag(String uid, String tag) async {
    final snapshot = await _db
    .collection('users/$uid/notes')
    .where('tags', arrayContains: tag)
    .get();

    return snapshot.docs.map((doc) => NoteModel.fromDoc(doc)).toList();
  }



}