import 'package:axscend_tech_test/features/posts/models/comment.dart';
import 'package:axscend_tech_test/features/posts/providers/comments_provider.dart';
import 'package:axscend_tech_test/features/posts/repositories/post_repository.dart';
import 'package:axscend_tech_test/networking/api_client.dart';
import 'package:axscend_tech_test/widgets/error_widget.dart';
import 'package:axscend_tech_test/widgets/text_with_label.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CommentsScreen extends StatelessWidget {
  const CommentsScreen({super.key, required this.postId});

  final int postId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Comments')),
      body: ChangeNotifierProvider(
        create: (_) => CommentsProvider(
          repo: PostRepository(context.read<ApiClient>()),
          postId: postId,
        ),
        child: const CommentList(),
      ),
    );
  }
}

class CommentList extends StatefulWidget {
  const CommentList({super.key});

  @override
  State<CommentList> createState() => _CommentListState();
}

class _CommentListState extends State<CommentList> {
  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CommentsProvider>();

    return RefreshIndicator(
      onRefresh: () => provider.refresh(),
      child: ListView.builder(
        itemCount: provider.comments.length + (provider.hasMore ? 1 : 0),
        itemBuilder: (context, index) {
          if (provider.hasError) {
            return const ErrorMessageWidget();
          }

          if (index == provider.comments.length) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              provider.loadNextPage();
            });

            return const Center(child: CircularProgressIndicator());
          }

          final post = provider.comments[index];

          return CommentCard(comment: post);
        },
      ),
    );
  }
}

class CommentCard extends StatelessWidget {
  const CommentCard({super.key, required this.comment});

  final Comment comment;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: .start,
          children: [
            TextWithLabel(label: 'Name', text: comment.name),
            const SizedBox(height: 10),
            TextWithLabel(label: 'Email', text: comment.email),
            const SizedBox(height: 10),
            TextWithLabel(label: 'Comment', text: comment.body),
          ],
        ),
      ),
    );
  }
}
