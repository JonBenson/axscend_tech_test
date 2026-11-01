import 'package:axscend_tech_test/features/albums/models/album.dart';
import 'package:axscend_tech_test/features/albums/repositories/album_repository.dart';
import 'package:axscend_tech_test/utils/pagination_provider.dart';

class AlbumsProvider extends PaginationProvider<Album> {
  AlbumsProvider({required this.repo, required this.userId});

  final AlbumRepository repo;
  final int userId;

  List<Album> get albums => items;

  @override
  Future<List<Album>> fetchNextPage() {
    return repo.getAlbumsForUser(userId: userId, page: currentPage);
  }
}
