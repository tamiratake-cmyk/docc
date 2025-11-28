// lib/domain/entities/note.dart
import 'task.dart';

class Note {
  final String id;
  final String title;
  final String content;
  final List<TaskItem> tasks;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool pinned;
  final String? color;

  const Note({
    required this.id,
    required this.title,
    required this.content,
    required this.tasks,
    required this.createdAt,
    required this.updatedAt,
    this.pinned = false,
    this.color,
  });

  Note copyWith({
    String? id,
    String? title,
    String? content,
    List<TaskItem>? tasks,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? pinned,
    String? color,
  }) {
    return Note(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      tasks: tasks ?? this.tasks,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      pinned: pinned ?? this.pinned,
      color: color ?? this.color,
    );
  }
}
