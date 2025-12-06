// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'note_hive_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class NoteHiveModelAdapter extends TypeAdapter<NoteHiveModel> {
  @override
  final int typeId = 0;

  @override
  NoteHiveModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return NoteHiveModel(
      id: fields[0] as String,
      title: fields[1] as String,
      content: fields[2] as String,
      tags: (fields[3] as List?)?.cast<String>(),
      tasks: (fields[4] as List).cast<TaskHiveModel>(),
      createdAt: fields[5] as DateTime,
      updatedAt: fields[6] as DateTime,
      pinned: fields[7] as bool,
      color: fields[8] as String?,
      imageUrls: (fields[9] as List).cast<String>(),
      isSynced: fields[10] as bool,
      isDeleted: fields[11] as bool,
      lastSyncedAt: fields[12] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, NoteHiveModel obj) {
    writer
      ..writeByte(13)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.content)
      ..writeByte(3)
      ..write(obj.tags)
      ..writeByte(4)
      ..write(obj.tasks)
      ..writeByte(5)
      ..write(obj.createdAt)
      ..writeByte(6)
      ..write(obj.updatedAt)
      ..writeByte(7)
      ..write(obj.pinned)
      ..writeByte(8)
      ..write(obj.color)
      ..writeByte(9)
      ..write(obj.imageUrls)
      ..writeByte(10)
      ..write(obj.isSynced)
      ..writeByte(11)
      ..write(obj.isDeleted)
      ..writeByte(12)
      ..write(obj.lastSyncedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NoteHiveModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class TaskHiveModelAdapter extends TypeAdapter<TaskHiveModel> {
  @override
  final int typeId = 1;

  @override
  TaskHiveModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TaskHiveModel(
      id: fields[0] as String,
      text: fields[1] as String,
      done: fields[2] as bool,
      description: fields[3] as String?,
      dueDate: fields[4] as DateTime?,
      priority: fields[5] as TaskPriority,
      reminderTime: fields[6] as DateTime?,
      recurringWeekly: fields[7] as bool,
      recurringDaily: fields[8] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, TaskHiveModel obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.text)
      ..writeByte(2)
      ..write(obj.done)
      ..writeByte(3)
      ..write(obj.description)
      ..writeByte(4)
      ..write(obj.dueDate)
      ..writeByte(5)
      ..write(obj.priority)
      ..writeByte(6)
      ..write(obj.reminderTime)
      ..writeByte(7)
      ..write(obj.recurringWeekly)
      ..writeByte(8)
      ..write(obj.recurringDaily);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TaskHiveModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class TaskPriorityAdapter extends TypeAdapter<TaskPriority> {
  @override
  final int typeId = 2;

  @override
  TaskPriority read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return TaskPriority.low;
      case 1:
        return TaskPriority.normal;
      case 2:
        return TaskPriority.high;
      default:
        return TaskPriority.low;
    }
  }

  @override
  void write(BinaryWriter writer, TaskPriority obj) {
    switch (obj) {
      case TaskPriority.low:
        writer.writeByte(0);
        break;
      case TaskPriority.normal:
        writer.writeByte(1);
        break;
      case TaskPriority.high:
        writer.writeByte(2);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TaskPriorityAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
