import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class AuthService extends ChangeNotifier {
  static final AuthService instance = AuthService._();
  
  AuthService._() {
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      notifyListeners();
    });
  }

  User? get currentUser => FirebaseAuth.instance.currentUser;
  
  bool get isLoggedIn => currentUser != null;
}
