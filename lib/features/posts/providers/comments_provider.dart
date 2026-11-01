import 'package:axscend_tech_test/features/posts/models/comment.dart';
import 'package:axscend_tech_test/features/posts/repositories/post_repository.dart';
import 'package:axscend_tech_test/utils/pagination_provider.dart';

class CommentsProvider extends PaginationProvider<Comment> {
  CommentsProvider({required this.repo, required this.postId});

  final PostRepository repo;
  final int postId;

  List<Comment> get comments => items;

  @override
  Future<List<Comment>> fetchNextPage() {
    return repo.getCommentsForPost(postId: postId, page: currentPage);
  }
}
