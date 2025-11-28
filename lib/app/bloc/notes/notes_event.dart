import 'package:equatable/equatable.dart';
import 'package:flutter_application_1/domain/entities/notes.dart';

abstract class NotesEvent extends Equatable {
  const NotesEvent();

  @override
  List<Object> get props => [];
}


class LoadNotes extends NotesEvent {
  final String uid;
  
  const LoadNotes(this.uid);

  @override
  List<Object> get props => [uid];
}

class AddNote extends NotesEvent{
  final String uid;
  final Note note;

  const AddNote(this.uid, this.note);

  @override
  List<Object> get props => [uid, note];
}


class NotesUpdated  extends NotesEvent {
  final List<Note> notes;
  final String uid;

  const NotesUpdated(this.notes, this.uid);

  @override
  List<Object> get props => [notes, uid];
}


class UpdateNote extends NotesEvent {
  final String uid;
  final Note note;

  const UpdateNote(this.uid, this.note);

  @override
  List<Object> get props => [uid, note];
}


class DeleteNote extends NotesEvent {
  final String uid;
  final String noteId;

  const DeleteNote(this.uid, this.noteId);

  @override
  List<Object> get props => [uid, noteId];
}

class ToggleTaskEvent extends NotesEvent {
  final String uid;
  final String noteId;
  final String taskId;

  const ToggleTaskEvent(this.uid, this.noteId, this.taskId,);

  @override
  List<Object> get props => [uid, noteId, taskId];
}


class AddTaskEvent extends NotesEvent {
  final String uid;
  final String noteId;
  final String taskText;

  const AddTaskEvent(this.uid, this.noteId, this.taskText,);

  @override
  List<Object> get props => [uid, noteId, taskText];
}


