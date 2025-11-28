import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/data/models/notes_model.dart';
import 'package:flutter_application_1/data/services/note_service.dart';

class NotesPage extends StatelessWidget {
  const NotesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        final user = snapshot.data;
        if (user == null) {
          return Scaffold(
            appBar: AppBar(title: const Text('Notes Page')),
            body: const Center(child: Text('Please sign in to view notes.')),
          );
        }
        final noteService = NoteService();
        return Scaffold(
          appBar: AppBar(
            title: const Text('Notes Page'),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              noteService.addNote(
                user.uid,
                NotesModel(
                  id: "",
                  title: 'New Note',
                  content: 'Note content',
                  completed: false,
                  timestamp: Timestamp.now(),
                ),
              );
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
                    subtitle: Text(note.content),
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
      },
    );
  }
}