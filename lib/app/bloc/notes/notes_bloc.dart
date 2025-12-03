import 'dart:async';
import 'dart:math';

import 'package:flutter_application_1/app/bloc/notes/notes_event.dart';
import 'package:flutter_application_1/app/bloc/notes/notes_state.dart';
import 'package:flutter_application_1/data/models/notes_model.dart';
import 'package:flutter_application_1/data/models/task_model.dart';
import 'package:flutter_application_1/domain/entities/notes.dart';
import 'package:flutter_application_1/domain/repositories/auth_repository.dart';
import 'package:flutter_application_1/domain/repositories/note_repository.dart';
import 'package:flutter_application_1/utils/notification_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NotesBloc extends Bloc<NotesEvent, NotesState> {
  final NoteRepository noteRepository;
  final AuthRepository authRepository;
  StreamSubscription<List<Note>>? _noteSubscription;

  NotesBloc({
    required this.noteRepository,
    required this.authRepository,
  }) : super(NotesInitial()) {
    on<LoadNotes>(_onLoadNotes);
    on<NotesUpdated>(_onNotesUpdated);
    on<AddNote>(_onAddNote);
    on<searchNotes>(_onSearchNotes);
    on<FilterNotesByTag>(_onFilterNotesByTag);
    on<UpdateNote>(_onUpdateNote);
    on<DeleteNote>(_onDeleteNote);
    on<RestoreNote>(_onRestoreNote);
    on<ToggleTaskEvent>(_onToggleTask);
    on<AddTaskEvent>(_onAddTask);
  }

  Future<void> _onLoadNotes(LoadNotes event, Emitter<NotesState> emit) async {
    final uid = authRepository.currentUserId();
    if (uid == null) {
      emit(const NotesFailure("User not authenticated"));
      return;
    }
    emit(NotesLoading());
    await _noteSubscription?.cancel();
    _noteSubscription = noteRepository.getNotes(uid).listen(
          (notes) => add(NotesUpdated(notes, uid)),
          onError: (error) {
            emit(NotesFailure(error.toString()));
          },
        );
  }

  void _onNotesUpdated(NotesUpdated event, Emitter<NotesState> emit) {
    final tags = event.notes.expand((n) => n.tags ?? []).cast<String>().toSet().toList();
    emit(NotesLoaded(event.notes, event.uid, availableTags: tags));
  }

  Future<void> _onAddNote(AddNote event, Emitter<NotesState> emit) async {
    final uid = authRepository.currentUserId();
    
    try {
      await NotificationService.showNotification(
        id: event.note.id.hashCode,
        title: event.note.title,
        body: event.note.content,
        scheduledDate: DateTime.now().add(const Duration(seconds: 60)),
      );
    } catch (e) {
      // Ignore notification errors so note creation isn't blocked
      print("Notification error: $e");
    }

    if (uid == null) {
      emit(const NotesFailure("User not authenticated"));
      return;
    }
    try {
      await noteRepository.addNote(uid, NoteModel.fromEntity(event.note));
    } catch (e) {
      emit(NotesFailure(e.toString()));
    }
  }

  Future<void> _onSearchNotes(
      searchNotes event, Emitter<NotesState> emit) async {
    final uid = authRepository.currentUserId();
    if (uid == null) {
      emit(const NotesFailure("User not authenticated"));
      return;
    }
    
    List<String> availableTags = [];
    if (state is NotesLoaded) {
      availableTags = (state as NotesLoaded).availableTags;
    }

    emit(NotesLoading());
    try {
      final notes = await noteRepository.searchNotes(uid, event.query);
      emit(NotesLoaded(notes, uid, query: event.query, availableTags: availableTags));
    } catch (e) {
      emit(NotesFailure(e.toString()));
    }
  }

  Future<void> _onFilterNotesByTag(FilterNotesByTag event, Emitter<NotesState> emit) async {
    final uid = authRepository.currentUserId();
    if (uid == null) {
      emit(const NotesFailure("User not authenticated"));
      return;
    }

    List<String> availableTags = [];
    if (state is NotesLoaded) {
      availableTags = (state as NotesLoaded).availableTags;
    }

    emit(NotesLoading());
    try {
      final notes = await noteRepository.filterNotesByTag(uid, event.tag);
      emit(NotesLoaded(notes, uid, tag: event.tag, availableTags: availableTags));
    } catch (e) {
      emit(NotesFailure(e.toString()));
    }
  }

  Future<void> _onDeleteNote(DeleteNote event, Emitter<NotesState> emit) async {
    final uid = authRepository.currentUserId();
    if (uid == null) {
      emit(const NotesFailure("User not authenticated"));
      return;
    }
    try {
      await noteRepository.deleteNote(uid, event.noteId);
    } catch (e) {
      emit(NotesFailure(e.toString()));
    }
  }

  Future<void> _onToggleTask(
      ToggleTaskEvent event, Emitter<NotesState> emit) async {
    final uid = authRepository.currentUserId();
    if (uid == null) {
      emit(const NotesFailure("User not authenticated"));
      return;
    }
    try {
      final currentState = state;
      if (currentState is NotesLoaded) {
        final notes = currentState.notes;
        final noteIndex = notes.indexWhere((n) => n.id == event.noteId);
        if (noteIndex == -1) return;
        final note = notes[noteIndex];
        final newTasks = note.tasks.map((t) {
          if (t.id == event.taskId) {
            return TaskModel(
              id: t.id,
              text: t.text,
              done: !t.done,
              description: t.description,
              dueDate: t.dueDate,
              reminderTime: t.reminderTime,
              priority: t.priority,
              recurringWeekly: t.recurringWeekly,
              recurringDaily: t.recurringDaily,
            );
          }
          return t;
        }).toList();
        
        final taskModels = newTasks.map((t) {
             if (t is TaskModel) return t;
             return TaskModel(
              id: t.id,
              text: t.text,
              done: t.done,
              description: t.description,
              dueDate: t.dueDate,
              reminderTime: t.reminderTime,
              priority: t.priority,
              recurringWeekly: t.recurringWeekly,
              recurringDaily: t.recurringDaily,
            );
        }).toList();

        final updatedNote = NoteModel(
            id: note.id,
            title: note.title,
            content: note.content,
            tags: note.tags,
            tasks: taskModels,
            createdAt: note.createdAt,
            updatedAt: DateTime.now(),
            pinned: note.pinned,
            color: note.color);

        await noteRepository.updateNote(uid, updatedNote);
      }
    } catch (e) {
      emit(NotesFailure(e.toString()));
    }
  }

  Future<void> _onAddTask(AddTaskEvent event, Emitter<NotesState> emit) async {
    final uid = authRepository.currentUserId();
    if (uid == null) {
      emit(const NotesFailure("User not authenticated"));
      return;
    }
    try {
      final currentState = state;
      if (currentState is NotesLoaded) {
        final notes = currentState.notes;
        final noteIndex = notes.indexWhere((n) => n.id == event.noteId);
        if (noteIndex == -1) return;
        final note = notes[noteIndex];
        
        final newTaskModel = TaskModel(
            id: event.task.id,
            text: event.task.text,
            done: event.task.done,
            description: event.task.description,
            dueDate: event.task.dueDate,
            reminderTime: event.task.reminderTime,
            priority: event.task.priority,
            recurringWeekly: event.task.recurringWeekly,
            recurringDaily: event.task.recurringDaily,
        );

        final newTasks = List<TaskModel>.from(note.tasks.map((t) {
             if (t is TaskModel) return t;
             return TaskModel(
              id: t.id,
              text: t.text,
              done: t.done,
              description: t.description,
              dueDate: t.dueDate,
              reminderTime: t.reminderTime,
              priority: t.priority,
              recurringWeekly: t.recurringWeekly,
              recurringDaily: t.recurringDaily,
            );
        }))..add(newTaskModel);

        final updatedNote = NoteModel(
            id: note.id,
            title: note.title,
            content: note.content,
            tags: note.tags,
            tasks: newTasks,
            createdAt: note.createdAt,
            updatedAt: DateTime.now(),
            pinned: note.pinned,
            color: note.color);

        await noteRepository.updateNote(uid, updatedNote);
      }
    } catch (e) {
      emit(NotesFailure(e.toString()));
    }
  }

  Future<void> _onUpdateNote(UpdateNote event, Emitter<NotesState> emit) async {
    final uid = authRepository.currentUserId();
    if (uid == null) {
      emit(const NotesFailure("User not authenticated"));
      return;
    }
    try {
      // Expecting the UpdateNote event to carry a full Note entity.
      // Convert to NoteModel and persist the update.
      await noteRepository.updateNote(uid, NoteModel.fromEntity(event.note));
    } catch (e) {
      emit(NotesFailure(e.toString()));
    }
  }

  Future<void> _onRestoreNote(RestoreNote event, Emitter<NotesState> emit) async {
    final uid = authRepository.currentUserId();
    if (uid == null) {
      emit(const NotesFailure("User not authenticated"));
      return;
    }
    try {
      await noteRepository.addNote(uid, NoteModel.fromEntity(event.note));
      add(const LoadNotes());
    } catch (e) {
      emit(NotesFailure('Failed to restore note: $e'));
    }
  }

  @override
  Future<void> close() {
    _noteSubscription?.cancel();
    return super.close();
  }
}