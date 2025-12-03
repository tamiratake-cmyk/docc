import 'package:flutter/material.dart';
import 'package:flutter_application_1/app/widgets/pressable.dart';
import 'package:flutter_application_1/data/models/task_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_application_1/app/bloc/notes/notes_bloc.dart';
import 'package:flutter_application_1/app/bloc/notes/notes_event.dart';
import 'package:flutter_application_1/app/bloc/notes/notes_state.dart';
import 'package:flutter_application_1/data/helpers/di/injector.dart';
import 'package:flutter_application_1/data/models/notes_model.dart';
import 'package:flutter_application_1/domain/entities/notes.dart';

class EditNotesPage extends StatefulWidget {
  final Note note;
  const EditNotesPage({super.key, required this.note});

  @override
  State<EditNotesPage> createState() => _EditNotesPageState();
}

class _EditNotesPageState extends State<EditNotesPage> {
  late TextEditingController _titleController;
  late TextEditingController _contentController;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.note.title);
    _contentController = TextEditingController(text: widget.note.content);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  void _saveNote(BuildContext context) {
    final title = _titleController.text.trim();
    final content = _contentController.text.trim();

    

    if (title.isEmpty && content.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Title or content cannot be empty')),
      );
      return;
    }

    final updatedNote = NoteModel(
      id: widget.note.id,
      title: title,
      content: content,
      tags: widget.note.tags,
      createdAt: widget.note.createdAt,
      updatedAt: DateTime.now(),
      pinned: widget.note.pinned,
      color: widget.note.color,
      tasks: widget.note.tasks.map((t) => TaskModel(
        id: t.id,
        text: t.text,
        done: t.done,
        description: t.description,
        dueDate: t.dueDate,
        priority: t.priority,
        reminderTime: t.reminderTime,
        recurringWeekly: t.recurringWeekly,
        recurringDaily: t.recurringDaily,
      )).toList(),
    );

    context.read<NotesBloc>().add(UpdateNote(updatedNote));
    
    
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<NotesBloc>(),
      child: BlocConsumer<NotesBloc, NotesState>(
        listener: (context, state) {
          if (state is NotesFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Error: ${state.error}')),
            );
          } else if (state is NotesLoaded) {
            // Wait for the update to propagate or just pop
            // Since NotesLoaded contains the list, we can assume success if no error
             context.go('/notes');
          }
        },
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Edit Note'),
              actions: [
                // IconButton(
                //   icon: const Icon(Icons.check),
                //   onPressed: _isLoading ? null : () => _saveNote(context),
                // ),
                 PressableButton(
                 child: Container(
                    padding: const EdgeInsets.all(8.0),
                    child: const Icon(Icons.check),
                    decoration:  BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                 ),
                 onTap: () => _saveNote(context)),
              ],
            ),
            body: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        TextField(
                          controller: _titleController,
                          style: Theme.of(context).textTheme.headlineSmall,
                          decoration: const InputDecoration(
                            labelText: 'Title',
                            border: InputBorder.none,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Expanded(
                          child: TextField(
                            controller: _contentController,
                            decoration: const InputDecoration(
                              labelText: 'Content',
                              border: InputBorder.none,
                              alignLabelWithHint: true,
                            ),
                            maxLines: null,
                            expands: true,
                            textAlignVertical: TextAlignVertical.top,
                          ),
                        ),
                      ],
                    ),
                  ),
          );
        },
      ),
    );
  }
}
