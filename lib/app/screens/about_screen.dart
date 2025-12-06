import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('About'),
        elevation: 0,
      ),
      body: Container(
        // decoration: BoxDecoration(
        //   gradient: LinearGradient(
        //     begin: Alignment.topLeft,
        //     end: Alignment.bottomRight,
        //     colors: [
        //       theme.colorScheme.primaryContainer,
        //       theme.colorScheme.secondaryContainer,
        //     ],
        //   ),
        // ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Modern Notes & Tasks', style: theme.textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              Text(
                'Designed to keep your thoughts, reminders, and ideas organized with a clean experience that stays out of your way while still offering powerful features when you need them.',
                style: theme.textTheme.bodyMedium,
              ),
              const SizedBox(height: 24),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: const [
                  _HighlightCard(icon: Icons.flash_on, title: 'Instant Insights', subtitle: 'AI-powered summaries and rewriting tools.'),
                  _HighlightCard(icon: Icons.tag, title: 'Smart Tags', subtitle: 'Filter by tags or sticker-like chips in any view.'),
                  _HighlightCard(icon: Icons.lock, title: 'Data First', subtitle: 'Privacy-minded Firestore sync & local storage.'),
                ],
              ),
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(color: const Color.fromARGB(255, 1, 60, 143).withOpacity(0.12), borderRadius: BorderRadius.circular(16)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Mission', style: theme.textTheme.titleLarge),
                    const SizedBox(height: 6),
                    Text(
                      'We believe every note should be effortless to capture, beautiful to revisit, and smart enough to keep you in flow. Our goal: bring intuitive tooling to every thought.',
                      style: theme.textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 16),
                    Text('Contact', style: theme.textTheme.titleLarge),
                    const SizedBox(height: 6),
                    Text('support@yourapp.example.com', style: theme.textTheme.bodyMedium),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _HighlightCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const _HighlightCard({required this.icon, required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: 200,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: const Color.fromARGB(255, 5, 70, 150).withOpacity(0.15), borderRadius: BorderRadius.circular(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 28, color: theme.colorScheme.secondary),
          const SizedBox(height: 8),
          Text(title, style: theme.textTheme.titleMedium),
          const SizedBox(height: 4),
          Text(subtitle, style: theme.textTheme.bodySmall),
        ],
      ),
    );
  }
}
