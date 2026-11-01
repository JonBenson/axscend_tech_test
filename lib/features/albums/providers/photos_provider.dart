import 'package:axscend_tech_test/features/albums/models/photo.dart';
import 'package:axscend_tech_test/features/albums/repositories/album_repository.dart';
import 'package:axscend_tech_test/utils/pagination_provider.dart';

class PhotosProvider extends PaginationProvider<Photo> {
  PhotosProvider({required this.repo, required this.albumId});

  final AlbumRepository repo;
  final int albumId;

  List<Photo> get photos => items;

  @override
  Future<List<Photo>> fetchNextPage() {
    return repo.getPhotosForAlbum(albumId: albumId, page: currentPage);
  }
}
