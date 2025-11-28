import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_application_1/domain/entities/task.dart';


class TaskModel extends TaskItem {

  TaskModel({
    required String id,
    required String text,
    required bool done,
    String? description,
    DateTime? dueDate,
    DateTime? reminderTime,
    TaskPriority priority = TaskPriority.normal,
    bool recurringWeekly = false,
    bool recurringDaily = false,
  }): super(
     id: id,
    text: text,
    done: done,
    description: description,
    dueDate: dueDate,
    reminderTime: reminderTime,
    priority: priority,
    recurringWeekly: recurringWeekly,
    recurringDaily: recurringDaily,
  );

  factory TaskModel.fromMap(Map<String, dynamic> data) {
    return TaskModel(
      id: data['id'] ?? '',
      text: data['text'] ?? '',
      done: data['done'] ?? false,
      description: data['description'],
      priority: TaskPriority.values[data['priority'] ?? 1],
      dueDate: data['dueDate'] != null ? (data['dueDate'] as Timestamp).toDate() : null,
      reminderTime: data['reminderTime'] != null ? (data['reminderTime'] as Timestamp).toDate() : null,
      recurringWeekly: data['recurringWeekly'] ?? false,
      recurringDaily: data['recurringDaily'] ?? false,
    );
  }

  Map<String, dynamic> toMap() => {
        "id": id,
        "text": text,
        "done": done,
        "description": description,
        "priority": priority.index,
        "dueDate": dueDate != null ? Timestamp.fromDate(dueDate!) : null,
        "reminderTime": reminderTime != null ? Timestamp.fromDate(reminderTime!) : null,
        "recurringWeekly": recurringWeekly,
        "recurringDaily": recurringDaily,
      };




      TaskItem toEntity(){
         return TaskItem(
            id: id,
            text: text,
            done: done,
            description: description,
            dueDate: dueDate,
            priority: priority,
            reminderTime: reminderTime,
            recurringWeekly: recurringWeekly,
            recurringDaily: recurringDaily,
         );
      }
}
