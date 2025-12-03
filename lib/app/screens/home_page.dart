import 'package:flutter/material.dart';
import 'package:flutter_application_1/data/services/auth_service.dart';
import 'package:go_router/go_router.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = AuthService.instance.currentUser;
    final email = user?.email ?? 'User';
    final hour = DateTime.now().hour;

    String greeting;

    if (hour < 12) {
      greeting = 'Good Morning - ready to write your first note?';
    } else if (hour < 17) {
      greeting = 'Good Afternoon - ready to collect your thoughts!';
    } else {
      greeting = 'Good Evening - unwind and jot down your ideas!';
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              AuthService.instance.signOut();
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),    
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      greeting,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      email,
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Quick Actions',
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
                  icon: Icons.note_alt,
                  title: 'Notes',
                  color: Colors.orange.shade100,
                  onTap: () => context.go('/notes'),
                ),
                HomeCard(
                  icon: Icons.battery_std,
                  title: 'Battery',
                  color: Colors.green.shade100,
                  onTap: () => context.go('/battery'),
                ),
                HomeCard(
                  icon: Icons.camera_alt,
                  title: 'Camera',
                  color: Colors.blue.shade100,
                  onTap: () => context.go('/camera'),
                ),
                HomeCard(
                  icon: Icons.map,
                  title: 'Map',
                  color: Colors.purple.shade100,
                  onTap: () => context.go('/map'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

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
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
