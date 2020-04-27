import 'package:equatable/equatable.dart';

class Post extends Equatable {
  const Post({this.id, this.title, this.body});

  final int id;
  final String title;
  final String body;

  @override
  List<Object> get props => [id, title, body];

  @override
  String toString() {
    return 'Post { id: $id, title: $title, body: $body }';
  }
}
