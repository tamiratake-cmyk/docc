import 'package:cloud_firestore/cloud_firestore.dart';

class TaskItem {
   final String text;
    final bool done;

  TaskItem({
    required this.text,
    required this.done,
  });

  factory TaskItem.fromMap(Map<String, dynamic> data) {
    return TaskItem(
      text: data['text'] ?? '',
      done: data['done'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'text': text,
      'done': done,
    };
  }


}

class NotesModel {
  final String id;
  final String title;
  final String content;
  final List<TaskItem> tasks;
  final Timestamp timestamp;


  NotesModel({
    required this.id,
    required this.title,
    required this.content,
    required this.tasks,
    required this.timestamp,
  });

  factory NotesModel.fromMap(String id, Map<String, dynamic> data) {
    return NotesModel(
      id: id,
      title: data['title'] ?? '',
      content: data['content'] ?? '',
      tasks: (data['tasks'] as List<dynamic>?)
          ?.map((item) => TaskItem.fromMap(item as Map<String, dynamic>))
          .toList() ??
          [],
      timestamp: data['timestamp'] ?? Timestamp.now(),
    );
  }


  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'content': content,
      'tasks': tasks.map((task) => task.toMap()).toList(),
      'timestamp': timestamp,
    };
  }
}