import 'package:axscend_tech_test/config/constants.dart';
import 'package:axscend_tech_test/networking/api_client.dart';
import 'package:axscend_tech_test/features/users/models/user.dart';
import 'package:axscend_tech_test/utils/sort.dart';

class UserRepository {
  UserRepository(this._api);

  final ApiClient _api;

  Future<List<User>> getUsers({
    required int page,
    UserSortField sort = .id,
    SortOrder order = .asc,
  }) async {
    final json =
        await _api.get(
              '/users',
              query: {
                '_page': '$page',
                '_limit': '$pageLimit',
                '_sort': sort.name,
                '_order': order.name,
              },
            )
            as List;
    return json.map((e) => User.fromJson(e as Map<String, dynamic>)).toList();
  }
}
