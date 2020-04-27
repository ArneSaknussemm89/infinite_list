library post_bloc;

import 'dart:async';
import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:http/http.dart' as http;
import 'package:rxdart/rxdart.dart';
import 'package:infinitelist/model/post.dart';

part 'event.dart';
part 'state.dart';

class PostBloc extends Bloc<PostEvent, PostState> {
  PostBloc({this.httpClient});

  final http.Client httpClient;

  @override
  PostState get initialState => PostStateInitial();

  bool _hasReachedMax(PostState state) => state is PostStateLoaded && state.hasReachedMax;

  Future<List<Post>> _fetchPosts(int startIndex, int count) async {
    var response = await httpClient.get('https://jsonplaceholder.typicode.com/posts?_start=$startIndex&_limit=$count');

    if (response.statusCode == 200) {
      var decoded = json.decode(response.body) as List;
      return decoded.map((item) {
        return Post(id: item['id'], title: item['title'], body: item['body']);
      }).toList();
    } else {
      throw new Exception('Unable to load posts.');
    }
  }

  @override
  Stream<Transition<PostEvent, PostState>> transformEvents(Stream<PostEvent> events, transitionFn) {
    return super.transformEvents(events.debounceTime(const Duration(milliseconds: 300)), transitionFn);
  }

  @override
  Stream<PostState> mapEventToState(PostEvent event) async* {
    var current = state;
    if (event is PostEventFetch && !_hasReachedMax(current)) {
      try {
        if (current is PostStateInitial) {
          var posts = await _fetchPosts(0, 20);
          yield PostStateLoaded(posts: posts, hasReachedMax: false);
        }

        if (current is PostStateLoaded) {
          var posts = await _fetchPosts(current.posts.length, 20);
          if (posts.isEmpty) {
            yield current.copyWith(posts: current.posts + posts, hasReachedMax: true);
          } else {
            yield current.copyWith(posts: current.posts + posts);
          }
        }
      } catch (e) {
        yield current.copyWith(errorMessage: e.toString());
      }
    }
  }
}
