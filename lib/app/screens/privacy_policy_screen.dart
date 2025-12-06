import 'package:flutter/material.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    Widget section(String title, String text) {
      return Card(
        margin: const EdgeInsets.symmetric(vertical: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 6),
              Text(text, style: theme.textTheme.bodyMedium),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Privacy Policy'),
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text('Your privacy matters', style: theme.textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text(
            'We keep your notes safe and only share data when you explicitly allow integrations or exports. You stay in control.',
            style: theme.textTheme.bodyMedium,
          ),
          const SizedBox(height: 16),
          section('Data Collection', 'We only collect the minimum metadata to sync your notes. No tracking outside the app.'),
          section('Data Storage', 'Firestore handles persistence, encrypted in transit. Local caching respects your device encryption.'),
          section('Sharing & Export', 'You can export or share notes manually. The app never shares anything without your action.'),
          section('Third-party Services', 'Optional integrations (e.g., Groq AI) are only used when you opt into the feature.'),
        ],
      ),
    );
  }
}
