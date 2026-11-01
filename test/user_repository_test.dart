import 'package:axscend_tech_test/features/users/repositories/user_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'helpers.dart';

void main() {
  test('getUsers requests the right URL and parses users', () async {
    late Uri requested;
    final repo = UserRepository(
      fakeApi((request) async {
        requested = request.url;
        return jsonResponse([userJson(1), userJson(2)]);
      }),
    );

    final users = await repo.getUsers(page: 1);

    expect(requested.path, '/users');
    expect(requested.queryParameters['_page'], '1');
    expect(users.length, 2);
    expect(users.first.name, 'User 1');
  });

  test('getUsers throws on a server error', () async {
    final repo = UserRepository(fakeApi((_) async => jsonResponse({}, 500)));
    expect(repo.getUsers(page: 1), throwsException);
  });
}
