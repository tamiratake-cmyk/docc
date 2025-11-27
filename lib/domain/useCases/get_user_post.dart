import 'package:flutter_application_1/domain/entities/post.dart';
import 'package:flutter_application_1/domain/repositories/user_repository.dart';

class GetUserPost {
   final UserRepository repository;
   
   GetUserPost(this.repository);


   Future<List<Post>> call() async {
    return await repository.getUserPosts();
   }
}  