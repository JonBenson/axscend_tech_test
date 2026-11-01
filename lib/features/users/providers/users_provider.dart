import 'package:axscend_tech_test/features/users/models/user.dart';
import 'package:axscend_tech_test/features/users/repositories/user_repository.dart';
import 'package:axscend_tech_test/utils/pagination_provider.dart';
import 'package:axscend_tech_test/utils/sort.dart';

class UsersProvider extends PaginationProvider<User> {
  UsersProvider({required this.repo});

  final UserRepository repo;
  final UserSortField _sortBy = .name;
  SortOrder _sortOrder = .asc;

  List<User> get users => items;
  SortOrder get sortOrder => _sortOrder;

  void toggleSort() {
    _sortOrder = _sortOrder == SortOrder.asc ? SortOrder.desc : SortOrder.asc;
    notifyListeners();
    refresh();
  }

  @override
  Future<List<User>> fetchNextPage() {
    return repo.getUsers(page: currentPage, sort: _sortBy, order: _sortOrder);
  }
}
