import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/app/widgets/pressable.dart';
import 'package:flutter_application_1/l10n/app_localizations.dart';
import 'package:flutter_application_1/data/models/task_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_application_1/app/bloc/notes/notes_bloc.dart';
import 'package:flutter_application_1/app/bloc/notes/notes_event.dart';
import 'package:flutter_application_1/app/bloc/notes/notes_state.dart';
import 'package:flutter_application_1/data/helpers/di/injector.dart';
import 'package:flutter_application_1/data/models/notes_model.dart';
import 'package:flutter_application_1/domain/entities/notes.dart';
import 'package:flutter_application_1/domain/entities/task.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

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
  late List<String> _retainedImageUrls;
  final List<XFile> _newImages = [];
  final ImagePicker _imagePicker = ImagePicker();
  late List<TaskItem> _tasks;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.note.title);
    _contentController = TextEditingController(text: widget.note.content);
    _retainedImageUrls = List<String>.from(widget.note.imageUrls);
    _tasks = widget.note.tasks
      .map((t) => t.copyWith())
      .toList();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  String _formatDate(DateTime date) {
    final mm = date.month.toString().padLeft(2, '0');
    final dd = date.day.toString().padLeft(2, '0');
    return '${date.year}-$mm-$dd';
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
        tasks: _tasks
          .map((t) => TaskModel(
            id: t.id,
            text: t.text,
            done: t.done,
            description: t.description,
            dueDate: t.dueDate,
            priority: t.priority,
            reminderTime: t.reminderTime,
            recurringWeekly: t.recurringWeekly,
            recurringDaily: t.recurringDaily,
            ))
          .toList(),
      imageUrls: _retainedImageUrls,
    );

    context.read<NotesBloc>().add(UpdateNote(
      updatedNote,
      newAttachmentPaths: _newImages.map((image) => image.path).toList(),
      retainedImageUrls: _retainedImageUrls,
    ));
    
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Note saved successfully')),
    );

    context.push('/view-note', extra: updatedNote);

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
          final loc = AppLocalizations.of(context);
          return Scaffold(
            appBar: AppBar(
              title: Text(loc?.edit ?? 'Edit'),
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
                        const SizedBox(height: 16),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Tasks',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                        ),
                        const SizedBox(height: 8),
                        if (_tasks.isEmpty)
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'No tasks yet. Add one below.',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(color: Colors.grey),
                            ),
                          )
                        else
                          ListView.separated(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: _tasks.length,
                            separatorBuilder: (_, __) => const SizedBox(height: 12),
                            itemBuilder: (context, index) {
                              final task = _tasks[index];
                              return Card(
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  side: BorderSide(color: Colors.grey.shade300),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Checkbox(
                                            value: task.done,
                                            onChanged: (val) {
                                              setState(() {
                                                _tasks[index] = task.copyWith(done: val ?? false);
                                              });
                                            },
                                          ),
                                          Expanded(
                                            child: TextField(
                                              controller: TextEditingController(text: task.text)
                                                ..selection = TextSelection.collapsed(offset: task.text.length),
                                              decoration: const InputDecoration(
                                                hintText: 'Task description',
                                                border: InputBorder.none,
                                              ),
                                              onChanged: (val) {
                                                setState(() {
                                                  _tasks[index] = task.copyWith(text: val);
                                                });
                                              },
                                            ),
                                          ),
                                          IconButton(
                                            icon: const Icon(Icons.delete_outline),
                                            onPressed: () {
                                              setState(() {
                                                _tasks.removeAt(index);
                                              });
                                            },
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 8),
                                      Wrap(
                                        spacing: 8,
                                        runSpacing: 8,
                                        children: [
                                          DropdownButton<TaskPriority>(
                                            value: task.priority,
                                            onChanged: (value) {
                                              if (value == null) return;
                                              setState(() {
                                                _tasks[index] = task.copyWith(priority: value);
                                              });
                                            },
                                            items: TaskPriority.values
                                                .map((p) => DropdownMenuItem(
                                                      value: p,
                                                      child: Text(p.name),
                                                    ))
                                                .toList(),
                                          ),
                                          OutlinedButton.icon(
                                            icon: const Icon(Icons.event_outlined),
                                            label: Text(
                                              task.dueDate == null
                                                  ? 'Due date'
                                                  : 'Due: ${_formatDate(task.dueDate!)}',
                                            ),
                                            onPressed: () async {
                                              final picked = await showDatePicker(
                                                context: context,
                                                initialDate: task.dueDate ?? DateTime.now(),
                                                firstDate: DateTime(2000),
                                                lastDate: DateTime(2100),
                                              );
                                              if (picked != null) {
                                                setState(() {
                                                  _tasks[index] = task.copyWith(dueDate: picked);
                                                });
                                              }
                                            },
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: TextButton.icon(
                            onPressed: () {
                              setState(() {
                                _tasks.add(TaskModel(
                                  id: const Uuid().v4(),
                                  text: '',
                                  done: false,
                                  priority: TaskPriority.normal,
                                  recurringDaily: false,
                                  recurringWeekly: false,
                                ));
                              });
                            },
                            icon: const Icon(Icons.add_task),
                            label: const Text('Add task'),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Attachments',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                        ),
                        const SizedBox(height: 12),
                        if (_retainedImageUrls.isEmpty && _newImages.isEmpty)
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'No images attached',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(color: Colors.grey),
                            ),
                          )
                        else
                          Wrap(
                            spacing: 12,
                            runSpacing: 12,
                            children: [
                              ...List.generate(_retainedImageUrls.length, (index) {
                                final url = _retainedImageUrls[index];
                                return Stack(
                                  alignment: Alignment.topRight,
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(12),
                                      child: Image.network(
                                        url,
                                        width: 100,
                                        height: 100,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    Positioned(
                                      top: 4,
                                      right: 4,
                                      child: CircleAvatar(
                                        radius: 14,
                                        backgroundColor:
                                            Colors.black.withOpacity(0.6),
                                        child: IconButton(
                                          padding: EdgeInsets.zero,
                                          icon: const Icon(
                                            Icons.close,
                                            size: 16,
                                            color: Colors.white,
                                          ),
                                          onPressed: () {
                                            setState(() {
                                              _retainedImageUrls.removeAt(index);
                                            });
                                          },
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              }),
                              ...List.generate(_newImages.length, (index) {
                                final file = File(_newImages[index].path);
                                return Stack(
                                  alignment: Alignment.topRight,
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(12),
                                      child: Image.file(
                                        file,
                                        width: 100,
                                        height: 100,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    Positioned(
                                      top: 4,
                                      right: 4,
                                      child: CircleAvatar(
                                        radius: 14,
                                        backgroundColor:
                                            Colors.black.withOpacity(0.6),
                                        child: IconButton(
                                          padding: EdgeInsets.zero,
                                          icon: const Icon(
                                            Icons.close,
                                            size: 16,
                                            color: Colors.white,
                                          ),
                                          onPressed: () {
                                            setState(() {
                                              _newImages.removeAt(index);
                                            });
                                          },
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              }),
                            ],
                          ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton.icon(
                                icon:
                                    const Icon(Icons.photo_library_outlined),
                                label: const Text('Gallery'),
                                onPressed: () async {
                                  try {
                                    final images =
                                        await _imagePicker.pickMultiImage();
                                    if (images.isEmpty) return;
                                    setState(() {
                                      _newImages.addAll(images);
                                    });
                                  } catch (e) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          content: Text(
                                              'Failed to pick images: $e')),
                                    );
                                  }
                                },
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: OutlinedButton.icon(
                                icon: const Icon(Icons.photo_camera_outlined),
                                label: const Text('Camera'),
                                onPressed: () async {
                                  try {
                                    final image = await _imagePicker.pickImage(
                                      source: ImageSource.camera,
                                    );
                                    if (image == null) return;
                                    setState(() {
                                      _newImages.add(image);
                                    });
                                  } catch (e) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          content: Text(
                                              'Failed to capture image: $e')),
                                    );
                                  }
                                },
                              ),
                            ),
                          ],
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
