import 'package:equatable/equatable.dart';
import 'package:flutter_application_1/domain/entities/notes.dart';
import 'package:flutter_application_1/domain/entities/task.dart';

abstract class NotesEvent extends Equatable {
  const NotesEvent();

  @override
  List<Object> get props => [];
}


class LoadNotes extends NotesEvent {
  const LoadNotes();
}

class AddNote extends NotesEvent{
  final Note note;
  final List<String> attachmentPaths;

  const AddNote(this.note, {this.attachmentPaths = const []});

  @override
  List<Object> get props => [note, attachmentPaths];
}

class searchNotes extends NotesEvent {
  final String query;

  const searchNotes(this.query);

  @override
  List<Object> get props => [query];
}

class FilterNotesByTag extends NotesEvent {
  final String tag;

  const FilterNotesByTag(this.tag);

  @override
  List<Object> get props => [tag];
}

class NotesUpdated  extends NotesEvent {
  final List<Note> notes;
  final String uid;

  const NotesUpdated(this.notes, this.uid);

  @override
  List<Object> get props => [notes, uid];
}


class UpdateNote extends NotesEvent {
  final Note note;
  final List<String> newAttachmentPaths;
  final List<String> retainedImageUrls;

  const UpdateNote(
    this.note, {
    this.newAttachmentPaths = const [],
    this.retainedImageUrls = const [],
  });

  @override
  List<Object> get props => [note, newAttachmentPaths, retainedImageUrls];
}



class DeleteNote extends NotesEvent {
  final String noteId;

  const DeleteNote(this.noteId);

  @override
  List<Object> get props => [noteId];
}

class RestoreNote extends NotesEvent {
  final Note note;

  const RestoreNote(this.note);

  @override
  List<Object> get props => [note];
}

class ToggleTaskEvent extends NotesEvent {
  final String noteId;
  final String taskId;

  const ToggleTaskEvent(this.noteId, this.taskId,);

  @override
  List<Object> get props => [noteId, taskId];
}


class AddTaskEvent extends NotesEvent {
  final String noteId;
  final TaskItem task;

  const AddTaskEvent(this.noteId, this.task);

  @override
  List<Object> get props => [noteId, task];
}

class RestoreDeletedNotes extends NotesEvent {
  final String uid;
  final List<Note> deletedNotes;

  const RestoreDeletedNotes(this.uid, this.deletedNotes);

  @override
  List<Object> get props => [uid, deletedNotes];
}
