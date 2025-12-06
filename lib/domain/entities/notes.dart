// lib/domain/entities/note.dart
import 'task.dart';

class Note {
  final String id;
  final String title;
  final String content;
  final List<String>? tags;
  final List<TaskItem> tasks;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool pinned;
  final String? color;
  final List<String> imageUrls;

  const Note({
    required this.id,
    required this.title,
    required this.content,
    this.tags,
    required this.tasks,
    required this.createdAt,
    required this.updatedAt,
    this.pinned = false,
    this.color,
    this.imageUrls = const [],
  });

  Note copyWith({
    String? id,
    String? title,
    String? content,
    List<String>? tags,
    List<TaskItem>? tasks,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? pinned,
    String? color,
    List<String>? imageUrls,
  }) {
    return Note(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      tags: tags ?? this.tags,
      tasks: tasks ?? this.tasks,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      pinned: pinned ?? this.pinned,
      color: color ?? this.color,
      imageUrls: imageUrls ?? this.imageUrls,
    );
  }
}
