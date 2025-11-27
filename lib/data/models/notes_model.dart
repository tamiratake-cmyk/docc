import 'package:cloud_firestore/cloud_firestore.dart';

class NotesModel {
  final String id;
  final String title;
  final String content;
  final bool completed;
  final Timestamp timestamp;


  NotesModel({
    required this.id,
    required this.title,
    required this.content,
    required this.completed,
    required this.timestamp,
  });

  factory NotesModel.fromMap(String id, Map<String, dynamic> data) {
    return NotesModel(
      id: id,
      title: data['title'] ?? '',
      content: data['content'] ?? '',
      completed: data['completed'] ?? false,
      timestamp: data['timestamp'] ?? Timestamp.now(),
    );
  }


  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'content': content,
      'completed': completed,
      'timestamp': timestamp,
    };
  }
}