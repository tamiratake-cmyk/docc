import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class Navigationbar extends StatefulWidget {
  final String? currentLocation;

  const Navigationbar({super.key, this.currentLocation});

  @override
  State<Navigationbar> createState() => _NavigationbarState();
}

class _NavigationbarState extends State<Navigationbar> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: _selectedIndex,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'User',
        ),
      ],
      onTap: (index) {
        setState(() {
          _selectedIndex = index;
        });
        switch (index) {
          case 0:
            context.go('/');
            break;
          case 1:
            context.go('/user');
            break;
        }
      },
    );
  }
}