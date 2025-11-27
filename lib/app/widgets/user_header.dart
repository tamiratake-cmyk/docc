import 'package:flutter/material.dart';
import 'package:flutter_application_1/domain/entities/users.dart';
import 'package:go_router/go_router.dart';

class UserHeader extends StatelessWidget {
  final User user;

  const UserHeader({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          radius: 30,
          child: Text(
            _initials(user.name),
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              user.name,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              user.email,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),

            ElevatedButton(onPressed: ()=>context.go('/map'), 
            child: const Text('Go to Map')),

            ElevatedButton(onPressed: ()=>context.go('/camera'),
             child: const Text('Go to Camera'))
          ],
        ),
      ],
    );
  }
 
  String _initials(String name) {
    final parts = name.trim().split(RegExp(r"\s+"));
    if (parts.isEmpty) return "";
    final first = parts.first.isNotEmpty ? parts.first[0] : "";
    final last = parts.length > 1 && parts.last.isNotEmpty ? parts.last[0] : "";
    return (first + last).toUpperCase();
  }
 }