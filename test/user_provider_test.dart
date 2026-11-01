import 'package:axscend_tech_test/config/constants.dart';
import 'package:axscend_tech_test/features/users/providers/users_provider.dart';
import 'package:axscend_tech_test/features/users/repositories/user_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'helpers.dart';

void main() {
  test(
    'loads a page and stops when fewer than a full page comes back',
    () async {
      final provider = UsersProvider(
        repo: UserRepository(
          fakeApi((_) async => jsonResponse([userJson(1), userJson(2)])),
        ),
      );

      await provider.loadNextPage();

      expect(provider.users.length, 2);
      expect(provider.hasMore, false);
      expect(provider.hasError, false);
    },
  );

  test(
    'loads a page and detects its a full page and there is still more data to come',
    () async {
      final provider = UsersProvider(
        repo: UserRepository(
          fakeApi(
            (_) async => jsonResponse([
              userJson(1),
              userJson(2),
              userJson(3),
              userJson(4),
              userJson(5),
              userJson(6),
              userJson(7),
              userJson(8),
              userJson(9),
              userJson(10),
            ]),
          ),
        ),
      );

      await provider.loadNextPage();

      expect(provider.users.length, pageLimit);
      expect(provider.hasMore, true);
      expect(provider.hasError, false);
    },
  );

  test('sets hasError when the request fails', () async {
    final provider = UsersProvider(
      repo: UserRepository(fakeApi((_) async => jsonResponse({}, 500))),
    );

    await provider.loadNextPage();

    expect(provider.hasError, true);
    expect(provider.users, isEmpty);
  });
}
