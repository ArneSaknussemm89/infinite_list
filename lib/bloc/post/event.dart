part of post_bloc;

abstract class PostEvent extends Equatable {
  const PostEvent();

  @override
  List<Object> get props => [];
}

class PostEventFetch extends PostEvent {
  const PostEventFetch();
}

class PostEventClearError extends PostEvent {
  const PostEventClearError();
}
