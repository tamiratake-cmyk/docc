import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class LoginPage  extends StatelessWidget{
  const LoginPage ({super.key});


Future signIn() async {
  await FirebaseAuth.instance.signInAnonymously();
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login Page'),
      ),
      body:Center(  
      child: ElevatedButton(
          onPressed: signIn,
          child: const Text("Enter App (Temporary login)"),
        ),
      ),
    );
  }
}