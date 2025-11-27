
import 'package:flutter_application_1/domain/entities/users.dart';
import 'package:flutter_application_1/domain/repositories/user_repository.dart';

class GetUserProfile {
   final UserRepository repository;

    GetUserProfile(this.repository);

    Future<User> call() async {
      return await repository.getUserProfile();
    }
}