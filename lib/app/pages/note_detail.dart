import 'package:flutter/material.dart';
import 'package:flutter_application_1/app/bloc/notes/notes_bloc.dart';
import 'package:flutter_application_1/app/bloc/notes/notes_state.dart';
import 'package:flutter_application_1/data/helpers/di/injector.dart';
import 'package:flutter_application_1/domain/entities/notes.dart';
import 'package:flutter_application_1/domain/entities/task.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class NoteDetailPage extends StatelessWidget {
  final Note note;

  const NoteDetailPage({super.key, required this.note});

  String _formatDate(DateTime date) {
    final mm = date.month.toString().padLeft(2, '0');
    final dd = date.day.toString().padLeft(2, '0');
    return '${date.year}-$mm-$dd';
  }

  @override

  Widget build(BuildContext context) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Note Detail'),
              actions: [
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () {
                    context.push('/edit-note', extra: note);
                  },
                ),
              ],
            ),
            body: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    note.title,
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Created: ${note.createdAt.toString().split(' ')[0]}',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.grey,
                        ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    note.content,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  if (note.imageUrls.isNotEmpty) ...[
                    const SizedBox(height: 24),
                    const Divider(),
                    const SizedBox(height: 12),
                    Text(
                      'Attachments',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children: note.imageUrls
                          .map(
                            (url) => ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.network(
                                url,
                                width: 120,
                                height: 120,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stack) => Container(
                                  width: 120,
                                  height: 120,
                                  color: Colors.grey.shade200,
                                  alignment: Alignment.center,
                                  child: const Icon(Icons.broken_image_outlined),
                                ),
                              ),
                            ),
                          )
                          .toList(),
                    ),
                  ],
                  if (note.tasks.isNotEmpty) ...[
                    const SizedBox(height: 24),
                    const Divider(),
                    const SizedBox(height: 8),
                    Text(
                      'Tasks',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: note.tasks.length,
                      itemBuilder: (context, index) {
                        final task = note.tasks[index];
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
                                    Icon(
                                      task.done ? Icons.check_circle : Icons.radio_button_unchecked,
                                      color: task.done ? Colors.green : Colors.grey,
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        task.text,
                                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                              decoration: task.done ? TextDecoration.lineThrough : null,
                                            ),
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                      decoration: BoxDecoration(
                                        color: Colors.blueGrey.shade50,
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Text(
                                        _priorityLabel(task.priority),
                                        style: const TextStyle(fontSize: 12),
                                      ),
                                    ),
                                  ],
                                ),
                                if ((task.description ?? '').isNotEmpty) ...[
                                  const SizedBox(height: 8),
                                  Text(
                                    task.description!,
                                    style: Theme.of(context).textTheme.bodyMedium,
                                  ),
                                ],
                                const SizedBox(height: 8),
                                Wrap(
                                  spacing: 12,
                                  runSpacing: 8,
                                  children: [
                                    if (task.dueDate != null)
                                      Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          const Icon(Icons.event, size: 16),
                                          const SizedBox(width: 4),
                                          Text('Due ${_formatDate(task.dueDate!)}'),
                                        ],
                                      ),
                                    if (task.reminderTime != null)
                                      Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          const Icon(Icons.alarm, size: 16),
                                          const SizedBox(width: 4),
                                          Text('Reminder ${_formatDate(task.reminderTime!)}'),
                                        ],
                                      ),
                                    if (task.recurringDaily)
                                      const Chip(label: Text('Daily')),
                                    if (task.recurringWeekly)
                                      const Chip(label: Text('Weekly')),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ],
              ),
            ),
          );
        
  }

  String _priorityLabel(TaskPriority priority) {
    switch (priority) {
      case TaskPriority.low:
        return 'Low';
      case TaskPriority.normal:
        return 'Normal';
      case TaskPriority.high:
        return 'High';
    }
  }
}