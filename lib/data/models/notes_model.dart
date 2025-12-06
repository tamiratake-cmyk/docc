

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_application_1/data/models/task_model.dart';
import 'package:flutter_application_1/domain/entities/notes.dart';

class NoteModel extends Note {
  const NoteModel({
    required String id,
    required String title,
    required String content,
    required List<String>? tags,
    required List<TaskModel> tasks,
    required DateTime createdAt,
    required DateTime updatedAt,
    bool pinned = false,
    String? color,
    List<String> imageUrls = const [],
  }) : super(
          id: id,
          title: title,
          content: content,
          tags: tags,
          tasks: tasks,
          createdAt: createdAt,
          updatedAt: updatedAt,
          pinned: pinned,
          color: color,
          imageUrls: imageUrls,
        );

  factory NoteModel.fromDoc(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>? ?? {};

    final taskList = (data['tasks'] as List<dynamic>?)
            ?.map((t) => TaskModel.fromMap(Map<String, dynamic>.from(t as Map)))
            .toList() ??
        <TaskModel>[];

    final created = data['createdAt'] != null
        ? (data['createdAt'] as Timestamp).toDate()
        : DateTime.now();
    final updated = data['updatedAt'] != null
        ? (data['updatedAt'] as Timestamp).toDate()
        : created;

    return NoteModel(
      id: doc.id,
      title: data['title'] ?? '',
      content: data['content'] ?? '',
      tags: data['tags'] != null
          ? List<String>.from(data['tags'] as List<dynamic>)
          : null,
      tasks: taskList,
      createdAt: created,
      updatedAt: updated,
      pinned: data['pinned'] ?? false,
      color: data['color'],
      imageUrls: data['imageUrls'] != null
          ? List<String>.from(data['imageUrls'] as List<dynamic>)
          : const [],
    );
  }

  factory NoteModel.fromEntity(Note note) {
    return NoteModel(
      id: note.id,
      title: note.title,
      content: note.content,
      tags: note.tags,
      tasks: note.tasks
          .map((t) => t is TaskModel
              ? t
              : TaskModel(
                  id: t.id,
                  text: t.text,
                  done: t.done,
                  description: t.description,
                  dueDate: t.dueDate,
                  reminderTime: t.reminderTime,
                  priority: t.priority,
                  recurringWeekly: t.recurringWeekly,
                  recurringDaily: t.recurringDaily,
                ))
          .toList(),
      createdAt: note.createdAt,
      updatedAt: note.updatedAt,
      pinned: note.pinned,
      color: note.color,
      imageUrls: note.imageUrls,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'content': content,
      'tags': tags,
      'tasks': (tasks as List<TaskModel>).map((t) => t.toMap()).toList(),
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
      'pinned': pinned,
      'color': color,
      'imageUrls': imageUrls,
    };
  }

  Note toEntity() {
    return Note(
      id: id,
      title: title,
      content: content,
      tags: tags,
      tasks: (tasks as List<TaskModel>).map((t) => t.toEntity()).toList(),
      createdAt: createdAt,
      updatedAt: updatedAt,
      pinned: pinned,
      color: color,
      imageUrls: imageUrls,
    );
  }
}