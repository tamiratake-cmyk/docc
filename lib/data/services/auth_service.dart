import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService extends ChangeNotifier {
  static final AuthService instance = AuthService._();
  static const String _guestModeKey = 'guest_mode';
  bool _isGuestMode = true;
  
  AuthService._() {
    _loadGuestMode();
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user != null) {
        _isGuestMode = false;
        _saveGuestMode(false);
      }
      notifyListeners();
    });
  }

  Future<void> _loadGuestMode() async {
    final prefs = await SharedPreferences.getInstance();
    _isGuestMode = prefs.getBool(_guestModeKey) ?? true;
    notifyListeners();
  }

  Future<void> _saveGuestMode(bool isGuest) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_guestModeKey, isGuest);
  }

  User? get currentUser => FirebaseAuth.instance.currentUser;
  
  bool get isLoggedIn => currentUser != null;
  
  bool get isGuestMode => _isGuestMode && currentUser == null;
  
  String? get userId => currentUser?.uid;

  /// Enable guest mode (skip login)
  Future<void> continueAsGuest() async {
    _isGuestMode = true;
    await _saveGuestMode(true);
    notifyListeners();
  }

  /// Sign out and return to guest mode
  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
    _isGuestMode = true;
    await _saveGuestMode(true);
    notifyListeners();
  }

  /// Disable guest mode (user wants to log in)
  Future<void> exitGuestMode() async {
    _isGuestMode = false;
    await _saveGuestMode(false);
    notifyListeners();
  }
}
