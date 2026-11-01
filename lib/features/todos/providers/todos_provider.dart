import 'package:axscend_tech_test/features/todos/models/todo.dart';
import 'package:axscend_tech_test/features/todos/repositories/todo_repository.dart';
import 'package:axscend_tech_test/utils/pagination_provider.dart';

class TodosProvider extends PaginationProvider<Todo> {
  TodosProvider({required this.repo, required this.userId});

  final TodoRepository repo;
  final int userId;
  bool _showCompleted = false;

  List<Todo> get todos => items;
  bool get showCompleted => _showCompleted;

  void toggleStatus() {
    _showCompleted = _showCompleted == false ? true : false;
    notifyListeners();
    refresh();
  }

  @override
  Future<List<Todo>> fetchNextPage() {
    return repo.getTodosForUser(
      userId: userId,
      page: currentPage,
      completedFilter: _showCompleted,
    );
  }
}
