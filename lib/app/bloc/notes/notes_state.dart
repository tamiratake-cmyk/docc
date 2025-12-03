import 'package:equatable/equatable.dart';
import 'package:flutter_application_1/domain/entities/notes.dart';

abstract class NotesState extends Equatable{
    const NotesState();
    @override
    List<Object> get props => [];
}


class NotesLoading extends NotesState{}


class NotesInitial extends NotesState{}

class NotesLoaded extends NotesState{
  final List<Note> notes;
  final String uid;
  final List<String> availableTags;

  final String? query;
  final String? tag;

  const NotesLoaded(this.notes, this.uid, {this.availableTags = const [], this.query, this.tag});

  @override
  List<Object> get props => [notes, uid, availableTags, query ?? '', tag ?? ''];
}

class NotesFailure extends NotesState{
  final String error;

  const NotesFailure(this.error);

  @override
  List<Object> get props => [error];
}