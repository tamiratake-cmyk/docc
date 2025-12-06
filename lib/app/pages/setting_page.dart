import 'package:flutter/material.dart';
import 'package:flutter_application_1/app/bloc/language/lang_bloc.dart';
import 'package:flutter_application_1/app/bloc/language/lang_event.dart';
import 'package:flutter_application_1/app/bloc/language/lang_state.dart';
import 'package:flutter_application_1/app/bloc/theme/theme_bloc.dart';
import 'package:flutter_application_1/app/bloc/theme/theme_event.dart';
import 'package:flutter_application_1/app/bloc/theme/theme_state.dart';
import 'package:flutter_application_1/app/theme/app_theme.dart';
import 'package:flutter_application_1/data/services/auth_service.dart';
import 'package:flutter_application_1/domain/entities/theme.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class SettingPage extends StatelessWidget {
  const SettingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LangBloc, LangState>(
      builder: (context, langState) {
        return Scaffold(
          appBar: AppBar(title: const Text('Settings'), elevation: 0),
          body: BlocBuilder<ThemeBloc, ThemeState>(
            builder: (context, state) => ListView(
              padding: const EdgeInsets.all(20),
              children: [
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 20,
                      horizontal: 16,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Appearance',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 12),
                        DropdownButton<AppThemeMode>(
                          isExpanded: true,
                          value: state.theme,
                          underline: const SizedBox.shrink(),
                          items: const [
                            DropdownMenuItem(
                              child: Text('Light Theme'),
                              value: AppThemeMode.light,
                            ),
                            DropdownMenuItem(
                              child: Text('Dark Theme'),
                              value: AppThemeMode.dark,
                            ),
                            DropdownMenuItem(
                              child: Text('System Theme'),
                              value: AppThemeMode.system,
                            ),
                          ],
                          onChanged: (value) => context.read<ThemeBloc>().add(
                            ChangeTheme(value!),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Language',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 8),
                        DropdownButton<Locale>(
                          isExpanded: true,
                          value: langState.locale,
                          underline: const SizedBox.shrink(),
                          items: const [
                            DropdownMenuItem(
                              child: Text('English'),
                              value: Locale('en', ''),
                            ),
                            DropdownMenuItem(
                              child: Text('Amharic'),
                              value: Locale('am', ''),
                            ),
                            DropdownMenuItem(
                              child: Text('French'),
                              value: Locale('fr', ''),
                            ),
                          ],
                          onChanged: (value) => context.read<LangBloc>().add(
                            ChangeLanguageEvent(
                              languageCode: value!.languageCode,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                // Account Section
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Account',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 12),
                        if (AuthService.instance.isGuestMode) ...[
                          const Text(
                            'You are using the app as a guest. Sign in to sync your notes across devices.',
                            style: TextStyle(color: Colors.grey),
                          ),
                          const SizedBox(height: 12),
                          ElevatedButton.icon(
                            onPressed: () {
                              context.push('/login');
                            },
                            icon: const Icon(Icons.login),
                            label: const Text('Sign In to Sync'),
                            style: ElevatedButton.styleFrom(
                              minimumSize: const Size(double.infinity, 48),
                            ),
                          ),
                        ] else ...[
                          Text(
                            'Signed in as: ${AuthService.instance.currentUser?.email ?? "Unknown"}',
                            style: const TextStyle(color: Colors.grey),
                          ),
                          const SizedBox(height: 12),
                          OutlinedButton.icon(
                            onPressed: () async {
                              final confirmed = await showDialog<bool>(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: const Text('Sign Out'),
                                  content: const Text(
                                    'Your notes will remain stored locally. You can sign in again anytime to sync.',
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(context, false),
                                      child: const Text('Cancel'),
                                    ),
                                    TextButton(
                                      onPressed: () => Navigator.pop(context, true),
                                      child: const Text('Sign Out'),
                                    ),
                                  ],
                                ),
                              );
                              if (confirmed == true) {
                                await AuthService.instance.signOut();
                              }
                            },
                            icon: const Icon(Icons.logout),
                            label: const Text('Sign Out'),
                            style: OutlinedButton.styleFrom(
                              minimumSize: const Size(double.infinity, 48),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    children: [
                      ListTile(
                        leading: const Icon(Icons.info_outline),
                        title: const Text('About'),
                        subtitle: const Text(
                          'Learn why we built this experience',
                        ),
                        trailing: const Icon(Icons.arrow_forward_ios),
                        onTap: () => context.push('/about'),
                      ),
                      const Divider(height: 1),
                      ListTile(
                        leading: const Icon(Icons.privacy_tip_outlined),
                        title: const Text('Privacy Policy'),
                        subtitle: const Text('How we keep your data safe'),
                        trailing: const Icon(Icons.arrow_forward_ios),
                        onTap: () => context.push('/privacy-policy'),
                      ),
                      const Divider(height: 1),
                      ListTile(
                        leading: const Icon(Icons.description_outlined),
                        title: const Text('Terms of Use'),
                        subtitle: const Text('Guidelines for using the app'),
                        trailing: const Icon(Icons.arrow_forward_ios),
                        onTap: () => context.push('/terms'),
                      ),
                    ],
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
