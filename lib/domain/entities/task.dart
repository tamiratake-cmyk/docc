import 'package:cloud_firestore/cloud_firestore.dart';

enum TaskPriority { low, normal, high }

class TaskItem {
  final String id;
  final String text;
  final bool done;
  final String? description;
  final DateTime? dueDate;
  final TaskPriority priority;
  final DateTime? reminderTime;
  final bool recurringWeekly;
  final bool recurringDaily;

  TaskItem({
    required this.id,
    required this.text,
    required this.done,
    this.description,
    this.dueDate,
    this.reminderTime,
    this.priority = TaskPriority.normal,
    this.recurringWeekly = false,
    this.recurringDaily = false,
  });


TaskItem copyWith({
  String? id,
  String? text,
  bool? done,
  String? description,
  DateTime? dueDate,
  TaskPriority? priority,
  DateTime? reminderTime,
  bool? recurringDaily,
  bool? recurringWeekly

}){
  return TaskItem(
    id: id ?? this.id,
    text: text ?? this.text,
    done: done ?? this.done,
    description: description ?? this.description,
    dueDate: dueDate ?? this.dueDate,
    priority: priority ?? this.priority,
    reminderTime: reminderTime ?? this.reminderTime,
    recurringWeekly: recurringWeekly ?? this.recurringWeekly,
    recurringDaily: recurringDaily ?? this.recurringDaily, 
  );
}

}