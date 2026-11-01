import 'package:axscend_tech_test/config/constants.dart';
import 'package:axscend_tech_test/networking/api_client.dart';
import 'package:axscend_tech_test/features/albums/models/album.dart';
import 'package:axscend_tech_test/features/albums/models/photo.dart';
import 'package:axscend_tech_test/utils/sort.dart';

class AlbumRepository {
  AlbumRepository(this._api);

  final ApiClient _api;

  Future<List<Album>> getAlbumsForUser({
    required int userId,
    required int page,
    AlbumSortField sort = .id,
    SortOrder order = .asc,
  }) async {
    final json =
        await _api.get(
              '/users/$userId/albums',
              query: {
                '_page': '$page',
                '_limit': '$pageLimit',
                '_sort': sort.name,
                '_order': order.name,
              },
            )
            as List;
    return json.map((e) => Album.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<List<Photo>> getPhotosForAlbum({
    required int albumId,
    required int page,
  }) async {
    final json =
        await _api.get(
              '/albums/$albumId/photos',
              query: {'_page': '$page', '_limit': '$pageLimit'},
            )
            as List;
    return json.map((e) => Photo.fromJson(e as Map<String, dynamic>)).toList();
  }
}
