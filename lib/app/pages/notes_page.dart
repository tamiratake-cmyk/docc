import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/app/bloc/ai/ai_bloc.dart';
import 'package:flutter_application_1/app/bloc/ai/ai_event.dart';
import 'package:flutter_application_1/app/bloc/ai/ai_state.dart';
import 'package:flutter_application_1/app/widgets/error_view.dart';
import 'package:flutter_application_1/l10n/app_localizations.dart';
import 'package:flutter_application_1/app/widgets/loading_view.dart';
import 'package:flutter_application_1/domain/entities/notes.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_application_1/app/bloc/notes/notes_bloc.dart';
import 'package:flutter_application_1/app/bloc/notes/notes_event.dart';
import 'package:flutter_application_1/app/bloc/notes/notes_state.dart';
import 'package:flutter_application_1/data/models/notes_model.dart';
import 'package:flutter_application_1/data/models/task_model.dart';
import 'package:flutter_application_1/data/helpers/di/injector.dart';
import 'package:go_router/go_router.dart';

class NotesPage extends StatelessWidget {
  const NotesPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Only access Firebase services if Firebase has been initialized.
    final firebaseAvailable = Firebase.apps.isNotEmpty;

    if (!firebaseAvailable) {
      // Provide a local/offline notes UI so the app is usable on platforms
      // where Firebase isn't configured (e.g., Linux during development).
      return const OfflineNotesView();
    }

    return 
   MultiBlocProvider(
      providers: [
        // BlocProvider<ThemeBloc>(
        //   create: (_) => sl<ThemeBloc>()..add(LoadTheme()),
        // ),
        BlocProvider<NotesBloc>(
          create: (context) => sl<NotesBloc>()..add(const LoadNotes()),
        ),
        BlocProvider<AiBloc>(
          create: (context) => sl<AiBloc>(),
        ),
      ] ,
      child: const NotesView(),
   );
    // BlocProvider(
    //   create: (context) => sl<NotesBloc>()..add(const LoadNotes()),
    //   child: const NotesView(),
    // );
  }
}

class NotesView extends StatefulWidget {
  const NotesView({super.key});

  @override
  State<NotesView> createState() => _NotesViewState();
}

class _NotesViewState extends State<NotesView> {
  final TextEditingController _searchController = TextEditingController();
  String? _selectedTag;

