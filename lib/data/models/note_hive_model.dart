
import 'package:hive/hive.dart';

part 'note_hive_model.g.dart';
  


@HiveType(typeId: 2)
enum TaskPriority {
  @HiveField(0)
  low,
  @HiveField(1)
  normal,
  @HiveField(2)
  high,
}


@HiveType(typeId: 0)
class NoteHiveModel extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String title;

  @HiveField(2)
  String content;

  @HiveField(3)
  List<String>? tags;

  @HiveField(4)
  List<TaskHiveModel> tasks;

  @HiveField(5)
  DateTime createdAt;

  @HiveField(6)
  DateTime updatedAt;

  @HiveField(7)
  bool pinned;

  @HiveField(8)
  String? color;

  @HiveField(9)
  List<String> imageUrls;

  @HiveField(10)
  bool isSynced;

  @HiveField(11)
  bool isDeleted;

  @HiveField(12)
  DateTime? lastSyncedAt;

  NoteHiveModel({
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
    this.isSynced = false,
    this.isDeleted = false,
    this.lastSyncedAt,
  });
}

@HiveType(typeId: 1)
class TaskHiveModel extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String text;

  @HiveField(2)
  bool done;

  @HiveField(3)
  String? description;

  @HiveField(4)
  DateTime? dueDate;

  @HiveField(5)
  TaskPriority priority;

  @HiveField(6)
  DateTime? reminderTime;

  @HiveField(7)
  bool recurringWeekly;

  @HiveField(8)
  bool recurringDaily;

  TaskHiveModel({
    required this.id,
    required this.text,
    this.done = false,
    this.description,
    this.dueDate,
    this.priority= TaskPriority.normal,
    this.reminderTime,
    this.recurringWeekly = false,
    this.recurringDaily = false,
  });
}
