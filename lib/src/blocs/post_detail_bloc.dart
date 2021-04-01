import 'dart:async';
import 'dart:convert';
import 'package:rxdart/rxdart.dart';
import 'package:http/http.dart' as http;
import '../../src/models/comment_model.dart';
import '../../src/models/post_model.dart';
import '../../src/resources/api_provider.dart';
import '../config.dart';

class PostDetailBloc {

  final _postFetcher = BehaviorSubject<Post>();
  ValueStream<Post> get post => _postFetcher.stream;
  final api = ApiProvider();
  Config config = Config();

  final _commentsFetcher = BehaviorSubject<CommentsModel>();
  final _hasMoreCommentsFetcher = BehaviorSubject<bool>();
  var _commentsPage = new Map<int, dynamic>();

  final _postIdController = StreamController<int>();

  Sink<int> get postId => _postIdController.sink;

  ValueStream<CommentsModel> get comments => _commentsFetcher.stream;
  ValueStream<bool> get hasMoreCommets => _hasMoreCommentsFetcher.stream;

  Map<int, CommentsModel> _comments;
  var _post = new Map<int, Post>();

  PostDetailBloc() : _comments = Map() {
    _postIdController.stream.listen((id) async {
      fetchPost(id);
      fetchComments(id);
    });
  }

  fetchPost(id) async {
    if(!_post.containsKey(id)) {
      _post[id] = await _getPost(id);
    }
    _postFetcher.sink.add(_post[id]);
  }

  addPost(Post post) {
    _post[post.id] = post;
    _postFetcher.sink.add(post);
  }

  fetchComments(id) async {
    _commentsPage[id] = 1;
    if(!_comments.containsKey(id)) {
      _comments[id] = await _getComments(id);
    }
    _commentsFetcher.sink.add(_comments[id]);
  }

  fetchMoreComments(id) async {
    _commentsPage[id] = _commentsPage[id] + 1;
    CommentsModel comments = await _getComments(id);
    if(comments.comments.isEmpty){
      _hasMoreCommentsFetcher.add(false);
    } else {
      _comments[id].comments.addAll(comments.comments);
      _commentsFetcher.sink.add(_comments[id]);
    }
  }

  Future<CommentsModel> _getComments(id) async {
    final url = config.url + '/wp-json/wp/v2/comments?page=' + _commentsPage[id].toString() + '&post=' + id.toString();
    final response = await http.get(url);
    if (response.statusCode == 200) {
      return CommentsModel.fromJson(json.decode(response.body));
    } else {
      _hasMoreCommentsFetcher.add(false);
      throw Exception('Failed to fetch comments');
    }
  }

  Future<Post> _getPost(id) async {
    final url = config.url + '/wp-json/wp/v2/posts/' + id.toString();
    print(url);
    final response = await http.get(url);
    if (response.statusCode == 200) {
      return Post.fromJson(json.decode(response.body));
    } else {
      _postFetcher.addError('Nothing to show');
      _hasMoreCommentsFetcher.add(false);
      throw Exception('Failed to fetch post');
    }
  }

  dispose() {
    _commentsFetcher.close();
    _postFetcher.close();
  }
}