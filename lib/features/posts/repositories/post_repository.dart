import 'package:axscend_tech_test/config/constants.dart';
import 'package:axscend_tech_test/networking/api_client.dart';
import 'package:axscend_tech_test/features/posts/models/comment.dart';
import 'package:axscend_tech_test/features/posts/models/post.dart';
import 'package:axscend_tech_test/utils/sort.dart';

class PostRepository {
  PostRepository(this._api);

  final ApiClient _api;

  Future<List<Post>> getPostsForUser({
    required int userId,
    required int page,
    PostSortField sort = .id,
    SortOrder order = .asc,
  }) async {
    final json =
        await _api.get(
              '/users/$userId/posts',
              query: {
                '_page': '$page',
                '_limit': '$pageLimit',
                '_sort': sort.name,
                '_order': order.name,
              },
            )
            as List;
    return json.map((e) => Post.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<List<Comment>> getCommentsForPost({
    required int postId,
    required int page,
    CommentSortField sort = .id,
    SortOrder order = .asc,
  }) async {
    final json =
        await _api.get(
              '/posts/$postId/comments',
              query: {
                '_page': '$page',
                '_limit': '$pageLimit',
                '_sort': sort.name,
                '_order': order.name,
              },
            )
            as List;
    return json
        .map((e) => Comment.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
