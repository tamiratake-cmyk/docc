import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/data/models/notes_model.dart';
import 'package:flutter_application_1/data/services/note_service.dart';

class NotesPage extends StatelessWidget{
  

  NotesPage ({super.key});

  @override
  Widget build(BuildContext context) {
    // Only access Firebase services if Firebase has been initialized.
    final firebaseAvailable = Firebase.apps.isNotEmpty;

    if (!firebaseAvailable) {
      // Provide a local/offline notes UI so the app is usable on platforms
      // where Firebase isn't configured (e.g., Linux during development).
      return OfflineNotesView();
    }

    final NoteService noteService = NoteService();
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Notes Page')),
        body: const Center(child: Text('Please sign in to view notes.')),
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notes Page'),

      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          noteService.addNote(user.uid,
              NotesModel(
                id:"",
                title: 'New Note', content: 'Note content', 
                tasks: [TaskItem(text: '', done: false)],
                timestamp: Timestamp.now()));
        },
        child: const Icon(Icons.add),
      ),
      body: StreamBuilder<List<NotesModel>>(
        stream: noteService.getNotes(user.uid),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          final notes = snapshot.data ?? [];
          return ListView.builder(
            itemCount: notes.length,
            itemBuilder: (context, index) {
              final note = notes[index];
            return ListTile(
              title: Text(note.title),
              subtitle: note.tasks.isNotEmpty
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: note.tasks.map((task) => Row(
                      children: [
                        Icon(
                          task.done ? Icons.check_box : Icons.check_box_outline_blank,
                          size: 16,
                        ),
                        const SizedBox(width: 4),
                        Text(task.text),
                      ],
                    )).toList(),
                  )
                : Text(note.content),
              trailing: IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () {
                  noteService.deleteNote(user.uid, note.id);
                },
              ),
            );
            },
          );
        },
      ),
    );
  }
}

/// A simple local notes view used when Firebase is unavailable. This stores
/// notes in memory for development on platforms without Firebase support.
class OfflineNotesView extends StatefulWidget {
  const OfflineNotesView({Key? key}) : super(key: key);

  @override
  State<OfflineNotesView> createState() => _OfflineNotesViewState();
}

class _OfflineNotesViewState extends State<OfflineNotesView> {
  final List<NotesModel> _notes = [];

  void _addNote() {
    final note = NotesModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: 'Local Note',
      content: 'This note is stored locally (no Firebase).',
      tasks: [TaskItem(text: '', done: false)],
      timestamp: Timestamp.now(),
    );
    setState(() => _notes.insert(0, note));
  }

  void _deleteNote(String id) {
    setState(() => _notes.removeWhere((n) => n.id == id));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Notes (Offline)')),
      floatingActionButton: FloatingActionButton(
        onPressed: _addNote,
        child: const Icon(Icons.add),
      ),
      body: _notes.isEmpty
          ? const Center(child: Text('No local notes yet.'))
          : ListView.builder(
              itemCount: _notes.length,
              itemBuilder: (context, index) {
                final note = _notes[index];
                return ListTile(
                  title: Text(note.title),
                  subtitle: Text(note.content),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () => _deleteNote(note.id),
                  ),
                );
              },
            ),
    );
  }
}