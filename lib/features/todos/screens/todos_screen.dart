import 'package:axscend_tech_test/config/app_theme.dart';
import 'package:axscend_tech_test/features/todos/models/todo.dart';
import 'package:axscend_tech_test/features/todos/providers/todos_provider.dart';
import 'package:axscend_tech_test/features/todos/repositories/todo_repository.dart';
import 'package:axscend_tech_test/networking/api_client.dart';
import 'package:axscend_tech_test/widgets/error_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ToDosScreen extends StatelessWidget {
  const ToDosScreen({super.key, required this.userId});

  final int userId;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => TodosProvider(
        repo: TodoRepository(context.read<ApiClient>()),
        userId: userId,
      ),
      child: const ToDoList(),
    );
  }
}

class ToDoList extends StatefulWidget {
  const ToDoList({super.key});

  @override
  State<ToDoList> createState() => _ToDoListState();
}

class _ToDoListState extends State<ToDoList> {
  @override
  Widget build(BuildContext context) {
    final provider = context.watch<TodosProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Todos'),
        actions: [
          TextButton(
            onPressed: () => provider.toggleStatus(),
            child: Text(
              provider.showCompleted == false
                  ? 'Show Complete'
                  : 'Hide Complete',
            ),
          ),
        ],
      ),

      body: RefreshIndicator(
        onRefresh: () => provider.refresh(),
        child: ListView.builder(
          itemCount: provider.todos.length + (provider.hasMore ? 1 : 0),
          itemBuilder: (context, index) {
            if (provider.hasError) {
              return const ErrorMessageWidget();
            }

            if (index == provider.todos.length) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                provider.loadNextPage();
              });

              return const Center(child: CircularProgressIndicator());
            }

            final todo = provider.todos[index];

            return TodoCard(todo: todo);
          },
        ),
      ),
    );
  }
}

class TodoCard extends StatelessWidget {
  const TodoCard({super.key, required this.todo});

  final Todo todo;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SizedBox(
      height: 100,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: .center,
                  crossAxisAlignment: .start,
                  children: [
                    Text(
                      'Task',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: AppColors.label,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(todo.title, style: theme.textTheme.bodyMedium),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Column(
                mainAxisAlignment: .center,
                crossAxisAlignment: .start,
                children: [
                  Text(
                    'Status',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: AppColors.label,
                    ),
                  ),
                  const SizedBox(height: 5),
                  todo.completed
                      ? const Icon(Icons.check, color: AppColors.todoDone)
                      : const Icon(Icons.close, color: AppColors.todoNotDone),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
