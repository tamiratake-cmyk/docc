
import 'package:equatable/equatable.dart';

class Post extends Equatable{
    final int id;
    final String title;
    final String body;
    final int authorId;


    const Post({
      required this.id,
      required this.title,
      required this.body,
      required this.authorId,
    });

    @override
    List<Object?> get props => [id, title, body, authorId];

}