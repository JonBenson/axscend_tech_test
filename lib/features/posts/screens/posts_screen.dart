import 'package:axscend_tech_test/features/posts/models/post.dart';
import 'package:axscend_tech_test/features/posts/providers/posts_provider.dart';
import 'package:axscend_tech_test/features/posts/repositories/post_repository.dart';
import 'package:axscend_tech_test/networking/api_client.dart';
import 'package:axscend_tech_test/widgets/error_widget.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class PostsScreen extends StatelessWidget {
  const PostsScreen({super.key, required this.userId});

  final int userId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Posts')),
      body: ChangeNotifierProvider(
        create: (_) =>
            PostsProvider(repo: PostRepository(ApiClient()), userId: userId),
        child: const PostsList(),
      ),
    );
  }
}

class PostsList extends StatefulWidget {
  const PostsList({super.key});

  @override
  State<PostsList> createState() => _PostListState();
}

class _PostListState extends State<PostsList> {
  @override
  Widget build(BuildContext context) {
    final provider = context.watch<PostsProvider>();

    return RefreshIndicator(
      onRefresh: () => provider.refresh(),
      child: ListView.builder(
        itemCount: provider.posts.length + (provider.hasMore ? 1 : 0),
        itemBuilder: (context, index) {
          if (provider.hasError) {
            return const ErrorMessageWidget();
          }

          if (index == provider.posts.length) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              provider.loadNextPage();
            });

            return const Center(child: CircularProgressIndicator());
          }

          final post = provider.posts[index];

          return PostCard(post: post);
        },
      ),
    );
  }
}

class PostCard extends StatelessWidget {
  const PostCard({super.key, required this.post});

  final Post post;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: () => context.go('./${post.id}/comments'),
      child: SizedBox(
        height: 100,
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Text(post.title, style: theme.textTheme.bodyLarge),
          ),
        ),
      ),
    );
  }
}
