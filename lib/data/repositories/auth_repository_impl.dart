import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_application_1/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final FirebaseAuth _firebaseAuth;

  AuthRepositoryImpl({FirebaseAuth? firebaseAuth})
      : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance;

  @override
  String? currentUserId() {
    return _firebaseAuth.currentUser?.uid;
  }
}
