// lib/data/models/note_model.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_application_1/domain/entities/notes.dart';
import 'task_model.dart';

class NoteModel extends Note {

  const NoteModel({
    required String id,
    required String title,
    required String content,
    required List<TaskModel> tasks,
    required DateTime createdAt,
    required DateTime updatedAt,
    bool pinned = false,
    String? color,
  }) : super(
          id: id,
          title: title,
          content: content,
          tasks: tasks,
          createdAt: createdAt,
          updatedAt: updatedAt,
          pinned: pinned,
          color: color,
        );

  factory NoteModel.fromDoc(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>? ?? {};
    final taskList = (data['tasks'] as List<dynamic>?)
            ?.map((t) => TaskModel.fromMap(Map<String, dynamic>.from(t as Map)))
            .toList() ??
        <TaskModel>[];
    final created = data['createdAt'] != null ? (data['createdAt'] as Timestamp).toDate() : DateTime.now();
    final updated = data['updatedAt'] != null ? (data['updatedAt'] as Timestamp).toDate() : created;
    return NoteModel(
      id: doc.id,
      title: data['title'] ?? '',
      content: data['content'] ?? '',
      tasks: taskList,
      createdAt: created,
      updatedAt: updated,
      pinned: data['pinned'] ?? false,
      color: data['color'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'content': content,
      'tasks': (tasks as List<TaskModel>).map((t) => t.toMap()).toList(),
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
      'pinned': pinned,
      'color': color,
    };
  }

  Note toEntity() {
    return Note(
      id: id,
      title: title,
      content: content,
      tasks: (tasks as List<TaskModel>).map((t) => t.toEntity()).toList(),
      createdAt: createdAt,
      updatedAt: updatedAt,
      pinned: pinned,
      color: color,
    );
  }
}