  Future<void> _showAiOptions(Note note) async {
    showModalBottomSheet(
      context: context,
      builder: (_) {
        return Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.summarize),
              title: const Text('Summarize it'),
              onTap: () {
                Navigator.of(context).pop();
                _handleSummarize(note);
              },
            ),
            ListTile(
              leading: const Icon(Icons.edit),
              title: const Text('Rewrite with flair'),
              onTap: () {
                Navigator.of(context).pop();
                _handleRewrite(note);
              },
            ),
            ListTile(
              leading: const Icon(Icons.chat_bubble),
              title: const Text('Ask anything'),
              onTap: () {
                Navigator.of(context).pop();
                _handleChat(note);
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _handleSummarize(Note note) async {
    final aiBloc = context.read<AiBloc>();
    final dialogContext = context;
    // Show progress dialog
    showDialog(
      context: dialogContext,
      barrierDismissible: false,
      builder: (_) => const AlertDialog(content: Center(child: CircularProgressIndicator())),
    );

    try {
      aiBloc.add(Summarize(note.content));
      final state = await aiBloc.stream
          .firstWhere((s) => s is AiLoaded || s is AiFailure)
          .timeout(const Duration(seconds: 20), onTimeout: () => AiFailure('AI request timed out'));

      // Dismiss progress dialog if still open
      try {
        if (Navigator.of(dialogContext, rootNavigator: true).canPop()) Navigator.of(dialogContext, rootNavigator: true).pop();
      } catch (_) {}

      if (state is AiLoaded) {
        final text = state.response.trim();
        final locale = AppLocalizations.of(dialogContext);
        await showDialog(
          context: dialogContext,
          builder: (_) => AlertDialog(
            title: Text(locale?.summary ?? 'Instant summary'),
            content: Text(text.isEmpty ? 'No summary returned. Try again with more details.' : text),
            actions: [TextButton(onPressed: () => Navigator.of(dialogContext).pop(), child: const Text('OK'))],
          ),
        );
      } else if (state is AiFailure) {
        final err = state.error;
        await showDialog(
          context: dialogContext,
          builder: (_) => AlertDialog(
              title: const Text('AI hiccup'),
              content: Text(err),
              actions: [TextButton(onPressed: () => Navigator.of(dialogContext).pop(), child: const Text('OK'))],
            ),
        );
      }
    } catch (e) {
      // Ensure dialog dismissed and show error
      try {
        if (Navigator.of(dialogContext, rootNavigator: true).canPop()) Navigator.of(dialogContext, rootNavigator: true).pop();
      } catch (_) {}
      await showDialog(
        context: dialogContext,
        builder: (_) => AlertDialog(
          title: const Text('AI hiccup'),
          content: Text(e.toString()),
          actions: [TextButton(onPressed: () => Navigator.of(dialogContext).pop(), child: const Text('OK'))],
        ),
      );
    }
  }

  Future<void> _handleRewrite(Note note) async {
    final instructionController = TextEditingController();
    final result = await showDialog<String?>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Rewrite it your way'),
        content: TextField(controller: instructionController, decoration: const InputDecoration(hintText: 'Instruction')),
        actions: [TextButton(onPressed: () => context.pop(), child: const Text('Cancel')), TextButton(onPressed: () => Navigator.of(context).pop(instructionController.text.trim()), child: const Text('OK'))],
      ),
    );
      if (result == null || result.isEmpty) return;
    final aiBloc = context.read<AiBloc>();
    showDialog(context: context, barrierDismissible: false, builder: (_) => const AlertDialog(content: Center(child: CircularProgressIndicator())));
    aiBloc.add(ReWrite(result, note.content));
    final state = await aiBloc.stream
        .firstWhere((s) => s is AiLoaded || s is AiFailure)
        .timeout(const Duration(seconds: 20), onTimeout: () => AiFailure('AI request timed out'));
    // Navigator.of(context).pop();
    context.pop();

    if (state is AiLoaded) {
      final text = state.response.trim();
      showDialog(context: context, builder: (_) => AlertDialog(title: const Text('Fresh rewrite'), content: Text(text.isEmpty ? 'No rewrite returned. Try a clearer instruction.' : text)));
    } else if (state is AiFailure) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('AI error: ${state.error}')));
    }
  }

  Future<void> _handleChat(Note note) async {
    final questionController = TextEditingController();
    final result = await showDialog<String?>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Ask this note anything'),
        content: TextField(controller: questionController, decoration: const InputDecoration(hintText: 'E.g., “What are the next steps?”')),
        actions: [TextButton(onPressed: () => context.pop(), child: const Text('Cancel')), TextButton(onPressed: () => context.pop(questionController.text.trim()), child: const Text('Ask'))],
      ),
    );
    if (result == null || result.isEmpty) return;
    final aiBloc = context.read<AiBloc>();
    showDialog(context: context, barrierDismissible: false, builder: (_) => const AlertDialog(content: Center(child: CircularProgressIndicator())));
    aiBloc.add(Chat(result, note.content));
    final state = await aiBloc.stream
        .firstWhere((s) => s is AiLoaded || s is AiFailure)
        .timeout(const Duration(seconds: 20), onTimeout: () => AiFailure('AI request timed out'));
    // Navigator.of(context).pop();

    context.pop();

    print('AI State: ${state}');
    if (state is AiLoaded) {
      final text = state.response.trim();
      showDialog(context: context, builder: (_) => AlertDialog(title: const Text('AI says'), content: Text(text.isEmpty ? 'No reply returned. Ask again with more context.' : text)));
    } else if (state is AiFailure) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('AI error: ${state.error}')));
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(loc?.appTitle ?? 'Notes & Tasks, your way'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.push('/add-note');
        },
        child: const Icon(Icons.add),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(18.0),

            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: loc?.search ?? 'Find ideas, tasks, tags…',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _searchController.clear();
                    context.read<NotesBloc>().add(const LoadNotes());
                  },
                ),
              ),
              onSubmitted: (query) {
                if (query.isNotEmpty) {
                  context.read<NotesBloc>().add(searchNotes(query));
                } else {
                  context.read<NotesBloc>().add(const LoadNotes());
                }
              },
            ),
          ),
          BlocBuilder<NotesBloc, NotesState>(
            builder: (context, state) {
              if (state is NotesLoaded) {
                final allTags = state.availableTags;

                if (allTags.isNotEmpty) {
                  return SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Row(
                      children: [
                        ChoiceChip(
                          label: const Text('All'),
                          selected: _selectedTag == null,
                          onSelected: (selected) {
                            if (selected) {
                              setState(() {
                                _selectedTag = null;
                              });
                              context.read<NotesBloc>().add(const LoadNotes());
                            }
                          },
                        ),
                        const SizedBox(width: 8),
                        ...allTags.map((tag) {
                          return Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: ChoiceChip(
                              label: Text(tag),
                              selected: _selectedTag == tag,
                              onSelected: (selected) {
                                if (selected) {
                                  setState(() {
                                    _selectedTag = tag;
                                  });
                                  context
                                      .read<NotesBloc>()
                                      .add(FilterNotesByTag(tag));
                                } else {
                                  setState(() {
                                    _selectedTag = null;
                                  });
                                  context.read<NotesBloc>().add(const LoadNotes());
                                }
                              },
                            ),
                          );
                        }),
                      ],
                    ),
                  );
                }
              }
              return const SizedBox.shrink();
            },
          ),
          Expanded(
            child: BlocBuilder<NotesBloc, NotesState>(
              builder: (context, state) {
                if (state is NotesLoading) {
                  return ListView(
                    children: List.generate(6, (_) => LoadingWidget(),
                    growable: true),
                  );
                } else if (state is NotesFailure) {
                  return  ErrorView(message: state.error);
                } else if (state is NotesLoaded) {
                  final notes = state.notes;
                  if (notes.isEmpty) {
                    return AnimatedCrossFade(
                      firstChild: Center(
                        child: Text(
                            _selectedTag != null
                              ? 'Nothing here for "$_selectedTag". Try another tag or add a note!'
                              : 'No notes yet. Tap + to jot your next idea or task.',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ),
                       secondChild: SizedBox.shrink(),
                        crossFadeState: notes.isEmpty
                            ? CrossFadeState.showFirst
                            : CrossFadeState.showSecond,
                         duration: Duration(milliseconds: 300),
                         );
                  }
                  return ListView.builder(
                    itemCount: notes.length,
                    itemBuilder: (context, index) {
                      final note = notes[index];
                      return Dismissible(
                        key: Key(note.id),
                        direction: DismissDirection.endToStart,
                        background: Container(
                          color: Colors.red,
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: const Icon(Icons.delete, color: Colors.white),
                        ),
                        onDismissed: (_){ 
                          context.read<NotesBloc>().add(DeleteNote(note.id));
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text("Note deleted"),
                              action: SnackBarAction(
                                label: 'Undo',
                                onPressed: () {
                                  context.read<NotesBloc>().add(RestoreNote(note));
                                },
                              ),
                        )
                          );
                        },  
                        // confirmDismiss: (_) async {
                          
                        child: ListTile(
                          onTap: () => context.push('/view-note', extra: note),
                            title: Text(note.title),
                          leading: Icon(
                            note.pinned ? Icons.push_pin : Icons.note,
                            color: note.pinned ? Colors.blue : null,
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (note.tasks.isNotEmpty)
                                ...note.tasks.take(3).map((task) => Row(
                                      children: [
                                        Checkbox(
                                          value: task.done,
                                          visualDensity: VisualDensity.compact,
                                          onChanged: (_) {
                                            context.read<NotesBloc>().add(ToggleTaskEvent(note.id, task.id));
                                          },
                                        ),
                                        const SizedBox(width: 4),
                                        Expanded(
                                          child: Text(
                                            task.text,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
                                    )),
                              if (note.tasks.isEmpty)
                                Text(
                                  note.content,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              const SizedBox(height: 8),
                              if ((note.tags ?? []).isNotEmpty)
                                Wrap(
                                  spacing: 4.0,
                                  runSpacing: 4.0,
                                  children: (note.tags ?? [])
                                      .map((tag) => Chip(
                                            label: Text(tag, style: const TextStyle(fontSize: 10)),
                                            padding: EdgeInsets.zero,
                                            visualDensity: VisualDensity.compact,
                                          ))
                                      .toList(),
                                ),
                              if (note.imageUrls.isNotEmpty) ...[
                                const SizedBox(height: 8),
                                SizedBox(
                                  height: 70,
                                  child: ListView.separated(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: note.imageUrls.length,
                                    separatorBuilder: (_, __) => const SizedBox(width: 8),
                                    itemBuilder: (context, imageIndex) {
                                      final imageUrl = note.imageUrls[imageIndex];
                                      return ClipRRect(
                                        borderRadius: BorderRadius.circular(8),
                                        child: Image.network(
                                          imageUrl,
                                          width: 70,
                                          height: 70,
                                          fit: BoxFit.cover,
                                          errorBuilder: (context, error, stack) => Container(
                                            width: 70,
                                            height: 70,
                                            color: Colors.grey.shade200,
                                            alignment: Alignment.center,
                                            child: const Icon(
                                              Icons.broken_image_outlined,
                                              size: 20,
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ],
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.smart_toy_outlined),
                                  onPressed: () => _showAiOptions(note),
                                  tooltip: loc?.askAI ?? 'Ask AI',
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete),
                                onPressed: () {
                                  context.read<NotesBloc>().add(DeleteNote(note.id));
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
    );
  }
}

/// A simple local notes view used when Firebase is unavailable. This stores
/// notes in memory for development on platforms without Firebase support.
class OfflineNotesView extends StatefulWidget {
  const OfflineNotesView({super.key});

  @override
  State<OfflineNotesView> createState() => _OfflineNotesViewState();
}

class _OfflineNotesViewState extends State<OfflineNotesView> {
  final List<NoteModel> _notes = [];

  void _addNote() {
    final note = NoteModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: 'Local Note',
      content: 'This note is stored locally (no Firebase).',
      tags: List.empty(growable: true),
      tasks: [
        TaskModel(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          text: 'Local Task',
          done: false,
        )
      ],
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
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