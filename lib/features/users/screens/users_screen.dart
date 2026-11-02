import 'package:axscend_tech_test/features/users/models/user.dart';
import 'package:axscend_tech_test/features/users/providers/users_provider.dart';
import 'package:axscend_tech_test/features/users/repositories/user_repository.dart';
import 'package:axscend_tech_test/networking/api_client.dart';
import 'package:axscend_tech_test/widgets/error_widget.dart';
import 'package:axscend_tech_test/widgets/text_with_label.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class UsersScreen extends StatelessWidget {
  const UsersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) =>
          UsersProvider(repo: UserRepository(context.read<ApiClient>())),
      child: const UserList(),
    );
  }
}

class UserList extends StatefulWidget {
  const UserList({super.key});

  @override
  State<UserList> createState() => _UserListState();
}

class _UserListState extends State<UserList> {
  @override
  Widget build(BuildContext context) {
    final provider = context.watch<UsersProvider>();

    return Scaffold(
      appBar: AppBar(
        title: Text('usersPageTitle'.tr()),
        actions: [
          TextButton(
            onPressed: () => provider.toggleSort(),
            child: Text(provider.sortOrder.name.toUpperCase()),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => provider.refresh(),
        child: ListView.builder(
          itemCount: provider.users.length + (provider.hasMore ? 1 : 0),
          itemBuilder: (context, index) {
            if (provider.hasError) {
              return const ErrorMessageWidget();
            }

            if (index == provider.users.length) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                provider.loadNextPage();
              });

              return const Center(child: CircularProgressIndicator());
            }

            final user = provider.users[index];

            return UserCard(user: user);
          },
        ),
      ),
    );
  }
}

class UserCard extends StatelessWidget {
  const UserCard({super.key, required this.user});

  final User user;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: .start,
          children: [
            _UserDetails(user: user),
            _UserButtons(user: user),
          ],
        ),
      ),
    );
  }
}

class _UserDetails extends StatelessWidget {
  const _UserDetails({required this.user});

  final User user;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: .start,
      children: [
        TextWithLabel(label: 'labelName'.tr(), text: user.name),
        TextWithLabel(label: 'labelEmail'.tr(), text: user.email),
        TextWithLabel(label: 'labelPhone'.tr(), text: user.phone),
        TextWithLabel(label: 'labelWebsite'.tr(), text: user.website),
      ],
    );
  }
}

class _UserButtons extends StatelessWidget {
  const _UserButtons({required this.user});

  final User user;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const .symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: .spaceBetween,
        children: [
          Expanded(
            child: ElevatedButton(
              onPressed: () => context.go('/users/${user.id}/albums'),
              child: Text('buttonTextAlbums'.tr()),
            ),
          ),
          const SizedBox(width: 5),
          Expanded(
            child: ElevatedButton(
              onPressed: () => context.go('/users/${user.id}/posts'),
              child: Text('buttonTextPosts'.tr()),
            ),
          ),
          const SizedBox(width: 5),
          Expanded(
            child: ElevatedButton(
              onPressed: () => context.go('/users/${user.id}/todos'),
              child: Text('buttonTextTodos'.tr()),
            ),
          ),
        ],
      ),
    );
  }
}
