import 'package:axscend_tech_test/config/constants.dart';
import 'package:axscend_tech_test/networking/api_client.dart';
import 'package:axscend_tech_test/features/todos/models/todo.dart';
import 'package:axscend_tech_test/utils/sort.dart';

class TodoRepository {
  TodoRepository(this._api);

  final ApiClient _api;

  Future<List<Todo>> getTodosForUser({
    required int userId,
    required int page,
    TodoSortField sort = .id,
    SortOrder order = .asc,
    bool completedFilter = false,
  }) async {
    final json =
        await _api.get(
              '/users/$userId/todos',
              query: {
                '_page': '$page',
                '_limit': '$pageLimit',
                '_sort': sort.name,
                '_order': order.name,
                'completed': completedFilter == false ? 'false' : 'true',
              },
            )
            as List;
    return json.map((e) => Todo.fromJson(e as Map<String, dynamic>)).toList();
  }
}
