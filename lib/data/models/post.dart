import 'package:equatable/equatable.dart';
import 'package:flutter_application_1/domain/entities/post.dart';


class PostModel extends Post {
  const PostModel({
    required super.id,
    required super.title,
    required super.body,
    required super.authorId,
  });

  factory PostModel.fromJson(Map<String, dynamic> json) {
    return PostModel(
      id: json['id'] is int ? json['id'] : int.parse('${json['id']}'),
      title: json['title'] ?? '',
      body: json['body'] ?? '',
      authorId: json['authorId'] is int
          ? json['authorId']
          : int.parse('${json['authorId']}'),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'body': body,
        'authorId': authorId,
      };

  Post toEntity() => Post(
        id: id,
        title: title,
        body: body,
        authorId: authorId,
      );
}
