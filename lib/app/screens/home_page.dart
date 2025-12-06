import 'package:flutter/material.dart';
import 'package:flutter_application_1/app/bloc/language/lang_bloc.dart';
import 'package:flutter_application_1/app/bloc/language/lang_event.dart'
    show ChangeLanguageEvent;
import 'package:flutter_application_1/app/bloc/language/lang_state.dart';
import 'package:flutter_application_1/data/services/auth_service.dart';
import 'package:flutter_application_1/l10n/app_localizations.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class HomeCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final Color color;
  final VoidCallback onTap;

  const HomeCard({
    super.key,
    required this.icon,
    required this.title,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: color,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 48, color: Colors.black54),
            const SizedBox(height: 8),
            Text(
              title,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}

class _TipItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;

  const _TipItem({
    required this.icon,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: theme.colorScheme.primary),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(description, style: theme.textTheme.bodyMedium),
            ],
          ),
        ),
      ],
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LangBloc, LangState>(
      builder: (context, langState) {
        final user = AuthService.instance.currentUser;
        final email = user?.email ?? 'User';
        final hour = DateTime.now().hour;
        final loc = AppLocalizations.of(context);

        String greeting;

        if (hour < 12) {
          greeting =
              loc?.greetingMorning ??
              'Good Morning';
        } else if (hour < 17) {
          greeting =
              loc?.greetingAfternoon ??
              'Good Afternoon';
        } else {
          greeting =
              loc?.greetingEvening ??
              'Good Evening';
        }

        return Scaffold(
          appBar: AppBar(
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 28.0),
                  child: Column(
                    children: [
                      Text(
                        greeting,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      // const SizedBox(height: 8),
                      // Text(
                      //   email,
                      //   style: Theme.of(context).textTheme.headlineSmall
                      //       ?.copyWith(fontWeight: FontWeight.bold),
                      // ),
                    ],
                  ),
                ),
              ],
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.language),
                onPressed: () async {
                  final currentCode = langState.locale.languageCode;
                  final selectedCode = await showModalBottomSheet<String>(
                    context: context,
                    builder: (bottomSheetContext) {
                      return _LanguageSelector(currentCode: currentCode);
                    },
                  );

                  if (selectedCode != null && selectedCode != currentCode) {
                    context.read<LangBloc>().add(
                      ChangeLanguageEvent(languageCode: selectedCode),
                    );
                  }
                },
                tooltip: loc?.changeLanguageTooltip ?? 'Change language',
              ),

             
              // IconButton(
              //   icon: const Icon(Icons.logout),
              //   onPressed: () {
              //     AuthService.instance.signOut();
              //   },
              // ),
            ],
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Card(
                //   elevation: 2,
                //   child: Padding(
                //     padding: const EdgeInsets.all(16.0),
                //     child: Column(
                //       crossAxisAlignment: CrossAxisAlignment.start,
                //       children: [
                //         Text(
                //           greeting,
                //           style: Theme.of(context).textTheme.titleMedium,
                //         ),
                //         const SizedBox(height: 8),
                //         Text(
                //           email,
                //           style: Theme.of(context).textTheme.headlineSmall
                //               ?.copyWith(fontWeight: FontWeight.bold),
                //         ),
                //       ],
                //     ),
                //   ),
                // ),
                const SizedBox(height: 34),
                Text(
                  loc?.quickActions ?? 'Quick Actions',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 16),
                GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  children: [
                    HomeCard(
                      icon: Icons.edit_note,
                      title: loc?.quickActionNewNote ?? 'New Task List',
                      color: Colors.orange.shade100,
                      onTap: () => context.push('/add-note'),
                    ),
                    HomeCard(
                      icon: Icons.library_books_outlined,
                      title: loc?.quickActionMyNotes ?? 'My Tasks',
                      color: Colors.blue.shade100,
                      onTap: () => context.go('/notes'),
                    ),
                    HomeCard(
                      icon: Icons.settings_suggest_outlined,
                      title: loc?.quickActionSettings ?? 'Settings',
                      color: Colors.purple.shade100,
                      onTap: () => context.go('/settings'),
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                Text(
                  loc?.startingPointPrompt ?? 'Need a starting point?',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 12),
                Card(
                  elevation: 0,
                  color: Theme.of(
                    context,
                  ).colorScheme.surfaceVariant.withOpacity(0.6),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _TipItem(
                          icon: Icons.lightbulb_outline,
                          title:
                            loc?.tipCaptureTitle ?? 'Capture tasks instantly',
                          description:
                            loc?.tipCaptureBody ??
                            'Tap New Task List when something pops up—add tasks now, organize and tag later.',
                        ),
                        SizedBox(height: 12),
                        _TipItem(
                          icon: Icons.sell_outlined,
                          title: loc?.tipTagTitle ?? 'Tag to stay organized',
                          description:
                            loc?.tipTagBody ??
                            'Group task lists with tags (work, personal, urgent) and filter them on the Tasks page.',
                        ),
                        SizedBox(height: 12),
                        _TipItem(
                          icon: Icons.smart_toy_outlined,
                          title: loc?.tipAiTitle ?? 'Let AI help out',
                          description:
                            loc?.tipAiBody ??
                            'Open any task list and tap the robot to summarize tasks, rewrite steps, or ask for next moves.',
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _LanguageSelector extends StatelessWidget {
  final String currentCode;
  const _LanguageSelector({required this.currentCode});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final loc = AppLocalizations.of(context);
    final options = <_LanguageOption>[
      _LanguageOption(code: 'en', label: loc?.languageEnglish ?? 'English'),
      _LanguageOption(code: 'am', label: loc?.languageAmharic ?? 'Amharic'),
      _LanguageOption(code: 'fr', label: loc?.languageFrench ?? 'French'),
    ];

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              loc?.chooseLanguageLabel ?? 'Choose language',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            ...options.map((option) {
              final isSelected = option.code == currentCode;
              return ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Icon(
                  isSelected
                      ? Icons.radio_button_checked
                      : Icons.radio_button_off,
                  color: theme.colorScheme.primary,
                ),
                title: Text(option.label),
                onTap: () => Navigator.of(context).pop(option.code),
              );
            }),
          ],
        ),
      ),
    );
  }
}

class _LanguageOption {
  final String code;
  final String label;
  const _LanguageOption({required this.code, required this.label});
}
