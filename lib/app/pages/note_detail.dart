import 'package:flutter/material.dart';
import 'package:flutter_application_1/domain/entities/notes.dart';
import 'package:go_router/go_router.dart';

class NoteDetailPage extends StatelessWidget {
  final Note note;

  const NoteDetailPage({super.key, required this.note});

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
                  return ListTile(
                    leading: Icon(
                      task.done ? Icons.check_box : Icons.check_box_outline_blank,
                      color: task.done ? Colors.green : null,
                    ),
                    title: Text(
                      task.text,
                      style: TextStyle(
                        decoration: task.done ? TextDecoration.lineThrough : null,
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
}