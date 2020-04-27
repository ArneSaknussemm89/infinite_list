part of post_bloc;

abstract class PostState extends Equatable {
  const PostState({this.errorMessage = ''});

  final String errorMessage;

  @override
  List<Object> get props => [errorMessage];

  PostState copyWith({String errorMessage}) => this;
}

class PostStateInitial extends PostState {
  const PostStateInitial({String errorMessage = ''}) : super(errorMessage: errorMessage);

  @override
  PostStateInitial copyWith({
    String errorMessage,
  }) =>
      PostStateInitial(errorMessage: errorMessage ?? this.errorMessage);
}

class PostStateLoaded extends PostState {
  const PostStateLoaded({
    String errorMessage = '',
    this.posts,
    this.hasReachedMax,
  }) : super(errorMessage: errorMessage);

  final List<Post> posts;
  final bool hasReachedMax;

  @override
  List<Object> get props => [errorMessage, posts, hasReachedMax];

  @override
  PostStateLoaded copyWith({
    String errorMessage,
    List<Post> posts,
    bool hasReachedMax,
  }) =>
      PostStateLoaded(
        errorMessage: errorMessage ?? this.errorMessage,
        posts: posts ?? this.posts,
        hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      );
}
