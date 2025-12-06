import 'package:flutter/material.dart';

class TermsScreen extends StatelessWidget {
  const TermsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    Widget bullet(String title, String description) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(Icons.check_circle_outline, size: 20),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 2),
                  Text(description, style: theme.textTheme.bodyMedium),
                ],
              ),
            ),
          ],
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Terms of Use'),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Modern, thoughtful policies', style: theme.textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Text('By using the app you agree to keep your account secure and to treat other users with respect.',
                style: theme.textTheme.bodyMedium),
            const SizedBox(height: 20),
            Expanded(
              child: ListView(
                children: [
                  bullet('Responsible use', 'Build notes for personal productivity or collaboration—no abuse, no harassment.'),
                  bullet('Account care', 'Keep your credentials confidential and notify us immediately if something seems off.'),
                  bullet('Feature access', 'We may update, add, or remove features; you will be notified by release notes.'),
                  bullet('Feedback welcome', 'Send ideas or bug reports using the in-app feedback tools. We read every message.'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
