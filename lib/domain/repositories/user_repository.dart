import 'package:flutter_application_1/domain/entities/post.dart';
import 'package:flutter_application_1/domain/entities/users.dart';

abstract class UserRepository {
   Future<List<Post>> getUserPosts();
   Future<User> getUserProfile();

}
