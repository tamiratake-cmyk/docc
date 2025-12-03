import 'package:flutter/material.dart';


Widget ErrorView({required String message}){
   return AnimatedContainer(duration: const Duration(milliseconds: 300),
   curve: Curves.easeInOut,
    padding: const EdgeInsets.all(16.0),
    child: Text(
      message,
      style: const TextStyle(color: Colors.red, fontSize: 16),
      textAlign: TextAlign.center,
    ),
  );
}