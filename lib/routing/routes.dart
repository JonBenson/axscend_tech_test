import 'package:axscend_tech_test/features/albums/screens/photos_screen.dart';
import 'package:axscend_tech_test/features/posts/screens/comments_screen.dart';
import 'package:go_router/go_router.dart';
import 'package:axscend_tech_test/features/albums/screens/albums_screen.dart';
import 'package:axscend_tech_test/features/posts/screens/posts_screen.dart';
import 'package:axscend_tech_test/features/todos/screens/todos_screen.dart';
import 'package:axscend_tech_test/features/users/screens/users_screen.dart';

final router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const UsersScreen(),
      routes: [
        GoRoute(
          path: 'users/:userId/albums',
          builder: (context, state) =>
              AlbumsScreen(userId: int.parse(state.pathParameters['userId']!)),
          routes: [
            GoRoute(
              path: ':albumId/photos',
              builder: (context, state) => PhotosScreen(
                albumId: int.parse(state.pathParameters['albumId']!),
              ),
            ),
          ],
        ),
        GoRoute(
          path: 'users/:userId/posts',
          builder: (context, state) =>
              PostsScreen(userId: int.parse(state.pathParameters['userId']!)),
          routes: [
            GoRoute(
              path: ':postId/comments',
              builder: (context, state) => CommentsScreen(
                postId: int.parse(state.pathParameters['postId']!),
              ),
            ),
          ],
        ),
        GoRoute(
          path: 'users/:userId/todos',
          builder: (context, state) =>
              ToDosScreen(userId: int.parse(state.pathParameters['userId']!)),
        ),
      ],
    ),
  ],
);
