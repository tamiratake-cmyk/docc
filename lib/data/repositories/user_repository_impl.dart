import 'package:flutter_application_1/data/mock/mock_api_service.dart';
import 'package:flutter_application_1/data/models/post.dart';
import 'package:flutter_application_1/data/models/user.dart';
import 'package:flutter_application_1/domain/entities/post.dart';
import 'package:flutter_application_1/domain/entities/users.dart';
import 'package:flutter_application_1/domain/repositories/user_repository.dart';

class UserRepositoryImpl implements UserRepository {
  final MockApiService api;

  UserRepositoryImpl(this.api);

  @override
  Future<User> getUserProfile() async {

    final data = await api.getUserProfile();

    final userModel = UserModel.fromJson(data);
    return userModel.toEntity();
  }

  @override
  Future<List<Post>> getUserPosts() async {
      final data  = await api.getPosts();
      final posts =  data.map((postModel) => PostModel.fromJson(postModel)).toList();

      return posts;
  }
}