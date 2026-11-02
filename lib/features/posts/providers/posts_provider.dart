import 'package:axscend_tech_test/features/posts/models/post.dart';
import 'package:axscend_tech_test/features/posts/repositories/post_repository.dart';
import 'package:axscend_tech_test/utils/pagination_provider.dart';

class PostsProvider extends PaginationProvider<Post> {
  PostsProvider({required this.repo, required this.userId});

  final PostRepository repo;
  final int userId;

  List<Post> get posts => items;

  @override
  Future<List<Post>> fetchNextPage() {
    return repo.getPostsForUser(userId: userId, page: currentPage);
  }
}
