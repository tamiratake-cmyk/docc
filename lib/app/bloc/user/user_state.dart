import 'package:equatable/equatable.dart';
import 'package:flutter_application_1/domain/entities/post.dart';
import 'package:flutter_application_1/domain/entities/users.dart';

class UserState extends Equatable {
  final bool isLoading;
  final User? user;
  final List<Post>? posts;
  final String? error;


  const UserState({
    this.isLoading = false,
    this.user,
    this.posts = const [],
    this.error,
  });

  UserState copyWith({
    bool? isLoading,
    User? user,
    List<Post>? posts,
    String? error,
  }) {
    return UserState(
      isLoading: isLoading ?? this.isLoading,
      user: user ?? this.user,
      posts: posts ?? this.posts,
      error: error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [isLoading, user, posts, error];
}
